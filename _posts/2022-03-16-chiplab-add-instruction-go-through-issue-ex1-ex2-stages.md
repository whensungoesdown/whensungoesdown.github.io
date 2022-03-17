---
title: Chiplab, how instructions go through the issue, ex1 and ex2 stages
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
(还要注意的是ex2_mdu_op，ex2_mdu_a，ex2_mdu_b都是reg类型)

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

原因是：LA32给了mul和div模块，LA64里没给，直接这么对付了。。。除法操作不知道会被verilog生成成啥样，在一个clock里完成除法频率肯定上不去。。
所以才会有上面重复的ex2_mdu_a和mul_a，div_a
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

从ex1_stage里出来以后，在LA64的代码里，ex2_mdu_a，ex2_mdu_b, ex2_mdu_op等就进ex2_stage里去算除法去了。
在条件编译LA32的时候，mul_a, div_a分别在mul64x64, div模块里计算。
这让代码看上去乱了很多，比如ex1_stage参数这里，
`````verilog
 156     //MDU                                                                                                                                                                                             
 157     input [`LSOC1K_MDU_CODE_BIT-1:0] ex2_mdu_op,                                                                                                                                                      
 158     input [`GRLEN-1:0]               ex2_mdu_a,                                                                                                                                                       
 159     input [`GRLEN-1:0]               ex2_mdu_b,                                                                                                                                                       
 160     input                            ex2_mul_ready,                                                                                                                                                   
 161     input [`GRLEN-1:0]               ex2_mul_res,                                                                                                                                                     
 162     `ifdef LA64                                                                                                                                                                                       
 163     output [`GRLEN-1:0]              ex2_div_res,                                                                                                                                                     
 164     `elsif LA32                                                                                                                                                                                       
 165     input [`GRLEN-1:0]               ex2_div_res,                                                                                                                                                     
 166     `endif
`````
ex2_div_res LA64时就是output，LA32时就是input。。。。

我后面就只关注LA32就行了

-------------------
那怎样知道mul或div指令完成了，然后ex2_stage到下一级流水wb呢。更重要的是，mul，div没有完成的时候，上一级ex1_stage里的指令应该stall。
还是跟chiplab里这一套allowin一样的机制，ex2_allow_in没有置1，前面的一系列流水线都会stall。

``````````verilog
 414 //////basic                                                                                                                                                                                           
 415 assign allow_in_temp = wb_allow_in && change;                                                                                                                                                         
 416 assign ex2_allow_in  = allow_in_temp;  ////TODO: MAY WAIT FOR DEBUG  
``````````
同样的ex2_allow_in需要看下后面的wb_allow_in行没行，然后再等change。这个change，就是mul，div或者lsu给出来的，表示结果已经好了。

```````verilog
 482 //result                                                                                                                                                                                              
 483 wire port0_change;                                                                                                                                                                                    
 484 wire port0_alu_change  = (ex2_port0_src == `EX_ALU0  ) && ex2_alu0_valid;                                                                                                                             
 485 wire port0_lsu_change  = (ex2_port0_src == `EX_LSU   ) && lsu_res_valid;                                                                                                                              
 486 wire port0_bru_change  = (ex2_port0_src == `EX_BRU   ) && ex2_bru_valid;                                                                                                                              
 487 wire port0_none_change = (ex2_port0_src == `EX_NONE0 ) && ex2_none0_valid;                                                                                                                            
 488 wire port0_div_change  = (ex2_port0_src == `EX_DIV   ) && ex2_div_valid;// && (div_complete || div_completed);                                                                                        
 489 wire port0_mul_change  = (ex2_port0_src == `EX_MUL   ) && ex2_mul_valid && ex2_mul_ready;                                                                                                             
 490                                                                                                                                                                                                       
 491 wire port1_change;                                                                                                                                                                                    
 492 wire port1_alu_change  = (ex2_port1_src == `EX_ALU1  ) && ex2_alu1_valid;                                                                                                                             
 493 wire port1_lsu_change  = (ex2_port1_src == `EX_LSU   ) && lsu_res_valid;                                                                                                                              
 494 wire port1_bru_change  = (ex2_port1_src == `EX_BRU   ) && ex2_bru_valid;                                                                                                                              
 495 wire port1_none_change = (ex2_port1_src == `EX_NONE1 ) && ex2_none1_valid;                                                                                                                            
 496 wire port1_div_change  = (ex2_port1_src == `EX_DIV   ) && ex2_div_valid;// && (div_complete || div_completed);                                                                                        
 497 wire port1_mul_change  = (ex2_port1_src == `EX_MUL   ) && ex2_mul_valid && ex2_mul_ready;                                                                                                             
 498                                                                                                                                                                                                       
 499 always @(posedge clk) begin                                                                                                                                                                           
 500     if(port0_change) wb_port0_rf_res_lsu <= port0_lsu_change;                                                                                                                                         
 501                                                                                                                                                                                                       
 502     if(port1_change) wb_port1_rf_res_lsu <= port1_lsu_change;                                                                                                                                         
 503                                                                                                                                                                                                       
 504     if(data_data_ok) wb_lsu_res <= ex2_lsu_res;                                                                                                                                                       
 505 end                                                                                                                                                                                                   
 506                                                                                                                                                                                                       
 507 assign port0_change = port0_alu_change || port0_lsu_change || port0_bru_change || port0_none_change || port0_div_change || port0_mul_change || !ex2_port0_valid;                                      
 508 assign port1_change = port1_alu_change || port1_lsu_change || port1_bru_change || port1_none_change || port1_div_change || port1_mul_change || !ex2_port1_valid;                                      
 509                                                                                                                                                                                                       
 510 assign change = port0_change && port1_change;                                                                                                                                                         
 511                                                                                                                                                                                                       
 512 wire [`GRLEN-1:0] port0_res_input = ({`GRLEN{port0_alu_change  }} & ex2_alu0_res     ) |                                                                                                              
 513                                     ({`GRLEN{port0_bru_change  }} & ex2_bru_link_pc  ) |                                                                                                              
 514                                     ({`GRLEN{port0_none_change }} & ex2_none0_result ) |                                                                                                              
 515                                     ({`GRLEN{port0_div_change  }} & ex2_div_res      ) |                                                                                                              
 516                                     ({`GRLEN{port0_mul_change  }} & ex2_mul_res      ) ;                                                                                                              
 517                                                                                                                                                                                                       
 518 wire [`GRLEN-1:0] port1_res_input = ({`GRLEN{port1_alu_change  }} & ex2_alu1_res     ) |                                                                                                              
 519                                     ({`GRLEN{port1_bru_change  }} & ex2_bru_link_pc  ) |                                                                                                              
 520                                     ({`GRLEN{port1_none_change }} & ex2_none1_result ) |                                                                                                              
 521                                     ({`GRLEN{port1_div_change  }} & ex2_div_res      ) |                                                                                                              
 522                                     ({`GRLEN{port1_mul_change  }} & ex2_mul_res      ) ;                                                                                                              
 523                                                                                                                                                                                                       
 524                                                                                                                                                                                                       
 525 always @(posedge clk) begin                                                                                                                                                                           
 526     if (port0_change) begin                                                                                                                                                                           
 527         wb_port0_rf_result <= port0_res_input;                                                                                                                                                        
 528     end                                                                                                                                                                                               
 529 end

 530                                                                                                                                                                                                       
 531 always @(posedge clk) begin                                                                                                                                                                           
 532     if (port1_change) begin                                                                                                                                                                           
 533         wb_port1_rf_result <= port1_res_input;                                                                                                                                                        
 534     end                                                                                                                                                                                               
 535 end 
```````
`````````verilog
 463 always @(posedge clk) begin                                                                                                                                                                           
 464     if (rst || exception || eret || wb_cancel || bru_cancel_all_ex2) begin                                                                                                                            
 465         wb_port0_valid  <= 1'd0;                                                                                                                                                                      
 466         wb_port1_valid  <= 1'd0;                                                                                                                                                                      
 467     end                                                                                                                                                                                               
 468     else if(ex2_allow_in) begin                                                                                                                                                                       
 469         wb_port0_valid  <= ex2_port0_valid && !bru_cancel_all_ex2;                                                                                                                                    
 470         wb_port1_valid  <= ex2_port1_valid && !(port0_cancel || (bru_cancel_ex2 && ex2_bru_port[0] && !bru_ignore_ex2)) && !bru_cancel_all_ex2;                                                       
 471     end                                                                                                                                                                                               
 472     else begin                                                                                                                                                                                        
 473         wb_port0_valid  <= 1'b0;                                                                                                                                                                      
 474         wb_port1_valid  <= 1'b0;                                                                                                                                                                      
 475     end                                                                                                                                                                                               
 476                                                                                                                                                                                                       
 477     if (rst || exception || eret || wb_cancel) wb_port2_valid  <= 1'b0;                                                                                                                               
 478     else if(ex2_allow_in) wb_port2_valid  <= ex2_bru_port[0];                                                                                                                                         
 479     else wb_port2_valid  <= 1'b0;                                                                                                                                                                     
 480 end

`````````


同样的，ex2_stage允许进了，也就把wb_port0_valid置1，如果后面的wb_allow_in是1，就可以交给wb了。


````````````verilog
 463 always @(posedge clk) begin                                                                                                                                                                           
 464     if (rst || exception || eret || wb_cancel || bru_cancel_all_ex2) begin                                                                                                                            
 465         wb_port0_valid  <= 1'd0;                                                                                                                                                                      
 466         wb_port1_valid  <= 1'd0;                                                                                                                                                                      
 467     end                                                                                                                                                                                               
 468     else if(ex2_allow_in) begin                                                                                                                                                                       
 469         wb_port0_valid  <= ex2_port0_valid && !bru_cancel_all_ex2;                                                                                                                                    
 470         wb_port1_valid  <= ex2_port1_valid && !(port0_cancel || (bru_cancel_ex2 && ex2_bru_port[0] && !bru_ignore_ex2)) && !bru_cancel_all_ex2;                                                       
 471     end                                                                                                                                                                                               
 472     else begin                                                                                                                                                                                        
 473         wb_port0_valid  <= 1'b0;                                                                                                                                                                      
 474         wb_port1_valid  <= 1'b0;                                                                                                                                                                      
 475     end                                                                                                                                                                                               
 476                                                                                                                                                                                                       
 477     if (rst || exception || eret || wb_cancel) wb_port2_valid  <= 1'b0;                                                                                                                               
 478     else if(ex2_allow_in) wb_port2_valid  <= ex2_bru_port[0];                                                                                                                                         
 479     else wb_port2_valid  <= 1'b0;                                                                                                                                                                     
 480 end
 
 ``````````````


-------------------------------

突然有个想法，ex1_stage和ex2_stage，会不会有一个是多余的。比如只保留ex1_stage，可以完成整数指令，mul，div都可以在这个阶段发出，
等带结果出来以后带到wb去。
我现在能想到的其它问题，就是csr指令在哪个阶段完成，LSU是怎样实现的。

找了下LSU，ex1_stage里有lsu_s1，ex2_stage里有lsu_s2。还没仔细看这两个模块，但参数有点意思，lsu_s1里面是memory interface，lsu_s2里
是cache interface。

````````````verilog
  4 module lsu_s1(                                                                                                                                                                                         
  5   input               clk,                                                                                                                                                                             
  6   input               resetn,                                                                                                                                                                          
  7                                                                                                                                                                                                        
  8   input               valid,                                                                                                                                                                           
  9   input [`LSOC1K_LSU_CODE_BIT-1:0]lsu_op,                                                                                                                                                              
 10   input [`GRLEN-1:0]  base,                                                                                                                                                                            
 11   input [`GRLEN-1:0]  offset,                                                                                                                                                                          
 12   input [`GRLEN-1:0]  wdata,                                                                                                                                                                           
 13                                                                                                                                                                                                        
 14   input               tlb_req,                                                                                                                                                                         
 15   input               data_exception,                                                                                                                                                                  
 16   input   [`GRLEN-1:0]data_badvaddr,                                                                                                                                                                   
 17   input               tlb_finish,                                                                                                                                                                      
 18                                                                                                                                                                                                        
 19   //memory interface                                                                                                                                                                                   
 20   output              data_req,                                                                                                                                                                        
 21   output [`GRLEN-1:0] data_addr,                                                                                                                                                                       
 22   output              data_wr,                                                                                                                                                                         
 23   `ifdef LA64                                                                                                                                                                                          
 24   output [ 7:0]       data_wstrb,                                                                                                                                                                      
 25   `elsif LA32                                                                                                                                                                                          
 26   output [ 3:0]       data_wstrb,                                                                                                                                                                      
 27   `endif                                                                                                                                                                                               
 28   output [`GRLEN-1:0] data_wdata,                                                                                                                                                                      
 29   output              data_prefetch,                                                                                                                                                                   
 30   output              data_ll,                                                                                                                                                                         
 31   output              data_sc,                                                                                                                                                                         
 32   input               data_addr_ok,                                                                                                                                                                    
 33                                                                                                                                                                                                        
 34 //result                                                                                                                                                                                               
 35   output              lsu_finish,                                                                                                                                                                      
 36   output              lsu_ale,                                                                                                                                                                         
 37   output              lsu_adem,                                                                                                                                                                        
 38   output              lsu_recv,                                                                                                                                                                        
 39                                                                                                                                                                                                        
 40   input [`LSOC1K_CSR_OUTPUT_BIT-1:0] csr_output,                                                                                                                                                       
 41   input                              change,                                                                                                                                                           
 42   input                              eret,                                                                                                                                                             
 43   input                              exception,                                                                                                                                                        
 44   output reg [`GRLEN-1:0]            badvaddr                                                                                                                                                          
 45 ); 
````````````
