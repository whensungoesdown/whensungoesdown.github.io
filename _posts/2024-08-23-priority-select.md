---
title: verilog 里 order of priority 实现的方式
published: true
---

a的priority最高。

`````verilog
wire event_a;
wire event_b;
wire event_c;
wire event_d;

wire a_select;
wire b_select;
wire c_select;
wire d_select;

assign a_select = event_a;

assign b_select = ~event_a &
                   event_b;

assign c_select = ~event_a &
                  ~event_b &
                   event_c;

assign d_select = ~event_a &
                  ~event_b &
                  ~event_c &
                   event_d;

`````


如果2进制编码的话，可以这样，3bit没用完，就不搞太多x_select。

`````verilog
wire [2:0] encode;

assign encode = {3{a_select}} & 3'b001    |
                {3{b_select}} & 3'b010    |
                {3{c_select}} & 3'b011    |
                {3{d_select}} & 3'b100    |
                };
`````


也可以这样用， 不用encode。


`````verilog
always @* begin
   case({a_select, b_select, c_select, d_select})
      4'b0000
      begin
      // none selected
      end
      4'b0001:
      begin
      // select d
      end
      4'b0010:
      begin
      // select c
      end
      4'b0100:
      begin
      // select b
      end
      4'b1000:
      begin
      // select a
      end
      default:
      begin
      // default, handle error
      end
   endcase
end
`````
