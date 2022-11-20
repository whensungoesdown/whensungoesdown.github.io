---
title: 流水线和data byp
published: true
---

现在的问题是cache miss的时候，每2个cycle取指一次。

以前cpu6都是一个cycle一条指令，所以在做data forwarding的时候没想那么多。


因为读寄存器是在_d，所以_e要把alu的数据前递给_d。而_m时lsu要把load的数据给_d。

而如果时2个cycle fetch一个指令，拿alu来说，在_e时，下一条指令还没有到_d，也就是还没有读寄存器，所以没法前递。

需要到_m时，下一条指令才到_d。


_d   _e(alu)   _m(lsu)
^_______|         |
^________________|


比如下面这个例子，在2 cycle fetch一条指令的时候，func_uty1_ld。

`````asm
obj/main.elf:     file format elf32-loongarch
obj/main.elf


Disassembly of section .text:

1c000000 <_start>:
kernel_entry():
1c000000:       14380006        lu12i.w $r6,114688(0x1c000)
1c000004:       028030c6        addi.w  $r6,$r6,12(0xc)
1c000008:       288000c5        ld.w    $r5,$r6,0

Disassembly of section .data:

1c00000c <var1>:
var1():
1c00000c:       0000005a        0x0000005a

`````

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-21-0.png)

当第一条指令到_e，alu的result已经是1c000000了，而_d阶段pc_d显示当前ip还是1c000000。


