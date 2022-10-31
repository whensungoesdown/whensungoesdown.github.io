---
title: LSU OP decode 搞错地方了
published: true
---

应该放在_d。现在是放在_e了。

LSU BRU要是想stall IFU，最好在_d就判断好指令，这样stall IFU的时候就不需要再处理_d流水线寄存器里的指令了，要不_d也得stall。


ALU也是把alu_op送进去的，里面也有解码的部分。

感觉应该把lsu_op在_d送进去，decode的verilog代码也是在lsu里，把结果送到_e的流水线寄存器里。

不过看到在OpenSPARC里也是部分解码出op，具体详细的还是在各个功能模块里。

`````verilog
ifu/rtl/sparc_ifu_dec.v

//----------------------------------------------------------------------
// Code Begins Here
//----------------------------------------------------------------------
   assign       clk = rclk;


   assign   op  = dtu_inst_d[31:30];
   assign   op2 = dtu_inst_d[24:22];
   assign   op3 = dtu_inst_d[24:19];
   assign   opf = dtu_inst_d[13:5];

   // decode op
   assign   brsethi_inst = ~op[1] & ~op[0];
   assign   call_inst    = ~op[1] &  op[0];
   assign   arith_inst   =  op[1] & ~op[0];
   assign   mem_inst     =  op[1] &  op[0];

   // partial decode op2
   assign   sethi_or_nop = op2[2] & ~op2[1] & ~op2[0];

   // decode op3
   assign   op3_hi[0] = ~op3[5] & ~op3[4];
   assign   op3_hi[1] = ~op3[5] &  op3[4];
   assign   op3_hi[2] =  op3[5] & ~op3[4];
   assign   op3_hi[3] =  op3[5] &  op3[4];

   assign   op3_lo[0]  = ~op3[3] & ~op3[2] & ~op3[1] & ~op3[0];
   assign   op3_lo[1]  = ~op3[3] & ~op3[2] & ~op3[1] &  op3[0];
   assign   op3_lo[2]  = ~op3[3] & ~op3[2] &  op3[1] & ~op3[0];



...



   //-------------
   // ALU Controls
   //-------------
   // mov bit
   assign ifu_exu_aluop_d[2] = brsethi_inst & sethi_or_nop |   // sethi
                            arith_inst & op3_hi[2] & op3[3];   // mov, rd

   // aluop
   assign ifu_exu_aluop_d[1] = (arith_inst &
                                      ((op3_hi[3] & (op3_lo[0] |   // wr
                                               op3_lo[2] |   // wrpr
                                               op3_lo[3])) | // wrhpr
                                                         (~op3[5] & op3[1]))         // xor, or
                                );

   // aluop/mov type
   assign ifu_exu_aluop_d[0] = (arith_inst &
                                      ((op3_hi[3] & (op3_lo[0] |
                                               op3_lo[2] |
                                               op3_lo[3])) | // wr
                                                         (~op3[5] & op3[0])        | // xor, and
                                                         (op3_hi[2] & op3_lo[15]))   // movr
                                );

   // invert rs2
   assign ifu_exu_invert_d  = arith_inst &
                              (~op3[5] & op3[2]  |   // sub, andn, orn, xorn
                               op3_hi[2] & (op3_lo[3] | op3_lo[1])); // tag sub

   assign ifu_exu_usecin_d   = arith_inst & ~op3[5] & op3[3];   // addc, subc

`````

现在LSU就先不改了，先用lsu_dispatch_d，这个就是表明指令是lsu related的。


