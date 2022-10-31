---
title: 遇到LSU指令时stall IFU，处理流水线中的指令
published: true
---

可以在_d阶段判断出是不是LSU指令，也可以知道是不是load指令。

现在store指令还没有试，不知道写成功回不回data_data_ok，要是回的话需要几个周期。

_d阶段，可以控制IFU仍然选择old pc，但当前的指令会进到_d的流水线寄存器。

1. 可以刷_d流水线寄存器

2. 可以用exu_ifu_stall_req来清除进到_d流水线寄存器的valid信号。这也相当于刷掉了这条指令，卡在_bf和_f的oldpc这条指令是最终送进流水线执行的。

	问题是，exu_ifu_stall_req信号从lsu_op decode给出，只有1个cycle有效，怎样让它持续到LSU指令完成。

	要看下openSPACR里，stall_req后是怎么恢复的。

`````verilog
ifu/rtl/sparc_ifu_fcl.v

   dff_s #(2) stlreq_reg(.din ({lsu_ifu_stallreq,
                              ffu_ifu_stallreq}),
                       .q   ({lsu_stallreq_d1,
                              ffu_stallreq_d1}),
                       .clk (clk), .se(se), .si(), .so());

   assign all_stallreq = ifq_fcl_stallreq | lsu_stallreq_d1 |
                         ffu_stallreq_d1 | itlb_starv_alert;

   // leave out stall from ifq which goes directly to swl
   assign fcl_dtu_stall_bf = lsu_stallreq_d1 | ffu_stallreq_d1 |
                             itlb_starv_alert | rst_stallreq;

`````

进了寄存器后留到_d阶段，这里有fcl_dtu_stall_bf和all_stall_req。

先看看fcl_dtu_stall_bf，这个是在bf阶段。

`````verilog
ifu/rtl/sparc_ifu_swl.v


//   assign sched_nt = fcl_dtu_switch_s & ~fcl_dtu_stall_bf;
   assign sched_nt = dtu_fcl_ntr_s & ~(fcl_dtu_stall_bf | ifq_swl_stallreq);
   assign schedule = dtu_fcl_nextthr_bf & {4{sched_nt}};
`````

看这样子是这个信号会进线程的状态机，会选择调度其它线程，这对当前线程就相当于stall了，但问题是stall发生的时候还先传到了_d寄存器，这个时候f里的指令不会给传递下去吗？


再看看all_stallreq。


`````verilog
ifu/rtl/sparc_ifu_fcl.v

//--------------------------
// Fetch Request and Stall
//--------------------------

   // Determine if we need can continue fetching next cycle
//   assign fetch_bf = (~all_stallreq & ~fcl_reset & ~rst_stallreq) &
//                   (switch_bf |
//                    ~(part_stall_thisthr_f | fdp_fcl_swc_s2));
//                    ~(stall_thisthr_f | fdp_fcl_swc_s2 | immu_fault_f));

   assign fetch_bf = (~all_stallreq & ~fcl_reset & ~rst_stallreq) &
                       (switch_bf |  // replace with ntr_s?
                        ~(part_stall_thisthr_f
                          | fdp_fcl_swc_s2
                          )
                        );

...




   //-------------------------
   // Valid Instruction Pipe
   //-------------------------
   // F stage
   assign inst_vld_bf = fetch_bf;
   dff_s #(1) inst_vld_ff(.din (inst_vld_bf),
                                  .clk (clk),
                                  .q   (inst_vld_f),
                                  .se  (se), .si(), .so());

   assign stall_f = ~inst_vld_f | kill_curr_f;
   assign stall_thisthr_f = stall_f | imsto_thisthr_s1 | // intrto_thisthr_d |
                                  kill_thread_s2 | rb_stg_s | ~dtu_fcl_running_s |
                            iferrto_thisthr_d1;

   assign part_stall_thisthr_f = stall_f |
                                 imsto_thisthr_s1 |
                                 ~dtu_fcl_running_s |
                                 ely_kill_thread_s2 |
                                       rb_stg_s;

   assign ely_stall_thisthr_f = stall_f | rb_stg_s;

//   assign stall_s1_nxt = stall_thisthr_f | intr_vld_s | tmsto_thisthr_f;
   assign stall_s1_nxt = stall_thisthr_f; //| intr_vld_s;

   // S1 stage
   dff_s #(1) stalld_ff(.din (stall_s1_nxt),
                                  .clk (clk),
                                  .q   (stall_s1),
                                  .se  (se), .si(), .so());

   assign inst_vld_s1 = ~stall_s1 & ~ic_miss_s1 & ~kill_curr_d;
   assign val_thr_s1 = thr_s1 & {4{inst_vld_s1}}; // 4b

   // S2 stage
   assign val_thr_f = thr_f & {4{~stall_f & ~rb_stg_s & dtu_fcl_running_s}};

   // Tag the S stage thr inst register as containing a valid inst or not
   assign tinst_vld_nxt = (ifq_fcl_fill_thr |
                           (rb_w2 & ~rb_for_iferr_e) | // set
                                             val_thr_s1 & ~val_thr_f |
                           //                      val_thr_s1 |
                                             tinst_vld_s & ~val_thr_f) &
                                              ~(clear_s_d1 |
                              {4{erb_dtu_ifeterr_d1 & inst_vld_d1 &
                                 ~rb_stg_e}} & thr_e);   // reset

   dffr_s #(4) tinst_reg(.din  (tinst_vld_nxt),
                                 .clk  (clk),
                                 .rst  (fcl_reset),
                                 .q    (tinst_vld_s),
                                 .se   (se), .si(), .so());

`````

终于见到用带reset的dff了。


inst_vld_f inst_vld_s inst_vld_e ... 一直跟着这条指令。是不是只要这条指令不是vld的，不管是什么指令进到哪个模块都是1个cycle通过？


还要看看lsu_ifu_stallreq是怎么产生的，能持续多久。

`````verilog
lsu/rtl/lsu_qctl2.v

// High water mark conservatively put at 16-4 = 12
assign  dfq_stall = (dfq_vld_entries[5:0] >= 6'd4) ;
assign  lsu_ifu_stallreq =
        dfq_stall |  int_skid_stall | lsu_tlbop_force_swo ;
        //dfq_stall | dfq_stall_d1 | dfq_stall_d2 | int_skid_stall | lsu_tlbop_force_swo ; 

dff_s   dfqst_d1 (
        .din  (dfq_stall), .q  (dfq_stall_d1),
        .clk  (clk),
        .se     (1'b0),       .si (),          .so ()
        );
`````

lsu_ifu_stallreq没有写是在哪个阶段也是有原因的。



要不就让exu_ifu_stall_req在_e发出？ 相当于LSU resource unavailable一直stall IFU。

再把_d里的指令tag inst_vld为0，一路跟下来。


其实LSU需要IFU是因为后续的指令可能会用到load的结果，寄存器值可能需要bypass。可以把指令当在_e就行。

不过我主要是想学习opensparc怎样控制流水线，各种情况都怎么处理。

现在知道fcl_reset的时候是会reset相关的寄存器的。

--------------------------------------------------------------

再来看ffu_ifu_stallreq。

`````verilog
ffu/rtl/sparc_ffu_ctl.v


   ///////////////////
   // bst starvation
   //----------------
   // when six bit counter saturates then a req to stall inst issue is made
   // The request stays high until a bst gets issued
   ///////////////////
   assign ffu_ifu_stallreq = bst_stall_req;
   assign bst_stall_req_next = ((bst_stall_cnt[5:0] == 6'b111111) & bst_issue_c2 & ~can_issue_bst_c2 |
                                bst_stall_req & other_mem_op_e);
   assign bst_stall_cnt_next[5:0] = (~bst_issue_c2)? 6'd0: bst_stall_cnt[5:0] + 6'd1;

`````

这个和我想要处理的情况特别像，先有一个信号来开启stall，然后另一个信号结束stall，但开启和结束的信号都只能是持续一个cycle。

ffu里紧接着是这两个寄存器。

`````verilog
   dff_s #(6) bst_stall_cntdff(.din(bst_stall_cnt_next[5:0]), .clk(clk), .q(bst_stall_cnt[5:0]),
                             .se(se), .si(), .so());
   dffr_s bst_stall_reqdff(.din(bst_stall_req_next), .clk(clk), .q(bst_stall_req),
                        .se(se), .si(), .so(), .rst(reset));

`````

这个方法不错啊，简化一下就是这样。

`````verilog
   assign bst_stall_req_next = (bst_stall_cnt[5:0] == 6'd111111) | bst_stall_req & other_mem_op_e;

   dffr_s bst_stall_reqdff(.din(bst_stall_req_next), .clk(clk), .q(bst_stall_req),
                        .se(se), .si(), .so(), .rst(reset));
`````

优先级 & 比 | 高

一但bst_stall_cnt满了，如果其它条件都不动，bst_stall_req就会一值是1，直到bst_stall_cnt变小了，或者other_mem_op_e为0，bst_stall_req这个开关就给关上了。

`````verilog
   assign        other_mem_op_e = exu_ffu_ist_e | ifu_tlu_flsh_inst_e | ifu_lsu_ld_inst_e;
`````

这个方法也可以用来做counter，我忘了上次做timer计数器的时候是咋搞的了，估计也是这样吧。


-------------------------------------------------------


uty: bug

还想到了一个LSU的bug，现在lsu是以data_data_ok为标志表示lsu操作结束，但可能遇到无效地址，或什么情况数据读不正确。

也就是说data_addr_ok和data_data_ok都有可能不出现。


现在这样，在exu_ecl里：
`````verilog
assign lsu_stall_req_next =  (lsu_dispatch_d) | (lsu_stall_req & ~lsu_ecl_rdata_valid_m);
`````

也可以搞个lsu_ecl_finish表示无论结果怎样lsu都完成了。不过如果出异常，lsu应该会raise exception。

看来还是应该先做几个测试，搞清LSU读写都会有什么情况发生。


-------------------------------------------------------


`````verilog
cpu7/IP/myCPU/cpu7_ifu_fdp.v


  73    // if exu ask ifu to stall, the pc_bf takes bc_f and the instruction passed                                                                                              
  74    // down the pipe should be invalid                                                                                                                                         
  75    //assign fdp_dec_valid = inst_valid;                                                                                                                                      
  76    assign fdp_dec_valid = inst_valid & ~exu_ifu_stall_req; 

...

 184    // use inst_valid instead of inst_addr_ok, should name it fcl_fdp_pcbf_sel_old_l_bf                                                                                       
 185    //assign ifu_pcbf_sel_old_bf_l = inst_valid || reset || br_cancel;                                                                                                        
 186    assign ifu_pcbf_sel_old_bf_l = (inst_valid || reset || br_cancel) & (~exu_ifu_stall_req);                                                                                
 187                                                                                                                                                                             
 188    //assign ifu_pcbf_sel_pcinc_bf_l = ~(inst_valid && ~br_cancel);  /// ??? br_cancel never comes along with inst_valid, br_cancel_e                                       
 189    assign ifu_pcbf_sel_pcinc_bf_l = ~(inst_valid && ~br_cancel) | exu_ifu_stall_req;  /// ??? br_cancel never comes along with inst_valid, br_cancel_e 
`````


`````verilog
cpu7/IP/myCPU/cpu7_exu_ecl.v


 382    // lsu stall request                                                                                                                                                       
 383                                                                                                                                                                                
 384    wire lsu_stall_req;                                                                                                                                                          
 385    wire lsu_stall_req_next;                                                                                                                                                    
 386                                                                                                                                                                                
 387    assign lsu_stall_req_next =  (lsu_dispatch_d) | (lsu_stall_req & ~lsu_ecl_rdata_valid_m);                                                                                 
 388                                                                                                                                                                                
 389    dffr_s #(1) lsu_stall_req_reg (                                                                                                                                              
 390       .din (lsu_stall_req_next),                                                                                                                                               
 391       .clk (clk),                                                                                                                                                               
 392       .q   (lsu_stall_req),                                                                                                                                                   
 393       .se(), .si(), .so(), .rst (~resetn));                                                                                                                                   
 394                                                                                                                                                                                
 395    assign exu_ifu_stall_req = lsu_stall_req_next;
`````

这里exu_ifu_stall_req选择lsu_stall_req_next，是为了让信号提前一个cycle。

如果是lsu_stall_req，要先经过dff，才能给到ifu，这样没法及时把在pc_f阶段的valid给取消掉。

有个有意思的现象，因为bug，ifu_pcbf_sel_pcinc_bf_l和ifu_pcbf_sel_old_bf_l同时为low，也就是4：1 mux选了两个，结果是pc_bf变成0了。

pc_f更新还是等着inst_valid，pc_bf停住，再反复取值，下发，只是valid是0，指令被后面忽略。

下面是测试代码 func_uty2_ld_2。

`````shell

obj/main.elf:     file format elf32-loongarch
obj/main.elf


Disassembly of section .text:

1c000000 <_start>:
kernel_entry():
1c000000:       14380006        lu12i.w $r6,114688(0x1c000)
1c000004:       028040c6        addi.w  $r6,$r6,16(0x10)
1c000008:       288000c7        ld.w    $r7,$r6,0
1c00000c:       02816805        addi.w  $r5,$r0,90(0x5a)

Disassembly of section .data:

1c000010 <var1>:
var1():
1c000010:       0000005a        0x0000005a

`````

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-10-30-0.png)

首先这个一连串的pc_x寄存器太让人头晕了，也不准确，因为pc_bf卡在哪等inst_valid，但后面的寄存器都跟着更新了。

uty: bug

这是个bug，要改。看看是加enable还是怎么样。lsu这样的模块，比如在load的时候，也需要把pc_m给维护好，可以给IFU送信号。

抛开这个bug不看，红线处，pc_bf刚变1c00000c（其实已经卡在1c000008很久了，一直等inst_valid），指令inst是288000c7。

inst_valid在这个cycle到了，所以下面是ifu_pcbf_set_pcint_bf_l=0。1c000008的指令准备执行。这时候pc_f就是1c000008。


![screenshot1](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-10-30-1.png)

下一个周期，ld指令deocde，所以exu_ifu_stall_req为1了。

从代码上说，`assign fdp_dec_valid = inst_valid & ~exu_ifu_stall_req;`，应该让fdp_dec_valid为0，而实际上因为fetch取值还没有取道，所以fdp_dec_valid本来也是0。


![screenshot2](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-10-30-2.png)

关键在这，红线的地方，inst_valid的来了，但因为这时候exu_ifu_stall_req还是1，所以fdp_dec_valid也是0，这个时候pc_bf pc_f都是还是一样的卡在1c00000c上。


![screenshot3](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-10-30-2.png)

exu_ifu_stall_req过去以后，又浪费了几个cycle，直到inst_valid再次来，一切才恢复正常。


之所以等这么久是因为用chiplab里操作cache的代码，fetch和load都需要大该7个还是8个的cycle。

还没看什么原因，不过等以后用cache，cache hit，读用1 cycle的时候，估计这部分会有bug出来。
