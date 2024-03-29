---
title: 加test case
published: true
---

先复制份代码。

`````shell
u@unamed:~/prjs/cpu7/software/func/$ cp -r func_uty0/ func_uty1_ld
`````

代码不在这里编译。

现在configure.sh里加上func/func_uty1_ld

`````shell
        func/func_advance)
            RUN_FUNC=y
            mkdir -p ./obj/func
            mkdir -p ./log/func
            ;;
        func/func_uty0)
            RUN_FUNC=y
            mkdir -p ./obj/func
            mkdir -p ./log/func
            ;;
        func/func_uty1_ld)
            RUN_FUNC=y
            mkdir -p ./obj/func
            mkdir -p ./log/func
            ;;
        my_program)
            RUN_FUNC=n
            RUN_C=y
            mkdir -p ./obj/
            mkdir -p ./log/
            ;;

`````

然后在run_func里编译。

`````shell
u@unamed:~/prjs/cpu7/sims/verilator/run_func$ ./configure.sh -run func/func_uty1_ld --disable-trace-comp
u@unamed:~/prjs/cpu7/sims/verilator/run_func$ make clean
u@unamed:~/prjs/cpu7/sims/verilator/run_func$ make soft
`````

测下ld指令。


`````shell
#include "asm.h"
#include "regdef.h"
#include "cpu_cde.h"


##s0, number
##s1, number adress 
##s2, exception use
##s3, score
##s4, exception pc
        .globl  _start
        .globl  start
        .globl  __main
_start:
start:
    lu12i.w $r6, 0x1c000
    addi.w  $r6, $r6, 0x0c
    ld.w $r5, $r6, 0x0
#    addi.w $r5, $r0, 0x5a

.data

var1:   .word   0x5a

`````

`````shell
obj/func/func_uty1_ld_obj/obj/test.s


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

结果是这样，lu12i指令看来没问题。因为现在还是取值7个cycle，所以就算这里没byp，相邻两条指令也没事。。。

````shell
Read Miss For Addr0.
Read Miss For Addr0.
Read Miss For Addr0.
[0000000544ns] mycpu : pc = 1c000000,  reg = 06, val = 1c000000
[0000000556ns] mycpu : pc = 1c000004,  reg = 06, val = 1c00000c
[0000000568ns] mycpu : pc = 1c000008,  reg = 05, val = 00000000
total clock is 995
uty: test golden_trace->reg[5]: 0

Terminated at 2004 ns.
Test exit.
Time limit exceeded.
total time is 327411 us
Test case failed!
**************************************************
*                                                *
*      * * *       *         ***      *          *
*      *          * *         *       *          *
*      * * *     *   *        *       *          *
*      *        * * * *       *       *          *
*      *       *       *     ***      * * *      *
*                                                *
**************************************************
````

有个奇怪的问题就是为什么lui指令要叫lu12i，而实际操作数是20 bits的imm。



![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-10-26-0.png)

看时序发现些问题。

红色的data_pc，应该是填这条ld指令的pc。黄色圈里是ifu_fdp里保存的各个pc，但这个假设是每个cycle pc向后递增。

这里没考虑branch，也没考虑stall。pc似乎不方便从头到尾记录在ifu_fdp里，而且可能exu后面也不需要每个阶段都保留pc。

不过在发data_req时，data_pc是1c000008，是对的。

现在没有读到结果，不知道是不是蓝框里的这几个信号给的不对。


做下对比，下面是chiplab运行同一个testcase。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-10-26-1.png)

res_valid从来都是0，这个很奇怪，因为res_valid还是个reg，这块逻辑有点乱，所以从来没有1过。

关键不同的地方就是data_recv这个信号和我之前的不同。


![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-10-26-2.png)

现在把res_valid这个dff改成一直是0，结果data_recv多高了一个cycle，结果就能读数据了。

现在需要搞清res_valid，lsu_res_valid，data_recv的意义和之间的逻辑，要简化这部分。chiplab这块好像是碰巧了，要不res_valid寄存器一直是0没有意义。

----------------------------------------------------------

现在要把lsu和alu的结果做个选择然后写到regfile里。

`````verilog
exu/rtl/sparc_exu_byp.v

   // Mux for rd_data_m between ALU and load data and ECC result and restore result
   mux4ds #(64) rd_data_m_mux(.dout(byp_irf_rd_data_m[63:0]),
                              .in0(full_rd_data_m[63:0]),
                              .in1(dfill_data_g2[63:0]),
                              .in2(ecc_byp_ecc_result_m[63:0]),
                              .in3(restore_rd_data[63:0]),
                              .sel0(ecl_byp_sel_pipe_m),
                              .sel1(ecl_byp_sel_load_m),
                              .sel2(ecl_byp_sel_ecc_m),
                              .sel3(ecl_byp_sel_restore_m));
`ifdef FPGA_SYN_CLK_DFF
   dffe_s #(64) dff_rd_data_m2w(.din(byp_irf_rd_data_m[63:0]), .en (~(sehold)), .clk(clk), .q(byp_irf_rd_data_w[63:0]),
                           .se(se), .si(), .so());
`else
   dff_s #(64) dff_rd_data_m2w(.din(byp_irf_rd_data_m[63:0]), .clk(sehold_clk), .q(byp_irf_rd_data_w[63:0]),
                           .se(se), .si(), .so());
`endif

`````

这种控制信号都是先从lsu alu进到ecl，再给出到byp。

bypass相当于exu里的data path了。

`````verilog
exu/rtl/sparc_exu_ecl_wb.v

   ///////////////////
   // W1 port control
   ///////////////////
   // sehold will turn off in pipe writes and put the hold functionality through
   // the non inst_vld part
   // Mux between load and ALU for rd, thr, and wen
   assign      ecl_byp_sel_load_m = ~(wb_m | wrsr_m | ecl_byp_sel_ecc_m) & ld_g2;
   assign      ecl_byp_sel_pipe_m = (wb_m | wrsr_m) & ~ecl_byp_sel_ecc_m;
   assign      ecl_byp_sel_restore_m = ~(wb_m | wrsr_m | ld_g2 | ecl_byp_sel_ecc_m);
   assign      wen_no_inst_vld_m = (sehold)? ecl_irf_wen_w:
                                             ((dfill_vld_g2 & ecl_byp_sel_load_m) |
                                              (ecl_byp_sel_restore_m & restore_wen));
   dff_s dff_lsu_wen_m2w(.din(wen_no_inst_vld_m), .clk(clk), .q(wen_no_inst_vld_w), .se(se), .si(),
                       .so());

`````

------------------------------------------

lsu_res_valid的意思，估计是resource valid，不是result valid。

我这里改成result valid，表示lsu resource 可用的，以后在说，反正现在是顺序core。
