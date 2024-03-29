---
title: 流水线和data byp
published: true
---

现在的问题是cache miss的时候，每2个cycle取指一次。

以前cpu6都是一个cycle一条指令，所以在做data forwarding的时候没想那么多。


因为读寄存器是在_d，所以_e要把alu的数据前递给_d。而_m时lsu要把load的数据给_d。

而如果时2个cycle fetch一个指令，拿alu来说，在_e时，下一条指令还没有到_d，也就是还没有读寄存器，所以没法前递。

需要到_m时，下一条指令才到_d。


`````shell
_d   _e(alu)   _m(lsu)
^_______|         |
^_________________|
`````


比如下面这个例子，在2 cycle fetch一条指令的时候，func_uty1_ld。

`````asm
obj/main.elf:     file format elf32-loongarch
obj/main.elf


Disassembly of section .text:

1c000000 <_start>:
kernel_entry():
1c000000:       14380006        lu12i.w $r6,114688(0x1c000)
1c000004:       028030c6        addi.w  $r6,$r6,12(0xc)
1c000008:       288000c5        ld.w    $r5,$r6,0

Disassembly of section .data:

1c00000c <var1>:
var1():
1c00000c:       0000005a        0x0000005a

`````

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-21-0.png)

当第一条指令到_e，alu的result已经是1c000000了，而_d阶段pc_d显示当前ip还是1c000000。

----------------------------------------------

又看了看书，是我搞错了。

在_m _w的时候把数据送向_e。_d读完寄存器应该时间挺紧张的。


`````shell
_e      _m        _w
^_______|         |
^_________________|
`````


这样的话就算chiplab的cache fill cache line需要2个cycle（外面也是SRAM），也不用担心了，_w --> _e就行了。

如果delay时间更长的话，data forwarding也不用管了。


------------------------------------------------------------------

看了下OpenSPARC，这里的data bypass是从regfile里读出来就直接在_d的时候就做mux，得到的结果再传给_e的流水线寄存器。

`````verilog
   // rs1_data muxes: RF and E are critical paths
   mux4ds #(64) mux_rs1_data_1(.dout(rs1_data_btwn_mux[63:0]),
                               .in0(rd_data_m[63:0]),
                               .in1(byp_irf_rd_data_w[63:0]),
                               .in2(rs1_data_w2[63:0]),
                               .in3({{16{ifu_exu_pc_d[47]}}, ifu_exu_pc_d[47:0]}),
                             .sel0(ecl_byp_rs1_mux1_sel_m),
                             .sel1(ecl_byp_rs1_mux1_sel_w),
                             .sel2(ecl_byp_rs1_mux1_sel_w2),
                             .sel3(ecl_byp_rs1_mux1_sel_other));

   mux4ds #(64) mux_rs1_data_2(.dout(byp_alu_rs1_data_d[63:0]),
                             .in0(rs1_data_btwn_mux[63:0]),
                             .in1(irf_byp_rs1_data_d[63:0]),
                             .in2(alu_byp_rd_data_e[63:0]),
                             .in3(lsu_exu_dfill_data_g[63:0]),
                             .sel0(ecl_byp_rs1_mux2_sel_usemux1),
                             .sel1(ecl_byp_rs1_mux2_sel_rf),
                             .sel2(ecl_byp_rs1_mux2_sel_e),
                             .sel3(ecl_byp_rs1_mux2_sel_ld));

`````

---------------------------------------------------
**2022-12-20 add:**

今天在做csr寄存器bypass的时候又在想这个问题，为什么bypass _w不把结果传递给_d，毕竟_d的时候已经从寄存器读出结果了。

OpenSPARC的byp就是做在_d。

我想来想去也觉得不应该是_d _e位置随便选吧。

应该是读regfile在哪，就应该在什么地方开始做byp。

那为什么现在做在_e，只要把_m _w的数据前递就行了呢？

特意做了个func_uty13_testbyp1cycle来测试下。

`````asm
1c000000 <_start>:
kernel_entry():
1c000000:       02800403        addi.w  $r3,$r0,1(0x1)
1c000004:       02800004        addi.w  $r4,$r0,0

1c000008 <again>:
again():
1c000008:       02800484        addi.w  $r4,$r4,1(0x1)

1c00000c:       02802805        addi.w  $r5,$r0,10(0xa)
1c000010:       02800000        addi.w  $r0,$r0,0
1c000014:       02800000        addi.w  $r0,$r0,0
1c000018:       028140a5        addi.w  $r5,$r5,80(0x50)

1c00001c:       02800000        addi.w  $r0,$r0,0
1c000020:       02800000        addi.w  $r0,$r0,0
1c000024:       5fffe464        bne     $r3,$r4,-28(0x3ffe4) # 1c000008 <again>

`````
中间r5的两次addi.w，中间隔着2个nop，结果也是正确的。

现在找到的原因是cpu7里用的是chiplab的regfile。

还没有搞清楚这个regfile生成出来的是latch还是dflop。

`````verilog
 78   // process write                                                                                                                            
 79         always @(posedge clk) begin                                                                                                           
 80                 // if(rst) begin                                                                                                              
 81                 //      regs[31] <= 32'd0;                                                                                                    
 82                                                                                                                                               
 83                 // end                                                                                                                        
 84                 // else begin                                                                                                                 
 85                         case({wen1_input,wen2_input})                                                                                         
 86                                         2'b11:begin                                                                                           
 87                                            regs[waddr1] <= wdata1;                                                                            
 88                                            regs[waddr2] <= wdata2;                                                                            
 89                                            end                                                                                                
 90                                         2'b10:regs[waddr1] <= wdata1;                                                                         
 91                                         2'b01:regs[waddr2] <= wdata2;                                                                         
 92                                         default:        ;                                                                                     
 93                         endcase                                                                                                               
 94                 // end                                                                                                                        
 95         end
`````

不过先看下上面func_uty13_testbyp1cycle测试的例子。


![screenshot2](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-12-20-0.png)

可以看到rd_data_w的数据0xa，已经写进去了，并且irf_ecl_rs1_data_d，也就是nop nop后面的addi指令也已经从寄存器里读出来了。

本来以为rd_data_w的数据要在下一个rising edge写进寄存器，那时候_d才能读出来，现在看来不是。

不过这个是always @(posedge clk) 感觉就是和dff是又一样的啊。

原来是里面做了read port forwarding。

`````verilog
 32   // read after write (RAW)                                                                                                                   
 33         wire r1_1_w1_raw =      wen1 && (raddr0_0 == waddr1);                                                                                 
 34         wire r1_2_w1_raw =  wen1 && (raddr0_1 == waddr1);                                                                                     
 35         wire r1_1_w2_raw =      wen2 && (raddr0_0 == waddr2);                                                                                 
 36         wire r1_2_w2_raw =  wen2 && (raddr0_1 == waddr2);                                                                                     
 37                                                                                                                                               
 38         wire r2_1_w1_raw =      wen1 && (raddr1_0 == waddr1);                                                                                 
 39         wire r2_2_w1_raw =  wen1 && (raddr1_1 == waddr1);                                                                                     
 40         wire r2_1_w2_raw =      wen2 && (raddr1_0 == waddr2);                                                                                 
 41         wire r2_2_w2_raw =  wen2 && (raddr1_1 == waddr2);                                                                                     
 42                                                                                                                                               
 43         wire r3_1_w1_raw =      wen1 && (raddr2_0 == waddr1);                                                                                 
 44         wire r3_2_w1_raw =  wen1 && (raddr2_1 == waddr1);                                                                                     
 45         wire r3_1_w2_raw =      wen2 && (raddr2_0 == waddr2);                                                                                 
 46         wire r3_2_w2_raw =  wen2 && (raddr2_1 == waddr2);                                                                                     
 47  
 48         wire r1_1_raw = r1_1_w1_raw || r1_1_w2_raw;     // read port need forwarding                                                          
 49         wire r1_2_raw = r1_2_w1_raw || r1_2_w2_raw;                                                                                           
 50         wire r2_1_raw = r2_1_w1_raw || r2_1_w2_raw;                                                                                           
 51         wire r2_2_raw = r2_2_w1_raw || r2_2_w2_raw;                                                                                           
 52         wire r3_1_raw = r3_1_w1_raw || r3_1_w2_raw;                                                                                           
 53         wire r3_2_raw = r3_2_w1_raw || r3_2_w2_raw;                                                                                           
 54                                                                                                                                               
 55         wire [`GRLEN-1:0]       r1_1_raw_data = r1_1_w2_raw ? wdata2 : wdata1;  // forwarding data                                            
 56         wire [`GRLEN-1:0]       r1_2_raw_data = r1_2_w2_raw ? wdata2 : wdata1;                                                                
 57         wire [`GRLEN-1:0]       r2_1_raw_data = r2_1_w2_raw ? wdata2 : wdata1;                                                                
 58         wire [`GRLEN-1:0]       r2_2_raw_data = r2_2_w2_raw ? wdata2 : wdata1;                                                                
 59         wire [`GRLEN-1:0]       r3_1_raw_data = r3_1_w2_raw ? wdata2 : wdata1;                                                                
 60         wire [`GRLEN-1:0]       r3_2_raw_data = r3_2_w2_raw ? wdata2 : wdata1; 
`````

原因在这，也就是说，这个图上的_w时刻，数据还没有写进reg。

![screenshot3](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-12-20-1.png)

果然是这样，r5的值在下一个cycle才写进去。

那这么说，现在实现的cpu7_csr里，读csr寄存器在_d，写csr寄存器在_m，byp要把_e _m的都forwarding到_d。

**以后做byp，要regfile读在那个阶段，数据就要前递到哪个阶段。当然还要看refile的实现。**
---------------------------------------------------

现在又有一个想法，让lsu里计算地址也复用ALU，有个好处，就是data bypass只需要处理给alu的参数了。

否则ld指令需要的参数也要考虑data bypass。

在ecl里alu和lsu的操作数都需要传过去。

------------------------------------------------------------------


`````verilog
 144    wire alu_b_imm = (ifu_exu_op_d[`LSOC1K_I5] || ifu_exu_op_d[`LSOC1K_I12] || ifu_exu_op_d[`LSOC1K_I16] || ifu_exu_op_d[`LSOC1K_I20]) & alu_dispatch_d;


 157    wire [`GRLEN-1:0] alu_b_d = alu_b_imm? ifu_exu_imm_shifted_d : irf_ecl_rs2_data_d;


 252    assign user_other = alu_b_imm_e | double_read_e;                                                                                        
 253                                                                                                                                             
 254    cpu7_exu_eclbyplog byplog_rs2(                                                                                                             
 255       .rs_e           (rs2_e[4:0]             ),                                                                                              
 256       .rd_m           (rd_m[4:0]              ),                                                                                             
 257       .rd_w           (rd_w[4:0]              ),                                                                                             
 258       .wen_m          (wen_m                  ),                                                                                              
 259       .wen_w          (wen_w                  ),                                                                                            
 260       .use_other      (alu_b_imm_e            ),                                                                                                
 261                                                                                                                                                        
 262       .rs_mux_sel_rf  (ecl_byp_rs2_mux_sel_rf ),                                                                                                       
 263       .rs_mux_sel_m   (ecl_byp_rs2_mux_sel_m  ),                                                                                              
 264       .rs_mux_sel_w   (ecl_byp_rs2_mux_sel_w  )                                                                                                
 265       );  


 359    assign double_read_d = ifu_exu_op_d[`LSOC1K_DOUBLE_READ] & lsu_dispatch_d;

 373    assign lsu_offset_e = double_read_e ? byp_rs2_data_e : ifu_exu_imm_shifted_e; 
`````

ALU指令的时候alu_b_imm决定用rs2寄存器还是用imm。

而LSU指令时double_read_e作用差不多，也是选择imm和rs2，不过意思反的。

最主要是alu_b_imm和double_read_e在指令里也不是同一个bit，没办法一个bit决定ALU和LSU的参数。

这俩都不是指令里的bit，而是解码的时候给出的。

比如DOUBLE_READ, alu_b_imm也是一样。

`````verilog
decoder.v

assign res[`LSOC1K_DOUBLE_READ   ] = double_read;


wire double_read = op_preldx || op_ldx_b || op_ldx_h || op_ldx_w || op_ldx_d || op_ldx_bu || op_ldx_hu || op_ldx_wu || op_ldgt_b || op_ldgt_h || op_ldgt_w || op_ldgt_d || op_ldle_b || op_ldle_h || op_ldle_w || op_ldle_d ||
                   op_amswap_w || op_amswap_d || op_amadd_w || op_amadd_d || op_amand_w || op_amand_d || op_amor_w ||
                   op_amor_d || op_amxor_w || op_amxor_d || op_ammax_w || op_ammax_d || op_ammin_w || op_ammin_d || op_ammax_wu || op_ammax_du || op_ammin_wu || op_ammin_du ||
                   op_amswap_db_w || op_amswap_db_d || op_amadd_db_w || op_amadd_db_d || op_amand_db_w || op_amand_db_d || op_amor_db_w || op_amor_db_d || op_amxor_db_w ||
                   op_amxor_db_d || op_ammax_db_w || op_ammax_db_d || op_ammin_db_w || op_ammin_db_d || op_ammax_db_wu || op_ammax_db_du || op_ammin_db_wu || op_ammin_db_du;

`````

所以需要"& alu_dispatch_d" "& lsu_dispatch"来选择是进alu的指令还是进lsu的指令。

------------------------------------------------------------------

搞了个func_uty7_beq_testbyp1cycle_obj，测试下cache一个cycle一条指令的时候byp是否正常。

`````asm
obj/main.elf:     file format elf32-loongarch
obj/main.elf


Disassembly of section .text:

1c000000 <_start>:
kernel_entry():
1c000000:       02800803        addi.w  $r3,$r0,2(0x2)
1c000004:       02800004        addi.w  $r4,$r0,0

1c000008 <again>:
again():
1c000008:       02800484        addi.w  $r4,$r4,1(0x1)
1c00000c:       02802805        addi.w  $r5,$r0,10(0xa)
1c000010:       028040a5        addi.w  $r5,$r5,16(0x10)
1c000014:       028040a5        addi.w  $r5,$r5,16(0x10)
1c000018:       0280a406        addi.w  $r6,$r0,41(0x29)
1c00001c:       028004c6        addi.w  $r6,$r6,1(0x1)
1c000020:       580008c5        beq     $r6,$r5,8(0x8) # 1c000028 <skip>
1c000024:       028200a5        addi.w  $r5,$r5,128(0x80)

1c000028 <skip>:
skip():
1c000028:       028040a5        addi.w  $r5,$r5,16(0x10)
1c00002c:       028040a5        addi.w  $r5,$r5,16(0x10)
1c000030:       028040a5        addi.w  $r5,$r5,16(0x10)
1c000034:       5fffd464        bne     $r3,$r4,-44(0x3ffd4) # 1c000008 <again>

`````

1c000010 1c000014这两条就应该是_m的rd bypass到_e。

![screenshot1](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-21-1.png)

------------------------------------------------------------------

之前乱改cache和tlb，搞成1cycle一条指令，但有问题，比如下一个cache line的时候 0x20以后会出问题。

就不git上传了，把patch文件贴这算了。

`````shell

diff --git a/IP/myCPU/cpu7.v b/IP/myCPU/cpu7.v
index 8a14d5c..b7265d6 100644
--- a/IP/myCPU/cpu7.v
+++ b/IP/myCPU/cpu7.v
@@ -120,7 +120,10 @@ module cpu7(
    wire               data_req_empty ;
    wire               data_scsucceed ;
 
-      
+   // uty: test  
+   wire  [`PABITS-1:0]      itlb_paddr_dumb;
+
+   assign itlb_paddr = inst_tlb_vaddr[`PABITS-1:0];
 
    
    cpu7_ifu ifu(
@@ -351,7 +354,7 @@ module cpu7(
       .i_cache_rcv       (itlb_cache_recv  ),
       .i_finish          (itlb_finish      ),
       .i_hit             (itlb_hit         ),
-      .i_paddr           (itlb_paddr       ),
+      .i_paddr           (itlb_paddr_dumb  ),
       .i_uncached        (itlb_uncache     ),
       .i_exccode         (itlb_exccode     ),
       
diff --git a/IP/myCPU/icache.v b/IP/myCPU/icache.v
index b1946a1..5f5942e 100644
--- a/IP/myCPU/icache.v
+++ b/IP/myCPU/icache.v
@@ -206,7 +206,8 @@ wire        rfil_new_req;
 reg                      rfil_send_cpu;
 reg  [`I_TAG_LEN-1   :0] rfil_ptag ;
 reg  [`I_INDEX_LEN-1 :0] rfil_index;
-reg  [`I_OFFSET_LEN-1:0] rfil_offset;
+reg  [`I_OFFSET_LEN-1:0] rfil_offset;  // uty: test
+wire  [`I_OFFSET_LEN-1:0] rfil_offset_uty;
 reg                      rfil_uncache;
 
 reg  [31             :0] rfil_data [`LINE_INST_NUM-1:0];
@@ -219,6 +220,7 @@ reg  [`SCWAY_LEN-1   :0] rfil_rscway;
 //  ------------------- Store Req & Addr ------------------
 reg  inst_cancel_reg; // TODO: We can cencel request at lkup_state
 
+// uty: test
 reg  [`I_INDEX_LEN-1 :0] index ;
 reg  [`I_OFFSET_LEN-1:0] offset;
 
@@ -227,11 +229,19 @@ always @(posedge clk) begin
     index   <= {`I_INDEX_LEN {1'b0}};  // TODO: remove rst ?
     offset  <= {`I_OFFSET_LEN{1'b0}};
   end
-  else if(inst_addr_ok) begin
+  //else if(inst_addr_ok) begin  // uty: test
+  else begin
     index   <= inst_addr[`I_INDEX_BITS];
     offset  <= inst_addr[`I_OFFSET_BITS];
   end
 end
+//wire  [`I_INDEX_LEN-1 :0] index ;
+//wire  [`I_OFFSET_LEN-1:0] offset;
+//
+//assign index = inst_addr[`I_INDEX_BITS];
+//assign offset = inst_addr[`I_OFFSET_BITS];
+
+
 
 always @(posedge clk) begin
   if(rst)
@@ -541,15 +551,16 @@ end
   assign data_wdata_o = {rfil_data[ 7], rfil_data[ 6], rfil_data[ 5], rfil_data[ 4],
                          rfil_data[ 3], rfil_data[ 2], rfil_data[ 1], rfil_data[ 0]};
 
+  // uty: test		 
   assign miss_ret_data = {`INST_OUT_LEN{                         rfil_uncache}} & {32'b0        , 32'b0        , 32'b0        , rfil_data[ 0]} |
-                         {`INST_OUT_LEN{rfil_offset == 3'b000 & !rfil_uncache}} & {rfil_data[ 3], rfil_data[ 2], rfil_data[ 1], rfil_data[ 0]} |
-                         {`INST_OUT_LEN{rfil_offset == 3'b001 & !rfil_uncache}} & {rfil_data[ 4], rfil_data[ 3], rfil_data[ 2], rfil_data[ 1]} |
-                         {`INST_OUT_LEN{rfil_offset == 3'b010 & !rfil_uncache}} & {rfil_data[ 5], rfil_data[ 4], rfil_data[ 3], rfil_data[ 2]} |
-                         {`INST_OUT_LEN{rfil_offset == 3'b011 & !rfil_uncache}} & {rfil_data[ 6], rfil_data[ 5], rfil_data[ 4], rfil_data[ 3]} |
-                         {`INST_OUT_LEN{rfil_offset == 3'b100 & !rfil_uncache}} & {rfil_data[ 7], rfil_data[ 6], rfil_data[ 5], rfil_data[ 4]} |
-                         {`INST_OUT_LEN{rfil_offset == 3'b101 & !rfil_uncache}} & {32'b0        , rfil_data[ 7], rfil_data[ 6], rfil_data[ 5]} |
-                         {`INST_OUT_LEN{rfil_offset == 3'b110 & !rfil_uncache}} & {32'b0        , 32'b0        , rfil_data[ 7], rfil_data[ 6]} |
-                         {`INST_OUT_LEN{rfil_offset == 3'b111 & !rfil_uncache}} & {32'b0        , 32'b0        , 32'b0        , rfil_data[ 7]} ;
+                         {`INST_OUT_LEN{offset == 3'b000 & !rfil_uncache}} & {rfil_data[ 3], rfil_data[ 2], rfil_data[ 1], rfil_data[ 0]} |
+                         {`INST_OUT_LEN{offset == 3'b001 & !rfil_uncache}} & {rfil_data[ 4], rfil_data[ 3], rfil_data[ 2], rfil_data[ 1]} |
+                         {`INST_OUT_LEN{offset == 3'b010 & !rfil_uncache}} & {rfil_data[ 5], rfil_data[ 4], rfil_data[ 3], rfil_data[ 2]} |
+                         {`INST_OUT_LEN{offset == 3'b011 & !rfil_uncache}} & {rfil_data[ 6], rfil_data[ 5], rfil_data[ 4], rfil_data[ 3]} |
+                         {`INST_OUT_LEN{offset == 3'b100 & !rfil_uncache}} & {rfil_data[ 7], rfil_data[ 6], rfil_data[ 5], rfil_data[ 4]} |
+                         {`INST_OUT_LEN{offset == 3'b101 & !rfil_uncache}} & {32'b0        , rfil_data[ 7], rfil_data[ 6], rfil_data[ 5]} |
+                         {`INST_OUT_LEN{offset == 3'b110 & !rfil_uncache}} & {32'b0        , 32'b0        , rfil_data[ 7], rfil_data[ 6]} |
+                         {`INST_OUT_LEN{offset == 3'b111 & !rfil_uncache}} & {32'b0        , 32'b0        , 32'b0        , rfil_data[ 7]} ;
 `endif
 
 assign data_addr_o = (rfil_refill              )?  rfil_index              :
@@ -653,10 +664,17 @@ wire [1:0] miss_count;
   assign hit_count  = offset     [2] == 1'b1 ? ~offset     [1:0] : 2'b11;
   assign miss_count = rfil_offset[2] == 1'b1 ? ~rfil_offset[1:0] : 2'b11;
 
-  assign miss_data_ok[0] = rfil_send_cpu &  rfil_offset == 3'b000 & rfil_record[1];
-  assign miss_data_ok[1] = rfil_send_cpu & (rfil_offset == 3'b001  || rfil_offset == 3'b010) & rfil_record[2];
-  assign miss_data_ok[2] = rfil_send_cpu & (rfil_offset[2] == 1'b1 || rfil_offset == 3'b011) & rfil_record[3];
-  assign miss_data_ok[3] = rfil_send_cpu & (rfil_offset[2] == 1'b1 || rfil_offset == 3'b011) & rfil_record[3];
+  // uty: test
+//  assign miss_data_ok[0] = rfil_send_cpu &  rfil_offset == 3'b000 & rfil_record[1];
+//  assign miss_data_ok[1] = rfil_send_cpu & (rfil_offset == 3'b001  || rfil_offset == 3'b010) & rfil_record[2];
+//  assign miss_data_ok[2] = rfil_send_cpu & (rfil_offset[2] == 1'b1 || rfil_offset == 3'b011) & rfil_record[3];
+//  assign miss_data_ok[3] = rfil_send_cpu & (rfil_offset[2] == 1'b1 || rfil_offset == 3'b011) & rfil_record[3];
+
+  assign miss_data_ok[0] = (rfil_offset_uty == 3'b000  || rfil_offset_uty == 3'b001) & rfil_record[0];
+  assign miss_data_ok[1] = (rfil_offset_uty == 3'b010  || rfil_offset_uty == 3'b011) & rfil_record[1];
+  assign miss_data_ok[2] = (rfil_offset_uty == 3'b100  || rfil_offset_uty == 3'b101) & rfil_record[2];
+  assign miss_data_ok[3] = (rfil_offset_uty == 3'b110  || rfil_offset_uty == 3'b111) & rfil_record[3];
+
 `endif
 
 assign inst_count = (uncache_data_ok)? 2'b00 : ({2{|hit_data_ok}} & hit_count | {2{|miss_data_ok}} & miss_count);
@@ -682,7 +700,9 @@ assign rfil_idle      = rfil_state == 4'b0000;
 assign rfil_addr_wait = rfil_state == 4'b0001;
 assign rfil_data_wait = rfil_state == 4'b0010;
 
+// uty: test
 assign rfil_hit     = rfil_valid && tlb_ptag == rfil_ptag && index == rfil_index && tlb_finish && state_lkup;
+//assign rfil_hit     = rfil_valid && tlb_ptag == rfil_ptag && index == rfil_index && tlb_finish;
 
 assign rfil_alloc   = rfil_idle && state_lkup && cache_miss && !rfil_hit || rfil_refill && state_blck;
 
@@ -724,10 +744,12 @@ always @(posedge clk) begin
   if(rfil_new_req) begin
     rfil_ptag   <= (state_blck)? blck_ptag : tlb_ptag;
     rfil_index  <= index;
-    rfil_offset <= offset;
+    rfil_offset <= offset;   
   end
 end
 
+assign rfil_offset_uty = inst_addr[`I_OFFSET_BITS]; // uty: tet
+
 // cache or uncache
 always @(posedge clk) begin
   if(uncache_data_ok) // TODO: remove?
@@ -768,7 +790,9 @@ always @(posedge clk) begin
 end
 
 always @(posedge clk) begin
+  // uty: test
   if((!rfil_uncache && rfil_record[`RFIL_RECORD_LEN-1] && rfil_refill || rfil_uncache && rfil_record[0]) || rfil_alloc)
+  //if((!rfil_uncache && rfil_record[`RFIL_RECORD_LEN-1] || rfil_uncache && rfil_record[0]) || rfil_alloc)
     rfil_record <= {`RFIL_RECORD_LEN{1'b0}};
   else if(rfil_data_wait && ret_valid) begin
     rfil_record[3] <= rfil_record[2]? 1'b1 : 1'b0;
@@ -873,4 +897,4 @@ assign wr_awscway  = 4'b0;
 assign wr_pgcl     = ex_pgcl;
 assign wr_fmt      = `WR_FMT_ALLLINE;
 // ------------------------- END --------------------------
-endmodule
\ No newline at end of file
+endmodule
diff --git a/IP/myCPU/mycpu_top.v b/IP/myCPU/mycpu_top.v
index 7e39d58..ea96a54 100644
--- a/IP/myCPU/mycpu_top.v
+++ b/IP/myCPU/mycpu_top.v
@@ -626,10 +626,15 @@ module mycpu_top (
         .cache_op_badvaddr(icache_op_badvaddr  ),
 
         .tlb_ptag         (itlb_paddr[`I_TAG_BITS]),
-        .tlb_finish       (itlb_finish         ),
-        .tlb_hit          (itlb_hit            ),
+        //.tlb_finish       (itlb_finish         ),  // uty: test
+        //.tlb_finish       (cpu_inst_tlb_req    ),
+        .tlb_finish       (1'b1    ),
+        //.tlb_hit          (itlb_hit            ), // uty: test
+        //.tlb_hit          (cpu_inst_tlb_req    ),
+        .tlb_hit          (1'b1    ),
         .tlb_cache_recv   (itlb_cache_recv     ),
-        .tlb_uncache      (itlb_uncache        ),
+        //.tlb_uncache      (itlb_uncache        ), // uty: test
+        .tlb_uncache      (1'b0                ), // uty: test
         .tlb_exccode      (itlb_exccode        ),
 
         ////cpu_control
diff --git a/IP/myCPU/tlb.v b/IP/myCPU/tlb.v
index a2e447a..0f6128c 100644
--- a/IP/myCPU/tlb.v
+++ b/IP/myCPU/tlb.v
@@ -33,6 +33,7 @@ module tlb
     input                   i_s_cache_rcv ,
     output reg              i_s_finish_his,
     output reg [PABITS-1:0] i_s_paddr_his ,
+//    output [PABITS-1:0]     i_s_paddr_uty ,
     output                  i_s_hit       ,
     output                  i_s_uncached  ,
     output     [ 5:0]       i_s_exccode   ,
@@ -184,6 +185,10 @@ assign i_dir_map_win_hit  = i_dir_map_win0_hit | i_dir_map_win1_hit;
 assign i_dir_map_win0_hit = csr_CRMD_PG & i_s_vaddr[`LSOC1K_DMW_VSEG] == csr_dir_map_win0[`LSOC1K_DMW_VSEG] & csr_dir_map_win0[{3'b0,csr_CRMD_PLV}];
 assign i_dir_map_win1_hit = csr_CRMD_PG & i_s_vaddr[`LSOC1K_DMW_VSEG] == csr_dir_map_win1[`LSOC1K_DMW_VSEG] & csr_dir_map_win1[{3'b0,csr_CRMD_PLV}];
 
+
+// uty: test
+//assign i_s_paddr_uty = i_s_vaddr[PABITS-1:0];
+
 always @(posedge clk) begin
   if(i_s_req && i_unmapped_search) begin
     i_s_hit_his   <= 1'b1;
diff --git a/sims/verilator/run_func/config-software.mak b/sims/verilator/run_func/config-software.mak
index 8a8d0ed..4ca42e4 100644
--- a/sims/verilator/run_func/config-software.mak
+++ b/sims/verilator/run_func/config-software.mak
@@ -1,4 +1,4 @@
-RUN_SOFTWARE=func/func_uty5_jirl
+RUN_SOFTWARE=func/func_uty1_ld
 TRACE_COMP=n
 SIMU_TRACE=y
 RUN_FUNC=y
diff --git a/sims/verilator/run_func/configure.sh b/sims/verilator/run_func/configure.sh
index 55f36dc..30083d2 100755
--- a/sims/verilator/run_func/configure.sh
+++ b/sims/verilator/run_func/configure.sh
@@ -282,6 +282,11 @@ do
             mkdir -p ./obj/func
             mkdir -p ./log/func
             ;;
+        func/test_cache_loop) 
+            RUN_FUNC=y
+            mkdir -p ./obj/func
+            mkdir -p ./log/func
+            ;;
         my_program)
             RUN_FUNC=n 
             RUN_C=y

`````
