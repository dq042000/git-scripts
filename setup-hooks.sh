#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Git Hooks 設定與管理腳本
# ============================================================================
# 專門處理 Git hooks 的安裝、權限設定與安全檢查
# 包含：路徑驗證、權限檢查、檔案驗證、符號連結檢測等安全機制
# ============================================================================

# ============================================================================
# 配置區域
# ============================================================================

# 安全的 hooks 檔案類型白名單
hooks_whitelist=(
    "pre-commit"
    "post-commit" 
    "pre-push"
    "post-receive"
    "pre-receive"
    "commit-msg"
    "pre-rebase"
    "post-update"
    "applypatch-msg"
    "pre-applypatch"
    "post-applypatch"
)

# 取得腳本目錄的絕對路徑
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================================================
# 工具函數區域
# ============================================================================
declare -A hooks_whitelist_map
for hook in "${hooks_whitelist[@]}"; do
    hooks_whitelist_map["$hook"]=1
done

# 安全取得真實路徑（改進版）
get_real_path() {
    local path="$1"
    local real_path
    
    # 如果路徑不存在，返回錯誤
    if [ ! -e "$path" ]; then
        echo "路徑不存在: $path" >&2
        return 1
    fi
    
    # 優先使用 realpath
    if command -v realpath >/dev/null 2>&1; then
        real_path="$(realpath "$path" 2>/dev/null)"
        if [ $? -eq 0 ] && [ -n "$real_path" ]; then
            echo "$real_path"
            return 0
        fi
    fi
    
    # Fallback：處理目錄和檔案
    if [ -d "$path" ]; then
        # 目錄：cd 進入並取得 pwd
        echo "$(cd "$path" && pwd)"
    elif [ -f "$path" ]; then
        # 檔案：取得目錄部分和檔名部分
        local dir_part
        local file_part
        dir_part="$(dirname "$path")"
        file_part="$(basename "$path")"
        echo "$(cd "$dir_part" && pwd)/$file_part"
    else
        # 其他情況返回原始路徑（但先警告）
        echo "警告: 無法處理的路徑類型: $path" >&2
        echo "$path"
        return 1
    fi
}

# ============================================================================
# 核心功能函數區域
# ============================================================================
check_directory_permissions() {
    local dir="$1"
    
    # 檢查目錄是否只有 owner 可寫入
    local perms
    perms=$(stat -c "%a" "$dir" 2>/dev/null)
    
    if [ -z "$perms" ]; then
        echo "⚠️  無法檢查目錄權限: $dir"
        return 1
    fi
    
    # 正確檢查其他用戶寫入權限（bit 1 為寫入權限）
    local others_perm=$((perms % 10))
    if [ $((others_perm & 2)) -eq 2 ]; then
        echo "⚠️  安全警告: 目錄 $dir 允許其他用戶寫入 (權限: $perms)"
        return 1
    fi
    
    # 檢查群組是否可寫入
    local group_perm=$(((perms / 10) % 10))
    if [ $((group_perm & 2)) -eq 2 ]; then
        echo "⚠️  注意: 目錄 $dir 允許群組寫入 (權限: $perms)"
    fi
    
    return 0
}

# 檢查檔案擁有者
check_file_owner() {
    local file="$1"
    local current_user
    current_user=$(id -u)
    
    local file_owner
    file_owner=$(stat -c "%u" "$file" 2>/dev/null)
    
    if [ -z "$file_owner" ]; then
        echo "⚠️  無法檢查檔案擁有者: $file"
        return 1
    fi
    
    if [ "$file_owner" != "$current_user" ]; then
        echo "⚠️  安全警告: 檔案 $file 不屬於當前用戶"
        return 1
    fi
    
    return 0
}

# 驗證檔案內容是否為有效腳本
validate_hook_file() {
    local file="$1"
    
    # 檢查檔案是否為空
    if [ ! -s "$file" ]; then
        echo "⚠️  檔案為空: $(basename "$file")"
        return 1
    fi
    
    # 檢查檔案擁有者
    if ! check_file_owner "$file"; then
        return 1
    fi
    
    # 檢查是否有有效的 shebang
    local first_line
    first_line=$(head -n1 "$file" 2>/dev/null)
    
    if [[ ! "$first_line" =~ ^#! ]]; then
        echo "⚠️  缺少 shebang: $(basename "$file")"
        return 1
    fi
    
    return 0
}

# 驗證 hooks 路徑是否安全
validate_hooks_path() {
    local hooks_dir="$1"
    
    # 檢查目錄是否存在
    if [ ! -d "$hooks_dir" ]; then
        echo "⚠️  Hooks 目錄不存在: $hooks_dir"
        return 1
    fi
    
    # 檢查是否為符號連結
    if [ -L "$hooks_dir" ]; then
        echo "⚠️  安全警告: Hooks 目錄是符號連結: $hooks_dir"
        local link_target
        link_target=$(readlink -f "$hooks_dir")
        echo "    連結目標: $link_target"
    fi
    
    # 取得真實路徑並嚴格比對
    local real_hooks_dir
    local real_script_dir
    real_hooks_dir=$(get_real_path "$hooks_dir")
    real_script_dir=$(get_real_path "$script_dir")
    
    # 使用 case 語句進行更嚴格的路徑比對
    case "$real_hooks_dir" in
        "$real_script_dir"*)
            # 確保是真正的子目錄，而非只是字首相同
            if [ "$real_hooks_dir" = "$real_script_dir" ]; then
                echo "⚠️  安全警告: Hooks 目錄不能與腳本目錄相同"
                return 1
            fi
            ;;
        *)
            echo "⚠️  安全警告: Hooks 目錄不在腳本目錄範圍內"
            echo "    腳本目錄: $real_script_dir"
            echo "    Hooks 目錄: $real_hooks_dir"
            return 1
            ;;
    esac
    
    # 檢查目錄權限
    if ! check_directory_permissions "$hooks_dir"; then
        echo "    建議執行: chmod 755 $hooks_dir"
        return 1
    fi
    
    return 0
}

# 設定 hooks 檔案權限
set_hook_permissions() {
    local hooks_dir="$1"
    
    echo "正在設定 hooks 檔案權限..."
    
    # 只對白名單中的檔案設定可執行權限
    for hook_file in "${hooks_whitelist[@]}"; do
        local hook_path="$hooks_dir/$hook_file"
        if [ -f "$hook_path" ]; then
            # 驗證檔案內容
            if validate_hook_file "$hook_path"; then
                chmod +x "$hook_path"
                echo "  ✓ $hook_file"
            else
                echo "  ⚠️  跳過 $hook_file (驗證失敗)"
            fi
        fi
    done
}

# 警告未知檔案
warn_unknown_files() {
    local hooks_dir="$1"
    
    # 將變數宣告移出 while 迴圈
    local basename_file
    local is_whitelisted
    
    # 限制搜尋深度避免效能問題
    while IFS= read -r -d '' file; do
        basename_file=$(basename "$file")
        
        # 使用映射表加速查找
        if [[ -n "${hooks_whitelist_map[$basename_file]:-}" ]]; then
            is_whitelisted=true
        else
            is_whitelisted=false
        fi
        
        if ! $is_whitelisted; then
            echo "  ⚠️  發現未知檔案: $basename_file (未設定可執行權限)"
            
            # 如果是類似 hook 的檔案名稱，給出建議
            for hook in "${hooks_whitelist[@]}"; do
                if [[ "$basename_file" == "$hook"* ]]; then
                    echo "      提示: 可能是 $hook 的變體，請確認檔名正確"
                    break
                fi
            done
        fi
    done < <(find "$hooks_dir" -maxdepth 1 -type f -print0 2>/dev/null)
}

# 安全設定 hooks 檔案權限（主函數）
setup_hooks_permissions() {
    local hooks_dir="$1"
    
    if ! validate_hooks_path "$hooks_dir"; then
        echo "⚠️  Hooks 路徑驗證失敗，跳過權限設定"
        return 1
    fi
    
    # 設定權限
    set_hook_permissions "$hooks_dir"
    
    # 警告未知檔案
    warn_unknown_files "$hooks_dir"
}

# 安全詢問用戶確認（改進版）
ask_user_safely() {
    local prompt="$1"
    local default="${2:-n}"
    local timeout="${3:-30}"
    local max_attempts=3
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        echo -n "$prompt "
        if [[ $default == "y" ]]; then
            echo -n "(Y/n): "
        else
            echo -n "(y/N): "
        fi
        
        local confirm=""
        if read -r -t "$timeout" confirm 2>/dev/null; then
            # 用戶有輸入
            case "$confirm" in
                [Yy]|[Yy][Ee][Ss]) 
                    return 0 
                    ;;
                [Nn]|[Nn][Oo]) 
                    return 1 
                    ;;
                "") 
                    # 空輸入使用預設值
                    echo "使用預設值: $default"
                    [[ $default == "y" ]]
                    return $?
                    ;;
                *) 
                    # 無效輸入，重試
                    echo "無效輸入，請輸入 y/yes 或 n/no"
                    attempt=$((attempt + 1))
                    if [ $attempt -le $max_attempts ]; then
                        echo "剩餘嘗試次數: $((max_attempts - attempt + 1))"
                    fi
                    continue
                    ;;
            esac
        else
            echo ""
            echo "⏰ 輸入超時，使用預設值 ($default)"
            [[ $default == "y" ]]
            return $?
        fi
    done
    
    echo "達到最大嘗試次數，使用預設值 ($default)"
    [[ $default == "y" ]]
    return $?
}

# 設定全域 Git Hooks
configure_git_hooks() {
    local hooks_path="$script_dir/hooks"
    
    echo "設定全域 Git Hooks 路徑..."
    
    # 檢查是否已設定過 hooks 路徑
    local current_hooks_path
    current_hooks_path=$(git config --global --get core.hooksPath 2>/dev/null || echo "")
    
    if [ -n "$current_hooks_path" ] && [ "$current_hooks_path" != "$hooks_path" ]; then
        echo "⚠️  目前已設定 hooks 路徑: $current_hooks_path"
        
        if ask_user_safely "是否要覆蓋為新路徑？" "n" 30; then
            # 繼續設定新路徑
            echo "將覆蓋現有設定..."
        else
            echo "保留現有設定，跳過 hooks 路徑設定"
            # 仍然嘗試設定現有路徑的權限
            if [ -d "$current_hooks_path" ]; then
                echo "檢查現有 hooks 路徑的權限..."
                setup_hooks_permissions "$current_hooks_path"
            fi
            return 0
        fi
    fi
    
    # 設定 hooks 路徑
    git config --global core.hooksPath "$hooks_path"
    
    # 設定權限
    if ! setup_hooks_permissions "$hooks_path"; then
        echo "⚠️  Hooks 權限設定失敗，但路徑已設定"
    fi
    
    echo "✓ Git hooks 路徑設定完成: $hooks_path"
}

# ============================================================================
# 主程序區域
# ============================================================================

# 主程序
main() {
    echo "Git Hooks 設定與管理工具"
    echo "========================="
    
    # 檢查 Git 是否可用
    if ! command -v git >/dev/null 2>&1; then
        echo "❌ 錯誤: Git 未安裝或不在 PATH 中"
        exit 1
    fi
    
    # 執行 hooks 設定
    configure_git_hooks
    
    echo ""
    echo "✅ Git hooks 設定完成！"
}

# 執行主程序
main "$@"