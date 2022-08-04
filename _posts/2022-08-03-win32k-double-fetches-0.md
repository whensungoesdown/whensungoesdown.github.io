---
title: win32k double fetches, case 0 - case 50
published: true
---

case 0

***

need review

`````shell
DOUBLE FETCH:   cr3 0x11ec2f000, syscall 0x1005
   user_address 0x3234cfd2f0, user_data 0x80000000, modrm 0xb8, pc 0xfffff960cca34caf
   user_address 0x3234cfd2f0, user_data 0x80000000, modrm 0x88, pc 0xfffff960cca35035
`````


`````shell
                             0x34c30  1267  NtGdiFlushUserBatch
                             Ordinal_1267                                    XREF[5]:     Entry Point(*), 1c02f2ee0(*), 
                             NtGdiFlushUserBatch                                          1c0332a94(*), 1c03663f0(*), 
                                                                                          1c037c154(*)  
       1c0034c30 48 89 5c        MOV        qword ptr [RSP + local_res8],RBX
                 24 08
       1c0034c35 48 89 74        MOV        qword ptr [RSP + local_res10],RSI
                 24 10
       1c0034c3a 48 89 7c        MOV        qword ptr [RSP + local_res18],RDI
                 24 18
       1c0034c3f 4c 89 64        MOV        qword ptr [RSP + local_res20],R12
                 24 20
       1c0034c44 41 55           PUSH       R13
       1c0034c46 41 56           PUSH       R14
       1c0034c48 41 57           PUSH       R15
       1c0034c4a 48 81 ec        SUB        RSP,0x260
                 60 02 00 00
       1c0034c51 48 8b 05        MOV        RAX,qword ptr [DAT_1c0320fb8]                    = 00002B992DDFA232h
                 60 c3 2e 00
       1c0034c58 48 33 c4        XOR        RAX,RSP
       1c0034c5b 48 89 84        MOV        qword ptr [RSP + local_28],RAX
                 24 50 02 
                 00 00
       1c0034c63 65 48 8b        MOV        RAX,qword ptr GS:[0x30]
                 04 25 30 
                 00 00 00
       1c0034c6c 48 89 84        MOV        qword ptr [RSP + local_198],RAX
                 24 e0 00 
                 00 00
       1c0034c74 c7 84 24        MOV        dword ptr [RSP + local_1b4],0x1
                 c4 00 00 
                 00 01 00 
       1c0034c7f 8b 88 40        MOV        ECX,dword ptr [RAX + 0x1740]
                 17 00 00
       1c0034c85 89 8c 24        MOV        dword ptr [RSP + local_1dc],ECX
                 9c 00 00 00
       1c0034c8c 4c 8d a8        LEA        R13,[RAX + 0x300]
                 00 03 00 00
       1c0034c93 4c 89 ac        MOV        qword ptr [RSP + local_1e8],R13
                 24 90 00 
                 00 00
       1c0034c9b c7 80 40        MOV        dword ptr [RAX + 0x1740],0x0
                 17 00 00 
                 00 00 00 00
       1c0034ca5 81 a0 f0        AND        dword ptr [RAX + 0x2f0],0x80000000
                 02 00 00 
                 00 00 00 80
       1c0034caf 8b b8 f0        MOV        EDI,dword ptr [RAX + 0x2f0]
                 02 00 00
       1c0034cb5 eb 05           JMP        LAB_1c0034cbc
       1c0034cb7 e9 63 01        JMP        LAB_1c0034e1f
                 00 00

`````


`````shell
                             switchD_1c00350e8::caseD_c0034fee               XREF[17]:    1c0034fbc(j), 1c0034fd5(j), 
                                                                                          1c00350d7(j), 1c00350e8(j), 
                                                                                          1c0035137(j), 1c00351d5(j), 
                                                                                          1c00351eb(j), 1c003528c(j), 
                                                                                          1c00352ed(j), 1c00352f7(j), 
                                                                                          1c0035301(j), 1c0035370(j), 
                                                                                          1c003537d(j), 1c0035390(j), 
                                                                                          1c0162877(j), 1c0162882(j), 
                                                                                          1c016296b(j)  
       1c0034fee 8b 8c 24        MOV        ECX,dword ptr [RSP + local_1dc]
                 9c 00 00 00
       1c0034ff5 ff c9           DEC        ECX
       1c0034ff7 89 8c 24        MOV        dword ptr [RSP + local_1dc],ECX
                 9c 00 00 00
       1c0034ffe 41 8d 44        LEA        EAX,[R12 + 0x7]
                 24 07
       1c0035003 83 e0 f8        AND        EAX,0xfffffff8
       1c0035006 4c 03 e8        ADD        R13,RAX
       1c0035009 4c 89 ac        MOV        qword ptr [RSP + local_1e8],R13
                 24 90 00 
                 00 00
       1c0035011 85 c9           TEST       ECX,ECX
       1c0035013 0f 85 52        JNZ        LAB_1c003516b
                 01 00 00
                             LAB_1c0035019                                   XREF[2]:     1c0034f55(j), 1c003517d(j)  
       1c0035019 48 8b 84        MOV        RAX,qword ptr [RSP + local_198]
                 24 e0 00 
                 00 00
       1c0035021 c7 80 40        MOV        dword ptr [RAX + 0x1740],0x0
                 17 00 00 
                 00 00 00 00
       1c003502b 81 a0 f0        AND        dword ptr [RAX + 0x2f0],0x80000000
                 02 00 00 
                 00 00 00 80
   --> 1c0035035 8b 88 f0        MOV        ECX,dword ptr [RAX + 0x2f0]
                 02 00 00
       1c003503b 0f ba f1 1f     BTR        ECX,0x1f
       1c003503f 89 88 f0        MOV        dword ptr [RAX + 0x2f0],ECX
                 02 00 00
       1c0035045 eb 08           JMP        LAB_1c003504f
       1c0035047 4c 8b ac        MOV        R13,qword ptr [RSP + 0x90]
                 24 90 00 
                 00 00
                             LAB_1c003504f                                   XREF[1]:     1c0035045(j)  
       1c003504f 48 8b 44        MOV        RAX,qword ptr [RSP + local_200]
                 24 78
       1c0035054 48 8b 48 50     MOV        RCX,qword ptr [RAX + 0x50]
       1c0035058 48 8b 84        MOV        RAX,qword ptr [RSP + local_d8]
                 24 a0 01 
                 00 00
       1c0035060 48 89 41 10     MOV        qword ptr [RCX + 0x10],RAX
       1c0035064 48 8b 44        MOV        RAX,qword ptr [RSP + local_200]
                 24 78
       1c0035069 48 8b 48 50     MOV        RCX,qword ptr [RAX + 0x50]
       1c003506d 81 49 08        OR         dword ptr [RCX + 0x8],0x1000
                 00 10 00 00

`````

--------------------------------------------------------------------


case 1

8a 01 is also useless. The difference from 8a 01 is using which register.

`````shell
DOUBLE FETCH:   cr3 0x11ec2f000, syscall 0x10c3
   user_address 0x3234aee608, user_data 0x30, modrm 0x2, pc 0xfffff960cca76714
   user_address 0x3234aee608, user_data 0x30, modrm 0x7, pc 0xfffff960cca7671e
`````


`````shell
                             LAB_1c0076703                                   XREF[1]:     1c00766fb(j)  
       1c0076703 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 ee ae 2d 00
       1c007670a 48 8b d7        MOV        RDX,RDI
       1c007670d 48 3b 38        CMP        RDI,qword ptr [RAX]
       1c0076710 48 0f 43 10     CMOVNC     RDX,qword ptr [RAX]
   --> 1c0076714 8a 02           MOV        AL,byte ptr [RDX]
       1c0076716 88 02           MOV        byte ptr [RDX],AL
       1c0076718 8a 42 2f        MOV        AL,byte ptr [RDX + 0x2f]
       1c007671b 88 42 2f        MOV        byte ptr [RDX + 0x2f],AL
   --> 1c007671e 8b 07           MOV        EAX,dword ptr [RDI]
       1c0076720 89 44 24 60     MOV        dword ptr [RSP + local_68[0]],EAX
       1c0076724 eb 07           JMP        LAB_1c007672d
       1c0076726 33 db           XOR        EBX,EBX
       1c0076728 e9 a1 00        JMP        LAB_1c00767ce
                 00 00

`````

------------------------------------------------------------------------

case 2

useless

`````shell
DOUBLE FETCH:   cr3 0x11ec2f000, syscall 0x1091
   user_address 0x3234aeea60, user_data 0x2c, modrm 0x2, pc 0xfffff960cca55b2e
   user_address 0x3234aeea60, user_data 0x2c, modrm 0x7, pc 0xfffff960cca55b38
`````

`````shell
                             LAB_1c0055b1d                                   XREF[1]:     1c0055b15(j)  
       1c0055b1d 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 d4 ba 2f 00
       1c0055b24 48 8b d7        MOV        RDX,RDI
       1c0055b27 48 3b 38        CMP        RDI,qword ptr [RAX]
       1c0055b2a 48 0f 43 10     CMOVNC     RDX,qword ptr [RAX]
   --> 1c0055b2e 8a 02           MOV        AL,byte ptr [RDX]
       1c0055b30 88 02           MOV        byte ptr [RDX],AL
       1c0055b32 8a 42 2b        MOV        AL,byte ptr [RDX + 0x2b]
       1c0055b35 88 42 2b        MOV        byte ptr [RDX + 0x2b],AL
   --> 1c0055b38 8b 07           MOV        EAX,dword ptr [RDI]
       1c0055b3a 89 44 24 68     MOV        dword ptr [RSP + local_50[0]],EAX
       1c0055b3e eb 07           JMP        LAB_1c0055b47
       1c0055b40 33 db           XOR        EBX,EBX
       1c0055b42 e9 e7 00        JMP        LAB_1c0055c2e
                 00 00

`````

---------------------------------------------------------------------------

case 3

`````shell
DOUBLE FETCH:   cr3 0x1269cb000, syscall 0x100a
   user_address 0xf0810, user_data 0x4fe8bfb38e0f7a12, modrm 0xa, pc 0xfffff960ccad292a
   user_address 0xf0810, user_data 0x4fe8bfb38e0f7a12, modrm 0xa, pc 0xfffff960ccad292a
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
                             LAB_1c00d294a                                   XREF[1]:     1c00d293f(j)  
       1c00d294a 48 85 c9        TEST       RCX,RCX
       1c00d294d 74 0b           JZ         LAB_1c00d295a
       1c00d294f 41 ff c1        INC        R9D
       1c00d2952 41 83 f9 05     CMP        R9D,0x5
       1c00d2956 72 d2           JC         LAB_1c00d292a
       1c00d2958 eb 1a           JMP        LAB_1c00d2974
                             LAB_1c00d295a                                   XREF[1]:     1c00d294d(j)  
       1c00d295a 41 8b c9        MOV        ECX,R9D
       1c00d295d 48 8d 05        LEA        RAX,[DAT_1c02df590]
                 2c cc 20 00
       1c00d2964 48 c1 e1 05     SHL        RCX,0x5
       1c00d2968 41 b8 01        MOV        R8D,0x1
                 00 00 00
       1c00d296e 48 03 c8        ADD        RCX,RAX
       1c00d2971 48 89 0a        MOV        qword ptr [RDX],RCX=>DAT_1c02df590
                             LAB_1c00d2974                                   XREF[3]:     1c00d291d(j), 1c00d2922(j), 
                                                                                          1c00d2958(j)  
       1c00d2974 41 8b c0        MOV        EAX,R8D
       1c00d2977 c3              RET

`````

-----------------------------------------------------------------------


case 4

`````shell
DOUBLE FETCH:   cr3 0x1269cb000, syscall 0x10b2
   user_address 0x7ff658c29dc0, user_data 0x79006100720054, modrm 0x44, pc 0xfffff960ccb44f00
   user_address 0x7ff658c29dc0, user_data 0x79006100720054, modrm 0x44, pc 0xfffff960ccb44f00

DOUBLE FETCH:   cr3 0x1269cb000, syscall 0x10b2
   user_address 0x7ff658c29d88, user_data 0x54, modrm 0x44, pc 0xfffff960ccb44f20
   user_address 0x7ff658c29d88, user_data 0x54, modrm 0x44, pc 0xfffff960ccb44f20

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
                             LAB_1c0144f20                                   XREF[1]:     1c0144f2c(j)  
   --> 1c0144f20 8a 44 0a ff     MOV        AL,byte ptr [_Src + _Dst*0x1 + -0x1]
       1c0144f24 48 ff c9        DEC        _Dst
       1c0144f27 49 ff c8        DEC        _Size
       1c0144f2a 88 01           MOV        byte ptr [_Dst],AL
       1c0144f2c 75 f2           JNZ        LAB_1c0144f20
                             LAB_1c0144f2e                                   XREF[1]:     1c0144f15(j)  
       1c0144f2e 49 8b c3        MOV        RAX,R11
       1c0144f31 c3              RET
`````


----------------------------------------------------


case 5

***

need review

`````shell
DOUBLE FETCH:   cr3 0xb68ca000, syscall 0x100a
   user_address 0x290fcddd3fc, user_data 0x57, modrm 0x1, pc 0xfffff960cca739ba
   user_address 0x290fcddd3fc, user_data 0x64006e00690057, modrm 0x44, pc 0xfffff960ccb44f00
`````

`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c0072978()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x10]:8  local_res10                             XREF[2]:     1c007297d(W), 
                                                                                                   1c0072ac0(R)  
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1c0072978(W), 
                                                                                                   1c0072abc(R)  
             undefined1        Stack[-0x8]:1  local_8                                 XREF[1]:     1c0072ab4(*)  
             undefined8        Stack[-0x10]:8 local_10                                XREF[2]:     1c0072997(W), 
                                                                                                   1c0072aa8(R)  
             undefined4        Stack[-0x20]:4 local_20                                XREF[2]:     1c0172d44(W), 
                                                                                                   1c0172d4b(*)  
             undefined8        Stack[-0x28]:8 local_28                                XREF[1]:     1c0172c25(W)  
             undefined4        Stack[-0x30]:4 local_30                                XREF[2]:     1c0172c1a(W), 
                                                                                                   1c0172c21(*)  
             undefined8        Stack[-0x38]:8 local_38                                XREF[1]:     1c0172bd5(W)  
             undefined4        Stack[-0x40]:4 local_40                                XREF[2]:     1c0172bd1(*), 
                                                                                                   1c0172bd9(W)  
             undefined4        Stack[-0x50]:4 local_50                                XREF[4]:     1c0072b2c(W), 
                                                                                                   1c0072b33(*), 
                                                                                                   1c0172c97(W), 
                                                                                                   1c0172c9e(*)  
             undefined4        Stack[-0x58]:4 local_58                                XREF[2]:     1c0072a40(*), 
                                                                                                   1c0172bcd(R)  
             undefined4        Stack[-0x68]:4 local_68                                XREF[1]:     1c0172bff(W)  
                             FUN_1c0072978                                   XREF[3]:     FUN_1c00726e0:1c00726ea(c), 
                                                                                          1c02f79e0(*), 1c0334324(*)  
       1c0072978 48 89 5c        MOV        qword ptr [RSP + local_res8],RBX
                 24 08
       1c007297d 48 89 7c        MOV        qword ptr [RSP + local_res10],RDI
                 24 10
       1c0072982 55              PUSH       RBP
       1c0072983 48 8b ec        MOV        RBP,RSP
       1c0072986 48 81 ec        SUB        RSP,0x80
                 80 00 00 00
       1c007298d 48 8b 05        MOV        RAX,qword ptr [DAT_1c0320fb8]                    = 00002B992DDFA232h
                 24 e6 2a 00
       1c0072994 48 33 c4        XOR        RAX,RSP
       1c0072997 48 89 45 f8     MOV        qword ptr [RBP + local_10],RAX
       1c007299b ff 15 af        CALL       qword ptr [->WIN32KBASE.SYS::RIMWatchDog]
                 cc 2d 00
       1c00729a1 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::gPowerState]    = 0035a868
                 b0 cc 2d 00
       1c00729a8 8b 08           MOV        ECX,dword ptr [RAX]
       1c00729aa f6 c1 01        TEST       CL,0x1
       1c00729ad 0f 85 f5        JNZ        LAB_1c0072aa8
                 00 00 00
       1c00729b3 48 8b 0d        MOV        RCX,qword ptr [->WIN32KBASE.SYS::gafAsyncKeySt   = 00359662
                 5e c7 2d 00
   --> 1c00729ba 8a 01           MOV        AL,byte ptr [RCX]
       1c00729bc a8 04           TEST       AL,0x4
       1c00729be 0f 85 e4        JNZ        LAB_1c0072aa8
                 00 00 00
       1c00729c4 a8 10           TEST       AL,0x10
       1c00729c6 0f 85 dc        JNZ        LAB_1c0072aa8
                 00 00 00
       1c00729cc 8a 41 01        MOV        AL,byte ptr [RCX + 0x1]
       1c00729cf a8 01           TEST       AL,0x1
       1c00729d1 0f 85 d1        JNZ        LAB_1c0072aa8
                 00 00 00
       1c00729d7 a8 04           TEST       AL,0x4
       1c00729d9 0f 85 c9        JNZ        LAB_1c0072aa8
                 00 00 00
       1c00729df a8 10           TEST       AL,0x10
       1c00729e1 0f 85 c1        JNZ        LAB_1c0072aa8
                 00 00 00
       1c00729e7 ff 15 73        CALL       qword ptr [->WIN32KBASE.SYS::EtwTraceIdleStatus]
                 cc 2d 00

`````

`````shell
memcpy

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

--------------------------------------------------------------------

case 6


`````shell
DOUBLE FETCH:   cr3 0x1269cb000, syscall 0x100e
   user_address 0x2d1140, user_data 0x0, modrm 0x86, pc 0xfffff960ccdacc5b
   user_address 0x2d1140, user_data 0x0, modrm 0x86, pc 0xfffff960ccdacc5b
`````

`````shell
                             LAB_1c0211c3d                                   XREF[1]:     1c0211c37(j)  
       1c0211c3d 48 8b 0f        MOV        param_1,qword ptr [RDI]
                             LAB_1c0211c40                                   XREF[1]:     1c0211c3b(j)  
       1c0211c40 49 8b 86        MOV        RAX,qword ptr [R14 + 0x1b0]
                 b0 01 00 00
       1c0211c47 48 89 48 40     MOV        qword ptr [RAX + 0x40],param_1
       1c0211c4b 48 85 ff        TEST       RDI,RDI
       1c0211c4e 75 04           JNZ        LAB_1c0211c54
       1c0211c50 33 c9           XOR        param_1,param_1
       1c0211c52 eb 07           JMP        LAB_1c0211c5b
                             LAB_1c0211c54                                   XREF[1]:     1c0211c4e(j)  
       1c0211c54 48 8b 8f        MOV        param_1,qword ptr [RDI + 0x108]
                 08 01 00 00
                             LAB_1c0211c5b                                   XREF[1]:     1c0211c52(j)  
   --> 1c0211c5b 49 8b 86        MOV        RAX,qword ptr [R14 + 0x1b0]
                 b0 01 00 00
       1c0211c62 48 89 48 50     MOV        qword ptr [RAX + 0x50],param_1
       1c0211c66 ff 15 44        CALL       qword ptr [->WIN32KBASE.SYS::UserSessionSwitch
                 f6 13 00
       1c0211c6c be 60 00        MOV        ESI,0x60
                 00 00
       1c0211c71 8b ce           MOV        param_1,ESI
       1c0211c73 ff 15 3f        CALL       qword ptr [->WIN32KBASE.SYS::EtwTraceBeginCall
                 e1 13 00
       1c0211c79 48 83 63        AND        qword ptr [RBX + 0x10],0x0
                 10 00
       1c0211c7e 48 8d 44        LEA        RAX=>local_348,[RSP + 0x30]
                 24 30
       1c0211c83 48 89 44        MOV        qword ptr [RSP + local_358],RAX
                 24 20
       1c0211c88 4c 8d 4c        LEA        param_4=>local_328,[RSP + 0x50]
                 24 50
       1c0211c8d 44 8b 03        MOV        param_3,dword ptr [RBX]
       1c0211c90 48 8b d3        MOV        param_2,RBX
       1c0211c93 8b ce           MOV        param_1,ESI
       1c0211c95 ff 15 ed        CALL       qword ptr [->NTOSKRNL.EXE::KeUserModeCallback]
                 c8 13 00

`````


----------------------------------------------------------------

case 7

0xfffff960ccac2835 repeats 1807470 times.

`````shell
DOUBLE FETCH:   cr3 0x1269cb000, syscall 0x1083
   user_address 0x262e1e0, user_data 0xff000000, modrm 0x12, pc 0xfffff960ccac2835
   user_address 0x262e1e0, user_data 0xff000000, modrm 0x12, pc 0xfffff960ccac2835
`````

`````shell
                             LAB_1c00c2800                                   XREF[1]:     1c00c2881(j)  
       1c00c2800 8b 41 38        MOV        EAX,dword ptr [RCX + 0x38]
       1c00c2803 45 33 c0        XOR        R8D,R8D
       1c00c2806 44 8b 74        MOV        R14D,dword ptr [RSP + local_res10]
                 24 68
       1c00c280b 4b 8d 0c 0a     LEA        RCX,[R10 + R9*0x1]
       1c00c280f 48 8b d9        MOV        RBX,RCX
       1c00c2812 44 03 f5        ADD        R14D,EBP
       1c00c2815 49 2b d9        SUB        RBX,R9
       1c00c2818 48 8b d6        MOV        RDX,RSI
       1c00c281b 48 83 c3 03     ADD        RBX,0x3
       1c00c281f 48 c1 eb 02     SHR        RBX,0x2
       1c00c2823 4c 3b c9        CMP        R9,RCX
       1c00c2826 41 8b c8        MOV        ECX,R8D
       1c00c2829 48 0f 47 d9     CMOVA      RBX,RCX
       1c00c282d 48 85 db        TEST       RBX,RBX
       1c00c2830 74 38           JZ         LAB_1c00c286a
       1c00c2832 45 33 ed        XOR        R13D,R13D
                             LAB_1c00c2835                                   XREF[1]:     1c00c285b(j)  
   --> 1c00c2835 44 8b 12        MOV        R10D,dword ptr [RDX]
       1c00c2838 42 8d 0c 18     LEA        ECX,[RAX + R11*0x1]
       1c00c283c 3b c8           CMP        ECX,EAX
       1c00c283e 72 5e           JC         LAB_1c00c289e
       1c00c2840 41 8b c5        MOV        EAX,R13D
                             LAB_1c00c2843                                   XREF[1]:     1c00c28a3(j)  
       1c00c2843 48 98           CDQE
       1c00c2845 49 ff c0        INC        R8
       1c00c2848 48 03 c7        ADD        RAX,RDI
       1c00c284b 45 89 11        MOV        dword ptr [R9],R10D
       1c00c284e 49 83 c1 04     ADD        R9,0x4
       1c00c2852 48 8d 14 82     LEA        RDX,[RDX + RAX*0x4]
       1c00c2856 8b c1           MOV        EAX,ECX
       1c00c2858 4c 3b c3        CMP        R8,RBX
       1c00c285b 75 d8           JNZ        LAB_1c00c2835
       1c00c285d 4c 8b 6c        MOV        R13,qword ptr [RSP + local_res20]
                 24 78
       1c00c2862 8b 7c 24 70     MOV        EDI,dword ptr [RSP + local_res18]
       1c00c2866 4c 8b 14 24     MOV        R10,qword ptr [RSP]=>local_58

`````

----------------------------------------------------------------------------

case 8

useless

`````shell
DOUBLE FETCH:   cr3 0x1269cb000, syscall 0x1087
   user_address 0x6734c0, user_data 0x28, modrm 0x0, pc 0xfffff960cca46fac
   user_address 0x6734c0, user_data 0x28, modrm 0x37, pc 0xfffff960cca46fae

DOUBLE FETCH:   cr3 0x1269cb000, syscall 0x1087
   user_address 0x6734c0, user_data 0x28, modrm 0x0, pc 0xfffff960cca46fac
   user_address 0x6734c0, user_data 0x28, modrm 0x11, pc 0xfffff960cca47386
`````

`````shell
       1c0046f87 41 f7 d9        NEG        param_4
       1c0046f8a 4d 1b e4        SBB        R12,R12
       1c0046f8d 4c 23 e1        AND        R12,param_1
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
       1c00473a1 8b 50 20        MOV        EDX,dword ptr [RAX + 0x20]
       1c00473a4 44 8d 5b 04     LEA        R11D,[RBX + 0x4]
       1c00473a8 8b 40 10        MOV        EAX,dword ptr [RAX + 0x10]
       1c00473ab 0f b7 49 0e     MOVZX      ECX,word ptr [RCX + 0xe]
       1c00473af 83 f8 03        CMP        EAX,0x3
       1c00473b2 75 49           JNZ        LAB_1c00473fd
       1c00473b4 41 83 f8 01     CMP        R8D,0x1
       1c00473b8 44 0f 44 c3     CMOVZ      R8D,EBX
       1c00473bc 83 f9 20        CMP        ECX,0x20
       1c00473bf 0f 85 94        JNZ        LAB_1c0166f59
                 fb 11 00

`````

-----------------------------------------------------------

case 9

`````shell
DOUBLE FETCH:   cr3 0x1269cb000, syscall 0x1087
   user_address 0x6734e0, user_data 0x0, modrm 0x50, pc 0xfffff960cca473a1
   user_address 0x6734e0, user_data 0x0, modrm 0x44, pc 0xfffff960ccb44f00

DOUBLE FETCH:   cr3 0x1269cb000, syscall 0x1087
   user_address 0x6734d0, user_data 0x0, modrm 0x40, pc 0xfffff960cca473a8
   user_address 0x6734d0, user_data 0x0, modrm 0x44, pc 0xfffff960ccb44f00
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
   --1 1c00473a1 8b 50 20        MOV        EDX,dword ptr [RAX + 0x20]
       1c00473a4 44 8d 5b 04     LEA        R11D,[RBX + 0x4]
   --2 1c00473a8 8b 40 10        MOV        EAX,dword ptr [RAX + 0x10]
       1c00473ab 0f b7 49 0e     MOVZX      ECX,word ptr [RCX + 0xe]
       1c00473af 83 f8 03        CMP        EAX,0x3
       1c00473b2 75 49           JNZ        LAB_1c00473fd
       1c00473b4 41 83 f8 01     CMP        R8D,0x1
       1c00473b8 44 0f 44 c3     CMOVZ      R8D,EBX
       1c00473bc 83 f9 20        CMP        ECX,0x20
       1c00473bf 0f 85 94        JNZ        LAB_1c0166f59
                 fb 11 00

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

--------------------------------------------------------------------

case 10

0xfffff800b unknow module

`````shell
DOUBLE FETCH:   cr3 0xbade3000, syscall 0x11d1
   user_address 0x1d82efaeb78, user_data 0xff, modrm 0x44, pc 0xfffff800b9e512e0
   user_address 0x1d82efaeb78, user_data 0xffffffffffffffff, modrm 0x44, pc 0xfffff800b9e512c0
`````


-----------------------------------------------------------------------

case 11

unknown module, maybe kernel

`````shell
DOUBLE FETCH:   cr3 0x128d28000, syscall 0x12dd
   user_address 0x1de810c0008, user_data 0x0, modrm 0x40, pc 0xfffff8032e7f50df
   user_address 0x1de810c0008, user_data 0x130, modrm 0x40, pc 0xfffff8032e7f50df

DOUBLE FETCH:   cr3 0x128d28000, syscall 0x12dd
   user_address 0x1de810c0018, user_data 0x40, modrm 0x40, pc 0xfffff8032e7f50e7
   user_address 0x1de810c0018, user_data 0x40, modrm 0x40, pc 0xfffff8032e7f50e7

DOUBLE FETCH:   cr3 0x128d28000, syscall 0x12dd
   user_address 0x1de810c0010, user_data 0x1de810c0030, modrm 0x78, pc 0xfffff8032e7f5108
   user_address 0x1de810c0010, user_data 0x1de810c0030, modrm 0x78, pc 0xfffff8032e7f5108

DOUBLE FETCH:   cr3 0x128d28000, syscall 0x12dd
   user_address 0x1de810c0020, user_data 0x0, modrm 0x48, pc 0xfffff8032e7f5111
   user_address 0x1de810c0020, user_data 0x0, modrm 0x48, pc 0xfffff8032e7f5111

DOUBLE FETCH:   cr3 0x128d28000, syscall 0x12dd
   user_address 0x1de810c0028, user_data 0x0, modrm 0x70, pc 0xfffff8032e7f511a
   user_address 0x1de810c0028, user_data 0x0, modrm 0x70, pc 0xfffff8032e7f511a

DOUBLE FETCH:   cr3 0x128d28000, syscall 0x12dd
   user_address 0x1de810c0030, user_data 0x20a0054, modrm 0x2, pc 0xfffff8032e7f52f1
   user_address 0x1de810c0030, user_data 0x20a000e, modrm 0x2, pc 0xfffff8032e7f52f1

DOUBLE FETCH:   cr3 0x128d28000, syscall 0x12dd
   user_address 0x1de810c0038, user_data 0x1de810c0040, modrm 0x4a, pc 0xfffff8032e7f52f7
   user_address 0x1de810c0038, user_data 0x1de810c0040, modrm 0x4a, pc 0xfffff8032e7f52f7

`````

---------------------------------------------------------

case 12

***


1 3 useless

2 need review


`````shell
win32kbase.sys

DOUBLE FETCH:   cr3 0x128d28000, syscall 0x12dd
   user_address 0x810657c000, user_data 0x0, modrm 0x2, pc 0xfffff960ccdc59f5
   user_address 0x810657c000, user_data 0x0, modrm 0x0, pc 0xfffff960cca9b3fd

DOUBLE FETCH:   cr3 0xbe167000, syscall 0x12dd
   user_address 0xfdc667e020, user_data 0x2a3a2b20d20, modrm 0x48, pc 0xfffff960ccdc59f7
   user_address 0xfdc667e020, user_data 0x2a3a2b20d20, modrm 0x55, pc 0xfffff960cca9b3ff

DOUBLE FETCH:   cr3 0x128d28000, syscall 0x12dd
   user_address 0x1de81181340, user_data 0x5e, modrm 0x1, pc 0xfffff960ccdc5a1c
   user_address 0x1de81181340, user_data 0x5e, modrm 0x0, pc 0xfffff960cca9b417

`````


`````shell
       1c00359e0 4c 8b c0        MOV        R8,RAX
       1c00359e3 48 8b d0        MOV        RDX,RAX
       1c00359e6 48 3b 05        CMP        RAX,qword ptr [W32UserProbeAddress]              = ??
                 d3 ea 0c 00
       1c00359ed 48 0f 43        CMOVNC     RDX,qword ptr [W32UserProbeAddress]              = ??
                 15 cb ea 
                 0c 00
   --1 1c00359f5 8a 02           MOV        AL,byte ptr [RDX]
   --2 1c00359f7 49 8b 48 20     MOV        RCX,qword ptr [R8 + 0x20]
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
   --2 1c0035a1c 8a 01           MOV        AL,byte ptr [RCX]
       1c0035a1e 48 8b 8d        MOV        RCX,qword ptr [RBP + local_f8]
                 88 00 00 00

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
       1c009b3fd 8a 00           MOV        AL,byte ptr [RAX]
   --> 1c009b3ff 49 8b 55 20     MOV        RDX,qword ptr [R13 + 0x20]
       1c009b403 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 ee 61 2b 00
       1c009b40a 48 8b 08        MOV        RCX,qword ptr [RAX]
       1c009b40d 48 8b c2        MOV        RAX,RDX
       1c009b410 48 3b d1        CMP        RDX,RCX
       1c009b413 48 0f 43 c1     CMOVNC     RAX,RCX
       1c009b417 8a 00           MOV        AL,byte ptr [RAX]
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

`````

-----------------------------------------------------------

case 13


`````shell
DOUBLE FETCH:   cr3 0x27cf000, syscall 0x12dd
   user_address 0x1decf220040, user_data 0x6e00690057005c, modrm 0x44, pc 0xfffff8032e559940
   user_address 0x1decf220040, user_data 0x44, modrm 0x44, pc 0xfffff8032e559960
`````

`````shell
ntoskrnl

                             LAB_14014d92e                                   XREF[1]:     14014d786(j)  
       14014d92e 49 03 c8        ADD        _Dst,_Size
       14014d931 49 83 f8 4f     CMP        _Size,0x4f
       14014d935 73 4f           JNC        LAB_14014d986
                             LAB_14014d937                                   XREF[2]:     14014d9de(j), 14014dab4(j)  
       14014d937 4d 8b c8        MOV        R9,_Size
       14014d93a 49 c1 e9 03     SHR        R9,0x3
       14014d93e 74 11           JZ         LAB_14014d951
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
   --> 14014d960 8a 44 0a ff     MOV        AL,byte ptr [_Src + _Dst*0x1 + -0x1]
       14014d964 48 ff c9        DEC        _Dst
       14014d967 49 ff c8        DEC        _Size
       14014d96a 88 01           MOV        byte ptr [_Dst],AL
       14014d96c 75 f2           JNZ        LAB_14014d960
                             LAB_14014d96e                                   XREF[1]:     14014d955(j)  
       14014d96e 49 8b c3        MOV        RAX,R11
       14014d971 c3              RET

`````

--------------------------------------------------------------------

case 14

***

need review

`````shell
DOUBLE FETCH:   cr3 0xbe167000, syscall 0x135b
   user_address 0xfdc653fac8, user_data 0xe0, modrm 0x41, pc 0xfffff960ccaa9686
   user_address 0xfdc653fac8, user_data 0xe0, modrm 0x40, pc 0xfffff8032e7f50df
`````

`````shell
       1c00a9656 45 33 ed        XOR        R13D,R13D
       1c00a9659 4c 21 ac        AND        qword ptr [RSP + local_138],R13
                 24 a0 00 
                 00 00
       1c00a9661 45 33 e4        XOR        R12D,R12D
       1c00a9664 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::gptiCurrent]    = 00357d68
                 dd 7f 2a 00
       1c00a966b 4c 8b 30        MOV        R14,qword ptr [RAX]
       1c00a966e 44 21 a4        AND        dword ptr [RSP + local_140],R12D
                 24 98 00 
                 00 00
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

`````shell
ntoskrnl

       1401150a8 41 b8 4d        MOV        R8D,0x6946694d
                 69 46 69
       1401150ae 8b cb           MOV        ECX,EBX
       1401150b0 e8 9b b8        CALL       ExAllocatePoolWithTag                            undefined ExAllocatePoolWithTag(
                 11 00
       1401150b5 48 8b d8        MOV        RBX,RAX
       1401150b8 48 8b ce        MOV        RCX,RSI
       1401150bb 48 85 c0        TEST       RAX,RAX
       1401150be 0f 84 43        JZ         LAB_140198807
                 37 08 00
       1401150c4 48 8b d7        MOV        RDX,RDI
       1401150c7 e8 78 c7        CALL       FUN_1403c1844                                    undefined FUN_1403c1844()
                 2a 00
       1401150cc 48 89 73 28     MOV        qword ptr [RBX + 0x28],RSI
       1401150d0 49 8d 4e ff     LEA        RCX,[R14 + -0x1]
       1401150d4 48 89 7b 30     MOV        qword ptr [RBX + 0x30],RDI
       1401150d8 4c 89 73 10     MOV        qword ptr [RBX + 0x10],R14
       1401150dc 48 8b 07        MOV        RAX,qword ptr [RDI]
   --> 1401150df 8b 40 08        MOV        EAX,dword ptr [RAX + 0x8]
       1401150e2 c1 e0 0c        SHL        EAX,0xc
       1401150e5 48 03 c8        ADD        RCX,RAX
       1401150e8 48 89 4b 18     MOV        qword ptr [RBX + 0x18],RCX
       1401150ec 48 8b 07        MOV        RAX,qword ptr [RDI]
       1401150ef 48 8b 48 20     MOV        RCX,qword ptr [RAX + 0x20]
       1401150f3 48 b8 00        MOV        RAX,0x70000000000
                 00 00 00 
                 00 07 00 00
       1401150fd 48 89 4b 20     MOV        qword ptr [RBX + 0x20],RCX
       140115101 49 03 c6        ADD        RAX,R14
       140115104 48 b9 ff        MOV        RCX,0x7fffffffff
                 ff ff ff 
                 7f 00 00 00

`````

------------------------------------------------

case 15


***

need review


`````shell
DOUBLE FETCH:   cr3 0xbade3000, syscall 0x115b
   user_address 0x1d82b7d0ee8, user_data 0x8, modrm 0x6, pc 0xfffff960ccdb7a52
   user_address 0x1d82b7d0ee8, user_data 0x0, modrm 0x7, pc 0xfffff960ccdacd1b
`````

0xfffff960ccdb7a52 - 0xfffff960ccdacd1b = AD37


1c0027a52 - 1c001cd1b = AD37


`````shell
win32kbase
bDeleteBrush

       1c0027a30 48 89 4c        MOV        qword ptr [RSP + local_68],RCX
                 24 40
       1c0027a35 49 8b 71 10     MOV        RSI,qword ptr [R9 + 0x10]
       1c0027a39 48 89 74        MOV        qword ptr [RSP + local_70],RSI
                 24 38
       1c0027a3e 8b 41 08        MOV        EAX,dword ptr [RCX + 0x8]
       1c0027a41 85 c0           TEST       EAX,EAX
       1c0027a43 0f 85 45        JNZ        LAB_1c0027b8e
                 01 00 00
       1c0027a49 48 85 f6        TEST       RSI,RSI
       1c0027a4c 0f 84 85        JZ         LAB_1c0027ad7
                 00 00 00
   --> 1c0027a52 8b 06           MOV        EAX,dword ptr [RSI]
       1c0027a54 41 23 c4        AND        EAX,R12D
       1c0027a57 89 44 24 30     MOV        dword ptr [RSP + local_78],EAX
       1c0027a5b eb 30           JMP        LAB_1c0027a8d
       1c0027a5d b8 01 00        MOV        EAX,0x1
                 00 00
       1c0027a62 89 44 24 30     MOV        dword ptr [RSP + 0x30],EAX
       1c0027a66 44 8b ac        MOV        R13D,dword ptr [RSP + 0xb8]
                 24 b8 00 
                 00 00
       1c0027a6e 4c 8b b4        MOV        R14,qword ptr [RSP + 0xb0]
                 24 b0 00 
                 00 00

`````

`````shell
       1c001cce3 0f b7 4b 0c     MOVZX      param_1,word ptr [RBX + 0xc]
       1c001cce7 81 c1 00        ADD        param_1,0x100
                 01 00 00
       1c001cced 66 89 4b 0c     MOV        word ptr [RBX + 0xc],param_1
       1c001ccf1 0f b7 d1        MOVZX      param_2,param_1
       1c001ccf4 c1 e2 10        SHL        param_2,0x10
       1c001ccf7 4c 63 c2        MOVSXD     param_3,param_2
       1c001ccfa 0f b7 4c        MOVZX      param_1,word ptr [RSP + local_res8]
                 24 70
       1c001ccff 4c 0b c1        OR         param_3,param_1
       1c001cd02 4c 89 44        MOV        qword ptr [RSP + local_res8],param_3
                 24 70
       1c001cd07 48 8b 0b        MOV        param_1,qword ptr [RBX]
       1c001cd0a 4c 89 01        MOV        qword ptr [param_1],param_3
       1c001cd0d 4c 89 00        MOV        qword ptr [RAX],param_3
       1c001cd10 43 ff 84        INC        dword ptr [R14 + R15*0x4 + 0x148]
                 be 48 01 
                 00 00
       1c001cd18 83 27 f5        AND        dword ptr [RDI],0xfffffff5
   --> 1c001cd1b 8b 07           MOV        EAX,dword ptr [RDI]
       1c001cd1d 83 c8 01        OR         EAX,0x1
       1c001cd20 89 07           MOV        dword ptr [RDI],EAX
       1c001cd22 f0              LOCK
       1c001cd23 83 0c 24 00     OR         dword ptr [RSP]=>local_68,0x0
       1c001cd27 c7 44 24        MOV        dword ptr [RSP + local_48],0x1
                 20 01 00 
                 00 00
       1c001cd2f 48 8b 9c        MOV        RBX,qword ptr [RSP + param_5]
                 24 90 00 
                 00 00
       1c001cd37 48 8b 0b        MOV        param_1,qword ptr [RBX]
       1c001cd3a f6 41 0f 40     TEST       byte ptr [param_1 + 0xf],0x40
       1c001cd3e 74 18           JZ         LAB_1c001cd58
       1c001cd40 8b 4b 14        MOV        param_1,dword ptr [RBX + 0x14]
       1c001cd43 48 8b 05        MOV        RAX,qword ptr [gpentPushLock]                    = NaP
                 0e 88 0e 00

`````

----------------------------------------------------------------------

case 16


***

need review

it access the same user_address as case 15 does.


`````shell
DOUBLE FETCH:   cr3 0xbade3000, syscall 0x1071
   user_address 0x1d82b7d0ee8, user_data 0x0, modrm 0x7, pc 0xfffff960ccdbb701
   user_address 0x1d82b7d0ee8, user_data 0x0, modrm 0x7, pc 0xfffff960ccdbb6b4
`````


`````shell
       1c002b690 0f 84 08        JZ         LAB_1c002b79e
                 01 00 00
       1c002b696 48 8b 8b        MOV        RCX,qword ptr [RBX + 0x90]
                 90 00 00 00
       1c002b69d 4c 8b 79 38     MOV        R15,qword ptr [RCX + 0x38]
       1c002b6a1 e8 4a 11        CALL       FUN_1c002c7f0                                    undefined FUN_1c002c7f0()
                 00 00
       1c002b6a6 66 83 f8 01     CMP        AX,0x1
       1c002b6aa 75 41           JNZ        LAB_1c002b6ed
       1c002b6ac c7 44 24        MOV        dword ptr [RSP + local_48],0x0
                 20 00 00 
                 00 00
   --> 1c002b6b4 41 8b 07        MOV        EAX,dword ptr [R15]
       1c002b6b7 83 e0 02        AND        EAX,0x2
       1c002b6ba 89 44 24 20     MOV        dword ptr [RSP + local_48],EAX
       1c002b6be eb 25           JMP        LAB_1c002b6e5
       1c002b6c0 f0              LOCK
       1c002b6c1 ff 05 5d        INC        dword ptr [gGdiInPageErrors]                     = ??
                 ca 0d 00
       1c002b6c7 4c 8b 74        MOV        R14,qword ptr [RSP + 0x78]
                 24 78
       1c002b6cc 48 8b 5c        MOV        RBX,qword ptr [RSP + 0x70]
                 24 70
       1c002b6d1 48 8b b4        MOV        RSI,qword ptr [RSP + 0x80]
                 24 80 00 
                 00 00
       1c002b6d9 48 8b bc        MOV        RDI,qword ptr [RSP + 0x88]
                 24 88 00 
                 00 00
       1c002b6e1 8b 44 24 20     MOV        EAX,dword ptr [RSP + 0x20]

                             LAB_1c002b6e5                                   XREF[1]:     1c002b6be(j)  
       1c002b6e5 85 c0           TEST       EAX,EAX
       1c002b6e7 0f 85 9b        JNZ        LAB_1c002b788
                 00 00 00
                             LAB_1c002b6ed                                   XREF[2]:     1c002b6aa(j), 1c002b799(j)  
       1c002b6ed 48 8b 43 50     MOV        RAX,qword ptr [RBX + 0x50]
       1c002b6f1 83 48 08 01     OR         dword ptr [RAX + 0x8],0x1
       1c002b6f5 48 89 bb        MOV        qword ptr [RBX + 0x90],RDI
                 90 00 00 00
       1c002b6fc e9 35 ff        JMP        LAB_1c002b636
                 ff ff
                             LAB_1c002b701                                   XREF[1]:     1c002b650(j)  
   --> 1c002b701 41 8b 07        MOV        EAX,dword ptr [R15]
       1c002b704 83 e0 04        AND        EAX,0x4
       1c002b707 89 44 24 24     MOV        dword ptr [RSP + local_44],EAX
       1c002b70b 41 8b 57 04     MOV        EDX,dword ptr [R15 + 0x4]
       1c002b70f 89 54 24 28     MOV        dword ptr [RSP + local_40],EDX
       1c002b713 eb 30           JMP        LAB_1c002b745
       1c002b715 f0              LOCK
       1c002b716 ff 05 08        INC        dword ptr [gGdiInPageErrors]                     = ??
                 ca 0d 00
       1c002b71c 33 c0           XOR        EAX,EAX
       1c002b71e 89 44 24 24     MOV        dword ptr [RSP + 0x24],EAX
       1c002b722 4c 8b 74        MOV        R14,qword ptr [RSP + 0x78]
                 24 78
       1c002b727 48 8b 5c        MOV        RBX,qword ptr [RSP + 0x70]
                 24 70
       1c002b72c 48 8b b4        MOV        RSI,qword ptr [RSP + 0x80]
                 24 80 00 
                 00 00
       1c002b734 48 8b bc        MOV        RDI,qword ptr [RSP + 0x88]
                 24 88 00 
                 00 00

`````


--------------------------------------------------------------------------


case 17


***

need review

0xfffff960cca68412 - 0xfffff960cca6330a = 5108

1c0068412 - 1c006330a = 5108


`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x10ec
   user_address 0x2db800, user_data 0x388, modrm 0x8, pc 0xfffff960cca68412
   user_address 0x2db800, user_data 0x388, modrm 0x4, pc 0xfffff960cca6330a
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
       1c0068424 48 8b bc        MOV        RDI,qword ptr [RSP + 0x6b0]
                 24 b0 06 
                 00 00
       1c006842c 48 8b 9c        MOV        RBX,qword ptr [RSP + 0xd0]
                 24 d0 00 
                 00 00
       1c0068434 48 8b b4        MOV        RSI,qword ptr [RSP + 0xb8]
                 24 b8 00 
                 00 00
       1c006843c 4c 8b e3        MOV        R12,RBX
       1c006843f e9 7f 0c        JMP        LAB_1c00690c3
                 00 00

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


------------------------------------------------------------

case 18

useless


`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x10d8
   user_address 0xbbae718, user_data 0x0, modrm 0x0, pc 0xfffff960cce01337
   user_address 0xbbae718, user_data 0x3f800000, modrm 0x9, pc 0xfffff960cce0133a
`````

`````shell

win32kbase

                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined ProbeAndConvertXFORM()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x10]:8  local_res10                             XREF[2]:     1c0071315(W), 
                                                                                                   1c00713af(R)  
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1c0071310(W), 
                                                                                                   1c00713aa(R)  
             undefined4        Stack[-0x18]:4 local_18                                XREF[1]:     1c007139c(W)  
                             0x71310  1283  ProbeAndConvertXFORM
                             Ordinal_1283                                    XREF[5]:     Entry Point(*), 
                             ProbeAndConvertXFORM                                         NtGdiExtCreateRegion:1c00a5768(c
                                                                                          1c0111a04(*), 1c012b430(*), 
                                                                                          1c013ecfc(*)  
       1c0071310 48 89 5c        MOV        qword ptr [RSP + local_res8],RBX
                 24 08
       1c0071315 48 89 74        MOV        qword ptr [RSP + local_res10],RSI
                 24 10
       1c007131a 57              PUSH       RDI
       1c007131b 48 83 ec 30     SUB        RSP,0x30
       1c007131f 48 8b f2        MOV        RSI,RDX
       1c0071322 48 8b f9        MOV        RDI,RCX
       1c0071325 4c 8b c1        MOV        R8,RCX
       1c0071328 48 3b 0d        CMP        RCX,qword ptr [W32UserProbeAddress]              = ??
                 91 31 09 00
       1c007132f 4c 0f 43        CMOVNC     R8,qword ptr [W32UserProbeAddress]               = ??
                 05 89 31 
                 09 00
   --> 1c0071337 41 8a 00        MOV        AL,byte ptr [R8]
   --> 1c007133a 8b 09           MOV        ECX,dword ptr [RCX]
       1c007133c e8 7f 00        CALL       bConvertDwordToFloat                             undefined bConvertDwordToFloat()
                 00 00
       1c0071341 33 db           XOR        EBX,EBX
       1c0071343 85 c0           TEST       EAX,EAX
       1c0071345 74 55           JZ         LAB_1c007139c
       1c0071347 48 8d 56 04     LEA        RDX,[RSI + 0x4]
       1c007134b 8b 4f 04        MOV        ECX,dword ptr [RDI + 0x4]
       1c007134e e8 6d 00        CALL       bConvertDwordToFloat                             undefined bConvertDwordToFloat()
                 00 00

`````


-------------------------------------------------


case 19

***

need review

`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x1388
   user_address 0x233800, user_data 0x388, modrm 0x1, pc 0xfffff960ccaef0c6
   user_address 0x233800, user_data 0x388, modrm 0x1, pc 0xfffff960ccaef0f7
`````

`````shell
       1c00ef0a4 48 8b f8        MOV        RDI,RAX
       1c00ef0a7 83 64 24        AND        dword ptr [RSP + local_18],0x0
                 20 00
       1c00ef0ac 83 64 24        AND        dword ptr [RSP + local_14],0x0
                 24 00
       1c00ef0b1 65 48 8b        MOV        RCX,qword ptr GS:[0x188]
                 0c 25 88 
                 01 00 00
       1c00ef0ba e8 8d 94        CALL       FUN_1c005854c                                    undefined FUN_1c005854c()
                 f6 ff
       1c00ef0bf 48 8b 88        MOV        RCX,qword ptr [RAX + 0x1b0]
                 b0 01 00 00
   --> 1c00ef0c6 8b 01           MOV        EAX,dword ptr [RCX]
       1c00ef0c8 25 00 00        AND        EAX,0x40000000
                 00 40
       1c00ef0cd 8b 4c 24 20     MOV        ECX,dword ptr [RSP + local_18]
       1c00ef0d1 41 bf 01        MOV        R15D,0x1
                 00 00 00
       1c00ef0d7 48 85 c0        TEST       RAX,RAX
       1c00ef0da 41 0f 45 cf     CMOVNZ     ECX,R15D
       1c00ef0de 89 4c 24 20     MOV        dword ptr [RSP + local_18],ECX
       1c00ef0e2 65 48 8b        MOV        RCX,qword ptr GS:[0x188]
                 0c 25 88 
                 01 00 00
       1c00ef0eb e8 5c 94        CALL       FUN_1c005854c                                    undefined FUN_1c005854c()
                 f6 ff
       1c00ef0f0 48 8b 88        MOV        RCX,qword ptr [RAX + 0x1b0]
                 b0 01 00 00
   --> 1c00ef0f7 8b 01           MOV        EAX,dword ptr [RCX]
       1c00ef0f9 b9 00 00        MOV        ECX,0x80000000
                 00 80
       1c00ef0fe 8b 54 24 24     MOV        EDX,dword ptr [RSP + local_14]
       1c00ef102 48 23 c1        AND        RAX,RCX
       1c00ef105 41 0f 45 d7     CMOVNZ     EDX,R15D
       1c00ef109 89 54 24 24     MOV        dword ptr [RSP + local_14],EDX
       1c00ef10d eb 04           JMP        LAB_1c00ef113

`````

-----------------------------------------------------------------------


case 20


useless

`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x1051
   user_address 0xd9edd58, user_data 0x75da, modrm 0x47, pc 0xfffff960ccacf1d5
   user_address 0xd9edd58, user_data 0x75da, modrm 0x57, pc 0xfffff960ccacf222
`````

`````shell
                             LAB_1c00cf1c5                                   XREF[1]:     1c00cf1ec(j)  
       1c00cf1c5 0f 10 07        MOVUPS     XMM0,xmmword ptr [RDI]
       1c00cf1c8 0f 11 07        MOVUPS     xmmword ptr [RDI],XMM0
       1c00cf1cb f2 0f 10        MOVSD      XMM1,qword ptr [RDI + 0x10]
                 4f 10
       1c00cf1d0 f2 0f 11        MOVSD      qword ptr [RDI + 0x10],XMM1
                 4f 10
   --> 1c00cf1d5 8b 47 18        MOV        EAX,dword ptr [RDI + 0x18]
       1c00cf1d8 89 47 18        MOV        dword ptr [RDI + 0x18],EAX
       1c00cf1db 40 f6 c6 03     TEST       SIL,0x3
       1c00cf1df 75 0d           JNZ        LAB_1c00cf1ee
       1c00cf1e1 eb 11           JMP        LAB_1c00cf1f4
                             LAB_1c00cf1e3                                   XREF[1]:     1c00cf1c3(j)  
       1c00cf1e3 89 18           MOV        dword ptr [RAX],EBX
       1c00cf1e5 48 8b 0d        MOV        RCX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 0c 24 28 00
       1c00cf1ec eb d7           JMP        LAB_1c00cf1c5
                             LAB_1c00cf1ee                                   XREF[1]:     1c00cf1df(j)  
       1c00cf1ee ff 15 84        CALL       qword ptr [->NTOSKRNL.EXE::ExRaiseDatatypeMisa
                 f8 27 00
                             LAB_1c00cf1f4                                   XREF[1]:     1c00cf1e1(j)  
       1c00cf1f4 48 8b 01        MOV        RAX,qword ptr [RCX]
       1c00cf1f7 48 8b ce        MOV        RCX,RSI
       1c00cf1fa 48 3b f0        CMP        RSI,RAX
       1c00cf1fd 48 0f 43 c8     CMOVNC     RCX,RAX
       1c00cf201 8a 01           MOV        AL,byte ptr [RCX]
       1c00cf203 0f 10 06        MOVUPS     XMM0,xmmword ptr [RSI]
       1c00cf206 f3 0f 7f        MOVDQU     xmmword ptr [RSP + local_30[0]],XMM0
                 44 24 58
       1c00cf20c 0f 10 07        MOVUPS     XMM0,xmmword ptr [RDI]
       1c00cf20f 0f 10 d0        MOVUPS     XMM2,XMM0
       1c00cf212 0f 11 44        MOVUPS     xmmword ptr [RSP + local_58[0]],XMM0
                 24 30
       1c00cf217 f2 0f 10        MOVSD      XMM1,qword ptr [RDI + 0x10]
                 4f 10
       1c00cf21c f2 0f 11        MOVSD      qword ptr [RSP + local_48],XMM1
                 4c 24 40
   --> 1c00cf222 8b 57 18        MOV        EDX,dword ptr [RDI + 0x18]
       1c00cf225 89 54 24 48     MOV        dword ptr [RSP + local_40],EDX
       1c00cf229 eb 07           JMP        LAB_1c00cf232

`````

--------------------------------------------------------------

case 21

***

need review

`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x1057
   user_address 0x19955ec6110, user_data 0x0, modrm 0x9, pc 0xfffff8032e424042
   user_address 0x19955ec6110, user_data 0x0, modrm 0x2, pc 0xfffff8032e424143

`````

`````shell
                             LAB_14001802b                                   XREF[1]:     1400180f1(j)  
       14001802b 48 8b 47 08     MOV        RAX,qword ptr [RDI + 0x8]
       14001802f 8b ca           MOV        ECX,EDX
       140018031 48 c1 e9 05     SHR        RCX,0x5
       140018035 4c 8d 0c 88     LEA        R9,[RAX + RCX*0x4]
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

`````


----------------------------------------------------------


case 22


***


need review


`````shell
DOUBLE FETCH:   cr3 0xbade3000, syscall 0x1015
   user_address 0x195c82ff68c, user_data 0x66070000, modrm 0x7c, pc 0xfffff960ccb17686
   user_address 0x195c82ff68c, user_data 0x66070000, modrm 0x5c, pc 0xfffff960ccb18a0c

DOUBLE FETCH:   cr3 0xbade3000, syscall 0x1015
   user_address 0x195c82ff688, user_data 0xf2060000, modrm 0x3c, pc 0xfffff960ccb17682
   user_address 0x195c82ff688, user_data 0xf2060000, modrm 0x3c, pc 0xfffff960ccb17682

DOUBLE FETCH:   cr3 0xbade3000, syscall 0x1015
   user_address 0x195c82ff68c, user_data 0x66070000, modrm 0x7c, pc 0xfffff960ccb17686
   user_address 0x195c82ff68c, user_data 0x66070000, modrm 0x7c, pc 0xfffff960ccb17686

DOUBLE FETCH:   cr3 0xbade3000, syscall 0x1015
   user_address 0x195c82ff688, user_data 0xf2060000, modrm 0x3c, pc 0xfffff960ccb17682
   user_address 0x195c82ff688, user_data 0xf2060000, modrm 0x34, pc 0xfffff960ccb18a09

DOUBLE FETCH:   cr3 0xbade3000, syscall 0x1015
   user_address 0x195c82ff68c, user_data 0x66070000, modrm 0x7c, pc 0xfffff960ccb17686
   user_address 0x195c82ff68c, user_data 0x66070000, modrm 0x5c, pc 0xfffff960ccb18a0c

DOUBLE FETCH:   cr3 0xbade3000, syscall 0x1015
   user_address 0x195c82ff68c, user_data 0x66070000, modrm 0x7c, pc 0xfffff960ccb17686
   user_address 0x195c82ff68c, user_data 0x66070000, modrm 0x3c, pc 0xfffff960ccb17682

DOUBLE FETCH:   cr3 0xbade3000, syscall 0x1015
   user_address 0x195c82ff68c, user_data 0x66070000, modrm 0x7c, pc 0xfffff960ccb17686
   user_address 0x195c82ff68c, user_data 0x66070000, modrm 0x34, pc 0xfffff960ccb18a09
`````


`````shell
                             LAB_1c011766b                                   XREF[1]:     1c01b0b25(j)  
       1c011766b 48 85 c9        TEST       param_1,param_1
       1c011766e 0f 84 a3        JZ         LAB_1c01b0b17
                 94 09 00
       1c0117674 41 0f b7 c5     MOVZX      EAX,R13W
       1c0117678 66 45 85 d2     TEST       R10W,R10W
       1c011767c 0f 84 88        JZ         LAB_1c011840a
                 0d 00 00
   --> 1c0117682 44 8b 3c 81     MOV        R15D,dword ptr [param_1 + RAX*0x4]
   --> 1c0117686 8b 7c 81 04     MOV        EDI,dword ptr [param_1 + RAX*0x4 + 0x4]
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
   --> 1c0118a09 8b 34 82        MOV        ESI,dword ptr [RDX + RAX*0x4]
   --> 1c0118a0c 8b 5c 82 04     MOV        EBX,dword ptr [RDX + RAX*0x4 + 0x4]
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

-----------------------------------------------------


case 23

useless

`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x1095
   user_address 0xd86dc20, user_data 0x3c, modrm 0x2, pc 0xfffff960cca77352
   user_address 0xd86dc20, user_data 0x3c, modrm 0x7, pc 0xfffff960cca7735c
`````

`````shell
                             LAB_1c0077341                                   XREF[1]:     1c0077339(j)  
       1c0077341 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 b0 a2 2d 00
       1c0077348 48 8b d7        MOV        RDX,RDI
       1c007734b 48 3b 38        CMP        RDI,qword ptr [RAX]
       1c007734e 48 0f 43 10     CMOVNC     RDX,qword ptr [RAX]
   --> 1c0077352 8a 02           MOV        AL,byte ptr [RDX]
       1c0077354 88 02           MOV        byte ptr [RDX],AL
       1c0077356 8a 42 3b        MOV        AL,byte ptr [RDX + 0x3b]
       1c0077359 88 42 3b        MOV        byte ptr [RDX + 0x3b],AL
   --> 1c007735c 8b 07           MOV        EAX,dword ptr [RDI]
       1c007735e 89 44 24 68     MOV        dword ptr [RSP + local_60[0]],EAX
       1c0077362 eb 07           JMP        LAB_1c007736b
       1c0077364 33 db           XOR        EBX,EBX
       1c0077366 e9 d5 00        JMP        LAB_1c0077440
                 00 00

`````

----------------------------------------------

case 24


***

need review


0xfffff8032e84085a - 0xfffff8032e836842 = A018

14043485a - 14042a842 = A018 

`````shell
DOUBLE FETCH:   cr3 0x0, syscall 0x1031
   user_address 0x2400b4e0078, user_data 0xffffe00124f7d66a, modrm 0x43, pc 0xfffff8032e84085a
   user_address 0x2400b4e0078, user_data 0x2400b4e066a, modrm 0x42, pc 0xfffff8032e836842
`````

`````shell
                             LAB_14043484a                                   XREF[1]:     1404348d7(j)  
       14043484a 48 8b 43 68     MOV        RAX,qword ptr [RBX + 0x68]
       14043484e 48 85 c0        TEST       RAX,RAX
       140434851 74 07           JZ         LAB_14043485a
       140434853 48 03 c6        ADD        RAX,RSI
       140434856 48 89 43 68     MOV        qword ptr [RBX + 0x68],RAX
                             LAB_14043485a                                   XREF[1]:     140434851(j)  
   --> 14043485a 48 8b 43 78     MOV        RAX,qword ptr [RBX + 0x78]
       14043485e 48 85 c0        TEST       RAX,RAX
       140434861 74 07           JZ         LAB_14043486a
       140434863 48 03 c6        ADD        RAX,RSI
       140434866 48 89 43 78     MOV        qword ptr [RBX + 0x78],RAX
                             LAB_14043486a                                   XREF[1]:     140434861(j)  
       14043486a 48 8b 83        MOV        RAX,qword ptr [RBX + 0xb8]
                 b8 00 00 00
       140434871 48 85 c0        TEST       RAX,RAX
       140434874 74 0a           JZ         LAB_140434880
       140434876 48 03 c6        ADD        RAX,RSI
       140434879 48 89 83        MOV        qword ptr [RBX + 0xb8],RAX
                 b8 00 00 00

`````


`````shell
       14042a829 48 83 c2 70     ADD        RDX,0x70
       14042a82d 48 3b 15        CMP        RDX,qword ptr [MmUserProbeAddress]               = ??
                 cc 49 f5 ff
       14042a834 48 0f 43        CMOVNC     RDX,qword ptr [MmUserProbeAddress]               = ??
                 15 c4 49 
                 f5 ff
       14042a83c 8b 0a           MOV        ECX,dword ptr [RDX]
       14042a83e 89 4c 24 30     MOV        dword ptr [RSP + local_28[0]],ECX
   --> 14042a842 48 8b 42 08     MOV        RAX,qword ptr [RDX + 0x8]
       14042a846 49 89 43 e0     MOV        qword ptr [R11 + local_28[8]],RAX
       14042a84a 0f 28 44        MOVAPS     XMM0,xmmword ptr [RSP + local_28[0]]
                 24 30
       14042a84f 66 0f 7f        MOVDQA     xmmword ptr [RSP + local_38[0]],XMM0
                 44 24 20
       14042a855 0f b7 f9        MOVZX      EDI,CX
       14042a858 48 83 e7 fe     AND        RDI,-0x2
       14042a85c 66 89 7c        MOV        word ptr [RSP + local_38[0]],DI
                 24 20

`````


--------------------------------------------------


case 25


useless


`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x1454
   user_address 0xcec50, user_data 0x161000003be, modrm 0x1, pc 0xfffff960ccaf3139
   user_address 0xcec50, user_data 0x161000003be, modrm 0x6, pc 0xfffff960ccaf313f

`````

`````shell
       1c00f3125 48 8b 0d        MOV        RCX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 cc e4 25 00
       1c00f312c 48 8b 11        MOV        RDX,qword ptr [RCX]
       1c00f312f 49 8b ce        MOV        RCX,R14
       1c00f3132 4c 3b f2        CMP        R14,RDX
       1c00f3135 48 0f 43 ca     CMOVNC     RCX,RDX
   --> 1c00f3139 48 8b 01        MOV        RAX,qword ptr [RCX]
       1c00f313c 48 89 01        MOV        qword ptr [RCX],RAX
   --> 1c00f313f 49 8b 06        MOV        RAX,qword ptr [R14]
       1c00f3142 48 89 44        MOV        qword ptr [RSP + local_res20],RAX
                 24 78
       1c00f3147 eb 0c           JMP        LAB_1c00f3155
       1c00f3149 33 f6           XOR        ESI,ESI
       1c00f314b 8d 4e 57        LEA        ECX,[RSI + 0x57]
       1c00f314e e8 8d d3        CALL       FUN_1c00504e0                                    undefined FUN_1c00504e0()
                 f5 ff
       1c00f3153 eb 48           JMP        LAB_1c00f319d

`````

-----------------------------------------------------

case 26

***

need review

`````shell
DOUBLE FETCH:   cr3 0x678d3000, syscall 0x1009
   user_address 0x18d2fa48a00, user_data 0x30, modrm 0x41, pc 0xfffff8032e80480c
   user_address 0x18d2fa48a00, user_data 0x30, modrm 0x41, pc 0xfffff8032e8048e0
`````

`````shell
                             LAB_1403f87ed                                   XREF[1]:     1403f8e84(j)  
       1403f87ed 48 8b d1        MOV        param_2,param_1
       1403f87f0 f6 c1 03        TEST       param_1,0x3
       1403f87f3 75 40           JNZ        LAB_1403f8835
       1403f87f5 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 04 6a f8 ff
       1403f87fc 48 3b c8        CMP        param_1,RAX
       1403f87ff 73 39           JNC        LAB_1403f883a
                             LAB_1403f8801                                   XREF[1]:     1403f883d(j)  
       1403f8801 0f b6 02        MOVZX      EAX,byte ptr [param_2]
       1403f8804 0f 10 01        MOVUPS     XMM0,xmmword ptr [param_1]
       1403f8807 0f 11 44        MOVUPS     xmmword ptr [RSP + local_68[0]],XMM0
                 24 70
   --> 1403f880c 8b 41 10        MOV        EAX,dword ptr [param_1 + 0x10]
       1403f880f 89 84 24        MOV        dword ptr [RSP + local_58],EAX
                 80 00 00 00
       1403f8816 66 48 0f        MOVQ       RSI,XMM0
                 7e c6
       1403f881b 48 8b c6        MOV        RAX,RSI
       1403f881e 48 c1 e8 10     SHR        RAX,0x10
       1403f8822 41 b8 00        MOV        param_3,0x8000
                 80 00 00
       1403f8828 66 41 85 c0     TEST       param_3,AX
       1403f882c 75 16           JNZ        LAB_1403f8844
       1403f882e f6 c1 07        TEST       param_1,0x7
       1403f8831 75 0c           JNZ        LAB_1403f883f
       1403f8833 eb 0f           JMP        LAB_1403f8844

`````

`````shell
                             LAB_1403f88d1                                   XREF[1]:     1403f889e(j)  
       1403f88d1 44 8b 41 08     MOV        param_3,dword ptr [param_1 + 0x8]
       1403f88d5 45 85 c0        TEST       param_3,param_3
       1403f88d8 74 2d           JZ         LAB_1403f8907
       1403f88da 4a 8d 3c 01     LEA        RDI,[param_1 + param_3*0x1]
       1403f88de eb c4           JMP        LAB_1403f88a4
                             LAB_1403f88e0                                   XREF[1]:     1403f88c9(j)  
   --> 1403f88e0 8b 41 10        MOV        EAX,dword ptr [param_1 + 0x10]
       1403f88e3 85 c0           TEST       EAX,EAX
       1403f88e5 74 4e           JZ         LAB_1403f8935
       1403f88e7 4c 8d 34 01     LEA        R14,[param_1 + RAX*0x1]
       1403f88eb eb 4b           JMP        LAB_1403f8938

`````

-------------------------------------------------------------

case 27

module unknown

`````shell
DOUBLE FETCH:   cr3 0x36ef8000, syscall 0x1009
   user_address 0xbf5271e720, user_data 0xbc, modrm 0x83, pc 0xfffff800b97d6f6f
   user_address 0xbf5271e720, user_data 0xbc, modrm 0x80, pc 0xfffff800b97d75f0

`````

-------------------------------------------------

case 28

***

need review

`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x103b
   user_address 0x2b2318, user_data 0x0, modrm 0x85, pc 0xfffff8032e8375f2
   user_address 0x2b2318, user_data 0x0, modrm 0x86, pc 0xfffff8032e88e838
`````

`````shell
                             LAB_14042b5d3                                   XREF[1]:     14042b7dc(j)  
       14042b5d3 48 8d 57 ff     LEA        param_2,[RDI + -0x1]
       14042b5d7 48 f7 d2        NOT        param_2
       14042b5da 48 8d 5f ff     LEA        RBX,[RDI + -0x1]
       14042b5de 48 03 d8        ADD        RBX,RAX
       14042b5e1 48 23 da        AND        RBX,param_2
       14042b5e4 48 8d b1        LEA        RSI,[param_1 + 0xffff]
                 ff ff 00 00
       14042b5eb 48 81 e6        AND        RSI,-0x10000
                 00 00 ff ff
   --> 14042b5f2 49 8b 85        MOV        RAX,qword ptr [R13 + 0x318]
                 18 03 00 00
       14042b5f9 48 89 44        MOV        qword ptr [RSP + local_70],RAX
                 24 48
       14042b5fe eb 05           JMP        LAB_14042b605
       14042b600 e9 12 01        JMP        LAB_14042b717
                 00 00

`````


`````shell
                             LAB_140482819                                   XREF[1]:     1405a0a5a(j)  
       140482819 48 8d b9        LEA        RDI,[param_1 + 0xfff]
                 ff 0f 00 00
       140482820 48 c7 c1        MOV        param_1,-0x1000
                 00 f0 ff ff
       140482827 48 23 f9        AND        RDI,param_1
       14048282a 48 8d b0        LEA        RSI,[RAX + 0xffff]
                 ff ff 00 00
       140482831 48 81 e6        AND        RSI,-0x10000
                 00 00 ff ff
   --> 140482838 49 8b 86        MOV        RAX,qword ptr [R14 + 0x318]
                 18 03 00 00
       14048283f 48 89 84        MOV        qword ptr [RSP + local_48],RAX
                 24 90 00 
                 00 00
       140482847 eb 05           JMP        LAB_14048284e
       140482849 e9 04 01        JMP        LAB_140482952
                 00 00

`````

-----------------------------------------------------

case 29


`````shell
DOUBLE FETCH:   cr3 0xbade3000, syscall 0x13c3
   user_address 0x1d82b7d0f00, user_data 0x10, modrm 0x8, pc 0xfffff960ccdab2d7
   user_address 0x1d82b7d0f00, user_data 0x10, modrm 0x8, pc 0xfffff960ccdab2d7

`````

`````shell
                             LAB_1c02542b7                                   XREF[2]:     1c025429d(j), 1c02542d5(j)  
       1c02542b7 41 0f b6 09     MOVZX      ECX,byte ptr [R9]
       1c02542bb 49 ff c1        INC        R9
       1c02542be 41 0f b7        MOVZX      EAX,word ptr [R11 + RCX*0x4]
                 04 8b
       1c02542c3 66 89 02        MOV        word ptr [RDX],AX
       1c02542c6 41 8a 44        MOV        AL,byte ptr [R11 + RCX*0x4 + 0x2]
                 8b 02
       1c02542cb 88 42 02        MOV        byte ptr [RDX + 0x2],AL
       1c02542ce 48 83 c2 03     ADD        RDX,0x3
       1c02542d2 49 3b d2        CMP        RDX,R10
       1c02542d5 72 e0           JC         LAB_1c02542b7
                             LAB_1c02542d7                                   XREF[1]:     1c02542b5(j)  
   --> 1c02542d7 41 8a 08        MOV        CL,byte ptr [R8]
       1c02542da f6 c1 02        TEST       CL,0x2
       1c02542dd 74 38           JZ         LAB_1c0254317
       1c02542df 41 8b 40 34     MOV        EAX,dword ptr [R8 + 0x34]
       1c02542e3 85 c0           TEST       EAX,EAX
       1c02542e5 74 13           JZ         LAB_1c02542fa
       1c02542e7 83 e8 01        SUB        EAX,0x1
       1c02542ea 41 89 40 34     MOV        dword ptr [R8 + 0x34],EAX
       1c02542ee 74 0a           JZ         LAB_1c02542fa
       1c02542f0 49 63 40 3c     MOVSXD     RAX,dword ptr [R8 + 0x3c]
       1c02542f4 49 01 40 28     ADD        qword ptr [R8 + 0x28],RAX
       1c02542f8 eb 1d           JMP        LAB_1c0254317

`````

--------------------------------------------------

case 30


***

need review

`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x1077
   user_address 0x195c82ff664, user_data 0x42000000, modrm 0x3c, pc 0xfffff960ccb17682
   user_address 0x195c82ff664, user_data 0x42000000, modrm 0x4, pc 0xfffff960ccaf197a
`````

`````shell
                             LAB_1c011766b                                   XREF[1]:     1c01b0b25(j)
       1c011766b 48 85 c9        TEST       param_1,param_1
       1c011766e 0f 84 a3        JZ         LAB_1c01b0b17
                 94 09 00
       1c0117674 41 0f b7 c5     MOVZX      EAX,R13W
       1c0117678 66 45 85 d2     TEST       R10W,R10W
       1c011767c 0f 84 88        JZ         LAB_1c011840a
                 0d 00 00
   --> 1c0117682 44 8b 3c 81     MOV        R15D,dword ptr [param_1 + RAX*0x4]
       1c0117686 8b 7c 81 04     MOV        EDI,dword ptr [param_1 + RAX*0x4 + 0x4]
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
       1c00f1950 41 8b 41 10     MOV        EAX,dword ptr [R9 + 0x10]
       1c00f1954 66 c1 c9 08     ROR        CX,0x8
       1c00f1958 0f b7 e9        MOVZX      EBP,CX
       1c00f195b 42 0f b7        MOVZX      ECX,word ptr [RAX + R10*0x1 + 0x32]
                 4c 10 32
       1c00f1961 66 c1 c9 08     ROR        CX,0x8
       1c00f1965 44 0f bf c9     MOVSX      R9D,CX
       1c00f1969 45 85 c9        TEST       R9D,R9D
       1c00f196c 0f 84 b2        JZ         LAB_1c00f1a24
                 00 00 00
       1c00f1972 41 83 e9 01     SUB        R9D,0x1
       1c00f1976 75 0c           JNZ        LAB_1c00f1984
       1c00f1978 8b c2           MOV        EAX,EDX
   --> 1c00f197a 8b 04 83        MOV        EAX,dword ptr [RBX + RAX*0x4]
       1c00f197d 0f c8           BSWAP      EAX
       1c00f197f 8b c0           MOV        EAX,EAX
                             LAB_1c00f1981                                   XREF[1]:     1c00f1a35(j)  
       1c00f1981 4c 03 c0        ADD        R8,RAX
                             LAB_1c00f1984                                   XREF[1]:     1c00f1976(j)  
       1c00f1984 41 0f b7        MOVZX      EBX,word ptr [R8 + 0x8]
                 58 08
       1c00f1989 45 0f b7        MOVZX      R9D,word ptr [R8 + 0x4]
                 48 04
       1c00f198e 41 0f b7        MOVZX      EDI,word ptr [R8 + 0x2]
                 78 02
       1c00f1993 41 0f b7        MOVZX      ESI,word ptr [R8 + 0x6]
                 70 06

`````

--------------------------------------------------------

case 31

didn't find them in win32kfull.sys. High chances they are 8a 01, which is useless probe code.

`````shell
DOUBLE FETCH:   cr3 0x108338000, syscall 0x13fb
   user_address 0x60ac1fe678, user_data 0x1, modrm 0x1, pc 0xfffff960ccdd7b13
   user_address 0x60ac1fe678, user_data 0x1, modrm 0x45, pc 0xfffff960ccdd7b17

DOUBLE FETCH:   cr3 0x108338000, syscall 0x13fb
   user_address 0x60ac1fe670, user_data 0x2, modrm 0x1, pc 0xfffff960ccdd7b4c
   user_address 0x60ac1fe670, user_data 0x2, modrm 0x7, pc 0xfffff960ccdd7b50
`````



-------------------------------------------------------

case 32


`````shell
DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2c7748, user_data 0x0, modrm 0x8a, pc 0xfffff8032e8861de
   user_address 0x2c7748, user_data 0x0, modrm 0x8a, pc 0xfffff8032e8861de

DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2c8000, user_data 0x10, modrm 0x1, pc 0xfffff8032e88632f
   user_address 0x2c8000, user_data 0x10, modrm 0x1, pc 0xfffff8032e88632f

DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2c8004, user_data 0x6b70000, modrm 0x4e, pc 0xfffff8032e886331
   user_address 0x2c8004, user_data 0x6b70000, modrm 0x4e, pc 0xfffff8032e886331

DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2c8e0c, user_data 0x6a70000, modrm 0x86, pc 0xfffff8032e886339
   user_address 0x2c8e0c, user_data 0x6a70000, modrm 0x86, pc 0xfffff8032e886339

DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2c8f78, user_data 0x0, modrm 0x96, pc 0xfffff8032e886344
   user_address 0x2c8f78, user_data 0x0, modrm 0x96, pc 0xfffff8032e886344

DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2b20bc, user_data 0x0, modrm 0x82, pc 0xfffff8032e886267
   user_address 0x2b20bc, user_data 0x0, modrm 0x82, pc 0xfffff8032e886267
DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2c8004, user_data 0x6b70000, modrm 0x4e, pc 0xfffff8032e886331
   user_address 0x2c8004, user_data 0x6b70000, modrm 0x4e, pc 0xfffff8032e886331

DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2c8e0c, user_data 0x6a70000, modrm 0x86, pc 0xfffff8032e886339
   user_address 0x2c8e0c, user_data 0x6a70000, modrm 0x86, pc 0xfffff8032e886339

DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2c8f78, user_data 0x0, modrm 0x96, pc 0xfffff8032e886344
   user_address 0x2c8f78, user_data 0x0, modrm 0x96, pc 0xfffff8032e886344

DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2b20bc, user_data 0x0, modrm 0x82, pc 0xfffff8032e886267
   user_address 0x2b20bc, user_data 0x0, modrm 0x82, pc 0xfffff8032e886267

DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2c6008, user_data 0xe2fd20, modrm 0x42, pc 0xfffff8032e8861c9
   user_address 0x2c6008, user_data 0xe2fd20, modrm 0x42, pc 0xfffff8032e8861c9

DOUBLE FETCH:   cr3 0x0, syscall 0x1004
   user_address 0x2c7478, user_data 0xdf0000, modrm 0x82, pc 0xfffff8032e8861d2
   user_address 0x2c7478, user_data 0xdf0000, modrm 0x82, pc 0xfffff8032e8861d2

`````

`````shell
       14047a1b5 e8 46 10        CALL       KeIsAttachedProcess                              undefined KeIsAttachedProcess()
                 bf ff
       14047a1ba 84 c0           TEST       AL,AL
       14047a1bc 0f 85 d4        JNZ        LAB_14047a396
                 01 00 00
       14047a1c2 49 8b 96        MOV        RDX,qword ptr [R14 + 0xf0]
                 f0 00 00 00
   x   14047a1c9 4c 8b 42 08     MOV        R8,qword ptr [RDX + 0x8]
       14047a1cd 4c 89 44        MOV        qword ptr [RSP + local_40],R8
                 24 38
   x   14047a1d2 48 8b 82        MOV        RAX,qword ptr [RDX + 0x1478]
                 78 14 00 00
       14047a1d9 48 89 44        MOV        qword ptr [RSP + local_38],RAX
                 24 40
   x   14047a1de 8b 8a 48        MOV        ECX,dword ptr [RDX + 0x1748]
                 17 00 00
       14047a1e4 48 89 8c        MOV        qword ptr [RSP + local_res18],RCX
                 24 90 00 
                 00 00
       14047a1ec eb 0a           JMP        LAB_14047a1f8
       14047a1ee b8 01 00        MOV        EAX,0x80000001
                 00 80
       14047a1f3 e9 ea 00        JMP        LAB_14047a2e2
                 00 00
                             LAB_14047a1f8                                   XREF[1]:     14047a1ec(j)  
       14047a1f8 49 c7 c2        MOV        R10,-0x1000
                 00 f0 ff ff
       14047a1ff 49 23 c2        AND        RAX,R10
       14047a202 48 81 c1        ADD        RCX,0xfff
                 ff 0f 00 00
       14047a209 49 23 ca        AND        RCX,R10
       14047a20c 4c 8d 7a 10     LEA        R15,[RDX + 0x10]
       14047a210 bf 00 10        MOV        EDI,0x1000
                 00 00
       14047a215 0f 85 d3        JNZ        LAB_14047a2ee
                 00 00 00
                             LAB_14047a21b                                   XREF[1]:     14047a2f1(j)  
       14047a21b 41 b9 00        MOV        R9D,0x3000
                 30 00 00
       14047a221 49 3b c9        CMP        RCX,R9
       14047a224 49 0f 42 c9     CMOVC      RCX,R9
       14047a228 48 89 8c        MOV        qword ptr [RSP + local_res18],RCX
                 24 90 00 
                 00 00
       14047a230 49 3b d8        CMP        RBX,R8
       14047a233 0f 83 bd        JNC        LAB_14047a2f6
                 00 00 00
       14047a239 48 3b d8        CMP        RBX,RAX
       14047a23c 0f 82 b4        JC         LAB_14047a2f6
                 00 00 00
                             LAB_14047a242                                   XREF[1]:     14047a38c(j)  
       14047a242 49 23 da        AND        RBX,R10
       14047a245 48 2b d9        SUB        RBX,RCX
       14047a248 48 89 9c        MOV        qword ptr [RSP + local_res20],RBX
                 24 98 00 
                 00 00
       14047a250 48 3b d8        CMP        RBX,RAX
       14047a253 0f 86 c3        JBE        LAB_14059e81c
                 45 12 00
       14047a259 49 8b 86        MOV        RAX,qword ptr [R14 + 0xb8]
                 b8 00 00 00
       14047a260 48 8b 90        MOV        RDX,qword ptr [RAX + 0x3f8]
                 f8 03 00 00
   x   14047a267 8b 82 bc        MOV        EAX,dword ptr [RDX + 0xbc]
                 00 00 00
       14047a26d 89 44 24 30     MOV        dword ptr [RSP + local_48],EAX
       14047a271 eb 07           JMP        LAB_14047a27a
       14047a273 b8 01 00        MOV        EAX,0x80000001
                 00 80
       14047a278 eb 68           JMP        LAB_14047a2e2
                             LAB_14047a27a                                   XREF[1]:     14047a271(j)  
       14047a27a 0f ba e0 10     BT         EAX,0x10
       14047a27e 0f 82 a8        JC         LAB_14059e82c
                 45 12 00
       14047a284 c7 44 24        MOV        dword ptr [RSP + local_50],0x104
                 28 04 01 
                 00 00
       14047a28c 89 7c 24 20     MOV        dword ptr [RSP + local_58],EDI
       14047a290 4c 8d 8c        LEA        R9=>local_res18,[RSP + 0x90]
                 24 90 00 
                 00 00
       14047a298 45 33 c0        XOR        R8D,R8D
       14047a29b 48 8d 94        LEA        RDX=>local_res20,[RSP + 0x98]
                 24 98 00 
                 00 00
       14047a2a3 48 83 c9 ff     OR         RCX,-0x1
       14047a2a7 e8 34 48        CALL       ZwAllocateVirtualMemory                          undefined ZwAllocateVirtualMemor
                 cc ff
       14047a2ac 48 8b 8c        MOV        RCX,qword ptr [RSP + local_res18]
                 24 90 00 
                 00 00
       14047a2b4 48 8b 9c        MOV        RBX,qword ptr [RSP + local_res20]
                 24 98 00 
                 00 00
                             LAB_14047a2bc                                   XREF[1]:     14059e831(j)  
       14047a2bc 85 c0           TEST       EAX,EAX
       14047a2be 0f 88 72        JS         LAB_14059e836
                 45 12 00
       14047a2c4 48 8d 14 0b     LEA        RDX,[RBX + RCX*0x1]
       14047a2c8 b8 13 01        MOV        EAX,0x113
                 00 00
                             LAB_14047a2cd                                   XREF[1]:     14059e885(j)  
       14047a2cd 90              NOP
       14047a2ce 48 85 f6        TEST       RSI,RSI
       14047a2d1 75 05           JNZ        LAB_14047a2d8
       14047a2d3 49 89 17        MOV        qword ptr [R15],RDX
       14047a2d6 eb 03           JMP        LAB_14047a2db
                             LAB_14047a2d8                                   XREF[1]:     14047a2d1(j)  
       14047a2d8 41 89 17        MOV        dword ptr [R15],EDX
                             LAB_14047a2db                                   XREF[1]:     14047a2d6(j)  
       14047a2db eb 05           JMP        LAB_14047a2e2
       14047a2dd b8              ??         B8h
       14047a2de 01              ??         01h
       14047a2df 00              ??         00h
       14047a2e0 00              ??         00h
       14047a2e1 80              ??         80h
                             LAB_14047a2e2                                   XREF[5]:     14047a1f3(j), 14047a278(j), 
                                                                                          14047a2db(j), 14047a359(j), 
                                                                                          14047a39b(j)  
       14047a2e2 48 83 c4 50     ADD        RSP,0x50
       14047a2e6 41 5f           POP        R15
       14047a2e8 41 5e           POP        R14
       14047a2ea 5f              POP        RDI
       14047a2eb 5e              POP        RSI
       14047a2ec 5b              POP        RBX
       14047a2ed c3              RET
                             LAB_14047a2ee                                   XREF[1]:     14047a215(j)  
       14047a2ee 48 03 cf        ADD        RCX,RDI
       14047a2f1 e9 25 ff        JMP        LAB_14047a21b
                 ff ff
                             LAB_14047a2f6                                   XREF[2]:     14047a233(j), 14047a23c(j)  
       14047a2f6 49 8b 86        MOV        RAX,qword ptr [R14 + 0xb8]
                 b8 00 00 00
       14047a2fd 48 83 b8        CMP        qword ptr [RAX + 0x428],0x0
                 28 04 00 
                 00 00
       14047a305 0f 84 8b        JZ         LAB_14047a396
                 00 00 00
       14047a30b 48 8d b2        LEA        RSI,[RDX + 0x2000]
                 00 20 00 00
       14047a312 40 f6 c6 03     TEST       SIL,0x3
       14047a316 74 05           JZ         LAB_14047a31d
       14047a318 e8 f3 7e        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 1f 00
                             LAB_14047a31d                                   XREF[1]:     14047a316(j)  
       14047a31d 48 8b ce        MOV        RCX,RSI
       14047a320 48 3b 35        CMP        RSI,qword ptr [MmUserProbeAddress]               = ??
                 d9 4e f0 ff
       14047a327 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d d1 4e 
                 f0 ff
   x   14047a32f 8a 01           MOV        AL,byte ptr [RCX]
   x   14047a331 8b 4e 04        MOV        ECX,dword ptr [RSI + 0x4]
       14047a334 48 89 4c        MOV        qword ptr [RSP + local_40],RCX
                 24 38
   x   14047a339 8b 86 0c        MOV        EAX,dword ptr [RSI + 0xe0c]
                 0e 00 00
       14047a33f 48 89 44        MOV        qword ptr [RSP + local_38],RAX
                 24 40
   x   14047a344 8b 96 78        MOV        EDX,dword ptr [RSI + 0xf78]
                 0f 00 00
       14047a34a 48 89 94        MOV        qword ptr [RSP + local_res18],RDX
                 24 90 00 
                 00 00
       14047a352 eb 07           JMP        LAB_14047a35b
       14047a354 b8 01 00        MOV        EAX,0x80000001
                 00 80
       14047a359 eb 87           JMP        LAB_14047a2e2

`````

-------------------------------------------------------

case 33

`````shell
DOUBLE FETCH:   cr3 0xbade3000, syscall 0x13be
   user_address 0x1b2679db9f8, user_data 0x0, modrm 0x4a, pc 0xfffff960cca3e368
   user_address 0x1b2679db9f8, user_data 0x0, modrm 0x4a, pc 0xfffff960cca3e368
`````

`````shell
                             LAB_1c003e353                                   XREF[1]:     1c003e32b(j)  
       1c003e353 48 8b 91        MOV        RDX,qword ptr [RCX + 0x178]
                 78 01 00 00
       1c003e35a 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 97 32 31 00
       1c003e361 48 3b 10        CMP        RDX,qword ptr [RAX]
       1c003e364 48 0f 43 10     CMOVNC     RDX,qword ptr [RAX]
   --> 1c003e368 48 8b 4a 10     MOV        RCX,qword ptr [RDX + 0x10]
       1c003e36c 48 89 4c        MOV        qword ptr [RSP + local_80],RCX
                 24 28
       1c003e371 eb 1f           JMP        LAB_1c003e392
       1c003e373 4c 8b ac        MOV        R13,qword ptr [RSP + 0xc0]
                 24 c0 00 
                 00 00
       1c003e37b 48 8b b4        MOV        RSI,qword ptr [RSP + 0xc8]
                 24 c8 00 
                 00 00
       1c003e383 4c 8b 74        MOV        R14,qword ptr [RSP + 0x20]
                 24 20
       1c003e388 48 8b bc        MOV        RDI,qword ptr [RSP + 0xb8]
                 24 b8 00 
                 00 00
       1c003e390 eb 9b           JMP        LAB_1c003e32d

`````

----------------------------------------------------

case 34

`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x10b5
   user_address 0x195c7e70058, user_data 0x1e000000, modrm 0x42, pc 0xfffff960ccb0e935
   user_address 0x195c7e70058, user_data 0x1e000000, modrm 0x42, pc 0xfffff960ccb0e935

DOUBLE FETCH:   cr3 0x5124e000, syscall 0x10b5
   user_address 0x195c7e7005c, user_data 0x6d677066, modrm 0x2, pc 0xfffff960ccb0e85c
   user_address 0x195c7e7005c, user_data 0x6d677066, modrm 0x2, pc 0xfffff960ccb0e85c

DOUBLE FETCH:   cr3 0x5124e000, syscall 0x10b5
   user_address 0x195c7e70064, user_data 0x5c200000, modrm 0x42, pc 0xfffff960ccb0e92c
   user_address 0x195c7e70064, user_data 0x5c200000, modrm 0x42, pc 0xfffff960ccb0e92c

`````


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c010e85c()
             undefined         AL:1           <RETURN>
                             FUN_1c010e85c                                   XREF[1]:     FUN_1c010e790:1c010e818(c)  
   x   1c010e85c 8b 02           MOV        EAX,dword ptr [RDX]
       1c010e85e 4c 8b c1        MOV        R8,RCX
       1c010e861 0f c8           BSWAP      EAX
       1c010e863 b9 66 79        MOV        ECX,0x676c7966
                 6c 67
       1c010e868 3b c1           CMP        EAX,ECX
       1c010e86a 77 6a           JA         LAB_1c010e8d6
       1c010e86c 0f 84 dc        JZ         LAB_1c010e94e
                 00 00 00
       1c010e872 3d 32 2f        CMP        EAX,0x4f532f32
                 53 4f
       1c010e877 0f 84 ca        JZ         LAB_1c010e947
                 00 00 00
       1c010e87d 3d 70 61        CMP        EAX,0x636d6170
                 6d 63
       1c010e882 0f 84 b8        JZ         LAB_1c010e940
                 00 00 00
       1c010e888 3d 20 74        CMP        EAX,0x63767420
                 76 63
       1c010e88d 0f 84 91        JZ         LAB_1c010e924
                 00 00 00
       1c010e893 3d 6d 67        CMP        EAX,0x6670676d
                 70 66
       1c010e898 0f 84 de        JZ         LAB_1c010e97c
                 00 00 00
       1c010e89e 3d 48 53        CMP        EAX,0x4c545348
                 54 4c
       1c010e8a3 0f 84 e1        JZ         LAB_1c010e98a
                 00 00 00
       1c010e8a9 3d 54 44        CMP        EAX,0x45424454
                 42 45
       1c010e8ae 0f 84 eb        JZ         LAB_1c010e99f
                 00 00 00
       1c010e8b4 3d 43 4c        CMP        EAX,0x45424c43
                 42 45
       1c010e8b9 0f 84 d9        JZ         LAB_1c010e998
                 00 00 00
       1c010e8bf 3d 43 53        CMP        EAX,0x45425343
                 42 45
       1c010e8c4 0f 84 42        JZ         LAB_1c01af10c
                 08 0a 00
       1c010e8ca 3d 72 69        CMP        EAX,0x67646972
                 64 67
       1c010e8cf 0f 84 2d        JZ         LAB_1c01af102
                 08 0a 00
       1c010e8d5 c3              RET
                             LAB_1c010e8d6                                   XREF[1]:     1c010e86a(j)  
       1c010e8d6 3d 64 61        CMP        EAX,0x68656164
                 65 68
       1c010e8db 0f 84 97        JZ         LAB_1c010e978
                 00 00 00
       1c010e8e1 3d 61 65        CMP        EAX,0x68686561
                 68 68
       1c010e8e6 0f 84 85        JZ         LAB_1c010e971
                 00 00 00
       1c010e8ec 3d 78 74        CMP        EAX,0x686d7478
                 6d 68
       1c010e8f1 74 77           JZ         LAB_1c010e96a
       1c010e8f3 3d 61 63        CMP        EAX,0x6c6f6361
                 6f 6c
       1c010e8f8 74 69           JZ         LAB_1c010e963
       1c010e8fa 3d 70 78        CMP        EAX,0x6d617870
                 61 6d
       1c010e8ff 74 5b           JZ         LAB_1c010e95c
       1c010e901 3d 70 65        CMP        EAX,0x70726570
                 72 70
       1c010e906 74 4d           JZ         LAB_1c010e955
       1c010e908 3d 78 6d        CMP        EAX,0x68646d78
                 64 68
       1c010e90d 74 74           JZ         LAB_1c010e983
       1c010e90f 3d 61 65        CMP        EAX,0x76686561
                 68 76
       1c010e914 74 7b           JZ         LAB_1c010e991
       1c010e916 3d 78 74        CMP        EAX,0x766d7478
                 6d 76
       1c010e91b 75 22           JNZ        LAB_1c010e93f
       1c010e91d b8 14 00        MOV        EAX,0x14
                 00 00
       1c010e922 eb 05           JMP        LAB_1c010e929
                             LAB_1c010e924                                   XREF[1]:     1c010e88d(j)  
       1c010e924 b8 04 00        MOV        EAX,0x4
                 00 00
                             LAB_1c010e929                                   XREF[18]:    1c010e922(j), 1c010e945(j), 
                                                                                          1c010e94c(j), 1c010e953(j), 
                                                                                          1c010e95a(j), 1c010e961(j), 
                                                                                          1c010e968(j), 1c010e96f(j), 
                                                                                          1c010e976(j), 1c010e97a(j), 
                                                                                          1c010e981(j), 1c010e988(j), 
                                                                                          1c010e98f(j), 1c010e996(j), 
                                                                                          1c010e99d(j), 1c010e9a4(j), 
                                                                                          1c01af107(j), 1c01af111(j)  
       1c010e929 48 63 c8        MOVSXD     RCX,EAX
   x   1c010e92c 8b 42 08        MOV        EAX,dword ptr [RDX + 0x8]
       1c010e92f 0f c8           BSWAP      EAX
       1c010e931 41 89 04 c8     MOV        dword ptr [R8 + RCX*0x8],EAX
   x   1c010e935 8b 42 0c        MOV        EAX,dword ptr [RDX + 0xc]
       1c010e938 0f c8           BSWAP      EAX
       1c010e93a 41 89 44        MOV        dword ptr [R8 + RCX*0x8 + 0x4],EAX
                 c8 04
                             LAB_1c010e93f                                   XREF[1]:     1c010e91b(j)  
       1c010e93f c3              RET

`````

--------------------------------------------------------------------

case 35

`````shell
DOUBLE FETCH:   cr3 0x5124e000, syscall 0x10b5
   user_address 0x195c7e70128, user_data 0xf53c0f5f, modrm 0x42, pc 0xfffff960ccb0ea26
   user_address 0x195c7e70128, user_data 0xf53c0f5f, modrm 0x42, pc 0xfffff960ccb0ea26

DOUBLE FETCH:   cr3 0x5124e000, syscall 0x10b5
   user_address 0x195c7e70178, user_data 0x100, modrm 0x1, pc 0xfffff960ccb0eb3e
   user_address 0x195c7e70178, user_data 0x100, modrm 0x1, pc 0xfffff960ccb0eb3e

DOUBLE FETCH:   cr3 0x5124e000, syscall 0x10b5
   user_address 0x195c7e71494, user_data 0xc000000, modrm 0x40, pc 0xfffff960ccb0dcc0
   user_address 0x195c7e71494, user_data 0xc000000, modrm 0x40, pc 0xfffff960ccb0dcc0

`````

`````shell
       1c010e9f5 48 8d 44        LEA        RAX=>local_10,[RSP + 0x38]
                 24 38
       1c010e9fa 41 83 c8 ff     OR         R8D,0xffffffff
       1c010e9fe 48 89 44        MOV        qword ptr [RSP + local_20],RAX
                 24 28
       1c010ea03 44 8d 4d 01     LEA        R9D,[RBP + 0x1]
       1c010ea07 33 d2           XOR        EDX,EDX
       1c010ea09 c7 44 24        MOV        dword ptr [RSP + local_28],0x1
                 20 01 00 
                 00 00
       1c010ea11 48 8b cb        MOV        RCX,RBX
       1c010ea14 e8 6f 02        CALL       FUN_1c010ec88                                    undefined FUN_1c010ec88(undefine
                 00 00
       1c010ea19 85 c0           TEST       EAX,EAX
       1c010ea1b 0f 85 1a        JNZ        LAB_1c010ec3b
                 02 00 00
       1c010ea21 48 8b 54        MOV        RDX,qword ptr [RSP + local_18]
                 24 30
   x   1c010ea26 8b 42 0c        MOV        EAX,dword ptr [RDX + 0xc]
       1c010ea29 0f c8           BSWAP      EAX
       1c010ea2b 3d f5 3c        CMP        EAX,0x5f0f3cf5
                 0f 5f
       1c010ea30 0f 85 e0        JNZ        LAB_1c01af116
                 06 0a 00
       1c010ea36 0f b7 42 12     MOVZX      EAX,word ptr [RDX + 0x12]
       1c010ea3a b9 f0 3f        MOV        ECX,0x3ff0
                 00 00
       1c010ea3f 66 c1 c8 08     ROR        AX,0x8
       1c010ea43 66 89 06        MOV        word ptr [RSI],AX
       1c010ea46 66 83 e8 10     SUB        AX,0x10
       1c010ea4a 66 3b c1        CMP        AX,CX
       1c010ea4d 0f 87 fa        JA         LAB_1c01af14d
                 06 0a 00
       1c010ea53 0f b7 42 10     MOVZX      EAX,word ptr [RDX + 0x10]
       1c010ea57 48 8b 74        MOV        RSI,qword ptr [RSP + local_10]
                 24 38
       1c010ea5c 66 c1 c8 08     ROR        AX,0x8
       1c010ea60 0f b6 c8        MOVZX      ECX,AL
       1c010ea63 c1 e9 03        SHR        ECX,0x3
       1c010ea66 83 e1 01        AND        ECX,0x1
       1c010ea69 41 89 0e        MOV        dword ptr [R14],ECX
       1c010ea6c 0f b7 46 22     MOVZX      EAX,word ptr [RSI + 0x22]
       1c010ea70 66 c1 c8 08     ROR        AX,0x8
       1c010ea74 66 89 83        MOV        word ptr [RBX + 0xc8],AX
                 c8 00 00 00
       1c010ea7b 66 85 c0        TEST       AX,AX
       1c010ea7e 0f 84 9c        JZ         LAB_1c01af120
                 06 0a 00
       1c010ea84 0f b7 42 32     MOVZX      EAX,word ptr [RDX + 0x32]
       1c010ea88 44 8d 4d 0e     LEA        R9D,[RBP + 0xe]
       1c010ea8c 66 c1 c8 08     ROR        AX,0x8
       1c010ea90 44 8d 45 4e     LEA        R8D,[RBP + 0x4e]
       1c010ea94 66 89 43 10     MOV        word ptr [RBX + 0x10],AX
       1c010ea98 33 d2           XOR        EDX,EDX
       1c010ea9a 48 8d 44        LEA        RAX=>local_10,[RSP + 0x38]
                 24 38
       1c010ea9f 48 8b cb        MOV        RCX,RBX
       1c010eaa2 48 89 44        MOV        qword ptr [RSP + local_20],RAX
                 24 28
       1c010eaa7 89 6c 24 20     MOV        dword ptr [RSP + local_28],EBP
       1c010eaab e8 d8 01        CALL       FUN_1c010ec88                                    undefined FUN_1c010ec88(undefine
                 00 00
       1c010eab0 85 c0           TEST       EAX,EAX
       1c010eab2 0f 85 83        JNZ        LAB_1c010ec3b
                 01 00 00
       1c010eab8 48 8b 4c        MOV        RCX,qword ptr [RSP + local_10]
                 24 38
       1c010eabd 48 85 c9        TEST       RCX,RCX
       1c010eac0 0f 84 64        JZ         LAB_1c01af12a
                 06 0a 00
       1c010eac6 0f b7 41 44     MOVZX      EAX,word ptr [RCX + 0x44]
       1c010eaca 66 c1 c8 08     ROR        AX,0x8
       1c010eace 66 89 83        MOV        word ptr [RBX + 0xe0],AX
                 e0 00 00 00
       1c010ead5 0f b7 41 46     MOVZX      EAX,word ptr [RCX + 0x46]
       1c010ead9 8b 4b 0c        MOV        ECX,dword ptr [RBX + 0xc]
       1c010eadc 66 c1 c8 08     ROR        AX,0x8
       1c010eae0 66 89 83        MOV        word ptr [RBX + 0xe2],AX
                 e2 00 00 00
       1c010eae7 e8 88 01        CALL       FUN_1c010ec74                                    undefined FUN_1c010ec74()
                 00 00
                             LAB_1c010eaec                                   XREF[1]:     1c01af148(j)  
       1c010eaec 0f b7 46 06     MOVZX      EAX,word ptr [RSI + 0x6]
       1c010eaf0 8b 4b 0c        MOV        ECX,dword ptr [RBX + 0xc]
       1c010eaf3 66 c1 c8 08     ROR        AX,0x8
       1c010eaf7 66 89 83        MOV        word ptr [RBX + 0xe4],AX
                 e4 00 00 00
       1c010eafe e8 71 01        CALL       FUN_1c010ec74                                    undefined FUN_1c010ec74()
                 00 00
       1c010eb03 8b 4b 0c        MOV        ECX,dword ptr [RBX + 0xc]
       1c010eb06 e8 69 01        CALL       FUN_1c010ec74                                    undefined FUN_1c010ec74()
                 00 00
       1c010eb0b 48 8d 44        LEA        RAX=>local_10,[RSP + 0x38]
                 24 38
       1c010eb10 41 b9 03        MOV        R9D,0x3
                 00 00 00
       1c010eb16 48 89 44        MOV        qword ptr [RSP + local_20],RAX
                 24 28
       1c010eb1b 41 83 c8 ff     OR         R8D,0xffffffff
       1c010eb1f 33 d2           XOR        EDX,EDX
       1c010eb21 c7 44 24        MOV        dword ptr [RSP + local_28],0x1
                 20 01 00 
                 00 00
       1c010eb29 48 8b cb        MOV        RCX,RBX
       1c010eb2c e8 57 01        CALL       FUN_1c010ec88                                    undefined FUN_1c010ec88(undefine
                 00 00
       1c010eb31 85 c0           TEST       EAX,EAX
       1c010eb33 0f 85 02        JNZ        LAB_1c010ec3b
                 01 00 00
       1c010eb39 48 8b 4c        MOV        RCX,qword ptr [RSP + local_10]
                 24 38
   x   1c010eb3e 8b 01           MOV        EAX,dword ptr [RCX]
       1c010eb40 0f c8           BSWAP      EAX
       1c010eb42 89 07           MOV        dword ptr [RDI],EAX
       1c010eb44 0f b7 41 04     MOVZX      EAX,word ptr [RCX + 0x4]
       1c010eb48 66 c1 c8 08     ROR        AX,0x8
       1c010eb4c 66 89 47 04     MOV        word ptr [RDI + 0x4],AX
       1c010eb50 0f b7 41 06     MOVZX      EAX,word ptr [RCX + 0x6]
       1c010eb54 66 c1 c8 08     ROR        AX,0x8
       1c010eb58 66 89 47 06     MOV        word ptr [RDI + 0x6],AX

`````


`````shell
       1c0226cab 48 89 45 10     MOV        qword ptr [RBP + local_b8],RAX
       1c0226caf 41 8b 40 28     MOV        EAX,dword ptr [param_3 + 0x28]
       1c0226cb3 89 44 24 30     MOV        dword ptr [RSP + local_198],EAX
       1c0226cb7 48 8d 44        LEA        RAX=>local_198,[RSP + 0x30]
                 24 30
       1c0226cbc 48 89 45 20     MOV        qword ptr [RBP + local_a8],RAX
   x   1c0226cc0 41 8b 40 2c     MOV        EAX,dword ptr [param_3 + 0x2c]
       1c0226cc4 89 44 24 34     MOV        dword ptr [RSP + local_194],EAX
       1c0226cc8 48 8d 44        LEA        RAX=>local_194,[RSP + 0x34]
                 24 34
       1c0226ccd 48 89 45 30     MOV        qword ptr [RBP + local_98],RAX
       1c0226cd1 41 8b 40 30     MOV        EAX,dword ptr [param_3 + 0x30]
       1c0226cd5 89 44 24 3c     MOV        dword ptr [RSP + local_18c],EAX
       1c0226cd9 48 8d 44        LEA        RAX=>local_18c,[RSP + 0x3c]
                 24 3c
       1c0226cde 48 89 45 40     MOV        qword ptr [RBP + local_88],RAX
       1c0226ce2 41 8b 40 34     MOV        EAX,dword ptr [param_3 + 0x34]
       1c0226ce6 89 44 24 44     MOV        dword ptr [RSP + local_184],EAX
       1c0226cea 48 8d 44        LEA        RAX=>local_184,[RSP + 0x44]
                 24 44

`````


----------------------------------------------------------------------------

case 36

not found?

`````shell
DOUBLE FETCH:   cr3 0xb68ca000, syscall 0x1012
   user_address 0x11047617d0, user_data 0x0, modrm 0x80, pc 0xfffff8032e4edafb
   user_address 0x11047617d0, user_data 0x0, modrm 0x80, pc 0xfffff8032e4edafb
`````

--------------------------------------------------------------------------

case 37

useless

`````shell
DOUBLE FETCH:   cr3 0xbc767000, syscall 0x1449
   user_address 0x11049ff498, user_data 0xe1, modrm 0x0, pc 0xfffff960ccaffc4d
   user_address 0x11049ff498, user_data 0xfce1, modrm 0x6, pc 0xfffff960ccaffc4f

`````

`````shell
       1c00ffc23 ff 15 07        CALL       qword ptr [->WIN32KBASE.SYS::ValidateHwinsta]
                 02 25 00
       1c00ffc29 33 db           XOR        EBX,EBX
       1c00ffc2b 85 c0           TEST       EAX,EAX
       1c00ffc2d 0f 88 84        JS         LAB_1c00ffcb7
                 00 00 00
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
       1c00ffc57 48 85 ff        TEST       RDI,RDI
       1c00ffc5a 74 33           JZ         LAB_1c00ffc8f
       1c00ffc5c 45 85 f6        TEST       R14D,R14D
       1c00ffc5f 74 2e           JZ         LAB_1c00ffc8f
       1c00ffc61 40 f6 c7 03     TEST       DIL,0x3
       1c00ffc65 75 20           JNZ        LAB_1c00ffc87
       1c00ffc67 4a 8d 0c 37     LEA        RCX,[RDI + R14*0x1]
       1c00ffc6b 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 86 19 25 00

`````

-----------------------------------------------------------------------

case 38

`````shell
DOUBLE FETCH:   cr3 0xb68ca000, syscall 0x1203
   user_address 0x7ffc5742b040, user_data 0x409, modrm 0x9, pc 0xfffff8032e852d9c
   user_address 0x7ffc5742b040, user_data 0x409, modrm 0x9, pc 0xfffff8032e852d9c
`````

`````shelll
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_140446d54(undefined param_1, undefined par
             undefined         AL:1           <RETURN>
             undefined         CL:1           param_1
             undefined         DL:1           param_2
             undefined         R8B:1          param_3
             undefined         R9B:1          param_4
             undefined8        Stack[0x28]:8  param_5                                 XREF[1]:     140446d6a(R)  
             undefined8        Stack[0x30]:8  param_6                                 XREF[1]:     140446d82(R)  
             undefined4        Stack[0x38]:4  param_7                                 XREF[1]:     140446d63(R)  
             undefined8        Stack[0x40]:8  param_8                                 XREF[4]:     140446db1(R), 
                                                                                                   140446e25(R), 
                                                                                                   140585f68(R), 
                                                                                                   140585f78(R)  
             undefined8        Stack[0x10]:8  local_res10                             XREF[2]:     140446d59(W), 
                                                                                                   140446dbf(R)  
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     140446d54(W), 
                                                                                                   140446dba(R)  
                             FUN_140446d54                                   XREF[6]:     14027e374(*), 14027e394(*), 
                                                                                          14035996c(*), 140359974(*), 
                                                                                          FUN_140446e38:140447123(c), 
                                                                                          FUN_140446e38:140447226(c)  
       140446d54 48 89 5c        MOV        qword ptr [RSP + local_res8],RBX
                 24 08
       140446d59 48 89 74        MOV        qword ptr [RSP + local_res10],RSI
                 24 10
       140446d5e 57              PUSH       RDI
       140446d5f 48 83 ec 20     SUB        RSP,0x20
       140446d63 8b 44 24 60     MOV        EAX,dword ptr [RSP + param_7]
       140446d67 49 8b f1        MOV        RSI,param_4
       140446d6a 4c 8b 4c        MOV        param_4,qword ptr [RSP + param_5]
                 24 50
       140446d6f 33 db           XOR        EBX,EBX
       140446d71 c1 e8 0c        SHR        EAX,0xc
       140446d74 48 8b d1        MOV        param_2,param_1
       140446d77 24 01           AND        AL,0x1
       140446d79 4d 85 c9        TEST       param_4,param_4
       140446d7c 0f 84 14        JZ         LAB_140585f96
                 f2 13 00
       140446d82 48 8b 4c        MOV        param_1,qword ptr [RSP + param_6]
                 24 58
       140446d87 48 85 c9        TEST       param_1,param_1
       140446d8a 0f 84 06        JZ         LAB_140585f96
                 f2 13 00
       140446d90 49 c7 c2        MOV        R10,-0x10000
                 00 00 ff ff
       140446d97 49 85 f2        TEST       R10,RSI
       140446d9a 75 2e           JNZ        LAB_140446dca
   --> 140446d9c 8b 09           MOV        param_1,dword ptr [param_1]
       140446d9e 85 c9           TEST       param_1,param_1
       140446da0 0f 88 e2        JS         LAB_140585f88
                 f1 13 00
       140446da6 84 c0           TEST       AL,AL
       140446da8 74 05           JZ         LAB_140446daf
       140446daa 49 85 ca        TEST       R10,param_1
       140446dad 75 7f           JNZ        LAB_140446e2e
                             LAB_140446daf                                   XREF[1]:     140446da8(j)  
       140446daf 2b f1           SUB        ESI,param_1
       140446db1 48 8b 4c        MOV        param_1,qword ptr [RSP + param_8]
                 24 68
       140446db6 89 31           MOV        dword ptr [param_1],ESI

`````


---------------------------------------------------------------------


case 39


`````shell
DOUBLE FETCH:   cr3 0xb68ca000, syscall 0x1203
   user_address 0x7ffc5742b02c, user_data 0x80000030, modrm 0x52, pc 0xfffff8032e853142
   user_address 0x7ffc5742b02c, user_data 0x80000030, modrm 0x52, pc 0xfffff8032e853142
`````

`````shell
       140447120 49 8b cb        MOV        param_1,R11
       140447123 e8 2c fc        CALL       FUN_140446d54                                    undefined FUN_140446d54(undefine
                 ff ff
       140447128 89 44 24 40     MOV        dword ptr [RSP + local_e8],EAX
       14044712c 85 c0           TEST       EAX,EAX
       14044712e 0f 88 46        JS         LAB_14044787a
                 07 00 00
       140447134 39 5c 24 68     CMP        dword ptr [RSP + local_c0],EBX
       140447138 75 4a           JNZ        LAB_140447184
       14044713a 48 8b 94        MOV        param_2,qword ptr [RSP + local_98]
                 24 90 00 
                 00 00
   --> 140447142 8b 52 04        MOV        param_2,dword ptr [param_2 + 0x4]
       140447145 85 d2           TEST       param_2,param_2
       140447147 0f 89 80        JNS        LAB_1404476cd
                 05 00 00
                             LAB_14044714d                                   XREF[1]:     1404475ca(j)  
       14044714d 40 84 f6        TEST       SIL,SIL
       140447150 0f 84 00        JZ         LAB_140447856
                 07 00 00
       140447156 48 39 5c        CMP        qword ptr [RSP + local_b0],RBX
                 24 78
       14044715b 0f 85 bd        JNZ        LAB_14044781e
                 06 00 00
       140447161 0f ba f2 1f     BTR        param_2,0x1f
       140447165 4c 8d 44        LEA        param_3=>local_e0,[RSP + 0x48]
                 24 48
       14044716a 49 8b cc        MOV        param_1,R12
       14044716d e8 d6 de        CALL       FUN_1400b5048                                    undefined FUN_1400b5048()
                 c6 ff
       140447172 85 c0           TEST       EAX,EAX
       140447174 0f 88 a4        JS         LAB_14044781e
                 06 00 00
       14044717a 48 8b 7c        MOV        RDI,qword ptr [RSP + local_e0]
                 24 48

`````

------------------------------------------------------------------

case 40


`````shell
DOUBLE FETCH:   cr3 0xb68ca000, syscall 0x143c
   user_address 0x195c7ad2020, user_data 0x2c000000, modrm 0x49, pc 0xfffff960ccb09af1
   user_address 0x195c7ad2020, user_data 0x2c000000, modrm 0x49, pc 0xfffff960ccb09af1
`````


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c0109ad8(undefined param_1, undefined par
             undefined         AL:1           <RETURN>
             undefined         CL:1           param_1
             undefined         DL:1           param_2
             undefined         R8B:1          param_3
             undefined         R9B:1          param_4
             undefined8        Stack[0x28]:8  param_5                                 XREF[1]:     1c0109afc(R)  
                             FUN_1c0109ad8                                   XREF[1]:     FUN_1c0109d30:1c0109d80(c)  
       1c0109ad8 4d 8b d1        MOV        R10,param_4
       1c0109adb 41 83 f8 04     CMP        param_3,0x4
       1c0109adf 72 56           JC         LAB_1c0109b37
       1c0109ae1 0f b7 01        MOVZX      EAX,word ptr [param_1]
       1c0109ae4 66 c1 c8 08     ROR        AX,0x8
       1c0109ae8 66 85 c0        TEST       AX,AX
       1c0109aeb 75 4a           JNZ        LAB_1c0109b37
       1c0109aed 0f b7 41 02     MOVZX      EAX,word ptr [param_1 + 0x2]
   --> 1c0109af1 8b 49 04        MOV        param_1,dword ptr [param_1 + 0x4]
       1c0109af4 66 c1 c8 08     ROR        AX,0x8
       1c0109af8 44 0f b7 c8     MOVZX      param_4,AX
       1c0109afc 48 8b 44        MOV        RAX,qword ptr [RSP + param_5]
                 24 28
       1c0109b01 0f c9           BSWAP      param_1
       1c0109b03 45 89 0a        MOV        dword ptr [R10],param_4
       1c0109b06 89 08           MOV        dword ptr [RAX],param_1
       1c0109b08 8b 82 28        MOV        EAX,dword ptr [param_2 + 0x228]
                 02 00 00
       1c0109b0e 83 c0 02        ADD        EAX,0x2
       1c0109b11 3b c8           CMP        param_1,EAX
       1c0109b13 72 22           JC         LAB_1c0109b37
       1c0109b15 f6 c1 03        TEST       param_1,0x3
       1c0109b18 75 1d           JNZ        LAB_1c0109b37
       1c0109b1a 85 c9           TEST       param_1,param_1
       1c0109b1c 74 19           JZ         LAB_1c0109b37
       1c0109b1e 33 d2           XOR        param_2,param_2
       1c0109b20 41 8b c0        MOV        EAX,param_3
       1c0109b23 48 83 e8 04     SUB        RAX,0x4
       1c0109b27 8b c9           MOV        param_1,param_1
       1c0109b29 48 f7 f1        DIV        param_1
       1c0109b2c 4c 3b c8        CMP        param_4,RAX
       1c0109b2f 77 06           JA         LAB_1c0109b37
       1c0109b31 b8 01 00        MOV        EAX,0x1
                 00 00

`````

-----------------------------------------------------------------------

case 41

`````shell
DOUBLE FETCH:   cr3 0xb68ca000, syscall 0x143c
   user_address 0x195c7ad02db, user_data 0x1, modrm 0x1, pc 0xfffff960ccb0adb5
   user_address 0x195c7ad02db, user_data 0x1, modrm 0x1, pc 0xfffff960ccb0adb5
`````

`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c010ad30(undefined param_1, undefined par
             undefined         AL:1           <RETURN>
             undefined         CL:1           param_1
             undefined         DL:1           param_2
             undefined         R8B:1          param_3
             undefined         R9B:1          param_4
             undefined8        Stack[0x28]:8  param_5                                 XREF[2]:     1c010ae65(R), 
                                                                                                   1c010aed3(R)  
             undefined8        Stack[0x30]:8  param_6                                 XREF[1]:     1c010ad45(R)  
             undefined8        Stack[0x20]:8  local_res20                             XREF[2]:     1c010ad3f(W), 
                                                                                                   1c010aec3(R)  
             undefined8        Stack[0x18]:8  local_res18                             XREF[2]:     1c010ad3b(W), 
                                                                                                   1c010aebe(R)  
             undefined8        Stack[0x10]:8  local_res10                             XREF[2]:     1c010ad37(W), 
                                                                                                   1c010aeb9(R)  
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1c010ad33(W), 
                                                                                                   1c010aeb4(R)  
                             FUN_1c010ad30                                   XREF[3]:     FUN_1c010aa44:1c010ab05(c), 
                                                                                          FUN_1c010aa44:1c010ac28(c), 
                                                                                          1c033a3d8(*)  
       1c010ad30 48 8b c4        MOV        RAX,RSP
       1c010ad33 48 89 58 08     MOV        qword ptr [RAX + local_res8],RBX
       1c010ad37 48 89 68 10     MOV        qword ptr [RAX + local_res10],RBP
       1c010ad3b 48 89 70 18     MOV        qword ptr [RAX + local_res18],RSI
       1c010ad3f 48 89 78 20     MOV        qword ptr [RAX + local_res20],RDI
       1c010ad43 41 56           PUSH       R14
       1c010ad45 48 8b 44        MOV        RAX,qword ptr [RSP + param_6]
                 24 38
       1c010ad4a 45 8b f0        MOV        R14D,param_3
       1c010ad4d 8b ea           MOV        EBP,param_2
       1c010ad4f 4c 8b d9        MOV        R11,param_1
       1c010ad52 4c 8b 90        MOV        R10,qword ptr [RAX + 0xc0]
                 c0 00 00 00
       1c010ad59 41 8b 42 54     MOV        EAX,dword ptr [R10 + 0x54]
       1c010ad5d 83 f8 06        CMP        EAX,0x6
       1c010ad60 0f 82 b7        JC         LAB_1c010af1d
                 01 00 00
       1c010ad66 0f b7 49 04     MOVZX      param_1,word ptr [param_1 + 0x4]
       1c010ad6a 8b f0           MOV        ESI,EAX
       1c010ad6c 66 c1 c9 08     ROR        param_1,0x8
       1c010ad70 0f b7 f9        MOVZX      EDI,param_1
       1c010ad73 48 8d 47 01     LEA        RAX,[RDI + 0x1]
       1c010ad77 48 8d 04 40     LEA        RAX,[RAX + RAX*0x2]
       1c010ad7b 48 03 c0        ADD        RAX,RAX
       1c010ad7e 48 3b c6        CMP        RAX,RSI
       1c010ad81 0f 87 96        JA         LAB_1c010af1d
                 01 00 00
       1c010ad87 41 8d 81        LEA        EAX,[param_4 + 0xfe]
                 fe 00 00 00
       1c010ad8e 3d fc 01        CMP        EAX,0x1fc
                 00 00
       1c010ad93 0f 87 84        JA         LAB_1c010af1d
                 01 00 00
       1c010ad99 33 d2           XOR        param_2,param_2
       1c010ad9b 44 0f b7 d1     MOVZX      R10D,param_1
       1c010ad9f 44 8b c2        MOV        param_3,param_2
       1c010ada2 45 85 d2        TEST       R10D,R10D
       1c010ada5 74 39           JZ         LAB_1c010ade0
       1c010ada7 49 8d 4b 07     LEA        param_1,[R11 + 0x7]
                             LAB_1c010adab                                   XREF[1]:     1c010af31(j)  
       1c010adab 80 79 ff 01     CMP        byte ptr [param_1 + -0x1],0x1
       1c010adaf 0f 85 6c        JNZ        LAB_1c010af21
                 01 00 00
   --> 1c010adb5 8a 01           MOV        AL,byte ptr [param_1]
       1c010adb7 84 c0           TEST       AL,AL
       1c010adb9 74 25           JZ         LAB_1c010ade0
       1c010adbb 0f b6 d8        MOVZX      EBX,AL
       1c010adbe 0f b6 41 01     MOVZX      EAX,byte ptr [param_1 + 0x1]
       1c010adc2 0f af c5        IMUL       EAX,EBP
       1c010adc5 41 0f af de     IMUL       EBX,R14D
       1c010adc9 3b d8           CMP        EBX,EAX
       1c010adcb 0f 8c 50        JL         LAB_1c010af21
                 01 00 00
       1c010add1 0f b6 41 02     MOVZX      EAX,byte ptr [param_1 + 0x2]
       1c010add5 0f af c5        IMUL       EAX,EBP
       1c010add8 3b d8           CMP        EBX,EAX
       1c010adda 0f 8f 41        JG         LAB_1c010af21
                 01 00 00

`````


--------------------------------------------------------


case 42


***

need review


`````shell
DOUBLE FETCH:   cr3 0xbc767000, syscall 0x1402
   user_address 0x110454d998, user_data 0x110454da60, modrm 0x40, pc 0xfffff960ccb01337
   user_address 0x110454d998, user_data 0x110454da60, modrm 0x51, pc 0xfffff960cca99635

DOUBLE FETCH:   cr3 0xbc767000, syscall 0x1402
   user_address 0x110454d958, user_data 0x110454da60, modrm 0x40, pc 0xfffff960ccb01416
   user_address 0x110454d958, user_data 0x110454da60, modrm 0x51, pc 0xfffff960cca99635

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
   --1 1c0101337 4c 8b 40 08     MOV        R8,qword ptr [RAX + 0x8]
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
   --2 1c0101416 4c 8b 40 08     MOV        R8,qword ptr [RAX + 0x8]
       1c010141a 4c 89 44        MOV        qword ptr [RSP + local_10],R8
                 24 68
       1c010141f 44 84 c3        TEST       BL,R8B
       1c0101422 75 53           JNZ        LAB_1c0101477
       1c0101424 0f b7 c1        MOVZX      EAX,CX
       1c0101427 4d 8d 48 02     LEA        R9,[R8 + 0x2]
       1c010142b 4c 03 c8        ADD        R9,RAX
       1c010142e 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 c3 01 25 00

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

`````

-------------------------------------------------------------------

case 43

***

need review

`````shell
DOUBLE FETCH:   cr3 0xbc767000, syscall 0x1402
   user_address 0x110454d990, user_data 0x560054, modrm 0x8, pc 0xfffff960ccb0132d
   user_address 0x110454d990, user_data 0x560054, modrm 0x1, pc 0xfffff960cca99628

DOUBLE FETCH:   cr3 0xbc767000, syscall 0x1402
   user_address 0x110454d950, user_data 0x560054, modrm 0x8, pc 0xfffff960ccb0140c
   user_address 0x110454d950, user_data 0x560054, modrm 0x1, pc 0xfffff960cca99628

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
   --1 1c010132d 8b 08           MOV        ECX,dword ptr [RAX]
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
   --2 1c010140c 8b 08           MOV        ECX,dword ptr [RAX]
       1c010140e 89 4c 24 20     MOV        dword ptr [RSP + local_58],ECX
       1c0101412 89 4c 24 60     MOV        dword ptr [RSP + local_18],ECX
       1c0101416 4c 8b 40 08     MOV        R8,qword ptr [RAX + 0x8]
       1c010141a 4c 89 44        MOV        qword ptr [RSP + local_10],R8
                 24 68

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
       1c0099647 48 8d 4a 02     LEA        RCX,[RDX + 0x2]
       1c009964b 48 03 c8        ADD        RCX,RAX
       1c009964e 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 a3 7f 2b 00
       1c0099655 4c 8b 08        MOV        R9,qword ptr [RAX]
       1c0099658 49 3b c9        CMP        RCX,R9
       1c009965b 73 17           JNC        LAB_1c0099674
       1c009965d 66 44 3b        CMP        R8W,word ptr [RSP + local_res10+0x2]
                 44 24 5a

`````

--------------------------------------------------------------------

case 44


***

need review

`````shell
DOUBLE FETCH:   cr3 0xbc767000, syscall 0x116b
   user_address 0x195c7ad3061, user_data 0x60, modrm 0x43, pc 0xfffff960cca139a8
   user_address 0x195c7ad3061, user_data 0x60, modrm 0x40, pc 0xfffff960cca13235
`````


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1c0013970()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1c0013970(W), 
                                                                                                   1c0013a39(R)  
                             FUN_1c0013970                                   XREF[3]:     FUN_1c0012e20:1c0012e50(c), 
                                                                                          1c02efdd8(*), 1c0331918(*)  
       1c0013970 48 89 5c        MOV        qword ptr [RSP + local_res8],RBX
                 24 08
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
       1c001324a 49 8b 55 48     MOV        RDX,qword ptr [R13 + 0x48]
       1c001324e 41 b8 01        MOV        R8D,0x1
                 00 00 00
       1c0013254 8b 4a 24        MOV        ECX,dword ptr [RDX + 0x24]
       1c0013257 45 8d 48 01     LEA        R9D,[R8 + 0x1]
       1c001325b 0f b7 42 28     MOVZX      EAX,word ptr [RDX + 0x28]
       1c001325f 41 2b c8        SUB        ECX,R8D
       1c0013262 66 89 43 70     MOV        word ptr [RBX + 0x70],AX
       1c0013266 49 03 c8        ADD        RCX,R8
       1c0013269 48 03 c9        ADD        RCX,RCX
       1c001326c 0f b7 44        MOVZX      EAX,word ptr [RDX + RCX*0x8 + 0x18]
                 ca 18
       1c0013271 0f b7 4c        MOVZX      ECX,word ptr [RDX + RCX*0x8 + 0x1a]
                 ca 1a

`````

------------------------------------------------------------------

case 45


***

need review


0xfffff960cca1305b - 0xfffff960cca12ec5 = 196

1c001305b - 1c0012ec5 = 196


`````shell
DOUBLE FETCH:   cr3 0xbc767000, syscall 0x116b
   user_address 0x195c7ad3055, user_data 0x0, modrm 0x48, pc 0xfffff960cca12ec5
   user_address 0x195c7ad3055, user_data 0x0, modrm 0x46, pc 0xfffff960cca1305b
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
       1c001302a 83 e0 fc        AND        EAX,0xfffffffc
       1c001302d 48 63 c8        MOVSXD     RCX,EAX
       1c0013030 48 03 cb        ADD        RCX,RBX
       1c0013033 89 43 18        MOV        dword ptr [RBX + 0x18],EAX
       1c0013036 41 8b 45 44     MOV        EAX,dword ptr [R13 + 0x44]
       1c001303a 85 c0           TEST       EAX,EAX
       1c001303c 0f 85 7a        JNZ        LAB_1c00134bc
                 04 00 00
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

`````

------------------------------------------------------------------------------

case 46


***


need review



`````shell
DOUBLE FETCH:   cr3 0xbc767000, syscall 0x116b
   user_address 0x195c7ad045f, user_data 0x20, modrm 0x42, pc 0xfffff960cca12217
   user_address 0x195c7ad045f, user_data 0x20, modrm 0x47, pc 0xfffff960cca11e4c

DOUBLE FETCH:   cr3 0xbc767000, syscall 0x116b
   user_address 0x195c7ad0460, user_data 0xff, modrm 0x4a, pc 0xfffff960cca1221b
   user_address 0x195c7ad0460, user_data 0xff, modrm 0x47, pc 0xfffff960cca11e52
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
       1c001224d 41 0f b6        MOVZX      ECX,byte ptr [R10 + 0x57]
                 4a 57

`````


`````shell
       1c0011e36 2b ca           SUB        ECX,EDX
       1c0011e38 41 03 ca        ADD        ECX,R10D
       1c0011e3b f7 e9           IMUL       ECX
       1c0011e3d 48 8d 4b 74     LEA        RCX,[RBX + 0x74]
       1c0011e41 8b c2           MOV        EAX,EDX
       1c0011e43 c1 e8 1f        SHR        EAX,0x1f
       1c0011e46 03 d0           ADD        EDX,EAX
       1c0011e48 66 89 53 6a     MOV        word ptr [RBX + 0x6a],DX
   --1 1c0011e4c 8a 47 5f        MOV        AL,byte ptr [RDI + 0x5f]
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

`````
------------------------------------------------------------------


case 47


***

need review


`````shell
DOUBLE FETCH:   cr3 0xbc767000, syscall 0x116b
   user_address 0x195c7ad0450, user_data 0x0, modrm 0x43, pc 0xfffff960cca12634
   user_address 0x195c7ad0450, user_data 0x0, modrm 0x43, pc 0xfffff960cca12634

DOUBLE FETCH:   cr3 0xbc767000, syscall 0x116b
   user_address 0x195c7ad0450, user_data 0x0, modrm 0x43, pc 0xfffff960cca12634
   user_address 0x195c7ad0450, user_data 0x0, modrm 0x41, pc 0xfffff960cca11aa1

`````

`````shell
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

case 48


***

need review

`````shell
DOUBLE FETCH:   cr3 0xbc767000, syscall 0x116b 
   user_address 0x195c7ad0455, user_data 0xff, modrm 0x4f, pc 0xfffff960cca12543
   user_address 0x195c7ad0455, user_data 0xff, modrm 0x47, pc 0xfffff960cca11c74
`````

`````shell
       1c0012510 48 03 db        ADD        RBX,RBX
       1c0012513 0f 11 44        MOVUPS     xmmword ptr [RAX + RBX*0x8 + 0x28],XMM0
                 d8 28
       1c0012518 f2 0f 11        MOVSD      qword ptr [RAX + RBX*0x8 + 0x38],XMM1
                 4c d8 38
       1c001251e e8 71 f5        CALL       FUN_1c0011a94                                    undefined FUN_1c0011a94()
                 ff ff
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
       1c001254c 49 8b 0e        MOV        param_1,qword ptr [R14]
       1c001254f 48 89 44        MOV        qword ptr [param_1 + RBX*0x8 + 0x48],RAX
                 d9 48
       1c0012554 49 8b 06        MOV        RAX,qword ptr [R14]
       1c0012557 48 8b 54        MOV        param_2,qword ptr [RAX + RBX*0x8 + 0x48]
                 d8 48
       1c001255c 48 85 d2        TEST       param_2,param_2
       1c001255f 0f 84 db        JZ         LAB_1c0159d40
                 77 14 00
       1c0012565 48 83 c2 18     ADD        param_2,0x18
       1c0012569 4d 8b c4        MOV        param_3,R12
       1c001256c 49 8b cf        MOV        param_1,R15

`````

`````shell
       1c0011c31 44 89 41 08     MOV        dword ptr [RCX + 0x8],R8D
       1c0011c35 4c 63 31        MOVSXD     R14,dword ptr [RCX]
       1c0011c38 4c 03 f1        ADD        R14,RCX
       1c0011c3b 4c 3b f1        CMP        R14,RCX
       1c0011c3e 0f 82 5a        JC         LAB_1c001209e
                 04 00 00
       1c0011c44 4c 63 79 04     MOVSXD     R15,dword ptr [RCX + 0x4]
       1c0011c48 4c 03 f9        ADD        R15,RCX
       1c0011c4b 4c 3b f9        CMP        R15,RCX
       1c0011c4e 0f 82 4a        JC         LAB_1c001209e
                 04 00 00
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

`````

---------------------------------------------------------------------------------


case 49


***

strange, access a hardcoded address

need review


`````shell
DOUBLE FETCH:   cr3 0xbe661000, syscall 0x12dd
   user_address 0x7ffe02d0, user_data 0x110, modrm 0x4, pc 0xfffff960ccdfcfb5
   user_address 0x7ffe02d0, user_data 0x110, modrm 0x4, pc 0xfffff960ccdfcfb5
`````


`````shell
                             LAB_1c006cf9c                                   XREF[1]:     1c00a41f3(j)  
       1c006cf9c 41 38 5a 55     CMP        byte ptr [R10 + 0x55],BL
       1c006cfa0 0f 84 62        JZ         LAB_1c00a4208
                 72 03 00
       1c006cfa6 41 c6 42        MOV        byte ptr [R10 + 0x54],0x1
                 54 01
                             LAB_1c006cfab                                   XREF[2]:     1c00a4203(j), 1c00a420c(j)  
       1c006cfab 41 38 5a 54     CMP        byte ptr [R10 + 0x54],BL
       1c006cfaf 0f 84 5c        JZ         LAB_1c00a4211
                 72 03 00
   --> 1c006cfb5 8b 04 25        MOV        EAX,dword ptr [DAT_7ffe02d0]
                 d0 02 fe 7f
       1c006cfbc 25 10 01        AND        EAX,0x110
                 00 00
       1c006cfc1 83 f8 10        CMP        EAX,0x10
       1c006cfc4 0f 94 c1        SETZ       CL
       1c006cfc7 f6 c2 04        TEST       DL,0x4
       1c006cfca 0f 94 c0        SETZ       AL
       1c006cfcd 22 c8           AND        CL,AL
       1c006cfcf 41 0f b6        MOVZX      EAX,byte ptr [R10 + 0x54]
                 42 54
       1c006cfd4 0f 45 c3        CMOVNZ     EAX,EBX
       1c006cfd7 41 88 42 54     MOV        byte ptr [R10 + 0x54],AL
       1c006cfdb 3a c3           CMP        AL,BL
       1c006cfdd 0f 84 2e        JZ         LAB_1c00a4211
                 72 03 00

`````

---------------------------------------------------------------

case 50

`````shell
DOUBLE FETCH:   cr3 0xbf061000, syscall 0x13ce
   user_address 0x125f869720, user_data 0x0, modrm 0x80, pc 0xfffff8032e905a2b
   user_address 0x125f869720, user_data 0x0, modrm 0x80, pc 0xfffff8032e905a2b
`````

`````shell
                             LAB_1404f9a07                                   XREF[1]:     1404f99f3(j)  
       1404f9a07 e8 18 35        CALL       PsGetCurrentThreadTeb                            undefined PsGetCurrentThreadTeb()
                 be ff
       1404f9a0c 48 85 c0        TEST       RAX,RAX
       1404f9a0f 74 31           JZ         LAB_1404f9a42
       1404f9a11 65 48 8b        MOV        RCX,qword ptr GS:[0x188]
                 0c 25 88 
                 01 00 00
       1404f9a1a 48 8b 89        MOV        RCX,qword ptr [RCX + 0x220]
                 20 02 00 00
       1404f9a21 48 83 b9        CMP        qword ptr [RCX + 0x428],0x0
                 28 04 00 
                 00 00
       1404f9a29 75 08           JNZ        LAB_1404f9a33
   --> 1404f9a2b 8b 80 20        MOV        EAX,dword ptr [RAX + 0x1720]
                 17 00 00
       1404f9a31 eb 06           JMP        LAB_1404f9a39
                             LAB_1404f9a33                                   XREF[1]:     1404f9a29(j)  
       1404f9a33 8b 80 60        MOV        EAX,dword ptr [RAX + 0x2f60]
                 2f 00 00
                             LAB_1404f9a39                                   XREF[1]:     1404f9a31(j)  
       1404f9a39 89 84 24        MOV        dword ptr [RSP + local_38],EAX
                 80 00 00 00
       1404f9a40 eb 00           JMP        LAB_1404f9a42

`````
------------------------------------------------------------
