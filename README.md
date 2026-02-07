# git-scripts 使用說明

本專案提供常用的 Git 輔助腳本，目前主要保留的腳本為：

- setup-git-config.sh：交互式初始化全域 Git 設定（會詢問使用者名稱與電子郵件）。

目標：快速在新環境中套用一致的 Git 設定，包含別名、編碼與行尾設定等。

快速使用：

```shell
# 下載或切換到本倉庫後，執行：
./setup-git-config.sh
```

這個腳本會設定以下項目（範例）：

- user.name / user.email
- push.autoSetupRemote = true（推新分支時自動設定上游）
- init.defaultBranch = main（預設初始分支名稱）
- core.autocrlf = input、core.safecrlf = false（統一使用 LF 行尾）
- core.quotepath = false（顯示 UTF-8 路徑，例如中文）
- color.diff/status/branch = auto（在命令列顯示顏色）
- 常用 alias（ci, cm, co, st, sts, br, re, di, lo, ls, ll, lg, alias, ignore, acp, ac, pushall, acpa）

注意：本專案先前包含多個便捷腳本（ac.sh、acp.sh、agc.sh、pl.sh、ph.sh、st.sh、br.sh），已移除未使用的檔案以簡化維護；如需對應功能，請在歷史紀錄中查找或重新建立。

檔案權限：請確保腳本具有執行權限：

```shell
chmod +x ~/git-scripts/*.sh
```

若要自訂或新增 alias，可將對應設定加入你的 ~/.gitconfig（或由腳本延伸）。

問題回報或需求建議請建立 issue。