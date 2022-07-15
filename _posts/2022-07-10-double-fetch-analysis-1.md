---
title: Double fetch case 1
published: true
---

`````shell
DOUBLE FETCH:   cr3 0xa9774000, syscall 0x88
   eip 0xfffff80179c9f8e1, user_address 0x13ee991bec8, user_data 0x7c000000, modrm 0x38, pc 0xfffff80179c9f9eb
   eip 0xfffff80179ca2b6e, user_address 0x13ee991bec8, user_data 0x7c000000, modrm 0x19, pc 0xfffff80179ca2bb8
DIFF EIP
`````


`````shell
                             LAB_1404159c2                                   XREF[1]:     140415989(j)  
       1404159c2 4c 8b 8c        MOV        param_4,qword ptr [RSP + param_7]
                 24 90 01 
                 00 00
       1404159ca 4d 85 c9        TEST       param_4,param_4
       1404159cd 0f 84 fe        JZ         LAB_140415ad1
                 00 00 00
       1404159d3 c6 44 24        MOV        byte ptr [RSP + local_108],0x1
                 50 01
       1404159d8 49 8b c1        MOV        RAX,param_4
       1404159db 48 8b 0d        MOV        param_1,qword ptr [MmUserProbeAddress]           = ??
                 1e 98 f6 ff
       1404159e2 4c 3b c9        CMP        param_4,param_1
       1404159e5 0f 83 1f        JNC        LAB_140415b0a
                 01 00 00
                             LAB_1404159eb                                   XREF[1]:     140415b0d(j)  
   --> 1404159eb 8b 38           MOV        EDI,dword ptr [RAX]
       1404159ed 81 fa 00        CMP        param_2,0x80000000
                 00 00 80
       1404159f3 0f 84 c0        JZ         LAB_140415ab9
                 00 00 00
       1404159f9 41 bf 08        MOV        R15D,0x8
                 00 00 00
       1404159ff 41 8b cf        MOV        param_1,R15D
       140415a02 8b c7           MOV        EAX,EDI
       140415a04 41 bb 20        MOV        R11D,0x20
                 00 00 00
       140415a0a 25 00 00        AND        EAX,0x80000000
                 00 80
       140415a0f 41 0f 45 cb     CMOVNZ     param_1,R11D
       140415a13 0f ba e7 1e     BT         EDI,0x1e
       140415a17 73 03           JNC        LAB_140415a1c
       140415a19 41 03 cb        ADD        param_1,R11D
                             LAB_140415a1c                                   XREF[1]:     140415a17(j)  
       140415a1c 0f ba e7 1d     BT         EDI,0x1d
       140415a20 73 03           JNC        LAB_140415a25
       140415a22 41 03 cb        ADD        param_1,R11D
                             LAB_140415a25                                   XREF[1]:     140415a20(j)  
       140415a25 0f ba e7 1c     BT         EDI,0x1c
       140415a29 73 03           JNC        LAB_140415a2e
       140415a2b 83 c1 18        ADD        param_1,0x18
                             LAB_140415a2e                                   XREF[1]:     140415a29(j)  
       140415a2e 0f ba e7 1b     BT         EDI,0x1b
       140415a32 73 03           JNC        LAB_140415a37
       140415a34 83 c1 18        ADD        param_1,0x18
                             LAB_140415a37                                   XREF[1]:     140415a32(j)  
       140415a37 0f ba e7 1a     BT         EDI,0x1a
       140415a3b 73 03           JNC        LAB_140415a40
       140415a3d 41 03 cf        ADD        param_1,R15D
                             LAB_140415a40                                   XREF[1]:     140415a3b(j)  
       140415a40 45 8b c7        MOV        param_3,R15D
`````



`````shell
       140418b7f 4d 85 f6        TEST       R14,R14
       140418b82 0f 84 57        JZ         LAB_140418edf
                 03 00 00
       140418b88 65 48 8b        MOV        RAX,qword ptr GS:[0x188]
                 04 25 88 
                 01 00 00
       140418b91 0f b6 88        MOVZX      param_1,byte ptr [RAX + 0x232]
                 32 02 00 00
       140418b98 84 c9           TEST       param_1,param_1
       140418b9a 0f 84 82        JZ         LAB_140418f22
                 03 00 00
       140418ba0 c6 44 24        MOV        byte ptr [RSP + local_38],0x0
                 30 00
       140418ba5 49 8b ce        MOV        param_1,R14
       140418ba8 48 8b 05        MOV        RAX,qword ptr [MmUserProbeAddress]               = ??
                 51 66 f6 ff
       140418baf 4c 3b f0        CMP        R14,RAX
       140418bb2 0f 83 e3        JNC        LAB_140418c9b
                 00 00 00
                             LAB_140418bb8                                   XREF[1]:     140418c9e(j)  
   --> 140418bb8 8b 19           MOV        EBX,dword ptr [param_1]
       140418bba 8b c7           MOV        EAX,EDI
       140418bbc 25 00 00        AND        EAX,0xc0000000
                 00 c0
       140418bc1 8b cb           MOV        param_1,EBX
       140418bc3 3d 00 00        CMP        EAX,0x80000000
                 00 80
       140418bc8 0f 84 ba        JZ         LAB_140418c88
                 00 00 00
       140418bce 41 bf 08        MOV        R15D,0x8
                 00 00 00
       140418bd4 41 8b c7        MOV        EAX,R15D
       140418bd7 41 ba 20        MOV        R10D,0x20
                 00 00 00
       140418bdd 81 e1 00        AND        param_1,0x80000000
                 00 00 80
       140418be3 41 0f 45 c2     CMOVNZ     EAX,R10D
       140418be7 0f ba e3 1e     BT         EBX,0x1e
       140418beb 73 03           JNC        LAB_140418bf0
       140418bed 41 03 c2        ADD        EAX,R10D
                             LAB_140418bf0                                   XREF[1]:     140418beb(j)  
       140418bf0 0f ba e3 1d     BT         EBX,0x1d
       140418bf4 73 03           JNC        LAB_140418bf9
       140418bf6 41 03 c2        ADD        EAX,R10D
                             LAB_140418bf9                                   XREF[1]:     140418bf4(j)  
       140418bf9 0f ba e3 1c     BT         EBX,0x1c
       140418bfd 73 03           JNC        LAB_140418c02
       140418bff 83 c0 18        ADD        EAX,0x18
                             LAB_140418c02                                   XREF[1]:     140418bfd(j)  
       140418c02 0f ba e3 1b     BT         EBX,0x1b
       140418c06 73 03           JNC        LAB_140418c0b
       140418c08 83 c0 18        ADD        EAX,0x18
                             LAB_140418c0b                                   XREF[1]:     140418c06(j)  
       140418c0b 0f ba e3 1a     BT         EBX,0x1a
       140418c0f 73 03           JNC        LAB_140418c14
       140418c11 41 03 c7        ADD        EAX,R15D
                             LAB_140418c14                                   XREF[1]:     140418c0f(j)  
       140418c14 41 8b cf        MOV        param_1,R15D
                             LAB_140418c17                                   XREF[1]:     140418c96(j)  
       140418c17 f7 c3 00        TEST       EBX,0xa0000000
                 00 00 a0
       140418c1d 74 3f           JZ         LAB_140418c5e
       140418c1f c6 44 24        MOV        byte ptr [RSP + local_38],0x1
                 30 01
`````

都是类似这样的一段代码

`````shell
      else {
        uVar15 = 8;
        if ((uVar8 & 0x80000000) != 0) {
          uVar15 = 0x20;
        }
        if ((uVar8 >> 0x1e & 1) != 0) {
          uVar15 = uVar15 + 0x20;
        }
        if ((uVar8 >> 0x1d & 1) != 0) {
          uVar15 = uVar15 + 0x20;
        }
        if ((uVar8 >> 0x1c & 1) != 0) {
          uVar15 = uVar15 + 0x18;
        }
        if ((uVar8 >> 0x1b & 1) != 0) {
          uVar15 = uVar15 + 0x18;
        }
        if ((uVar8 >> 0x1a & 1) != 0) {
          uVar15 = uVar15 + 8;
        }
        iVar16 = 8;
      }
`````

BT是Bit Test。

> Selects the bit in a bit string (specified with the first operand, called the bit base) at the bitposition designated by the bit offset operand (second operand) and stores the value of the bit in the CF flag.
> 
> CF = Bit(BitBase, BitOffset);


没看出来这段double fetch有什么用。



