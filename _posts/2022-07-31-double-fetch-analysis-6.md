---
title: Double fetch, case 63 - case 98
published: true
---

case 63

0xfffff800a moudle again. Saved for later.

`````shell
DOUBLE FETCH:   cr3 0x12cd41000, syscall 0x7
   eip 0xfffff800a2772a3e, user_address 0x1c4597f0a0, user_data 0x6, modrm 0x1, pc 0xfffff800a2772a5f
   eip 0xfffff800a2772a3e, user_address 0x1c4597f0a0, user_data 0x6, modrm 0x6, pc 0xfffff800a2772a8e
`````

----------------------------------------------------------------


case 64


`````shell
DOUBLE FETCH:   cr3 0x12cd41000, syscall 0xa9
   eip 0xfffff80179d0ecec, user_address 0x1c4597f410, user_data 0xe0, modrm 0x1, pc 0xfffff80179d0ed57
   eip 0xfffff80179d0ecec, user_address 0x1c4597f410, user_data 0xfffffffffff85ee0, modrm 0x2, pc 0xfffff80179d0ed59

`````


`````shell
                             LAB_140484d45                                   XREF[1]:     140484d3e(j)  
       140484d45 48 8b ca        MOV        RCX,RDX
       140484d48 48 3b 15        CMP        RDX,qword ptr [MmUserProbeAddress]               = ??
                 b1 a4 ef ff
       140484d4f 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d a9 a4 
                 ef ff
   --> 140484d57 8a 01           MOV        AL,byte ptr [RCX]
   --> 140484d59 48 8b 02        MOV        RAX,qword ptr [RDX]
       140484d5c 48 89 84        MOV        qword ptr [RSP + 0x88],RAX
                 24 88 00 
                 00 00
       140484d64 eb 05           JMP        LAB_140484d6b

`````

--------------------------------------------------------------------

case 65


***

Need review.

This is could be a "size".

`````shell
DOUBLE FETCH:   cr3 0x1236c3000, syscall 0x135b
   eip 0xfffff961a3aa9630, user_address 0x2189edf5c8, user_data 0xe0, modrm 0x41, pc 0xfffff961a3aa9686
   eip 0xfffff80179c73515, user_address 0x2189edf5c8, user_data 0xe0, modrm 0x40, pc 0xfffff80179c730df
`````

`````shell
       1403e90b1 84 c9           TEST       param_1,param_1
       1403e90b3 74 20           JZ         LAB_1403e90d5
       1403e90b5 49 8b c8        MOV        param_1,param_3
       1403e90b8 41 f6 c0 07     TEST       param_3,0x7
       1403e90bc 0f 85 c1        JNZ        LAB_1403e9183
                 00 00 00
       1403e90c2 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 37 61 f9 ff
       1403e90c9 4c 3b c0        CMP        param_3,RAX
       1403e90cc 0f 83 b6        JNC        LAB_1403e9188
                 00 00 00
                             LAB_1403e90d2                                   XREF[1]:     1403e918b(j)
       1403e90d2 0f b6 01        MOVZX      EAX,byte ptr [param_1]
                             LAB_1403e90d5                                   XREF[2]:     1403e9098(j), 1403e90b3(j)
       1403e90d5 41 83 38 30     CMP        dword ptr [param_3],0x30
       1403e90d9 0f 85 b1        JNZ        LAB_1403e9190
                 00 00 00
   --> 1403e90df 49 8b 40 08     MOV        RAX,qword ptr [param_3 + 0x8]
       1403e90e3 48 89 43 08     MOV        qword ptr [RBX + 0x8],RAX
       1403e90e7 41 8b 40 18     MOV        EAX,dword ptr [param_3 + 0x18]
       1403e90eb 89 44 24 48     MOV        dword ptr [RSP + local_50],EAX
       1403e90ef 84 d2           TEST       param_2,param_2
       1403e90f1 74 08           JZ         LAB_1403e90fb
       1403e90f3 0f ba f0 09     BTR        EAX,0x9
       1403e90f7 89 44 24 48     MOV        dword ptr [RSP + local_50],EAX

`````

`````shell
       1c00a9676 83 8c 24        OR         dword ptr [RSP + local_130],0xffffffff
                 a8 00 00 
                 00 ff
       1c00a967e 44 21 a4        AND        dword ptr [RSP + local_118],R12D
                 24 c0 00 
                 00 00
   --> 1c00a9686 48 8b 41 08     MOV        RAX,qword ptr [param_1 + 0x8]
       1c00a968a 49 89 83        MOV        qword ptr [R11 + local_100],RAX
                 00 ff ff ff
       1c00a9691 49 89 83        MOV        qword ptr [R11 + local_90],RAX
                 70 ff ff ff
       1c00a9698 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::gSessionId]     = 00357cdc
                 e9 7f 2a 00
       1c00a969f 8b 08           MOV        param_1,dword ptr [RAX]
       1c00a96a1 89 8c 24        MOV        dword ptr [RSP + local_d8],param_1
                 00 01 00 00
       1c00a96a8 44 89 8c        MOV        dword ptr [RSP + local_d4],param_4
                 24 04 01 
                 00 00

`````

--------------------------------------------------------------


case 66



This is case 32.


What if an address is below [W32UserProbeAddress], but [address+0x20] will cross the line.

It is still inside the [W32UserProbeAddress] page, so it probably still will be try-catched.


`````shell
DOUBLE FETCH:   cr3 0xb7261000, syscall 0x12dd
   eip 0xfffff961a3dc59e0, user_address 0x40f37b8000, user_data 0x0, modrm 0x2, pc 0xfffff961a3dc59f5
   eip 0xfffff961a3a9b389, user_address 0x40f37b8000, user_data 0x0, modrm 0x0, pc 0xfffff961a3a9b3fd

DOUBLE FETCH:   cr3 0xb7261000, syscall 0x12dd
   eip 0xfffff961a3dc59e0, user_address 0x40f37b8020, user_data 0x1c957e029e0, modrm 0x48, pc 0xfffff961a3dc59f7
   eip 0xfffff961a3a9b389, user_address 0x40f37b8020, user_data 0x1c957e029e0, modrm 0x55, pc 0xfffff961a3a9b3ff

DOUBLE FETCH:   cr3 0xb7261000, syscall 0x12dd
   eip 0xfffff961a3dc59e0, user_address 0x1c957e029e0, user_data 0x1c, modrm 0x1, pc 0xfffff961a3dc5a1c
   eip 0xfffff961a3a9b389, user_address 0x1c957e029e0, user_data 0x1c, modrm 0x0, pc 0xfffff961a3a9b417

`````


`````shell
win32kbase.sys

       1c00359d7 48 8b ce        MOV        RCX,RSI
       1c00359da ff 15 60        CALL       qword ptr [->NTOSKRNL.EXE::PsGetProcessPeb]
                 58 0e 00
       1c00359e0 4c 8b c0        MOV        R8,RAX
       1c00359e3 48 8b d0        MOV        RDX,RAX
       1c00359e6 48 3b 05        CMP        RAX,qword ptr [W32UserProbeAddress]              = ??
                 d3 ea 0c 00
       1c00359ed 48 0f 43        CMOVNC     RDX,qword ptr [W32UserProbeAddress]              = ??
                 15 cb ea 
                 0c 00
   --> 1c00359f5 8a 02           MOV        AL,byte ptr [RDX]
   --> 1c00359f7 49 8b 48 20     MOV        RCX,qword ptr [R8 + 0x20]
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
       1c0035a3b 89 45 40        MOV        dword ptr [RBP + local_140],EAX
       1c0035a3e 8b 81 8c        MOV        EAX,dword ptr [RCX + 0x8c]
                 00 00 00

`````

`````shell
                             LAB_1c009b3d3                                   XREF[1]:     1c009b396(j)  
       1c009b3d3 48 8b 93        MOV        RDX,qword ptr [RBX + 0x1c0]
                 c0 01 00 00
       1c009b3da 41 bf 01        MOV        R15D,0x1
                 00 00 00
       1c009b3e0 48 85 d2        TEST       RDX,RDX
       1c009b3e3 0f 85 92        JNZ        LAB_1c009b47b
                 00 00 00
       1c009b3e9 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 08 62 2b 00
       1c009b3f0 48 8b 08        MOV        RCX,qword ptr [RAX]
       1c009b3f3 49 8b c5        MOV        RAX,R13
       1c009b3f6 4c 3b e9        CMP        R13,RCX
       1c009b3f9 48 0f 43 c1     CMOVNC     RAX,RCX
   --> 1c009b3fd 8a 00           MOV        AL,byte ptr [RAX]
   --> 1c009b3ff 49 8b 55 20     MOV        RDX,qword ptr [R13 + 0x20]
       1c009b403 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 ee 61 2b 00
       1c009b40a 48 8b 08        MOV        RCX,qword ptr [RAX]
       1c009b40d 48 8b c2        MOV        RAX,RDX
       1c009b410 48 3b d1        CMP        RDX,RCX
       1c009b413 48 0f 43 c1     CMOVNC     RAX,RCX
   --> 1c009b417 8a 00           MOV        AL,byte ptr [RAX]
       1c009b419 48 83 c2 60     ADD        RDX,0x60
       1c009b41d 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 d4 61 2b 00
       1c009b424 48 3b 10        CMP        RDX,qword ptr [RAX]
       1c009b427 48 0f 43 10     CMOVNC     RDX,qword ptr [RAX]
       1c009b42b 44 8b 0a        MOV        R9D,dword ptr [RDX]
       1c009b42e 44 89 4c        MOV        dword ptr [RSP + local_218],R9D
                 24 50
       1c009b433 44 89 4c        MOV        dword ptr [RSP + local_200],R9D
                 24 68
       1c009b438 4c 8b 42 08     MOV        R8,qword ptr [RDX + 0x8]
       1c009b43c 4c 89 44        MOV        qword ptr [RSP + local_1f8],R8
                 24 70
       1c009b441 45 84 c7        TEST       R15B,R8B
       1c009b444 74 06           JZ         LAB_1c009b44c
       1c009b446 ff 15 2c        CALL       qword ptr [->NTOSKRNL.EXE::ExRaiseDatatypeMisa
                 36 2b 00

`````

-------------------------------------------------------

case 67

`````shell
DOUBLE FETCH:   cr3 0x10e3e8000, syscall 0x75
   eip 0xfffff80179d32e78, user_address 0x8e12cfed80, user_data 0xf0, modrm 0x1, pc 0xfffff80179d32e28
   eip 0xfffff80179d32e78, user_address 0x8e12cfed80, user_data 0xf0, modrm 0x1, pc 0xfffff80179d32e42
`````

`````shell
                             LAB_1404a8e16                                   XREF[1]:     1404a8dad(j)  
       1404a8e16 49 8b ce        MOV        param_1,R14
       1404a8e19 4c 3b 35        CMP        R14,qword ptr [MmUserProbeAddress]               = ??
                 e0 63 ed ff
       1404a8e20 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d d8 63 
                 ed ff
   --> 1404a8e28 48 8b 01        MOV        RAX,qword ptr [param_1]
       1404a8e2b 48 89 44        MOV        qword ptr [RSP + local_a0],RAX
                 24 68
       1404a8e30 49 8b ce        MOV        param_1,R14
       1404a8e33 4c 3b 35        CMP        R14,qword ptr [MmUserProbeAddress]               = ??
                 c6 63 ed ff
       1404a8e3a 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d be 63 
                 ed ff
   --> 1404a8e42 48 8b 01        MOV        RAX,qword ptr [param_1]
       1404a8e45 48 89 01        MOV        qword ptr [param_1],RAX
       1404a8e48 44 8b 6c        MOV        R13D,dword ptr [RSP + local_b4]
                 24 54
       1404a8e4d 48 8b 74        MOV        RSI,qword ptr [RSP + local_a0]
                 24 68
       1404a8e52 48 89 74        MOV        qword ptr [RSP + local_b0],RSI
                 24 58
       1404a8e57 33 f6           XOR        ESI,ESI
       1404a8e59 e9 51 ff        JMP        LAB_1404a8daf
                 ff ff

`````

----------------------------------------------------------------

case 68

module 800a unknown

`````shell
DOUBLE FETCH:   cr3 0x10e3e8000, syscall 0x8
   eip 0xfffff800a1a28880, user_address 0x8e12cfef75, user_data 0x3, modrm 0x44, pc 0xfffff800a1a28a60
   eip 0xfffff801799d7780, user_address 0x8e12cfef75, user_data 0x3, modrm 0x44, pc 0xfffff801799d7960
`````


-------------------------------------------------------------------


case 69

useless

`````shell
DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x100a
   eip 0xfffff961a3a73980, user_address 0x1f97a4f077c, user_data 0x57, modrm 0x1, pc 0xfffff961a3a739ba
   eip 0xfffff961a3b44d40, user_address 0x1f97a4f077c, user_data 0x64006e00690057, modrm 0x44, pc 0xfffff961a3b44f00
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

`````shell
       1c00739a4 75 28           JNZ        LAB_1c00739ce
       1c00739a6 41 f6 c1 01     TEST       param_4,0x1
       1c00739aa 75 44           JNZ        LAB_1c00739f0
       1c00739ac 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 45 dc 2d 00
       1c00739b3 4c 3b 08        CMP        param_4,qword ptr [RAX]
       1c00739b6 4c 0f 43 08     CMOVNC     param_4,qword ptr [RAX]
   --> 1c00739ba 41 8a 01        MOV        AL,byte ptr [param_4]
       1c00739bd 48 8b 54        MOV        param_2,qword ptr [RSP + local_res20]
                 24 78
       1c00739c2 48 8d 4c        LEA        param_1=>local_20,[RSP + 0x38]
                 24 38
       1c00739c7 e8 4c 02        CALL       FUN_1c0073c18                                    undefined FUN_1c0073c18()
                 00 00
       1c00739cc eb 28           JMP        LAB_1c00739f6

`````
-------------------------------------------------------------------------

case 70


`````shell
DOUBLE FETCH:   cr3 0x121cb7000, syscall 0x2
   eip 0xfffff80179d30bf5, user_address 0x248e4c08fa8, user_data 0x18, modrm 0x1, pc 0xfffff80179d30c81
   eip 0xfffff80179d30bf5, user_address 0x248e4c08fa8, user_data 0x18, modrm 0x1, pc 0xfffff80179d30ca6
`````

`````shell
                             LAB_1404a6c6f                                   XREF[1]:     1404a6c50(j)  
       1404a6c6f 48 8b cb        MOV        param_1,RBX
       1404a6c72 48 3b 1d        CMP        RBX,qword ptr [MmUserProbeAddress]               = ??
                 87 85 ed ff
       1404a6c79 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d 7f 85 
                 ed ff
   --> 1404a6c81 8b 01           MOV        EAX,dword ptr [param_1]
       1404a6c83 83 f8 18        CMP        EAX,0x18
       1404a6c86 0f 85 a9        JNZ        LAB_1404a6d35
                 00 00 00
       1404a6c8c f6 c3 03        TEST       BL,0x3
       1404a6c8f 0f 85 aa        JNZ        LAB_1404a6d3f
                 00 00 00
       1404a6c95 48 8b cb        MOV        param_1,RBX
       1404a6c98 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 61 85 ed ff
       1404a6c9f 48 3b d8        CMP        RBX,RAX
       1404a6ca2 48 0f 43 c8     CMOVNC     param_1,RAX
   --> 1404a6ca6 8a 01           MOV        AL,byte ptr [param_1]
       1404a6ca8 88 01           MOV        byte ptr [param_1],AL
       1404a6caa 8a 41 17        MOV        AL,byte ptr [param_1 + 0x17]
       1404a6cad 88 41 17        MOV        byte ptr [param_1 + 0x17],AL
       1404a6cb0 e9 8f 00        JMP        LAB_1404a6d44
                 00 00

`````
-------------------------------------------------------

case 71

***

need review

syscall 0xb4 NtCreateTimer


0xfffff80179c730e7 also appears in case 35

````shell
DOUBLE FETCH:   cr3 0x123ebd000, syscall 0xb4
   eip 0xfffff80179c9102b, user_address 0x1790c7f730, user_data 0x200, modrm 0x44, pc 0xfffff80179c910cf
   eip 0xfffff80179c73030, user_address 0x1790c7f730, user_data 0x200, modrm 0x40, pc 0xfffff80179c730e7

````

0xfffff80179c910cf - 0xfffff80179c730e7 = 1DFE8


1403e90e7 - 1404070cf = 1DFE8


`````shell
                             LAB_1404070cc                                   XREF[1]:     1404070ef(j)  
       1404070cc 0f b6 01        MOVZX      EAX,byte ptr [param_1]
                             LAB_1404070cf                                   XREF[1]:     1404070b5(j)  
   --> 1404070cf 41 8b 44        MOV        EAX,dword ptr [R12 + 0x18]
                 24 18
       1404070d4 45 84 c9        TEST       param_4,param_4
       1404070d7 75 07           JNZ        LAB_1404070e0
       1404070d9 25 f2 1f        AND        EAX,0x11ff2
                 01 00
       1404070de eb 11           JMP        LAB_1404070f1
                             LAB_1404070e0                                   XREF[1]:     1404070d7(j)  
       1404070e0 25 f2 1d        AND        EAX,0x1df2
                 00 00
       1404070e5 eb 0a           JMP        LAB_1404070f1

`````


`````shell
       1403e90c2 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 37 61 f9 ff
       1403e90c9 4c 3b c0        CMP        param_3,RAX
       1403e90cc 0f 83 b6        JNC        LAB_1403e9188
                 00 00 00
                             LAB_1403e90d2                                   XREF[1]:     1403e918b(j)  
       1403e90d2 0f b6 01        MOVZX      EAX,byte ptr [param_1]
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

---------------------------------------------------

case 72


useless, most 8a 01 are useless.

They are usually part of MmUserProbeAddress check. 


CMP        R8,qword ptr [MmUserProbeAddress]                = ??
CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
MOV        AL,byte ptr [RCX]


`````shell
DOUBLE FETCH:   cr3 0x11067e000, syscall 0xd6
   eip 0xfffff80179ce371f, user_address 0x2c596ed3890, user_data 0xa, modrm 0x1, pc 0xfffff80179ce3731
   eip 0xfffff80179ce371f, user_address 0x2c596ed3890, user_data 0xa, modrm 0x10, pc 0xfffff80179ce3733

`````

`````shell
       14045970c 4d 85 c0        TEST       R8,R8
       14045970f 0f 84 be        JZ         LAB_1404597d3
                 00 00 00
       140459715 41 f6 c0 03     TEST       R8B,0x3
       140459719 0f 85 af        JNZ        LAB_1404597ce
                 00 00 00
       14045971f 49 8b c8        MOV        RCX,R8
       140459722 4c 3b 05        CMP        R8,qword ptr [MmUserProbeAddress]                = ??
                 d7 5a f2 ff
       140459729 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d cf 5a 
                 f2 ff
   --> 140459731 8a 01           MOV        AL,byte ptr [RCX]
   --> 140459733 41 8b 10        MOV        EDX,dword ptr [R8]
       140459736 89 54 24 6c     MOV        dword ptr [RSP + 0x6c],EDX
       14045973a 49 8d 48 08     LEA        RCX,[R8 + 0x8]
       14045973e 48 8d 44        LEA        RAX,[RSP + 0x74]
                 24 74
       140459743 48 89 44        MOV        qword ptr [RSP + 0x40],RAX
                 24 40
       140459748 48 8d 44        LEA        RAX,[RSP + 0x78]
                 24 78
       14045974d 48 89 44        MOV        qword ptr [RSP + 0x38],RAX
                 24 38
       140459752 89 5c 24 20     MOV        dword ptr [RSP + 0x20],EBX
       140459756 45 33 c9        XOR        R9D,R9D
       140459759 44 8a c6        MOV        R8B,SIL
       14045975c e8 cf fe        CALL       FUN_1404a9630                                    undefined FUN_1404a9630(undefine
                 04 00

`````



case 73

***

need review

Two set of code are very similar.


`````shell
DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x1203
   eip 0xfffff80179cb67ca, user_address 0x7fff8a8e0148, user_data 0x27b124, modrm 0x48, pc 0xfffff80179cb67cf
   eip 0xfffff80179cb660e, user_address 0x7fff8a8e0148, user_data 0x27b124, modrm 0x48, pc 0xfffff80179cb6613

DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x1203
   eip 0xfffff80179cb67ca, user_address 0x7fff8a8e00f8, user_data 0x5632d3d0, modrm 0x48, pc 0xfffff80179cb67d6
   eip 0xfffff80179cb660e, user_address 0x7fff8a8e00f8, user_data 0x5632d3d0, modrm 0x48, pc 0xfffff80179cb661a

DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x1203
   eip 0xfffff80179cb67ca, user_address 0x7fff8a8e0120, user_data 0x7fff8a8e0000, modrm 0x40, pc 0xfffff80179cb67dd
   eip 0xfffff80179cb660e, user_address 0x7fff8a8e0120, user_data 0x7fff8a8e0000, modrm 0x40, pc 0xfffff80179cb6621
`````


`````shell
       14042c5f6 8b 84 24        MOV        EAX,dword ptr [RSP + param_8]
                 38 01 00 00
       14042c5fd 88 44 24 6d     MOV        byte ptr [RSP + local_8b],AL
       14042c601 45 85 f6        TEST       R14D,R14D
       14042c604 74 2d           JZ         LAB_14042c633
       14042c606 48 8b ce        MOV        param_1,RSI
       14042c609 e8 9a ab        CALL       RtlImageNtHeader                                 undefined RtlImageNtHeader()
                 c5 ff
       14042c60e 48 85 c0        TEST       RAX,RAX
       14042c611 74 17           JZ         LAB_14042c62a
   --1 14042c613 8b 48 58        MOV        param_1,dword ptr [RAX + 0x58]
       14042c616 89 4c 24 64     MOV        dword ptr [RSP + local_94],param_1
   --2 14042c61a 8b 48 08        MOV        param_1,dword ptr [RAX + 0x8]
       14042c61d 89 4c 24 68     MOV        dword ptr [RSP + local_90],param_1
   --3 14042c621 48 8b 40 30     MOV        RAX,qword ptr [RAX + 0x30]
       14042c625 48 89 44        MOV        qword ptr [RSP + local_88],RAX
                 24 70

`````


`````shell
       14042c79d 49 89 5b a0     MOV        qword ptr [R11 + local_60],RBX
       14042c7a1 49 89 5b a8     MOV        qword ptr [R11 + local_58],RBX
       14042c7a5 49 89 5b 8c     MOV        qword ptr [R11 + local_74],RBX
       14042c7a9 49 89 5b 98     MOV        qword ptr [R11 + local_68],RBX
       14042c7ad 41 8b 10        MOV        EDX,dword ptr [R8]
       14042c7b0 8b c2           MOV        EAX,EDX
       14042c7b2 c1 e8 0c        SHR        EAX,0xc
       14042c7b5 24 0f           AND        AL,0xf
       14042c7b7 88 44 24 5c     MOV        byte ptr [RSP + local_6c],AL
       14042c7bb c1 ea 10        SHR        EDX,0x10
       14042c7be 80 e2 07        AND        DL,0x7
       14042c7c1 88 54 24 5d     MOV        byte ptr [RSP + local_6b],DL
       14042c7c5 e8 de a9        CALL       RtlImageNtHeader                                 undefined RtlImageNtHeader()
                 c5 ff
       14042c7ca 48 85 c0        TEST       RAX,RAX
       14042c7cd 74 17           JZ         LAB_14042c7e6
   --1 14042c7cf 8b 48 58        MOV        ECX,dword ptr [RAX + 0x58]
       14042c7d2 89 4c 24 54     MOV        dword ptr [RSP + local_74],ECX
   --2 14042c7d6 8b 48 08        MOV        ECX,dword ptr [RAX + 0x8]
       14042c7d9 89 4c 24 58     MOV        dword ptr [RSP + local_74+0x4],ECX
   --3 14042c7dd 48 8b 40 30     MOV        RAX,qword ptr [RAX + 0x30]
       14042c7e1 48 89 44        MOV        qword ptr [RSP + local_68],RAX
                 24 60
                             LAB_14042c7e6                                   XREF[1]:     14042c7cd(j)  
       14042c7e6 eb 07           JMP        LAB_14042c7ef
       14042c7e8 33 db           XOR        EBX,EBX
       14042c7ea 48 8b 7c        MOV        RDI,qword ptr [RSP + 0x30]
                 24 30

`````


------------------------------

case 74


useless

`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0xbb
   eip 0xfffff80179cab197, user_address 0x44127febe0, user_data 0xc1, modrm 0x1, pc 0xfffff80179cab4da
   eip 0xfffff80179cab197, user_address 0x44127febe0, user_data 0x8eacedc1, modrm 0x11, pc 0xfffff80179cab4e9

`````


`````shell
       1404214bd 45 84 ed        TEST       R13B,R13B
       1404214c0 74 27           JZ         LAB_1404214e9
       1404214c2 41 84 c8        TEST       R8B,CL
       1404214c5 0f 85 5b        JNZ        LAB_140421a26
                 05 00 00
       1404214cb 48 3b 0d        CMP        RCX,qword ptr [MmUserProbeAddress]               = ??
                 2e dd f5 ff
       1404214d2 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 26 dd 
                 f5 ff
   --> 1404214da 8a 01           MOV        AL,byte ptr [RCX]
       1404214dc 48 8b 5c        MOV        RBX,qword ptr [RSP + local_100]
                 24 28
       1404214e1 48 8b 8c        MOV        RCX,qword ptr [RSP + local_98]
                 24 90 00 
                 00 00
                             LAB_1404214e9                                   XREF[1]:     1404214c0(j)  
   --> 1404214e9 8b 11           MOV        EDX,dword ptr [RCX]
       1404214eb f6 c2 1c        TEST       DL,0x1c
       1404214ee 0f 85 37        JNZ        LAB_140421a2b
                 05 00 00

`````

-----------------------------------------

case 75


useless

`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0xbb
   eip 0xfffff80179cab651, user_address 0x44127fec20, user_data 0x1, modrm 0x1, pc 0xfffff80179cab660
   eip 0xfffff80179cab651, user_address 0x44127fec20, user_data 0x1, modrm 0x1, pc 0xfffff80179cab66f
`````


`````shell
       140421643 45 84 ed        TEST       R13B,R13B
       140421646 74 27           JZ         LAB_14042166f
       140421648 41 84 c8        TEST       R8B,CL
       14042164b 0f 85 e4        JNZ        LAB_140421a35
                 03 00 00
       140421651 48 3b 0d        CMP        RCX,qword ptr [MmUserProbeAddress]               = ??
                 a8 db f5 ff
       140421658 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d a0 db 
                 f5 ff
   --> 140421660 8a 01           MOV        AL,byte ptr [RCX]
       140421662 48 8b 5c        MOV        RBX,qword ptr [RSP + local_100]
                 24 28
   --> 140421667 48 8b 8c        MOV        RCX,qword ptr [RSP + local_78]
                 24 b0 00 
                 00 00
                             LAB_14042166f                                   XREF[1]:     140421646(j)  
       14042166f 8b 01           MOV        EAX,dword ptr [RCX]
       140421671 41 89 86        MOV        dword ptr [R14 + 0x134],EAX
                 34 01 00 00
       140421678 e9 1a fb        JMP        LAB_140421197
                 ff ff

`````


----------------------------------------

case 76


useless


8a 01 following CMOVNC, those are all useless. 

`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0xbb
   eip 0xfffff80179cab546, user_address 0x44127fe9f4, user_data 0x2, modrm 0x1, pc 0xfffff80179cab555
   eip 0xfffff80179cab546, user_address 0x44127fe9f4, user_data 0x2, modrm 0x1, pc 0xfffff80179cab564
`````


`````shell
       140421541 45 84 ed        TEST       R13B,R13B
       140421544 74 1e           JZ         LAB_140421564
       140421546 48 3b 0d        CMP        RCX,qword ptr [MmUserProbeAddress]               = ??
                 b3 dc f5 ff
       14042154d 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d ab dc 
                 f5 ff
   --> 140421555 8a 01           MOV        AL,byte ptr [RCX]
       140421557 48 8b 5c        MOV        RBX,qword ptr [RSP + local_100]
                 24 28
       14042155c 48 8b 8c        MOV        RCX,qword ptr [RSP + local_a8]
                 24 80 00 
                 00 00
                             LAB_140421564                                   XREF[1]:     140421544(j)  
   --> 140421564 8a 01           MOV        AL,byte ptr [RCX]
       140421566 41 88 86        MOV        byte ptr [R14 + 0xf0],AL
                 f0 00 00 00
       14042156d e9 25 fc        JMP        LAB_140421197
                 ff ff

`````


--------------------------------------------

case 77

useless

`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0xd6
   eip 0xfffff80179ce376f, user_address 0x17bd41f6070, user_data 0x8, modrm 0x1, pc 0xfffff80179ce3781
   eip 0xfffff80179ce376f, user_address 0x17bd41f6070, user_data 0x8, modrm 0x16, pc 0xfffff80179ce3783
`````

`````shell
                             LAB_140459769                                   XREF[1]:     1404596fa(j)  
       140459769 41 f6 c6 03     TEST       R14B,0x3
       14045976d 75 5a           JNZ        LAB_1404597c9
       14045976f 49 8b ce        MOV        RCX,R14
       140459772 4c 3b 35        CMP        R14,qword ptr [MmUserProbeAddress]               = ??
                 87 5a f2 ff
       140459779 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 7f 5a 
                 f2 ff
   --> 140459781 8a 01           MOV        AL,byte ptr [RCX]
   --> 140459783 41 8b 16        MOV        EDX,dword ptr [R14]
       140459786 89 54 24 70     MOV        dword ptr [RSP + 0x70],EDX
       14045978a 49 8d 4e 04     LEA        RCX,[R14 + 0x4]
       14045978e 48 8d 84        LEA        RAX,[RSP + 0x9c]
                 24 9c 00 
                 00 00

`````

----------------------------------------------------

case 78

***

need review

`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0x1402
   eip 0xfffff961a3b013f8, user_address 0x44123fdbc8, user_data 0x44123fdcd0, modrm 0x40, pc 0xfffff961a3b01416
   eip 0xfffff961a3a99610, user_address 0x44123fdbc8, user_data 0x44123fdcd0, modrm 0x51, pc 0xfffff961a3a99635

DOUBLE FETCH:   cr3 0x122af5000, syscall 0x1402
   eip 0xfffff961a3b01319, user_address 0x44123fdc08, user_data 0x44123fdcd0, modrm 0x40, pc 0xfffff961a3b01337
   eip 0xfffff961a3a99610, user_address 0x44123fdc08, user_data 0x44123fdcd0, modrm 0x51, pc 0xfffff961a3a99635

`````


`````shell
                             LAB_1c0101304                                   XREF[1]:     1c0101455(j)  
       1c0101304 41 bc 04        MOV        R12D,0x104
                 01 00 00
       1c010130a 41 8b d4        MOV        EDX,R12D
       1c010130d 48 8d 0d        LEA        RCX,[DAT_1c0327a20]                              = ??
                 0c 67 22 00
       1c0101314 e8 f7 2a        CALL       FUN_1c0053e10                                    undefined FUN_1c0053e10()
                 f5 ff
       1c0101319 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 d8 02 25 00
       1c0101320 48 8b 08        MOV        RCX,qword ptr [RAX]
       1c0101323 48 8b c6        MOV        RAX,RSI
       1c0101326 48 3b f1        CMP        RSI,RCX
       1c0101329 48 0f 43 c1     CMOVNC     RAX,RCX
       1c010132d 8b 08           MOV        ECX,dword ptr [RAX]
       1c010132f 89 4c 24 20     MOV        dword ptr [RSP + local_58],ECX
       1c0101333 89 4c 24 40     MOV        dword ptr [RSP + local_38],ECX
   --> 1c0101337 4c 8b 40 08     MOV        R8,qword ptr [RAX + 0x8]
       1c010133b 4c 89 44        MOV        qword ptr [RSP + local_30],R8
                 24 48
       1c0101340 44 84 c3        TEST       BL,R8B
       1c0101343 0f 85 11        JNZ        LAB_1c010145a
                 01 00 00
       1c0101349 0f b7 c1        MOVZX      EAX,CX
       1c010134c 49 8d 50 02     LEA        RDX,[R8 + 0x2]
       1c0101350 48 03 d0        ADD        RDX,RAX
       1c0101353 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 9e 02 25 00
       1c010135a 4c 8b 08        MOV        R9,qword ptr [RAX]
       1c010135d 49 3b d1        CMP        RDX,R9
       1c0101360 0f 83 fa        JNC        LAB_1c0101460
                 00 00 00
       1c0101366 66 3b 4c        CMP        CX,word ptr [RSP + local_58+0x2]
                 24 22
       1c010136b 0f 87 ef        JA         LAB_1c0101460
                 00 00 00
       1c0101371 49 3b d0        CMP        RDX,R8
       1c0101374 0f 86 e6        JBE        LAB_1c0101460
                 00 00 00
                             LAB_1c010137a                                   XREF[1]:     1c0101464(j)  
       1c010137a 49 8b d4        MOV        RDX,R12
       1c010137d 48 8d 0d        LEA        RCX,[DAT_1c0327810]                              = ??
                 8c 64 22 00
       1c0101384 e8 87 2a        CALL       FUN_1c0053e10                                    undefined FUN_1c0053e10()
                 f5 ff
       1c0101389 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 68 02 25 00
       1c0101390 48 3b 38        CMP        RDI,qword ptr [RAX]
       1c0101393 48 0f 43 38     CMOVNC     RDI,qword ptr [RAX]
       1c0101397 44 8b 0f        MOV        R9D,dword ptr [RDI]
       1c010139a 44 89 4c        MOV        dword ptr [RSP + local_58],R9D
                 24 20
       1c010139f 44 89 4c        MOV        dword ptr [RSP + local_28],R9D
                 24 50
       1c01013a4 4c 8b 47 08     MOV        R8,qword ptr [RDI + 0x8]
       1c01013a8 4c 89 44        MOV        qword ptr [RSP + local_20],R8
                 24 58
       1c01013ad 44 84 c3        TEST       BL,R8B
       1c01013b0 0f 85 b3        JNZ        LAB_1c0101469
                 00 00 00
       1c01013b6 41 0f b7 c1     MOVZX      EAX,R9W
       1c01013ba 49 8d 48 02     LEA        RCX,[R8 + 0x2]
       1c01013be 48 03 c8        ADD        RCX,RAX
       1c01013c1 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 30 02 25 00
       1c01013c8 48 8b 10        MOV        RDX,qword ptr [RAX]
       1c01013cb 48 3b ca        CMP        RCX,RDX
       1c01013ce 0f 83 9b        JNC        LAB_1c010146f
                 00 00 00
       1c01013d4 66 44 3b        CMP        R9W,word ptr [RSP + local_58+0x2]
                 4c 24 22
       1c01013da 0f 87 8f        JA         LAB_1c010146f
                 00 00 00
       1c01013e0 49 3b c8        CMP        RCX,R8
       1c01013e3 0f 86 86        JBE        LAB_1c010146f
                 00 00 00

                             LAB_1c01013e9                                   XREF[1]:     1c0101472(j)  
       1c01013e9 49 8b d4        MOV        RDX,R12
       1c01013ec 48 8d 0d        LEA        RCX,[DAT_1c0327600]                              = ??
                 0d 62 22 00
       1c01013f3 e8 18 2a        CALL       FUN_1c0053e10                                    undefined FUN_1c0053e10()
                 f5 ff
       1c01013f8 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 f9 01 25 00
       1c01013ff 48 8b 08        MOV        RCX,qword ptr [RAX]
       1c0101402 49 8b c6        MOV        RAX,R14
       1c0101405 4c 3b f1        CMP        R14,RCX
       1c0101408 48 0f 43 c1     CMOVNC     RAX,RCX
       1c010140c 8b 08           MOV        ECX,dword ptr [RAX]
       1c010140e 89 4c 24 20     MOV        dword ptr [RSP + local_58],ECX
       1c0101412 89 4c 24 60     MOV        dword ptr [RSP + local_18],ECX
   --> 1c0101416 4c 8b 40 08     MOV        R8,qword ptr [RAX + 0x8]
       1c010141a 4c 89 44        MOV        qword ptr [RSP + local_10],R8
                 24 68
       1c010141f 44 84 c3        TEST       BL,R8B
       1c0101422 75 53           JNZ        LAB_1c0101477
       1c0101424 0f b7 c1        MOVZX      EAX,CX
       1c0101427 4d 8d 48 02     LEA        R9,[R8 + 0x2]
       1c010142b 4c 03 c8        ADD        R9,RAX
       1c010142e 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 c3 01 25 00
       1c0101435 4c 8b 10        MOV        R10,qword ptr [RAX]
       1c0101438 4d 3b ca        CMP        R9,R10
       1c010143b 73 40           JNC        LAB_1c010147d
       1c010143d 66 3b 4c        CMP        CX,word ptr [RSP + local_58+0x2]
                 24 22
       1c0101442 77 39           JA         LAB_1c010147d
       1c0101444 4d 3b c8        CMP        R9,R8
       1c0101447 76 34           JBE        LAB_1c010147d
       1c0101449 eb 36           JMP        LAB_1c0101481

`````


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c0099610()
             undefined         AL:1           <RETURN>
             undefined4        Stack[0x10]:4  local_res10                             XREF[1,1]:   1c009962b(W), 
                                                                                                   1c009965d(R)  
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1c0099610(W), 
                                                                                                   1c00996e5(R)  
             undefined8        Stack[-0x10]:8 local_10                                XREF[1]:     1c0099639(W)  
             undefined4        Stack[-0x18]:4 local_18                                XREF[1]:     1c0099630(W)  
             undefined2        Stack[-0x28]:2 local_28                                XREF[1]:     1c0099695(W)  
                             FUN_1c0099610                                   XREF[8]:     FUN_1c0097134:1c009727c(c), 
                                                                                          FUN_1c009bd94:1c009bf18(c), 
                                                                                          FUN_1c0101210:1c0101499(c), 
                                                                                          FUN_1c0101210:1c01014b3(c), 
                                                                                          FUN_1c0102900:1c0102a6f(c), 
                                                                                          FUN_1c0102900:1c0102a89(c), 
                                                                                          1c02fb4b8(*), 1c033595c(*)  
       1c0099610 48 89 5c        MOV        qword ptr [RSP + local_res8],RBX
                 24 08
       1c0099615 57              PUSH       RDI
       1c0099616 48 83 ec 40     SUB        RSP,0x40
       1c009961a 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 d7 7f 2b 00
       1c0099621 48 3b 08        CMP        RCX,qword ptr [RAX]
       1c0099624 48 0f 43 08     CMOVNC     RCX,qword ptr [RAX]
       1c0099628 44 8b 01        MOV        R8D,dword ptr [RCX]
       1c009962b 44 89 44        MOV        dword ptr [RSP + local_res10],R8D
                 24 58
       1c0099630 44 89 44        MOV        dword ptr [RSP + local_18],R8D
                 24 30
   --> 1c0099635 48 8b 51 08     MOV        RDX,qword ptr [RCX + 0x8]
       1c0099639 48 89 54        MOV        qword ptr [RSP + local_10],RDX
                 24 38
       1c009963e f6 c2 01        TEST       DL,0x1
       1c0099641 75 2b           JNZ        LAB_1c009966e
       1c0099643 41 0f b7 c0     MOVZX      EAX,R8W
       1c0099647 48 8d 4a 02     LEA        RCX,[RDX + 0x2]
       1c009964b 48 03 c8        ADD        RCX,RAX
       1c009964e 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 a3 7f 2b 00
       1c0099655 4c 8b 08        MOV        R9,qword ptr [RAX]
       1c0099658 49 3b c9        CMP        RCX,R9
       1c009965b 73 17           JNC        LAB_1c0099674
       1c009965d 66 44 3b        CMP        R8W,word ptr [RSP + local_res10+0x2]
                 44 24 5a
       1c0099663 77 0f           JA         LAB_1c0099674
       1c0099665 48 3b ca        CMP        RCX,RDX
       1c0099668 76 0a           JBE        LAB_1c0099674
       1c009966a 33 ff           XOR        EDI,EDI
       1c009966c eb 0b           JMP        LAB_1c0099679

`````

-------------------------------------------------------


case 79

***

need review

1c010132d - 1c0099628 = 67D05

0xfffff961a3b0132d - 0xfffff961a3a99628 = 67D05

`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0x1402
   eip 0xfffff961a3b01319, user_address 0x44123fdc00, user_data 0x560054, modrm 0x8, pc 0xfffff961a3b0132d
   eip 0xfffff961a3a99610, user_address 0x44123fdc00, user_data 0x560054, modrm 0x1, pc 0xfffff961a3a99628


DOUBLE FETCH:   cr3 0x122af5000, syscall 0x1402
   eip 0xfffff961a3b013f8, user_address 0x44123fdbc0, user_data 0x560054, modrm 0x8, pc 0xfffff961a3b0140c
   eip 0xfffff961a3a99610, user_address 0x44123fdbc0, user_data 0x560054, modrm 0x1, pc 0xfffff961a3a99628

`````


`````shell
                             LAB_1c0101304                                   XREF[1]:     1c0101455(j)  
       1c0101304 41 bc 04        MOV        R12D,0x104
                 01 00 00
       1c010130a 41 8b d4        MOV        EDX,R12D
       1c010130d 48 8d 0d        LEA        RCX,[DAT_1c0327a20]                              = ??
                 0c 67 22 00
       1c0101314 e8 f7 2a        CALL       FUN_1c0053e10                                    undefined FUN_1c0053e10()
                 f5 ff
       1c0101319 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 d8 02 25 00
       1c0101320 48 8b 08        MOV        RCX,qword ptr [RAX]
       1c0101323 48 8b c6        MOV        RAX,RSI
       1c0101326 48 3b f1        CMP        RSI,RCX
       1c0101329 48 0f 43 c1     CMOVNC     RAX,RCX
   --> 1c010132d 8b 08           MOV        ECX,dword ptr [RAX]
       1c010132f 89 4c 24 20     MOV        dword ptr [RSP + local_58],ECX
       1c0101333 89 4c 24 40     MOV        dword ptr [RSP + local_38],ECX
       1c0101337 4c 8b 40 08     MOV        R8,qword ptr [RAX + 0x8]
       1c010133b 4c 89 44        MOV        qword ptr [RSP + local_30],R8
                 24 48
       1c0101340 44 84 c3        TEST       BL,R8B
       1c0101343 0f 85 11        JNZ        LAB_1c010145a
                 01 00 00
       1c0101349 0f b7 c1        MOVZX      EAX,CX
       1c010134c 49 8d 50 02     LEA        RDX,[R8 + 0x2]
       1c0101350 48 03 d0        ADD        RDX,RAX
       1c0101353 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 9e 02 25 00
       1c010135a 4c 8b 08        MOV        R9,qword ptr [RAX]
       1c010135d 49 3b d1        CMP        RDX,R9
       1c0101360 0f 83 fa        JNC        LAB_1c0101460
                 00 00 00
       1c0101366 66 3b 4c        CMP        CX,word ptr [RSP + local_58+0x2]
                 24 22
       1c010136b 0f 87 ef        JA         LAB_1c0101460
                 00 00 00
       1c0101371 49 3b d0        CMP        RDX,R8
       1c0101374 0f 86 e6        JBE        LAB_1c0101460
                 00 00 00
                             LAB_1c010137a                                   XREF[1]:     1c0101464(j)  
       1c010137a 49 8b d4        MOV        RDX,R12
       1c010137d 48 8d 0d        LEA        RCX,[DAT_1c0327810]                              = ??
                 8c 64 22 00
       1c0101384 e8 87 2a        CALL       FUN_1c0053e10                                    undefined FUN_1c0053e10()
                 f5 ff
       1c0101389 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 68 02 25 00
       1c0101390 48 3b 38        CMP        RDI,qword ptr [RAX]
       1c0101393 48 0f 43 38     CMOVNC     RDI,qword ptr [RAX]
       1c0101397 44 8b 0f        MOV        R9D,dword ptr [RDI]
       1c010139a 44 89 4c        MOV        dword ptr [RSP + local_58],R9D
                 24 20
       1c010139f 44 89 4c        MOV        dword ptr [RSP + local_28],R9D
                 24 50
       1c01013a4 4c 8b 47 08     MOV        R8,qword ptr [RDI + 0x8]
       1c01013a8 4c 89 44        MOV        qword ptr [RSP + local_20],R8
                 24 58
       1c01013ad 44 84 c3        TEST       BL,R8B
       1c01013b0 0f 85 b3        JNZ        LAB_1c0101469
                 00 00 00
       1c01013b6 41 0f b7 c1     MOVZX      EAX,R9W
       1c01013ba 49 8d 48 02     LEA        RCX,[R8 + 0x2]
       1c01013be 48 03 c8        ADD        RCX,RAX
       1c01013c1 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 30 02 25 00
       1c01013c8 48 8b 10        MOV        RDX,qword ptr [RAX]
       1c01013cb 48 3b ca        CMP        RCX,RDX
       1c01013ce 0f 83 9b        JNC        LAB_1c010146f
                 00 00 00
       1c01013d4 66 44 3b        CMP        R9W,word ptr [RSP + local_58+0x2]
                 4c 24 22
       1c01013da 0f 87 8f        JA         LAB_1c010146f
                 00 00 00
       1c01013e0 49 3b c8        CMP        RCX,R8
       1c01013e3 0f 86 86        JBE        LAB_1c010146f
                 00 00 00
                             LAB_1c01013e9                                   XREF[1]:     1c0101472(j)  
       1c01013e9 49 8b d4        MOV        RDX,R12
       1c01013ec 48 8d 0d        LEA        RCX,[DAT_1c0327600]                              = ??
                 0d 62 22 00
       1c01013f3 e8 18 2a        CALL       FUN_1c0053e10                                    undefined FUN_1c0053e10()
                 f5 ff
       1c01013f8 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 f9 01 25 00
       1c01013ff 48 8b 08        MOV        RCX,qword ptr [RAX]
       1c0101402 49 8b c6        MOV        RAX,R14
       1c0101405 4c 3b f1        CMP        R14,RCX
       1c0101408 48 0f 43 c1     CMOVNC     RAX,RCX
   --> 1c010140c 8b 08           MOV        ECX,dword ptr [RAX]
       1c010140e 89 4c 24 20     MOV        dword ptr [RSP + local_58],ECX
       1c0101412 89 4c 24 60     MOV        dword ptr [RSP + local_18],ECX
       1c0101416 4c 8b 40 08     MOV        R8,qword ptr [RAX + 0x8]
       1c010141a 4c 89 44        MOV        qword ptr [RSP + local_10],R8
                 24 68
       1c010141f 44 84 c3        TEST       BL,R8B
       1c0101422 75 53           JNZ        LAB_1c0101477
       1c0101424 0f b7 c1        MOVZX      EAX,CX
       1c0101427 4d 8d 48 02     LEA        R9,[R8 + 0x2]
       1c010142b 4c 03 c8        ADD        R9,RAX
       1c010142e 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 c3 01 25 00
       1c0101435 4c 8b 10        MOV        R10,qword ptr [RAX]
       1c0101438 4d 3b ca        CMP        R9,R10
       1c010143b 73 40           JNC        LAB_1c010147d
       1c010143d 66 3b 4c        CMP        CX,word ptr [RSP + local_58+0x2]
                 24 22
       1c0101442 77 39           JA         LAB_1c010147d
       1c0101444 4d 3b c8        CMP        R9,R8
       1c0101447 76 34           JBE        LAB_1c010147d
       1c0101449 eb 36           JMP        LAB_1c0101481

`````

`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c0099610()
             undefined         AL:1           <RETURN>
             undefined4        Stack[0x10]:4  local_res10                             XREF[1,1]:   1c009962b(W), 
                                                                                                   1c009965d(R)  
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1c0099610(W), 
                                                                                                   1c00996e5(R)  
             undefined8        Stack[-0x10]:8 local_10                                XREF[1]:     1c0099639(W)  
             undefined4        Stack[-0x18]:4 local_18                                XREF[1]:     1c0099630(W)  
             undefined2        Stack[-0x28]:2 local_28                                XREF[1]:     1c0099695(W)  
                             FUN_1c0099610                                   XREF[8]:     FUN_1c0097134:1c009727c(c), 
                                                                                          FUN_1c009bd94:1c009bf18(c), 
                                                                                          FUN_1c0101210:1c0101499(c), 
                                                                                          FUN_1c0101210:1c01014b3(c), 
                                                                                          FUN_1c0102900:1c0102a6f(c), 
                                                                                          FUN_1c0102900:1c0102a89(c), 
                                                                                          1c02fb4b8(*), 1c033595c(*)  
       1c0099610 48 89 5c        MOV        qword ptr [RSP + local_res8],RBX
                 24 08
       1c0099615 57              PUSH       RDI
       1c0099616 48 83 ec 40     SUB        RSP,0x40
       1c009961a 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 d7 7f 2b 00
       1c0099621 48 3b 08        CMP        RCX,qword ptr [RAX]
       1c0099624 48 0f 43 08     CMOVNC     RCX,qword ptr [RAX]
   --> 1c0099628 44 8b 01        MOV        R8D,dword ptr [RCX]
       1c009962b 44 89 44        MOV        dword ptr [RSP + local_res10],R8D
                 24 58
       1c0099630 44 89 44        MOV        dword ptr [RSP + local_18],R8D
                 24 30
       1c0099635 48 8b 51 08     MOV        RDX,qword ptr [RCX + 0x8]
       1c0099639 48 89 54        MOV        qword ptr [RSP + local_10],RDX
                 24 38
       1c009963e f6 c2 01        TEST       DL,0x1
       1c0099641 75 2b           JNZ        LAB_1c009966e
       1c0099643 41 0f b7 c0     MOVZX      EAX,R8W

`````

----------------------------------------------------------


case 80

moudle 800a unknown.


syscall 0x7 NtDeviceIoControlFile

`````shell
DOUBLE FETCH:   cr3 0x12279c000, syscall 0x7
   eip 0xfffff800a12d4e01, user_address 0x3dd1ffe408, user_data 0x28, modrm 0x47, pc 0xfffff800a12d4e09
   eip 0xfffff800a12d4e3a, user_address 0x3dd1ffe408, user_data 0x28, modrm 0x4f, pc 0xfffff800a12d4e44

DOUBLE FETCH:   cr3 0x12279c000, syscall 0x7
   eip 0xfffff800a12d4ff4, user_address 0x3dd1ffe410, user_data 0x181e5030000, modrm 0x6f, pc 0xfffff800a12d4ffe
   eip 0xfffff800a12d5017, user_address 0x3dd1ffe410, user_data 0x181e5030000, modrm 0x7f, pc 0xfffff800a12d501e

DOUBLE FETCH:   cr3 0x12279c000, syscall 0x7
   eip 0xfffff800a12d4ff4, user_address 0x3dd1ffe410, user_data 0x218a27f720, modrm 0x6f, pc 0xfffff800a12d4ffe
   eip 0xfffff800a12d5017, user_address 0x3dd1ffe410, user_data 0x218a27f720, modrm 0x7f, pc 0xfffff800a12d501e

DOUBLE FETCH:   cr3 0x12279c000, syscall 0x7
   eip 0xfffff800a12d4ff4, user_address 0x3dd1ffe710, user_data 0x218a27f480, modrm 0x6f, pc 0xfffff800a12d4ffe
   eip 0xfffff800a12d5017, user_address 0x3dd1ffe710, user_data 0x218a27f480, modrm 0x7f, pc 0xfffff800a12d501e

`````

---------------------------------------------------------------

case 81

useless


`````shell
DOUBLE FETCH:   cr3 0x12132c000, syscall 0x198
   eip 0xfffff80179dc3d40, user_address 0x66280ff5d0, user_data 0x8f, modrm 0x1, pc 0xfffff80179dc3d52
   eip 0xfffff80179dc3d40, user_address 0x66280ff5d0, user_data 0xdee6808f, modrm 0x4, pc 0xfffff80179dc3d54
`````

`````shell
                             LAB_140539d40                                   XREF[1]:     140539cfd(j)  
       140539d40 49 8b cc        MOV        RCX,R12
       140539d43 4c 3b 25        CMP        R12,qword ptr [MmUserProbeAddress]               = ??
                 b6 54 e4 ff
       140539d4a 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d ae 54 
                 e4 ff
   --> 140539d52 8a 01           MOV        AL,byte ptr [RCX]
   --> 140539d54 41 8b 04 24     MOV        EAX,dword ptr [R12]
       140539d58 89 44 24 64     MOV        dword ptr [RSP + local_a4],EAX
       140539d5c 41 0f b7        MOVZX      EAX,word ptr [R12 + 0x4]
                 44 24 04
       140539d62 66 89 44        MOV        word ptr [RSP + local_a0],AX
                 24 68
       140539d67 33 db           XOR        EBX,EBX
       140539d69 89 5c 24 54     MOV        dword ptr [RSP + local_b4],EBX
       140539d6d eb 06           JMP        LAB_140539d75
       140539d6f 8b d8           MOV        EBX,EAX
       140539d71 89 44 24 54     MOV        dword ptr [RSP + 0x54],EAX

`````

-----------------------------------------------------------------

case 82

useless

`````shell
DOUBLE FETCH:   cr3 0x12279c000, syscall 0xff
   eip 0xfffff80179cdb99f, user_address 0x3dd1aafa10, user_data 0x207a9ee0000, modrm 0x1, pc 0xfffff80179cdb9b1
   eip 0xfffff80179cdb99f, user_address 0x3dd1aafa10, user_data 0x207a9ee0000, modrm 0x3a, pc 0xfffff80179cdb9cf

DOUBLE FETCH:   cr3 0x12279c000, syscall 0xff
   eip 0xfffff80179cdb99f, user_address 0x3dd1aafa18, user_data 0x4bc, modrm 0x1, pc 0xfffff80179cdb9c9
   eip 0xfffff80179cdb99f, user_address 0x3dd1aafa18, user_data 0x4bc, modrm 0x18, pc 0xfffff80179cdb9d7
`````

`````shell
       140451993 44 8a b0        MOV        R14B,byte ptr [RAX + 0x232]
                 32 02 00 00
       14045199a 45 84 f6        TEST       R14B,R14B
       14045199d 74 30           JZ         LAB_1404519cf
       14045199f 48 8b ca        MOV        param_1,param_2
       1404519a2 48 3b 15        CMP        param_2,qword ptr [MmUserProbeAddress]           = ??
                 57 d8 f2 ff
       1404519a9 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d 4f d8 
                 f2 ff
   --1 1404519b1 48 8b 01        MOV        RAX,qword ptr [param_1]
       1404519b4 48 89 01        MOV        qword ptr [param_1],RAX
       1404519b7 49 8b c8        MOV        param_1,param_3
       1404519ba 4c 3b 05        CMP        param_3,qword ptr [MmUserProbeAddress]           = ??
                 3f d8 f2 ff
       1404519c1 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d 37 d8 
                 f2 ff
   --2 1404519c9 48 8b 01        MOV        RAX,qword ptr [param_1]
       1404519cc 48 89 01        MOV        qword ptr [param_1],RAX
                             LAB_1404519cf                                   XREF[1]:     14045199d(j)  
   --1 1404519cf 48 8b 3a        MOV        RDI,qword ptr [param_2]
       1404519d2 48 89 7c        MOV        qword ptr [RSP + local_20],RDI
                 24 58
   --2 1404519d7 49 8b 18        MOV        RBX,qword ptr [param_3]
       1404519da 48 89 5c        MOV        qword ptr [RSP + local_18],RBX
                 24 60
       1404519df eb 05           JMP        LAB_1404519e6
       1404519e1 e9 86 00        JMP        LAB_140451a6c
                 00 00

`````

------------------------------------------------------------------------

case 83

useless

`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0x1449
   eip 0xfffff961a3affc29, user_address 0x44123ff898, user_data 0x0, modrm 0x0, pc 0xfffff961a3affc4d
   eip 0xfffff961a3affc29, user_address 0x44123ff898, user_data 0x0, modrm 0x6, pc 0xfffff961a3affc4f
`````

`````shell
       1c00ffc33 40 f6 c6 03     TEST       SIL,0x3
       1c00ffc37 75 48           JNZ        LAB_1c00ffc81
       1c00ffc39 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 b8 19 25 00
       1c00ffc40 48 8b 08        MOV        RCX,qword ptr [RAX]
       1c00ffc43 48 8b c6        MOV        RAX,RSI
       1c00ffc46 48 3b f1        CMP        RSI,RCX
       1c00ffc49 48 0f 43 c1     CMOVNC     RAX,RCX
   --> 1c00ffc4d 8a 00           MOV        AL,byte ptr [RAX]
   --> 1c00ffc4f 48 8b 06        MOV        RAX,qword ptr [RSI]
       1c00ffc52 48 89 44        MOV        qword ptr [RSP + local_20],RAX
                 24 28
`````
---------------------------------------------------------------------


case 84

***

need review


syscall NtUserSetCalibrationData


`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0x12d4
   eip 0xfffff961a3b17260, user_address 0x17a9fa3f7a0, user_data 0xe8390000, modrm 0x3c, pc 0xfffff961a3b17682
   eip 0xfffff961a3b18918, user_address 0x17a9fa3f7a0, user_data 0xe8390000, modrm 0x34, pc 0xfffff961a3b18a09

DOUBLE FETCH:   cr3 0x122af5000, syscall 0x12d4
   eip 0xfffff961a3b17260, user_address 0x17a9fa3f7a4, user_data 0xba3a0000, modrm 0x7c, pc 0xfffff961a3b17686
   eip 0xfffff961a3b18918, user_address 0x17a9fa3f7a4, user_data 0xba3a0000, modrm 0x5c, pc 0xfffff961a3b18a0c
`````


`````shell
       1c0117654 42 8d 04 02     LEA        EAX,[param_2 + param_3*0x1]
       1c0117658 41 3b 41 48     CMP        EAX,dword ptr [param_4 + 0x48]
       1c011765c 0f 8f bf        JG         LAB_1c01b0b21
                 94 09 00
       1c0117662 48 8b ca        MOV        param_1,param_2
                             LAB_1c0117665                                   XREF[1]:     1c01b0b31(j)  
       1c0117665 49 03 49 40     ADD        param_1,qword ptr [param_4 + 0x40]
       1c0117669 33 d2           XOR        param_2,param_2
                             LAB_1c011766b                                   XREF[1]:     1c01b0b25(j)  
       1c011766b 48 85 c9        TEST       param_1,param_1
       1c011766e 0f 84 a3        JZ         LAB_1c01b0b17
                 94 09 00
       1c0117674 41 0f b7 c5     MOVZX      EAX,R13W
       1c0117678 66 45 85 d2     TEST       R10W,R10W
       1c011767c 0f 84 88        JZ         LAB_1c011840a
                 0d 00 00
   --1 1c0117682 44 8b 3c 81     MOV        R15D,dword ptr [param_1 + RAX*0x4]
   --2 1c0117686 8b 7c 81 04     MOV        EDI,dword ptr [param_1 + RAX*0x4 + 0x4]
       1c011768a 41 0f cf        BSWAP      R15D
       1c011768d 0f cf           BSWAP      EDI
                             LAB_1c011768f                                   XREF[1]:     1c0118429(j)  
       1c011768f 44 3b ff        CMP        R15D,EDI
       1c0117692 0f 87 9e        JA         LAB_1c01b0b36
                 94 09 00
       1c0117698 8b 4e 0c        MOV        param_1,dword ptr [RSI + 0xc]
       1c011769b 41 2b ff        SUB        EDI,R15D
       1c011769e 41 bd 06        MOV        R13D,0x6
                 00 00 00
       1c01176a4 83 e9 01        SUB        param_1,0x1
       1c01176a7 0f 85 93        JNZ        LAB_1c01b0b40
                 94 09 00

`````

`````shell
                             LAB_1c01189f3                                   XREF[1]:     1c01b0dcf(j)  
       1c01189f3 48 85 d2        TEST       RDX,RDX
       1c01189f6 0f 84 cb        JZ         LAB_1c01b0dc7
                 83 09 00
       1c01189fc 66 45 85 d2     TEST       R10W,R10W
       1c0118a00 0f 84 1f        JZ         LAB_1c0118b25
                 01 00 00
       1c0118a06 0f b7 c5        MOVZX      EAX,BP
   --1 1c0118a09 8b 34 82        MOV        ESI,dword ptr [RDX + RAX*0x4]
   --2 1c0118a0c 8b 5c 82 04     MOV        EBX,dword ptr [RDX + RAX*0x4 + 0x4]
       1c0118a10 0f ce           BSWAP      ESI
       1c0118a12 0f cb           BSWAP      EBX
                             LAB_1c0118a14                                   XREF[1]:     1c0118b44(j)  
       1c0118a14 3b f3           CMP        ESI,EBX
       1c0118a16 0f 87 c4        JA         LAB_1c01b0de0
                 83 09 00
       1c0118a1c 8b 4f 0c        MOV        ECX,dword ptr [RDI + 0xc]
       1c0118a1f 2b de           SUB        EBX,ESI
       1c0118a21 bd 06 00        MOV        EBP,0x6
                 00 00
       1c0118a26 83 e9 01        SUB        ECX,0x1
       1c0118a29 0f 85 bb        JNZ        LAB_1c01b0dea
                 83 09 00

`````


--------------------------------------------------------


case 85


***

need review


syscall 116b NtUserBuildHwndList

`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0x116b
   eip 0xfffff961a3a1398b, user_address 0x17a9f2b3061, user_data 0x60, modrm 0x43, pc 0xfffff961a3a139a8
   eip 0xfffff961a3a130ca, user_address 0x17a9f2b3061, user_data 0x60, modrm 0x40, pc 0xfffff961a3a13235
`````

`````shell
       1c0013975 57              PUSH       RDI
       1c0013976 48 83 ec 20     SUB        RSP,0x20
       1c001397a 48 8b 1a        MOV        RBX,qword ptr [RDX]
       1c001397d 48 8b f9        MOV        RDI,RCX
       1c0013980 33 d2           XOR        EDX,EDX
       1c0013982 44 8d 42 20     LEA        R8D,[RDX + 0x20]
       1c0013986 e8 f5 16        CALL       memset                                           void * memset(void * _Dst, int _
                 13 00
       1c001398b 0f b6 03        MOVZX      EAX,byte ptr [RBX]
       1c001398e 0f b6 53 01     MOVZX      EDX,byte ptr [RBX + 0x1]
       1c0013992 66 c1 e2 08     SHL        DX,0x8
       1c0013996 66 0b d0        OR         DX,AX
       1c0013999 66 89 17        MOV        word ptr [RDI],DX
       1c001399c 8a 43 5f        MOV        AL,byte ptr [RBX + 0x5f]
       1c001399f 88 47 04        MOV        byte ptr [RDI + 0x4],AL
       1c00139a2 8a 43 60        MOV        AL,byte ptr [RBX + 0x60]
       1c00139a5 88 47 05        MOV        byte ptr [RDI + 0x5],AL
   --> 1c00139a8 8a 43 61        MOV        AL,byte ptr [RBX + 0x61]
       1c00139ab 88 47 06        MOV        byte ptr [RDI + 0x6],AL
       1c00139ae 8a 43 62        MOV        AL,byte ptr [RBX + 0x62]
       1c00139b1 88 47 07        MOV        byte ptr [RDI + 0x7],AL
       1c00139b4 0f b6 4b 59     MOVZX      ECX,byte ptr [RBX + 0x59]
       1c00139b8 0f b6 43 58     MOVZX      EAX,byte ptr [RBX + 0x58]
       1c00139bc 66 c1 e1 08     SHL        CX,0x8
       1c00139c0 66 0b c8        OR         CX,AX
       1c00139c3 66 89 4f 08     MOV        word ptr [RDI + 0x8],CX
       1c00139c7 b9 80 00        MOV        ECX,0x80
                 00 00
       1c00139cc 0f b6 43 55     MOVZX      EAX,byte ptr [RBX + 0x55]
       1c00139d0 66 89 47 0e     MOV        word ptr [RDI + 0xe],AX
       1c00139d4 66 2b c1        SUB        AX,CX
       1c00139d7 66 83 f8 08     CMP        AX,0x8
       1c00139db 77 11           JA         LAB_1c00139ee
       1c00139dd 0f b7 c0        MOVZX      EAX,AX
       1c00139e0 b9 43 01        MOV        ECX,0x143
                 00 00
       1c00139e5 0f a3 c1        BT         ECX,EAX
       1c00139e8 0f 82 76        JC         LAB_1c015a064
                 66 14 00

`````

`````shell
                             LAB_1c00131ee                                   XREF[1]:     1c00134b7(j)  
       1c00131ee 41 0f bf c2     MOVSX      EAX,R10W
       1c00131f2 41 0f bf cb     MOVSX      ECX,R11W
       1c00131f6 2b c8           SUB        ECX,EAX
       1c00131f8 b8 56 55        MOV        EAX,0x55555556
                 55 55
       1c00131fd 83 c1 02        ADD        ECX,0x2
       1c0013200 f7 e9           IMUL       ECX
       1c0013202 49 8d 4d 24     LEA        RCX,[R13 + 0x24]
       1c0013206 8b c2           MOV        EAX,EDX
       1c0013208 c1 e8 1f        SHR        EAX,0x1f
       1c001320b 03 d0           ADD        EDX,EAX
       1c001320d 66 89 53 6a     MOV        word ptr [RBX + 0x6a],DX
       1c0013211 41 8a 45 28     MOV        AL,byte ptr [R13 + 0x28]
       1c0013215 88 43 6c        MOV        byte ptr [RBX + 0x6c],AL
       1c0013218 41 8a 45 29     MOV        AL,byte ptr [R13 + 0x29]
       1c001321c 88 43 6d        MOV        byte ptr [RBX + 0x6d],AL
       1c001321f 41 8a 55 2b     MOV        DL,byte ptr [R13 + 0x2b]
       1c0013223 41 02 55 28     ADD        DL,byte ptr [R13 + 0x28]
       1c0013227 48 8b 45 48     MOV        RAX,qword ptr [RBP + local_res10]
       1c001322b 88 53 6f        MOV        byte ptr [RBX + 0x6f],DL
       1c001322e 48 8d 53 74     LEA        RDX,[RBX + 0x74]
       1c0013232 48 8b 00        MOV        RAX,qword ptr [RAX]
   --> 1c0013235 44 8a 40 61     MOV        R8B,byte ptr [RAX + 0x61]
       1c0013239 44 02 40 5f     ADD        R8B,byte ptr [RAX + 0x5f]
       1c001323d 44 88 43 6e     MOV        byte ptr [RBX + 0x6e],R8B
       1c0013241 4c 8d 43 76     LEA        R8,[RBX + 0x76]
       1c0013245 e8 92 02        CALL       FUN_1c00134dc                                    undefined FUN_1c00134dc()
                 00 00

`````

-----------------------------------------------------------

case 86


***

need review

syscall 116b NtUserBuildHwndList

`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0x116b
   eip 0xfffff961a3a12eb2, user_address 0x17a9f2b3055, user_data 0x0, modrm 0x48, pc 0xfffff961a3a12ec5
   eip 0xfffff961a3a13020, user_address 0x17a9f2b3055, user_data 0x0, modrm 0x46, pc 0xfffff961a3a1305b
`````


`````shell
                             LAB_1c0012ea5                                   XREF[4]:     1c0012f2e(j), 1c0159de1(j), 
                                                                                          1c0159dee(j), 1c0159dfa(j)  
       1c0012ea5 48 8b 0d        MOV        RCX,qword ptr [DAT_1c03226d0]                    = ??
                 24 f8 30 00
       1c0012eac ff 15 7e        CALL       qword ptr [->WIN32KBASE.SYS::EngAcquireSemapho
                 d2 33 00
       1c0012eb2 48 8b 06        MOV        RAX,qword ptr [RSI]
       1c0012eb5 48 8d 0d        LEA        RCX,[DAT_1c0328820]                              = ??
                 64 59 31 00
       1c0012ebc 44 0f b6        MOVZX      R8D,byte ptr [RDI + 0x29]
                 47 29
       1c0012ec1 0f b6 57 28     MOVZX      EDX,byte ptr [RDI + 0x28]
   --> 1c0012ec5 44 8a 48 55     MOV        R9B,byte ptr [RAX + 0x55]
       1c0012ec9 e8 02 07        CALL       FUN_1c00135d0                                    undefined FUN_1c00135d0()
                 00 00
       1c0012ece 48 8b 0d        MOV        RCX,qword ptr [DAT_1c03226d0]                    = ??
                 fb f7 30 00
       1c0012ed5 48 89 47 48     MOV        qword ptr [RDI + 0x48],RAX
       1c0012ed9 ff 15 39        CALL       qword ptr [->WIN32KBASE.SYS::EngReleaseSemapho
                 d2 33 00
       1c0012edf 48 39 5f 48     CMP        qword ptr [RDI + 0x48],RBX
       1c0012ee3 0f 84 16        JZ         LAB_1c0159dff
                 6f 14 00
       1c0012ee9 48 8b d6        MOV        RDX,RSI
       1c0012eec 48 8b cf        MOV        RCX,RDI
       1c0012eef e8 40 00        CALL       FUN_1c0012f34                                    undefined FUN_1c0012f34()
                 00 00
       1c0012ef4 48 8b 4f 50     MOV        RCX,qword ptr [RDI + 0x50]
       1c0012ef8 39 19           CMP        dword ptr [RCX],EBX
       1c0012efa 0f 45 dd        CMOVNZ     EBX,EBP

`````

`````shell
       1c0013042 89 11           MOV        dword ptr [RCX],EDX
       1c0013044 4c 8d 71 0c     LEA        R14,[RCX + 0xc]
       1c0013048 44 89 61 04     MOV        dword ptr [RCX + 0x4],R12D
       1c001304c 4c 8d 79 20     LEA        R15,[RCX + 0x20]
       1c0013050 c7 41 08        MOV        dword ptr [RCX + 0x8],0x34
                 34 00 00 00
       1c0013057 48 8d 79 34     LEA        RDI,[RCX + 0x34]
                             LAB_1c001305b                                   XREF[4]:     1c00134c1(j), 1c00134d1(j), 
                                                                                          1c0159e71(j), 1c0159e7b(j)  
   --> 1c001305b 8a 46 55        MOV        AL,byte ptr [RSI + 0x55]
       1c001305e 88 43 2c        MOV        byte ptr [RBX + 0x2c],AL
       1c0013061 8a 56 5a        MOV        DL,byte ptr [RSI + 0x5a]
       1c0013064 80 e2 f0        AND        DL,0xf0
       1c0013067 88 53 2d        MOV        byte ptr [RBX + 0x2d],DL
       1c001306a 8a 46 56        MOV        AL,byte ptr [RSI + 0x56]
       1c001306d f6 d8           NEG        AL
       1c001306f 1b c9           SBB        ECX,ECX
       1c0013071 41 03 cb        ADD        ECX,R11D
       1c0013074 0a ca           OR         CL,DL
       1c0013076 88 4b 2d        MOV        byte ptr [RBX + 0x2d],CL
       1c0013079 0f b6 46 53     MOVZX      EAX,byte ptr [RSI + 0x53]
       1c001307d 0f b6 4e 54     MOVZX      ECX,byte ptr [RSI + 0x54]
       1c0013081 66 c1 e1 08     SHL        CX,0x8
       1c0013085 66 0b c8        OR         CX,AX
       1c0013088 b8 e7 03        MOV        EAX,0x3e7
                 00 00
       1c001308d 66 89 4b 2e     MOV        word ptr [RBX + 0x2e],CX
       1c0013091 66 41 2b ca     SUB        CX,R10W
       1c0013095 66 3b c8        CMP        CX,AX
       1c0013098 0f 87 e2        JA         LAB_1c0159e80
                 6d 14 00

`````

----------------------------------------------------

case 87

***

need review


`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0x116b
   eip 0xfffff961a3a123fb, user_address 0x17a9f2b045f, user_data 0x20, modrm 0x42, pc 0xfffff961a3a12217
   eip 0xfffff961a3a11ce4, user_address 0x17a9f2b045f, user_data 0x20, modrm 0x47, pc 0xfffff961a3a11e4c

DOUBLE FETCH:   cr3 0x122af5000, syscall 0x116b
   eip 0xfffff961a3a123fb, user_address 0x17a9f2b0460, user_data 0xff, modrm 0x4a, pc 0xfffff961a3a1221b
   eip 0xfffff961a3a11ce4, user_address 0x17a9f2b0460, user_data 0xff, modrm 0x47, pc 0xfffff961a3a11e52

`````

`````shell
                             LAB_1c00121e0                                   XREF[1]:     1c0159ce6(j)  
       1c00121e0 41 0f b6        MOVZX      EAX,byte ptr [R10 + 0x59]
                 42 59
       1c00121e5 66 c1 e0 08     SHL        AX,0x8
       1c00121e9 0f bf c8        MOVSX      ECX,AX
       1c00121ec 41 0f b6        MOVZX      EAX,byte ptr [R10 + 0x58]
                 42 58
       1c00121f1 0b c8           OR         ECX,EAX
       1c00121f3 44 3b c1        CMP        R8D,ECX
       1c00121f6 0f 8f 37        JG         LAB_1c0012333
                 01 00 00
       1c00121fc 41 0f b6        MOVZX      ECX,byte ptr [R10 + 0x4d]
                 4a 4d
       1c0012201 41 0f b6        MOVZX      EAX,byte ptr [R10 + 0x4c]
                 42 4c
       1c0012206 66 c1 e1 08     SHL        CX,0x8
       1c001220a 66 0b c8        OR         CX,AX
       1c001220d 66 41 3b cb     CMP        CX,R11W
       1c0012211 0f 8f 1c        JG         LAB_1c0012333
                 01 00 00
   --1 1c0012217 41 8a 42 5f     MOV        AL,byte ptr [R10 + 0x5f]
   --2 1c001221b 41 8a 4a 60     MOV        CL,byte ptr [R10 + 0x60]
       1c001221f 3a c1           CMP        AL,CL
       1c0012221 0f 87 0c        JA         LAB_1c0012333
                 01 00 00
       1c0012227 0f b6 c0        MOVZX      EAX,AL
       1c001222a 44 0f b6 c1     MOVZX      R8D,CL
       1c001222e 44 2b c0        SUB        R8D,EAX
       1c0012231 41 0f b6        MOVZX      EAX,byte ptr [R10 + 0x61]
                 42 61
       1c0012236 41 3b c0        CMP        EAX,R8D
       1c0012239 0f 8f f4        JG         LAB_1c0012333
                 00 00 00
       1c001223f 41 0f b6        MOVZX      EAX,byte ptr [R10 + 0x62]
                 42 62
       1c0012244 41 3b c0        CMP        EAX,R8D
       1c0012247 0f 8f e6        JG         LAB_1c0012333
                 00 00 00

`````


`````shell
                             LAB_1c0011e03                                   XREF[1]:     1c0159ca6(j)  
       1c0011e03 0f b6 47 4d     MOVZX      EAX,byte ptr [RDI + 0x4d]
       1c0011e07 4c 8d 4d 40     LEA        R9=>local_res8,[RBP + 0x40]
       1c0011e0b 66 c1 e0 08     SHL        AX,0x8
       1c0011e0f 45 33 c0        XOR        R8D,R8D
       1c0011e12 0f bf d0        MOVSX      EDX,AX
       1c0011e15 0f b6 47 4c     MOVZX      EAX,byte ptr [RDI + 0x4c]
       1c0011e19 0b d0           OR         EDX,EAX
       1c0011e1b 44 89 6c        MOV        dword ptr [RSP + local_68],R13D
                 24 20
       1c0011e20 0f b6 47 4b     MOVZX      EAX,byte ptr [RDI + 0x4b]
       1c0011e24 66 c1 e0 08     SHL        AX,0x8
       1c0011e28 0f bf c8        MOVSX      ECX,AX
       1c0011e2b 0f b6 47 4a     MOVZX      EAX,byte ptr [RDI + 0x4a]
       1c0011e2f 0b c8           OR         ECX,EAX
       1c0011e31 b8 56 55        MOV        EAX,0x55555556
                 55 55
       1c0011e36 2b ca           SUB        ECX,EDX
       1c0011e38 41 03 ca        ADD        ECX,R10D
       1c0011e3b f7 e9           IMUL       ECX
       1c0011e3d 48 8d 4b 74     LEA        RCX,[RBX + 0x74]
       1c0011e41 8b c2           MOV        EAX,EDX
       1c0011e43 c1 e8 1f        SHR        EAX,0x1f
       1c0011e46 03 d0           ADD        EDX,EAX
       1c0011e48 66 89 53 6a     MOV        word ptr [RBX + 0x6a],DX
   --> 1c0011e4c 8a 47 5f        MOV        AL,byte ptr [RDI + 0x5f]
       1c0011e4f 88 43 6c        MOV        byte ptr [RBX + 0x6c],AL
   --2 1c0011e52 8a 47 60        MOV        AL,byte ptr [RDI + 0x60]
       1c0011e55 88 43 6d        MOV        byte ptr [RBX + 0x6d],AL
       1c0011e58 8a 57 61        MOV        DL,byte ptr [RDI + 0x61]
       1c0011e5b 02 57 5f        ADD        DL,byte ptr [RDI + 0x5f]
       1c0011e5e 8a 47 62        MOV        AL,byte ptr [RDI + 0x62]
       1c0011e61 02 47 5f        ADD        AL,byte ptr [RDI + 0x5f]
       1c0011e64 88 55 40        MOV        byte ptr [RBP + local_res8],DL
       1c0011e67 88 53 6e        MOV        byte ptr [RBX + 0x6e],DL
       1c0011e6a 41 8b d2        MOV        EDX,R10D
       1c0011e6d 88 45 50        MOV        byte ptr [RBP + local_res18],AL
       1c0011e70 88 43 6f        MOV        byte ptr [RBX + 0x6f],AL
       1c0011e73 ff 15 f7        CALL       qword ptr [->WIN32KBASE.SYS::EngMultiByteToUni
                 e2 33 00
       1c0011e79 45 33 c0        XOR        R8D,R8D
       1c0011e7c 44 89 6c        MOV        dword ptr [RSP + local_68],R13D
                 24 20
       1c0011e81 48 8d 4b 76     LEA        RCX,[RBX + 0x76]
       1c0011e85 4c 8d 4d 50     LEA        R9=>local_res18,[RBP + 0x50]
       1c0011e89 41 8d 50 02     LEA        EDX,[R8 + 0x2]
       1c0011e8d ff 15 dd        CALL       qword ptr [->WIN32KBASE.SYS::EngMultiByteToUni
                 e2 33 00

`````

case 88


***

need review


`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0x116b
   eip 0xfffff961a3a12523, user_address 0x17a9f2b0455, user_data 0xff, modrm 0x4f, pc 0xfffff961a3a12543
   eip 0xfffff961a3a11bda, user_address 0x17a9f2b0455, user_data 0xff, modrm 0x47, pc 0xfffff961a3a11c74
`````


`````shell
       1c0011c54 49 63 f0        MOVSXD     RSI,R8D
       1c0011c57 48 03 f1        ADD        RSI,RCX
       1c0011c5a 48 3b f1        CMP        RSI,RCX
       1c0011c5d 0f 82 3b        JC         LAB_1c001209e
                 04 00 00
       1c0011c63 8d 42 3c        LEA        EAX,[RDX + 0x3c]
       1c0011c66 3b c2           CMP        EAX,EDX
       1c0011c68 0f 82 30        JC         LAB_1c001209e
                 04 00 00
                             LAB_1c0011c6e                                   XREF[1]:     1c0159c3a(j)  
       1c0011c6e 41 bd 01        MOV        R13D,0x1
                 00 00 00
                             LAB_1c0011c74                                   XREF[2]:     1c0159c4c(j), 1c0159c6b(j)  
   --> 1c0011c74 8a 47 55        MOV        AL,byte ptr [RDI + 0x55]
       1c0011c77 41 ba 02        MOV        R10D,0x2
                 00 00 00
       1c0011c7d 88 43 2c        MOV        byte ptr [RBX + 0x2c],AL
       1c0011c80 8a 47 5a        MOV        AL,byte ptr [RDI + 0x5a]
       1c0011c83 88 43 2d        MOV        byte ptr [RBX + 0x2d],AL
       1c0011c86 a8 0f           TEST       AL,0xf
       1c0011c88 0f 84 e8        JZ         LAB_1c0159c76
                 7f 14 00
       1c0011c8e 24 f2           AND        AL,0xf2
       1c0011c90 41 0a c2        OR         AL,R10B
                             LAB_1c0011c93                                   XREF[1]:     1c0159c7b(j)  
       1c0011c93 88 43 2d        MOV        byte ptr [RBX + 0x2d],AL

`````

`````shell
       1c0012523 49 8b 0e        MOV        param_1,qword ptr [R14]
       1c0012526 89 44 d9 40     MOV        dword ptr [param_1 + RBX*0x8 + 0x40],EAX
       1c001252a 48 8d 0d        LEA        param_1,[DAT_1c0328828]                          = ??
                 f7 62 31 00
       1c0012531 49 8b 06        MOV        RAX,qword ptr [R14]
       1c0012534 4c 89 64        MOV        qword ptr [RAX + RBX*0x8 + 0x50],R12
                 d8 50
       1c0012539 45 0f b6        MOVZX      param_3,byte ptr [R15 + 0x60]
                 47 60
       1c001253e 41 0f b6        MOVZX      param_2,byte ptr [R15 + 0x5f]
                 57 5f
   --> 1c0012543 45 8a 4f 55     MOV        param_4,byte ptr [R15 + 0x55]
       1c0012547 e8 84 10        CALL       FUN_1c00135d0                                    undefined FUN_1c00135d0()
                 00 00

`````

---------------------------------------------------


case 89


*** 

need review

`````shell
DOUBLE FETCH:   cr3 0x122af5000, syscall 0x116b
   eip 0xfffff961a3a125f9, user_address 0x17a9f2b0450, user_data 0x0, modrm 0x43, pc 0xfffff961a3a12634
   eip 0xfffff961a3a125f9, user_address 0x17a9f2b0450, user_data 0x0, modrm 0x43, pc 0xfffff961a3a12634

DOUBLE FETCH:   cr3 0x122af5000, syscall 0x116b
   eip 0xfffff961a3a125f9, user_address 0x17a9f2b0450, user_data 0x0, modrm 0x43, pc 0xfffff961a3a12634
   eip 0xfffff961a3a11bc0, user_address 0x17a9f2b0450, user_data 0x0, modrm 0x41, pc 0xfffff961a3a11aa1

`````

`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c00125b4()
             undefined         AL:1           <RETURN>
             undefined4        Stack[0x8]:4   local_res8                              XREF[2]:     1c00125bb(*), 
                                                                                                   1c00125f9(R)  
                             FUN_1c00125b4                                   XREF[3]:     FUN_1c0011ab8:1c0011b1d(c), 
                                                                                          FUN_1c0012368:1c0012439(c), 
                                                                                          1c0331894(*)  
       1c00125b4 48 83 ec 28     SUB        RSP,0x28
       1c00125b8 4c 8b d9        MOV        R11,RCX
       1c00125bb 4c 8d 44        LEA        R8=>local_res8,[RSP + 0x30]
                 24 30
       1c00125c0 0f b6 49 6b     MOVZX      ECX,byte ptr [RCX + 0x6b]
       1c00125c4 ba 00 00        MOV        EDX,0xff000000
                 00 ff
       1c00125c9 c1 e1 08        SHL        ECX,0x8
       1c00125cc 41 0f b6        MOVZX      EAX,byte ptr [R11 + 0x6a]
                 43 6a
       1c00125d1 0b c8           OR         ECX,EAX
       1c00125d3 41 0f b6        MOVZX      EAX,byte ptr [R11 + 0x6c]
                 43 6c
       1c00125d8 c1 e1 08        SHL        ECX,0x8
       1c00125db c1 e0 18        SHL        EAX,0x18
       1c00125de 48 23 c2        AND        RAX,RDX
       1c00125e1 ba ff ff        MOV        EDX,0x7fffffff
                 ff 7f
       1c00125e6 48 0b c8        OR         RCX,RAX
       1c00125e9 41 0f b6        MOVZX      EAX,byte ptr [R11 + 0x69]
                 43 69
       1c00125ee 48 0b c8        OR         RCX,RAX
       1c00125f1 49 03 cb        ADD        RCX,R11
       1c00125f4 e8 8b 0f        CALL       FUN_1c0013584                                    undefined FUN_1c0013584()
                 00 00
       1c00125f9 8b 44 24 30     MOV        EAX,dword ptr [RSP + local_res8]
       1c00125fd 41 b8 ff        MOV        R8D,0xffffffff
                 ff ff ff
       1c0012603 ff c0           INC        EAX
       1c0012605 48 03 c0        ADD        RAX,RAX
       1c0012608 49 3b c0        CMP        RAX,R8
       1c001260b 77 70           JA         LAB_1c001267d
       1c001260d 8d 50 03        LEA        EDX,[RAX + 0x3]
       1c0012610 3b d0           CMP        EDX,EAX
       1c0012612 72 69           JC         LAB_1c001267d
       1c0012614 83 e2 fc        AND        EDX,0xfffffffc
       1c0012617 81 c2 c0        ADD        EDX,0xc0
                 00 00 00
       1c001261d 81 fa c0        CMP        EDX,0xc0
                 00 00 00
       1c0012623 72 58           JC         LAB_1c001267d
       1c0012625 41 0f b6        MOVZX      EAX,byte ptr [R11 + 0x53]
                 43 53
       1c001262a 41 0f b6        MOVZX      ECX,byte ptr [R11 + 0x54]
                 4b 54
       1c001262f c1 e1 08        SHL        ECX,0x8
       1c0012632 0b c8           OR         ECX,EAX
   --> 1c0012634 41 8a 43 50     MOV        AL,byte ptr [R11 + 0x50]
       1c0012638 81 f9 90        CMP        ECX,0x190
                 01 00 00
       1c001263e 7f 34           JG         LAB_1c0012674
       1c0012640 f6 d8           NEG        AL
       1c0012642 1b c9           SBB        ECX,ECX
       1c0012644 83 e1 fe        AND        ECX,0xfffffffe
       1c0012647 83 c1 04        ADD        ECX,0x4
                             LAB_1c001264a                                   XREF[1]:     1c001267b(j)  
       1c001264a 83 e9 01        SUB        ECX,0x1
       1c001264d 74 1e           JZ         LAB_1c001266d
       1c001264f 48 8d 0c 89     LEA        RCX,[RCX + RCX*0x4]
       1c0012653 48 c1 e1 02     SHL        RCX,0x2
       1c0012657 49 3b c8        CMP        RCX,R8
       1c001265a 77 21           JA         LAB_1c001267d
       1c001265c 8d 41 0c        LEA        EAX,[RCX + 0xc]
       1c001265f 83 f8 0c        CMP        EAX,0xc
       1c0012662 72 19           JC         LAB_1c001267d
       1c0012664 8d 0c 10        LEA        ECX,[RAX + RDX*0x1]
       1c0012667 3b ca           CMP        ECX,EDX
       1c0012669 72 12           JC         LAB_1c001267d
       1c001266b 8b d1           MOV        EDX,ECX
                             LAB_1c001266d                                   XREF[1]:     1c001264d(j)  
       1c001266d 8b c2           MOV        EAX,EDX
                             LAB_1c001266f                                   XREF[1]:     1c001267f(j)  
       1c001266f 48 83 c4 28     ADD        RSP,0x28
       1c0012673 c3              RET
                             LAB_1c0012674                                   XREF[1]:     1c001263e(j)  
       1c0012674 f6 d8           NEG        AL
       1c0012676 1b c9           SBB        ECX,ECX
       1c0012678 83 c1 02        ADD        ECX,0x2
       1c001267b eb cd           JMP        LAB_1c001264a
                             LAB_1c001267d                                   XREF[6]:     1c001260b(j), 1c0012612(j), 
                                                                                          1c0012623(j), 1c001265a(j), 
                                                                                          1c0012662(j), 1c0012669(j)  
       1c001267d 33 c0           XOR        EAX,EAX
       1c001267f eb ee           JMP        LAB_1c001266f
                             LAB_1c0012681                                   XREF[1]:     1c0331898(*)  
       1c0012681 cc              INT3

`````

`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c0011a94()
             undefined         AL:1           <RETURN>
                             FUN_1c0011a94                                   XREF[4]:     FUN_1c0011ab8:1c0011bd5(c), 
                                                                                          FUN_1c0012368:1c001251e(c), 
                                                                                          1c02efbb8(*), 1c0331868(*)  
       1c0011a94 0f b6 41 53     MOVZX      EAX,byte ptr [RCX + 0x53]
       1c0011a98 0f b6 51 54     MOVZX      EDX,byte ptr [RCX + 0x54]
       1c0011a9c c1 e2 08        SHL        EDX,0x8
       1c0011a9f 0b d0           OR         EDX,EAX
   --> 1c0011aa1 8a 41 50        MOV        AL,byte ptr [RCX + 0x50]
       1c0011aa4 81 fa 90        CMP        EDX,0x190
                 01 00 00
       1c0011aaa 0f 8f 7c        JG         LAB_1c0159c2c
                 81 14 00
       1c0011ab0 f6 d8           NEG        AL
       1c0011ab2 1b c0           SBB        EAX,EAX
       1c0011ab4 83 e0 02        AND        EAX,0x2
       1c0011ab7 c3              RET

`````


-------------------------------------------------------

case 90


`````shell
DOUBLE FETCH:   cr3 0x110f4d000, syscall 0x2c
   eip 0xfffff80179cb660e, user_address 0x7ff695510140, user_data 0x24df0, modrm 0x48, pc 0xfffff80179cb6613
   eip 0xfffff80179cb4b44, user_address 0x7ff695510140, user_data 0x24df0, modrm 0x48, pc 0xfffff80179cb4b49

DOUBLE FETCH:   cr3 0x110f4d000, syscall 0x2c
   eip 0xfffff80179cb660e, user_address 0x7ff6955100f0, user_data 0x5632d707, modrm 0x48, pc 0xfffff80179cb661a
   eip 0xfffff80179cb4b44, user_address 0x7ff6955100f0, user_data 0x5632d707, modrm 0x40, pc 0xfffff80179cb4b4e

`````


`````shell
       14042c5e2 89 5c 24 68     MOV        dword ptr [RSP + local_90],EBX
       14042c5e6 48 89 5c        MOV        qword ptr [RSP + local_88],RBX
                 24 70
       14042c5eb 8b 84 24        MOV        EAX,dword ptr [RSP + param_7]
                 30 01 00 00
       14042c5f2 88 44 24 6c     MOV        byte ptr [RSP + local_8c],AL
       14042c5f6 8b 84 24        MOV        EAX,dword ptr [RSP + param_8]
                 38 01 00 00
       14042c5fd 88 44 24 6d     MOV        byte ptr [RSP + local_8b],AL
       14042c601 45 85 f6        TEST       R14D,R14D
       14042c604 74 2d           JZ         LAB_14042c633
       14042c606 48 8b ce        MOV        param_1,RSI
       14042c609 e8 9a ab        CALL       RtlImageNtHeader                                 undefined RtlImageNtHeader()
                 c5 ff
       14042c60e 48 85 c0        TEST       RAX,RAX
       14042c611 74 17           JZ         LAB_14042c62a
   --1 14042c613 8b 48 58        MOV        param_1,dword ptr [RAX + 0x58]
       14042c616 89 4c 24 64     MOV        dword ptr [RSP + local_94],param_1
   --2 14042c61a 8b 48 08        MOV        param_1,dword ptr [RAX + 0x8]
       14042c61d 89 4c 24 68     MOV        dword ptr [RSP + local_90],param_1
       14042c621 48 8b 40 30     MOV        RAX,qword ptr [RAX + 0x30]
       14042c625 48 89 44        MOV        qword ptr [RSP + local_88],RAX
                 24 70
                             LAB_14042c62a                                   XREF[1]:     14042c611(j)  
       14042c62a eb 07           JMP        LAB_14042c633
       14042c62c 33 db           XOR        EBX,EBX
       14042c62e 48 8b 7c        MOV        RDI,qword ptr [RSP + 0x38]
                 24 38

`````


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_14042ab24()
             undefined         AL:1           <RETURN>
                             FUN_14042ab24                                   XREF[4]:     1403589b4(*), 
                                                                                          FUN_14042b7f0:14042b96f(c), 
                                                                                          FUN_14046eb0c:14046ebe4(c), 
                                                                                          FUN_140665204:1406652ed(c)  
       14042ab24 40 53           PUSH       RBX
       14042ab26 48 83 ec 20     SUB        RSP,0x20
       14042ab2a 48 8b da        MOV        RBX,RDX
       14042ab2d 33 c0           XOR        EAX,EAX
       14042ab2f 48 89 02        MOV        qword ptr [RDX],RAX
       14042ab32 e8 f9 b0        CALL       PsGetProcessSectionBaseAddress                   undefined PsGetProcessSectionBas
                 c5 ff
       14042ab37 48 85 c0        TEST       RAX,RAX
       14042ab3a 74 1a           JZ         LAB_14042ab56
       14042ab3c 48 8b c8        MOV        RCX,RAX
       14042ab3f e8 64 c6        CALL       RtlImageNtHeader                                 undefined RtlImageNtHeader()
                 c5 ff
       14042ab44 48 85 c0        TEST       RAX,RAX
       14042ab47 74 0b           JZ         LAB_14042ab54
   --1 14042ab49 8b 48 58        MOV        ECX,dword ptr [RAX + 0x58]
       14042ab4c 89 0b           MOV        dword ptr [RBX],ECX
   --2 14042ab4e 8b 40 08        MOV        EAX,dword ptr [RAX + 0x8]
       14042ab51 89 43 04        MOV        dword ptr [RBX + 0x4],EAX
                             LAB_14042ab54                                   XREF[1]:     14042ab47(j)  
       14042ab54 eb 00           JMP        LAB_14042ab56
                             LAB_14042ab56                                   XREF[2]:     14042ab3a(j), 14042ab54(j)  
       14042ab56 48 83 c4 20     ADD        RSP,0x20
       14042ab5a 5b              POP        RBX
       14042ab5b c3              RET

`````

------------------------------------------------------------------


case 91

***

1 need review

case 14


2 useless

`````shell
DOUBLE FETCH:   cr3 0x122fef000, syscall 0xb3
   eip 0xfffff80179d0d2cd, user_address 0x74e8a5f430, user_data 0x74e8a5f450, modrm 0x4f, pc 0xfffff80179d0d304
   eip 0xfffff80179c73030, user_address 0x74e8a5f430, user_data 0x74e8a5f450, modrm 0x78, pc 0xfffff80179c73108

DOUBLE FETCH:   cr3 0x122fef000, syscall 0xb3
   eip 0xfffff80179d0d2cd, user_address 0x74e8a5f450, user_data 0x2, modrm 0x1, pc 0xfffff80179d0d324
   eip 0xfffff80179c73030, user_address 0x74e8a5f450, user_data 0x40002, modrm 0x2, pc 0xfffff80179c732f1
`````


`````shell
       1404832f0 48 8b cf        MOV        RCX,RDI
       1404832f3 48 3b 3d        CMP        RDI,qword ptr [MmUserProbeAddress]               = ??
                 06 bf ef ff
       1404832fa 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d fe be 
                 ef ff
       140483302 8a 01           MOV        AL,byte ptr [RCX]
   --1 140483304 48 8b 4f 10     MOV        RCX,qword ptr [RDI + 0x10]
       140483308 48 89 8c        MOV        qword ptr [RSP + local_b8],RCX
                 24 a0 00 
                 00 00
       140483310 48 85 c9        TEST       RCX,RCX
       140483313 74 49           JZ         LAB_14048335e
       140483315 48 3b 0d        CMP        RCX,qword ptr [MmUserProbeAddress]               = ??
                 e4 be ef ff
       14048331c 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d dc be 
                 ef ff
   --2 140483324 8a 01           MOV        AL,byte ptr [RCX]
       140483326 48 8b 84        MOV        RAX,qword ptr [RSP + local_b8]
                 24 a0 00 
                 00 00
       14048332e 0f 10 00        MOVUPS     XMM0,xmmword ptr [RAX]
       140483331 0f 11 84        MOVUPS     xmmword ptr [RSP + local_c8[0]],XMM0
                 24 90 00 
                 00 00
       140483339 66 0f 7e c0     MOVD       EAX,XMM0
       14048333d 66 85 c0        TEST       AX,AX
       140483340 74 1c           JZ         LAB_14048335e
       140483342 0f b7 d0        MOVZX      EDX,AX
       140483345 48 8b 8c        MOV        RCX,qword ptr [RSP + local_c8[8]]
                 24 98 00 
                 00 00

`````



`````shell
                             LAB_1403e90fb                                   XREF[1]:     1403e90f1(j)
       1403e90fb a9 0d e0        TEST       EAX,0xfffee00d
                 fe ff
       1403e9100 0f 85 9a        JNZ        LAB_1403e91a0
                 00 00 00
       1403e9106 89 03           MOV        dword ptr [RBX],EAX
   --1 1403e9108 4d 8b 78 10     MOV        R15,qword ptr [param_3 + 0x10]
       1403e910c 4c 89 7c        MOV        qword ptr [RSP + local_48],R15
                 24 50
       1403e9111 49 8b 48 20     MOV        param_1,qword ptr [param_3 + 0x20]
       1403e9115 48 89 4c        MOV        qword ptr [RSP + local_40],param_1
                 24 58
       1403e911a 4d 8b 70 28     MOV        R14,qword ptr [param_3 + 0x28]
       1403e911e 4c 89 74        MOV        qword ptr [RSP + local_58],R14
                 24 40
       1403e9123 4d 85 f6        TEST       R14,R14
       1403e9126 0f 84 8e        JZ         LAB_1403e91ba
                 00 00 00
       1403e912c 40 84 f6        TEST       SIL,SIL
       1403e912f 74 3f           JZ         LAB_1403e9170
       1403e9131 65 48 8b        MOV        RAX,qword ptr GS:[0x188]
                 04 25 88
                 01 00 00

`````

`````shell
       1403e92c5 65 48 8b        MOV        RAX,qword ptr GS:[0x188]
                 04 25 88 
                 01 00 00
       1403e92ce 0f b6 88        MOVZX      ECX,byte ptr [RAX + 0x232]
                 32 02 00 00
       1403e92d5 41 88 4b 18     MOV        byte ptr [R11 + local_res18],CL
       1403e92d9 84 c9           TEST       CL,CL
       1403e92db 0f 84 5d        JZ         LAB_1403e943e
                 01 00 00
       1403e92e1 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 18 5f f9 ff
       1403e92e8 48 3b d0        CMP        RDX,RAX
       1403e92eb 0f 83 5a        JNC        LAB_1403e944b
                 01 00 00
                             LAB_1403e92f1                                   XREF[1]:     1403e944e(j)  
   --2 1403e92f1 8b 02           MOV        EAX,dword ptr [RDX]
       1403e92f3 89 44 24 40     MOV        dword ptr [RSP + local_38[0]],EAX
       1403e92f7 48 8b 4a 08     MOV        RCX,qword ptr [RDX + 0x8]
       1403e92fb 48 89 4c        MOV        qword ptr [RSP + local_38[8]],RCX
                 24 48
       1403e9300 66 85 c0        TEST       AX,AX
       1403e9303 74 28           JZ         LAB_1403e932d
       1403e9305 f6 c1 01        TEST       CL,0x1
       1403e9308 0f 85 45        JNZ        LAB_1403e9453
                 01 00 00
       1403e930e 0f b7 d0        MOVZX      EDX,AX
       1403e9311 48 03 d1        ADD        RDX,RCX
       1403e9314 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 e5 5e f9 ff
       1403e931b 48 3b d0        CMP        RDX,RAX
       1403e931e 0f 87 34        JA         LAB_1403e9458
                 01 00 00

`````

------------------------------------------

case 92

useless

0xfffff80179c41a95 - 0xfffff801799bcd00 = 284D95

1403b7a95 - 140132d00 = 284D95


`````shell
DOUBLE FETCH:   cr3 0x121a56000, syscall 0x191
   eip 0xfffff80179c41a55, user_address 0x2807e0001a2, user_data 0x5c, modrm 0x1, pc 0xfffff80179c41a95
   eip 0xfffff801799bccf0, user_address 0x2807e0001a2, user_data 0x5c, modrm 0x1, pc 0xfffff801799bcd00
`````

`````shell
       1403b7a6c 41 8b 06        MOV        EAX,dword ptr [R14]
       1403b7a6f 89 44 24 60     MOV        dword ptr [RSP + local_388[0]],EAX
       1403b7a73 49 8b 4e 08     MOV        RCX,qword ptr [R14 + 0x8]
       1403b7a77 48 89 4c        MOV        qword ptr [RSP + local_388[8]],RCX
                 24 68
       1403b7a7c bb 3e 00        MOV        EBX,0x3e
                 00 00
       1403b7a81 66 3b c3        CMP        AX,BX
       1403b7a84 75 2e           JNZ        LAB_1403b7ab4
       1403b7a86 48 3b 0d        CMP        RCX,qword ptr [MmUserProbeAddress]               = ??
                 73 77 fc ff
       1403b7a8d 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 6b 77 
                 fc ff
   --> 1403b7a95 8a 01           MOV        AL,byte ptr [RCX]
       1403b7a97 44 8b c3        MOV        R8D,EBX
       1403b7a9a 48 8d 3d        LEA        RDI,[u_\SystemRoot\System32\win32k.sys_1402ccb   = u"\\SystemRoot\\System32\\win3
                 9f 50 f1 ff
       1403b7aa1 48 8b d7        MOV        RDX=>u_\SystemRoot\System32\win32k.sys_1402ccb   = u"\\SystemRoot\\System32\\win3
       1403b7aa4 48 8b 4c        MOV        RCX,qword ptr [RSP + local_388[8]]
                 24 68
       1403b7aa9 e8 42 b2        CALL       memcmp                                           int memcmp(void * _Buf1, void * 
                 d7 ff
       1403b7aae 85 c0           TEST       EAX,EAX
       1403b7ab0 75 0c           JNZ        LAB_1403b7abe
       1403b7ab2 eb 14           JMP        LAB_1403b7ac8

`````

`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             int __fastcall memcmp(void * _Buf1, void * _Buf2, size_t
             int               EAX:4          <RETURN>
             void *            RCX:8          _Buf1
             void *            RDX:8          _Buf2
             size_t            R8:8           _Size
                             0x132cf0  2605  memcmp
                             Ordinal_2605                                    XREF[88]:    Entry Point(*), 
                             memcmp                                                       SeAccessCheckWithHint:14004dbed(
                                                                                          SeAccessCheckWithHint:14004dedb(
                                                                                          FUN_14004ebd0:14004ee25(c), 
                                                                                          FUN_14004ebd0:14004efc5(c), 
                                                                                          FUN_14004f290:14004f3d5(c), 
                                                                                          FUN_14004f290:14004f441(c), 
                                                                                          FUN_14004f6b0:14004f83d(c), 
                                                                                          RtlEqualSid:140050178(c), 
                                                                                          RtlSidHashLookup:14005c228(c), 
                                                                                          FUN_140085620:1400856b2(c), 
                                                                                          KeSetEvent:1401543f3(c), 
                                                                                          SeAccessCheckWithHint:1401690a4(
                                                                                          FUN_14004ebd0:140169892(c), 
                                                                                          FUN_14004f6b0:140169c50(c), 
                                                                                          IoRaiseInformationalHardError:14
                                                                                          IoRaiseInformationalHardError:14
                                                                                          FUN_1401c2308:1401c23e1(c), 
                                                                                          FUN_1402157d4:1402157ec(c), 
                                                                                          1403421cc(*), [more]
       140132cf0 48 2b d1        SUB        _Buf2,_Buf1
       140132cf3 49 83 f8 08     CMP        _Size,0x8
       140132cf7 72 22           JC         LAB_140132d1b
       140132cf9 f6 c1 07        TEST       _Buf1,0x7
       140132cfc 74 14           JZ         LAB_140132d12
       140132cfe 66 90           NOP
                             LAB_140132d00                                   XREF[1]:     140132d10(j)  
   --> 140132d00 8a 01           MOV        AL,byte ptr [_Buf1]
       140132d02 3a 04 0a        CMP        AL,byte ptr [_Buf2 + _Buf1*0x1]
       140132d05 75 2c           JNZ        LAB_140132d33
       140132d07 48 ff c1        INC        _Buf1
       140132d0a 49 ff c8        DEC        _Size
       140132d0d f6 c1 07        TEST       _Buf1,0x7
       140132d10 75 ee           JNZ        LAB_140132d00

`````

----------------------------------------------------------------

case 93


useless


opcode 8a 01 are all useless

`````shell
DOUBLE FETCH:   cr3 0x135311000, syscall 0xaa
   eip 0xfffff80179db9d10, user_address 0x11feff228, user_data 0x0, modrm 0x1, pc 0xfffff80179db9d78
   eip 0xfffff80179db9d10, user_address 0x11feff228, user_data 0x58000000, modrm 0x3f, pc 0xfffff80179db9d7a

DOUBLE FETCH:   cr3 0x135311000, syscall 0xaa
   eip 0xfffff80179db9d10, user_address 0x11feff220, user_data 0x0, modrm 0x1, pc 0xfffff80179db9d4e
   eip 0xfffff80179db9d10, user_address 0x11feff220, user_data 0x1dc13fe00, modrm 0x1b, pc 0xfffff80179db9db1
`````

`````shell
       14052fd35 8a 01           MOV        AL,byte ptr [param_1]
       14052fd37 41 84 dc        TEST       R12B,BL
       14052fd3a 75 20           JNZ        LAB_14052fd5c
       14052fd3c 48 8b cb        MOV        param_1,RBX
       14052fd3f 48 3b 1d        CMP        RBX,qword ptr [MmUserProbeAddress]               = ??
                 ba f4 e4 ff
       14052fd46 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d b2 f4 
                 e4 ff
   --2 14052fd4e 8a 01           MOV        AL,byte ptr [param_1]
       14052fd50 41 84 fc        TEST       R12B,DIL
       14052fd53 75 0c           JNZ        LAB_14052fd61
       14052fd55 eb 0f           JMP        LAB_14052fd66
                             LAB_14052fd57                                   XREF[1]:     14052fd21(j)  
       14052fd57 e8 b4 24        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 14 00
                             LAB_14052fd5c                                   XREF[1]:     14052fd3a(j)  
       14052fd5c e8 af 24        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 14 00
                             LAB_14052fd61                                   XREF[1]:     14052fd53(j)  
       14052fd61 e8 aa 24        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 14 00
                             LAB_14052fd66                                   XREF[1]:     14052fd55(j)  
       14052fd66 48 8b cf        MOV        param_1,RDI
       14052fd69 48 3b 3d        CMP        RDI,qword ptr [MmUserProbeAddress]               = ??
                 90 f4 e4 ff
       14052fd70 48 0f 43        CMOVNC     param_1,qword ptr [MmUserProbeAddress]           = ??
                 0d 88 f4 
                 e4 ff
   --1 14052fd78 8a 01           MOV        AL,byte ptr [param_1]
   --1 14052fd7a 48 8b 3f        MOV        RDI,qword ptr [RDI]
       14052fd7d 48 89 7d 30     MOV        qword ptr [RBP + local_110],RDI
       14052fd81 eb 05           JMP        LAB_14052fd88
       14052fd83 e9 e8 04        JMP        LAB_140530270
                 00 00
                             LAB_14052fd88                                   XREF[2]:     14052fd81(j), 1405c04cf(j)  
       14052fd88 48 b8 00        MOV        RAX,0xfffffffe000
                 e0 ff ff 
                 ff 0f 00 00
       14052fd92 48 3b f8        CMP        RDI,RAX
       14052fd95 0f 87 86        JA         LAB_1405c0721
                 09 09 00
       14052fd9b 48 81 ff        CMP        RDI,0x100000
                 00 00 10 00
       14052fda2 0f 8c 79        JL         LAB_1405c0721
                 09 09 00
       14052fda8 40 84 f6        TEST       SIL,SIL
       14052fdab 0f 84 23        JZ         LAB_1405c04d4
                 07 09 00
   --2 14052fdb1 48 8b 1b        MOV        RBX,qword ptr [RBX]
       14052fdb4 48 89 5d 58     MOV        qword ptr [RBP + local_e8],RBX
       14052fdb8 eb 05           JMP        LAB_14052fdbf
       14052fdba e9 b1 04        JMP        LAB_140530270
                 00 00

`````


---------------------------------------------

case 94


useless

`````shell
DOUBLE FETCH:   cr3 0x135311000, syscall 0x12e
   eip 0xfffff80179c8e8c6, user_address 0x11fe7e618, user_data 0x4e, modrm 0x1, pc 0xfffff80179c8e8dd
   eip 0xfffff80179c8e8c6, user_address 0x11fe7e618, user_data 0x4e, modrm 0x30, pc 0xfffff80179c8e90b
`````

`````shell
                             LAB_1404048b5                                   XREF[1]:     140404542(j)  
       1404048b5 48 8b d3        MOV        param_2,RBX
       1404048b8 41 b8 02        MOV        param_3,0x2
                 00 00 00
       1404048be 49 8b c9        MOV        param_1,param_4
       1404048c1 e8 5a ee        CALL       ProbeForWrite                                    undefined ProbeForWrite()
                 fe ff
       1404048c6 4c 8b 84        MOV        param_3,qword ptr [RSP + param_6]
                 24 08 01 
                 00 00
       1404048ce 49 8b c8        MOV        param_1,param_3
       1404048d1 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 28 a9 f7 ff
       1404048d8 4c 3b c0        CMP        param_3,RAX
       1404048db 73 37           JNC        LAB_140404914
                             LAB_1404048dd                                   XREF[1]:     140404917(j)  
   --> 1404048dd 8b 01           MOV        EAX,dword ptr [param_1]
       1404048df 89 01           MOV        dword ptr [param_1],EAX
       1404048e1 48 8b 94        MOV        param_2,qword ptr [RSP + param_7]
                 24 10 01 
                 00 00
       1404048e9 48 85 d2        TEST       param_2,param_2
       1404048ec 74 13           JZ         LAB_140404901
       1404048ee 48 8b ca        MOV        param_1,param_2
       1404048f1 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 08 a9 f7 ff
       1404048f8 48 3b d0        CMP        param_2,RAX
       1404048fb 73 1c           JNC        LAB_140404919
                             LAB_1404048fd                                   XREF[1]:     14040491c(j)  
       1404048fd 8b 01           MOV        EAX,dword ptr [param_1]
       1404048ff 89 01           MOV        dword ptr [param_1],EAX
                             LAB_140404901                                   XREF[1]:     1404048ec(j)  
       140404901 80 bc 24        CMP        byte ptr [RSP + param_5],0x0
                 00 01 00 
                 00 00
       140404909 75 05           JNZ        LAB_140404910
   --> 14040490b 41 8b 30        MOV        ESI,dword ptr [param_3]
       14040490e eb 0e           JMP        LAB_14040491e

`````
-------------------------------------------------------

case 95

***

need review

`````shell
DOUBLE FETCH:   cr3 0x135311000, syscall 0x28
   eip 0xfffff80179cebc09, user_address 0x7dfb76ba0ff8, user_data 0x0, modrm 0x2, pc 0xfffff80179cebc32
   eip 0xfffff801798ae03e, user_address 0x7dfb76ba0ff8, user_data 0x0, modrm 0x80, pc 0xfffff801798ae298
`````

0xfffff80179cebc32 - 0xfffff801798ae298 = 43D99A

140461c32 - 140024298 = 43D99A

`````shell
                             LAB_140461c15                                   XREF[1]:     140461c95(j)  
       140461c15 48 89 74        MOV        qword ptr [RSP + local_f8],RSI
                 24 20
       140461c1a 48 85 f6        TEST       RSI,RSI
       140461c1d 0f 84 8f        JZ         LAB_140461cb2
                 00 00 00
       140461c23 4c 8b c3        MOV        R8,RBX
       140461c26 48 8d 93        LEA        RDX,[RBX + 0xff8]
                 f8 0f 00 00
       140461c2d 48 89 54        MOV        qword ptr [RSP + local_f0],RDX
                 24 28
                             LAB_140461c32                                   XREF[1]:     140461c4f(j)  
   --> 140461c32 48 8b 02        MOV        RAX,qword ptr [RDX]
       140461c35 49 0b 00        OR         RAX,qword ptr [R8]
       140461c38 75 17           JNZ        LAB_140461c51
       140461c3a 49 83 c0 08     ADD        R8,0x8
       140461c3e 4c 89 44        MOV        qword ptr [RSP + local_d8],R8
                 24 40
       140461c43 48 83 ea 08     SUB        RDX,0x8
       140461c47 48 89 54        MOV        qword ptr [RSP + local_f0],RDX
                 24 28
       140461c4c 4c 3b c2        CMP        R8,RDX
       140461c4f 76 e1           JBE        LAB_140461c32

`````

`````shell
                             LAB_14002425a                                   XREF[1]:     140024c15(j)  
       14002425a 66 41 83        CMP        word ptr [R14 + 0x20],0x1
                 7e 20 01
       140024260 0f 85 b5        JNZ        LAB_140024c1b
                 09 00 00
       140024266 41 0f b6        MOVZX      EAX,byte ptr [R14 + 0x22]
                 46 22
       14002426b 24 c0           AND        AL,0xc0
       14002426d 3c 40           CMP        AL,0x40
       14002426f 0f 85 a6        JNZ        LAB_140024c1b
                 09 00 00
       140024275 44 8b 4c        MOV        R9D,dword ptr [RSP + local_204]
                 24 34
       14002427a 41 84 46 23     TEST       byte ptr [R14 + 0x23],AL
       14002427e 75 28           JNZ        LAB_1400242a8
       140024280 49 8b c7        MOV        RAX,R15
       140024283 48 c1 e0 19     SHL        RAX,0x19
       140024287 48 c1 f8 10     SAR        RAX,0x10
       14002428b 41 f6 c1 02     TEST       R9B,0x2
       14002428f 0f 85 ca        JNZ        LAB_140024a5f
                 07 00 00
       140024295 48 8b 08        MOV        RCX,qword ptr [RAX]
   --> 140024298 48 8b 80        MOV        RAX,qword ptr [RAX + 0xff8]
                 f8 0f 00 00
       14002429f 48 0b c1        OR         RAX,RCX
       1400242a2 0f 84 b7        JZ         LAB_140024a5f
                 07 00 00
                             LAB_1400242a8                                   XREF[2]:     14002427e(j), 140024c20(j)  
       1400242a8 41 f6 c1 02     TEST       R9B,0x2
       1400242ac 0f 85 15        JNZ        LAB_14015c9c7
                 87 13 00

`````

---------------------------------------------------

case 96

***

need review

`````shell
DOUBLE FETCH:   cr3 0x0, syscall 0x0
   eip 0xfffff80179fe317a, user_address 0x21d3d8cfffb, user_data 0x39, modrm 0x6, pc 0xfffff80179fe317a
   eip 0xfffff80179fe31a6, user_address 0x21d3d8cfffb, user_data 0x39, modrm 0x6, pc 0xfffff80179fe31b9

DOUBLE FETCH:   cr3 0x0, syscall 0x0
   eip 0xfffff80179fe3186, user_address 0x21d3d8cfffc, user_data 0x39, modrm 0x47, pc 0xfffff80179fe3186
   eip 0xfffff80179fe31a6, user_address 0x21d3d8cfffc, user_data 0x39, modrm 0x47, pc 0xfffff80179fe31c1
`````

`````shell
                             LAB_140759151                                   XREF[1]:     1407590e6(j)  
       140759151 80 7f 03 2f     CMP        byte ptr [RDI + 0x3],0x2f
       140759155 75 91           JNZ        LAB_1407590e8
       140759157 8a 47 ff        MOV        AL,byte ptr [RDI + -0x1]
       14075915a 2a c3           SUB        AL,BL
       14075915c 3c 09           CMP        AL,0x9
       14075915e 77 88           JA         LAB_1407590e8
       140759160 8a 47 01        MOV        AL,byte ptr [RDI + 0x1]
       140759163 2a c3           SUB        AL,BL
       140759165 3c 09           CMP        AL,0x9
       140759167 0f 87 7b        JA         LAB_1407590e8
                 ff ff ff
       14075916d 8a 47 02        MOV        AL,byte ptr [RDI + 0x2]
       140759170 2a c3           SUB        AL,BL
       140759172 3c 09           CMP        AL,0x9
       140759174 0f 87 6e        JA         LAB_1407590e8
                 ff ff ff
   --1 14075917a 8a 06           MOV        AL,byte ptr [RSI]
       14075917c 2a c3           SUB        AL,BL
       14075917e 3c 09           CMP        AL,0x9
       140759180 0f 87 62        JA         LAB_1407590e8
                 ff ff ff
   --2 140759186 8a 47 05        MOV        AL,byte ptr [RDI + 0x5]
       140759189 2a c3           SUB        AL,BL
       14075918b 3c 09           CMP        AL,0x9
       14075918d 0f 87 55        JA         LAB_1407590e8
                 ff ff ff
       140759193 48 8d 57 fe     LEA        RDX,[RDI + -0x2]
       140759197 41 b8 05        MOV        R8D,0x5
                 00 00 00
       14075919d 48 8d 4d d5     LEA        RCX=>local_63,[RBP + -0x2b]
       1407591a1 e8 da 45        CALL       RtlCopyMemory                                    void * RtlCopyMemory(void * _Dst
                 9f ff
       1407591a6 0f b6 4d d5     MOVZX      ECX=>local_63,byte ptr [RBP + -0x2b]
       1407591aa 8a 45 d5        MOV        AL,byte ptr [RBP + local_63]
       1407591ad 2a c3           SUB        AL,BL
       1407591af c6 45 da 00     MOV        byte ptr [RBP + local_5e],0x0
       1407591b3 3c 09           CMP        AL,0x9
       1407591b5 c6 45 d7 00     MOV        byte ptr [RBP + local_61],0x0
   --1 1407591b9 8a 06           MOV        AL,byte ptr [RSI]
       1407591bb 0f 47 cb        CMOVA      ECX,EBX
       1407591be 88 45 d2        MOV        byte ptr [RBP + local_66],AL
   --2 1407591c1 8a 47 05        MOV        AL,byte ptr [RDI + 0x5]
       1407591c4 33 d2           XOR        EDX,EDX
       1407591c6 88 4d d5        MOV        byte ptr [RBP + local_63],CL
       1407591c9 48 8d 4d d2     LEA        RCX=>local_66,[RBP + -0x2e]
       1407591cd 88 45 d3        MOV        byte ptr [RBP + local_65],AL
       1407591d0 c6 45 d4 00     MOV        byte ptr [RBP + local_64],0x0
       1407591d4 44 8d 42 10     LEA        R8D,[RDX + 0x10]
       1407591d8 e8 0b b4        CALL       FUN_1401345e8                                    undefined FUN_1401345e8()
                 9d ff

`````

-----------------------------------------------------------

case 97

***

need review

`````shell
DOUBLE FETCH:   cr3 0x0, syscall 0x0
   eip 0xfffff80179fe3275, user_address 0x21d3d8c5a32, user_data 0x31, modrm 0x47, pc 0xfffff80179fe316d
   eip 0xfffff801799d7780, user_address 0x21d3d8c5a32, user_data 0x31, modrm 0x44, pc 0xfffff801799d7960

DOUBLE FETCH:   cr3 0x0, syscall 0x0
   eip 0xfffff80179fe3275, user_address 0x21d3d8c5a31, user_data 0x30, modrm 0x47, pc 0xfffff80179fe3160
   eip 0xfffff801799d7780, user_address 0x21d3d8c5a31, user_data 0x30, modrm 0x44, pc 0xfffff801799d7960

DOUBLE FETCH:   cr3 0x0, syscall 0x0
   eip 0xfffff80179fe3275, user_address 0x21d3d8c5a2f, user_data 0x34, modrm 0x47, pc 0xfffff80179fe3157
   eip 0xfffff801799d7780, user_address 0x21d3d8c5a2f, user_data 0x34, modrm 0x44, pc 0xfffff801799d7960
`````

`````shell
                             LAB_140759151                                   XREF[1]:     1407590e6(j)  
       140759151 80 7f 03 2f     CMP        byte ptr [RDI + 0x3],0x2f
       140759155 75 91           JNZ        LAB_1407590e8
   --1 140759157 8a 47 ff        MOV        AL,byte ptr [RDI + -0x1]
       14075915a 2a c3           SUB        AL,BL
       14075915c 3c 09           CMP        AL,0x9
       14075915e 77 88           JA         LAB_1407590e8
   --2 140759160 8a 47 01        MOV        AL,byte ptr [RDI + 0x1]
       140759163 2a c3           SUB        AL,BL
       140759165 3c 09           CMP        AL,0x9
       140759167 0f 87 7b        JA         LAB_1407590e8
                 ff ff ff
   --3 14075916d 8a 47 02        MOV        AL,byte ptr [RDI + 0x2]
       140759170 2a c3           SUB        AL,BL
       140759172 3c 09           CMP        AL,0x9
       140759174 0f 87 6e        JA         LAB_1407590e8
                 ff ff ff
   --x 14075917a 8a 06           MOV        AL,byte ptr [RSI]
       14075917c 2a c3           SUB        AL,BL
       14075917e 3c 09           CMP        AL,0x9
       140759180 0f 87 62        JA         LAB_1407590e8
                 ff ff ff
   --y 140759186 8a 47 05        MOV        AL,byte ptr [RDI + 0x5]
       140759189 2a c3           SUB        AL,BL
       14075918b 3c 09           CMP        AL,0x9
       14075918d 0f 87 55        JA         LAB_1407590e8
                 ff ff ff
       140759193 48 8d 57 fe     LEA        RDX,[RDI + -0x2]
       140759197 41 b8 05        MOV        R8D,0x5
                 00 00 00
       14075919d 48 8d 4d d5     LEA        RCX=>local_63,[RBP + -0x2b]
       1407591a1 e8 da 45        CALL       RtlCopyMemory                                    void * RtlCopyMemory(void * _Dst
                 9f ff
       1407591a6 0f b6 4d d5     MOVZX      ECX=>local_63,byte ptr [RBP + -0x2b]
       1407591aa 8a 45 d5        MOV        AL,byte ptr [RBP + local_63]
       1407591ad 2a c3           SUB        AL,BL
       1407591af c6 45 da 00     MOV        byte ptr [RBP + local_5e],0x0
       1407591b3 3c 09           CMP        AL,0x9
       1407591b5 c6 45 d7 00     MOV        byte ptr [RBP + local_61],0x0
   --x 1407591b9 8a 06           MOV        AL,byte ptr [RSI]
       1407591bb 0f 47 cb        CMOVA      ECX,EBX
       1407591be 88 45 d2        MOV        byte ptr [RBP + local_66],AL
   --y 1407591c1 8a 47 05        MOV        AL,byte ptr [RDI + 0x5]
       1407591c4 33 d2           XOR        EDX,EDX
       1407591c6 88 4d d5        MOV        byte ptr [RBP + local_63],CL
       1407591c9 48 8d 4d d2     LEA        RCX=>local_66,[RBP + -0x2e]
       1407591cd 88 45 d3        MOV        byte ptr [RBP + local_65],AL
       1407591d0 c6 45 d4 00     MOV        byte ptr [RBP + local_64],0x0
       1407591d4 44 8d 42 10     LEA        R8D,[RDX + 0x10]
       1407591d8 e8 0b b4        CALL       FUN_1401345e8                                    undefined FUN_1401345e8()
                 9d ff

`````

`````shell
RtlCopyMemory

                             LAB_14014d940                                   XREF[1]:     14014d94f(j)
       14014d940 48 8b 44        MOV        RAX,qword ptr [_Src + _Dst*0x1 + -0x8]
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
 --1 2 14014d960 8a 44 0a ff     MOV        AL,byte ptr [_Src + _Dst*0x1 + -0x1]
       14014d964 48 ff c9        DEC        _Dst
       14014d967 49 ff c8        DEC        _Size
       14014d96a 88 01           MOV        byte ptr [_Dst],AL
       14014d96c 75 f2           JNZ        LAB_14014d960

`````

----------------------------------------

case 98


*** 

need review

see also case 96

`````shell
DOUBLE FETCH:   cr3 0x0, syscall 0x0
   eip 0xfffff80179fe3275, user_address 0x21d3d8c5a34, user_data 0x32, modrm 0x6, pc 0xfffff80179fe317a
   eip 0xfffff8017a002dce, user_address 0x21d3d8c5a34, user_data 0x32, modrm 0x6, pc 0xfffff8017a002dfd
   
DOUBLE FETCH:   cr3 0x0, syscall 0x0
   eip 0xfffff80179fe3275, user_address 0x21d3d8c5a35, user_data 0x30, modrm 0x47, pc 0xfffff80179fe3186
   eip 0xfffff8017a002dce, user_address 0x21d3d8c5a35, user_data 0x30, modrm 0x47, pc 0xfffff8017a002e02
`````


`````shell
                             LAB_140759151                                   XREF[1]:     1407590e6(j)  
       140759151 80 7f 03 2f     CMP        byte ptr [RDI + 0x3],0x2f
       140759155 75 91           JNZ        LAB_1407590e8
       140759157 8a 47 ff        MOV        AL,byte ptr [RDI + -0x1]
       14075915a 2a c3           SUB        AL,BL
       14075915c 3c 09           CMP        AL,0x9
       14075915e 77 88           JA         LAB_1407590e8
       140759160 8a 47 01        MOV        AL,byte ptr [RDI + 0x1]
       140759163 2a c3           SUB        AL,BL
       140759165 3c 09           CMP        AL,0x9
       140759167 0f 87 7b        JA         LAB_1407590e8
                 ff ff ff
       14075916d 8a 47 02        MOV        AL,byte ptr [RDI + 0x2]
       140759170 2a c3           SUB        AL,BL
       140759172 3c 09           CMP        AL,0x9
       140759174 0f 87 6e        JA         LAB_1407590e8
                 ff ff ff
   --1 14075917a 8a 06           MOV        AL,byte ptr [RSI]
       14075917c 2a c3           SUB        AL,BL
       14075917e 3c 09           CMP        AL,0x9
       140759180 0f 87 62        JA         LAB_1407590e8
                 ff ff ff
   --2 140759186 8a 47 05        MOV        AL,byte ptr [RDI + 0x5]
       140759189 2a c3           SUB        AL,BL
       14075918b 3c 09           CMP        AL,0x9
       14075918d 0f 87 55        JA         LAB_1407590e8
                 ff ff ff
       140759193 48 8d 57 fe     LEA        RDX,[RDI + -0x2]
       140759197 41 b8 05        MOV        R8D,0x5
                 00 00 00
       14075919d 48 8d 4d d5     LEA        RCX=>local_63,[RBP + -0x2b]
       1407591a1 e8 da 45        CALL       RtlCopyMemory                                    void * RtlCopyMemory(void * _Dst
                 9f ff
       1407591a6 0f b6 4d d5     MOVZX      ECX=>local_63,byte ptr [RBP + -0x2b]
       1407591aa 8a 45 d5        MOV        AL,byte ptr [RBP + local_63]
       1407591ad 2a c3           SUB        AL,BL

`````


`````shell
                             LAB_140778dce                                   XREF[3]:     14037cbf8(*), 14037cc00(*), 
                                                                                          14075922e(j)  
       140778dce 8a 57 07        MOV        DL,byte ptr [RDI + 0x7]
       140778dd1 8a c2           MOV        AL,DL
       140778dd3 2a c3           SUB        AL,BL
       140778dd5 3c 09           CMP        AL,0x9
       140778dd7 0f 87 57        JA         LAB_140759234
                 04 fe ff
       140778ddd 0f b7 0e        MOVZX      ECX,word ptr [RSI]
       140778de0 0f b7 05        MOVZX      EAX,word ptr [DAT_1407706f0]                     = 3931h
                 09 79 ff ff
       140778de7 3b c8           CMP        ECX,EAX
       140778de9 74 12           JZ         LAB_140778dfd
       140778deb 0f b7 0e        MOVZX      ECX,word ptr [RSI]
       140778dee 0f b7 05        MOVZX      EAX,word ptr [DAT_140770700]                     = 3032h
                 0b 79 ff ff
       140778df5 3b c8           CMP        ECX,EAX
       140778df7 0f 85 37        JNZ        LAB_140759234
                 04 fe ff
                             LAB_140778dfd                                   XREF[1]:     140778de9(j)  
   --1 140778dfd 8a 06           MOV        AL,byte ptr [RSI]
       140778dff 88 45 d0        MOV        byte ptr [RBP + local_68],AL
   --2 140778e02 8a 47 05        MOV        AL,byte ptr [RDI + 0x5]
       140778e05 88 45 d1        MOV        byte ptr [RBP + local_68+0x1],AL
       140778e08 44 88 45 d2     MOV        byte ptr [RBP + local_66],R8B
       140778e0c 88 55 d3        MOV        byte ptr [RBP + local_65],DL
       140778e0f e9 2f 04        JMP        LAB_140759243
                 fe ff
                             LAB_140778e14                                   XREF[1]:     1407590fb(j)  
       140778e14 41 c6 06 00     MOV        byte ptr [R14],0x0
       140778e18 32 c0           XOR        AL,AL
       140778e1a e9 0e 03        JMP        LAB_14075912d
                 fe ff
                             LAB_140778e1f                                   XREF[1]:     14037cc04(*)  
       140778e1f cc              INT3

`````
