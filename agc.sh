#!/bin/bash

# 先加入所有變更
git add --all

# 確認有暫存的變更
if ! git diff --cached --quiet; then
    DIFF=$(git diff --cached)
else
    echo "⚠️ 沒有暫存的變更"
    exit 1
fi

# 用新版 gemini CLI 生成訊息
MESSAGE=$(echo "$DIFF" | gemini -m gemini-2.5-pro \
    "請根據以下 git diff，撰寫一個清晰的 commit message（使用繁體中文）。")

echo ""
echo "✅ 建議的 commit message："
echo "------------------------------------------------------------"
echo "$MESSAGE"
echo "------------------------------------------------------------"
echo ""

read -p "是否要使用這個 message commit? (y/N): " confirm
if [[ $confirm == [yY] ]]; then
    git commit -m "$MESSAGE"
else
    echo "❌ 已取消。"
fi
