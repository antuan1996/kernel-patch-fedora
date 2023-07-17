#!/usr/bin/env bash

set -oue pipefail

WD="$(pwd)"

echo 'Setup rpm build tree'
dnf install -y koji rpm-build 
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}

echo 'Download and unpack kernel src.rpm'
koji download-build -a src kernel-$PACKAGE_VERSION
rpm --define "_topdir $WD/rpmbuild" -Uvh kernel-$PACKAGE_VERSION.src.rpm

echo 'Copy files to SOURCES and SPECS directories'
cp $WD/kernel_patches/* $WD/rpmbuild/SOURCES/
cp $WD/kernel_patches/spec-mod.sh $WD/rpmbuild/SPECS/

echo 'Modify kernel configs in SOURCES'
cat $WD/kernel-local.custom > rpmbuild/SOURCES/kernel-local
cd $WD/rpmbuild/SOURCES &&  ./config-patch.sh

echo 'Modify kernel.spec'
cd $WD/rpmbuild/SPECS && ./spec-mod.sh formile bmq

echo 'Rebuild src.rpm'
rpmbuild --define "_topdir $WD/rpmbuild" -bs kernel.spec
