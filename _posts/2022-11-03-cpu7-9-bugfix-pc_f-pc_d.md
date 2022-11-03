---
title: BUG FIX: pc_f到pc_d，在指令还没fetch回来的时候就把pc_f传给pc_d了。
published: true
---

这部分传递受到exu_ifu_stall_req控制，同时也受inst_valid控制。

就算是ALU指令也不应该是阶梯一样，每个cycle都向下传，因为这里fetch指令的时候要5个周期。

应该是下面蓝线这样，pc_bf和pc_f以后就停住了，直到新的pc_bf处的指令读回来了，这个时候pc_bf+4，pc_f再次获得pc_bf的值。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-11-03-0.png)

在时序图里，会有一个时刻，pc_f和pc_bf值一样，指向下一条指令，而且inst为0，这时候_f阶段的valid信号也是0。

当时在想，这个时候要不要不让pc_f等于pc_bf，因为如果这个时候要用pc_f的值并不正确，等指令fetch到了pc_f再更新才好。

我看了OpenSPARC，也是这样。

`````verilog
ifu/rtl/sparc_ifu_fdp.v


//   assign fdp_icd_vaddr_bf = icaddr_bf[47:0];
   // this goes to the itlb, icd and ict on top of fdp
   // this is !!very critical!!
   assign fdp_icd_vaddr_bf = pc_bf[47:2];

   // create separate output for the icv to the left
   assign fdp_icv_index_bf = pc_bf[11:5];

   // Place this mux as close to the top (itlb) as possible
   dp_mux3ds #(48) pcbf_mux(.dout  (pc_bf[47:0]),
                          .in0   (swpc_bf[47:0]),
                          .in1   (nextpc_nosw_bf[47:0]),
                          .in2   (exu_ifu_brpc_e[47:0]),
                          .sel0_l (fcl_fdp_pcbf_sel_swpc_bf_l),
                          .sel1_l (fcl_fdp_pcbf_sel_nosw_bf_l),
                          .sel2_l (fcl_fdp_pcbf_sel_br_bf_l));

   dff_s #(48)  pcf_reg(.din  (pc_bf),
                    .clk  (clk),
                    .q    (pc_f),
                    .se   (se), .si(), .so());

   assign fdp_erb_pc_f = pc_f[47:0];
`````

如果fdp_icd_vaddr_bf是去cache里取值的，如果cache miss，无论怎样，下一个周期里pc_f都会等于pc_bf。

以后还要看看cache miss怎样stall pc_bf的。上面这个pcbf_mux，如果不选switch pc，也不选branch pc的话nextpc_nosw_bf应该要stall。


`````verilog
   // can reduce this to a 2:1 mux since reset pc is not used any more and
   // pc_f is not needed.
   dp_mux3ds #(49) pcp4_mux(.dout  (nextpc_nosw_bf),
                          .in0   (pcinc_f),
                          .in1   (thr_trappc_bf),
                          .in2   ({fcl_fdp_pcoor_f, pc_f[47:0]}),
                          .sel0_l (fcl_fdp_noswpc_sel_inc_l_bf),
                          .sel1_l (fcl_fdp_noswpc_sel_tnpc_l_bf),
                          .sel2_l (fcl_fdp_noswpc_sel_old_l_bf));

`````

看样也是sel_old。




----------------------------------------------


`````verilog
ifu/rtl/sparc_ifu_fdp.v


   // Thread instruction muxes
   dp_mux4ds #(33)  t0inst_mux(.dout (t0inst_s1),
                             .in0 (ifq_fdp_fill_inst),
                             .in1 (inst_s1_bf1),
                             .in2 (t0inst_s2),
                             .in3 (rb_inst0_s),
                             .sel0_l (fcl_fdp_tinst_sel_ifq_s_l[0]),
                             .sel1_l (fcl_fdp_tinst_sel_curr_s_l[0]),
                             .sel2_l (fcl_fdp_tinst_sel_old_s_l[0]),
                             .sel3_l (fcl_fdp_tinst_sel_rb_s_l[0]));


ifu/rtl/sparc_ifu_fcl.v

   // thread IR input muxes
   assign fcl_fdp_tinst_sel_rb_s_l   = ~rb_w2;
   assign fcl_fdp_tinst_sel_ifq_s_l  = rb_w2 | ~ifq_fcl_fill_thr;
   assign fcl_fdp_tinst_sel_curr_s_l = ~val_thr_s1 | rb_w2 | ifq_fcl_fill_thr;
   assign fcl_fdp_tinst_sel_old_s_l  = val_thr_s1 | rb_w2 | ifq_fcl_fill_thr;

`````

还没搞清楚。
