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
