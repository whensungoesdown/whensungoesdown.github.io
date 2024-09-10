---
title: ifu fetch request logic
published: true
---

现在的问题是：ifu 发出的ifu_biu_rd_req，是按一个cycle触发的。也就是说--_表示ifu发出了2次request。结果就是biu register了这个请求，连着发出了同一addr同一arid的请求，这样发有问题。

这样有问题，以为ifu发出第一个req后，读的数据还没回来，这时候biu不应该接受ifu发出的第2个req。这时候biu可以发lsu的req，因为arid不同。

看了下代码，是对应的axi_ar_ready_ifu还没有实现。

`````verilog
   assign biu_ifu_rd_ack = axi_ar_ready /*& axi_ar_ready_ifu*/ & ifu_select;
   assign biu_lsu_rd_ack = axi_ar_ready /*& axi_ar_ready_lsu*/ & lsu_select;

   assign arb_rd_val = biu_ifu_rd_ack | biu_lsu_rd_ack;

`````

![arb_rd_val wrong](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2024-09-05_arb_rd_val_wrong.png)


axi_ar_ready_ifu以ifu_select开始，以axi_rdata_ifu_val结束。

改名成axi_ar_busy_ifu。


`````verilog
   // scenario 0
   //
   // ifu_select           : _-_____
   // axi_rdata_ifu_val    : _____-_
   //
   // axi_ar_busy_ifu_in   : _----__
   // axi_ar_busy_ifu_q    : __----_

   // scenario 1
   // 
   // ifu_select           : _-_____
   // axi_rdata_ifu_val    : _-_____
   //
   // axi_ar_busy_ifu_in   : _-_____
   // axi_ar_busy_ifu_q    : __-____ 

   assign axi_ar_busy_ifu_in = (axi_ar_busy_ifu_q & ~axi_rdata_ifu_val) | ifu_select;

   dffrl_s #(1) axi_ar_busy_ifu_reg (
      .din   (axi_ar_busy_ifu_in),
      .clk   (clk),
      .rst_l (resetn),
      .q     (axi_ar_busy_ifu_q),
      .se(), .si(), .so());

   assign axi_ar_busy_ifu = axi_ar_busy_ifu_q;

   // uty: test
   // todo: axi_ar_busy_lsu 


   assign biu_ifu_rd_ack = axi_ar_ready & ~axi_ar_busy_ifu & ifu_select;
   assign biu_lsu_rd_ack = axi_ar_ready /*& ~axi_ar_busy_lsu*/ & lsu_select;

   assign arb_rd_val = biu_ifu_rd_ack | biu_lsu_rd_ack;

`````

![arb_rd_val correct](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2024-09-05_arb_rd_val_correct.png)

解决了这个问题，ifu_biu_rd_req是连续的，但arb_rd_req只发出一次，biu_ifu_rd_ack也是只回一次。
