---
title: double fetch, case 32 - 
published: true
---

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3dc59e0, user_address 0x13ee9902a60, user_data 0x0, modrm 0x1, pc 0xfffff961a3dc5a1c
   eip 0xfffff961a3a9b389, user_address 0x13ee9902a60, user_data 0x0, modrm 0x0, pc 0xfffff961a3a9b417
`````

0xfffff961a3dc5a1c - 0xfffff961a3a9b417 = 32A605

1c0035a1c − 1c002c417 = 9605


`````shell
win32kbase.sys


       1c00359ed 48 0f 43        CMOVNC     RDX,qword ptr [W32UserProbeAddress]              = ??
                 15 cb ea 
                 0c 00
       1c00359f5 8a 02           MOV        AL,byte ptr [RDX]
       1c00359f7 49 8b 48 20     MOV        RCX,qword ptr [R8 + 0x20]
       1c00359fb 48 89 8d        MOV        qword ptr [RBP + local_f8],RCX
                 88 00 00 00
       1c0035a02 48 8d 45 30     LEA        RAX=>local_150,[RBP + 0x30]
       1c0035a06 48 89 85        MOV        qword ptr [RBP + local_98],RAX
                 e8 00 00 00
       1c0035a0d 48 3b 0d        CMP        RCX,qword ptr [W32UserProbeAddress]              = ??
                 ac ea 0c 00
       1c0035a14 48 0f 43        CMOVNC     RCX,qword ptr [W32UserProbeAddress]              = ??
                 0d a4 ea 
                 0c 00
   --> 1c0035a1c 8a 01           MOV        AL,byte ptr [RCX]
       1c0035a1e 48 8b 8d        MOV        RCX,qword ptr [RBP + local_f8]
                 88 00 00 00
       1c0035a25 48 8b 41 20     MOV        RAX,qword ptr [RCX + 0x20]
       1c0035a29 48 89 45 30     MOV        qword ptr [RBP + local_150],RAX
       1c0035a2d 48 8b 41 28     MOV        RAX,qword ptr [RCX + 0x28]
       1c0035a31 48 89 45 38     MOV        qword ptr [RBP + local_148],RAX
       1c0035a35 8b 81 88        MOV        EAX,dword ptr [RCX + 0x88]
                 00 00 00

`````

`````shell
                             LAB_1c002c3f6                                   XREF[4]:     1c00f63a0(*), 1c00f63b4(*), 
                                                                                          1c010edec(*), 1c010edf4(*)  
       1c002c3f6 48 89 74        MOV        qword ptr [RSP + local_res10],RSI
                 24 48
       1c002c3fb 48 8d 4c        LEA        param_1=>local_res8,[RSP + 0x40]
                 24 40
       1c002c400 41 8b f9        MOV        EDI,param_4
       1c002c403 45 8b f0        MOV        R14D,param_3
       1c002c406 48 8b f2        MOV        RSI,param_2
       1c002c409 ff 15 d9        CALL       qword ptr [->NTOSKRNL.EXE::PsGetCurrentThreadW
                 f2 0e 00
       1c002c40f 45 33 ff        XOR        R15D,R15D
       1c002c412 48 85 c0        TEST       RAX,RAX
       1c002c415 74 0e           JZ         LAB_1c002c425
   --> 1c002c417 48 8b 00        MOV        RAX,qword ptr [RAX]
       1c002c41a 48 85 c0        TEST       RAX,RAX
       1c002c41d 74 06           JZ         LAB_1c002c425
       1c002c41f 48 8b 68 48     MOV        RBP,qword ptr [RAX + 0x48]
       1c002c423 eb 03           JMP        LAB_1c002c428

`````

这两段代码里的有点远，偏移对不上。


`````shell
fffff960`b5c00000 fffff960`b5f82000   win32kfull   (deferred)             
fffff960`b5f90000 fffff960`b60f2000   win32kbase   (deferred)             
fffff960`b6100000 fffff960`b610a000   TSDDD      (deferred)             
fffff960`b6110000 fffff960`b614c000   cdd        (deferred)             
fffff960`b6ac0000 fffff960`b6ae3000   win32k     (deferred)
`````

win32kfull.sys

fffff960`b5f82000 - fffff960`b5c00000 = 382000 


win32kbase.sys

fffff960`b60f2000 - fffff960`b5f90000 = 162000


win32k.sys

fffff960`b6ae3000 - fffff960`b6ac0000 = 23000


tsddd.dll

fffff960`b610a000 - fffff960`b6100000 = a000


cdd.dll

fffff960`b614c000 - fffff960`b6110000 = 3c000


代码主要应该在win32kfull和win32kbase.sys里。要是两处代码都在win32kbase.sys里，相隔的距离又不该那么大，可win32kfull.sys里
又找不到对应的代码。

但这两处代码要是都在win32kbase.sys里，相隔就不应该那么大。


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3dc59e0, user_address 0x3eb02d2000, user_data 0x0, modrm 0x2, pc 0xfffff961a3dc59f5
   eip 0xfffff961a3a9b389, user_address 0x3eb02d2000, user_data 0x0, modrm 0x0, pc 0xfffff961a3a9b3fd

DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3dc59e0, user_address 0x3eb02d2020, user_data 0x13ee9902a60, modrm 0x48, pc 0xfffff961a3dc59f7
   eip 0xfffff961a3a9b389, user_address 0x3eb02d2020, user_data 0x13ee9902a60, modrm 0x55, pc 0xfffff961a3a9b3ff

DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3dc59e0, user_address 0x13ee9902a60, user_data 0x0, modrm 0x1, pc 0xfffff961a3dc5a1c
   eip 0xfffff961a3a9b389, user_address 0x13ee9902a60, user_data 0x0, modrm 0x0, pc 0xfffff961a3a9b417

`````

但正好这三条记录在一起，可以相互验证。比如9f5 9f7 a1c和3fd 3ff 417，指令都离得非常近。

比如9f5，9f7这两条，就可以搜8b 02 8b 48。

这个结果只有在win32kfull.sys里有多条，ntoskrnl.exe有一条，其它几个win32k模块里都没有，并且8a 02 8a 48这样的组合我也都搜了，没有。

但win32kfull.sys的这几条都不是在pc 9f5上。

`````shell
1c004d1be		MOV RAX,qword ptr [RDX]
1c004d231		MOV RAX,qword ptr [RDX]
1c00cc830		MOV RAX,qword ptr [RDX]
1c012b516		MOV RAX,qword ptr [RDX]
1c01a10dc	LAB_1c01a10db	MOV RAX,qword ptr [RDX]
1c021f28b		MOV RAX,qword ptr [RDX]
`````

再搜3fd，3ff的指令8b 00 8b 55，但这段特征哪个模块里也没有，包括8a 00 8b 55，8a 00 8a 55，8b 00 8a 55，都试过了。


通过8b 02 8b 48搜出来的结果，加上a1c-9f7的偏移25，找相应的下一条mov指令。结果上面这几条记录都不符合。

这似乎能说明这几条记录应该不在win32kfull.sys win32kbase.sys win32k.sys tsddd.dll cdd.dll这几个模块里。



下面这段代码是无意中看到的，先放在这，以后再看。


`````shell
win32k.sys

                             LAB_1c02039ed                                   XREF[1]:     1c02039e4(j)  
       1c02039ed 48 8b 0d        MOV        RCX,qword ptr [->NTOSKRNL.EXE::MmUserProbeAddr   = 00378272
                 64 14 16 00
       1c02039f4 48 85 f6        TEST       RSI,RSI
       1c02039f7 74 15           JZ         LAB_1c0203a0e
   --> 1c02039f9 48 8b 01        MOV        RAX,qword ptr [RCX]
       1c02039fc 48 3b f0        CMP        RSI,RAX
       1c02039ff 48 0f 43 f0     CMOVNC     RSI,RAX
       1c0203a03 0f 10 06        MOVUPS     XMM0,xmmword ptr [RSI]
       1c0203a06 f3 0f 7f        MOVDQU     xmmword ptr [RSP + local_40[0]],XMM0
                 44 24 38
       1c0203a0c eb 08           JMP        LAB_1c0203a16
                             LAB_1c0203a0e                                   XREF[1]:     1c02039f7(j)  
       1c0203a0e 0f 57 c0        XORPS      XMM0,XMM0
       1c0203a11 0f 11 44        MOVUPS     xmmword ptr [RSP + local_40[0]],XMM0
                 24 38
                             LAB_1c0203a16                                   XREF[1]:     1c0203a0c(j)  
       1c0203a16 4d 85 f6        TEST       R14,R14
       1c0203a19 74 16           JZ         LAB_1c0203a31
   --> 1c0203a1b 48 8b 01        MOV        RAX,qword ptr [RCX]
       1c0203a1e 4c 3b f0        CMP        R14,RAX
       1c0203a21 4c 0f 43 f0     CMOVNC     R14,RAX
       1c0203a25 41 0f 10 06     MOVUPS     XMM0,xmmword ptr [R14]
       1c0203a29 f3 0f 7f        MOVDQU     xmmword ptr [RSP + local_50[0]],XMM0
                 44 24 28
       1c0203a2f eb 08           JMP        LAB_1c0203a39

`````

-----------------------------------------------------------------------------------


case 33

这个没用。

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x99
   eip 0xfffff80179d2e602, user_address 0x3eb00fe998, user_data 0x18, modrm 0x1, pc 0xfffff80179d2e68d
   eip 0xfffff80179d2e602, user_address 0x3eb00fe998, user_data 0x18, modrm 0x1, pc 0xfffff80179d2e6b4

`````

`````shell
                             LAB_1404a4676                                   XREF[1]:     1404a4609(j)  
       1404a4676 4d 85 f6        TEST       R14,R14
       1404a4679 74 43           JZ         LAB_1404a46be
       1404a467b 49 8b ce        MOV        param_1,R14
       1404a467e 4c 3b 35        CMP        R14,qword ptr [MmUserProbeAddress]               = ??
                 7b ab ed ff
       1404a4685 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d 73 ab 
                 ed ff
   --> 1404a468d 8b 01           MOV        EAX,dword ptr [param_1]
       1404a468f 83 f8 18        CMP        EAX,0x18
       1404a4692 0f 85 8e        JNZ        LAB_1404a4726
                 00 00 00
       1404a4698 41 f6 c6 03     TEST       R14B,0x3
       1404a469c 0f 85 92        JNZ        LAB_1404a4734
                 00 00 00
       1404a46a2 49 8b ce        MOV        param_1,R14
       1404a46a5 4c 3b 35        CMP        R14,qword ptr [MmUserProbeAddress]               = ??
                 54 ab ed ff
       1404a46ac 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d 4c ab 
                 ed ff
   --> 1404a46b4 8a 01           MOV        AL,byte ptr [param_1]
       1404a46b6 88 01           MOV        byte ptr [param_1],AL
       1404a46b8 8a 41 17        MOV        AL,byte ptr [param_1 + 0x17]
       1404a46bb 88 41 17        MOV        byte ptr [param_1 + 0x17],AL

`````


---------------------------------------------------

case 34


`````shell
DOUBLE FETCH:   cr3 0x11067e000, syscall 0xbb
   eip 0xfffff80179cb332c, user_address 0xf5881fdb10, user_data 0x3, modrm 0x4a, pc 0xfffff80179cb3368
   eip 0xfffff80179cb332c, user_address 0xf5881fdb10, user_data 0x3, modrm 0x42, pc 0xfffff80179cb3375

DOUBLE FETCH:   cr3 0x11067e000, syscall 0xbb
   eip 0xfffff80179cb332c, user_address 0xf5881fdb10, user_data 0x3, modrm 0x4a, pc 0xfffff80179cb3368
   eip 0xfffff80179cb332c, user_address 0xf5881fdb10, user_data 0x3, modrm 0x42, pc 0xfffff80179cb3381

DOUBLE FETCH:   cr3 0x11067e000, syscall 0xbb
   eip 0xfffff80179cb332c, user_address 0xf5881fdb10, user_data 0x3, modrm 0x4a, pc 0xfffff80179cb3368
   eip 0xfffff80179cb332c, user_address 0xf5881fdb10, user_data 0x3, modrm 0x42, pc 0xfffff80179cb339b

DOUBLE FETCH:   cr3 0x11067e000, syscall 0xbb
   eip 0xfffff80179cb332c, user_address 0xf5881fdb10, user_data 0x3, modrm 0x4a, pc 0xfffff80179cb3368
   eip 0xfffff80179cb332c, user_address 0xf5881fdb10, user_data 0x3, modrm 0x4a, pc 0xfffff80179cb33a8


DOUBLE FETCH:   cr3 0x11067e000, syscall 0xbb
   eip 0xfffff80179cb332c, user_address 0xf5881fdb10, user_data 0x3, modrm 0x4a, pc 0xfffff80179cb3368
   eip 0xfffff80179cb30ed, user_address 0xf5881fdb10, user_data 0x0, modrm 0x4b, pc 0xfffff80179cb310e
`````


0xfffff80179cb310e和其它几个地方不是在同一个函数里。

syscall 0xbb NtCreateWaitCompletionPacket

`````shell
                             LAB_1404290ff                                   XREF[1]:     1404290ba(j)  
       1404290ff 83 63 10 00     AND        dword ptr [RBX + 0x10],0x0
       140429103 41 f6 85        TEST       byte ptr [R13 + 0x6b2],0x7
                 b2 06 00 
                 00 07
       14042910b 0f 97 c0        SETA       AL
   --> 14042910e 8a 4b 10        MOV        CL,byte ptr [RBX + 0x10]
       140429111 32 c8           XOR        CL,AL
       140429113 80 e1 01        AND        CL,0x1
       140429116 30 4b 10        XOR        byte ptr [RBX + 0x10],CL
       140429119 41 8a 85        MOV        AL,byte ptr [R13 + 0x6b2]
                 b2 06 00 00
       140429120 24 07           AND        AL,0x7
       140429122 3c 01           CMP        AL,0x1
       140429124 0f 94 c0        SETZ       AL
       140429127 c0 e0 04        SHL        AL,0x4
       14042912a 32 43 10        XOR        AL,byte ptr [RBX + 0x10]
       14042912d 24 10           AND        AL,0x10
       14042912f 32 43 10        XOR        AL,byte ptr [RBX + 0x10]
       140429132 88 43 10        MOV        byte ptr [RBX + 0x10],AL
       140429135 41 8b 8d        MOV        ECX,dword ptr [R13 + 0x304]
                 04 03 00 00


...

                             LAB_14042935c                                   XREF[1]:     140429335(j)  
       14042935c 44 39 4a 08     CMP        dword ptr [RDX + 0x8],R9D
       140429360 75 6f           JNZ        LAB_1404293d1
       140429362 48 83 3a 58     CMP        qword ptr [RDX],0x58
       140429366 75 69           JNZ        LAB_1404293d1
   --> 140429368 8a 4a 10        MOV        CL,byte ptr [RDX + 0x10]
       14042936b c0 e1 05        SHL        CL,0x5
       14042936e 41 32 48 08     XOR        CL,byte ptr [R8 + 0x8]
       140429372 80 e1 7f        AND        CL,0x7f
   --> 140429375 8a 42 10        MOV        AL,byte ptr [RDX + 0x10]
       140429378 c0 e0 05        SHL        AL,0x5
       14042937b 32 c8           XOR        CL,AL
       14042937d 41 88 48 08     MOV        byte ptr [R8 + 0x8],CL
   --> 140429381 8a 42 10        MOV        AL,byte ptr [RDX + 0x10]
       140429384 c0 e8 03        SHR        AL,0x3
       140429387 41 32 40 09     XOR        AL,byte ptr [R8 + 0x9]
       14042938b 24 01           AND        AL,0x1
       14042938d 41 30 40 09     XOR        byte ptr [R8 + 0x9],AL
       140429391 8b 42 14        MOV        EAX,dword ptr [RDX + 0x14]
       140429394 41 89 80        MOV        dword ptr [R8 + 0x98],EAX
                 98 00 00 00
   --> 14042939b 8a 42 10        MOV        AL,byte ptr [RDX + 0x10]
       14042939e 02 c0           ADD        AL,AL
       1404293a0 32 c1           XOR        AL,CL
       1404293a2 24 02           AND        AL,0x2
       1404293a4 41 30 40 08     XOR        byte ptr [R8 + 0x8],AL
   --> 1404293a8 8a 4a 10        MOV        CL,byte ptr [RDX + 0x10]
       1404293ab c0 e1 03        SHL        CL,0x3
       1404293ae 41 32 48 08     XOR        CL,byte ptr [R8 + 0x8]
       1404293b2 80 e1 10        AND        CL,0x10
       1404293b5 41 32 48 08     XOR        CL,byte ptr [R8 + 0x8]
       1404293b9 41 88 48 08     MOV        byte ptr [R8 + 0x8],CL
       1404293bd 0f b7 42 12     MOVZX      EAX,word ptr [RDX + 0x12]
       1404293c1 66 41 89        MOV        word ptr [R8 + 0xa],AX
                 40 0a
       1404293c6 49 89 50 28     MOV        qword ptr [R8 + 0x28],RDX
       1404293ca eb 0b           JMP        LAB_1404293d7
                             LAB_1404293cc                                   XREF[1]:     14042933a(j)  
       1404293cc e8 3f 8e        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 24 00

`````


------------------------------------------------------------


case 35


这个可以再看看。


`````shell
DOUBLE FETCH:   cr3 0x11067e000, syscall 0xbb
   eip 0xfffff80179cb2422, user_address 0xf5881fdd48, user_data 0x0, modrm 0x46, pc 0xfffff80179cb250b
   eip 0xfffff80179c73030, user_address 0xf5881fdd48, user_data 0x0, modrm 0x40, pc 0xfffff80179c730e7
`````

0xfffff80179cb250b - 0xfffff80179c730e7 = 3F424

14042850b - 1403e90e7 = 3F424

`````shell
                             LAB_1404284e7                                   XREF[1]:     1404284a5(j)  
       1404284e7 48 85 f6        TEST       RSI,RSI
       1404284ea 74 41           JZ         LAB_14042852d
       1404284ec 45 84 ff        TEST       R15B,R15B
       1404284ef 74 1a           JZ         LAB_14042850b
       1404284f1 40 f6 c6 03     TEST       SIL,0x3
       1404284f5 75 31           JNZ        LAB_140428528
       1404284f7 48 8b ce        MOV        RCX,RSI
       1404284fa 48 3b 35        CMP        RSI,qword ptr [MmUserProbeAddress]               = ??
                 ff 6c f5 ff
       140428501 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d f7 6c 
                 f5 ff
       140428509 8a 01           MOV        AL,byte ptr [RCX]
                             LAB_14042850b                                   XREF[1]:     1404284ef(j)  
   --> 14042850b 8b 46 18        MOV        EAX,dword ptr [RSI + 0x18]
       14042850e 45 84 ff        TEST       R15B,R15B
       140428511 74 0e           JZ         LAB_140428521
       140428513 25 f2 1d        AND        EAX,0x1df2
                 00 00
                             LAB_140428518                                   XREF[1]:     140428526(j)  
       140428518 89 84 24        MOV        dword ptr [RSP + 0x4d0],EAX
                 d0 04 00 00
       14042851f eb 0c           JMP        LAB_14042852d

`````


`````shell
                             LAB_1403e90d5                                   XREF[2]:     1403e9098(j), 1403e90b3(j)  
       1403e90d5 41 83 38 30     CMP        dword ptr [param_3],0x30
       1403e90d9 0f 85 b1        JNZ        LAB_1403e9190
                 00 00 00
       1403e90df 49 8b 40 08     MOV        RAX,qword ptr [param_3 + 0x8]
       1403e90e3 48 89 43 08     MOV        qword ptr [RBX + 0x8],RAX
   --> 1403e90e7 41 8b 40 18     MOV        EAX,dword ptr [param_3 + 0x18]
       1403e90eb 89 44 24 48     MOV        dword ptr [RSP + local_50],EAX
       1403e90ef 84 d2           TEST       param_2,param_2
       1403e90f1 74 08           JZ         LAB_1403e90fb
       1403e90f3 0f ba f0 09     BTR        EAX,0x9
       1403e90f7 89 44 24 48     MOV        dword ptr [RSP + local_50],EAX

`````

------------------------------------------------


case 36


这个没用。

`````shell
DOUBLE FETCH:   cr3 0x11067e000, syscall 0xbb
   eip 0xfffff80179cab038, user_address 0xf5881fdd90, user_data 0x88, modrm 0x1, pc 0xfffff80179cab085
   eip 0xfffff80179cab038, user_address 0xf5881fdd90, user_data 0x88, modrm 0x3, pc 0xfffff80179cab087

`````

`````shell
       140421054 4d 8b f1        MOV        R14,R9
       140421057 45 8b c8        MOV        R9D,R8D
       14042105a 44 8a ea        MOV        R13B,DL
       14042105d 48 8b d9        MOV        RBX,RCX
       140421060 41 88 16        MOV        byte ptr [R14],DL
       140421063 33 f6           XOR        ESI,ESI
       140421065 44 8d 46 03     LEA        R8D,[RSI + 0x3]
       140421069 84 d2           TEST       DL,DL
       14042106b 74 1a           JZ         LAB_140421087
       14042106d 41 84 c8        TEST       R8B,CL
       140421070 0f 85 9b        JNZ        LAB_140421911
                 08 00 00
       140421076 48 3b 0d        CMP        RCX,qword ptr [MmUserProbeAddress]               = ??
                 83 e1 f5 ff
       14042107d 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 7b e1 
                 f5 ff
   --> 140421085 8a 01           MOV        AL,byte ptr [RCX]
                             LAB_140421087                                   XREF[1]:     14042106b(j)  
   --> 140421087 48 8b 03        MOV        RAX,qword ptr [RBX]
       14042108a 48 89 44        MOV        qword ptr [RSP + local_f8],RAX
                 24 30
       14042108f 48 83 f8 28     CMP        RAX,0x28
       140421093 0f 82 7d        JC         LAB_140421916
                 08 00 00

`````

----------------------------------------------


case 37


和case36代码特着一样，应该是编译器的原因。

`````shell
DOUBLE FETCH:   cr3 0x11067e000, syscall 0x41
   eip 0xfffff80179cb01dc, user_address 0x2c596e34440, user_data 0x4, modrm 0x1, pc 0xfffff80179cb026a
   eip 0xfffff80179cb01dc, user_address 0x2c596e34440, user_data 0x4, modrm 0x0, pc 0xfffff80179cb026c

`````

`````shell
       14042624d 45 84 f6        TEST       R14B,R14B
       140426250 75 49           JNZ        LAB_14042629b
       140426252 40 f6 c7 03     TEST       DIL,0x3
       140426256 75 7e           JNZ        LAB_1404262d6
       140426258 49 8b c8        MOV        param_1,param_3
       14042625b 4c 3b 05        CMP        param_3,qword ptr [MmUserProbeAddress]           = ??
                 9e 8f f5 ff
       140426262 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d 96 8f 
                 f5 ff
   --> 14042626a 8a 01           MOV        AL,byte ptr [param_1]
   --> 14042626c 41 8b 00        MOV        EAX,dword ptr [param_3]
       14042626f 89 44 24 54     MOV        dword ptr [RSP + local_54],EAX
       140426273 ff c8           DEC        EAX
       140426275 8d 0c 40        LEA        param_1,[RAX + RAX*0x2]
       140426278 8d 0c 8d        LEA        param_1,[0x10 + param_1*0x4]
                 10 00 00 00
       14042627f 89 4c 24 78     MOV        dword ptr [RSP + local_30],param_1
       140426283 85 c9           TEST       param_1,param_1
       140426285 74 14           JZ         LAB_14042629b
       140426287 49 03 c8        ADD        param_1,param_3
       14042628a 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 6f 8f f5 ff
       140426291 48 3b c8        CMP        param_1,RAX
       140426294 77 45           JA         LAB_1404262db
       140426296 49 3b c8        CMP        param_1,param_3
       140426299 72 40           JC         LAB_1404262db

`````

----------------------------------------------------------

case 38


好像是在代码靠前的位值测试了下用户地址是否可读。

下一次用的时候就直接用了？ 64位看不好是不是加了try catch。这个应该试试。

这样下一次把这个页面释放就可以BSOD。





`````shell
DOUBLE FETCH:   cr3 0x12279c000, syscall 0xb8
   eip 0xfffff80179ce2639, user_address 0x207a9f67988, user_data 0x64, modrm 0x1, pc 0xfffff80179ce2743
   eip 0xfffff80179ce2a19, user_address 0x207a9f67988, user_data 0x207a9f67c64, modrm 0x4d, pc 0xfffff80179ce2a2b

`````

`````shell
       140458731 49 8b cd        MOV        param_1,R13
       140458734 4c 3b 2d        CMP        R13,qword ptr [MmUserProbeAddress]               = ??
                 c5 6a f2 ff
       14045873b 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d bd 6a 
                 f2 ff
   --> 140458743 8a 01           MOV        AL,byte ptr [param_1]
                             LAB_140458745                                   XREF[1]:     140458726(j)  
       140458745 48 8b 8c        MOV        param_1,qword ptr [RSP + param_5]
                 24 e0 01 
                 00 00
       14045874d 41 84 c8        TEST       param_3,param_1
       140458750 0f 85 96        JNZ        LAB_1404587ec
                 00 00 00
       140458756 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 a3 6a f2 ff
       14045875d 48 3b c8        CMP        param_1,RAX
       140458760 48 0f 43 c8     CMOVNC     param_1,RAX
       140458764 8a 01           MOV        AL,byte ptr [param_1]
       140458766 48 8b 94        MOV        param_2,qword ptr [RSP + param_13]
                 24 20 02 
                 00 00
       14045876e 48 85 d2        TEST       param_2,param_2
       140458771 75 7e           JNZ        LAB_1404587f1

`````


`````shell
                             LAB_140458a22                                   XREF[2]:     1404589f2(j), 140458ab2(j)  
       140458a22 4d 85 ed        TEST       R13,R13
       140458a25 74 40           JZ         LAB_140458a67
       140458a27 85 ff           TEST       EDI,EDI
       140458a29 78 3c           JS         LAB_140458a67
   --> 140458a2b 49 8b 4d 00     MOV        param_1,qword ptr [R13]
       140458a2f 48 85 c9        TEST       param_1,param_1
       140458a32 74 33           JZ         LAB_140458a67
       140458a34 48 8d 84        LEA        RAX=>local_68,[RSP + 0x150]
                 24 50 01 
                 00 00
       140458a3c 48 89 44        MOV        qword ptr [RSP + local_180],RAX
                 24 38
       140458a41 48 8d 84        LEA        RAX=>local_d0,[RSP + 0xe8]
                 24 e8 00 
                 00 00
       140458a49 48 89 44        MOV        qword ptr [RSP + local_188],RAX
                 24 30
       140458a4e c7 44 24        MOV        dword ptr [RSP + local_198],0x200
                 20 00 02 
                 00 00
       140458a56 40 8a d6        MOV        param_2,SIL
       140458a59 e8 46 04        CALL       FUN_140458ea4                                    undefined FUN_140458ea4(undefine
                 00 00
       140458a5e 8b f8           MOV        EDI,EAX
       140458a60 89 84 24        MOV        dword ptr [RSP + local_f4],EAX
                 c4 00 00 00

`````


-------------------------------------------------------


case 39


`````shell
DOUBLE FETCH:   cr3 0x12279c000, syscall 0xb8
   eip 0xfffff80179ce2639, user_address 0x207a9f67970, user_data 0xdc, modrm 0x1, pc 0xfffff80179ce2719
   eip 0xfffff80179ce29de, user_address 0x207a9f67970, user_data 0x207a9f67adc, modrm 0x8, pc 0xfffff80179ce29fc

`````

syscall 0xb8 NtCreateTransaction


719这里和上一个case 38里743离的很近，感觉是集中把几个用户地址读一个字节试下地址是否可读。

后面就直接用了。要验证下后一次读是否有try catch。

`````shell
                             LAB_1404586fa                                   XREF[1]:     1404587c4(j)  
       1404586fa 48 8b 8c        MOV        param_1,qword ptr [RSP + param_15]
                 24 30 02 
                 00 00
       140458702 41 84 c8        TEST       param_3,param_1
       140458705 0f 85 d7        JNZ        LAB_1404587e2
                 00 00 00
       14045870b 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 ee 6a f2 ff
       140458712 48 3b c8        CMP        param_1,RAX
       140458715 48 0f 43 c8     CMOVNC     param_1,RAX
   --> 140458719 8a 01           MOV        AL,byte ptr [param_1]
       14045871b 4c 8b ac        MOV        R13,qword ptr [RSP + param_16]
                 24 38 02 
                 00 00
       140458723 4d 85 ed        TEST       R13,R13
       140458726 74 1d           JZ         LAB_140458745
       140458728 45 84 e8        TEST       param_3,R13B
       14045872b 0f 85 b6        JNZ        LAB_1404587e7
                 00 00 00
       140458731 49 8b cd        MOV        param_1,R13
       140458734 4c 3b 2d        CMP        R13,qword ptr [MmUserProbeAddress]               = ??
                 c5 6a f2 ff
       14045873b 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d bd 6a 
                 f2 ff
   x   140458743 8a 01           MOV        AL,byte ptr [param_1]
                             LAB_140458745                                   XREF[1]:     140458726(j)  
       140458745 48 8b 8c        MOV        param_1,qword ptr [RSP + param_5]
                 24 e0 01 
                 00 00

`````

后面这部分代码就见不到MmUserProbeAddress和`CALL       ExRaiseDatatypeMisalignment`了，要验证是否有try catch。



测试过了，后面的部分也try catch了。



`````shell
                             LAB_1404589e7                                   XREF[1]:     1404589a5(j)  
       1404589e7 4d 85 e4        TEST       R12,R12
       1404589ea 0f 85 c0        JNZ        LAB_140458ab0
                 00 00 00
                             LAB_1404589f0                                   XREF[1]:     140458adf(j)  
       1404589f0 85 ff           TEST       EDI,EDI
       1404589f2 78 2e           JS         LAB_140458a22
       1404589f4 48 8b 84        MOV        RAX,qword ptr [RSP + param_15]
                 24 30 02 
                 00 00
   --> 1404589fc 48 8b 08        MOV        param_1,qword ptr [RAX]
       1404589ff 48 8d 84        LEA        RAX=>local_a8,[RSP + 0x110]
                 24 10 01 
                 00 00
       140458a07 48 89 44        MOV        qword ptr [RSP + local_188],RAX
                 24 30
       140458a0c c6 44 24        MOV        byte ptr [RSP + local_190],0x1
                 28 01
       140458a11 40 8a d6        MOV        param_2,SIL
       140458a14 e8 6b 01        CALL       FUN_1404a8b84                                    undefined FUN_1404a8b84(undefine
                 05 00
       140458a19 8b f8           MOV        EDI,EAX
       140458a1b 89 84 24        MOV        dword ptr [RSP + local_f4],EAX
                 c4 00 00 00

`````




应该用虚拟机这样找一下，所有读用户提供地址的都要probe，也就是和MmUserProbeAddress比一下。

如果没有比一下就用的，应该是有问题的。

PAGE_FAULT_IN_NONPAGED_AREA是不能被try catch的。




----------------------------------------------------------------


case 40

`````shell
DOUBLE FETCH:   cr3 0x12279c000, syscall 0xb8
   eip 0xfffff80179ce2639, user_address 0x207a9f67c94, user_data 0xa, modrm 0x1, pc 0xfffff80179ce26c6
   eip 0xfffff80179ce296e, user_address 0x207a9f67c94, user_data 0xa, modrm 0x11, pc 0xfffff80179ce29af
`````

This is a piece of typical "probe" code generated by the compiler.

`````shell
       1404586b8 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 41 6b f2 ff
       1404586bf 48 3b c8        CMP        param_1,RAX
       1404586c2 48 0f 43 c8     CMOVNC     param_1,RAX
   --> 1404586c6 8a 01           MOV        AL,byte ptr [param_1]
       1404586c8 48 8b 8c        MOV        param_1,qword ptr [RSP + param_17]
                 24 40 02 
                 00 00
`````


can't determine from the code that whether the second reference is protected by a try-catch.



`````shell
                             LAB_1404589a3                                   XREF[1]:     14045892b(j)  
       1404589a3 85 ff           TEST       EDI,EDI
       1404589a5 78 40           JS         LAB_1404589e7
       1404589a7 48 8b 8c        MOV        param_1,qword ptr [RSP + param_9]
                 24 00 02 
                 00 00
   --> 1404589af 8b 11           MOV        param_2,dword ptr [param_1]
       1404589b1 89 94 24        MOV        dword ptr [RSP + local_e8],param_2
                 d0 00 00 00
       1404589b8 48 83 c1 04     ADD        param_1,0x4
       1404589bc 48 8d 84        LEA        RAX=>local_88,[RSP + 0x130]
                 24 30 01 
                 00 00
       1404589c4 48 89 44        MOV        qword ptr [RSP + local_178],RAX
                 24 40
       1404589c9 48 8d 84        LEA        RAX=>local_c0,[RSP + 0xf8]
                 24 f8 00 
                 00 00
       1404589d1 48 89 44        MOV        qword ptr [RSP + local_180],RAX
                 24 38
       1404589d6 44 8a c6        MOV        param_3,SIL
       1404589d9 e8 92 e2        CALL       FUN_140426c70                                    undefined FUN_140426c70(undefine
                 fc ff
       1404589de 8b f8           MOV        EDI,EAX
       1404589e0 89 84 24        MOV        dword ptr [RSP + local_f4],EAX
                 c4 00 00 00

`````

------------------------------------------
case 41

`````shell
DOUBLE FETCH:   cr3 0x12279c000, syscall 0xb8
   eip 0xfffff80179d336e4, user_address 0x207a9f9fcb8, user_data 0x207a9f67adc, modrm 0x4, pc 0xfffff80179d3373d
   eip 0xfffff801799d7780, user_address 0x207a9f9fcb8, user_data 0x207a9f67adc, modrm 0x44, pc 0xfffff801799d7940
`````

0xfffff80179d3373d - 0xfffff801799d7940 = 35BDFD


1404a973d - 35BDFD = 14014D940

`````shell
                             LAB_1404a9730                                   XREF[1]:     1404a97c6(j)  
       1404a9730 3b c7           CMP        EAX,EDI
       1404a9732 0f 83 cb        JNC        LAB_1404a9803
                 00 00 00
       1404a9738 8b c8           MOV        param_1,EAX
       1404a973a 48 03 c9        ADD        param_1,param_1
   --> 1404a973d 4c 8b 04 ce     MOV        param_3,qword ptr [RSI + param_1*0x8]
       1404a9741 49 8d 40 01     LEA        RAX,[param_3 + 0x1]
       1404a9745 48 8b 15        MOV        param_2,qword ptr [MmUserProbeAddress]           = ??
                 b4 5a ed ff
       1404a974c 48 3b c2        CMP        RAX,param_2
       1404a974f 0f 83 83        JNC        LAB_1404a97d8
                 00 00 00

`````


`````shell
                             LAB_14014d940                                   XREF[1]:     14014d94f(j)  
   --> 14014d940 48 8b 44        MOV        RAX,qword ptr [_Src + _Dst*0x1 + -0x8]
                 0a f8
       14014d945 48 83 e9 08     SUB        _Dst,0x8
       14014d949 49 ff c9        DEC        R9
       14014d94c 48 89 01        MOV        qword ptr [_Dst],RAX
       14014d94f 75 ef           JNZ        LAB_14014d940

                             LAB_14014d951                                   XREF[1]:     14014d93e(j)  
       14014d951 49 83 e0 07     AND        _Size,0x7
       14014d955 74 17           JZ         LAB_14014d96e
       14014d957 66 0f 1f        NOP        word ptr [RAX + RAX*0x1]
                 84 00 00 
                 00 00 00
                             LAB_14014d960                                   XREF[1]:     14014d96c(j)  
       14014d960 8a 44 0a ff     MOV        AL,byte ptr [_Src + _Dst*0x1 + -0x1]
       14014d964 48 ff c9        DEC        _Dst
       14014d967 49 ff c8        DEC        _Size
       14014d96a 88 01           MOV        byte ptr [_Dst],AL
       14014d96c 75 f2           JNZ        LAB_14014d960

`````


Those two references are far away. The latter code belongs RtlCopyMemory().

So, the code first probes the buffer then copies some data to it?


This also solves the mistery of previous 0xfffff801799d7940 and 0xfffff801799d7960. They both from RtlCopyMemory().

-----------------------------------------------------------------------------

case 42


They are all the same. First probe, then read.

`````shell
DOUBLE FETCH:   cr3 0x12279c000, syscall 0xb8
   eip 0xfffff80179ce2639, user_address 0x3dd227dfe8, user_data 0xe4, modrm 0x1, pc 0xfffff80179ce2764
   eip 0xfffff80179ce28ab, user_address 0x3dd227dfe8, user_data 0x3e4, modrm 0x8, pc 0xfffff80179ce28cd

DOUBLE FETCH:   cr3 0x12279c000, syscall 0xb8
   eip 0xfffff80179ce2639, user_address 0x207a9f67950, user_data 0x90, modrm 0x1, pc 0xfffff80179ce2684
   eip 0xfffff80179ce28ab, user_address 0x207a9f67950, user_data 0x6207526b64ceb90, modrm 0x8, pc 0xfffff80179ce28e0

DOUBLE FETCH:   cr3 0x12279c000, syscall 0xb8
   eip 0xfffff80179ce2639, user_address 0x207a9f9fcb0, user_data 0x13, modrm 0x1, pc 0xfffff80179ce26a5
   eip 0xfffff80179ce2920, user_address 0x207a9f9fcb0, user_data 0x13, modrm 0x19, pc 0xfffff80179ce2935

`````


`````shell
       14045866a 41 b0 03        MOV        param_3,0x3
       14045866d 41 84 c8        TEST       param_3,param_1
       140458670 0f 85 53        JNZ        LAB_1404587c9
                 01 00 00
       140458676 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 83 6b f2 ff
       14045867d 48 3b c8        CMP        param_1,RAX
       140458680 48 0f 43 c8     CMOVNC     param_1,RAX
   --> 140458684 8a 01           MOV        AL,byte ptr [param_1]
       140458686 48 8b 8c        MOV        param_1,qword ptr [RSP + param_8]
                 24 f8 01 
                 00 00
       14045868e 41 84 c8        TEST       param_3,param_1
       140458691 0f 85 37        JNZ        LAB_1404587ce
                 01 00 00
       140458697 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 62 6b f2 ff
       14045869e 48 3b c8        CMP        param_1,RAX
       1404586a1 48 0f 43 c8     CMOVNC     param_1,RAX
   --> 1404586a5 8a 01           MOV        AL,byte ptr [param_1]
       1404586a7 48 8b 8c        MOV        param_1,qword ptr [RSP + param_9]
                 24 00 02 
                 00 00
       1404586af 41 84 c8        TEST       param_3,param_1
       1404586b2 0f 85 1b        JNZ        LAB_1404587d3
                 01 00 00
       1404586b8 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 41 6b f2 ff
       1404586bf 48 3b c8        CMP        param_1,RAX
       1404586c2 48 0f 43 c8     CMOVNC     param_1,RAX
       1404586c6 8a 01           MOV        AL,byte ptr [param_1]
       1404586c8 48 8b 8c        MOV        param_1,qword ptr [RSP + param_17]
                 24 40 02 
                 00 00
       1404586d0 41 84 c8        TEST       param_3,param_1
       1404586d3 0f 85 ff        JNZ        LAB_1404587d8
                 00 00 00
       1404586d9 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 20 6b f2 ff
       1404586e0 48 3b c8        CMP        param_1,RAX
       1404586e3 48 0f 43 c8     CMOVNC     param_1,RAX
       1404586e7 8a 01           MOV        AL,byte ptr [param_1]
       1404586e9 4c 8b a4        MOV        R12,qword ptr [RSP + param_14]
                 24 28 02 
                 00 00
       1404586f1 4d 85 e4        TEST       R12,R12
       1404586f4 0f 85 b1        JNZ        LAB_1404587ab
                 00 00 00
                             LAB_1404586fa                                   XREF[1]:     1404587c4(j)  
       1404586fa 48 8b 8c        MOV        param_1,qword ptr [RSP + param_15]
                 24 30 02 
                 00 00
       140458702 41 84 c8        TEST       param_3,param_1
       140458705 0f 85 d7        JNZ        LAB_1404587e2
                 00 00 00
       14045870b 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 ee 6a f2 ff
       140458712 48 3b c8        CMP        param_1,RAX
       140458715 48 0f 43 c8     CMOVNC     param_1,RAX
       140458719 8a 01           MOV        AL,byte ptr [param_1]
       14045871b 4c 8b ac        MOV        R13,qword ptr [RSP + param_16]
                 24 38 02 
                 00 00
       140458723 4d 85 ed        TEST       R13,R13
       140458726 74 1d           JZ         LAB_140458745
       140458728 45 84 e8        TEST       param_3,R13B
       14045872b 0f 85 b6        JNZ        LAB_1404587e7
                 00 00 00
       140458731 49 8b cd        MOV        param_1,R13
       140458734 4c 3b 2d        CMP        R13,qword ptr [MmUserProbeAddress]               = ??
                 c5 6a f2 ff
       14045873b 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d bd 6a 
                 f2 ff
       140458743 8a 01           MOV        AL,byte ptr [param_1]
                             LAB_140458745                                   XREF[1]:     140458726(j)  
       140458745 48 8b 8c        MOV        param_1,qword ptr [RSP + param_5]
                 24 e0 01 
                 00 00
       14045874d 41 84 c8        TEST       param_3,param_1
       140458750 0f 85 96        JNZ        LAB_1404587ec
                 00 00 00
       140458756 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 a3 6a f2 ff
       14045875d 48 3b c8        CMP        param_1,RAX
       140458760 48 0f 43 c8     CMOVNC     param_1,RAX
   --> 140458764 8a 01           MOV        AL,byte ptr [param_1]
       140458766 48 8b 94        MOV        param_2,qword ptr [RSP + param_13]
                 24 20 02 
                 00 00
       14045876e 48 85 d2        TEST       param_2,param_2
       140458771 75 7e           JNZ        LAB_1404587f1

`````


`````shell
                             LAB_1404588be                                   XREF[1]:     140458e83(j)  
       1404588be 89 94 24        MOV        dword ptr [RSP + local_f4],param_2
                 c4 00 00 00
       1404588c5 48 8b 84        MOV        RAX,qword ptr [RSP + param_5]
                 24 e0 01 
                 00 00
   --> 1404588cd 48 8b 08        MOV        param_1,qword ptr [RAX]
       1404588d0 48 89 8c        MOV        qword ptr [RSP + local_70],param_1
                 24 48 01 
                 00 00
       1404588d8 48 8b 84        MOV        RAX,qword ptr [RSP + param_6]
                 24 e8 01 
                 00 00
   --> 1404588e0 48 8b 08        MOV        param_1,qword ptr [RAX]
       1404588e3 48 89 8c        MOV        qword ptr [RSP + local_60],param_1
                 24 58 01 
                 00 00
       1404588eb 48 8d 84        LEA        RAX=>local_8c,[RSP + 0x12c]
                 24 2c 01 
                 00 00
       1404588f3 48 89 44        MOV        qword ptr [RSP + local_178],RAX
                 24 40
       1404588f8 48 8d 84        LEA        RAX=>local_d8,[RSP + 0xe0]
                 24 e0 00 
                 00 00
       140458900 48 89 44        MOV        qword ptr [RSP + local_180],RAX
                 24 38
       140458905 89 54 24 20     MOV        dword ptr [RSP + local_198],param_2
       140458909 45 33 c9        XOR        param_4,param_4
       14045890c 44 8a c6        MOV        param_3,SIL
       14045890f 41 8d 51 01     LEA        param_2,[param_4 + 0x1]
       140458913 48 8b 8c        MOV        param_1,qword ptr [RSP + param_7]
                 24 f0 01 
                 00 00
       14045891b e8 10 0d        CALL       FUN_1404a9630                                    undefined FUN_1404a9630(undefine
                 05 00
       140458920 8b f8           MOV        EDI,EAX
       140458922 89 84 24        MOV        dword ptr [RSP + local_f4],EAX
                 c4 00 00 00
       140458929 85 c0           TEST       EAX,EAX
       14045892b 78 76           JS         LAB_1404589a3
       14045892d 48 8b 8c        MOV        param_1,qword ptr [RSP + param_8]
                 24 f8 01 
                 00 00
   --> 140458935 8b 19           MOV        EBX,dword ptr [param_1]
       140458937 89 9c 24        MOV        dword ptr [RSP + local_e0],EBX
                 d8 00 00 00
       14045893e 48 83 c1 08     ADD        param_1,0x8
       140458942 48 8d 84        LEA        RAX=>local_f0,[RSP + 0xc8]
                 24 c8 00 
                 00 00
       14045894a 48 89 44        MOV        qword ptr [RSP + local_178],RAX
                 24 40
       14045894f 48 8d 84        LEA        RAX=>local_b0,[RSP + 0x108]
                 24 08 01 
                 00 00
       140458957 48 89 44        MOV        qword ptr [RSP + local_180],RAX
                 24 38
       14045895c 83 64 24        AND        dword ptr [RSP + local_198],0x0
                 20 00
       140458961 45 33 c9        XOR        param_4,param_4
       140458964 44 8a c6        MOV        param_3,SIL
       140458967 8b d3           MOV        param_2,EBX
       140458969 e8 c2 0c        CALL       FUN_1404a9630                                    undefined FUN_1404a9630(undefine
                 05 00

`````



------------------------------------------------------------------------

case 43


It seems that all the 1-byte read (opcode 8a 01) are all the same kind.

`````shell
DOUBLE FETCH:   cr3 0x12cd41000, syscall 0x6a
   eip 0xfffff80179ce0bc0, user_address 0x1c455cf948, user_data 0x1, modrm 0x1, pc 0xfffff80179ce0c3f
   eip 0xfffff80179ce0bc0, user_address 0x1c455cf948, user_data 0x1, modrm 0x16, pc 0xfffff80179ce0c8d

`````


`````shell
       140456c22 45 84 f6        TEST       R14B,R14B
       140456c25 75 1a           JNZ        LAB_140456c41
       140456c27 40 f6 c6 03     TEST       SIL,0x3
       140456c2b 75 23           JNZ        LAB_140456c50
       140456c2d 49 8b c8        MOV        param_1,param_3
       140456c30 4c 3b 05        CMP        param_3,qword ptr [MmUserProbeAddress]           = ??
                 c9 85 f2 ff
       140456c37 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d c1 85 
                 f2 ff
   --> 140456c3f 8a 01           MOV        AL,byte ptr [param_1]
                             LAB_140456c41                                   XREF[1]:     140456c25(j)  
       140456c41 48 8b 9c        MOV        RBX,qword ptr [RSP + param_5]
                 24 d0 00 
                 00 00
       140456c49 48 85 db        TEST       RBX,RBX
       140456c4c 75 07           JNZ        LAB_140456c55
       140456c4e eb 31           JMP        LAB_140456c81
                             LAB_140456c50                                   XREF[1]:     140456c2b(j)  
       140456c50 e8 bb b5        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 21 00
                             LAB_140456c55                                   XREF[1]:     140456c4c(j)  
       140456c55 49 8b d5        MOV        param_2,R13
       140456c58 41 b8 04        MOV        param_3,0x4
                 00 00 00
       140456c5e 48 8b cb        MOV        param_1,RBX
       140456c61 e8 ba ca        CALL       ProbeForWrite                                    undefined ProbeForWrite()
                 f9 ff
       140456c66 48 8b 8c        MOV        param_1,qword ptr [RSP + param_6]
                 24 d8 00 
                 00 00
       140456c6e 48 3b 0d        CMP        param_1,qword ptr [MmUserProbeAddress]           = ??
                 8b 85 f2 ff
       140456c75 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d 83 85 
                 f2 ff
       140456c7d 8b 01           MOV        EAX,dword ptr [param_1]
       140456c7f 89 01           MOV        dword ptr [param_1],EAX
                             LAB_140456c81                                   XREF[1]:     140456c4e(j)  
       140456c81 eb 05           JMP        LAB_140456c88
       140456c83 e9              ??         E9h
       140456c84 3b              ??         3Bh    ;
       140456c85 02              ??         02h
       140456c86 00              ??         00h
       140456c87 00              ??         00h
                             LAB_140456c88                                   XREF[2]:     140456c81(j), 1405909be(j)  
       140456c88 45 84 f6        TEST       R14B,R14B
       140456c8b 75 41           JNZ        LAB_140456cce
   --> 140456c8d 8b 16           MOV        param_2,dword ptr [RSI]
       140456c8f 89 54 24 5c     MOV        dword ptr [RSP + local_4c],param_2
       140456c93 48 8d 4e 08     LEA        param_1,[RSI + 0x8]
       140456c97 48 8d 44        LEA        RAX=>local_44,[RSP + 0x64]
                 24 64

`````
-------------------------------------------------------------

case 44


useless


`````shell
DOUBLE FETCH:   cr3 0x12cd41000, syscall 0x86
   eip 0xfffff80179cfc0d0, user_address 0x1c455cf640, user_data 0x0, modrm 0x1, pc 0xfffff80179cfc2cc
   eip 0xfffff80179cfc0d0, user_address 0x1c455cf640, user_data 0x0, modrm 0x1, pc 0xfffff80179cfc2fb

`````

`````shell
       1404722b3 45 84 d2        TEST       R10B,R10B
       1404722b6 74 16           JZ         LAB_1404722ce
       1404722b8 f6 c1 03        TEST       CL,0x3
       1404722bb 75 52           JNZ        LAB_14047230f
       1404722bd 48 3b 0d        CMP        RCX,qword ptr [MmUserProbeAddress]               = ??
                 3c cf f0 ff
       1404722c4 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 34 cf 
                 f0 ff
   --> 1404722cc 8a 01           MOV        AL,byte ptr [RCX]
                             LAB_1404722ce                                   XREF[1]:     1404722b6(j)  
       1404722ce b9 00 10        MOV        ECX,0x1000
                 00 00
       1404722d3 66 41 85        TEST       word ptr [R9 + 0x4],CX
                 49 04
       1404722d8 0f 85 92        JNZ        LAB_140599770
                 74 12 00
       1404722de 45 84 d2        TEST       R10B,R10B
       1404722e1 74 1a           JZ         LAB_1404722fd
       1404722e3 41 f6 c1 03     TEST       R9B,0x3
       1404722e7 75 2c           JNZ        LAB_140472315
       1404722e9 4c 3b 0d        CMP        R9,qword ptr [MmUserProbeAddress]                = ??
                 10 cf f0 ff
       1404722f0 49 8b c9        MOV        RCX,R9
       1404722f3 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 05 cf 
                 f0 ff
   --> 1404722fb 8a 01           MOV        AL,byte ptr [RCX]
                             LAB_1404722fd                                   XREF[1]:     1404722e1(j)  
       1404722fd 41 8b 41 18     MOV        EAX,dword ptr [R9 + 0x18]
       140472301 89 02           MOV        dword ptr [RDX],EAX
       140472303 41 8b 41 20     MOV        EAX,dword ptr [R9 + 0x20]

`````
--------------------------------------------------------------

case 45

Didn't find those two.

They may not from the ntoskrnl becasue their address 0xfffff800a296351a is different from the previous case's 0xfffff80179ce0c3f.

0xfffff800axxxxxxx is another kernel module.

`````shell
DOUBLE FETCH:   cr3 0x10e9f5000, syscall 0x7
   eip 0xfffff800a29634fa, user_address 0x4157ffe988, user_data 0x4157ffe940, modrm 0x66, pc 0xfffff800a296351a
   eip 0xfffff800a2964040, user_address 0x4157ffe988, user_data 0x4157ffe940, modrm 0x44, pc 0xfffff800a2964200

DOUBLE FETCH:   cr3 0x10e9f5000, syscall 0x7
   eip 0xfffff800a29634fa, user_address 0x4157ffe958, user_data 0x2258a557170, modrm 0x6e, pc 0xfffff800a296350e
   eip 0xfffff800a2964040, user_address 0x4157ffe958, user_data 0x2258a557170, modrm 0x44, pc 0xfffff800a2964200
`````

-----------------------------------------------------


case 46


useless

`````shell
DOUBLE FETCH:   cr3 0x10d414000, syscall 0x14c
   eip 0xfffff80179cabf44, user_address 0x4999f7ee24, user_data 0x0, modrm 0x11, pc 0xfffff80179cabf8c
   eip 0xfffff80179cabf44, user_address 0x4999f7ee24, user_data 0x0, modrm 0x1, pc 0xfffff80179cabfa4

`````

`````shell
                             LAB_140421f64                                   XREF[1]:     140422047(j)  
       140421f64 49 8b cb        MOV        RCX,R11
       140421f67 4c 3b 1d        CMP        R11,qword ptr [MmUserProbeAddress]               = ??
                 92 d2 f5 ff
       140421f6e 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 8a d2 
                 f5 ff
       140421f76 8b 01           MOV        EAX,dword ptr [RCX]
       140421f78 89 01           MOV        dword ptr [RCX],EAX
       140421f7a 49 8b ca        MOV        RCX,R10
       140421f7d 4c 3b 15        CMP        R10,qword ptr [MmUserProbeAddress]               = ??
                 7c d2 f5 ff
       140421f84 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 74 d2 
                 f5 ff
   --> 140421f8c 8b 11           MOV        EDX,dword ptr [RCX]
       140421f8e 89 54 24 50     MOV        dword ptr [RSP + 0x50],EDX
       140421f92 49 8b ca        MOV        RCX,R10
       140421f95 4c 3b 15        CMP        R10,qword ptr [MmUserProbeAddress]               = ??
                 64 d2 f5 ff
       140421f9c 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 5c d2 
                 f5 ff
   --> 140421fa4 8b 01           MOV        EAX,dword ptr [RCX]
       140421fa6 89 01           MOV        dword ptr [RCX],EAX
       140421fa8 85 d2           TEST       EDX,EDX
       140421faa 74 0e           JZ         LAB_140421fba
       140421fac 41 b8 01        MOV        R8D,0x1
                 00 00 00
       140421fb2 48 8b cb        MOV        RCX,RBX
       140421fb5 e8 66 17        CALL       ProbeForWrite                                    undefined ProbeForWrite()
                 fd ff

`````

----------------------------------------------------------

case 47


*** need review


`````shell
DOUBLE FETCH:   cr3 0x0, syscall 0x88
   eip 0xfffff801798a2011, user_address 0x16934f44d10, user_data 0xf0, modrm 0x9, pc 0xfffff801798a2042
   eip 0xfffff801798a20f8, user_address 0x16934f44d10, user_data 0xf0, modrm 0x2, pc 0xfffff801798a2143

`````

`````shell
                             LAB_140018039                                   XREF[1]:     1400180c5(j)  
       140018039 4c 3b cd        CMP        R9,RBP
       14001803c 0f 87 a8        JA         LAB_1400180ea
                 00 00 00
   --> 140018042 41 8b 09        MOV        ECX,dword ptr [R9]
       140018045 4c 8d 05        LEA        R8,[DAT_14023d240]
                 f4 51 22 00
       14001804c 8b c2           MOV        EAX,EDX
       14001804e 83 e0 1f        AND        EAX,0x1f
       140018051 41 8b 1c 80     MOV        EBX,dword ptr [R8 + RAX*0x4]=>DAT_14023d240
       140018055 0b d9           OR         EBX,ECX
       140018057 8b c3           MOV        EAX,EBX
       140018059 41 23 c2        AND        EAX,R10D
       14001805c 41 3b c2        CMP        EAX,R10D
       14001805f 74 52           JZ         LAB_1400180b3
       140018061 83 e2 e0        AND        EDX,0xffffffe0
       140018064 45 8b c4        MOV        R8D,R12D

`````


`````shell
RtlInterlockedSetClearRun


                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined RtlInterlockedSetClearRun()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x20]:8  local_res20                             XREF[2]:     140018107(W), 
                                                                                                   140018187(R)  
             undefined8        Stack[0x18]:8  local_res18                             XREF[2]:     140018103(W), 
                                                                                                   140018182(R)  
             undefined8        Stack[0x10]:8  local_res10                             XREF[2]:     1400180ff(W), 
                                                                                                   14001817d(R)  
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1400180fb(W), 
                                                                                                   140018178(R)  
                             0x180f8  1927  RtlInterlockedSetClearRun
                             Ordinal_1927                                    XREF[5]:     Entry Point(*), 14025d71c(*), 
                             RtlInterlockedSetClearRun                                    1403326ec(*), 
                                                                                          FUN_1403c9e38:1403c9e8f(c), 
                                                                                          1406e5e40(*)  
       1400180f8 48 8b c4        MOV        RAX,RSP
       1400180fb 48 89 58 08     MOV        qword ptr [RAX + local_res8],RBX
       1400180ff 48 89 68 10     MOV        qword ptr [RAX + local_res10],RBP
       140018103 48 89 70 18     MOV        qword ptr [RAX + local_res18],RSI
       140018107 48 89 78 20     MOV        qword ptr [RAX + local_res20],RDI
       14001810b 41 56           PUSH       R14
       14001810d 41 57           PUSH       R15
       14001810f 8b da           MOV        EBX,EDX
       140018111 41 bf 20        MOV        R15D,0x20
                 00 00 00
       140018117 83 e3 1f        AND        EBX,0x1f
       14001811a 45 8b d8        MOV        R11D,R8D
       14001811d 44 8b d2        MOV        R10D,EDX
       140018120 45 8b c8        MOV        R9D,R8D
       140018123 49 c1 ea 03     SHR        R10,0x3
       140018127 4c 8b f1        MOV        R14,RCX
       14001812a 4c 03 51 08     ADD        R10,qword ptr [RCX + 0x8]
       14001812e 45 8d 47 e1     LEA        R8D,[R15 + -0x1f]
       140018132 4a 8d 04 1b     LEA        RAX,[RBX + R11*0x1]
       140018136 8b fa           MOV        EDI,EDX
       140018138 49 83 e2 fc     AND        R10,-0x4
       14001813c 8b f2           MOV        ESI,EDX
       14001813e 49 3b c7        CMP        RAX,R15
       140018141 77 4e           JA         LAB_140018191
   --> 140018143 41 8b 02        MOV        EAX,dword ptr [R10]
       140018146 45 3b df        CMP        R11D,R15D
       140018149 0f 84 3d        JZ         LAB_140159c8c
                 1b 14 00
       14001814f 41 8b cb        MOV        ECX,R11D
       140018152 41 8b d0        MOV        EDX,R8D
       140018155 d3 e2           SHL        EDX,CL
       140018157 8b cb           MOV        ECX,EBX
       140018159 41 2b d0        SUB        EDX,R8D
       14001815c d3 e2           SHL        EDX,CL

                             LAB_14001815e                                   XREF[1]:     140159c8f(j)  
       14001815e 85 d0           TEST       EAX,EDX
       140018160 0f 85 49        JNZ        LAB_140159caf
                 1b 14 00
                             LAB_140018166                                   XREF[1]:     140159c96(j)  
       140018166 8b ca           MOV        ECX,EDX
       140018168 0b c8           OR         ECX,EAX
       14001816a f0              LOCK
       14001816b 41 0f b1 0a     CMPXCHG    dword ptr [R10],ECX
       14001816f 0f 85 1f        JNZ        LAB_140159c94
                 1b 14 00
                             LAB_140018175                                   XREF[2]:     1400181d8(j), 1400181f9(j)  
       140018175 41 8b c0        MOV        EAX,R8D
                             LAB_140018178                                   XREF[1]:     140159cb1(j)  
       140018178 48 8b 5c        MOV        RBX,qword ptr [RSP + local_res8]
                 24 18
       14001817d 48 8b 6c        MOV        RBP,qword ptr [RSP + local_res10]
                 24 20
       140018182 48 8b 74        MOV        RSI,qword ptr [RSP + local_res18]
                 24 28
       140018187 48 8b 7c        MOV        RDI,qword ptr [RSP + local_res20]
                 24 30
       14001818c 41 5f           POP        R15
       14001818e 41 5e           POP        R14
       140018190 c3              RET

`````

------------------------------------------------------------------

case 48


Nowhere to find this module. I searched win32kfull.sys win32kbase.sys tsddd.dll cdd.dll.


Found it! It is win32kfull.sys. But somehow it needs to be win32kfull_10.0.10586.0.sys.

The binaries seems differ a bit.

I forgot what the differences between these two version, I think they both are version 10586.

Maybe the win32kfull.sys is from the vritual machine that with internet connection, so the system gets updated.

`````shell
DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x1101
   eip 0xfffff961a3ac82ed, user_address 0x7592a7afd0, user_data 0x48, modrm 0x2, pc 0xfffff961a3ac8321
   eip 0xfffff961a3ac82ed, user_address 0x7592a7afd0, user_data 0x48, modrm 0x7, pc 0xfffff961a3ac832b

`````


`````shell
                             LAB_1c00c8310                                   XREF[1]:     1c00c8308(j)  
       1c00c8310 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 e1 92 28 00
       1c00c8317 48 8b d7        MOV        RDX,RDI
       1c00c831a 48 3b 38        CMP        RDI,qword ptr [RAX]
       1c00c831d 48 0f 43 10     CMOVNC     RDX,qword ptr [RAX]
   --> 1c00c8321 8a 02           MOV        AL,byte ptr [RDX]
       1c00c8323 88 02           MOV        byte ptr [RDX],AL
       1c00c8325 8a 42 47        MOV        AL,byte ptr [RDX + 0x47]
       1c00c8328 88 42 47        MOV        byte ptr [RDX + 0x47],AL
   --> 1c00c832b 8b 07           MOV        EAX,dword ptr [RDI]
       1c00c832d 89 44 24 50     MOV        dword ptr [RSP + local_58[0]],EAX
       1c00c8331 eb 04           JMP        LAB_1c00c8337
       1c00c8333 33              ??         33h    3
       1c00c8334 db              ??         DBh
       1c00c8335 eb              ??         EBh
       1c00c8336 4b              ??         4Bh    K

`````


--------------------------------------------------------------------------

case 49

Finally, find this 0xfffff961a3ad292a.

It seems useless though.

`````shell
DOUBLE FETCH:   cr3 0x121cb7000, syscall 0x1005
   eip 0xfffff961a3ad2869, user_address 0x248e4ae0810, user_data 0x4fe8bfb38e0f7a12, modrm 0xa, pc 0xfffff961a3ad292a
   eip 0xfffff961a3ad2869, user_address 0x248e4ae0810, user_data 0x4fe8bfb38e0f7a12, modrm 0xa, pc 0xfffff961a3ad292a

DOUBLE FETCH:   cr3 0x121cb7000, syscall 0x1005
   eip 0xfffff961a3ad2869, user_address 0x248e4ae0810, user_data 0x4fe8bfb38e0f7a12, modrm 0xa, pc 0xfffff961a3ad292a
   eip 0xfffff961a3ad2869, user_address 0x248e4ae0810, user_data 0x4fe8bfb38e0f7a12, modrm 0xa, pc 0xfffff961a3ad292a

DOUBLE FETCH:   cr3 0x121cb7000, syscall 0x1005
   eip 0xfffff961a3ad2869, user_address 0x248e4ae0810, user_data 0x4fe8bfb38e0f7a12, modrm 0xa, pc 0xfffff961a3ad292a
   eip 0xfffff961a3ad2869, user_address 0x248e4ae0810, user_data 0x4fe8bfb38e0f7a12, modrm 0xa, pc 0xfffff961a3ad292a

DOUBLE FETCH:   cr3 0x121cb7000, syscall 0x1005
   eip 0xfffff961a3ad2869, user_address 0x248e4ae0810, user_data 0x4fe8bfb38e0f7a12, modrm 0xa, pc 0xfffff961a3ad292a
   eip 0xfffff961a3ad2869, user_address 0x248e4ae0810, user_data 0x4fe8bfb38e0f7a12, modrm 0xa, pc 0xfffff961a3ad292a

`````


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c00d2914()
             undefined         AL:1           <RETURN>
                             FUN_1c00d2914                                   XREF[1]:     SetManifestWinVer:1c00d2877(c)  
       1c00d2914 45 33 c0        XOR        R8D,R8D
       1c00d2917 4c 8b d1        MOV        R10,RCX
       1c00d291a 48 85 d2        TEST       RDX,RDX
       1c00d291d 74 55           JZ         LAB_1c00d2974
       1c00d291f 48 85 c9        TEST       RCX,RCX
       1c00d2922 74 50           JZ         LAB_1c00d2974
       1c00d2924 4c 89 02        MOV        qword ptr [RDX],R8
       1c00d2927 45 8b c8        MOV        R9D,R8D
                             LAB_1c00d292a                                   XREF[1]:     1c00d2956(j)  
   --> 1c00d292a 49 8b 0a        MOV        RCX,qword ptr [R10]
       1c00d292d 48 8d 05        LEA        RAX,[DAT_1c02df594]                              = 43C51546E2011457h
                 60 cc 20 00
       1c00d2934 45 8b d9        MOV        R11D,R9D
       1c00d2937 49 c1 e3 05     SHL        R11,0x5
       1c00d293b 49 2b 0c 03     SUB        RCX,qword ptr [R11 + RAX*offset DAT_1c02df594]   = 43C51546E2011457h
                                                                                             = 4FBD5D9635138B9Ah
       1c00d293f 75 09           JNZ        LAB_1c00d294a
       1c00d2941 49 8b 4a 08     MOV        RCX,qword ptr [R10 + 0x8]
       1c00d2945 49 2b 4c        SUB        RCX,qword ptr [R11 + RAX*offset DAT_1c02df59c    = F0D3E3EE8D00FEA5h
                 03 08

`````


-----------------------------------------------------------------

case 50

useless

`````shell
DOUBLE FETCH:   cr3 0xb7261000, syscall 0x100a
   eip 0xfffff961a3a73a50, user_address 0x7fff9068e770, user_data 0x4f, modrm 0x2, pc 0xfffff961a3a73adf
   eip 0xfffff961a3b44d40, user_address 0x7fff9068e770, user_data 0x4f, modrm 0x44, pc 0xfffff961a3b44f20
`````

`````shell
memcpy
                             LAB_1c0144f20                                   XREF[1]:     1c0144f2c(j)  
  -->  1c0144f20 8a 44 0a ff     MOV        AL,byte ptr [_Src + _Dst*0x1 + -0x1]
       1c0144f24 48 ff c9        DEC        _Dst
       1c0144f27 49 ff c8        DEC        _Size
       1c0144f2a 88 01           MOV        byte ptr [_Dst],AL
       1c0144f2c 75 f2           JNZ        LAB_1c0144f20

`````


`````shell
       1c0073ac8 75 73           JNZ        LAB_1c0073b3d
       1c0073aca 48 85 d2        TEST       param_2,param_2
       1c0073acd 74 17           JZ         LAB_1c0073ae6
       1c0073acf f6 c2 01        TEST       param_2,0x1
       1c0073ad2 0f 85 c2        JNZ        LAB_1c0073b9a
                 00 00 00
       1c0073ad8 49 3b 12        CMP        param_2,qword ptr [R10]
       1c0073adb 49 0f 43 12     CMOVNC     param_2,qword ptr [R10]
   --> 1c0073adf 8a 02           MOV        AL,byte ptr [param_2]
       1c0073ae1 48 8b 54        MOV        param_2,qword ptr [RSP + local_48[8]]
                 24 78
                             LAB_1c0073ae6                                   XREF[1]:     1c0073acd(j)  
       1c0073ae6 48 8d 8c        LEA        param_1=>local_28,[RSP + 0x90]
                 24 90 00 
                 00 00
       1c0073aee e8 25 01        CALL       FUN_1c0073c18                                    undefined FUN_1c0073c18()
                 00 00

`````

-------------------------------------------


case 51

*** need review

`````shell
DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x5
   eip 0xfffff961a3a6839f, user_address 0x75925d6800, user_data 0x8388, modrm 0x8, pc 0xfffff961a3a68412
   eip 0xfffff961a3a632e5, user_address 0x75925d6800, user_data 0x8388, modrm 0x4, pc 0xfffff961a3a6330a

`````

`````shell
                             LAB_1c006840b                                   XREF[19]:    1c00686d5(j), 1c0069382(j), 
                                                                                          1c006975c(j), 1c00699b9(j), 
                                                                                          1c00699c7(j), 1c0069af0(j), 
                                                                                          1c0069b9b(j), 1c0069c9e(j), 
                                                                                          1c0069dbe(j), 1c016f52f(j), 
                                                                                          1c016f53d(j), 1c016f54b(j), 
                                                                                          1c016f779(j), 1c016f791(j), 
                                                                                          1c016fb18(j), 1c016fb25(j), 
                                                                                          1c016fb32(j), 1c0170a1f(j), 
                                                                                          1c0170e11(j)  
       1c006840b 48 8b 87        MOV        RAX,qword ptr [RDI + 0x1b0]
                 b0 01 00 00
   --> 1c0068412 8b 08           MOV        param_1,dword ptr [RAX]
       1c0068414 48 c1 e9 09     SHR        param_1,0x9
       1c0068418 83 e1 01        AND        param_1,0x1
       1c006841b 89 8c 24        MOV        dword ptr [RSP + local_518],param_1
                 90 01 00 00
       1c0068422 eb 20           JMP        LAB_1c0068444
       1c0068424 48              ??         48h    H

`````


`````shell
                             LAB_1c00632ed                                   XREF[1]:     1c00632e8(j)  
       1c00632ed 4c 8b a7        MOV        R12,qword ptr [RDI + DAT_000001b0]
                 b0 01 00 00
       1c00632f4 83 7b 30 04     CMP        dword ptr [RBX + 0x30],0x4
       1c00632f8 0f 85 6a        JNZ        LAB_1c016e468
                 b1 10 00
       1c00632fe 49 8b be        MOV        RDI,qword ptr [R14 + 0x88]
                 88 00 00 00
       1c0063305 4c 8b 5c        MOV        R11,qword ptr [RSP + local_58]
                 24 50
                             LAB_1c006330a                                   XREF[1]:     1c016e47c(j)  
   --> 1c006330a 49 8b 04 24     MOV        RAX,qword ptr [R12]
       1c006330e 4c 8b f0        MOV        R14,RAX
       1c0063311 41 83 e6 10     AND        R14D,0x10
       1c0063315 4c 89 74        MOV        qword ptr [RSP + local_50],R14
                 24 58
       1c006331a 49 8b 4c        MOV        RCX,qword ptr [R12 + 0x68]
                 24 68
       1c006331f 48 89 4c        MOV        qword ptr [RSP + local_58],RCX
                 24 50
       1c0063324 48 89 4c        MOV        qword ptr [RSP + local_48],RCX
                 24 60
       1c0063329 48 83 bc        CMP        qword ptr [RSP + local_res18],0x0
                 24 c0 00 
                 00 00 00
       1c0063332 75 06           JNZ        LAB_1c006333a
       1c0063334 48 83 e0 ef     AND        RAX,-0x11
       1c0063338 eb 04           JMP        LAB_1c006333e

`````

-------------------------------------------------------


case 52


They all invoked memcpy.

*** need review

`````shell
DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x1087
   eip 0xfffff961a3a47370, user_address 0x1f979a1c130, user_data 0x0, modrm 0x50, pc 0xfffff961a3a473a1
   eip 0xfffff961a3b44d40, user_address 0x1f979a1c130, user_data 0x0, modrm 0x44, pc 0xfffff961a3b44f00

DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x1087
   eip 0xfffff961a3a47370, user_address 0x1f979a1c120, user_data 0x0, modrm 0x40, pc 0xfffff961a3a473a8
   eip 0xfffff961a3b44d40, user_address 0x1f979a1c120, user_data 0x100000000000, modrm 0x44, pc 0xfffff961a3b44f00

DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x1087
   eip 0xfffff961a3a46ed0, user_address 0x1f979a1c110, user_data 0x28, modrm 0x0, pc 0xfffff961a3a46fac
   eip 0xfffff961a3b44d40, user_address 0x1f979a1c110, user_data 0x2000000028, modrm 0x44, pc 0xfffff961a3b44f00

`````



`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c0047370()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1c0047370(W), 
                                                                                                   1c00473f7(R)  
                             FUN_1c0047370                                   XREF[7]:     NtGdiCreateDIBSection:1c004603a(
                                                                                          FUN_1c0046a9c:1c0046b30(c), 
                                                                                          NtGdiGetDIBitsInternal:1c0047006
                                                                                          NtGdiGetDIBitsInternal:1c0047095
                                                                                          FUN_1c01f18ec:1c01f1913(c), 
                                                                                          1c02f4498(*), 1c0333190(*)  
       1c0047370 48 89 5c        MOV        qword ptr [RSP + local_res8],RBX
                 24 08
       1c0047375 33 db           XOR        EBX,EBX
       1c0047377 44 8b c2        MOV        R8D,EDX
       1c004737a 48 8b c1        MOV        RAX,RCX
       1c004737d 48 85 c9        TEST       RCX,RCX
       1c0047380 0f 84 ed        JZ         LAB_1c0047473
                 00 00 00
       1c0047386 44 8b 11        MOV        R10D,dword ptr [RCX]
       1c0047389 44 8d 4b 02     LEA        R9D,[RBX + 0x2]
       1c004738d 41 83 fa 0c     CMP        R10D,0xc
       1c0047391 0f 84 ad        JZ         LAB_1c0166f44
                 fb 11 00
       1c0047397 41 83 fa 28     CMP        R10D,0x28
       1c004739b 0f 82 d2        JC         LAB_1c0047473
                 00 00 00
   --> 1c00473a1 8b 50 20        MOV        EDX,dword ptr [RAX + 0x20]
       1c00473a4 44 8d 5b 04     LEA        R11D,[RBX + 0x4]
   --> 1c00473a8 8b 40 10        MOV        EAX,dword ptr [RAX + 0x10]
       1c00473ab 0f b7 49 0e     MOVZX      ECX,word ptr [RCX + 0xe]
       1c00473af 83 f8 03        CMP        EAX,0x3
       1c00473b2 75 49           JNZ        LAB_1c00473fd
       1c00473b4 41 83 f8 01     CMP        R8D,0x1
       1c00473b8 44 0f 44 c3     CMOVZ      R8D,EBX
       1c00473bc 83 f9 20        CMP        ECX,0x20
       1c00473bf 0f 85 94        JNZ        LAB_1c0166f59
                 fb 11 00

                             LAB_1c00473c5                                   XREF[1]:     1c0166f5c(j)  
       1c00473c5 41 83 fa 28     CMP        R10D,0x28
       1c00473c9 0f 87 a0        JA         LAB_1c004746f
                 00 00 00
       1c00473cf ba 03 00        MOV        EDX,0x3
                 00 00
                             LAB_1c00473d4                                   XREF[2]:     1c0047427(j), 1c004742d(j)  
       1c00473d4 41 83 f8 01     CMP        R8D,0x1
       1c00473d8 74 0a           JZ         LAB_1c00473e4
       1c00473da 45 3b c1        CMP        R8D,R9D
       1c00473dd 44 0f 44 db     CMOVZ      R11D,EBX
       1c00473e1 45 8b cb        MOV        R9D,R11D
                             LAB_1c00473e4                                   XREF[1]:     1c00473d8(j)  
       1c00473e4 41 0f af d1     IMUL       EDX,R9D
       1c00473e8 41 8d 42 03     LEA        EAX,[R10 + 0x3]
       1c00473ec 03 c2           ADD        EAX,EDX
       1c00473ee 83 e0 fc        AND        EAX,0xfffffffc
       1c00473f1 41 3b c2        CMP        EAX,R10D
       1c00473f4 0f 42 c3        CMOVC      EAX,EBX
                             LAB_1c00473f7                                   XREF[2]:     1c004743e(j), 1c0047475(j)  
       1c00473f7 48 8b 5c        MOV        RBX,qword ptr [RSP + local_res8]
                 24 08
       1c00473fc c3              RET


`````

probe
`````shell
       1c0046f90 4c 89 a4        MOV        qword ptr [RSP + local_88],R12
                 24 a0 00 
                 00 00
       1c0046f98 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 59 a6 30 00
       1c0046f9f 48 8b 08        MOV        param_1,qword ptr [RAX]
       1c0046fa2 49 8b c7        MOV        RAX,R15
       1c0046fa5 4c 3b f9        CMP        R15,param_1
       1c0046fa8 48 0f 43 c1     CMOVNC     RAX,param_1
   --> 1c0046fac 8a 00           MOV        AL,byte ptr [RAX]
       1c0046fae 41 8b 37        MOV        ESI,dword ptr [R15]
       1c0046fb1 8b d6           MOV        param_2,ESI
       1c0046fb3 49 8b cf        MOV        param_1,R15
       1c0046fb6 ff 15 3c        CALL       qword ptr [->NTOSKRNL.EXE::ProbeForWrite]
                 7a 30 00
       1c0046fbc 4d 85 e4        TEST       R12,R12
       1c0046fbf 0f 85 f0        JNZ        LAB_1c00471b5
                 01 00 00

`````

`````shell
memcpy

                             LAB_1c0144eee                                   XREF[1]:     1c0144d46(j)  
       1c0144eee 49 03 c8        ADD        _Dst,_Size
       1c0144ef1 49 83 f8 4f     CMP        _Size,0x4f
       1c0144ef5 73 4f           JNC        LAB_1c0144f46
                             LAB_1c0144ef7                                   XREF[2]:     1c0144f9e(j), 1c0145074(j)  
       1c0144ef7 4d 8b c8        MOV        R9,_Size
       1c0144efa 49 c1 e9 03     SHR        R9,0x3
       1c0144efe 74 11           JZ         LAB_1c0144f11
                             LAB_1c0144f00                                   XREF[1]:     1c0144f0f(j)  
   --> 1c0144f00 48 8b 44        MOV        RAX,qword ptr [_Src + _Dst*0x1 + -0x8]
                 0a f8
       1c0144f05 48 83 e9 08     SUB        _Dst,0x8
       1c0144f09 49 ff c9        DEC        R9
       1c0144f0c 48 89 01        MOV        qword ptr [_Dst],RAX
       1c0144f0f 75 ef           JNZ        LAB_1c0144f00
                             LAB_1c0144f11                                   XREF[1]:     1c0144efe(j)  
       1c0144f11 49 83 e0 07     AND        _Size,0x7
       1c0144f15 74 17           JZ         LAB_1c0144f2e
       1c0144f17 66 0f 1f        NOP        word ptr [RAX + RAX*0x1]
                 84 00 00 
                 00 00 00

`````

------------------------------------------------------------

case 53

`````shell
DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x1087
   eip 0xfffff961a3a46f87, user_address 0x1f978d80030, user_data 0x28, modrm 0x0, pc 0xfffff961a3a46fac
   eip 0xfffff961a3a47370, user_address 0x1f978d80030, user_data 0x28, modrm 0x11, pc 0xfffff961a3a47386
`````

`````shell
       1c0046f90 4c 89 a4        MOV        qword ptr [RSP + local_88],R12
                 24 a0 00 
                 00 00
       1c0046f98 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 59 a6 30 00
       1c0046f9f 48 8b 08        MOV        param_1,qword ptr [RAX]
       1c0046fa2 49 8b c7        MOV        RAX,R15
       1c0046fa5 4c 3b f9        CMP        R15,param_1
       1c0046fa8 48 0f 43 c1     CMOVNC     RAX,param_1
   --> 1c0046fac 8a 00           MOV        AL,byte ptr [RAX]
   --> 1c0046fae 41 8b 37        MOV        ESI,dword ptr [R15]
       1c0046fb1 8b d6           MOV        param_2,ESI
       1c0046fb3 49 8b cf        MOV        param_1,R15
       1c0046fb6 ff 15 3c        CALL       qword ptr [->NTOSKRNL.EXE::ProbeForWrite]
                 7a 30 00
       1c0046fbc 4d 85 e4        TEST       R12,R12
       1c0046fbf 0f 85 f0        JNZ        LAB_1c00471b5
                 01 00 00
       1c0046fc5 44 8d 77 0c     LEA        R14D,[RDI + 0xc]
       1c0046fc9 41 3b f6        CMP        ESI,R14D
       1c0046fcc 0f 84 f2        JZ         LAB_1c00471c4
                 01 00 00
                             LAB_1c0046fd2                                   XREF[1]:     1c00471c9(j)  
       1c0046fd2 bb 28 00        MOV        EBX,0x28
                 00 00
       1c0046fd7 44 8b 74        MOV        R14D,dword ptr [RSP + local_d8]
                 24 50
       1c0046fdc 3b f3           CMP        ESI,EBX
       1c0046fde 72 0e           JC         LAB_1c0046fee
       1c0046fe0 66 41 39        CMP        word ptr [R15 + 0xe],DI
                 7f 0e
       1c0046fe5 44 0f 44 f3     CMOVZ      R14D,EBX
       1c0046fe9 44 89 74        MOV        dword ptr [RSP + local_d8],R14D
                 24 50
                             LAB_1c0046fee                                   XREF[2]:     1c0046fde(j), 1c00471bf(j)  
       1c0046fee 45 85 f6        TEST       R14D,R14D
       1c0046ff1 0f 85 1e        JNZ        LAB_1c0047115
                 01 00 00
       1c0046ff7 41 39 1f        CMP        dword ptr [R15],EBX
       1c0046ffa 75 04           JNZ        LAB_1c0047000
       1c0046ffc 41 89 7f 20     MOV        dword ptr [R15 + 0x20],EDI
                             LAB_1c0047000                                   XREF[1]:     1c0046ffa(j)  
       1c0047000 41 8b d5        MOV        param_2,R13D
       1c0047003 49 8b cf        MOV        param_1,R15
       1c0047006 e8 65 03        CALL       FUN_1c0047370                                    undefined FUN_1c0047370()
                 00 00
       1c004700b 44 8b f0        MOV        R14D,EAX
       1c004700e 44 89 74        MOV        dword ptr [RSP + local_d8],R14D
                 24 50
       1c0047013 85 c0           TEST       EAX,EAX
       1c0047015 0f 84 15        JZ         LAB_1c0047130
                 01 00 00
       1c004701b 48 89 bc        MOV        qword ptr [RSP + local_a0],RDI
                 24 88 00 
                 00 00
       1c0047023 ba 47 74        MOV        param_2,0x706d7447
                 6d 70
       1c0047028 41 8b ce        MOV        param_1,R14D
       1c004702b ff 15 7f        CALL       qword ptr [->WIN32KBASE.SYS::Win32AllocPool]
                 a6 30 00

`````


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c0047370()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1c0047370(W), 
                                                                                                   1c00473f7(R)  
                             FUN_1c0047370                                   XREF[7]:     NtGdiCreateDIBSection:1c004603a(
                                                                                          FUN_1c0046a9c:1c0046b30(c), 
                                                                                          NtGdiGetDIBitsInternal:1c0047006
                                                                                          NtGdiGetDIBitsInternal:1c0047095
                                                                                          FUN_1c01f18ec:1c01f1913(c), 
                                                                                          1c02f4498(*), 1c0333190(*)  
       1c0047370 48 89 5c        MOV        qword ptr [RSP + local_res8],RBX
                 24 08
       1c0047375 33 db           XOR        EBX,EBX
       1c0047377 44 8b c2        MOV        R8D,EDX
       1c004737a 48 8b c1        MOV        RAX,RCX
       1c004737d 48 85 c9        TEST       RCX,RCX
       1c0047380 0f 84 ed        JZ         LAB_1c0047473
                 00 00 00
   --> 1c0047386 44 8b 11        MOV        R10D,dword ptr [RCX]
       1c0047389 44 8d 4b 02     LEA        R9D,[RBX + 0x2]
       1c004738d 41 83 fa 0c     CMP        R10D,0xc
       1c0047391 0f 84 ad        JZ         LAB_1c0166f44
                 fb 11 00
       1c0047397 41 83 fa 28     CMP        R10D,0x28
       1c004739b 0f 82 d2        JC         LAB_1c0047473
                 00 00 00
   x   1c00473a1 8b 50 20        MOV        EDX,dword ptr [RAX + 0x20]
       1c00473a4 44 8d 5b 04     LEA        R11D,[RBX + 0x4]
   x   1c00473a8 8b 40 10        MOV        EAX,dword ptr [RAX + 0x10]
       1c00473ab 0f b7 49 0e     MOVZX      ECX,word ptr [RCX + 0xe]
       1c00473af 83 f8 03        CMP        EAX,0x3
       1c00473b2 75 49           JNZ        LAB_1c00473fd
       1c00473b4 41 83 f8 01     CMP        R8D,0x1
       1c00473b8 44 0f 44 c3     CMOVZ      R8D,EBX
       1c00473bc 83 f9 20        CMP        ECX,0x20
       1c00473bf 0f 85 94        JNZ        LAB_1c0166f59
                 fb 11 00

                             LAB_1c00473c5                                   XREF[1]:     1c0166f5c(j)  
       1c00473c5 41 83 fa 28     CMP        R10D,0x28
       1c00473c9 0f 87 a0        JA         LAB_1c004746f
                 00 00 00
       1c00473cf ba 03 00        MOV        EDX,0x3
                 00 00
                             LAB_1c00473d4                                   XREF[2]:     1c0047427(j), 1c004742d(j)  
       1c00473d4 41 83 f8 01     CMP        R8D,0x1
       1c00473d8 74 0a           JZ         LAB_1c00473e4
       1c00473da 45 3b c1        CMP        R8D,R9D
       1c00473dd 44 0f 44 db     CMOVZ      R11D,EBX
       1c00473e1 45 8b cb        MOV        R9D,R11D
                             LAB_1c00473e4                                   XREF[1]:     1c00473d8(j)  
       1c00473e4 41 0f af d1     IMUL       EDX,R9D
       1c00473e8 41 8d 42 03     LEA        EAX,[R10 + 0x3]
       1c00473ec 03 c2           ADD        EAX,EDX
       1c00473ee 83 e0 fc        AND        EAX,0xfffffffc
       1c00473f1 41 3b c2        CMP        EAX,R10D
       1c00473f4 0f 42 c3        CMOVC      EAX,EBX
                             LAB_1c00473f7                                   XREF[2]:     1c004743e(j), 1c0047475(j)  
       1c00473f7 48 8b 5c        MOV        RBX,qword ptr [RSP + local_res8]
                 24 08
       1c00473fc c3              RET


`````
