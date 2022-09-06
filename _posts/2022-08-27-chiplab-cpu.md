---
title: chiplab pipeline moudle
published: true
---

ifu里先去掉所有和分支预测有关的信号，只剩下三组信号需要处理。

cpu读取指令的信号 inst_

后面传回的跳转地址 br_

给后一级decode的信号，o_port0_

chiplab里是有三个port的，为了简单，ifu只能单发射，虽然接口没有变，但只有port0有效。


NONE0是什么种类的指令？

在ex1_stage里

`````verilog
wire [`GRLEN-1:0]   ex1_none0_result;
wire [`GRLEN-1:0]   ex1_none1_result;
wire                ex1_none0_exception;
wire                ex1_none1_exception;
wire [`GRLEN-1:0]   ex1_none0_csr_result;
wire [`GRLEN-1:0]   ex1_none1_csr_result;
wire [`GRLEN-1:0]   ex1_none0_csr_a;
wire [`GRLEN-1:0]   ex1_none1_csr_a;
`````

可以看到exception，cache，tlb，csr相关的指令都走NONE。


      +-------------------------------------------------------+
      |      cpu7_ifu_fdp cpu7_ifu                            |
      |                                                       |
      |                                       .inst_req       |
      |                                       .inst_addr      |
      |                                       .inst_cancel    |
      |                                       .inst_addr_ok   |
      |                                       .inst_valid     |
      |    .o_allow                           .inst_count     |
      |    .o_valid                           .inst_rdata     |
      |    .o_port0_pc                        .inst_uncache   |
      |    .o_port0_inst                      .inst_ex        |
      |    .o_port0_taken                     .inst_exccode   |
      |    .o_port0_target                                    |
      |    .o_port0_ex                                        |
      |    .o_port0_exccode                   .br_cancel      |
      |    .o_port0_hint                      .br_target      |
      |                                                       |
      +-------------------------------------------------------+
            | |     |
            | | ... |
            | |     |
            | |     |
     +-------------------------------------------------------+
     |           lsoc1000_stage_de de_stage                  |
     |                                                       |
     |     .de_port0_valid                                   |
     |     .de_port0_pc                                      |
     |     .de_port0_inst                                    |
     |     .de_port0_br_target                               |
     |     .de_port0_br_taken                                |
     |     .de_port0_exception                               |
     |     .de_port0_exccode                                 |
     |     .de_port0_hint                                    |
     |                                                       |
     |                                                       |
     |                                                       |
     |                                                       |
     |     // pipe out                                       |
     |     .is_allow_in                                      |
     |     // port0                                          |
     |     .is_port0_valid                                   |
     |     .is_port0_inst                                    |
     |     .is_port0_pc                                      |
     |     .is_port0_op                                      |
     |     .is_port0_br_target                               |
     |     .is_port0_br_taken                                |
     |     .is_port0_exception                               |
     |     .is_port0_exccode                                 |
     |     .is_port0_hint                                    |
     |     .is_port0_rf_wen                                  |
     |     .is_port0_rf_target                               |
     |                                                       |
     +-------------------------------------------------------+
            | |     |
            | | ... |
            | |     |
            | |     |
     +-----------------------------------------------------------------------------------------------------------------------------------------+
     |         lsoc1000_stage_issue is_stage                                                                                                   |
     |                                                                                                                                         |
     |     // port0                                                                                                                            |
     |     .is_port0_valid                                                                                                                     |
     |     .is_port0_pc                                                                                                                        |
     |     .is_port0_inst                                                                                                                      |
     |     .is_port0_op                                                                                                                        |
     |     .is_port0_br_target                                                                                                                 |
     |     .is_port0_br_taken                                                                                                                  |
     |     .is_port0_exception                                                                                                                 |
     |     .is_port0_exccode                                                                                                                   |
     |     .is_port0_hint                                                                                                                      |
     |     .is_port0_rf_wen                                                                                                                    |
     |     .is_port0_rf_target                                                                                                                 |
     |                                                                                                                                         |
     |                                                                                                                               // port0  |
     |                                                                                                                               .raddr0_0 |
     |                                                                                                                               .raddr0_1 |
     |                                                                                                                               .rdata0_0 |
     |                                                                                                                               .rdata0_1 |
     |                                                                                                                                         |
     |                                                                                                                                         |
     |                                                                                                                                         |
     |                                                                                                                                         |
     |                                                                                       //BRU                                             |
     |                                                                                       .bru_delay                                        |
     |                                                                                       .ex1_bru_delay                                    |
     |                                                                                       .ex1_bru_op                                       |
     |   // pipe out                                                                         .ex1_bru_a                                        |
     |   .ex1_allow_in                                                                       .ex1_bru_b                                        |
     |   .ex2_allow_in                                                                       .ex1_bru_br_taken                                 |
     |   // port0                                                                            .ex1_bru_br_target                                |
     |   .ex1_port0_inst         //ALU1                                                      .ex1_bru_hint            //NONE0                  |
     |   .ex1_port0_pc           .ex1_port0_a                                                .ex1_bru_link            .ex1_none0_result        |
     |   .ex1_port0_src          .ex1_port0_b                                                .ex1_bru_jrra            .ex1_none0_exception     |
     |   .ex1_port0_valid        .ex1_port0_op                                               .ex1_bru_brop            .ex1_none0_csr_addr      |
     |   .ex1_port0_rf_target    .ex1_port0_c                           //LSU                .ex1_bru_jrop            .ex1_none0_op            |
     |   .ex1_port0_rf_wen       .ex1_port0_a_ignore    //MDU           .ex1_lsu_op          .ex1_bru_offset          .ex1_none0_exccode       |
     |   .ex1_port0_ll           .ex1_port0_b_ignore    .ex1_mdu_op     .ex1_lsu_base        .ex1_bru_pc              .ex1_none0_csr_a         |
     |   .ex1_port0_sc           .ex1_port0_b_get_a     .ex1_mdu_a      .ex1_lsu_offset      .ex1_bru_port            .ex1_none0_csr_result    |
     |   .ex1_port0_type         .ex1_port0_double      .ex1_mdu_b      .ex1_lsu_wdata       .ex1_branch_valid        .ex1_none0_info          |
     |                                                                                                                                         |
     +-----------------------------------------------------------------------------------------------------------------------------------------+
            | |     |               | |     |            | |     |          | |     |           | |     |               | |     |
            | | ... |               | | ... |            | | ... |          | | ... |           | | ... |               | | ... |
            | |     |               | |     |            | |     |          | |     |           | |     |               | |     |
            | |     |               | |     |            | |     |          | |     |           | |     |               | |     |
     +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
     |          ex1_stage ex1_stage                                                                                                                                                                            |
     |                                                                                                                                                                                                         |
     |   // port0                //ALU0                 //MDU           //LSU                //BRU                  //LSU               //NONE0                    //forward                                   |
     |   .ex1_port0_valid        .ex1_port0_a           .ex1_mdu_op     .ex1_lsu_op          .ex1_bru_delay         .ex1_lsu_op         .ex1_none0_result          .ex1_raddr0_0                               |
     |   .ex1_port0_pc           .ex1_port0_b           .ex1_mdu_a      .ex1_lsu_base        .ex1_bru_op            .ex1_lsu_base       .ex1_none0_exception       .ex1_raddr0_1                               |
     |   .ex1_port0_inst         .ex1_port0_op          .ex1_mdu_b      .ex1_lsu_offset      .ex1_bru_a             .ex1_lsu_offset     .ex1_none0_exccode         .ex1_raddr1_0                               |
     |   .ex1_port0_src          .ex1_port0_c                           .ex1_lsu_wdata       .ex1_bru_b             .ex1_lsu_wdata      .ex1_none0_csr_result      .ex1_raddr1_1                               |
     |   .ex1_port0_rf_target    .ex1_port0_double                                           .ex1_bru_br_taken                          .ex1_none0_csr_addr        .ex1_raddr2_0                               |
     |   .ex1_port0_rf_wen       .ex1_port0_a_ignore                                         .ex1_bru_br_target                         .ex1_none0_csr_a           .ex1_raddr2_1                               |
     |   .ex1_port0_ll           .ex1_port0_b_ignore                                         .ex1_bru_hint                              .ex1_none0_op                                                          |
     |   .ex1_port0_sc           .ex1_port0_b_get_a                                          .ex1_bru_link                              .ex1_none0_info                                                        |
     |   .ex1_port0_type                                                                     .ex1_bru_jrra                                                                                                     |
     |                                                                                       .ex1_bru_brop                                                                                                     |
     |                                                                                       .ex1_bru_jrop                                                                                                     |
     |                                                                                       .ex1_bru_offset                                                                                                   |
     |                                                                                       .ex1_bru_pc                                                                                                       |
     |                                                                                       .ex1_bru_port                                                                                                     |
     |                                                                                       .ex1_branch_valid                                                                                                 |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  .mul_valid             |
     |                                                                                                                                                                                  .mul_a                 |
     |                                                                                                                                                                                  .mul_b                 |
     |                                                                                                                                                                                  .mul_signed            |
     |                                                                                                                                                                                  .mul_double            |
     |                                                                                                                                                                                  .mul_hi                |
     |                                                                                                                                                                                  .mul_short             |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  .div_valid             |
     |                                                                                                                                                                                  .div_a                 |
     |                                                                                                                                                                                  .div_b                 |
     |                                                                                                                                                                                  .div_signed            |
     |                                                                                                                                                                                  .div_double            |
     |                                                                                                                                                                                  .div_mod               |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  .bru_cancel            |
     |                                                                                                                                                                                  .bru_cancel_all        |
     |                                                                                                                                                                                  .bru_ignore            |
     |                                                                                                                                                                                  .bru_port              |
     |                                                                                                                                                                                  .bru_pc                |
     |                                                                                                                                                                                  .bru_target            |
     |                                                                                                                                                                                  .bru_valid             |
     |                                                                                                                                                                                  .bru_hint              |
     |                                                                                                                                                                                  .bru_sign              |
     |                                                                                                                                                                                  .bru_taken             |
     |                                                                                                                                                                                  .bru_brop              |
     |                                                                                                                                                                                  .bru_jrop              |
     |                                                                                                                                                                                  .bru_jrra              |
     |                                                                                                                                                                                  .bru_link              |
     |                                                                                                                                                                                  .bru_link_pc           |
     |                                                                                                                                                                                  .bru_delay             |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  //memory interface     |
     |                                                                                                                                                                                  .data_req              |
     |                                                                                                                                                                                  .data_pc               |
     |                                                                                                                                                                                  .data_addr             |
     |                                                                                                                                                                                  .data_wr               |
     |                                                                                                                                                                                  .data_wstrb            |
     |                                                                                                                                                                                  .data_wdata            |
     |                                                                                                                                                                                  .data_cancel           |
     |                                                                                                                                                                                  .data_prefetch         |
     |                                                                                                                                                                                  .data_ll               |
     |                                                                                                                                                                                  .data_sc               |
     |                                                                                                                                                                                  .data_addr_ok          |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  //tlb interface        |
     |                                                                                                                                                                                  .tlb_req               |
     |                                                                                                                                                                                  .tlb_recv              |
     |                                                                                                                                                                                  .tlb_op                |
     |                                                                                                                                                                                  .tlb_finish            |
     |                                                                                                                                                                                  .tlb_index             |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  .data_exception        |
     |                                                                                                                                                                                  .data_excode           |
     |                                                                                                                                                                                  .data_badvaddr         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  .cache_req             |
     |                                                                                                                                                                                  .cache_op              |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                       .ex2_bru_delay                                                                                                    |
     |                                                                                       .ex2_bru_op                                                                                                       |
     |                                                                                       .ex2_bru_a                                                                                                        |
     |                                                                                       .ex2_bru_b                                                                                                        |
     |                                                                                       .ex2_bru_br_taken                                                                                                 |
     |                                                                                       .ex2_bru_br_target                                                                                                |
     |   // port0                                                                            .ex2_bru_offset                                                                                                   |
     |   .ex2_port0_src                                                                      .ex2_bru_link_pc                                                                                                  |
     |   .ex2_port0_valid                                                                    .ex2_bru_link                                                                                                     |
     |   .ex2_port0_pc                                                  //LSU                .ex2_bru_jrra                              .ex2_none0_result                                                      |
     |   .ex2_port0_inst                                                .ex2_lsu_shift       .ex2_bru_jrop          .ex2_lsu_shift      .ex2_none0_exception                                                   |
     |   .ex2_port0_rf_target    .ex2_port0_a                           .ex2_lsu_op          .ex2_bru_brop          .ex2_lsu_op         .ex2_none0_exccode         .ex2_alu0_res                               |
     |   .ex2_port0_rf_wen       .ex2_port0_b           //MDU           .ex2_lsu_wdata       .ex2_bru_port          .ex2_lsu_wdata      .ex2_none0_csr_result      .ex2_alu1_res                               |
     |   .ex2_port0_ll           .ex2_port0_c           .ex2_mdu_op     .ex2_lsu_recv        .ex2_bru_valid         .ex2_lsu_recv       .ex2_none0_csr_addr        .ex2_lsu_res                                |
     |   .ex2_port0_sc           .ex2_port0_op          .ex2_mdu_a      .ex2_lsu_ale         .ex2_bru_hint          .ex2_lsu_ale        .ex2_none0_op              .ex2_none0_res                              |
     |   .ex2_port0_type         .ex2_port0_double      .ex2_mdu_b      .ex2_lsu_adem        .ex2_bru_pc            .ex2_lsu_adem       .ex2_none0_info            .ex2_none1_res                              |
     |                                                                                                                                                                                                         |
     +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
