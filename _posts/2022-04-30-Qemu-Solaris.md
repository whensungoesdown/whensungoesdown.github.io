---
title: Qemu Sparc64 Solaris
published: true
---

想先在Sparc虚拟机上装ubuntu，发现qemu模拟sparc还要麻烦些。
像装x86系统那样装sparc版的ubuntu，卡在了load kernel上。

在qemu手册上找到了模拟sparc的方法。


> ## Sparc64 System emulator
> 
> Use the executable qemu-system-sparc64 to simulate a Sun4u (UltraSPARC PC-like machine), Sun4v (T1 PC-like machine), or generic Niagara (T1) machine. The Sun4u emulator is mostly complete, being able to run Linux, NetBSD and OpenBSD in headless (-nographic) mode. The Sun4v emulator is still a work in progress.
> 
> The Niagara T1 emulator makes use of firmware and OS binaries supplied in the S10image/ directory of the OpenSPARC T1 project http://download.oracle.com/technetwork/systems/opensparc/OpenSPARCT1_Arch.1.5.tar.bz2 and is able to boot the disk.s10hw2 Solaris image.
> 
> `````shell
> qemu-system-sparc64 -M niagara -L /path-to/S10image/ \
>                     -nographic -m 256 \
>                     -drive if=pflash,readonly=on,file=/S10image/disk.s10hw2
> `````
> 
> QEMU emulates the following peripherals:
> 
>     UltraSparc IIi APB PCI Bridge
>     PCI VGA compatible card with VESA Bochs Extensions
>     PS/2 mouse and keyboard
>     Non Volatile RAM M48T59
>     PC-compatible serial ports
>     2 PCI IDE interfaces with hard disk and CD-ROM support
>     Floppy disk



按上面说的方法跑起sparc虚拟机了，但只能是Solaris。

----------

装好后创建了一个新用户u，# useradd u
但改不了密码，后来网上找到了原因，Solaris还是有些和linux不一样的地方。

> You need to specify the repository where do you wanna change it,, in case locally then:
> passwd -r files “username”
