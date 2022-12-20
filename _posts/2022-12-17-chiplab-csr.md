---
title: chiplab里的csr
published: true
---

`````verilog
    // csrrd/wr/xchg
    output [`GRLEN-2         :0] rdata,    <---
    input  [`LSOC1K_CSR_BIT-1:0] raddr,
    input  [`GRLEN-1         :0] wdata,
    input  [`LSOC1K_CSR_BIT-1:0] waddr,
    input                        wen  ,
`````
这有个bug，rdata长度是31bit。

可能因为很少csr寄存器用到第31bit吧，不容易发现。


csr寄存器是这样实现的。

`````verilog
// CRMD 0x0_0_0
reg [1:0] crmd_plv;                                                      
reg       crmd_ie;                                                       
reg       crmd_da;                                                       
reg       crmd_pg;
reg [1:0] crmd_datf;                                                     
reg [1:0] crmd_datm;                                                     
reg       crmd_we;                                                       
assign crmd = {
  `ifdef GS264C_64BIT                                                    
    32'b0,    //63:32                                                    
    22'b0,    //31:10                                                    
    crmd_we  ,//9                                                        
  `else
    23'b0,    //31:9                                                     
  `endif
    crmd_datm,//8:7                                                      
    crmd_datf,//6:5                                                      
    crmd_pg,  //4                                                        
    crmd_da,  //3                                                        
    crmd_ie,  //2
    crmd_plv  //1:0                                                      
};


...


//// read/write interface
assign rdata =  {`GRLEN{raddr == `LSOC1K_CSR_CRMD      }} & crmd      |
                {`GRLEN{raddr == `LSOC1K_CSR_PRMD      }} & prmd      |
                `ifdef GS264C_64BIT
                {`GRLEN{raddr == `LSOC1K_CSR_MISC      }} & misc      |
                `endif
                {`GRLEN{raddr == `LSOC1K_CSR_EUEN      }} & euen      |
                {`GRLEN{raddr == `LSOC1K_CSR_ECTL      }} & ectl      |
                {`GRLEN{raddr == `LSOC1K_CSR_ESTAT     }} & estat     |
                {`GRLEN{raddr == `LSOC1K_CSR_EPC       }} & epc       |
                {`GRLEN{raddr == `LSOC1K_CSR_BADV      }} & badv      |
                `ifdef GS264C_64BIT
                {`GRLEN{raddr == `LSOC1K_CSR_BADI      }} & badi      |
                `endif
                {`GRLEN{raddr == `LSOC1K_CSR_EBASE     }} & ebase     |
                {`GRLEN{raddr == `LSOC1K_CSR_INDEX     }} & tlbidx    |
                {`GRLEN{raddr == `LSOC1K_CSR_TLBEHI    }} & tlbehi    |
                {`GRLEN{raddr == `LSOC1K_CSR_TLBELO0   }} & tlbelo0   |
                {`GRLEN{raddr == `LSOC1K_CSR_TLBELO1   }} & tlbelo1   |
                {`GRLEN{raddr == `LSOC1K_CSR_ASID      }} & asid      |
                {`GRLEN{raddr == `LSOC1K_CSR_PGDL      }} & pgdl      |
                {`GRLEN{raddr == `LSOC1K_CSR_PGDH      }} & pgdh      |
                {`GRLEN{raddr == `LSOC1K_CSR_PGD       }} & pgd       |
                `ifdef GS264C_64BIT
                {`GRLEN{raddr == `LSOC1K_CSR_PWCL      }} & pwcl      |
                {`GRLEN{raddr == `LSOC1K_CSR_PWCH      }} & pwch      |
                {`GRLEN{raddr == `LSOC1K_CSR_STLBPS    }} & stlbps    |
                {`GRLEN{raddr == `LSOC1K_CSR_RVACFG    }} & rvacfg    |
                `endif
                {`GRLEN{raddr == `LSOC1K_CSR_CPUNUM    }} & cpunum    |
                `ifdef GS264C_64BIT
                {`GRLEN{raddr == `LSOC1K_CSR_PRCFG1    }} & prcfg1    |
                {`GRLEN{raddr == `LSOC1K_CSR_PRCFG2    }} & prcfg2    |
                {`GRLEN{raddr == `LSOC1K_CSR_PRCFG3    }} & prcfg3    |
                `endif
                {`GRLEN{raddr == `LSOC1K_CSR_SAVE0     }} & save0     |
                {`GRLEN{raddr == `LSOC1K_CSR_SAVE1     }} & save1     |
                {`GRLEN{raddr == `LSOC1K_CSR_SAVE2     }} & save2     |
                {`GRLEN{raddr == `LSOC1K_CSR_SAVE3     }} & save3     |
                `ifdef GS264C_64BIT
                {`GRLEN{raddr == `LSOC1K_CSR_SAVE4     }} & save4     |
                {`GRLEN{raddr == `LSOC1K_CSR_SAVE5     }} & save5     |
                {`GRLEN{raddr == `LSOC1K_CSR_SAVE6     }} & save6     |
                {`GRLEN{raddr == `LSOC1K_CSR_SAVE7     }} & save7     |
                `endif
                {`GRLEN{raddr == `LSOC1K_CSR_TID       }} & tid       |
                {`GRLEN{raddr == `LSOC1K_CSR_TCFG      }} & tcfg      |
                {`GRLEN{raddr == `LSOC1K_CSR_TVAL      }} & tval      |
                `ifdef GS264C_64BIT
                {`GRLEN{raddr == `LSOC1K_CSR_CNTC      }} & cntc      |
                `endif
                {`GRLEN{raddr == `LSOC1K_CSR_TICLR     }} & ticlr     |
                {`GRLEN{raddr == `LSOC1K_CSR_LLBCTL    }} & llbctl    |
                {`GRLEN{raddr == `LSOC1K_CSR_TLBREBASE }} & tlbrebase |
                `ifdef GS264C_64BIT
                {`GRLEN{raddr == `LSOC1K_CSR_TLBRBADV  }} & tlbrbadv  |
                {`GRLEN{raddr == `LSOC1K_CSR_TLBREPC   }} & tlbrepc   |
                {`GRLEN{raddr == `LSOC1K_CSR_TLBRSAVE  }} & tlbrsave  |
                {`GRLEN{raddr == `LSOC1K_CSR_TLBRELO0  }} & tlbrelo0  |
                {`GRLEN{raddr == `LSOC1K_CSR_TLBRELO1  }} & tlbrelo1  |
                {`GRLEN{raddr == `LSOC1K_CSR_TLBREHI   }} & tlbrehi   |
                {`GRLEN{raddr == `LSOC1K_CSR_TLBRPRMD  }} & tlbrprmd  |
                {`GRLEN{raddr == `LSOC1K_CSR_ERRCTL    }} & errctl    |
                {`GRLEN{raddr == `LSOC1K_CSR_ERRINFO1  }} & errinfo1  |
                {`GRLEN{raddr == `LSOC1K_CSR_ERRINFO2  }} & errinfo2  |
                {`GRLEN{raddr == `LSOC1K_CSR_ERREBASE  }} & errebase  |
                {`GRLEN{raddr == `LSOC1K_CSR_ERREPC    }} & errepc    |
                {`GRLEN{raddr == `LSOC1K_CSR_ERRSAVE   }} & errsave   |
                `endif
                {`GRLEN{raddr == `LSOC1K_CSR_DMW0      }} & dmw0      |
                {`GRLEN{raddr == `LSOC1K_CSR_DMW1      }} & dmw1      |
                                                        `GRLEN'd0     ;
`````

csrwr指令里要先读rd，写到csr寄存器里，再把寄存器里的旧值写回到rd。


`````verilog
 136    assign ecl_irf_rs1_d = ifu_exu_op_d[`LSOC1K_RD2RJ  ] ? `GET_RD(ifu_exu_inst_d) : `GET_RJ(ifu_exu_inst_d);                                 
 137    assign ecl_irf_rs2_d = ifu_exu_op_d[`LSOC1K_RD_READ] ? `GET_RD(ifu_exu_inst_d) : `GET_RK(ifu_exu_inst_d); 
`````

这种情况应该选LOSC1K_RD_READ。

`````verilog
decoder.v


  wire rd_read = op_jirl || op_beq || op_bne || op_blt || op_bge || op_bltu || op_bgeu ||
                op_bstrins_d || op_bstrins_w ||
                // op_lu32i_d ||
                op_csrxchg || op_csrwr ||
                op_sc_w || op_sc_d || op_stptr_w || op_stptr_d || op_st_b || op_st_h || op_st_w || op_st_d || op_stx_b || op_stx_h || op_stx_w || op_stx_d ||
                op_amswap_w || op_amswap_d || op_amadd_w || op_amadd_d || op_amand_w || op_amand_d || op_amor_w ||
                op_amor_d || op_amxor_w || op_amxor_d || op_ammax_w || op_ammax_d || op_ammin_w || op_ammin_d || op_ammax_wu || op_ammax_du || op_ammin_wu || op_ammin_du ||
                op_amswap_db_w || op_amswap_db_d || op_amadd_db_w || op_amadd_db_d || op_amand_db_w || op_amand_db_d || op_amor_db_w || op_amor_db_d || op_amxor_db_w ||
                op_amxor_db_d || op_ammax_db_w || op_ammax_db_d || op_ammin_db_w || op_ammin_db_d || op_ammax_db_wu || op_ammax_db_du || op_ammin_db_wu || op_ammin_db_du ||
                op_ldgt_b || op_ldgt_h || op_ldgt_w || op_ldgt_d || op_ldle_b || op_ldle_h || op_ldle_w || op_ldle_d || op_stgt_b || op_stgt_h ||
                op_stgt_w || op_stgt_d || op_stle_b || op_stle_h || op_stle_w || op_stle_d || //mem;
                op_iocsrwr_b || op_iocsrwr_h || op_iocsrwr_w || op_iocsrwr_d;

`````
