# git-scripts
我的 git scripts

## acp.sh

### 使用方式：

#### 只推 origin（預設）

```shell
git acp "你的 commit 訊息"
```

功能：

> git add --all  
> git commit -m "你的 commit 訊息"  
> git push -u origin 當前分支  

#### 只推 origin-gitlab

```shell
git acp gitlab "你的 commit 訊息"
```

功能：

> git add --all  
> git commit -m "你的 commit 訊息"  
> git push -u origin-gitlab 當前分支  

#### 同時推 origin 和 origin-gitlab

```shell
git acp all "你的 commit 訊息"
```

功能：

> git add --all  
> git commit -m "你的 commit 訊息"  
> git push -u origin-gitlab 當前分支 
> git push -u origin 當前分支

## ac.sh

### 使用方式：

#### 只 commit

```shell
git ac "你的 commit 訊息"
```

功能：

> git add --all  
> git commit -m "你的 commit 訊息"  

## pl.sh

### 使用方式：

#### 拉取最新的變更

```shell
git pl
```

功能：

> git pull `當前遠端儲存庫名稱` `當前分支名稱`

## ph.sh

### 使用方式：

#### 推送本地變更

```shell
git ph
```

功能：

> git push `當前遠端儲存庫名稱` `當前分支名稱`

## 在 ~/.gitconfig 中加入以下設定：

```shell
[alias]
   acp = "!~/git-scripts/acp.sh"
   ac = "!~/git-scripts/ac.sh"
   pl = "!~/git-scripts/pl.sh"
   ph = "!~/git-scripts/ph.sh"