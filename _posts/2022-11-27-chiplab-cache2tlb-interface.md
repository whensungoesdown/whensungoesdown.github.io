---
title: chiplab里cache向tlb模块查询物理地址的信号
published: true
---


cache模块向tlbwrapper模块发请求，给出vaddr，要求得到paddr。

因为现在只有machine mode，没有虚实地址转换，所以直接把vaddr返回来作为paddr就行。

icache发的请求就是这3个信号。

`````verilog
 23     input               inst_tlb_req  ,                                                                                             
 24     input   [`GRLEN-1:0] inst_tlb_vaddr,                                                                                            
 25     input               inst_tlb_cacop, 
`````
inst_tlb_cacop还没搞清楚是啥，也没管。

需要返回的信号是这几个output。

`````verilog
 42     // tlb-cache interface                                                                                                          
 43     output  [`PABITS-1:0]      itlb_paddr,                                                                                          
 44     output              itlb_finish,                                                                                                
 45     output              itlb_hit,                                                                                                   
 46     input               itlb_cache_recv,                                                                                            
 47     output              itlb_uncache,                                                                                               
 48     output  [ 5:0]      itlb_exccode,
`````

chiplab里的tlb似乎是需要2个cycle完成应答。

第一个cycle发出inst_tlb_req inst_tlb_vaddr，后一个cycle里给出itlb_paddr itlb_finish itlb_hit itlb_uncache。

dcache也是差不多的接口。

`````verilog
 51     output  [`PABITS-1:0]      dtlb_paddr,                                                                                          
 52     output              dtlb_finish,                                                                                                
 53     output              dtlb_hit,                                                                                                   
 54     input               data_tlb_req,                                                                                               
 55     input               data_tlb_wr   ,                                                                                             
 56     input   [`GRLEN-1:0]data_tlb_vaddr,                                                                                             
 57     input               dtlb_cache_recv,                                                                                            
 58     input               dtlb_no_trans  ,                                                                                            
 59     input               dtlb_p_pgcl    ,                                                                                            
 60     output              dtlb_uncache,                                                                                               
 61     output  [ 5:0]      dtlb_exccode,
`````

icache只要把itlb_finish和itlb_hit设1，itlb_uncache设0，assign dtlb_paddr = data_tlb_vaddr;就行。

而dcache是必须在data_tlb_req发出的下一个cycle返回dtlb_paddr和dtlb_finish设1。dtlb_hit可以一直为1，dtlb_uncache一直为0。

主要是代码里具体的实现，不过不想深究这里的tlb了，所以搞了简单的方法把tlbwrapper tlb模块都去掉，还有csr模块，和tlb有关联，之前也没删。

下面这段代码满足应答就能让cache凑合着工作。

`````verilog
 277 //   assign itlb_finish  = 1'b1;                                                                                                   
 278    dff_s #(1) itlb_finish_reg (                                                                                                    
 279       .din (inst_tlb_req),                                                                                                         
 280       .clk (clk),                                                                                                                  
 281       .q   (itlb_finish),                                                                                                          
 282       .se(), .si(), .so());                                                                                                        
 283    assign itlb_hit     = 1'b1;                                                                                                     
 284    assign itlb_uncache = 1'b0;                                                                                                     
 285 //   assign itlb_paddr   = inst_tlb_vaddr[`PABITS-1:0];                                                                            
 286    dff_s #(`PABITS) itlb_paddr_reg (                                                                                               
 287       .din (inst_tlb_vaddr[`PABITS-1:0]),                                                                                          
 288       .clk (clk),                                                                                                                  
 289       .q   (itlb_paddr),                                                                                                           
 290       .se(), .si(), .so());                                                                                                        
 291                                                                                                                                    
 292                                                                                                                                    
 293    dff_s #(1) dtlb_finish_reg (                                                                                                    
 294       .din (data_tlb_req),                                                                                                         
 295       .clk (clk),                                                                                                                  
 296       .q   (dtlb_finish),                                                                                                          
 297       .se(), .si(), .so());                                                                                                        
 298 //   assign dtlb_finish  = 1'b1;                                                                                                   
 299    assign dtlb_hit     = 1'b1;                                                                                                     
 300    assign dtlb_uncache = 1'b0;                                                                                                     
 301    dff_s #(`PABITS) dtlb_paddr_reg (                                                                                               
 302       .din (data_tlb_vaddr[`PABITS-1:0]),                                                                                          
 303       .clk (clk),                                                                                                                  
 304       .q   (dtlb_paddr),                                                                                                           
 305       .se(), .si(), .so());                                                                                                        
 306    //assign dtlb_paddr   = data_tlb_vaddr[`PABITS-1:0];
`````

其它还有几个cache相关的信号，看了下一直都是0，也没管。

`````verilog
 35     output              tlb_req         ,                                                                                           
 36     output              cache_req       ,                                                                                           
 37     output  [4 :0]      cache_op        ,                                                                                           
 38     output [`D_TAG_LEN-1:0] cache_op_tag,                                                                                           
 39     input               cache_op_recv   ,                                                                                           
 40     input               cache_op_finish ,
`````
