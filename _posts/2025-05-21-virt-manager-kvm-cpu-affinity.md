---
title: kvm vm vcpu to physical cpu affinity
published: true
---

`````shell
u@uu:~$ sudo virsh list
[sudo] password for u:
 Id   Name       State
--------------------------
 4    vm10_x86   running

u@uu:~$ sudo virsh vcpuinfo 4
VCPU:           0
CPU:            2
State:          running
CPU time:       307.4s
CPU Affinity:   yyyy

u@uu:~$ sudo virsh vcpupin 4
 VCPU   CPU Affinity
----------------------
 0      0-3

u@uu:~$ sudo virsh vcpupin 0 0
error: failed to get domain '0'

u@uu:~$ sudo virsh vcpupin 4 0 0
`````
