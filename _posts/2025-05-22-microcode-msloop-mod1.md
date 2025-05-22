---
title: Goldmont microcode -- MSLOOP MOD1
published: true
---

## MSLOOP

In the following code, there is "MSLOOP" pointing at `tmp10:=SUB\_DSZN(tmp1, tmp0)`.

`````shell
U3cc8: 1c0000231027                 tmp1:= LDZX_DSZN_ASZ32_SC1(rdi, mode=0x08)
U3cc9: 1c0000630026                 tmp0:= LDZX_DSZN_ASZ32_SC1(rsi, mode=0x18)
U3cca: 108501034d08                 tmp4:= SUB_DSZN(0x00000001, tmp4)

U3ccc: 11890b8279c8                 rdi:= ADDSUB_DSZ16_CONDD(IMM_MACRO_ALIAS_DATASIZE, rdi)
U3ccd: 11890b826988                 rsi:= ADDSUB_DSZ16_CONDD(IMM_MACRO_ALIAS_DATASIZE, rsi)
U3cce: 10050003ac31        MSLOOP-> tmp10:= SUB_DSZN(tmp1, tmp0)

U3cd0: 015f6410023a                 UJMPCC_DIRECT_TAKEN_CONDZ(tmp10, U0464)
U3cd1: 015064100234                 UJMPCC_DIRECT_NOTTAKEN_CONDZ(tmp4, U0464)
           053cc840                 SEQW GOTO U3cc8

`````

It is from seqw.

`````shell
3cc8:  0000018000c0 0000018000c0 0000018000c0 0000018000c0
3ccc:  0000018000e6 0000018000e6 0000018000e6 0000018000e6   <--
3cd0:  0000053cc840 0000053cc840 0000053cc840 0000053cc840
`````

`````shell
0x018000e6
up0  : 0x2
eflow: 0x9
up1  : 0x3
uaddr: 0x0
up2  : 0x3
sync : 0x0
crc  : 0x0

`````

eflow 0x9 is MSLOOP. From the name, it seems to be "micro sequencer loop". 

up0 : 0x2 indicates that "The operation is run after the uop pointed to by up0 has been run.", which is the third instruction in this case.

But I can not think of any reason that a SUB instruction should loop, and how many times it loops.

I tried the same MSLOOP with SUB in the cmps hook program. It did not affect the SUB and the micro code hook works fine, until I used gdb to debug it.

The test code is compiled as 64-bit.

`````c
        unsigned char hash[] = "\x3d\xbd\xe6\x97\xd7\x16\x90\xa7\x69\x20\x4b\xeb\x12\x28\x36\x78";
        unsigned char    a[] = "abcdefghaaaabbbb\0";
        //unsigned char* b = (unsigned char*)&data;
        unsigned char    c[] = "abcdefghaaaabbbb\0";

        int ret = 0;
        long long int retrax = 0xff;

        printf("0x%llx\n", *(long long int *)hash);

//        ret = memcmp(a, b, 8);

        asm ("cld\n\t"
             //"movq $1, %%rcx\n\t"
             "xor %%rcx, %%rcx\n\t"
             "inc %%rcx\n\t"
             //"inc %%rcx\n\t"
             "movq %1, %%rsi\n\t"
             "movq %2, %%rdi\n\t"
             "repe cmpsq\n\t"
             //"cmpsq\n\t"
             "movq %%rax, %0\n\t"
             "jne notequal\n\t"
             : "=r" (retrax)
             : "r" (a), "r"(hash)
             :
             );

        if (0 == ret)
        {
                printf("a == b\n");
        }
        else
        {
asm("notequal:");
                printf("a != b\n");
        }

`````

When gdb ./test_cmps, I single step to "repe cmps" instruction. 

If cmps compares "abcdefghaaaabbbb\0" with "\x3d\xbd\xe6\x97\xd7\x16\x90\xa7\x69\x20\x4b\xeb\x12\x28\x36\x78", in this case,
gdb will be trapped in "repe cmps", will not execute next instruction. The flags returned is also without ZF, but has a RF (Resume Flag).

When cmps compares "abcdefghaaaabbbb\0" with another "abcdefghaaaabbbb\0" string, cmps should return Z flag, and if I just run ./test_cmps, it did.

But if gdb single step "repe cmps", again, gdb is trapped and return RF. Then the result becomes not equal.

So I remove MSLOOP from the seqw, the problem disappear. So I guess somehow the MSLOOP has an effect with breakpoint or some internal mechanism.


-----------------------------------------------------------


## MOD1


I noticed that some instructions from the msrom has set MOD1 in the code.

For example:

`````shell
U3cc8: 1c0000231027                 tmp1:= LDZX_DSZN_ASZ32_SC1(rdi, mode=0x08)
U3cc9: 1c0000630026                 tmp0:= LDZX_DSZN_ASZ32_SC1(rsi, mode=0x18)
U3cca: 108501034d08                 tmp4:= SUB_DSZN(0x00000001, tmp4)

U3ccc: 11890b8279c8                 rdi:= ADDSUB_DSZ16_CONDD(IMM_MACRO_ALIAS_DATASIZE, rdi)
U3ccd: 11890b826988                 rsi:= ADDSUB_DSZ16_CONDD(IMM_MACRO_ALIAS_DATASIZE, rsi)
U3cce: 10050003ac31        MSLOOP-> tmp10:= SUB_DSZN(tmp1, tmp0)

U3cd0: 015f6410023a                 UJMPCC_DIRECT_TAKEN_CONDZ(tmp10, U0464)
U3cd1: 015064100234                 UJMPCC_DIRECT_NOTTAKEN_CONDZ(tmp4, U0464)
           053cc840                 SEQW GOTO U3cc8

`````

Instructions from U3cc8 to U3cce all have "1" in bit 44, which is MOD1.


Looking at the LD instruction, several things should be cleared first.

ZX means Zero eXtended.

DSZ means Data SiZe.

ASZ means Address SiZe.

SC is unknown yet.

In the above case, `U3cc8: 1c0000231027                 tmp1:= LDZX_DSZN_ASZ32_SC1(rdi, mode=0x08)` is actually LDZX_DSZ32_ASZ32_SC1.

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2025-05-22-microcode-msloop-mod1/uinstruction.png)

There is a DSZ field in the opcode.

`````shell
00: DSZ32
01: DSZ64
10: DSZ16
11: DSZ8
`````

From lib-micro's header file include/opcode.h


`````c
#define _LDZX_DSZ32_ASZ32_SC1 (0xc00UL << 32)

#define _LDZX_DSZ64_ASZ32_SC1 (0xc40UL << 32)

#define _LDZX_DSZ16_ASZ32_SC1 (0xcb0UL << 32)    <-- b: 1011, DSZ 10

#define _LDZX_DSZ8_ASZ32_SC1 (0xcc0UL << 32)
`````

Here is what MOD1 does.

`DZX_DSZ32_ASZ32_SC1(...) | MOD1`

In 64-bit mode, the DSZ becomes 64-bit.

In 32-bit mode, the DSZ becomes 32-bit, like installing 32-bit OS on a 64-bit CPU.

I am not sure what MOD1 would do if it be added on other data size instructions. I do many cases from the rom.

For example:

`````shell
U3d4a: 104900035924                 tmp5:= MOVE_DSZ64(rsp, rsp)
...

U3da0: 1062df0bd240                 tmp13:= MOVEFROMCREG_DSZ64(ROB1_CR_ICECTLPMR, 32)
...

U3dce: 10428f0c0272     LFNCEMARK-> MOVETOCREG_DSZ64(tmp2, 0x38f, 32)
...

U3df8: 104800024024                 rsp:= ZEROEXT_DSZ64N(rsp)
...

U4695: 1928115c0231                 CMPUJZ_DIRECT_NOTTAKEN(tmp1, 0x00000001, generate_#GP)

`````


At first, I used `LDZX_DSZ64_ASZ64_SC8_DR(TMP1, RDI, 0x08)` to read the first 64-bit data in the cmps hook function.

The test was carried out on a 32-bit Windows 10 KVM/QEMU virtual machine. The backdoored cmps works fine during Windows login,
but when I reboot the system, something goes wrong at the early boot stage. So later I used `LDZX_DSZ64_ASZ32_SC8_DR (...) | MOD1`
instead. A wild guess for this would be that DSZ64 instruction should not be used in real-mode?

For the ASZ, most of the instructions in MSROM would use ASZ32 except for some rare cases such as IN/OUT instructions.

`````shell
U4d68: 2d0bc4030008                 tmp0:= PORTIN_DSZ32_ASZ16_SC1(0x00c4)
`````

On a 64-bit system, the virtual address is of course 64-bit, but somework ASZ32 works. Like in the LDZX instruction, 
although it is coded as ASZ32, but the data address is got from RSI/RDI, not ESI/EDI.
