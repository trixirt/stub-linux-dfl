#!/bin/sh
if [ -f $DESTDIR/etc/udev/rules.d/40-dfl-fpga.rules ]; then
  rm -f $DESTDIR/etc/udev/rules.d/40-dfl-fpga.rules
fi

rmmod    dfl-fme-mgr \
	 dfl-fme-region \
	 dfl-fme-br \
	 dfl-afu \
	 dfl-fme \
	 dfl-pci \
	 intel_ll_10g_mac \
	 dfl_n3000_nios \
	 dfl_spi_altera \
	 dfl \
	 fpga-region \
	 fpga-mgr \
	 fpga-bridge \
	 intel-m10-bmc \
	 intel-m10-bmc-hwmon \
	 spi-altera \
	 intel-s10-phy  2>/dev/null
