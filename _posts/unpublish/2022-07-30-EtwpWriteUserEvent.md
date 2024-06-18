---
title: EtwpWriteUserEvent
published: false
---



case 62

`````shell
DOUBLE FETCH:   cr3 0x120c9d000, syscall 0x5e
   eip 0xfffff80179c99665, user_address 0x7592d7f5e0, user_data 0x49, modrm 0x4a, pc 0xfffff80179c99706
   eip 0xfffff80179c99d12, user_address 0x7592d7f5e0, user_data 0x49, modrm 0x54, pc 0xfffff80179c99ade

`````

`````shell
                             LAB_14040f6eb                                   XREF[1]:     14040f73b(j)  
       14040f6eb 89 85 bc        MOV        dword ptr [RBP + local_28c],EAX
                 00 00 00
       14040f6f1 41 3b c7        CMP        EAX,R15D
       14040f6f4 0f 83 b5        JNC        LAB_14040f7af
                 00 00 00
       14040f6fa 45 8b ce        MOV        param_4,R14D
       14040f6fd 8b c8           MOV        param_1,EAX
       14040f6ff 48 c1 e1 04     SHL        param_1,0x4
       14040f703 48 03 d1        ADD        param_2,param_1
   --> 14040f706 8b 4a 08        MOV        param_1,dword ptr [param_2 + 0x8]
       14040f709 89 4d 7c        MOV        dword ptr [RBP + local_2cc],param_1
       14040f70c 44 8b c1        MOV        param_3,param_1
       14040f70f 81 f9 ff        CMP        param_1,0xffff
                 ff 00 00
       14040f715 77 56           JA         LAB_14040f76d
       14040f717 45 84 d2        TEST       R10B,R10B
       14040f71a 75 21           JNZ        LAB_14040f73d
       14040f71c 32 c9           XOR        param_1,param_1

`````


`````shell
                             LAB_14040fac3                                   XREF[1]:     14040fb76(j)  
       14040fac3 89 9d b8        MOV        dword ptr [RBP + local_290],EBX
                 00 00 00
       14040fac9 3b 9d 98        CMP        EBX,dword ptr [RBP + param_10]
                 03 00 00
       14040facf 0f 83 bf        JNC        LAB_14040fb94
                 00 00 00
       14040fad5 8b c3           MOV        EAX,EBX
       14040fad7 48 03 c0        ADD        RAX,RAX
       14040fada 48 8b 4d 50     MOV        param_1,qword ptr [RBP + local_2f8]
   --> 14040fade 8b 54 c1 08     MOV        param_2,dword ptr [param_1 + RAX*0x8 + 0x8]
       14040fae2 4c 8b 14 c1     MOV        R10,qword ptr [param_1 + RAX*0x8]
       14040fae6 45 84 ed        TEST       R13B,R13B
       14040fae9 0f 85 8c        JNZ        LAB_14040fb7b
                 00 00 00
       14040faef 32 c9           XOR        param_1,param_1

`````

The data read is `user_data 0x49`. It might be a "size", so I need to search functions like memcpy, memmove in the context.

`````shell
      --> v49 = *(_DWORD *)(v48 + 8);
          *(_DWORD *)(a4 + 124) = v49;
          v20 = v49;
      *   if ( v49 > 0xFFFF )
          {
            *(_DWORD *)(a4 + 16) = 0x80000005;
            v22 = *(_BYTE *)a4;
            v51 = *(_QWORD *)(a4 + 24);
            v23 = 1;
            v52 = *(_QWORD *)(a4 + 64);
            v53 = *(_QWORD *)(a4 + 56);
            goto LABEL_146;
          }
`````

This is the first fetch. After the if statement, v49 never be used.


`````shell
        while ( 1 )
        {
          *(_DWORD *)(a4 + 184) = v69;
          if ( v69 >= *(_DWORD *)(a4 + 920) )
            break;
          v71 = *(_QWORD *)(a4 + 80);
      --> v72 = *(_DWORD *)(v71 + 16i64 * v69 + 8);
          v73 = *(char **)(v71 + 16i64 * v69);
          if ( v70 )
          {
            LOBYTE(v71) = *(_BYTE *)(v71 + 16i64 * v69 + 12);
            v39 = *(_DWORD *)(a4 + 4);
            v68 = *(char **)(a4 + 144);
            v60 = *(_DWORD *)(a4 + 12);
          }
          else
          {
            LOBYTE(v71) = 0;
          }
          LODWORD(v71) = (unsigned __int8)v71;
          if ( (_BYTE)v71 )
          {
            v78 = v71 - 1;
            if ( v78 )
            {
              if ( v78 == 2 && (_DWORD)v72 == 8 )
              {
                if ( v73 + 8 > MmUserProbeAddress || v73 + 8 < v73 )
                  *(_BYTE *)MmUserProbeAddress = 0;
                *(_QWORD *)(a4 + 128) = *(_QWORD *)v73;
              }
            }
            else
            {
              if ( !v68
                || (v20 = v72, v79 = &v68[v72], (unsigned __int64)&v68[v72] > *(_QWORD *)(a4 + 192))
                || !*(_DWORD *)(a4 + 44) )
              {
                *(_DWORD *)(a4 + 16) = -1073741820;
                *(_DWORD *)v59 = v39 | *(_DWORD *)(*(_QWORD *)(a4 + 112) + 28i64);
                *(_QWORD *)(v59 + 16) = *(_QWORD *)(a4 + 128);
                v22 = *(_BYTE *)a4;
                v51 = *(_QWORD *)(a4 + 24);
                v23 = 1;
                v52 = *(_QWORD *)(a4 + 64);
                v53 = *(_QWORD *)(a4 + 56);
                goto LABEL_146;
              }
   -->       if ( (_DWORD)v72 && (&v73[v72] > MmUserProbeAddress || &v73[v72] < v73) )
                *(_BYTE *)MmUserProbeAddress = 0;
              memmove(v68, v73, v72);
              v68 = v79;
              *(_QWORD *)(a4 + 144) = v79;
              --*(_DWORD *)(a4 + 44);
            }
          }
          else
          {
            v21 = v59 + (unsigned int)v60;
            v74 = v72 + v60;
            if ( (signed int)v72 + v60 < (unsigned int)v60 )
            {
              *(_DWORD *)(a4 + 12) = -1;
LABEL_140:
              *(_DWORD *)(a4 + 16) = -1073741820;
              *(_DWORD *)v59 = v39 | *(_DWORD *)(*(_QWORD *)(a4 + 112) + 28i64);
              *(_QWORD *)(v59 + 16) = *(_QWORD *)(a4 + 128);
              v22 = *(_BYTE *)a4;
              v51 = *(_QWORD *)(a4 + 24);
              v23 = 1;
              v52 = *(_QWORD *)(a4 + 64);
              v53 = *(_QWORD *)(a4 + 56);
              goto LABEL_146;
            }
            *(_DWORD *)(a4 + 12) = v74;
            if ( v74 > v39 )
              goto LABEL_140;
            v75 = *(_BYTE *)(v188 + 562);
            *(_BYTE *)(a4 + 120) = v75;
            if ( v75 && (_DWORD)v72 && (&v73[v72] > MmUserProbeAddress || &v73[v72] < v73) )
              *(_BYTE *)MmUserProbeAddress = 0;
            memmove((void *)(v59 + (unsigned int)v60), v73, v72);
            v39 = *(_DWORD *)(a4 + 4);
            v68 = *(char **)(a4 + 144);
            v60 = *(_DWORD *)(a4 + 12);
          }
          ++v69;
          v59 = *(_QWORD *)(a4 + 104);
        }
`````

This is the second fetch. When some conditions meet, the v72 is used as the size of a memmove.

Set breakpoint at fffff800`cee1fb5c memmove

`````shell
kd> g
Breakpoint 0 hit
nt!EtwpWriteUserEvent+0x79c:
fffff800`cee1fb5c e81fdcd3ff      call    nt!memmove (fffff800`ceb5d780)

rcx: ffffe0005d2785d0
rdx: 19abe5c1d40
r8 : 1c


kd> db @rdx
0000019a`be5c1d40  01 05 00 00 00 00 00 05-15 00 00 00 0f 88 75 e9  ..............u.
0000019a`be5c1d50  2c 33 7f 2d 19 31 ec 24-e9 03 00 00 04 00 04 00  ,3.-.1.$........
0000019a`be5c1d60  60 1d 5c be 9a 01 00 00-30 c2 55 be 9a 01 00 00  `.\.....0.U.....
0000019a`be5c1d70  10 b3 51 be 9a 01 00 00-d1 43 5e be 9a 01 00 00  ..Q......C^.....
0000019a`be5c1d80  44 00 45 00 53 00 4b 00-54 00 4f 00 50 00 2d 00  D.E.S.K.T.O.P.-.
0000019a`be5c1d90  4d 00 43 00 45 00 4c 00-38 00 53 00 55 00 02 00  M.C.E.L.8.S.U...
0000019a`be5c1da0  44 00 45 00 53 00 4b 00-54 00 4f 00 50 00 2d 00  D.E.S.K.T.O.P.-.
0000019a`be5c1db0  4d 00 43 00 45 00 4c 00-38 00 53 00 55 00 00 00  M.C.E.L.8.S.U...
`````

This is a copy-user-buffer-to-kernel-buffer.

Unfortnately, there are some checks for v72.

`````shell
     PAGE:000000014040FAF1 loc_14040FAF1:                          ; CODE XREF: EtwpWriteUserEvent+7CFj
     PAGE:000000014040FAF1                 movzx   ecx, cl
     PAGE:000000014040FAF4                 test    ecx, ecx
     PAGE:000000014040FAF6                 jnz     loc_14040FBB6
     PAGE:000000014040FAFC                 mov     r9d, r15d
 *   PAGE:000000014040FAFF                 add     r9, r11
 >   PAGE:000000014040FB02                 lea     eax, [rdx+r15]
     PAGE:000000014040FB06                 cmp     eax, r15d
     PAGE:000000014040FB09                 jb      loc_14040FF52
     PAGE:000000014040FB0F                 mov     [rbp+0Ch], eax
 >   PAGE:000000014040FB12                 cmp     eax, r14d
     PAGE:000000014040FB15                 ja      loc_14040FF59
     PAGE:000000014040FB1B                 mov     rax, gs:188h
     PAGE:000000014040FB24                 movzx   ecx, byte ptr [rax+232h]
     PAGE:000000014040FB2B                 mov     [rbp+78h], cl
     PAGE:000000014040FB2E                 test    cl, cl
     PAGE:000000014040FB30                 jz      short loc_14040FB53
     PAGE:000000014040FB32                 test    edx, edx
     PAGE:000000014040FB34                 jz      short loc_14040FB53
     PAGE:000000014040FB36                 lea     rcx, [r10+rdx]
     PAGE:000000014040FB3A                 mov     rax, cs:MmUserProbeAddress
     PAGE:000000014040FB41                 cmp     rcx, rax
     PAGE:000000014040FB44                 ja      loc_14040FF4A
     PAGE:000000014040FB4A                 cmp     rcx, r10
     PAGE:000000014040FB4D                 jb      loc_14040FF4A
     PAGE:000000014040FB53
     PAGE:000000014040FB53 loc_14040FB53:                          ; CODE XREF: EtwpWriteUserEvent+770j
     PAGE:000000014040FB53                                         ; EtwpWriteUserEvent+774j ...
     PAGE:000000014040FB53                 mov     r8, rdx         ; Size
     PAGE:000000014040FB56                 mov     rdx, r10        ; Src
     PAGE:000000014040FB59                 mov     rcx, r9         ; Dst
     PAGE:000000014040FB5C                 call    memmove
     PAGE:000000014040FB61                 mov     r14d, [rbp+4]
     PAGE:000000014040FB65                 mov     rdi, [rbp+90h]
     PAGE:000000014040FB6C                 mov     r15d, [rbp+0Ch]
`````

edx is v72, which stores the size, after *, eax carries rdx+r15 and later there are two size checks against r15d r14d.

If I set edx with a large value like 20001c, it won't pass those two checks.


The root cause of this being unexplitable is that the first fetch does not contorl the allocation of the buffer.



So, how large is the kernel buffer.

`````shell
kd> g
Breakpoint 0 hit
nt!EtwpWriteUserEvent+0x79c:
fffff800`cee1fb5c e81fdcd3ff      call    nt!memmove (fffff800`ceb5d780)
kd> db ffffc000ec7510b0 L100
ffffc000`ec7510b0  03 00 00 00 0e 20 37 00-2f 00 0e 20 32 00 39 00  ..... 7./.. 2.9.
ffffc000`ec7510c0  2f 00 0e 20 32 00 30 00-32 00 32 00 20 00 31 00  /.. 2.0.2.2. .1.
ffffc000`ec7510d0  31 00 3a 00 32 00 31 00-20 00 50 00 4d 00 00 00  1.:.2.1. .P.M...
ffffc000`ec7510e0  98 00 13 c0 01 00 00 00-cc 07 00 00 04 03 00 00  ................
ffffc000`ec7510f0  34 9b c8 92 dc a3 d8 01-ea 24 7b de c8 73 09 4a  4........${..s.J
ffffc000`ec751100  98 5d 5b da dc fa 90 17-20 03 00 13 04 00 20 03  .][..... ..... .
ffffc000`ec751110  00 00 00 00 00 00 00 08-0a 00 00 00 07 00 00 00  ................
ffffc000`ec751120  00 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00  ................
ffffc000`ec751130  18 00 02 00 00 00 0c 00-01 01 00 00 00 00 00 05  ................
ffffc000`ec751140  12 00 00 00 00 00 00 00-01 00 00 00 0e 20 37 00  ............. 7.
ffffc000`ec751150  2f 00 0e 20 32 00 39 00-2f 00 0e 20 32 00 30 00  /.. 2.9./.. 2.0.
ffffc000`ec751160  32 00 32 00 20 00 31 00-31 00 3a 00 32 00 31 00  2.2. .1.1.:.2.1.
ffffc000`ec751170  20 00 50 00 4d 00 00 00-41 8c 06 ff db a3 d8 01   .P.M...A.......
ffffc000`ec751180  46 55 a7 11 34 32 5e 46-be c8 2d 30 1c b5 01 ac  FU..42^F..-0....
ffffc000`ec751190  09 00 00 10 04 00 01 00-00 00 00 00 00 00 00 80  ................
ffffc000`ec7511a0  01 00 00 00 00 00 00 00-00 00 00 00 00 00 00 00  ................
kd> db 3f323fe4d0 L100
0000003f`323fe4d0  44 00 45 00 53 00 4b 00-54 00 4f 00 50 00 2d 00  D.E.S.K.T.O.P.-.
0000003f`323fe4e0  4d 00 43 00 45 00 4c 00-38 00 53 00 55 00 5c 00  M.C.E.L.8.S.U.\.
0000003f`323fe4f0  75 00 00 00 f1 17 00 00-00 00 00 00 00 00 00 00  u...............
0000003f`323fe500  40 00 00 00 00 00 00 00-40 99 40 7a 03 02 00 00  @.......@.@z....
0000003f`323fe510  a0 00 00 00 00 00 00 00-9c 9b 4f bb fe 7f 00 00  ..........O.....
0000003f`323fe520  20 a1 16 b9 fe 7f 00 00-88 e5 3f 32 3f 00 00 00   .........?2?...
0000003f`323fe530  c0 a3 1a b9 fe 7f 00 00-28 28 48 7a 03 02 00 00  ........((Hz....
0000003f`323fe540  20 a3 1a b9 fe 7f 00 00-bc 57 11 b9 fe 7f 00 00   ........W......
0000003f`323fe550  4c 4e b4 7a 03 02 00 00-80 99 10 b9 fe 7f 00 00  LN.z............
0000003f`323fe560  00 00 e2 bd fe 7f 00 00-67 a1 16 b9 fe 7f 00 00  ........g.......
0000003f`323fe570  9c b5 b7 7a 03 02 00 00-39 e6 3f 32 3f 00 00 00  ...z....9.?2?...
0000003f`323fe580  b0 b5 b7 7a 03 02 00 00-03 01 07 80 00 00 00 00  ...z............
0000003f`323fe590  c0 b5 b7 7a 03 02 00 00-c1 88 10 b9 fe 7f 00 00  ...z............
0000003f`323fe5a0  d0 e6 3f 32 3f 00 00 00-20 a1 16 b9 fe 7f 00 00  ..?2?... .......
0000003f`323fe5b0  68 01 00 00 00 00 00 00-00 22 48 7a 03 02 00 00  h........"Hz....
0000003f`323fe5c0  08 00 00 00 00 00 00 00-f0 4e b4 7a 03 02 00 00  .........N.z....
kd> p
nt!EtwpWriteUserEvent+0x7a1:
fffff800`cee1fb61 448b7504        mov     r14d,dword ptr [rbp+4]
kd> db ffffc000ec7510b0 L100
ffffc000`ec7510b0  44 00 45 00 53 00 4b 00-54 00 4f 00 50 00 2d 00  D.E.S.K.T.O.P.-.
ffffc000`ec7510c0  4d 00 43 00 45 00 4c 00-38 00 53 00 55 00 5c 00  M.C.E.L.8.S.U.\.
ffffc000`ec7510d0  75 00 00 00 f1 17 00 00-00 00 00 00 00 00 00 00  u...............
ffffc000`ec7510e0  40 00 00 00 00 00 00 00-40 99 40 7a 03 02 00 00  @.......@.@z....
ffffc000`ec7510f0  a0 00 00 00 00 00 00 00-9c 9b 4f bb fe 7f 00 00  ..........O.....
ffffc000`ec751100  20 a1 16 b9 fe 7f 00 00-88 e5 3f 32 3f 00 00 00   .........?2?...
ffffc000`ec751110  c0 a3 1a b9 fe 7f 00 00-28 28 48 7a 03 02 00 00  ........((Hz....
ffffc000`ec751120  20 a3 1a b9 fe 7f 00 00-bc 57 11 b9 fe 7f 00 00   ........W......
ffffc000`ec751130  4c 4e b4 7a 03 02 00 00-80 99 10 b9 fe 7f 00 00  LN.z............
ffffc000`ec751140  00 00 e2 bd fe 7f 00 00-67 a1 16 b9 fe 7f 00 00  ........g.......
ffffc000`ec751150  9c b5 b7 7a 03 02 00 00-39 e6 3f 32 3f 00 00 00  ...z....9.?2?...
ffffc000`ec751160  b0 b5 b7 7a 03 02 00 00-03 01 07 80 00 00 00 00  ...z............
ffffc000`ec751170  c0 b5 b7 7a 03 02 00 00-c1 88 10 b9 fe 7f 00 00  ...z............
ffffc000`ec751180  d0 e6 3f 32 3f 00 00 00-20 a1 16 b9 fe 7f 00 00  ..?2?... .......
ffffc000`ec751190  68 01 00 00 00 00 00 00-00 22 48 7a 03 02 00 00  h........"Hz....
ffffc000`ec7511a0  08 00 00 00 00 00 00 00-f0 4e b4 7a 03 02 00 00  .........N.z....

`````

I made the user buffer size larger but not too much, for example, 24->124.


