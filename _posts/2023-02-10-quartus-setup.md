---
title: 装Quartus II 13.1 Web Edition
published: true
---

发现自己前段时间就装了个13.1，现在才想起来之前是用modelsim去跑opensparc里的一个模块。

现在quartus_sh跑不起来，缺so文件。也早忘了以前在我那个dell笔记本上怎么搞的了。

其实也没多麻烦，so文件基本都在quartus/linux64目录下，只是LD_LIBRARY_PATH没有设置，找不到so。

还有就是so的版本号不对，要老的版本，随便复制下改个名就能凑合着用。

在~/.bashrc里加这个就行。

`````shell
export LD_LIBRARY_PATH=/home/u/altera/13.1/quartus/linux64
`````


要想在ubuntu的launcher里加个快捷方式，在/home/u/.local/share/applications目录下创建quartus.desktop

`````shell
[Desktop Entry]
Type=Application
Version=0.9.4
Name=Quartus II 13.1 (64-bit) Web Edition
Comment=Quartus II 13.1 (64-bit)
Icon=/home/u/altera/13.1/quartus/adm/quartusii.png
Exec=/home/u/altera/13.1/quartus/bin/quartus --64bit
Terminal=false
Path=/home/u/altera/13.1
`````

明天还得看看usb blaster能把不能认出来，这个我在blogspot上记录过。


现在打个字是真懒啊。。。。多一点都不想写。
