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

-------------------------------------------------------------------------
`````shell
u@unamed:~$ xclm
Traceback (most recent call last):
  File "/usr/lib/command-not-found", line 28, in <module>
    from CommandNotFound import CommandNotFound
  File "/usr/lib/python3/dist-packages/CommandNotFound/CommandNotFound.py", line 19, in <module>
    from CommandNotFound.db.db import SqliteDatabase
  File "/usr/lib/python3/dist-packages/CommandNotFound/db/db.py", line 5, in <module>
    import apt_pkg
ImportError: /home/u/Xilinx/10.1/EDK/lib/lin64/libstdc++.so.6: version `CXXABI_1.3.8' not found (required by /usr/lib/python3/dist-packages/apt_pkg.cpython-38-x86_64-linux-gnu.so)

`````



`````shell
u@unamed:/lib$ strings x86_64-linux-gnu/libstdc++.so.6 | grep CXXABI
CXXABI_1.3
CXXABI_1.3.1
CXXABI_1.3.2
CXXABI_1.3.3
CXXABI_1.3.4
CXXABI_1.3.5
CXXABI_1.3.6
CXXABI_1.3.7
CXXABI_1.3.8
CXXABI_1.3.9
CXXABI_1.3.10
CXXABI_1.3.11
CXXABI_1.3.12
CXXABI_TM_1
CXXABI_FLOAT128
u@unamed:/lib$ file x86_64-linux-gnu/libstdc++.so.6
x86_64-linux-gnu/libstdc++.so.6: symbolic link to libstdc++.so.6.0.28
u@unamed:/lib$ cd
u@unamed:~$ file /home/u/Xilinx/10.1/EDK/lib/lin64/libstdc++.so.6
/home/u/Xilinx/10.1/EDK/lib/lin64/libstdc++.so.6: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, stripped
u@unamed:~$ mv /home/u/Xilinx/10.1/EDK/lib/lin64/libstdc++.so.6 /home/u/Xilinx/10.1/EDK/lib/lin64/libstdc++.so.6.bak
u@unamed:~$ ln -s /lib/x86_64-linux-gnu/libstdc++.so.6 /home/u/Xilinx/10.1/EDK/lib/lin64/libstdc++.so.6
u@unamed:~$ file /home/u/Xilinx/10.1/EDK/lib/lin64/libstdc++.so.6
/home/u/Xilinx/10.1/EDK/lib/lin64/libstdc++.so.6: symbolic link to /lib/x86_64-linux-gnu/libstdc++.so.6
u@unamed:~$
`````

后来发现这个什么也不是，装的ISE里就没有xclm还是xlcm这个程序。
