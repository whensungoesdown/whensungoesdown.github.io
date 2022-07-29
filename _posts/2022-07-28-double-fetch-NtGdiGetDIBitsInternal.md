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

`````

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


I tried several values such as 3, a, b, ff. They do not cause a crash.

Note:
To uf a win32k function, first need to switch the process context to a GUI process.

`````shell
kd> !process 0 0 
**** NT ACTIVE PROCESS DUMP ****
PROCESS ffffe00024c4b040
    SessionId: none  Cid: 0004    Peb: 00000000  ParentCid: 0000
    DirBase: 001aa000  ObjectTable: ffffc001d2e14000  HandleCount: <Data Not Accessible>
    Image: System

PROCESS ffffe00025f59840
    SessionId: none  Cid: 010c    Peb: 4d9a1a8000  ParentCid: 0004
    DirBase: 46eea000  ObjectTable: ffffc001d33267c0  HandleCount: <Data Not Accessible>
    Image: smss.exe

PROCESS ffffe000260e9080
    SessionId: 0  Cid: 0158    Peb: d7ebcf000  ParentCid: 0150
    DirBase: 67ab4000  ObjectTable: ffffc001da988e80  HandleCount: <Data Not Accessible>
    Image: csrss.exe

PROCESS ffffe000263ac080
    SessionId: 0  Cid: 01a0    Peb: 4e946a1000  ParentCid: 0150
    DirBase: 62a7a000  ObjectTable: ffffc001da98f880  HandleCount: <Data Not Accessible>
    Image: wininit.exe

PROCESS ffffe000261d4080
    SessionId: 1  Cid: 01ac    Peb: c9ee62a000  ParentCid: 0198
    DirBase: 62869000  ObjectTable: ffffc001d36301c0  HandleCount: <Data Not Accessible>
    Image: csrss.exe

PROCESS ffffe000263d9840
    SessionId: 1  Cid: 01d8    Peb: 69627aa000  ParentCid: 0198
    DirBase: 61f2f000  ObjectTable: ffffc001d3646e40  HandleCount: <Data Not Accessible>
    Image: winlogon.exe

PROCESS ffffe000274a1080
    SessionId: 0  Cid: 0218    Peb: 6274fc8000  ParentCid: 01a0
    DirBase: 6192a000  ObjectTable: ffffc001d36d5a80  HandleCount: <Data Not Accessible>
    Image: services.exe

PROCESS ffffe000274ad080
    SessionId: 0  Cid: 0220    Peb: 181cbdd000  ParentCid: 01a0
    DirBase: 61b49000  ObjectTable: ffffc001d36f3c80  HandleCount: <Data Not Accessible>
    Image: lsass.exe

PROCESS ffffe000263de840
    SessionId: 0  Cid: 0260    Peb: 75c583a000  ParentCid: 0218
    DirBase: 5f5a1000  ObjectTable: ffffc001d37db2c0  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe0002750c840
    SessionId: 0  Cid: 028c    Peb: c7bce6000  ParentCid: 0218
    DirBase: 5ee75000  ObjectTable: ffffc001d3832180  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000275a2080
    SessionId: 1  Cid: 0304    Peb: 3dd7a24000  ParentCid: 01d8
    DirBase: 5ee97000  ObjectTable: ffffc001d3903740  HandleCount: <Data Not Accessible>
    Image: dwm.exe

PROCESS ffffe0002759d840
    SessionId: 0  Cid: 035c    Peb: 9720af000  ParentCid: 0218
    DirBase: 5cd0b000  ObjectTable: ffffc001d3990580  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000275f4840
    SessionId: 0  Cid: 037c    Peb: 14f08bd000  ParentCid: 0218
    DirBase: 5cb67000  ObjectTable: ffffc001d39fed00  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe00027a61080
    SessionId: 0  Cid: 03b0    Peb: a71e9f4000  ParentCid: 0218
    DirBase: 5c288000  ObjectTable: ffffc001d3a41dc0  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe000263a2700
    SessionId: 0  Cid: 03c4    Peb: 00334000  ParentCid: 0218
    DirBase: 5cccf000  ObjectTable: ffffc001d3a5fb80  HandleCount: <Data Not Accessible>
    Image: VBoxService.exe

PROCESS ffffe00027a75840
    SessionId: 0  Cid: 00ec    Peb: e724c72000  ParentCid: 0218
    DirBase: 5b05b000  ObjectTable: ffffc001d3aa1cc0  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe00027aa0840
    SessionId: 0  Cid: 0124    Peb: 2e39e81000  ParentCid: 0218
    DirBase: 59e63000  ObjectTable: ffffc001d3acbd00  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe00027ac4840
    SessionId: 0  Cid: 0134    Peb: b02ebee000  ParentCid: 0218
    DirBase: 5a3ae000  ObjectTable: ffffc001d3acc4c0  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe00027acd840
    SessionId: 0  Cid: 041c    Peb: c8fa33b000  ParentCid: 0218
    DirBase: 5535f000  ObjectTable: ffffc001d3b33500  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe00024cdf080
    SessionId: 0  Cid: 04f4    Peb: 00299000  ParentCid: 0218
    DirBase: 4e175000  ObjectTable: ffffc001d3ca4480  HandleCount: <Data Not Accessible>
    Image: spoolsv.exe

PROCESS ffffe00027a0d840
    SessionId: 0  Cid: 0598    Peb: efa550d000  ParentCid: 0218
    DirBase: 4cd14000  ObjectTable: ffffc001d3d65a80  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe00027c75080
    SessionId: 0  Cid: 0600    Peb: 191131a000  ParentCid: 0218
    DirBase: 4bb44000  ObjectTable: ffffc001d3dab640  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe00027c7d840
    SessionId: 0  Cid: 0608    Peb: dfc7da000  ParentCid: 0218
    DirBase: 4c5d2000  ObjectTable: ffffc001d3db7800  HandleCount: <Data Not Accessible>
    Image: MsMpEng.exe

PROCESS ffffe00027e9c080
    SessionId: 0  Cid: 07c4    Peb: 412959e000  ParentCid: 0218
    DirBase: 3d07c000  ObjectTable: ffffc001d42a1e00  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe00027f3f080
    SessionId: 0  Cid: 0540    Peb: c1f49f6000  ParentCid: 0218
    DirBase: 3b7cb000  ObjectTable: ffffc001d42f4800  HandleCount: <Data Not Accessible>
    Image: NisSrv.exe

PROCESS ffffe00024fca480
    SessionId: 0  Cid: 0a60    Peb: dac372c000  ParentCid: 0218
    DirBase: 38063000  ObjectTable: ffffc001d4377940  HandleCount: <Data Not Accessible>
    Image: SearchIndexer.exe

PROCESS ffffe00024fdc840
    SessionId: 0  Cid: 0510    Peb: e0758f8000  ParentCid: 0260
    DirBase: 4b9c4000  ObjectTable: ffffc001d4c3a040  HandleCount: <Data Not Accessible>
    Image: WmiPrvSE.exe

PROCESS ffffe00025626840
    SessionId: 1  Cid: 0310    Peb: 35d9bb9000  ParentCid: 0124
    DirBase: 39aef000  ObjectTable: ffffc001d4655480  HandleCount: <Data Not Accessible>
    Image: sihost.exe

PROCESS ffffe00024f26080
    SessionId: 1  Cid: 00dc    Peb: cb2079000  ParentCid: 0124
    DirBase: 39e74000  ObjectTable: ffffc001d522ee40  HandleCount: <Data Not Accessible>
    Image: taskhostw.exe

PROCESS ffffe00025737080
    SessionId: 1  Cid: 0348    Peb: 5e7b0d8000  ParentCid: 01d8
    DirBase: 21b11000  ObjectTable: 00000000  HandleCount:   0.
    Image: userinit.exe

PROCESS ffffe00025690840
    SessionId: 1  Cid: 0a2c    Peb: 002cb000  ParentCid: 0348
    DirBase: 56340000  ObjectTable: ffffc001d5045cc0  HandleCount: <Data Not Accessible>
    Image: explorer.exe

PROCESS ffffe00025d8b840
    SessionId: 1  Cid: 0ae4    Peb: 002c5000  ParentCid: 0260
    DirBase: 4f7f3000  ObjectTable: ffffc001d4084600  HandleCount: <Data Not Accessible>
    Image: SkypeHost.exe

PROCESS ffffe000260a3540
    SessionId: 1  Cid: 0b08    Peb: 422e8af000  ParentCid: 0260
    DirBase: 20918000  ObjectTable: ffffc001d50c9680  HandleCount: <Data Not Accessible>
    Image: RuntimeBroker.exe

PROCESS ffffe000257fe840
    SessionId: 1  Cid: 0b8c    Peb: dbe4e44000  ParentCid: 0260
    DirBase: 36185000  ObjectTable: ffffc001d50847c0  HandleCount: <Data Not Accessible>
    Image: ShellExperienceHost.exe

PROCESS ffffe000260f6840
    SessionId: 1  Cid: 053c    Peb: 173e5ad000  ParentCid: 0260
    DirBase: 60b0a000  ObjectTable: ffffc001d5032140  HandleCount: <Data Not Accessible>
    Image: SearchUI.exe

PROCESS ffffe000263a5080
    SessionId: 1  Cid: 0d84    Peb: 0023b000  ParentCid: 0a2c
    DirBase: 6f54f000  ObjectTable: ffffc001d519d900  HandleCount: <Data Not Accessible>
    Image: VBoxTray.exe

PROCESS ffffe00027b07080
    SessionId: 1  Cid: 0dc4    Peb: 0034e000  ParentCid: 0a2c
    DirBase: 6f46d000  ObjectTable: ffffc001d522eb40  HandleCount: <Data Not Accessible>
    Image: OneDrive.exe

PROCESS ffffe00027eb4840
    SessionId: 1  Cid: 0ffc    Peb: d1fe671000  ParentCid: 0218
    DirBase: 5f48f000  ObjectTable: ffffc001d5777240  HandleCount: <Data Not Accessible>
    Image: svchost.exe

PROCESS ffffe00024f91580
    SessionId: 1  Cid: 0cb4    Peb: ded8184000  ParentCid: 0a2c
    DirBase: 6a9da000  ObjectTable: ffffc001d53c6880  HandleCount: <Data Not Accessible>
    Image: notepad.exe

kd> .process /i ffffe00024f91580
You need to continue execution (press 'g' <enter>) for the context
to be switched. When the debugger breaks in again, you will be in
the new process context.
kd> g
Break instruction exception - code 80000003 (first chance)
nt!DbgBreakPointWithStatus:
fffff802`08d4b6d0 cc              int     3
kd> dq fffff961`8a162230
fffff961`8a162230  cccc0000`863225ff cccccccc`cccccccc
fffff961`8a162240  cccc0000`862a25ff cccccccc`cccccccc
fffff961`8a162250  cccc0000`862225ff cccccccc`cccccccc
fffff961`8a162260  cccc0000`861a25ff cccccccc`cccccccc
fffff961`8a162270  cccc0000`861225ff cccccccc`cccccccc
fffff961`8a162280  cccc0000`860a25ff cccccccc`cccccccc
fffff961`8a162290  cccc0000`860225ff cccccccc`cccccccc
fffff961`8a1622a0  cccc0000`85fa25ff cccccccc`cccccccc
kd> u NtGdiGetDIBitsInternal
win32k!NtGdiGetDIBitsInternal:
fffff961`8a162230 ff2532860000    jmp     qword ptr [win32k!_imp_NtGdiGetDIBitsInternal (fffff961`8a16a868)]
fffff961`8a162236 cc              int     3
fffff961`8a162237 cc              int     3
fffff961`8a162238 cc              int     3
fffff961`8a162239 cc              int     3
fffff961`8a16223a cc              int     3
fffff961`8a16223b cc              int     3
fffff961`8a16223c cc              int     3
kd> u fffff961`8a16a868
win32k!_imp_NtGdiGetDIBitsInternal:
fffff961`8a16a868 d06ec4          shr     byte ptr [rsi-3Ch],1
fffff961`8a16a86b 8961f9          mov     dword ptr [rcx-7],esp
fffff961`8a16a86e ff              ???
fffff961`8a16a86f fff0            push    rax
fffff961`8a16a871 d8d3            fcom    st(3)
fffff961`8a16a873 8961f9          mov     dword ptr [rcx-7],esp
fffff961`8a16a876 ff              ???
fffff961`8a16a877 ff20            jmp     qword ptr [rax]
kd> dq win32k!_imp_NtGdiGetDIBitsInternal
fffff961`8a16a868  fffff961`89c46ed0 fffff961`89d3d8f0
fffff961`8a16a878  fffff961`89cf6b20 fffff961`89cda600
fffff961`8a16a888  fffff961`89c1a890 fffff961`89d43f60
fffff961`8a16a898  fffff961`89cf1b30 fffff961`89c97020
fffff961`8a16a8a8  fffff961`89c8c760 fffff961`89ea8090
fffff961`8a16a8b8  fffff961`89c55a60 fffff961`89cef290
fffff961`8a16a8c8  fffff961`89c8bab0 fffff961`89ce5c10
fffff961`8a16a8d8  fffff961`89c77290 fffff961`89ea7080
kd> u fffff961`89c46ed0
win32kfull!NtGdiGetDIBitsInternal:
fffff961`89c46ed0 4c8bdc          mov     r11,rsp
fffff961`89c46ed3 53              push    rbx
fffff961`89c46ed4 56              push    rsi
fffff961`89c46ed5 57              push    rdi
fffff961`89c46ed6 4154            push    r12
fffff961`89c46ed8 4155            push    r13
fffff961`89c46eda 4156            push    r14
fffff961`89c46edc 4157            push    r15
kd> uf fffff961`89c46ed0
win32kfull!NtGdiGetDIBitsInternal:
fffff961`89c46ed0 4c8bdc          mov     r11,rsp
fffff961`89c46ed3 53              push    rbx
fffff961`89c46ed4 56              push    rsi
fffff961`89c46ed5 57              push    rdi
fffff961`89c46ed6 4154            push    r12
fffff961`89c46ed8 4155            push    r13
fffff961`89c46eda 4156            push    r14
fffff961`89c46edc 4157            push    r15
fffff961`89c46ede 4881ecf0000000  sub     rsp,0F0h
fffff961`89c46ee5 488b05cca02d00  mov     rax,qword ptr [win32kfull!_security_cookie (fffff961`89f20fb8)]
fffff961`89c46eec 4833c4          xor     rax,rsp
fffff961`89c46eef 48898424e8000000 mov     qword ptr [rsp+0E8h],rax
fffff961`89c46ef7 4889942498000000 mov     qword ptr [rsp+98h],rdx
fffff961`89c46eff 48898c24b8000000 mov     qword ptr [rsp+0B8h],rcx
fffff961`89c46f07 48898c24a8000000 mov     qword ptr [rsp+0A8h],rcx
fffff961`89c46f0f 4889942490000000 mov     qword ptr [rsp+90h],rdx
fffff961`89c46f17 4489442460      mov     dword ptr [rsp+60h],r8d
fffff961`89c46f1c 44894c2458      mov     dword ptr [rsp+58h],r9d
fffff961`89c46f21 488b8c2450010000 mov     rcx,qword ptr [rsp+150h]
fffff961`89c46f29 4c8bbc2458010000 mov     r15,qword ptr [rsp+158h]
fffff961`89c46f31 4c89bc24b0000000 mov     qword ptr [rsp+0B0h],r15
fffff961`89c46f39 8b842468010000  mov     eax,dword ptr [rsp+168h]
fffff961`89c46f40 89442468        mov     dword ptr [rsp+68h],eax
fffff961`89c46f44 33ff            xor     edi,edi
fffff961`89c46f46 897c2450        mov     dword ptr [rsp+50h],edi
fffff961`89c46f4a 448d4701        lea     r8d,[rdi+1]
fffff961`89c46f4e 4489442470      mov     dword ptr [rsp+70h],r8d
fffff961`89c46f53 4989bb58ffffff  mov     qword ptr [r11-0A8h],rdi
fffff961`89c46f5a 498d4398        lea     rax,[r11-68h]
fffff961`89c46f5e 4889442478      mov     qword ptr [rsp+78h],rax
fffff961`89c46f63 448bac2460010000 mov     r13d,dword ptr [rsp+160h]
fffff961`89c46f6b 4183fd02        cmp     r13d,2
fffff961`89c46f6f 0f87f2030000    ja      win32kfull!NtGdiGetDIBitsInternal+0x497 (fffff961`89c47367)

win32kfull!NtGdiGetDIBitsInternal+0xa5:
fffff961`89c46f75 4d85ff          test    r15,r15
fffff961`89c46f78 0f84e9030000    je      win32kfull!NtGdiGetDIBitsInternal+0x497 (fffff961`89c47367)

win32kfull!NtGdiGetDIBitsInternal+0xae:
fffff961`89c46f7e 4885d2          test    rdx,rdx
fffff961`89c46f81 0f84e0030000    je      win32kfull!NtGdiGetDIBitsInternal+0x497 (fffff961`89c47367)

win32kfull!NtGdiGetDIBitsInternal+0xb7:
fffff961`89c46f87 41f7d9          neg     r9d
fffff961`89c46f8a 4d1be4          sbb     r12,r12
fffff961`89c46f8d 4c23e1          and     r12,rcx
fffff961`89c46f90 4c89a424a0000000 mov     qword ptr [rsp+0A0h],r12
fffff961`89c46f98 488b0559a63000  mov     rax,qword ptr [win32kfull!_imp_W32UserProbeAddress (fffff961`89f515f8)]
fffff961`89c46f9f 488b08          mov     rcx,qword ptr [rax]
fffff961`89c46fa2 498bc7          mov     rax,r15
fffff961`89c46fa5 4c3bf9          cmp     r15,rcx
fffff961`89c46fa8 480f43c1        cmovae  rax,rcx
fffff961`89c46fac 8a00            mov     al,byte ptr [rax]
fffff961`89c46fae 418b37          mov     esi,dword ptr [r15]
fffff961`89c46fb1 8bd6            mov     edx,esi
fffff961`89c46fb3 498bcf          mov     rcx,r15
fffff961`89c46fb6 ff153c7a3000    call    qword ptr [win32kfull!_imp_ProbeForWrite (fffff961`89f4e9f8)]
fffff961`89c46fbc 4d85e4          test    r12,r12
fffff961`89c46fbf 0f85f0010000    jne     win32kfull!NtGdiGetDIBitsInternal+0x2e5 (fffff961`89c471b5)

win32kfull!NtGdiGetDIBitsInternal+0xf5:
fffff961`89c46fc5 448d770c        lea     r14d,[rdi+0Ch]
fffff961`89c46fc9 413bf6          cmp     esi,r14d
fffff961`89c46fcc 0f84f2010000    je      win32kfull!NtGdiGetDIBitsInternal+0x2f4 (fffff961`89c471c4)

win32kfull!NtGdiGetDIBitsInternal+0x102:
fffff961`89c46fd2 bb28000000      mov     ebx,28h
fffff961`89c46fd7 448b742450      mov     r14d,dword ptr [rsp+50h]
fffff961`89c46fdc 3bf3            cmp     esi,ebx
fffff961`89c46fde 720e            jb      win32kfull!NtGdiGetDIBitsInternal+0x11e (fffff961`89c46fee)

win32kfull!NtGdiGetDIBitsInternal+0x110:
fffff961`89c46fe0 6641397f0e      cmp     word ptr [r15+0Eh],di
fffff961`89c46fe5 440f44f3        cmove   r14d,ebx
fffff961`89c46fe9 4489742450      mov     dword ptr [rsp+50h],r14d

win32kfull!NtGdiGetDIBitsInternal+0x11e:
fffff961`89c46fee 4585f6          test    r14d,r14d
fffff961`89c46ff1 0f851e010000    jne     win32kfull!NtGdiGetDIBitsInternal+0x245 (fffff961`89c47115)

win32kfull!NtGdiGetDIBitsInternal+0x127:
fffff961`89c46ff7 41391f          cmp     dword ptr [r15],ebx
fffff961`89c46ffa 7504            jne     win32kfull!NtGdiGetDIBitsInternal+0x130 (fffff961`89c47000)

win32kfull!NtGdiGetDIBitsInternal+0x12c:
fffff961`89c46ffc 41897f20        mov     dword ptr [r15+20h],edi

win32kfull!NtGdiGetDIBitsInternal+0x130:
fffff961`89c47000 418bd5          mov     edx,r13d
fffff961`89c47003 498bcf          mov     rcx,r15
fffff961`89c47006 e865030000      call    win32kfull!GreGetBitmapSize (fffff961`89c47370)
fffff961`89c4700b 448bf0          mov     r14d,eax
fffff961`89c4700e 4489742450      mov     dword ptr [rsp+50h],r14d
fffff961`89c47013 85c0            test    eax,eax
fffff961`89c47015 0f8415010000    je      win32kfull!NtGdiGetDIBitsInternal+0x260 (fffff961`89c47130)

win32kfull!NtGdiGetDIBitsInternal+0x14b:
fffff961`89c4701b 4889bc2488000000 mov     qword ptr [rsp+88h],rdi
fffff961`89c47023 ba47746d70      mov     edx,706D7447h
fffff961`89c47028 418bce          mov     ecx,r14d
fffff961`89c4702b ff157fa63000    call    qword ptr [win32kfull!_imp_Win32AllocPool (fffff961`89f516b0)]
fffff961`89c47031 488bf0          mov     rsi,rax
fffff961`89c47034 4889842488000000 mov     qword ptr [rsp+88h],rax
fffff961`89c4703c 4885c0          test    rax,rax
fffff961`89c4703f 740d            je      win32kfull!NtGdiGetDIBitsInternal+0x17e (fffff961`89c4704e)

win32kfull!NtGdiGetDIBitsInternal+0x171:
fffff961`89c47041 458bc6          mov     r8d,r14d
fffff961`89c47044 33d2            xor     edx,edx
fffff961`89c47046 488bc8          mov     rcx,rax
fffff961`89c47049 e832e00f00      call    win32kfull!memset (fffff961`89d45080)

win32kfull!NtGdiGetDIBitsInternal+0x17e:
fffff961`89c4704e 4889742478      mov     qword ptr [rsp+78h],rsi
fffff961`89c47053 4885f6          test    rsi,rsi
fffff961`89c47056 0f84d9000000    je      win32kfull!NtGdiGetDIBitsInternal+0x265 (fffff961`89c47135)

win32kfull!NtGdiGetDIBitsInternal+0x18c:
fffff961`89c4705c 4b8d0c37        lea     rcx,[r15+r14]
fffff961`89c47060 493bcf          cmp     rcx,r15
fffff961`89c47063 0f8275010000    jb      win32kfull!NtGdiGetDIBitsInternal+0x30e (fffff961`89c471de)

win32kfull!NtGdiGetDIBitsInternal+0x199:
fffff961`89c47069 488b0588a53000  mov     rax,qword ptr [win32kfull!_imp_W32UserProbeAddress (fffff961`89f515f8)]
fffff961`89c47070 483b08          cmp     rcx,qword ptr [rax]
fffff961`89c47073 0f8765010000    ja      win32kfull!NtGdiGetDIBitsInternal+0x30e (fffff961`89c471de)

win32kfull!NtGdiGetDIBitsInternal+0x1a9:
fffff961`89c47079 4d8bc6          mov     r8,r14
fffff961`89c4707c 498bd7          mov     rdx,r15
fffff961`89c4707f 488bce          mov     rcx,rsi
fffff961`89c47082 e8b9dc0f00      call    win32kfull!memmove (fffff961`89d44d40)
fffff961`89c47087 448bac2460010000 mov     r13d,dword ptr [rsp+160h]
fffff961`89c4708f 418bd5          mov     edx,r13d
fffff961`89c47092 488bce          mov     rcx,rsi
fffff961`89c47095 e8d6020000      call    win32kfull!GreGetBitmapSize (fffff961`89c47370)
fffff961`89c4709a 413bc6          cmp     eax,r14d
fffff961`89c4709d 0f8595010000    jne     win32kfull!NtGdiGetDIBitsInternal+0x368 (fffff961`89c47238)

win32kfull!NtGdiGetDIBitsInternal+0x1d3:
fffff961`89c470a3 391e            cmp     dword ptr [rsi],ebx
fffff961`89c470a5 7203            jb      win32kfull!NtGdiGetDIBitsInternal+0x1da (fffff961`89c470aa)

win32kfull!NtGdiGetDIBitsInternal+0x1d7:
fffff961`89c470a7 897e20          mov     dword ptr [rsi+20h],edi

win32kfull!NtGdiGetDIBitsInternal+0x1da:
fffff961`89c470aa 397c2458        cmp     dword ptr [rsp+58h],edi
fffff961`89c470ae 7452            je      win32kfull!NtGdiGetDIBitsInternal+0x232 (fffff961`89c47102)

win32kfull!NtGdiGetDIBitsInternal+0x1e0:
fffff961`89c470b0 391e            cmp     dword ptr [rsi],ebx
fffff961`89c470b2 0f8242010000    jb      win32kfull!NtGdiGetDIBitsInternal+0x32a (fffff961`89c471fa)

win32kfull!NtGdiGetDIBitsInternal+0x1e8:
fffff961`89c470b8 8b4608          mov     eax,dword ptr [rsi+8]
fffff961`89c470bb 85c0            test    eax,eax
fffff961`89c470bd 0f88eb000000    js      win32kfull!NtGdiGetDIBitsInternal+0x2de (fffff961`89c471ae)

win32kfull!NtGdiGetDIBitsInternal+0x1f3:
fffff961`89c470c3 8b4c2460        mov     ecx,dword ptr [rsp+60h]
fffff961`89c470c7 3bc1            cmp     eax,ecx
fffff961`89c470c9 0f42c8          cmovb   ecx,eax
fffff961`89c470cc 894c2460        mov     dword ptr [rsp+60h],ecx
fffff961`89c470d0 2bc1            sub     eax,ecx
fffff961`89c470d2 8b4c2458        mov     ecx,dword ptr [rsp+58h]
fffff961`89c470d6 3bc1            cmp     eax,ecx
fffff961`89c470d8 0f42c8          cmovb   ecx,eax
fffff961`89c470db 894c2458        mov     dword ptr [rsp+58h],ecx
fffff961`89c470df 397e04          cmp     dword ptr [rsi+4],edi
fffff961`89c470e2 0f8408010000    je      win32kfull!NtGdiGetDIBitsInternal+0x320 (fffff961`89c471f0)

win32kfull!NtGdiGetDIBitsInternal+0x218:
fffff961`89c470e8 66397e0c        cmp     word ptr [rsi+0Ch],di
fffff961`89c470ec 0f84fe000000    je      win32kfull!NtGdiGetDIBitsInternal+0x320 (fffff961`89c471f0)

win32kfull!NtGdiGetDIBitsInternal+0x222:
fffff961`89c470f2 66397e0e        cmp     word ptr [rsi+0Eh],di

win32kfull!NtGdiGetDIBitsInternal+0x226:
fffff961`89c470f6 8bc7            mov     eax,edi
fffff961`89c470f8 0f84f2000000    je      win32kfull!NtGdiGetDIBitsInternal+0x320 (fffff961`89c471f0)

win32kfull!NtGdiGetDIBitsInternal+0x22e:
fffff961`89c470fe 89442470        mov     dword ptr [rsp+70h],eax

win32kfull!NtGdiGetDIBitsInternal+0x232:
fffff961`89c47102 4585f6          test    r14d,r14d
fffff961`89c47105 0f844f010000    je      win32kfull!NtGdiGetDIBitsInternal+0x38a (fffff961`89c4725a)

win32kfull!NtGdiGetDIBitsInternal+0x23b:
fffff961`89c4710b 4d85e4          test    r12,r12
fffff961`89c4710e 752f            jne     win32kfull!NtGdiGetDIBitsInternal+0x26f (fffff961`89c4713f)

win32kfull!NtGdiGetDIBitsInternal+0x240:
fffff961`89c47110 e945010000      jmp     win32kfull!NtGdiGetDIBitsInternal+0x38a (fffff961`89c4725a)

win32kfull!NtGdiGetDIBitsInternal+0x245:
fffff961`89c47115 458bc6          mov     r8d,r14d
fffff961`89c47118 498bd7          mov     rdx,r15
fffff961`89c4711b 488d8c24c0000000 lea     rcx,[rsp+0C0h]
fffff961`89c47123 e818dc0f00      call    win32kfull!memmove (fffff961`89d44d40)
fffff961`89c47128 4489b424c0000000 mov     dword ptr [rsp+0C0h],r14d

win32kfull!NtGdiGetDIBitsInternal+0x260:
fffff961`89c47130 488b742478      mov     rsi,qword ptr [rsp+78h]

win32kfull!NtGdiGetDIBitsInternal+0x265:
fffff961`89c47135 448bac2460010000 mov     r13d,dword ptr [rsp+160h]
fffff961`89c4713d ebc3            jmp     win32kfull!NtGdiGetDIBitsInternal+0x232 (fffff961`89c47102)

win32kfull!NtGdiGetDIBitsInternal+0x26f:
fffff961`89c4713f 4885f6          test    rsi,rsi
fffff961`89c47142 0f8412010000    je      win32kfull!NtGdiGetDIBitsInternal+0x38a (fffff961`89c4725a)

win32kfull!NtGdiGetDIBitsInternal+0x278:
fffff961`89c47148 391e            cmp     dword ptr [rsi],ebx
fffff961`89c4714a 720e            jb      win32kfull!NtGdiGetDIBitsInternal+0x28a (fffff961`89c4715a)

win32kfull!NtGdiGetDIBitsInternal+0x27c:
fffff961`89c4714c 8b4610          mov     eax,dword ptr [rsi+10h]
fffff961`89c4714f ffc8            dec     eax
fffff961`89c47151 83f801          cmp     eax,1
fffff961`89c47154 0f86d5000000    jbe     win32kfull!NtGdiGetDIBitsInternal+0x35f (fffff961`89c4722f)

win32kfull!NtGdiGetDIBitsInternal+0x28a:
fffff961`89c4715a 397c2468        cmp     dword ptr [rsp+68h],edi
fffff961`89c4715e 0f84dd000000    je      win32kfull!NtGdiGetDIBitsInternal+0x371 (fffff961`89c47241)

win32kfull!NtGdiGetDIBitsInternal+0x294:
fffff961`89c47164 8b5c2468        mov     ebx,dword ptr [rsp+68h]
fffff961`89c47168 41b804000000    mov     r8d,4
fffff961`89c4716e 8bd3            mov     edx,ebx
fffff961`89c47170 498bcc          mov     rcx,r12
fffff961`89c47173 ff157f783000    call    qword ptr [win32kfull!_imp_ProbeForWrite (fffff961`89f4e9f8)]
fffff961`89c47179 41b804000000    mov     r8d,4
fffff961`89c4717f 8bd3            mov     edx,ebx
fffff961`89c47181 498bcc          mov     rcx,r12
fffff961`89c47184 ff154e723000    call    qword ptr [win32kfull!_imp_MmSecureVirtualMemory (fffff961`89f4e3d8)]
fffff961`89c4718a 4889842480000000 mov     qword ptr [rsp+80h],rax

win32kfull!NtGdiGetDIBitsInternal+0x2c2:
fffff961`89c47192 488b842480000000 mov     rax,qword ptr [rsp+80h]
fffff961`89c4719a 48f7d8          neg     rax
fffff961`89c4719d 1bc9            sbb     ecx,ecx
fffff961`89c4719f 4123ce          and     ecx,r14d
fffff961`89c471a2 448bf1          mov     r14d,ecx
fffff961`89c471a5 894c2450        mov     dword ptr [rsp+50h],ecx
fffff961`89c471a9 e9ac000000      jmp     win32kfull!NtGdiGetDIBitsInternal+0x38a (fffff961`89c4725a)

win32kfull!NtGdiGetDIBitsInternal+0x2de:
fffff961`89c471ae f7d8            neg     eax
fffff961`89c471b0 e90effffff      jmp     win32kfull!NtGdiGetDIBitsInternal+0x1f3 (fffff961`89c470c3)

win32kfull!NtGdiGetDIBitsInternal+0x2e5:
fffff961`89c471b5 bb28000000      mov     ebx,28h
fffff961`89c471ba 448b742450      mov     r14d,dword ptr [rsp+50h]
fffff961`89c471bf e92afeffff      jmp     win32kfull!NtGdiGetDIBitsInternal+0x11e (fffff961`89c46fee)

win32kfull!NtGdiGetDIBitsInternal+0x2f4:
fffff961`89c471c4 6641397f0a      cmp     word ptr [r15+0Ah],di
fffff961`89c471c9 0f8503feffff    jne     win32kfull!NtGdiGetDIBitsInternal+0x102 (fffff961`89c46fd2)

win32kfull!NtGdiGetDIBitsInternal+0x2ff:
fffff961`89c471cf 4489742450      mov     dword ptr [rsp+50h],r14d
fffff961`89c471d4 bb28000000      mov     ebx,28h
fffff961`89c471d9 e937ffffff      jmp     win32kfull!NtGdiGetDIBitsInternal+0x245 (fffff961`89c47115)

win32kfull!NtGdiGetDIBitsInternal+0x30e:
fffff961`89c471de 488b0513a43000  mov     rax,qword ptr [win32kfull!_imp_W32UserProbeAddress (fffff961`89f515f8)]
fffff961`89c471e5 488b08          mov     rcx,qword ptr [rax]
fffff961`89c471e8 408839          mov     byte ptr [rcx],dil
fffff961`89c471eb e989feffff      jmp     win32kfull!NtGdiGetDIBitsInternal+0x1a9 (fffff961`89c47079)

win32kfull!NtGdiGetDIBitsInternal+0x320:
fffff961`89c471f0 b801000000      mov     eax,1
fffff961`89c471f5 e904ffffff      jmp     win32kfull!NtGdiGetDIBitsInternal+0x22e (fffff961`89c470fe)

win32kfull!NtGdiGetDIBitsInternal+0x32a:
fffff961`89c471fa 0fb74606        movzx   eax,word ptr [rsi+6]
fffff961`89c471fe 8b4c2460        mov     ecx,dword ptr [rsp+60h]
fffff961`89c47202 3bc1            cmp     eax,ecx
fffff961`89c47204 0f42c8          cmovb   ecx,eax
fffff961`89c47207 894c2460        mov     dword ptr [rsp+60h],ecx
fffff961`89c4720b 2bc1            sub     eax,ecx
fffff961`89c4720d 8b4c2458        mov     ecx,dword ptr [rsp+58h]
fffff961`89c47211 3bc1            cmp     eax,ecx
fffff961`89c47213 0f42c8          cmovb   ecx,eax
fffff961`89c47216 894c2458        mov     dword ptr [rsp+58h],ecx
fffff961`89c4721a 66397e04        cmp     word ptr [rsi+4],di
fffff961`89c4721e 74d0            je      win32kfull!NtGdiGetDIBitsInternal+0x320 (fffff961`89c471f0)

win32kfull!NtGdiGetDIBitsInternal+0x350:
fffff961`89c47220 66397e08        cmp     word ptr [rsi+8],di
fffff961`89c47224 74ca            je      win32kfull!NtGdiGetDIBitsInternal+0x320 (fffff961`89c471f0)

win32kfull!NtGdiGetDIBitsInternal+0x356:
fffff961`89c47226 66397e0a        cmp     word ptr [rsi+0Ah],di
fffff961`89c4722a e9c7feffff      jmp     win32kfull!NtGdiGetDIBitsInternal+0x226 (fffff961`89c470f6)

win32kfull!NtGdiGetDIBitsInternal+0x35f:
fffff961`89c4722f 397e14          cmp     dword ptr [rsi+14h],edi
fffff961`89c47232 0f8522ffffff    jne     win32kfull!NtGdiGetDIBitsInternal+0x28a (fffff961`89c4715a)

win32kfull!NtGdiGetDIBitsInternal+0x368:
fffff961`89c47238 448bf7          mov     r14d,edi
fffff961`89c4723b 897c2450        mov     dword ptr [rsp+50h],edi
fffff961`89c4723f eb19            jmp     win32kfull!NtGdiGetDIBitsInternal+0x38a (fffff961`89c4725a)

win32kfull!NtGdiGetDIBitsInternal+0x371:
fffff961`89c47241 488bce          mov     rcx,rsi
fffff961`89c47244 e8c3ecffff      call    win32kfull!GreGetBitmapBitsSize (fffff961`89c45f0c)
fffff961`89c47249 89442468        mov     dword ptr [rsp+68h],eax
fffff961`89c4724d 3bc7            cmp     eax,edi
fffff961`89c4724f 0f843dffffff    je      win32kfull!NtGdiGetDIBitsInternal+0x2c2 (fffff961`89c47192)

win32kfull!NtGdiGetDIBitsInternal+0x385:
fffff961`89c47255 e90affffff      jmp     win32kfull!NtGdiGetDIBitsInternal+0x294 (fffff961`89c47164)

win32kfull!NtGdiGetDIBitsInternal+0x38a:
fffff961`89c4725a 488b942498000000 mov     rdx,qword ptr [rsp+98h]
fffff961`89c47262 488b8c24b8000000 mov     rcx,qword ptr [rsp+0B8h]
fffff961`89c4726a eb37            jmp     win32kfull!NtGdiGetDIBitsInternal+0x3d3 (fffff961`89c472a3)

win32kfull!NtGdiGetDIBitsInternal+0x3d3:
fffff961`89c472a3 4d85e4          test    r12,r12
fffff961`89c472a6 0f85a7000000    jne     win32kfull!NtGdiGetDIBitsInternal+0x483 (fffff961`89c47353)

win32kfull!NtGdiGetDIBitsInternal+0x3dc:
fffff961`89c472ac 4585f6          test    r14d,r14d
fffff961`89c472af 0f84b6000000    je      win32kfull!NtGdiGetDIBitsInternal+0x49b (fffff961`89c4736b)

win32kfull!NtGdiGetDIBitsInternal+0x3e5:
fffff961`89c472b5 4885f6          test    rsi,rsi
fffff961`89c472b8 0f84ad000000    je      win32kfull!NtGdiGetDIBitsInternal+0x49b (fffff961`89c4736b)

win32kfull!NtGdiGetDIBitsInternal+0x3ee:
fffff961`89c472be 4489742440      mov     dword ptr [rsp+40h],r14d
fffff961`89c472c3 8b442468        mov     eax,dword ptr [rsp+68h]
fffff961`89c472c7 89442438        mov     dword ptr [rsp+38h],eax
fffff961`89c472cb 44896c2430      mov     dword ptr [rsp+30h],r13d
fffff961`89c472d0 4889742428      mov     qword ptr [rsp+28h],rsi
fffff961`89c472d5 4c89642420      mov     qword ptr [rsp+20h],r12
fffff961`89c472da 448b4c2458      mov     r9d,dword ptr [rsp+58h]
fffff961`89c472df 448b442460      mov     r8d,dword ptr [rsp+60h]
fffff961`89c472e4 e897010000      call    win32kfull!GreGetDIBitsInternal (fffff961`89c47480)
fffff961`89c472e9 8bd8            mov     ebx,eax
fffff961`89c472eb 85c0            test    eax,eax
fffff961`89c472ed 7417            je      win32kfull!NtGdiGetDIBitsInternal+0x436 (fffff961`89c47306)

win32kfull!NtGdiGetDIBitsInternal+0x41f:
fffff961`89c472ef 458bc6          mov     r8d,r14d
fffff961`89c472f2 488bd6          mov     rdx,rsi
fffff961`89c472f5 498bcf          mov     rcx,r15
fffff961`89c472f8 e843da0f00      call    win32kfull!memmove (fffff961`89d44d40)
fffff961`89c472fd eb07            jmp     win32kfull!NtGdiGetDIBitsInternal+0x436 (fffff961`89c47306)

win32kfull!NtGdiGetDIBitsInternal+0x436:
fffff961`89c47306 488b8c2480000000 mov     rcx,qword ptr [rsp+80h]
fffff961`89c4730e 4885c9          test    rcx,rcx
fffff961`89c47311 754c            jne     win32kfull!NtGdiGetDIBitsInternal+0x48f (fffff961`89c4735f)

win32kfull!NtGdiGetDIBitsInternal+0x443:
fffff961`89c47313 4885f6          test    rsi,rsi
fffff961`89c47316 7416            je      win32kfull!NtGdiGetDIBitsInternal+0x45e (fffff961`89c4732e)

win32kfull!NtGdiGetDIBitsInternal+0x448:
fffff961`89c47318 488d8424c0000000 lea     rax,[rsp+0C0h]
fffff961`89c47320 483bf0          cmp     rsi,rax
fffff961`89c47323 7409            je      win32kfull!NtGdiGetDIBitsInternal+0x45e (fffff961`89c4732e)

win32kfull!NtGdiGetDIBitsInternal+0x455:
fffff961`89c47325 488bce          mov     rcx,rsi
fffff961`89c47328 ff1502a43000    call    qword ptr [win32kfull!_imp_Win32FreePool (fffff961`89f51730)]

win32kfull!NtGdiGetDIBitsInternal+0x45e:
fffff961`89c4732e 8bc3            mov     eax,ebx

win32kfull!NtGdiGetDIBitsInternal+0x460:
fffff961`89c47330 488b8c24e8000000 mov     rcx,qword ptr [rsp+0E8h]
fffff961`89c47338 4833cc          xor     rcx,rsp
fffff961`89c4733b e850c10f00      call    win32kfull!_security_check_cookie (fffff961`89d43490)
fffff961`89c47340 4881c4f0000000  add     rsp,0F0h
fffff961`89c47347 415f            pop     r15
fffff961`89c47349 415e            pop     r14
fffff961`89c4734b 415d            pop     r13
fffff961`89c4734d 415c            pop     r12
fffff961`89c4734f 5f              pop     rdi
fffff961`89c47350 5e              pop     rsi
fffff961`89c47351 5b              pop     rbx
fffff961`89c47352 c3              ret

win32kfull!NtGdiGetDIBitsInternal+0x483:
fffff961`89c47353 397c2470        cmp     dword ptr [rsp+70h],edi
fffff961`89c47357 0f844fffffff    je      win32kfull!NtGdiGetDIBitsInternal+0x3dc (fffff961`89c472ac)

win32kfull!NtGdiGetDIBitsInternal+0x48d:
fffff961`89c4735d eb0c            jmp     win32kfull!NtGdiGetDIBitsInternal+0x49b (fffff961`89c4736b)

win32kfull!NtGdiGetDIBitsInternal+0x48f:
fffff961`89c4735f ff156b703000    call    qword ptr [win32kfull!_imp_MmUnsecureVirtualMemory (fffff961`89f4e3d0)]
fffff961`89c47365 ebac            jmp     win32kfull!NtGdiGetDIBitsInternal+0x443 (fffff961`89c47313)

win32kfull!NtGdiGetDIBitsInternal+0x497:
fffff961`89c47367 33c0            xor     eax,eax
fffff961`89c47369 ebc5            jmp     win32kfull!NtGdiGetDIBitsInternal+0x460 (fffff961`89c47330)

win32kfull!NtGdiGetDIBitsInternal+0x49b:
fffff961`89c4736b 8bdf            mov     ebx,edi
fffff961`89c4736d eb97            jmp     win32kfull!NtGdiGetDIBitsInternal+0x436 (fffff961`89c47306)

`````

 
==================================================================================

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
