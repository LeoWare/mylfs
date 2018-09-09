%global _default_patch_fuzz 2
#-----------------------------------------------------------------------------
Summary:	The Coreutils package contains utilities for showing and setting the basic system characteristics.
Name:		coreutils
Version:	8.29
Release:	1
License:	GPLv3
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source:		http://ftp.gnu.org/gnu/coreutils/%{name}-%{version}.tar.xz
Patch0:		coreutils-8.29-i18n-1.patch
BuildRequires:	e2fsprogs
%description
	The Coreutils package contains utilities for showing and setting the basic system characteristics.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%patch0 -p1
sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
%build
	FORCE_UNSAFE_CONFIGURE=1 \
	./configure \
		--prefix=%{_prefix} \
		--enable-no-install-program=kill,uptime
	FORCE_UNSAFE_CONFIGURE=1 make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/bin
	install -vdm 755 %{buildroot}%{_sbindir}
	install -vdm 755 %{buildroot}%{_mandir}/man8
	mv -v %{buildroot}%{_bindir}/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} %{buildroot}/bin
	mv -v %{buildroot}%{_bindir}/{false,ln,ls,mkdir,mknod,mv,pwd,rm} %{buildroot}/bin
	mv -v %{buildroot}%{_bindir}/{rmdir,stty,sync,true,uname} %{buildroot}/bin
	mv -v %{buildroot}%{_bindir}/chroot %{buildroot}%{_sbindir}
	mv -v %{buildroot}%{_mandir}/man1/chroot.1 %{buildroot}%{_mandir}/man8/chroot.8
	sed -i s/\"1\"/\"8\"/1 %{buildroot}%{_mandir}/man8/chroot.8
	mv -v %{buildroot}%{_bindir}/{head,sleep,nice} %{buildroot}/bin
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
	%{_mandir}/man8/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 8.29-1
-	Initial build.	First version
