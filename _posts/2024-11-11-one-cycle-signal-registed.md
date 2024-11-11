---
title: 看到个接口上保存信号的
published: true
---

接口给过来的信号xxx只持续一个cycle，这样的信号可能要接收端保存下。存到dff后，保存的xxx_q要到下一个cycle才行，但这个信号也许当前这个cycle就要用，那就把xxx和xxx_q或起来   xxx | xxx_q

这样的代码写不少了，这回是看到别人代码里也这样用，说明大家都遇到过相似的情况。不过这里用的不是 |, 而是有一个信号表示是不是第一个cycle。

这个是always的代码风格。

`````verilog
reg [2:0]    attrs_reg;

always @(posedge clk or negedge reset_n)
   if (~reset_n)
      attrs_reg     <= {3{1'b0}};
   else if (fist_cycle)
      attrs_reg     <= attrs_i;

wire [2:0] attrs = first_cycle ? attrs_i : attrs_reg;
       
`````

