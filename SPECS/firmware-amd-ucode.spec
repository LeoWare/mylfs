#MD5SUM:	dd92e77d72097f89a7c28eeb121cd62e;SOURCES/firmware-amd-ucode-1.00.tar.gz
#-----------------------------------------------------------------------------
Summary:	Firmware for amd processors
Name:		firmware-amd-ucode
Version:	1.00
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source:	%{name}-%{version}.tar.gz
%description
Firmware for amd processors
#-----------------------------------------------------------------------------
%prep
%build
	cd %{_builddir}
	tar xf %{_sourcedir}/%{name}-%{version}.tar.gz
	install -vdm 755 %{buildroot}/boot
#	AMD family 21 - 15h
	install -vdm 755 fam15h/kernel/x86/microcode
	cp -var amd-ucode/microcode_amd_fam15h.bin fam15h/kernel/x86/microcode/AuthenticAMD.bin
	pushd fam15h
	find . | cpio -o -H newc > %{buildroot}/boot/microcode_amd_fam15h.img
	popd
#	AMD family 22 - 16h
	install -vdm 755 fam16h/kernel/x86/microcode
	cp -var amd-ucode/microcode_amd_fam16h.bin fam16h/kernel/x86/microcode/AuthenticAMD.bin
	pushd fam16h
	find . | cpio -o -H newc > %{buildroot}/boot/microcode_amd_fam16h.img
	popd
#	AMD family 23 - 17h
	install -vdm 755 fam17h/kernel/x86/microcode
	cp -var amd-ucode/microcode_amd_fam17h.bin fam17h/kernel/x86/microcode/AuthenticAMD.bin
	pushd fam17h
	find . | cpio -o -H newc > %{buildroot}/boot/microcode_amd_fam17h.img
	popd
%install
	ls %{buildroot}/boot
#-----------------------------------------------------------------------------
#	Copy license/copying file
#	install -D -m644 %{_builddir}/LICENSE.radeon  %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
#	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
#	sed -i '/man\/man/d' filelist.rpm
#	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
#	%%{_infodir}/*.gz
#	%%{_mandir}/man1/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Sun Jul 29 2018 baho-utot <baho-utot@columbus.rr.com> 1.00-1
-	Initial build.	First version
