---
title: microcode something
published: true
---

Trying to learn the microcode syntax.

Put some data here.

````shell
u@uu:~/prjs/lib-micro/build$ ./ms_match_n_patch_read
idx p src    dst
00: 0 0x0000  0x0000
01: 1 0x1434  0x06c6
02: 1 0x4c04  0x7c0a
03: 1 0x61e6  0x7cae
04: 1 0x757a  0x7cb0
05: 1 0x244a  0x7cdc
06: 1 0x065c  0x7c5c
07: 1 0x29ca  0x7c2e
08: 1 0x2078  0x7cf6
09: 1 0x263a  0x7cfe
10: 1 0x18c4  0x7cfa
11: 1 0x78d6  0x7d02
12: 1 0x2018  0x7c04
13: 1 0x5b94  0x7c14
14: 1 0x5ce2  0x7c88
15: 1 0x6908  0x7c6c
16: 1 0x3b52  0x7c4a
17: 1 0x4e76  0x7db8
18: 1 0x01ce  0x7ce6
19: 1 0x2ec8  0x7d6e
20: 1 0x6ff6  0x7d26
21: 1 0x13da  0x7d94
22: 1 0x667c  0x7cea
23: 1 0x0cd2  0x7d0a
24: 1 0x0e66  0x7d7a
25: 1 0x4c5a  0x7dd6
26: 1 0x24bc  0x7d12
27: 1 0x31a4  0x7d36
28: 1 0x758e  0x7df6
29: 0 0x0000  0x0000
30: 0 0x0000  0x0000
31: 0 0x0000  0x0000

`````

---------------------------------------

`````shell

0x018000f0
up0  : 0x0
eflow: 0xc
up1  : 0x3
uaddr: 0x0
up2  : 0x3
sync : 0x0
crc  : 0x0

0x018000c0
up0  : 0x0
eflow: 0x0
up1  : 0x3
uaddr: 0x0
up2  : 0x3
sync : 0x0
crc  : 0x0

NOP_SEQWORD
up0  : 0x0
eflow: 0x0
up1  : 0x3
uaddr: 0x0
up2  : 0x3
sync : 0x0
crc  : 0x0

END_SEQWORD
up0  : 0x2
eflow: 0xc
up1  : 0x3
uaddr: 0x0
up2  : 0x2
sync : 0x1
crc  : 0x0

`````

-----------------------------------------

Now the basic prototype works.

The problems are the followings.

The CPU already has many microcode patches, as listed above.

In total 32 match and patch entries, 29 of them are taken.

And the very limited microcode ram, range from 0x7C00 to 0x7e00, is also full.

There was no microcode patch from linux (or may be just one, saw it through dmesg | grep microcode). I added linux kernel command line option "dis_ucode_ldr" to disable loading microcode update. But still, the match and patch entries were not less. 

So, maybe the microcode updates are from the bios, it is the coreboot in this case. I also disabled microcode updates in coreboot, but have not tried that image yet. Hope it gives more space.

Now I am working on this coreboot image, trying to get some space.

I tried to reset all the match and patch entries to 0, so that it is as to be no patch applied and the ram space will be all available. But when I did this, the system is freezed. I guess there may be some important patch that the CPU can not run without it.

After serveral attemps, cleaning the first 16 entries seems ok. And it squeezes some space in ram.

(If I only clean the first 5 entries, space from 7c00 to 7c10 is still in use by some of the rest patch entries.)

Here is the steps to setup.

1. wrmsr to 0x1e6 with 0x200 (bit 9).

2. lib-micro.bak/build.bak/cmps_static_do_fix_IN_patch

3. lib-micro/build.bak/cmps_static_clean_first_16

4. lib-micro/build/cmps_static


The code is simple. At the beginning of cmps' microcode routine, check the memory content that rdi points to, fetching the first 64-bit data. If it matches certain pattern, in this case, 0x0000000041424142, returns z flag indicating the two strings in comparision are equal.

`````c
{SUBR_DSZ64_DRR(TMP10, TMP10, TMP10), GENARITHFLAGS_IR(0x0000003f, TMP10), SFENCE, 0x0b0000f2} // SEQW UEND0
`````

The SUB uop clears TMP10 register and set the z flag that associated with TMP10. Only doing the arithemic operation so that the z flag can be generated to the architecture EFLAGS register by the following uop `GENARITHFLAGS_IR(0x0000003f, TMP10)`.

Why 0x0000003f? Do not know yet.

Also not sure if the SFENCE is a must, copied that from the actual cmps microcode routine. So is 0x0b0000f2, which is a END_SEQWORD with up2 points to SFENCE with sync type being WAIT.

------------------------------------------------------------

Later I compiled coreboot without CBFS microcode update blob. I thought there would be less or even no microcode update any more.

Surprisingly, the microcode match and path entries even has one more! And the sram space also is used up to 0x7df2.

`````shell
u@uu:~/prjs/lib-micro.bak$ ./build/ms_match_n_patch_read_static
idx p src   dst
00: 0 0x0000  0x0000
01: 1 0x3a3a  0x7d9a
02: 1 0x6ef6  0x7d76
03: 1 0x6216  0x7d36
04: 1 0x29a2  0x7c80
05: 1 0x69ee  0x7d16
06: 1 0x18b2  0x7c26
07: 1 0x2832  0x7cea
08: 1 0x549a  0x7c3a
09: 1 0x6706  0x7d06
10: 1 0x23aa  0x7cca
11: 1 0x4868  0x7c60
12: 1 0x2010  0x7c08
13: 1 0x18dc  0x7c00
14: 1 0x4588  0x7c38
15: 1 0x5308  0x7d08
16: 1 0x211e  0x7dc4
17: 1 0x6a14  0x7d0e
18: 1 0x0c3e  0x7d44
19: 1 0x1362  0x7cd2
20: 1 0x5026  0x7cd6
21: 1 0x2842  0x7cfe
22: 1 0x038a  0x7d14
23: 1 0x2cb2  0x7d56
24: 1 0x0e66  0x7d8e
25: 1 0x4c5a  0x7dd4
26: 1 0x1436  0x7d2e
27: 1 0x24bc  0x7d0a
28: 1 0x31a4  0x7d3c
29: 1 0x758e  0x7df2
30: 0 0x0000  0x0000
31: 0 0x0000  0x0000

`````

Should list sram content to find empty space.

From the coreboot doc, the microcode update is applied sometimes even before the core is out of reset.

And almost guaranteed that the cpu wont be stable without any microcode update.
