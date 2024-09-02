---
title: axi channel valid control
published: true
---

原来我是用下面这种方式控制axi channel里的valid，比如ar_valid。

但当结束信号ext_biu_ar_ready和开始信号arb_rd_val_q一起high起来的时候会有问题，后面还需要补偿下 | arb_rd_val_q

这个scenario 2我也不记得当时什么场景了， 好像不太对，先这么放着了。

`````verilog
   // scenario 0
   //
   // arb_rd_val_q         : _-_____
   // ext_biu_ar_ready     : _____-_
   //
   // ar_valid_in          : _----__
   // ar_valid_q           : __----_
   // biu_ext_ar_valid     : _-----_ 

   // scenario 1
   // 
   // arb_rd_val_q         : _-_____
   // ext_biu_ar_ready     : _-_____
   //
   // ar_valid_in          : _______
   // ar_valid_q           : _______ 
   // biu_ext_ar_valid     : _-_____ 

   // scenario 2
   // 
   // arb_rd_val_q         : -______
   // ext_biu_ar_ready     : -______
   //
   // ar_valid_in          : _______
   // ar_valid_q           : -______ 
   // biu_ext_ar_valid     : -______ 

   wire ar_valid_in;
   wire ar_valid_q;


   assign ar_valid_in = (ar_valid_q | arb_rd_val_q) & (~ext_biu_ar_ready);
   assign biu_ext_ar_valid = ar_valid_q | arb_rd_val_q;

   dffrl_s #(1) ar_valid_reg (
      .din   (ar_valid_in),
      .clk   (clk),
      .rst_l (resetn),
      .q     (ar_valid_q),
      .se(), .si(), .so());

`````

后来发现这样写更好些，`wire biu_ext_ar_valid_in = (biu_ext_ar_valid & ~ext_biu_ar_ready) | arb_rd_val;`

道理是一样的，但开始和结束信号一起到的时候也没问题。以后这种控制信号，都改成下面这样些了。


`````verilog
   // scenario 0
   //
   // arb_rd_val           : _-_____
   // ext_biu_ar_ready     : _____-_
   //
   // biu_ext_ar_valid_in  : _----__
   // biu_ext_ar_valid_q   : __----_

   // scenario 1
   // 
   // arb_rd_val           : _-_____
   // ext_biu_ar_ready     : _-_____
   //
   // biu_ext_ar_valid_in  : _-_____
   // biu_ext_ar_valid_q   : __-____ 


   wire biu_ext_ar_valid_in = (biu_ext_ar_valid & ~ext_biu_ar_ready) | arb_rd_val;
   
   dffrl_s #(1) ar_valid_reg (
      .din   (biu_ext_ar_valid_in),
      .clk   (clk),
      .rst_l (resetn),
      .q     (biu_ext_ar_valid_q),
      .se(), .si(), .so());

   assign biu_ext_ar_valid = biu_ext_ar_valid_q;

`````

