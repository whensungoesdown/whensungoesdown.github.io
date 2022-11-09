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
