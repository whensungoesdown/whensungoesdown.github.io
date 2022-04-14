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

