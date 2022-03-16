---
title: See how the add instruction goes through the issue, ex1 and ex2 stages
published: true
---

I want to trace how the "add" instruction goes through the ex1 and ex2 stages. Because there are several things that I feel weird about. For one, there are ALUs in both ex1 and ex2. And for simple arithmetic operations such as add, it only takes one cycle to finish.

I traced ex1_port0_a, ex1_port0_b, ex1_port0_op, ex1_port0_double, ex1_port0_c, ex1_port0_ignore_a, ex1_port0_ignore_b, ex1_port0_b_get_a. They come from the issue stage and go to ex1. They are calculated in the ALU  and get the result ex1_alu0_res, but the result returns to the issue stage. I guess this is for the forwarding-related stuff. Then, the ex1 stage passes those signals to the ex2 stage as ex2_port0_a, ex2_port0_b, etc.

I guess it will be calculated again. I get confused because the ALU is not a tiny functional unit.

Let's see the forwarding-related code in the ex1_stage.


`````````````verilog
 737 ////forwarding related                                                                                                                                                                                
 738 //forwarding check                                                                                                                                                                                    
 739 assign r1_1_w1_fw =     ex2_port0_valid && (ex1_raddr0_0 == ex2_port0_rf_target) && (ex2_port0_rf_target != 5'd0);                                                                                    
 740 assign r1_2_w1_fw = ex2_port0_valid && (ex1_raddr0_1 == ex2_port0_rf_target) && (ex2_port0_rf_target != 5'd0);                                                                                        
 741 assign r1_1_w2_fw =     ex2_port1_valid && (ex1_raddr0_0 == ex2_port1_rf_target) && (ex2_port1_rf_target != 5'd0);                                                                                    
 742 assign r1_2_w2_fw = ex2_port1_valid && (ex1_raddr0_1 == ex2_port1_rf_target) && (ex2_port1_rf_target != 5'd0);
`````````````

First of all, the naming is inconsistent.
r1_1_w1_fw means the reading of rf (raddr0_0) is conflicted with the writing of rf in the next cycle (ex2). This signal should be named r0_0_w1_fw.

后面再跟ex2_port0_a，


在issue模块的参数里，



````````verilog
 1255     //forwarding related                                                                                                                                                                             
 1256     .ex1_raddr0_0       (ex1_raddr0_0       ),                                                                                                                                                       
 1257     .ex1_raddr0_1       (ex1_raddr0_1       ),                                                                                                                                                       
 1258     .ex1_raddr1_0       (ex1_raddr1_0       ),                                                                                                                                                       
 1259     .ex1_raddr1_1       (ex1_raddr1_1       ),                                                                                                                                                       
 1260     .ex1_raddr2_0       (ex1_raddr2_0       ),                                                                                                                                                       
 1261     .ex1_raddr2_1       (ex1_raddr2_1       ),                                                                                                                                                       
 1262                                                                                                                                                                                                      
 1263     .ex1_alu0_res       (ex1_alu0_res       ),                                                                                                                                                       
 1264     .ex1_alu1_res       (ex1_alu1_res       ),                                                                                                                                                       
 1265     .ex1_bru_res        (bru_link_pc        ),                                                                                                                                                       
 1266     .ex1_none0_res      (ex1_none0_result   ),                                                                                                                                                       
 1267     .ex1_none1_res      (ex1_none1_result   ),                                                                                                                                                       
 1268                                                                                                                                                                                                      
 1269     .ex2_port0_src       (ex2_port0_src      ),                                                                                                                                                      
 1270     .ex2_port0_valid     (ex2_port0_valid    ),                                                                                                                                                      
 1271     .ex2_port0_rf_target (ex2_port0_rf_target),                                                                                                                                                      
 1272     .ex2_port1_src       (ex2_port1_src      ),                                                                                                                                                      
 1273     .ex2_port1_valid     (ex2_port1_valid    ),                                                                                                                                                      
 1274     .ex2_port1_rf_target (ex2_port1_rf_target),                                                                                                                                                      
 1275                                                                                                                                                                                                      
 1276     .ex2_alu0_res       (ex2_alu0_res       ),                                                                                                                                                       
 1277     .ex2_alu1_res       (ex2_alu1_res       ),                                                                                                                                                       
 1278     .ex2_lsu_res        (ex2_lsu_res        ),                                                                                                                                                       
 1279     .ex2_bru_res        (ex2_bru_link_pc    ),                                                                                                                                                       
 1280     .ex2_none0_res      (ex2_none0_result   ),                                                                                                                                                       
 1281     .ex2_none1_res      (ex2_none1_result   ),                                                                                                                                                       
 1282     .ex2_mul_res        (ex2_mul_res        ),                                                                                                                                                       
 1283     .ex2_div_res        (ex2_div_res        )                                                                                                                                                        
 1284 );
````````

能看到ex1_port0_res ，ex2_port0_res，两个ex stage里的alu的结果都送回issue里用来forwarding了，这里肯定得有点问题。



在ex2里, ex2_alu0_res作为结果被传出去，wb_port0_rf_result, 再进入wb_stage，然后又以wdata1回写到registerfile。
其实应该叫wdata0，毕竟这是第一个回写端口。感觉ex2后面的代码是另一个人写的，ex1里的alu0 alu1，到ex2的注释里变成alu1 alu2了。

```````verilog
 512 wire [`GRLEN-1:0] port0_res_input = ({`GRLEN{port0_alu_change  }} & ex2_alu0_res     ) |                                                                                                              
 513                                     ({`GRLEN{port0_bru_change  }} & ex2_bru_link_pc  ) |                                                                                                              
 514                                     ({`GRLEN{port0_none_change }} & ex2_none0_result ) |                                                                                                              
 515                                     ({`GRLEN{port0_div_change  }} & ex2_div_res      ) |                                                                                                              
 516                                     ({`GRLEN{port0_mul_change  }} & ex2_mul_res      ) ;                                                                                                              
 517                                                                                                                                                                                                       
....

 525 always @(posedge clk) begin                                                                                                                                                                           
 526     if (port0_change) begin                                                                                                                                                                           
 527         wb_port0_rf_result <= port0_res_input;                                                                                                                                                        
 528     end                                                                                                                                                                                               
 529 end 
```````

现在的问题是，add这种整数指令只需要一个周期就完成了，虽然也还是经历了ex1，ex2，相当于算了两遍，但mul，div这种指令需要好几个周期，
怎样做到等待mul，div指令完成的呢？因为回写是在wb，按说mul，div应该在wb之前算完。


这个地方很晕，为什么有ex1_mdu_a，还有ex2_mdu_a，还有mul_a和div_a。。。

````````verilog
 126     //MDU                                                                                                                                                                                             
 127     input [`LSOC1K_MDU_CODE_BIT-1:0]      ex1_mdu_op,                                                                                                                                                 
 128     input [`GRLEN-1:0]                    ex1_mdu_a,                                                                                                                                                  
 129     input [`GRLEN-1:0]                    ex1_mdu_b,                                                                                                                                                  
 130     output reg [`LSOC1K_MDU_CODE_BIT-1:0] ex2_mdu_op,                                                                                                                                                 
 131     output reg [`GRLEN-1:0]               ex2_mdu_a,                                                                                                                                                  
 132     output reg [`GRLEN-1:0]               ex2_mdu_b,                                                                                                                                                  
 133                                                                                                                                                                                                       
 134     output                                mul_valid,                                                                                                                                                  
 135     output [`GRLEN-1:0]                   mul_a,                                                                                                                                                      
 136     output [`GRLEN-1:0]                   mul_b,                                                                                                                                                      
 137     output                                mul_signed,                                                                                                                                                 
 138     output                                mul_double,                                                                                                                                                 
 139     output                                mul_hi,                                                                                                                                                     
 140     output                                mul_short,                                                                                                                                                  
 141                                                                                                                                                                                                       
 142     output                                div_valid,                                                                                                                                                  
 143     output [`GRLEN-1:0]                   div_a,                                                                                                                                                      
 144     output [`GRLEN-1:0]                   div_b,                                                                                                                                                      
 145     output                                div_signed,                                                                                                                                                 
 146     output                                div_double,                                                                                                                                                 
 147     output                                div_mod,                                                                                                                                                    
 148                                                                                                                                                                                                       
 149     input [`GRLEN-1:0]                    ex2_mul_res,                                                                                                                                                
 150     input [`GRLEN-1:0]                    ex2_div_res,                                                                                                                                                
 151     input                                 ex1_mul_ready,                                                                                                                                              
 152     input                                 ex1_div_ready,
````````


这是咋回事。。。ex2_stage里的
``````verilog
 355 //mdu                                                                                                                                                                                                 
 356 wire ex2_mul_valid = (((ex2_port0_src == `EX_MUL) && ex2_port0_valid) ||                                                                                                                              
 357                      ((ex2_port1_src == `EX_MUL) && ex2_port1_valid)) ;                                                                                                                               
 358                                                                                                                                                                                                       
 359 wire ex2_div_valid = (((ex2_port0_src == `EX_DIV) && ex2_port0_valid) ||                                                                                                                              
 360                      ((ex2_port1_src == `EX_DIV) && ex2_port1_valid)) ;                                                                                                                               
 361                                                                                                                                                                                                       
 362 // wire [31:0] div_w,mod_w,div_wu,mod_wu;                                                                                                                                                             
 363 // assign div_w  = $signed(ex2_mdu_a[31:0]) / $signed(ex2_mdu_b[31:0]);                                                                                                                               
 364 // assign mod_w  = $signed(ex2_mdu_a[31:0]) % $signed(ex2_mdu_b[31:0]);                                                                                                                               
 365 // assign div_wu = ex2_mdu_a[31:0] / ex2_mdu_b[31:0];                                                                                                                                                 
 366 // assign mod_wu = ex2_mdu_a[31:0] % ex2_mdu_b[31:0];                                                                                                                                                 
 367 `ifdef LA64                                                                                                                                                                                           
 368 wire [63:0] div_d,mod_d,div_du,mod_du;                                                                                                                                                                
 369                                                                                                                                                                                                       
 370 assign div_d  = $signed(ex2_mdu_a) / $signed(ex2_mdu_b);                                                                                                                                              
 371 assign mod_d  = $signed(ex2_mdu_a) % $signed(ex2_mdu_b);                                                                                                                                              
 372 assign div_du = ex2_mdu_a / ex2_mdu_b;                                                                                                                                                                
 373 assign mod_du = ex2_mdu_a % ex2_mdu_b;                                                                                                                                                                
 374                                                                                                                                                                                                       
 375 assign ex2_div_res = ex2_mdu_op == `LSOC1K_MDU_DIV_W  ? {{32{div_w[31]}},div_w}   :                                                                                                                   
 376                      ex2_mdu_op == `LSOC1K_MDU_MOD_W  ? {{32{mod_w[31]}},mod_w}   :                                                                                                                   
 377                      ex2_mdu_op == `LSOC1K_MDU_DIV_WU ? {{32{div_wu[31]}},div_wu} :                                                                                                                   
 378                      ex2_mdu_op == `LSOC1K_MDU_MOD_WU ? {{32{mod_wu[31]}},mod_wu} :                                                                                                                   
 379                      ex2_mdu_op == `LSOC1K_MDU_DIV_D  ? div_d                     :                                                                                                                   
 380                      ex2_mdu_op == `LSOC1K_MDU_MOD_D  ? mod_d                     :                                                                                                                   
 381                      ex2_mdu_op == `LSOC1K_MDU_DIV_DU ? div_du                    :                                                                                                                   
 382                      ex2_mdu_op == `LSOC1K_MDU_MOD_DU ? mod_du                    :                                                                                                                   
 383                                                         64'd0                     ;                                                                                                                   
 384 // `elsif LA32                                                                                                                                                                                        
 385 // assign ex2_div_res = ex2_mdu_op == `LSOC1K_MDU_DIV_W  ? div_w   :                                                                                                                                  
 386 //                      ex2_mdu_op == `LSOC1K_MDU_MOD_W  ? mod_w   :                                                                                                                                  
 387 //                      ex2_mdu_op == `LSOC1K_MDU_DIV_WU ? div_wu  :                                                                                                                                  
 388 //                      ex2_mdu_op == `LSOC1K_MDU_MOD_WU ? mod_wu  :                                                                                                                                  
 389 //                                                         32'd0   ;                                                                                                                                  
 390 `endif 
``````

原因是：LA32给了mul和div模块，LA64里没给，直接这么对付了。。。所以才会有上面重复的ex2_mdu_a和mul_a，div_a
ex1_mdu_a在ex1_stage里分别成为ex2_mdu_a和mul_a或div_a，代码如下
```````verilog
 552 //mdu                                                                                                                                                                                                 
 553 always @(posedge clk) begin                                                                                                                                                                           
 554     if (ex1_allow_in) begin                                                                                                                                                                           
 555         ex2_mdu_op <= ex1_mdu_op;                                                                                                                                                                     
 556         ex2_mdu_a  <= ex1_mdu_a_lsu_fw ? ex1_lsu_fw_data : ex1_mdu_a;                                                                                                                                 
 557         ex2_mdu_b  <= ex1_mdu_b_lsu_fw ? ex1_lsu_fw_data : ex1_mdu_b;                                                                                                                                 
 558     end                                                                                                                                                                                               
 559 end                                                                                                                                                                                                   
 560                                                                                                                                                                                                       
 561 assign mul_valid  = (((ex1_port0_src == `EX_MUL) && ex1_port0_valid) ||                                                                                                                               
 562                      ((ex1_port1_src == `EX_MUL) && ex1_port1_valid)) ;                                                                                                                               
 563 assign mul_a      = ex1_mdu_a_lsu_fw ? ex1_lsu_fw_data : ex1_mdu_a;                                                                                                                                   
 564 assign mul_b      = ex1_mdu_b_lsu_fw ? ex1_lsu_fw_data : ex1_mdu_b;                                                                                                                                   
 565 assign mul_signed = ex1_mdu_op == `LSOC1K_MDU_MUL_W     ||                                                                                                                                            
 566                     ex1_mdu_op == `LSOC1K_MDU_MULH_W    ||                                                                                                                                            
 567                     ex1_mdu_op == `LSOC1K_MDU_MUL_D     ||                                                                                                                                            
 568                     ex1_mdu_op == `LSOC1K_MDU_MULH_D    ||                                                                                                                                            
 569                     ex1_mdu_op == `LSOC1K_MDU_MULW_D_W  ;                                                                                                                                             
 570 assign mul_double = ex1_mdu_op == `LSOC1K_MDU_MUL_D     ||                                                                                                                                            
 571                     ex1_mdu_op == `LSOC1K_MDU_MULH_D    ||                                                                                                                                            
 572                     ex1_mdu_op == `LSOC1K_MDU_MULH_DU   ;                                                                                                                                             
 573 assign mul_hi     = ex1_mdu_op == `LSOC1K_MDU_MULH_W    ||                                                                                                                                            
 574                     ex1_mdu_op == `LSOC1K_MDU_MULH_WU   ||                                                                                                                                            
 575                     ex1_mdu_op == `LSOC1K_MDU_MULH_D    ||                                                                                                                                            
 576                     ex1_mdu_op == `LSOC1K_MDU_MULH_DU   ;                                                                                                                                             
 577 assign mul_short  = ex1_mdu_op == `LSOC1K_MDU_MUL_W     ||                                                                                                                                            
 578                     ex1_mdu_op == `LSOC1K_MDU_MULH_W    ||                                                                                                                                            
 579                     ex1_mdu_op == `LSOC1K_MDU_MULH_WU   ;                                                                                                                                             
 580                                                                                                                                                                                                       
 581 assign div_valid  = (((ex1_port0_src == `EX_DIV) && ex1_port0_valid) ||                                                                                                                               
 582                      ((ex1_port1_src == `EX_DIV) && ex1_port1_valid)) ;                                                                                                                               
 583 assign div_a      = ex1_mdu_a_lsu_fw ? ex1_lsu_fw_data : ex1_mdu_a;                                                                                                                                   
 584 assign div_b      = ex1_mdu_b_lsu_fw ? ex1_lsu_fw_data : ex1_mdu_b;                                                                                                                                   
 585 assign div_signed = ex1_mdu_op == `LSOC1K_MDU_DIV_W     ||                                                                                                                                            
 586                     ex1_mdu_op == `LSOC1K_MDU_MOD_W     ||                                                                                                                                            
 587                     ex1_mdu_op == `LSOC1K_MDU_DIV_D     ||                                                                                                                                            
 588                     ex1_mdu_op == `LSOC1K_MDU_MOD_D     ;                                                                                                                                             
 589 assign div_double = ex1_mdu_op == `LSOC1K_MDU_DIV_D     ||                                                                                                                                            
 590                     ex1_mdu_op == `LSOC1K_MDU_MOD_D     ||                                                                                                                                            
 591                     ex1_mdu_op == `LSOC1K_MDU_DIV_DU    ||                                                                                                                                            
 592                     ex1_mdu_op == `LSOC1K_MDU_MOD_DU    ;                                                                                                                                             
 593 assign div_mod    = ex1_mdu_op == `LSOC1K_MDU_MOD_W     ||                                                                                                                                            
 594                     ex1_mdu_op == `LSOC1K_MDU_MOD_WU    ||                                                                                                                                            
 595                     ex1_mdu_op == `LSOC1K_MDU_MOD_D     ||                                                                                                                                            
 596                     ex1_mdu_op == `LSOC1K_MDU_MOD_DU    ; 
```````


