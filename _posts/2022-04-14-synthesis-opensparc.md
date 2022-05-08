---
title: XST Synthesis OpenSPARCT1 
published: true
---

装的Xilinx ISE9.1i。

`````shell
u@unamed:~$ source ~/Xilinx91i/settings.sh

u@unamed:~$ cd ~/prjs/OpenSPARCT1
u@unamed:~/prjs/OpenSPARCT1$ source OpenSPARCT1.bash

u@unamed:~/prjs/OpenSPARCT1$ rxil -device=XC5VLX110T -all
`````

我的开发板是XC5VLX110T的。

> The Virtex®-5 OpenSPARC Evaluation Platform is a powerful system for hosting the OpenSPARC T1 open-source microprocessor. Equivalent to the Xilinx® ML509 board and based on the Xilinx XUPV5-LX110T FPGA, this kit brings the throughput of OpenSPARC Chip Multi-Threading to an FPGA.
> 
> OpenSPARC T1 is the open-sourced version of the custom designed UltraSPARC T1 microprocesor from Sun Microsystems. To broaden the appeal of this state-of-the-art Chip Multi-threading (CMT) technology to the developers, engineers at Sun Microsystems and Xilinx Inc. have developed a reference design that allows a scaled-down version of the OpenSPARC T1 processor to run on Xilinx Virtex-5 FPGAs. This reference design is an excellent starting point for researchers and entrepreneurs to build and test novel ideas in the areas of computer architecture, logic design, parallel programming, and compiler techniques, among others. 


netlist生成好了以后，sparc.ngc还要复制到OpenSPARCT1/design/sys/edk/pcores/iop_fpga_v1_00_a/netlist目录下。

> To use an XST netlist instead, the Synplicity netlist must be removed and the XST
> netlist placed in the netlist directory in its place. There can only be one netlist in the
> netlist directory. The text box shows how to replace the Synplicity netlist with the
> XST netlist
> `````shell
> % cd $DV_ROOT/design/sys/edk/pcores/iop_fpga_v1_00_a
> % mv netlist/sparc.edf .
> % cp path-to-netlist/sparc.ngc netlist
> `````shell
> After the new netlist has been put in place, the file data/iop_fpga_v2_1_0.bbd
> must be edited to point to the new netlist.

在修改opensparc的代码后 可以只编译sparc部分来看编译是否成功，看下ERROR是不是0.
`````shell
u@unamed:~/prjs/OpenSPARCT1$ rxil -device=XC5VLX110T sparc
`````

因为就算有错没有成功编译，sparc.ngc也不会自动删除，很有可能用到以前的版本自己还不知道。

复制过去的sparc.ngc，在edk里生成bitstream的时候会用到。edk编译netlist是编译其它系统资源，而sparc核心的netlist就是用之前xst编译好的。
OpenSPARCT1/design/sys/edk/pcores/iop_fpga_v1_00_a/netlist/sparc.ngc会复制到OpenSPARCT1/design/sys/edk/implementation/iop_fpga_0_wrapper/sparc.ngc。

而在edk里，只有Hardware->Clean Hardware才会删掉以前的sparc.ngc。

如果sparc.ngc没有准备好，在Generate Bitstream的时候会有下面的出错提示。

`````shell
Managing hardware (BBD-specified) netlist files ...
IPNAME:iop_fpga INSTANCE:iop_fpga_0 -
/home/u/prjs/OpenSPARCT1/design/sys/edk/system.mhs line 344 - Copying
(BBD-specified) netlist files.
ERROR:MDT - BlackBox Netlist file iop_fpga_v1_00_a/netlist/sparc.ngc not found
ERROR:MDT - IPNAME:iop_fpga INSTANCE:iop_fpga_0 -
   /home/u/prjs/OpenSPARCT1/design/sys/edk/system.mhs line 344 - BBD netlist
   file(s) not found!
ERROR:MDT - platgen failed with errors!
make: *** [system.make:240: implementation/system.bmm] Error 2
Done!
`````


--------------------

先装了Xilinx ISE9.1i，再装EDK9.1的时候发现安装包里没有bin/lin64的目录，没办法在64位系统上装。
又装了ISE9.2i，成功装了EDK9.2。在打开system.xmp的时候报错，说这个工程是在10.1.03上生成的，也就是EDK10.1 sp3。
所以又装了10.1，这时候叫Design Suite，ISE和EDK一起都装上了。

system.xmp能打开，出错说：
`````shell
u@unamed:~$ Overriding Xilinx file <mdtgui/images/xps-splash-screen.bmp> with local file
</home/u/Xilinx/10.1/EDK/data/mdtgui/images/xps-splash-screen.bmp>
Generating Block Diagram :
/home/u/prjs/OpenSPARCT1/design/sys/edk/blkdiagram/system.html...
Generated --- system.svg
Rendering --- system.png
Error occurred during initialization of VM
java/lang/NoClassDefFoundError: java/lang/Object
ERROR:MDT - Rendering engine could not generate block diagram.
Generating Block Diagram :
/home/u/prjs/OpenSPARCT1/design/sys/edk/blkdiagram/dual_core.html...
Generated --- dual_core.svg
Rendering --- dual_core.png
Error occurred during initialization of VM
java/lang/NoClassDefFoundError: java/lang/Object
ERROR:MDT - Rendering engine could not generate block diagram.
`````
不过不影响，这个就先不管。


接着Generate Bitstream，紧接着的问题就是找不到microblaze_7_10_d这个IP，microblaze是个小cpu，在这里是起北桥的作用。
ip在`Xilinx/10.1/EDK/hw/XilinxProcessorIPLib/pcores`，但只找到了microblaza_7_10_a。
又装了EDK10.1 sp3补丁就有了。



------------------------------------
接下来又找不到libdb-4.1.so。装上了libdb，但版本不对，是5.3的。

`````shell
$ sudo ln -s /usr/lib/x86_64-linux-gnu/libdb-5.3.so /usr/lib/x86_64-linux-gnu/libdb-4.1.so
`````
这样凑合着应该是能用。


`````shell
ERROR:Xst:1484 - A core is unlicensed !
ERROR:MDT - Aborting XST flow execution!
INFO:MDT - Refer to
   /home/u/prjs/OpenSPARCT1/design/sys/edk/synthesis/hard_ethernet_mac_wrapper_x
   st.srp for details
Running NGCBUILD ...
ERROR:MDT - IPNAME:hard_ethernet_mac_wrapper INSTANCE:hard_ethernet_mac -
   /home/u/prjs/OpenSPARCT1/design/sys/edk/dual_core.mhs line 158 - failed to
   move
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/hard_ethernet_mac_wrap
   per.ngc to
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/hard_ethernet_mac_wrap
   per/hard_ethernet_mac_wrapper.ngc
ERROR:MDT - IPNAME:ddr2_sdram_wrapper INSTANCE:ddr2_sdram -
   /home/u/prjs/OpenSPARCT1/design/sys/edk/dual_core.mhs line 191 - failed to
   move
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/ddr2_sdram_wrapper.ngc
   to
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/ddr2_sdram_wrapper/ddr
   2_sdram_wrapper.ngc
ERROR:MDT - IPNAME:xps_intc_0_wrapper INSTANCE:xps_intc_0 -
   /home/u/prjs/OpenSPARCT1/design/sys/edk/dual_core.mhs line 313 - failed to
   move
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/xps_intc_0_wrapper.ngc
   to
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/xps_intc_0_wrapper/xps
   _intc_0_wrapper.ngc
ERROR:MDT - IPNAME:ccx2mb_0_to_microblaze_0_wrapper
   INSTANCE:ccx2mb_0_to_microblaze_0 -
   /home/u/prjs/OpenSPARCT1/design/sys/edk/dual_core.mhs line 323 - failed to
   move
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/ccx2mb_0_to_microblaze
   _0_wrapper.ngc to
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/ccx2mb_0_to_microblaze
   _0_wrapper/ccx2mb_0_to_microblaze_0_wrapper.ngc
ERROR:MDT - IPNAME:microblaze_0_to_ccx2mb_0_wrapper
   INSTANCE:microblaze_0_to_ccx2mb_0 -
   /home/u/prjs/OpenSPARCT1/design/sys/edk/dual_core.mhs line 350 - failed to
   move
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/microblaze_0_to_ccx2mb
   _0_wrapper.ngc to
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/microblaze_0_to_ccx2mb
   _0_wrapper/microblaze_0_to_ccx2mb_0_wrapper.ngc
ERROR:MDT - IPNAME:iop_fpga_0_wrapper INSTANCE:iop_fpga_0 -
   /home/u/prjs/OpenSPARCT1/design/sys/edk/dual_core.mhs line 361 - failed to
   move
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/iop_fpga_0_wrapper.ngc
   to
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/iop_fpga_0_wrapper/iop
   _fpga_0_wrapper.ngc
ERROR:MDT - IPNAME:aurora_201_pcore_0_to_microblaze_0_wrapper
   INSTANCE:aurora_201_pcore_0_to_microblaze_0 -
   /home/u/prjs/OpenSPARCT1/design/sys/edk/dual_core.mhs line 376 - failed to
   move
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/aurora_201_pcore_0_to_
   microblaze_0_wrapper.ngc to
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/aurora_201_pcore_0_to_
   microblaze_0_wrapper/aurora_201_pcore_0_to_microblaze_0_wrapper.ngc
ERROR:MDT - IPNAME:microblaze_0_to_aurora_201_pcore_0_wrapper
   INSTANCE:microblaze_0_to_aurora_201_pcore_0 -
   /home/u/prjs/OpenSPARCT1/design/sys/edk/dual_core.mhs line 408 - failed to
   move
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/microblaze_0_to_aurora
   _201_pcore_0_wrapper.ngc to
   /home/u/prjs/OpenSPARCT1/design/sys/edk/implementation/microblaze_0_to_aurora
   _201_pcore_0_wrapper/microblaze_0_to_aurora_201_pcore_0_wrapper.ngc
Rebuilding cache ...
ERROR:MDT - platgen failed with errors!
make: *** [dual_core.make:258: implementation/dual_core.bmm] Error 2
Done!

`````

这回是网卡的ip没有license。

搜到个xilinx_all_version.lic，加到Xilinx/10.1/ISE/coregen/core_licenses/目录下就可以了。



接着又出现这些
`````shell
ERROR:NgdBuild:604 - logical block
   'Hard_Ethernet_MAC/Hard_Ethernet_MAC/I_RX0/I_RX_STATUS_FIFO' with type
   'hard_ethernet_mac_wrapper_sync_fifo_v5_0_3' could not be resolved. A pin
   name misspelling can cause this, a missing edif or ngc file, or the
   misspelling of a type name. Symbol
   'hard_ethernet_mac_wrapper_sync_fifo_v5_0_3' is not supported in target
   'virtex5'.
ERROR:NgdBuild:604 - logical block
   'Hard_Ethernet_MAC/Hard_Ethernet_MAC/I_RX0/I_RX_FIFO' with type
   'hard_ethernet_mac_wrapper_sync_fifo_v5_0_4' could not be resolved. A pin
   name misspelling can cause this, a missing edif or ngc file, or the
   misspelling of a type name. Symbol
   'hard_ethernet_mac_wrapper_sync_fifo_v5_0_4' is not supported in target
   'virtex5'.
ERROR:NgdBuild:604 - logical block
   'Hard_Ethernet_MAC/Hard_Ethernet_MAC/I_RX0/I_RX_TEMAC_IF/I_RX_CL_IF/I_RX_CLIE
   NT_FIFO' with type 'hard_ethernet_mac_wrapper_async_fifo_v6_1_2' could not be
   resolved. A pin name misspelling can cause this, a missing edif or ngc file,
   or the misspelling of a type name. Symbol
   'hard_ethernet_mac_wrapper_async_fifo_v6_1_2' is not supported in target
   'virtex5'.
ERROR:NgdBuild:604 - logical block
   'Hard_Ethernet_MAC/Hard_Ethernet_MAC/I_TX0/I_TX_TEMAC_IF/I_TX_CL_IF/I_TX_CLIE
   NT_FIFO' with type 'hard_ethernet_mac_wrapper_async_fifo_v6_1_1' could not be
   resolved. A pin name misspelling can cause this, a missing edif or ngc file,
   or the misspelling of a type name. Symbol
   'hard_ethernet_mac_wrapper_async_fifo_v6_1_1' is not supported in target
   'virtex5'.
ERROR:NgdBuild:604 - logical block
   'Hard_Ethernet_MAC/Hard_Ethernet_MAC/I_TX0/I_TX_CSUM_FIFO' with type
   'hard_ethernet_mac_wrapper_sync_fifo_v5_0_1' could not be resolved. A pin
   name misspelling can cause this, a missing edif or ngc file, or the
   misspelling of a type name. Symbol
   'hard_ethernet_mac_wrapper_sync_fifo_v5_0_1' is not supported in target
   'virtex5'.
ERROR:NgdBuild:604 - logical block
   'Hard_Ethernet_MAC/Hard_Ethernet_MAC/I_TX0/I_TX_FIFO' with type
   'hard_ethernet_mac_wrapper_sync_fifo_v5_0_2' could not be resolved. A pin
   name misspelling can cause this, a missing edif or ngc file, or the
   misspelling of a type name. Symbol
   'hard_ethernet_mac_wrapper_sync_fifo_v5_0_2' is not supported in target
   'virtex5'.

`````

最终显示的是这个。

OpenSPARCT1/design/sys/edk/synthesis目录下有生成的system.ngc文件。

`````shell
Partition Implementation Status
-------------------------------
  No Partitions were found in this design.
-------------------------------
NGDBUILD Design Results Summary:
  Number of errors:     6
  Number of warnings: 108
One or more errors were found during NGDBUILD.  No NGD file will be written.
Writing NGDBUILD log file "system.bld"...
make: *** [system.make:252: __xps/system_routed] Error 1
ERROR:Xflow - Program ngdbuild returned error code 2. Aborting flow execution...
    
Done!
`````

从这个文件里能看到更具体点的出错信息。
`OpenSPARCT1/design/sys/edk/synthesis/hard_ethernet_mac_wrapper_xst.srp`


`````shell
Synthesizing Unit <hard_ethernet_mac_wrapper>.
    Related source file is "/home/u/prjs/OpenSPARCT1/design/sys/edk/hdl/hard_ethernet_mac_wrapper.vhd".
Unit <hard_ethernet_mac_wrapper> synthesized.

WARNING: verilog is not supported as a language.  Using usenglish.
Release 10.1.03 - edk_generatecore $Revision: 1.1.2.1.4.14.4.11 $ (lin64)
Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
Error occurred during initialization of VM
java/lang/NoClassDefFoundError: java/lang/Object
ERROR:coreutil - Aborting COREGEN execution!
Generated unit <hard_ethernet_mac_wrapper_sync_fifo_v5_0_1>.

End of process call...
WARNING: verilog is not supported as a language.  Using usenglish.
Release 10.1.03 - edk_generatecore $Revision: 1.1.2.1.4.14.4.11 $ (lin64)
Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
Error occurred during initialization of VM
java/lang/NoClassDefFoundError: java/lang/Object
ERROR:coreutil - Aborting COREGEN execution!
Generated unit <hard_ethernet_mac_wrapper_sync_fifo_v5_0_2>.

End of process call...
WARNING: verilog is not supported as a language.  Using usenglish.
Release 10.1.03 - edk_generatecore $Revision: 1.1.2.1.4.14.4.11 $ (lin64)
Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
Error occurred during initialization of VM
java/lang/NoClassDefFoundError: java/lang/Object
ERROR:coreutil - Aborting COREGEN execution!
Generated unit <hard_ethernet_mac_wrapper_async_fifo_v6_1_1>.
`````


这个看上去是个java程序没跑起来，edk_generatecore是个程序，最后找到这里：


`````shell
u@unamed:~/prjs/OpenSPARCT1/design/sys/edk/implementation$ edk_generatecore -v hard_ethernet_mac_wrapper
Release 10.1.03 - edk_generatecore $Revision: 1.1.2.1.4.14.4.11 $ (lin64)
Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.

INFO:coreutil - Arguments passed to core generator:
#cell=
#simName=hard_ethernet_mac_wrapper
#component=
#targetArch=

Executing: /home/u/Xilinx/10.1/ISE/java/lin64/jre/bin/java -Xmx1048m -Xms10m -cp
/home/u/Xilinx/10.1/EDK/hw/coregen/lib/coreutil.jar:/home/u/Xilinx/10.1/EDK/hw/c
oregen/lib/sim.jar:/home/u/Xilinx/10.1/EDK/hw/coregen/lib/xcc.jar::/home/u/Xilin
x/10.1/ISE/coregen/lib/coreutil.jar:/home/u/Xilinx/10.1/ISE/coregen/lib/sim.jar:
/home/u/Xilinx/10.1/ISE/coregen/lib/xcc.jar::/home/u/Xilinx/10.1/ISE/coregen/ip/
xilinx/dsp:/home/u/Xilinx/10.1/ISE/coregen/ip/xilinx/network:/home/u/Xilinx/10.1
/ISE/coregen/ip/xilinx/other:/home/u/Xilinx/10.1/ISE/coregen/ip/xilinx/primary
com.xilinx.sim.netlisters.NetlisterAPI -APIFile=/tmp/xil_eIRXql.opt
Error occurred during initialization of VM
java/lang/NoClassDefFoundError: java/lang/Object
ERROR:coreutil - Aborting COREGEN execution!
Arguments file /tmp/xil_eIRXql.opt not deleted.
Generated unit <>.

u@unamed:~/prjs/OpenSPARCT1/design/sys/edk/implementation$ /home/u/Xilinx/10.1/ISE/java/lin64/jre/bin/java
Error occurred during initialization of VM
java/lang/NoClassDefFoundError: java/lang/Object
u@unamed:~/prjs/OpenSPARCT1/design/sys/edk/implementation$ file /home/u/Xilinx/10.1/ISE/java/lin64/jre/bin/java
/home/u/Xilinx/10.1/ISE/java/lin64/jre/bin/java: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.4.0, stripped
`````

可以看到这个edk_generatecore居然是调用java程序。ISE10.1自带的java程序应该是在我的这个系统上跑不起来，单独运行都会出同样的错。

Java不熟，看样是个挺老的版本。

`Xilinx/10.1/ISE/java/lin64/jre/README`

`````shell
                                README

                Java(TM) 2 Platform Standard Edition
                        Runtime Environment
                            Version 5.0


The J2SE(TM) Runtime Environment (JRE) is intended for software developers
and vendors to redistribute with their applications.

The J2SE Runtime Environment contains the Java virtual machine,
runtime class libraries, and Java application launcher that are
necessary to run programs written in the Java programming language.
It is not a development environment and does not contain development
tools such as compilers or debuggers.  For development tools, see the
J2SE Development Kit.


=======================================================================
     Deploying Applications with the J2SE Runtime Environment
=======================================================================

When you deploy an application written in the Java programming
language, your software bundle will probably consist of the following
parts:

            Your own class, resource, and data files.
            A runtime environment.
            An installation procedure or program.

You already have the first part, of course. The remainder of this
document covers the other two parts. See also the Notes for Developers
page on the Java Software website:

     http://java.sun.com/j2se/1.5.0/runtime.html
`````

下载个新的Java SE Development Kit 5.0u22

https://www.oracle.com/java/technologies/java-archive-javase5-downloads.html

https://download.oracle.com/otn/java/jdk/1.5.0_22/jdk-1_5_0_22-linux-amd64.bin

运行安装后找到里面的jre目录。
`````shell
u@unamed:~/tools/jdk1.5.0_22$ ls
bin  COPYRIGHT  demo  include  jre  lib  LICENSE  man  README.html  sample  src.zip  THIRDPARTYLICENSEREADME.txt
u@unamed:~/tools/jdk1.5.0_22$ ls jre
bin  CHANGES  COPYRIGHT  lib  LICENSE  README  THIRDPARTYLICENSEREADME.txt  Welcome.html
`````
然后用这个jre目录替换Xilinx/10.1/ISE/java/lin64/jre。
问题就解决了，xps启动后Block Diagram显示出来了，之前也是java的问题这里出错。

还有个事情要注意，从新生成bitstream的时候，要把Hardware菜单下的Clean Netlist，Clean Bits和Clean Hardware全都运行清理一遍。
否则之前的错误还在，没有重新生成。
特别是Clean Hardware，才看到下面这个文件被清理了，相应的东西重新生成。

`OpenSPARCT1/design/sys/edk/synthesis/hard_ethernet_mac_wrapper_xst.srp`


--------------------------
现在这个环境能生成bitstream了，netlist system.ngc文件，1.2MB, system.ngd, 22MB。

![generate bitstream](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-04-14.png)



------------------------
第二天早上一看，console里又输出了不少。

`````shell
ERROR:Bitgen - Unknown PLL_ADV site  in pminfo.
ERROR:Bitgen - Unknown PLL_ADV site  in pminfo.
ERROR:Bitgen - Unknown PLL_ADV site  in pminfo.
ERROR:Bitgen - Unknown PLL_ADV site  in pminfo.
ERROR:Bitgen - Unknown PLL_ADV site  in pminfo.
ERROR:Bitgen - Unknown PLL_ADV site  in pminfo.
ERROR:Bitgen - Unknown PLL_ADV site  in pminfo.
ERROR:Bitgen - Unknown PLL_ADV site  in pminfo.
Saving bit stream in "system.bit".
Bitstream generation is complete.
`````

没有找到怎么解决这个错误，但bitstream还是成功生成了，system.bit。
后来用system.bit生成ace文件，放到ml505上跑也成功了。

pminfo这些应该是BFD file里的东西。

> PLL_ADV    Primitive: Advanced Phase Locked Loop Clock Circuit


> 3.2 BFD Files
> BFD (BitFile Description) files are internal and proprietary Xilinx files which map configuration
> information to bitstream contents. The configuration information consists of all the programmable
> resources in a device family, including routing resources, logic configuration, and block RAM re-
> sources. This configuration information is broken down according to tile type, and is mapped to
> configuration bits through sets of equations. These equations are expressed in BFD syntax and are
> commonly referred to as BFD equations.
> 
> Each FPGA family typically has its own BFD file, able to accommodate the entire range of devices
> in the family. This means that a BFD file must define resources and configuration bits for all tile
> types which occur in the family, even though not all tile types will necessarily be present in all
> devices in the family. In addition the BFD file may define abstract tile types which never occur in
> any device in the family, but which are used hierarchically as parents of other tile types. The use
> of abstract tile types in BFD files increases the maintainability of the files, decreases their sizes,
> and allows them to more accurately match the device models.
> 
> BFD files are normally included with Xilinx software tools in a binary format suitable only for tool
> use. The BFD files used here are original text files from which the binary versions are generated.


先不管了。


大意了。。。生成的ace文件不行，这个错误还是要解决。


/home/u/Xilinx/10.1/ISE/bin/lin64/bitgen，用的时候参数在bitgen.ut里。
`````shell
system.make:	cd implementation; bitgen -w -f bitgen.ut $(SYSTEM)
`````



`````shell
$(SYSTEM_ACE):
        @echo "In order to generate ace file, you must have:-"
        @echo "- exactly one processor."
        @echo "- opb_mdm, if using microblaze."

`````


edk/system.log里还有错误。这个之前处理过。
`````shell
ERROR:MDT - C_MEM_CAS_LATENCY0 (mpmc) -
   /home/u/Xilinx/10.1/ISE/bin/lin64/unwrapped/xilperl: error while loading
   shared libraries: libdb-4.1.so: cannot open shared object file: No such file
   or directory
       while executing
   "exec xilperl $perlPath  -mpmc3
                                   -family      [xget_hw_parameter_value $mh..."
       (procedure "init_control" line 40)
       invoked from within
   "init_control   $mhsinst"
       (procedure "::hw_mpmc_v4_03_a::syslevel_update_ctrl_parameter" line 6)
       invoked from within
   "::hw_mpmc_v4_03_a::syslevel_update_ctrl_parameter 100783616"

`````

system.log之前的编译信息也都保存着，所以这个是改过了。
