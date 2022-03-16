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
