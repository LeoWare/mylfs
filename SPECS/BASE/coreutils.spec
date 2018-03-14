Summary:	The Coreutils package contains utilities for showing and setting the basic system characteristics.
Name:		coreutils
Version:	8.27
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://ftp.gnu.org/gnu/coreutils/%{name}-%{version}.tar.xz
Patch0:		coreutils-8.27-i18n-1.patch
%description
	The Coreutils package contains utilities for showing and setting the basic system characteristics.
%prep
%setup -q -n %{NAME}-%{VERSION}
%patch0 -p1
%build
	FORCE_UNSAFE_CONFIGURE=1 \
	./configure \
		--prefix=%{_prefix} \
		--enable-no-install-program=kill,uptime
	FORCE_UNSAFE_CONFIGURE=1 make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/bin
	install -vdm 755 %{buildroot}/usr/sbin
	install -vdm 755 %{buildroot}/usr/share/man/man8
	mv -v %{buildroot}/usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} %{buildroot}/bin
	mv -v %{buildroot}/usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} %{buildroot}/bin
	mv -v %{buildroot}/usr/bin/{rmdir,stty,sync,true,uname} %{buildroot}/bin
	mv -v %{buildroot}/usr/bin/chroot %{buildroot}/usr/sbin
	mv -v %{buildroot}/usr/share/man/man1/chroot.1 %{buildroot}/usr/share/man/man8/chroot.8
	sed -i s/\"1\"/\"8\"/1 %{buildroot}/usr/share/man/man8/chroot.8
	mv -v %{buildroot}/usr/bin/{head,sleep,nice,test,[} %{buildroot}/bin
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	rm  %{buildroot}/usr/share/info/dir
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version