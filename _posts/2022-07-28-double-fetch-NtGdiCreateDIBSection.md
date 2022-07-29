---
title: NtGdiCreateDIBSection
published: true
---

case 53 seems interesting.

case 53

`````shell
DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x1087
   eip 0xfffff961a3a46f87, user_address 0x1f978d80030, user_data 0x28, modrm 0x0, pc 0xfffff961a3a46fac
   eip 0xfffff961a3a47370, user_address 0x1f978d80030, user_data 0x28, modrm 0x11, pc 0xfffff961a3a47386
`````

`````shell
NtGdiGetDIBitsInternal

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
GreGetBitmapSize

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

The user data fetched is 0x28, which quit possible to be a size value.

GreGetBitmapSize reads it and computes the bitmap size. 

NtGdiGetDIBitsInternal uses the calulated size to allocate memory by calling Win32AllocPool().

`````shell
  v13 = GreGetBitmapSize((__int64)Addressa, a7);
  v12 = v13;
  if ( !v13 )
    goto LABEL_40;
  LODWORD(v14) = Win32AllocPool(v13, 1886221383i64);
  v15 = v14;
`````


Even 1c0046fac 1c0046fae are double fetches. Change the user-mode value at 1c0046fae to 0, this way, 
it can bypass ProbeForWrite().

Actually, thi is not possible and the reason is the following.

`````shell
       1c0046f98 48 8b 05        MOV        RAX,qword ptr [->WIN32KBASE.SYS::W32UserProbeA   = 00357e22
                 59 a6 30 00
       1c0046f9f 48 8b 08        MOV        param_1,qword ptr [RAX]
       1c0046fa2 49 8b c7        MOV        RAX,R15
       1c0046fa5 4c 3b f9        CMP        R15,param_1
       1c0046fa8 48 0f 43 c1     CMOVNC     RAX,param_1

  v9 = Addressa;
  if ( (unsigned __int64)Addressa >= *(_QWORD *)W32UserProbeAddress )
    v9 = *(char **)W32UserProbeAddress;
````

If the Addressa is above W32UserProbeAddress, then RAX will be assigned with W32UserProbeAddress, 
so that the malicious address will not be used.


Later I found that this used to be a known vulnerability (cve-2017-0058), attached at the end.

The bug was found on Win7 32bit system. It was triple fetches before, they have already been fixed.
The double fetch remains but not harmfull anymore.



`````shell
  if ( *(_DWORD *)Addressa == 40 )
    *((_DWORD *)Addressa + 8) = 0;
  v13 = GreGetBitmapSize((__int64)Addressa, a7);
  v12 = v13;
  if ( !v13 )
    goto LABEL_40;
  LODWORD(v14) = Win32AllocPool(v13, 1886221383i64);
  v15 = v14;
  if ( v14 )
    memset(v14, 0, (unsigned int)v12);
  if ( !v15 )
    goto LABEL_41;
  if ( &Addressa[v12] < Addressa || (unsigned __int64)&Addressa[v12] > *(_QWORD *)W32UserProbeAddress )
    **(_BYTE **)W32UserProbeAddress = 0;
  memmove(v15, Addressa, v12);
  v16 = a7;
  if ( (unsigned int)GreGetBitmapSize((__int64)v15, a7) != (_DWORD)v12 )
  {
LABEL_61:
    LODWORD(v12) = 0;
    goto LABEL_64;
  }
`````
There are other double fetches in the nearby code.

The first fetch is inside GreGetBitmapSize where it referece two data field of the BITMAPINFOHEADER structure.
`````shell

   x   1c00473a1 8b 50 20        MOV        EDX,dword ptr [RAX + 0x20]
       1c00473a4 44 8d 5b 04     LEA        R11D,[RBX + 0x4]
   x   1c00473a8 8b 40 10        MOV        EAX,dword ptr [RAX + 0x10]
`````

The second fetch of those two data fields is when `memmove(v15, Addressa, v12);`.


`````shell
typedef struct tagBITMAPINFOHEADER {
+00  DWORD biSize;
+04  LONG  biWidth;
+08  LONG  biHeight;
+0c  WORD  biPlanes;
     WORD  biBitCount;
+10  DWORD biCompression;
+14  DWORD biSizeImage;
+18  LONG  biXPelsPerMeter;
+1c  LONG  biYPelsPerMeter;
+20  DWORD biClrUsed;
+24  DWORD biClrImportant;
} BITMAPINFOHEADER, *LPBITMAPINFOHEADER, *PBITMAPINFOHEADER;
`````

So, the biCompression (offset 0x10) field can be compromised. It determines the size that calculated by GreGetBitmapSize.

`````shell
  if ( v8 && v33 || !(_DWORD)v12 || !v15 )
  {
    v28 = 0;
  }
  else
  {
    v28 = GreGetDIBitsInternal(v36, (__int64)v35, v31, v30, (unsigned __int8 *)v8, (__int64)v15, v16, Length, v12);
    if ( v28 )
      memmove(Addressa, v15, (unsigned int)v12);
  }
`````

Unfortunately, it can't affect the memmove because v12 was the previously calulated.

It may affect GreGetDIBitsInternal() because the data structure and the Length are not match.

But, that's too deep an internal function. 

I could give it try by change the value before the second fetch, see if it causes any BSOD.


> biCompression
> The type of compression for a compressed bottom-up bitmap (top-down DIBs cannot be compressed). This member can be one of the following values.
> 
> Value	Description
> BI_RGB	An uncompressed format.
> BI_RLE8	A run-length encoded (RLE) format for bitmaps with 8 bpp. The compression format is a 2-byte format consisting of a count byte followed by a byte containing a color index. For more information, see Bitmap Compression.
> BI_RLE4	An RLE format for bitmaps with 4 bpp. The compression format is a 2-byte format consisting of a count byte followed by two word-length color indexes. For more information, see Bitmap Compression.
> BI_BITFIELDS	Specifies that the bitmap is not compressed and that the color table consists of three DWORD color masks that specify the red, green, and blue components, respectively, of each pixel. This is valid when used with 16- and 32-bpp bitmaps.
> BI_JPEG	Indicates that the image is a JPEG image.
> BI_PNG	Indicates that the image is a PNG image.

 

-------------------------------------------------------------------------------

> Source: https://bugs.chromium.org/p/project-zero/issues/detail?id=1078
> 
> We have discovered two bugs in the implementation of the win32k!NtGdiGetDIBitsInternal system call, which is a part of the graphic subsystem in all modern versions of Windows. The issues can potentially lead to kernel pool memory disclosure (bug #1) or denial of service (bug #1 and #2). Under certain circumstances, memory corruption could also be possible.
> 
> ----------[ Double-fetch while handling the BITMAPINFOHEADER structure ]----------
> 
> At the beginning of the win32k!NtGdiGetDIBitsInternal system call handler, the code references the BITMAPINFOHEADER structure (and specifically its .biSize field) several times, in order to correctly calculate its size and capture it into kernel-mode memory. A pseudo-code representation of the relevant code is shown below, where "bmi" is a user-controlled address:
> 
> --- cut ---
>   ProbeForRead(bmi, 4, 1);
>   ProbeForWrite(bmi, bmi->biSize, 1); <------------ Fetch #1
> 
>   header_size = GreGetBitmapSize(bmi); <----------- Fetch #2
>   captured_bmi = Alloc(header_size);
> 
>   ProbeForRead(bmi, header_size, 1);
>   memcpy(captured_bmi, bmi, header_size); <-------- Fetch #3
> 
>   new_header_size = GreGetBitmapSize(bmi);
>   if (header_size != new_header_size) {
>     // Bail out.
>   }
> 
>   // Process the data further.
> --- cut ---
> 
> In the snippet above, we can see that the user-mode "bmi" buffer is accessed thrice: when accessing the biSize field, in the GreGetBitmapSize() call, and in the final memcpy() call. While this is clearly a multi-fetch condition, it is mostly harmless: since there is a ProbeForRead() call for "bmi", it must be a user-mode address, so bypassing the subsequent ProbeForWrite() call by setting bmi->biSize to 0 doesn't change much. Furthermore, since the two results of the GreGetBitmapSize() calls are eventually compared, introducing any inconsistencies in between them is instantly detected.
> 
> As far as we are concerned, the only invalid outcome of the behavior could be read access to out-of-bounds pool memory in the second GreGetBitmapSize() call. This is achieved in the following way:
> 
> 1. Invoke NtGdiGetDIBitsInternal with a structure having the biSize field set to 12 (sizeof(BITMAPCOREHEADER)).
> 2. The first call to GreGetBitmapSize() now returns 12 or a similar small value.
> 3. This number of bytes is allocated for the header buffer.
> 4. (In a second thread) Change the value of the biSize field to 40 (sizeof(BITMAPINFOHEADER)) before the memcpy() call.
> 5. memcpy() copies the small structure (with incorrectly large biSize) into the pool allocation.
> 6. When called again, the GreGetBitmapSize() function assumes that the biSize field is set adequately to the size of the corresponding memory area (untrue), and attempts to access structure fields at offsets greater than 12.
> 
> The bug is easiest to reproduce with Special Pools enabled for win32k.sys, as the invalid memory read will then be reliably detected and will yield a system bugcheck. An excerpt from a kernel crash log triggered using the bug in question is shown below:
> 
> --- cut ---
>   DRIVER_PAGE_FAULT_BEYOND_END_OF_ALLOCATION (d6)
>   N bytes of memory was allocated and more than N bytes are being referenced.
>   This cannot be protected by try-except.
>   When possible, the guilty driver's name (Unicode string) is printed on
>   the bugcheck screen and saved in KiBugCheckDriver.
>   Arguments:
>   Arg1: fe3ff008, memory referenced
>   Arg2: 00000000, value 0 = read operation, 1 = write operation
>   Arg3: 943587f1, if non-zero, the address which referenced memory.
>   Arg4: 00000000, (reserved)
> 
>   Debugging Details:
>   ------------------
> 
>   [...]
> 
>   TRAP_FRAME:  92341b1c -- (.trap 0xffffffff92341b1c)
>   ErrCode = 00000000
>   eax=fe3fefe8 ebx=00000000 ecx=00000000 edx=00000028 esi=00000004 edi=01240000
>   eip=943587f1 esp=92341b90 ebp=92341b98 iopl=0         nv up ei pl zr na pe nc
>   cs=0008  ss=0010  ds=0023  es=0023  fs=0030  gs=0000             efl=00010246
>   win32k!GreGetBitmapSize+0x34:
>   943587f1 8b7820          mov     edi,dword ptr [eax+20h] ds:0023:fe3ff008=????????
>   Resetting default scope
> 
>   LAST_CONTROL_TRANSFER:  from 816f9dff to 816959d8
> 
>   STACK_TEXT:  
>   9234166c 816f9dff 00000003 09441320 00000065 nt!RtlpBreakWithStatusInstruction
>   923416bc 816fa8fd 00000003 00000000 00000002 nt!KiBugCheckDebugBreak+0x1c
>   92341a80 816a899d 00000050 fe3ff008 00000000 nt!KeBugCheck2+0x68b
>   92341b04 8165af98 00000000 fe3ff008 00000000 nt!MmAccessFault+0x104
>   92341b04 943587f1 00000000 fe3ff008 00000000 nt!KiTrap0E+0xdc
>   92341b98 9434383e fe3fefe8 00000000 067f9cd5 win32k!GreGetBitmapSize+0x34
>   92341c08 81657db6 00000000 00000001 00000000 win32k!NtGdiGetDIBitsInternal+0x17f
>   92341c08 011d09e1 00000000 00000001 00000000 nt!KiSystemServicePostCall
>   [...]
> --- cut ---
> 
> The out-of-bounds data read by GreGetBitmapSize() could then be extracted back to user-mode to some degree, which could help disclose sensitive data or defeat certain kernel security mitigations (such as kASLR).
> 
> Attached is a PoC program for Windows 7 32-bit (double_fetch_oob_read.cpp).
> 
> ----------[ Unhandled out-of-bounds write to user-mode memory when requesting RLE-compressed bitmaps ]----------
> 
> The 5th parameter of the NtGdiGetDIBitsInternal syscall is a pointer to an output buffer where the bitmap data should be written to. The length of the buffer is specified in the 8th parameter, and can be optionally 0. The logic of sanitizing and locking the memory area is shown below ("Buffer" is the 5th argument and "Length" is the 8th).
> 
> --- cut ---
>   if (Length != 0 || (Length = GreGetBitmapSize(bmi)) != 0) {
>     ProbeForWrite(Buffer, Length, 4);
>     MmSecureVirtualMemory(Buffer, Length, PAGE_READWRITE);
>   }
> --- cut ---
> 
> We can see that if the "Length" argument is non-zero, it is prioritized over the result of GreGetBitmapSize() in specifying how many bytes of the user-mode output buffer should be locked in memory as readable/writeable. Since the two calls above are supposed to guarantee that the required user-mode memory region will be accessible until it is unlocked, the call to the GreGetDIBitsInternal() function which actually fills the buffer with data is not guarded with a try/except block.
> 
> However, if we look into GreGetDIBitsInternal() and further into GreGetDIBitsInternalWorker(), we can see that if a RLE-compressed bitmap is requested by the user (as indicated by bmi.biCompression set to BI_RLE[4,8]), the internal EncodeRLE4() and EncodeRLE8() routines are responsible for writing the output data. The legal size of the buffer is passed through the functions' 5th parameter (last one), and is always set to bmi.biSizeImage. This creates a discrepancy: a different number of bytes is ensured to be present in memory (Length), and a different number can be actually written to it (bmi.biSizeImage). Due to the lack of exception handling in this code area, the resulting exception causes a system-wide bugcheck:
> 
> --- cut ---
>   KERNEL_MODE_EXCEPTION_NOT_HANDLED (8e)
>   This is a very common bugcheck.  Usually the exception address pinpoints
>   the driver/function that caused the problem.  Always note this address
>   as well as the link date of the driver/image that contains this address.
>   Some common problems are exception code 0x80000003.  This means a hard
>   coded breakpoint or assertion was hit, but this system was booted
>   /NODEBUG.  This is not supposed to happen as developers should never have
>   hardcoded breakpoints in retail code, but ...
>   If this happens, make sure a debugger gets connected, and the
>   system is booted /DEBUG.  This will let us see why this breakpoint is
>   happening.
>   Arguments:
>   Arg1: c0000005, The exception code that was not handled
>   Arg2: 9461564b, The address that the exception occurred at
>   Arg3: 9d0539a0, Trap Frame
>   Arg4: 00000000
> 
>   Debugging Details:
>   ------------------
> 
>   [...]
> 
>   TRAP_FRAME:  9d0539a0 -- (.trap 0xffffffff9d0539a0)
>   ErrCode = 00000002
>   eax=00291002 ebx=00291000 ecx=00000004 edx=fe9bb1c1 esi=00000064 edi=fe9bb15c
>   eip=9461564b esp=9d053a14 ebp=9d053a40 iopl=0         nv up ei ng nz ac pe cy
>   cs=0008  ss=0010  ds=0023  es=0023  fs=0030  gs=0000             efl=00010297
>   win32k!EncodeRLE8+0x1ac:
>   9461564b c60300          mov     byte ptr [ebx],0           ds:0023:00291000=??
>   Resetting default scope
> 
>   [...]
> 
>   STACK_TEXT:  
>   9d052f5c 8172adff 00000003 17305ce1 00000065 nt!RtlpBreakWithStatusInstruction
>   9d052fac 8172b8fd 00000003 9d0533b0 00000000 nt!KiBugCheckDebugBreak+0x1c
>   9d053370 8172ac9c 0000008e c0000005 9461564b nt!KeBugCheck2+0x68b
>   9d053394 817002f7 0000008e c0000005 9461564b nt!KeBugCheckEx+0x1e
>   9d053930 81689996 9d05394c 00000000 9d0539a0 nt!KiDispatchException+0x1ac
>   9d053998 8168994a 9d053a40 9461564b badb0d00 nt!CommonDispatchException+0x4a
>   9d053a40 944caea9 fe9bb1c1 ff290ffc 00000064 nt!KiExceptionExit+0x192
>   9d053b04 944e8b09 00000028 9d053b5c 9d053b74 win32k!GreGetDIBitsInternalWorker+0x73e
>   9d053b7c 944d390f 0c0101fb 1f050140 00000000 win32k!GreGetDIBitsInternal+0x21b
>   9d053c08 81688db6 0c0101fb 1f050140 00000000 win32k!NtGdiGetDIBitsInternal+0x250
>   9d053c08 00135ba6 0c0101fb 1f050140 00000000 nt!KiSystemServicePostCall
>   [...]
> --- cut ---
> 
> While the size of the buffer passed to EncodeRLE[4,8] can be arbitrarily controlled through bmi.biSizeImage (32-bit field), it doesn't enable an attacker to corrupt kernel-mode memory, as the memory writing takes place sequentially from the beginning to the end of the buffer. Furthermore, since the code in NtGdiGetDIBitsInternal() makes sure that the buffer size passed to ProbeForWrite() is >= 1, its base address must reside in user space. As such, this appears to be a DoS issue only, if we haven't missed anything in our analysis.
> 
> Attached is a PoC program for Windows 7 32-bit (usermode_oob_write.cpp), and a bitmap file necessary for the exploit to work (test.bmp).
> 
> 
> Proof of Concept:
> https://github.com/offensive-security/exploitdb-bin-sploits/raw/master/bin-sploits/41879.zip
