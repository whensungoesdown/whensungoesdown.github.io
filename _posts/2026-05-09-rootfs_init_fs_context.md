---
title: rootfs\_init\_fs\_context
published: true
---

在执行到alloc\_fs\_context()

`````verilog
/**
 * alloc_fs_context - Create a filesystem context.
 * @fs_type: The filesystem type.
 * @reference: The dentry from which this one derives (or NULL)
 * @sb_flags: Filesystem/superblock flags (SB_*)
 * @sb_flags_mask: Applicable members of @sb_flags
 * @purpose: The purpose that this configuration shall be used for.
 *
 * Open a filesystem and create a mount context.  The mount context is
 * initialised with the supplied flags and, if a submount/automount from
 * another superblock (referred to by @reference) is supplied, may have
 * parameters such as namespaces copied across from that superblock.
 */
static struct fs_context *alloc_fs_context(struct file_system_type *fs_type,
                                      struct dentry *reference,
                                      unsigned int sb_flags,
                                      unsigned int sb_flags_mask,
                                      enum fs_context_purpose purpose)
{
        int (*init_fs_context)(struct fs_context *);
        struct fs_context *fc;
        int ret = -ENOMEM;

        printk("                                        in alloc_fs_context()\n");

        fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL);
        if (!fc)
                return ERR_PTR(-ENOMEM);

        fc->purpose     = purpose;
        fc->sb_flags    = sb_flags;
        fc->sb_flags_mask = sb_flags_mask;
        fc->fs_type     = get_filesystem(fs_type);
        fc->cred        = get_current_cred();
        fc->net_ns      = get_net(current->nsproxy->net_ns);
        fc->log.prefix  = fs_type->name;

        mutex_init(&fc->uapi_mutex);

        switch (purpose) {
        case FS_CONTEXT_FOR_MOUNT:
                fc->user_ns = get_user_ns(fc->cred->user_ns);
                break;
        case FS_CONTEXT_FOR_SUBMOUNT:
                fc->user_ns = get_user_ns(reference->d_sb->s_user_ns);
                break;
        case FS_CONTEXT_FOR_RECONFIGURE:
                atomic_inc(&reference->d_sb->s_active);
                fc->user_ns = get_user_ns(reference->d_sb->s_user_ns);
                fc->root = dget(reference);
                break;
        }

        /* TODO: Make all filesystems support this unconditionally */
        init_fs_context = fc->fs_type->init_fs_context;
        printk("                                        init_fs_context() init_fs_context=0x%x, legacy_init_fs_context=0x%x\n", (int)init_fs_context, (int)legacy_init_fs_context);
        if (!init_fs_context)
                init_fs_context = legacy_init_fs_context;

        ret = init_fs_context(fc);
        if (ret < 0)
                goto err_fc;
        fc->need_free = true;
        return fc;

err\_fc:
        printk("                                        put_fs_context()\n");
        put_fs_context(fc);
        printk("                                        put_fs_context() finish\n");
        return ERR_PTR(ret);
}

`````

里面调用init_fs_context(), 这个函数应该是rootfs_init_fs_context()。

但奇怪的是，系统执行到这里会执行不下去。因为soc2我还有很多东西没实现，所以卡在这里也许是因为访问内存出错什么的。

所以我在这个函数里加了句printk，看看执行的什么情况。结果是这段程序直接跑过去了。也就是说在函数开始只加了句printk，导致执行结果是不同的。

开始想可能是有什么竞争情况？但是在想不出来，printk是我自己接管了后直接写显存，本来就不拿锁。应该也和中断没关系。

但这个函数的地址很奇怪，0x2000040，非常靠近内核起点。

``````shell
la_build/vmlinux:     file format elf32-loongarch


Disassembly of section .text:

02000000 <_stext>:
 2000000:       02bfc063        addi.w  $r3,$r3,-16(0xff0)
 2000004:       29802076        st.w    $r22,$r3,8(0x8)
 2000008:       29803061        st.w    $r1,$r3,12(0xc)
 200000c:       02804076        addi.w  $r22,$r3,16(0x10)
 2000010:       1c0037c7        pcaddu12i       $r7,446(0x1be)
 2000014:       0289a0e7        addi.w  $r7,$r7,616(0x268)
 2000018:       02833006        addi.w  $r6,$r0,204(0xcc)
 200001c:       1c00aa05        pcaddu12i       $r5,1360(0x550)
 2000020:       02bf90a5        addi.w  $r5,$r5,-28(0xfe4)
 2000024:       1c0056c4        pcaddu12i       $r4,694(0x2b6)
 2000028:       02bf7084        addi.w  $r4,$r4,-36(0xfdc)
 200002c:       54ba3402        bl      571956(0x8ba34) # 208ba60 <free_reserved_area>
 2000030:       28803061        ld.w    $r1,$r3,12(0xc)
 2000034:       28802076        ld.w    $r22,$r3,8(0x8)
 2000038:       02804063        addi.w  $r3,$r3,16(0x10)
 200003c:       4c000020        jirl    $r0,$r1,0

02000040 <rootfs_init_fs_context>:
 2000040:       02bfc063        addi.w  $r3,$r3,-16(0xff0)
 2000044:       29802076        st.w    $r22,$r3,8(0x8)
 2000048:       29803061        st.w    $r1,$r3,12(0xc)
 200004c:       02804076        addi.w  $r22,$r3,16(0x10)
 2000050:       54b9c004        bl      1096128(0x10b9c0) # 210ba10 <ramfs_init_fs_context>
 2000054:       28803061        ld.w    $r1,$r3,12(0xc)
 2000058:       28802076        ld.w    $r22,$r3,8(0x8)
 200005c:       02804063        addi.w  $r3,$r3,16(0x10)
 2000060:       4c000020        jirl    $r0,$r1,0
 2000064:       03400000        andi    $r0,$r0,0x0
 2000068:       03400000        andi    $r0,$r0,0x0
 200006c:       03400000        andi    $r0,$r0,0x0

``````

一但加了printk，这个函数的位置就变了。

`````shell
021846e4 <rootfs_init_fs_context>:
 21846e4:       02bfc063        addi.w  $r3,$r3,-16(0xff0)
 21846e8:       29803061        st.w    $r1,$r3,12(0xc)
 21846ec:       29802076        st.w    $r22,$r3,8(0x8)
 21846f0:       29801077        st.w    $r23,$r3,4(0x4)
 21846f4:       02804076        addi.w  $r22,$r3,16(0x10)
 21846f8:       00150097        move    $r23,$r4
 21846fc:       1c000744        pcaddu12i       $r4,58(0x3a)
 2184700:       02b64084        addi.w  $r4,$r4,-624(0xd90)
 2184704:       54253400        bl      9524(0x2534) # 2186c38 <printk>
 2184708:       001502e4        move    $r4,$r23
 218470c:       5472e7fe        bl      -494876(0xff872e4) # 210b9f0 <ramfs_init_fs_context>
 2184710:       28803061        ld.w    $r1,$r3,12(0xc)
 2184714:       28802076        ld.w    $r22,$r3,8(0x8)
 2184718:       28801077        ld.w    $r23,$r3,4(0x4)
 218471c:       02804063        addi.w  $r3,$r3,16(0x10)
 2184720:       4c000020        jirl    $r0,$r1,0


`````

这个函数位置就比较正常。但我不明白的是，就算是在0x2000040执行rootfs_init_fs_context, 也不至于跑不下去。

它们中间调用的ramfs_init_fs_context的地址也都很正常。

现在做个实现，rootfs_init_fs_context里不加printk，在ramfs_init_fs_context里printk，看看程序跑成什么情况。

结果是不行，不在rootfs_init_fs_context里加printk程序执行的就不正常。

0x2000040确实不在我在dtb里描述的memory的范围，因为我把vmlinux占用的几mb排除了，从0x2800000-0x3ffffff。但直接的jirl应该不会有什么代码会检查这个范围。


