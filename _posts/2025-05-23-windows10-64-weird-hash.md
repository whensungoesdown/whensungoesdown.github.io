---
title: Windows 10 x64 22h2 weird hashes
published: true
---

I am testing windows 10 x64 generated password hashes for the cpu backdoor project.





`````shell
kd> !process 0 0
...

PROCESS ffff9a8fa5e6d080
    SessionId: 1  Cid: 0218    Peb: e83886000  ParentCid: 01d4
    DirBase: 7d0f0000  ObjectTable: ffffd801f7e84bc0  HandleCount: <Data Not Accessible>
    Image: winlogon.exe
...

kd> .process /i ffff9a8fa5e6d080
You need to continue execution (press 'g' <enter>) for the context
to be switched. When the debugger breaks in again, you will be in
the new process context.
kd> g
Break instruction exception - code 80000003 (first chance)
nt!RtlpBreakWithStatusInstruction:
fffff805`4b424e40 cc              int     3
kd> u ntdll!RtlCompareMemory
ntdll!RtlCompareMemory:
00007ffe`eeed1980 57              push    rdi
00007ffe`eeed1981 56              push    rsi
00007ffe`eeed1982 488bf1          mov     rsi,rcx
00007ffe`eeed1985 488bfa          mov     rdi,rdx
00007ffe`eeed1988 33d1            xor     edx,ecx
00007ffe`eeed198a 83e207          and     edx,7
00007ffe`eeed198d 7553            jne     ntdll!RtlCompareMemory+0x62 (00007ffe`eeed19e2)
00007ffe`eeed198f 4983f808        cmp     r8,8


`````

`````shell
kd> u ntdll!RtlCompareMemory L100
ntdll!RtlCompareMemory:
00007ffe`eeed1980 57              push    rdi
00007ffe`eeed1981 56              push    rsi
00007ffe`eeed1982 488bf1          mov     rsi,rcx
00007ffe`eeed1985 488bfa          mov     rdi,rdx
00007ffe`eeed1988 33d1            xor     edx,ecx
00007ffe`eeed198a 83e207          and     edx,7
00007ffe`eeed198d 7553            jne     ntdll!RtlCompareMemory+0x62 (00007ffe`eeed19e2)
00007ffe`eeed198f 4983f808        cmp     r8,8
00007ffe`eeed1993 724d            jb      ntdll!RtlCompareMemory+0x62 (00007ffe`eeed19e2)
00007ffe`eeed1995 4c8bcf          mov     r9,rdi
00007ffe`eeed1998 f7d9            neg     ecx
00007ffe`eeed199a 83e107          and     ecx,7
00007ffe`eeed199d 7407            je      ntdll!RtlCompareMemory+0x26 (00007ffe`eeed19a6)
00007ffe`eeed199f 4c2bc1          sub     r8,rcx
00007ffe`eeed19a2 f3a6            repe cmps byte ptr [rsi],byte ptr [rdi]
00007ffe`eeed19a4 7530            jne     ntdll!RtlCompareMemory+0x56 (00007ffe`eeed19d6)
00007ffe`eeed19a6 498bc8          mov     rcx,r8
00007ffe`eeed19a9 4883e1f8        and     rcx,0FFFFFFFFFFFFFFF8h
00007ffe`eeed19ad 741b            je      ntdll!RtlCompareMemory+0x4a (00007ffe`eeed19ca)
00007ffe`eeed19af 4c2bc1          sub     r8,rcx
00007ffe`eeed19b2 48c1e903        shr     rcx,3
00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
00007ffe`eeed19b9 740f            je      ntdll!RtlCompareMemory+0x4a (00007ffe`eeed19ca)
00007ffe`eeed19bb 48ffc1          inc     rcx
00007ffe`eeed19be 4883ee08        sub     rsi,8
00007ffe`eeed19c2 4883ef08        sub     rdi,8
00007ffe`eeed19c6 48c1e103        shl     rcx,3
00007ffe`eeed19ca 4c03c1          add     r8,rcx
00007ffe`eeed19cd 740a            je      ntdll!RtlCompareMemory+0x59 (00007ffe`eeed19d9)
00007ffe`eeed19cf 498bc8          mov     rcx,r8
00007ffe`eeed19d2 f3a6            repe cmps byte ptr [rsi],byte ptr [rdi]
00007ffe`eeed19d4 7403            je      ntdll!RtlCompareMemory+0x59 (00007ffe`eeed19d9)
00007ffe`eeed19d6 48ffcf          dec     rdi
00007ffe`eeed19d9 492bf9          sub     rdi,r9
00007ffe`eeed19dc 488bc7          mov     rax,rdi
00007ffe`eeed19df 5e              pop     rsi
00007ffe`eeed19e0 5f              pop     rdi
00007ffe`eeed19e1 c3              ret
00007ffe`eeed19e2 4d85c0          test    r8,r8
00007ffe`eeed19e5 740d            je      ntdll!RtlCompareMemory+0x74 (00007ffe`eeed19f4)
00007ffe`eeed19e7 498bc8          mov     rcx,r8
00007ffe`eeed19ea f3a6            repe cmps byte ptr [rsi],byte ptr [rdi]
00007ffe`eeed19ec 7406            je      ntdll!RtlCompareMemory+0x74 (00007ffe`eeed19f4)
00007ffe`eeed19ee 48ffc1          inc     rcx
00007ffe`eeed19f1 4c2bc1          sub     r8,rcx
00007ffe`eeed19f4 498bc0          mov     rax,r8
00007ffe`eeed19f7 5e              pop     rsi
00007ffe`eeed19f8 5f              pop     rdi
00007ffe`eeed19f9 c3              ret
00007ffe`eeed19fa cc              int     3
00007ffe`eeed19fb cc              int     3
00007ffe`eeed19fc cc              int     3
00007ffe`eeed19fd cc              int     3
00007ffe`eeed19fe cc              int     3
00007ffe`eeed19ff cc              int     3

`````


`````shell
kd> bp 00007ffe`eeed19b6 ".if @rcx = 0x2 {} .else {gc}"
breakpoint 1 redefined
kd> bl
 0 d 00007ffe`eeed1980     0001 (0001) ntdll!RtlCompareMemory
 1 e 00007ffe`eeed19b6     0001 (0001) ntdll!RtlCompareMemory+0x36 ".if @rcx = 0x2 {} .else {gc}"

kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000bb8c0fd9b0
kd> r rdi
rdi=00007ffeebff4610
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rdi
rdi=00007ffeebff4610
kd> r rsi
rsi=000000bb8c0fb270
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rsi
rsi=000000bb8c0fba00
kd> r rcx
rcx=0000000000000002
kd> r rdi
rdi=000000bb8c0fcb30

`````


`````shell
00007ffe`ebff4610 31e96ad1e0cfd631 c089c0e0d7593cb7

00007ffe`ebff4610 e0cfd631 31e96ad1 d7593cb7 c089c0e0

00007ffe`ebff4610 31 d6 cf e0 d1 6a e9 31 b7 3c 59 d7 e0 c0 89 c0




000000bb`8c0fd9b0 95431ceb08848e53 eff899104923d042

second break rsi
000000bb`8c0fb270 95431ceb08848e53 eff899104923d042

third break rsi
000000bb`8c0fba00 95431ceb08848e53 eff899104923d042
third break rdi
000000bb`8c0fcb30 a79016d797e6bd3d 78362812eb4b2069     <-- only this is the password's hash I entered
`````


the forth break
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000bb8c0fb030
kd> r rdi
rdi=00007ffeebff4610


000000bb`8c0fb030 95431ceb08848e53 eff899104923d042

00007ffe`ebff4610 31e96ad1e0cfd631 c089c0e0d7593cb7
`````


After 2 seconds, the fifth break
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000002b282e7d770
kd> r rdi
rdi=000002b282e7d8e0


000002b2`82e7d770 0000000000000000 0000000000000002 0000000000010003 01dbcb55f4056f9b

000002b2`82e7d8e0 0000000000000000 0000000000000002 0000000000000001 0000000000000001

`````


The sixth break
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000bb8c1fe3b0
kd> r rdi
rdi=00007ffeebff4610


000000bb`8c1fe3b0 95431ceb08848e53 eff899104923d042 0000000800000000 ffffdeff0aa68000

00007ffe`ebff4610 31e96ad1e0cfd631 c089c0e0d7593cb7 0000000000000001 000002b282e3d730

`````

Seventh break
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000bb8c1fe3b0
kd> r rdi
rdi=00007ffeebff4610


000000bb`8c1fe3b0 95431ceb08848e53 eff899104923d042 0000000000000000 0000000000000000

00007ffe`ebff4610 31e96ad1e0cfd631 c089c0e0d7593cb7 0000000000000001 000002b282e3d730


`````

Then goes quiet, and the "The password is incorrect. Try again." show up.



Now I reenter the password.

`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000bb8c0fd9b0
kd> r rdi
rdi=00007ffeebff4610


000000bb`8c0fd9b0 95431ceb08848e53 eff899104923d042 0000000800000000 ffffdeff0aa68000

00007ffe`ebff4610 31e96ad1e0cfd631 c089c0e0d7593cb7 0000000000000001 000002b282e3d730

`````

Fake rdi pointed data to be the same as rsi.

After few seconds, I got the second break.

`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000bb8c0fb270
kd> r rdi
rdi=00007ffeebff4610


000000bb`8c0fb270 95431ceb08848e53 eff899104923d042 0000000800000000 ffffdeff0aa68000

00007ffe`ebff4610 95431ceb08848e53 eff899104923d042 0000000000000001 000002b282e3d730

`````

Right away, got the third break.
`````shell
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000bb8c0fba00
kd> r rdi
rdi=000000bb8c0fcb30


000000bb`8c0fba00 31e96ad1e0cfd631 c089c0e0d7593cb7 ee0414b535b4d3aa ee0414b535b4d3aa

000000bb`8c0fcb30 a79016d797e6bd3d 78362812eb4b2069 00007ffeec1b1ca0 0000001200000001

`````

a79016d797e6bd3d 78362812eb4b2069 is the actual hash that generated from my input with NTLM hash algorithm.

I guess Windows 10 use two different hash algorithm to verify the password?


Not faking rdi, let go.


4th break
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000bb8c0fb030
kd> r rdi
rdi=00007ffeebff4610


000000bb`8c0fb030 95431ceb08848e53 eff899104923d042 0000000800000000 ffffdeff0aa68000

00007ffe`ebff4610 95431ceb08848e53 eff899104923d042 0000000000000001 000002b282e3d730

`````

after 2 seconds, 5th break
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000002b282e7d770
kd> r rdi
rdi=000002b282e7d8e0


000002b2`82e7d770 0000000000000000 0000000000000002 0000000000010003 01dbcb55f4056f9b

000002b2`82e7d8e0 0000000000000000 0000000000000002 0000000000000001 0000000000000001

`````

6th break
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000bb8c1fe3b0
kd> r rdi
rdi=00007ffeebff4610

000000bb`8c1fe3b0 95431ceb08848e53 eff899104923d042 0000000800000000 ffffdeff0aa68000

00007ffe`ebff4610 95431ceb08848e53 eff899104923d042 0000000000000001 000002b282e3d730

`````

7th break
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000bb8c1fe3b0
kd> r rdi
rdi=00007ffeebff4610


000000bb`8c1fe3b0 95431ceb08848e53 eff899104923d042 0000000000000000 0000000000000000

00007ffe`ebff4610 95431ceb08848e53 eff899104923d042 0000000000000001 000002b282e3d730

`````

Finally, it shows "The password is incorrect. Try again."



-----------------------------------------------

Windows asks me my security questions.

And then comes more breaks.

`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000d1661fe380
kd> r rdi
rdi=000001da30cabd00


000000d1`661fe380 4ba4e2445e4bb01f e08d6b1a1e8ad3b2 0000000000000000 00007ffeeee5ae20

000001da`30cabd00 4ba4e2445e4bb01f e08d6b1a1e8ad3b2 000001da30cabd10 000001da30cabd10

`````

2nd

`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcs
        ^ Bad register error in 'r rcs'
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000d1661fe380
kd> r rdi
rdi=000001da30cabd00

000000d1`661fe380 4ba4e2445e4bb01f e08d6b1a1e8ad3b2 42d43e580a01a004 7429cfc5093e93b3

000001da`30cabd00 4ba4e2445e4bb01f e08d6b1a1e8ad3b2 000001da30d29348 000001da30d29348

`````

3rd
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000d1661fe390
kd> r rdi
rdi=000001da30d29310


000000d1`661fe390 42d43e580a01a004 7429cfc5093e93b3 000001da2fd15340 000001da2fd15c00

000001da`30d29310 42d43e580a01a004 7429cfc5093e93b3 0000000000000000 0000000000000007

`````

4th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000d1661fe380
kd> r rdi
rdi=000001da30cabd00


000000d1`661fe380 4ba4e2445e4bb01f e08d6b1a1e8ad3b2 42d43e580a01a004 7429cfc5093e93b3

000001da`30cabd00 4ba4e2445e4bb01f e08d6b1a1e8ad3b2 000001da30d29348 000001da30d29348

`````

5th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da30ce80c8
kd> r rdi
rdi=000001da30d29310


000001da`30ce80c8 42d43e580a01a004 7429cfc5093e93b3 0000000000000000 0072006300000000

000001da`30d29310 42d43e580a01a004 7429cfc5093e93b3 0000000000000000 0000000000000007

`````

6th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da2fecce60
kd> r rdi
rdi=000001da30d29310


000001da`2fecce60 42d43e580a01a004 7429cfc5093e93b3 000001da2fecd420 000001da30c58050

000001da`30d29310 42d43e580a01a004 7429cfc5093e93b3 0000000000000000 0000000000000007

`````

7th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da2fecce60
kd> r rdi
rdi=000001da30d29310


000001da`2fecce60 42d43e580a01a004 7429cfc5093e93b3 000001da2fecd420 000001da30c58050

000001da`30d29310 42d43e580a01a004 7429cfc5093e93b3 0000000000000000 0000000000000007

`````

8th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da30793aa8
kd> r rdi
rdi=000001da30ceb3c8


000001da`30793aa8 49061aa2db57eb61 324c02b8e8239693 a3a0384500000000 0000000041c64e6d

000001da`30ceb3c8 4ff70bd2bce9c4d2 7f2cbb2592d6948f 0000000000000000 ffffffff00000000

`````

9th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da307475a8
kd> r rdi
rdi=000001da30ceb3c


000001da`307475a8 440b4238b5ccd5ef fe1c8f829f99a0bb a3ae204500000000 0000000041c64e6d

000001da`30ceb3c8 4ff70bd2bce9c4d2 7f2cbb2592d6948f 0000000000000000 ffffffff00000000

`````

10th
`````shell
kd> kb
RetAddr           : Args to Child                                                           : Call Site
00000000`00000000 : 00000000`00000000 00000000`00000000 00000000`00000000 00000000`00000000 : ntdll!RtlCompareMemory+0x36
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da307c8458
kd> r rdi
rdi=000001da30ceb3c8


000001da`307c8458 456b505e7cd4a68a 1c49dda576ca1eb1 a3a1b84500000000 0000000041c64e6d

000001da`30ceb3c8 4ff70bd2bce9c4d2 7f2cbb2592d6948f 0000000000000000 ffffffff00000000

`````

11th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da3072e398
kd> r rdi
rdi=000001da30ceb3c8


000001da`3072e398 456b505e7cd4a68a 1c49dda576ca1eb1 a3a5184500000000 0000000041c64e6d

000001da`30ceb3c8 4ff70bd2bce9c4d2 7f2cbb2592d6948f 0000000000000000 ffffffff00000000

`````

12th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da307c3e18
kd> r rdi
rdi=000001da30ceb3c8


000001da`307c3e18 456b505e7cd4a68a 1c49dda576ca1eb1 a3a2304500000000 0000000041c64e6d

000001da`30ceb3c8 4ff70bd2bce9c4d2 7f2cbb2592d6948f 0000000000000000 ffffffff00000000

`````

13th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da307b0218
kd> r rdi
rdi=000001da30ceb3c8


000001da`307b0218 4f4e67dcfe081f7f fb8edc5c55d64aa7 a3a7c84500000000 0000000041c64e6d

000001da`30ceb3c8 4ff70bd2bce9c4d2 7f2cbb2592d6948f 0000000000000000 ffffffff00000000

`````

14th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da3077d8d8
kd> r rdi
rdi=000001da30ceb3c8


000001da`3077d8d8 456b505e7cd4a68a 1c49dda576ca1eb1 a3a8484500000000 0000000041c64e6d

000001da`30ceb3c8 4ff70bd2bce9c4d2 7f2cbb2592d6948f 0000000000000000 ffffffff00000000

`````

15th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da307c7378
kd> r rdi
rdi=000001da30ceb3c8


000001da`307c7378 456b505e7cd4a68a 1c49dda576ca1eb1 a3a2384500000000 0000000041c64e6d

000001da`30ceb3c8 4ff70bd2bce9c4d2 7f2cbb2592d6948f 0000000000000000 ffffffff00000000

`````

16th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da30770b88
kd> r rdi
rdi=000001da30ceb3c8


000001da`30770b88 440b4238b5ccd5ef fe1c8f829f99a0bb a3a7784500000000 0000000041c64e6d

000001da`30ceb3c8 4ff70bd2bce9c4d2 7f2cbb2592d6948f 0000000000000000 ffffffff00000000

`````

17th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ffe`eeed19b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000001da30780648
kd> r rdi
rdi=000001da30ceb3c8


000001da`30780648 456b505e7cd4a68a 1c49dda576ca1eb1 a3a9584500000000 0000000041c64e6d

000001da`30ceb3c8 4ff70bd2bce9c4d2 7f2cbb2592d6948f 0000000000000000 ffffffff00000000

`````


There are too many of them.

I disabled the breakpoint, entered the correct password. But the system still says password incorrect.

And later the login screen shows a button says "Sign in". Then I do not need a password to login.
Even I tried to use Win+L to lock the screen, it still shows the sign-in button and no need password anymore.

--------------------------------------------------------

Enter the correct password "uuu"


1st
`````shell
kd> bp 00007ff9`13d519b6 ".if @rcx = 0x2 {} .else {gc}"
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ff9`13d519b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000256f15d820
kd> r rdi
rdi=00007ff910e74610


00000025`6f15d820 95431ceb08848e53 eff899104923d042 0000000800000000 ffffdeff0aa68000

00007ff9`10e74610 31e96ad1e0cfd631 c089c0e0d7593cb7 0000000000000001 0000016336c3d630

`````

2nd
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ff9`13d519b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000256f15b0e0
kd> r rdi
rdi=00007ff910e74610


00000025`6f15b0e0 95431ceb08848e53 eff899104923d042 0000000800000000 ffffdeff0aa68000

00007ff9`10e74610 31e96ad1e0cfd631 c089c0e0d7593cb7 0000000000000001 0000016336c3d630

`````

3rd
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ff9`13d519b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000256f15b870
kd> r rdi
rdi=000000256f15c9a0


kd> kv
Child-SP          RetAddr           : Args to Child                                                           : Call Site
00000025`6f15b6c8 00007ff9`109b94cd : 00000163`00000000 00000000`00000001 00000000`00000000 00007ff9`13cd3119 : ntdll!RtlCompareMemory+0x36
00000025`6f15b6e0 00000163`00000000 : 00000000`00000001 00000000`00000000 00007ff9`13cd3119 00000000`00000037 : 0x7ff9`109b94cd
00000025`6f15b6e8 00000000`00000001 : 00000000`00000000 00007ff9`13cd3119 00000000`00000037 00000000`00000000 : 0x163`00000000
00000025`6f15b6f0 00000000`00000000 : 00007ff9`13cd3119 00000000`00000037 00000000`00000000 00000000`000011a0 : 0x1


00000025`6f15b870 95431ceb08848e53 eff899104923d042 ee0414b535b4d3aa ee0414b535b4d3aa

00000025`6f15c9a0 95431ceb08848e53 eff899104923d042 0000000000000000 0000016336cbf9e0

`````

4th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ff9`13d519b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=00007ff910a52010
kd> r rdi
rdi=0000016337a0c210
kd> kv
Child-SP          RetAddr           : Args to Child                                                           : Call Site
00000025`6f15b8d8 00007ff9`109eef5b : 00000000`00000000 00007ff9`113a26ee 00000000`00000002 7fffffff`ffffffff : ntdll!RtlCompareMemory+0x36
00000025`6f15b8f0 00000000`00000000 : 00007ff9`113a26ee 00000000`00000002 7fffffff`ffffffff 00000025`6f15b9e0 : 0x7ff9`109eef5b


00007ff9`10a52010 31e96ad1e0cfd631 c089c0e0d7593cb7 0000000000560054 00007ff910a3cdd0

00000163`37a0c210 95431ceb08848e53 eff899104923d042 0000000000000000 0000000800000000


`````


5th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ff9`13d519b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=0000016336c7d770
kd> r rdi
rdi=0000016336c7d8e0
kd> kv
Child-SP          RetAddr           : Args to Child                                                           : Call Site
00000025`6f15b6e8 00007ff9`10dcde1c : 00000163`373df2c8 00007ff9`10daa714 00000000`00000000 00000163`37a0c200 : ntdll!RtlCompareMemory+0x36
00000025`6f15b700 00000163`373df2c8 : 00007ff9`10daa714 00000000`00000000 00000163`37a0c200 00000163`373f5501 : 0x7ff9`10dcde1c
00000025`6f15b708 00007ff9`10daa714 : 00000000`00000000 00000163`37a0c200 00000163`373f5501 00000000`00000000 : 0x163`373df2c8
00000025`6f15b710 00000000`00000000 : 00000163`37a0c200 00000163`373f5501 00000000`00000000 00000000`00000000 : 0x7ff9`10daa714


00000163`36c7d770 0000000000000000 0000000000000002 0000000000010003 01dbcb55f4056f9b

00000163`36c7d8e0 0000000000000000 0000000000000002 0000000000000001 0000000000000001

`````

6th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ff9`13d519b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000256f15e550
kd> r rdi
rdi=00007ff910e74610
kd> kv
Child-SP          RetAddr           : Args to Child                                                           : Call Site
00000025`6f15e318 00000000`00000000 : 00000000`00000000 00000000`00000000 00000000`00000000 00000000`00000000 : ntdll!RtlCompareMemory+0x36


00000025`6f15e550 95431ceb08848e53 eff899104923d042 0000000800000000 ffffdeff0aa68000

00007ff9`10e74610 31e96ad1e0cfd631 c089c0e0d7593cb7 0000000000000001 0000016336c3d630

`````

7th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ff9`13d519b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=000000256f15e550
kd> r rdi
rdi=00007ff910e74610
kd> kv
Child-SP          RetAddr           : Args to Child                                                           : Call Site
00000025`6f15e318 00000000`00000000 : 00000000`00000000 00000000`00000000 00000000`00000000 00000000`00000000 : ntdll!RtlCompareMemory+0x36


00000025`6f15e550 95431ceb08848e53 eff899104923d042 0000000000000000 0000000000000000

00007ff9`10e74610 31e96ad1e0cfd631 c089c0e0d7593cb7 0000000000000001 0000016336c3d630

`````

8th
`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ff9`13d519b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=00007ff90a545dd0
kd> r rdi
rdi=000001911d8ab0c8
kd> kv
Child-SP          RetAddr           : Args to Child                                                           : Call Site
00000069`bd37e4c8 00000000`00000000 : 00000000`00000000 00000000`00000000 00000000`00000000 00000000`00000000 : ntdll!RtlCompareMemory+0x36


00007ff9`0a545dd0 440b4238b5ccd5ef fe1c8f829f99a0bb 0000000000000000 6f6c6c6120646162

00000191`1d8ab0c8 440b4238b5ccd5ef fe1c8f829f99a0bb 000001911d8a7080 000001911d889c90

`````



------------------------------

After logged into the system, the break point is still triggered, and looks like hash compare again.

`````shell
kd> g
ntdll!RtlCompareMemory+0x36:
0033:00007ff9`13d519b6 f348a7          repe cmps qword ptr [rsi],qword ptr [rdi]
kd> r rcx
rcx=0000000000000002
kd> r rsi
rsi=0000013ad925bb60
kd> r rdi
rdi=0000013ad909f070

kd> kv
Child-SP          RetAddr           : Args to Child                                                           : Call Site
00000033`e7d7f8b8 00000000`00000000 : 00000000`00000000 00000000`00000000 00000000`00000000 00000000`00000000 : ntdll!RtlCompareMemory+0x36


0000013a`d925bb60 4d8f630921cfc7ae edbd0bba15471cab 0000013ad92b8220 0000013ada5b88d0

0000013a`d909f070 4d8f630921cfc7ae edbd0bba15471cab 0000000000000000 0000000000000007

`````



-----------------------------------

Turns out, “31d6cfe0d16ae931b73c59d7e0c089c0” is the hash for empty password.
