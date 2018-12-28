Summary:	Programs for dynamic creation of device nodes
Name:		eudev
Version:	1.6
Release:	1
License:	GPLv2
URL:		http://www.gentoo.org/proj/en/eudev
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source0:	%{name}-%{version}.tar.gz
#Source1:	%{name}-%{version}-manpages.tar.bz2
%description
The eudev package contains programs for dynamic creation of device nodes.
%prep
%setup -q
sed -i '/struct ucred/i struct ucred;' src/libudev/util.h
sed -r -i 's|/usr(/bin/test)|\1|'         test/udev-test.pl
#tar -xvf %{SOURCE1} -C %{buildroot}%{_datadir}
%build
BLKID_CFLAGS=-I/tools/include \
BLKID_LIBS='-L/tools/lib -lblkid' \
./configure --prefix=%{_prefix} \
         --bindir=/sbin \
         --sbindir=/sbin \
         --libdir=%{_libdir} \
         --libexecdir=%{_lib} \
         --sysconfdir=%{_sysconfdir} \
         --with-rootprefix= \
         --with-rootlibdir=%{_lib} \
         --enable-shared         \
         --disable-static        \
         --disable-selinux       \
         --disable-introspection \
         --disable-keymap        \
         --disable-gudev         \
         --disable-gtk-doc-html  \
         --with-firmware-path=%{_lib}/firmware \
         --disable-silent-rules
make VERBOSE=1 %{?_smp_mflags}
install -vdm 755 %{buildroot}%{_sysconfdir}/udev/rules.d
%install
install -vdm 755 %{buildroot}%{_lib}/{firmware,udev/devices/pts}
install -vdm 755 %{buildroot}%{_lib}/udev/{devices/pts,rules.d}
install -vdm 755 %{buildroot}%{_sysconfdir}/udev/{hwdb.d,rules.d}
make DESTDIR=%{buildroot} install
# symlink udevd to /lib/udev/udevd
ln -vs /sbin/udevd %{buildroot}/lib/udev/
mv %{buildroot}/usr/share/pkgconfig/udev.pc %{buildroot}%{_libdir}/pkgconfig
rmdir %{buildroot}/usr/share/pkgconfig
find %{buildroot} -name '*.la' -delete
%post
/sbin/ldconfig
/sbin/udevadm hwdb --update
#bash /lib/udev/init-net-rules.sh || true
%postun	-p /sbin/ldconfig
%files 
%defattr(-,root,root)
%config %{_sysconfdir}/udev/hwdb.d/20-OUI.hwdb
%config %{_sysconfdir}/udev/hwdb.d/20-acpi-vendor.hwdb
%config %{_sysconfdir}/udev/hwdb.d/20-bluetooth-vendor-product.hwdb
%config %{_sysconfdir}/udev/hwdb.d/20-pci-classes.hwdb
%config %{_sysconfdir}/udev/hwdb.d/20-pci-vendor-model.hwdb
%config %{_sysconfdir}/udev/hwdb.d/20-sdio-classes.hwdb
%config %{_sysconfdir}/udev/hwdb.d/20-sdio-vendor-model.hwdb
%config %{_sysconfdir}/udev/hwdb.d/20-usb-classes.hwdb
%config %{_sysconfdir}/udev/hwdb.d/20-usb-vendor-model.hwdb
%config %{_sysconfdir}/udev/udev.conf
/lib/udev/accelerometer
/lib/udev/ata_id
/lib/udev/cdrom_id
/lib/udev/collect
/lib/udev/mtd_probe
/lib/udev/rules.d/42-usb-hid-pm.rules
/lib/udev/rules.d/50-firmware.rules
/lib/udev/rules.d/50-udev-default.rules
/lib/udev/rules.d/60-cdrom_id.rules
/lib/udev/rules.d/60-drm.rules
/lib/udev/rules.d/60-persistent-alsa.rules
/lib/udev/rules.d/60-persistent-input.rules
/lib/udev/rules.d/60-persistent-serial.rules
/lib/udev/rules.d/60-persistent-storage-tape.rules
/lib/udev/rules.d/60-persistent-storage.rules
/lib/udev/rules.d/60-persistent-v4l.rules
/lib/udev/rules.d/61-accelerometer.rules
/lib/udev/rules.d/64-btrfs.rules
/lib/udev/rules.d/75-net-description.rules
/lib/udev/rules.d/75-probe_mtd.rules
/lib/udev/rules.d/75-tty-description.rules
/lib/udev/rules.d/78-sound-card.rules
/lib/udev/rules.d/80-drivers-modprobe.rules
/lib/udev/rules.d/80-net-name-slot.rules
/lib/udev/rules.d/95-udev-late.rules
/lib/udev/scsi_id
/lib/udev/udevd
/lib/udev/v4l_id
%{_lib}/libudev.so.1
%{_lib}/libudev.so.1.4.0
/sbin/udevadm
/sbin/udevd
%{_includedir}/libudev.h
%{_includedir}/udev.h
%{_libdir}/libudev.so
%{_libdir}/pkgconfig/libudev.pc
%{_libdir}/pkgconfig/udev.pc
%changelog
*	Sat Jun 06 2014 baho-utot <baho-utot@columbus.rr.com> 1.6-1
-	initial version
