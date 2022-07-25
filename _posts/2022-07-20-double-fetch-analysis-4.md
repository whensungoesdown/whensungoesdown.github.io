---
title: double fetch, case 5, case 6 .. case 31
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



---------------------------------------------

case 23

这个没啥意思，AL读进来也没用到。

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x42
   eip 0xfffff80179c84540, user_address 0x3eb00fd6e0, user_data 0x30, modrm 0x1, pc 0xfffff80179c848a2
   eip 0xfffff801798e6474, user_address 0x3eb00fd6e0, user_data 0x30, modrm 0x1, pc 0xfffff801798e649e
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
   --> 14005c49e 8a 01           MOV        AL,byte ptr [RCX]
   x   14005c4a0 49 8b 41 20     MOV        RAX,qword ptr [R9 + 0x20]
       14005c4a4 48 89 44        MOV        qword ptr [RSP + local_res18],RAX
                 24 40
       14005c4a9 49 3b c2        CMP        RAX,R10
       14005c4ac 74 0e           JZ         LAB_14005c4bc
       14005c4ae 41 8d 4a 01     LEA        ECX,[R10 + 0x1]
       14005c4b2 41 88 08        MOV        byte ptr [R8],CL
       14005c4b5 eb 05           JMP        LAB_14005c4bc

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
   --> 1403fa8a2 8a 01           MOV        AL,byte ptr [RCX]
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
   x   1403fa8ed 8b 40 08        MOV        EAX,dword ptr [RAX + 0x8]
       1403fa8f0 41 89 41 08     MOV        dword ptr [R9 + 0x8],EAX
       1403fa8f4 41 89 09        MOV        dword ptr [R9],ECX
       1403fa8f7 eb 11           JMP        LAB_1403fa90a

`````


------------------------------------------------------

case 24


这两个位值离得太近了。

这个需要以后分析。


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x42
   eip 0xfffff80179c84540, user_address 0x3eb00fd710, user_data 0xc, modrm 0x1, pc 0xfffff80179c848c9
   eip 0xfffff80179c84540, user_address 0x3eb00fd710, user_data 0xc, modrm 0x8, pc 0xfffff80179c848d0
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
   y   1403fa8a2 8a 01           MOV        AL,byte ptr [RCX]
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
   --> 1403fa8c9 8a 01           MOV        AL,byte ptr [RCX]
       1403fa8cb 48 8b 44        MOV        RAX,qword ptr [RSP + local_res18]
                 24 40
   --> 1403fa8d0 8b 08           MOV        ECX,dword ptr [RAX]
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

------------------------------------------

case 25

这个没啥意思。

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x28
   eip 0xfffff80179c56d6f, user_address 0x3eb00fcbf0, user_data 0x0, modrm 0x1, pc 0xfffff80179c56dd0
   eip 0xfffff80179c56d6f, user_address 0x3eb00fcbf0, user_data 0x0, modrm 0x2a, pc 0xfffff80179c56e43

`````

`````shell
                             LAB_1403ccdb3                                   XREF[1]:     1403cce2a(j)  
       1403ccdb3 48 8b 01        MOV        RAX,qword ptr [param_1]
       1403ccdb6 48 89 01        MOV        qword ptr [param_1],RAX
       1403ccdb9 48 8b 94        MOV        param_2,qword ptr [RSP + param_7]
                 24 10 01 
                 00 00
       1403ccdc1 48 8b ca        MOV        param_1,param_2
       1403ccdc4 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 35 24 fb ff
       1403ccdcb 48 3b d0        CMP        param_2,RAX
       1403ccdce 73 5c           JNC        LAB_1403cce2c
                             LAB_1403ccdd0                                   XREF[1]:     1403cce2f(j)  
   --> 1403ccdd0 48 8b 01        MOV        RAX,qword ptr [param_1]
       1403ccdd3 48 89 01        MOV        qword ptr [param_1],RAX
                             LAB_1403ccdd6                                   XREF[1]:     1403cce25(j)  
       1403ccdd6 48 8b bc        MOV        RDI,qword ptr [RSP + param_6]
                 24 08 01 
                 00 00

`````


`````shell
                             LAB_1403cce3b                                   XREF[2]:     1403cce12(j), 1403cce1b(j)  
       1403cce3b 4d 8b 30        MOV        R14,qword ptr [param_3]
       1403cce3e 4c 89 74        MOV        qword ptr [RSP + local_68],R14
                 24 70
   --> 1403cce43 4c 8b 2a        MOV        R13,qword ptr [param_2]
       1403cce46 4c 89 ac        MOV        qword ptr [RSP + local_50],R13
                 24 88 00 
                 00 00
       1403cce4e eb 05           JMP        LAB_1403cce55
       1403cce50 e9              ??         E9h
       1403cce51 e3              ??         E3h
       1403cce52 01              ??         01h
       1403cce53 00              ??         00h
       1403cce54 00              ??         00h

`````


----------------------------------------


case 26

这个也没啥意思， 和case 25在同一个函数里（NtMapViewOfSection）。


`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x28
   eip 0xfffff80179c56d6f, user_address 0x3eb00fcbe8, user_data 0x0, modrm 0x1, pc 0xfffff80179c56db3
   eip 0xfffff80179c56d6f, user_address 0x3eb00fcbe8, user_data 0x0, modrm 0x30, pc 0xfffff80179c56e3b
`````

`````shell
                             LAB_1403ccdb3                                   XREF[1]:     1403cce2a(j)  
   --> 1403ccdb3 48 8b 01        MOV        RAX,qword ptr [param_1]
       1403ccdb6 48 89 01        MOV        qword ptr [param_1],RAX
       1403ccdb9 48 8b 94        MOV        param_2,qword ptr [RSP + param_7]
                 24 10 01 
                 00 00
       1403ccdc1 48 8b ca        MOV        param_1,param_2
       1403ccdc4 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 35 24 fb ff
       1403ccdcb 48 3b d0        CMP        param_2,RAX
       1403ccdce 73 5c           JNC        LAB_1403cce2c
                             LAB_1403ccdd0                                   XREF[1]:     1403cce2f(j)  
       1403ccdd0 48 8b 01        MOV        RAX,qword ptr [param_1]
       1403ccdd3 48 89 01        MOV        qword ptr [param_1],RAX
                             LAB_1403ccdd6                                   XREF[1]:     1403cce25(j)  
       1403ccdd6 48 8b bc        MOV        RDI,qword ptr [RSP + param_6]
                 24 08 01 
                 00 00
       1403ccdde 48 85 ff        TEST       RDI,RDI
       1403ccde1 74 31           JZ         LAB_1403cce14
       1403ccde3 84 db           TEST       BL,BL
       1403ccde5 74 21           JZ         LAB_1403cce08
       1403ccde7 48 8b cf        MOV        param_1,RDI
       1403ccdea 40 f6 c7 03     TEST       DIL,0x3
       1403ccdee 75 41           JNZ        LAB_1403cce31
       1403ccdf0 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 09 24 fb ff
       1403ccdf7 48 3b f8        CMP        RDI,RAX
       1403ccdfa 73 3a           JNC        LAB_1403cce36
                             LAB_1403ccdfc                                   XREF[1]:     1403cce39(j)  
       1403ccdfc 0f b6 01        MOVZX      EAX,byte ptr [param_1]
       1403ccdff 88 01           MOV        byte ptr [param_1],AL
       1403cce01 0f b6 41 07     MOVZX      EAX,byte ptr [param_1 + 0x7]
       1403cce05 88 41 07        MOV        byte ptr [param_1 + 0x7],AL
                             LAB_1403cce08                                   XREF[1]:     1403ccde5(j)  
       1403cce08 48 8b 07        MOV        RAX,qword ptr [RDI]
       1403cce0b 48 89 44        MOV        qword ptr [RSP + local_70],RAX
                 24 68
       1403cce10 33 f6           XOR        ESI,ESI
       1403cce12 eb 27           JMP        LAB_1403cce3b
                             LAB_1403cce14                                   XREF[1]:     1403ccde1(j)  
       1403cce14 33 f6           XOR        ESI,ESI
       1403cce16 48 89 74        MOV        qword ptr [RSP + local_70],RSI
                 24 68
       1403cce1b eb 1e           JMP        LAB_1403cce3b
                             LAB_1403cce1d                                   XREF[1]:     1403ccda2(j)  
       1403cce1d 48 8b 94        MOV        param_2,qword ptr [RSP + param_7]
                 24 10 01 
                 00 00
       1403cce25 eb af           JMP        LAB_1403ccdd6
                             LAB_1403cce27                                   XREF[1]:     1403ccdb1(j)  
       1403cce27 48 8b c8        MOV        param_1,RAX
       1403cce2a eb 87           JMP        LAB_1403ccdb3
                             LAB_1403cce2c                                   XREF[1]:     1403ccdce(j)  
       1403cce2c 48 8b c8        MOV        param_1,RAX
       1403cce2f eb 9f           JMP        LAB_1403ccdd0
                             LAB_1403cce31                                   XREF[1]:     1403ccdee(j)  
       1403cce31 e8 da 53        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 2a 00
                             LAB_1403cce36                                   XREF[1]:     1403ccdfa(j)  
       1403cce36 48 8b c8        MOV        param_1,RAX
       1403cce39 eb c1           JMP        LAB_1403ccdfc
                             LAB_1403cce3b                                   XREF[2]:     1403cce12(j), 1403cce1b(j)  
   --> 1403cce3b 4d 8b 30        MOV        R14,qword ptr [param_3]
       1403cce3e 4c 89 74        MOV        qword ptr [RSP + local_68],R14
                 24 70
       1403cce43 4c 8b 2a        MOV        R13,qword ptr [param_2]
       1403cce46 4c 89 ac        MOV        qword ptr [RSP + local_50],R13
                 24 88 00 
                 00 00
       1403cce4e eb 05           JMP        LAB_1403cce55

`````


--------------------------------------------


case 27


没用。

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0xe8
   eip 0xfffff80179d07ba4, user_address 0x3eb00fd360, user_data 0x4d0, modrm 0x1, pc 0xfffff80179d07c0e
   eip 0xfffff80179d07c8b, user_address 0x3eb00fd360, user_data 0x4d0, modrm 0x1, pc 0xfffff80179d07ce3
`````

`````shell
       14047dbf7 48 85 d2        TEST       RDX,RDX
       14047dbfa 74 2d           JZ         LAB_14047dc29
       14047dbfc 48 8b ca        MOV        RCX,RDX
       14047dbff 48 3b 15        CMP        RDX,qword ptr [MmUserProbeAddress]               = ??
                 fa 15 f0 ff
       14047dc06 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d f2 15 
                 f0 ff
   --> 14047dc0e 8b 01           MOV        EAX,dword ptr [RCX]
       14047dc10 89 44 24 40     MOV        dword ptr [RSP + local_b8],EAX
       14047dc14 eb 09           JMP        LAB_14047dc1f
       14047dc16 8b              ??         8Bh
       14047dc17 f0              ??         F0h
       14047dc18 33              ??         33h    3
       14047dc19 ff              ??         FFh
       14047dc1a e9              ??         E9h
       14047dc1b 0f              ??         0Fh
       14047dc1c 01              ??         01h
       14047dc1d 00              ??         00h
       14047dc1e 00              ??         00h
                             LAB_14047dc1f                                   XREF[1]:     14047dc14(j)  
       14047dc1f 85 c0           TEST       EAX,EAX
       14047dc21 0f 85 4a        JNZ        LAB_14047dd71
                 01 00 00
       14047dc27 eb 0d           JMP        LAB_14047dc36
                             LAB_14047dc29                                   XREF[1]:     14047dbfa(j)  
       14047dc29 f6 c1 0a        TEST       CL,0xa
       14047dc2c 0f 84 c6        JZ         LAB_14059f8f8
                 1c 12 00
       14047dc32 89 7c 24 40     MOV        dword ptr [RSP + local_b8],EDI
                             LAB_14047dc36                                   XREF[2]:     14047dc27(j), 14047dd82(j)  
       14047dc36 4d 85 c0        TEST       R8,R8
       14047dc39 0f 85 b9        JNZ        LAB_14059f8f8
                 1c 12 00
                             LAB_14047dc3f                                   XREF[1]:     14047dd7c(j)  
       14047dc3f 41 bc 01        MOV        R12D,0x1
                 00 00 00
       14047dc45 85 db           TEST       EBX,EBX
       14047dc47 41 0f 44 dc     CMOVZ      EBX,R12D
       14047dc4b f7 c3 f4        TEST       EBX,0xfffffff4
                 ff ff ff
       14047dc51 0f 85 a1        JNZ        LAB_14059f8f8
                 1c 12 00
       14047dc57 48 8b 05        MOV        RAX,qword ptr [DAT_140303e28]                    = ??
                 ca 61 e8 ff
       14047dc5e 48 85 c0        TEST       RAX,RAX
       14047dc61 0f 84 55        JZ         LAB_14047debc
                 02 00 00
                             LAB_14047dc67                                   XREF[1]:     14047ded5(j)  
       14047dc67 65 48 8b        MOV        RAX,qword ptr GS:[0x188]
                 04 25 88 
                 01 00 00
       14047dc70 49 83 cd ff     OR         R13,-0x1
       14047dc74 66 44 01        ADD        word ptr [RAX + 0x1e4],R13W
                 a8 e4 01 
                 00 00
       14047dc7c 41 8a d4        MOV        DL,R12B
       14047dc7f 48 8b 0d        MOV        RCX,qword ptr [DAT_140303e28]                    = ??
                 a2 61 e8 ff
       14047dc86 e8 45 e6        CALL       ExAcquireResourceExclusiveLite                   undefined ExAcquireResourceExclu
                 bc ff
       14047dc8b 44 88 a4        MOV        byte ptr [RSP + local_res20],R12B
                 24 18 01 
                 00 00
       14047dc93 48 8b 0d        MOV        RCX,qword ptr [DAT_1402fada8]                    = ??
                 0e d1 e7 ff
       14047dc9a 49 3b cd        CMP        RCX,R13
       14047dc9d 0f 84 5f        JZ         LAB_14059f902
                 1c 12 00
       14047dca3 41 84 dc        TEST       R12B,BL
       14047dca6 0f 84 34        JZ         LAB_14047dee0
                 02 00 00
       14047dcac 40 8a df        MOV        BL,DIL
       14047dcaf 48 85 c9        TEST       RCX,RCX
       14047dcb2 0f 84 cf        JZ         LAB_14047dd87
                 00 00 00
                             LAB_14047dcb8                                   XREF[1]:     14047deb1(j)  
       14047dcb8 8b 44 24 40     MOV        EAX,dword ptr [RSP + local_b8]
       14047dcbc 85 c0           TEST       EAX,EAX
       14047dcbe 74 0f           JZ         LAB_14047dccf
       14047dcc0 3b 05 ea        CMP        EAX,dword ptr [DAT_1402fadb0]                    = ??
                 d0 e7 ff
       14047dcc6 0f 82 9d        JC         LAB_14059f969
                 1c 12 00
       14047dccc 41 8a dc        MOV        BL,R12B
                             LAB_14047dccf                                   XREF[1]:     14047dcbe(j)  
       14047dccf 8b f7           MOV        ESI,EDI
                             LAB_14047dcd1                                   XREF[1]:     14059f96e(j)  
       14047dcd1 49 8b ce        MOV        RCX,R14
       14047dcd4 4c 3b 35        CMP        R14,qword ptr [MmUserProbeAddress]               = ??
                 25 15 f0 ff
       14047dcdb 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 1d 15 
                 f0 ff
   --> 14047dce3 8b 01           MOV        EAX,dword ptr [RCX]
       14047dce5 89 01           MOV        dword ptr [RCX],EAX

`````

--------------------------------------------
case 28

这是一个win32k的函数。win32k.sys win32kbase.sys win32kfull.sys

找win32k的函数总是对不上。因为可能不在同一个模块里，算两个地方偏移量也不行。

现在也不清楚这两块代码到底找的准不准，先放在这，以后开始搞win32k的syscall了再看具体该怎么调。

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3dc59e0, user_address 0x3eb02d2000, user_data 0x0, modrm 0x2, pc 0xfffff961a3dc59f5
   eip 0xfffff961a3a9b389, user_address 0x3eb02d2000, user_data 0x0, modrm 0x0, pc 0xfffff961a3a9b3fd

`````


`````shell

win32kfull.sys

                             LAB_1c01b39e8                                   XREF[1]:     1c0108399(j)  
       1c01b39e8 48 39 08        CMP        qword ptr [RAX],RCX
       1c01b39eb 0f 84 ae        JZ         LAB_1c010839f
                 49 f5 ff
       1c01b39f1 48 8d 50 10     LEA        RDX,[RAX + 0x10]
   --> 1c01b39f5 48 8b 02        MOV        RAX,qword ptr [RDX]
       1c01b39f8 e9 99 49        JMP        LAB_1c0108396
                 f5 ff
       1c01b39fd cc              ??         CCh

`````


`````shell
win32kbase.sys


       1c008c3f8 48 8b 44        MOV        RAX,qword ptr [RSP + local_390]
                 24 68
   --> 1c008c3fd 8b 00           MOV        EAX,dword ptr [RAX]
       1c008c3ff c1 e8 17        SHR        EAX,0x17
       1c008c402 83 e0 01        AND        EAX,0x1
       1c008c405 85 c0           TEST       EAX,EAX
       1c008c407 74 18           JZ         LAB_1c008c421
       1c008c409 48 8b 84        MOV        RAX,qword ptr [RSP + local_360]
                 24 98 00 
                 00 00

`````


`````````````````````````````````````````````````````````````

case 29

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a6, user_data 0x740073006f0068, modrm 0x44, pc 0xfffff961a3b44f00
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a6, user_data 0x740073006f0068, modrm 0x44, pc 0xfffff961a3b44f00

DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a5, user_data 0x0, modrm 0x44, pc 0xfffff961a3b44f20
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a5, user_data 0x0, modrm 0x44, pc 0xfffff961a3b44f20

DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a4, user_data 0x63, modrm 0x44, pc 0xfffff961a3b44f20
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a4, user_data 0x63, modrm 0x44, pc 0xfffff961a3b44f20

DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a3, user_data 0x0, modrm 0x44, pc 0xfffff961a3b44f20
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a3, user_data 0x0, modrm 0x44, pc 0xfffff961a3b44f20

DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a2, user_data 0x76, modrm 0x44, pc 0xfffff961a3b44f20
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a2, user_data 0x76, modrm 0x44, pc 0xfffff961a3b44f20

DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a1, user_data 0x0, modrm 0x44, pc 0xfffff961a3b44f20
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a1, user_data 0x0, modrm 0x44, pc 0xfffff961a3b44f20

DOUBLE FETCH:   cr3 0xa9774000, syscall 0x12dd
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a0, user_data 0x73, modrm 0x44, pc 0xfffff961a3b44f20
   eip 0xfffff961a3b44d40, user_address 0x13ee99030a0, user_data 0x73, modrm 0x44, pc 0xfffff961a3b44f20

`````

这个看上区很像ntoskrnel里的RtlCopyMemory，但这个syscall是0x12dd，是NtUserGetPointerDevices，应该是在win32k里的。

可我怎么也没定位到。

pc的值也不像是在kernel里，0xfffff961a3b44f00，96开头的模块，不像前面kernel的pc都是80几。

实在找不到了，就在kernel里搜这个地址，也找不到即符合f00又符合f20的。

0x740073006f0068   t s o h   (host)

0x63  c

0x76  v

这个很像在复制unicode string。

----------------------------------------------------


case 30

这个要以后分析。

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x43
   eip 0xfffff801799010b4, user_address 0x3eb017f9c8, user_data 0x3eb017fe08, modrm 0x83, pc 0xfffff801799010b4
   eip 0xfffff801799013b5, user_address 0x3eb017f9c8, user_data 0x3eb017fe08, modrm 0x81, pc 0xfffff801799016f7
`````


0xfffff801799016f7-0xfffff801799010b4=643

1400776f7-1400770b4=643


`````shell
       14007709c 8a 01           MOV        AL,byte ptr [RCX]
       14007709e 88 01           MOV        byte ptr [RCX],AL
       1400770a0 8a 81 cf        MOV        AL,byte ptr [RCX + 0x4cf]
                 04 00 00
       1400770a6 88 81 cf        MOV        byte ptr [RCX + 0x4cf],AL
                 04 00 00
       1400770ac 40 8a cf        MOV        CL,DIL
       1400770af e8 c8 00        CALL       KeTestAlertThread                                undefined KeTestAlertThread()
                 00 00
   --> 1400770b4 48 8b 83        MOV        RAX,qword ptr [RBX + 0x98]=>DAT_0000009b
                 98 00 00 00
       1400770bb 48 83 e8 28     SUB        RAX,0x28
       1400770bf 48 83 e0 f0     AND        RAX,-0x10
       1400770c3 48 05 30        ADD        RAX,-0x4d0
                 fb ff ff
       1400770c9 48 3b c3        CMP        RAX,RBX
       1400770cc 74 1d           JZ         LAB_1400770eb

`````


`````shell
                             LAB_1400776c9                                   XREF[1]:     1400778a4(j)  
       1400776c9 b9 01 00        MOV        ECX,0x100001
                 10 00
       1400776ce 41 8b c0        MOV        EAX,R8D
       1400776d1 23 c1           AND        EAX,ECX
       1400776d3 3b c1           CMP        EAX,ECX
       1400776d5 75 35           JNZ        LAB_14007770c
       1400776d7 49 8b 81        MOV        RAX,qword ptr [R9 + 0xf8]
                 f8 00 00 00
       1400776de 48 89 82        MOV        qword ptr [RDX + 0xf8],RAX
                 f8 00 00 00
       1400776e5 41 0f b7        MOVZX      EAX,word ptr [R9 + 0x38]
                 41 38
       1400776ea 66 89 42 38     MOV        word ptr [RDX + 0x38],AX
       1400776ee 41 0f b7        MOVZX      EAX,word ptr [R9 + 0x42]
                 41 42
       1400776f3 66 89 42 42     MOV        word ptr [RDX + 0x42],AX
   --> 1400776f7 49 8b 81        MOV        RAX,qword ptr [R9 + 0x98]
                 98 00 00 00
       1400776fe 48 89 82        MOV        qword ptr [RDX + 0x98],RAX
                 98 00 00 00
       140077705 41 8b 41 44     MOV        EAX,dword ptr [R9 + 0x44]
       140077709 89 42 44        MOV        dword ptr [RDX + 0x44],EAX

`````


----------------------------------------------


case 31

`````shell
DOUBLE FETCH:   cr3 0x0, syscall 0x23
   eip 0xfffff80179d041ba, user_address 0x3eb02d20bc, user_data 0x0, modrm 0x82, pc 0xfffff80179d04267
   eip 0xfffff80179d041ba, user_address 0x3eb02d20bc, user_data 0x0, modrm 0x82, pc 0xfffff80179d04267
`````

syscall 0x23NtQueryVirtualMemory


`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_14047a184()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x20]:8  local_res20                             XREF[7]:     14047a248(W), 
                                                                                                   14047a29b(*), 
                                                                                                   14047a2b4(R), 
                                                                                                   14059e822(W), 
                                                                                                   14059e839(W), 
                                                                                                   14059e867(*), 
                                                                                                   14059e878(*)  
             undefined8        Stack[0x18]:8  local_res18                             XREF[8]:     14047a1e4(W), 
                                                                                                   14047a228(W), 
                                                                                                   14047a290(*), 
                                                                                                   14047a2ac(R), 
                                                                                                   14047a34a(W), 
                                                                                                   14047a380(W), 
                                                                                                   14059e844(W), 
                                                                                                   14059e85f(*)  
             undefined1        Stack[0x10]:1  local_res10                             XREF[1]:     14059e84c(*)  
             undefined8        Stack[-0x38]:8 local_38                                XREF[2]:     14047a1d9(W), 
                                                                                                   14047a33f(W)  
             undefined8        Stack[-0x40]:8 local_40                                XREF[2]:     14047a1cd(W), 
                                                                                                   14047a334(W)  
             undefined4        Stack[-0x48]:4 local_48                                XREF[1]:     14047a26d(W)  
             undefined4        Stack[-0x50]:4 local_50                                XREF[1]:     14047a284(W)  
             undefined8        Stack[-0x58]:8 local_58                                XREF[2]:     14047a28c(W), 
                                                                                                   14059e854(W)  
                             FUN_14047a184                                   XREF[4]:     FUN_140038b50:1400390e8(c), 
                                                                                          FUN_140039a90:14016254a(c), 
                                                                                          14028951c(*), 14035b990(*)  
       14047a184 40 53           PUSH       RBX
       14047a186 56              PUSH       RSI
       14047a187 57              PUSH       RDI
       14047a188 41 56           PUSH       R14
       14047a18a 41 57           PUSH       R15
       14047a18c 48 83 ec 50     SUB        RSP,0x50
       14047a190 48 8b d9        MOV        RBX,RCX
       14047a193 33 f6           XOR        ESI,ESI
       14047a195 65 4c 8b        MOV        R14,qword ptr GS:[0x188]
                 34 25 88 
                 01 00 00
       14047a19e 41 8a 86        MOV        AL,byte ptr [R14 + 0x6c4]
                 c4 06 00 00
       14047a1a5 84 c0           TEST       AL,AL
       14047a1a7 0f 88 e9        JS         LAB_14047a396
                 01 00 00
       14047a1ad a8 03           TEST       AL,0x3
       14047a1af 0f 85 e1        JNZ        LAB_14047a396
                 01 00 00
       14047a1b5 e8 46 10        CALL       KeIsAttachedProcess                              undefined KeIsAttachedProcess()
                 bf ff
       14047a1ba 84 c0           TEST       AL,AL
       14047a1bc 0f 85 d4        JNZ        LAB_14047a396
                 01 00 00
       14047a1c2 49 8b 96        MOV        RDX,qword ptr [R14 + 0xf0]
                 f0 00 00 00
       14047a1c9 4c 8b 42 08     MOV        R8,qword ptr [RDX + 0x8]
       14047a1cd 4c 89 44        MOV        qword ptr [RSP + local_40],R8
                 24 38
       14047a1d2 48 8b 82        MOV        RAX,qword ptr [RDX + 0x1478]
                 78 14 00 00
       14047a1d9 48 89 44        MOV        qword ptr [RSP + local_38],RAX
                 24 40
       14047a1de 8b 8a 48        MOV        ECX,dword ptr [RDX + 0x1748]
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
   --> 14047a267 8b 82 bc        MOV        EAX,dword ptr [RDX + 0xbc]
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

`````



`MOV        R14,qword ptr GS:[0x188]`

GS:[0x188]是_KTHREAD，

_KTHREAD+0xb8是什么结构没搞清楚。落在nt!_KTHREAD结构的ApcStateFill里，但这个定义为char[43]。

后来调用windbg调了下，这个_KTHREAD+0xb8虽然结构里给出的位值很奇怪，但实际上这是个_EPROCESS指针。

_EPROCESS+0x3f8指向_PEB。

又调上这个了，过了十来年，又重操旧业。。。

这个不继续看下去了，PEB里的东西自然是user-mode的。


`````shell

kd> dt nt!_KTHREAD
   +0x000 Header           : _DISPATCHER_HEADER
   +0x018 SListFaultAddress : Ptr64 Void
   +0x020 QuantumTarget    : Uint8B
   +0x028 InitialStack     : Ptr64 Void
   +0x030 StackLimit       : Ptr64 Void
   +0x038 StackBase        : Ptr64 Void
   +0x040 ThreadLock       : Uint8B
   +0x048 CycleTime        : Uint8B
   +0x050 CurrentRunTime   : Uint4B
   +0x054 ExpectedRunTime  : Uint4B
   +0x058 KernelStack      : Ptr64 Void
   +0x060 StateSaveArea    : Ptr64 _XSAVE_FORMAT
   +0x068 SchedulingGroup  : Ptr64 _KSCHEDULING_GROUP
   +0x070 WaitRegister     : _KWAIT_STATUS_REGISTER
   +0x071 Running          : UChar
   +0x072 Alerted          : [2] UChar
   +0x074 AutoBoostActive  : Pos 0, 1 Bit
   +0x074 ReadyTransition  : Pos 1, 1 Bit
   +0x074 WaitNext         : Pos 2, 1 Bit
   +0x074 SystemAffinityActive : Pos 3, 1 Bit
   +0x074 Alertable        : Pos 4, 1 Bit
   +0x074 UserStackWalkActive : Pos 5, 1 Bit
   +0x074 ApcInterruptRequest : Pos 6, 1 Bit
   +0x074 QuantumEndMigrate : Pos 7, 1 Bit
   +0x074 UmsDirectedSwitchEnable : Pos 8, 1 Bit
   +0x074 TimerActive      : Pos 9, 1 Bit
   +0x074 SystemThread     : Pos 10, 1 Bit
   +0x074 ProcessDetachActive : Pos 11, 1 Bit
   +0x074 CalloutActive    : Pos 12, 1 Bit
   +0x074 ScbReadyQueue    : Pos 13, 1 Bit
   +0x074 ApcQueueable     : Pos 14, 1 Bit
   +0x074 ReservedStackInUse : Pos 15, 1 Bit
   +0x074 UmsPerformingSyscall : Pos 16, 1 Bit
   +0x074 TimerSuspended   : Pos 17, 1 Bit
   +0x074 SuspendedWaitMode : Pos 18, 1 Bit
   +0x074 SuspendSchedulerApcWait : Pos 19, 1 Bit
   +0x074 Reserved         : Pos 20, 12 Bits
   +0x074 MiscFlags        : Int4B
   +0x078 AutoAlignment    : Pos 0, 1 Bit
   +0x078 DisableBoost     : Pos 1, 1 Bit
   +0x078 ThreadFlagsSpare0 : Pos 2, 1 Bit
   +0x078 AlertedByThreadId : Pos 3, 1 Bit
   +0x078 QuantumDonation  : Pos 4, 1 Bit
   +0x078 EnableStackSwap  : Pos 5, 1 Bit
   +0x078 GuiThread        : Pos 6, 1 Bit
   +0x078 DisableQuantum   : Pos 7, 1 Bit
   +0x078 ChargeOnlySchedulingGroup : Pos 8, 1 Bit
   +0x078 DeferPreemption  : Pos 9, 1 Bit
   +0x078 QueueDeferPreemption : Pos 10, 1 Bit
   +0x078 ForceDeferSchedule : Pos 11, 1 Bit
   +0x078 SharedReadyQueueAffinity : Pos 12, 1 Bit
   +0x078 FreezeCount      : Pos 13, 1 Bit
   +0x078 TerminationApcRequest : Pos 14, 1 Bit
   +0x078 AutoBoostEntriesExhausted : Pos 15, 1 Bit
   +0x078 KernelStackResident : Pos 16, 1 Bit
   +0x078 CommitFailTerminateRequest : Pos 17, 1 Bit
   +0x078 ProcessStackCountDecremented : Pos 18, 1 Bit
   +0x078 ThreadFlagsSpare : Pos 19, 5 Bits
   +0x078 EtwStackTraceApcInserted : Pos 24, 8 Bits
   +0x078 ThreadFlags      : Int4B
   +0x07c Tag              : UChar
   +0x07d SystemHeteroCpuPolicy : UChar
   +0x07e UserHeteroCpuPolicy : Pos 0, 7 Bits
   +0x07e ExplicitSystemHeteroCpuPolicy : Pos 7, 1 Bit
   +0x07f Spare0           : UChar
   +0x080 SystemCallNumber : Uint4B
   +0x084 Spare10          : Uint4B
   +0x088 FirstArgument    : Ptr64 Void
   +0x090 TrapFrame        : Ptr64 _KTRAP_FRAME
   +0x098 ApcState         : _KAPC_STATE
   +0x098 ApcStateFill     : [43] UChar
   +0x0c3 Priority         : Char
   +0x0c4 UserIdealProcessor : Uint4B
   +0x0c8 WaitStatus       : Int8B
   +0x0d0 WaitBlockList    : Ptr64 _KWAIT_BLOCK
   +0x0d8 WaitListEntry    : _LIST_ENTRY
   +0x0d8 SwapListEntry    : _SINGLE_LIST_ENTRY
   +0x0e8 Queue            : Ptr64 _DISPATCHER_HEADER
   +0x0f0 Teb              : Ptr64 Void
   +0x0f8 RelativeTimerBias : Uint8B
   +0x100 Timer            : _KTIMER
   +0x140 WaitBlock        : [4] _KWAIT_BLOCK
   +0x140 WaitBlockFill4   : [20] UChar
   +0x154 ContextSwitches  : Uint4B
   +0x140 WaitBlockFill5   : [68] UChar
   +0x184 State            : UChar
   +0x185 Spare13          : Char
   +0x186 WaitIrql         : UChar
   +0x187 WaitMode         : Char
   +0x140 WaitBlockFill6   : [116] UChar
   +0x1b4 WaitTime         : Uint4B
   +0x140 WaitBlockFill7   : [164] UChar
   +0x1e4 KernelApcDisable : Int2B
   +0x1e6 SpecialApcDisable : Int2B
   +0x1e4 CombinedApcDisable : Uint4B
   +0x140 WaitBlockFill8   : [40] UChar
   +0x168 ThreadCounters   : Ptr64 _KTHREAD_COUNTERS
   +0x140 WaitBlockFill9   : [88] UChar
   +0x198 XStateSave       : Ptr64 _XSTATE_SAVE
   +0x140 WaitBlockFill10  : [136] UChar
   +0x1c8 Win32Thread      : Ptr64 Void
   +0x140 WaitBlockFill11  : [176] UChar
   +0x1f0 Ucb              : Ptr64 _UMS_CONTROL_BLOCK
   +0x1f8 Uch              : Ptr64 _KUMS_CONTEXT_HEADER
   +0x200 TebMappedLowVa   : Ptr64 Void
   +0x208 QueueListEntry   : _LIST_ENTRY
   +0x218 NextProcessor    : Uint4B
   +0x218 NextProcessorNumber : Pos 0, 31 Bits
   +0x218 SharedReadyQueue : Pos 31, 1 Bit
   +0x21c QueuePriority    : Int4B
   +0x220 Process          : Ptr64 _KPROCESS
   +0x228 UserAffinity     : _GROUP_AFFINITY
   +0x228 UserAffinityFill : [10] UChar
   +0x232 PreviousMode     : Char
   +0x233 BasePriority     : Char
   +0x234 PriorityDecrement : Char
   +0x234 ForegroundBoost  : Pos 0, 4 Bits
   +0x234 UnusualBoost     : Pos 4, 4 Bits
   +0x235 Preempted        : UChar
   +0x236 AdjustReason     : UChar
   +0x237 AdjustIncrement  : Char
   +0x238 AffinityVersion  : Uint8B
   +0x240 Affinity         : _GROUP_AFFINITY
   +0x240 AffinityFill     : [10] UChar
   +0x24a ApcStateIndex    : UChar
   +0x24b WaitBlockCount   : UChar
   +0x24c IdealProcessor   : Uint4B
   +0x250 NpxState         : Uint8B
   +0x258 SavedApcState    : _KAPC_STATE
   +0x258 SavedApcStateFill : [43] UChar
   +0x283 WaitReason       : UChar
   +0x284 SuspendCount     : Char
   +0x285 Saturation       : Char
   +0x286 SListFaultCount  : Uint2B
   +0x288 SchedulerApc     : _KAPC
   +0x288 SchedulerApcFill0 : [1] UChar
   +0x289 ResourceIndex    : UChar
   +0x288 SchedulerApcFill1 : [3] UChar
   +0x28b QuantumReset     : UChar
   +0x288 SchedulerApcFill2 : [4] UChar
   +0x28c KernelTime       : Uint4B
   +0x288 SchedulerApcFill3 : [64] UChar
   +0x2c8 WaitPrcb         : Ptr64 _KPRCB
   +0x288 SchedulerApcFill4 : [72] UChar
   +0x2d0 LegoData         : Ptr64 Void
   +0x288 SchedulerApcFill5 : [83] UChar
   +0x2db CallbackNestingLevel : UChar
   +0x2dc UserTime         : Uint4B
   +0x2e0 SuspendEvent     : _KEVENT
   +0x2f8 ThreadListEntry  : _LIST_ENTRY
   +0x308 MutantListHead   : _LIST_ENTRY
   +0x318 AbEntrySummary   : UChar
   +0x319 AbWaitEntryCount : UChar
   +0x31a Spare20          : Uint2B
   +0x31c SecureThreadCookie : Uint4B
   +0x320 LockEntries      : [6] _KLOCK_ENTRY
   +0x560 PropagateBoostsEntry : _SINGLE_LIST_ENTRY
   +0x568 IoSelfBoostsEntry : _SINGLE_LIST_ENTRY
   +0x570 PriorityFloorCounts : [16] UChar
   +0x580 PriorityFloorSummary : Uint4B
   +0x584 AbCompletedIoBoostCount : Int4B
   +0x588 KeReferenceCount : Int2B
   +0x58a AbOrphanedEntrySummary : UChar
   +0x58b AbOwnedEntryCount : UChar
   +0x58c ForegroundLossTime : Uint4B
   +0x590 GlobalForegroundListEntry : _LIST_ENTRY
   +0x590 ForegroundDpcStackListEntry : _SINGLE_LIST_ENTRY
   +0x598 InGlobalForegroundList : Uint8B
   +0x5a0 ReadOperationCount : Int8B
   +0x5a8 WriteOperationCount : Int8B
   +0x5b0 OtherOperationCount : Int8B
   +0x5b8 ReadTransferCount : Int8B
   +0x5c0 WriteTransferCount : Int8B
   +0x5c8 OtherTransferCount : Int8B
   +0x5d0 QueuedScb        : Ptr64 _KSCB





kd> !process 0 0
**** NT ACTIVE PROCESS DUMP ****
PROCESS ffffe000ab060040
    SessionId: none  Cid: 0004    Peb: 00000000  ParentCid: 0000
    DirBase: 001aa000  ObjectTable: ffffc0014ea14000  HandleCount: <Data Not Accessible>
    Image: System

PROCESS ffffe000ac480040
    SessionId: none  Cid: 010c    Peb: ec5278000  ParentCid: 0004
    DirBase: 72ee5000  ObjectTable: ffffc0014ef3ebc0  HandleCount: <Data Not Accessible>
    Image: smss.exe

PROCESS ffffe000ad7be080
    SessionId: 0  Cid: 0158    Peb: e20dafe000  ParentCid: 0150
    DirBase: 0199c000  ObjectTable: ffffc0015653e280  HandleCount: <Data Not Accessible>
    Image: csrss.exe

PROCESS ffffe000ad973080
    SessionId: 0  Cid: 01a0    Peb: a530ea7000  ParentCid: 0150
    DirBase: 7a3c4000  ObjectTable: ffffc0014fa259c0  HandleCount: <Data Not Accessible>
    Image: wininit.exe

PROCESS ffffe000ad7b6080
    SessionId: 1  Cid: 01ac    Peb: 542d0f7000  ParentCid: 0198
    DirBase: 7a34c000  ObjectTable: ffffc0014fa31280  HandleCount: <Data Not Accessible>
    Image: csrss.exe

PROCESS ffffe000ac4f0840
    SessionId: 1  Cid: 01d4    Peb: 4bdaf0a000  ParentCid: 0198
    DirBase: 79752000  ObjectTable: ffffc0014fa3fa00  HandleCount: <Data Not Accessible>
    Image: winlogon.exe

PROCESS ffffe000ad9e61c0
    SessionId: 0  Cid: 0218    Peb: 85bafcf000  ParentCid: 01a0
    DirBase: 789e4000  ObjectTable: ffffc0014fa47800  HandleCount: <Data Not Accessible>
    Image: services.exe

PROCESS ffffe000ad9f2080
    SessionId: 0  Cid: 0220    Peb: ccaf5cc000  ParentCid: 01a0
    DirBase: 78bc2000  ObjectTable: ffffc0014faf3540  HandleCount: <Data Not Accessible>
    Image: lsass.exe

PROCESS ffffe000ad9a8840
    SessionId: 0  Cid: 0260    Peb: 2e7c4b5000  ParentCid: 0218
    DirBase: 771fe000  ObjectTable: ffffc0014fb78300  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000adcb9840
    SessionId: 0  Cid: 0280    Peb: a1a89f5000  ParentCid: 0218
    DirBase: 76dd2000  ObjectTable: ffffc0014fbe1800  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000add3e080
    SessionId: 1  Cid: 0304    Peb: ac336e8000  ParentCid: 01d4
    DirBase: 7582c000  ObjectTable: ffffc0014fc51200  HandleCount: <Data Not Accessible>
    Image: dwm.exe

PROCESS ffffe000add90640
    SessionId: 0  Cid: 0354    Peb: 1007abd000  ParentCid: 0218
    DirBase: 74cbf000  ObjectTable: ffffc0014fd70d80  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000add8b840
    SessionId: 0  Cid: 0368    Peb: a6bdac5000  ParentCid: 0218
    DirBase: 74805000  ObjectTable: ffffc0014fd8e040  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000addc0840
    SessionId: 0  Cid: 039c    Peb: ad7c65e000  ParentCid: 0218
    DirBase: 742bd000  ObjectTable: ffffc0014fda8700  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000addd1840
    SessionId: 0  Cid: 03b4    Peb: e50c35b000  ParentCid: 0218
    DirBase: 74091000  ObjectTable: ffffc0014fcbb3c0  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000ade01840
    SessionId: 0  Cid: 03dc    Peb: 00214000  ParentCid: 0218
    DirBase: 7275d000  ObjectTable: ffffc0014fc92800  HandleCount: <Data Not Accessible>
    Image: VBoxService.exe

PROCESS ffffe000addcc840
    SessionId: 0  Cid: 00f0    Peb: f5f9922000  ParentCid: 0218
    DirBase: 72205000  ObjectTable: ffffc0014fd56d40  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000ade29840
    SessionId: 0  Cid: 0170    Peb: f8670ab000  ParentCid: 0218
    DirBase: 717b4000  ObjectTable: ffffc0014fe36e40  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000ab093080
    SessionId: 0  Cid: 0448    Peb: 9d68b63000  ParentCid: 0218
    DirBase: 6c70b000  ObjectTable: ffffc00150015940  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000ada1a840
    SessionId: 0  Cid: 04c4    Peb: 003dc000  ParentCid: 0218
    DirBase: 6b89d000  ObjectTable: ffffc00150097f40  HandleCount: <Data Not Accessible>
    Image: spoolsv.exe

PROCESS ffffe000ada6f840
    SessionId: 0  Cid: 0548    Peb: cf4015e000  ParentCid: 0218
    DirBase: 69f25000  ObjectTable: ffffc0014ffd4380  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000adbb0840
    SessionId: 0  Cid: 05f0    Peb: 544d93f000  ParentCid: 0218
    DirBase: 674b8000  ObjectTable: ffffc001501f8880  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000adbf7840
    SessionId: 0  Cid: 0664    Peb: f143062000  ParentCid: 0218
    DirBase: 66b31000  ObjectTable: ffffc001501e5900  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000adbd5840
    SessionId: 0  Cid: 066c    Peb: 7660e52000  ParentCid: 0218
    DirBase: 66bc2000  ObjectTable: ffffc001501fce40  HandleCount: <Data Not Accessible>
    Image: MsMpEng.exe

PROCESS ffffe000ae198840
    SessionId: 0  Cid: 0588    Peb: 9afc07a000  ParentCid: 0218
    DirBase: 58098000  ObjectTable: ffffc001506cc440  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000adbb8080
    SessionId: 0  Cid: 0564    Peb: 23b4ddf000  ParentCid: 0218
    DirBase: 5ea61000  ObjectTable: ffffc001506f9500  HandleCount: <Data Not Accessible>
    Image: NisSrv.exe

PROCESS ffffe000ab228840
    SessionId: 1  Cid: 08bc    Peb: ce6f113000  ParentCid: 0354
    DirBase: 750eb000  ObjectTable: ffffc00150a6cd40  HandleCount: <Data Not Accessible>
    Image: taskhostw.exe

PROCESS ffffe000ae00f840
    SessionId: 1  Cid: 08fc    Peb: 30b87a1000  ParentCid: 0354
    DirBase: 576f7000  ObjectTable: ffffc00150a75f40  HandleCount: <Data Not Accessible>
    Image: sihost.exe

PROCESS ffffe000ae29e840
    SessionId: 1  Cid: 09c8    Peb: f79cc99000  ParentCid: 0260
    DirBase: 56cfc000  ObjectTable: ffffc00150a58d40  HandleCount: <Data Not Accessible>
    Image: RuntimeBroker.exe

PROCESS ffffe000ab213840
    SessionId: 1  Cid: 09f4    Peb: 3fc5003000  ParentCid: 01d4
    DirBase: 56854000  ObjectTable: 00000000  HandleCount:   0.
    Image: userinit.exe

PROCESS ffffe000ae2fa500
    SessionId: 1  Cid: 0a08    Peb: 003bd000  ParentCid: 09f4
    DirBase: 565e3000  ObjectTable: ffffc00150bf98c0  HandleCount: <Data Not Accessible>
    Image: explorer.exe

PROCESS ffffe000ae2e0840
    SessionId: 1  Cid: 0a28    Peb: 00563000  ParentCid: 0260
    DirBase: 5627d000  ObjectTable: ffffc00150c509c0  HandleCount: <Data Not Accessible>
    Image: SkypeHost.exe

PROCESS ffffe000ae377840
    SessionId: 0  Cid: 0ac4    Peb: 804aad2000  ParentCid: 0218
    DirBase: 54d50000  ObjectTable: ffffc00150cffcc0  HandleCount: <Data Not Accessible>
    Image: SearchIndexer.exe

PROCESS ffffe000ae3b0600
    SessionId: 1  Cid: 0b48    Peb: 37ac40f000  ParentCid: 0260
    DirBase: 53add000  ObjectTable: ffffc00150c0b2c0  HandleCount: <Data Not Accessible>
    Image: ShellExperienceHost.exe

PROCESS ffffe000ae482340
    SessionId: 1  Cid: 0bc4    Peb: 6cd1e11000  ParentCid: 0260
    DirBase: 516e3000  ObjectTable: ffffc00150e343c0  HandleCount: <Data Not Accessible>
    Image: SearchUI.exe

PROCESS ffffe000ac5b8840
    SessionId: 1  Cid: 0d88    Peb: 002ee000  ParentCid: 0a08
    DirBase: 78ad2000  ObjectTable: ffffc0015129f1c0  HandleCount: <Data Not Accessible>
    Image: VBoxTray.exe

PROCESS ffffe000ac520840
    SessionId: 1  Cid: 0da8    Peb: 00350000  ParentCid: 0a08
    DirBase: 24257000  ObjectTable: ffffc001512b2d00  HandleCount: <Data Not Accessible>
    Image: OneDrive.exe

PROCESS ffffe000ae399080
    SessionId: 1  Cid: 0ac0    Peb: f2c7f3f000  ParentCid: 0218
    DirBase: 0102d000  ObjectTable: ffffc001511c3e40  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000ae431840
    SessionId: 0  Cid: 0f60    Peb: f275a9e000  ParentCid: 0ac4
    DirBase: 54e4c000  ObjectTable: ffffc00151591200  HandleCount: <Data Not Accessible>
    Image: SearchProtocolHost.exe

PROCESS ffffe000abad8840
    SessionId: 0  Cid: 031c    Peb: f9f5648000  ParentCid: 0ac4
    DirBase: 483a2000  ObjectTable: ffffc00150050140  HandleCount: <Data Not Accessible>
    Image: SearchFilterHost.exe

PROCESS ffffe000abac0840
    SessionId: 0  Cid: 0fcc    Peb: 62d1f03000  ParentCid: 00f0
    DirBase: 4ace1000  ObjectTable: ffffc00151670140  HandleCount: <Data Not Accessible>
    Image: audiodg.exe

kd> g
Break instruction exception - code 80000003 (first chance)
*******************************************************************************
*                                                                             *
*   You are seeing this message because you pressed either                    *
*       CTRL+C (if you run kd.exe) or,                                        *
*       CTRL+BREAK (if you run WinDBG),                                       *
*   on your debugger machine's keyboard.                                      *
*                                                                             *
*                   THIS IS NOT A BUG OR A SYSTEM CRASH                       *
*                                                                             *
* If you did not intend to break into the debugger, press the "g" key, then   *
* press the "Enter" key now.  This message might immediately reappear.  If it *
* does, press "g" and "Enter" again.                                          *
*                                                                             *
*******************************************************************************
nt!DbgBreakPointWithStatus:
fffff800`9cfc06d0 cc              int     3
kd> !process 0 0
**** NT ACTIVE PROCESS DUMP ****
PROCESS ffffe000ab060040
    SessionId: none  Cid: 0004    Peb: 00000000  ParentCid: 0000
    DirBase: 001aa000  ObjectTable: ffffc0014ea14000  HandleCount: <Data Not Accessible>
    Image: System

PROCESS ffffe000ac480040
    SessionId: none  Cid: 010c    Peb: ec5278000  ParentCid: 0004
    DirBase: 72ee5000  ObjectTable: ffffc0014ef3ebc0  HandleCount: <Data Not Accessible>
    Image: smss.exe

PROCESS ffffe000ad7be080
    SessionId: 0  Cid: 0158    Peb: e20dafe000  ParentCid: 0150
    DirBase: 0199c000  ObjectTable: ffffc0015653e280  HandleCount: <Data Not Accessible>
    Image: csrss.exe

PROCESS ffffe000ad973080
    SessionId: 0  Cid: 01a0    Peb: a530ea7000  ParentCid: 0150
    DirBase: 7a3c4000  ObjectTable: ffffc0014fa259c0  HandleCount: <Data Not Accessible>
    Image: wininit.exe

PROCESS ffffe000ad7b6080
    SessionId: 1  Cid: 01ac    Peb: 542d0f7000  ParentCid: 0198
    DirBase: 7a34c000  ObjectTable: ffffc0014fa31280  HandleCount: <Data Not Accessible>
    Image: csrss.exe

PROCESS ffffe000ac4f0840
    SessionId: 1  Cid: 01d4    Peb: 4bdaf0a000  ParentCid: 0198
    DirBase: 79752000  ObjectTable: ffffc0014fa3fa00  HandleCount: <Data Not Accessible>
    Image: winlogon.exe

PROCESS ffffe000ad9e61c0
    SessionId: 0  Cid: 0218    Peb: 85bafcf000  ParentCid: 01a0
    DirBase: 789e4000  ObjectTable: ffffc0014fa47800  HandleCount: <Data Not Accessible>
    Image: services.exe

PROCESS ffffe000ad9f2080
    SessionId: 0  Cid: 0220    Peb: ccaf5cc000  ParentCid: 01a0
    DirBase: 78bc2000  ObjectTable: ffffc0014faf3540  HandleCount: <Data Not Accessible>
    Image: lsass.exe

PROCESS ffffe000ad9a8840
    SessionId: 0  Cid: 0260    Peb: 2e7c4b5000  ParentCid: 0218
    DirBase: 771fe000  ObjectTable: ffffc0014fb78300  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000adcb9840
    SessionId: 0  Cid: 0280    Peb: a1a89f5000  ParentCid: 0218
    DirBase: 76dd2000  ObjectTable: ffffc0014fbe1800  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000add3e080
    SessionId: 1  Cid: 0304    Peb: ac336e8000  ParentCid: 01d4
    DirBase: 7582c000  ObjectTable: ffffc0014fc51200  HandleCount: <Data Not Accessible>
    Image: dwm.exe

PROCESS ffffe000add90640
    SessionId: 0  Cid: 0354    Peb: 1007abd000  ParentCid: 0218
    DirBase: 74cbf000  ObjectTable: ffffc0014fd70d80  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000add8b840
    SessionId: 0  Cid: 0368    Peb: a6bdac5000  ParentCid: 0218
    DirBase: 74805000  ObjectTable: ffffc0014fd8e040  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000addc0840
    SessionId: 0  Cid: 039c    Peb: ad7c65e000  ParentCid: 0218
    DirBase: 742bd000  ObjectTable: ffffc0014fda8700  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000addd1840
    SessionId: 0  Cid: 03b4    Peb: e50c35b000  ParentCid: 0218
    DirBase: 74091000  ObjectTable: ffffc0014fcbb3c0  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000ade01840
    SessionId: 0  Cid: 03dc    Peb: 00214000  ParentCid: 0218
    DirBase: 7275d000  ObjectTable: ffffc0014fc92800  HandleCount: <Data Not Accessible>
    Image: VBoxService.exe

PROCESS ffffe000addcc840
    SessionId: 0  Cid: 00f0    Peb: f5f9922000  ParentCid: 0218
    DirBase: 72205000  ObjectTable: ffffc0014fd56d40  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000ade29840
    SessionId: 0  Cid: 0170    Peb: f8670ab000  ParentCid: 0218
    DirBase: 717b4000  ObjectTable: ffffc0014fe36e40  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000ab093080
    SessionId: 0  Cid: 0448    Peb: 9d68b63000  ParentCid: 0218
    DirBase: 6c70b000  ObjectTable: ffffc00150015940  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000ada1a840
    SessionId: 0  Cid: 04c4    Peb: 003dc000  ParentCid: 0218
    DirBase: 6b89d000  ObjectTable: ffffc00150097f40  HandleCount: <Data Not Accessible>
    Image: spoolsv.exe

PROCESS ffffe000adbb0840
    SessionId: 0  Cid: 05f0    Peb: 544d93f000  ParentCid: 0218
    DirBase: 674b8000  ObjectTable: ffffc001501f8880  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000adbf7840
    SessionId: 0  Cid: 0664    Peb: f143062000  ParentCid: 0218
    DirBase: 66b31000  ObjectTable: ffffc001501e5900  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000adbd5840
    SessionId: 0  Cid: 066c    Peb: 7660e52000  ParentCid: 0218
    DirBase: 66bc2000  ObjectTable: ffffc001501fce40  HandleCount: <Data Not Accessible>
    Image: MsMpEng.exe

PROCESS ffffe000ae198840
    SessionId: 0  Cid: 0588    Peb: 9afc07a000  ParentCid: 0218
    DirBase: 58098000  ObjectTable: ffffc001506cc440  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000adbb8080
    SessionId: 0  Cid: 0564    Peb: 23b4ddf000  ParentCid: 0218
    DirBase: 5ea61000  ObjectTable: ffffc001506f9500  HandleCount: <Data Not Accessible>
    Image: NisSrv.exe

PROCESS ffffe000ab228840
    SessionId: 1  Cid: 08bc    Peb: ce6f113000  ParentCid: 0354
    DirBase: 750eb000  ObjectTable: ffffc00150a6cd40  HandleCount: <Data Not Accessible>
    Image: taskhostw.exe

PROCESS ffffe000ae00f840
    SessionId: 1  Cid: 08fc    Peb: 30b87a1000  ParentCid: 0354
    DirBase: 576f7000  ObjectTable: ffffc00150a75f40  HandleCount: <Data Not Accessible>
    Image: sihost.exe

PROCESS ffffe000ae29e840
    SessionId: 1  Cid: 09c8    Peb: f79cc99000  ParentCid: 0260
    DirBase: 56cfc000  ObjectTable: ffffc00150a58d40  HandleCount: <Data Not Accessible>
    Image: RuntimeBroker.exe

PROCESS ffffe000ab213840
    SessionId: 1  Cid: 09f4    Peb: 3fc5003000  ParentCid: 01d4
    DirBase: 56854000  ObjectTable: 00000000  HandleCount:   0.
    Image: userinit.exe

PROCESS ffffe000ae2fa500
    SessionId: 1  Cid: 0a08    Peb: 003bd000  ParentCid: 09f4
    DirBase: 565e3000  ObjectTable: ffffc00150bf98c0  HandleCount: <Data Not Accessible>
    Image: explorer.exe

PROCESS ffffe000ae2e0840
    SessionId: 1  Cid: 0a28    Peb: 00563000  ParentCid: 0260
    DirBase: 5627d000  ObjectTable: ffffc00150c509c0  HandleCount: <Data Not Accessible>
    Image: SkypeHost.exe

PROCESS ffffe000ae377840
    SessionId: 0  Cid: 0ac4    Peb: 804aad2000  ParentCid: 0218
    DirBase: 54d50000  ObjectTable: ffffc00150cffcc0  HandleCount: <Data Not Accessible>
    Image: SearchIndexer.exe

PROCESS ffffe000ae3b0600
    SessionId: 1  Cid: 0b48    Peb: 37ac40f000  ParentCid: 0260
    DirBase: 53add000  ObjectTable: ffffc00150c0b2c0  HandleCount: <Data Not Accessible>
    Image: ShellExperienceHost.exe

PROCESS ffffe000ae482340
    SessionId: 1  Cid: 0bc4    Peb: 6cd1e11000  ParentCid: 0260
    DirBase: 516e3000  ObjectTable: ffffc00150e343c0  HandleCount: <Data Not Accessible>
    Image: SearchUI.exe

PROCESS ffffe000ac5b8840
    SessionId: 1  Cid: 0d88    Peb: 002ee000  ParentCid: 0a08
    DirBase: 78ad2000  ObjectTable: ffffc0015129f1c0  HandleCount: <Data Not Accessible>
    Image: VBoxTray.exe

PROCESS ffffe000ac520840
    SessionId: 1  Cid: 0da8    Peb: 00350000  ParentCid: 0a08
    DirBase: 24257000  ObjectTable: ffffc001512b2d00  HandleCount: <Data Not Accessible>
    Image: OneDrive.exe

PROCESS ffffe000ae399080
    SessionId: 1  Cid: 0ac0    Peb: f2c7f3f000  ParentCid: 0218
    DirBase: 0102d000  ObjectTable: ffffc001511c3e40  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000ae431840
    SessionId: 0  Cid: 0f60    Peb: f275a9e000  ParentCid: 0ac4
    DirBase: 54e4c000  ObjectTable: ffffc00151591200  HandleCount: <Data Not Accessible>
    Image: SearchProtocolHost.exe

PROCESS ffffe000abad8840
    SessionId: 0  Cid: 031c    Peb: f9f5648000  ParentCid: 0ac4
    DirBase: 483a2000  ObjectTable: ffffc00150050140  HandleCount: <Data Not Accessible>
    Image: SearchFilterHost.exe

PROCESS ffffe000abac0840
    SessionId: 0  Cid: 0fcc    Peb: 62d1f03000  ParentCid: 00f0
    DirBase: 4ace1000  ObjectTable: ffffc00151670140  HandleCount: <Data Not Accessible>
    Image: audiodg.exe

PROCESS ffffe000adb572c0
    SessionId: 1  Cid: 0590    Peb: 93acec7000  ParentCid: 0a08
    DirBase: 7bd57000  ObjectTable: ffffc0014ffd4380  HandleCount: <Data Not Accessible>
    Image: notepad.exe

kd> .process ffffe000adb572c0
Implicit process is now ffffe000`adb572c0
WARNING: .cache forcedecodeuser is not enabled
kd> g
Break instruction exception - code 80000003 (first chance)
*******************************************************************************
*                                                                             *
*   You are seeing this message because you pressed either                    *
*       CTRL+C (if you run kd.exe) or,                                        *
*       CTRL+BREAK (if you run WinDBG),                                       *
*   on your debugger machine's keyboard.                                      *
*                                                                             *
*                   THIS IS NOT A BUG OR A SYSTEM CRASH                       *
*                                                                             *
* If you did not intend to break into the debugger, press the "g" key, then   *
* press the "Enter" key now.  This message might immediately reappear.  If it *
* does, press "g" and "Enter" again.                                          *
*                                                                             *
*******************************************************************************
nt!DbgBreakPointWithStatus:
fffff800`9cfc06d0 cc              int     3
kd> .process ffffe000adb572c0
Implicit process is now ffffe000`adb572c0
WARNING: .cache forcedecodeuser is not enabled
kd> .process
Implicit process is now ffffe000`ab060040
kd> .process /i ffffe000adb572c0
You need to continue execution (press 'g' <enter>) for the context
to be switched. When the debugger breaks in again, you will be in
the new process context.
kd> g
Break instruction exception - code 80000003 (first chance)
nt!DbgBreakPointWithStatus:
fffff800`9cfc06d0 cc              int     3
kd> .process
Implicit process is now ffffe000`adb572c0
kd> dq gs:0x188
002b:00000000`00000188  ffffe000`abb83340 00000000`00000000
002b:00000000`00000198  fffff800`9d20c740 00000000`01010100
002b:00000000`000001a8  ffffd000`3773ddd0 00000000`00000000
002b:00000000`000001b8  fffff800`9d19c890 00000000`80050031
002b:00000000`000001c8  00000000`0511efe8 00000000`7bd57000
002b:00000000`000001d8  00000000`000006f8 00000000`00000000
002b:00000000`000001e8  00000000`00000000 00000000`00000000
002b:00000000`000001f8  00000000`00000000 00000000`ffff0ff0
kd> dq ffffe000`abb83340+b8
ffffe000`abb833f8  ffffe000`adb572c0 00000000`0c000000
ffffe000`abb83408  fffff800`9d14bf00 ffffe000`abb83480
ffffe000`abb83418  fffff800`9d19bb40 fffff800`9d19bb40
ffffe000`abb83428  fffff800`9d20c340 00000000`00000000
ffffe000`abb83438  00000000`00000000 00000000`00e80008
ffffe000`abb83448  ffffe000`abb83510 ffffe000`abb83510
ffffe000`abb83458  00000000`8ba2831e ffffe000`ae3971a0
ffffe000`abb83468  fffff800`9d19b688 d8a0721f`e18b8764
kd> dq ffffe000`adb572c0+3f8
ffffe000`adb576b8  00000093`acec7000 ffffd000`39353000
ffffe000`adb576c8  00000000`00000000 ffffe000`adcb6340
ffffe000`adb576d8  ffffc001`4ffd4380 00000000`00000000
ffffe000`adb576e8  00000000`00000000 ffffc001`50732cf0
ffffe000`adb576f8  ffffe000`ad77fc21 00000000`00000000
ffffe000`adb57708  ffffe000`ae2c5db0 2e646170`65746f6e
ffffe000`adb57718  02000000`00657865 00000000`00000000
ffffe000`adb57728  ffffe000`ada58a80 00000000`00000000
kd> dq ffffe000`adb572c0+3f8
ffffe000`adb576b8  00000093`acec7000 ffffd000`39353000
ffffe000`adb576c8  00000000`00000000 ffffe000`adcb6340
ffffe000`adb576d8  ffffc001`4ffd4380 00000000`00000000
ffffe000`adb576e8  00000000`00000000 ffffc001`50732cf0
ffffe000`adb576f8  ffffe000`ad77fc21 00000000`00000000
ffffe000`adb57708  ffffe000`ae2c5db0 2e646170`65746f6e
ffffe000`adb57718  02000000`00657865 00000000`00000000
ffffe000`adb57728  ffffe000`ada58a80 00000000`00000000
kd> dt nt!_EPROCESS ffffe000`adb572c0
   +0x000 Pcb              : _KPROCESS
   +0x2d8 ProcessLock      : _EX_PUSH_LOCK
   +0x2e0 RundownProtect   : _EX_RUNDOWN_REF
   +0x2e8 UniqueProcessId  : 0x00000000`00000590 Void
   +0x2f0 ActiveProcessLinks : _LIST_ENTRY [ 0xfffff800`9d1521a0 - 0xffffe000`abac0b30 ]
   +0x300 Flags2           : 0x200d000
   +0x300 JobNotReallyActive : 0y0
   +0x300 AccountingFolded : 0y0
   +0x300 NewProcessReported : 0y0
   +0x300 ExitProcessReported : 0y0
   +0x300 ReportCommitChanges : 0y0
   +0x300 LastReportMemory : 0y0
   +0x300 ForceWakeCharge  : 0y0
   +0x300 CrossSessionCreate : 0y0
   +0x300 NeedsHandleRundown : 0y0
   +0x300 RefTraceEnabled  : 0y0
   +0x300 DisableDynamicCode : 0y0
   +0x300 EmptyJobEvaluated : 0y0
   +0x300 DefaultPagePriority : 0y101
   +0x300 PrimaryTokenFrozen : 0y1
   +0x300 ProcessVerifierTarget : 0y0
   +0x300 StackRandomizationDisabled : 0y0
   +0x300 AffinityPermanent : 0y0
   +0x300 AffinityUpdateEnable : 0y0
   +0x300 PropagateNode    : 0y0
   +0x300 ExplicitAffinity : 0y0
   +0x300 ProcessExecutionState : 0y00
   +0x300 DisallowStrippedImages : 0y0
   +0x300 HighEntropyASLREnabled : 0y1
   +0x300 ExtensionPointDisable : 0y0
   +0x300 ForceRelocateImages : 0y0
   +0x300 ProcessStateChangeRequest : 0y00
   +0x300 ProcessStateChangeInProgress : 0y0
   +0x300 DisallowWin32kSystemCalls : 0y0
   +0x304 Flags            : 0x144d0c11
   +0x304 CreateReported   : 0y1
   +0x304 NoDebugInherit   : 0y0
   +0x304 ProcessExiting   : 0y0
   +0x304 ProcessDelete    : 0y0
   +0x304 ControlFlowGuardEnabled : 0y1
   +0x304 VmDeleted        : 0y0
   +0x304 OutswapEnabled   : 0y0
   +0x304 Outswapped       : 0y0
   +0x304 FailFastOnCommitFail : 0y0
   +0x304 Wow64VaSpace4Gb  : 0y0
   +0x304 AddressSpaceInitialized : 0y11
   +0x304 SetTimerResolution : 0y0
   +0x304 BreakOnTermination : 0y0
   +0x304 DeprioritizeViews : 0y0
   +0x304 WriteWatch       : 0y0
   +0x304 ProcessInSession : 0y1
   +0x304 OverrideAddressSpace : 0y0
   +0x304 HasAddressSpace  : 0y1
   +0x304 LaunchPrefetched : 0y1
   +0x304 Background       : 0y0
   +0x304 VmTopDown        : 0y0
   +0x304 ImageNotifyDone  : 0y1
   +0x304 PdeUpdateNeeded  : 0y0
   +0x304 VdmAllowed       : 0y0
   +0x304 ProcessRundown   : 0y0
   +0x304 ProcessInserted  : 0y1
   +0x304 DefaultIoPriority : 0y010
   +0x304 ProcessSelfDelete : 0y0
   +0x304 SetTimerResolutionLink : 0y0
   +0x308 CreateTime       : _LARGE_INTEGER 0x1d89ffa`dcc90782
   +0x310 ProcessQuotaUsage : [2] 0x29e8
   +0x320 ProcessQuotaPeak : [2] 0x2b90
   +0x330 PeakVirtualSize  : 0x200`073ae000
   +0x338 VirtualSize      : 0x200`073ad000
   +0x340 SessionProcessLinks : _LIST_ENTRY [ 0xffffd000`39353010 - 0xffffe000`ae3993c0 ]
   +0x350 ExceptionPortData : 0xffffe000`ad96b090 Void
   +0x350 ExceptionPortValue : 0xffffe000`ad96b090
   +0x350 ExceptionPortState : 0y000
   +0x358 Token            : _EX_FAST_REF
   +0x360 WorkingSetPage   : 0xb9d3
   +0x368 AddressCreationLock : _EX_PUSH_LOCK
   +0x370 PageTableCommitmentLock : _EX_PUSH_LOCK
   +0x378 RotateInProgress : (null) 
   +0x380 ForkInProgress   : (null) 
   +0x388 CommitChargeJob  : (null) 
   +0x390 CloneRoot        : _RTL_AVL_TREE
   +0x398 NumberOfPrivatePages : 0x177
   +0x3a0 NumberOfLockedPages : 0
   +0x3a8 Win32Process     : 0xfffff901`43ea3c20 Void
   +0x3b0 Job              : (null) 
   +0x3b8 SectionObject    : 0xffffc001`501dcc10 Void
   +0x3c0 SectionBaseAddress : 0x00007ff6`8d390000 Void
   +0x3c8 Cookie           : 0x84c039f3
   +0x3d0 WorkingSetWatch  : (null) 
   +0x3d8 Win32WindowStation : 0x00000000`00000070 Void
   +0x3e0 InheritedFromUniqueProcessId : 0x00000000`00000a08 Void
   +0x3e8 LdtInformation   : (null) 
   +0x3f0 OwnerProcessId   : 0
   +0x3f8 Peb              : 0x00000093`acec7000 _PEB
   +0x400 Session          : 0xffffd000`39353000 Void
   +0x408 AweInfo          : (null) 
   +0x410 QuotaBlock       : 0xffffe000`adcb6340 _EPROCESS_QUOTA_BLOCK
   +0x418 ObjectTable      : 0xffffc001`4ffd4380 _HANDLE_TABLE
   +0x420 DebugPort        : (null) 
   +0x428 WoW64Process     : (null) 
   +0x430 DeviceMap        : 0xffffc001`50732cf0 Void
   +0x438 EtwDataSource    : 0xffffe000`ad77fc21 Void
   +0x440 PageDirectoryPte : 0
   +0x448 ImageFilePointer : 0xffffe000`ae2c5db0 _FILE_OBJECT
   +0x450 ImageFileName    : [15]  "notepad.exe"
   +0x45f PriorityClass    : 0x2 ''
   +0x460 SecurityPort     : (null) 
   +0x468 SeAuditProcessCreationInfo : _SE_AUDIT_PROCESS_CREATION_INFO
   +0x470 JobLinks         : _LIST_ENTRY [ 0x00000000`00000000 - 0x0 ]
   +0x480 HighestUserAddress : 0x00007fff`ffff0000 Void
   +0x488 ThreadListHead   : _LIST_ENTRY [ 0xffffe000`ae52aed0 - 0xffffe000`ab097710 ]
   +0x498 ActiveThreads    : 2
   +0x49c ImagePathHash    : 0xd8414f97
   +0x4a0 DefaultHardErrorProcessing : 1
   +0x4a4 LastThreadExitStatus : 0n0
   +0x4a8 PrefetchTrace    : _EX_FAST_REF
   +0x4b0 LockedPagesList  : (null) 
   +0x4b8 ReadOperationCount : _LARGE_INTEGER 0x0
   +0x4c0 WriteOperationCount : _LARGE_INTEGER 0x0
   +0x4c8 OtherOperationCount : _LARGE_INTEGER 0x0
   +0x4d0 ReadTransferCount : _LARGE_INTEGER 0x0
   +0x4d8 WriteTransferCount : _LARGE_INTEGER 0x0
   +0x4e0 OtherTransferCount : _LARGE_INTEGER 0x0
   +0x4e8 CommitChargeLimit : 0
   +0x4f0 CommitCharge     : 0x1de
   +0x4f8 CommitChargePeak : 0x1de
   +0x500 Vm               : _MMSUPPORT
   +0x5f8 MmProcessLinks   : _LIST_ENTRY [ 0xfffff800`9d174558 - 0xffffe000`abac0e38 ]
   +0x608 ModifiedPageCount : 3
   +0x60c ExitStatus       : 0n259
   +0x610 VadRoot          : _RTL_AVL_TREE
   +0x618 VadHint          : 0xffffe000`adb4d470 Void
   +0x620 VadCount         : 0x4e
   +0x628 VadPhysicalPages : 0
   +0x630 VadPhysicalPagesLimit : 0
   +0x638 AlpcContext      : _ALPC_PROCESS_CONTEXT
   +0x658 TimerResolutionLink : _LIST_ENTRY [ 0x00000000`00000000 - 0x0 ]
   +0x668 TimerResolutionStackRecord : (null) 
   +0x670 RequestedTimerResolution : 0
   +0x674 SmallestTimerResolution : 0
   +0x678 ExitTime         : _LARGE_INTEGER 0x0
   +0x680 InvertedFunctionTable : (null) 
   +0x688 InvertedFunctionTableLock : _EX_PUSH_LOCK
   +0x690 ActiveThreadsHighWatermark : 2
   +0x694 LargePrivateVadCount : 0
   +0x698 ThreadListLock   : _EX_PUSH_LOCK
   +0x6a0 WnfContext       : (null) 
   +0x6a8 Spare0           : 0
   +0x6b0 SignatureLevel   : 0 ''
   +0x6b1 SectionSignatureLevel : 0 ''
   +0x6b2 Protection       : _PS_PROTECTION
   +0x6b3 HangCount        : 0 ''
   +0x6b4 Flags3           : 0
   +0x6b4 Minimal          : 0y0
   +0x6b4 ReplacingPageRoot : 0y0
   +0x6b4 DisableNonSystemFonts : 0y0
   +0x6b4 AuditNonSystemFontLoading : 0y0
   +0x6b4 Crashed          : 0y0
   +0x6b4 JobVadsAreTracked : 0y0
   +0x6b4 VadTrackingDisabled : 0y0
   +0x6b4 AuxiliaryProcess : 0y0
   +0x6b4 SubsystemProcess : 0y0
   +0x6b4 IndirectCpuSets  : 0y0
   +0x6b4 InPrivate        : 0y0
   +0x6b4 ProhibitRemoteImageMap : 0y0
   +0x6b4 ProhibitLowILImageMap : 0y0
   +0x6b4 SignatureMitigationOptIn : 0y0
   +0x6b8 DeviceAsid       : 0n0
   +0x6c0 SvmData          : (null) 
   +0x6c8 SvmProcessLock   : _EX_PUSH_LOCK
   +0x6d0 SvmLock          : 0
   +0x6d8 SvmProcessDeviceListHead : _LIST_ENTRY [ 0xffffe000`adb57998 - 0xffffe000`adb57998 ]
   +0x6e8 LastFreezeInterruptTime : 0
   +0x6f0 DiskCounters     : 0xffffe000`adb57a48 _PROCESS_DISK_COUNTERS
   +0x6f8 PicoContext      : (null) 
   +0x700 TrustletIdentity : 0
   +0x708 KeepAliveCounter : 0
   +0x70c NoWakeKeepAliveCounter : 0
   +0x710 HighPriorityFaultsAllowed : 0
   +0x718 EnergyValues     : (null) 
   +0x720 VmContext        : (null) 
   +0x728 SequenceNumber   : 0x4a
   +0x730 CreateInterruptTime : 0x9d7f8aca
   +0x738 CreateUnbiasedInterruptTime : 0x9d7f8aca
   +0x740 TotalUnbiasedFrozenTime : 0
   +0x748 LastAppStateUpdateTime : 0x9d7f8aca
   +0x750 LastAppStateUptime : 0y0000000000000000000000000000000000000000000000000000000000000 (0)
   +0x750 LastAppState     : 0y000
   +0x758 SharedCommitCharge : 0x838
   +0x760 SharedCommitLock : _EX_PUSH_LOCK
   +0x768 SharedCommitLinks : _LIST_ENTRY [ 0xffffc001`501da7f8 - 0xffffc001`4f10d618 ]
   +0x778 AllowedCpuSets   : 0
   +0x780 DefaultCpuSets   : 0
   +0x778 AllowedCpuSetsIndirect : (null) 
   +0x780 DefaultCpuSetsIndirect : (null) 
kd> dt nt!_PEB 0x00000093`acec7000
   +0x000 InheritedAddressSpace : 0 ''
   +0x001 ReadImageFileExecOptions : 0 ''
   +0x002 BeingDebugged    : 0 ''
   +0x003 BitField         : 0x4 ''
   +0x003 ImageUsesLargePages : 0y0
   +0x003 IsProtectedProcess : 0y0
   +0x003 IsImageDynamicallyRelocated : 0y1
   +0x003 SkipPatchingUser32Forwarders : 0y0
   +0x003 IsPackagedProcess : 0y0
   +0x003 IsAppContainer   : 0y0
   +0x003 IsProtectedProcessLight : 0y0
   +0x003 SpareBits        : 0y0
   +0x004 Padding0         : [4]  ""
   +0x008 Mutant           : 0xffffffff`ffffffff Void
   +0x010 ImageBaseAddress : 0x00007ff6`8d390000 Void
   +0x018 Ldr              : 0x00007ff8`113b5200 _PEB_LDR_DATA
   +0x020 ProcessParameters : 0x0000023e`9a5712e0 _RTL_USER_PROCESS_PARAMETERS
   +0x028 SubSystemData    : (null) 
   +0x030 ProcessHeap      : 0x0000023e`9a570000 Void
   +0x038 FastPebLock      : 0x00007ff8`113b4e80 _RTL_CRITICAL_SECTION
   +0x040 AtlThunkSListPtr : (null) 
   +0x048 IFEOKey          : (null) 
   +0x050 CrossProcessFlags : 0
   +0x050 ProcessInJob     : 0y0
   +0x050 ProcessInitializing : 0y0
   +0x050 ProcessUsingVEH  : 0y0
   +0x050 ProcessUsingVCH  : 0y0
   +0x050 ProcessUsingFTH  : 0y0
   +0x050 ReservedBits0    : 0y000000000000000000000000000 (0)
   +0x054 Padding1         : [4]  ""
   +0x058 KernelCallbackTable : 0x00007ff8`0ebc2220 Void
   +0x058 UserSharedInfoPtr : 0x00007ff8`0ebc2220 Void
   +0x060 SystemReserved   : [1] 0
   +0x064 AtlThunkSListPtr32 : 0
   +0x068 ApiSetMap        : 0x0000023e`9a460000 Void
   +0x070 TlsExpansionCounter : 0
   +0x074 Padding2         : [4]  ""
   +0x078 TlsBitmap        : 0x00007ff8`113b52a0 Void
   +0x080 TlsBitmapBits    : [2] 0xffffffff
   +0x088 ReadOnlySharedMemoryBase : 0x00007ff6`8cb90000 Void
   +0x090 SparePvoid0      : (null) 
   +0x098 ReadOnlyStaticServerData : 0x00007ff6`8cb90720  -> (null) 
   +0x0a0 AnsiCodePageData : 0x00007ff6`8cc90000 Void
   +0x0a8 OemCodePageData  : 0x00007ff6`8cca0228 Void
   +0x0b0 UnicodeCaseTableData : 0x00007ff6`8ccb0650 Void
   +0x0b8 NumberOfProcessors : 1
   +0x0bc NtGlobalFlag     : 0
   +0x0c0 CriticalSectionTimeout : _LARGE_INTEGER 0xffffe86d`079b8000
   +0x0c8 HeapSegmentReserve : 0x100000
   +0x0d0 HeapSegmentCommit : 0x2000
   +0x0d8 HeapDeCommitTotalFreeThreshold : 0x10000
   +0x0e0 HeapDeCommitFreeBlockThreshold : 0x1000
   +0x0e8 NumberOfHeaps    : 4
   +0x0ec MaximumNumberOfHeaps : 0x10
   +0x0f0 ProcessHeaps     : 0x00007ff8`113b3ac0  -> 0x0000023e`9a570000 Void
   +0x0f8 GdiSharedHandleTable : 0x0000023e`9a840000 Void
   +0x100 ProcessStarterHelper : (null) 
   +0x108 GdiDCAttributeList : 0x14
   +0x10c Padding3         : [4]  ""
   +0x110 LoaderLock       : 0x00007ff8`113b21e0 _RTL_CRITICAL_SECTION
   +0x118 OSMajorVersion   : 0xa
   +0x11c OSMinorVersion   : 0
   +0x120 OSBuildNumber    : 0x295a
   +0x122 OSCSDVersion     : 0
   +0x124 OSPlatformId     : 2
   +0x128 ImageSubsystem   : 2
   +0x12c ImageSubsystemMajorVersion : 0xa
   +0x130 ImageSubsystemMinorVersion : 0
   +0x134 Padding4         : [4]  ""
   +0x138 ActiveProcessAffinityMask : 1
   +0x140 GdiHandleBuffer  : [60] 0
   +0x230 PostProcessInitRoutine : (null) 
   +0x238 TlsExpansionBitmap : 0x00007ff8`113b52c0 Void
   +0x240 TlsExpansionBitmapBits : [32] 1
   +0x2c0 SessionId        : 1
   +0x2c4 Padding5         : [4]  ""
   +0x2c8 AppCompatFlags   : _ULARGE_INTEGER 0x0
   +0x2d0 AppCompatFlagsUser : _ULARGE_INTEGER 0x0
   +0x2d8 pShimData        : 0x0000023e`9a4a0000 Void
   +0x2e0 AppCompatInfo    : (null) 
   +0x2e8 CSDVersion       : _UNICODE_STRING ""
   +0x2f8 ActivationContextData : 0x0000023e`9a490000 _ACTIVATION_CONTEXT_DATA
   +0x300 ProcessAssemblyStorageMap : 0x0000023e`9a5707f0 _ASSEMBLY_STORAGE_MAP
   +0x308 SystemDefaultActivationContextData : 0x0000023e`9a480000 _ACTIVATION_CONTEXT_DATA
   +0x310 SystemAssemblyStorageMap : (null) 
   +0x318 MinimumStackCommit : 0
   +0x320 FlsCallback      : 0x0000023e`9a5828d0 _FLS_CALLBACK_INFO
   +0x328 FlsListHead      : _LIST_ENTRY [ 0x0000023e`9a5824b0 - 0x23e`9a5824b0 ]
   +0x338 FlsBitmap        : 0x00007ff8`113b5310 Void
   +0x340 FlsBitmapBits    : [4] 0xf
   +0x350 FlsHighIndex     : 3
   +0x358 WerRegistrationData : (null) 
   +0x360 WerShipAssertPtr : (null) 
   +0x368 pUnused          : (null) 
   +0x370 pImageHeaderHash : (null) 
   +0x378 TracingFlags     : 0
   +0x378 HeapTracingEnabled : 0y0
   +0x378 CritSecTracingEnabled : 0y0
   +0x378 LibLoaderTracingEnabled : 0y0
   +0x378 SpareTracingBits : 0y00000000000000000000000000000 (0)
   +0x37c Padding6         : [4]  ""
   +0x380 CsrServerReadOnlySharedMemoryBase : 0x7ff7`3bcc0000
   +0x388 TppWorkerpListLock : 0
   +0x390 TppWorkerpList   : _LIST_ENTRY [ 0x00000093`acd9fa00 - 0x93`acd9fa00 ]
   +0x3a0 WaitOnAddressHashTable : [128] (null) 
kd> dq 00000093`acec7000+bc
00000093`acec70bc  079b8000`00000000 00100000`ffffe86d
00000093`acec70cc  00002000`00000000 00010000`00000000
00000093`acec70dc  00001000`00000000 00000004`00000000
00000093`acec70ec  113b3ac0`00000010 9a840000`00007ff8
00000093`acec70fc  00000000`0000023e 00000014`00000000
00000093`acec710c  113b21e0`00000000 0000000a`00007ff8
00000093`acec711c  0000295a`00000000 00000002`00000002
00000093`acec712c  00000000`0000000a 00000001`00000000 
`````


