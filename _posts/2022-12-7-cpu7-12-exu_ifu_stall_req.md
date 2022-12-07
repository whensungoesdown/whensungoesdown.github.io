---
title: exu_ifu_stall_req
published: true
---

### exu_ifu_stall_req

This signal stalls the IFU from fetching next instruction and the pc_f remains.

When executing a load instruction, the pipeline need to be stalled until it retrives data.



`````verilog
assign fdp_dec_valid = inst_valid & ~exu_ifu_stall_req & ~br_taken;
`````

>  exu_ifu_stall_req should contains br_taken.

Turns out, br_taken better not mess with exu_ifu_stall_req because br_taken actually changes pc which is different from load mul div.

`````verilog
 189    // when branch taken, inst_cancel need to be signal
 190    // so that the new target instruction can be fetched instead of the one previously requested
 191    assign inst_cancel = br_taken;
 192
 193    assign ifu_pcbf_sel_init_bf_l = ~reset;
 194    // use inst_valid instead of inst_addr_ok, should name it fcl_fdp_pcbf_sel_old_l_bf
 195    //assign ifu_pcbf_sel_old_bf_l = inst_valid || reset || br_taken;
 196    assign ifu_pcbf_sel_old_bf_l = (inst_valid || reset || br_taken) & (~exu_ifu_stall_req);
 197
 198    //assign ifu_pcbf_sel_pcinc_bf_l = ~(inst_valid && ~br_taken);  /// ??? br_taken never comes along with inst_valid, br_taken_e
 199    assign ifu_pcbf_sel_pcinc_bf_l = ~(inst_valid && ~br_taken) | exu_ifu_stall_req;  /// ??? br_taken never comes along with inst_valid, br_\

`````

It should also contains the stall request from the mul and div.
