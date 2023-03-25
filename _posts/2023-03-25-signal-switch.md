---
title: 以前经常用的信号开关，dff得加上reset
published: true
---

`````verilog
 100    wire rdata_valid_next;                                                                                                                    
 101                                                                                                                                              
 102    assign rdata_valid_next = (rdata_valid | ar_enter) & (~m_rready);                                                                         
 103                                                                                                                                              
 104    dff_s #(1) rdata_valid_reg (                                                                                                              
 105       .din (rdata_valid_next),                                                                                                               
 106       .clk (aclk),                                                                                                                           
 107       .q   (rdata_valid),                                                                                                                    
 108       .se(), .si(), .so()); 
`````

这里有个问题，如果ar_enter如果不为1，或者m_rready没有为1过，这时候rdata_valid是x。

所以这段代码在刚reset以后，rdata_valid可能会有一段x的时候。

所以这个dff得用带reset的。

`````verilog
 100    wire rdata_valid_next;                                                                                                                    
 101                                                                                                                                              
 102    assign rdata_valid_next = (rdata_valid | ar_enter) & (~m_rready);                                                                         
 103                                                                                                                                              
 104    dffrl_s #(1) rdata_valid_reg (                                                                                                            
 105       .din   (rdata_valid_next),                                                                                                             
 106       .clk   (aclk),                                                                                                                         
 107       .rst_l (aresetn),                                                                                                                      
 108       .q     (rdata_valid),                                                                                                                  
 109       .se(), .si(), .so());
`````
