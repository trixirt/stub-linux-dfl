#!/bin/sh

#	 s10hssi 

rmmod    dfl_fme_mgr \
	 dfl_fme_region \
	 dfl_fme_br \
	 dfl_afu \
	 dfl_fme \
	 dfl_pci \
	 dfl_n3000_nios \
	 dfl_spi_altera \
	 dfl \
	 fpga_region \
	 fpga_mgr \
	 fpga_bridge \
	 intel_m10_bmc_hwmon \
	 intel_m10_bmc_secure \
	 ifpga_sec_mgr \
	 intel_m10_bmc \
	 spi_altera \
	 intel_s10_phy  2>/dev/null

if [ -d $DESTDIR/etc/udev/rules.d ]; then
  cp $DESTDIR/usr/src/opae-dfl-fpga-driver-PKGVER/40-dfl-fpga.rules $DESTDIR/etc/udev/rules.d
fi
