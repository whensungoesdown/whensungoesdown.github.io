---
title: ext_intr sync
published: true
---
外部中断ext_intr来的时候不确定，可能在一个时钟周期里的任意时刻到，处理的时候也许cycle省的时间不够了，更差的情况是在cycle的末尾，给别的寄存器setup的时间到。所以ext_intr没法直接用，要先同步一下。

同步可以是与clk同步，让ext_intr总是在clk上升沿送进来。

`````verilog
// two-stage synchronizer
module sync2r (
   input  clk,
   input  resetn,
   input  din,
   output q
   )；

   reg d1, d2;

   always @(posedge clk, or negedge resetn) begin
      if (resetn)
         {d2, d1} <= 2'b0;
      else
         {d2, d1} <= {d1, din};
   end

   assign q = d2;
   
endmodule
`````

如果要以某一个信号作为起始信号同步，就可以先在sync2r后再与某个信号的上升沿同步。

先做个这个信号上升沿的检测，比如是ifu_exu_valid_rising_e;

`````verilog
wire ifu_exu_valid_rising_e;

wire prev_ifu_exu_valid_e;

dff_s #(1) ifu_exu_valid_e_posedge_detect_reg (
   .din (ifu_exu_valid_e),
   .clk (clk),
   .q   (prev_ifu_exu_valid_e),
   .se(), .si(), .so());

assign ifu_exu_valid_rising_e = ~prev_ifu_exu_valid_e & ifu_exu_valid_e;


wire ext_intr_sync;
wire ext_intr_sync_qual;

sync24 u_ext_intr_sync2r(
   .clk    (clk),
   .resetn (resetn),
   .din    (ext_intr),
   .q      (ext_intr_sync)
   );

dffelr ext_intr_sync_qual_reg (
   .clk    (clk),
   .din    (ext_intr_sync),
   .rst_l  (resetn),
   .en     (ifu_exu_valid_rising_e | ~ext_intr_sync),
   .q      (ext_intr_sync_qual)
   );
`````
