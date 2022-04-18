---
title: Generate ace file
published: true
---

前两天生成了.bit文件，按照OpenSPARC T1 Processor Design and Verification User's Guide里的方法就可以
通过调试链接开发板把要跑的操作系统传上去了。

但是我想用CF卡。CF卡上之前跑Solaris是一个.ace文件，大概100MB左右。

所以，首先就要生成.ace文件，并且把bootloader和Solaris系统也都装进取。

Xilinx自带的iMPACT，也就是bin下的impact可以生成ace，但是没找到怎样把Solaris也放进去。

主要就是靠网上搜到的Xilinx OpenSPARC Tutorial 2了。里面说了运行独立程序的步骤，但把程序的那个gz包换成Solaris也可以。

`````shell
u@unamed:~/prjs/testaceos$ source ~/Xilinx/10.1/ISE/settings64.sh
u@unamed:~/prjs/testaceos$ source ~/Xilinx/10.1/EDK/settings64.sh

u@unamed:~/prjs/testaceos$ xmd -tcl genace.tcl -jprog -target mdm -board ml505 -hw ~/prjs/OpenSPARCT1/design/sys/edk/implementation/system.bit -elf executable.elf -data ./1c4t_obp_prom.bin 0x8ff00000 -data ./ramdisk.snv-b77-nd.gz 0x8af00000 -ace uty_testopensolaris.ace

`````

这些文件都是OpenSPARC里自带的
~/prjs/OpenSPARCT1/design/sys/edk/ccx-firmware/executable.elf
~/prjs/OpenSPARCT1/design/sys/edk/os/proms/1c4t_obp_prom.bin
~/prjs/OpenSPARCT1/design/sys/edk/os/OpenSolaris/proto/ramdisk.snv-b77-nd.gz

才发现prom我用的是1c4t的，1核4线程，但我编译的sparc内核是单线程的，也就是1c1t。不过看来影响不大。


最主要的是这个genace.tcl文件，在这个位置。但这个文件也是可以处理ml505开发板的。
~/prjs/OpenSPARCT1/design/sys/edk_bee3/bee3_util/ace/genace_bee3.tcl

只是里面有一个小问题。
line 472:

`````tcl
 460 proc get_elf_startaddr { target_type elffile } {
 461     if { ![file exists $elffile] } {
 462         puts "Error: File $elffile not found\n"
 463         return -code error
 464     }
 465 
 466     if { $target_type == "ppc_hw" } {
 467         if { [catch {set saddr [exec powerpc-eabi-objdump -x $elffile | grep -w "start address"]} err] } {
 468             puts "Error: Executable $elffile does not contain start address.."
 469             return -code error
 470         }
 471     } else {
 472         if { [catch {set saddr [exec mb-objdump -x $elffile | grep -w "start address"]} err] } {
 473             puts "Error: Executable $elffile does not contain start address.."
 474             return -code error
 475         }
 476     }
 477     set saddr_list [string trimleft $saddr]
 478     set saddr [lindex $saddr_list end]
 479     return $saddr
 480 }
`````
mb-objdump改成objdump。


Memory map addresses也在OpenSPARC T1 Processor Design and Verification User's Guide的p6-10里给出了。

-------------------------------------------

现在有了ace文件，就得说下该怎么在开发板上跑。

tutorial里说的是把板上的sw3开关拌到10101010，表示从CF卡启动，并且0-2位是010，表示读rev2目录里的文件，
所以要把生成的ace文件放在/rev2目录下。
这个听上去很合理，因为ace文件里还有OBP（Open Boot PROM）。但其实这个prom应该是OpenSPARC启动时的firmware，
microblaze启动时运行的是microblaze_0_bootloop。ccx-firmware是干啥的还没搞清楚。
而我这个ml505开发板启动的时候，如果sw3在10101000的时候（rev0），是先进入个小菜单的。
启动自己的ace文件可以放在/config/rev6/里，开机的时候选6。


