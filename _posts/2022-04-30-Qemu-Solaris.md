---
title: Qemu Sparc64
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


-----------

后来又找到个装debian的。
https://wiki.debian.org/Sparc64Qemu

用这里面的参数装ubuntu7.10没成功，不过debian9.0还是装上了。

> ## Using qemu-system-sparc64 command line
> 
> ** hard drive and d-i image
> 
> Once you have a virtual disk created, e.g.
> 
> `````shell
> qemu-img create -f qcow2 -o size=8G /path/to/vm/images/default/debian-unstable-sparc64.qcow2
> `````
> 
> As of 2016-06-28 you will need a d-i iso from
> 
> https://people.debian.org/~glaubitz/debian-cd/
> 
> ### Short form
> 
> Short form of qemu-system-sparc64, limited networking
> 
> `````shell
> qemu-system-sparc64 -hda /path/to/vm/images/default/debian-unstable-sparc64.qcow2 -cdrom /path/to/vm/images/default/iso/debian-9.0-sparc64-NETINST-1.iso -boot once=d -serial pty -nographic -m 160
> `````
> 
> Access the VM via
> 
> `````shell
> minicom -p /dev/pty/X
> `````
> 
> ### Longer form
> 
> Longer form of qemu-system-sparc64, shows a little more of the defined system features
> 
> `````shell
> LC_ALL=C QEMU_AUDIO_DRV=none \
> PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
> /usr/bin/qemu-system-sparc64 -name debian-unstable-sparc64 -machine sun4u,accel=tcg,usb=off -m 1024 \
> -realtime mlock=off -smp 1,sockets=1,cores=1,threads=1 \
> -uuid ccd8b5c2-b8e4-4d5e-af19-9322cd8e55bf -rtc base=utc -no-reboot -no-shutdown \
> -boot strict=on \
> -drive file=/path/to/vm/images/default/debian-unstable-sparc64.qcow2,if=none,id=drive-ide0-0-1,format=qcow2,cache=none,aio=native \
> -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-1,id=ide0-0-1 \
> -netdev user,id=hostnet0,hostfwd=tcp::5555-:22 \
> -device e1000,netdev=hostnet0,id=net0,mac=52:54:00:ce:98:e8 \
> -msg timestamp=on -serial pty -nographic
> `````shell
> 
> Connect to the VM's serial via PTY e.g. from minicom
> 
> `````shell
> minicom -p /dev/pty/X
> `````shell
