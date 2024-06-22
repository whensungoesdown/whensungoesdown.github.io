---
title: 处理exception interrupt的时机
published: true
---

纠结在流水线的什么阶段处理exception和interrupt。

interrupt可以算做是exception的一种，在loogarch里interrupt是exception cdoe的里的一个，处理函数入口点是同一个，eentry。

但本质的不同是interrupt是async，任意时间都可以发生的。exception看作是同步的，但在流水线的不同阶段是有不同种类的异常。

比如illegal instruction是在decode阶段，ale是在_e计算地址的时候。

具体在流水线哪个阶段处理，这是个需要搞清楚的问题。

大改了解了其它的代码，应该是在completion或者说指令retire，commit的时候，看看指令有没有exception。exception code也是跟着指令一起通过流水线。

这说的是乱序的核。

顺序核的话就是_w的阶段，在这里处理exception，包括interrupt，最主要的问题就是流水线前面所有的指令都要刷掉。但如果流水线里有store指令，在进入到_w之前就已经写内存了，没有办法取消了。如果是流水线只要产生exception或有interrupt就设置标志位让后面已经进到pipeline的store指令不写内存，这样似乎是可以，但感觉有点奇怪。因为这样等同于stall fetch，然后刷新pipeline里的其它指令，并且让当前指令顺着pipeline走到_w再去处理。那为什么不马上处理呢？


所以现在的想法是，在_e的时候处理exception和interrupt。因为指令到_e，就一定是branch走对了的指令。进eentry的时候，era里存的也是pc_e的值，等ertn的时候从之前_e的指令重新执行。

如果是decode的exception，比如illegal instruction，exception code跟着pipeline到_e的地方处理。

如果是store或load指令出异常，比如页面不存在，这种虽然可能在_m，但因为stall了fetch，所以pipeline里并没有其它指令，也可以马上处理，只是era里要存什么还要到时候想清楚。



----------------------------------

这种方式解决了前面说的test21_timer_intr_right_after_branch里的bug。

加了kill_e，在exu_ifu_except的时候exu里kill_d， kill_e。

在ifu里加了kill_f。其实以前就有kill_f的功能，只是没这么叫。

`````verilog
   wire kill_f;

   assign kill_f = exu_ifu_stall_req | br_taken | exu_ifu_except | exu_ifu_ertn_e;

   assign fdp_dec_valid = inst_valid_f & (~kill_f); // pc_f shoudl not be passed to pc_d if a branch is taken at _e.

`````
有exception的时候kill_f kill_d kill_e把这部分的pipeline刷掉。cpu7b里不是用pipeline里nop泡泡的方法，二是学的opensparc里的kill_x的方式。

一个cycle的kill_x信号让当前阶段的指令不会传递到pipeline的下一阶段，或者不起作用，比如alu操作的alu_wen_e不传递到alu_wen_m。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2024-06-22-0.png)

黄框种，当exu_ifu_except为1时，kill_f kill_d kill_e全部置1。导致当前的1c00003c，和后面的1c000040，1c000044全部都没有执行。虽然这几个地址看着是进到pc_e里了，但实际上没有起作用。

比如红框里的1c000040，也就是beq指令，后面进到了pc_e，但由于上两个cycle的kill_d对应的是这条指令，所以后面划红线的ecl_bru_valid_e没有置1，这条指令没有起作用。


`````assembly
Disassembly of section .text:

1c000000 <_start>:
kernel_entry():
1c000000:	14380006 	lu12i.w	$r6,114688(0x1c000)
1c000004:	028230c6 	addi.w	$r6,$r6,140(0x8c)
1c000008:	04003026 	csrwr	$r6,0xc
1c00000c:	02802805 	addi.w	$r5,$r0,10(0xa)
1c000010:	02801006 	addi.w	$r6,$r0,4(0x4)
1c000014:	04000026 	csrwr	$r6,0x0
1c000018:	02804406 	addi.w	$r6,$r0,17(0x11)
1c00001c:	04010426 	csrwr	$r6,0x41
1c000020:	02800005 	addi.w	$r5,$r0,0
1c000024:	02800000 	addi.w	$r0,$r0,0
1c000028:	02800000 	addi.w	$r0,$r0,0
1c00002c:	02800000 	addi.w	$r0,$r0,0
1c000030:	02800000 	addi.w	$r0,$r0,0
1c000034:	02800000 	addi.w	$r0,$r0,0
1c000038:	02800000 	addi.w	$r0,$r0,0
1c00003c:	02800000 	addi.w	$r0,$r0,0
1c000040:	58003800 	beq	$r0,$r0,56(0x38) # 1c000078 <dst>
1c000044:	0283fc05 	addi.w	$r5,$r0,255(0xff)
1c000048:	02800000 	addi.w	$r0,$r0,0
1c00004c:	02800000 	addi.w	$r0,$r0,0
1c000050:	02800000 	addi.w	$r0,$r0,0
1c000054:	02800000 	addi.w	$r0,$r0,0
1c000058:	02800000 	addi.w	$r0,$r0,0
1c00005c:	02800000 	addi.w	$r0,$r0,0
1c000060:	02800000 	addi.w	$r0,$r0,0
1c000064:	02800000 	addi.w	$r0,$r0,0
1c000068:	02800000 	addi.w	$r0,$r0,0
1c00006c:	02800000 	addi.w	$r0,$r0,0
1c000070:	02800000 	addi.w	$r0,$r0,0
1c000074:	02800000 	addi.w	$r0,$r0,0

1c000078 <dst>:
dst():
1c000078:	0280a8a5 	addi.w	$r5,$r5,42(0x2a)
1c00007c:	02800000 	addi.w	$r0,$r0,0
1c000080:	02800000 	addi.w	$r0,$r0,0
1c000084:	02800000 	addi.w	$r0,$r0,0
1c000088:	02800000 	addi.w	$r0,$r0,0

1c00008c <fault_handler>:
fault_handler():
1c00008c:	0280040b 	addi.w	$r11,$r0,1(0x1)
1c000090:	0401102b 	csrwr	$r11,0x44
1c000094:	0280c0a5 	addi.w	$r5,$r5,48(0x30)
1c000098:	06483800 	ertn
1c00009c:	02800000 	addi.w	$r0,$r0,0
1c0000a0:	02800000 	addi.w	$r0,$r0,0
1c0000a4:	02800000 	addi.w	$r0,$r0,0
`````

