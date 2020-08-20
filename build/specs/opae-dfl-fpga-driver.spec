#
# OPAE Drivers rpm .spec file
#
Summary: Create OPAE Driver source and binary rpm packages.
Name: opae-dfl-fpga-driver
Version: 5.8.0
Release: alpha
License: GPL V2
Group: Applications/System
Distribution: RHEL Linux
Vendor: Intel Corporation
Source: %{name}-%{version}.tar.gz
Exclusiveos: linux
ExclusiveArch: i386 i586 i686 x86_64
Buildroot: %{_builddir}/%{name}-%{version}
BuildRequires: kernel-headers, kernel-devel, tar, gcc, make
%if 0%{?suse_version}
BuildRequires: kernel-default-devel
%else
%if %{?_vendor} != "clr"
BuildRequires: kernel-devel
%endif
%endif
Requires: dkms, gcc, kernel-devel, make
%define debug_package ${nil}

%package devel
Summary: OPAE modules devel files
Group: Applications/System
%description devel
OPAE Modules Development files

%package prebuilt
Summary: Prebuilt OPAE drivers for common kernels
Group: Applications/System
%description prebuilt
Prebuilt OPAE Drivers for common kernels

%package source
Summary: Source for the OPAE drivers for common kernels
Group: Applications/System
Requires: gcc, kernel-devel, make
%description source
Source for the OPAE Drivers for common kernels

%prep
%setup -q

%description
OPAE Driver

%build

%install

FILES_TO_COPY=`ls | grep -v '^build-' | grep -v debian | grep -v spec`

copy_source()
{
mkdir -p ${1}
cp -al $FILES_TO_COPY ${1}
}

rm -rf $RPM_BUILD_ROOT

mkdir -p $RPM_BUILD_ROOT/lib/modules

# Build and install the kernel modules
for kern in /usr/src/kernels/* /usr/src/linux-*-obj/*/*
do
	if [ -f $kern/Module.symvers ]
	then
		kernname=`basename $kern`
		if [[ $kernname == *"2.6."* ]]; then
			continue
		fi
		if [[ $kernname == *"4."* ]]; then
			continue
		fi
		if ! grep -q "CONFIG_REGMAP=y" $kern/include/config/auto.conf ; then
			continue
		fi
		copy_source build-$kernname
		(set -e
		cd build-$kernname
		make -C $kern M=$PWD clean modules V=1 ARCH=$RPM_ARCH
		make -C $kern M=$PWD modules_install INSTALL_MOD_PATH=$RPM_BUILD_ROOT ARCH=$RPM_ARCH
		)
	fi
done

# Remove the depmod related file we will not be including
rm -f $RPM_BUILD_ROOT/lib/modules/*/modules.*

# Now, install the source for the DKMS package
install -d $RPM_BUILD_ROOT/usr/src/%{name}-%{version}
cp -a drivers $RPM_BUILD_ROOT/usr/src/%{name}-%{version}
cp -a include $RPM_BUILD_ROOT/usr/src/%{name}-%{version}
cp -a scripts $RPM_BUILD_ROOT/usr/src/%{name}-%{version}
cp -a Makefile $RPM_BUILD_ROOT/usr/src/%{name}-%{version}
cp -a 40-dfl-fpga.rules $RPM_BUILD_ROOT/usr/src/%{name}-%{version}
cp -a LICENSE $RPM_BUILD_ROOT/usr/src/%{name}-%{version}
# Now, create/install a source tarball of the driver for the -source package
# Make a tarball of the driver source
tar -C $RPM_BUILD_ROOT/usr/src --group=root --owner=root -czf $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}.tar.gz %{name}-%{version}
# Set up a specfile
sed -e 's/PKGVER/%{version}/' -e 's/PKGREL/%{release}/' build/specs/native-build.spec.in >$RPM_BUILD_ROOT/usr/src/%{name}.spec
# Create a source package tarball that rpmbuild can consume directly
tar -C $RPM_BUILD_ROOT/usr/src --group=root --owner=root -czf $RPM_BUILD_ROOT/usr/src/%{name}-source-%{version}-%{release}.tar.gz %{name}-%{version}-%{release}.tar.gz %{name}.spec
# Clean up the intemediate files
rm -rf $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}.tar.gz $RPM_BUILD_ROOT/usr/src/%{name}.spec $RPM_BUILD_ROOT/usr/src/%{name}-%{version}

# Prebuilt module udev file
install -d $RPM_BUILD_ROOT/etc/udev/rules.d
cp -a 40-dfl-fpga.rules $RPM_BUILD_ROOT/etc/udev/rules.d

# Now, install the source for the DKMS package
install -d $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}
cp -a drivers $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}
cp -a include $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}
cp -a scripts $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}
cp -a Makefile $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}
cp -a 40-dfl-fpga.rules $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}
cp -a LICENSE $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}

# DKMS stuff
cp -a dkms-postinst.sh $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}
cp -a dkms-postrem.sh $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}
sed -e 's/PKGVER/%{version}-%{release}/' dkms-preinst.sh >$RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}/dkms-preinst.sh
chmod 0755 $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}/dkms-preinst.sh
echo "Creating $RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}/dkms.conf"
sed -e 's/PKGVER/%{version}-%{release}/' dkms.conf >$RPM_BUILD_ROOT/usr/src/%{name}-%{version}-%{release}/dkms.conf

%post
if [ -z "`dkms status -m opae-dfl-fpga-driver -v %{version}-%{release}`" ]; then
  echo "Add module source to dkms"
  dkms add -m opae-dfl-fpga-driver -v %{version}-%{release} --rpm_safe_upgrade
fi

# If we haven't loaded a tarball, then try building it for the current kernel
if [ `uname -r | grep -c "BOOT"` -eq 0 ] && [ -e /lib/modules/`uname -r`/build/include ]; then
  dkms build -m opae-dfl-fpga-driver -v %{version}-%{release}
  dkms install -m opae-dfl-fpga-driver -v %{version}-%{release} --force

elif [ `uname -r | grep -c "BOOT"` -gt 0 ]; then
  echo -e ""
  echo -e "Module build for the currently running kernel was skipped since you"
  echo -e "are running a BOOT variant of the kernel."
else
  echo -e ""
  echo -e "Module build for the currently running kernel was skipped since the"
  echo -e "kernel source for this kernel does not seem to be installed."
fi

exit 0


%preun
echo -e
echo -e "Uninstall of opae-dfl-fpga-driver module (version %{version}-%{release}) beginning:"
dkms remove -m opae-dfl-fpga-driver -v %{version}-%{release} --all --rpm_safe_upgrade
if [ "$1" -eq "0" ]
then
	find /lib/modules -type f \( -name spi-nor-mod.ko* \
	     -o -name altera-asmip2.ko* \
             -o -name fpga-mgr-mod.ko* \
             -o -name dfl-fpga-pci.ko* \
             -o -name dfl-fpga-fme.ko* \
             -o -name dfl-fpga-afu.ko* \
             -o -name dfl-fpga-pac-hssi.ko* \
             -o -name dfl-fpga-pac-iopll.ko* \) -delete
fi
echo -e "Force regeneration of new initramfs"
dracut --force /boot/initramfs-$(uname -r).img $(uname -r)
exit 0

%post prebuilt
depmod=/sbin/depmod
if [ -x /usr/sbin/depmod ]
then
	depmod=/usr/sbin/depmod
fi
if [ -x /usr/bin/depmod ]
then
	depmod=/usr/bin/depmod
fi

cd /boot
for kern in System.map*
do
	ver=`echo $kern | sed -e 's/System.map-//'`
	echo "Adding module to $ver"
	$depmod -a $ver
done

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
/usr/src/%{name}-%{version}-%{release}

%files devel
#/usr/include/*

%files prebuilt
%defattr(-,root,root)
/lib/modules
/etc/udev

%files source
%defattr(-,root,root)
/usr/src/%{name}-source-%{version}-%{release}.tar.gz

%changelog
* %(date "+%a %b %d %Y") %{version}-%{release}
-OPAE Intel FPGA Driver Build
