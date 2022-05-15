---
title: SunOS 5.11上的原型
published: true
---

/etc/security/policy.conf

`````shell
# cat /etc/security/policy.conf
…
CRYPT_ALGORITHMS_ALLOW=1,2a,md5,5,6
#
# Use the version of MD5 (5) that works with Linux and BSD systems.
# Passwords previously encrypted with SHA256 (1) will be encrypted
# with MD5 when users change their passwords.
#
#
#CRYPT_DEFAULT=5
CRYPT_DEFAULT=1
`````

passwd 123

test3:$1$IeMksC9S$/iJs8EavskWJoelddvsWB.:19125::::::



SunOS 5.10

`````shell
u@unamed:~/prjs/vm/Solaris10/OpenSPARCT1_Arch.1.5/S10image$ sudo mount -t ufs -o rw,loop,ufstype=44bsd disk.s10hw2 ramdisk/
`````


