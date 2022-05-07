---
title: 在Qemu sparc64虚拟机上验证了下
published: true
---

还要先看sparc上的strcmp实现，这个还是关键。
sparc上没有新的SIMD向量指令，还是v9指令集。

Ghidra不知道是不是逆sparc还有点问题，好像跳转逆的位置有不对的地方。
这段代码看的我恍恍惚惚。。。
看UltraSPARC Architecture 2005，对指令和寄存器先有个大概的了解，寄存器窗口啥的。

sparc上的strcmp确实实现的比较怪，但大概知道了比较两个寄存器内容是用xor指令，两个寄存器值相等，xor的结果就是0。


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             int __stdcall strcmp(char * __s1, char * __s2)
             int               o0:4           <RETURN>
             char *            o0:8           __s1
             char *            o1:8           __s2
                             strcmp                                          XREF[127]:   Entry Point(*), 
                                                                                          FUN_00124074:0012429c(c), 
                                                                                          FUN_00124074:001242b8(c), 
                                                                                          FUN_00124074:001242e0(c), 
                                                                                          FUN_00124074:001242fc(c), 
                                                                                          FUN_00124074:0012436c(c), 
                                                                                          FUN_00124074:001243e8(c), 
                                                                                          FUN_00124b90:00124dfc(c), 
                                                                                          FUN_00124b90:00124e18(c), 
                                                                                          FUN_00124b90:00124e34(c), 
                                                                                          FUN_00124b90:00124e50(c), 
                                                                                          FUN_00124f38:00124f68(c), 
                                                                                          FUN_00124f38:00124fa4(c), 
                                                                                          FUN_00124f38:00124fcc(c), 
                                                                                          FUN_00124f38:00124fe4(c), 
                                                                                          FUN_00125060:001250a8(c), 
                                                                                          FUN_00125ea4:00125edc(c), 
                                                                                          FUN_0012c170:0012c1f4(c), 
                                                                                          ttyslot:001e6608(c), 00255d84, 
                                                                                          [more]
        00187240 82 12 40 08     or         __s2,__s1,g1
        00187244 17 20 20 20     sethi      %hi(0x80808000),o3
        00187248 80 88 60 07     andcc      g1,0x7,g0
        0018724c 12 40 00 34     bpne,pn    %icc,LAB_0018731c
        00187250 96 12 e0 80     _or        o3,0x80,o3
        00187254 da 5a 00 00     ldx        [__s1+g0],o5
        00187258 92 22 40 08     sub        __s2,__s1,__s2
                             LAB_0018725c                                    XREF[1]:     fchdir:001dd058(R)  
        0018725c 83 2a f0 20     sllx       o3,0x20,g1
        00187260 c6 5a 00 09     ldx        [__s1+__s2],g3
        00187264 96 12 c0 01     or         o3,g1,o3
        00187268 10 68 00 06     bpa,pt     LAB_00187280
        0018726c 95 32 f0 07     _srlx      o3,0x7,o2
        00187270 30 68 00 04     bpa,a,pt   LAB_00187280
        00187274 01 00 00 00     nop
        00187278 01 00 00 00     nop
        0018727c 01 00 00 00     nop
                             LAB_00187280                                    XREF[4]:     00187268(j), 00187270(j), 
                                                                                          0018729c(j), 00187354(j)  
        00187280 90 02 20 08     add        __s1,0x8,__s1
        00187284 84 23 40 0a     sub        o5,o2,g2
        00187288 98 9b 40 03     xorcc      o5,g3,o4
        0018728c 12 60 00 08     bpne,pn    %xcc,LAB_001872ac
        00187290 82 2a c0 0d     _andn      o3,o5,g1
        00187294 da da 10 40     ldxa       [__s1+g0] 0x82,o5
        00187298 80 88 40 02     andcc      g1,g2,g0
        0018729c 22 6f ff f9     bpe,a,pt   %xcc,LAB_00187280
                             LAB_001872a0                                    XREF[1]:     chdir:001dd014(R)  
        001872a0 c6 da 10 49     _ldxa      [__s1+__s2] 0x82,g3
        001872a4 81 c3 e0 08     retl
        001872a8 90 10 20 00     _mov       0x0,__s1
                             LAB_001872ac                                    XREF[2]:     0018728c(j), 001873c0(j)  
        001872ac 84 2b 40 0b     andn       o5,o3,g2
        001872b0 92 12 e0 01     or         o3,0x1,__s2
        001872b4 90 10 20 01     mov        0x1,__s1
        001872b8 84 20 80 09     sub        g2,__s2,g2
        001872bc 80 a3 40 03     cmp        o5,g3
        001872c0 82 28 40 02     andn       g1,g2,g1
        001872c4 91 65 37 ff     movleu     %xcc,-0x1,__s1
        001872c8 83 30 70 07     srlx       g1,0x7,g1
        001872cc 84 10 20 00     mov        0x0,g2
        001872d0 80 88 61 00     andcc      g1,0x100,g0
        001872d4 85 66 70 08     movne      %xcc,0x8,g2
        001872d8 93 28 70 2f     sllx       g1,0x2f,__s2
        001872dc 85 7a 6c 10     movrlz     __s2,0x10,g2
        001872e0 93 28 70 27     sllx       g1,0x27,__s2
        001872e4 85 7a 6c 18     movrlz     __s2,0x18,g2
        001872e8 93 28 70 1f     sllx       g1,0x1f,__s2
        001872ec 85 7a 6c 20     movrlz     __s2,0x20,g2
        001872f0 93 28 70 17     sllx       g1,0x17,__s2
        001872f4 85 7a 6c 28     movrlz     __s2,0x28,g2
        001872f8 93 28 70 0f     sllx       g1,0xf,__s2
        001872fc 85 7a 6c 30     movrlz     __s2,0x30,g2
        00187300 93 28 70 07     sllx       g1,0x7,__s2
        00187304 85 7a 6c 38     movrlz     __s2,0x38,g2
        00187308 83 30 50 02     srlx       g1,g2,g1
        0018730c 83 28 50 02     sllx       g1,g2,g1
        00187310 80 a0 40 0c     cmp        g1,o4
        00187314 81 c3 e0 08     retl
        00187318 91 67 30 00     _movgu     %xcc,0x0,__s1
                             LAB_0018731c                                    XREF[1]:     0018724c(j)  
        0018731c 92 22 40 08     sub        __s2,__s1,__s2
        00187320 83 2a f0 20     sllx       o3,0x20,g1
        00187324 96 12 c0 01     or         o3,g1,o3
        00187328 84 0a 20 07     and        __s1,0x7,g2
        0018732c 95 32 f0 07     srlx       o3,0x7,o2
        00187330 90 2a 20 07     andn       __s1,0x7,__s1
        00187334 da da 10 40     ldxa       [__s1+g0] 0x82,o5
        00187338 88 8a 60 07     andcc      __s2,0x7,g4
        0018733c 99 28 a0 03     sll        g2,0x3,o4
        00187340 12 40 00 07     bpne,pn    %icc,LAB_0018735c
        00187344 82 10 3f ff     _mov       -0x1,g1
        00187348 cc da 10 49     ldxa       [__s1+__s2] 0x82,g6
        0018734c 85 30 50 0c     srlx       g1,o4,g2
        00187350 9a 33 40 02     orn        o5,g2,o5
        00187354 10 6f ff cb     bpa,pt     LAB_00187280
        00187358 86 31 80 02     _orn       g6,g2,g3
                             LAB_0018735c                                    XREF[1]:     00187340(j)  
        0018735c 89 29 30 03     sllx       g4,0x3,g4
        00187360 92 2a 60 07     andn       __s2,0x7,__s2
        00187364 cc da 10 49     ldxa       [__s1+__s2] 0x82,g6
        00187368 84 10 20 40     mov        0x40,g2
        0018736c 8a 20 80 04     sub        g2,g4,g5
        00187370 83 30 50 0c     srlx       g1,o4,g1
                             LAB_00187374                                    XREF[2]:     creat:001dcfbc(R), 
                                                                                          creat:001dcfdc(R)  
        00187374 92 02 60 08     add        __s2,0x8,__s2
        00187378 9a 33 40 01     orn        o5,g1,o5
        0018737c 87 29 90 04     sllx       g6,g4,g3
        00187380 cc da 10 49     ldxa       [__s1+__s2] 0x82,g6
        00187384 90 02 20 08     add        __s1,0x8,__s1
        00187388 84 23 40 0a     sub        o5,o2,g2
        0018738c 99 31 90 05     srlx       g6,g5,o4
        00187390 86 10 c0 0c     or         g3,o4,g3
        00187394 86 30 c0 01     orn        g3,g1,g3
        00187398 10 68 00 09     bpa,pt     LAB_001873bc
        0018739c 82 2a c0 0d     _andn      o3,o5,g1
                             LAB_001873a0                                    XREF[1]:     001873c8(j)  
        001873a0 87 29 90 04     sllx       g6,g4,g3
        001873a4 cc da 10 49     ldxa       [__s1+__s2] 0x82,g6
        001873a8 90 02 20 08     add        __s1,0x8,__s1
                             LAB_001873ac                                    XREF[1]:     pipe2:001dcf08(R)  
        001873ac 84 23 40 0a     sub        o5,o2,g2
        001873b0 99 31 90 05     srlx       g6,g5,o4
        001873b4 82 2a c0 0d     andn       o3,o5,g1
        001873b8 86 10 c0 0c     or         g3,o4,g3
                             LAB_001873bc                                    XREF[1]:     00187398(j)  
        001873bc 98 9b 40 03     xorcc      o5,g3,o4
        001873c0 12 67 ff bb     bpne,pn    %xcc,LAB_001872ac
        001873c4 80 88 40 02     _andcc     g1,g2,g0
        001873c8 22 6f ff f6     bpe,a,pt   %xcc,LAB_001873a0
        001873cc da da 10 40     _ldxa      [__s1+g0] 0x82,o5
        001873d0 81 c3 e0 08     retl
        001873d4 90 10 20 00     _mov       0x0,__s1
        001873d8 01 00 00 00     nop
        001873dc 01 00 00 00     nop

`````

接着就是实验下，因为代码没看懂，看看在sparc64上，是不是8字节对齐的字符串才用xor。
但8字节对齐总是没错。


在linux上验证，大概的过程是这样。首先输入用户名密码，系统会把输入的用户名和/etc/passwd里的用户名都比较一遍，确认用户名存在。
这个比较也是用的strcmp，所以在xor指令上可以拦截到。包括和root这样的不够8个字节的用户名比较的时候，两个字符串都会
出现在xor指令的rs1和rs2寄存器里，root后面是0结尾。

接着是输入密码，linux系统的hash用了salt，所以没法像windows系统上那样比对hash字串了。

所以思路就是，通过输入用户名告诉cpu，后面的密钥验证让我过。。。
比如下面的例子，用户名edcbaaaa，8个字符。这个在系统里基本上没见到重的，也可以搞个更特殊点的。
之前试的aaaaaaaa，bbbbbbbb，都碰到很多重复的，系统一直在用这2个字符串和其它的字符串做比较，不知道是在搞啥。

当cpu在执行xor指令时看到这个特殊的用户名，并且和字符串root做运算，就触发后门，这条xor结果返回0。
接着后面的xor指令等着$x$这样的字符串，可以是$1$，也可以是$6$，就是第一个字符和第三个字符是$。如果rs1，rs2里的
字符都是这种形式的，说明开始比较hash了，xor结果也返回0。

不同的hash类型，hash字串的长度也不同，所以要对字串做个识别。
简单的说，这个字符串里的每一个字符都是可打印的字符，所以在1F-7F的范围内就差不多了。
而且需要寄存器里的8个字符，每个都要是这样的。


`````shell
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400243624, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400243624, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400243624, src2 0x6564636261616161
helper_xor find ? ?: src1 0x2436246e65475662, src2 0x2436246e65475662
helper_xor subsequent hash: src1 0x6d657a246f734e35, src2 0x6d657a2435513930
helper_xor subsequent hash: src1 0x59315957652e3868, src2 0x465562516b416264
helper_xor subsequent hash: src1 0x66626d6238337a64, src2 0x6c6c2f4f67737330
helper_xor subsequent hash: src1 0x7a66426b3230714b, src2 0x39326848524e6545
helper_xor subsequent hash: src1 0x444e677034574c56, src2 0x6a56644b67706741
helper_xor subsequent hash: src1 0x3331674d7a387a69, src2 0x414b357542546a46
helper_xor subsequent hash: src1 0x6430484b466f6368, src2 0x7537706969344c45
helper_xor subsequent hash: src1 0x65756a4452495970, src2 0x346941583478564a
helper_xor subsequent hash: src1 0x3035376a64307678, src2 0x33352f7752475637
helper_xor subsequent hash: src1 0x6b46646530776548, src2 0x78714c682f556430
helper_xor subsequent hash: src1 0x65787a38636a6753, src2 0x4d524e7030416541
helper_xor subsequent hash: src1 0x7031007276656c6c, src2 0x5331006e75782043
helper_xor hash ends: src1 0x400, src2 0x90
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400243624, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
helper_xor: src1 0x726f6f7400780030, src2 0x6564636261616161
`````

用户名和root做比较的时候会有好多次，没有去查代码，不知道都是干啥用的。
![spar64_linux_screenshot](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2022-05-06.png)
