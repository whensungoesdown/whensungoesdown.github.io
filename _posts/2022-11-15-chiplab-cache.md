---
title: chiplab的cache
published: true
---

为了解决取值和读数据都要5个cycle的问题，要先把chiplab的cache看懂些。


`````verilog
myCPU/cache.vh


  // way
`define I_WAY_NUM4
`ifdef I_WAY_NUM4
  `define I_WAY_LEN          2
`endif
`define I_WAY_NUM           (1 << `I_WAY_LEN)
`define I_WAY_BITS          `I_WAY_LEN - 1 : 0


...



  // WAY
//`define D_WAY_NUM1
//`define D_WAY_NUM2
`define D_WAY_NUM4

`ifdef D_WAY_NUM1
  `define D_WAY_LEN 0
`endif

`ifdef D_WAY_NUM2
  `define D_WAY_LEN 1
`endif

`ifdef D_WAY_NUM4
  `define D_WAY_LEN 2
`endif

`define D_WAY_NUM            (1 << `D_WAY_LEN)
`define D_WAY_BITS           `D_WAY_LEN - 1 : 0

`````

可以看出icache和dcache都是4 way associative。

这样说icache和dcache就应该都是16KB。

4-way associative就是4个direct-mapped的cache，最后mux。

>  A 4Kbyte page, for example, limits a direct-mapped cache to a maximum size of 4 Kbytes, a 2-way set-associative ache to a maximum size of 8 Kbytes, and so on.



-----------------------------------------------------

`````shell
cache.vh:`define PIPELINE2DCACHE_BUS_ADDR       `WSTRB_WIDTH + `GRLEN * 1 + 1 : `WSTRB_WIDTH + 2
dcache.v:assign pipeline_data_addr  = pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_ADDR     ];
lsoc1000_mainpipe.v:assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_ADDR     ] = data_addr      ;
mycpu_top.v:    assign cache_op_addr               = pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_ADDR     ];
`````

cache_op_addr是data_addr。

`````verilog
myCPU/icache.v


assign inst_tlb_vaddr      = cache_op_addr_ok? cache_op_addr : inst_addr;
`````


-----------------------------------------------------------

看了下，cache_hit一直都没有，都是cache_miss，所以cache没起作用。

chiplab的，cpu7也是这样，得跟下哪里的问题。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-15-0.png)

----------------------------------------------------------------

看这个cache_hit，里面主要是tlb_uncache一直是1，tlb_hit也是1。

chipab里mmu都去掉了，所以tlb没什么用，只要把virtual address直接取高位给出tag就行。

看了下tlb_ptag[19:0]，取virtual address高20位，给出的是1c000，也都对。

`````verilog
//  ---------------- Look Up in Icache Tag ----------------
assign cache_hit   =   |way_hit && !tlb_uncache  && tlb_valid_ret;
assign cache_miss  =(!(|way_hit) || tlb_uncache) && tlb_valid_ret;
`````
把icache的tlb_uncache写成1'b0，结果成下面这样了。

![screenshot1](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-15-1.png)

cache似乎是起作用了，变成2个cycle取到一次指令了。

而且每隔0x20个字节，也就是32个字节的地方，会有7个cycle的一次取指，应该是cache miss。

看了下头文件，LA32时cache line确实时32字节（256 bit）。


`````verilog
`ifdef LA64
  `define I_LINE_SIZE_b      512    // bit
  `define I_OFFSET_LEN       4
  `define I_INDEX_LEN        7
  `define I_IO_WDATA_LEN    (64 * `I_BANK_NUM)
  //`define I_BANK_BITS       5 : 3
  `define BUS_DATA_WIDTH     128
`elsif LA32
  `define I_LINE_SIZE_b      256    // bit
  `define I_OFFSET_LEN       3
  `define I_INDEX_LEN        8
  `define I_IO_WDATA_LEN    (32 * `I_BANK_NUM)
  //`define I_BANK_BITS       4 : 2
  `define BUS_DATA_WIDTH     64
`endif
`````

但是始终还是cache_miss，cache_hit一次也没出现，而且4个line_tag也一直都是0，还不知道为什么会这样。


跟了几个信号，比如这面这个。

`````verilog
assign inst_rdata = {`INST_OUT_LEN{tlb_finish & way_hit[0]        }} & data_way_sel[0] |
                    {`INST_OUT_LEN{tlb_finish & way_hit[1]        }} & data_way_sel[1] |
                    {`INST_OUT_LEN{tlb_finish & way_hit[2]        }} & data_way_sel[2] |
                    {`INST_OUT_LEN{tlb_finish & way_hit[3]        }} & data_way_sel[3] |
                    {`INST_OUT_LEN{|miss_data_ok | uncache_data_ok}} & miss_ret_data   ;

`````

![screenshot2](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-15-2.png)

tlb_finish每隔一个cycle为1，但way_hit始终都为0。

所有取回来的数据都是最后 |miss_data_ok选的miss_ret_data。


`````verilog
// inst return
wire [`INST_OUT_LEN-1 :0] data_way_sel [`I_WAY_NUM-1:0];
wire [`INST_OUT_LEN-1 :0] miss_ret_data;


....


  assign data_wdata_o = {rfil_data[ 7], rfil_data[ 6], rfil_data[ 5], rfil_data[ 4],
                         rfil_data[ 3], rfil_data[ 2], rfil_data[ 1], rfil_data[ 0]};

  assign miss_ret_data = {`INST_OUT_LEN{                         rfil_uncache}} & {32'b0        , 32'b0        , 32'b0        , rfil_data[ 0]} |
                         {`INST_OUT_LEN{rfil_offset == 3'b000 & !rfil_uncache}} & {rfil_data[ 3], rfil_data[ 2], rfil_data[ 1], rfil_data[ 0]} |
                         {`INST_OUT_LEN{rfil_offset == 3'b001 & !rfil_uncache}} & {rfil_data[ 4], rfil_data[ 3], rfil_data[ 2], rfil_data[ 1]} |
                         {`INST_OUT_LEN{rfil_offset == 3'b010 & !rfil_uncache}} & {rfil_data[ 5], rfil_data[ 4], rfil_data[ 3], rfil_data[ 2]} |
                         {`INST_OUT_LEN{rfil_offset == 3'b011 & !rfil_uncache}} & {rfil_data[ 6], rfil_data[ 5], rfil_data[ 4], rfil_data[ 3]} |
                         {`INST_OUT_LEN{rfil_offset == 3'b100 & !rfil_uncache}} & {rfil_data[ 7], rfil_data[ 6], rfil_data[ 5], rfil_data[ 4]} |
                         {`INST_OUT_LEN{rfil_offset == 3'b101 & !rfil_uncache}} & {32'b0        , rfil_data[ 7], rfil_data[ 6], rfil_data[ 5]} |
                         {`INST_OUT_LEN{rfil_offset == 3'b110 & !rfil_uncache}} & {32'b0        , 32'b0        , rfil_data[ 7], rfil_data[ 6]} |
                         {`INST_OUT_LEN{rfil_offset == 3'b111 & !rfil_uncache}} & {32'b0        , 32'b0        , 32'b0        , rfil_data[ 7]} ;

....


always @(posedge clk) begin
  if(ret_valid) begin
  `ifdef LA64
    {rfil_data[15], rfil_data[14], rfil_data[13], rfil_data[12]} <= (!rfil_record[3] & rfil_record[2])? ret_data        : {rfil_data[15], rfil_data[14], rfil_data[13], rfil_data[12]};
    {rfil_data[11], rfil_data[10], rfil_data[ 9], rfil_data[ 8]} <= (!rfil_record[2] & rfil_record[1])? ret_data        : {rfil_data[11], rfil_data[10], rfil_data[ 9], rfil_data[ 8]};
    {rfil_data[ 7], rfil_data[ 6], rfil_data[ 5], rfil_data[ 4]} <= (!rfil_record[1] & rfil_record[0])? ret_data        : {rfil_data[ 7], rfil_data[ 6], rfil_data[ 5], rfil_data[ 4]};
    {rfil_data[ 3], rfil_data[ 2], rfil_data[ 1]               } <= (!rfil_record[0]                 )? ret_data[127:32]: {rfil_data[ 3], rfil_data[ 2], rfil_data[ 1]               };
  `elsif LA32
    {rfil_data[ 7], rfil_data[ 6]} <= (!rfil_record[3] & rfil_record[2])? ret_data       : {rfil_data[ 7], rfil_data[ 6]};
    {rfil_data[ 5], rfil_data[ 4]} <= (!rfil_record[2] & rfil_record[1])? ret_data       : {rfil_data[ 5], rfil_data[ 4]};
    {rfil_data[ 3], rfil_data[ 2]} <= (!rfil_record[1] & rfil_record[0])? ret_data       : {rfil_data[ 3], rfil_data[ 2]};
    {rfil_data[ 1]               } <= (!rfil_record[0]                 )? ret_data[63:32]: {rfil_data[ 1]               };
  `endif
  end
end

`````

miss_ret_data来自于ret_data，和ret_valid一起，是cache_interface通过AXI协议从外面的memory取得的数据。

`````verilog
    icache u_icache
    (
        .clk(aclk),
        .resetn(aresetn),

        .cache_op_req     (icache_op_req       ),
        .cache_op         (icache_op           ),
        .cache_op_tag     (cache_op_tag        ),
        .cache_op_addr    (cache_op_addr       ),
        .cache_op_addr_ok (icache_op_addr_ok   ),
        .cache_op_ok      (icache_op_ok        ),
        .cache_op_error   (icache_op_error     ),
        .cache_op_badvaddr(icache_op_badvaddr  ),

        .tlb_ptag         (itlb_paddr[`I_TAG_BITS]),
        .tlb_finish       (itlb_finish         ),
        .tlb_hit          (itlb_hit            ),
        .tlb_cache_recv   (itlb_cache_recv     ),
        //.tlb_uncache      (itlb_uncache        ), // uty: test
        .tlb_uncache      (1'b0                ), // uty: test
        .tlb_exccode      (itlb_exccode        ),

        ////cpu_control
        //------inst request interface-------
        .inst_req          (cpu_inst_req & icache_init_finish),
        .inst_addr         (cpu_inst_addr      ),
        .inst_cancel       (cpu_inst_cancel    ),
        .inst_addr_ok      (cpu_inst_addr_ok   ),
        .inst_rdata        (cpu_inst_rdata     ),
        .inst_valid        (cpu_inst_valid     ),
        .inst_count        (cpu_inst_count     ),
        .inst_uncache      (cpu_inst_uncache   ),
        .inst_exccode      (cpu_inst_exccode   ),
        .inst_exception    (cpu_inst_exception ),

        .inst_tlb_req      (cpu_inst_tlb_req   ),
        .inst_tlb_vaddr    (cpu_inst_tlb_vaddr ),
        .inst_tlb_cacop    (cpu_inst_tlb_cacop ),

        // interact with MISS queue
        .rd_req            (i_rd_req           ),
        .rd_addr           (i_rd_addr          ),
        .rd_arcmd          (i_rd_arcmd         ),
        .rd_uncache        (i_rd_uncache       ),
        .rd_ready          (i_rd_ready         ),
        .ret_valid         (i_ret_valid        ),    <--
        .ret_last          (i_ret_last         ),


    cache_interface u_cache_interface
    (
        ////basic  
        .clk              (aclk               ), 
        .resetn           (aresetn            ),

        .test_pc (debug0_wb_pc), 

         // icache
        .i_rd_req         (i_rd_req           ),
        .i_rd_addr        (i_rd_addr          ),
        .i_rd_arcmd       (i_rd_arcmd         ),
        .i_rd_uncache     (i_rd_uncache       ),
        .i_rd_ready       (i_rd_ready         ),
        .i_ret_valid      (i_ret_valid        ),     <--
        .i_ret_last       (i_ret_last         ),
        .i_ret_data       (i_ret_data         ),
        .i_ret_rstate     (i_ret_rstate       ),

`````


现在的问题是要追踪ret_valid和ret_data，看看读进数据以后为什么没有进到cache里。


![screenshot3](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-15-3.png)

从外部memory每个周期可以读进64bit，连续4个cycle，一共256 bit，8条指令，一个cache line。

这就是为什么cache miss了也可以每2个cycle能取值一条指令。


icache里的这几个输出的信号应该是写cache的。

`````verilog
    output reg [`I_WAY_NUM-1  :0] data_clk_en_o,
    output [`I_IO_EN_LEN-1    :0] data_en_o    ,
    output [`I_WAY_NUM-1      :0] data_wen_o   ,
    output [`I_INDEX_LEN-1    :0] data_addr_o  ,
    output [`I_IO_WDATA_LEN-1 :0] data_wdata_o ,
    input  [`I_IO_RDATA_LEN-1 :0] data_rdata_i ,
`````


-----------------------------------------
现在的情况是因为cache miss，icache refill的时候虽然一次从外memory读64bit，但不知道为什么ifu取值的时候只能每两个cycle取值一次。

不知道cache存没存上，写了个测试的例子test_case_loop。loop回去，看看再次执行的时候能不能从cache里直接取。


![screenshot4](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-15-4.png)

果然是这样，loop回1c000000以后，后面的指令都是每个cycle都可以fetch一条。

看下面的cache_hit，也都有了。

这样就能满足后面写bypass模块的需求了。

不过，要是每次代码都是前几条指令循环一遍，也很不方便。

看看能不能把TLB去掉，cache似乎能正常工作，问题可能出在TLB上。
