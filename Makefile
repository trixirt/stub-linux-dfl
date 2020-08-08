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
	- rm drivers/base/regmap/*.o
	- rm drivers/base/regmap/.*.d
	- rm drivers/fpga/*.o
	- rm drivers/fpga/.*.d
	- rm drivers/hwmon/*.o
	- rm drivers/hwmon/.*.d
	- rm drivers/mfd/*.o
	- rm drivers/mfd/.*.d
	- rm drivers/net/ethernet/intel/*.o
	- rm drivers/net/ethernet/intel/.*.d
	- rm drivers/net/phy/*.o
	- rm drivers/net/phy/.*.d
	- rm drivers/spi/*.o
	- rm drivers/spi/.*.d

load: $(MODULES) unload
	insmod ./fpga-bridge.ko
	insmod ./fpga-mgr.ko
	insmod ./fpga-region.ko
	insmod ./dfl.ko
	insmod ./dfl-fme.ko
	insmod ./dfl-afu.ko
	insmod ./dfl-fme-br.ko
	insmod ./dfl-fme-mgr.ko
	insmod ./dfl-fme-region.ko
	insmod ./intel_ll_10g_mac.ko
	insmod ./intel-s10-phy.ko
	insmod ./spi-altera.ko
	insmod ./intel-m10-bmc.ko
	insmod ./intel-m10-bmc-hwmon.ko
	insmod ./dfl-pci.ko

unload:
	- rmmod dfl_pci
	- rmmod dfl_fme_region
	- rmmod dfl_fme_br
	- rmmod dfl_afu
	- rmmod dfl_fme
	- rmmod intel_m10_bmc
	- rmmod intel_m10_bmc_hwmon
	- rmmod dfl_fme_mgr
	- rmmod spi_altera
	- rmmod intel_s10_phy
	- rmmod intel_ll_10g_mac
	- rmmod dfl
	- rmmod fpga_region
	- rmmod fpga_mgr
	- rmmod fpga_bridge

