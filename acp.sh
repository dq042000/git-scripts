#!/bin/bash
branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$1" = "gitlab" ]; then
  git add --all && git commit -m "$2" && git push -u origin-gitlab "$branch"
elif [ "$1" = "all" ]; then
  git add --all && git commit -m "$2" && git push -u origin-gitlab "$branch" && git push -u origin "$branch"
else
  git add --all && git commit -m "$1" && git push -u origin "$branch"
fi
