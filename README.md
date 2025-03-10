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

## 在 ~/.gitconfig 中加入以下設定：

```shell
[alias]
   acp = "!~/git-scripts/acp.sh"
```

## ac.sh

### 使用方式：

#### 只 commit

```shell
git ac "你的 commit 訊息"
```

功能：

> git add --all  
> git commit -m "你的 commit 訊息"  