#!/bin/sh

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

if [ -d $DESTDIR/etc/udev/rules.d ]; then
  cp $DESTDIR/usr/src/opae-dfl-fpga-driver-PKGVER/40-dfl-fpga.rules $DESTDIR/etc/udev/rules.d
fi
