# 16 - SELinux 進階

[02 章 §7](02-初始設定.md) 與 [08 章 §5.2](08-安全強化.md) 涵蓋日常會用到的 SELinux 操作（`restorecon`、boolean、`semanage port`、`sealert`）。本章深入它的運作模型與政策語言：為什麼標籤是一切、targeted 政策怎麼組成、如何讀懂 AVC、查詢政策（`sesearch` / `seinfo`）、正確地寫自訂模組（而不是把 `audit2allow` 的輸出照單全收）、為新服務建立 confined domain、容器與 MLS/MCS、以及系統性的除錯與效能議題。

本章是 🔵 **Fedora（與 RHEL 系）專屬**；🟠 Ubuntu 預設用 AppArmor，雖可安裝 SELinux（實測 24.04 套件庫有 `selinux-basics`、`selinux-policy-default`、`policycoreutils`、`setools`）但 Debian 的 refpolicy 覆蓋率與工具整合遠不如 Fedora，正式環境不建議在 Ubuntu 上換用 SELinux——需要 SELinux 的工作負載請直接選 Fedora / RHEL 系。

驗證說明：實驗容器的核心無法啟用 SELinux（`getenforce` 為 Disabled），因此本章所有**離線**操作——政策查詢（`seinfo` / `sesearch`）、`semanage` 修改政策庫、`matchpathcon`、`audit2allow` / `audit2why`、`.te` / CIL 模組編譯與 `semodule` 安裝、`sepolicy generate`——皆於 Fedora 44（selinux-policy 44.7、setools 4.6、policycoreutils 3.11）實測；需要 enforcing 核心的行為（AVC 產生、`setenforce`、標籤轉換）依 Fedora / RHEL 官方文件撰寫並標示。範例檔在 [`scripts/examples/selinux/`](scripts/examples/selinux/)。

**本章解決什麼問題**：SELinux 是 Fedora 伺服器上「服務起不來 / 讀不到檔案 / 連不到埠」的第二大原因（第一是防火牆），而最常見的錯誤處置是 `setenforce 0` 或 `SELINUX=disabled` 一勞永逸——這等於拆掉 2014 年 Shellshock、2021 年 Log4Shell 這類「服務被打穿後試圖橫向移動」時唯一還在運作的防線。第二常見的錯誤是把 `audit2allow` 吐出的規則全部裝上去，結果政策被撐出一個大洞卻沒人知道。本章的取捨原則：**永遠先問「標籤對不對」，再問「有沒有現成 boolean」，最後才寫自訂模組；自訂模組要最小、有版本、進 git**。

---

## 1. 運作模型：為什麼是「標籤」

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

### 5.1 為什麼不能直接 `audit2allow -M` 然後 `semodule -i`

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
