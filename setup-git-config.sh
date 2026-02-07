#!/usr/bin/env bash
set -euo pipefail

# Prompt for user name and email
read -rp "Git user.name: " name
read -rp "Git user.email: " email

# Set basic user info
git config --global user.name "$name"
git config --global user.email "$email"

# Push new branches with upstream by default
git config --global push.autoSetupRemote true

# Default initial branch name
git config --global init.defaultBranch main

# Use LF for line endings and avoid safecrlf warnings
git config --global core.autocrlf input
git config --global core.safecrlf false

# Display UTF-8 paths correctly (for Chinese)
git config --global core.quotepath false

# Enable colored output in CLI
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto

# Common aliases
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

# Helper to fetch .gitignore templates from gitignore.io
git config --global alias.ignore '!gi() { curl -sL https://www.gitignore.io/api/$@ ;}; gi'

# Add/commit/push helpers
git config --global alias.acp '!f() { git add . && if [ -n "$1" ]; then git commit -m "$1"; else git commit; fi && git push; }; f'
git config --global alias.ac '!f() { git add . && if [ -n "$1" ]; then git commit -m "$1"; else git commit; fi; }; f'

# Push all remotes
git config --global alias.pushall '!git remote | xargs -L1 git push --all'

git config --global alias.acpa '!f() { git add . && if [ -n "$1" ]; then git commit -m "$1"; else git commit; fi && git remote | xargs -L1 git push; }; f'

printf "Git configuration updated.\n"
