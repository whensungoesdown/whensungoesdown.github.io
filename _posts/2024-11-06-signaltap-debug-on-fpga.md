---
title: Signal Tap II debug on FPGA
published: true
---

并不了解Signal Tap工作原理，把项目下载到FPGA，设置抓取信号和触发条件。

感觉应该是加了一些逻辑在项目里，因为抓波形需要FPGA芯片里的RAM，抓取的信号越多，能抓出来的信号深度"Sample depth"，也就是多少个cycle，就越少。

而且需要项目降低些频率。比如调soc2的时候，本来可以工作在75MHz，但如果加上Signal Tap，运行就不正常，感觉是有些指令完不成。所以就改到25MHz了。

应该在编译后的报告里可以看到，Signal Tap是需要和项目一起编译的。

"Invalid JTAG configuration"这些提示不是说FPGA开发板连不上，而是要编译好项目后在SOF Manager那里点"Program Device"把项目下载到FPGA上才行。

一开始纠结在这里很长时间。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2024-11-06-0.png)


