# SPDX-License-Identifier: GPL-2.0
KERNELDIR ?= /lib/modules/$(shell uname -r)/build

ccflags-y += -I$(src) -Wno-implicit-function-declaration -Wno-error

# Include our copy of header files first
LINUXINCLUDE := -I$(src)/include -I$(src)/include/uapi $(LINUXINCLUDE)

MODULES = \
	dfl.ko \
	dfl-fme.ko \
	dfl-afu.ko \
	dfl-fme-br.ko \
	dfl-fme-mgr.ko \
	dfl-fme-region.ko \
	dfl-n3000-nios.ko \
	dfl-spi-altera.ko \
	dfl-hssi.ko \
	dfl-pci.ko \
	fpga-bridge.ko \
	fpga-mgr.ko \
	fpga-region.ko \
	intel_ll_10g_mac.ko \
	intel-m10-bmc.ko \
	intel-m10-bmc-hwmon.ko \
	intel-s10-phy.ko \
	spi-altera.ko

obj-m += dfl-afu.o
obj-m += dfl-fme.o
obj-m += dfl-fme-br.o
obj-m += dfl-fme-mgr.o
obj-m += dfl-fme-region.o
obj-m += dfl.o
obj-m += dfl-pci.o
obj-m += fpga-bridge.o
obj-m += fpga-region.o
obj-m += fpga-mgr.o
obj-m += intel_ll_10g_mac.o
obj-m += intel-m10-bmc.o
obj-m += intel-m10-bmc-hwmon.o
obj-m += intel-s10-phy.o
obj-m += spi-altera.o
obj-m += drivers/base/regmap/regmap-mmio.o
obj-m += drivers/fpga/dfl-afu-error.o
obj-m += drivers/fpga/dfl-afu-dma-region.o
obj-m += drivers/fpga/dfl-afu-main.o
obj-m += drivers/fpga/dfl-afu-region.o
obj-m += drivers/fpga/dfl-fme-error.o
obj-m += drivers/fpga/dfl-fme-perf.o
obj-m += drivers/fpga/dfl-fme-pr.o
obj-m += dfl-n3000-nios.o
obj-m += dfl-spi-altera.o
obj-m += dfl-hssi.o
obj-m += drivers/mfd/intel-m10-bmc-main.o
obj-m += drivers/mfd/intel-spi-avmm.o

dfl-objs := drivers/fpga/dfl.o
dfl-afu-objs := drivers/fpga/dfl-afu-region.o drivers/fpga/dfl-afu-error.o drivers/fpga/dfl-afu-dma-region.o drivers/fpga/dfl-afu-main.o

dfl-fme-objs := drivers/fpga/dfl-fme-error.o drivers/fpga/dfl-fme-main.o drivers/fpga/dfl-fme-pr.o drivers/fpga/dfl-fme-perf.o 
dfl-fme-br-objs := drivers/fpga/dfl-fme-br.o
dfl-fme-mgr-objs := drivers/fpga/dfl-fme-mgr.o
dfl-fme-region-objs := drivers/fpga/dfl-fme-region.o
dfl-pci-objs := drivers/fpga/dfl-pci.o
fpga-bridge-objs := drivers/fpga/fpga-bridge.o
fpga-mgr-objs := drivers/fpga/fpga-mgr.o
fpga-region-objs := drivers/fpga/fpga-region.o
intel_ll_10g_mac-objs := drivers/net/ethernet/intel/intel_ll_10g_mac.o
intel-m10-bmc-objs := drivers/mfd/intel-m10-bmc-main.o drivers/mfd/intel-spi-avmm.o
intel-m10-bmc-hwmon-objs := drivers/hwmon/intel-m10-bmc-hwmon.o
intel-s10-phy-objs := drivers/net/phy/intel-s10-phy.o
spi-altera-objs := drivers/spi/spi-altera.o drivers/base/regmap/regmap-mmio.o

dfl-n3000-nios-objs :=	drivers/fpga/dfl-n3000-nios.o
dfl-spi-altera-objs :=	drivers/fpga/dfl-spi-altera.o
dfl-hssi-objs := drivers/fpga/dfl-hssi.o

all: 
	$(MAKE) -C $(KERNELDIR) M=$(CURDIR) $(MODULES)

clean:
	- rm *.o
	- rm *.ko
	- rm Module.symvers
	- rm *.mod.c
	- rm .*.d
	- rm .*.cmd
	- rm -rf .tmp_versions
	- rm *.a
	- rm drivers/fpga/*.o
	- rm drivers/hwmon/*.o
	- rm drivers/mfd/*.o
	- rm drivers/net/ethernet/intel/*.o
	- rm drivers/net/phy/*.o
	- rm drivers/spi/*.o

load: $(MODULES)
	insmod spi-altera.ko
	insmod intel-m10-bmc.ko
	insmod intel-m10-bmc-hwmon.ko
	insmod intel-s10-phy.ko
	insmod fpga-bridge.ko
	insmod fpga-mgr.ko
	insmod fpga-region.ko
	insmod dfl.ko
	insmod intel_ll_10g_mac.ko
	insmod dfl-n3000-nios.ko
	insmod dfl-spi-altera.ko
	insmod dfl-hssi.ko
	insmod dfl-pci.ko
	insmod dfl-fme.ko
	insmod dfl-afu.ko
	insmod dfl-fme-br.ko
	insmod dfl-fme-region.ko
	insmod dfl-fme-mgr.ko

unload:
	- rmmod dfl-fme-mgr.ko
	- rmmod dfl-fme-region.ko
	- rmmod dfl-fme-br.ko
	- rmmod dfl-afu.ko
	- rmmod dfl-fme.ko
	- rmmod dfl-pci.ko
	- rmmod	dfl-n3000-nios.ko
	- rmmod dfl-spi-altera.ko
	- rmmod	dfl-hssi.ko
	- rmmod intel_ll_10g_mac.ko
	- rmmod dfl.ko
	- rmmod fpga-region.ko
	- rmmod fpga-mgr.ko
	- rmmod fpga-bridge.ko
	- rmmod intel-m10-bmc.ko
	- rmmod intel-m10-bmc-hwmon.ko
	- rmmod intel-s10-phy.ko
	- rmmod spi-altera.ko
