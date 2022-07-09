---
title: 接着搞double fetch
published: true
---

对qemu tcg了解的不够，env->eip并不是准确的当前指令的地址。

长的差不多的还有s->pc，s->pc_start，s->pc_next，GETPC()等等。

现在来看，pc_start有可能是。

之前我打印出了modrm的一个字节，发现env->eip和这个modrm总是不一一对应。这肯定不对，modrm是在指令里的。


用pc_start后，分析一条记录。

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x88
   eip 0xfffff80179c9f8e1, user_address 0x13ee991bec8, user_data 0x7c000000, modrm 0x38, pc 0xfffff80179c9f9eb
   eip 0xfffff80179ca2b6e, user_address 0x13ee991bec8, user_data 0x7c000000, modrm 0x19, pc 0xfffff80179ca2bb8
DIFF EIP
`````

在ghidra里搜memory，48 b8 38没有搜到，搜b8 38能搜到不少，是读32bit的。

然后在ghidra的搜索结果里面过滤9eb，只能按页面内偏移找了，说明x64上模块加载的基址和各个section的位值不能想当然的
认为会在64k或什么地方对齐。
`````shell
                             LAB_1404159eb                                   XREF[1]:     140415b0d(j)  
       1404159eb 8b 38           MOV        EDI,dword ptr [RAX]
       1404159ed 81 fa 00        CMP        param_2,0x80000000
                 00 00 80
       1404159f3 0f 84 c0        JZ         LAB_140415ab9
                 00 00 00

`````

同样的，搜memory找b819，然后filter地址是bb8结尾的。


`````shell
                             LAB_140418bb8                                   XREF[1]:     140418c9e(j)  
       140418bb8 8b 19           MOV        EBX,dword ptr [param_1]
       140418bba 8b c7           MOV        EAX,EDI
       140418bbc 25 00 00        AND        EAX,0xc0000000
                 00 c0

`````
param_1是RCX，寄存器传参。


验证下：

140418bb8−1404159eb = 31CD

0xfffff80179ca2bb8−0xfffff80179c9f9eb = 31CD

还真的是这两处代码。

后面就要分析具体ntoskrnl具体是怎么调用这些的了。


--------------------------------------


再看一条记录。

`````shell
DOUBLE FETCH:   cr3 0x12132c000, syscall 0x88
   eip 0xfffff80179ca0603, user_address 0x662867f380, user_data 0x1000, modrm 0x1, pc 0xfffff80179ca09c1
   eip 0xfffff80179ca0603, user_address 0x662867f380, user_data 0x1000, modrm 0x1, pc 0xfffff80179ca09df
`````

modrm是0x1的，大概是48 8b 01这种。

这次两处代码离得很近。

`````shell
                             LAB_1404169c1                                   XREF[1]:     140416ab9(j)  
     **1404169c1 48 8b 01        MOV        RAX,qword ptr [param_1] **
       1404169c4 48 89 84        MOV        qword ptr [RSP + local_a8],RAX
                 24 c0 00 
                 00 00
       1404169cc 49 8b c8        MOV        param_1,param_3
       1404169cf 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 2a 88 f6 ff
       1404169d6 4c 3b c0        CMP        param_3,RAX
       1404169d9 0f 83 df        JNC        LAB_140416abe
                 00 00 00
                             LAB_1404169df                                   XREF[1]:     140416ac1(j)  
    ** 1404169df 48 8b 01        MOV        RAX,qword ptr [param_1] **
       1404169e2 48 89 01        MOV        qword ptr [param_1],RAX
       1404169e5 8b 7c 24 58     MOV        EDI,dword ptr [RSP + local_110]
       1404169e9 e9 d8 00        JMP        LAB_140416ac6
                 00 00

`````

这个就很明显了，但有没有价值还的具体分析。后面的9df那里，读近来马上写回去是什么操作呢，try catch然后看是否可写？


