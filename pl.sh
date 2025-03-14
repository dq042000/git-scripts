#!/bin/bash

# 取得所有 remote 名稱
remote_names=$(git remote)

# 取得目前所在的 branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

# 取得目前 branch 所用的 remote 名稱
current_remote=$(git config branch.$current_branch.remote)

# 檢查是否輸入了 'all'
if [ "$1" == "all" ]; then
    # 對每個 remote 執行 git pull 指令
    for remote_name in $remote_names; do
        git pull $remote_name $current_branch
    done
else
    # 只 pull 到目前 branch 所用的 remote
    git pull $current_remote $current_branch
fi

