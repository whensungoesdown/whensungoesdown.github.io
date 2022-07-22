---
title: double fetches ...
published: true
---

case 3:

`````shell
DOUBLE FETCH:   cr3 0xb7261000, syscall 0x125
   eip 0xfffff80179cb0aa3, user_address 0x40f3efe798, user_data 0x1, modrm 0x1, pc 0xfffff80179cb0aeb
   eip 0xfffff80179cb0aa3, user_address 0x40f3efe798, user_data 0x1, modrm 0x36, pc 0xfffff80179cb0af5
`````

`````shell
                             LAB_140426acf                                   XREF[1]:     140426ac0(j)  
       140426acf 40 f6 c6 03     TEST       SIL,0x3
       140426ad3 0f 85 8e        JNZ        LAB_140426b67
                 00 00 00
   --> 140426ad9 48 8b ce        MOV        RCX,RSI
       140426adc 48 3b 35        CMP        RSI,qword ptr [MmUserProbeAddress]               = ??
                 1d 87 f5 ff
       140426ae3 48 0f 43        CMOVNC     RCX,qword ptr [MmUserProbeAddress]               = ??
                 0d 15 87 
                 f5 ff
   --> 140426aeb 8a 01           MOV        AL,byte ptr [RCX]
       140426aed 88 01           MOV        byte ptr [RCX],AL
       140426aef 8a 41 13        MOV        AL,byte ptr [RCX + 0x13]
       140426af2 88 41 13        MOV        byte ptr [RCX + 0x13],AL
   --> 140426af5 44 8b 36        MOV        R14D,dword ptr [RSI]
       140426af8 44 89 74        MOV        dword ptr [RSP + 0x54],R14D
                 24 54
       140426afd 48 8b 0d        MOV        RCX,qword ptr [MmSystemRangeStart]               = ??
                 e4 87 f5 ff
       140426b04 48 f7 d9        NEG        RCX
       140426b07 48 b8 ab        MOV        RAX,-0x5555555555555555
                 aa aa aa 
                 aa aa aa aa
       140426b11 48 f7 e1        MUL        RCX
       140426b14 48 c1 ea 03     SHR        RDX,0x3
       140426b18 4c 3b f2        CMP        R14,RDX
       140426b1b 73 4f           JNC        LAB_140426b6c
`````

好像也没什么用。。。。


----------------------------------


case 4


`````shell
DOUBLE FETCH:   cr3 0x11067e000, syscall 0x29
   eip 0xfffff80179c82790, user_address 0x2c596e4e690, user_data 0x30, modrm 0x41, pc 0xfffff80179c8280c
   eip 0xfffff80179c82790, user_address 0x2c596e4e690, user_data 0x30, modrm 0x41, pc 0xfffff80179c828e0
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
                             LAB_1403f8835                                   XREF[1]:     1403f87f3(j)  
       1403f8835 e8 d6 99        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 27 00
                             LAB_1403f883a                                   XREF[1]:     1403f87ff(j)  
       1403f883a 48 8b d0        MOV        param_2,RAX
       1403f883d eb c2           JMP        LAB_1403f8801
                             LAB_1403f883f                                   XREF[1]:     1403f8831(j)  
       1403f883f e8 cc 99        CALL       ExRaiseDatatypeMisalignment                      undefined ExRaiseDatatypeMisalig
                 27 00
                             LAB_1403f8844                                   XREF[2]:     1403f882c(j), 1403f8833(j)  
       1403f8844 eb 05           JMP        LAB_1403f884b
       1403f8846 e9              ??         E9h
       1403f8847 fb              ??         FBh
       1403f8848 05              ??         05h
       1403f8849 00              ??         00h
       1403f884a 00              ??         00h
                             LAB_1403f884b                                   XREF[1]:     1403f8844(j)  
       1403f884b 44 8b 5c        MOV        R11D,dword ptr [RSP + local_90]
                 24 48
       1403f8850 44 89 5c        MOV        dword ptr [RSP + local_ac],R11D
                 24 2c
       1403f8855 8b 44 24 34     MOV        EAX,dword ptr [RSP + local_a4]
       1403f8859 89 44 24 20     MOV        dword ptr [RSP + local_b8],EAX
       1403f885d 44 8b 5c        MOV        R11D,dword ptr [RSP + local_8c]
                 24 4c
       1403f8862 44 89 5c        MOV        dword ptr [RSP + local_a8],R11D
                 24 30
       1403f8867 44 8b 5c        MOV        R11D,dword ptr [RSP + local_a0]
                 24 38
       1403f886c 44 89 5c        MOV        dword ptr [RSP + local_b4],R11D
                 24 24
                             LAB_1403f8871                                   XREF[1]:     1403f8ea7(j)  
       1403f8871 80 7c 24        CMP        byte ptr [RSP + local_68[0]],0x1
                 70 01
       1403f8876 0f 85 e8        JNZ        LAB_140570064
                 77 17 00
       1403f887c 0f b7 51 02     MOVZX      param_2,word ptr [param_1 + 0x2]
       1403f8880 0f b7 c2        MOVZX      EAX,param_2
       1403f8883 66 41 23 c0     AND        AX,param_3
       1403f8887 0f 85 8e        JNZ        LAB_1403f891b
                 00 00 00
       1403f888d 48 8b 59 08     MOV        RBX,qword ptr [param_1 + 0x8]
                             LAB_1403f8891                                   XREF[2]:     1403f8928(j), 1403f8930(j)  
       1403f8891 48 89 5c        MOV        qword ptr [RSP + local_70],RBX
                 24 68
       1403f8896 48 89 5c        MOV        qword ptr [RSP + local_68[8]],RBX
                 24 78
       1403f889b 66 85 c0        TEST       AX,AX
       1403f889e 75 31           JNZ        LAB_1403f88d1
  -->> 1403f88a0 48 8b 79 10     MOV        RDI,qword ptr [param_1 + 0x10]
                             LAB_1403f88a4                                   XREF[1]:     1403f88de(j)  
       1403f88a4 48 89 7c        MOV        qword ptr [RSP + local_78],RDI
                 24 60
                             LAB_1403f88a9                                   XREF[1]:     1403f890f(j)  
       1403f88a9 48 89 bc        MOV        qword ptr [RSP + local_58],RDI
                 24 80 00 
                 00 00
       1403f88b1 f6 c2 10        TEST       param_2,0x10
       1403f88b4 75 37           JNZ        LAB_1403f88ed
       1403f88b6 4d 8b ec        MOV        R13,R12
                             LAB_1403f88b9                                   XREF[3]:     1403f88ff(j), 1403f8905(j), 
                                                                                          1403f8919(j)  
       1403f88b9 4c 89 ac        MOV        qword ptr [RSP + local_50],R13
                 24 88 00 
                 00 00
       1403f88c1 f6 c2 04        TEST       param_2,0x4
       1403f88c4 74 4b           JZ         LAB_1403f8911
       1403f88c6 66 85 c0        TEST       AX,AX
       1403f88c9 75 15           JNZ        LAB_1403f88e0
       1403f88cb 4c 8b 71 20     MOV        R14,qword ptr [param_1 + 0x20]
       1403f88cf eb 67           JMP        LAB_1403f8938
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


syscall 0x29 NtAccessCheckAndAuditAlarm()

calls

SeCaptureSecurityDescriptor()


> NTSTATUS
> SeCaptureSecurityDescriptor(
>   IN  PSECURITY_DESCRIPTOR InputSecurityDescriptor,
>   IN  KPROCESSOR_MODE RequestorMode,
>   IN  POOL_TYPE PoolType,
>   IN  BOOLEAN ForceCapture,
>   OUT PSECURITY_DESCRIPTOR *OutputSecurityDescriptor
>   );
> 
> Routine Description:
> 
>     This routine probes and captures a copy of the security descriptor based
>     upon the following tests.
> 
>     if the requestor mode is not kernel mode then
> 
>         probe and capture the input descriptor
>         (the captured descriptor is self-relative)
> 
>     if the requstor mode is kernel mode then
> 
>         if force capture is true then
> 
>             do not probe the input descriptor, but do capture it.
>             (the captured descriptor is self-relative)
> 
>         else
> 
>             do nothing
>             (the input descriptor is expected to be self-relative)
> 
> Arguments:
> 
>     InputSecurityDescriptor - Supplies the security descriptor to capture.
>     This parameter is assumed to have been provided by the mode specified
>     in RequestorMode.
> 
>     RequestorMode - Specifies the caller's access mode.
> 
>     PoolType - Specifies which pool type to allocate the captured
>         descriptor from
> 
>     ForceCapture - Specifies whether the input descriptor should always be
>         captured
> 
>     OutputSecurityDescriptor - Supplies the address of a pointer to the
>         output security descriptor.  The captured descriptor will be
>         self-relative format.
> 
> Return Value:
> 
>     STATUS_SUCCESS if the operation is successful.
> 
>     STATUS_INVALID_SID - An SID within the security descriptor is not
>         a valid SID.
> 
>     STATUS_INVALID_ACL - An ACL within the security descriptor is not
>         a valid ACL.
> 
>     STATUS_UNKNOWN_REVISION - The revision level of the security descriptor
>         is not one known to this revision of the capture routine.
> 




> NTSTATUS
> NtAccessCheckAndAuditAlarm(
>   IN  PUNICODE_STRING SubsystemName,
>   IN  PVOID HandleId,
>   IN  PUNICODE_STRING ObjectTypeName,
>   IN  PUNICODE_STRING ObjectName,
>   IN  PSECURITY_DESCRIPTOR SecurityDescriptor,
>   IN  ACCESS_MASK DesiredAccess,
>   IN  PGENERIC_MAPPING GenericMapping,
>   IN  BOOLEAN ObjectCreation,
>   OUT PACCESS_MASK GrantedAccess,
>   OUT PNTSTATUS AccessStatus,
>   OUT PBOOLEAN GenerateOnClose
>   );
> 
> Routine Description:
> 
>     This system service is used to perform both an access validation and
>     generate the corresponding audit and alarm messages.  This service may
>     only be used by a protected server that chooses to impersonate its
>     client and thereby specifies the client security context implicitly.
> 
> Arguments:
> 
>     SubsystemName - Supplies a name string identifying the subsystem
>         calling the routine.
> 
>     HandleId - A unique value that will be used to represent the client's
>         handle to the object.  This value is ignored (and may be re-used)
>         if the access is denied.
> 
>     ObjectTypeName - Supplies the name of the type of the object being
>         created or accessed.
> 
>     ObjectName - Supplies the name of the object being created or accessed.
> 
>     SecurityDescriptor - A pointer to the Security Descriptor against which
>         acccess is to be checked.
> 
>     DesiredAccess - The desired acccess mask.  This mask must have been
>         previously mapped to contain no generic accesses.
> 
>     GenericMapping - Supplies a pointer to the generic mapping associated
>         with this object type.
> 
>     ObjectCreation - A boolean flag indicated whether the access will
>         result in a new object being created if granted.  A value of TRUE
>         indicates an object will be created, FALSE indicates an existing
>         object will be opened.
> 
>     GrantedAccess - Receives a masking indicating which accesses have been
>         granted.
> 
>     AccessStatus - Receives an indication of the success or failure of the
>         access check.  If access is granted, STATUS_SUCCESS is returned.
>         If access is denied, a value appropriate for return to the client
>         is returned.  This will be STATUS_ACCESS_DENIED or, when mandatory
>         access controls are implemented, STATUS_OBJECT_NOT_FOUND.
> 
>     GenerateOnClose - Points to a boolean that is set by the audity
>         generation routine and must be passed to NtCloseObjectAuditAlarm
>         when the object handle is closed.
> 
> Return Value:
> 
>     STATUS_SUCCESS - Indicates the call completed successfully.  In this
>         case, ClientStatus receives the result of the access check.
> 
>     STATUS_PRIVILEGE_NOT_HELD - Indicates the caller does not have
>         sufficient privilege to use this privileged system service.
> 
> 


本以为系统在读InputSecurityDescriptor的时候没有try catch，因为看SeCaptureSecurityDescriptor和
NtAccessCheckAndAuditAlarm的时候没见到，以为可以搞个local DOS。结果是x64的exception早就变了，自己一直
都不知道。。。


SEH的记录不放在stack上了，所以代码上看着好像是没try catch，没有SEH_prolog4这样的函数地址压到栈上。

x64的exception表放在PE的section里。

相关的文章列几个在这里，还没来得及仔细看。


http://osronline.com/article.cfm%5earticle=469.htm

https://docs.microsoft.com/en-us/cpp/build/exception-handling-x64?view=msvc-170

https://docs.microsoft.com/en-us/cpp/cpp/exception-handling-in-visual-cpp?view=msvc-170

https://itanium-cxx-abi.github.io/cxx-abi/exceptions.pdf


在80c的地方下断点，等第一次读过去以后再改数据，试了些值，比如0，ffffffff，也没蓝。

先试试其它的吧。



后来发现其它记录里 1403f88a0这里和80c读的是同一个地方。


`````shell
DOUBLE FETCH:   cr3 0x135311000, syscall 0x77
   eip 0xfffff80179c82801, user_address 0x7ff69552fe30, user_data 0x0, modrm 0x41, pc 0xfffff80179c8280c
   eip 0xfffff80179c8287c, user_address 0x7ff69552fe30, user_data 0x0, modrm 0x79, pc 0xfffff80179c828a0
DIFF EIP

DOUBLE FETCH:   cr3 0x135311000, syscall 0xa8
   eip 0xfffff80179c82790, user_address 0x11fe7f0d8, user_data 0x0, modrm 0x41, pc 0xfffff80179c8280c
   eip 0xfffff80179c82790, user_address 0x11fe7f0d8, user_data 0x0, modrm 0x79, pc 0xfffff80179c828a0

DOUBLE FETCH:   cr3 0x135311000, syscall 0x9b
   eip 0xfffff80179c82790, user_address 0x7ff69552fdb0, user_data 0x0, modrm 0x41, pc 0xfffff80179c8280c
   eip 0xfffff80179c82790, user_address 0x7ff69552fdb0, user_data 0x0, modrm 0x79, pc 0xfffff80179c828a0

DOUBLE FETCH:   cr3 0x135311000, syscall 0xb3
   eip 0xfffff80179c82790, user_address 0x7ff69552fd70, user_data 0x0, modrm 0x41, pc 0xfffff80179c8280c
   eip 0xfffff80179c82790, user_address 0x7ff69552fd70, user_data 0x0, modrm 0x79, pc 0xfffff80179c828a0


`````

系统调用0x77是NtAlpcCreatePort。

系统调用0xa8是NtCreateNamedPipeFile。

0x9b NtCreateDirectoryObject

0xb3 NtCreateThreadEx


还有很多，不一一列举了。
