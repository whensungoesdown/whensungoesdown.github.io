---
title: timer中断发生在branch指令后的下一条指令 
published: true
---

例子就是下面这样，设置好timer，正好在1c000044的时候触发，在beq指令的下一句。

这么测的原因是interrupt和branch都会改pc_bf，看看这俩会不会冲突。


`````c
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

测试结果是确实冲突了，和预期的有点不同，不是interrupt执行了beq后的下一句，而是interrupt没有搞过beq，最终fault_handler没有执行，被beq又把pc_bf改回来了。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2024-06-18-0.png)


图里绿色1c000044是beq后面的addi，可以看到当它进入到pc_f的这个周期，timer中断发生了，红色1c00008c是fault_hander地址，被送入到pc_bf。

而这时黄色的1c000040也在这个周期进入到了pc_d。这句就是beq，因为以前实现的原因，branch会在_d阶段修改pc_bf改变程序流程。不过从图上看是在_e才改变的pc_bf，改成了蓝色的1c000078，也就是dst标签的位置。

刚看了下，记错了，branch是在_e的时候改变pc_bf。

`````c
   assign exu_ifu_brpc_e = bru_ecl_brpc_e;
   assign exu_ifu_br_taken_e = ecl_bru_valid_e & bru_ecl_br_taken_e;
`````


