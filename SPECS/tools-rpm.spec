%global debug_package %{nil}
%define	LFS	/mnt/lfs
#TARBALL:	
#MD5SUM:	
#PATCHES:
#FILE:		.md5sum
#-----------------------------------------------------------------------------
Summary:	RPM package manager
Name:		tools-rpm
Version:	4.14.1
Release:	1
License:	GPL
URL:		http://ftp.rpm.org/releases/rpm-4.14.x
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	http://ftp.rpm.org/releases/rpm-4.14.x/rpm-%{version}.tar.bz2
Source1:	http://download.oracle.com/berkeley-db/db-6.0.20.tar.gz
%description
RPM package manager
#-----------------------------------------------------------------------------
%prep
%setup -q -n rpm-%{version}
%setup -q -T -D -a 1 -n rpm-%{version}
	sed -i 's/--srcdir=$db_dist/--srcdir=$db_dist --with-pic/' db3/configure
%build
	ln -vs db-6.0.20 db
	./configure \
		--prefix=/usr \
		--program-prefix= \
		--sysconfdir=/etc \
		--disable-dependency-tracking \
		--disable-shared \
		--disable-silent-rules\
		--without-external-db \
		--without-archive \
		--without-lua \
		--without-plugins \
		--with-crypto=openssl \
		--enable-static \
		--enable-zstd=no \
		--enable-lmdb=no
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
#-----------------------------------------------------------------------------
#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
#-----------------------------------------------------------------------------
%changelog
*	Tue Mar 13 2018 baho-utot <baho-utot@columbus.rr.com> 4.14.1-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.14.0-1
-	LFS-8.1
