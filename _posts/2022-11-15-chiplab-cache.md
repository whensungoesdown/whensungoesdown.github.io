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
