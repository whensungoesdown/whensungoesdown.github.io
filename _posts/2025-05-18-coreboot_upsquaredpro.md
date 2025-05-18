---
title: Coreboot SeaVgaBIOS upsquaredpro 
published: true
---

Here is the problem. Coreboot cannot display anything on upsquared pro board, because SeaVgaBIOS has an issue.

-----------------------------------

Coreboot loads SeaBIOS as the payload firmware and SeaBIOS works at the legacy mode and only loads MBR partition. On the other hand, UEFI firmware only loads GPT partition. (UEFI firmware may support legacy boot mode, then it can load with MBR partition too.)


The firmwire comes with upsquared pro board is a UEFI one, but it does not support legacy mode boot.

So, I can not install Windows along with MBR partition. 

Although I can install ubuntu 20.04 with MBR partition, but with some extra work, as following.

1. Boot Ubuntu USB installer through UEFI firmware.

2. Only make / and swap partitions on the disk. Ubuntu will prompt that this configuration can not boot. So be it.

3. Flash coreboot to replace UEFI firmware.


However, this is not the case with installing Windows. Windows will always format the disk using GPT partition when the system is booted through UEFI mode.

------------------------------------------------------

The up squared vga issue with coreboot is documented on coreboot website.

https://doc.coreboot.org/mainboard/up/squared/index.html


> Not working / Known issues
>
> Generally SeaBIOS works, but it can’t find the CBFS region and therefore it can’t load seavgabios. This is because of changes at the Apollolake platform.


Someone solved this issue before. 


https://mail.coreboot.org/hyperkitty/list/coreboot@coreboot.org/thread/KYZQBLQZ2TERK674CVEYYRG7JINXZPBN/

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2025-05-18-coreboot_upsquaredpro/EBEFFE.png)

I tried. The offset is right, but the value I am looking for is not 0xFF483038.

The following is the steps to fix this issue.



`````shell
u@HX01040279:~/prjs/coreboot$ make menuconfig
`````

Devices->Display->Framebuffer mode, choose "Linear high-resolution framebuffer"

The default resolution

(3840) Maximum width in pixels
(2140) Maximum height in pixels

works fine.

![screenshot1](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2025-05-18-coreboot_upsquaredpro/framebuffermode.png)

Then compiles coreboot.

`````shell
u@HX01040279:~/prjs/coreboot$ make
`````

Next, fix SeaBIOS.

Change CONFIG\_CBFS\_LOCATION=0 to 0xFFFC0000.

After compiling coreboot, SeaBIOS .config will be reset.


`````shell
u@HX01040279:~/prjs/coreboot$ grep CONFIG_CBFS_LOCATION -R *
grep: build/coreboot.pre: binary file matches
grep: build/coreboot.rom: binary file matches
grep: build/coreboot.vgacbfsfix.6.rom: binary file matches
grep: build/coreboot.vgacbfsfix.8.rom: binary file matches
grep: build/coreboot.vgacbfshighres.rom: binary file matches
payloads/external/SeaBIOS/Makefile:     echo "CONFIG_CBFS_LOCATION=0xfffc0000" >> seabios/.config
payloads/external/SeaBIOS/seabios/.config:CONFIG_CBFS_LOCATION=0
payloads/external/SeaBIOS/seabios/out/autoconf.h:#define CONFIG_CBFS_LOCATION 0x0
payloads/external/SeaBIOS/seabios/out/include/config/auto.conf:CONFIG_CBFS_LOCATION=0
payloads/external/SeaBIOS/seabios/src/fw/coreboot.c:    struct cbfs_header *hdr = *(void **)(CONFIG_CBFS_LOCATION - 4);
payloads/external/SeaBIOS/seabios/src/fw/coreboot.c:    if (CONFIG_CBFS_LOCATION && (u32)hdr > CONFIG_CBFS_LOCATION)
payloads/external/SeaBIOS/seabios/src/fw/coreboot.c:        // Looks like the pointer is relative to CONFIG_CBFS_LOCATION
payloads/external/SeaBIOS/seabios/src/fw/coreboot.c:        hdr = (void*)hdr + CONFIG_CBFS_LOCATION;
payloads/external/SeaBIOS/seabios/src/fw/coreboot.c:    u32 romstart = CONFIG_CBFS_LOCATION - romsize;

`````

I tried add code to "payloads/external/SeaBIOS/Makefile" to set CONFIG\_CBFS\_LOCATION. No effect, SeaBIOS/Makefile seems to be ignored.

So, after compiling coreboot, go to seabios, do the following.

`````shell
u@HX01040279:~/prjs/coreboot$ cd payloads/external/SeaBIOS/seabios/
u@HX01040279:~/prjs/coreboot/payloads/external/SeaBIOS/seabios$ make menuconfig
`````
Set CBFS memory end location to 0xFFFC0000

![screenshot2](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2025-05-18-coreboot_upsquaredpro/seabios_cbfs_end.png)


`````shell
u@HX01040279:~/prjs/coreboot/payloads/external/SeaBIOS/seabios$ make
`````

Then, make coreboot again. build/coreboot.rom will be updated with the newly generated SeaBIOS.

`````shell
u@HX01040279:~/prjs/coreboot$ make
`````

Now, patch build/coreboot.rom.

At offset 0xBFBFFC, it is 0xFF34202C.

Change it to 0xFF44302C.


![screenshot3](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2025-05-18-coreboot_upsquaredpro/EBEFFC_fix.png)


Here is how the value is counted.

When booting, coreboot complains "Unable to find CFBS (ptr=0xff342c20; got 54a19295 not 4342524f)"

![screenshot4](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2025-05-18-coreboot_upsquaredpro/unabletofindcbfs_wrongoffset.png)

Search "Unable to find CFBS" in the code.

![screenshot5](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2025-05-18-coreboot_upsquaredpro/unabletofindcbfs.png)

At the end of CBFS (0xFFFC0000), there is a pointer that is 0xff342c20. It is supposed to point at CBFS\_HEADER\_MAGIC, but it points to data 54a19295.

Search 54a19295 and 4342524f in coreboot.rom.

"95 92 a1 54" is found at 24102C.

![screenshot6](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2025-05-18-coreboot_upsquaredpro/54a19295.png)

"4f 52 42 43" is found at 34202C.

![screenshot7](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2025-05-18-coreboot_upsquaredpro/4342524f.png)

It is seems to forget to caculate some offset.

Now, fix it.

0xFF34202C + (0x34202C - 0x24102C) = 0xFF44302C


