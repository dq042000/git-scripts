#!/bin/bash

# 取得目前所在的 branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

commit_and_push() {
    git add --all && git commit -m "$1" && git push -u "$2" "$current_branch"
}

if [ "$1" = "gitlab" ]; then
    if [ -z "$2" ]; then
        echo "Commit message is required."
        exit 1
    fi
    commit_and_push "$2" "origin-gitlab"
elif [ "$1" = "all" ]; then
    if [ -z "$2" ]; then
        echo "Commit message is required."
        exit 1
    fi
    commit_and_push "$2" "origin-gitlab" && git push -u origin "$current_branch"
else
    if [ -z "$1" ]; then
        echo "Commit message is required."
        exit 1
    fi
    commit_and_push "$1" "origin"
fi
