---
title: inst memory interface里的inst_cancel信号
published: true
---

这个信号过了很久就忘了干什么用的了。

等以后自己写cache了就能换掉这些icache dcache的memory interface了。

`````verilog
 188    // when branch taken, inst_cancel need to be signal                                                                                      
 189    // so that the new target instruction can be fetched instead of the one previously requested                                               
 190    assign inst_cancel = br_taken; 
`````

当跳转发生的时候signal inst_cancel，就是下面这样，取指令的时间更久了。

![screenshot1](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-09-1.png)

但如果去掉这句，不signal inst_cancel，就是下面这样。

取指令时间没有变，但取出来的指令并不是跳转以后的新地址处的指令，而是跳转指令顺序下一条的指令。

还是之前发处的取值指令。

![screenshot2](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-09-2.png)

`````asm

obj/main.elf:     file format elf32-loongarch
obj/main.elf


Disassembly of section .text:

1c000000 <_start>:
kernel_entry():
1c000000:       14380006        lu12i.w $r6,114688(0x1c000)
1c000004:       02802805        addi.w  $r5,$r0,10(0xa)
1c000008:       028040a5        addi.w  $r5,$r5,16(0x10)
1c00000c:       028040a5        addi.w  $r5,$r5,16(0x10)
1c000010:       4c0018c1        jirl    $r1,$r6,24(0x18)
1c000014:       028200a5        addi.w  $r5,$r5,128(0x80)    <--

1c000018 <skip>:
skip():
1c000018:       028040a5        addi.w  $r5,$r5,16(0x10)
1c00001c:       028040a5        addi.w  $r5,$r5,16(0x10)
1c000020:       028040a5        addi.w  $r5,$r5,16(0x10)

`````
