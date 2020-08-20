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
	dfl-pci.ko \
	dfl-spi-altera.ko \
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
obj-m += dfl-n3000-nios.o
obj-m += dfl-pci.o
obj-m += dfl-spi-altera.o
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
dfl-n3000-nios-objs := drivers/fpga/dfl-n3000-nios.o
dfl-pci-objs := drivers/fpga/dfl-pci.o
dfl-spi-altera-objs := drivers/fpga/dfl-spi-altera.o
fpga-bridge-objs := drivers/fpga/fpga-bridge.o
fpga-mgr-objs := drivers/fpga/fpga-mgr.o
fpga-region-objs := drivers/fpga/fpga-region.o
intel_ll_10g_mac-objs := drivers/net/ethernet/intel/intel_ll_10g_mac.o
intel-m10-bmc-objs := drivers/mfd/intel-m10-bmc-main.o drivers/mfd/intel-spi-avmm.o
intel-m10-bmc-hwmon-objs := drivers/hwmon/intel-m10-bmc-hwmon.o
intel-s10-phy-objs := drivers/net/phy/intel-s10-phy.o
spi-altera-objs := drivers/spi/spi-altera.o drivers/base/regmap/regmap-mmio.o

all: 
	$(MAKE) -j 1 -C $(KERNELDIR) M=$(CURDIR) $(MODULES)

rpm: clean
	build/build-driver-rpm.sh

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
	- rm -rf build/rpmbuild

load: $(MODULES)
	insmod intel-s10-phy.ko
	insmod spi-altera.ko
	insmod intel-m10-bmc.ko
	insmod intel-m10-bmc-hwmon.ko
	insmod fpga-bridge.ko
	insmod fpga-mgr.ko
	insmod fpga-region.ko
	insmod dfl.ko
	insmod intel_ll_10g_mac.ko
	insmod dfl-spi-altera.ko
	insmod dfl-n3000-nios.ko
	insmod dfl-pci.ko
	insmod dfl-fme.ko
	insmod dfl-afu.ko
	insmod dfl-fme-br.ko
	insmod dfl-fme-region.ko
	insmod dfl-fme-mgr.ko

unload:
	- rmmod dfl-fme-mgr
	- rmmod dfl-fme-region
	- rmmod dfl-fme-br
	- rmmod dfl-afu
	- rmmod dfl-fme
	- rmmod dfl-pci
	- rmmod intel_ll_10g_mac
	- rmmod dfl_n3000_nios
	- rmmod dfl_spi_altera
	- rmmod dfl
	- rmmod fpga-region
	- rmmod fpga-mgr
	- rmmod fpga-bridge
	- rmmod intel-m10-bmc
	- rmmod intel-m10-bmc-hwmon
	- rmmod spi-altera
	- rmmod intel-s10-phy
