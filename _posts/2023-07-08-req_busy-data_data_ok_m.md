---
title: 加了req_busy，用来控制data_data_m
published: true
---

自从丢掉cache，自己写core里的axi master，乱套了，x到处都是。。。

bug一个一个的改吧。



现在的情况是只处理data读请求，lsu发data_req过来一个cycle，通过axi向sram读数据。

axi读需要等一个cycle，数据到的时候设置data_data_ok(这个名字太差了，后面改成data_vld)。

lsu发出请求data_req是在_e阶段，后面要把信号名都统一好，应该叫data_req_e。

而data_data_ok应该叫data_data_ok_m。并不是说数据会在下一个cycle就到，而是要在data_req_e +2个cycle准时到。

但既然用了axi协议，数据到达的时间就可以是不确定的，只要rvalid来了，就说明数据到了。

所以_m表示lsu接收数据在_m阶段，如果数据没到，就stall整个pipeline，这时候就一直算做_m里。

(所以data_data_m也要控制stall_ifu的信号。)

现在的思路是：

还是用以前用过的逻辑开关，名字就叫req_busy，表示正在向总线请求数据。

信号的开始位置由data_req决定，由rvalid & rready结束，但data_req（1）的时候可能axi上正好有数据到达，rvalid & rready (1)，所以加个限制，表示data_req的时候绝不可能当前的request就已经完成了。



`````verilog
   //
   // req_busy        : ___---_
   //
   // data_req        : __-____
   // rvalid & rready : _____-_
   wire req_busy;
   wire req_busy_nxt;

   // ((rvalid & rready) & ~data_req) means (rvalid & rready) should be the one
   // that after data_req goes low
   // also, while req_busy is 1, data_req shold not be 1 again
   assign req_busy_nxt = (req_busy | data_req) & (~((rvalid & rready) & ~data_req));

   dffrl_s #(1) req_busy_reg (
      .din   (req_busy_nxt),
      .clk   (aclk),
      .rst_l (aresetn),
      .q     (req_busy),
      .se(), .si(), .so());

   //
   // priority lsu_read lsu_write ifu_fetch
   //

   // they are actually ifu_fetch_e lsu_read_e lsu_write_e
   wire                ifu_fetch;
   wire                lsu_read;
   wire                lsu_write;

   wire                ifu_fetch_f;
   wire                lsu_read_m;
   wire                lsu_write_m;


   // todo: do fetch later, should be the same mechanism as data req takes

   assign ifu_fetch = inst_req & ~lsu_write & ~lsu_read;
   assign lsu_read  = data_req & ~lsu_write;
   assign lsu_write = data_req & data_wr;

   assign lsu_read_m  = req_busy & ~lsu_write_m;
   assign lsu_write_m = req_busy & data_wr; // uty: bug  data_wr should be kept as data_req does, now data_wr always 0

   dffrl_s #(1) ifu_fetch_bf2f_reg (
      .din   (ifu_fetch),
      .clk   (aclk),
      .rst_l (aresetn),
      .q     (ifu_fetch_f),
      .se(), .si(), .so());

//   dffrl_s #(1) lsu_read_e2m_reg (
//      .din   (lsu_read),
//      .clk   (aclk),
//      .rst_l (aresetn),
//      .q     (lsu_read_m),
//      .se(), .si(), .so());
//
//   dffrl_s #(1) lsu_write_e2m_reg (
//      .din   (lsu_write),
//      .clk   (aclk),
//      .rst_l (aresetn),
//      .q     (lsu_write_m),
//      .se(), .si(), .so());
`````

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-07-08-0.png)



这样data_data_ok_m就可以下面这样确定。

·····shell
assign data_data_ok_m = (rready & rvalid) & req_busy;
·····

好像有点重复，req_busy就是rready & rvalid确定的，不过这样也行，看起来也清楚。




这样axi_interface对core的接口就很清楚，core发data_req_e，数据到了axi_interface就发data_data_ok_m。

req_busy是axi_interface的内部逻辑，不暴露给core。但这样core就要自己维护逻辑来保证数据到达之前stall ifu。

而另一种设计接口的方式可以是：

core一直拉高data_req，直到data_data_ok为1。在core里，data_req就可以直接控制stall ifu。

但这样信号名也很不好起，data_req_e，这样看起来也不合适。

后面还需要考虑addr异常，align异常，request cancel的情况，所以现在接口是什么样的也定不下来。

得多看代码，学学opensparc，arm都是怎样搞的。不过这些都是和cache接口，inst和data是分开的。



------------------------------------------------------------------------

上面的问题解决后，马上就是下一个问题。

因为现在inst和data是通过同一个axi_interface读写数据，所以要注意data读回来的数据不要进入指令里。

这是通过在ld指令decocde阶段就stall ifu，等stall恢复后再取指。

现在的bug是，stall ifu的时间不够，看下面代码，之前用的是lsu_stall_req_next，少stall了1个cycle。


![screenshot1](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-07-08-1.png)

当时不太会补上cycle的缺口，又想lsu_dispatch_d来了以后马上stall ifu，所以选了lsu_stall_req_next。

其实lsu_stall_req | lsu_dispatch_d就可以了。


`````verilog
   //
   // lsu stall request
   //

   // lsu_dispatch_d     : _-______
   // lsu_ecl_finish_m   : ______-_
   //
   // lsu_stall_req      : __-----_
   // lsu_stall_req_next : _-----__
   // lsu_stall_req_ful  : _------_
   //

   wire lsu_stall_req;
   wire lsu_stall_req_next;

   wire lsu_stall_req_ful;

   assign lsu_stall_req_ful = lsu_stall_req | lsu_dispatch_d;

   //
   // lsu_dispatch_d is the staring signal
   // lsu_ecl_finish_m ends it
   //
   assign lsu_stall_req_next =  (lsu_dispatch_d) | (lsu_stall_req & ~lsu_ecl_finish_m);

   dffr_s #(1) lsu_stall_req_reg (
      .din (lsu_stall_req_next),
      .clk (clk),
      .q   (lsu_stall_req),
      .se(), .si(), .so(), .rst (~resetn));

`````

![screenshot2](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2023-07-08-2.png)

但这里不能用 `assign lsu_stall_req_ful = lsu_stall_req | lsu_ecl_finish_m`，因为lsu_ecl_finish_m的原因，在reset后是x，所以导致后面取值都出问题了。
这个问题可以通过找到lsu_ecl_finish_m是x的原因来解决，但我没试。


