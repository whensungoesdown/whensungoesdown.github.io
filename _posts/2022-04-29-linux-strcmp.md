---
title: strcmp in Linux
published: true
---

`````shell
(gdb) disassemble 
Dump of assembler code for function __strcmp_avx2:
=> 0x00007ffff7f30ae0 <+0>:	endbr64 
   0x00007ffff7f30ae4 <+4>:	mov    %edi,%eax
   0x00007ffff7f30ae6 <+6>:	xor    %edx,%edx
   0x00007ffff7f30ae8 <+8>:	vpxor  %ymm7,%ymm7,%ymm7
   0x00007ffff7f30aec <+12>:	or     %esi,%eax
   0x00007ffff7f30aee <+14>:	and    $0xfff,%eax
   0x00007ffff7f30af3 <+19>:	cmp    $0xf80,%eax
   0x00007ffff7f30af8 <+24>:	jg     0x7ffff7f30e50 <__strcmp_avx2+880>
   0x00007ffff7f30afe <+30>:	vmovdqu (%rdi),%ymm1
   0x00007ffff7f30b02 <+34>:	vpcmpeqb (%rsi),%ymm1,%ymm0
   0x00007ffff7f30b06 <+38>:	vpminub %ymm1,%ymm0,%ymm0
   0x00007ffff7f30b0a <+42>:	vpcmpeqb %ymm7,%ymm0,%ymm0
   0x00007ffff7f30b0e <+46>:	vpmovmskb %ymm0,%ecx
   0x00007ffff7f30b12 <+50>:	test   %ecx,%ecx
   0x00007ffff7f30b14 <+52>:	je     0x7ffff7f30b90 <__strcmp_avx2+176>
   0x00007ffff7f30b16 <+54>:	tzcnt  %ecx,%edx
   0x00007ffff7f30b1a <+58>:	movzbl (%rdi,%rdx,1),%eax
   0x00007ffff7f30b1e <+62>:	movzbl (%rsi,%rdx,1),%edx
   0x00007ffff7f30b22 <+66>:	sub    %edx,%eax
   0x00007ffff7f30b24 <+68>:	vzeroupper 
   0x00007ffff7f30b27 <+71>:	retq   
   0x00007ffff7f30b28 <+72>:	nopl   0x0(%rax,%rax,1)
   0x00007ffff7f30b30 <+80>:	tzcnt  %ecx,%edx
   0x00007ffff7f30b34 <+84>:	movzbl 0x20(%rdi,%rdx,1),%eax
   0x00007ffff7f30b39 <+89>:	movzbl 0x20(%rsi,%rdx,1),%edx
   0x00007ffff7f30b3e <+94>:	sub    %edx,%eax
   0x00007ffff7f30b40 <+96>:	vzeroupper 
   0x00007ffff7f30b43 <+99>:	retq   
   0x00007ffff7f30b44 <+100>:	data16 nopw %cs:0x0(%rax,%rax,1)
   0x00007ffff7f30b4f <+111>:	nop
   0x00007ffff7f30b50 <+112>:	tzcnt  %ecx,%edx
   0x00007ffff7f30b54 <+116>:	movzbl 0x40(%rdi,%rdx,1),%eax
   0x00007ffff7f30b59 <+121>:	movzbl 0x40(%rsi,%rdx,1),%edx
   0x00007ffff7f30b5e <+126>:	sub    %edx,%eax
   0x00007ffff7f30b60 <+128>:	vzeroupper 
--Type <RET> for more, q to quit, c to continue without paging--
   0x00007ffff7f30b63 <+131>:	retq   
   0x00007ffff7f30b64 <+132>:	data16 nopw %cs:0x0(%rax,%rax,1)
   0x00007ffff7f30b6f <+143>:	nop
   0x00007ffff7f30b70 <+144>:	tzcnt  %ecx,%edx
   0x00007ffff7f30b74 <+148>:	movzbl 0x60(%rdi,%rdx,1),%eax
   0x00007ffff7f30b79 <+153>:	movzbl 0x60(%rsi,%rdx,1),%edx
   0x00007ffff7f30b7e <+158>:	sub    %edx,%eax
   0x00007ffff7f30b80 <+160>:	vzeroupper 
   0x00007ffff7f30b83 <+163>:	retq   
   0x00007ffff7f30b84 <+164>:	data16 nopw %cs:0x0(%rax,%rax,1)
   0x00007ffff7f30b8f <+175>:	nop
   0x00007ffff7f30b90 <+176>:	vmovdqu 0x20(%rdi),%ymm6
   0x00007ffff7f30b95 <+181>:	vpcmpeqb 0x20(%rsi),%ymm6,%ymm3
   0x00007ffff7f30b9a <+186>:	vpminub %ymm6,%ymm3,%ymm3
   0x00007ffff7f30b9e <+190>:	vpcmpeqb %ymm7,%ymm3,%ymm3
   0x00007ffff7f30ba2 <+194>:	vpmovmskb %ymm3,%ecx
   0x00007ffff7f30ba6 <+198>:	test   %ecx,%ecx
   0x00007ffff7f30ba8 <+200>:	jne    0x7ffff7f30b30 <__strcmp_avx2+80>
   0x00007ffff7f30baa <+202>:	vmovdqu 0x40(%rdi),%ymm5
   0x00007ffff7f30baf <+207>:	vmovdqu 0x60(%rdi),%ymm4
   0x00007ffff7f30bb4 <+212>:	vmovdqu 0x60(%rsi),%ymm0
   0x00007ffff7f30bb9 <+217>:	vpcmpeqb 0x40(%rsi),%ymm5,%ymm2
   0x00007ffff7f30bbe <+222>:	vpminub %ymm5,%ymm2,%ymm2
   0x00007ffff7f30bc2 <+226>:	vpcmpeqb %ymm4,%ymm0,%ymm0
   0x00007ffff7f30bc6 <+230>:	vpcmpeqb %ymm7,%ymm2,%ymm2
   0x00007ffff7f30bca <+234>:	vpmovmskb %ymm2,%ecx
   0x00007ffff7f30bce <+238>:	test   %ecx,%ecx
   0x00007ffff7f30bd0 <+240>:	jne    0x7ffff7f30b50 <__strcmp_avx2+112>
   0x00007ffff7f30bd6 <+246>:	vpminub %ymm4,%ymm0,%ymm0
   0x00007ffff7f30bda <+250>:	vpcmpeqb %ymm7,%ymm0,%ymm0
   0x00007ffff7f30bde <+254>:	vpmovmskb %ymm0,%ecx
   0x00007ffff7f30be2 <+258>:	test   %ecx,%ecx
   0x00007ffff7f30be4 <+260>:	jne    0x7ffff7f30b70 <__strcmp_avx2+144>
   0x00007ffff7f30be6 <+262>:	lea    0x80(%rdi),%rdx
   0x00007ffff7f30bed <+269>:	mov    $0x1000,%ecx
   0x00007ffff7f30bf2 <+274>:	and    $0xffffffffffffff80,%rdx
--Type <RET> for more, q to quit, c to continue without paging--
   0x00007ffff7f30bf6 <+278>:	sub    %rdi,%rdx
   0x00007ffff7f30bf9 <+281>:	lea    (%rdi,%rdx,1),%rax
   0x00007ffff7f30bfd <+285>:	add    %rsi,%rdx
   0x00007ffff7f30c00 <+288>:	mov    %rdx,%rsi
   0x00007ffff7f30c03 <+291>:	and    $0xfff,%esi
   0x00007ffff7f30c09 <+297>:	sub    %rsi,%rcx
   0x00007ffff7f30c0c <+300>:	shr    $0x7,%rcx
   0x00007ffff7f30c10 <+304>:	mov    %ecx,%esi
   0x00007ffff7f30c12 <+306>:	jmp    0x7ffff7f30c2d <__strcmp_avx2+333>
   0x00007ffff7f30c14 <+308>:	data16 nopw %cs:0x0(%rax,%rax,1)
   0x00007ffff7f30c1f <+319>:	nop
   0x00007ffff7f30c20 <+320>:	add    $0x80,%rax
   0x00007ffff7f30c26 <+326>:	add    $0x80,%rdx
   0x00007ffff7f30c2d <+333>:	test   %esi,%esi
   0x00007ffff7f30c2f <+335>:	lea    -0x1(%esi),%esi
   0x00007ffff7f30c33 <+339>:	je     0x7ffff7f30d10 <__strcmp_avx2+560>
   0x00007ffff7f30c39 <+345>:	vmovdqa (%rax),%ymm0
   0x00007ffff7f30c3d <+349>:	vmovdqa 0x20(%rax),%ymm3
   0x00007ffff7f30c42 <+354>:	vpcmpeqb (%rdx),%ymm0,%ymm4
   0x00007ffff7f30c46 <+358>:	vpcmpeqb 0x20(%rdx),%ymm3,%ymm1
   0x00007ffff7f30c4b <+363>:	vpminub %ymm0,%ymm4,%ymm4
   0x00007ffff7f30c4f <+367>:	vpminub %ymm3,%ymm1,%ymm1
   0x00007ffff7f30c53 <+371>:	vmovdqa 0x40(%rax),%ymm2
   0x00007ffff7f30c58 <+376>:	vpminub %ymm1,%ymm4,%ymm0
   0x00007ffff7f30c5c <+380>:	vmovdqa 0x60(%rax),%ymm3
   0x00007ffff7f30c61 <+385>:	vpcmpeqb 0x40(%rdx),%ymm2,%ymm5
   0x00007ffff7f30c66 <+390>:	vpcmpeqb 0x60(%rdx),%ymm3,%ymm6
   0x00007ffff7f30c6b <+395>:	vpminub %ymm2,%ymm5,%ymm5
   0x00007ffff7f30c6f <+399>:	vpminub %ymm3,%ymm6,%ymm6
   0x00007ffff7f30c73 <+403>:	vpminub %ymm5,%ymm0,%ymm0
   0x00007ffff7f30c77 <+407>:	vpminub %ymm6,%ymm0,%ymm0
   0x00007ffff7f30c7b <+411>:	vpcmpeqb %ymm7,%ymm0,%ymm0
   0x00007ffff7f30c7f <+415>:	vpmovmskb %ymm0,%ecx
   0x00007ffff7f30c83 <+419>:	test   %ecx,%ecx
   0x00007ffff7f30c85 <+421>:	je     0x7ffff7f30c20 <__strcmp_avx2+320>
   0x00007ffff7f30c87 <+423>:	vpcmpeqb %ymm7,%ymm4,%ymm0
--Type <RET> for more, q to quit, c to continue without paging--
   0x00007ffff7f30c8b <+427>:	vpmovmskb %ymm0,%edi
   0x00007ffff7f30c8f <+431>:	test   %edi,%edi
   0x00007ffff7f30c91 <+433>:	je     0x7ffff7f30cb0 <__strcmp_avx2+464>
   0x00007ffff7f30c93 <+435>:	tzcnt  %edi,%ecx
   0x00007ffff7f30c97 <+439>:	movzbl (%rax,%rcx,1),%eax
   0x00007ffff7f30c9b <+443>:	movzbl (%rdx,%rcx,1),%edx
   0x00007ffff7f30c9f <+447>:	sub    %edx,%eax
   0x00007ffff7f30ca1 <+449>:	vzeroupper 
   0x00007ffff7f30ca4 <+452>:	retq   
   0x00007ffff7f30ca5 <+453>:	data16 nopw %cs:0x0(%rax,%rax,1)
   0x00007ffff7f30cb0 <+464>:	vpcmpeqb %ymm7,%ymm1,%ymm1
   0x00007ffff7f30cb4 <+468>:	vpmovmskb %ymm1,%ecx
   0x00007ffff7f30cb8 <+472>:	test   %ecx,%ecx
   0x00007ffff7f30cba <+474>:	je     0x7ffff7f30cd0 <__strcmp_avx2+496>
   0x00007ffff7f30cbc <+476>:	tzcnt  %ecx,%edi
   0x00007ffff7f30cc0 <+480>:	movzbl 0x20(%rax,%rdi,1),%eax
   0x00007ffff7f30cc5 <+485>:	movzbl 0x20(%rdx,%rdi,1),%edx
   0x00007ffff7f30cca <+490>:	sub    %edx,%eax
   0x00007ffff7f30ccc <+492>:	vzeroupper 
   0x00007ffff7f30ccf <+495>:	retq   
   0x00007ffff7f30cd0 <+496>:	vpcmpeqb %ymm7,%ymm5,%ymm5
   0x00007ffff7f30cd4 <+500>:	vpmovmskb %ymm5,%ecx
   0x00007ffff7f30cd8 <+504>:	test   %ecx,%ecx
   0x00007ffff7f30cda <+506>:	je     0x7ffff7f30cf0 <__strcmp_avx2+528>
   0x00007ffff7f30cdc <+508>:	tzcnt  %ecx,%edi
   0x00007ffff7f30ce0 <+512>:	movzbl 0x40(%rax,%rdi,1),%eax
   0x00007ffff7f30ce5 <+517>:	movzbl 0x40(%rdx,%rdi,1),%edx
   0x00007ffff7f30cea <+522>:	sub    %edx,%eax
   0x00007ffff7f30cec <+524>:	vzeroupper 
   0x00007ffff7f30cef <+527>:	retq   
   0x00007ffff7f30cf0 <+528>:	vpcmpeqb %ymm7,%ymm6,%ymm6
   0x00007ffff7f30cf4 <+532>:	vpmovmskb %ymm6,%esi
   0x00007ffff7f30cf8 <+536>:	tzcnt  %esi,%ecx
   0x00007ffff7f30cfc <+540>:	movzbl 0x60(%rax,%rcx,1),%eax
   0x00007ffff7f30d01 <+545>:	movzbl 0x60(%rdx,%rcx,1),%edx
   0x00007ffff7f30d06 <+550>:	sub    %edx,%eax
--Type <RET> for more, q to quit, c to continue without paging--
   0x00007ffff7f30d08 <+552>:	vzeroupper 
   0x00007ffff7f30d0b <+555>:	retq   
   0x00007ffff7f30d0c <+556>:	nopl   0x0(%rax)
   0x00007ffff7f30d10 <+560>:	xor    %r10d,%r10d
   0x00007ffff7f30d13 <+563>:	mov    %rdx,%rcx
   0x00007ffff7f30d16 <+566>:	and    $0x7f,%ecx
   0x00007ffff7f30d19 <+569>:	sub    %rcx,%r10
   0x00007ffff7f30d1c <+572>:	cmp    $0x40,%ecx
   0x00007ffff7f30d1f <+575>:	jge    0x7ffff7f30d80 <__strcmp_avx2+672>
   0x00007ffff7f30d21 <+577>:	vmovdqu (%rax,%r10,1),%ymm2
   0x00007ffff7f30d27 <+583>:	vmovdqu 0x20(%rax,%r10,1),%ymm3
   0x00007ffff7f30d2e <+590>:	vpcmpeqb (%rdx,%r10,1),%ymm2,%ymm0
   0x00007ffff7f30d34 <+596>:	vpcmpeqb 0x20(%rdx,%r10,1),%ymm3,%ymm1
   0x00007ffff7f30d3b <+603>:	vpminub %ymm2,%ymm0,%ymm0
   0x00007ffff7f30d3f <+607>:	vpminub %ymm3,%ymm1,%ymm1
   0x00007ffff7f30d43 <+611>:	vpcmpeqb %ymm7,%ymm0,%ymm0
   0x00007ffff7f30d47 <+615>:	vpcmpeqb %ymm7,%ymm1,%ymm1
   0x00007ffff7f30d4b <+619>:	vpmovmskb %ymm0,%edi
   0x00007ffff7f30d4f <+623>:	vpmovmskb %ymm1,%esi
   0x00007ffff7f30d53 <+627>:	shl    $0x20,%rsi
   0x00007ffff7f30d57 <+631>:	xor    %rsi,%rdi
   0x00007ffff7f30d5a <+634>:	shr    %cl,%rdi
   0x00007ffff7f30d5d <+637>:	test   %rdi,%rdi
   0x00007ffff7f30d60 <+640>:	je     0x7ffff7f30d80 <__strcmp_avx2+672>
   0x00007ffff7f30d62 <+642>:	tzcnt  %rdi,%rcx
   0x00007ffff7f30d67 <+647>:	movzbl (%rax,%rcx,1),%eax
   0x00007ffff7f30d6b <+651>:	movzbl (%rdx,%rcx,1),%edx
   0x00007ffff7f30d6f <+655>:	sub    %edx,%eax
   0x00007ffff7f30d71 <+657>:	vzeroupper 
   0x00007ffff7f30d74 <+660>:	retq   
   0x00007ffff7f30d75 <+661>:	data16 nopw %cs:0x0(%rax,%rax,1)
   0x00007ffff7f30d80 <+672>:	vmovdqu 0x40(%rax,%r10,1),%ymm2
   0x00007ffff7f30d87 <+679>:	vmovdqu 0x60(%rax,%r10,1),%ymm3
   0x00007ffff7f30d8e <+686>:	vpcmpeqb 0x40(%rdx,%r10,1),%ymm2,%ymm5
   0x00007ffff7f30d95 <+693>:	vpminub %ymm2,%ymm5,%ymm5
   0x00007ffff7f30d99 <+697>:	vpcmpeqb 0x60(%rdx,%r10,1),%ymm3,%ymm6
--Type <RET> for more, q to quit, c to continue without paging--
   0x00007ffff7f30da0 <+704>:	vpcmpeqb %ymm7,%ymm5,%ymm5
   0x00007ffff7f30da4 <+708>:	vpminub %ymm3,%ymm6,%ymm6
   0x00007ffff7f30da8 <+712>:	vpcmpeqb %ymm7,%ymm6,%ymm6
   0x00007ffff7f30dac <+716>:	vpmovmskb %ymm5,%edi
   0x00007ffff7f30db0 <+720>:	vpmovmskb %ymm6,%esi
   0x00007ffff7f30db4 <+724>:	shl    $0x20,%rsi
   0x00007ffff7f30db8 <+728>:	xor    %rsi,%rdi
   0x00007ffff7f30dbb <+731>:	xor    %r8d,%r8d
   0x00007ffff7f30dbe <+734>:	sub    $0x40,%ecx
   0x00007ffff7f30dc1 <+737>:	jle    0x7ffff7f30dc9 <__strcmp_avx2+745>
   0x00007ffff7f30dc3 <+739>:	shr    %cl,%rdi
   0x00007ffff7f30dc6 <+742>:	mov    %ecx,%r8d
   0x00007ffff7f30dc9 <+745>:	mov    $0x1f,%esi
   0x00007ffff7f30dce <+750>:	test   %rdi,%rdi
   0x00007ffff7f30dd1 <+753>:	je     0x7ffff7f30c39 <__strcmp_avx2+345>
   0x00007ffff7f30dd7 <+759>:	tzcnt  %rdi,%rcx
   0x00007ffff7f30ddc <+764>:	add    %r10,%rcx
   0x00007ffff7f30ddf <+767>:	add    %r8,%rcx
   0x00007ffff7f30de2 <+770>:	movzbl 0x40(%rax,%rcx,1),%eax
   0x00007ffff7f30de7 <+775>:	movzbl 0x40(%rdx,%rcx,1),%edx
   0x00007ffff7f30dec <+780>:	sub    %edx,%eax
   0x00007ffff7f30dee <+782>:	vzeroupper 
   0x00007ffff7f30df1 <+785>:	retq   
   0x00007ffff7f30df2 <+786>:	data16 nopw %cs:0x0(%rax,%rax,1)
   0x00007ffff7f30dfd <+797>:	nopl   (%rax)
   0x00007ffff7f30e00 <+800>:	sub    %ecx,%eax
   0x00007ffff7f30e02 <+802>:	jne    0x7ffff7f30e21 <__strcmp_avx2+833>
   0x00007ffff7f30e04 <+804>:	add    $0x1,%edx
   0x00007ffff7f30e07 <+807>:	cmp    $0x80,%edx
   0x00007ffff7f30e0d <+813>:	je     0x7ffff7f30be6 <__strcmp_avx2+262>
   0x00007ffff7f30e13 <+819>:	movzbl (%rdi,%rdx,1),%eax
   0x00007ffff7f30e17 <+823>:	movzbl (%rsi,%rdx,1),%ecx
   0x00007ffff7f30e1b <+827>:	test   %eax,%eax
   0x00007ffff7f30e1d <+829>:	jne    0x7ffff7f30e00 <__strcmp_avx2+800>
   0x00007ffff7f30e1f <+831>:	sub    %ecx,%eax
   0x00007ffff7f30e21 <+833>:	vzeroupper 
--Type <RET> for more, q to quit, c to continue without paging--
   0x00007ffff7f30e24 <+836>:	retq   
   0x00007ffff7f30e25 <+837>:	data16 nopw %cs:0x0(%rax,%rax,1)
   0x00007ffff7f30e30 <+848>:	add    %rdx,%rdi
   0x00007ffff7f30e33 <+851>:	add    %rdx,%rsi
   0x00007ffff7f30e36 <+854>:	tzcnt  %ecx,%edx
   0x00007ffff7f30e3a <+858>:	movzbl (%rdi,%rdx,1),%eax
   0x00007ffff7f30e3e <+862>:	movzbl (%rsi,%rdx,1),%edx
   0x00007ffff7f30e42 <+866>:	sub    %edx,%eax
   0x00007ffff7f30e44 <+868>:	vzeroupper 
   0x00007ffff7f30e47 <+871>:	retq   
   0x00007ffff7f30e48 <+872>:	nopl   0x0(%rax,%rax,1)
   0x00007ffff7f30e50 <+880>:	cmp    $0xfe0,%eax
   0x00007ffff7f30e55 <+885>:	jg     0x7ffff7f30e7e <__strcmp_avx2+926>
   0x00007ffff7f30e57 <+887>:	vmovdqu (%rdi,%rdx,1),%ymm1
   0x00007ffff7f30e5c <+892>:	vpcmpeqb (%rsi,%rdx,1),%ymm1,%ymm0
   0x00007ffff7f30e61 <+897>:	vpminub %ymm1,%ymm0,%ymm0
   0x00007ffff7f30e65 <+901>:	vpcmpeqb %ymm7,%ymm0,%ymm0
   0x00007ffff7f30e69 <+905>:	vpmovmskb %ymm0,%ecx
   0x00007ffff7f30e6d <+909>:	test   %ecx,%ecx
   0x00007ffff7f30e6f <+911>:	jne    0x7ffff7f30e30 <__strcmp_avx2+848>
   0x00007ffff7f30e71 <+913>:	add    $0x20,%edx
   0x00007ffff7f30e74 <+916>:	add    $0x20,%eax
   0x00007ffff7f30e77 <+919>:	cmp    $0xfe0,%eax
   0x00007ffff7f30e7c <+924>:	jle    0x7ffff7f30e57 <__strcmp_avx2+887>
   0x00007ffff7f30e7e <+926>:	cmp    $0xff0,%eax
   0x00007ffff7f30e83 <+931>:	jg     0x7ffff7f30ea5 <__strcmp_avx2+965>
   0x00007ffff7f30e85 <+933>:	vmovdqu (%rdi,%rdx,1),%xmm1
   0x00007ffff7f30e8a <+938>:	vpcmpeqb (%rsi,%rdx,1),%xmm1,%xmm0
   0x00007ffff7f30e8f <+943>:	vpminub %xmm1,%xmm0,%xmm0
   0x00007ffff7f30e93 <+947>:	vpcmpeqb %xmm7,%xmm0,%xmm0
   0x00007ffff7f30e97 <+951>:	vpmovmskb %xmm0,%ecx
   0x00007ffff7f30e9b <+955>:	test   %ecx,%ecx
   0x00007ffff7f30e9d <+957>:	jne    0x7ffff7f30e30 <__strcmp_avx2+848>
   0x00007ffff7f30e9f <+959>:	add    $0x10,%edx
   0x00007ffff7f30ea2 <+962>:	add    $0x10,%eax
   0x00007ffff7f30ea5 <+965>:	cmp    $0xff8,%eax
--Type <RET> for more, q to quit, c to continue without paging--
   0x00007ffff7f30eaa <+970>:	jg     0x7ffff7f30eda <__strcmp_avx2+1018>
   0x00007ffff7f30eac <+972>:	vmovq  (%rdi,%rdx,1),%xmm1
   0x00007ffff7f30eb1 <+977>:	vmovq  (%rsi,%rdx,1),%xmm0
   0x00007ffff7f30eb6 <+982>:	vpcmpeqb %xmm0,%xmm1,%xmm0
   0x00007ffff7f30eba <+986>:	vpminub %xmm1,%xmm0,%xmm0
   0x00007ffff7f30ebe <+990>:	vpcmpeqb %xmm7,%xmm0,%xmm0
   0x00007ffff7f30ec2 <+994>:	vpmovmskb %xmm0,%ecx
   0x00007ffff7f30ec6 <+998>:	and    $0xff,%ecx
   0x00007ffff7f30ecc <+1004>:	test   %ecx,%ecx
   0x00007ffff7f30ece <+1006>:	jne    0x7ffff7f30e30 <__strcmp_avx2+848>
   0x00007ffff7f30ed4 <+1012>:	add    $0x8,%edx
   0x00007ffff7f30ed7 <+1015>:	add    $0x8,%eax
   0x00007ffff7f30eda <+1018>:	cmp    $0xffc,%eax
   0x00007ffff7f30edf <+1023>:	jg     0x7ffff7f30f09 <__strcmp_avx2+1065>
   0x00007ffff7f30ee1 <+1025>:	vmovd  (%rdi,%rdx,1),%xmm1
   0x00007ffff7f30ee6 <+1030>:	vmovd  (%rsi,%rdx,1),%xmm0
   0x00007ffff7f30eeb <+1035>:	vpcmpeqb %xmm0,%xmm1,%xmm0
   0x00007ffff7f30eef <+1039>:	vpminub %xmm1,%xmm0,%xmm0
   0x00007ffff7f30ef3 <+1043>:	vpcmpeqb %xmm7,%xmm0,%xmm0
   0x00007ffff7f30ef7 <+1047>:	vpmovmskb %xmm0,%ecx
   0x00007ffff7f30efb <+1051>:	and    $0xf,%ecx
   0x00007ffff7f30efe <+1054>:	test   %ecx,%ecx
   0x00007ffff7f30f00 <+1056>:	jne    0x7ffff7f30e30 <__strcmp_avx2+848>
   0x00007ffff7f30f06 <+1062>:	add    $0x4,%edx
   0x00007ffff7f30f09 <+1065>:	movzbl (%rdi,%rdx,1),%eax
   0x00007ffff7f30f0d <+1069>:	movzbl (%rsi,%rdx,1),%ecx
   0x00007ffff7f30f11 <+1073>:	test   %eax,%eax
   0x00007ffff7f30f13 <+1075>:	jne    0x7ffff7f30e00 <__strcmp_avx2+800>
   0x00007ffff7f30f19 <+1081>:	sub    %ecx,%eax
   0x00007ffff7f30f1b <+1083>:	vzeroupper 
   0x00007ffff7f30f1e <+1086>:	retq   
End of assembler dump.
`````
这个机制是GNU上的IFUNC。
其实用更特殊一些的指令处理字符串是有好处的，更隐蔽，也更不容易误判。


这个是debian9 sparc64 libc里的strcmp，不知道Ghidra逆的对不对，要开始看Sparc v9的指令了。

`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             int __stdcall strcmp(char * __s1, char * __s2)
             int               o0:4           <RETURN>
             char *            o0:8           __s1
             char *            o1:8           __s2
                             strcmp                                          XREF[127]:   Entry Point(*), 
                                                                                          FUN_00124074:0012429c(c), 
                                                                                          FUN_00124074:001242b8(c), 
                                                                                          FUN_00124074:001242e0(c), 
                                                                                          FUN_00124074:001242fc(c), 
                                                                                          FUN_00124074:0012436c(c), 
                                                                                          FUN_00124074:001243e8(c), 
                                                                                          FUN_00124b90:00124dfc(c), 
                                                                                          FUN_00124b90:00124e18(c), 
                                                                                          FUN_00124b90:00124e34(c), 
                                                                                          FUN_00124b90:00124e50(c), 
                                                                                          FUN_00124f38:00124f68(c), 
                                                                                          FUN_00124f38:00124fa4(c), 
                                                                                          FUN_00124f38:00124fcc(c), 
                                                                                          FUN_00124f38:00124fe4(c), 
                                                                                          FUN_00125060:001250a8(c), 
                                                                                          FUN_00125ea4:00125edc(c), 
                                                                                          FUN_0012c170:0012c1f4(c), 
                                                                                          ttyslot:001e6608(c), 00255d84, 
                                                                                          [more]
        00187240 82 12 40 08     or         __s2,__s1,g1
        00187244 17 20 20 20     sethi      %hi(0x80808000),o3
        00187248 80 88 60 07     andcc      g1,0x7,g0
        0018724c 12 40 00 34     bpne,pn    %icc,LAB_0018731c
        00187250 96 12 e0 80     _or        o3,0x80,o3
        00187254 da 5a 00 00     ldx        [__s1+g0],o5
        00187258 92 22 40 08     sub        __s2,__s1,__s2
                             LAB_0018725c                                    XREF[1]:     fchdir:001dd058(R)  
        0018725c 83 2a f0 20     sllx       o3,0x20,g1
        00187260 c6 5a 00 09     ldx        [__s1+__s2],g3
        00187264 96 12 c0 01     or         o3,g1,o3
        00187268 10 68 00 06     bpa,pt     LAB_00187280
        0018726c 95 32 f0 07     _srlx      o3,0x7,o2
        00187270 30              ??         30h    0
        00187271 68              ??         68h    h
        00187272 00              ??         00h
        00187273 04              ??         04h
        00187274 01              ??         01h
        00187275 00              ??         00h
        00187276 00              ??         00h
        00187277 00              ??         00h
        00187278 01              ??         01h
        00187279 00              ??         00h
        0018727a 00              ??         00h
        0018727b 00              ??         00h
        0018727c 01              ??         01h
        0018727d 00              ??         00h
        0018727e 00              ??         00h
        0018727f 00              ??         00h
                             LAB_00187280                                    XREF[3]:     00187268(j), 0018729c(j), 
                                                                                          00187354(j)  
        00187280 90 02 20 08     add        __s1,0x8,__s1
        00187284 84 23 40 0a     sub        o5,o2,g2
        00187288 98 9b 40 03     xorcc      o5,g3,o4
        0018728c 12 60 00 08     bpne,pn    %xcc,LAB_001872ac
        00187290 82 2a c0 0d     _andn      o3,o5,g1
        00187294 da da 10 40     ldxa       [__s1+g0] 0x82,o5
        00187298 80 88 40 02     andcc      g1,g2,g0
        0018729c 22 6f ff f9     bpe,a,pt   %xcc,LAB_00187280
                             LAB_001872a0                                    XREF[1]:     chdir:001dd014(R)  
        001872a0 c6 da 10 49     _ldxa      [__s1+__s2] 0x82,g3
        001872a4 81 c3 e0 08     retl
        001872a8 90 10 20 00     _mov       0x0,__s1
                             LAB_001872ac                                    XREF[2]:     0018728c(j), 001873c0(j)  
        001872ac 84 2b 40 0b     andn       o5,o3,g2
        001872b0 92 12 e0 01     or         o3,0x1,__s2
        001872b4 90 10 20 01     mov        0x1,__s1
        001872b8 84 20 80 09     sub        g2,__s2,g2
        001872bc 80 a3 40 03     cmp        o5,g3
        001872c0 82 28 40 02     andn       g1,g2,g1
        001872c4 91 65 37 ff     movleu     %xcc,-0x1,__s1
        001872c8 83 30 70 07     srlx       g1,0x7,g1
        001872cc 84 10 20 00     mov        0x0,g2
        001872d0 80 88 61 00     andcc      g1,0x100,g0
        001872d4 85 66 70 08     movne      %xcc,0x8,g2
        001872d8 93 28 70 2f     sllx       g1,0x2f,__s2
        001872dc 85 7a 6c 10     movrlz     __s2,0x10,g2
        001872e0 93 28 70 27     sllx       g1,0x27,__s2
        001872e4 85 7a 6c 18     movrlz     __s2,0x18,g2
        001872e8 93 28 70 1f     sllx       g1,0x1f,__s2
        001872ec 85 7a 6c 20     movrlz     __s2,0x20,g2
        001872f0 93 28 70 17     sllx       g1,0x17,__s2
        001872f4 85 7a 6c 28     movrlz     __s2,0x28,g2
        001872f8 93 28 70 0f     sllx       g1,0xf,__s2
        001872fc 85 7a 6c 30     movrlz     __s2,0x30,g2
        00187300 93 28 70 07     sllx       g1,0x7,__s2
        00187304 85 7a 6c 38     movrlz     __s2,0x38,g2
        00187308 83 30 50 02     srlx       g1,g2,g1
        0018730c 83 28 50 02     sllx       g1,g2,g1
        00187310 80 a0 40 0c     cmp        g1,o4
        00187314 81 c3 e0 08     retl
        00187318 91 67 30 00     _movgu     %xcc,0x0,__s1
                             LAB_0018731c                                    XREF[1]:     0018724c(j)  
        0018731c 92 22 40 08     sub        __s2,__s1,__s2
        00187320 83 2a f0 20     sllx       o3,0x20,g1
        00187324 96 12 c0 01     or         o3,g1,o3
        00187328 84 0a 20 07     and        __s1,0x7,g2
        0018732c 95 32 f0 07     srlx       o3,0x7,o2
        00187330 90 2a 20 07     andn       __s1,0x7,__s1
        00187334 da da 10 40     ldxa       [__s1+g0] 0x82,o5
        00187338 88 8a 60 07     andcc      __s2,0x7,g4
        0018733c 99 28 a0 03     sll        g2,0x3,o4
        00187340 12 40 00 07     bpne,pn    %icc,LAB_0018735c
        00187344 82 10 3f ff     _mov       -0x1,g1
        00187348 cc da 10 49     ldxa       [__s1+__s2] 0x82,g6
        0018734c 85 30 50 0c     srlx       g1,o4,g2
        00187350 9a 33 40 02     orn        o5,g2,o5
        00187354 10 6f ff cb     bpa,pt     LAB_00187280
        00187358 86 31 80 02     _orn       g6,g2,g3
                             LAB_0018735c                                    XREF[1]:     00187340(j)  
        0018735c 89 29 30 03     sllx       g4,0x3,g4
        00187360 92 2a 60 07     andn       __s2,0x7,__s2
        00187364 cc da 10 49     ldxa       [__s1+__s2] 0x82,g6
        00187368 84 10 20 40     mov        0x40,g2
        0018736c 8a 20 80 04     sub        g2,g4,g5
        00187370 83 30 50 0c     srlx       g1,o4,g1
                             LAB_00187374                                    XREF[2]:     creat:001dcfbc(R), 
                                                                                          creat:001dcfdc(R)  
        00187374 92 02 60 08     add        __s2,0x8,__s2
        00187378 9a 33 40 01     orn        o5,g1,o5
        0018737c 87 29 90 04     sllx       g6,g4,g3
        00187380 cc da 10 49     ldxa       [__s1+__s2] 0x82,g6
        00187384 90 02 20 08     add        __s1,0x8,__s1
        00187388 84 23 40 0a     sub        o5,o2,g2
        0018738c 99 31 90 05     srlx       g6,g5,o4
        00187390 86 10 c0 0c     or         g3,o4,g3
        00187394 86 30 c0 01     orn        g3,g1,g3
        00187398 10 68 00 09     bpa,pt     LAB_001873bc
        0018739c 82 2a c0 0d     _andn      o3,o5,g1
                             LAB_001873a0                                    XREF[1]:     001873c8(j)  
        001873a0 87 29 90 04     sllx       g6,g4,g3
        001873a4 cc da 10 49     ldxa       [__s1+__s2] 0x82,g6
        001873a8 90 02 20 08     add        __s1,0x8,__s1
                             LAB_001873ac                                    XREF[1]:     pipe2:001dcf08(R)  
        001873ac 84 23 40 0a     sub        o5,o2,g2
        001873b0 99 31 90 05     srlx       g6,g5,o4
        001873b4 82 2a c0 0d     andn       o3,o5,g1
        001873b8 86 10 c0 0c     or         g3,o4,g3
                             LAB_001873bc                                    XREF[1]:     00187398(j)  
        001873bc 98 9b 40 03     xorcc      o5,g3,o4
        001873c0 12 67 ff bb     bpne,pn    %xcc,LAB_001872ac
        001873c4 80 88 40 02     _andcc     g1,g2,g0
        001873c8 22 6f ff f6     bpe,a,pt   %xcc,LAB_001873a0
        001873cc da da 10 40     _ldxa      [__s1+g0] 0x82,o5
        001873d0 81 c3 e0 08     retl
        001873d4 90 10 20 00     _mov       0x0,__s1
        001873d8 01              ??         01h
        001873d9 00              ??         00h
        001873da 00              ??         00h
        001873db 00              ??         00h
        001873dc 01              ??         01h
        001873dd 00              ??         00h
        001873de 00              ??         00h
        001873df 00              ??         00h

`````


sparc64 ubuntu7.10  libc-2.6.1.so

`````shell
                             **************************************************************
                             *                          FUNCTION                          *
                             **************************************************************
                             int __stdcall strcmp(char * __s1, char * __s2)
             int               o0:4           <RETURN>
             char *            o0:8           __s1
             char *            o1:8           __s2
                             strcmp                                          XREF[144]:   Entry Point(*), 
                                                                                          FUN_0012d0c0:0012d2f0(c), 
                                                                                          FUN_0012d0c0:0012d358(c), 
                                                                                          FUN_0012d0c0:0012d370(c), 
                                                                                          FUN_0012d0c0:0012d3c4(c), 
                                                                                          FUN_0012d0c0:0012d69c(c), 
                                                                                          FUN_0012da00:0012dc54(c), 
                                                                                          FUN_0012da00:0012dc6c(c), 
                                                                                          FUN_0012da00:0012dc84(c), 
                                                                                          FUN_0012da00:0012dc9c(c), 
                                                                                          FUN_0012dea0:0012ded0(c), 
                                                                                          FUN_0012dea0:0012df10(c), 
                                                                                          FUN_0012dea0:0012df28(c), 
                                                                                          FUN_0012e380:0012e3c4(c), 
                                                                                          FUN_0012edc0:0012ede0(c), 
                                                                                          FUN_0012edc0:0012edf4(c), 
                                                                                          FUN_0012edc0:0012ee08(c), 
                                                                                          FUN_0012edc0:0012ee1c(c), 
                                                                                          FUN_0012edc0:0012ee30(c), 
                                                                                          00256134, [more]
        0018d2e0 03 00 40 40     sethi      %hi(0x1010000),g1
        0018d2e4 80 8a 20 07     andcc      __s1,0x7,g0
        0018d2e8 12 40 00 66     bpne,pn    %icc,LAB_0018d480
        0018d2ec 82 10 61 01     _or        g1,0x101,g1
        0018d2f0 86 8a 60 07     andcc      __s2,0x7,g3
        0018d2f4 12 40 00 74     bpne,pn    %icc,LAB_0018d4c4
        0018d2f8 85 28 70 20     _sllx      g1,0x20,g2
        0018d2fc d4 5a 00 00     ldx        [__s1+g0],o2
        0018d300 82 10 40 02     or         g1,g2,g1
                             LAB_0018d304                                    XREF[1]:     0018d4bc(j)  
        0018d304 d6 5a 40 00     ldx        [__s2+g0],o3
        0018d308 92 22 40 08     sub        __s2,__s1,__s2
        0018d30c 85 28 70 07     sllx       g1,0x7,g2
                             LAB_0018d310                                    XREF[2]:     0018d328(j), 0018d398(j)  
        0018d310 90 02 20 08     add        __s1,0x8,__s1
        0018d314 86 22 80 01     sub        o2,g1,g3
        0018d318 80 a2 80 0b     cmp        o2,o3
        0018d31c 12 60 00 29     bpne,pn    %xcc,LAB_0018d3c0
        0018d320 d4 da 10 40     _ldxa      [__s1+g0] 0x82,o2
        0018d324 80 88 c0 02     andcc      g3,g2,g0
        0018d328 22 6f ff fa     bpe,a,pt   %xcc,LAB_0018d310
        0018d32c d6 da 50 48     _ldxa      [__s2+__s1] 0x82,o3
        0018d330 98 80 c0 01     addcc      g3,g1,o4
        0018d334 87 30 f0 20     srlx       g3,0x20,g3
        0018d338 80 88 c0 02     andcc      g3,g2,g0
        0018d33c 02 68 00 0d     bpe,pt     %xcc,LAB_0018d370
        0018d340 9b 33 30 38     _srlx      o4,0x38,o5
        0018d344 80 8b 60 ff     andcc      o5,0xff,g0
        0018d348 02 40 00 16     bpe,pn     %icc,LAB_0018d3a0
        0018d34c 9b 33 30 30     _srlx      o4,0x30,o5
        0018d350 80 8b 60 ff     andcc      o5,0xff,g0
        0018d354 02 40 00 13     bpe,pn     %icc,LAB_0018d3a0
        0018d358 9b 33 30 28     _srlx      o4,0x28,o5
        0018d35c 80 8b 60 ff     andcc      o5,0xff,g0
        0018d360 02 40 00 10     bpe,pn     %icc,LAB_0018d3a0
        0018d364 9b 33 30 20     _srlx      o4,0x20,o5
        0018d368 80 8b 60 ff     andcc      o5,0xff,g0
        0018d36c 02 40 00 0d     bpe,pn     %icc,LAB_0018d3a0
                             LAB_0018d370                                    XREF[1]:     0018d33c(j)  
        0018d370 9b 33 30 18     _srlx      o4,0x18,o5
        0018d374 80 8b 60 ff     andcc      o5,0xff,g0
        0018d378 02 40 00 0a     bpe,pn     %icc,LAB_0018d3a0
        0018d37c 9b 33 30 10     _srlx      o4,0x10,o5
        0018d380 80 8b 60 ff     andcc      o5,0xff,g0
        0018d384 02 40 00 07     bpe,pn     %icc,LAB_0018d3a0
        0018d388 9b 33 30 08     _srlx      o4,0x8,o5
        0018d38c 80 8b 60 ff     andcc      o5,0xff,g0
        0018d390 02 40 00 04     bpe,pn     %icc,LAB_0018d3a0
        0018d394 80 8b 20 ff     _andcc     o4,0xff,g0
        0018d398 32 47 ff de     bpne,a,pn  %icc,LAB_0018d310
        0018d39c d6 da 50 48     _ldxa      [__s2+__s1] 0x82,o3
                             LAB_0018d3a0                                    XREF[16]:    0018d348(j), 0018d354(j), 
                                                                                          0018d360(j), 0018d36c(j), 
                                                                                          0018d378(j), 0018d384(j), 
                                                                                          0018d390(j), 0018d4a0(j), 
                                                                                          0018d528(j), 0018d534(j), 
                                                                                          0018d540(j), 0018d54c(j), 
                                                                                          0018d558(j), 0018d564(j), 
                                                                                          0018d570(j), 0018d578(j)  
        0018d3a0 81 c3 e0 08     retl
        0018d3a4 90 10 00 00     _mov       g0,__s1
        0018d3a8 30 68 00 06     bpa,a,pt   LAB_0018d3c0
        0018d3ac 01 00 00 00     nop
        0018d3b0 01 00 00 00     nop
        0018d3b4 01 00 00 00     nop
        0018d3b8 01 00 00 00     nop
        0018d3bc 01 00 00 00     nop
                             LAB_0018d3c0                                    XREF[3]:     0018d31c(j), 0018d3a8(j), 
                                                                                          0018d504(j)  
        0018d3c0 8c 10 20 ff     mov        0xff,g6
        0018d3c4 80 88 c0 02     andcc      g3,g2,g0
        0018d3c8 02 68 00 1b     bpe,pt     %xcc,LAB_0018d434
        0018d3cc 98 80 c0 01     _addcc     g3,g1,o4
        0018d3d0 87 30 f0 20     srlx       g3,0x20,g3
        0018d3d4 80 88 c0 02     andcc      g3,g2,g0
        0018d3d8 02 68 00 0d     bpe,pt     %xcc,LAB_0018d40c
        0018d3dc 9b 29 b0 38     _sllx      g6,0x38,o5
        0018d3e0 80 8b 00 0d     andcc      o4,o5,g0
        0018d3e4 02 60 00 1b     bpe,pn     %xcc,LAB_0018d450
        0018d3e8 9b 29 b0 30     _sllx      g6,0x30,o5
        0018d3ec 80 8b 00 0d     andcc      o4,o5,g0
        0018d3f0 02 60 00 18     bpe,pn     %xcc,LAB_0018d450
        0018d3f4 9b 29 b0 28     _sllx      g6,0x28,o5
        0018d3f8 80 8b 00 0d     andcc      o4,o5,g0
        0018d3fc 02 60 00 15     bpe,pn     %xcc,LAB_0018d450
        0018d400 9b 29 b0 20     _sllx      g6,0x20,o5
        0018d404 80 8b 00 0d     andcc      o4,o5,g0
        0018d408 02 60 00 12     bpe,pn     %xcc,LAB_0018d450
                             LAB_0018d40c                                    XREF[1]:     0018d3d8(j)  
        0018d40c 9b 29 b0 18     _sllx      g6,0x18,o5
        0018d410 80 8b 00 0d     andcc      o4,o5,g0
        0018d414 02 40 00 0f     bpe,pn     %icc,LAB_0018d450
        0018d418 9b 29 b0 10     _sllx      g6,0x10,o5
        0018d41c 80 8b 00 0d     andcc      o4,o5,g0
        0018d420 02 40 00 0c     bpe,pn     %icc,LAB_0018d450
        0018d424 9b 29 b0 08     _sllx      g6,0x8,o5
        0018d428 80 8b 00 0d     andcc      o4,o5,g0
        0018d42c 02 40 00 09     bpe,pn     %icc,LAB_0018d450
        0018d430 9a 10 00 06     _mov       g6,o5
                             LAB_0018d434                                    XREF[1]:     0018d3c8(j)  
        0018d434 80 a3 00 0b     cmp        o4,o3
        0018d438 90 10 3f ff     mov        -0x1,__s1
        0018d43c 81 c3 e0 08     retl
        0018d440 91 67 30 01     _movgu     %xcc,0x1,__s1
        0018d444 30 68 00 03     bpa,a,pt   LAB_0018d450
        0018d448 01 00 00 00     nop
        0018d44c 01 00 00 00     nop
                             LAB_0018d450                                    XREF[8]:     0018d3e4(j), 0018d3f0(j), 
                                                                                          0018d3fc(j), 0018d408(j), 
                                                                                          0018d414(j), 0018d420(j), 
                                                                                          0018d42c(j), 0018d444(j)  
        0018d450 8c 23 60 01     sub        o5,0x1,g6
        0018d454 90 10 00 00     mov        g0,__s1
        0018d458 9a 13 40 06     or         o5,g6,o5
        0018d45c 98 2b 00 0d     andn       o4,o5,o4
        0018d460 96 2a c0 0d     andn       o3,o5,o3
        0018d464 80 a3 00 0b     cmp        o4,o3
        0018d468 91 67 30 01     movgu      %xcc,0x1,__s1
        0018d46c 81 c3 e0 08     retl
        0018d470 91 65 77 ff     _movcs     %xcc,-0x1,__s1
                             LAB_0018d474                                    XREF[1]:     0018d498(j)  
        0018d474 81 c3 e0 08     retl
        0018d478 90 10 00 0c     _mov       o4,__s1
        0018d47c 01 00 00 00     nop
                             LAB_0018d480                                    XREF[1]:     0018d2e8(j)  
        0018d480 d4 0a 00 00     ldub       [__s1+g0],o2
        0018d484 90 02 20 01     add        __s1,0x1,__s1
        0018d488 d6 0a 40 00     ldub       [__s2+g0],o3
        0018d48c 85 28 70 20     sllx       g1,0x20,g2
                             LAB_0018d490                                    XREF[1]:     0018d4ac(j)  
        0018d490 92 02 60 01     add        __s2,0x1,__s2
        0018d494 98 a2 80 0b     subcc      o2,o3,o4
        0018d498 12 67 ff f7     bpne,pn    %xcc,LAB_0018d474
        0018d49c d4 8a 10 40     _lduba     [__s1+g0] 0x82,o2
        0018d4a0 02 f2 ff c0     brz,pn     o3,LAB_0018d3a0
        0018d4a4 d6 8a 50 40     _lduba     [__s2+g0] 0x82,o3
        0018d4a8 80 8a 20 07     andcc      __s1,0x7,g0
        0018d4ac 32 47 ff f9     bpne,a,pn  %icc,LAB_0018d490
        0018d4b0 90 02 20 01     _add       __s1,0x1,__s1
        0018d4b4 82 10 40 02     or         g1,g2,g1
        0018d4b8 86 8a 60 07     andcc      __s2,0x7,g3
        0018d4bc 22 47 ff 92     bpe,a,pn   %icc,LAB_0018d304
        0018d4c0 d4 da 10 40     _ldxa      [__s1+g0] 0x82,o2
                             LAB_0018d4c4                                    XREF[1]:     0018d2f4(j)  
        0018d4c4 8b 28 f0 03     sllx       g3,0x3,g5
        0018d4c8 9a 10 20 40     mov        0x40,o5
        0018d4cc 92 22 40 03     sub        __s2,g3,__s2
        0018d4d0 9a 23 40 05     sub        o5,g5,o5
        0018d4d4 cc da 50 40     ldxa       [__s2+g0] 0x82,g6
        0018d4d8 82 10 40 02     or         g1,g2,g1
        0018d4dc 92 22 40 08     sub        __s2,__s1,__s2
        0018d4e0 85 28 70 07     sllx       g1,0x7,g2
        0018d4e4 92 02 60 08     add        __s2,0x8,__s2
                             LAB_0018d4e8                                    XREF[1]:     0018d510(j)  
        0018d4e8 97 29 90 05     sllx       g6,g5,o3
        0018d4ec cc da 50 48     ldxa       [__s2+__s1] 0x82,g6
                             LAB_0018d4f0                                    XREF[1]:     0018d580(j)  
        0018d4f0 99 31 90 0d     srlx       g6,o5,o4
        0018d4f4 d4 da 10 40     ldxa       [__s1+g0] 0x82,o2
        0018d4f8 96 12 c0 0c     or         o3,o4,o3
        0018d4fc 90 02 20 08     add        __s1,0x8,__s1
        0018d500 80 a2 80 0b     cmp        o2,o3
        0018d504 12 67 ff af     bpne,pn    %xcc,LAB_0018d3c0
        0018d508 86 22 80 01     _sub       o2,g1,g3
        0018d50c 80 88 c0 02     andcc      g3,g2,g0
        0018d510 02 6f ff f6     bpe,pt     %xcc,LAB_0018d4e8
        0018d514 87 30 f0 20     _srlx      g3,0x20,g3
        0018d518 80 88 c0 02     andcc      g3,g2,g0
        0018d51c 02 68 00 0d     bpe,pt     %xcc,LAB_0018d550
        0018d520 87 32 b0 38     _srlx      o2,0x38,g3
        0018d524 80 88 e0 ff     andcc      g3,0xff,g0
        0018d528 02 47 ff 9e     bpe,pn     %icc,LAB_0018d3a0
        0018d52c 87 32 b0 30     _srlx      o2,0x30,g3
        0018d530 80 88 e0 ff     andcc      g3,0xff,g0
        0018d534 02 47 ff 9b     bpe,pn     %icc,LAB_0018d3a0
        0018d538 87 32 b0 28     _srlx      o2,0x28,g3
        0018d53c 80 88 e0 ff     andcc      g3,0xff,g0
        0018d540 02 47 ff 98     bpe,pn     %icc,LAB_0018d3a0
        0018d544 87 32 b0 20     _srlx      o2,0x20,g3
        0018d548 80 88 e0 ff     andcc      g3,0xff,g0
        0018d54c 02 47 ff 95     bpe,pn     %icc,LAB_0018d3a0
                             LAB_0018d550                                    XREF[1]:     0018d51c(j)  
        0018d550 87 32 b0 18     _srlx      o2,0x18,g3
        0018d554 80 88 e0 ff     andcc      g3,0xff,g0
        0018d558 02 47 ff 92     bpe,pn     %icc,LAB_0018d3a0
        0018d55c 87 32 b0 10     _srlx      o2,0x10,g3
        0018d560 80 88 e0 ff     andcc      g3,0xff,g0
        0018d564 02 47 ff 8f     bpe,pn     %icc,LAB_0018d3a0
        0018d568 87 32 b0 08     _srlx      o2,0x8,g3
        0018d56c 80 88 e0 ff     andcc      g3,0xff,g0
        0018d570 02 47 ff 8c     bpe,pn     %icc,LAB_0018d3a0
        0018d574 80 8a a0 ff     _andcc     o2,0xff,g0
        0018d578 02 47 ff 8a     bpe,pn     %icc,LAB_0018d3a0
        0018d57c 97 29 90 05     _sllx      g6,g5,o3
        0018d580 10 6f ff dc     bpa,pt     LAB_0018d4f0
        0018d584 cc da 50 48     _ldxa      [__s2+__s1] 0x82,g6
        0018d588 30 68 00 06     bpa,a,pt   FUN_0018d5a0                                     undefined FUN_0018d5a0()
                             -- Flow Override: CALL_RETURN (CALL_TERMINATOR)
        0018d58c 01 00 00 00     nop
        0018d590 01 00 00 00     nop
        0018d594 01 00 00 00     nop
        0018d598 01 00 00 00     nop
        0018d59c 01 00 00 00     nop

`````
