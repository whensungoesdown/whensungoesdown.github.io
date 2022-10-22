---
title: Chiplab LSU
published: true
---

Chiplab的lsu要简单些，因为用的是memory interface，不需要处理dcache，也不需要通过AXI控制内存，因为这些都包装在别的模块。

`````verilog
module lsu_s1(
  input               clk,
  input               resetn,

  input               valid,
  input [`LSOC1K_LSU_CODE_BIT-1:0]lsu_op,
  input [`GRLEN-1:0]  base,
  input [`GRLEN-1:0]  offset,
  input [`GRLEN-1:0]  wdata,

  input               tlb_req,
  input               data_exception,
  input   [`GRLEN-1:0]data_badvaddr,
  input               tlb_finish,

  //memory interface
  output              data_req,
  output [`GRLEN-1:0] data_addr, 
  output              data_wr,
  `ifdef LA64
  output [ 7:0]       data_wstrb,
  `elsif LA32
  output [ 3:0]       data_wstrb,
  `endif
  output [`GRLEN-1:0] data_wdata,
  output              data_prefetch,
  output              data_ll,
  output              data_sc,
  input               data_addr_ok,

//result
  output              lsu_finish,
  output              lsu_ale,
  output              lsu_adem,
  output              lsu_recv,

  input [`LSOC1K_CSR_OUTPUT_BIT-1:0] csr_output,
  input                              change,
  input                              eret,
  input                              exception,
  output reg [`GRLEN-1:0]            badvaddr
);                                                                                                             9,1           To
`````


lsu_s1主要把写请求完成，因为地址数据都准备好了。

data_wr 1表示是写操作，0表示读操作。是读还是写是在lsu_op里通过在lsu_s1里判断指令类型。

lsu_s1里有个base和offset，base+offset是要写数据的地址。

其实 base + offset就是 reg + imm

`````verilog
lsoc1000_stage_issue.v


        ex1_lsu_base          <= rdata0_0_input;
        ex1_lsu_offset        <= port0_double_read ? rdata0_1_input : port0_triple_read ? rdata2_0_input : port0_imm_shifted;
        ex1_lsu_wdata         <= rdata0_1_input;

`````


lsu_s1有个lsu_finish的信号。返回data_addr_ok的时候就可以给这个信号。

`````verilog
// signal process
always @(posedge clk) begin
    if (rst || change)                                       res_valid <= 1'd0;
    else if(data_addr_ok || lsu_except || exception || eret) res_valid <= valid;
end

assign lsu_finish = data_addr_ok || res_valid || (lsu_op == `LSOC1K_LSU_IDLE);

`````



`````verilog
ex1_stage.v


//////basic
assign change =
    ((((ex1_port0_src == `EX_LSU) && ex1_port0_valid) || ((ex1_port1_src == `EX_LSU) && ex1_port1_valid)) ? lsu_finish    : 1'dd
1) &&
    ((((ex1_port0_src == `EX_MUL) && ex1_port0_valid) || ((ex1_port1_src == `EX_MUL) && ex1_port1_valid)) ? ex1_mul_ready : 1'dd
1) &&
    ((((ex1_port0_src == `EX_DIV) && ex1_port0_valid) || ((ex1_port1_src == `EX_DIV) && ex1_port1_valid)) ? ex1_div_ready : 1'dd
1) ;
assign ex1_allow_in = ex2_allow_in && change && tlb_allow_in;
`````

应该是在lsu_s2的时候，读出数据或者返回写数据成功的时候会给出data_data_ok。

现在还不清楚data_addr_ok能不能在同一个周期给出结果。如果能的话，那就是lsu_s1是单周期就行，lsu_s2需要等，等得多少个周期不确定。

-----------------------------------


`````verilog
module lsu_s2(
  input               clk,
  input               resetn,

  input               valid,
  input [`LSOC1K_LSU_CODE_BIT-1:0]lsu_op,
  input               lsu_recv,
  input [ 2:0]        lsu_shift,

  //cached memory interface
  output              data_recv,
  input               data_scsucceed,
  input   [`GRLEN-1:0]data_rdata,
  input               data_exception,
  input   [ 5:0]      data_excode,
  input   [`GRLEN-1:0]data_badvaddr,
  input               data_data_ok,

//result
  output [`GRLEN-1:0] read_result,
  output              lsu_res_valid,

  input               change,
  input               exception,
  output reg [`GRLEN-1:0]   badvaddr,
  output              badvaddr_valid
);
`````


因为lsu分成了lsu_s1和lsu_s2两个部分，分别塞进了ex1_stage和ex2_stage，两个里面都有lsu_op的解码部分。

虽说是combinational logic，但还是需要transistor和propagation time的。

