Summary:	Basic system utilities
Name:		coreutils
Version:	8.29
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/coreutils/
Group:		LFS/Base
Vendor:		LeoWare
Distribution:	MyLFS
Source0:	http://ftp.gnu.org/gnu/coreutils/%{name}-%{version}.tar.xz
Patch0:		http://www.linuxfromscratch.org/patches/lfs/8.2/%{name}-%{version}-i18n-1.patch

%description
The Coreutils package contains utilities for showing and setting
the basic system

%prep
%setup -q
%{__patch} -Np1 -i $RPM_SOURCE_DIR/%{name}-%{version}-i18n-1.patch
sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk

%build
FORCE_UNSAFE_CONFIGURE=1  ./configure \
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
mv -v %{buildroot}%{_bindir}/{rmdir,stty,sync,true,uname,test,[} %{buildroot}/bin
mv -v %{buildroot}%{_bindir}/chroot %{buildroot}%{_sbindir}
mv -v %{buildroot}%{_mandir}/man1/chroot.1 %{buildroot}%{_mandir}/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 %{buildroot}%{_mandir}/man8/chroot.8
mv -v %{buildroot}%{_bindir}/{head,sleep,nice} %{buildroot}/bin
rm -rf %{buildroot}%{_infodir}/dir
%find_lang %{name}

%check
make NON_ROOT_USERNAME=nobody check-root |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%post	-p /sbin/ldconfig

%postun	-p /sbin/ldconfig

%files -f %{name}.lang
%defattr(-,root,root)
/bin/*
%{_libexecdir}/*
%{_bindir}/*
%{_sbindir}/*
%doc %{_mandir}/*/*
%doc %{_infodir}/*

%changelog
*	Wed Oct 10 2018 Samuel Raynor <samuel@samuelraynor.com> 8.29-1
*	Sat Apr 05 2014 baho-utot <baho-utot@columbus.rr.com> 8.22-1
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 8.21-1
-	Upgrade version
	Upgrade version
