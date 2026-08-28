# 附錄 A - 手冊常用指令與 Shell 寫法說明

本手冊的指令範例大量使用 `sudo tee`、heredoc（`<<'EOF'`）、`2>&1`、`|| true`、`$( )` 等寫法。本附錄逐一說明它們的意義、為什麼要這樣寫、以及常見誤用。範例皆於 Ubuntu 24.04 / Fedora 44 實測，兩者行為相同。

---

## 1. `tee`：把輸入同時寫到檔案**和**螢幕

`tee` 讀取標準輸入（stdin），**原樣輸出到標準輸出（stdout），同時寫入一個或多個檔案**。名稱來自水管的 T 型接頭。

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

**因為重新導向（`>`、`>>`）是由目前的 shell 執行，不是由 `sudo` 執行的指令執行。**

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

### 1.2 `sudo tee` + heredoc：一次寫入多行設定檔（手冊最常見的組合）

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

| 寫法 | 變數 / 指令替換 | 用途 |
|---|---|---|
| `<<'EOF'`（有引號） | **不展開**：`$HOME`、`$(date)`、`` ` `` 原樣寫入 | 寫設定檔、腳本、含 `$` 的內容（**手冊預設用法**） |
| `<<EOF`（無引號） | **展開**：`$HOME` 變成 `/root` | 需要把變數值帶進檔案時（01 章 Docker repo 範例的 `$(. /etc/os-release && echo "$VERSION_CODENAME")` 即是） |
| `<<-EOF` | 去掉每行開頭的 **Tab**（不含空白） | 讓腳本內縮排好看 |

⚠️ 用 `<<EOF`（無引號）寫 systemd unit 時，`$MAINPID`、`${PORT}` 會被 shell 展開成空字串；記得改用 `'EOF'` 或跳脫成 `\$MAINPID`。

### 1.4 tee 的其他實用場景

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

`2>&1 | tee log` 的順序重要：`cmd 2>&1 | tee` 兩種輸出都進 log；`cmd | tee 2>&1` 只有 stdout 進 log。

---

## 3. 指令替換與變數

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

---

## 5. 其他常見指令

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
