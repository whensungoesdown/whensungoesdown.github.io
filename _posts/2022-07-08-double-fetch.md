---
title: 跟着看一个double fetch
published: true
---

之前qemu的ld范围太大了，连pop edx这样的指令因为有读栈的操作，都会用道ld。

现在改成只抓0x8b的mov，也就是mov Gv, Ev，从Ev往Gv（寄存器）里搬。

因为是64位系统，0x8b前可能会有prefix 0x48。

比如下面这条记录：

`````shell
DOUBLE FETCH:   cr3 0x107c36000, syscall 0x42
   eip 0xfffff8006a08a540, user_address 0xc93b1fed88, user_data 0xc93b1fed90, s->pc 0xfffff8006a08a8a8
   eip 0xfffff8006a079030, user_address 0xc93b1fed88, user_data 0xc93b1fed90, s->pc 0xfffff8006a07911e
DIFF EIP
`````

因为不知道kernel的加载基址，所以只能用笨办法在ghidra里按最后4位的地址搜。
这会只需要找8b或者48 8b的，如果还不好找，可以考虑把modrm的这个字节也打印出来。


0xfffff8006a08a540

`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             undefined FUN_1400ca52c()
             undefined         AL:1           <RETURN>
             undefined8        Stack[0x18]:8  local_res18                             XREF[2]:     1400ca52c(W), 
                                                                                                   1400ca706(R)  
             undefined4        Stack[0x10]:4  local_res10                             XREF[2]:     1400ca6ca(RW), 
                                                                                                   1400ca6da(*)  
             undefined4        Stack[0x8]:4   local_res8                              XREF[2]:     1400ca56b(RW), 
                                                                                                   1400ca57f(*)  
                             FUN_1400ca52c                                   XREF[4]:     FUN_1400ca448:1400ca4cb(c), 
                                                                                          FUN_1400ca448:1400ca506(*), 
                                                                                          140285844(*), 14033b4a0(*)  
       1400ca52c 48 89 5c        MOV        qword ptr [RSP + local_res18],RBX
                 24 18
       1400ca531 55              PUSH       RBP
       1400ca532 56              PUSH       RSI
       1400ca533 57              PUSH       RDI
       1400ca534 41 54           PUSH       R12
       1400ca536 41 55           PUSH       R13
       1400ca538 41 56           PUSH       R14
       1400ca53a 41 57           PUSH       R15
       1400ca53c 48 83 ec 20     SUB        RSP,0x20
       1400ca540 48 8b 39        MOV        RDI,qword ptr [RCX]             <-----
       1400ca543 45 33 e4        XOR        R12D,R12D
       1400ca546 48 8b 71 10     MOV        RSI,qword ptr [RCX + 0x10]
       1400ca54a 4c 8b f1        MOV        R14,RCX
       1400ca54d 83 c8 ff        OR         EAX,0xffffffff
       1400ca550 4c 8b 6f 28     MOV        R13,qword ptr [RDI + 0x28]

`````


0xfffff8006a079030

`````shell
       1400a9023 89 4c 24 34     MOV        dword ptr [RSP + local_34],ECX
       1400a9027 48 8b 4b 20     MOV        RCX,qword ptr [RBX + 0x20]
       1400a902b 48 89 4c        MOV        qword ptr [RSP + local_20],RCX
                 24 48
       1400a9030 48 8b 4b 10     MOV        RCX,qword ptr [RBX + 0x10]      <-----
       1400a9034 48 c1 e9 09     SHR        RCX,0x9
       1400a9038 8b c9           MOV        ECX,ECX
       1400a903a 48 89 4c        MOV        qword ptr [RSP + local_30],RCX
                 24 38
       1400a903f 65 48 8b        MOV        RCX,qword ptr GS:[0x188]
                 0c 25 88 
                 01 00 00

`````

这次还真的都找到了，也都是48 8b的mov指令，表示load内存到64bit的寄存器。


1400ca540 - 1400a9030 = 21510

0xfffff8006a08a540 - 0xfffff8006a079030 = 11510

这两个函数在内存中，和在由ghidra展开的ntoskrnl.exe中地址相差了0x10000。可能是因为这俩代码不在同一个section吧。


又发现0xfffff80069cec474和0xfffff8006a079030读过同一个地址，但这两个地址相差太远。搜了下c474结尾的地址，以下搜出来几个。

看来还是要把modrm打出来。有了这个，指令长度其实也就有了。

`````shell
DOUBLE FETCH:   cr3 0x107c36000, syscall 0x42
   eip 0xfffff80069cec474, user_address 0xc93b1fed80, user_data 0x0, s->pc 0xfffff80069cec4a4
   eip 0xfffff8006a079030, user_address 0xc93b1fed80, user_data 0x0, s->pc 0xfffff8006a079115
DIFF EIP
`````

`````shell
       14011c45b 4c 89 75 c8     MOV        qword ptr [RBP + local_50],R14
       14011c45f 48 c7 45        MOV        qword ptr [RBP + local_48],0x10
                 d0 10 00 
                 00 00
       14011c467 48 c7 45        MOV        qword ptr [RBP + local_38],0x2
                 e0 02 00 
                 00 00
       14011c46f e8 0c 4f        CALL       EtwWrite                                         undefined EtwWrite(undefined par
                 f6 ff
                             LAB_14011c474                                   XREF[1]:     14011c426(j)  
       14011c474 48 8b 4d f8     MOV        RCX,qword ptr [RBP + local_20]                                                    <-------
       14011c478 48 33 cc        XOR        RCX,RSP
       14011c47b e8 40 53        CALL       FUN_1401317c0                                    undefined FUN_1401317c0()
                 01 00
       14011c480 4c 8d 5c        LEA        R11=>local_18,[RSP + 0x70]
                 24 70
       14011c485 49 8b 5b 28     MOV        RBX,qword ptr [R11 + local_res10]
       14011c489 49 8b 73 30     MOV        RSI,qword ptr [R11 + local_res18]
       14011c48d 49 8b 7b 38     MOV        RDI,qword ptr [R11 + local_res20]
       14011c491 49 8b e3        MOV        RSP,R11
       14011c494 41 5f           POP        R15
       14011c496 41 5e           POP        R14
       14011c498 5d              POP        RBP
       14011c499 c3              RET

`````

`````shell
                             LAB_1401fc46f                                   XREF[1]:     1401fc47a(j)  
       1401fc46f 39 71 10        CMP        dword ptr [RCX + 0x10],ESI
       1401fc472 74 52           JZ         LAB_1401fc4c6
       1401fc474 48 8b 09        MOV        RCX,qword ptr [RCX]                                            <-------

`````

`````shell
       1403fc46d 4d 89 7b e8     MOV        qword ptr [R11 + local_18],R15
       1403fc471 4c 8b f9        MOV        R15,RCX
       1403fc474 48 8b 05        MOV        RAX,qword ptr [DAT_1403192f0]                   <------
                 75 ce f1 ff
       1403fc47b 49 c7 43        MOV        qword ptr [R11 + local_38],0x0
                 c8 00 00 
                 00 00
       1403fc483 48 85 c0        TEST       RAX,RAX
       1403fc486 74 1b           JZ         LAB_1403fc4a3
       1403fc488 4d 8d 4b c8     LEA        R9=>local_38,[R11 + -0x38]
       1403fc48c ba 00 02        MOV        EDX,0x200
                 00 00

`````


搞不下去了。。。env->eip不准。
