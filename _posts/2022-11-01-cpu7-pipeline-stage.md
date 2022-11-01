---
title: 流水线划分的问题，很多个cycle的长周期指令应该怎么分流水线
published: true
---

以前是用sram，读写都可以1 cycle完成，所以可以很好的放在fetch MEM里，

现在的这个cache操作，不管是inst_valid还是data_addr_ok data_data_ok都要很多个cycle。

LSU里发地址过去是在ex里，但data_addr_ok给回来要5个cycle。而等到data_data_ok又需要5个cycle。

所以现在要搞清楚发地址或者写dcache需要几个cycle，是不是要把计算地址放在EX，把发地址，等读回数据都算做MEM？

--------------------------------------------------

之前提到的bug，pc_x流水线寄存器一直走，IFU被stall了应该停下来准确表示当前指令的问题。

在pc_f2d_reg里加了en，如果IFU stall，pc_d就不更新。再加上之前改的，valid也不进到_d，pippeline里的数据是无效的。


`````verilog
cpu7/IP/myCPU/cpu7_ifu_fdp.v


 130    wire pc_f2d_en = ~exu_ifu_stall_req;                                                                                                                                   
 131                                                                                                                                                                              
 132    dffe_s #(`GRLEN) pc_f2d_reg (                                                                                                                                               
 133       .din (pc_f),                                                                                                                                                             
 134       .clk (clock),                                                                                                                                                           
 135       .q   (pc_d),                                                                                                                                                              
 136       .en  (pc_f2d_en),                                                                                                                                                                
 137       .se(), .si(), .so()); 
`````

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-01-0.png)

红框的地方pc_f被exu_ifu_stall_req stall住了，一直没有传到pc_d，直到这个信号消失。这里将来还有其它的控制信号，比如mul div指令的。

蓝线的是addi指令的，这个没问题，每一步都是1个cycle，也没有IFU stall。

黄线是ld.w指令，这个有问题，因为在EX MEM都花了5个cycle，但pc_e pc_m没有反映出来。

不过这部分要先把上面说的LSU的情况搞清楚以后再改。

下面是测试程序fun_uty2_ld_2，和以前的一样。


`````shell

obj/main.elf:     file format elf32-loongarch
obj/main.elf


Disassembly of section .text:

1c000000 <_start>:
kernel_entry():
1c000000:       14380006        lu12i.w $r6,114688(0x1c000)
1c000004:       028040c6        addi.w  $r6,$r6,16(0x10)
1c000008:       288000c7        ld.w    $r7,$r6,0
1c00000c:       02816805        addi.w  $r5,$r0,90(0x5a)

Disassembly of section .data:

1c000010 <var1>:
var1():
1c000010:       0000005a        0x0000005a

`````
