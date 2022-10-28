---
title: LSU里遇到的处理lsu_op解码的问题
published: true
---

lsu_op需要解码，需要分清是load还是store指令，分别是byte word 还是dword等等。

发出读和写请求都是在_e阶段，但如果是写操作，数据和地址发出去后，等结果就行了。

而读请求需要在_e发出请求，如果地址正确的话会在同cycle里马上会得到个data_addr_ok。

而数据要在后面n个周期才会回来。 这个阶段都叫做_m，但具体几个cycle，不能确定，因为会遇到cache miss。

读数据回来后，需要根据lsu_op找出这个读指令是读byte还是word等。

而lsu_op实际上是lsu_op_e，这时候已经没有了，必须用dff保存一份。

所以这里我用带enable的dff，在lsu_op传进来的时候就存起来，用valid做en。

`````verilog
  70    // lsu_op needs dff, the following combinational logic is only used when data_data_ok is signaled at _m                                                                                                    
  71    wire [`LSOC1K_LSU_CODE_BIT-1:0]    lsu_op_m;                                                                                                                                                               
  72                                                                                                                                                                                                               
  73    dffe_s #(`LSOC1K_LSU_CODE_BIT) lsu_op_e2m_reg (                                                                                                                                                            
  74       .din (lsu_op),                                                                                                                                                                                          
  75       .en  (valid),                                                                                                                                                                                           
  76       .clk (clk),                                                                                                                                                                                             
  77       .q   (lsu_op_m),                                                                                                                                                                                        
  78       .se(), .si(), .so());                                                                                                                                                                                   
  79                                                                                                                                                                                                               
  80    // lsu_op is decoded at _e                                                                                                                                                                                 
  81    // lsu_op_m is decoded at _m                                                                                                                                                                               
  82                                                                                                                                                                                                               
  83    // LSUop decoder                                                                                                                                                                                           
  84    wire lsu_am      = lsu_op == `LSOC1K_LSU_AMSWAP_W    || lsu_op == `LSOC1K_LSU_AMSWAP_D    || lsu_op == `LSOC1K_LSU_AMADD_W     || lsu_op == `LSOC1K_LSU_AMADD_D     ||                                     
  85                       lsu_op == `LSOC1K_LSU_AMAND_W     || lsu_op == `LSOC1K_LSU_AMAND_D     || lsu_op == `LSOC1K_LSU_AMOR_W      || lsu_op == `LSOC1K_LSU_AMOR_D      ||                                     
  86                       lsu_op == `LSOC1K_LSU_AMXOR_W     || lsu_op == `LSOC1K_LSU_AMXOR_D     || lsu_op == `LSOC1K_LSU_AMMAX_W     || lsu_op == `LSOC1K_LSU_AMMAX_D     ||                                     
  87                       lsu_op == `LSOC1K_LSU_AMMIN_W     || lsu_op == `LSOC1K_LSU_AMMIN_D     || lsu_op == `LSOC1K_LSU_AMMAX_WU    || lsu_op == `LSOC1K_LSU_AMMAX_DU    ||                                     
  88                       lsu_op == `LSOC1K_LSU_AMMIN_WU    || lsu_op == `LSOC1K_LSU_AMMIN_DU    || lsu_op == `LSOC1K_LSU_AMSWAP_DB_W || lsu_op == `LSOC1K_LSU_AMSWAP_DB_D ||                                     
  89                       lsu_op == `LSOC1K_LSU_AMADD_DB_W  || lsu_op == `LSOC1K_LSU_AMADD_DB_D  || lsu_op == `LSOC1K_LSU_AMAND_DB_W  || lsu_op == `LSOC1K_LSU_AMAND_DB_D  ||                                     
  90                       lsu_op == `LSOC1K_LSU_AMOR_DB_W   || lsu_op == `LSOC1K_LSU_AMOR_DB_D   || lsu_op == `LSOC1K_LSU_AMXOR_DB_W  || lsu_op == `LSOC1K_LSU_AMXOR_DB_D  ||                                     
  91                       lsu_op == `LSOC1K_LSU_AMMAX_DB_W  || lsu_op == `LSOC1K_LSU_AMMAX_DB_D  || lsu_op == `LSOC1K_LSU_AMMIN_DB_W  || lsu_op == `LSOC1K_LSU_AMMIN_DB_D  ||                                     
  92                       lsu_op == `LSOC1K_LSU_AMMAX_DB_WU || lsu_op == `LSOC1K_LSU_AMMAX_DB_DU || lsu_op == `LSOC1K_LSU_AMMIN_DB_WU || lsu_op == `LSOC1K_LSU_AMMIN_DB_DU ;                                      
  93                                                                                                                                                                                                               
  94    wire lsu_am_m    = lsu_op_m == `LSOC1K_LSU_AMSWAP_W    || lsu_op_m == `LSOC1K_LSU_AMSWAP_D    || lsu_op_m == `LSOC1K_LSU_AMADD_W     || lsu_op_m == `LSOC1K_LSU_AMADD_D     ||                             
  95                       lsu_op_m == `LSOC1K_LSU_AMAND_W     || lsu_op_m == `LSOC1K_LSU_AMAND_D     || lsu_op_m == `LSOC1K_LSU_AMOR_W      || lsu_op_m == `LSOC1K_LSU_AMOR_D      ||                             
  96                       lsu_op_m == `LSOC1K_LSU_AMXOR_W     || lsu_op_m == `LSOC1K_LSU_AMXOR_D     || lsu_op_m == `LSOC1K_LSU_AMMAX_W     || lsu_op_m == `LSOC1K_LSU_AMMAX_D     ||                             
  97                       lsu_op_m == `LSOC1K_LSU_AMMIN_W     || lsu_op_m == `LSOC1K_LSU_AMMIN_D     || lsu_op_m == `LSOC1K_LSU_AMMAX_WU    || lsu_op_m == `LSOC1K_LSU_AMMAX_DU    ||                             
  98                       lsu_op_m == `LSOC1K_LSU_AMMIN_WU    || lsu_op_m == `LSOC1K_LSU_AMMIN_DU    || lsu_op_m == `LSOC1K_LSU_AMSWAP_DB_W || lsu_op_m == `LSOC1K_LSU_AMSWAP_DB_D ||                             
  99                       lsu_op_m == `LSOC1K_LSU_AMADD_DB_W  || lsu_op_m == `LSOC1K_LSU_AMADD_DB_D  || lsu_op_m == `LSOC1K_LSU_AMAND_DB_W  || lsu_op_m == `LSOC1K_LSU_AMAND_DB_D  ||                             
 100                       lsu_op_m == `LSOC1K_LSU_AMOR_DB_W   || lsu_op_m == `LSOC1K_LSU_AMOR_DB_D   || lsu_op_m == `LSOC1K_LSU_AMXOR_DB_W  || lsu_op_m == `LSOC1K_LSU_AMXOR_DB_D  ||                             
 101                       lsu_op_m == `LSOC1K_LSU_AMMAX_DB_W  || lsu_op_m == `LSOC1K_LSU_AMMAX_DB_D  || lsu_op_m == `LSOC1K_LSU_AMMIN_DB_W  || lsu_op_m == `LSOC1K_LSU_AMMIN_DB_D  ||                             
 102                       lsu_op_m == `LSOC1K_LSU_AMMAX_DB_WU || lsu_op_m == `LSOC1K_LSU_AMMAX_DB_DU || lsu_op_m == `LSOC1K_LSU_AMMIN_DB_WU || lsu_op_m == `LSOC1K_LSU_AMMIN_DB_DU ;             
`````

后面的解码就在_m的时候再解码一遍，因为_e和_m都需要用解码的信息。


这里提个问题。

一开始想用dff保存解码后的结果，比如直接保存lsu_am。

但问题是解码的组合逻辑也是需要时间的，如果先解码再传给dff，就可能不满足dff的setup时间。

同样的原因，base+offset选择再lsu里_e的时候做加法，就没办法在_e里保存加法的结果。

`````verilog
 243    wire [`GRLEN-1:0]    addr         = base + offset;                                                                                                                                                         
 244    wire [ 2:0]          shift        = addr[2:0];                                                                                                                                                             
 245    wire                 lsu_wr       = lsu_sw || lsu_sb || lsu_sh || lsu_scw || lsu_scd || lsu_sd;                                                                                                            
 246                                                                                                                                                                                                               
 247                                                                                                                                                                                                               
 248    wire [`GRLEN-1:0]    base_m;                                                                                                                                                                               
 249    wire [`GRLEN-1:0]    offset_m;                                                                                                                                                                             
 250                                                                                                                                                                                                               
 251    wire [`GRLEN-1:0]    addr_m       = base_m + offset_m;                                                                                                                                                     
 252    wire [ 2:0]          shift_m      = addr_m[2:0];                                                                                                                                                           
 253                                                                                                                                                                                                               
 254    dffe_s #(`GRLEN) base_e2m_reg (                                                                                                                                                                            
 255       .din (base),                                                                                                                                                                                            
 256       .en  (valid),                                                                                                                                                                                           
 257       .clk (clk),                                                                                                                                                                                             
 258       .q   (base_m),                                                                                                                                                                                          
 259       .se(), .si(), .so());                                                                                                                                                                                   
 260                                                                                                                                                                                                               
 261    dffe_s #(`GRLEN) offset_e2m_reg (                                                                                                                                                                          
 262       .din (offset),                                                                                                                                                                                          
 263       .en  (valid),                                                                                                                                                                                           
 264       .clk (clk),                                                                                                                                                                                             
 265       .q   (offset_m),                                                                                                                                                                                        
 266       .se(), .si(), .so());  
`````
