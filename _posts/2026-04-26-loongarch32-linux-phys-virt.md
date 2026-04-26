---
title: Loongarch32 Linux phys virt address
published: true
---
现在是到这了，问题是\_\_request\_resource第2个参数地址有问题，0xa2800000。物理内存从dtb里写的就是从0x2800000开始，前面的a是多出来的。

![screenshot0](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2026-04-26-loongarch32-linux-phys-virt/0.jpg)

这个第二个参数是memblock\_alloc()分配出来的。

`````c
        for_each_mem_range(i, &start, &end) {
                struct resource *res;

                res = memblock_alloc(sizeof(struct resource), SMP_CACHE_BYTES);
                if (!res)
                        panic("%s: Failed to allocate %zu bytes\n", __func__,
                              sizeof(struct resource));

                res->start = start;
                /*
                 * In memblock, end points to the first byte after the
                 * range while in resourses, end points to the last byte in
                 * the range.
                 */
                res->end = end - 1;
                res->flags = IORESOURCE_SYSTEM_RAM | IORESOURCE_BUSY;
                res->name = "System RAM";

                printk("!!!!request_resource\n");
                request_resource(&iomem_resource, res);

                /*
                 *  We don't know which RAM region contains kernel data,
                 *  so we try it repeatedly and let the resource manager
                 *  test it.
                 */
                printk("!!!!request_resource\n");
                request_resource(res, &code_resource);
                printk("!!!!request_resource\n");
                request_resource(res, &data_resource);
                printk("!!!!request_resource\n");
                request_resource(res, &bss_resource);
        }
`````

`````c
static __always_inline void *memblock_alloc(phys_addr_t size, phys_addr_t align)
{
        return memblock_alloc_try_nid(size, align, MEMBLOCK_LOW_LIMIT,
                                      MEMBLOCK_ALLOC_ACCESSIBLE, NUMA_NO_NODE);
}



void * __init memblock_alloc_try_nid(
                        phys_addr_t size, phys_addr_t align,
                        phys_addr_t min_addr, phys_addr_t max_addr,
                        int nid)      
{               
        void *ptr;

        memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa %pS\n",
                     __func__, (u64)size, (u64)align, nid, &min_addr,
                     &max_addr, (void *)_RET_IP_);
        ptr = memblock_alloc_internal(size, align,
                                           min_addr, max_addr, nid, false);
        if (ptr)
                memset(ptr, 0, size);

        return ptr;                             
}


static void * __init memblock_alloc_internal(
                                phys_addr_t size, phys_addr_t align,
                                phys_addr_t min_addr, phys_addr_t max_addr,
                                int nid, bool exact_nid)
{
        phys_addr_t alloc;

        /*
         * Detect any accidental use of these APIs after slab is ready, as at
         * this moment memblock may be deinitialized already and its
         * internal data may be destroyed (after execution of memblock_free_all)
         */
        if (WARN_ON_ONCE(slab_is_available()))
                return kzalloc_node(size, GFP_NOWAIT, nid);

        if (max_addr > memblock.current_limit)
                max_addr = memblock.current_limit;

        alloc = memblock_alloc_range_nid(size, align, min_addr, max_addr, nid,
                                        exact_nid);

        /* retry allocation without lower limit */
        if (!alloc && min_addr)
                alloc = memblock_alloc_range_nid(size, align, 0, max_addr, nid,
                                                exact_nid);

        if (!alloc)
                return NULL;

        return phys_to_virt(alloc);
}


`````

跟到这出现了phys_to_virt()

`````c
/*      
 * Change virtual addresses to physical addresses and vv.
 * These are pretty trivial
 */     
#ifndef virt_to_phys
#define virt_to_phys virt_to_phys
static inline unsigned long virt_to_phys(volatile void *address)
{
        return __pa((unsigned long)address);
}
#endif

#ifndef phys_to_virt
#define phys_to_virt phys_to_virt
static inline void *phys_to_virt(unsigned long address)
{
        return __va(address);
}
#endif



/*
 * __pa()/__va() should be used only during mem init.
 */
#define __pa(x)         PHYSADDR(x)
#define __va(x)         ((void *)((unsigned long)(x) + PAGE_OFFSET - PHYS_OFFSET))



/*
 * This handles the memory map.
 */
#ifndef PAGE_OFFSET
#define PAGE_OFFSET           (CAC_BASE + PHYS_OFFSET)
#endif




#ifndef IO_BASE
#define IO_BASE                 CSR_DMW0_BASE
#endif

#ifndef CAC_BASE
#define CAC_BASE                CSR_DMW1_BASE
#endif

#ifndef UNCAC_BASE
#define UNCAC_BASE              CSR_DMW0_BASE
#endif

`````

CAC应该是cache的意思，UNCAC就是un-cache。


`````c
/* Direct Map window 0/1 */
#ifdef CONFIG_64BIT
#define CSR_DMW0_PLV0           _CONST64_(1 << 0)
#define CSR_DMW0_VSEG           _CONST64_(0x8000)
#define CSR_DMW0_BASE           (CSR_DMW0_VSEG << DMW_PABITS)
#define CSR_DMW0_INIT           (CSR_DMW0_BASE | CSR_DMW0_PLV0)

#define CSR_DMW1_PLV0           _CONST64_(1 << 0)
#define CSR_DMW1_MAT            _CONST64_(1 << 4)
#define CSR_DMW1_VSEG           _CONST64_(0x9000)
#define CSR_DMW1_BASE           (CSR_DMW1_VSEG << DMW_PABITS)
#define CSR_DMW1_INIT           (CSR_DMW1_BASE | CSR_DMW1_MAT | CSR_DMW1_PLV0)

#else
#define CSR_DMW0_PLV0           _ULCAST_(1 << 0)
#define CSR_DMW0_VSEG           _ULCAST_(0x8)
#define CSR_DMW0_BASE           (CSR_DMW0_VSEG << DMW_PABITS)
#define CSR_DMW0_INIT           (CSR_DMW0_BASE | CSR_DMW0_PLV0)

#define CSR_DMW1_PLV0           _ULCAST_(1 << 0)
#define CSR_DMW1_MAT            _ULCAST_(1 << 4)
#define CSR_DMW1_VSEG           _ULCAST_(0xa)
#define CSR_DMW1_BASE           (CSR_DMW1_VSEG << DMW_PABITS)
#define CSR_DMW1_INIT           (CSR_DMW1_BASE | CSR_DMW1_MAT | CSR_DMW1_PLV0)
#endif

`````
a的出处找到了，32位上，0xa0000000开始的virt是可以被cache的，物理地址就是去掉前面的a。

0x80000000开始的virt addr是不走cache的，转换成物理地址就是把前面的8去掉。


virt转phys就比较简单了，直接取后面的几位。

`````c
/*
 * Returns the physical address of a KPRANGEx / XKPRANGE address
 */
#define PHYSADDR(a)             ((_ACAST32_(a)) & TO_PHYS_MASK)



#ifdef CONFIG_32BIT
#define DMW_PABITS      28
#define TO_PHYS_MASK    ((1UL << DMW_PABITS) - 1)
#endif
`````

从注释上看这个机制只是在mem init的时候用，后面怎样还不知道，遇到了再学习。

在soc2上，直接phys=virt， 改了代码后，这部分就跑过去了。


![screenshot1](https://github.com/whensungoesdown/whensungoesdown.github.io/raw/main/_posts/2026-04-26-loongarch32-linux-phys-virt/1.jpg)

