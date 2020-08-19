#!/bin/sh
if [ -f $DESTDIR/etc/udev/rules.d/40-intel-fpga.rules ]; then
  rm -f $DESTDIR/etc/udev/rules.d/40-intel-fpga.rules
fi

rmmod i2c-altera \
	  intel-generic-qspi \
	  intel-on-chip-flash \
	  altera-asmip2 \
	  spi-altera-mod \
	  spi-nor-mod \
	  intel-max10 \
	  avmmi-bmc \
	  intel-fpga-fme \
	  fpga-mgr-mod \
	  intel-fpga-afu \
	  intel-fpga-pci \
	  intel-fpga-pac-hssi \
	  intel-fpga-pac-iopll \
	  c827_retimer \
	  pac_n3000_net \
	  ifpga-sec-mgr \
	  spi-bitbang-mod \
	  regmap-mmio-mod 2>/dev/null