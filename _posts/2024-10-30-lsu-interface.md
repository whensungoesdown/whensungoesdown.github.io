---
title: lsu memory interface
published: true
---

lsu对外数据读写的接口以前是chiplab里的，这样：

`````verilog
   wire                   data_req;
   wire [`GRLEN-1:0]      data_pc;
   wire                   data_wr;
   wire [3 :0]            data_wstrb;
   wire [`GRLEN-1:0]      data_addr;
   wire                   data_cancel_ex2;
   wire                   data_cancel;
   wire [`GRLEN-1:0]      data_wdata;
   wire                   data_recv;
   wire                   data_prefetch;
   wire                   data_ll;
   wire                   data_sc;

   wire [`GRLEN-1:0]      data_rdata_m;
   wire                   data_addr_ok;
   wire                   data_data_ok_m;
   wire [ 5:0]            data_exccode;
`````

现在改成这样

`````verilog
   wire                   lsu_biu_rd_req;
   wire [`GRLEN-1:0]      lsu_biu_rd_addr;

   wire                   biu_lsu_rd_ack;
   wire                   biu_lsu_data_valid;
   wire [31:0]            biu_lsu_data;

   wire                   lsu_biu_wr_req;
   wire [`GRLEN-1:0]      lsu_biu_wr_addr;
   wire [31:0]            lsu_biu_wr_data;
   wire [3:0]             lsu_biu_wr_strb;

   wire                   biu_lsu_write_done;
`````

有很多信号等以后用到了再加。

最主要的区别是req和ack的机制。

req在获得biu之前一直high，一但biu给会ack，req就low下去，并且内部标记biu busy，直到这次的req执行完才会再次req。
