---
title: double fetch, case 5, case 6 .. case 14
published: true
---

case 5


`````shell
DOUBLE FETCH:   cr3 0xb7261000, syscall 0x88
   eip 0xfffff80179c9f8e1, user_address 0x40f3efdbe8, user_data 0x1000, modrm 0x1, pc 0xfffff80179c9f99e
   eip 0xfffff80179c9f8e1, user_address 0x40f3efdbe8, user_data 0x1000, modrm 0x1, pc 0xfffff80179c9f9bc
`````


`````shell
                             LAB_14041599e                                   XREF[1]:     140415afd(j)  
   --> 14041599e 48 8b 01        MOV        RAX,qword ptr [param_1]
       1404159a1 48 89 84        MOV        qword ptr [RSP + local_c8],RAX
                 24 90 00 
                 00 00
       1404159a9 48 8b ce        MOV        param_1,RSI
       1404159ac 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 4d 98 f6 ff
       1404159b3 48 3b f0        CMP        RSI,RAX
       1404159b6 0f 83 46        JNC        LAB_140415b02
                 01 00 00
                             LAB_1404159bc                                   XREF[1]:     140415b05(j)  
   --> 1404159bc 48 8b 01        MOV        RAX,qword ptr [param_1]
       1404159bf 48 89 01        MOV        qword ptr [param_1],RAX

`````

没啥意思。

---------------------------------------------


case 6


`````shell
DOUBLE FETCH:   cr3 0x10d414000, syscall 0x0
   eip 0xfffff801798e4d41, user_address 0x4999e7ef80, user_data 0x100, modrm 0x39, pc 0xfffff801798e4e14
   eip 0xfffff801798e4d41, user_address 0x4999e7ef80, user_data 0x100, modrm 0x1, pc 0xfffff801798e4e30
`````


`````shell
                             LAB_14005ae14                                   XREF[1]:     14005af22(j)  
   --> 14005ae14 8b 39           MOV        EDI,dword ptr [param_1]
       14005ae16 89 bc 24        MOV        dword ptr [RSP + local_140],EDI
                 f8 00 00 00
       14005ae1d 49 8b cd        MOV        param_1,R13
       14005ae20 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 d9 43 32 00
       14005ae27 4c 3b e8        CMP        R13,RAX
       14005ae2a 0f 83 f7        JNC        LAB_14005af27
                 00 00 00
                             LAB_14005ae30                                   XREF[1]:     14005af2a(j)  
   --> 14005ae30 8b 01           MOV        EAX,dword ptr [param_1]
       14005ae32 89 01           MOV        dword ptr [param_1],EAX
       14005ae34 48 8b d7        MOV        param_2,RDI
       14005ae37 41 b8 04        MOV        param_3,0x4
                 00 00 00

`````

------------------------------------------------------


case 7


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x75
   eip 0xfffff80179d33354, user_address 0x3eb00ff190, user_data 0x0, modrm 0x1a, pc 0xfffff80179d3336f
   eip 0xfffff80179d33354, user_address 0x3eb00ff190, user_data 0x0, modrm 0x1, pc 0xfffff80179d333f1

`````


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1404a9354()
             undefined         AL:1           <RETURN>
                             FUN_1404a9354                                   XREF[3]:     1402a8f6c(*), 14035e12c(*), 
                                                                                          FUN_1404a8d20:1404a8dc4(c)  
       1404a9354 40 53           PUSH       RBX
       1404a9356 48 83 ec 20     SUB        RSP,0x20
       1404a935a 48 3b 15        CMP        RDX,qword ptr [MmUserProbeAddress]               = ??
                 9f 5e ed ff
       1404a9361 4c 8b ca        MOV        R9,RDX
       1404a9364 45 8a d0        MOV        R10B,R8B
       1404a9367 48 0f 43        CMOVNC     RDX,qword ptr [MmUserProbeAddress]               = ??
                 15 91 5e 
                 ed ff
   --> 1404a936f 8b 1a           MOV        EBX,dword ptr [RDX]
       1404a9371 81 e1 00        AND        ECX,0xc0000000
                 00 00 c0
       1404a9377 ba 00 00        MOV        EDX,0x80000000
                 00 80
       1404a937c 3b ca           CMP        ECX,EDX
       1404a937e 0f 84 85        JZ         LAB_1404a9409
                 00 00 00
       1404a9384 41 b8 08        MOV        R8D,0x8
                 00 00 00
       1404a938a 8b c3           MOV        EAX,EBX
       1404a938c 23 c2           AND        EAX,EDX
       1404a938e 41 8b c8        MOV        ECX,R8D
       1404a9391 41 8d 50 18     LEA        EDX,[R8 + 0x18]
       1404a9395 0f 45 ca        CMOVNZ     ECX,EDX
       1404a9398 0f ba e3 1e     BT         EBX,0x1e
       1404a939c 0f 82 38        JC         LAB_1405cb1da
                 1e 12 00
                             LAB_1404a93a2                                   XREF[1]:     1405cb1dc(j)  
       1404a93a2 0f ba e3 1d     BT         EBX,0x1d
       1404a93a6 0f 82 35        JC         LAB_1405cb1e1
                 1e 12 00
                             LAB_1404a93ac                                   XREF[1]:     1405cb1e3(j)  
       1404a93ac 0f ba e3 1c     BT         EBX,0x1c
       1404a93b0 72 68           JC         LAB_1404a941a
                             LAB_1404a93b2                                   XREF[1]:     1404a941d(j)  
       1404a93b2 0f ba e3 1b     BT         EBX,0x1b
       1404a93b6 72 67           JC         LAB_1404a941f
                             LAB_1404a93b8                                   XREF[1]:     1404a9422(j)  
       1404a93b8 0f ba e3 1a     BT         EBX,0x1a
       1404a93bc 72 66           JC         LAB_1404a9424
                             LAB_1404a93be                                   XREF[2]:     1404a9418(j), 1404a9427(j)  
       1404a93be 45 84 d2        TEST       R10B,R10B
       1404a93c1 0f 84 21        JZ         LAB_1405cb1e8
                 1e 12 00
                             LAB_1404a93c7                                   XREF[1]:     1405cb1ee(j)  
       1404a93c7 8b d1           MOV        EDX,ECX
       1404a93c9 48 8d 42 ff     LEA        RAX,[RDX + -0x1]
       1404a93cd 48 3d fe        CMP        RAX,0xffe
                 0f 00 00
       1404a93d3 0f 87 80        JA         LAB_1405cb259
                 1e 12 00
       1404a93d9 41 8d 48 ff     LEA        ECX,[R8 + -0x1]
       1404a93dd 49 85 c9        TEST       R9,RCX
       1404a93e0 75 47           JNZ        LAB_1404a9429
       1404a93e2 4c 3b 0d        CMP        R9,qword ptr [MmUserProbeAddress]                = ??
                 17 5e ed ff
       1404a93e9 4c 0f 43        CMOVNC     R9,qword ptr [MmUserProbeAddress]                = ??
                 0d 0f 5e 
                 ed ff
   --> 1404a93f1 41 8a 01        MOV        AL,byte ptr [R9]
       1404a93f4 41 88 01        MOV        byte ptr [R9],AL
       1404a93f7 41 8a 44        MOV        AL,byte ptr [R9 + RDX*0x1 + -0x1]
                 11 ff
       1404a93fc 41 88 44        MOV        byte ptr [R9 + RDX*0x1 + -0x1],AL
                 11 ff

`````


--------------------------------------

case 8


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x18
   eip 0xfffff80179c5a904, user_address 0x3eb00ffa20, user_data 0x2000, modrm 0x1, pc 0xfffff80179c5a941
   eip 0xfffff80179c5a904, user_address 0x3eb00ffa20, user_data 0x2000, modrm 0x31, pc 0xfffff80179c5a966

`````


`````shell
                             LAB_1403d0941                                   XREF[1]:     1403d0951(j)  
   --> 1403d0941 48 8b 01        MOV        RAX,qword ptr [param_1]
       1403d0944 48 89 01        MOV        qword ptr [param_1],RAX
       1403d0947 eb 0a           JMP        LAB_1403d0953
                             LAB_1403d0949                                   XREF[1]:     1403d092a(j)  
       1403d0949 48 8b c8        MOV        param_1,RAX
       1403d094c eb de           JMP        LAB_1403d092c
                             LAB_1403d094e                                   XREF[1]:     1403d093f(j)  
       1403d094e 48 8b c8        MOV        param_1,RAX
       1403d0951 eb ee           JMP        LAB_1403d0941
                             LAB_1403d0953                                   XREF[2]:     1403d091b(j), 1403d0947(j)  
       1403d0953 4d 8b 30        MOV        R14,qword ptr [param_3]
       1403d0956 4c 89 b4        MOV        qword ptr [RSP + local_120],R14
                 24 a8 00 
                 00 00
       1403d095e 4c 89 b4        MOV        qword ptr [RSP + local_78],R14
                 24 50 01 
                 00 00
   --> 1403d0966 49 8b 31        MOV        RSI,qword ptr [param_4]
       1403d0969 48 89 b4        MOV        qword ptr [RSP + local_c0],RSI
                 24 08 01 
                 00 00
       1403d0971 eb 05           JMP        LAB_1403d0978

`````



------------------------------------

case 9


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x18
   eip 0xfffff80179c5a904, user_address 0x3eb00ff9e0, user_data 0x13eea002000, modrm 0x1, pc 0xfffff80179c5a92c
   eip 0xfffff80179c5a904, user_address 0x3eb00ff9e0, user_data 0x13eea002000, modrm 0x30, pc 0xfffff80179c5a953
`````


`````shell
                             LAB_1403d092c                                   XREF[1]:     1403d094c(j)  
   --> 1403d092c 48 8b 01        MOV        RAX,qword ptr [param_1]
       1403d092f 48 89 01        MOV        qword ptr [param_1],RAX
       1403d0932 49 8b c9        MOV        param_1,param_4
       1403d0935 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 c4 e8 fa ff
       1403d093c 4c 3b c8        CMP        param_4,RAX
       1403d093f 73 0d           JNC        LAB_1403d094e
                             LAB_1403d0941                                   XREF[1]:     1403d0951(j)  
       1403d0941 48 8b 01        MOV        RAX,qword ptr [param_1]
       1403d0944 48 89 01        MOV        qword ptr [param_1],RAX
       1403d0947 eb 0a           JMP        LAB_1403d0953
                             LAB_1403d0949                                   XREF[1]:     1403d092a(j)  
       1403d0949 48 8b c8        MOV        param_1,RAX
       1403d094c eb de           JMP        LAB_1403d092c
                             LAB_1403d094e                                   XREF[1]:     1403d093f(j)  
       1403d094e 48 8b c8        MOV        param_1,RAX
       1403d0951 eb ee           JMP        LAB_1403d0941
                             LAB_1403d0953                                   XREF[2]:     1403d091b(j), 1403d0947(j)  
   --> 1403d0953 4d 8b 30        MOV        R14,qword ptr [param_3]
       1403d0956 4c 89 b4        MOV        qword ptr [RSP + local_120],R14
                 24 a8 00 
                 00 00
       1403d095e 4c 89 b4        MOV        qword ptr [RSP + local_78],R14
                 24 50 01 
                 00 00
       1403d0966 49 8b 31        MOV        RSI,qword ptr [param_4]
       1403d0969 48 89 b4        MOV        qword ptr [RSP + local_c0],RSI
                 24 08 01 
                 00 00
       1403d0971 eb 05           JMP        LAB_1403d0978

`````
------------------------------------------------



case 10


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x1e
   eip 0xfffff80179cbddc0, user_address 0x3eb00ff978, user_data 0x20000, modrm 0x1, pc 0xfffff80179cbde6c
   eip 0xfffff80179cbddc0, user_address 0x3eb00ff978, user_data 0x20000, modrm 0x20, pc 0xfffff80179cbde89

`````

`````shell
                             LAB_140433e57                                   XREF[1]:     140433e77(j)  
       140433e57 48 8b 01        MOV        RAX,qword ptr [RCX]
       140433e5a 48 89 01        MOV        qword ptr [RCX],RAX
       140433e5d 49 8b c8        MOV        RCX,R8
       140433e60 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 99 b3 f4 ff
       140433e67 4c 3b c0        CMP        R8,RAX
       140433e6a 73 0d           JNC        LAB_140433e79
                             LAB_140433e6c                                   XREF[1]:     140433e7c(j)  
   --> 140433e6c 48 8b 01        MOV        RAX,qword ptr [RCX]
       140433e6f 48 89 01        MOV        qword ptr [RCX],RAX
       140433e72 eb 0a           JMP        LAB_140433e7e
                             LAB_140433e74                                   XREF[1]:     140433e55(j)  
       140433e74 48 8b c8        MOV        RCX,RAX
       140433e77 eb de           JMP        LAB_140433e57
                             LAB_140433e79                                   XREF[1]:     140433e6a(j)  
       140433e79 48 8b c8        MOV        RCX,RAX
       140433e7c eb ee           JMP        LAB_140433e6c
                             LAB_140433e7e                                   XREF[2]:     140433e46(j), 140433e72(j)  
       140433e7e 48 8b 32        MOV        RSI,qword ptr [RDX]
       140433e81 48 89 b4        MOV        qword ptr [RSP + local_88],RSI
                 24 90 00 
                 00 00
   --> 140433e89 4d 8b 20        MOV        R12,qword ptr [R8]
       140433e8c 4c 89 a4        MOV        qword ptr [RSP + local_80],R12
                 24 98 00 
                 00 00

`````

---------------------------------------------------------


case 11


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12
   eip 0xfffff80179c9d01b, user_address 0x7fff928b1b80, user_data 0x7fff928bd660, modrm 0x49, pc 0xfffff80179c9d0dc
   eip 0xfffff80179c73515, user_address 0x7fff928b1b80, user_data 0x7fff928bd660, modrm 0x4a, pc 0xfffff80179c732f7
DIFF EIP
`````


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1403e9290()
             undefined         AL:1           <RETURN>
             undefined1        Stack[0x18]:1  local_res18                             XREF[1]:     1403e92d5(W)  
             undefined8        Stack[0x10]:8  local_res10                             XREF[2]:     1403e9297(W), 
                                                                                                   1403e949c(R)  
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1403e9293(W), 
                                                                                                   1403e9498(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[1]:     1403e9493(*)  
             undefined1[16]    Stack[-0x38]   local_38                                XREF[3,2]:   1403e92f3(W), 
                                                                                                   1403e932d(R), 
                                                                                                   1403e9441(W), 
                                                                                                   1403e92fb(W), 
                                                                                                   1403e93d7(R)  
             undefined8        Stack[-0x48]:8 local_48                                XREF[3]:     1403e92b9(W), 
                                                                                                   1403e93c6(W), 
                                                                                                   1403e9460(W)  
             undefined4        Stack[-0x4c]:4 local_4c                                XREF[2]:     1403e933e(W), 
                                                                                                   1403e93b5(R)  
             undefined4        Stack[-0x50]:4 local_50                                XREF[2]:     1403e9369(W), 
                                                                                                   1403e9382(W)  
             undefined4        Stack[-0x54]:4 local_54                                XREF[4]:     1403e92b5(W), 
                                                                                                   1403e9465(W), 
                                                                                                   1403e946f(W), 
                                                                                                   1403e948f(R)  
                             FUN_1403e9290                                   XREF[3]:     1403566d4(*), 
                                                                                          FUN_1403e9030:1403e91f1(c), 
                                                                                          ObReferenceObjectByName:14041c9a
       1403e9290 4c 8b dc        MOV        R11,RSP
       1403e9293 49 89 5b 08     MOV        qword ptr [R11 + local_res8],RBX
       1403e9297 49 89 73 10     MOV        qword ptr [R11 + local_res10],RSI
       1403e929b 57              PUSH       RDI
       1403e929c 41 54           PUSH       R12
       1403e929e 41 55           PUSH       R13
       1403e92a0 41 56           PUSH       R14
       1403e92a2 41 57           PUSH       R15
       1403e92a4 48 83 ec 50     SUB        RSP,0x50
       1403e92a8 4d 8b f8        MOV        R15,R8
       1403e92ab 45 33 e4        XOR        R12D,R12D
       1403e92ae 4d 89 60 08     MOV        qword ptr [R8 + 0x8],R12
       1403e92b2 45 89 20        MOV        dword ptr [R8],R12D
       1403e92b5 45 89 63 ac     MOV        dword ptr [R11 + local_54],R12D
       1403e92b9 4d 89 63 b8     MOV        qword ptr [R11 + local_48],R12
       1403e92bd 84 c9           TEST       CL,CL
       1403e92bf 0f 84 79        JZ         LAB_1403e943e
                 01 00 00
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
       1403e92f1 8b 02           MOV        EAX,dword ptr [RDX]
       1403e92f3 89 44 24 40     MOV        dword ptr [RSP + local_38[0]],EAX
   --> 1403e92f7 48 8b 4a 08     MOV        RCX,qword ptr [RDX + 0x8]
       1403e92fb 48 89 4c        MOV        qword ptr [RSP + local_38[8]],RCX
                 24 48
       1403e9300 66 85 c0        TEST       AX,AX
       1403e9303 74 28           JZ         LAB_1403e932d
       1403e9305 f6 c1 01        TEST       CL,0x1
       1403e9308 0f 85 45        JNZ        LAB_1403e9453
                 01 00 00

`````



`````shell
       1404130bb 48 3b f8        CMP        RDI,RAX
       1404130be 73 74           JNC        LAB_140413134
                             LAB_1404130c0                                   XREF[1]:     140413137(j)  
       1404130c0 0f b6 01        MOVZX      EAX,byte ptr [param_1]
       1404130c3 48 8b 4f 10     MOV        param_1,qword ptr [RDI + 0x10]
       1404130c7 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 32 c1 f6 ff
       1404130ce 48 3b c8        CMP        param_1,RAX
       1404130d1 73 66           JNC        LAB_140413139
                             LAB_1404130d3                                   XREF[1]:     14041313c(j)  
       1404130d3 8b 01           MOV        EAX,dword ptr [param_1]
       1404130d5 89 84 24        MOV        dword ptr [RSP + local_f8[0]],EAX
                 b0 00 00 00
   --> 1404130dc 48 8b 49 08     MOV        param_1,qword ptr [param_1 + 0x8]
       1404130e0 48 89 8c        MOV        qword ptr [RSP + local_f8[8]],param_1
                 24 b8 00 
                 00 00
       1404130e8 0f 28 84        MOVAPS     XMM0,xmmword ptr [RSP + local_f8[0]]
                 24 b0 00 
                 00 00
       1404130f0 66 0f 7f        MOVDQA     xmmword ptr [RSP + local_158[0]],XMM0
                 44 24 50

`````

--------------------------------------------------------

case 12

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12
   eip 0xfffff80179c9d01b, user_address 0x3eb00ff828, user_data 0x0, modrm 0x47, pc 0xfffff80179c9d146
   eip 0xfffff80179c73515, user_address 0x3eb00ff828, user_data 0x0, modrm 0x40, pc 0xfffff80179c730df
DIFF EIP
`````



`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1403e9030(undefined param_1, undefined par
             undefined         AL:1           <RETURN>
             undefined         CL:1           param_1
             undefined         DL:1           param_2
             undefined         R8B:1          param_3
             undefined         R9B:1          param_4
             undefined8        Stack[0x28]:8  param_5                                 XREF[1]:     1403e905f(R)  
             undefined4        Stack[0x30]:4  param_6                                 XREF[1]:     1403e91df(R)  
             undefined1        Stack[0x18]:1  local_res18                             XREF[1]:     1403e90aa(W)  
             undefined8        Stack[0x10]:8  local_res10                             XREF[2]:     1403e9035(W), 
                                                                                                   1403e920c(R)  
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1403e9030(W), 
                                                                                                   1403e9208(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[1]:     1403e9203(*)  
             undefined8        Stack[-0x40]:8 local_40                                XREF[2]:     1403e9115(W), 
                                                                                                   1403e9166(R)  
             undefined8        Stack[-0x48]:8 local_48                                XREF[3]:     1403e904d(W), 
                                                                                                   1403e910c(W), 
                                                                                                   1403e916b(R)  
             undefined4        Stack[-0x50]:4 local_50                                XREF[2]:     1403e90eb(W), 
                                                                                                   1403e90f7(W)  
             undefined8        Stack[-0x58]:8 local_58                                XREF[3]:     1403e911e(W), 
                                                                                                   1403e9149(R), 
                                                                                                   1403e9161(R)  
             undefined4        Stack[-0x60]:4 local_60                                XREF[2]:     1403e9272(*), 
                                                                                                   1403e9280(*)  
             undefined4        Stack[-0x64]:4 local_64                                XREF[3]:     1403e908f(W), 
                                                                                                   1403e9196(W), 
                                                                                                   1403e91a6(W)  
             undefined1        Stack[-0x67]:1 local_67                                XREF[1]:     1403e9141(W)  
             undefined8        Stack[-0x78]:8 local_78                                XREF[1]:     1403e9250(W)  
                             FUN_1403e9030                                   XREF[7]:     140268ee0(*), 1403566c8(*), 
                                                                                          FUN_1403de470:1403de5e5(c), 
                                                                                          FUN_1403e59d0:1403e5a43(c), 
                                                                                          ObOpenObjectByNameEx:1403e955b(c
                                                                                          FUN_1403f3780:1403f3825(c), 
                                                                                          FUN_1404a9ab0:1404a9b42(c)  
       1403e9030 48 89 5c        MOV        qword ptr [RSP + local_res8],RBX
                 24 08
       1403e9035 48 89 74        MOV        qword ptr [RSP + local_res10],RSI
                 24 10
       1403e903a 57              PUSH       RDI
       1403e903b 41 54           PUSH       R12
       1403e903d 41 55           PUSH       R13
       1403e903f 41 56           PUSH       R14
       1403e9041 41 57           PUSH       R15
       1403e9043 48 83 ec 70     SUB        RSP,0x70
       1403e9047 49 8b f9        MOV        RDI,param_4
       1403e904a 0f b6 f1        MOVZX      ESI,param_1
       1403e904d 48 c7 44        MOV        qword ptr [RSP + local_48],0x0
                 24 50 00 
                 00 00 00
       1403e9056 33 c0           XOR        EAX,EAX
       1403e9058 49 89 01        MOV        qword ptr [param_4],RAX
       1403e905b 49 89 41 08     MOV        qword ptr [param_4 + 0x8],RAX
       1403e905f 48 8b 9c        MOV        RBX,qword ptr [RSP + param_5]
                 24 c0 00 
                 00 00
       1403e9067 48 89 03        MOV        qword ptr [RBX],RAX
       1403e906a 48 89 43 08     MOV        qword ptr [RBX + 0x8],RAX
       1403e906e 48 89 43 10     MOV        qword ptr [RBX + 0x10],RAX
       1403e9072 48 89 43 18     MOV        qword ptr [RBX + 0x18],RAX
       1403e9076 48 89 43 20     MOV        qword ptr [RBX + 0x20],RAX
       1403e907a 48 89 43 28     MOV        qword ptr [RBX + 0x28],RAX
       1403e907e 48 89 43 30     MOV        qword ptr [RBX + 0x30],RAX
       1403e9082 48 89 43 38     MOV        qword ptr [RBX + 0x38],RAX
       1403e9086 4d 85 c0        TEST       param_3,param_3
       1403e9089 0f 84 74        JZ         LAB_1403e9203
                 01 00 00
       1403e908f 89 44 24 34     MOV        dword ptr [RSP + local_64],EAX
       1403e9093 88 4b 10        MOV        byte ptr [RBX + 0x10],param_1
       1403e9096 84 c9           TEST       param_1,param_1
       1403e9098 74 3b           JZ         LAB_1403e90d5
       1403e909a 65 48 8b        MOV        RAX,qword ptr GS:[0x188]
                 04 25 88 
                 01 00 00
       1403e90a3 0f b6 88        MOVZX      param_1,byte ptr [RAX + 0x232]
                 32 02 00 00
       1403e90aa 88 8c 24        MOV        byte ptr [RSP + local_res18],param_1
                 b0 00 00 00
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
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_140412f50(undefined param_1, undefined par
             undefined         AL:1           <RETURN>
             undefined         CL:1           param_1
             undefined         DL:1           param_2
             undefined         R8B:1          param_3
             undefined         R9B:1          param_4
             undefined8        Stack[0x28]:8  param_5                                 XREF[1]:     140412f96(R)  
             undefined8        Stack[-0x48]:8 local_48                                XREF[2]:     140412f6d(W), 
                                                                                                   140413296(R)  
             undefined4        Stack[-0x4c]:4 local_4c                                XREF[1]:     140412fff(W)  
             undefined8        Stack[-0x54]:8 local_54                                XREF[1]:     140412ff7(W)  
             undefined4        Stack[-0x58]:4 local_58                                XREF[4]:     140412fed(W), 
                                                                                                   14057854f(*), 
                                                                                                   140578595(*), 
                                                                                                   140578660(*)  
             undefined8        Stack[-0x98]:8 local_98                                XREF[1]:     1404131a4(W)  
             undefined4        Stack[-0xcc]:4 local_cc                                XREF[1]:     140413023(W)  
             undefined4        Stack[-0xd0]:4 local_d0                                XREF[1]:     1404131ac(W)  
             undefined1        Stack[-0xe4]:1 local_e4                                XREF[1]:     140412fd7(*)  
             undefined4        Stack[-0xe8]:4 local_e8                                XREF[2]:     140412fc7(W), 
                                                                                                   1404131d2(*)  
             undefined1[16]    Stack[-0xf8]   local_f8                                XREF[2,1]:   1404130d5(W), 
                                                                                                   1404130e8(R), 
                                                                                                   1404130e0(W)  
             undefined8        Stack[-0x100   local_100                               XREF[1]:     140412f81(W)  
             undefined8        Stack[-0x108   local_108                               XREF[2]:     1405785f5(*), 
                                                                                                   140578616(R)  
             undefined8        Stack[-0x110   local_110                               XREF[1]:     140412f89(W)  
             undefined8        Stack[-0x120   local_120                               XREF[2]:     140412f9e(W), 
                                                                                                   14041319c(R)  
             undefined8        Stack[-0x128   local_128                               XREF[3]:     140413006(W), 
                                                                                                   140578622(W), 
                                                                                                   14057864d(R)  
             undefined4        Stack[-0x130   local_130                               XREF[1]:     140413031(W)  
             undefined8        Stack[-0x138   local_138                               XREF[3]:     140412fe8(W), 
                                                                                                   14041314a(W), 
                                                                                                   140578604(R)  
             undefined8        Stack[-0x140   local_140                               XREF[3]:     140412fac(W), 
                                                                                                   1404131c3(*), 
                                                                                                   140413216(R)  
             undefined4        Stack[-0x148   local_148                               XREF[1]:     140412f91(W)  
             undefined1[16]    Stack[-0x158   local_158                               XREF[4,3]:   140412fb1(W), 
                                                                                                   1404130f0(W), 
                                                                                                   140413120(W), 
                                                                                                   140578643(*), 
                                                                                                   140412fb9(W), 
                                                                                                   140412fbe(W), 
                                                                                                   140412fc2(W)  
             undefined1        Stack[-0x167   local_167                               XREF[1]:     14041308a(W)  
             undefined1        Stack[-0x168   local_168                               XREF[3]:     140412fe4(W), 
                                                                                                   140413201(R), 
                                                                                                   140413210(W)  
             undefined8        Stack[-0x170   local_170                               XREF[1]:     1404131c8(W)  
             undefined8        Stack[-0x178   local_178                               XREF[1]:     1404131cd(W)  
             undefined8        Stack[-0x180   local_180                               XREF[4]:     1404131da(W), 
                                                                                                   140578582(W), 
                                                                                                   1405785f0(W), 
                                                                                                   140578648(W)  
             undefined8        Stack[-0x188   local_188                               XREF[4]:     1404131df(W), 
                                                                                                   140578587(W), 
                                                                                                   1405785fd(W), 
                                                                                                   140578655(W)  
                             FUN_140412f50                                   XREF[14]:    1402726f4(*), 140357d9c(*), 
                                                                                          FUN_1404124d0:1404124dd(c), 
                                                                                          140412f3e(c), 14048a4e9(c), 
                                                                                          FUN_1404913e0:1404914b5(c), 
                                                                                          FUN_1405051d4:140505254(c), 
                                                                                          FUN_140521ae0:140521b37(c), 
                                                                                          FUN_140535bf0:140535d2f(c), 
                                                                                          FUN_140535bf0:140535ec2(c), 
                                                                                          FUN_140535bf0:140535f10(c), 
                                                                                          1405dbfae(c), 
                                                                                          FUN_14066b010:14066b0f2(c), 
                                                                                          FUN_14066b010:14066b320(c)  
       140412f50 40 53           PUSH       RBX
       140412f52 56              PUSH       RSI
       140412f53 57              PUSH       RDI
       140412f54 41 54           PUSH       R12
       140412f56 41 55           PUSH       R13
       140412f58 41 56           PUSH       R14
       140412f5a 41 57           PUSH       R15
       140412f5c 48 81 ec        SUB        RSP,0x170
                 70 01 00 00
       140412f63 48 8b 05        MOV        RAX,qword ptr [DAT_1402d0058]                    = 00002B992DDFA232h
                 ee d0 eb ff
       140412f6a 48 33 c4        XOR        RAX,RSP
       140412f6d 48 89 84        MOV        qword ptr [RSP + local_48],RAX
                 24 60 01 
                 00 00
       140412f75 45 8b f1        MOV        R14D,param_4
       140412f78 49 8b f8        MOV        RDI,param_3
       140412f7b 44 8b fa        MOV        R15D,param_2
       140412f7e 4c 8b e9        MOV        R13,param_1
       140412f81 48 89 8c        MOV        qword ptr [RSP + local_100],param_1
                 24 a8 00 
                 00 00
       140412f89 4c 89 84        MOV        qword ptr [RSP + local_110],param_3
                 24 98 00 
                 00 00
       140412f91 44 89 4c        MOV        dword ptr [RSP + local_148],param_4
                 24 60
       140412f96 48 8b 84        MOV        RAX,qword ptr [RSP + param_5]
                 24 d0 01 
                 00 00
       140412f9e 48 89 84        MOV        qword ptr [RSP + local_120],RAX
                 24 88 00 
                 00 00
       140412fa6 45 33 e4        XOR        R12D,R12D
       140412fa9 41 8b dc        MOV        EBX,R12D
       140412fac 4c 89 64        MOV        qword ptr [RSP + local_140],R12
                 24 68
       140412fb1 66 44 89        MOV        word ptr [RSP + local_158[0]],R12W
                 64 24 50
       140412fb7 33 c0           XOR        EAX,EAX
       140412fb9 48 89 44        MOV        qword ptr [RSP + local_158[2]],RAX
                 24 52
       140412fbe 89 44 24 5a     MOV        dword ptr [RSP + local_158[10]],EAX
       140412fc2 66 89 44        MOV        word ptr [RSP + local_158[14]],AX
                 24 5e
       140412fc7 44 89 a4        MOV        dword ptr [RSP + local_e8],R12D
                 24 c0 00 
                 00 00
       140412fcf 33 d2           XOR        param_2,param_2
       140412fd1 41 b8 84        MOV        param_3,0x84
                 00 00 00
       140412fd7 48 8d 8c        LEA        param_1=>local_e4,[RSP + 0xc4]
                 24 c4 00 
                 00 00
       140412fdf e8 dc aa        CALL       memset                                           void * memset(void * _Dst, int _
                 d3 ff
       140412fe4 88 5c 24 40     MOV        byte ptr [RSP + local_168],BL
       140412fe8 4c 89 64        MOV        qword ptr [RSP + local_138],R12
                 24 70
       140412fed 44 89 a4        MOV        dword ptr [RSP + local_58],R12D
                 24 50 01 
                 00 00
       140412ff5 33 c0           XOR        EAX,EAX
       140412ff7 48 89 84        MOV        qword ptr [RSP + local_54],RAX
                 24 54 01 
                 00 00
       140412fff 89 84 24        MOV        dword ptr [RSP + local_4c],EAX
                 5c 01 00 00
       140413006 4c 89 a4        MOV        qword ptr [RSP + local_128],R12
                 24 80 00 
                 00 00
       14041300e 48 39 05        CMP        qword ptr [DAT_1406fa008],RAX
                 f3 6f 2e 00
       140413015 0f 85 2f        JNZ        LAB_14057854a
                 55 16 00
                             LAB_14041301b                                   XREF[1]:     14057855d(j)  
       14041301b 41 8b c7        MOV        EAX,R15D
       14041301e 25 00 03        AND        EAX,0x300
                 00 00
       140413023 89 84 24        MOV        dword ptr [RSP + local_cc],EAX
                 dc 00 00 00
       14041302a 41 81 e7        AND        R15D,0xfffffcff
                 ff fc ff ff
       140413031 44 89 7c        MOV        dword ptr [RSP + local_130],R15D
                 24 78
       140413036 65 48 8b        MOV        RAX,qword ptr GS:[0x188]
                 04 25 88 
                 01 00 00
       14041303f 66 ff 88        DEC        word ptr [RAX + 0x1e4]
                 e4 01 00 00
       140413046 0f 0d 0d        PREFETCHW  byte ptr [DAT_1402fa6b8]                         = ??
                 6b 76 ee ff
       14041304d 48 8b 05        MOV        RAX,qword ptr [DAT_1402fa6b8]                    = ??
                 64 76 ee ff
       140413054 48 83 e0 fe     AND        RAX,-0x2
       140413058 48 8d 48 02     LEA        param_1,[RAX + 0x2]
       14041305c f0              LOCK
       14041305d 48 0f b1        CMPXCHG    qword ptr [DAT_1402fa6b8],param_1                = ??
                 0d 53 76 
                 ee ff
       140413065 0f 85 5f        JNZ        LAB_1404132ca
                 02 00 00
                             LAB_14041306b                                   XREF[1]:     1404132e4(j)  
       14041306b 41 8b c6        MOV        EAX,R14D
       14041306e 83 e0 0c        AND        EAX,0xc
       140413071 41 3b c6        CMP        EAX,R14D
       140413074 0f 85 31        JNZ        LAB_1405785ab
                 55 16 00
       14041307a 65 48 8b        MOV        RAX,qword ptr GS:[0x188]
                 04 25 88 
                 01 00 00
       140413083 0f b6 b0        MOVZX      ESI,byte ptr [RAX + 0x232]
                 32 02 00 00
       14041308a 40 88 74        MOV        byte ptr [RSP + local_167],SIL
                 24 41
       14041308f 40 80 fe 01     CMP        SIL,0x1
       140413093 0f 85 80        JNZ        LAB_140413119
                 00 00 00
       140413099 49 8b cd        MOV        param_1,R13
       14041309c 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 5d c1 f6 ff
       1404130a3 4c 3b e8        CMP        R13,RAX
       1404130a6 73 7f           JNC        LAB_140413127
                             LAB_1404130a8                                   XREF[1]:     14041312a(j)  
       1404130a8 4c 89 21        MOV        qword ptr [param_1],R12
       1404130ab 48 8b cf        MOV        param_1,RDI
       1404130ae 40 f6 c7 03     TEST       DIL,0x3
       1404130b2 75 7b           JNZ        LAB_14041312f
       1404130b4 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 45 c1 f6 ff
       1404130bb 48 3b f8        CMP        RDI,RAX
       1404130be 73 74           JNC        LAB_140413134
                             LAB_1404130c0                                   XREF[1]:     140413137(j)  
       1404130c0 0f b6 01        MOVZX      EAX,byte ptr [param_1]
       1404130c3 48 8b 4f 10     MOV        param_1,qword ptr [RDI + 0x10]
       1404130c7 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 32 c1 f6 ff
       1404130ce 48 3b c8        CMP        param_1,RAX
       1404130d1 73 66           JNC        LAB_140413139
                             LAB_1404130d3                                   XREF[1]:     14041313c(j)  
       1404130d3 8b 01           MOV        EAX,dword ptr [param_1]
       1404130d5 89 84 24        MOV        dword ptr [RSP + local_f8[0]],EAX
                 b0 00 00 00
       1404130dc 48 8b 49 08     MOV        param_1,qword ptr [param_1 + 0x8]
       1404130e0 48 89 8c        MOV        qword ptr [RSP + local_f8[8]],param_1
                 24 b8 00 
                 00 00
       1404130e8 0f 28 84        MOVAPS     XMM0,xmmword ptr [RSP + local_f8[0]]
                 24 b0 00 
                 00 00
       1404130f0 66 0f 7f        MOVDQA     xmmword ptr [RSP + local_158[0]],XMM0
                 44 24 50
       1404130f6 66 85 c0        TEST       AX,AX
       1404130f9 74 4b           JZ         LAB_140413146
       1404130fb f6 c1 01        TEST       param_1,0x1
       1404130fe 75 3e           JNZ        LAB_14041313e
       140413100 0f b7 d0        MOVZX      param_2,AX
       140413103 48 03 d1        ADD        param_2,param_1
       140413106 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 f3 c0 f6 ff
       14041310d 48 3b d0        CMP        param_2,RAX
       140413110 77 31           JA         LAB_140413143
       140413112 48 3b d1        CMP        param_2,param_1
       140413115 72 2c           JC         LAB_140413143
       140413117 eb 2d           JMP        LAB_140413146
                             LAB_140413119                                   XREF[1]:     140413093(j)  
       140413119 48 8b 47 10     MOV        RAX,qword ptr [RDI + 0x10]
       14041311d 0f 10 00        MOVUPS     XMM0,xmmword ptr [RAX]
       140413120 0f 11 44        MOVUPS     xmmword ptr [RSP + local_158[0]],XMM0
                 24 50
       140413125 eb 1f           JMP        LAB_140413146
                             LAB_140413127                                   XREF[1]:     1404130a6(j)  
       140413127 48 8b c8        MOV        param_1,RAX
       14041312a e9 79 ff        JMP        LAB_1404130a8
                 ff ff
                             LAB_14041312f                                   XREF[1]:     1404130b2(j)  
       14041312f e8 dc f0        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 25 00
                             LAB_140413134                                   XREF[1]:     1404130be(j)  
       140413134 48 8b c8        MOV        param_1,RAX
       140413137 eb 87           JMP        LAB_1404130c0
                             LAB_140413139                                   XREF[1]:     1404130d1(j)  
       140413139 48 8b c8        MOV        param_1,RAX
       14041313c eb 95           JMP        LAB_1404130d3
                             LAB_14041313e                                   XREF[1]:     1404130fe(j)  
       14041313e e8 cd f0        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 25 00
                             LAB_140413143                                   XREF[2]:     140413110(j), 140413115(j)  
       140413143 c6 00 00        MOV        byte ptr [RAX],0x0
                             LAB_140413146                                   XREF[3]:     1404130f9(j), 140413117(j), 
                                                                                          140413125(j)  
   --> 140413146 48 8b 47 08     MOV        RAX,qword ptr [RDI + 0x8]
       14041314a 48 89 44        MOV        qword ptr [RSP + local_138],RAX
                 24 70
       14041314f eb 35           JMP        LAB_140413186

`````


syscall 0x12 on Win10 1057 is NtOpenKey.

*** 这个没什么明显可以用的，回头可以再看看。


-------------------------------------------------------------------



case 13

和case 11 在同一段代码里，case 11的double fetch，用x标出。

DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12
   eip 0xfffff80179c9d01b, user_address 0x3eb00ff338, user_data 0x680066, modrm 0x1, pc 0xfffff80179c9d0d3
   eip 0xfffff80179c73515, user_address 0x3eb00ff338, user_data 0x680066, modrm 0x2, pc 0xfffff80179c732f1
DIFF EIP



`````shell
       1404130bb 48 3b f8        CMP        RDI,RAX
       1404130be 73 74           JNC        LAB_140413134
                             LAB_1404130c0                                   XREF[1]:     140413137(j)
       1404130c0 0f b6 01        MOVZX      EAX,byte ptr [param_1]
       1404130c3 48 8b 4f 10     MOV        param_1,qword ptr [RDI + 0x10]
       1404130c7 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 32 c1 f6 ff
       1404130ce 48 3b c8        CMP        param_1,RAX
       1404130d1 73 66           JNC        LAB_140413139
                             LAB_1404130d3                                   XREF[1]:     14041313c(j)
   --> 1404130d3 8b 01           MOV        EAX,dword ptr [param_1]
       1404130d5 89 84 24        MOV        dword ptr [RSP + local_f8[0]],EAX
                 b0 00 00 00
   x   1404130dc 48 8b 49 08     MOV        param_1,qword ptr [param_1 + 0x8]
       1404130e0 48 89 8c        MOV        qword ptr [RSP + local_f8[8]],param_1
                 24 b8 00
                 00 00
       1404130e8 0f 28 84        MOVAPS     XMM0,xmmword ptr [RSP + local_f8[0]]
                 24 b0 00
                 00 00
       1404130f0 66 0f 7f        MOVDQA     xmmword ptr [RSP + local_158[0]],XMM0
                 44 24 50

`````

`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1403e9290()
             undefined         AL:1           <RETURN>
             undefined1        Stack[0x18]:1  local_res18                             XREF[1]:     1403e92d5(W)  
             undefined8        Stack[0x10]:8  local_res10                             XREF[2]:     1403e9297(W), 
                                                                                                   1403e949c(R)  
             undefined8        Stack[0x8]:8   local_res8                              XREF[2]:     1403e9293(W), 
                                                                                                   1403e9498(R)  
             undefined1        Stack[-0x28]:1 local_28                                XREF[1]:     1403e9493(*)  
             undefined1[16]    Stack[-0x38]   local_38                                XREF[3,2]:   1403e92f3(W), 
                                                                                                   1403e932d(R), 
                                                                                                   1403e9441(W), 
                                                                                                   1403e92fb(W), 
                                                                                                   1403e93d7(R)  
             undefined8        Stack[-0x48]:8 local_48                                XREF[3]:     1403e92b9(W), 
                                                                                                   1403e93c6(W), 
                                                                                                   1403e9460(W)  
             undefined4        Stack[-0x4c]:4 local_4c                                XREF[2]:     1403e933e(W), 
                                                                                                   1403e93b5(R)  
             undefined4        Stack[-0x50]:4 local_50                                XREF[2]:     1403e9369(W), 
                                                                                                   1403e9382(W)  
             undefined4        Stack[-0x54]:4 local_54                                XREF[4]:     1403e92b5(W), 
                                                                                                   1403e9465(W), 
                                                                                                   1403e946f(W), 
                                                                                                   1403e948f(R)  
                             FUN_1403e9290                                   XREF[3]:     1403566d4(*), 
                                                                                          FUN_1403e9030:1403e91f1(c), 
                                                                                          ObReferenceObjectByName:14041c9a
       1403e9290 4c 8b dc        MOV        R11,RSP
       1403e9293 49 89 5b 08     MOV        qword ptr [R11 + local_res8],RBX
       1403e9297 49 89 73 10     MOV        qword ptr [R11 + local_res10],RSI
       1403e929b 57              PUSH       RDI
       1403e929c 41 54           PUSH       R12
       1403e929e 41 55           PUSH       R13
       1403e92a0 41 56           PUSH       R14
       1403e92a2 41 57           PUSH       R15
       1403e92a4 48 83 ec 50     SUB        RSP,0x50
       1403e92a8 4d 8b f8        MOV        R15,R8
       1403e92ab 45 33 e4        XOR        R12D,R12D
       1403e92ae 4d 89 60 08     MOV        qword ptr [R8 + 0x8],R12
       1403e92b2 45 89 20        MOV        dword ptr [R8],R12D
       1403e92b5 45 89 63 ac     MOV        dword ptr [R11 + local_54],R12D
       1403e92b9 4d 89 63 b8     MOV        qword ptr [R11 + local_48],R12
       1403e92bd 84 c9           TEST       CL,CL
       1403e92bf 0f 84 79        JZ         LAB_1403e943e
                 01 00 00
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
   --> 1403e92f1 8b 02           MOV        EAX,dword ptr [RDX]
       1403e92f3 89 44 24 40     MOV        dword ptr [RSP + local_38[0]],EAX
   x   1403e92f7 48 8b 4a 08     MOV        RCX,qword ptr [RDX + 0x8]
       1403e92fb 48 89 4c        MOV        qword ptr [RSP + local_38[8]],RCX
                 24 48
       1403e9300 66 85 c0        TEST       AX,AX
       1403e9303 74 28           JZ         LAB_1403e932d
       1403e9305 f6 c1 01        TEST       CL,0x1
       1403e9308 0f 85 45        JNZ        LAB_1403e9453
                 01 00 00

`````

--------------------------------------------------

case 14


看来NtOpenKey里double fetch是不少，case 12里的用x标，case 13里的用y标。

这几个都不是简单的读后回写，都先读到一个栈里一个变量里，后面再用，得根据上下文仔细分析才知道有没有用了。


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12
   eip 0xfffff80179c9d01b, user_address 0x3eb00ff370, user_data 0x3eb00ff338, modrm 0x4f, pc 0xfffff80179c9d0c3
   eip 0xfffff80179c73515, user_address 0x3eb00ff370, user_data 0x3eb00ff338, modrm 0x78, pc 0xfffff80179c73108
DIFF EIP
`````


`````shell
       1404130bb 48 3b f8        CMP        RDI,RAX
       1404130be 73 74           JNC        LAB_140413134
                             LAB_1404130c0                                   XREF[1]:     140413137(j)
       1404130c0 0f b6 01        MOVZX      EAX,byte ptr [param_1]
   --> 1404130c3 48 8b 4f 10     MOV        param_1,qword ptr [RDI + 0x10]
       1404130c7 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 32 c1 f6 ff
       1404130ce 48 3b c8        CMP        param_1,RAX
       1404130d1 73 66           JNC        LAB_140413139
                             LAB_1404130d3                                   XREF[1]:     14041313c(j)
   y   1404130d3 8b 01           MOV        EAX,dword ptr [param_1]
       1404130d5 89 84 24        MOV        dword ptr [RSP + local_f8[0]],EAX
                 b0 00 00 00
   x   1404130dc 48 8b 49 08     MOV        param_1,qword ptr [param_1 + 0x8]
       1404130e0 48 89 8c        MOV        qword ptr [RSP + local_f8[8]],param_1
                 24 b8 00
                 00 00
       1404130e8 0f 28 84        MOVAPS     XMM0,xmmword ptr [RSP + local_f8[0]]
                 24 b0 00
                 00 00
       1404130f0 66 0f 7f        MOVDQA     xmmword ptr [RSP + local_158[0]],XMM0
                 44 24 50

`````

`````shell
                             LAB_1403e90fb                                   XREF[1]:     1403e90f1(j)  
       1403e90fb a9 0d e0        TEST       EAX,0xfffee00d
                 fe ff
       1403e9100 0f 85 9a        JNZ        LAB_1403e91a0
                 00 00 00
       1403e9106 89 03           MOV        dword ptr [RBX],EAX
   --> 1403e9108 4d 8b 78 10     MOV        R15,qword ptr [param_3 + 0x10]
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


------------------------------------------

case 15, case 16


没啥意思。case 16 用--x标

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x50
   eip 0xfffff80179c59537, user_address 0x3eb00ff060, user_data 0x1000, modrm 0x1, pc 0xfffff80179c59585
   eip 0xfffff80179c59537, user_address 0x3eb00ff060, user_data 0x1000, modrm 0x8, pc 0xfffff80179c595b5

`````

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x50
   eip 0xfffff80179c59537, user_address 0x3eb00ff068, user_data 0x7fff907200a8, modrm 0x1, pc 0xfffff80179c59570
   eip 0xfffff80179c59537, user_address 0x3eb00ff068, user_data 0x7fff907200a8, modrm 0x16, pc 0xfffff80179c595ad

`````


`````shell
                             LAB_1403cf570                                   XREF[1]:     1403cf59f(j)  
   --x 1403cf570 48 8b 01        MOV        RAX,qword ptr [RCX]
       1403cf573 48 89 01        MOV        qword ptr [RCX],RAX
       1403cf576 49 8b c8        MOV        RCX,R8
       1403cf579 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 80 fc fa ff
       1403cf580 4c 3b c0        CMP        R8,RAX
       1403cf583 73 1c           JNC        LAB_1403cf5a1
                             LAB_1403cf585                                   XREF[1]:     1403cf5a4(j)  
   --> 1403cf585 48 8b 01        MOV        RAX,qword ptr [RCX]
       1403cf588 48 89 01        MOV        qword ptr [RCX],RAX
       1403cf58b 49 8b cc        MOV        RCX,R12
       1403cf58e 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 6b fc fa ff
       1403cf595 4c 3b e0        CMP        R12,RAX
       1403cf598 73 0c           JNC        LAB_1403cf5a6
       1403cf59a eb 0d           JMP        LAB_1403cf5a9
                             LAB_1403cf59c                                   XREF[1]:     1403cf56e(j)  
       1403cf59c 48 8b c8        MOV        RCX,RAX
       1403cf59f eb cf           JMP        LAB_1403cf570
                             LAB_1403cf5a1                                   XREF[1]:     1403cf583(j)  
       1403cf5a1 48 8b c8        MOV        RCX,RAX
       1403cf5a4 eb df           JMP        LAB_1403cf585
                             LAB_1403cf5a6                                   XREF[1]:     1403cf598(j)  
       1403cf5a6 48 8b c8        MOV        RCX,RAX
                             LAB_1403cf5a9                                   XREF[1]:     1403cf59a(j)  
       1403cf5a9 8b 01           MOV        EAX,dword ptr [RCX]
       1403cf5ab 89 01           MOV        dword ptr [RCX],EAX
   --x 1403cf5ad 48 8b 16        MOV        RDX,qword ptr [RSI]
       1403cf5b0 48 89 54        MOV        qword ptr [RSP + 0x50],RDX
                 24 50
   --> 1403cf5b5 49 8b 08        MOV        RCX,qword ptr [R8]
       1403cf5b8 48 89 4c        MOV        qword ptr [RSP + 0x40],RCX
                 24 40
       1403cf5bd eb 05           JMP        LAB_1403cf5c4

`````

------------------------------------

case 17


和case 10才同一块代码，case 10的用x标记。

这个似乎也没什么意思。

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x1e
   eip 0xfffff80179cbddc0, user_address 0x3eb00ff9d0, user_data 0x13eea100000, modrm 0x1, pc 0xfffff80179cbde57
   eip 0xfffff80179cbddc0, user_address 0x3eb00ff9d0, user_data 0x13eea100000, modrm 0x32, pc 0xfffff80179cbde7e

`````



`````shell
                             LAB_140433e57                                   XREF[1]:     140433e77(j)  
   --> 140433e57 48 8b 01        MOV        RAX,qword ptr [RCX]
       140433e5a 48 89 01        MOV        qword ptr [RCX],RAX
       140433e5d 49 8b c8        MOV        RCX,R8
       140433e60 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 99 b3 f4 ff
       140433e67 4c 3b c0        CMP        R8,RAX
       140433e6a 73 0d           JNC        LAB_140433e79
                             LAB_140433e6c                                   XREF[1]:     140433e7c(j)  
   x   140433e6c 48 8b 01        MOV        RAX,qword ptr [RCX]
       140433e6f 48 89 01        MOV        qword ptr [RCX],RAX
       140433e72 eb 0a           JMP        LAB_140433e7e
                             LAB_140433e74                                   XREF[1]:     140433e55(j)  
       140433e74 48 8b c8        MOV        RCX,RAX
       140433e77 eb de           JMP        LAB_140433e57
                             LAB_140433e79                                   XREF[1]:     140433e6a(j)  
       140433e79 48 8b c8        MOV        RCX,RAX
       140433e7c eb ee           JMP        LAB_140433e6c
                             LAB_140433e7e                                   XREF[2]:     140433e46(j), 140433e72(j)  
   --> 140433e7e 48 8b 32        MOV        RSI,qword ptr [RDX]
       140433e81 48 89 b4        MOV        qword ptr [RSP + local_88],RSI
                 24 90 00 
                 00 00
   x   140433e89 4d 8b 20        MOV        R12,qword ptr [R8]
       140433e8c 4c 89 a4        MOV        qword ptr [RSP + local_80],R12
                 24 98 00 
                 00 00

`````


------------------------------------------------

case 18

这个pc两次出现在同一位值，有可能是某一个函数被调用了两遍。

`````shell
DOUBLE FETCH:   cr3 0x12cd41000, syscall 0x1a9
   eip 0xfffff801799111d0, user_address 0x7fff8760003c, user_data 0x100, modrm 0x4a, pc 0xfffff8017991120a
   eip 0xfffff80179911000, user_address 0x7fff8760003c, user_data 0x100, modrm 0x4a, pc 0xfffff8017991120a
`````


`````shell
                             LAB_140087200                                   XREF[1]:     14008724c(j)  
       140087200 b9 4d 5a        MOV        ECX,0x5a4d
                 00 00
       140087205 66 39 0a        CMP        word ptr [RDX],CX
       140087208 75 44           JNZ        LAB_14008724e
   --> 14008720a 8b 4a 3c        MOV        ECX,dword ptr [RDX + 0x3c]
       14008720d 84 c0           TEST       AL,AL
       14008720f 75 45           JNZ        LAB_140087256

`````

`````shell
NTSYSAPI NTSTATUS NTAPI 
RtlImageNtHeaderEx (_In_ ULONG Flags, _In_ PVOID Base, _In_ ULONG64 Size, _Out_ PIMAGE_NT_HEADERS *OutHeaders)
`````

`````shell

undefined8 RtlImageNtHeaderEx(ulonglong param_1,int *param_2,ulonglong param_3,int **param_4)

{
  int *piVar1;
  bool bVar2;
  ulonglong uVar3;
  
                    /* 0x871d0  1896  RtlImageNtHeaderEx */
  if (((param_4 == (int **)0x0) || (*param_4 = (int *)0x0, (param_1 & 0xfffffffe) != 0)) ||
     (0xfffffffffffffffd < (longlong)param_2 - 1U)) {
    return 0xc000000d;
  }
  if ((param_1 & 1) == 0) {
    bVar2 = true;
    if (param_3 < 0x40) {
      return 0xc000007b;
    }
  }
  else {
    bVar2 = false;
  }
  if (*(short *)param_2 == 0x5a4d) {
--> uVar3 = (ulonglong)(uint)param_2[0xf];
    if (((!bVar2) ||
        (((uVar3 < param_3 && ((uint)param_2[0xf] < 0xffffffe7)) && (uVar3 + 0x18 < param_3)))) &&
       ((piVar1 = (int *)((longlong)param_2 + uVar3), param_2 <= piVar1 &&
        (((MmHighestUserAddress <= param_2 ||
          ((piVar1 < MmHighestUserAddress && (piVar1 + 0x42 < MmHighestUserAddress)))) &&
         (*piVar1 == 0x4550)))))) {
      *param_4 = piVar1;
      return 0;
    }
  }
  return 0xc000007b;
}
`````

> At location 0x3c, the stub has the file offset to the PE signature. This information enables Windows to properly execute the image file, even though it has an MS-DOS stub. This file offset is placed at location 0x3c during linking.


从地址和数据上看是正确的，`user_address 0x7fff8760003c, user_data 0x100`

看样是加载一个user lib到地址0x7fff87600000。但为什么RtlImageNtHeaderEx要调用两遍。

syscall 0x1a9 是NtUnloadDriver。

这个情况会有什么用呢？



------------------------------------------------


case 19


这又有重复的pc，而且user_address还都是连续的。

`````shell
DOUBLE FETCH:   cr3 0x11067e000, syscall 0x0
   eip 0xfffff801799d7780, user_address 0x2c596e07ad4, user_data 0x605000000, modrm 0x44, pc 0xfffff801799d7940
   eip 0xfffff801799d7780, user_address 0x2c596e07ad4, user_data 0x605000000, modrm 0x44, pc 0xfffff801799d7940

DOUBLE FETCH:   cr3 0x11067e000, syscall 0x0
   eip 0xfffff801799d7780, user_address 0x2c596e07ad3, user_data 0x0, modrm 0x44, pc 0xfffff801799d7960
   eip 0xfffff801799d7780, user_address 0x2c596e07ad3, user_data 0x0, modrm 0x44, pc 0xfffff801799d7960

DOUBLE FETCH:   cr3 0x11067e000, syscall 0x0
   eip 0xfffff801799d7780, user_address 0x2c596e07ad2, user_data 0x0, modrm 0x44, pc 0xfffff801799d7960
   eip 0xfffff801799d7780, user_address 0x2c596e07ad2, user_data 0x0, modrm 0x44, pc 0xfffff801799d7960

DOUBLE FETCH:   cr3 0x11067e000, syscall 0x0
   eip 0xfffff801799d7780, user_address 0x2c596e07ad1, user_data 0x1, modrm 0x44, pc 0xfffff801799d7960
   eip 0xfffff801799d7780, user_address 0x2c596e07ad1, user_data 0x1, modrm 0x44, pc 0xfffff801799d7960

DOUBLE FETCH:   cr3 0x11067e000, syscall 0x0
   eip 0xfffff801799d7780, user_address 0x2c596e07ad0, user_data 0x1, modrm 0x44, pc 0xfffff801799d7960
   eip 0xfffff801799d7780, user_address 0x2c596e07ad0, user_data 0x1, modrm 0x44, pc 0xfffff801799d7960

`````

后来发现代码是RtlCopyMemory的。960的刚开始没找到，是因为是8a44，不是8b44，是按byte读的。

但为什么要重复copy 2次呢？

syscall 0x0是NtAccessCheck。

`````shell
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
   --x 14014d960 8a 44 0a ff     MOV        AL,byte ptr [_Src + _Dst*0x1 + -0x1]
       14014d964 48 ff c9        DEC        _Dst
       14014d967 49 ff c8        DEC        _Size
       14014d96a 88 01           MOV        byte ptr [_Dst],AL
       14014d96c 75 f2           JNZ        LAB_14014d960

`````

`````shell

void * RtlCopyMemory(void *_Dst,void *_Src,size_t _Size)

{
  undefined4 *puVar1;
  undefined4 *puVar2;
  undefined *puVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  undefined4 uVar7;
  undefined4 uVar8;
  undefined4 uVar9;
  undefined4 uVar10;
  int iVar11;
  uint uVar12;
  undefined8 *puVar13;
  undefined8 *puVar14;
  ulonglong uVar15;
  ulonglong uVar16;
  
                    /* 0x14d780  1764  RtlCopyMemory
                       0x14d780  1978  RtlMoveMemory
                       0x14d780  2606  memcpy
                       0x14d780  2608  memmove */
  uVar15 = (longlong)_Src - (longlong)_Dst;
  if (_Src < _Dst) {
    puVar13 = (undefined8 *)((longlong)_Dst + _Size);
    if (0x4e < _Size) {
      if (uVar15 < 0xfffffffffffffff1) {
        uVar16 = (ulonglong)((uint)puVar13 & 0xf);
        if (((ulonglong)puVar13 & 0xf) != 0) {
          _Size = _Size - uVar16;
          uVar16 = -uVar16;
          puVar1 = (undefined4 *)((uVar15 - 0x10) + (longlong)puVar13);
          uVar4 = puVar1[1];
          uVar5 = puVar1[2];
          uVar6 = puVar1[3];
          *(undefined4 *)(puVar13 + -2) = *puVar1;
          *(undefined4 *)((longlong)puVar13 + -0xc) = uVar4;
          *(undefined4 *)(puVar13 + -1) = uVar5;
          *(undefined4 *)((longlong)puVar13 + -4) = uVar6;
        }
        puVar13 = (undefined8 *)(uVar16 + (longlong)puVar13);
      }
      else {
        while (((ulonglong)puVar13 & 0xf) != 0) {
          puVar13 = (undefined8 *)((longlong)puVar13 + -1);
          _Size = _Size - 1;
          *(undefined *)puVar13 = *(undefined *)(uVar15 + (longlong)puVar13);
        }
      }
      uVar16 = _Size >> 5;
      if ((0x2000 < uVar16) && (uVar15 < 0xfffffffffffffe01)) {
        do {
          iVar11 = 4;
          do {
            puVar14 = puVar13;
            iVar11 = iVar11 + -1;
            puVar13 = puVar14 + -0x10;
          } while (iVar11 != 0);
          iVar11 = 8;
          puVar14 = puVar14 + 0x30;
          do {
            puVar1 = (undefined4 *)((uVar15 - 0x10) + (longlong)puVar14);
            uVar4 = puVar1[1];
            uVar5 = puVar1[2];
            uVar6 = puVar1[3];
            puVar2 = (undefined4 *)((uVar15 - 0x20) + (longlong)puVar14);
            uVar7 = *puVar2;
            uVar8 = puVar2[1];
            uVar9 = puVar2[2];
            uVar10 = puVar2[3];
            *(undefined4 *)(puVar14 + -2) = *puVar1;
            *(undefined4 *)((longlong)puVar14 + -0xc) = uVar4;
            *(undefined4 *)(puVar14 + -1) = uVar5;
            *(undefined4 *)((longlong)puVar14 + -4) = uVar6;
            *(undefined4 *)(puVar14 + -4) = uVar7;
            *(undefined4 *)((longlong)puVar14 + -0x1c) = uVar8;
            *(undefined4 *)(puVar14 + -3) = uVar9;
            *(undefined4 *)((longlong)puVar14 + -0x14) = uVar10;
            puVar13 = puVar14 + -8;
            puVar2 = (undefined4 *)(uVar15 + 0x10 + (longlong)puVar13);
            uVar4 = puVar2[1];
            uVar5 = puVar2[2];
            uVar6 = puVar2[3];
            puVar1 = (undefined4 *)(uVar15 + (longlong)puVar13);
            uVar7 = *puVar1;
            uVar8 = puVar1[1];
            uVar9 = puVar1[2];
            uVar10 = puVar1[3];
            *(undefined4 *)(puVar14 + -6) = *puVar2;
            *(undefined4 *)((longlong)puVar14 + -0x2c) = uVar4;
            *(undefined4 *)(puVar14 + -5) = uVar5;
            *(undefined4 *)((longlong)puVar14 + -0x24) = uVar6;
            *(undefined4 *)puVar13 = uVar7;
            *(undefined4 *)((longlong)puVar14 + -0x3c) = uVar8;
            *(undefined4 *)(puVar14 + -7) = uVar9;
            *(undefined4 *)((longlong)puVar14 + -0x34) = uVar10;
            iVar11 = iVar11 + -1;
            puVar14 = puVar13;
          } while (iVar11 != 0);
          _Size = _Size - 0x200;
        } while (0x1ff < _Size);
        LOCK();
        uVar16 = _Size >> 5;
        if (uVar16 == 0) goto LAB_14014d937;
      }
      _Size = _Size & 0x1f;
      puVar14 = puVar13;
      do {
        puVar1 = (undefined4 *)((uVar15 - 0x10) + (longlong)puVar14);
        uVar4 = puVar1[1];
        uVar5 = puVar1[2];
        uVar6 = puVar1[3];
        puVar2 = (undefined4 *)((uVar15 - 0x20) + (longlong)puVar14);
        uVar7 = *puVar2;
        uVar8 = puVar2[1];
        uVar9 = puVar2[2];
        uVar10 = puVar2[3];
        puVar13 = puVar14 + -4;
        *(undefined4 *)(puVar14 + -2) = *puVar1;
        *(undefined4 *)((longlong)puVar14 + -0xc) = uVar4;
        *(undefined4 *)(puVar14 + -1) = uVar5;
        *(undefined4 *)((longlong)puVar14 + -4) = uVar6;
        *(undefined4 *)puVar13 = uVar7;
        *(undefined4 *)((longlong)puVar14 + -0x1c) = uVar8;
        *(undefined4 *)(puVar14 + -3) = uVar9;
        *(undefined4 *)((longlong)puVar14 + -0x14) = uVar10;
        uVar16 = uVar16 - 1;
        puVar14 = puVar13;
      } while (uVar16 != 0);
    }
LAB_14014d937:
    for (uVar16 = _Size >> 3; uVar16 != 0; uVar16 = uVar16 - 1) {
      puVar14 = (undefined8 *)((uVar15 - 8) + (longlong)puVar13);
      puVar13 = puVar13 + -1;
      *puVar13 = *puVar14;
    }
    for (uVar16 = _Size & 7; uVar16 != 0; uVar16 = uVar16 - 1) {
      puVar3 = (undefined *)((uVar15 - 1) + (longlong)puVar13);
      puVar13 = (undefined8 *)((longlong)puVar13 + -1);
      *(undefined *)puVar13 = *puVar3;
    }
    return _Dst;
  }
  puVar13 = (undefined8 *)_Dst;
  if (0x4e < _Size) {
    if (uVar15 < 0x10) {
      uVar16 = (ulonglong)_Dst & 0xf;
      while (uVar16 != 0) {
        _Size = _Size - 1;
        *(undefined *)puVar13 = *(undefined *)(uVar15 + (longlong)puVar13);
        puVar13 = (undefined8 *)((longlong)puVar13 + 1);
        uVar16 = (ulonglong)puVar13 & 0xf;
      }
    }
    else {
      uVar12 = -(int)_Dst & 0xf;
      if (uVar12 != 0) {
        _Size = _Size - uVar12;
        puVar1 = (undefined4 *)(uVar15 + (longlong)_Dst);
        uVar4 = puVar1[1];
        uVar5 = puVar1[2];
        uVar6 = puVar1[3];
        *(undefined4 *)_Dst = *puVar1;
        *(undefined4 *)((longlong)_Dst + 4) = uVar4;
        *(undefined4 *)((longlong)_Dst + 8) = uVar5;
        *(undefined4 *)((longlong)_Dst + 0xc) = uVar6;
      }
      puVar13 = (undefined8 *)((ulonglong)uVar12 + (longlong)_Dst);
    }
    uVar16 = _Size >> 5;
    if ((0x2000 < uVar16) && (0x1ff < uVar15)) {
      do {
        iVar11 = 4;
        do {
          puVar14 = puVar13;
          iVar11 = iVar11 + -1;
          puVar13 = puVar14 + 0x10;
        } while (iVar11 != 0);
        iVar11 = 8;
        puVar14 = puVar14 + -0x30;
        do {
          puVar1 = (undefined4 *)(uVar15 + (longlong)puVar14);
          uVar4 = puVar1[1];
          uVar5 = puVar1[2];
          uVar6 = puVar1[3];
          puVar2 = (undefined4 *)(uVar15 + 0x10 + (longlong)puVar14);
          uVar7 = *puVar2;
          uVar8 = puVar2[1];
          uVar9 = puVar2[2];
          uVar10 = puVar2[3];
          *(undefined4 *)puVar14 = *puVar1;
          *(undefined4 *)((longlong)puVar14 + 4) = uVar4;
          *(undefined4 *)(puVar14 + 1) = uVar5;
          *(undefined4 *)((longlong)puVar14 + 0xc) = uVar6;
          *(undefined4 *)(puVar14 + 2) = uVar7;
          *(undefined4 *)((longlong)puVar14 + 0x14) = uVar8;
          *(undefined4 *)(puVar14 + 3) = uVar9;
          *(undefined4 *)((longlong)puVar14 + 0x1c) = uVar10;
          puVar13 = puVar14 + 8;
          puVar1 = (undefined4 *)((uVar15 - 0x20) + (longlong)puVar13);
          uVar4 = puVar1[1];
          uVar5 = puVar1[2];
          uVar6 = puVar1[3];
          puVar2 = (undefined4 *)((uVar15 - 0x10) + (longlong)puVar13);
          uVar7 = *puVar2;
          uVar8 = puVar2[1];
          uVar9 = puVar2[2];
          uVar10 = puVar2[3];
          *(undefined4 *)(puVar14 + 4) = *puVar1;
          *(undefined4 *)((longlong)puVar14 + 0x24) = uVar4;
          *(undefined4 *)(puVar14 + 5) = uVar5;
          *(undefined4 *)((longlong)puVar14 + 0x2c) = uVar6;
          *(undefined4 *)(puVar14 + 6) = uVar7;
          *(undefined4 *)((longlong)puVar14 + 0x34) = uVar8;
          *(undefined4 *)(puVar14 + 7) = uVar9;
          *(undefined4 *)((longlong)puVar14 + 0x3c) = uVar10;
          iVar11 = iVar11 + -1;
          puVar14 = puVar13;
        } while (iVar11 != 0);
        _Size = _Size - 0x200;
      } while (0x1ff < _Size);
      LOCK();
      uVar16 = _Size >> 5;
      if (uVar16 == 0) goto LAB_14014d792;
    }
    _Size = _Size & 0x1f;
    puVar14 = puVar13;
    do {
      puVar1 = (undefined4 *)(uVar15 + (longlong)puVar14);
      uVar4 = puVar1[1];
      uVar5 = puVar1[2];
      uVar6 = puVar1[3];
      puVar2 = (undefined4 *)(uVar15 + 0x10 + (longlong)puVar14);
      uVar7 = *puVar2;
      uVar8 = puVar2[1];
      uVar9 = puVar2[2];
      uVar10 = puVar2[3];
      puVar13 = puVar14 + 4;
      *(undefined4 *)puVar14 = *puVar1;
      *(undefined4 *)((longlong)puVar14 + 4) = uVar4;
      *(undefined4 *)(puVar14 + 1) = uVar5;
      *(undefined4 *)((longlong)puVar14 + 0xc) = uVar6;
      *(undefined4 *)(puVar14 + 2) = uVar7;
      *(undefined4 *)((longlong)puVar14 + 0x14) = uVar8;
      *(undefined4 *)(puVar14 + 3) = uVar9;
      *(undefined4 *)((longlong)puVar14 + 0x1c) = uVar10;
      uVar16 = uVar16 - 1;
      puVar14 = puVar13;
    } while (uVar16 != 0);
  }
LAB_14014d792:
  for (uVar16 = _Size >> 3; uVar16 != 0; uVar16 = uVar16 - 1) {
    *puVar13 = *(undefined8 *)(uVar15 + (longlong)puVar13);
    puVar13 = puVar13 + 1;
  }
  for (uVar16 = _Size & 7; uVar16 != 0; uVar16 = uVar16 - 1) {
    *(undefined *)puVar13 = *(undefined *)(uVar15 + (longlong)puVar13);
    puVar13 = (undefined8 *)((longlong)puVar13 + 1);
  }
  return _Dst;
}


`````


--------------------------------------------------


case 20


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x42
   eip 0xfffff80179c84540, user_address 0x3eb00fd718, user_data 0x1, modrm 0x40, pc 0xfffff80179c848ed
   eip 0xfffff80179c73030, user_address 0x3eb00fd718, user_data 0x1, modrm 0x46, pc 0xfffff80179c7317a
`````

syscall 0x42, NtDuplicateToken


这个以后还要再看，也许会有逻辑错误。


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1403fa874()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x18]:8  local_res18                             XREF[3]:     1403fa8a8(W), 
                                                                                                   1403fa8cb(R), 
                                                                                                   1403fa8df(R)  
             undefined4        Stack[0x10]:4  local_res10                             XREF[1]:     1403fa8d2(W)  
                             FUN_1403fa874                                   XREF[3]:     140356cb0(*), 
                                                                                          NtDuplicateToken:1403fa5f9(c), 
                                                                                          FUN_140458558:1404588a6(c)  
       1403fa874 48 83 ec 28     SUB        RSP,0x28
       1403fa878 4c 8b d1        MOV        R10,RCX
       1403fa87b 45 33 db        XOR        R11D,R11D
       1403fa87e 45 88 18        MOV        byte ptr [R8],R11B
       1403fa881 84 d2           TEST       DL,DL
       1403fa883 0f 84 9d        JZ         LAB_1403fa926
                 00 00 00
       1403fa889 48 85 c9        TEST       RCX,RCX
       1403fa88c 74 7c           JZ         LAB_1403fa90a
       1403fa88e f6 c1 03        TEST       CL,0x3
       1403fa891 75 66           JNZ        LAB_1403fa8f9
       1403fa893 48 3b 0d        CMP        RCX,qword ptr [MmUserProbeAddress]               = ??
                 66 49 f8 ff
       1403fa89a 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 5e 49 
                 f8 ff
       1403fa8a2 8a 01           MOV        AL,byte ptr [RCX]
       1403fa8a4 49 8b 42 28     MOV        RAX,qword ptr [R10 + 0x28]
       1403fa8a8 48 89 44        MOV        qword ptr [RSP + local_res18],RAX
                 24 40
       1403fa8ad 48 8b c8        MOV        RCX,RAX
       1403fa8b0 48 85 c0        TEST       RAX,RAX
       1403fa8b3 74 55           JZ         LAB_1403fa90a
       1403fa8b5 f6 c1 03        TEST       CL,0x3
       1403fa8b8 75 44           JNZ        LAB_1403fa8fe
       1403fa8ba 48 3b 05        CMP        RAX,qword ptr [MmUserProbeAddress]               = ??
                 3f 49 f8 ff
       1403fa8c1 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 37 49 
                 f8 ff
       1403fa8c9 8a 01           MOV        AL,byte ptr [RCX]
       1403fa8cb 48 8b 44        MOV        RAX,qword ptr [RSP + local_res18]
                 24 40
       1403fa8d0 8b 08           MOV        ECX,dword ptr [RAX]
       1403fa8d2 89 4c 24 38     MOV        dword ptr [RSP + local_res10],ECX
       1403fa8d6 83 f9 0c        CMP        ECX,0xc
       1403fa8d9 75 28           JNZ        LAB_1403fa903
       1403fa8db 41 c6 00 01     MOV        byte ptr [R8],0x1
       1403fa8df 48 8b 44        MOV        RAX,qword ptr [RSP + local_res18]
                 24 40
       1403fa8e4 f2 0f 10 00     MOVSD      XMM0,qword ptr [RAX]
       1403fa8e8 f2 41 0f        MOVSD      qword ptr [R9],XMM0
                 11 01
   --> 1403fa8ed 8b 40 08        MOV        EAX,dword ptr [RAX + 0x8]
       1403fa8f0 41 89 41 08     MOV        dword ptr [R9 + 0x8],EAX
       1403fa8f4 41 89 09        MOV        dword ptr [R9],ECX
       1403fa8f7 eb 11           JMP        LAB_1403fa90a

`````

`````shell
                             LAB_1403e915e                                   XREF[1]:     1403e91b8(j)  
       1403e915e 0f b6 00        MOVZX      EAX,byte ptr [RAX]
                             LAB_1403e9161                                   XREF[1]:     1403e9147(j)  
       1403e9161 4c 8b 74        MOV        R14,qword ptr [RSP + local_58]
                 24 40
       1403e9166 48 8b 4c        MOV        param_1,qword ptr [RSP + local_40]
                 24 58
       1403e916b 4c 8b 7c        MOV        R15,qword ptr [RSP + local_48]
                 24 50
                             LAB_1403e9170                                   XREF[1]:     1403e912f(j)  
       1403e9170 f2 41 0f        MOVSD      XMM0,qword ptr [R14]
                 10 06
       1403e9175 f2 0f 11        MOVSD      qword ptr [RBX + 0x30],XMM0
                 43 30
   --> 1403e917a 41 8b 46 08     MOV        EAX,dword ptr [R14 + 0x8]
       1403e917e 89 43 38        MOV        dword ptr [RBX + 0x38],EAX
       1403e9181 eb 37           JMP        LAB_1403e91ba
                             LAB_1403e9183                                   XREF[1]:     1403e90bc(j)  
       1403e9183 e8 88 90        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 28 00
                             LAB_1403e9188                                   XREF[1]:     1403e90cc(j)  
       1403e9188 48 8b c8        MOV        param_1,RAX
       1403e918b e9 42 ff        JMP        LAB_1403e90d2
                 ff ff

`````

---------------------------------


case 21


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x42
   eip 0xfffff80179c84540, user_address 0x3eb00fd708, user_data 0x3eb00fd710, modrm 0x42, pc 0xfffff80179c848a4
   eip 0xfffff80179c73030, user_address 0x3eb00fd708, user_data 0x3eb00fd710, modrm 0x70, pc 0xfffff80179c7311a
`````


这个也是读用户数据到内核stack变量里，后面需要具体分析。

这次每个fetch在不同的函数里，这些函数其它部分也存在double fetch，也似乎说明有些函数直接从参数里读地址然后读数据，
并不考虑同一个用户地址读多遍的问题。

`````shell
                             LAB_1403e90fb                                   XREF[1]:     1403e90f1(j)  
       1403e90fb a9 0d e0        TEST       EAX,0xfffee00d
                 fe ff
       1403e9100 0f 85 9a        JNZ        LAB_1403e91a0
                 00 00 00
       1403e9106 89 03           MOV        dword ptr [RBX],EAX
   x   1403e9108 4d 8b 78 10     MOV        R15,qword ptr [param_3 + 0x10]
       1403e910c 4c 89 7c        MOV        qword ptr [RSP + local_48],R15
                 24 50
       1403e9111 49 8b 48 20     MOV        param_1,qword ptr [param_3 + 0x20]
       1403e9115 48 89 4c        MOV        qword ptr [RSP + local_40],param_1
                 24 58
   --> 1403e911a 4d 8b 70 28     MOV        R14,qword ptr [param_3 + 0x28]
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
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1403fa874()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x18]:8  local_res18                             XREF[3]:     1403fa8a8(W), 
                                                                                                   1403fa8cb(R), 
                                                                                                   1403fa8df(R)  
             undefined4        Stack[0x10]:4  local_res10                             XREF[1]:     1403fa8d2(W)  
                             FUN_1403fa874                                   XREF[3]:     140356cb0(*), 
                                                                                          NtDuplicateToken:1403fa5f9(c), 
                                                                                          FUN_140458558:1404588a6(c)  
       1403fa874 48 83 ec 28     SUB        RSP,0x28
       1403fa878 4c 8b d1        MOV        R10,RCX
       1403fa87b 45 33 db        XOR        R11D,R11D
       1403fa87e 45 88 18        MOV        byte ptr [R8],R11B
       1403fa881 84 d2           TEST       DL,DL
       1403fa883 0f 84 9d        JZ         LAB_1403fa926
                 00 00 00
       1403fa889 48 85 c9        TEST       RCX,RCX
       1403fa88c 74 7c           JZ         LAB_1403fa90a
       1403fa88e f6 c1 03        TEST       CL,0x3
       1403fa891 75 66           JNZ        LAB_1403fa8f9
       1403fa893 48 3b 0d        CMP        RCX,qword ptr [MmUserProbeAddress]               = ??
                 66 49 f8 ff
       1403fa89a 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 5e 49 
                 f8 ff
       1403fa8a2 8a 01           MOV        AL,byte ptr [RCX]
   --> 1403fa8a4 49 8b 42 28     MOV        RAX,qword ptr [R10 + 0x28]
       1403fa8a8 48 89 44        MOV        qword ptr [RSP + local_res18],RAX
                 24 40
       1403fa8ad 48 8b c8        MOV        RCX,RAX
       1403fa8b0 48 85 c0        TEST       RAX,RAX
       1403fa8b3 74 55           JZ         LAB_1403fa90a
       1403fa8b5 f6 c1 03        TEST       CL,0x3
       1403fa8b8 75 44           JNZ        LAB_1403fa8fe
       1403fa8ba 48 3b 05        CMP        RAX,qword ptr [MmUserProbeAddress]               = ??
                 3f 49 f8 ff
       1403fa8c1 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 37 49 
                 f8 ff
       1403fa8c9 8a 01           MOV        AL,byte ptr [RCX]
       1403fa8cb 48 8b 44        MOV        RAX,qword ptr [RSP + local_res18]
                 24 40
       1403fa8d0 8b 08           MOV        ECX,dword ptr [RAX]
       1403fa8d2 89 4c 24 38     MOV        dword ptr [RSP + local_res10],ECX
       1403fa8d6 83 f9 0c        CMP        ECX,0xc
       1403fa8d9 75 28           JNZ        LAB_1403fa903
       1403fa8db 41 c6 00 01     MOV        byte ptr [R8],0x1
       1403fa8df 48 8b 44        MOV        RAX,qword ptr [RSP + local_res18]
                 24 40
       1403fa8e4 f2 0f 10 00     MOVSD      XMM0,qword ptr [RAX]
       1403fa8e8 f2 41 0f        MOVSD      qword ptr [R9],XMM0
                 11 01
   x   1403fa8ed 8b 40 08        MOV        EAX,dword ptr [RAX + 0x8]
       1403fa8f0 41 89 41 08     MOV        dword ptr [R9 + 0x8],EAX
       1403fa8f4 41 89 09        MOV        dword ptr [R9],ECX
       1403fa8f7 eb 11           JMP        LAB_1403fa90a

`````
---------------------------------------------------------------------

case 22


需要分析。

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x42
   eip 0xfffff801798e6474, user_address 0x3eb00fd700, user_data 0x0, modrm 0x41, pc 0xfffff801798e64a0
   eip 0xfffff80179c73030, user_address 0x3eb00fd700, user_data 0x0, modrm 0x48, pc 0xfffff80179c73111
`````

0xfffff80179c73111−0xfffff801798e64a0 = 38CC71


1403e9111−14005c4a0 = 38CC71


`````shell
                             LAB_1403e90fb                                   XREF[1]:     1403e90f1(j)  
       1403e90fb a9 0d e0        TEST       EAX,0xfffee00d
                 fe ff
       1403e9100 0f 85 9a        JNZ        LAB_1403e91a0
                 00 00 00
       1403e9106 89 03           MOV        dword ptr [RBX],EAX
   x   1403e9108 4d 8b 78 10     MOV        R15,qword ptr [param_3 + 0x10]
       1403e910c 4c 89 7c        MOV        qword ptr [RSP + local_48],R15
                 24 50
   --> 1403e9111 49 8b 48 20     MOV        param_1,qword ptr [param_3 + 0x20]
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
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_14005c474()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x18]:8  local_res18                             XREF[1]:     14005c4a4(W)  
                             FUN_14005c474                                   XREF[4]:     FUN_1400bc6e0:1400bc7bc(c), 
                                                                                          140335fb4(*), 140335fbc(*), 
                                                                                          NtDuplicateToken:1403fa612(c)  
       14005c474 48 83 ec 28     SUB        RSP,0x28
       14005c478 4c 8b c9        MOV        R9,RCX
       14005c47b 45 33 d2        XOR        R10D,R10D
       14005c47e 45 88 10        MOV        byte ptr [R8],R10B
       14005c481 84 d2           TEST       DL,DL
       14005c483 74 42           JZ         LAB_14005c4c7
       14005c485 48 85 c9        TEST       RCX,RCX
       14005c488 74 32           JZ         LAB_14005c4bc
       14005c48a f6 c1 03        TEST       CL,0x3
       14005c48d 75 28           JNZ        LAB_14005c4b7
       14005c48f 48 3b 0d        CMP        RCX,qword ptr [MmUserProbeAddress]               = ??
                 6a 2d 32 00
       14005c496 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 62 2d 
                 32 00
       14005c49e 8a 01           MOV        AL,byte ptr [RCX]
   --> 14005c4a0 49 8b 41 20     MOV        RAX,qword ptr [R9 + 0x20]
       14005c4a4 48 89 44        MOV        qword ptr [RSP + local_res18],RAX
                 24 40
       14005c4a9 49 3b c2        CMP        RAX,R10
       14005c4ac 74 0e           JZ         LAB_14005c4bc
       14005c4ae 41 8d 4a 01     LEA        ECX,[R10 + 0x1]
       14005c4b2 41 88 08        MOV        byte ptr [R8],CL
       14005c4b5 eb 05           JMP        LAB_14005c4bc

`````
