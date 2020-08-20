#!/bin/sh
if [ -f $DESTDIR/etc/udev/rules.d/40-dfl-fpga.rules ]; then
  rm -f $DESTDIR/etc/udev/rules.d/40-dfl-fpga.rules
fi

rmmod    ifpga_sec_mgr \
	 dfl_fme_mgr \
	 dfl_fme_region \
	 dfl_fme_br \
	 dfl_afu \
	 dfl_fme \
	 dfl_pci \
	 s10hssi \
	 n5010_hssi \
	 dfl_n3000_nios \
	 dfl_spi_altera \
	 dfl \
	 fpga_region \
	 fpga_mgr \
	 fpga_bridge \
	 intel_m10_bmc \
	 intel_m10_bmc_hwmon \
	 spi_altera \
	 intel_s10_phy  2>/dev/null
