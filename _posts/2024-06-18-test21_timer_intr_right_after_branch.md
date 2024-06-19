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

`````verilog
   assign exu_ifu_brpc_e = bru_ecl_brpc_e;
   assign exu_ifu_br_taken_e = ecl_bru_valid_e & bru_ecl_br_taken_e;
`````

branch也得在_d里取寄存器。

在_e中计算出两个操作数比较的结果，然后改变pc_bf的值，同时设置kill_d，这时候在_d里的指令因为inst_vld_d和对应的xxx_dispatch_d设为0，所有这条指令进入到_e也不会产生结果。


`````verilog
   wire inst_vld_d;
   wire kill_d;



   assign kill_d = (ecl_bru_valid_e & bru_ecl_br_taken_e); // if branch is taken, kill the instruction at the pipeline _d stage.

   assign inst_vld_d = ifu_exu_valid_d & (~kill_d);



   //main
   assign alu_dispatch_d  = !ifu_exu_op_d[`LSOC1K_LSU_RELATED] && !ifu_exu_op_d[`LSOC1K_BRU_RELATED] && !ifu_exu_op_d[`LSOC1K_MUL_RELATED] && !ifu_exu_op_d[`LSOC1K_DIV_RELATED] && !ifu_exu_op_d[`LSOC1K_CSR_RELATED] && inst_vld_d; // && !port0_exception; // alu0 is binded to port0
   assign lsu_dispatch_d  = ifu_exu_op_d[`LSOC1K_LSU_RELATED] && inst_vld_d; // && !port0_exception;
   assign bru_dispatch_d  = ifu_exu_op_d[`LSOC1K_BRU_RELATED] && inst_vld_d; // && !port0_exception;
   assign mul_dispatch_d  = ifu_exu_op_d[`LSOC1K_MUL_RELATED] && inst_vld_d; // && !port0_exception;
   assign div_dispatch_d  = ifu_exu_op_d[`LSOC1K_DIV_RELATED] && inst_vld_d; // && !port0_exception;
   assign none_dispatch_d = (ifu_exu_op_d[`LSOC1K_CSR_RELATED] || ifu_exu_op_d[`LSOC1K_TLB_RELATED] || ifu_exu_op_d[`LSOC1K_CACHE_RELATED]) && inst_vld_d; // || port0_exception ;
   assign ertn_dispatch_d = ifu_exu_op_d[`LSOC1K_ERET] && inst_vld_d;

`````

所以branch上次在cpu6里就是最慢的指令，这次估计也是。因为要做算术运算比较操作数大小，还要在同一个周期里通过mux去改变pc_bf的值。

这次cpu7b运行100Mhz的时候，显示器上图像小恐龙是有，但是小恐龙不会移动，估计就是branch指令太慢没运行完。

上次cpu6里打飞机光标会横着移出屏幕去，感觉也是branch指令结果错了。

cpu6最多运行25Mhz，branch还有时会出错。cpu7b可以运行在75Mhz，对我这样的初级水平，编码的指令对运行速度的影响还是很大。

后面还是要学习下工具，运行在更高频率上让工具分析出时间违例的地方来。


--------------------------------------------------------------------------------------------


想了想，现在这个bug不好改。这种情况需要先把branch要跳转的地址存起来，并且把确定要跳转的标志位也存起来。

这样也就是把branch指令分成了两条指令，类似iop或微指令。第一条比较两个操作数，并把跳转地址和跳转标志分别存入寄存器。
第二条，在现在的情况下没有指令，但是在pc_bf的mux里，有一项选择时通过跳转标志选择跳转地址。

这样把branch分开了，对时序也好，因为pc_bf mux放在下一个周期了。

第一条指令设置kill_d，这样pipe里下一条指令也不会执行。

但这样还是有问题，timer intr发生的当个周期，就改变了pc_bf，而这时branch指令才走到_d，这时候跳转地址和跳转标志都还没有生成。
era记录的是pc_f，本打算通过era记录跳转地址寄存器里的值来实现走branch正确的路径，现在看来还不行。

----------------------------------------------------------------------------------------------

看来，中断发生时，也许可以flash _d _e，并且era记录pc_e的地址。中断处理返回时重新从当时_e的指令开始执行。

现在还没实现flash _e的功能，这个bug先留着不改，先看看别的大项目里是怎么处理的。interrupt和exception都是怎样处理的，什么时机。


同时，可以测下一些mcu和cpu，用decrementer或者incrementer定时器定个短时间的，正好在跳转指令前后触发，看看会出什么情况。

记得cortex-m3里就有个errta是说从中断返回出来的后3条指令还是执行在高权限。


-----------------------------------------------------------------------------------------------

感觉architecture里有eflags，cr寄存器这种还是有道理。

power里是只要写一种目的寄存器就会被解码成一个iop。比如一条指令里既写通用寄存器GPR又设置标志寄存器CR，那这条指令应该是被分成两个iop。还不确定，感觉是这样。

