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
     |   // port0                //ALU0                 //MDU           //LSU                //BRU                  //NONE0                    //forward                                                       |
     |   .ex1_port0_valid        .ex1_port0_a           .ex1_mdu_op     .ex1_lsu_op          .ex1_bru_delay         .ex1_none0_result          .ex1_raddr0_0                                                   |
     |   .ex1_port0_pc           .ex1_port0_b           .ex1_mdu_a      .ex1_lsu_base        .ex1_bru_op            .ex1_none0_exception       .ex1_raddr0_1                                                   |
     |   .ex1_port0_inst         .ex1_port0_op          .ex1_mdu_b      .ex1_lsu_offset      .ex1_bru_a             .ex1_none0_exccode         .ex1_raddr1_0                                                   |
     |   .ex1_port0_src          .ex1_port0_c                           .ex1_lsu_wdata       .ex1_bru_b             .ex1_none0_csr_result      .ex1_raddr1_1                                                   |
     |   .ex1_port0_rf_target    .ex1_port0_double                                           .ex1_bru_br_taken      .ex1_none0_csr_addr        .ex1_raddr2_0                                                   |
     |   .ex1_port0_rf_wen       .ex1_port0_a_ignore                                         .ex1_bru_br_target     .ex1_none0_csr_a           .ex1_raddr2_1                                                   |
     |   .ex1_port0_ll           .ex1_port0_b_ignore                                         .ex1_bru_hint          .ex1_none0_op                                                                              |
     |   .ex1_port0_sc           .ex1_port0_b_get_a                                          .ex1_bru_link          .ex1_none0_info                                                                            |
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
     |   .ex2_port0_src                                                 .ex2_lsu_res         .ex2_bru_link_pc       .ex2_non0_res                                                                              |
     |   .ex2_port0_valid                                                                    .ex2_bru_link                                                                                                     |
     |   .ex2_port0_pc           .ex2_alu0_res                          //LSU                .ex2_bru_jrra          .ex2_none0_result             .ex2_lsu_fw_data                                             |
     |   .ex2_port0_inst                                                .ex2_lsu_shift       .ex2_bru_jrop          .ex2_none0_exception          .ex2_rdata0_0_lsu_fw                                         |
     |   .ex2_port0_rf_target    .ex2_port0_a                           .ex2_lsu_op          .ex2_bru_brop          .ex2_none0_exccode            .ex2_rdata0_1_lsu_fw                                         |
     |   .ex2_port0_rf_wen       .ex2_port0_b           //MDU           .ex2_lsu_wdata       .ex2_bru_port          .ex2_none0_csr_result         .ex2_rdata1_0_lsu_fw                                         |
     |   .ex2_port0_ll           .ex2_port0_c           .ex2_mdu_op     .ex2_lsu_recv        .ex2_bru_valid         .ex2_none0_csr_addr           .ex2_rdata1_1_lsu_fw                                         |
     |   .ex2_port0_sc           .ex2_port0_op          .ex2_mdu_a      .ex2_lsu_ale         .ex2_bru_hint          .ex2_none0_op                 .ex2_bru_a_lsu_fw                                            |
     |   .ex2_port0_type         .ex2_port0_double      .ex2_mdu_b      .ex2_lsu_adem        .ex2_bru_pc            .ex2_none0_info               .ex2_bru_b_lsu_fw                                            |
     |                                                                                                                                                                                                         |
     +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
            | |     |               | |     |            | |     |          | |     |           | |     |               | |     |
            | | ... |               | | ... |            | | ... |          | | ... |           | | ... |               | | ... |
            | |     |               | |     |            | |     |          | |     |           | |     |               | |     |
            | |     |               | |     |            | |     |          | |     |           | |     |               | |     |
     +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
     |          ex2_stage ex2_stage                                                                                                                                                                            |
     |                                                                                                                                                                                                         |
     |   //port0                 //ALU0                 //MDU           //LSU                //BRANCH               //NONE1                       .ex2_lsu_fw_data                                             |
     |   .ex2_port0_src          .ex2_port0_a           .ex2_mdu_op     .ex2_lsu_res         .ex2_bru_delay         .ex2_none0_result             .ex2_rdata0_0_lsu_fw                                         |
     |   .ex2_port0_pc           .ex2_port0_b           .ex2_mdu_a                           .ex2_bru_op            .ex2_none0_csr_addr           .ex2_rdata0_1_lsu_fw                                         |
     |   .ex2_port0_inst         .ex2_port0_op          .ex2_mdu_b      .ex2_lsu_ale         .ex2_bru_a             .ex2_none0_csr_result         .ex2_rdata1_0_lsu_fw                                         |
     |   .ex2_port0_valid        .ex2_port0_c           .ex2_mul_ready  .ex2_lsu_adem        .ex2_bru_b             .ex2_none0_op                 .ex2_rdata1_1_lsu_fw                                         |
     |   .ex2_port0_rf_target    .ex2_port0_double      .ex2_mul_res    .ex2_lsu_shift       .ex2_bru_br_taken      .ex2_none0_info               .ex2_bru_a_lsu_fw                                            |
     |   .ex2_port0_rf_wen       .ex2_alu0_res          .ex2_div_res    .ex2_lsu_op          .ex2_bru_br_target                                   .ex2_bru_b_lsu_fw                                            |
     |   .ex2_port0_exception                                           .ex2_lsu_recv        .ex2_bru_offset                                                                                                   |
     |   .ex2_port0_exccode                                                                  .ex2_bru_link_pc                                                                                                  |
     |   .ex2_port0_ll                                                                       .ex2_bru_link                                                                                                     |
     |   .ex2_port0_sc                                                                       .ex2_bru_jrra                                                                                                     |
     |   .ex2_port0_type                                                                     .ex2_bru_jrop                                                                                                     |
     |                                                                                       .ex2_bru_brop                                                                                                     |
     |                                                                                       .ex2_bru_port                                                                                                     |
     |                                                                                       .ex2_bru_valid                                                                                                    |
     |                                                                                       .ex2_bru_hint                                                                                                     |
     |                                                                                       .ex2_bru_pc                                                                                                       |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  .bru_target_ex2        |
     |                                                                                                                                                                                  .bru_pc_ex2            |
     |                                                                                                                                                                                  .bru_cancel_ex2        |
     |                                                                                                                                                                                  .bru_ignore_ex2        |
     |                                                                                                                                                                                  .bru_cancel_all_ex2    |
     |                                                                                                                                                                                  .bru_port_ex2          |
     |                                                                                                                                                                                  .bru_valid_ex2         |
     |                                                                                                                                                                                  .bru_hint_ex2          |
     |                                                                                                                                                                                  .bru_sign_ex2          |
     |                                                                                                                                                                                  .bru_taken_ex2         |
     |                                                                                                                                                                                  .bru_brop_ex2          |
     |                                                                                                                                                                                  .bru_jrop_ex2          |
     |                                                                                                                                                                                  .bru_jrra_ex2          |
     |                                                                                                                                                                                  .bru_link_ex2          |
     |                                                                                                                                                                                  .bru_link_pc_ex2       |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  //memory interface     |
     |                                                                                                                                                                                  .data_recv             |
     |                                                                                                                                                                                  .data_scsucceed        |
     |                                                                                                                                                                                  .data_rdata            |
     |                                                                                                                                                                                  .data_data_ok          |
     |                                                                                                                                                                                  .data_exception        |
     |                                                                                                                                                                                  .data_excode           |
     |                                                                                                                                                                                  .data_badvaddr         |
     |                                                                                                                                                                                  .data_cancel_ex2       |
     |                                                                                                                                                                                  .badvaddr_ex2          |
     |                                                                                                                                                                                  .badvaddr_ex2_valid    |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |   // port 0                                                                                                                                                                                             |
     |   .wb_port0_valid                                                                                                                                                                                       |
     |   .wb_port0_src                                                                                                                                                                                         |
     |   .wb_port0_inst                                                                                                                                                                                        |
     |   .wb_port0_pc                                                                                                                                                                                          |
     |   .wb_port0_rf_target                                                                                                                                                                                   |
     |   .wb_port0_rf_wen                                                                                                                                                                                      |
     |   .wb_port0_rf_result                                                                 .wb_bru_link                                                                                                      |
     |   .wb_port0_exception                                                                 .wb_bru_jrra                                                                                                      |
     |   .wb_port0_exccode                                                                   .wb_bru_jrop                                                                                                      |
     |   .wb_port0_eret                                                                      .wb_bru_brop                                                                                                      |
     |   .wb_port0_csr_addr                                                                  .wb_bru_port                                                                                                      |
     |   .wb_port0_ll                                                                        .wb_bru_valid                                                                                                     |
     |   .wb_port0_sc                                                                        .wb_bru_hint                                                                                                      |
     |   .wb_port0_csr_result                                                                .wb_bru_br_taken                                                                                                  |
     |   .wb_port0_esubcode                                                                  .wb_bru_pc             .wb_none0_op                                                                               |
     |   .wb_port0_rf_res_lsu                                           .wb_lsu_res          .wb_bru_link_pc        .wb_none0_info                                                                             |
     |                                                                                                                                                                                                         |
     +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
            | |     |                                                    | |     |           | |     |               | |     |
            | | ... |                                                    | | ... |           | | ... |               | | ... |
            | |     |                                                    | |     |           | |     |               | |     |               -------------------------------------------------------------------------------- 
            | |     |                                                    | |     |           | |     |               | |     |               ||    |
     +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
     |          wb_stage wb_stage                                                                                                                                                                              |
     |                                                                                                                                                                                                         |
     |   // port 0                                                      // lsu               // branch             .wb_none0_op           // exception entrance calculation                                    |
     |   .wb_port0_inst                                                 .wb_lsu_res          .wb_branch_link       .wb_none0_info         .cp0_status_exl                                                      |
     |   .wb_port0_pc                                                                        .wb_branch_jrra                              .cp0_status_bev                                                      |
     |   .wb_port0_src                                                                       .wb_branch_jrop                              .cp0_cause_iv                                                        |
     |   .wb_port0_valid                                                                     .wb_branch_brop                              .cp0_ebase_exceptionbase                                             |
     |   .wb_port0_rf_target                                                                 .wb_bru_port                                 .eret_epc                                                            |
     |   .wb_port0_rf_wen                                                                    .wb_branch_valid                             .wb_tlbr_entrance                                                    |
     |   .wb_port0_rf_result                                                                 .wb_bru_hint                                 .csr_ebase                                                           |
     |   .wb_port0_exception                                                                 .wb_bru_br_taken                                                                                                  |
     |   .wb_port0_exccode                                                                   .wb_bru_pc                                                                                                        |
     |   .wb_port0_eret                                                                      .wb_bru_link_pc                                                                                                   |
     |   .wb_port0_csr_addr                                                                                                                                                                                    |
     |   .wb_port0_ll                                                                                                                                                                                          |
     |   .wb_port0_sc                                                                                                                                                                                          |
     |   .wb_port0_csr_result                                                                                                                                                                                  |
     |   .wb_port0_esubcode                                                                                                                                                                                    |
     |   .wb_port0_rf_res_lsu                                                                                                                                                                                  |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  //reg file interface   |
     |                                                                                                                                                                                  .waddr1                |
     |                                                                                                                                                                                  .waddr2                |
     |                                                                                                                                                                                  .wdata1                |
     |                                                                                                                                                                                  .wdata2                |
     |                                                                                                                                                                                  .wen1                  |
     |                                                                                                                                                                                  .wen2                  |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                              // cp0 registers interface |
     |                                                                                                                                                                                  .csr_waddr             |
     |                                                                                                                                                                                  .csr_wdata             |
     |                                                                                                                                                                                  .csr_wen               |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  .csr_tlbp              |
     |                                                                                                                                                                                  .csr_tlbop_index       |
     |                                                                                                                                                                                  .csr_tlbr              |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  // branch update       |
     |                                                                                                                                                                                  .wb_valid              |
     |                                                                                                                                                                                  .wb_brop               |
     |                                                                                                                                                                                  .wb_link               |
     |                                                                                                                                                                                  .wb_link_pc            |
     |                                                                                                                                                                                  .wb_jrop               |
     |                                                                                                                                                                                  .wb_jrra               |
     |                                                                                                                                                                                  .wb_pc                 |
     |                                                                                                                                                                                  .wb_hint               |
     |                                                                                                                                                                                  .wb_taken              |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                  //exception            |
     |                                                                                                                                                                                  .wb_cancel             |
     |                                                                                                                                                                                  .wb_target             |
     |                                                                                                                                                                                  .wb_exception          |
     |                                                                                                                                                                                  .wb_exccode            |
     |                                                                                                                                                                                  .wb_esubcode           |
     |                                                                                                                                                                                  .wb_eret               |
     |                                                                                                                                                                                  .wb_epc                |
     |                                                                                                                                                                                  .badvaddr_ex2          |
     |                                                                                                                                                                                  .badvaddr_ex2_valid    |
     |                                                                                                                                                                                  .lsu_badvaddr          |
     |                                                                                                                                                                                  .wb_badvaddr           |
     |                                                                                                                                                                                  .except_shield         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     |                                                                                                                                                                                                         |
     +---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+




--------------------------------------------------------------

分ex1_stage ex2_stage的原因主要是因为lsu至少需要2个cycle才能完成，第一个cycle发出地址，如果是写的话数据也发出。第二cycle得到从cache里回来的数据，或者是写的时候的回馈，比如data_addr_ok。

也就是说功能模块按流水线阶段分别放在不同的module里。这样写代码的方式有点麻烦，如果lsu需要三cycle的时候，改就很麻烦了。

而且数据bypassing的部分也散乱在各个模块里。

最有意思的是branch模块也分别在ex1_stage和ex2_stage都有，而且是同一module的两个实例。


`````verilog
ex1_stage.v

branch branch(
    .branch_valid (branch_valid     ),
    .branch_a     (bru_a            ),
    .branch_b     (bru_b            ),
    .branch_op    (ex1_bru_op       ),
    .branch_pc    (ex1_bru_pc       ),
    .branch_inst  (ex1_bru_inst     ),
    .branch_taken (ex1_bru_br_taken ),
    .branch_target(ex1_bru_br_target),
    .branch_offset(ex1_bru_offset   ),
    .cancel_allow (cancel_allow     ),
    // pc interface
    .bru_cancel   (bru_cancel       ),
    .bru_target   (bru_target       ),
    .bru_valid    (bru_valid        ),
    .bru_taken    (bru_taken        ),
    .bru_link_pc  (bru_link_pc      ),
    .bru_pc       (bru_pc           )
);
`````

`````verilog
ex2_stage.v

branch bru_s2(
    .branch_valid (branch_valid     ),
    .branch_a     (bru_a            ),
    .branch_b     (bru_b            ),
    .branch_op    (ex2_bru_op       ),
    .branch_pc    (ex2_bru_pc       ),
    .branch_inst  (ex2_bru_inst     ),
    .branch_taken (ex2_bru_br_taken ),
    .branch_target(ex2_bru_br_target),
    .branch_offset(ex2_bru_offset   ),
    .cancel_allow (cancel_allow     ),
    // pc interface
    .bru_cancel   (bru_cancel_ex2   ),
    .bru_target   (bru_target_ex2   ),
    .bru_valid    (bru_valid_ex2    ),
    .bru_taken    (bru_taken_ex2    ),
    .bru_link_pc  (bru_link_pc_ex2  ),
    .bru_pc       (bru_pc_ex2       )
);
`````

branch指令应该是计算了两遍了吧，至于结果取的是哪个，还得看其它代码分析。


--------------------------------------------------------------------------------


从前面的图很容易看出，issue后，各种指令分类进入ex1_stage，ex1_stage又有信号直接给出到mul，div，内部有alu。也就是说算术指令都是在ex1_stage开始的。

alu里的能单周期完成。mul，div都是在计算完结果后才给出ready，比如ex1_mul_ready，ex2_mul_ready，然后才会触发ex2_allow_in，流水线才会动起来。

还有个地方没搞清的就是mul分别想ex1_stage ex2_stage给出ex1_mul_ready ex2_mul_ready，那mul指令是不是同时stall住ex1和ex2呢？

感觉不是很想在这个框架上改了。


--------------------------------------------------------------------------------

`````verilog

//result
wire port0_change;
wire port0_alu_change  = (ex2_port0_src == `EX_ALU0  ) && ex2_alu0_valid;
wire port0_lsu_change  = (ex2_port0_src == `EX_LSU   ) && lsu_res_valid;
wire port0_bru_change  = (ex2_port0_src == `EX_BRU   ) && ex2_bru_valid;
wire port0_none_change = (ex2_port0_src == `EX_NONE0 ) && ex2_none0_valid;
wire port0_div_change  = (ex2_port0_src == `EX_DIV   ) && ex2_div_valid;// && (div_complete || div_completed);
wire port0_mul_change  = (ex2_port0_src == `EX_MUL   ) && ex2_mul_valid && ex2_mul_ready;

wire port1_change;
wire port1_alu_change  = (ex2_port1_src == `EX_ALU1  ) && ex2_alu1_valid;
wire port1_lsu_change  = (ex2_port1_src == `EX_LSU   ) && lsu_res_valid;
wire port1_bru_change  = (ex2_port1_src == `EX_BRU   ) && ex2_bru_valid;
wire port1_none_change = (ex2_port1_src == `EX_NONE1 ) && ex2_none1_valid;
wire port1_div_change  = (ex2_port1_src == `EX_DIV   ) && ex2_div_valid;// && (div_complete || div_completed);
wire port1_mul_change  = (ex2_port1_src == `EX_MUL   ) && ex2_mul_valid && ex2_mul_ready;

always @(posedge clk) begin
    if(port0_change) wb_port0_rf_res_lsu <= port0_lsu_change;

    if(port1_change) wb_port1_rf_res_lsu <= port1_lsu_change;

    if(data_data_ok) wb_lsu_res <= ex2_lsu_res;
end

assign port0_change = port0_alu_change || port0_lsu_change || port0_bru_change || port0_none_change || port0_div_change || port0_mul_change || !ex2_port0_valid;
assign port1_change = port1_alu_change || port1_lsu_change || port1_bru_change || port1_none_change || port1_div_change || port1_mul_change || !ex2_port1_valid;

assign change = port0_change && port1_change;

wire [`GRLEN-1:0] port0_res_input = ({`GRLEN{port0_alu_change  }} & ex2_alu0_res     ) |
                                    ({`GRLEN{port0_bru_change  }} & ex2_bru_link_pc  ) |
                                    ({`GRLEN{port0_none_change }} & ex2_none0_result ) |
                                    ({`GRLEN{port0_div_change  }} & ex2_div_res      ) |
                                    ({`GRLEN{port0_mul_change  }} & ex2_mul_res      ) ;

wire [`GRLEN-1:0] port1_res_input = ({`GRLEN{port1_alu_change  }} & ex2_alu1_res     ) |
                                    ({`GRLEN{port1_bru_change  }} & ex2_bru_link_pc  ) |
                                    ({`GRLEN{port1_none_change }} & ex2_none1_result ) |
                                    ({`GRLEN{port1_div_change  }} & ex2_div_res      ) |
                                    ({`GRLEN{port1_mul_change  }} & ex2_mul_res      ) ;


always @(posedge clk) begin
    if (port0_change) begin
        wb_port0_rf_result <= port0_res_input;
    end
end

always @(posedge clk) begin
    if (port1_change) begin
        wb_port1_rf_result <= port1_res_input;
    end
end
`````

这段代码，只要port0 port1有一个是有改动的，就会set change。

但这个change会传递到lsu_s2中。

`````verilog
module lsu_s2(
  input               clk,
  input               resetn,

  input               valid,
  input [`LSOC1K_LSU_CODE_BIT-1:0]lsu_op,
  input               lsu_recv,
  input [ 2:0]        lsu_shift,

  //cached memory interface
  output              data_recv,
  input               data_scsucceed,
  input   [`GRLEN-1:0]data_rdata,
  input               data_exception,
  input   [ 5:0]      data_excode,
  input   [`GRLEN-1:0]data_badvaddr,
  input               data_data_ok,

//result
  output [`GRLEN-1:0] read_result,
  output              lsu_res_valid,

  input               change,
  input               exception,
  output reg [`GRLEN-1:0]   badvaddr,
  output              badvaddr_valid
);

...

// signal process
always @(posedge clk) begin
    if     (rst || change) res_valid <= 1'd0;
    else if(data_data_ok || prefetch || data_exception) res_valid <= 1'd1;                          
end

assign lsu_res_valid = data_data_ok || data_exception || res_valid || prefetch || !valid || (lsu_op == `LSOC1K_LSU_IDLE);
...

endmodule
`````

change会改变res_valid，但这个res_valid并不最后改变output的lsu_res_valid。

但从道理上说，port0 port1任意一个有改动不应该都影响lsu吧。

感觉这里是改bug遗留下来的。
