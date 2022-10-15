---
title: 单发射就不需要issue stage了吧
published: true
---

过段时间就全忘啊。。

verilator模拟的时候出一大堆Read Miss Addr0，这个是正常的，不知道刚开始怎么着就读到地址0了。

新加模块什么的，重新编译要先make clean，现在没时间改进makefile。

要是make clean_all，一定记得在run_func，也就是make的目录下makdir log，创建log文件夹，要不后面不编译了。

verilator要用的内存文件最后在./tmp/ram.dat

Makefile里有这句，不过tmp目录运行完就删除了。

`cat ./tmp/rom.vlog > ./tmp/ram.dat;`   

确认有ram.dat，verilator就能读内存了。刚开始被一堆的Read Miss Addr0给整不会了，以为是内存文件没生成出来。

而且后来读内存的时候，是从1c000000开始读的，但读出来的是0，开始也是以为内存文件的事。


cpu7模块里本来想完全从头写，先只放cpu7_ifu和cpu7_exu，可发现没有tlb和csr模块控制cache，读内存会出问题。

本打算借着这个机会把cache看看，结果先试了把csr和tlb_wrapper加了回来，结果指令取值正常了。

那就先这样吧，一个inst_req要6个还是7个周期才读成功，inst_addr_ok和inst_valid同时返回，还没有看是因为什么。


先在cpu7_ifu里有cpu7_ifu_fdp和cpu7_ifu_dec，取值，解码。

`````c

obj/main.elf:     file format elf32-loongarch
obj/main.elf


Disassembly of section .text:

1c000000 <_start>:
kernel_entry():
1c000000:       0280058c        addi.w  $r12,$r12,1(0x1)
1c000004:       0280098c        addi.w  $r12,$r12,2(0x2)
1c000008:       02800d8c        addi.w  $r12,$r12,3(0x3)
1c00000c:       0280118c        addi.w  $r12,$r12,4(0x4)
1c000010:       0280158c        addi.w  $r12,$r12,5(0x5)
1c000014:       5c000d80        bne     $r12,$r0,12(0xc) # 1c000020 <testbranch>
1c000018:       0280058c        addi.w  $r12,$r12,1(0x1)
1c00001c:       0280058c        addi.w  $r12,$r12,1(0x1)

1c000020 <testbranch>:
testbranch():
1c000020:       028041ad        addi.w  $r13,$r13,16(0x10)
1c000024:       028041ad        addi.w  $r13,$r13,16(0x10)
1c000028:       028041ad        addi.w  $r13,$r13,16(0x10)
1c00002c:       02816805        addi.w  $r5,$r0,90(0x5a)

`````

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-10-13-0.png)

ifu_exu_op是解码的信息，但这里面好想没有imm，看来ifu里面也要搞个cpu7_ifu_imd这样的模块把imm解码出来。

---------------------------------------------------------------------


## issue stage在单发射里就可以不要了

chiplab里有issue stage，是因为后面的功能模块可能被占用，不能2个port同时用。

虽然ALU有两个，port0 port1都可以同时执行alu相关的指令。但浮点，csr模块都只有一个，比如port0执行浮点运算，port1就不能再issue下去了。

这也就是为什么多发射要有issue这样的模块。 在chiplab里，功能模块占用了，有冲突叫做crash。

我现在搞单发射就不需要用issue了。

参考opensparc，sparc_ifu_dec解码模块会解码出不同的信号给如alu，fpu，lsu等不同功能模块的信号。


`````verilog
   // to EXU
   output [2:0]   ifu_exu_aluop_d;// 000 - add/sub
                                  // 001 - and
                                  // 010 - or
                                  // 011 - xor
                                  // 1X0 - movcc
                                  // 1x1 - movr
   output         ifu_exu_invert_d;   // invert rs2 operand
   output         ifu_exu_useimm_d;
   output         ifu_exu_usecin_d;   // use c from icc
   output         ifu_exu_enshift_d;  // turn on shifter

   output         ifu_exu_tagop_d,
                              ifu_exu_tv_d,
                              ifu_exu_muls_d,
                  ifu_exu_ialign_d,
                              ifu_exu_range_check_jlret_d,
                              ifu_exu_range_check_other_d;

   output [2:0] ifu_exu_shiftop_d;  // b2 - 32b(0) or 64b(1)
                                    // b1 - unsigned(0)  or signed(1)
                                    // b0 - left(0) or right(1) shift

   output [4:0] ifu_exu_muldivop_d; // b4 - is_mul
                                    // b3 - is_div
                                    // b2 - 64b if 1, 32b if 0
                                    // b1 - signed if 1, unsigned if 0
                                    // b0 - set cc's

   output       ifu_exu_wen_d;      // write to rd
   output       ifu_exu_setcc_d;    // b0 - write to icc/xcc

   output       ifu_exu_rd_ifusr_e,
                            ifu_exu_rd_exusr_e,
                            ifu_exu_rd_ffusr_e;

   output       ifu_exu_rs1_vld_d,
                            ifu_exu_rs2_vld_d,
                            ifu_exu_rs3e_vld_d,
                            ifu_exu_rs3o_vld_d;

   output       ifu_exu_use_rsr_e_l;

   output       ifu_exu_save_d,
                            ifu_exu_restore_d,
                            ifu_exu_return_d,
                            ifu_exu_flushw_e,
                            ifu_exu_saved_e,
                            ifu_exu_restored_e;

   // to TLU
   output       ifu_tlu_rsr_inst_d,
                            ifu_lsu_wsr_inst_d,
                            ifu_exu_wsr_inst_d,
                            ifu_tlu_done_inst_d,
                            ifu_tlu_retry_inst_d;

   // to LSU 
   output       ifu_lsu_ld_inst_e,   // ld inst or atomic
                            ifu_lsu_st_inst_e,   // store or atomic
                ifu_lsu_pref_inst_e,
                            ifu_lsu_alt_space_e, // alt space -- to be removed
                            ifu_lsu_alt_space_d, // never x -- to be removed
                            ifu_tlu_alt_space_d, // sometimes x but faster
                            ifu_lsu_memref_d;    // alerts lsu of upcoming ldst
//                          ifu_lsu_imm_asi_vld_d;


   output       ifu_lsu_sign_ext_e,
                            ifu_lsu_ldstub_e,
                            ifu_lsu_casa_e,
                            ifu_exu_casa_d,
                            ifu_lsu_swap_e;

   output       ifu_tlu_mb_inst_e,
                            ifu_tlu_sir_inst_m,
                            ifu_tlu_flsh_inst_e;

   output       ifu_lsu_ldst_dbl_e,
                            ifu_lsu_ldst_fp_e;

   output [1:0] ifu_lsu_ldst_size_e;

   // to SPU
//   output     ifu_spu_scpy_inst_e,
//              ifu_spu_scmp_inst_e;

   // to FFU
   output       ifu_ffu_fpop1_d;
   output       ifu_ffu_visop_d;
   output       ifu_ffu_fpop2_d;
   output       ifu_ffu_fld_d;
   output       ifu_ffu_fst_d;
   output       ifu_ffu_ldst_size_d;

   output       ifu_ffu_ldfsr_d,
                            ifu_ffu_ldxfsr_d,
                            ifu_ffu_stfsr_d;
   output       ifu_ffu_quad_op_e;

   // within IFU
   output       dec_fcl_rdsr_sel_pc_d,
                            dec_fcl_rdsr_sel_thr_d;

   output       dec_imd_call_inst_d;

   output       dtu_fcl_flush_sonly_e,
//                dec_fcl_kill4sta_e,
                            dtu_fcl_illinst_e,
                            dtu_fcl_fpdis_e,
                            dtu_fcl_privop_e,
                            dtu_fcl_imask_hit_e,
                            dtu_fcl_br_inst_d,
                            dtu_fcl_sir_inst_e;

   output       dtu_ifq_kill_latest_d;

   // within DTU
   output       dec_swl_wrt_tcr_w,
                            dec_swl_wrtfprs_w,
                            dec_swl_ll_done_d,
                dec_swl_br_done_d,
                            dec_swl_rdsr_sel_thr_d,
                            dec_swl_ld_inst_d,
                            dec_swl_sta_inst_e,
                            dec_swl_std_inst_d,
                            dec_swl_st_inst_d,
                            dec_swl_fpop_d,
                            dec_swl_allfp_d,
                            dec_swl_frf_upper_d,
                            dec_swl_frf_lower_d,
                            dec_swl_div_inst_d,
                            dec_swl_mul_inst_d,
                            wsr_fixed_inst_w,
                            ifu_exu_sethi_inst_d;   // can be sethi or no-op

   output [2:0] dec_dcl_cctype_d;       // 0yy - fcc(yy)
                                        // 100 - icc
                                        // 110 - xcc
                                        // 1X1 - illegal inst!

`````


问题来了，是不是要有个信号表示这条指令到底是发给ALU的运算指令，还是发给LSU的读写指令?

到是没看到这样的信号，但有ifu_exu_wen_d。ALU不管怎么算，最终要写回寄存器才有作用。

`````verilog
   //-------------------
   // Writeback Controls
   //-------------------
   //  write to icc/xcc
   assign ifu_exu_setcc_d = arith_inst &
                             (op3_hi[1] & (~op3[3] | ~op3[1] & ~op3[0]) |
                              op3_hi[2] & (~op3[3] & ~op3[2])); // tagged op
   //  write to rd
   assign ifu_exu_wen_d = ((~rd_00) & brsethi_inst & sethi_or_nop | // sethi
                                 (~rd_00) & arith_inst &  // all single cycle insts
                                 (~op3[5] & ~op3[3]    |     // alu ops
                                              ~op3[5] & op3_lo[8]  |     // addC
                                              ~op3[5] & op3_lo[12] |     // subC
                                              op3_hi[2] &
                                              (~op3[3] & ~op3_lo[4] |    // shft, tag, ~muls
                                               // need to kill if rd to invalid reg
                                               // all vld regs will retn in W stage
                                               op3_lo[8] & ~rs1_0f | op3_lo[10]  | // rd
                             op3_lo[9] | // rdhpr
                                               op3_lo[12] | op3_lo[15])| // mov
                                              op3_hi[3] &
                                              (op3_lo[8]  |    // jmpl
                                               op3_lo[12] |    // save
                                               op3_lo[13] |    // restore
                             op3_lo[6] & int_align_d)  // vis int align
                                              )           |
                                 call_inst);

`````

在sparc_exu_ecl里，信号给进sparc_exu_ecl_wb。

`````verilog
   input        ifu_exu_wen_d;  // instruction in d-stage writes to regfile
   input        ifu_exu_ialign_d;// instruction is alignaddress


   // Writeback control logic
   sparc_exu_ecl_wb writeback(
	...
	.rd_m     (rd_m[4:0]),
        .tid_m    (tid_m[1:0]),
        .thr_m    (thr_m[3:0]),
        .tid_w1   (tid_w1[1:0]),
        .ifu_exu_wen_d(ifu_exu_wen_d),
        .ifu_exu_kill_e(ifu_exu_kill_e),
	...
   );

`````


------------------------------------------------------

还是用chiplab里的alu吧，因为loongarch里好像是有三个操作数的指令？

`````verilog
//alu0
wire [`GRLEN-1:0] alu0_a = ex1_port0_a_lsu_fw ? ex1_lsu_fw_data : ex1_port0_a;
wire [`GRLEN-1:0] alu0_b = ex1_port0_b_lsu_fw ? ex1_lsu_fw_data : ex1_port0_b;
    
alu alu0(   .a          (alu0_a),
            .b          (alu0_b),
            .double_word(ex1_port0_double),
            .alu_op     (ex1_port0_op),
            .c          (ex1_port0_c),
            .Result     (ex1_alu0_res)
        );
`````

