Summary:	Basic system utilities
Name:		coreutils
Version:	8.22
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/coreutils
Group:		LFS/Base
Vendor:		LeoWare
Distribution:	MyLFS
Source0:	http://ftp.gnu.org/gnu/coreutils/%{name}-%{version}.tar.xz
Patch0:		http://www.linuxfromscratch.org/patches/lfs/7.5/coreutils-8.22-i18n-4.patch
%description
The Coreutils package contains utilities for showing and setting
the basic system
%prep
%setup -q
%patch0 -p1
%build
FORCE_UNSAFE_CONFIGURE=1  ./configure \
	--prefix=%{_prefix} \
	--enable-no-install-program=kill,uptime \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}/bin
install -vdm 755 %{buildroot}%{_sbindir}
install -vdm 755 %{buildroot}%{_mandir}/man8
mv -v %{buildroot}%{_bindir}/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} %{buildroot}/bin
mv -v %{buildroot}%{_bindir}/{false,ln,ls,mkdir,mknod,mv,pwd,rm} %{buildroot}/bin
mv -v %{buildroot}%{_bindir}/{rmdir,stty,sync,true,uname,test,[} %{buildroot}/bin
mv -v %{buildroot}%{_bindir}/chroot %{buildroot}%{_sbindir}
mv -v %{buildroot}%{_mandir}/man1/chroot.1 %{buildroot}%{_mandir}/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 %{buildroot}%{_mandir}/man8/chroot.8
mv -v %{buildroot}%{_bindir}/{head,sleep,nice} %{buildroot}/bin
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}
%check
make -k NON_ROOT_USERNAME=nobody check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files -f %{name}.lang
%defattr(-,root,root)
/bin/*
%{_libexecdir}/*
%{_bindir}/*
%{_sbindir}/*
%{_mandir}/*/*
%changelog
*	Sat Apr 05 2014 baho-utot <baho-utot@columbus.rr.com> 8.22-1
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 8.21-1
-	Upgrade version
