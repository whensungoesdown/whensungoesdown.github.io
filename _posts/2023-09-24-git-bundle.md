---
title: 只有.git目录 怎样把代码提取出来
published: true
---

网上看到的，在.git同目录下

`````shell
# 创建bundle文件
git bundle create ./reponame.bundle --all
# 从bundle文件中clone出代码
git clone ./reponame.bundle reponame
# 接下来文件夹内会出现一个 reponame 文件夹，这个文件夹内就是所有的代码文件
`````

https://www.jianshu.com/p/92125cc920e1
