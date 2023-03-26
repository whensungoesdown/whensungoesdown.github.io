---
title: 经常用的信号开关的两个问题，1.dff得加上reset 2.结束信号来得太早，比开始信号还早
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

----------------------------------------------------------


`````verilog
assign rdata_valid_next = (rdata_valid | ar_enter) & (~m_rready);                                                                         
                                                                                                                                          
dffrl_s #(1) rdata_valid_reg (                                                                                                            
   .din   (rdata_valid_next),                                                                                                             
   .clk   (aclk),                                                                                                                         
   .rst_l (aresetn),                                                                                                                      
   .q     (rdata_valid),                                                                                                              
   .se(), .si(), .so()); 
`````

开始信号是ar_enter，结束信号是m_rready。

`````shell
ar_enter           __--______________

m_rready           ______________--__

rdata_valid        ____------------__

rdata_valid_next   __------------____

`````

选择用rdata_valid还是rdata_valid_next，效果会有一些差别。

但现在遇到了一个新问题，就是m_rready给出的比ar_enter还要早。

m_rready是master给出的，表示随时可以接收slave的数据，可以比rvalid给出的早，以为R和AR是不同的两个channel，所以没说rready不能比ar_valid早。

![read_transaction_dependencies](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/read_transaction_dependencies.png)

虽然图上看着这两个箭头rvalid是不能比arvalid或arready早的，但同时给出arvalid和rready也许是可以的。

>  In the dependency diagrams:
>  • Single-headed arrows point to signals that can be asserted before or after the signal at the start of the arrow.
>  • Double-headed arrows point to signals that must be asserted only after assertion of the signal at the start of
>  the arrow.

从图上看rready是不能比arreday早的，而arready是slave给出的，这个可以给的很早。

而rready是不能比arvalid早，但没说要晚一个cycle以后。

就是下面这种情况：

rready和arvalid在tb里是同时给出来的。也可以让rready稍微晚一点，还是在下个rising edge之前，这样手册字面上就没问题了。

![rready_ahead_rvalid_more_than_1_cycle](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/rready_ahead_rvalid_more_than_1_cycle.png)

还是直接说问题，因为之前的写操作（WR W B）还没完成，所以busy一直是1，导致后面的AR操作要等busy为0，所以ar_enter是比arvalid和rready还要晚。

因为结束信号比开始信号来的还早，这就导致了上面rdata_valid，也就是控制rvalid的信号无法变成1了。

所以这种情况，就需要，即使结束信号比开始信号还要早，或者同时来，当开始信号来的时候，至少要让rdata_valid high一个cycle。

解决方法就是rdata_valid | ar_enter; 这样ar_enter来了，至少能high一个cycle。

`````verilog
 128    assign rdata_valid_next = (rdata_valid | ar_enter) & (~m_rready);                                                                         
 129    //assign rdata_valid_next = (rdata_valid | ar_enter) & (~rready);                                                                         
 130                                                                                                                                              
 131    dffrl_s #(1) rdata_valid_reg (                                                                                                            
 132       .din   (rdata_valid_next),                                                                                                             
 133       .clk   (aclk),                                                                                                                         
 134       .rst_l (aresetn),                                                                                                                      
 135       .q     (rdata_valid_tmp),                                                                                                              
 136       .se(), .si(), .so());                                                                                                                  
 137                                                                                                                                              
 138                                                                                                                                              
 139    wire ar_enter_delay1;                                                                                                                     
 140                                                                                                                                              
 141    dffrl_s #(1) ar_enter_delay1_reg (                                                                                                        
 142       .din   (ar_enter),                                                                                                                     
 143       .clk   (aclk),                                                                                                                         
 144       .rst_l (aresetn),                                                                                                                      
 145       .q     (ar_enter_delay1),                                                                                                              
 146       .se(), .si(), .so());                                                                                                                  
 147                                                                                                                                              
 148    // rdata_valid show up at lease one cycle                                                                                                 
 149    assign rdata_valid = rdata_valid_tmp | ar_enter_delay1;
`````

这里给ar_enter一个dff，是因为当ar_enter为1时，刚读到addr，要到下一个cycle，数据才能读出来，所以ar_enter要延时一个cycle，和rdata一起给出。

上面代码还有一个地方要注意，ar_enter_delay1_reg的输入是另一个dff的输出，这种在reset的时候会有一个cycle的x。这个x还会传递。

所以要加reset。

自己还没总结出什么样的dff要带reset，但至少今天试的情况来看，如果要延时几个cycle，这样的dff都应该带reset。

![rready_ahead_rvalid_more_than_1_cycle_fix](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/rready_ahead_rvalid_more_than_1_cycle_fix.png)


