# git-scripts 使用說明

本專案提供常用的 Git 輔助腳本與 Git Hooks 管理工具，協助快速在新環境中建立一致的 Git 工作流程。

## 主要功能

### 1. setup-git-config.sh
交互式初始化全域 Git 設定腳本，會詢問使用者名稱與電子郵件，並自動設定常用的 Git 配置項目。

### 2. setup-hooks.sh
Git Hooks 設定與管理工具，提供安全的 hooks 安裝、權限檢查與檔案驗證機制。

### 3. hooks/
預設 Git Hooks 目錄，目前包含：
- **pre-commit**：使用 GitHub Copilot CLI 進行自動化程式碼審查的 pre-commit 鉤子

## 快速開始

### 初始化 Git 設定

```bash
# 下載或切換到本倉庫後，執行：
./setup-git-config.sh
```

### 安裝 Git Hooks

```bash
# 設定全域 Git Hooks 路徑並配置權限
./setup-hooks.sh
```

## 詳細說明

### setup-git-config.sh

這個腳本會自動設定以下 Git 配置項目：

- **使用者資訊**：user.name / user.email
- **推送設定**：push.autoSetupRemote = true（推新分支時自動設定上游）
- **分支設定**：init.defaultBranch = main（預設初始分支名稱）
- **行尾設定**：core.autocrlf = input、core.safecrlf = false（統一使用 LF 行尾）
- **編碼設定**：core.quotepath = false（正確顯示 UTF-8 路徑，例如中文檔名）
- **顏色設定**：color.diff/status/branch = auto（在命令列啟用顏色顯示）
- **常用別名**：ci, cm, co, st, sts, br, re, di, lo, ls, ll, lg, alias, ignore, acp, ac, pushall, acpa

### setup-hooks.sh

這個腳本提供完整的 Git Hooks 管理功能：

#### 主要功能
- 設定全域 Git Hooks 路徑（`core.hooksPath`）
- 自動驗證 hooks 檔案的安全性（檢查擁有者、權限、shebang）
- 為白名單中的 hooks 檔案設定可執行權限
- 警告未知或不安全的 hooks 檔案

#### 支援的 Hooks 類型
pre-commit, post-commit, pre-push, post-receive, pre-receive, commit-msg, pre-rebase, post-update, applypatch-msg, pre-applypatch, post-applypatch

#### 安全機制
- 路徑驗證：確保 hooks 目錄在腳本目錄範圍內
- 權限檢查：檢查目錄與檔案的擁有者和權限
- 內容驗證：確保 hooks 檔案包含有效的 shebang
- 符號連結檢測：警告並顯示符號連結的真實目標

### hooks/pre-commit

自動化程式碼審查的 pre-commit 鉤子，使用 GitHub Copilot CLI 進行智慧審查。

#### 功能特色
- **智慧過濾**：僅審查程式碼檔案（支援 js, ts, py, go, java, cpp, php, rb, rs 等）
- **安全檢查**：偵測敏感資訊（password, secret, api_key, token 等）
- **大小限制**：預設限制 500 行變更、20 個檔案（可超過限制但需確認）
- **互動式確認**：每個階段都可選擇跳過或繼續
- **緊急跳脫**：按 Ctrl+C 可強制跳過所有檢查

#### 使用前提
需要安裝 [GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/install-copilot-cli#installing-or-updating-copilot-cli)

#### 審查內容
1. 找出潛在 Bug
2. 效能優化建議
3. 程式碼結構與命名改善
4. 安全風險檢查

## 檔案權限設定

請確保腳本具有執行權限：

```bash
chmod +x ~/git-scripts/*.sh
```

## 自訂設定

若要自訂或新增 Git alias，可將對應設定加入你的 `~/.gitconfig`，或直接修改 `setup-git-config.sh` 腳本中的設定內容。

若要新增其他 hooks，請將 hook 檔案放入 `hooks/` 目錄，並確保檔名在 `setup-hooks.sh` 的白名單中，或手動新增至白名單。

## 注意事項

本專案先前包含多個便捷腳本（ac.sh、acp.sh、agc.sh、pl.sh、ph.sh、st.sh、br.sh），已移除未使用的檔案以簡化維護。如需對應功能，請在歷史紀錄中查找或使用 Git alias 替代。

## 問題回報

如有問題或功能建議，請建立 issue。