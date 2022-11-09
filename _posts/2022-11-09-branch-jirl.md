---
title: branch指令里的jirl
published: true
---


![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-09-0.png)

jirl主要就是把pc+4的值存到rd寄存器里，而且寻址也不是pc+offs，而是[rj]+offs。

在实现上，就相当于branch指令和ALU指令的结合。

既需要跳转，又需要算出地址并写回到rd指定的寄存器里。

`````verilog
 526    wire rddata_sel_alu_res_m_l;                                                                                                           
 527    wire rddata_sel_lsu_res_m_l;                                                                                                               
 528    wire rddata_sel_bru_res_m_l;                                                                                                                 
 529                                                                                                                                           
 530    assign rddata_sel_alu_res_m_l = (lsu_ecl_rdata_valid_m | bru_wen_m); // default is alu resulst if no other module claims it            
 531    assign rddata_sel_lsu_res_m_l = ~lsu_ecl_rdata_valid_m;                                                                                
 532    assign rddata_sel_bru_res_m_l = ~bru_wen_m;                                                                                               
 533                                                                                                                                               
 534    dp_mux3ds #(`GRLEN) rd_data_mux(.dout  (rd_data_m),                                                                                          
 535                           .in0   (alu_ecl_res_m),                                                                                              
 536                           .in1   (lsu_ecl_rdata_m),                                                                                          
 537                           .in2   (bru_link_pc_m),                                                                                               
 538                           .sel0_l (rddata_sel_alu_res_m_l),                                                                                  
 539                           .sel1_l (rddata_sel_lsu_res_m_l),                                                                                
 540                           .sel2_l (rddata_sel_bru_res_m_l)); 
`````

bru在_e返回bru_link_pc_e，就是pc+4，在ecl里，其实应该放在byp，经过流水线寄存器变成bru_link_pc_m。

和lsu返回的读的数据，还有ALU算出的结果，在_m时3选1。

alu最开始没有设置个alu_vld这样的信号，所以现在是lsu，bru没有返回结果的时候就默认是alu。

其实可以用alu_dispatch，以后有其它指令需要改这里的时候再说了。


`````verilog
 495    // set the wen if any module claims it                                                                                                     
 496    assign wen_m = rf_wen_m | (lsu_ecl_wen_m & lsu_ecl_rdata_valid_m) | bru_wen_m;                                                          
 497                                                                                                                                               
 498    dff_s #(1) wen_m2w_reg (                                                                                                               
 499       .din (wen_m),                                                                                                                       
 500       .clk (clk),                                                                                                                          
 501       .q   (wen_w),                                                                                                                        
 502       .se(), .si(), .so());                                                                                                                
 503                                                                                                                                           
 504    assign ecl_irf_wen_w = wen_w;
`````

wen的设置好像opensparc里有例子，应该先学学。

--------------------------------------------------------------

用个简单的例子测试下，func_uty5_jirl。

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
1c000014:       028200a5        addi.w  $r5,$r5,128(0x80)

1c000018 <skip>:
skip():
1c000018:       028040a5        addi.w  $r5,$r5,16(0x10)
1c00001c:       028040a5        addi.w  $r5,$r5,16(0x10)
1c000020:       028040a5        addi.w  $r5,$r5,16(0x10)

`````

jirl用$r6里的值+0x18，跳转到1c000018，同时$r1里存pc+4，也就是1c000014。

`````shell
Read Miss For Addr0.
Read Miss For Addr0.
Read Miss For Addr0.
[0000000544ns] mycpu : pc = 1c000000,  reg = 06, val = 1c000000
[0000000556ns] mycpu : pc = 1c000004,  reg = 05, val = 0000000a
[0000000568ns] mycpu : pc = 1c000008,  reg = 05, val = 0000001a
[0000000580ns] mycpu : pc = 1c00000c,  reg = 05, val = 0000002a
[0000000592ns] mycpu : pc = 1c000010,  reg = 01, val = 1c000014
[0000000616ns] mycpu : pc = 1c000018,  reg = 05, val = 0000003a
[0000000628ns] mycpu : pc = 1c00001c,  reg = 05, val = 0000004a
[0000000640ns] mycpu : pc = 1c000020,  reg = 05, val = 0000005a
total clock is 995
uty: test golden_trace->reg[5]: 5a

Terminated at 2004 ns.
Test exit.
Time limit exceeded.
total time is 332752 us
Test case passed!
**************************************************
*                                                *
*      * * *       *        * * *     * * *      *
*      *    *     * *      *         *           *
*      * * *     *   *      * * *     * * *      *
*      *        * * * *          *         *     *
*      *       *       *    * * *     * * *      *
*                                                *
**************************************************

make[1]: Leaving directory '/home/u/prjs/cpu7/sims/verilator/run_func/tmp'
`````
