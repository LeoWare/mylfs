Summary:	RPM package manager
Name:		rpm
Version:	4.14.0
Release:	1
License:	GPL
URL:		http://ftp.rpm.org/releases/rpm-4.14.x
Group:		LFS/BASE
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	http://ftp.rpm.org/releases/rpm-4.14.x/%{name}-%{version}.tar.bz2
Source1:	http://download.oracle.com/berkeley-db/db-6.0.20.tar.gz
%description
	RPM package manager
%prep
%setup -q -n %{name}-%{version}
%setup -q -T -D -a 1 -n %{name}-%{version}
	sed -i 's/--srcdir=$db_dist/--srcdir=$db_dist --with-pic/' db3/configure
%build
	ln -vs db-6.0.20 db
	./configure \
		--prefix=%{_prefix} \
		--with-crypto=openssl \
		--without-external-db \
		--without-archive \
		--program-prefix= \
		--sysconfdir=/etc \
		--disable-dependency-tracking \
		--without-lua \
		--disable-silent-rules
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,root,root)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.14.0-1
-	LFS-8.1
