---
title: Double fetch case 2
published: true
---


`````shell
DOUBLE FETCH:   cr3 0x12132c000, syscall 0x88
   eip 0xfffff80179ca0603, user_address 0x662867f3b0, user_data 0xf8000000, modrm 0x39, pc 0xfffff80179ca08fd
   eip 0xfffff80179ca0bf2, user_address 0x662867f3b0, user_data 0xf8000000, modrm 0x27, pc 0xfffff80179ca0c03
DIFF EIP
`````

`````shell
                             LAB_1404168fd                                   XREF[1]:     140416a72(j)  
       1404168fd 8b 39           MOV        EDI,dword ptr [param_1]
       1404168ff 41 3b c5        CMP        EAX,R13D
       140416902 0f 84 00        JZ         LAB_140416a08
                 01 00 00
       140416908 41 bf 08        MOV        R15D,0x8
                 00 00 00
       14041690e 41 8b c7        MOV        EAX,R15D
       140416911 41 85 fd        TEST       R13D,EDI
       140416914 74 04           JZ         LAB_14041691a
       140416916 41 8d 47 18     LEA        EAX,[R15 + 0x18]
                             LAB_14041691a                                   XREF[1]:     140416914(j)  
       14041691a 0f ba e7 1e     BT         EDI,0x1e
       14041691e 73 03           JNC        LAB_140416923
       140416920 83 c0 20        ADD        EAX,0x20

`````


`````shell
       140416c03 44 8b 27        MOV        R12D,dword ptr [RDI]
       140416c06 48 8d 77 04     LEA        RSI,[RDI + 0x4]
       140416c0a 48 89 74        MOV        qword ptr [RSP + local_118],RSI
                 24 50
       140416c0f 33 c0           XOR        EAX,EAX
       140416c11 89 06           MOV        dword ptr [RSI],EAX
       140416c13 41 8b d4        MOV        param_2,R12D
       140416c16 44 85 6c        TEST       dword ptr [RSP + local_134],R13D
                 24 34
       140416c1b 0f 85 69        JNZ        LAB_140416e8a
                 02 00 00
       140416c21 41 23 d5        AND        param_2,R13D
       140416c24 74 15           JZ         LAB_140416c3b
       140416c26 4c 89 bc        MOV        qword ptr [RSP + local_48],R15
                 24 20 01 
                 00 00
       140416c2e 49 39 86        CMP        qword ptr [R14 + 0x88],RAX
                 88 00 00 00
       140416c35 0f 85 a3        JNZ        LAB_1404171de
                 05 00 00

`````

看上区和case 1差不多，不知道该怎么搞，有什么用。




再看case 1的时候发现代码附近有个RtlCopyMemory，其中的size参数也是读了两遍。

szie，src，dst都是从很复杂的基层数据结构里得到的，跟了下，最终到gs:0x188，kthread。

应该都是内核里的，如果kthread里有用户层地址存在哪，那就是另外一个问题了。


`````shell
lVar6 = *(longlong *)(in_GS_OFFSET + 0x188);

lVar8 = lVar6 + 800 + (ulonglong)uVar2 * 0x60;

param_2 = lVar8;

return param_2;


-->

lVar3 = FUN_140045690(param_1 + 2,0,0);

return lVar3;


-->

       (lVar11 = FUN_14041c1e0(*(longlong *)(param_1 + 0x10) + 0x28,param_2 & 0x7fffffff,
                               &DAT_1402348c0), lVar11 != 0)) {

uVar13 = *(ulonglong *)(lVar11 + 0x18);

*param_4 = uVar13;


-->

uVar13 = FUN_1404151e0(lVar14,local_10c,local_100,&local_f0);

local_108 = local_f0;

plVar9 = local_108;

_Size = (ulonglong)*(ushort *)(local_108 + 0x1c) - 0x200


        plVar15 = (longlong *)local_108[0x1a];
      }
      RtlCopyMemory(puVar18,plVar15,_Size);





    if (local_108[0x15] == 0) {
      _Size = (size_t)*(ushort *)(local_108 + 0x1c);
      if (_Size < 0x201) {
        plVar15 = local_108 + 0x21;
      }
      else {
        plVar15 = local_108 + 0x21;
        lVar14 = 4;
`````

