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
	dfl-spi-altera.ko \
	fpga-bridge.ko \
	fpga-mgr.ko \
	fpga-region.ko \
	n5010-hssi.ko \
	intel-m10-bmc.ko \
	intel-m10-bmc-hwmon.ko \
	intel-m10-bmc-secure.ko \
	spi-altera.ko \
	ifpga-sec-mgr.ko \
	vfio-mdev-dfl.ko

obj-m += dfl-afu.o
obj-m += dfl-fme.o
obj-m += dfl-fme-br.o
obj-m += dfl-fme-mgr.o
obj-m += dfl-fme-region.o
obj-m += dfl.o
obj-m += dfl-pci.o
obj-m += dfl-spi-altera.o
obj-m += fpga-bridge.o
obj-m += fpga-region.o
obj-m += fpga-mgr.o
obj-m += n5010-hssi.o
obj-m += intel-m10-bmc.o
obj-m += intel-m10-bmc-hwmon.o
obj-m += intel-m10-bmc-secure.o
obj-m += spi-altera.o
obj-m += ifpga-sec-mgr.o
obj-m += vfio-mdev-dfl.o
obj-m += drivers/base/regmap/regmap-mmio.o
obj-m += drivers/fpga/dfl-afu-error.o
obj-m += drivers/fpga/dfl-afu-dma-region.o
obj-m += drivers/fpga/dfl-afu-main.o
obj-m += drivers/fpga/dfl-afu-region.o
obj-m += drivers/fpga/dfl-fme-error.o
obj-m += drivers/fpga/dfl-fme-perf.o
obj-m += drivers/fpga/dfl-fme-pr.o
obj-m += drivers/fpga/dfl-indirect-regmap.o
obj-m += drivers/mfd/intel-m10-bmc-main.o
obj-m += drivers/mfd/intel-spi-avmm.o

dfl-objs := drivers/fpga/dfl.o drivers/fpga/dfl-indirect-regmap.o
dfl-afu-objs := drivers/fpga/dfl-afu-region.o drivers/fpga/dfl-afu-error.o drivers/fpga/dfl-afu-dma-region.o drivers/fpga/dfl-afu-main.o

dfl-fme-objs := drivers/fpga/dfl-fme-error.o drivers/fpga/dfl-fme-main.o drivers/fpga/dfl-fme-pr.o drivers/fpga/dfl-fme-perf.o 
dfl-fme-br-objs := drivers/fpga/dfl-fme-br.o
dfl-fme-mgr-objs := drivers/fpga/dfl-fme-mgr.o
dfl-fme-region-objs := drivers/fpga/dfl-fme-region.o
dfl-pci-objs := drivers/fpga/dfl-pci.o
dfl-spi-altera-objs := drivers/fpga/dfl-spi-altera.o
ifpga-sec-mgr-objs := drivers/fpga/ifpga-sec-mgr.o
vfio-mdev-dfl-objs := drivers/fpga/vfio-mdev-dfl.o

fpga-bridge-objs := drivers/fpga/fpga-bridge.o
fpga-mgr-objs := drivers/fpga/fpga-mgr.o
fpga-region-objs := drivers/fpga/fpga-region.o
n5010-hssi-objs := drivers/net/ethernet/silicom/n5010-hssi.o
intel-m10-bmc-objs := drivers/mfd/intel-m10-bmc-main.o drivers/mfd/intel-spi-avmm.o
intel-m10-bmc-hwmon-objs := drivers/hwmon/intel-m10-bmc-hwmon.o
intel-m10-bmc-secure-objs := drivers/mfd/intel-m10-bmc-secure.o
spi-altera-objs := drivers/spi/spi-altera.o drivers/base/regmap/regmap-mmio.o

all: 
	$(MAKE) -j 1 -C $(KERNELDIR) M=$(CURDIR) $(MODULES)

rpm: clean
	build/build-driver-rpm.sh

clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
	- rm -rf build/rpmbuild

load: $(MODULES)
	insmod spi-altera.ko
	insmod intel-m10-bmc.ko
	insmod intel-m10-bmc-hwmon.ko
	insmod fpga-bridge.ko
	insmod fpga-mgr.ko
	insmod fpga-region.ko
	insmod dfl.ko
	insmod n5010-hssi.ko
	insmod dfl-spi-altera.ko
	insmod dfl-pci.ko
	insmod dfl-fme.ko
	insmod dfl-afu.ko
	insmod dfl-fme-br.ko
	insmod dfl-fme-region.ko
	insmod dfl-fme-mgr.ko
	insmod ifpga-sec-mgr.ko
	insmod intel-m10-bmc-secure.ko

unload:
	- rmmod dfl_fme_region
	- rmmod dfl_fme_br
	- rmmod dfl_afu
	- rmmod dfl_fme
	- rmmod dfl_pci
	- rmmod n5010_hssi
	- rmmod dfl_spi_altera
	- rmmod dfl
	- rmmod fpga_region
	- rmmod dfl_fme_mgr
	- rmmod fpga_mgr
	- rmmod fpga_bridge
	- rmmod intel_m10_bmc_hwmon
	- rmmod intel_m10_bmc_secure
	- rmmod ifpga-sec-mgr
	- rmmod intel-m10-bmc
	- rmmod spi_altera
