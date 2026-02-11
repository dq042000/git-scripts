#!/usr/bin/env bash
set -euo pipefail

# 提前宣告腳本目錄，避免未宣告錯誤
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 驗證 hooks 腳本是否安全
verify_hooks_script() {
    local hooks_script="$SCRIPT_DIR/setup-hooks.sh"
    
    # 檢查腳本是否存在
    if [ ! -f "$hooks_script" ]; then
        echo "❌ 找不到 hooks 設定腳本: $hooks_script"
        return 1
    fi
    
    # 檢查腳本是否可執行
    if [ ! -x "$hooks_script" ]; then
        echo "❌ hooks 設定腳本無執行權限: $hooks_script"
        return 1
    fi
    
    # 檢查腳本擁有者是否為當前用戶
    local current_user
    current_user=$(id -u)
    local script_owner
    script_owner=$(stat -c "%u" "$hooks_script" 2>/dev/null)
    
    if [ "$script_owner" != "$current_user" ]; then
        echo "⚠️  安全警告: hooks 腳本不屬於當前用戶"
        echo "    腳本: $hooks_script"
        echo "    擁有者 UID: $script_owner"
        echo "    當前用戶 UID: $current_user"
        return 1
    fi
    
    # 檢查腳本是否在預期位置
    local real_script_dir
    real_script_dir=$(realpath "$SCRIPT_DIR" 2>/dev/null || echo "$SCRIPT_DIR")
    local real_hooks_script
    real_hooks_script=$(realpath "$hooks_script" 2>/dev/null || echo "$hooks_script")
    
    if [[ "$real_hooks_script" != "$real_script_dir/setup-hooks.sh" ]]; then
        echo "⚠️  安全警告: hooks 腳本路徑異常"
        echo "    期望: $real_script_dir/setup-hooks.sh"
        echo "    實際: $real_hooks_script"
        return 1
    fi
    
    return 0
}

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

# 拉取所有遠端的別名（針對當前分支）
git config --global alias.pullall '!f() { branch=$(git rev-parse --abbrev-ref HEAD); git remote | xargs -L1 -I r sh -c "git pull r $branch"; }; f'

printf "Git configuration updated.\n"

# 詢問是否要設定 Git Hooks
echo ""
echo -n "是否要設定 Git Hooks？(Y/n): "
read -r setup_hooks

if [[ ! $setup_hooks =~ ^[Nn]$ ]]; then
    # 驗證 hooks 腳本安全性
    if verify_hooks_script; then
        echo ""
        echo "執行 hooks 設定腳本..."
        # 使用安全的方式執行腳本
        bash "$SCRIPT_DIR/setup-hooks.sh"
    else
        echo "❌ hooks 腳本安全驗證失敗，跳過設定"
        exit 1
    fi
else
    echo "跳過 Git Hooks 設定"
fi
