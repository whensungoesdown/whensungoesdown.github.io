---
title: LSU里读写内存有stall一个cycle结果回不来怎么办？
published: true
---

以前写的都是用block ram，一个cycle读写都能完成，所以没遇到这个问题。

现在要是用cache，cache miss以后需要很多个周期。取指时还好解决，取不到就ifu就不往下进行。

而LSU在读写内存时一个cycle回不来，就要stall在那，流水线也要暂停等结果。

chiplab里是结果返回后设置lsu_res_valid。data_data_ok是cached memory interface给出的读成功的信号。

`````verilog
lsu_s2.v
assign lsu_res_valid = data_data_ok || data_exception || res_valid || prefetch || !valid || (lsu_op == `LSOC1K_LSU_IDLE);

`````
在ex2_stage里，lsu指令的完成可以让change=1。最终设置ex2_allow_in让流水线动起来。


`````verilog
//result
wire port0_change;
wire port0_alu_change  = (ex2_port0_src == `EX_ALU0  ) && ex2_alu0_valid;
wire port0_lsu_change  = (ex2_port0_src == `EX_LSU   ) && lsu_res_valid;
wire port0_bru_change  = (ex2_port0_src == `EX_BRU   ) && ex2_bru_valid;
wire port0_none_change = (ex2_port0_src == `EX_NONE0 ) && ex2_none0_valid;
wire port0_div_change  = (ex2_port0_src == `EX_DIV   ) && ex2_div_valid;// && (div_complete || div_completed);
wire port0_mul_change  = (ex2_port0_src == `EX_MUL   ) && ex2_mul_valid && ex2_mul_ready;

wire port1_change;
wire port1_alu_change  = (ex2_port1_src == `EX_ALU1  ) && ex2_alu1_valid;
wire port1_lsu_change  = (ex2_port1_src == `EX_LSU   ) && lsu_res_valid;
wire port1_bru_change  = (ex2_port1_src == `EX_BRU   ) && ex2_bru_valid;
wire port1_none_change = (ex2_port1_src == `EX_NONE1 ) && ex2_none1_valid;
wire port1_div_change  = (ex2_port1_src == `EX_DIV   ) && ex2_div_valid;// && (div_complete || div_completed);
wire port1_mul_change  = (ex2_port1_src == `EX_MUL   ) && ex2_mul_valid && ex2_mul_ready;


//////basic
assign allow_in_temp = wb_allow_in && change;
assign ex2_allow_in  = allow_in_temp;  ////TODO: MAY WAIT FOR DEBUG

`````



有个问题，在双端口事，如果是一个端口的alu指令或者mul div指令完成设置的change，流水线流动，新进来的一条LSU指令，而这时另一个端口的LSU指令还没有完成怎么办？

也许在发射的时候就就不让其它类型的指令和LSU指令以其过来？

还得看看这种静态双发射都允许什么样的指令二条一起发射。


---------------------------------------------------

还得看看OpenSPARC T1的LSU怎么做的。

LSU是很大的一个模块，和ifu，exu，tlu都有关联。

控制cache，cache miss的时候又需要通过总线去内存取数据。
