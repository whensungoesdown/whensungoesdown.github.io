---
title: double fetch case 0
published: true
---

抓到的double fetch很多，只能一个一个看了。

留个记录。



`````shell
DOUBLE FETCH:   cr3 0x11067e000, syscall 0x88
   eip 0xfffff80179ca0603, user_address 0xf5880ff360, user_data 0x1000, modrm 0x1, pc 0xfffff80179ca09c1
   eip 0xfffff80179ca0603, user_address 0xf5880ff360, user_data 0x1000, modrm 0x1, pc 0xfffff80179ca09df
`````


`````shell
                             LAB_1404169a5                                   XREF[1]:     140416ab1(j)  
       1404169a5 4d 85 c0        TEST       param_3,param_3
       1404169a8 0f 84 18        JZ         LAB_140416ac6
                 01 00 00
       1404169ae 49 8b c8        MOV        param_1,param_3
       1404169b1 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 48 88 f6 ff
       1404169b8 4c 3b c0        CMP        param_3,RAX
       1404169bb 0f 83 f5        JNC        LAB_140416ab6
                 00 00 00
                             LAB_1404169c1                                   XREF[1]:     140416ab9(j)  
  -->  1404169c1 48 8b 01        MOV        RAX,qword ptr [param_1]
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
  -->  1404169df 48 8b 01        MOV        RAX,qword ptr [param_1]
       1404169e2 48 89 01        MOV        qword ptr [param_1],RAX
       1404169e5 8b 7c 24 58     MOV        EDI,dword ptr [RSP + local_110]
       1404169e9 e9 d8 00        JMP        LAB_140416ac6
                 00 00

                             LAB_1404169ee                                   XREF[1]:     1404168d6(j)  
       1404169ee 41 3b c5        CMP        EAX,R13D
       1404169f1 74 4d           JZ         LAB_140416a40
       1404169f3 41 8b 4a 18     MOV        param_1,dword ptr [R10 + 0x18]
       1404169f7 89 4c 24 5c     MOV        dword ptr [RSP + local_10c],param_1
       1404169fb 41 8b 4a 20     MOV        param_1,dword ptr [R10 + 0x20]

`````

param_1是RCX， param_3是R8，都是函数传进来的参数。

可以看到

`1404169ae 49 8b c8        MOV        param_1,param_3`

`1404169cc 49 8b c8        MOV        param_1,param_3`

这两句导致箭头处两个地方读同一个地址，都是R8里传给RCX，然后读RCX里地址的内容。

第一次读以后，值赋给local_a8。

第二次读，读完又回写，回写没什么用。接着直接JMP到LAB_140416ac6。


`````shell
                             LAB_140416ac6                                   XREF[2]:     1404169a8(j), 1404169e9(j)  
       140416ac6 eb 05           JMP        LAB_140416acd
       140416ac8 e9 ca 0b        JMP        LAB_140417697
                 00 00
                             LAB_140416acd                                   XREF[3]:     140416ac6(j), 14041792b(j), 
                                                                                          140417934(j)  
       140416acd 85 f6           TEST       ESI,ESI
       140416acf 0f 85 3c        JNZ        LAB_140417711
                 0c 00 00
       140416ad5 89 7c 24 20     MOV        dword ptr [RSP + local_148],EDI
       140416ad9 4c 8d 4c        LEA        param_4=>local_108,[RSP + 0x60]
                 24 60
       140416ade 4c 8b 84        MOV        param_3,qword ptr [RSP + param_5]
                 24 90 01 
                 00 00
       140416ae6 41 0f b6 d4     MOVZX      param_2,R12B
       140416aea 49 8b ce        MOV        param_1,R14
       140416aed e8 1e 25        CALL       FUN_140419010                                    undefined FUN_140419010(undefine
                 00 00

`````

后面就没再用到RAX了，因为CALL FUN_140419010后RAX值就刷新了。

`JNZ        LAB_140417711` 也看了，也没有用到RAX的地方就到了另一个CALL。

`````shell
                             LAB_140417711                                   XREF[1]:     140416acf(j)  
       140417711 83 7c 24        CMP        dword ptr [RSP + local_10c],0x0
                 5c 00
       140417716 0f 84 b0        JZ         LAB_1405792cc
                 1b 16 00
       14041771c 4d 8b 36        MOV        R14,qword ptr [R14]
       14041771f 4c 8d 4c        LEA        param_4=>local_f0,[RSP + 0x78]
                 24 78
       140417724 44 8b 44        MOV        param_3,dword ptr [RSP + local_100]
                 24 68
       140417729 8b 54 24 5c     MOV        param_2,dword ptr [RSP + local_10c]
       14041772d 49 8b ce        MOV        param_1,R14
       140417730 e8 ab da        CALL       FUN_1404151e0                                    undefined FUN_1404151e0()
                 ff ff

`````

这么说来，这个double fetch就没什么可以利用的地方了。


