---
title: git command
date: 2022-08-05 16:44:02
tags: 
  - cvs
  - git
categories:
    - 开发工具
---


**全局配置**

```bash
$ git config --global user.name "Name"
$ git config --global user.email "**.com"
$ git config --list
```

**局部仓库配置**

```bash
$ git config  user.name "Name"
$ git config  user.email "**.com"
$ git config --list
```

**常用指令**

- basic command 

  ```bash
    $ git add
    $ git commit
    $ git push
    ```

- 查看日志

  ```bash
  $ git log --pretty=oneline 
  $ git log --oneline
  $ git reflog
  ```

- 版本控制

  ```bash
  $ git reset --hard index
  $ git reset --hard head^^
  $ git reset --hard head~2
  ```

- 分支

  ```bash
  $ git branch -v
  $ git checkout branchName
  $ git branch branchName
  ```

  - 合并

    ```bash
    $ git chekout branchName
    $ git merge branchName
    ```

- 远程push源设置

  ```bash
  $ git remote -v
  $ git remote add origin https:......
  $ gite push origin branchName
  ```

- 克隆拉取

  ```bash
  $ git clone htpps:.....
  pull = fetch + merge
  $ git fetch origin/branchName
  ```
