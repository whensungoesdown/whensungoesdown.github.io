---
title: 看看OpenSparc T1里exu的各模块是怎样安排的
published: true
---

特别是ALU和DIV执行周期不一样，最后Writeback的时候是怎样做的。


``````````verilog
/*
//  Module Name: sparc_exu
//	Description: Execution unit containing register file(IRF),
//			execution control (ECL), ALU, shifting (SHFT).
*/
module sparc_exu (/*AUTOARG*/
   // Outputs
   exu_tlu_wsr_data_m, exu_tlu_va_oor_m, exu_tlu_va_oor_jl_ret_m, 
   exu_tlu_ue_trap_m, exu_tlu_ttype_vld_m, exu_tlu_ttype_m, 
   exu_tlu_spill_wtype, exu_tlu_spill_tid, exu_tlu_spill_other, 
   exu_tlu_spill, exu_tlu_misalign_addr_jmpl_rtn_m, 
   exu_tlu_cwp_retry, exu_tlu_cwp_cmplt_tid, exu_tlu_cwp_cmplt, 
   exu_tlu_cwp3_w, exu_tlu_cwp2_w, exu_tlu_cwp1_w, exu_tlu_cwp0_w, 
   exu_tlu_ccr3_w, exu_tlu_ccr2_w, exu_tlu_ccr1_w, exu_tlu_ccr0_w, 
   exu_spu_rs3_data_e, exu_mul_rs2_data, exu_mul_rs1_data, 
   exu_mul_input_vld, exu_mmu_early_va_e, exu_lsu_rs3_data_e, 
   exu_lsu_rs2_data_e, exu_lsu_priority_trap_m, exu_lsu_ldst_va_e, 
   exu_lsu_early_va_e, exu_ifu_va_oor_m, exu_ifu_spill_e, 
   exu_ifu_regz_e, exu_ifu_regn_e, exu_ifu_oddwin_s, 
   exu_ifu_longop_done_g, exu_ifu_inj_ack, exu_ifu_err_reg_m, 
   exu_ifu_ecc_ue_m, exu_ifu_ecc_ce_m, exu_ifu_cc_d, exu_ifu_brpc_e, 
   exu_ffu_wsr_inst_e, short_so0, short_so1, so0, exu_ifu_err_synd_m, 
   // Inputs
   tlu_exu_rsr_data_m, tlu_exu_priv_trap_m, tlu_exu_pic_twobelow_m, 
   tlu_exu_pic_onebelow_m, tlu_exu_cwpccr_update_m, 
   tlu_exu_cwp_retry_m, tlu_exu_cwp_m, tlu_exu_ccr_m, 
   tlu_exu_agp_tid, tlu_exu_agp_swap, tlu_exu_agp, sehold, se, rclk, 
   mul_exu_data_g, mul_exu_ack, lsu_exu_thr_m, 
   lsu_exu_st_dtlb_perr_g, lsu_exu_rd_m, lsu_exu_ldxa_m, 
   lsu_exu_ldxa_data_g, lsu_exu_ldst_miss_g2, lsu_exu_flush_pipe_w, 
   lsu_exu_dfill_vld_g, lsu_exu_dfill_data_g, ifu_tlu_wsr_inst_d, 
   ifu_tlu_sraddr_d, ifu_tlu_flush_m, ifu_exu_wen_d, 
   ifu_exu_useimm_d, ifu_exu_usecin_d, ifu_exu_use_rsr_e_l, 
   ifu_exu_tv_d, ifu_exu_ttype_vld_m, ifu_exu_tid_s2, ifu_exu_tcc_e, 
   ifu_exu_tagop_d, ifu_exu_shiftop_d, ifu_exu_sethi_inst_d, 
   ifu_exu_setcc_d, ifu_exu_saved_e, ifu_exu_save_d, 
   ifu_exu_rs3o_vld_d, ifu_exu_rs3e_vld_d, ifu_exu_rs3_s, 
   ifu_exu_rs2_vld_d, ifu_exu_rs2_s, ifu_exu_rs1_vld_d, 
   ifu_exu_rs1_s, ifu_exu_return_d, ifu_exu_restored_e, 
   ifu_exu_restore_d, ifu_exu_ren3_s, ifu_exu_ren2_s, ifu_exu_ren1_s, 
   ifu_exu_rd_ifusr_e, ifu_exu_rd_ffusr_e, ifu_exu_rd_exusr_e, 
   ifu_exu_rd_d, ifu_exu_range_check_other_d, 
   ifu_exu_range_check_jlret_d, ifu_exu_pcver_e, ifu_exu_pc_d, 
   ifu_exu_nceen_e, ifu_exu_muls_d, ifu_exu_muldivop_d, 
   ifu_exu_kill_e, ifu_exu_invert_d, ifu_exu_inst_vld_w, 
   ifu_exu_inst_vld_e, ifu_exu_inj_irferr, ifu_exu_imm_data_d, 
   ifu_exu_ialign_d, ifu_exu_flushw_e, ifu_exu_enshift_d, 
   ifu_exu_ecc_mask, ifu_exu_dontmv_regz1_e, ifu_exu_dontmv_regz0_e, 
   ifu_exu_disable_ce_e, ifu_exu_dbrinst_d, ifu_exu_casa_d, 
   ifu_exu_aluop_d, ifu_exu_addr_mask_d, grst_l, ffu_exu_rsr_data_m, 
   arst_l, mux_drive_disable, mem_write_disable, short_si0, 
   short_si1, si0
   ) ;


   bw_r_irf irf(...);

   sparc_exu_byp bypass(...);

   sparc_exu_ecc ecc(...);

   sparc_exu_ecl ecl(...);

   sparc_exu_alu alu(...);

   sparc_exu_shft shft(...);

   sparc_exu_div div(...);

   sparc_exu_rml rml(...);


endmodule // sparc_exu

``````````

在chiplab issue里的东西，应该对应在这的bypass和ecl。

乘法和除法都在div里。

rml是个控制寄存器窗口的，这个和SPARC架构有关。ecc也先不用看。

这里没有一个wb模块，chiplab里的wb_stage似乎也在bypass模块里。从bypass的参数里能看到byp_irf_rd_data_w, byp_irf_rd_data_w2。
还得搞清楚这个w，w2是啥情况。

```````````````verilog
/*
//  Module Name: sparc_exu_byp
//      Description: This block includes the muxes for the bypassing for all
//              3 register outputs.  It also includes the pipeline registers 
//              for the output of the ALU.  All other operands come from
//              outside the bypass block.  Rs1_data chooses between the normal
//              bypassing paths and the PC.  Rs2_data chooses between the normal
//              bypassing paths and the immediate.
*/
```````````````

```
The pipeline stages generally follow this convention:
F - S - D - E - M - W/G - W2
```
