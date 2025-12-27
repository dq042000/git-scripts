---
post_title: git-scripts 使用指南
author1: dq042000
post_slug: git-scripts-guide
microsoft_alias: dq042000
featured_image: https://example.com/git-scripts-banner.png
categories: [工具, 自動化]
tags: [git, shell, 自動化, gemini, cli]
ai_note: 本文部分內容由 AI 協助產製
summary: 本指南介紹 git-scripts 專案的各個 shell 腳本用途、用法與設定方式，並說明如何確保每個檔案具備執行權限。
post_date: 2025-10-29
---

## 1. acp.sh

### 使用方式

#### 只推 origin（預設）

```shell
git acp "你的 commit 訊息"
```

或

```shell
git acp
```

- 若有輸入 commit 訊息：
  - git add --all
  - git commit -m "你的 commit 訊息"
  - git push -u origin 當前分支
- 若沒輸入 commit 訊息：
  - git add --all
  - git commit（進入互動式編輯）
  - git push -u origin 當前分支

#### 只推 origin-gitlab

```shell
git acp gitlab "你的 commit 訊息"
```

或

```shell
git acp gitlab
```

- 若有輸入 commit 訊息：
  - git add --all
  - git commit -m "你的 commit 訊息"
  - git push -u origin-gitlab 當前分支
- 若沒輸入 commit 訊息：
  - git add --all
  - git commit（進入互動式編輯）
  - git push -u origin-gitlab 當前分支

#### 同時推 origin 和 origin-gitlab

```shell
git acp all "你的 commit 訊息"
```

或

```shell
git acp all
```

- 若有輸入 commit 訊息：
  - git add --all
  - git commit -m "你的 commit 訊息"
  - git push -u origin-gitlab 當前分支
  - git push -u origin 當前分支
- 若沒輸入 commit 訊息：
  - git add --all
  - git commit（進入互動式編輯）
  - git push -u origin-gitlab 當前分支
  - git push -u origin 當前分支

## 2. ac.sh

### 使用方式

```shell
git ac "你的 commit 訊息"
```

或

```shell
git ac
```

- 若有輸入 commit 訊息：
  - git add --all
  - git commit -m "你的 commit 訊息"
- 若沒輸入 commit 訊息：
  - git add --all
  - git commit（進入互動式編輯）

## 3. agc.sh

### 使用方式

```shell
git agc
```

- 會先執行 `git add --all`
- 再呼叫 gemini cli 產生 commit message 並自動 commit

適合讓 Gemini CLI 根據變更自動產生 commit message，無需手動輸入。

### 依賴需求

若要使用 `agc` 指令，請先安裝 gemini cli。可使用下列指令安裝：

```shell
npm install -g @google/gemini-cli
```

或參考 [Gemini CLI 官方文件](https://github.com/GoogleCloudPlatform/gemini-cli) 取得更多安裝與設定資訊。

### 記憶體參數說明

`agc.sh` 內部會設定下列環境變數來提升 Node.js 執行時的記憶體上限：

```shell
NODE_OPTIONS="--max-old-space-size=8192"
```

這樣可避免在大型專案或大量檔案時，gemini cli 執行時發生記憶體不足的問題。

## 4. pl.sh

### 使用方式

```shell
git pl
```

- git pull `當前遠端儲存庫名稱` `當前分支名稱`

## 5. ph.sh

### 使用方式

```shell
git ph
```

- git push `當前遠端儲存庫名稱` `當前分支名稱`

## 6. st.sh
### 使用方式

```shell
git st
```

- git status

## 7. br.sh
### 使用方式
```shell
git br
```

- git branch

## 8. 設定 git alias

請在 `~/.gitconfig` 中加入以下設定：

```shell
[alias]
  acp = "!~/git-scripts/acp.sh"
  ac = "!~/git-scripts/ac.sh"
  agc = "!~/git-scripts/agc.sh"
  pl = "!~/git-scripts/pl.sh"
  ph = "!~/git-scripts/ph.sh"
  st = "!~/git-scripts/st.sh"
  br = "!~/git-scripts/br.sh"
```

## 10. 檔案權限設定

請確保所有 shell 腳本都具備執行權限。可使用以下指令一次性設定：

```shell
chmod +x ~/git-scripts/*.sh
```

這樣才能直接執行這些腳本，並讓 git alias 正常運作。