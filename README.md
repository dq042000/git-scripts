# git-scripts

我的 git scripts

## acp.sh

### 使用方式：

#### 只推 origin (預設)

```shell
git acp "你的 commit 訊息"
```

或

```shell
git acp
```

- 若有輸入 commit 訊息：
  > git add --all\
  > git commit -m "你的 commit 訊息"\
  > git push -u origin 當前分支
- 若沒輸入 commit 訊息：
  > git add --all\
  > git commit (進入互動式編輯)\
  > git push -u origin 當前分支

#### 只推 origin-gitlab

```shell
git acp gitlab "你的 commit 訊息"
```

或

```shell
git acp gitlab
```

- 若有輸入 commit 訊息：
  > git add --all\
  > git commit -m "你的 commit 訊息"\
  > git push -u origin-gitlab 當前分支
- 若沒輸入 commit 訊息：
  > git add --all\
  > git commit (進入互動式編輯)\
  > git push -u origin-gitlab 當前分支

#### 同時推 origin 和 origin-gitlab

```shell
git acp all "你的 commit 訊息"
```

或

```shell
git acp all
```

- 若有輸入 commit 訊息：
  > git add --all\
  > git commit -m "你的 commit 訊息"\
  > git push -u origin-gitlab 當前分支\
  > git push -u origin 當前分支
- 若沒輸入 commit 訊息：
  > git add --all\
  > git commit (進入互動式編輯)\
  > git push -u origin-gitlab 當前分支\
  > git push -u origin 當前分支

## ac.sh

### 使用方式：

```shell
git ac "你的 commit 訊息"
```

或

```shell
git ac
```

- 若有輸入 commit 訊息：
  > git add --all\
  > git commit -m "你的 commit 訊息"
- 若沒輸入 commit 訊息：
  > git add --all\
  > git commit (進入互動式編輯)

## pl.sh

### 使用方式：

```shell
git pl
```

功能：

> git pull `當前遠端儲存庫名稱` `當前分支名稱`

## ph.sh

### 使用方式：

```shell
git ph
```

功能：

> git push `當前遠端儲存庫名稱` `當前分支名稱`

## 在 \~/.gitconfig 中加入以下設定：

```shell
[alias]
   acp = "!~/git-scripts/acp.sh"
   ac = "!~/git-scripts/ac.sh"
   pl = "!~/git-scripts/pl.sh"
   ph = "!~/git-scripts/ph.sh"
```