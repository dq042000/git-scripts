#!/usr/bin/env bash
set -euo pipefail

# 提示輸入 Git 使用者名稱與電子郵件
read -rp "Git user.name: " name
read -rp "Git user.email: " email

# 設定基本使用者資訊
git config --global user.name "$name"
git config --global user.email "$email"

# 新分支推送時預設設定上游分支
git config --global push.autoSetupRemote true

# 預設的初始化分支名稱
git config --global init.defaultBranch main

# # 設定全域 Git Hooks 路徑
# SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# git config --global core.hooksPath "$SCRIPT_DIR/hooks"

# # 設定 hooks 目錄中的所有檔案為可執行
# if [ -d "$SCRIPT_DIR/hooks" ]; then
#     find "$SCRIPT_DIR/hooks" -type f -exec chmod +x {} \;
# fi

# 使用 LF 作為行尾並避免 safecrlf 警告
git config --global core.autocrlf input
git config --global core.safecrlf false

# 正確顯示 UTF-8 路徑（例如中文）
git config --global core.quotepath false

# 在命令列中啟用顏色輸出
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto

# 常用別名
git config --global alias.ci commit
git config --global alias.cm "commit --amend -C HEAD"
git config --global alias.co checkout
git config --global alias.st status
git config --global alias.sts "status -s"
git config --global alias.br branch
git config --global alias.re remote
git config --global alias.di diff
git config --global alias.lo "log --oneline"
git config --global alias.ls "log --show-signature"
git config --global alias.ll "log --pretty=format:'%h %ad | %s%d [%Cgreen%an%Creset]' --graph --date=short"
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset %ad |%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset [%Cgreen%an%Creset]' --abbrev-commit --date=short"
git config --global alias.alias "config --get-regexp ^alias\."

# 從 gitignore.io 取得 .gitignore 範本的輔助別名
git config --global alias.ignore '!f() { curl -sL "https://www.gitignore.io/api/$*" > .gitignore && echo -e "\n# Custom rules\n.history" >> .gitignore; }; f'

# 新增/提交/推送 的輔助別名
git config --global alias.acp '!f() { git add . && if [ -n "$1" ]; then git commit -m "$1"; else git commit; fi && git push; }; f'
git config --global alias.ac '!f() { git add . && if [ -n "$1" ]; then git commit -m "$1"; else git commit; fi; }; f'
git config --global alias.acpa '!f() { git add . && if [ -n "$1" ]; then git commit -m "$1"; else git commit; fi && git remote | xargs -L1 git push; }; f'

# 推送所有遠端的別名
git config --global alias.pushall '!git remote | xargs -L1 git push --all'


printf "Git configuration updated.\n"
printf "Git hooks path set to: %s/hooks\n" "$SCRIPT_DIR"
printf "All hooks have been set as executable.\n"
