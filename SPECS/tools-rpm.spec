Summary:	RPM package manager
Name:	tools-rpm
Version:	4.14.1
Release:	1
License:	GPL
URL:		http://ftp.rpm.org/releases/rpm-4.14.x
Group:	LFS/Tools
Vendor:	Octothorpe
BuildRequires:	tools-popt
Source0:	http://ftp.rpm.org/releases/rpm-4.14.x/rpm-%{version}.tar.bz2
Source1:	http://download.oracle.com/berkeley-db/db-6.0.20.tar.gz
%define	LFS	/mnt/lfs
%description
	RPM package manager
%prep
%setup -q -n rpm-%{version}
%setup -q -T -D -a 1 -n rpm-%{version}
	sed -i 's/--srcdir=$db_dist/--srcdir=$db_dist --with-pic/' db3/configure
%build
	ln -vs db-6.0.20 db
	./configure \
		--prefix=/usr \
		--with-crypto=openssl \
		--without-external-db \
		--without-archive \
		--program-prefix= \
		--sysconfdir=/etc \
		--disable-dependency-tracking \
		--enable-static \
		--disable-shared \
		--without-lua \
		--disable-silent-rules\
		--without-plugins
	make %{?_smp_mflags}
%install
	install -vdm 755 %{buildroot}%{LFS}
	make DESTDIR=%{buildroot}%{LFS} install
	#	rm -rf %{buildroot}/tools/share
	#	Thin the herd
	rm -rf	%{buildroot}%{LFS}/usr/include
	rm 	%{buildroot}%{LFS}/usr/lib/librpm.a
	rm 	%{buildroot}%{LFS}/usr/lib/librpmbuild.a
	rm 	%{buildroot}%{LFS}/usr/lib/librpmio.a
	rm 	%{buildroot}%{LFS}/usr/lib/librpmsign.a
	rm 	%{buildroot}%{LFS}/usr/lib/pkgconfig/rpm.pc
	rm -rf	%{buildroot}%{LFS}/usr/share
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Tue Mar 13 2018 baho-utot <baho-utot@columbus.rr.com> 4.14.1-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.14.0-1
-	LFS-8.1
