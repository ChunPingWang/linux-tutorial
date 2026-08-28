# 附錄 A - 手冊常用指令與 Shell 寫法說明

本手冊的指令範例大量使用 `sudo tee`、heredoc（`<<'EOF'`）、`2>&1`、`|| true`、`$( )` 等寫法。本附錄逐一說明它們的意義、為什麼要這樣寫、以及常見誤用。範例皆於 Ubuntu 24.04 / Fedora 44 實測，兩者行為相同。

**本附錄解決什麼問題**：手冊裡的指令看起來像是「照抄就好」，但這些寫法各自繞過了一個真實的陷阱——`sudo` 提升不到重新導向、heredoc 引號沒加導致 `$MAINPID` 被吃掉、`set -e` 下一個無關緊要的失敗讓整支腳本中止。不懂原理時，換個路徑或搬進腳本就會出錯，而且錯誤訊息往往不指向真正的原因。本附錄的取捨是：只講手冊實際用到的寫法，每一項都先說明「不這樣寫會遇到什麼問題」，再給可直接照用的形式。

---

## 1. `tee`：把輸入同時寫到檔案**和**螢幕

**為什麼**：管線裡的輸出只能往一個方向走——不是進檔案就是上螢幕。跑長時間的升級或建置時，既想即時盯著進度，又要留下完整紀錄以便事後查錯，單靠 `>` 只能二選一。`tee` 就是為了把同一份資料流分岔給兩個去處而存在。

**怎麼做**：`tee` 讀取標準輸入（stdin），**原樣輸出到標準輸出（stdout），同時寫入一個或多個檔案**。名稱來自水管的 T 型接頭。

```bash
echo hello | tee /tmp/t1.txt          # 螢幕顯示 hello，且 /tmp/t1.txt 內容為 hello（覆蓋）
echo again | tee -a /tmp/t1.txt       # -a（append）附加而非覆蓋
echo x | tee a.txt b.txt              # 同時寫多個檔
some_command 2>&1 | tee build.log     # 邊看輸出邊存 log（最常見的日常用途）
echo hello | tee /tmp/t1.txt >/dev/null   # 不想在螢幕看到：把 tee 的 stdout 丟掉
```

常用選項：

| 選項 | 意義 |
|---|---|
| `-a` / `--append` | 附加到檔尾 |
| `-i` | 忽略 Ctrl-C（讓前面的指令先收到中斷） |
| `-p` / `--output-error=warn` | 寫入失敗時繼續（例如管線另一端已關閉） |

### 1.1 為什麼手冊到處用 `sudo tee` 而不是 `sudo echo ... > 檔案`？

**為什麼**：**因為重新導向（`>`、`>>`）是由目前的 shell 執行，不是由 `sudo` 執行的指令執行。** `sudo echo "x" > /etc/file` 看起來合理，卻永遠得到 `Permission denied`，而且錯誤訊息來自 bash 而非 sudo，初學者常以為是 sudo 設定有問題。

**怎麼做**：讓「開啟檔案的那個程式」以 root 執行——也就是把寫檔的動作交給 `sudo tee`，或者讓整個 shell 以 root 跑：

```bash
# ✗ 錯誤：實測輸出 "-bash: /etc/tee-test.conf: Permission denied"
sudo echo "x" > /etc/tee-test.conf
#   → sudo 只提升了 echo 的權限；「> /etc/tee-test.conf」是一般使用者的 shell 在開檔，所以沒權限。

# ✓ 正確：檔案由 tee 開啟，而 tee 是以 root 執行的
echo "x" | sudo tee /etc/tee-test.conf
echo "x" | sudo tee -a /etc/tee-test.conf      # 附加
echo "x" | sudo tee /etc/tee-test.conf >/dev/null   # 不要回顯

# 其他等價寫法
sudo sh -c 'echo "x" > /etc/tee-test.conf'    # 讓 root 的 shell 做重新導向
sudo bash -c 'cat > /etc/file' <<'EOF'
...
EOF
sudo install -m 644 /dev/stdin /etc/file <<'EOF'   # 順便設權限
...
EOF
```

**注意**：手冊選 `sudo tee` 而非 `sudo sh -c '...'`，是因為前者不必把整段內容塞進單引號字串裡再處理跳脫，配合 heredoc 可以原樣貼上多行設定（見 §1.2）。

### 1.2 `sudo tee` + heredoc：一次寫入多行設定檔（手冊最常見的組合）

**為什麼**：設定檔通常不只一行，用多個 `echo ... | sudo tee -a` 逐行附加既冗長又容易重複執行時疊加內容；用編輯器又無法寫進可複製貼上的手冊。heredoc 讓你把整段檔案內容原樣放在指令裡，一次寫入、可重複執行、結果可預期。

**怎麼做**：

```bash
sudo tee /etc/ssh/sshd_config.d/10-hardening.conf <<'EOF'
PermitRootLogin no
PasswordAuthentication no
EOF
```

拆解：
1. `<<'EOF'` 開啟一段 **heredoc**：從下一行開始、直到單獨一行 `EOF` 為止的文字，成為指令的標準輸入。
2. 這段文字經由管線給 `sudo tee /etc/...`，tee 以 root 身分把它寫進檔案，並回顯在螢幕（可加 `>/dev/null` 關掉）。
3. `EOF` 只是慣用的結束標記，可以換成任何字（手冊有時用 `MANUAL_EOF`、`PY`）；結尾標記**必須頂格、獨立一行、後面不能有空白**。

### 1.3 `'EOF'` 與 `EOF` 的差別（加不加引號）

**為什麼**：heredoc 預設會像雙引號字串一樣做變數與指令替換。寫設定檔或腳本時內容常含 `$`（systemd 的 `$MAINPID`、腳本裡的 `$1`、cron 的 `%`），不加引號就會在寫入當下被目前的 shell 展開成空字串，檔案看起來正常，服務卻莫名失敗。這是手冊預設用 `<<'EOF'` 的原因；只有真的要把變數值帶進檔案時才用無引號版本。

**怎麼做**：依內容決定引號：

| 寫法 | 變數 / 指令替換 | 用途 |
|---|---|---|
| `<<'EOF'`（有引號） | **不展開**：`$HOME`、`$(date)`、`` ` `` 原樣寫入 | 寫設定檔、腳本、含 `$` 的內容（**手冊預設用法**） |
| `<<EOF`（無引號） | **展開**：`$HOME` 變成 `/root` | 需要把變數值帶進檔案時（01 章 Docker repo 範例的 `$(. /etc/os-release && echo "$VERSION_CODENAME")` 即是） |
| `<<-EOF` | 去掉每行開頭的 **Tab**（不含空白） | 讓腳本內縮排好看 |

⚠️ 用 `<<EOF`（無引號）寫 systemd unit 時，`$MAINPID`、`${PORT}` 會被 shell 展開成空字串；記得改用 `'EOF'` 或跳脫成 `\$MAINPID`。

### 1.4 tee 的其他實用場景

**為什麼**：`tee` 不只用來寫設定檔。`/proc`、`/sys` 底下的核心參數「檔案」只有 root 能寫，同樣受 §1.1 的重新導向限制；而腳本若要同時把 stdout / stderr 留在終端又寫進日誌，也需要 `tee` 做分流。下面是手冊各章實際出現過的幾種用法。

**怎麼做**：

```bash
# 同時看與存長時間工作的輸出（配 tmux）
sudo apt full-upgrade -y 2>&1 | tee ~/upgrade-$(date +%F).log
# 把指令輸出送到多個處理程序（process substitution）
cat access.log | tee >(grep " 500 " > errors.txt) >(wc -l > count.txt) >/dev/null
# 寫入 /proc /sys 的核心參數（這些「檔案」只能 root 寫）
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
echo 3 | sudo tee /proc/sys/vm/drop_caches
# 在 script 中同時記錄 stdout/stderr 到日誌
exec > >(tee -a /var/log/myscript.log) 2>&1
```

---

## 2. 重新導向與管線

**為什麼**：每個程式有兩條輸出——stdout（正常結果）與 stderr（錯誤訊息）——預設都印在螢幕，看起來一樣，但管線與 `>` 只接 stdout。這造成兩個常見問題：存下來的日誌缺了錯誤訊息，或者 `grep` 過濾不到 stderr 裡的警告。手冊裡的 `2>&1`、`2>/dev/null` 都是在明確指定「錯誤訊息要去哪」。

**怎麼做**：

```bash
cmd > file          # stdout 覆蓋寫入 file
cmd >> file         # 附加
cmd 2> file         # stderr 寫入 file
cmd 2>&1            # stderr 併入 stdout（順序：先決定 stdout 去哪，再把 2 指向 1）
cmd > file 2>&1     # 兩者都進 file（常見）；cmd &> file 是 bash 簡寫
cmd 2>/dev/null     # 丟掉錯誤訊息（手冊用於「有沒有都沒關係」的查詢）
cmd < file          # 以 file 當 stdin
cmd1 | cmd2         # 管線：cmd1 的 stdout 接 cmd2 的 stdin
cmd1 |& cmd2        # 連 stderr 一起接（bash 4+）
```

**注意**：`2>&1 | tee log` 的順序重要：`cmd 2>&1 | tee` 兩種輸出都進 log；`cmd | tee 2>&1` 只有 stdout 進 log。重新導向是由左到右依序生效的，`2>&1` 寫在管線之後時，stderr 早已經過了分岔點。

---

## 3. 指令替換與變數

**為什麼**：手冊需要在兩個發行版、多個版本上通用，所以不能把 `noble`、`44` 這類值寫死，而是在執行當下用 `$(...)` 從系統取得（`rpm -E %fedora`、`/etc/os-release`）。變數若不加雙引號，含空白或 `*` 的值會被 shell 拆成多個參數或展開成檔名，這類錯誤只在特定輸入下出現，最難重現。

**怎麼做**：

```bash
$(cmd)                          # 指令輸出當字串（舊寫法 `cmd`，避免使用，不可巢狀）
KEY=$(cat /root/.restic-pw)
rpm -E %fedora                  # → 44；手冊用 $(rpm -E %fedora) 組 RPM Fusion 網址
$(. /etc/os-release && echo "$VERSION_CODENAME")   # 在子 shell 讀取 os-release 取得 noble
"${VAR}"                        # 一律加雙引號，避免空白與萬用字元展開
"${VAR:-default}"               # 未設定時用預設值；"${VAR:?訊息}" 未設定就報錯結束（bootstrap.sh 用法）
. /etc/os-release               # 讀入檔案中的 KEY=VALUE 成為變數（等同 source）；之後可用 $ID、$VERSION_ID
```

---

## 4. 條件與錯誤處理慣用語

**為什麼**：手冊的腳本多以 `set -euo pipefail` 開頭，好處是任何一步失敗就立刻停止，不會帶著壞狀態繼續跑；代價是「本來就允許失敗」的步驟（例如 🟠/🔵 擇一的服務名稱、刪除可能不存在的檔案）會把整支腳本殺掉。`|| true`、`cmd1 || cmd2`、`command -v` 這些慣用語就是在嚴格模式下，把「預期中的失敗」明確標示出來，讓真正的錯誤仍會中止。

**怎麼做**：

```bash
cmd || true                     # cmd 失敗也不讓整個腳本（set -e 環境）中止
cmd && echo ok                  # 成功才執行後面
cmd1 || cmd2                    # cmd1 失敗才執行 cmd2（🟠/🔵 擇一：systemctl restart ssh || systemctl restart sshd）
[ -f /var/run/reboot-required ] && echo "需要重開機"     # [ ] 是 test 指令；-f 檔案存在、-d 目錄存在、-b 區塊裝置、-n 字串非空
[[ $EUID -eq 0 ]] || { echo "請以 root 執行" >&2; exit 1; }   # bash 的 [[ ]] 較安全；>&2 把訊息送到 stderr
command -v restic >/dev/null 2>&1 && echo "有裝"          # 檢查指令是否存在（比 which 可靠）
set -euo pipefail               # 腳本開頭：e 任一指令失敗就結束、u 未定義變數報錯、pipefail 管線中任一失敗即失敗
trap cleanup EXIT               # 結束（含錯誤）時執行 cleanup 函式（實驗腳本用來卸載 / 清 loop 裝置）
```

**注意**：`cmd && a || b` 不是 if/else——若 `a` 本身失敗也會跑到 `b`。需要真正的分支時請用 `if ... then ... else ... fi`。

---

## 5. 其他常見指令

**為什麼**：這些指令的共同點是「一步做完、可重複執行」。例如 `mkdir` + `chmod` + `chown` 三步中途失敗會留下權限錯誤的目錄；`echo >> file` 每跑一次就多一行，`grep -qxF ... ||` 才能保證只加一次；`echo` 遇到 `-n`、`-e` 開頭的內容會誤判為選項，`printf` 沒有這個問題。手冊的 bootstrap 與實驗腳本要能反覆執行而不累積副作用，靠的就是這些寫法。

**怎麼做**：

```bash
install -d -m 700 -o alice -g alice /home/alice/.ssh   # 建目錄並一次設好權限與擁有者（比 mkdir + chmod + chown 簡潔）
install -m 0755 -d /etc/apt/keyrings
install -m 644 src dest                                 # 複製並設權限
chmod 600 file; chown user:group file
grep -qxF "$LINE" file || echo "$LINE" >> file          # 只在該行不存在時附加（-q 安靜 -x 整行比對 -F 字面字串）
sed -i 's/^apply_updates *=.*/apply_updates = yes/' /etc/dnf/automatic.conf   # 就地取代（-i）；^ 行首、.* 到行尾
sed -i 's|^#\?Port .*|Port 2222|' file                  # 用 | 當分隔符避免跳脫 /；\? 表示 # 可有可無
awk -F: '$3 >= 1000 {print $1}' /etc/passwd             # 依欄位條件輸出（-F 分隔符）
xargs sudo dnf install -y < pkgs.txt                    # 把檔案內容當參數
printf '%s\n' "line1" "line2"                           # 比 echo 可靠（不會吃掉 -n、-e）
getent passwd alice | cut -d: -f6                       # 查家目錄（兼容 LDAP / SSSD 帳號）
systemd-run --on-active=30m cmd                         # 30 分鐘後執行（取代 at）
timeout 30 cmd                                          # 最多跑 30 秒
```

---

## 6. 快速自我測試

**為什麼**：上面的觀念裡最容易「以為懂了」的是兩件事：重新導向由誰執行（§1.1）、heredoc 引號有無（§1.3）。與其等到寫壞 `/etc` 下的設定檔才發現，不如先在實驗機上跑一遍，親眼看到 `Permission denied` 與 `$HOME` 展開與否的差別。

**怎麼做**：逐行執行並對照註解中的預期結果：

```bash
# 以下每行的預期結果（可在任一實驗機執行）
echo hello | tee /tmp/t.txt | cat            # 螢幕：hello；/tmp/t.txt：hello
echo again | tee -a /tmp/t.txt >/dev/null && cat /tmp/t.txt   # hello / again
su - alice -c 'echo x > /etc/x.conf'         # Permission denied（重新導向由 alice 執行）
su - alice -c 'echo x | sudo tee /etc/x.conf'   # 成功（需 alice 有 sudo 權限；實測會先要求密碼）
cat <<'EOF'
$HOME 不會展開
EOF
cat <<EOF
$HOME 會展開成 $HOME
EOF
```
