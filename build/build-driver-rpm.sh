#!/bin/bash -x

specFile=`ls build/specs/*.spec`

tmp=`grep Name: $specFile`
pkgname=${tmp##*Name: }
tmp=`grep Version: $specFile`
pkgver=${tmp##*Version: }
tmp=`grep Release: $specFile`
release=${tmp##*Release: }

tmpDir=$pkgname-$pkgver
rm -fr $tmpDir
mkdir $tmpDir
rsync -rp --exclude '.*' --exclude tools --exclude $pkgname-$pkgver ./ build/$pkgname-$pkgver
rm -rf build/rpmbuild
mkdir -p build/rpmbuild/SOURCES
tar czf build/rpmbuild/SOURCES/$pkgname-$pkgver.tar.gz -C build \
	--exclude-vcs $tmpDir
rm -rf build/$tmpDir

rpmbuild --define "_topdir ${PWD}/build/rpmbuild" -bs -vv $specFile
rpmbuild --define "_topdir ${PWD}/build/rpmbuild" --rebuild \
	build/rpmbuild/SRPMS/$pkgname-$pkgver-$release.src.rpm
