---
title: gs132 ifcbus
published: true
---

这两天看gs132的代码，看到CPU_gs132/ls132r_interface.v

里面的ifc还没搞明白是什么，应该不是instruction fetch control。

因为从代码里可以看出来，有inst到ifc，也有data到ifc。


`````verilog
output          idle_in_ifc_o;

input  [`Ltoifcbus-1:0]     inst_ifc_i;
output [`Lfromifcbus-1:0]   ifc_inst_o;

input  [`Ltoifcbus-1:0]     data_ifc_i;
output [`Lfromifcbus-1:0]   ifc_data_o;

wire        inst_ifc_valid = inst_ifc_i[ 0: 0];
wire [ 3:0] inst_ifc_width = inst_ifc_i[ 4: 1];
wire [ 3:0] inst_ifc_ben   = inst_ifc_i[ 8: 5];
wire        inst_ifc_wr    = inst_ifc_i[ 9: 9];
wire [31:0] inst_ifc_addr  = inst_ifc_i[41:10];
wire [31:0] inst_ifc_wdata = inst_ifc_i[73:42];

wire        inst_ifc_ack  ;
wire        inst_ifc_rrdy ;
wire [31:0] inst_ifc_rdata;

assign ifc_inst_o[ 0: 0] = inst_ifc_ack  ;
assign ifc_inst_o[ 1: 1] = inst_ifc_rrdy ;
assign ifc_inst_o[33: 2] = inst_ifc_rdata;

wire        data_ifc_valid = data_ifc_i[ 0: 0];
wire [ 3:0] data_ifc_width = data_ifc_i[ 4: 1];
wire [ 3:0] data_ifc_ben   = data_ifc_i[ 8: 5];
wire        data_ifc_wr    = data_ifc_i[ 9: 9];
wire [31:0] data_ifc_addr  = data_ifc_i[41:10];
wire [31:0] data_ifc_wdata = data_ifc_i[73:42];

wire        data_ifc_rack ;
wire        data_ifc_rrdy ;
wire [31:0] data_ifc_rdata;
wire        data_ifc_wack ;

assign ifc_data_o[ 0: 0] = data_ifc_rack ;
assign ifc_data_o[ 1: 1] = data_ifc_rrdy ;
assign ifc_data_o[33: 2] = data_ifc_rdata;
assign ifc_data_o[34:34] = data_ifc_wack ;
`````

-----------------------------------------


晕 找了半天，gs132里并没有axi_sram_bridge这样的ip。

要不就是直接用sram，要不就是用的xilinx的axi_sram。

从gs132的目录结构看。

`````shell
.
└── CPU_CDE_AXI
    ├── cpu132_gettrace
    │   ├── golden_trace.txt
    │   ├── rtl
    │   │   ├── BRIDGE
    │   │   ├── CONFREG
    │   │   ├── CPU_gs132
    │   │   ├── soc_lite_top.v
    │   │   ├── tags
    │   │   └── xilinx_ip
    │   ├── run_vivado
    │   │   ├── cpu132_gettrace
    │   │   └── soc_lite.xdc
    │   └── testbench
    │       └── tb_top.v
    ├── mycpu_axi_verify
    │   ├── rtl
    │   │   ├── axi_wrap
    │   │   ├── CONFREG
    │   │   ├── myCPU
    │   │   ├── ram_wrap
    │   │   ├── soc_axi_lite_top.v
    │   │   ├── tags
    │   │   └── xilinx_ip
    │   ├── run_vivado
    │   │   ├── mycpu_prj1
    │   │   └── soc_lite.xdc
    │   └── testbench
    │       └── mycpu_tb.v
    ├── Readme_First.txt
    └── soft

`````

一个是cpu132_gettrace，core的实现在这个目录下的myCPU里。

但是ls132r_top里的ls132r_interface看似是用了axi的接口，实际上axi的信号都没用上，最终还是sram的信号出去了。


而mycpu_axi_verify下的myCPU目录是空的。soc_axi_lite_top.v里也用的是mycpu_top，而不是上面说的ls132r_top。

这个mycpu_top到是和chiplab里的那个差不多。

soc_axi_lite_top.v里还用了个axi_crossbar_1x2，是xilinx的ip。这个crossbar我也是没看明白。

`````verilog
axi_crossbar_1x2 u_axi_crossbar_1x2(
    .aclk             ( cpu_wrap_aclk        ), // i, 1                 
    .aresetn          ( cpu_wrap_aresetn     ), // i, 1                 

    .s_axi_arid       ( cpu_wrap_arid        ),
    .s_axi_araddr     ( cpu_wrap_araddr      ),
    .s_axi_arlen      ( cpu_wrap_arlen[3:0]  ),
    .s_axi_arsize     ( cpu_wrap_arsize      ),
    .s_axi_arburst    ( cpu_wrap_arburst     ),
    .s_axi_arlock     ( cpu_wrap_arlock      ),
    .s_axi_arcache    ( cpu_wrap_arcache     ),
    .s_axi_arprot     ( cpu_wrap_arprot      ),
    .s_axi_arqos      ( 4'd0                 ),
    .s_axi_arvalid    ( cpu_wrap_arvalid     ),
    .s_axi_arready    ( cpu_wrap_arready     ),
    .s_axi_rid        ( cpu_wrap_rid         ),
    .s_axi_rdata      ( cpu_wrap_rdata       ),
    .s_axi_rresp      ( cpu_wrap_rresp       ),
    .s_axi_rlast      ( cpu_wrap_rlast       ),
    .s_axi_rvalid     ( cpu_wrap_rvalid      ),
    .s_axi_rready     ( cpu_wrap_rready      ),
    .s_axi_awid       ( cpu_wrap_awid        ),
    .s_axi_awaddr     ( cpu_wrap_awaddr      ),
    .s_axi_awlen      ( cpu_wrap_awlen[3:0]  ),
    .s_axi_awsize     ( cpu_wrap_awsize      ),
    .s_axi_awburst    ( cpu_wrap_awburst     ),
    .s_axi_awlock     ( cpu_wrap_awlock      ),
    .s_axi_awcache    ( cpu_wrap_awcache     ),
    .s_axi_awprot     ( cpu_wrap_awprot      ),
    .s_axi_awqos      ( 4'd0                 ),
    .s_axi_awvalid    ( cpu_wrap_awvalid     ),
    .s_axi_awready    ( cpu_wrap_awready     ),
    .s_axi_wid        ( cpu_wrap_wid         ),
    .s_axi_wdata      ( cpu_wrap_wdata       ),
    .s_axi_wstrb      ( cpu_wrap_wstrb       ),
    .s_axi_wlast      ( cpu_wrap_wlast       ),
    .s_axi_wvalid     ( cpu_wrap_wvalid      ),
    .s_axi_wready     ( cpu_wrap_wready      ),
    .s_axi_bid        ( cpu_wrap_bid         ),
    .s_axi_bresp      ( cpu_wrap_bresp       ),
    .s_axi_bvalid     ( cpu_wrap_bvalid      ),
    .s_axi_bready     ( cpu_wrap_bready      ),

    .m_axi_arid       ( {ram_arid   ,conf_arid   } ),
    .m_axi_araddr     ( {ram_araddr ,conf_araddr } ),
    .m_axi_arlen      ( {ram_arlen  ,conf_arlen  } ),
    .m_axi_arsize     ( {ram_arsize ,conf_arsize } ),
    .m_axi_arburst    ( {ram_arburst,conf_arburst} ),
    .m_axi_arlock     ( {ram_arlock ,conf_arlock } ),
    .m_axi_arcache    ( {ram_arcache,conf_arcache} ),
    .m_axi_arprot     ( {ram_arprot ,conf_arprot } ),
    .m_axi_arqos      (                            ),
    .m_axi_arvalid    ( {ram_arvalid,conf_arvalid} ),
    .m_axi_arready    ( {ram_arready,conf_arready} ),
    .m_axi_rid        ( {ram_rid    ,conf_rid    } ),
    .m_axi_rdata      ( {ram_rdata  ,conf_rdata  } ),
    .m_axi_rresp      ( {ram_rresp  ,conf_rresp  } ),
    .m_axi_rlast      ( {ram_rlast  ,conf_rlast  } ),
    .m_axi_rvalid     ( {ram_rvalid ,conf_rvalid } ),
    .m_axi_rready     ( {ram_rready ,conf_rready } ),
    .m_axi_awid       ( {ram_awid   ,conf_awid   } ),
    .m_axi_awaddr     ( {ram_awaddr ,conf_awaddr } ),
    .m_axi_awlen      ( {ram_awlen  ,conf_awlen  } ),
    .m_axi_awsize     ( {ram_awsize ,conf_awsize } ),
    .m_axi_awburst    ( {ram_awburst,conf_awburst} ),
    .m_axi_awlock     ( {ram_awlock ,conf_awlock } ),
    .m_axi_awcache    ( {ram_awcache,conf_awcache} ),
    .m_axi_awprot     ( {ram_awprot ,conf_awprot } ),
    .m_axi_awqos      (                            ),
    .m_axi_awvalid    ( {ram_awvalid,conf_awvalid} ),
    .m_axi_awready    ( {ram_awready,conf_awready} ),
    .m_axi_wid        ( {ram_wid    ,conf_wid    } ),
    .m_axi_wdata      ( {ram_wdata  ,conf_wdata  } ),
    .m_axi_wstrb      ( {ram_wstrb  ,conf_wstrb  } ),
    .m_axi_wlast      ( {ram_wlast  ,conf_wlast  } ),
    .m_axi_wvalid     ( {ram_wvalid ,conf_wvalid } ),
    .m_axi_wready     ( {ram_wready ,conf_wready } ),
    .m_axi_bid        ( {ram_bid    ,conf_bid    } ),
    .m_axi_bresp      ( {ram_bresp  ,conf_bresp  } ),
    .m_axi_bvalid     ( {ram_bvalid ,conf_bvalid } ),
    .m_axi_bready     ( {ram_bready ,conf_bready } )
    .m_axi_bvalid     ( {ram_bvalid ,conf_bvalid } ),
    .m_axi_bready     ( {ram_bready ,conf_bready } )

 );
`````

把cpu变slave，然后sram核confreg是master？


`````verilog
//axi ram
axi_wrap_ram u_axi_ram
(
    .aclk          ( cpu_clk          ),
    .aresetn       ( cpu_resetn       ),
    //ar
    .axi_arid      ( ram_arid         ),
    .axi_araddr    ( ram_araddr       ),
    .axi_arlen     ( {4'd0,ram_arlen} ),
    .axi_arsize    ( ram_arsize       ),
    .axi_arburst   ( ram_arburst      ),
    .axi_arlock    ( ram_arlock       ),
    .axi_arcache   ( ram_arcache      ),
    .axi_arprot    ( ram_arprot       ),
    .axi_arvalid   ( ram_arvalid      ),
    .axi_arready   ( ram_arready      ),
    //r             
    .axi_rid       ( ram_rid          ),
    .axi_rdata     ( ram_rdata        ),
    .axi_rresp     ( ram_rresp        ),
    .axi_rlast     ( ram_rlast        ),
    .axi_rvalid    ( ram_rvalid       ),
    .axi_rready    ( ram_rready       ),
    //aw           
    .axi_awid      ( ram_awid         ),
    .axi_awaddr    ( ram_awaddr       ),
    .axi_awlen     ( {4'd0,ram_awlen[3:0]}        ),
    .axi_awsize    ( ram_awsize       ),
    .axi_awburst   ( ram_awburst      ),
    .axi_awlock    ( ram_awlock       ),
    .axi_awcache   ( ram_awcache      ),
    .axi_awprot    ( ram_awprot       ),
    .axi_awvalid   ( ram_awvalid      ),
    .axi_awready   ( ram_awready      ),
    //w          
    .axi_wid       ( ram_wid          ),
    .axi_wdata     ( ram_wdata        ),
    .axi_wstrb     ( ram_wstrb        ),
    .axi_wlast     ( ram_wlast        ),
    .axi_wvalid    ( ram_wvalid       ),
    .axi_wready    ( ram_wready       ),
    //b              ram
    .axi_bid       ( ram_bid          ),
    .axi_bresp     ( ram_bresp        ),
    .axi_bvalid    ( ram_bvalid       ),
    .axi_bready    ( ram_bready       ),

    //random mask
    .ram_random_mask ( ram_random_mask )
);

//confreg
confreg #(.SIMULATION(SIMULATION)) u_confreg
(
    .timer_clk   ( timer_clk  ),  // i, 1   
    .aclk        ( cpu_clk    ),  // i, 1   
    .aresetn     ( cpu_resetn ),  // i, 1    

    .arid        (conf_arid    ),
    .araddr      (conf_araddr  ),
    .arlen       (conf_arlen   ),
    .arsize      (conf_arsize  ),
    .arburst     (conf_arburst ),
    .arlock      (conf_arlock  ),
    .arcache     (conf_arcache ),
    .arprot      (conf_arprot  ),
    .arvalid     (conf_arvalid ),
    .arready     (conf_arready ),
    .rid         (conf_rid     ),
    .rdata       (conf_rdata   ),
    .rresp       (conf_rresp   ),
    .rlast       (conf_rlast   ),
    .rvalid      (conf_rvalid  ),
    .rready      (conf_rready  ),
    .awid        (conf_awid    ),
    .awaddr      (conf_awaddr  ),
    .awlen       (conf_awlen   ),
    .awsize      (conf_awsize  ),
    .awburst     (conf_awburst ),
    .awlock      (conf_awlock  ),
    .awcache     (conf_awcache ),
    .awprot      (conf_awprot  ),
    .awvalid     (conf_awvalid ),
    .awready     (conf_awready ),
    .wid         (conf_wid     ),
    .wdata       (conf_wdata   ),
    .wstrb       (conf_wstrb   ),
    .wlast       (conf_wlast   ),
    .wvalid      (conf_wvalid  ),
    .wready      (conf_wready  ),
    .bid         (conf_bid     ),
    .bresp       (conf_bresp   ),
    .bvalid      (conf_bvalid  ),
    .bready      (conf_bready  ),

    .ram_random_mask ( ram_random_mask ),
    .led         ( led        ),  // o, 16   
    .led_rg0     ( led_rg0    ),  // o, 2      
    .led_rg1     ( led_rg1    ),  // o, 2      
    .num_csn     ( num_csn    ),  // o, 8      
    .num_a_g     ( num_a_g    ),  // o, 7      
    .switch      ( switch     ),  // i, 8     
    .btn_key_col ( btn_key_col),  // o, 4          
    .btn_key_row ( btn_key_row),  // i, 4           
    .btn_step    ( btn_step   )   // i, 2   
);
`````

axi_wrap_ram和confreg都是axi的接口。

axi_wrap_ram是个xilinx的ip。

confreg是有实现的，虽然不是想找的axi_sram_bridge，但这个里面应该可以学到东西。

还要是CPU_CDE_AXI/mycpu_axi_verify/rtl/CONFREG/confreg.v，这个里面的confreg才是axi接口的。


