---
title: 编译调试sparc的日常
published: true
---

之前的blog上都有详细的步骤，当时把过程中遇到的问题也都放到一起了。

现在这几天连着编译运行sparc，步骤简化如下。



一次开几个terminal

term0 
opensparc source

term1
u@unamed:~/prjs/OpenSPARCT1$ source OpenSPARCT1.bash 
u@unamed:~/prjs/OpenSPARCT1$ source ../../Xilinx91i/settings.sh 
u@unamed:~/prjs/OpenSPARCT1$ rxil -device=XC5VLX110T sparc

term2
u@unamed:~/prjs/OpenSPARCT1$ cp /home/u/prjs/OpenSPARCT1/design/sys/iop/sparc/xst/XC5VLX110T/sparc.ngc design/sys/edk/pcores/iop_fpga_v1_00_a/netlist/

term3
u@unamed:~/prjs$ ./startxps.sh
Hardware -> Clean Netlist
Hardware -> Clean Bits
Hardware -> Clean Hardware
Hardware -> Generate Bitstream

term4
u@unamed:~/prjs/testaceos$ source ~/Xilinx/10.1/ISE/settings64.sh
u@unamed:~/prjs/testaceos$ source ~/Xilinx/10.1/EDK/settings64.sh
u@unamed:~/prjs/testaceos$ xmd -tcl genace.tcl -jprog -target mdm -board ml505 -hw ~/prjs/OpenSPARCT1/design/sys/edk/implementation/system.bit -elf executable.elf -data ./1c4t_obp_prom.bin 0x8ff00000 -data ./ramdisk.ubuntu-7.10-gutsy.gz 0x8af00000 -ace uty_ubuntu_patchbitgen1c4t_test57.ace

term5
u@unamed:~/prjs$ sudo screen /dev/ttyUSB0 9600
