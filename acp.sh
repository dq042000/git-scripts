#!/bin/bash

# 取得目前所在的 branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

commit_and_push() {
  if [ -z "$1" ]; then
    git add --all && git commit -s
  else
    git add --all && git commit -m "$1" -s
  fi
  git push -u "$2" "$current_branch"
}

if [ "$1" = "gitlab" ]; then
  commit_and_push "$2" "origin-gitlab"
elif [ "$1" = "all" ]; then
  commit_and_push "$2" "origin-gitlab"
  git push -u origin "$current_branch"
else
  commit_and_push "$1" "origin"
fi