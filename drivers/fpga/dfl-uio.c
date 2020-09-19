/* SPDX-License-Identifier: GPL-2.0 */
/*
 * prototype dfl uio driver
 *
 * Copyright Tom Rix 2020
 */
#include <linux/module.h>
#include "dfl.h"

static irqreturn_t dfl_uio_handler(int irq, struct uio_info *info)
{
	return IRQ_HANDLED;
}

static int dfl_uio_mmap(struct uio_info *info, struct vm_area_struct *vma)
{
	int ret = -ENODEV;
	return ret;
}

static int dfl_uio_open(struct uio_info *info, struct inode *inode)
{
	int ret = -ENODEV;
	struct dfl_feature *feature = container_of(info, struct dfl_feature, uio);
	if (feature->dev)
		mutex_lock(&feature->lock);

	ret = 0;
	return ret;
}

static int dfl_uio_release(struct uio_info *info, struct inode *inode)
{
	int ret = -ENODEV;
	struct dfl_feature *feature = container_of(info, struct dfl_feature, uio);
	if (feature->dev)
		mutex_unlock(&feature->lock);

	ret = 0;
	return ret;
}

static int dfl_uio_irqcontrol(struct uio_info *info, s32 irq_on)
{
	int ret = -ENODEV;
	return ret;
}

int dfl_uio_add(struct dfl_feature *feature)
{
	struct uio_info *uio = &feature->uio;
	struct resource *res =
		&feature->dev->resource[feature->resource_index];
	int ret = 0;

	uio->name = kasprintf(GFP_KERNEL, "dfl-uio-%llx", feature->id);
	if (!uio->name) {
		ret = -ENOMEM;
		goto exit;
	}

	uio->version = "0.1";
	uio->mem[0].memtype = UIO_MEM_PHYS;
	uio->mem[0].addr = res->start & PAGE_MASK;
	uio->mem[0].offs = res->start & ~PAGE_MASK;
	uio->mem[0].size = (uio->mem[0].offs + resource_size(res)
			    + PAGE_SIZE - 1) & PAGE_MASK;
	/* How are nr_irqs > 1 handled ??? */
	if (feature->nr_irqs == 1)
		uio->irq = feature->irq_ctx[0].irq;
	uio->handler = dfl_uio_handler;
	//uio->mmap = dfl_uio_mmap;
	uio->open = dfl_uio_open;
	uio->release = dfl_uio_release;
	uio->irqcontrol = dfl_uio_irqcontrol;

	ret = uio_register_device(&feature->dev->dev, uio);
	if (ret)
		goto err_register;

exit:
	return ret;
err_register:
	kfree(uio->name);
	goto exit;
}
EXPORT_SYMBOL_GPL(dfl_uio_add);

int dfl_uio_remove(struct dfl_feature *feature)
{
	uio_unregister_device(&feature->uio);
	kfree(feature->uio.name);
	return 0;
}
EXPORT_SYMBOL_GPL(dfl_uio_remove);

