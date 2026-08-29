# 16 - SELinux 進階

[02 章 §7](02-初始設定.md) 與 [08 章 §5.2](08-安全強化.md) 涵蓋日常會用到的 SELinux 操作（`restorecon`、boolean、`semanage port`、`sealert`）。本章深入它的運作模型與政策語言：為什麼標籤是一切、targeted 政策怎麼組成、如何讀懂 AVC、查詢政策（`sesearch` / `seinfo`）、正確地寫自訂模組（而不是把 `audit2allow` 的輸出照單全收）、為新服務建立 confined domain、容器與 MLS/MCS、以及系統性的除錯與效能議題。

本章是 🔵 **Fedora（與 RHEL 系）專屬**；🟠 Ubuntu 預設用 AppArmor，雖可安裝 SELinux（實測 24.04 套件庫有 `selinux-basics`、`selinux-policy-default`、`policycoreutils`、`setools`）但 Debian 的 refpolicy 覆蓋率與工具整合遠不如 Fedora，正式環境不建議在 Ubuntu 上換用 SELinux——需要 SELinux 的工作負載請直接選 Fedora / RHEL 系。

驗證說明：實驗容器的核心無法啟用 SELinux（`getenforce` 為 Disabled），因此本章所有**離線**操作——政策查詢（`seinfo` / `sesearch`）、`semanage` 修改政策庫、`matchpathcon`、`audit2allow` / `audit2why`、`.te` / CIL 模組編譯與 `semodule` 安裝、`sepolicy generate`——皆於 Fedora 44（selinux-policy 44.7、setools 4.6、policycoreutils 3.11）實測；需要 enforcing 核心的行為（AVC 產生、`setenforce`、標籤轉換）依 Fedora / RHEL 官方文件撰寫並標示。範例檔在 [`scripts/examples/selinux/`](scripts/examples/selinux/)。

**本章解決什麼問題**：SELinux 是 Fedora 伺服器上「服務起不來 / 讀不到檔案 / 連不到埠」的第二大原因（第一是防火牆），而最常見的錯誤處置是 `setenforce 0` 或 `SELINUX=disabled` 一勞永逸——這等於拆掉 2014 年 Shellshock、2021 年 Log4Shell 這類「服務被打穿後試圖橫向移動」時唯一還在運作的防線。第二常見的錯誤是把 `audit2allow` 吐出的規則全部裝上去，結果政策被撐出一個大洞卻沒人知道。本章的取捨原則：**永遠先問「標籤對不對」，再問「有沒有現成 boolean」，最後才寫自訂模組；自訂模組要最小、有版本、進 git**。

---

## 1. 運作模型：為什麼是「標籤」

**名詞與關係**：SELinux 的所有名詞都掛在同一張圖上——「一個程序想碰一個物件，核心拿雙方的標籤去查政策」。政策從哪裡來、被拒絕後的紀錄流到哪裡去，也都在這張圖上，本章之後每一節都只是放大其中一角：

```
                       ┌──────────── 核心（LSM 掛鉤點，在 DAC 檢查之後）────────────┐
 subject（程序）        │ 查政策：有沒有 allow <domain> <type>:<class> { <permission> }？ │      object（物件：檔案/目錄/埠/socket/程序）
 標籤 user:role:type:level ──────────── open / read / name_connect … ────────────▶ 標籤 user:role:type:level
 例 system_u:system_r:httpd_t:s0                                                  例 system_u:object_r:httpd_sys_content_t:s0（class=file）
        ▲ 程序的 type 叫 domain                                                          ▲ 物件的 type 就叫 type
        │                                                                               │
   查到 allow → 放行（結果進 AVC 快取）                  查不到 → 拒絕，並寫一筆 AVC 紀錄（除非有 dontaudit 規則壓掉）
                                                                     │
 政策（policy.35）從哪來：                                             ▼ 除錯資料流
   refpolicy 模組（selinux-policy-targeted 套件，priority 100）       AVC ─▶ auditd（/var/log/audit/audit.log）
     + 本機修改（semanage fcontext/port/boolean/login、                      ├─▶ ausearch -m avc（撈原始紀錄）
        semodule -i 自訂模組，priority 400）                                 ├─▶ setroubleshoot / sealert（翻成人話 + 建議指令）
   ══ semodule -B 編譯 ══▶ policy.35 ══▶ 核心載入                             └─▶ audit2why（解釋原因、指出 boolean）/ audit2allow（規則草稿）
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **DAC** | Discretionary Access Control：傳統 Unix 的 owner / group / mode 權限，由檔案擁有者自行決定誰能存取 | 核心先查 DAC 再查 SELinux；DAC 拒絕就直接拒絕，DAC 允許還要過 MAC 這關 |
| **MAC** | Mandatory Access Control：由系統政策強制決定、擁有者甚至 root 都改不了的存取控制 | SELinux 與 AppArmor 都是 MAC；MAC 補的正是 DAC「root 無所不能」的洞 |
| **LSM** | Linux Security Modules：核心內建的安全掛鉤框架，每個系統呼叫在 DAC 之後多呼叫一次掛鉤 | SELinux、AppArmor 都是 LSM 模組；「主要 LSM」同時只能掛一個，所以兩者不能並存 |
| **subject / object** | subject 是發出動作的程序；object 是被動作的東西（檔案、目錄、埠、socket、另一個程序…） | 每次存取都是「subject 對 object 做某 class 的某 permission」，政策規則就照這四元組寫 |
| **context / label（安全上下文 / 標籤）** | 一串 `user:role:type:level` 字串；程序的記在核心，檔案的存在 inode 的擴充屬性（xattr `security.selinux`） | subject 與 object 各有一個；「標籤跟著 inode 走」指的就是 xattr，搬檔案不會改它 |
| **SELinux user** | context 第一欄：登入身分對應到的 SELinux 身分（`system_u`、`unconfined_u`、`staff_u`…），與 Linux 帳號不是同一件事 | 決定一個人能拿到哪些 role；§8 的 confined user 改的就是這欄 |
| **role** | context 第二欄：一組 domain 的集合，只對程序有意義（物件一律 `object_r`） | SELinux user → 可用 role → 可進入的 domain，三者是逐層包含的關係 |
| **type / domain** | context 第三欄：貼在物件上叫 type，貼在程序上叫 domain（習慣以 `_t` 結尾） | targeted 政策 99% 的規則只比對這一欄；這種模型叫 type enforcement |
| **level（MLS / MCS）** | context 第四欄：`sensitivity:category`（如 `s0:c1,c2`）；targeted 下 sensitivity 永遠是 `s0` | 只有容器 / VM 隔離（§7）與 MLS 政策（§8）會用到它 |
| **type enforcement（TE）** | 「哪個 domain 對哪個 type 可以做什麼」的規則模型，所有 `allow` 規則都長這樣 | SELinux 的主體；role 與 MLS 是疊在 TE 之上的額外限制 |
| **class / permission** | class 是物件的種類（`file`、`dir`、`tcp_socket`、`process`…），permission 是該 class 上可做的動作（`read`、`name_connect`…） | 一條 allow 規則 = domain + type + class + permission；AVC 裡的 `tclass` 與 `{ … }` 就是它們 |
| **unconfined（`unconfined_t` / `unconfined_u`）** | 「不受限」的 domain / SELinux user：政策幾乎全部放行，只留極少數限制 | 登入 shell 與手動跑的程式都在這裡；targeted 只把已知服務關進受限 domain，其餘留在 unconfined |
| **domain transition / `*_exec_t`** | 程序執行一個標為 `xxx_exec_t` 的檔案時，依 `type_transition` 規則自動換到 `xxx_t` domain | 由 systemd 啟動才會轉換，從 unconfined shell 手動跑不會——「手動正常、systemd 失敗」的根源 |
| **targeted 政策** | Fedora 預設的政策類型（`SELINUXTYPE=targeted`）：只針對已知服務設限，其餘 unconfined | 另一種是 mls；政策內容 = refpolicy 模組 + 本機修改（§2） |
| **refpolicy** | Reference Policy：SELinux 上游用巨集寫成的政策原始碼專案，Fedora 的 `selinux-policy` 套件是它的下游 | 發行版模組（priority 100）由它編譯而來；§5 自訂模組也用它的巨集 |
| **semanage / semodule** | `semanage` 修改本機政策庫的 fcontext / port / boolean / login…；`semodule` 安裝、移除、重建政策模組 | 兩者都寫入 `/var/lib/selinux/targeted/`，再重建成核心載入的 `policy.35`（§2） |
| **AVC** | Access Vector Cache：核心快取政策查詢結果的地方；被拒絕時寫出的稽核紀錄也叫 AVC（`avc: denied`） | 除錯資料流的起點：AVC → auditd → ausearch / sealert / audit2why（§4） |
| **auditd / ausearch** | auditd 是接收核心稽核事件、寫入 `/var/log/audit/audit.log` 的守護程序；ausearch 是查詢它的工具 | 沒有 auditd 時 AVC 改落到 journal（`journalctl -k`） |
| **setroubleshoot / sealert** | 監看 AVC 並翻譯成「原因 + 建議指令」的服務（setroubleshootd）與它的 CLI（sealert） | 建議順序固定是 restorecon → boolean → 自訂模組，與 §4 的處置順序相同 |
| **audit2why / audit2allow** | 都讀 AVC：前者解釋「為什麼被拒、哪個 boolean 能解」，後者把 AVC 翻成 allow 規則草稿 | audit2allow 的輸出是 §5 自訂模組的原料，不是答案 |
| **AppArmor** | Ubuntu 預設的 MAC：用「程式路徑 → 允許存取的檔案路徑」profile 做限制 | 與 SELinux 同為 LSM，不能同時啟用；差別在「路徑」vs「標籤跟著 inode」 |

**為什麼**：傳統 Unix 權限（DAC）只看「誰擁有檔案」，root 或被入侵的 root 服務可以做任何事。SELinux 是 **MAC（強制存取控制）**：每個程序（subject）與每個物件（檔案、埠、socket、程序）都有一個**安全上下文（context / 標籤）**，核心在每次系統呼叫時查政策「這個 domain 對這個 type 可以做這個 class 的這個 permission 嗎」，查不到就拒絕——**預設拒絕**，DAC 允許也沒用。這就是為什麼複製檔案到 `/var/www` 後 nginx 讀不到（標籤是 `user_home_t` 而非 `httpd_sys_content_t`），也是為什麼被打穿的 `httpd_t` 讀不了 `/etc/shadow`（`shadow_t`）。AppArmor 用「路徑」做同樣的事，簡單但搬檔案就失效；SELinux 用「標籤跟著 inode 走」，嚴謹但需要理解標籤。

**怎麼做**：先學會讀 context。格式 `user:role:type:level`，targeted 政策下 99% 只看 **type**（第三欄）：

```bash
ls -Z /var/www/html/index.html          # system_u:object_r:httpd_sys_content_t:s0
ps -eZ | grep nginx                     # system_u:system_r:httpd_t:s0        ← 程序的 type 叫 domain
id -Z                                   # unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023  ← 登入使用者通常 unconfined
ss -ltnZ | head                         # socket 的 context
sudo semanage port -l | grep http_port_t  # 埠的標籤：實測 http_port_t tcp 80, 81, 443, 488, 8008, 8009, 8443, 9000
secon -t /usr/sbin/sshd 2>/dev/null; stat -c %C /etc/shadow      # 其他查法
matchpathcon /var/www/html/index.html /home/alice/.ssh/authorized_keys /etc/shadow /usr/sbin/sshd   # 「依政策應該是什麼標籤」（實測）
#   → httpd_sys_content_t / ssh_home_t / shadow_t / sshd_exec_t
```

| 欄位 | targeted 下的意義 | 常見值 |
|---|---|---|
| user（SELinux user） | 登入身分對應的 SELinux 使用者，決定可用的 role | `system_u`（服務）、`unconfined_u`（一般登入）、`staff_u` / `user_u`（confined 使用者） |
| role | 只有程序有意義；限制可進入哪些 domain | `system_r`、`unconfined_r`、`sysadm_r` |
| **type / domain** | **存取控制的核心**；程序的叫 domain，物件的叫 type | `httpd_t`、`httpd_sys_content_t`、`ssh_port_t` |
| level（MLS/MCS） | 敏感度 : 類別；targeted 只用 MCS 給容器 / VM 隔離 | `s0`、`s0:c123,c456` |

**注意**：`unconfined_t` 是「不受限」——你的 shell、你手動跑起來的程式都在這個 domain，所以「手動執行正常、用 systemd 啟動就失敗」幾乎一定是 SELinux：systemd 啟動時會依 `*_exec_t` 做 **domain transition** 進入受限 domain（見 §3），手動跑則留在 unconfined。

---

## 2. Targeted 政策的組成

**名詞與關係**：這一節的名詞分成「政策從哪來」與「標籤怎麼落到檔案上」兩條線，兩條線都在同一個政策庫會合：

```
/etc/selinux/config ── SELINUX=enforcing|permissive|disabled、SELINUXTYPE=targeted|mls ──▶ 開機時決定「載入哪套政策」與「擋不擋」

selinux-policy-targeted 套件 ──提供──▶ 發行版模組（priority 100）─┐
                                                                  ├─ 政策庫 /var/lib/selinux/targeted/active/ ══ semodule -B ══▶ policy.35 ──▶ 核心
semanage fcontext/port/boolean/login、semodule -i（priority 400）──▶ 本機修改層 ─┘            │
                                                                                            └─ 同時產生 contexts/files/file_contexts（+ file_contexts.local）
                                                                                                        │
                                                                    restorecon / 全盤重標 依它把標籤寫到 inode ◀──┘
                                                                    chcon 直接寫 inode、不經政策 → 下次 restorecon 就被改回
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **`/etc/selinux/config`** | 開機時讀的總開關：`SELINUX=` 決定 enforcing / permissive / disabled，`SELINUXTYPE=` 決定載入 targeted 還是 mls 政策 | `setenforce` 只改執行中狀態，重開機以此檔為準 |
| **enforcing / permissive / disabled** | 擋且記錄 / 只記錄不擋 / 不載入政策也不打標籤 | permissive 的 AVC 會帶 `permissive=1`；disabled 期間新建的檔沒標籤，回 enforcing 前要 autorelabel |
| **`selinux-policy-targeted`** | Fedora 打包的 refpolicy 下游：把 refpolicy 每個服務模組編好、裝進政策庫的 RPM | 它就是 priority 100 的發行版模組層；套件升級只換這一層 |
| **政策模組 / priority** | 政策由數百個模組組成（一個服務一個）；同名模組可同時存在多個優先權，數字大的生效 | 發行版 100、自訂 400；`semodule -i` 同名模組是「覆蓋」而不是「合併」 |
| **政策庫（policy store）** | `/var/lib/selinux/targeted/active/`：semanage / semodule 的實際存放處（`modules/`、`ports.local`、`file_contexts.local`、`booleans.local`…） | 「本機修改層」的實體；套件升級不會清掉它 |
| **`policy.35`** | 把政策庫所有模組編譯成的二進位檔，檔名數字是政策格式版本；核心開機載入的就是它 | `semodule -i` / `-B` 之後重新產生；`sesearch` / `seinfo` 查的也是它 |
| **`file_contexts` / `file_contexts.local`** | 「路徑 regex → 標籤」對照表：前者由各模組的 `.fc` 產生，後者是 `semanage fcontext -a` 加的 | `restorecon`、`matchpathcon`、全盤重標都只看這兩張表 |
| **`restorecon` / `chcon`** | 前者依 file_contexts 把「政策說該有的標籤」寫回 inode；後者把你指定的標籤直接寫到 inode | chcon 不留紀錄，restorecon 或重標一跑就被覆蓋，所以只適合暫時測試 |
| **`semanage`** | 修改政策庫「本機修改層」的統一工具（fcontext / port / boolean / login / permissive…） | 改完自動重建 policy.35；fcontext 例外——還要 restorecon 才會落到檔案 |
| **`semodule`** | 安裝 / 移除 / 列出模組、重建政策（`-B`）的工具 | `-l` 看模組、`-lfull` 看 priority；§5 自訂模組靠它裝 |
| **`seinfo`** | setools 的政策統計 / 查詢工具（§3 詳述） | 這裡只用來看 policy.35 有幾個 type、幾條 allow |
| **`/.autorelabel`** | 放在根目錄的旗標檔：開機時觸發全盤重標後自動刪除 | disabled → enforcing 必做；大磁碟要很久，所以「寧可 permissive 也不要 disabled」 |

**為什麼**：知道政策從哪來、存在哪，才知道該改哪一層：改錯層（例如直接 `chcon`）下次 `restorecon` 或套件升級就被蓋掉；而 `semanage` 改的是**本機政策庫**，會持久且優先於發行版預設。Fedora 的 `selinux-policy-targeted` 由 Red Hat 維護（Fedora 44 實測 44.7），把每個常見服務關進各自的 domain（httpd、sshd、chronyd、postgresql…約 5,300 個 type、67,000 條 allow 規則），未被定義的程式則留在 unconfined——這是「targeted」的意思：只針對已知服務。

**怎麼做**：

```bash
cat /etc/selinux/config                 # SELINUX=enforcing|permissive|disabled；SELINUXTYPE=targeted（另有 mls）
ls /etc/selinux/targeted/               # 實測：booleans.subs_dist contexts logins policy seusers setrans.conf
ls /etc/selinux/targeted/policy/        # policy.35：編譯後的二進位政策（核心載入的就是它）
ls /etc/selinux/targeted/contexts/files/ # file_contexts：路徑 → 標籤的 regex 表（restorecon 依此）；file_contexts.local 是你用 semanage 加的
ls /var/lib/selinux/targeted/active/    # 政策庫（modules/、ports.local、file_contexts.local、booleans.local…）— semanage 的實際存放處
sudo semodule -l | head; sudo semodule -lfull | head   # 已載入的模組與優先權（實測：發行版模組 priority 100、自訂 400）
seinfo /etc/selinux/targeted/policy/policy.35            # 政策統計（實測：Types 5295、Booleans 367、Allow 67471、Dontaudit 8847）
rpm -q selinux-policy selinux-policy-targeted
```

政策的三層（後者覆蓋前者）：

| 層 | 來源 | 修改方式 | 升級後 |
|---|---|---|---|
| 發行版模組（priority 100） | `selinux-policy-targeted` 套件 | 不要改 | 隨套件更新 |
| 本機政策庫 | `semanage fcontext/port/boolean/login`、`semodule -i` 自訂模組（priority 400） | ✅ 這裡 | 保留 |
| 檔案上的實際標籤 | `restorecon` 依 file_contexts 套用；`chcon` 手動改 | `chcon` 只是暫時 | `restorecon` 會改回政策值 |

**注意**：`SELINUX=disabled` 開機後檔案系統不會再打標籤；之後改回 enforcing 必須 `touch /.autorelabel` 重開機全盤重標（大磁碟要很久），這是 Fedora 建議「寧可 permissive 也不要 disabled」的原因。Fedora 37+ 更進一步：`/etc/selinux/config` 的 `disabled` 實際上只是不載入政策，核心參數 `selinux=0` 才是真關閉。

---

## 3. 讀懂政策：sesearch / seinfo / sepolicy（已實測）

**名詞與關係**：三支工具都只讀 `policy.35`、不改政策，差別在「查什麼」：

```
policy.35 ──▶ sesearch   查「規則」：-A allow、-T 轉換（type_transition）、--dontaudit、-b 限定某個 boolean 的條件規則
          ├─▶ seinfo     查「物件」：-t type、-a attribute、-b boolean、--portcon 埠標籤、--genfscon / --fs_use 檔案系統打標規則
          └─▶ sepolicy   查「摘要」：transition / network / communicate / manpage，把上面兩者的結果整理成人看的
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **setools** | 一套政策分析工具（`sesearch`、`seinfo`、`sediff`…），Fedora 套件名 `setools-console` | 只讀不改；改政策是 semanage / semodule 的事 |
| **`sesearch`** | 依 source domain / target type / class / permission 條件搜尋政策規則 | 回答「誰能對什麼做什麼」與「執行後轉到哪個 domain」 |
| **`seinfo`** | 列出政策中的物件：type、attribute、boolean、role、埠標籤、檔案系統打標規則 | 回答「這個 type 屬於哪些 attribute」「這個埠預設是什麼 type」 |
| **`sepolicy`** | `policycoreutils` 的高階查詢工具，輸出人類可讀的摘要或整份 man page | 同一支指令的 `generate` 子命令在 §6 用來產生模組骨架 |
| **attribute** | 一群 type 的集合名（`domain`、`httpdcontent`、`port_type`…），規則寫在 attribute 上即一次套用給所有成員 | sesearch 查到的 allow 常寫 attribute 而非單一 type；`seinfo -a` 展開成員 |
| **boolean / 條件規則** | boolean 是政策內建的開關；條件規則是「boolean 為真時才生效」的 allow | sesearch 顯示 `[ bool ]:False` 表示規則存在但被關；`setsebool -P` 開 |
| **type_transition（轉換規則）** | 「A domain 執行 B exec type → 進入 C domain」或「A domain 在 B 目錄建檔 → 新檔自動標 C type」 | 前者就是 §1 的 domain transition，後者決定新檔的預設標籤（§9）；都用 `sesearch -T` 查 |
| **dontaudit** | 「拒絕但不寫 AVC」的規則，用來壓掉已知無害的雜訊 | 除錯盲點：`semodule -DB` 重建一份不含 dontaudit 的政策，看完 `semodule -B` 恢復 |
| **portcon / genfscon / fs_use** | 政策內建的「埠 → type」「特殊檔案系統（proc、sysfs）→ type」「各檔案系統怎麼取得標籤（xattr / 固定值 / 依建立者）」規則 | `semanage port` 加的是政策庫層，portcon 是模組層；`semanage port -l` 兩者一起列 |
| **`-p policy.35`** | 指定要查的政策檔，而不是目前核心載入的那份 | disabled 環境或查別台機器時必加；`audit2allow` / `audit2why` 也一樣 |

**為什麼**：遇到 AVC 時，正確的問題不是「怎麼放行」，而是「政策**原本**打算怎麼讓這件事合法」——通常是某個 boolean、某個 type、或某條 type transition，只是你的檔案 / 埠標籤不符合。`setools` 讓你直接查編譯後的政策，不必猜。

**怎麼做**：

```bash
sudo dnf install -y setools-console policycoreutils-python-utils selinux-policy-devel
# 誰可以對什麼做什麼（allow 規則）
sesearch -A -s httpd_t -t httpd_sys_content_t -c file            # 實測：allow httpd_t httpd_content_type:file { getattr ioctl lock map open read }
sesearch -A -s httpd_t -c tcp_socket -p name_connect              # httpd 能連哪些埠 type（受 boolean 條件的會標示 [ httpd_can_network_connect ]:False）
sesearch -A -t shadow_t -c file -p read                           # 誰能讀 shadow_t（會發現只有 auth 相關 domain）
# 條件規則：哪個 boolean 控制
sesearch -A -s httpd_t -t user_home_t -b httpd_read_user_content
# 轉換：程序執行某 exec_t 會進入哪個 domain；檔案在某目錄建立會自動變什麼 type
sesearch -T -s sshd_t                                             # 實測：type_transition sshd_t admin_home_t:dir auth_home_t .yubico ...
sesearch -T -s httpd_t -c file                                    # httpd 在 /var/log/httpd 建的檔自動是 httpd_log_t
# dontaudit：明明被拒卻沒有 AVC 紀錄（除錯時很常見的盲點）
sesearch --dontaudit -s chronyd_t                                 # 實測有 dontaudit chronyd_t ... net_bind_service
sudo semodule -DB                                                 # 暫時停用所有 dontaudit（除錯完 semodule -B 恢復）
# type / attribute / boolean 資訊
seinfo -t httpd_t -x                                              # 實測：httpd_t 屬於 daemon, domain, syslog_client_type ... 等 attribute
seinfo -a httpdcontent -x                                         # attribute 含哪些 type
seinfo -b | wc -l; seinfo -b httpd_can_network_connect -x
seinfo --portcon | grep -E "\b(22|2222|8080),"                    # 埠標籤（政策內建）；semanage port -l 含本機新增
seinfo --fs_use; seinfo --genfscon | head                         # 檔案系統怎麼打標（tmpfs、nfs、proc…）
# sepolicy：人類可讀的摘要
sepolicy transition -s sshd_t                                     # 實測：sshd_t @ passwd_exec_t --> passwd_t ...
sepolicy network -t http_port_t                                   # 實測：http_port_t: tcp: 80,81,443,488,8008,8009,8443,9000
sepolicy communicate -s httpd_t -t postgresql_t                   # 兩個 domain 能否透過檔案溝通
sepolicy manpage -d httpd_t -p /tmp && man -l /tmp/httpd_selinux.8   # 實測：自動產生該 domain 的 man page（含所有 boolean、type、port）
sepolicy booleans -a                                              # 需 SELinux 啟用（容器內實測失敗）；離線用 semanage boolean -l
```

**注意**：`sesearch` 預設查的是**目前載入**的政策；SELinux disabled 或要查別台機器的政策時加 `-p /path/to/policy.35`（`audit2allow` / `audit2why` 同樣，實測 disabled 環境需 `-p`，否則報 `You must specify the -p option`）。

---

## 4. 讀懂 AVC 與系統性的除錯流程

**名詞與關係**：一則 AVC 從核心產生到變成「建議指令」會經過幾個工具，處置則固定分 A / B / C / D 四類：

```
核心拒絕 ─▶ AVC 紀錄 ─┬─▶ auditd → /var/log/audit/audit.log ─▶ ausearch -m avc（撈）─▶ audit2why（解釋 / 指出 boolean）、audit2allow（草稿，§5）
                      │                                        └▶ setroubleshootd（setroubleshoot-server）─▶ journal 摘要（journalctl -t setroubleshoot）
                      │                                                                                   └▶ sealert -l <UUID>（完整分析 + 建議）
                      └─▶ 沒裝 auditd：直接進 journal（journalctl -k -g avc）
處置（依序）：A 標籤錯 → restorecon（永久：semanage fcontext）｜B 埠錯 → semanage port｜C 政策預設關 → setsebool -P｜D 以上皆非 → §5 自訂模組
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **`scontext` / `tcontext`** | AVC 的 source context（發動的程序 domain）與 target context（被存取物件的 type） | 就是 §1 的 subject 與 object 標籤 |
| **`tclass` / `{ permission }`** | 被存取物件的 class 與被拒的動作 | 與 scontext / tcontext 合成一條可直接用 `sesearch -A -s -t -c -p` 查的四元組 |
| **`permissive=0/1`** | 0 表示真的擋了；1 表示只記錄沒擋 | 整機 permissive 或 `semanage permissive -a <domain>` 都會讓它變 1 |
| **`comm` / `pid` / `name` / `dest`** | 程式名、程序號、被碰的檔名、目的埠 | 定位「哪個程序在碰哪個東西」；`ausearch -c` 就是照 comm 篩 |
| **auditd / `audit.log` / `ausearch`** | 稽核守護程序 / 它寫的檔 / 查詢工具（`-m` 事件類型、`-ts` 時間、`-c` 程式名、`-i` 轉可讀） | AVC 的第一站；`-m avc,user_avc,selinux_err` 涵蓋核心、userspace（D-Bus、systemd）與政策載入錯誤三種 |
| **`journalctl -k` / `-t setroubleshoot`** | 看核心訊息 / 看 setroubleshootd 寫的摘要 | 前者是沒有 auditd 時的退路，後者是 sealert 的索引（提供 UUID） |
| **setroubleshoot-server / setroubleshootd / `sealert`** | 套件 / 常駐分析服務 / CLI：把 AVC 對照政策，產生「可能原因 + 建議指令 + 信心度」 | 建議順序 restorecon → boolean → 自訂模組；`sealert -a` 掃整個 log，`-l` 看單一事件 |
| **`audit2why`** | 讀 AVC，回答「被拒的原因是缺規則、標籤錯，還是某個 boolean 沒開」 | 比 sealert 輕量；能直接印出 `setsebool -P …` |
| **`default_t` / `unlabeled_t` / `unreserved_port_t`** | 「file_contexts 沒定義這條路徑」/「檔案根本沒標籤」/「沒有任何服務認領的埠」三個佔位 type | 出現在 tcontext 就代表標籤錯（A 或 B），不是缺規則 |
| **`init_t` / `bin_t`** | systemd 本身的 domain / 一般可執行檔的 type | `ExecStart` 指到非 `bin_t` 的檔時，AVC 的 scontext 是 init_t 而不是服務 |
| **`semanage port -a` / `-m`** | 把埠加進某個 port type / 把已被別的 type 佔用的埠改成另一個 type | 對應 B；埠已有標籤時 `-a` 會報「already defined」，改用 `-m` |
| **`setsebool -P` / `semanage boolean -l`** | 永久切換 boolean / 列出所有 boolean 與說明 | 對應 C；先用 `-l` 配 grep 找到正確的開關再開 |
| **`aa-logprof`** | AppArmor 的互動式工具：讀 `DENIED` 紀錄，逐條問你要不要加進 profile | 🟠 對應 sealert + audit2allow 的角色，但沒有 boolean / type 這層 |

**為什麼**：一則 AVC 已經包含解決問題所需的全部資訊：誰（scontext 的 domain）、對什麼（tcontext 的 type + tclass）、要做什麼（`{ permission }`）、是否真的被擋（`permissive=0`）。九成的案例落在三種原因：**檔案標籤錯**（tcontext 是 `user_home_t` / `default_t` / `unlabeled_t` 這種「不該出現」的 type）、**埠標籤錯**（tclass=tcp_socket，tcontext 是 `unreserved_port_t` 或別的服務的 port type）、**需要開 boolean**（tcontext 看起來合理但政策預設關）。只有剩下的一成才需要自訂模組。

**怎麼做**：

```bash
# 1) 取得 AVC（auditd 在 Fedora 預設安裝；沒有 auditd 時進 journal）
sudo ausearch -m avc,user_avc,selinux_err -ts recent              # 最近 10 分鐘
sudo ausearch -m avc -ts today -c nginx                            # 依程式名
sudo ausearch -m avc -ts recent -i                                 # -i 把數字轉可讀
sudo journalctl -t setroubleshoot --since -1h                      # setroubleshootd 的摘要（需 setroubleshoot-server）
sudo journalctl -k -g avc                                          # 無 auditd 時
# 2) 讓 setroubleshoot 分析（它會依序建議：restorecon → boolean → 自訂模組）
sudo sealert -a /var/log/audit/audit.log | less
sudo sealert -l <UUID>                                             # 依 journal 中的 UUID 看單一事件
# 3) 依原因處置（順序！）
sudo restorecon -Rv /path                                          # A. 標籤錯 → 修標籤；永久性的路徑用 semanage fcontext -a 再 restorecon
sudo semanage port -a -t http_port_t -p tcp 8080                   # B. 埠 → 標記埠（已被別的 type 佔用時用 -m 修改）
sudo setsebool -P httpd_can_network_connect 1                      # C. boolean（-P 永久）；先 semanage boolean -l | grep httpd 找對的
# D. 以上皆非 → §5 自訂模組
# 4) 驗證：清空後重現，確認沒有新 AVC
sudo ausearch -m avc -ts recent | audit2why                        # 實測範例會直接指出 "The boolean httpd_read_user_content was set incorrectly"
```

實測 `audit2why -p policy.35 -i sample-avc.log` 的輸出示範它如何把 AVC 對應到 boolean：

```
type=AVC msg=audit(...): avc:  denied  { name_connect } for  pid=1234 comm="nginx" dest=8080
    scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:http_cache_port_t:s0 tclass=tcp_socket
	Was caused by:
	One of the following booleans was set incorrectly.
	# setsebool -P httpd_can_network_connect 1
	# setsebool -P httpd_can_network_relay 1
```

**注意**：
- 看不到 AVC 但明明被擋：可能被 `dontaudit` 吃掉 → `sudo semodule -DB` 後重現，看完 `semodule -B`。
- `permissive=1` 的 AVC 表示只記錄沒擋（整機 permissive 或該 domain 被設為 permissive）——別在 permissive 模式下「測完沒問題」就上線。
- 服務啟動失敗但 AVC 出現在 **systemd**（`init_t`）而不是服務本身：常是 unit 的 `ExecStart` 指到標籤錯的可執行檔（自編程式放 `/opt` 未標 `bin_t`）→ `sudo semanage fcontext -a -t bin_t "/opt/myapp/bin(/.*)?" && sudo restorecon -Rv /opt/myapp`。
- 🟠 AppArmor 的對應：`journalctl -k -g apparmor` 看 `DENIED`，用 `aa-logprof` 補 profile；概念相同但沒有 boolean / type 這層。

---

## 5. 自訂政策模組（已實測建置流程）

**名詞與關係**：§5 全部在講「怎麼把自己的規則變成政策庫裡的一個模組」，所有名詞都是這條工具鏈上的檔案格式或工具：

```
   來源         .te（type enforcement 規則）    .fc（路徑 → 標籤）     .if（介面 / 巨集定義）      .cil（CIL 原生語法，§5.3）
              手寫 / audit2allow -M（§5.1）     sepolicy generate 一次產生三者（§6）                 手寫 / udica（§7）
                     │                             │                    │                             │
 raw 語法路徑   checkmodule -M -m ─▶ .mod ─semodule_package（-f .fc）─▶ .pp ─┐                       │
                                                                          ├─▶ semodule -i ─▶ 政策庫 modules/400/<名>/ ─semodule -B─▶ policy.35 ─▶ 核心
 refpolicy 巨集路徑  make -f /usr/share/selinux/devel/Makefile（selinux-policy-devel 提供，先用 m4 展開巨集）─▶ 同樣得到 .pp ─┘
                                                                          （.pp 進政策庫時會被轉成 CIL，再與其他模組一起編譯）
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **`.te`** | Type Enforcement 原始碼：宣告 type、寫 allow / 轉換規則 | 自訂模組的核心檔；純 raw 語法用 `checkmodule` 編，含巨集的用 Makefile 編 |
| **`.fc`** | File Contexts：本模組的「路徑 regex → 標籤」表 | 安裝後合併進 `file_contexts`，`restorecon` 才認得新路徑 |
| **`.if`** | Interface：本模組對外提供的巨集（例如 `myapp_read_config()`），讓別的模組引用 | refpolicy 巨集就是「別的模組的 `.if`」；發行版的都在 `/usr/share/selinux/devel/include/` |
| **`.mod` / `.pp`** | `.mod` 是 checkmodule 編出的中間物；`.pp`（Policy Package）把 `.mod` 與 `.fc` 打包成單一可安裝檔 | `semodule -i` 只吃 `.pp` 或 `.cil` |
| **`checkmodule` / `semodule_package`** | 編譯 `.te` → `.mod` / 打包 `.mod`（+ `.fc`）→ `.pp` 的兩支工具（`checkpolicy`、`policycoreutils` 套件） | 只處理 raw 語法；有巨集的 `.te` 要先經 Makefile 展開 |
| **`policy_module()` / refpolicy 巨集** | `.te` 開頭宣告「這是 refpolicy 模組」的巨集；巨集是 m4 定義，一行展開成多條規則 | 需要 `selinux-policy-devel` 的 Makefile 與 `include/` 才能展開（§5.4） |
| **`selinux-policy-devel` / Makefile** | 提供 `/usr/share/selinux/devel/Makefile` 與所有 `.if` 介面的套件 | `make -f … x.pp` 一步做完展開 + 編譯 + 打包 |
| **CIL** | Common Intermediate Language：新的原生政策語言，`semodule` 直接吃 `.cil` 不需編譯 | `.pp` 安裝時也會被轉成 CIL，所以 CIL 是政策庫的共同底層（§5.3） |
| **`semodule`** | 模組管理工具：`-i` 安裝、`-r` 移除、`-d` / `-e` 停用 / 啟用、`-B` 重建、`-X` 指定 priority | 把模組放進政策庫再重建 `policy.35`（§5.2） |

### 5.1 為什麼不能直接 `audit2allow -M` 然後 `semodule -i`

**名詞與關係**：`audit2allow`（把 AVC 紀錄機械式翻成 allow 規則的工具，`policycoreutils-python-utils` 提供）→ `-M <名稱>`（不只印規則，還直接產生 `<名稱>.te` 並編譯成可安裝的 `<名稱>.pp`）→ `semodule -i <名稱>.pp`（裝進本機政策庫、立即生效）。三步串成「AVC → 規則 → 安裝」的一鍵流水線，省掉的正是「這條規則該不該存在」的人工審查；輸出裡的 `#!!!!` 提示行是 audit2allow 自己在說「這條其實有 boolean 可用」。

**為什麼**：`audit2allow` 只是把「被拒的動作」機械式翻成 allow 規則。若被拒的原因是標籤錯，它會產生 `allow httpd_t user_home_t:file read`——這條規則讓 nginx 從此可以讀**所有使用者家目錄的檔案**，遠超出你要解決的那一個檔。更糟的是，如果 AVC 來自攻擊者的嘗試（例如 webshell 想讀 `/etc/shadow`），你等於替攻擊者開門。實測 `audit2allow` 自己也會在輸出加註 `#!!!! This avc can be allowed using the boolean ...`——**看到這行就不該裝模組，去開 boolean**。

**怎麼做**：把 `audit2allow` 當**草稿產生器**，人工審查每一條規則：

```bash
sudo ausearch -m avc -ts recent -c myapp > /tmp/avc.log
audit2allow -i /tmp/avc.log                     # 先只看（實測會標示可用的 boolean）
audit2allow -i /tmp/avc.log -M myapp_local      # 產生 myapp_local.te + myapp_local.pp
vim myapp_local.te                              # ⚠️ 逐條審查：刪掉「應該用 restorecon / boolean 解決」的規則，只留真正需要的
```

實測產生的 `.te`（`scripts/examples/selinux/nginxlocal.te`）：

```
module nginxlocal 1.0;

require {
	type httpd_t;
	type http_cache_port_t;
	type user_home_t;
	class tcp_socket name_connect;
	class file read;
}

#============= httpd_t ==============

#!!!! This avc can be allowed using one of the these booleans:
#     httpd_can_network_connect, httpd_can_network_relay
allow httpd_t http_cache_port_t:tcp_socket name_connect;

#!!!! This avc can be allowed using the boolean 'httpd_read_user_content'
allow httpd_t user_home_t:file read;
```

這個範例兩條都應該刪掉改用 boolean——它示範的正是「不要照單全收」。

### 5.2 模組的編譯、安裝、管理

**名詞與關係**：工具鏈全圖見 §5 開頭；這一節只補 `checkmodule` 的旗標與 `semodule` 各子命令的分工：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **`checkmodule -M -m`** | `-m` 表示編譯的是「模組」而非整套基礎政策；`-M` 啟用 MLS / MCS 欄位 | targeted 政策也帶 MCS，不加 `-M` 編出的模組裝不進去 |
| **`semodule_package -m … -f …`** | 把 `.mod`（必要）與 `.fc`（`-f`，可選）打包成 `.pp` | 沒有 `.fc` 的模組只加規則、不加路徑標籤 |
| **priority / `-X`** | 同名模組可並存多個優先權，最高者生效；`-X` 指定安裝到哪個優先權 | 不指定時自訂為 400；用 `-X 100` 蓋掉發行版模組不建議——升級後會混淆 |
| **`-n` / `-B`** | `-n` 只寫進政策庫不重建；`-B` 重建並載入 policy.35 | 批次安裝多個模組時用 `-n` 省下每次數十秒的重建 |
| **`-d` / `-e` / `-r`** | 停用（保留檔案）/ 啟用 / 移除 | 停用可快速驗證「問題是不是這個模組造成的」 |
| **`--extract`** | 從政策庫把已安裝模組取回成 `.pp` | 升級或搬機前備份沒進 git 的模組 |
| **`modules/400/<名>/`** | 模組在政策庫中的存放目錄（內含 cil、hll、lang_ext 三個檔） | `semodule -i` 之後的實體證據；`semodule -lfull` 列的就是這裡 |

**為什麼**：`.te`（type enforcement 原始碼）→ `.mod`（編譯）→ `.pp`（打包）→ `semodule -i` 進政策庫並重建 `policy.35`。理解這條鏈才能把模組納入版本控制與 Ansible 佈署（放 `.te` 進 git，佈署時編譯），而不是在每台機器上手動 `audit2allow`。

**怎麼做**（實測）：

```bash
checkmodule -M -m -o nginxlocal.mod nginxlocal.te      # 編譯（-M 啟用 MLS 欄位）
semodule_package -o nginxlocal.pp -m nginxlocal.mod    # 打包（實測 1.2 KB）
sudo semodule -i nginxlocal.pp                          # 安裝（自訂模組預設 priority 400，覆蓋同名的發行版模組 100）
sudo semodule -l | grep nginxlocal; sudo semodule -lfull | grep nginxlocal   # 實測：400 nginxlocal pp
sudo semodule -r nginxlocal                             # 移除
sudo semodule -d nginxlocal / -e nginxlocal             # 停用 / 啟用（保留檔案）
sudo semodule -X 400 -i nginxlocal.pp                   # 指定優先權
sudo semodule -n -i x.pp                                # -n：只寫入政策庫不重載（批次安裝多個時最後再 semodule -B）
sudo semodule -B                                        # 重建並載入
sudo semodule --extract nginxlocal                      # 取回已安裝模組的 .pp（升級前備份）
# 模組來源存放：/var/lib/selinux/targeted/active/modules/400/nginxlocal/
```

### 5.3 CIL：更簡潔的小型規則（已實測）

**名詞與關係**：CIL 之所以「不需編譯」，是因為政策庫內部本來就以 CIL 為共同底層：

```
.te（raw 或 refpolicy）──checkmodule / Makefile──▶ .pp ──semodule -i 時由 hll/pp 轉換器轉成──▶ CIL ─┐
.cil（直接手寫）─────────────────────────────────semodule -i────────────────────────────────▶ CIL ─┴─ 全部一起編譯 ▶ policy.35
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **CIL** | Common Intermediate Language：以括號（S-expression）語法寫的政策語言，`libsepol` 直接編譯 | `.te` / `.pp` 屬於「高階語言（HLL）」，安裝時被轉成 CIL；兩種模組可在同一政策庫並存 |
| **HLL / `hll/pp`** | High Level Language 與它的轉換器（`/usr/libexec/selinux/hll/pp`）：把 `.pp` 轉成 CIL | 解釋為什麼政策庫 `modules/` 裡每個模組都有 `cil` 與 `hll` 兩個檔 |
| **`(allow src tgt (class (perm …)))`** | CIL 的 allow 規則，等同 `.te` 的 `allow src tgt:class { perm };` | 引用既有 type 不需要 `require` 區塊 |
| **`(typeattributeset cil_gen_require T)`** | 宣告「T 由別的模組定義，這裡只是引用」 | 等同 `.te` 的 `require { type T; }`；semodule 多半會自動處理，可省略 |
| **`(boolean …)` / `(booleanif …)`** | 定義 boolean / 依 boolean 開關的條件規則 | 對應 `.te` 的 `bool` / `if (…) { }`；一樣能用 `setsebool` 切 |
| **`(typetransition …)`** | 檔案建立或程序執行時的自動標籤 / domain 轉換規則，可指定檔名 | 對應 §3 的 `type_transition`；帶檔名的「名稱轉換」是 CIL 與新版 `.te` 都支援的功能 |
| **`(portcon tcp 埠 (context))`** | 在模組內把埠綁到 port type | 效果同 `semanage port -a`，但隨模組佈署、可進版控 |

**為什麼**：只加一兩條規則時，`.te` 的 `require { }` 樣板顯得冗長；**CIL**（Common Intermediate Language）是 SELinux 新的原生政策語言，一行一條規則、不需編譯，`semodule -i x.cil` 直接吃。RHEL 9 / Fedora 的官方文件現多以 CIL 示範。

**怎麼做**：

```bash
cat > local_nginx.cil <<'EOF'
(allow httpd_t http_cache_port_t (tcp_socket (name_connect)))
EOF
sudo semodule -i local_nginx.cil        # 實測：直接安裝，semodule -l 出現 local_nginx
sudo semodule -r local_nginx
# 常見 CIL 片段
# (typeattributeset cil_gen_require httpd_t)                       ; 引用既有 type 不需 require
# (boolean my_bool false) (booleanif my_bool (true (allow ...)))   ; 自訂 boolean
# (typetransition httpd_t var_log_t file myapp_log_t "app.log")    ; 檔名轉換
# (portcon tcp 8085 (system_u object_r http_port_t ((s0) (s0))))   ; 埠標籤（等同 semanage port）
```

### 5.4 用 refpolicy 巨集寫「正式」模組：自訂 type 與 port（已實測）

**名詞與關係**：巨集、介面、Makefile 三者是「誰定義、誰展開、誰提供」的關係：

```
/usr/share/selinux/devel/include/{kernel,services,system,…}/*.if ◀── refpolicy 的介面（interface）定義，由 selinux-policy-devel 套件提供
          ▲ make -f devel/Makefile 用 m4 把巨集呼叫展開成規則
myapp_port.te：policy_module(...) + corenet_port(myapp_port_t) ──▶ myapp_port.pp ──semodule -i──▶ 政策庫（type 與 attribute 生效）
                                                                                       └─▶ semanage port -a -t myapp_port_t 9100：把真實埠號綁上新 type
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **refpolicy 巨集（macro）** | 用 m4 寫的規則樣板：一次呼叫展開成一組配套規則（type 宣告 + attribute + 常見 allow） | 發行版政策全用巨集寫；`audit2allow -R` 也會盡量翻成巨集 |
| **interface（`.if`）** | 巨集的定義所在：每個模組用 `interface(名稱, 規則)` 對外宣告「別的模組可以怎麼跟我互動」 | `corenet_port`、`files_type`、`init_daemon_domain` 分別來自 `kernel/corenetwork.if`、`kernel/files.if`、`system/init.if` |
| **`policy_module(名, 版本)`** | `.te` 開頭的巨集：宣告模組名稱與版本，並自動 require 基礎 class 與核心 type | 有它的 `.te` 只能用 Makefile 編，`checkmodule` 看不懂 |
| **`corenet_port(T)`** | 宣告 T 是埠 type：掛上 `port_type` attribute，讓 `sesearch` / `semanage port` 認得它 | 之後才能 `semanage port -a -t T` 綁真實埠號 |
| **`files_type(T)` / `init_daemon_domain(D, E)`** | 前者宣告 T 是一般檔案 type（restorecon、備份 domain 認得）；後者宣告「systemd 執行 E → 轉入 D」並給 D daemon 的基本權限 | §6 的骨架就靠這兩個巨集撐起一個 confined domain |
| **attribute `port_type`** | 所有埠 type 的集合 | 政策裡針對「所有埠」的通用規則以它為對象；沒掛上等於一個隱形的埠 |
| **`selinux-policy-devel` / Makefile** | 提供 `include/*.if` 與 `/usr/share/selinux/devel/Makefile` 的套件 | 沒裝就無法展開巨集，`make` 會找不到介面 |
| **`require { }`** | 引用「別的模組定義的 type / class」 | 本例引用 `httpd_t`；`policy_module` 不會自動幫你 require 服務的 type |

**為什麼**：`audit2allow` 產生的是「原始 allow 規則」，而發行版政策是用 **refpolicy 巨集**（`corenet_port()`、`files_type()`、`init_daemon_domain()`…）寫的：一個巨集展開成幾十條配套規則（例如宣告一個 port type 同時給它 `port_type` attribute 讓 `sesearch` / `semanage` 認得）。要新增 type（例如給自家服務專屬的埠或資料目錄）就必須用巨集，需要 `selinux-policy-devel` 提供的 Makefile 與介面定義。

**怎麼做**（實測 `scripts/examples/selinux/myapp_port.te`）：

```
policy_module(myapp_port, 1.0)
require { type httpd_t; }
type myapp_port_t;
corenet_port(myapp_port_t)
allow httpd_t myapp_port_t:tcp_socket name_connect;
```

```bash
sudo dnf install -y selinux-policy-devel
make -f /usr/share/selinux/devel/Makefile myapp_port.pp     # 實測成功產生 myapp_port.pp
sudo semodule -i myapp_port.pp
sudo semanage port -a -t myapp_port_t -p tcp 9100            # 把埠綁到新 type；之後只有明確 allow 的 domain 能連 9100
ls /usr/share/selinux/devel/include/                          # 所有可用的巨集介面（kernel/ services/ system/ …）
grep -r "interface(\`corenet_port'" /usr/share/selinux/devel/include/ -A5 | head    # 看巨集定義
```

---

## 6. 為自家服務建立 confined domain（sepolicy generate，已實測）

**名詞與關係**：`sepolicy generate` 一次產生五個檔，其中三個是 §5 的模組本體、兩個是佈署工具；迭代流程則是 §4 除錯流程套在一個「刻意 permissive」的 domain 上：

```
sepolicy generate --init /usr/local/bin/myapp -n myapp
   ├─ myapp.te    type myapp_t / myapp_exec_t、init_daemon_domain()、permissive myapp_t;
   ├─ myapp.fc    /usr/local/bin/myapp → myapp_exec_t、/var/lib/myapp → myapp_var_lib_t、/var/log/myapp → myapp_log_t
   ├─ myapp.if    給其他模組用的介面（myapp_read_lib_files() 之類）
   ├─ myapp.sh    = make（展開巨集）+ semodule -i + restorecon 三步
   └─ myapp_selinux.spec   rpmbuild 成 myapp-selinux 套件
迭代：./myapp.sh ─▶ systemctl restart（systemd 執行 myapp_exec_t ─domain transition─▶ myapp_t）─▶ 跑完所有功能
      ─▶ ausearch | audit2allow -R ─▶ 補進 myapp.te ─▶ 重複到沒有新 AVC ─▶ 刪掉 permissive 行 ─▶ 正式 enforcing
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **`unconfined_service_t`** | systemd 啟動「政策不認識的可執行檔（`bin_t`）」時進入的 domain，幾乎不受限 | 沒寫政策的自家服務都在這裡；有了 `myapp_exec_t` + `init_daemon_domain` 才會轉進 `myapp_t` |
| **confined domain** | 有專屬 type、規則只涵蓋服務實際需要動作的 domain | 本節的目標；發行版把 httpd、sshd 關進的就是這種 |
| **`sepolicy generate`** | `policycoreutils-devel` 的骨架產生器，依程式類型（`--init` / `--dbus` / `--cgi` / `--user`…）產生五個檔 | 產出用 refpolicy 巨集寫成，所以要 `selinux-policy-devel` 才編得過 |
| **`.te` / `.fc` / `.if` / `.sh` / `.spec`** | 規則 / 路徑標籤 / 介面 / 一鍵編譯安裝腳本 / RPM 打包規格 | 前三個是模組本體（§5），後兩個是佈署工具 |
| **`init_daemon_domain(D, E)`** | refpolicy 巨集：宣告 E 為 exec type，systemd（`init_t`）執行 E 時轉入 D | 骨架的 domain transition 來源；沒有它服務仍跑在 `unconfined_service_t` |
| **`gen_context(context, level)`** | `.fc` 裡產生完整 context 字串的巨集 | 安裝後併入 `file_contexts`，`restorecon` 才會把 `/usr/local/bin/myapp` 標成 `myapp_exec_t` |
| **`logging_log_file(T)` / `files_type(T)`** | 宣告 T 是日誌檔 type（logrotate 等日誌 domain 認得）/ 一般檔案 type | 讓既有 domain 用通用規則就能處理你的檔案，不必逐一 allow |
| **permissive domain / `permissive D;` / `semanage permissive`** | 只讓 D 這一個 domain「記錄不阻擋」，其他 domain 仍 enforcing | `.te` 裡的 `permissive` 行隨模組走，`semanage permissive -a` 是臨時加在政策庫；效果相同 |
| **`audit2allow -R`** | 產生規則時優先翻成 refpolicy 巨集（如 `sysnet_dns_name_resolve(myapp_t)`）而非原始 allow | 產出可直接貼進 `policy_module` 風格的 `.te` |
| **`rpmbuild` / `myapp-selinux` / Ansible `community.general.sefcontext`** | 把模組打成 RPM 隨應用安裝 / 用 Ansible 佈署 fcontext 與模組 | 讓政策與程式同版本、同流程上線，而不是每台機器手動 `audit2allow` |

**為什麼**：自己寫的 daemon（`/usr/local/bin/myapp`）由 systemd 啟動後會跑在 `unconfined_service_t`——等於沒有 SELinux 保護：被打穿後能讀所有 unconfined 可讀的東西。把它關進專屬 domain 是 SELinux 真正的價值所在：myapp 只能讀自己的設定、寫自己的資料與日誌、連自己的埠。`sepolicy generate` 會產生骨架並**預設 permissive**，讓你在不影響服務的情況下用 AVC 補齊規則。

**怎麼做**：

```bash
sudo dnf install -y policycoreutils-devel selinux-policy-devel
mkdir -p ~/selinux/myapp && cd ~/selinux/myapp
sepolicy generate --init /usr/local/bin/myapp -n myapp        # 實測產生 myapp.te myapp.fc myapp.if myapp.sh myapp_selinux.spec
#   --init 適合 systemd 服務；其他類型：--dbus --inetd --cgi --user --application --confined_admin
#   -w /var/lib/myapp -w /var/log/myapp  可一併宣告可寫目錄
```

實測產生的 `myapp.te`（節錄）與 `myapp.fc`：

```
policy_module(myapp, 1.0.0)

type myapp_t;
type myapp_exec_t;
init_daemon_domain(myapp_t, myapp_exec_t)      # systemd 執行 myapp_exec_t → 轉入 myapp_t

permissive myapp_t;                            # ⚠️ 骨架預設 permissive：只記錄不阻擋

type myapp_log_t;
logging_log_file(myapp_log_t)

type myapp_var_lib_t;
files_type(myapp_var_lib_t)

allow myapp_t self:fifo_file rw_fifo_file_perms;
allow myapp_t self:unix_stream_socket create_stream_socket_perms;
```

```
/usr/local/bin/myapp        --  gen_context(system_u:object_r:myapp_exec_t,s0)
/var/lib/myapp(/.*)?            gen_context(system_u:object_r:myapp_var_lib_t,s0)
/var/log/myapp(/.*)?            gen_context(system_u:object_r:myapp_log_t,s0)
```

迭代流程：

```bash
sudo ./myapp.sh                    # = make -f /usr/share/selinux/devel/Makefile myapp.pp && semodule -i myapp.pp && restorecon -R 上述路徑
sudo systemctl restart myapp && ps -eZ | grep myapp     # 應顯示 system_u:system_r:myapp_t:s0
# 跑過所有功能（含 log rotate、重載、備份）讓 AVC 出現，然後：
sudo ausearch -m avc -ts recent -c myapp | audit2allow -R      # -R 盡量用 refpolicy 巨集而非原始規則
#   把合理的規則加進 myapp.te（例如 corenet_tcp_bind_http_port(myapp_t)、logging_send_syslog_msg(myapp_t)、sysnet_dns_name_resolve(myapp_t)）
sudo ./myapp.sh                    # 重編、重裝、重測，直到沒有新 AVC
# 最後把 permissive myapp_t; 刪掉（或 semanage permissive -d myapp_t），重編安裝 → 正式 enforcing
sudo semanage permissive -l        # 確認沒有殘留的 permissive domain
# 打包：myapp_selinux.spec 可 rpmbuild 成 myapp-selinux 套件，隨應用一起佈署；或把 .te/.fc 放 Ansible 角色，用 community.general.sefcontext + 編譯安裝
```

**注意**：`semanage permissive -a some_t` 是「只讓某個 domain permissive」的正規做法，比整機 `setenforce 0` 安全得多，適合在正式環境上線新服務時使用。

---

## 7. 容器與 SELinux

**名詞與關係**：容器隔離只用了兩個 type 加上 MCS 類別，其餘名詞都是「拆掉」或「放寬」這層隔離的方式：

```
容器 A  container_t:s0:c12,c34 ──▶ 只能碰 container_file_t:s0:c12,c34（:Z 私有）或 container_file_t:s0（:z 共享，無類別）
                                             ▲ ✗ 類別不符，拒絕
容器 B  container_t:s0:c56,c78 ──▶ 只能碰 container_file_t:s0:c56,c78
container_t 對宿主機任何非 container_file_t 的檔案（/etc、/home、/root…）一律拒絕 ──▶ 逃逸後拿到 root 仍讀不到宿主機資料
拆掉這層：spc_t、label=disable、--privileged        放寬一點：container_* boolean ──▶ 還不夠：udica 產生專屬 domain
KVM 同一套：svirt_t:s0:cX,cY（qemu 程序）──▶ virt_image_t:s0:cX,cY（磁碟映像）＝ sVirt
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **`container_t`** | 所有容器程序預設跑的 domain（`container-selinux` 套件提供） | Podman / Docker / CRI-O 啟動容器時由 runtime 指定 |
| **`container_file_t`** | 容器可讀寫的檔案 type；宿主機上只有標成它的目錄才能給容器用 | `:z` / `:Z` 就是把 volume 重標成它 |
| **MCS（Multi-Category Security）/ 類別** | context 第四欄的 `cX,cY` 類別對；runtime 為每個容器隨機挑兩個類別 | 同為 `container_t` 的容器靠類別不同互相隔離；檔案的類別必須包含程序的類別才能存取 |
| **`:z` / `:Z`** | volume 掛載選項：小寫共享（`container_file_t:s0`，無類別）、大寫私有（加上本容器的類別） | 兩者都由 runtime 以 chcon 方式重標，不進 `file_contexts`；`restorecon` 會還原 |
| **`spc_t`（super privileged container）** | 幾乎不受限的容器 domain，等同關掉 SELinux 隔離 | 只給要管宿主機的工具容器；`--privileged` 的容器也跑在這裡 |
| **`label=disable` / `--privileged`** | 前者只關 SELinux 標籤；後者連 capability、seccomp、裝置隔離一起關 | 兩者都讓容器逃逸直達宿主機 root（§11） |
| **container boolean（`container_manage_cgroup`、`container_use_devices`…）** | `container-selinux` 內建的開關，放寬 `container_t` 的特定能力 | 比換 domain 輕量；先查有沒有 boolean 再考慮 udica |
| **udica** | 讀 `podman inspect` 的 volume / 埠 / capability，產生「`container_t` + 剛好需要的權限」的 CIL 模組 | 依賴 `/usr/share/udica/templates/*.cil` 樣板；容器啟動時用 `label=type:<名>.process` 指定 |
| **Docker `"selinux-enabled": true`** | Docker daemon 預設不打 SELinux 標籤，要在 `daemon.json` 開啟 | Podman 預設就開；沒開等於所有容器不受 `container_t` 限制 |
| **sVirt / `svirt_t` / `virt_image_t`** | libvirt 把同一套 MCS 隔離套到 KVM：每台 VM 的 qemu 程序是 `svirt_t:s0:cX,cY`，磁碟映像是 `virt_image_t:s0:cX,cY` | 映像放非預設路徑要 `semanage fcontext` 標成 `virt_image_t`，libvirt 才能再補上類別 |

**為什麼**：容器逃逸（runc CVE-2019-5736、2024 年的 Leaky Vessels）能拿到宿主機 root，SELinux 是 Fedora / RHEL 上容器隔離的最後一層：所有容器程序跑在 `container_t`，只能碰標為 `container_file_t` 的檔案，且每個容器有不同的 **MCS 類別**（`s0:c123,c456`），彼此之間也隔離。這就是為什麼 Podman / Docker 在 Fedora 上掛載 volume 要加 `:z` / `:Z`——把宿主目錄重標為 `container_file_t`，否則容器內 Permission denied。

**怎麼做**：

```bash
ps -eZ | grep container_t                                  # 容器程序 domain；MCS 欄位每個容器不同
podman run -v /srv/data:/data:Z fedora:44 ls -Z /data      # :Z 私有標籤（含該容器的 MCS）；:z 共享（多容器共用）
podman run --security-opt label=type:spc_t ...             # super privileged container（等同關 SELinux，僅限管理工具）
podman run --security-opt label=disable ...                # 關閉該容器的 SELinux 隔離（不建議）
sudo setsebool -P container_manage_cgroup 1                # 容器內跑 systemd
sudo setsebool -P container_use_devices 1                  # 容器需要 /dev 裝置
sudo semanage boolean -l | grep ^container_                # 全部容器相關 boolean
# 容器需要「比 container_t 多一點」的權限時，用 udica 產生專屬 domain（實測套件 udica 0.2.8）
sudo podman inspect mycontainer | sudo udica my_container  # 產生 my_container.cil
sudo semodule -i my_container.cil /usr/share/udica/templates/{base_container.cil,net_container.cil,home_container.cil}
podman run --security-opt label=type:my_container.process ...
# Docker 在 Fedora 需 daemon.json 加 "selinux-enabled": true 才會打標
# ⚠️ 不要用 chcon -Rt container_file_t /（或 /home）來「解決」volume 問題：等於把整個目錄開放給所有容器
# KVM / libvirt 同理：sVirt 給每台 VM 不同 MCS，映像放非預設路徑要 semanage fcontext -a -t virt_image_t
```

---

## 8. Confined 使用者與 MLS/MCS（進階）

**名詞與關係**：這一節動的是 context 的第一欄（SELinux user）與第四欄（level），兩者都由「登入時的對應表」決定：

```
Linux 帳號 ──semanage login（seusers）──▶ SELinux user ──semanage user──▶ 可用 role ──▶ 進入的 domain
 alice    ────────────────────────────▶ staff_u ──▶ staff_r（日常 staff_t）──sudo ROLE=sysadm_r TYPE=sysadm_t──▶ sysadm_r / sysadm_t（真管理員）
 bob      ────────────────────────────▶ user_u  ──▶ user_r（user_t：不能 su / sudo、不能執行家目錄程式）
 __default__（沒被明列的所有人）─────────▶ unconfined_u ──▶ unconfined_r / unconfined_t
level 欄：MLS = sensitivity（s0 < s1 < …）垂直分級；MCS = 只用 category（c0…c1023）水平隔離。targeted 只有 s0 + MCS；mls 政策才有多個 sensitivity
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **SELinux user** | context 第一欄；一個 SELinux user 對應一組允許的 role 與 level 範圍，多個 Linux 帳號可共用同一個 | 與 Linux 帳號不同層；靠 `semanage login` 對應 |
| **`unconfined_u` / `user_u` / `staff_u` / `sysadm_u`** | 不受限 / 最受限的一般使用者 / 可提權的員工 / 直接就是管理員 | 依「被盜帳號能做多少事」由寬到嚴；`user_u` 連 su / sudo 都拒 |
| **role / `sysadm_r`** | role 是一組可用 domain；`sysadm_r` 是能進 `sysadm_t`（真正管理員 domain）的 role | `staff_u` 平常在 `staff_r`，要 sudo 切 role 才進 `sysadm_r` |
| **`semanage login`** | 維護「Linux 帳號 → SELinux user（+ level 範圍）」對應表（存於 `seusers`） | 改的是登入時決定的第一欄；`__default__` 代表沒被明列的所有人 |
| **`semanage user`** | 維護「SELinux user → 可用 role + level 範圍」 | 通常只用 `-l` 查，不改 |
| **sudoers `TYPE=` / `ROLE=`** | sudo 執行時指定要轉到的 domain 與 role | 沒寫的話 sudo 之後仍是 `staff_t`，沒有管理權 |
| **`ssh_sysadm_login`** | 是否允許 `sysadm_r` 直接透過 SSH 登入的 boolean | 預設關：管理員必須先以 staff 身分登入再提權，留下稽核軌跡 |
| **`user_exec_content` 等 boolean** | 控制 confined 使用者能否執行家目錄裡的程式 | 對抗「下載後直接執行」的常見入侵路徑 |
| **MLS（Multi-Level Security）/ sensitivity** | 依機密等級（s0 < s1 < …）垂直分級的模型：低不能讀高、高不能寫低 | 需要 `selinux-policy-mls` 整套政策，且多數服務不支援 |
| **MCS（Multi-Category Security）/ category** | 只用類別（c0…c1023）做水平隔離，類別之間沒有高低 | targeted 內建，給容器 / VM（§7）與 alice 那種 level 範圍用 |
| **level 範圍 `s0-s0:c0.c1023`** | 「最低 level - 最高 level」；`c0.c1023` 表示全部類別 | 管理員要有全部類別才能管所有容器 / VM |
| **CIS / STIG** | 兩套常見的伺服器合規基準；STIG 明文要求 confined users | 「為什麼要做這一節」的外部驅動力 |

**為什麼**：targeted 政策預設所有登入使用者都是 `unconfined_u`，SELinux 對「人」幾乎不設限；高安全環境（多租戶跳板機、需要 CIS/STIG 合規）會把使用者對應到受限的 SELinux user，例如 `user_u`（不能 su/sudo、不能執行家目錄的程式）或 `staff_u`（可 sudo 到 `sysadm_r`），限制被盜帳號能做的事。MLS（多層級安全）是軍方等級的機密分級，一般企業不會用；MCS 則是 targeted 內建、給容器 / VM 用的類別隔離（§7）。

**怎麼做**：

```bash
sudo semanage login -l                                     # 登入 → SELinux user 對應（預設 __default__ → unconfined_u）
sudo semanage user -l                                      # SELinux user → 可用 role
sudo semanage login -a -s user_u bob                       # bob 變成 confined 使用者（下次登入生效）
sudo semanage login -a -s staff_u -r "s0-s0:c0.c1023" alice
sudo semanage login -m -s unconfined_u __default__         # 改預設
# staff_u 要當管理員：sudo 後切換 role
sudoedit /etc/sudoers.d/alice   # alice ALL=(ALL) TYPE=sysadm_t ROLE=sysadm_r ALL
sudo setsebool -P ssh_sysadm_login 1                       # 允許 sysadm_r 直接 SSH（預設關）
# 相關 boolean：user_exec_content（使用者能否執行家目錄程式）、staff_exec_content、xguest_*
# MLS 政策（selinux-policy-mls）需重灌 / 全盤重標，且大量服務不支援；除非合規強制，不要用
```

**注意**：改 `__default__` 前先確認自己的帳號已明確對應到 `unconfined_u` 或 `staff_u`，否則下次登入會被關進 `user_u` 而無法 sudo。

---

## 9. 檔案標籤的進階操作

**名詞與關係**：這一節所有名詞都在回答同一個問題——「一個檔案的標籤是由誰、在什麼時候決定的」：

```
檔案標籤（inode 的 xattr security.selinux）從哪來？
 ① 建檔當下：type_transition（建檔 domain + 父目錄 type → 新檔 type；模組裡用 filetrans_pattern() 寫）；沒規則就繼承父目錄的 type
 ② 事後重標：restorecon / fixfiles / autorelabel 依 file_contexts（+ .local、-e 路徑等價）覆寫 ①
 ③ 手動：chcon 直接寫 xattr → 下次 ② 就被抹掉
 ④ 檔案系統不支援 xattr（NFS v3、CIFS、vfat）：mount -o context= 給整個掛載點同一個標籤；
    defcontext= 只給「沒標籤的檔」；fscontext= 給檔案系統物件本身；NFS 4.2 + security_label 才能傳遞真實 xattr
 完全沒標籤 → unlabeled_t；有標籤但 file_contexts 沒定義該路徑 → default_t
 搬移：cp 走 ①（新 inode）→ 拿目的目錄的標籤；mv 保留 inode → 帶著舊標籤走
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **xattr `security.selinux`** | 檔案標籤實際存放的擴充屬性 | 需要檔案系統支援 xattr（ext4 / xfs / btrfs 都支援）；不支援的走 ④ |
| **`default_t` / `unlabeled_t`** | 「file_contexts 沒定義這條路徑」/「檔案根本沒 xattr」的兩個佔位 type | 沒有任何服務 domain 能讀它們；看到就是標籤問題 |
| **路徑等價 `semanage fcontext -e A B`** | 宣告「B 底下的標籤規則與 A 相同」，一條規則覆蓋整棵樹 | 比逐一 `fcontext -a` 乾淨；搬 `/home`、`/var/www` 到別的磁碟時用 |
| **`context=` / `defcontext=` / `fscontext=`** | 掛載選項：整個掛載點統一標籤 / 只給沒標籤的檔 / 給檔案系統本身（superblock） | 三者都寫在 fstab；`context=` 最常用，會讓該掛載點的 xattr 被忽略 |
| **NFS 4.2 `security_label` / `httpd_use_nfs`** | NFS 4.2 能把伺服器端的 xattr 傳給客戶端的選項 / 讓 httpd 讀 `nfs_t` 的 boolean | 前者讓 NFS 上的檔案有真正的標籤，後者是不傳標籤時的替代方案 |
| **`restorecon -n` / `fixfiles`** | dry run 只列出會改什麼 / 整批重標與檢查的包裝工具（`-F onboot` 排程開機重標） | 都依 file_contexts；`fixfiles -F onboot` 等同 `touch /.autorelabel` |
| **`semanage fcontext -l -C` / `semanage export` / `import`** | 只列本機新增的規則 / 匯出所有本機修改成可重放的指令 / 在另一台重放 | 把「本機修改層」變成文字，進 git 或 Ansible |
| **`type_transition` / `filetrans_pattern()`** | 決定新檔預設標籤的規則 / 在模組裡寫這種規則的 refpolicy 巨集 | 就是 ①；`sesearch -T` 查得到 |
| **`chcon`** | 直接改 xattr 的指令 | 就是 ③；只當暫時測試用 |
| **`cp` / `mv` / `cp --preserve=context`** | 建新 inode / 搬同一個 inode / 建新 inode 但複製 xattr | 「mv 家目錄檔案到 /var/www 仍是 `user_home_t`」是最經典的 AVC 來源 |

**為什麼**：`restorecon` 只認得 `file_contexts` 裡的 regex；新掛載點、NFS / CIFS、tmpfs、bind mount、搬移過的目錄，都可能出現「政策沒定義」（`default_t`）或「沒有標籤」（`unlabeled_t`）的情況。知道每種來源怎麼決定標籤，才不會反射性地 `chcon -R`。

**怎麼做**：

```bash
# 路徑等價：把 /srv/www 當成 /var/www 來標（比逐一 fcontext -a 乾淨）
sudo semanage fcontext -a -e /var/www /srv/www && sudo restorecon -Rv /srv/www
# 搬家目錄到 /data/home
sudo semanage fcontext -a -e /home /data/home && sudo restorecon -Rv /data/home
# 掛載時指定整個檔案系統的標籤（NFS / CIFS / vfat 等不支援 xattr 的來源）
sudo mount -o context="system_u:object_r:httpd_sys_content_t:s0" nas:/export/www /var/www
#   fstab：nas:/export/www /var/www nfs defaults,context=system_u:object_r:httpd_sys_content_t:s0 0 0
#   NFS 4.2 可傳遞標籤：mount -o vers=4.2,security_label；或直接開 boolean httpd_use_nfs
# 只在檔案沒標籤時才套用（不覆蓋既有）：defcontext=；fscontext= 給檔案系統本身
# 檢查與批次修正
sudo restorecon -Rvn /var                                  # -n 只列出會改什麼（dry run）
sudo fixfiles -F onboot; sudo fixfiles check /etc           # 全盤重標排程 / 檢查
sudo find / -context "*:unlabeled_t:*" -xdev 2>/dev/null | head   # 找無標籤檔（通常是 SELinux disabled 時建立的）
sudo semanage fcontext -l -C                               # 只列本機新增的規則（實測 -C）
sudo semanage export > selinux-local.txt                   # 匯出所有本機修改（fcontext/port/boolean/login）→ 進 git / Ansible
sudo semanage import -f selinux-local.txt                  # 另一台套用
# 檔案建立時的自動標籤：由 type_transition 決定（sesearch -T）；覆寫：
sudo semanage fcontext -a -t httpd_log_t "/var/log/myapp(/.*)?"    # 或在模組用 filetrans_pattern()
```

**注意**：`chcon` 改的標籤存在 inode 上，`restorecon` / `fixfiles` / 全盤重標會抹掉；`cp` 預設給**目的目錄**的預設標籤（安全），`mv` 則**保留原標籤**（搬 `~/index.html` 到 `/var/www/html` 後仍是 `user_home_t`——最經典的 AVC 來源）；`cp --preserve=context` / `-a` 才會保留。

---

## 10. 效能、稽核與運維

**名詞與關係**：運維上把 SELinux 拆成效能、稽核、變更管理、開機參數四條線，各自對應的名詞如下：

```
效能：系統呼叫 ─▶ AVC 快取（/sys/fs/selinux/avc/cache_stats：lookups / hits / misses）─miss─▶ 查 policy.35 ─▶ 寫回快取；avcstat 每秒讀這個檔
稽核：AVC ─▶ auditd ─▶ ausearch（撈）─▶ aureport -a（統計）─▶ node_exporter textfile collector（AVC 計數）／--collector.selinux（enforcing 狀態）
變更：semanage export、semodule -lfull、semanage * -l -C ─▶ git ─▶ Ansible（ansible.posix.selinux / seboolean、community.general.sefcontext / seport / selogin）
開機參數：enforcing=0（暫時 permissive）、selinux=0（真關）、autorelabel=1（= /.autorelabel）
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **AVC 快取 / `cache_stats`** | 核心把「domain–type–class → 允許的 permission」查詢結果快取起來；`/sys/fs/selinux/avc/cache_stats` 是它的計數器 | 命中率 > 99% 是「開銷 < 2%」的來源；miss 多才需要關心 |
| **`avcstat`** | `libselinux-utils` 的工具，每秒印一次 cache_stats 的差值 | 「SELinux 拖慢系統」的量測依據（§11） |
| **`aureport`** | auditd 的報表工具：`-a` 只算 AVC，`--summary` 依 domain / type 彙總 | 讀的是 ausearch 同一份 audit.log |
| **node_exporter `--collector.selinux` / textfile collector** | 前者暴露 enabled / enforcing 指標；後者讓你用 cron + ausearch 寫 AVC 計數給 Prometheus | 「AVC 異常增加」的告警就靠 textfile |
| **`semanage export`** | 把本機所有 fcontext / port / boolean / login 修改匯成一份可重放的文字 | 每次變更後 commit；`semanage import` 在別台重放 |
| **`semodule -lfull` / `semanage … -l -C`** | 列出模組與優先權 / 只列偏離發行版預設的設定 | 兩者合起來就是「這台機器的 SELinux 差異清單」 |
| **`dnf history` / `selinux-policy` 升級** | 政策套件升級會重建 policy.35；自訂模組（400）保留但可能與新版規則衝突 | 升級後看 `journalctl -t setroubleshoot -b` 有沒有新 AVC |
| **`/.autorelabel` / `fixfiles -F onboot`** | 全盤重標的兩種觸發方式（效果相同） | 大磁碟要數小時，排在維護窗口；能用 `restorecon -R` 指定目錄就不要全盤 |
| **開機參數 `enforcing=0` / `selinux=0` / `autorelabel=1`** | 在 GRUB 核心命令列暫時 permissive / 真正關閉 / 觸發重標 | 只影響這次開機，比改 config 安全；`selinux=0` 是 Fedora 37+ 唯一真關法 |
| **Ansible `ansible.posix.selinux` / `seboolean` / `community.general.sefcontext` / `seport` / `selogin`** | 分別對應 config 模式 / setsebool / semanage fcontext / semanage port / semanage login 的模組 | 讓本機修改層可重複佈署；自訂模組則用 copy + `semodule -i` |

**為什麼**：SELinux 的核心開銷通常 < 2%（AVC 快取命中率極高），真正的成本是「不理解時的除錯時間」與「全盤重標的停機時間」。運維上要把它當成和防火牆一樣的基礎設施：規則進版控、變更走流程、監控 AVC 異常增加（可能是攻擊或部署錯誤）。

**怎麼做**：

```bash
# 效能觀察
cat /sys/fs/selinux/avc/cache_stats                        # lookups / hits / misses；miss 比例高才需關心
sudo avcstat 1                                             # 每秒統計（libselinux-utils）
# 稽核：把 AVC 當安全事件
sudo ausearch -m avc -ts today | aureport -a                # 每日 AVC 報表
sudo aureport -a --summary -ts this-week
# Prometheus：node_exporter --collector.selinux（enabled/enforcing 指標）；AVC 計數可用 textfile + ausearch
# 變更管理
sudo semanage export > /etc/selinux/local-$(date +%F).txt   # 每次改完匯出並 commit（見 11 章備份 /etc）
sudo semodule -lfull | awk '$1==400'                        # 自訂模組清單
sudo semanage boolean -l -C; sudo semanage port -l -C; sudo semanage fcontext -l -C   # 本機所有偏離預設的設定
# 升級後
sudo dnf history info last | grep selinux-policy           # 政策升級會重建 policy；自訂模組保留但可能需要調整
sudo journalctl -t setroubleshoot -b | head                 # 新版政策造成的新 AVC
# 重標策略：大磁碟避免 /.autorelabel（可能數小時）；改用 restorecon -R 指定目錄，或 fixfiles -F onboot 排在維護窗口
# 開機參數
#   enforcing=0          暫時 permissive（救援用；比改 config 安全，重開即恢復）
#   selinux=0            完全關閉（Fedora 37+ 唯一的「真關閉」方式；之後回來要重標）
#   autorelabel=1        等同 /.autorelabel
```

Ansible 對應模組：`ansible.posix.selinux`（模式）、`ansible.posix.seboolean`、`community.general.sefcontext`、`community.general.seport`、`community.general.selogin`、`community.general.sefcontext` + `ansible.builtin.command: restorecon`；自訂模組用 `ansible.builtin.copy` 送 `.cil` 後 `semodule -i`。

---

## 11. 常見誤解與正確做法

**名詞與關係**：下表名詞多已在前面定義，只補三個：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **`setenforce 0/1`** | 執行期切換 permissive / enforcing 的指令，不寫入 `/etc/selinux/config` | 重開機後回到 config 的設定；「解決問題後放著」的陷阱來自它不持久 |
| **`httpd_enable_homedirs`** | 讓 `httpd_t` 讀使用者家目錄（`user_home_t` 等）的 boolean | 與 `-e` 路徑等價、搬到 `/srv` 是同一問題的三種解法 |
| **`--privileged`** | Podman / Docker 旗標：關掉 SELinux 標籤、capability、seccomp、裝置等全部隔離 | 比 `label=disable` 更寬；正解是 `:Z` / `:z` 或 udica（§7） |

| 誤解 / 錯誤做法 | 為什麼錯 | 正確做法 |
|---|---|---|
| `setenforce 0` 解決問題後就放著 | 等於沒有 SELinux；重開機後又回 enforcing 再壞一次 | 用 `semanage permissive -a <domain>` 限縮到單一服務，並排程修正 |
| `SELINUX=disabled` | 之後檔案不打標，回 enforcing 要全盤重標；Fedora 37+ 也不再是真關閉 | 最多 `permissive`；真要關用核心參數 `selinux=0` |
| `chcon -R` 修標籤 | 下次 `restorecon` / 重標就消失 | `semanage fcontext -a` + `restorecon` |
| `audit2allow -M x && semodule -i x.pp` 全裝 | 可能放行攻擊、開過大權限 | 先 `restorecon` → boolean → 再審查後最小化的模組 |
| 把資料放 `/home/x` 給 nginx 讀並 `chmod 777` | 標籤是 `user_home_t`，DAC 開再大也沒用 | 放 `/srv` / `/var/www` 或用 `-e` 路徑等價；或開 `httpd_enable_homedirs` |
| 容器 volume 用 `--privileged` | 關掉全部隔離 | `:Z` / `:z`、udica 專屬 domain |
| 在 permissive 測完就上線 | permissive 只記錄，enforcing 才會擋；某些 AVC 在 permissive 下不會出現（第一次拒絕後的後續動作） | 上線前在 enforcing 完整測試；用 `semodule -DB` 看 dontaudit |
| 「SELinux 拖慢系統」 | AVC 快取命中率 > 99%，開銷通常 < 2% | 用 `avcstat` 量測後再說 |

---

## 12. 本章差異總結

**名詞與關係**：對照表左欄的 AppArmor 工具與 SELinux 工具是一一對應的關係：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **AppArmor profile / enforce / complain** | 以「程式路徑」為單位的規則檔（`/etc/apparmor.d/`）；enforce 擋、complain 只記錄 | 對應 SELinux 的 domain 與 enforcing / permissive domain |
| **`aa-status`** | 列出已載入的 profile 與各自的模式 | 對應 `sestatus` + `semodule -l` |
| **`aa-logprof`** | 讀 `DENIED` 紀錄，逐條互動式問你要不要加進既有 profile | 對應 `sealert` + `audit2allow` |
| **`aa-genprof`** | 互動式為新程式從零產生 profile | 對應 `sepolicy generate`，但直接以 complain 模式跑、不需編譯 |
| **`docker-default`** | Docker / Podman 在 Ubuntu 上給每個容器套的預設 AppArmor profile | 對應 `container_t`，但沒有 MCS 類別，容器之間不互相隔離 |
| **refpolicy / setools / setroubleshoot / udica 的上游** | 分別由 Tresys → 社群、Tresys、Red Hat、Red Hat 維護，都先進 Fedora 再進 RHEL | 「Fedora 是 SELinux 的上游實驗場」指的就是這條路徑 |

SELinux 是 Red Hat 主導的技術（NSA 原創、Red Hat 自 RHEL 4 起維護 refpolicy 與工具鏈），Fedora 是它的上游實驗場：政策、setools、setroubleshoot、udica 都在 Fedora 先出現。Ubuntu 選擇 AppArmor（Novell / SUSE → Canonical 維護）是因為它以路徑為基礎、不需重標、學習曲線低；兩者都是 LSM 框架下的 MAC，但**不能同時啟用**。

| 項目 | 🟠 Ubuntu 24.04 | 🔵 Fedora 44 |
|---|---|---|
| 預設 MAC | AppArmor（enforce） | SELinux targeted（enforcing） |
| 可否換用對方 | 可裝 SELinux（`selinux-basics`、`selinux-policy-default` 2.20240202，Debian refpolicy），不建議 | 可裝 AppArmor（`dnf install apparmor`），需關 SELinux，不建議 |
| 模型 | 路徑 profile | 標籤 type enforcement |
| 除錯工具 | `aa-status`、`aa-logprof`、`journalctl -k -g apparmor` | `sealert`、`ausearch -m avc`、`audit2why`、`sesearch` / `seinfo` |
| 產生新政策 | `aa-genprof`（互動） | `sepolicy generate`（骨架 + permissive 迭代） |
| 政策語言 | AppArmor profile（路徑 + 權限字母） | `.te` refpolicy 巨集、CIL |
| 容器整合 | Docker/Podman 預設 `docker-default` profile | `container_t` + MCS、udica |
| 使用者限制 | 無（profile 綁程式） | confined users（`user_u` / `staff_u`） |
| 搬移檔案 | 路徑變了 profile 就不適用 | 標籤跟著檔案，需 `restorecon` |
| 網路埠控制 | 無 | port type（`semanage port`） |
| 全盤重標 | 不需要 | `/.autorelabel`（disabled → enforcing 時） |
| 合規（CIS/STIG） | AppArmor enforce 即可 | 要求 enforcing + targeted，STIG 另要求 confined users |
