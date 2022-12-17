---
title: 怎样新加一个功能性模块
published: true
---

最开始的ALU指令，5个cycle完成。

后面加了load store指令。 store还好，没有延迟，而load指令取决与cache，如果cache miss，就肯定不可能在一个周期里返回了。

cache miss，也还要看cache line refill要多久。

而load指令还是需要把结果写回寄存器的，所以有rd_idx, rd_data，同时也要有wen信号。

如果load指令的实现是封装在lsu模块里的，那lsu模块就要自己保存rd_idx rd_data wen信号。

因为从_e以后就和exu_ecl保存的alu指令相关的rd_idx rd_data就已经不同步了，LSU要自己维护这些，等到_m的时候返回给exu_ecl模块。

exu_ecl在_m这里就需要2个mux，一个是rd_idx的mux，一个是rd_data的mux。

`````verilog
 726    //                                                                                                                                        
 727    // rd_data mux                                                                                                                            
 728    //                                                                                                                                        
 729                                                                                                                                              
 730    wire [`GRLEN-1:0] rd_data_m;                                                                                                              
 731    wire [`GRLEN-1:0] rd_data_w;                                                                                                              
 732                                                                                                                                              
 733                                                                                                                                              
 734    wire rddata_sel_alu_res_m_l;                                                                                                              
 735    wire rddata_sel_lsu_res_m_l;                                                                                                              
 736    wire rddata_sel_bru_res_m_l;                                                                                                              
 737    wire rddata_sel_mul_res_m_l;                                                                                                              
 738                                                                                                                                              
 739    // uty: todo                                                                                                                              
 740    // alu better has a valid signal                                                                                                          
 741    assign rddata_sel_alu_res_m_l = (lsu_ecl_rdata_valid_m | bru_wen_m | mul_valid_m); // default is alu resulst if no other module claims it 
 742    assign rddata_sel_lsu_res_m_l = ~lsu_ecl_rdata_valid_m;                                                                                   
 743    assign rddata_sel_bru_res_m_l = ~bru_wen_m;   // bru's rd go with ALU's                                                                   
 744    assign rddata_sel_mul_res_m_l = ~mul_valid_m; // mul's rd go with ALU's                                                                   
 745                                                                                                                                              
 746    dp_mux4ds #(`GRLEN) rd_data_mux(.dout  (rd_data_m),                                                                                       
 747                           .in0   (alu_res_m),                                                                                                
 748                           .in1   (lsu_ecl_rdata_m),                                                                                          
 749                           .in2   (bru_link_pc_m),                                                                                            
 750                           .in3   (mul_byp_res_m),                                                                                            
 751                           .sel0_l (rddata_sel_alu_res_m_l),                                                                                  
 752                           .sel1_l (rddata_sel_lsu_res_m_l),                                                                                  
 753                           .sel2_l (rddata_sel_bru_res_m_l),                                                                                  
 754                           .sel3_l (rddata_sel_mul_res_m_l));
 755                                                                                                                                              
 756                                                                                                                                              
 757    dff_s #(`GRLEN) rd_data_w_reg (                                                                                                           
 758       .din (rd_data_m),                                                                                                                      
 759       .clk (clk),                                                                                                                            
 760       .q   (rd_data_w),                                                                                                                      
 761       .se(), .si(), .so());                                                                                                                  
 762                                                                                                                                              
 763    assign ecl_irf_rd_data_w = rd_data_w;
`````

这里面有alu的结果，lsu的，bru的，还有mul的。

bru是因为jirl指令要把pc+4写到一个指定的寄存器。

mul虽然也是一个cycle完成，但它和bru一样，结果都不是alu模块里给出的，所以各个模块最终得到的结果要回来mux选一下。

再看rd_mux:

`````verilog
 672    //                                                                                                                                        
 673    //  rd mux                                                                                                                                
 674    //                                                                                                                                        
 675    // Instructions other than ALU have longer pipeline.                                                                                      
 676    // they should maintain their own rd and mux them here at _m                                                                              
 677    // ALU instructions take exactly 5 cyclc.                                                                                                 
 678    //                                                                                                                                        
 679    // BRU and MUL share ALU's rd because they exactly follow the 5 stage pipeline.                                                           
 680    // LSU takes uncertain cycles. It keeps record of its own rd.                                                                             
 681    //                                                                                                                                        
 682                                                                                                                                              
 683    wire [4:0] rd_m;                                                                                                                          
 684    wire [4:0] rd_w;                                                                                                                          
 685                                                                                                                                              
 686    dp_mux2es #(5) rd_mux(                                                                                                                    
 687       .dout (rd_m),                                                                                                                          
 688       .in0  (rf_target_m),                                                                                                                   
 689       .in1  (lsu_ecl_rd_m),                                                                                                                  
 690       .sel  (lsu_ecl_rdata_valid_m));                                                                                                        
 691                                                                                                                                              
 692    dff_s #(5) rd_m2w_reg (                                                                                                                   
 693       .din (rd_m),                                                                                                                           
 694       .clk (clk),                                                                                                                            
 695       .q   (rd_w),                                                                                                                           
 696       .se(), .si(), .so());                                                                                                                  
 697                                                                                                                                              
 698    assign ecl_irf_rd_w = rd_w;
`````

这个选的比较少，只是2选1。是因为比较懒bru和mul的rd编在指令里都一样，并且需要的cycle一样，所以exu_ecl里这一路保存下来的rd，对bru和mul来说是正确的。

如果加div模块，不能在一个周期里完成，这时候也需要div模块自己保存rd，在这里mux。

而lsu则不同，比如当lsu返回结果的时候是_e以后的10个cycle，这时候exu_ecl里的rd早就传过去了，所以lsu要自己维护rd，这个时候再传回来用这个正确的。

当然，这里也可让rd的dff带个enable，如果lsu没有返回就不更新。不过exu_ecl里的rd的这几个dffs，是alu指令的，也不能让alu指令也等着lsu的信号吧。

`````verilog
 701    //                                                                                                                                        
 702    // wen mux                                                                                                                                
 703    //                                                                                                                                        
 704                                                                                                                                              
 705    wire wen_m;                                                                                                                               
 706    wire wen_w;                                                                                                                               
 707                                                                                                                                              
 708 //   dp_mux2es #(1) wen_mux(                                                                                                                 
 709 //      .dout (wen_m),                                                                                                                       
 710 //      .in0  (alu_wen_m),                                                                                                                   
 711 //      .in1  (lsu_ecl_wen_m),                                                                                                               
 712 //      .sel  (lsu_ecl_rdata_valid_m));                                                                                                      
 713                                                                                                                                              
 714    // set the wen if any module claims it                                                                                                    
 715    assign wen_m = alu_wen_m | (lsu_ecl_wen_m & lsu_ecl_rdata_valid_m) | bru_wen_m | mul_wen_m;                                               
 716                                                                                                                                              
 717    dff_s #(1) wen_m2w_reg (                                                                                                                  
 718       .din (wen_m),                                                                                                                          
 719       .clk (clk),                                                                                                                            
 720       .q   (wen_w),                                                                                                                          
 721       .se(), .si(), .so());                                                                                                                  
 722                                                                                                                                              
 723    assign ecl_irf_wen_w = wen_w;
`````

wen这里开始也想搞个mux，不过最终只有一个regfile可以写，又是单发射的，所以各个维护的wen或在一起就好。

这里lsu_ecl_wen_m & lsu_ecl_rdata_valid_m搞的和其它的模块不统一，回头还要再搞一下。

不过对于lsu来说，wen是确定的，但是否能成功读到结果还不一定，比如地址不正确，或者权限问题，可能是要raise exception。

-------------------------------------------------------------


现在要加csr模块，先不考虑cache和tlb相关的，就考虑几个控制状态寄存器。

一共3条指令：csrrd，csrwr，csrxchg。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-12-17-0.png)

这三条指令都要把csr寄存器里的值写到regfile 的rd里。

也就是说_w的部分还是需要，不用变。

而读csr寄存器的时候可以放到_d，和regfile一起读出来再选。

csrrw和csrxchg指令还要写csr寄存器，特别是csrxchg还要加个bit mask再写回csr寄存器。

那就是在_d读，在_e写。csr的旧值在_m返回给exu_ecl做选择。

还要注意的是，csrwr里既要从rd中先读数据，写进csr，有要把csr的旧值写回rd。

![screenshot1](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-12-17-1.png)

从指令编码上看csr这三条指令csr_num都有14bit，2^14=16384，LoongArch32手册里已经定义出的csr寄存器编码是到0x181，也就是385。

有一个rj编码的地方，csrxchg回用到rj里的值作为掩码，但rj不能是0或1，因为csrrd和csrwr是把rj当作了op的一部分。

这里就不是很明白了，为什么不能把op多出来2bit，csr_num减少为12bit，4096也够用啊。

难道是为了解码的时候不出现illegal instruction？

chiplab里的decoder模块确实没有illegal instruction这个信号给出去。

`````verilog
  4 module decoder (                                                                                                                              
  5     input  [31:0] inst,                                                                                                                       
  6     output [`LSOC1K_DECODE_RES_BIT-1:0] res                                                                                                   
  7 );
`````

lsoc1000_stage_de2.v里也没见到illegal instruction的异常。

`````verilog
wire port0_exception = de2_port0_exception   || port0_op[`LSOC1K_SYSCALL] || port0_op[`LSOC1K_BREAK ] || port0_op[`LSOC1K_INE] ||
                       port0_fpd || port0_ipe || int_except;
wire port1_exception = de2_port1_exception   || port1_op[`LSOC1K_SYSCALL] || port1_op[`LSOC1K_BREAK ] || port1_op[`LSOC1K_INE] ||
                       port1_fpd || port1_ipe;
wire port2_exception = de2_port2_exception   || port2_op[`LSOC1K_SYSCALL] || port2_op[`LSOC1K_BREAK ] || port2_op[`LSOC1K_INE] ||
                       port2_fpd || port2_ipe;

wire [5:0] port0_exccode = int_except                ? `EXC_INT          :
                           de2_port0_exception       ? de2_port0_exccode :
                           port0_op[`LSOC1K_SYSCALL] ? `EXC_SYS          :
                           port0_op[`LSOC1K_BREAK  ] ? `EXC_BRK          :
                           port0_op[`LSOC1K_INE    ] ? `EXC_INE          :
                           port0_fpd                 ? `EXC_FPD          :
                                                       6'd0              ;
wire [5:0] port1_exccode = de2_port1_exception       ? de2_port1_exccode :
                           port1_op[`LSOC1K_SYSCALL] ? `EXC_SYS          :
                           port1_op[`LSOC1K_BREAK  ] ? `EXC_BRK          :
                           port1_op[`LSOC1K_INE    ] ? `EXC_INE          :
                           port1_fpd                 ? `EXC_FPD          :
                                                       6'd0              ;
wire [5:0] port2_exccode = de2_port2_exception       ? de2_port2_exccode :
                           port2_op[`LSOC1K_SYSCALL] ? `EXC_SYS          :
                           port2_op[`LSOC1K_BREAK  ] ? `EXC_BRK          :
                           port2_op[`LSOC1K_INE    ] ? `EXC_INE          :
                           port2_fpd                 ? `EXC_FPD          :
                                                       6'd0              ;
`````

而且看了下才刚发现，loongarch32的指令编码里，是没有riscv那样的func3, func7这样的opcode段。

不知道mips是不是这样。

mips R-type指令里也是有6-bit的func。

后来搜了下，原来mips就只有3种format，R-format I-format J-format。

![screenshot2](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-12-17-2.png)


搜到个mips的opcode的图还挺好的

![screenshot3](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-12-17-3.png)
