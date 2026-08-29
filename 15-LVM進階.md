# 15 - LVM 進階

[06 章 §3](06-檔案系統與儲存.md) 涵蓋 LVM 的日常操作（建立、線上擴充、快照）。本章深入：內部結構與 metadata、條帶化與 RAID LV、Thin Provisioning、快取、pvmove 與 VG 搬移 / 匯出、metadata 備份還原、devices file 與過濾、效能與監控、以及各種災難情境的修復。所有可在 loop 裝置上驗證的操作皆由 [`scripts/lab/lab-lvm-advanced-test.sh`](scripts/lab/lab-lvm-advanced-test.sh) 於兩個發行版實測（dm-cache 因 WSL2 核心缺模組未能實測，指令依 `lvmcache(7)` 撰寫）。

兩者 LVM 版本差異（實測）：🟠 Ubuntu 24.04 **lvm2 2.03.16（2022）**、🔵 Fedora 44 **lvm2 2.03.38（2025）**。Fedora 預設啟用 **devices file**（`/etc/lvm/devices/system.devices`），Ubuntu 24.04 未啟用且不含 `lvmdevices` 指令，這是本章最大的行為差異（§8）。

**本章解決什麼問題**：06 章的 LVM 操作足以應付日常擴充；但遇到「thin pool 半夜滿了、所有 VM 一起 I/O error」「換了 RAID 卡後開機找不到根 VG」「不小心 `lvremove` 掉正式資料庫的 LV」「硬碟搬到新機、Fedora 卻看不到 VG」這類情境時，需要的是理解 LVM 的內部結構、metadata 與 devices file 機制。本章的取捨原則：優先用 LVM 內建功能（RAID LV、thin、cache）減少疊層，但每項功能都先講清楚它的失效模式——進階功能的代價通常是「壞起來更難修」。

---

## 1. 內部結構

**名詞與關係**：06 章把 LVM 講成 PV → VG → LV 三層；本章要往下看一層——這三個物件「在磁碟上長什麼樣」（label、metadata、PE / LE 對應表），以及它們怎麼被載入核心的 device-mapper 變成真正的裝置：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **PV / VG / LV** | LVM 的三個物件：原料裝置 / 儲存池 / 從池切出的邏輯卷（06 章 §3） | 本章關心的是它們在磁碟上的實際結構與失效方式 |
| **PE（Physical Extent）** | VG 把每個 PV 切成的固定大小塊（預設 4 MiB），配置的最小單位 | `vgs` 的 free extents 指它；striped / raid 的「每個 PV 都要有空間」也是以 PE 計算 |
| **LE（Logical Extent）** | LV 內部的邏輯塊，一對一對應到某個 PV 的某個 PE | LV 本質上就是一張 LE → PE 對應表；`lvdisplay -m` 印的就是這張表 |
| **segment / segtype** | LV 內一段連續 LE 的對應方式（linear、striped、raid1、thin…） | 一個 LV 可由多段組成（例如線性一段 + 後來擴充的另一段）；`lvs -o segtype` 看每段的型別 |
| **metadata** | 存在每個 PV 開頭的文字描述：VG 內有哪些 PV、每個 LV 的每一段對應哪些 PE | 所有 LVM 指令改的都是它；`vg_seqno` 每改一次加一，§6 的備份還原也是還原它 |
| **label** | PV 最前面幾個磁區的標籤，記 PV UUID 與 metadata 區的位置 | `pvs` 靠掃描 label 找 PV；label 壞了 PV 就「不見」（§6 有重建方法） |
| **device-mapper（dm）** | 核心把「邏輯區塊 → 實體區塊」對應表變成裝置的框架 | LVM 啟用 LV = 把 LE → PE 表載入 dm；linear / mirror / raid / thin / cache / crypt 都是 dm 的目標模組，LUKS 也走同一框架 |
| **`dmsetup`** | 直接操作 device-mapper 表的工具 | LVM 指令卡住時能看到核心那一側的真相：open count、表內容、suspend 狀態 |
| **partial / refresh needed** | `lvs` 健康欄的兩種狀態：缺 PV / 底層變動後 dm 表需要重載 | 都要對照 LE → PE 表才知道缺的是哪一段；§11 的災難表由此判讀 |

**為什麼**：修復 LVM 問題時，`lvs` 的錯誤訊息（partial、refresh needed、not enough free extents）都要對照「哪個 LE 落在哪個 PV 的哪些 PE」才解讀得出來；而 device-mapper 才是真正在核心執行 I/O 的層，LVM 指令卡住或 `lvremove` 報 busy 時，`dmsetup` 能直接看到核心那一側的狀態。

**怎麼做**：先記住三層與 device-mapper 的對應關係，再用下列指令看每一層的實際佈局。

```
PV（Physical Volume）  = 一顆磁碟 / 分割區 / RAID / LUKS 裝置，前端有 LVM label + metadata 區
VG（Volume Group）     = 一個以上 PV 的儲存池，切成固定大小的 PE（Physical Extent，預設 4 MiB）
LV（Logical Volume）   = 由 LE（Logical Extent）對應到 PE 組成；segtype 決定對應方式：
                         linear / striped / mirror / raid1,5,6,10 / thin / thin-pool / cache / vdo / snapshot
device-mapper          = 核心層；每個啟用的 LV 是一個 dm 裝置 /dev/dm-N，別名 /dev/mapper/VG-LV 與 /dev/VG/LV
```

```bash
sudo pvs -o +pv_uuid,pe_start,pv_mda_count,pv_mda_free     # PV metadata 區
sudo vgs -o +vg_extent_size,vg_extent_count,vg_free_count,vg_mda_count,vg_seqno,vg_tags
sudo lvs -a -o +segtype,stripes,stripe_size,devices,seg_pe_ranges   # 每個 LV 的實體佈局（-a 顯示隱藏的內部 LV）
sudo lvdisplay -m /dev/vg0/lv_data                                  # 逐段對應
sudo dmsetup ls --tree; sudo dmsetup table vg0-lv_data              # device-mapper 表
sudo dmsetup info -c
sudo lvm fullreport vg0 | head -40                                  # 一次全部
sudo lvmconfig --type full | less                                   # 目前生效的完整設定（含預設）
```

**注意**：`lvs` 的 `Attr` 欄位用十個字元濃縮了卷的類型與健康狀態，第 5 位不是 `a`、或第 9 位出現 `p` / `r`，就代表需要處理；§11 的災難表大多從這裡判讀。實測範例 `twi-aotz--`、`Vwi-a-tz--`、`rwi-a-r---`：

| 位置 | 意義 | 常見值 |
|---|---|---|
| 1 | 卷類型 | `-` 一般、`t` thin pool、`V` thin volume、`s` 快照、`r` raid、`m` mirror、`C` cache、`o` origin、`e` metadata、`p` pvmove |
| 2 | 權限 | `w` 讀寫、`r` 唯讀 |
| 3 | 配置策略 | `i` inherited、`c` contiguous、`a` anywhere |
| 4 | 固定 minor | `m` |
| 5 | 狀態 | `a` active、`s` suspended、`I` invalid snapshot、`d` 無 dm 表、`X` unknown |
| 6 | 裝置開啟中 | `o` open |
| 7 | 目標類型 | `t` thin、`r` raid、`m` mirror、`s` snapshot、`C` cache |
| 8 | 零化 | `z` 新區塊填零 |
| 9 | 健康 | `p` partial（缺 PV）、`r` refresh needed、`m` mismatches、`X` 未知、`w` writemostly |
| 10 | skip activation | `k`（thin snapshot 預設） |

### 1.1 PE 大小與對齊

**名詞與關係**：PE 大小決定 metadata 的規模，對齊決定 LV 起點是否落在底層硬體的邊界上，兩者都是建立 VG / PV 時一次定終身的參數：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **對齊（`pe_start`）** | PV 上第一個 PE 的起始位移（預設 1 MiB） | 決定所有 LV 的起點；應是 RAID 條帶大小或 4Kn 磁碟實體區塊的整數倍 |
| **條帶（stripe）** | RAID 卡或 striped LV 把資料切成的固定大小片段，輪流寫到各成員碟 | 起點不對齊條帶時，一次寫入跨兩個條帶就得寫兩次（讀—改—寫） |
| **4Kn** | 實體與邏輯磁區都是 4 KiB 的新式磁碟（相對於對外模擬 512 位元組的 512e） | 對齊 1 MiB 已能滿足；只有 RAID 卡的大條帶才需要手動指定 `--dataalignment` |
| **metadata 區（`--metadatasize` / `--metadatacopies`）** | PV 上保留給 metadata 的空間大小與份數 | LV / 快照越多 metadata 越大，預設 1 MiB 可能不夠；多份可提高 label 損毀時的存活率 |

**為什麼**：PE 大小建立後不能改，數十 TB 的 VG 用預設 4 MiB 會有數百萬個 extent，metadata 膨脹、每次 `lvs` 與變更都變慢。對齊則決定 LV 起點是否落在磁碟實體區塊或 RAID 條帶的邊界，錯位時每次寫入都會變成跨兩個條帶的兩次寫入。

**怎麼做**：

```bash
sudo vgcreate -s 8M vg0 /dev/sdb1               # PE 大小（預設 4M；大型 VG 用 16M~64M 減少 metadata，實測 -s 8M）
# PE 大小不影響效能，只影響 LV 最小粒度與 metadata 大小；建立後不可改（vgchange -s 只能在 PE 數量整除時）
sudo pvcreate --dataalignment 1M /dev/sdb        # 對齊（預設已對齊 1 MiB；RAID 條帶或 4Kn 磁碟可指定）
sudo pvs -o +pe_start                            # 資料起始位置（預設 1.00m）
sudo pvcreate --metadatasize 16M --metadatacopies 2 /dev/sdb   # metadata 區大小 / 份數（大量 LV / 快照時放大）
```

---

## 2. 條帶化（Striped）與 RAID LV

**名詞與關係**：LVM 的 segtype 決定一個 LV 的 LE 怎麼對應到 PE，冗餘與效能都由它決定；與 mdadm 的關係是「同一套 RAID 演算法、不同的管理粒度」：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **linear（線性）** | 預設 segtype：LE 依序對應到 PE，先填滿一個 PV 再用下一個 | 無冗餘、無並行；其他 segtype 都是它的替代 |
| **striped（條帶化）** | 把連續 LE 輪流分到 N 個 PV，等同 RAID0 | 吞吐約 ×N，任一 PV 壞就全毀；擴充需要 N 個 PV 都有空間 |
| **mirror / raid1** | 每筆資料寫到兩個以上 PV | 舊式 `mirror` segtype 已被 `raid1` 取代（後者用 md 的程式碼、每個副本有自己的 rmeta） |
| **RAID LV（raid1 / 5 / 6 / 10）** | LVM 透過核心 dm-raid 模組（借用 md 的 RAID 引擎）在單一 LV 內做冗餘 | 與 mdadm 是同一套演算法，差別在管理層：mdadm 以整顆碟為單位、RAID LV 以 LV 為單位 |
| **mdadm** | 獨立於 LVM 的軟體 RAID 工具（06 章 §5） | 兩者可疊：mdadm 的 `/dev/md0` 當 PV；也可只選其一 |
| **冗餘** | 可壞掉幾顆成員碟而不丟資料 | striped 為 0、raid1 為副本數減 1、raid5 為 1、raid6 為 2 |

**為什麼**：單一 PV 的頻寬有限。striped 把 I/O 平均分散到多顆碟以提升吞吐（但任一顆壞就全毀）；RAID LV 則在 LVM 內提供冗餘，不必再疊 mdadm 一層，還能對每個 LV 個別選等級——同一個 VG 內資料庫 LV 用 raid10、暫存 LV 用線性。

### 2.1 Striped（RAID0，只求效能）

**為什麼**：適合純暫存、可重建的資料（build cache、影片轉檔暫存）；條帶數（`-i`，資料輪流分散到幾個 PV）與條帶大小（`-I`，每輪寫到同一個 PV 的 KiB 數）在建立時就固定。最常踩的坑在擴充：striped LV 擴充時必須在「相同數量的 PV」上都有空間，VG 總量夠也會報 `not enough free extents`。

**怎麼做**：

```bash
sudo lvcreate -L 200G -i 2 -I 64 -n lv_stripe vg0            # -i 條帶數（PV 數）、-I 條帶大小 KiB（實測 -i 2 -I 64 → stripes=2, stripe_size=64k）
sudo lvs -o +stripes,stripe_size,devices vg0/lv_stripe
sudo lvextend -L +100G vg0/lv_stripe                          # 擴充時需在「相同數量的 PV」上有空間，否則報錯；可用 -i 1 加一段線性（效能降）
```

### 2.2 RAID LV（LVM 內建 md-raid，取代 mdadm + LVM 雙層）

**名詞與關係**：RAID LV 在 `lvs -a` 底下會多出一堆隱藏子 LV，維護指令都是針對這些子 LV 的狀態：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **dm-raid** | device-mapper 的 RAID 目標模組，內部呼叫 md 的 RAID 引擎 | RAID LV 的核心依賴；缺了模組 `lvcreate --type raid*` 直接失敗 |
| **`_rimage_N` / `_rmeta_N`** | RAID LV 的內部子 LV：第 N 個資料副本（image）/ 它的 RAID superblock（metadata） | `lvs -a` 才看得到；每個副本各佔一個 PV，rmeta 記錄同步狀態 |
| **`-m`（mirrors）** | 額外副本數：`-m 1` = 總共兩份 | raid1 / raid10 用；`lvconvert -m` 可線上加減副本 |
| **`-i`（stripes）** | 資料條帶數 | raid5 總顆數 = i+1、raid6 = i+2、raid10 = i × (m+1) |
| **`Cpy%Sync` / `sync_percent`** | 副本同步進度 | 建立與換碟後從 0 到 100；未到 100 前再壞一顆就丟資料 |
| **`--syncaction check / repair`** | 讀所有副本比對（check）/ 不一致時修正（repair） | 對應 mdadm 的 `sync_action`；`raid_mismatch_count` 是 check 的結果 |
| **`lvconvert --repair` / `--replace`** | 用 VG 內空閒 PV 頂替已壞的副本 / 主動把某 PV 上的副本搬到另一 PV | repair 是事後、replace 是事前；都需要 VG 有空閒 PE |
| **`writemostly`** | 標記某副本「盡量只寫不讀」 | SSD + HDD 混合鏡像時讓讀取全走 SSD |
| **dmeventd** | LVM 的 device-mapper 事件監控 daemon | 收到副本失效事件時可自動觸發 repair（§9） |

**為什麼**：資料 LV 需要冗餘、但不想整顆碟做 mdadm 時用它。線上就能把線性 LV 轉成鏡像、鏡像升到三副本、raid5 升 raid6，這是 mdadm 難以做到的彈性。SSD + HDD 混合鏡像時把 HDD 標成 `writemostly`，讀取全走 SSD，HDD 只當備援。

**怎麼做**：

```bash
sudo lvcreate --type raid1 -m 1 -L 200G -n lv_mirror vg0            # 鏡像（實測 raid1，Cpy%Sync 從 0 → 100）
sudo lvcreate --type raid5 -i 3 -L 1T -n lv_r5 vg0                  # RAID5：-i 資料條帶數（總共 i+1 顆）
sudo lvcreate --type raid6 -i 4 -L 2T -n lv_r6 vg0
sudo lvcreate --type raid10 -i 2 -m 1 -L 1T -n lv_r10 vg0           # 4 顆
sudo lvs -a -o name,segtype,sync_percent,copy_percent,raid_mismatch_count,devices vg0   # 內部 _rimage_N / _rmeta_N 子 LV
# 維護
sudo lvchange --syncaction check vg0/lv_mirror                       # 一致性檢查（排程每月）；--syncaction repair
sudo lvs -o +raid_sync_action,raid_mismatch_count vg0/lv_mirror
sudo lvconvert --repair vg0/lv_mirror                                # 壞 PV 後用 VG 內空閒 PV 重建
sudo lvconvert --replace /dev/sdc vg0/lv_mirror /dev/sde             # 主動換掉某顆
sudo lvconvert -m 2 vg0/lv_mirror                                    # 加到三副本；-m 0 拆成線性
sudo lvconvert --type raid1 -m 1 vg0/lv_linear                       # 線性 → 鏡像（線上）
sudo lvconvert --type raid6 vg0/lv_r5                                # raid5 → raid6（需多一顆 PV）
sudo lvextend -L +200G vg0/lv_r5                                     # RAID LV 擴充（保持條帶結構）
sudo lvchange --writemostly /dev/sdc vg0/lv_mirror                   # 慢碟只當備援讀（SSD+HDD 鏡像）
# 需要核心模組 dm-raid（實測 WSL2 需手動 modprobe；一般發行版核心已內建）
```

**注意**：兩者並非互斥。根目錄與整顆碟層級用 mdadm（安裝程式與救援工具支援最成熟）、資料 LV 需要細粒度時用 LVM RAID，取捨如下：

| | mdadm + LVM | LVM RAID |
|---|---|---|
| 適合 | 整顆磁碟層級 RAID、根目錄、與非 LVM 混用 | 每個 LV 自選 RAID 等級、細粒度 |
| 監控 | `mdadm --monitor`、`/proc/mdstat` | `lvs` 的 health / sync 欄位、`dmeventd` |
| 開機支援 | 成熟（initramfs 自動組） | 成熟（Fedora / Ubuntu 皆支援 raid1 根目錄） |
| 重建速度控制 | `/proc/sys/dev/raid/speed_limit_*` | `lvchange --[raid]maxrecoveryrate` |

---

## 3. Thin Provisioning（已實測）

**名詞與關係**：thin 在 VG 與 LV 之間多了一個「池」，池又分資料區與 metadata 區；快照、超額配置、自動擴充、空間回收全都是對這個池的操作：

```
VG
 └─ thin pool（tpool）＝ 隱藏的 tpool_tdata（資料區）＋ tpool_tmeta（metadata：每個 thin volume 的區塊對應表）
      ├─ thin1（虛擬 1T，只佔實際寫入的 chunk）
      │    └─ thin1_snap（thin 快照：只複製 metadata 指標，與 thin1 共用未變動的 chunk）
      └─ thin2 …
 監控：dmeventd 監聽 pool 使用率 → 依 lvm.conf 的 autoextend 設定自動 lvextend（VG 要留空間）
 回收：檔案系統 discard / fstrim → pool 把 chunk 標回空閒（passdown 再往下傳給 SSD）
```

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **thin pool** | 實際佔用 VG 空間的池，由 tdata + tmeta 兩個隱藏 LV 組成 | 所有 thin volume 與 thin 快照的區塊都從它拿 |
| **tdata / tmeta** | pool 的資料區 / metadata 區（記「thin volume 的哪個虛擬區塊 → pool 的哪個 chunk」） | metadata 滿了整個 pool 無法再配置也無法啟用，比 data 滿更難修 |
| **thin volume** | 只有虛擬大小的 LV | 寫入時才向 pool 要 chunk；`data_percent` 是它實際用了多少 |
| **chunk（`--chunksize`）** | pool 配置與快照差異追蹤的最小單位 | 越小快照越省空間但 metadata 越大；建立後不可改 |
| **thin 快照** | 複製 origin 的 metadata 指標、共用所有未改動 chunk 的新 thin volume | 與傳統 COW 快照不同：不預留大小、不拖慢 origin、可層疊、預設 skip activation（§7） |
| **超額配置** | thin volume 虛擬大小總和大於 pool | 這就是 pool 會滿的原因；VG 必須留空間給 autoextend |
| **autoextend（`thin_pool_autoextend_*`）** | lvm.conf 設定：pool 用到某百分比就自動 `lvextend` 多少 | 由 dmeventd 執行，dmeventd 沒在監控就等於沒設（§9） |
| **discard / passdown** | 檔案系統釋放區塊時通知 pool / pool 再把通知往下傳給底層 SSD | 沒有 discard，刪掉的檔案永遠不會還回 pool |
| **thin_check / thin_repair** | 檢查 / 修復 tmeta 的工具（🟠 thin-provisioning-tools；🔵 device-mapper-persistent-data） | `lvconvert --repair` 在背後呼叫它們 |

**為什麼**：傳統 COW 快照每寫一次原卷就要複製一次舊資料，快照多了原卷慢好幾倍；thin 快照只記錄 metadata 指標，可以層疊上百個而不拖慢原卷，也讓 LV 可以「超額配置」、先開卷後買碟。但 thin pool 滿了會讓所有 thin volume 同時 I/O error，且 metadata 滿比 data 滿更難修，所以監控與自動擴充不是選配。

**怎麼做**：

```bash
# 建立 pool（資料 + metadata；metadata 建議 ≥ 1 GB 給大型 pool）
sudo lvcreate -L 500G -T vg0/tpool --poolmetadatasize 1G --chunksize 256K
# 或分開建再合併：lvcreate -L 500G -n tdata vg0; lvcreate -L 1G -n tmeta vg0; lvconvert --type thin-pool --poolmetadata vg0/tmeta vg0/tdata
# Thin volume（虛擬大小可超過 pool）
sudo lvcreate -V 1T -T vg0/tpool -n thin1                           # 實測：2G thin 在 400M pool，WARNING 提示超配
sudo mkfs.xfs /dev/vg0/thin1
# Thin 快照（瞬間、不指定大小、可再快照快照）
sudo lvcreate -s -n thin1_snap vg0/thin1                             # 預設 skip activation（Attr 第 10 位 k）
sudo lvchange -ay -K vg0/thin1_snap && sudo mount -o nouuid /dev/vg0/thin1_snap /mnt/snap
sudo lvconvert --merge vg0/thin1_snap                                # 回滾
# 監看（最重要！pool 滿了所有 thin volume 都會 I/O error）
sudo lvs -a -o name,lv_size,data_percent,metadata_percent,pool_lv,origin vg0   # 實測 tpool 28.92% / tmeta
# 自動擴充（/etc/lvm/lvm.conf 或 lvmlocal.conf；由 dmeventd 監控）
#   activation {
#       thin_pool_autoextend_threshold = 80      # 用到 80% 就擴
#       thin_pool_autoextend_percent = 20        # 每次擴 20%
#   }
sudo lvextend -L +100G vg0/tpool                                     # 手動擴 data（實測 +100M 成功）
sudo lvextend --poolmetadatasize +512M vg0/tpool                     # 擴 metadata（實測 +8M 成功；metadata 滿比 data 滿更危險）
# 空間回收：thin 需要 discard 才能還回 pool
sudo fstrim -v /mnt/thin1                                            # 或掛載 -o discard；lvm.conf thin_pool_discards = passdown
sudo lvchange --discards passdown vg0/tpool
# 修復 metadata（pool 無法啟用時）
sudo lvconvert --repair vg0/tpool                                    # 使用 thin_check / thin_repair（🟠 thin-provisioning-tools；🔵 device-mapper-persistent-data）
sudo thin_check /dev/mapper/vg0-tpool_tmeta
# 移除
sudo lvremove vg0/thin1_snap vg0/thin1 vg0/tpool
```

⚠️ 實務規則：**thin pool 一定要監控 + 自動擴充 + 保留 VG 空間**；把 pool 用到 100% 等同資料損毀事件。不要在根目錄用 thin（開機修復困難）。

---

## 4. 快取（dm-cache / dm-writecache）

**名詞與關係**：兩種快取都是 device-mapper 的目標：把一個快的 LV 接到慢 LV 前面；差別在「加速什麼」與「寫入何時算完成」：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **dm-cache** | device-mapper 的讀寫快取目標：把慢 LV 的熱區塊複製一份到快裝置 | `--type cache`；資料仍以 HDD 為主，SSD 上是副本 |
| **dm-writecache** | device-mapper 的純寫入快取：寫入先落 SSD、背景回寫 HDD | `--type writecache`；不加速讀 |
| **cachevol** | 新式做法：一個普通 LV 同時放快取資料與快取 metadata | `lvconvert --cachevol lv_fast`；建議用 |
| **cachepool** | 舊式做法：快取資料與 metadata 是兩個獨立 LV 組成的 pool | 多一層管理；只有舊文件會要求 |
| **cachemode `writethrough` / `writeback`** | 寫入同時落 SSD 與 HDD 才回應 / 只落 SSD 就回應 | writethrough 安全但寫入不加速；writeback 快但 SSD 壞就丟未回寫的資料 |
| **cache_policy（smq）** | 決定哪些區塊該進快取、哪些該淘汰的演算法 | 預設 smq，通常不需調整 |
| **dirty blocks** | writeback 模式下已在 SSD 但尚未回寫 HDD 的區塊 | `--uncache` / `--splitcache` 前必須全部 flush 回 HDD |
| **`--uncache` / `--splitcache`** | 移除快取並丟棄 lv_fast / 分離但保留 lv_fast | 兩者都會先 flush，時間取決於 dirty blocks 數量 |
| **WAL** | 資料庫的 write-ahead log：先寫日誌再改資料頁 | 典型「小量、連續、fsync 密集」的寫入，是 writecache 的最佳受益者 |

**為什麼**：預算只夠一顆小 SSD、卻有一大堆 HDD 上的熱資料時，dm-cache 能讓常讀的區塊自動留在 SSD。`writeback` 模式把寫入先落在 SSD 再回寫 HDD，SSD 壞掉或斷電就丟資料，所以預設是安全的 `writethrough`；`writecache` 則專門吸收資料庫 WAL、日誌這類寫入尖峰。

**怎麼做**：先依負載選模式，再把 SSD 加入同一個 VG 建成 cache LV。

| | `--type cache` | `--type writecache` |
|---|---|---|
| 加速 | 讀 + 寫（依 cachemode） | 只加速寫 |
| cachemode | `writethrough`（安全，預設）/ `writeback`（快，SSD 壞會丟資料） | — |
| 適合 | 一般讀寫混合 | 寫入密集（資料庫 WAL、日誌） |

```bash
# 假設 vg0 內 /dev/sdb（HDD）上有 lv_slow，/dev/nvme0n1 加入 VG 當快取
sudo vgextend vg0 /dev/nvme0n1
sudo lvcreate -L 50G -n lv_fast vg0 /dev/nvme0n1
sudo lvconvert --type cache --cachevol lv_fast --cachemode writethrough vg0/lv_slow   # cachevol：單一 LV 同時放 data + metadata（新式，建議）
# 舊式 cachepool：lvcreate --type cache-pool -L 50G -n cpool vg0 /dev/nvme0n1; lvconvert --type cache --cachepool cpool vg0/lv_slow
sudo lvs -a -o name,segtype,cache_mode,cache_policy,data_percent,cache_read_hits,cache_read_misses,cache_dirty_blocks vg0
sudo lvchange --cachemode writeback vg0/lv_slow                     # 切換（writeback 需 UPS + 可靠 SSD）
sudo lvconvert --uncache vg0/lv_slow                                # 移除快取（會先 flush）
sudo lvconvert --splitcache vg0/lv_slow                             # 分離但保留 lv_fast
# writecache
sudo lvconvert --type writecache --cachevol lv_fast vg0/lv_slow
sudo lvconvert --splitcache vg0/lv_slow                             # 移除前會 flush（需等待）
# 需核心模組 dm-cache / dm-writecache（一般發行版核心內建；本手冊實驗環境的 WSL2 核心缺 dm-cache 故未能實測）
```

💡 快取的替代：直接把熱資料（DB、索引）放 SSD LV、冷資料放 HDD LV，比快取可預測。

---

## 5. 搬移與重組：pvmove、vgsplit、vgexport（已實測）

**名詞與關係**：這一節的指令分三組——搬 PE（pvmove）、切 VG（vgsplit / vgmerge）、換機器（vgexport / vgimport）——共同的敵人是 UUID 衝突與「兩台同時啟用」：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **pvmove** | 把某 PV 上的 PE 線上搬到其他 PV | 內部建暫時 mirror（需 dm-mirror 或 dm-raid 模組）、同步完切換再拆；中斷可續跑 |
| **vgsplit / vgmerge** | 把某些 PV（及其上完整的 LV）拆成新 VG / 把兩個 VG 合一 | LV 不能跨越拆分線，striped 跨 PV 時會拒絕 |
| **vgexport / vgimport** | 在 metadata 上標記「此 VG 已交出」/ 取消標記 | exported 的 VG 不會被自動啟用，用來安全地把碟搬到另一台機器 |
| **VG UUID / PV UUID** | 每個 VG 與 PV 的唯一識別碼，寫在 metadata / label 裡 | 同名 VG 可用 UUID 指定 `vgrename`；`dd` 克隆會連 UUID 一起複製造成衝突 |
| **vgimportclone** | 為克隆碟上的 PV / VG 產生新 UUID 並改名後匯入 | 唯一能解 UUID 重複的正規方法 |
| **`vgreduce --removemissing`** | 把已經不存在的 PV 從 metadata 中移除 | `--force` 會連帶刪掉落在它上面的 LV；先用 partial 啟用撈資料 |
| **`--activationmode partial`** | 允許在缺 PV 的情況下啟用 LV | 缺的那段讀到錯誤（linear）或由副本補上（raid / mirror） |
| **vgimportdevices** | 🔵 掃描新碟並把找到的 VG 加進 devices file | Fedora 搬碟後 `vgimport` 前的必要步驟（§8） |

**為什麼**：硬碟退役、搬到新機、或兩個 VG 要合併時，`pvmove` 能在服務不停的狀態下搬資料（它其實是暫時建一個 mirror、同步完再拆掉，中斷後可續跑）。`vgexport` 把 VG 標記為「已交出」，避免舊機與新機同時啟用同一組碟、metadata 互相覆寫；接了克隆碟造成 UUID 重複時要用 `vgimportclone`，手動改名救不了 UUID 衝突。

**怎麼做**：

```bash
# 線上把資料搬離某顆 PV（換碟、退役）
sudo pvmove /dev/sdb1                          # 全部搬到 VG 內其他空閒 PV（實測 pvmove 後 loop0 Used=0）
sudo pvmove /dev/sdb1 /dev/sdd1                # 指定目的
sudo pvmove -n lv_data /dev/sdb1               # 只搬某個 LV
sudo pvmove --atomic /dev/sdb1                 # 整個成功或整個不動
sudo pvmove -b /dev/sdb1; sudo pvmove          # 背景執行；無參數 = 續跑中斷的 pvmove（重開機後可續）
sudo pvmove --abort
sudo vgreduce vg0 /dev/sdb1 && sudo pvremove /dev/sdb1
sudo vgreduce --removemissing vg0               # PV 已經壞掉 / 不見時強制移除（--force 會連帶刪掉在它上面的 LV）
# 需 dm-mirror 或 dm-raid 模組（實測 WSL2 需 modprobe）

# 拆分 / 合併 VG（PV 上的 LV 必須完整落在同一邊，實測 lvstripe 跨 PV 時會拒絕）
sudo vgsplit vg0 vg_new /dev/sdc1               # 把 sdc1（與其上的 LV）拆到新 VG（實測成功）
sudo vgmerge vg0 vg_new                         # 合併（vg_new 需先 vgchange -an）
# 搬到另一台機器
sudo vgchange -an vg_data && sudo vgexport vg_data       # 標記 exported（實測 vg_exported 欄位）
#   → 拔硬碟接到新機 →
sudo pvscan; sudo vgimport vg_data && sudo vgchange -ay vg_data
# 同名衝突（兩顆 ubuntu-vg / fedora 接到同一台）
sudo vgs -o vg_name,vg_uuid
sudo vgrename <uuid> vg_old                     # 用 UUID 指定
# 複製整顆 PV（dd / 快照）後兩個相同 UUID：
sudo vgimportclone -n vg_clone /dev/sde1        # 產生新 UUID 再匯入
```

**注意**：`vgreduce --removemissing --force` 會把落在遺失 PV 上的 LV 一併刪掉；壞碟前先用 `lvchange -ay --activationmode partial` 把還讀得到的資料撈出來。🔵 Fedora 搬碟到新機後還要 `vgimportdevices -a`（§8），否則 `vgimport` 根本看不到 PV。

---

## 6. Metadata 備份與還原（已實測）

**名詞與關係**：metadata 有三個存放處——PV 開頭（正本）、`/etc/lvm/backup`（最新副本）、`/etc/lvm/archive`（歷史副本）——還原就是把某份副本寫回正本：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **metadata** | PV 開頭的 VG 描述文字（§1） | `vgcfgbackup` 存的、`vgcfgrestore` 寫回的就是這段文字 |
| **`/etc/lvm/backup/<vg>`** | 每次變更「後」最新的 metadata 副本 | 只有一份、隨時被覆寫；代表「現在的狀態」 |
| **`/etc/lvm/archive/<vg>_NNNNN-*.vg`** | 每次變更「前」的 metadata 副本，帶流水號與描述 | 誤刪 LV 要找的是「執行 lvremove 之前」那一份；`vgcfgrestore -l` 會列出描述 |
| **vgcfgbackup / vgcfgrestore** | 手動匯出 / 把某份副本寫回所有 PV | restore 前必須停用 VG；含 thin 時要 `--force` |
| **PV label** | PV 開頭的標籤（§1） | 壞了 `pvs` 看不到；`pvcreate --uuid --restorefile` 用 archive 裡的 UUID 重寫 label 而不動資料 |
| **`--restorefile`** | 告訴 `pvcreate` 依這份 metadata 的 PE 佈局來設 `pe_start` | 沒有它，重建的 label 可能把 metadata 區覆蓋到資料上 |
| **lvmdump** | 打包 metadata、dm 表、log 的診斷工具 | 求助或開 bug 時附上 |

**為什麼**：`lvremove` 只刪掉 metadata 裡的 LV 定義，PE 上的資料還在——所以誤刪後只要 metadata 能還原、區塊尚未被覆寫，資料就救得回來；這也是為什麼誤刪後第一件事是「停止寫入」而不是重開機。LVM 每次變更前都自動備份 metadata：`/etc/lvm/backup/<vg>`（最新）與 `/etc/lvm/archive/<vg>_NNNNN-*.vg`（歷史，實測命名如 `vgadv_00001-190095625.vg`），這是誤刪 LV 後最重要的救命資料。

**怎麼做**：

```bash
sudo vgcfgbackup -f /root/vg0-$(date +%F).cfg vg0     # 手動備份（丟進 restic，見 11 章）
sudo vgcfgrestore -l vg0                                # 列出可用的 archive 與描述（"Created *before* executing 'lvremove ...'"）
# 誤刪 LV 的還原流程
sudo vgchange -an vg0                                   # ⚠️ 實測：VG 有 active LV 時會互動詢問，腳本中請先停用
sudo vgcfgrestore -f /etc/lvm/archive/vg0_00042-123.vg vg0
sudo vgcfgrestore --force -f ... vg0                    # ⚠️ 實測：VG 含 thin pool 時必須 --force（"Consider using option --force to restore Volume Group with thin volumes"）
sudo vgchange -ay vg0 && sudo lvs vg0                   # LV 回來了（資料是否完整取決於 PE 是否已被覆寫）
# PV label 損毀（pvs 看不到）：用 archive 中的 PV UUID 重建 label
sudo pvcreate --uuid "JFpvAC-2XEl-..." --restorefile /etc/lvm/archive/vg0_00042-123.vg /dev/sdb1
sudo vgcfgrestore -f /etc/lvm/archive/vg0_00042-123.vg vg0
# 直接從磁碟撈 metadata（archive 也沒了時）
sudo dd if=/dev/sdb1 bs=512 count=4096 | strings | grep -A200 "vg0 {" | less
sudo lvmdump -a -m                                      # 打包所有 LVM 診斷資訊（給支援）
```

💡 根目錄 VG 的 archive 在同一顆碟上；請把 `/etc/lvm/{backup,archive}` 納入異地備份。

---

## 7. 啟用、鎖定與 initramfs

**名詞與關係**：「啟用」是 LVM 與核心的交界：metadata 裡的 LV 只有在被啟用後才存在於 `/dev`；誰在何時啟用什麼，由 autoactivation、skip 旗標、volume_list 與 initramfs 共同決定：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **啟用（activation）** | 把 LV 的 LE → PE 表載入 device-mapper，產生 `/dev/vg/lv` | `lvs` Attr 第 5 位 `a`；未啟用的 LV 存在於 metadata 但沒有裝置節點 |
| **autoactivation** | 開機（或裝置出現）時由 udev 事件觸發的自動啟用 | `--setautoactivation n` 關掉，適合外接 / 共用碟 |
| **activation skip（`-K` / `--setactivationskip`）** | LV 層級旗標：`vgchange -ay` 也跳過它，必須 `-K` 明確啟用 | thin 快照預設帶此旗標，防止一開機就啟用一堆快照 |
| **tag / `volume_list`** | 給 LV 貼標籤；lvm.conf 的 `volume_list` 只允許列出的 VG / tag 被啟用 | 叢集或多環境共用碟時的白名單機制 |
| **initramfs（🟠 initramfs-tools / 🔵 dracut）** | 開機早期的迷你根檔案系統，內含 lvm2 與 lvm.conf 的副本 | 根 VG 在這裡被啟用；VG 改名、過濾改了都要重建它 |
| **`rd.lvm.lv=vg/lv`** | 🔵 dracut 的核心參數：只啟用指定 LV | 讓 initramfs 不去碰不相干的 VG |
| **udev 規則（69-dm-lvm.rules）** | 裝置出現時觸發 `pvscan --cache` 進而啟用 VG 的事件機制 | 容器 / 無 udev 環境要關 `udev_sync`（§11） |
| **lvmlockd（sanlock / dlm）** | LVM 的叢集鎖管理員；兩種後端：sanlock 用共用磁碟上的租約、dlm 用叢集網路 | 多台同時啟用同一 VG（`--shared`）的唯一安全方式 |

**為什麼**：外接碟、SAN 共用碟或備份克隆碟若在開機時被自動啟用，可能被兩台機器同時掛載、或搶走裝置名；`setautoactivation n` 與 activation skip 就是為了控制這件事。根卷 VG 改名或搬 VG 後，initramfs 裡仍記著舊名，是「開機卡在 Volume group not found」最常見的原因。

**怎麼做**：

```bash
sudo vgchange -ay vg0; sudo vgchange -an vg0           # 啟用 / 停用整個 VG
sudo lvchange -ay vg0/lv_data; sudo lvchange -an vg0/lv_data
sudo lvchange -ay --activationmode partial vg0/lv_data # 缺 PV 時勉強啟用（raid / mirror 可讀，linear 只能讀到存在的部分）
sudo lvchange --setactivationskip y vg0/lv_archive     # 開機不自動啟用（-K 手動）
sudo vgchange --setautoactivation n vg_data            # 整個 VG 不自動啟用（2.03.12+；外接 / 叢集共用碟）
sudo lvchange --permission r vg0/lv_data               # 唯讀
sudo lvchange --addtag backup vg0/lv_data; sudo lvs @backup   # 標籤，可在 lvm.conf 用 volume_list = ["@backup"] 控制啟用
# 開機時 LVM 啟用：兩者由 initramfs 內的 lvm2 + udev 規則（69-dm-lvm.rules）事件驅動；
#   🟠 /etc/initramfs-tools/ 的 lvm2 hook；🔵 dracut 的 lvm 模組（rd.lvm.lv=vg/lv 參數可限制只啟用根卷）
# 根卷改名 / 換 VG 後：改 /etc/fstab、/etc/default/grub 的 root=、🟠 update-initramfs -u + update-grub；🔵 grubby --update-kernel=ALL --args="root=/dev/mapper/vg-root rd.lvm.lv=vg/root" + dracut -f
# 叢集共用儲存（多台同時看到同一 VG）：需 lvmlockd（sanlock / dlm）— sudo vgcreate --shared；否則只能一台啟用（vgchange -ay 前確認）
```

**注意**：沒有 lvmlockd 的情況下，兩台主機同時 `vgchange -ay` 同一個共用 VG 不會報錯，但 metadata 會互相覆寫；SAN 環境務必在其中一台設 `--setautoactivation n`。

---

## 8. Devices file 與過濾（🟠🔵 行為差異）

**名詞與關係**：LVM 找 PV 有兩套機制——舊的 filter（黑白名單 regex）與新的 devices file（明確清單）——兩者都是在回答「哪些區塊裝置可以被當成 PV 掃描」：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **devices file（`/etc/lvm/devices/system.devices`）** | lvm2 2.03.12+ 的白名單：只掃描檔中列出的裝置 | 取代 filter；`pvcreate` 自動加入，外來碟不會自動出現 |
| **`lvmdevices`** | 管理 devices file 的指令（列出、加、刪、檢查、更新 ID） | 🟠 24.04 套件未編入 |
| **`vgimportdevices`** | 掃描所有磁碟，把找到的 VG 的 PV 全部加入 devices file | 搬碟到 Fedora 後的第一步 |
| **裝置 ID（IDTYPE：sys_wwid / sys_serial / mpath_uuid / loop_file…）** | devices file 用來辨識裝置的「內容識別」而非路徑 | 換 HBA / 控制器後 ID 可能變，需 `lvmdevices --update` |
| **`filter` / `global_filter`** | lvm.conf 中以 regex 接受 / 拒絕裝置路徑的舊機制 | 順序敏感、第一個符合的規則生效；`global_filter` 連 udev 觸發的掃描也套用 |
| **multipath（mpath）** | 同一顆 SAN 碟經多條路徑出現為多個 `/dev/sdX`，由 multipathd 合成 `/dev/mapper/mpathN` | LVM 必須只認 mpath 裝置、排除子路徑，否則同一 PV 出現多次 |
| **`--devicesfile ""`** | 單次指令忽略 devices file | 找「消失的 PV」用，不改設定 |
| **`/etc/lvm/lvmlocal.conf`** | 本機覆寫設定檔 | 套件升級不覆蓋；devices / activation 區段的本機調整放這裡 |

**為什麼**：LVM 傳統上掃描所有區塊裝置找 PV：KVM 主機會掃到 VM 映像檔內部的 PV、多路徑環境會同時看到 mpath 裝置與底下的子路徑、備份克隆碟會造成 UUID 重複——這些都可能讓 LVM 啟用錯的裝置。LVM 2.03.12+ 引入 **devices file**，改成只掃描列在 `/etc/lvm/devices/system.devices` 的裝置，取代舊的 `filter` regex。兩者的差異純粹來自版本：Ubuntu 24.04 的 lvm2 2.03.16 仍以 filter 為主，Fedora 44 的 2.03.38 已預設 devices file，所以同樣的「搬硬碟到新機」在 Fedora 上會看不到 VG。

**怎麼做**：先確認自己在哪一種模式，再依下表操作。

| | 🟠 Ubuntu 24.04（lvm2 2.03.16） | 🔵 Fedora 44（lvm2 2.03.38） |
|---|---|---|
| `use_devicesfile` 預設 | **0**（實測 `lvmconfig --type default`） | **1**（實測 `/etc/lvm/devices/system.devices` 自動建立） |
| `lvmdevices` 指令 | **無**（實測 command not found；套件未編入） | 有 |
| 新增磁碟後 | 直接 `pvcreate` 即可 | `pvcreate` / `vgcreate` 會自動加入 devices file；用他機建立的 PV 需 `lvmdevices --adddev /dev/sdX` 或 `vgimportdevices -a` |
| 換機 / 搬硬碟 | 直接看得到 | **看不到**：`vgimportdevices -a` 或 `--devicesfile ""` 暫時忽略 |

```bash
# 🔵 Fedora devices file 操作
sudo lvmdevices                                    # 列出（實測 IDTYPE=loop_file / sys_wwid / mpath_uuid ...）
sudo lvmdevices --adddev /dev/sdd
sudo lvmdevices --deldev /dev/sdd
sudo vgimportdevices -a                            # 掃描所有磁碟，把找到的 VG 加入
sudo pvs --devicesfile ""                          # 忽略 devices file 一次性掃描（找「消失」的 PV 用）
sudo lvmdevices --check; sudo lvmdevices --update  # 磁碟 ID 變動（換控制器）後修正
# 關閉（回到 filter 模式）：/etc/lvm/lvm.conf 或 lvmlocal.conf → devices { use_devicesfile = 0 }
# 🟠 Ubuntu / 舊式過濾：/etc/lvm/lvm.conf
#   devices {
#       filter = [ "a|/dev/sd.*|", "a|/dev/nvme.*|", "r|.*|" ]      # 只接受 sd* nvme*，其餘拒絕（順序敏感）
#       global_filter = [ "r|/dev/loop.*|", "r|/dev/zd.*|" ]        # 連 udev / lvmetad 也套用；KVM 主機拒絕 VM 映像內的 PV
#   }
# 過濾改了要 🟠 update-initramfs -u / 🔵 dracut -f（initramfs 內有一份 lvm.conf）
sudo pvscan --cache; sudo pvs -vvv 2>&1 | grep -i "filter" | head    # 除錯過濾
```

**注意**：devices file 以磁碟 ID（WWID / 序號）辨識裝置，換 HBA 或控制器後 ID 變了，根 VG 會在開機時被排除——這種情況要進救援模式跑 `lvmdevices --update` 再重建 initramfs。`/etc/lvm/lvmlocal.conf`：本機覆寫（套件升級不覆蓋），本手冊實驗環境即用它關閉 udev 同步。

---

## 9. 監控、效能與 dmeventd

**名詞與關係**：LVM 自己沒有常駐程序，所有「自動反應」都靠 dmeventd；效能相關名詞則是 dm 層的統計與幾個建立時決定的參數：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **dmeventd** | device-mapper 事件監控 daemon | thin autoextend、RAID 副本修復、傳統快照 autoextend 都由它觸發 |
| **`lvm2-monitor.service` / `dm-event.socket`** | 開機時把已啟用的 LV 註冊給 dmeventd 的單元 / 讓 dmeventd 隨需啟動的 socket | 兩者都由 lvm2 套件提供；`seg_monitor` 欄顯示某 LV 是否在監控中 |
| **readahead** | 核心對某裝置預讀多少磁區 | 循序讀為主的 LV 可調大；`lv_kernel_read_ahead` 是核心實際值 |
| **dmstats** | device-mapper 內建的分區段 I/O 統計 | 比 iostat 更細，可對 LV 內特定區段計數 |
| **chunksize（傳統快照 `-c`）** | COW 快照每次複製的單位 | 太小則 metadata 大、太大則寫放大；thin 的 chunk 是另一個獨立參數（§3） |
| **`archive { retain_days / retain_min }`** | lvm.conf：archive 保留天數 / 最少份數 | 數百 LV 的 VG 每次變更都寫一份 archive，會拖慢操作 |

**為什麼**：thin pool 自動擴充、RAID LV 壞碟自動修復、快照滿了自動延伸，都靠 dmeventd 監聽 device-mapper 事件——它沒在跑，`lvm.conf` 裡的 autoextend 設定就只是擺設。效能問題則多半來自對齊錯誤、傳統快照過多，或數百個 LV 讓 metadata 操作變慢。

**怎麼做**：

```bash
# dmeventd：監控 thin pool / raid / mirror / snapshot 事件並觸發自動擴充或修復（兩者由 lvm2 套件提供，隨需啟動）
systemctl status lvm2-monitor.service dm-event.socket
sudo lvchange --monitor y vg0/tpool
sudo lvs -o +seg_monitor
# 效能
sudo lvs -o +lv_read_ahead,lv_kernel_read_ahead; sudo lvchange -r 4096 vg0/lv_data      # readahead
sudo dmsetup status vg0-lv_data; sudo dmstats create /dev/vg0/lv_data && sudo dmstats report   # dm 層統計
iostat -xz 1 /dev/dm-0                                                                   # 對 dm 裝置
# 快照效能：傳統 COW 快照的 chunksize（-c 64k~1M）與數量會顯著拖慢寫入；長期需要快照請用 thin
# 對齊檢查：pvs -o +pe_start；RAID 卡條帶 = PE 起點的倍數
# 大 VG（數百 LV）：metadata 操作變慢 → 增大 --metadatasize、減少 archive 數（lvm.conf archive { retain_days / retain_min }）
```

---

## 10. VDO（重複資料刪除 + 壓縮，🔵 Fedora / RHEL 原生）

**名詞與關係**：VDO 的結構與 thin 幾乎平行——一個實際佔空間的 pool、多個對外呈現邏輯大小的 LV——只是 pool 內多了 dedup 與壓縮引擎：

| 名詞 | 一句話定義 | 與其他名詞的關係 |
|---|---|---|
| **VDO（Virtual Data Optimizer）** | Red Hat 的區塊層重複資料刪除 + 壓縮 + 精簡配置引擎 | 核心模組 dm-vdo（舊名 kvdo）；lvm2 以 `--type vdo` 整合 |
| **重複資料刪除（dedup）** | 內容相同的區塊只存一份，其餘存指標 | VM 映像、備份倉庫最有效 |
| **壓縮（compression）** | 區塊寫入前先壓縮 | 與 dedup 可分別開關（`lvchange --compression` / `--deduplication`） |
| **vpool（VDO pool LV）** | 實際佔 VG 空間的 VDO 池 | 對應 thin pool 的角色；`-L` 是它的實體大小 |
| **VDO LV（`-V`）** | 掛在 vpool 上、對外呈現邏輯大小的 LV | 對應 thin volume；`-V` 是邏輯大小 |
| **超額配置** | 邏輯大小大於實體大小 | 實體滿了的後果與 thin pool 相同：全部 I/O error，所以要監控 `vdo_used_size` |

**為什麼**：VM 映像、備份倉庫這類重複度高的資料，重複資料刪除加壓縮能省下數倍空間。VDO 是 Red Hat 收購後開源的技術，已整合進 lvm2 並隨 Fedora 核心內建；Ubuntu 沒有打包，同樣需求走 ZFS 或 Btrfs。

**怎麼做**：

```bash
# 🔵 lvm2 整合 VDO（需 kmod-kvdo，Fedora 44 核心內建 dm-vdo）
sudo dnf install -y vdo
sudo lvcreate --type vdo -L 1T -V 10T -n lv_vdo vg0/vpool          # 實體 1T，邏輯 10T
sudo lvs -o +vdo_compression,vdo_deduplication,vdo_used_size,vdo_saving_percent vg0
sudo lvchange --compression n vg0/vpool
# 🟠 Ubuntu：無官方 VDO 套件；替代方案 ZFS（dedup / compression）或 Btrfs compress
```

**注意**：VDO 本質上也是超額配置，實體空間用完的後果與 thin pool 相同，`vdo_used_size` 要一併納入監控。

---

## 11. 常見災難與修復流程

**為什麼**：LVM 的錯誤訊息通常不直接說原因——`not enough free extents` 其實是 striped 需要每個 PV 都有空間、`Device or resource busy` 常是 LUKS（cryptsetup 解鎖出的 dm-crypt 裝置）或 md（mdadm 軟體 RAID 陣列）疊在上面。下表把實際遇過的症狀對應到根因與處理順序；救援時先查表再動手，避免在慌亂中執行 `--force`。

**怎麼做**：

| 情境 | 處理 |
|---|---|
| `pvs` 顯示 `WARNING: Device for PV xxx not found or rejected by a filter` | 磁碟不見或被過濾：`lsblk`；🔵 `pvs --devicesfile ""`、`vgimportdevices -a`；🟠 檢查 `filter`；壞碟 → `vgreduce --removemissing`（先 `lvchange -ay --activationmode partial` 搶救資料） |
| 誤刪 LV | §6：`vgcfgrestore -l` 找刪除前的 archive → 停用 VG → restore（thin 需 `--force`） |
| `lvcreate` 報 `not enough free extents` 但 `vgs` 有空間 | striped / raid 需要在「每個 PV」都有足夠空間；或空間碎片化 → `lvs -o +seg_pe_ranges` 觀察，`pvmove` 整理 |
| thin pool 100% / metadata 100% | 立即 `lvextend` pool（VG 要有預留）；metadata 滿：`lvextend --poolmetadatasize`；啟用不了：`lvconvert --repair`；之後設 autoextend |
| 傳統快照 `Snap%` 到 100% 變 invalid | 快照失效（原卷不受影響）；`lvremove` 快照；下次建大一點或用 thin |
| raid LV 顯示 `p`（partial）/ `r`（refresh） | `lvchange --refresh`；`lvconvert --repair`；換碟後 `--replace` |
| 兩個同名 VG（接了克隆碟） | `vgrename <uuid> newname`；克隆碟 `vgimportclone` |
| `Device or resource busy` 無法 `lvremove` / `vgchange -an` | `lsof`/`fuser -vm` 看掛載或開啟；`dmsetup info -c` 看 open count；可能是 LUKS / md / 其他 dm 疊在上面，先拆上層 |
| 開機卡 `Volume group not found` / `rd.lvm.lv` | initramfs 內 lvm.conf 過濾 / devices file 排除了根碟：救援模式 `vgchange -ay` 後 🟠 `update-initramfs -u`、🔵 `dracut -f`；🔵 檢查 `/etc/lvm/devices/system.devices` 是否含新控制器 ID（`lvmdevices --update`） |
| 容器 / 無 udev 環境 `device not cleared` / 節點不建立 | 實測：`lvmlocal.conf` 設 `activation { udev_sync=0 udev_rules=0 }`（實體機不需要） |
| LUKS 上的 LVM 忘記解鎖順序 | 先 `cryptsetup open` → `vgchange -ay`；關閉相反 |

---

## 12. 本章差異總結

本章差異的根源有二：lvm2 版本落差（2.03.16 vs 2.03.38，相隔三年，devices file 與 VDO 整合都是這段期間成熟的功能），以及 Red Hat 主導 lvm2 / VDO 開發——Fedora 最先拿到新功能，Ubuntu LTS 則凍結在較舊版本以求穩定，套件名稱亦承襲 Debian 命名。

| 項目 | 🟠 Ubuntu 24.04 | 🔵 Fedora 44 |
|---|---|---|
| lvm2 版本 | 2.03.16 | 2.03.38 |
| devices file | 預設關閉、無 `lvmdevices` 指令 | 預設開啟（`/etc/lvm/devices/system.devices`） |
| 搬硬碟到新機 | 直接可見 | 需 `vgimportdevices -a` |
| 過濾機制 | `lvm.conf` 的 `filter` / `global_filter` | devices file（`filter` 仍可用但次要） |
| thin 工具套件 | `thin-provisioning-tools` | `device-mapper-persistent-data` |
| VDO | 無 | `vdo` + lvm2 整合 |
| 預設安裝 VG / LV 名 | `ubuntu-vg` / `ubuntu-lv`（只用一半 VG） | `fedora` / `root`、`home`（Server：xfs） |
| initramfs 內 LVM | initramfs-tools lvm2 hook | dracut lvm 模組（`rd.lvm.lv=`） |
| 過濾變更後 | `update-initramfs -u` | `dracut -f` |
| `vgcfgrestore` 含 thin | 需 `--force`（相同） | 需 `--force`（實測） |
| dm-cache / dm-raid 模組 | 核心內建 | 核心內建 |
