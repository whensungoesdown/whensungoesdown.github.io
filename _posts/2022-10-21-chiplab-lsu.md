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

double_read和trible_read？

`````verilog
wire lsu_dispatch        = port0_lsu_dispatch || port1_lsu_dispatch;
assign port0_triple_read = is_port0_op[`LSOC1K_TRIPLE_READ] && is_port0_valid;
assign port1_triple_read = is_port1_op[`LSOC1K_TRIPLE_READ] && is_port1_valid;
wire port0_double_read   = is_port0_op[`LSOC1K_DOUBLE_READ] && is_port0_valid;
wire port1_double_read   = is_port1_op[`LSOC1K_DOUBLE_READ] && is_port1_valid;

`````
triple read还得看手册，什么时候用，并且这个读的寄存器位值也很奇怪，2_0。

double read就是两个操作数都是从寄存器里得到的，而普通的是一个寄存器，另一个是imm。

这里有个问题，Chiplab给lsu的参数是以base和offset分别给的，在lsu里做的加法。

在我这里，如果给的是addr=base+offset，则这个加法是在decode阶段做的。如果分别给base offset到lsu里，加法就是在execute阶段。

叫base offset不好听，也没有分别用到base offset。

问题是解码，计算imm都是在decode，这里再把加法也放进来，会不会时间太长，因为要解码，还要读寄存器，读出来还要做加法。

这里的加法不复用ALU了。

暂时还是放execute里吧，在LSU里做加法。 似乎哪个项目里看到过AGU  address generation unit？



lsu_s1有个lsu_finish的信号。返回data_addr_ok的时候就可以给这个信号。

`````verilog
// signal process
always @(posedge clk) begin
    if (rst || change)                                       res_valid <= 1'd0;
    else if(data_addr_ok || lsu_except || exception || eret) res_valid <= valid;
end

assign lsu_finish = data_addr_ok || res_valid || (lsu_op == `LSOC1K_LSU_IDLE);

`````

lsu_finish信号的意思是只要data_addr_ok就可以了，后面就是等返回结果。这个信号只在lsu_s1里有，它影响ex1_stage里的change。


`````verilog
ex1_stage.v

//////basic 
assign change =     
    ((((ex1_port0_src == `EX_LSU) && ex1_port0_valid) || ((ex1_port1_src == `EX_LSU) && ex1_port1_valid)) ? lsu_finish    : 1'd1) &&
    ((((ex1_port0_src == `EX_MUL) && ex1_port0_valid) || ((ex1_port1_src == `EX_MUL) && ex1_port1_valid)) ? ex1_mul_ready : 1'd1) &&
    ((((ex1_port0_src == `EX_DIV) && ex1_port0_valid) || ((ex1_port1_src == `EX_DIV) && ex1_port1_valid)) ? ex1_div_ready : 1'd1) ;
    assign ex1_allow_in = ex2_allow_in && change && tlb_allow_in;
`````

change关系到流水线控制。表示lsu mul div这样的长周期指令的完成。

可这个change又反过来送进lsu_s1里，可能是表示lsu模块现在空闲出来了。对于lsu来说，只要data_addr_ok了，确实就可以执行下一条ld/st指令了，这个还是讲道理的。

这些长周期模块确实需要个信号来表示可以接收下一条指令，只是这个change的名字起的太随意了。


这里chiplab有个问题，change能反过来控制lsu_s1里的状态，而change是由lsu mul div三个长指令模块共同控制的。

上面代码的意思是只要这三个模块任何一个模块正在被占用，那一定要等它运算出结果才可以让lsu运行下一条指令。

可能本意是store存的是mul div的结果？只有运算结束了才能把算出来的结果写进内存？

我这里先不用change了，等和长周期指令一起调的时候，建立起byp的时候再想想这部分的逻辑。

现在我想让lsu的结果尽量简单明了。


lsu_finish和res_valid关系有点复杂。。


要在opensparc里看看，lsu模块空闲时用什么信号表示。






应该是在lsu_s2的时候，读出数据或者返回写数据成功的时候会给出data_data_ok。

现在还不清楚data_addr_ok能不能在同一个周期给出结果。如果能的话，那就是lsu_s1是单周期就行，lsu_s2需要等，等得多少个周期不确定。



valid和前面port0_valid一样的作用，没有valid就不会发data_req。

`````verilog
assign data_req   = valid && !lsu_except && !eret && !exception && !res_valid && !tlb_req && !(lsu_op == `LSOC1K_LSU_IDLE);   // withdraw require when exception happens

`````



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


lsu_s2里的lsu_recv是从lsu_s1里传过来的。在lsu_s1里是要外部返回data_addr_ok。

`````verilog
lsu_s1.v

assign lsu_recv = addr_ok_his || data_addr_ok;
`````

但是lsu_s2的这个output data_recv是干啥的没搞懂。

`````verilog
lsu_s2.v

assign data_recv  = lsu_recv && !res_valid;

`````

怎么还要是!res_valid。

这个data_recv是dcache memory interface里的。

`````verilog
lsoc1000_mainpipe.v

assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_REQ      ] = data_req       ;
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_PC       ] = data_pc        ;
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_WR       ] = data_wr        ;
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_WSTRB    ] = data_wstrb     ;
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_ADDR     ] = data_addr      ;
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_WDATA    ] = data_wdata     ;
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_RECV     ] = data_recv      ;
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_CANCEL   ] = data_cancel    ;
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_EX2CANCEL] = data_cancel_ex2;
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_PREFETCH ] = data_prefetch  ; // TODO
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_LL       ] = data_ll        ; // TODO
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_SC       ] = data_sc        ; // TODO
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_ATOM     ] = 1'b0           ; // TODO
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_ATOMOP   ] = 5'b0           ; // TODO
assign pipeline2dcache_bus[`PIPELINE2DCACHE_BUS_ATOMSRC  ] = `GRLEN'b0          ; // TODO

assign data_rdata      = dcache2pipeline_bus[`DCACHE2PIPELINE_BUS_RDATA    ];
assign data_addr_ok    = dcache2pipeline_bus[`DCACHE2PIPELINE_BUS_ADDROK   ];
assign data_data_ok    = dcache2pipeline_bus[`DCACHE2PIPELINE_BUS_DATAOK   ];
assign data_exccode    = dcache2pipeline_bus[`DCACHE2PIPELINE_BUS_EXCCODE  ];
assign data_exception  = dcache2pipeline_bus[`DCACHE2PIPELINE_BUS_EXCEPTION];
assign data_badvaddr   = dcache2pipeline_bus[`DCACHE2PIPELINE_BUS_BADVADDR ];
assign data_req_empty  = dcache2pipeline_bus[`DCACHE2PIPELINE_BUS_REQEMPTY ];
assign data_scsucceed  = dcache2pipeline_bus[`DCACHE2PIPELINE_BUS_SCSUCCEED];

`````



lsu_s1的valid来自ex1_stage。

`````verilog
ex1_stage.v


//lsu
wire ex1_lsu_valid = (((ex1_port0_src == `EX_LSU) && ex1_port0_valid) || //port0 & port1 share
                     ((ex1_port1_src == `EX_LSU) && ex1_port1_valid)) && !eret && !exception && !wb_cancel;

`````

ex1_port0_src是port0_op里解码得来的，我还直接把这部分放在decode吧。

-------------------------------------------------------------


在OpenSPARC里，lsu是和ifu exu并且的模块，里面负责cache相关的。

> • Load-store unit (LSU) — Processes memory referencing operation codes
>  (opcodes) such as various types of loads, various types of stores, CAS,
>  SWAP, LDSTUB, FLUSH, PREFETCH, and MEMBAR instructions. The
>  LSU interfaces with all the SPARC core functional units and acts as the
>  gateway between the SPARC core units and the CPU-cache crossbar
>  (CCX). Through the CCX, data transfer paths can be established with the
>  memory subsystem and the I/O subsystem (the data transfers are done with
>  packets). The LSU includes memory and write-back stages and a data
>  cache complex. The LSU pipeline has four stages:
>      • E stage – Cache and TLB setup
>      • M stage – Cache/Tag TLB read
>      • W stage – Store buffer look-up, trap detection, and execution of data 
>        bypass
>      • W2 stage – Generates PCX requests and write-backs to the cache

而在Chiplab里，lsu是在exu里，只负责从dcache读写数据。
