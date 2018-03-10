%define		dist .LFS
Summary:	Package manager
Name:		rpm
Version:	4.14.0
Release:	4%{?dist}
License:	GPLv2
URL:		http://rpm.org
Group:		LFS/BASE
Vendor:		Octothorpe
Distribution:	LFS-8.1
Packager:	baho-utot@columbus.rr.com
Source0:	http://ftp.rpm.org/releases/rpm-4.14.x/%{name}-%{version}.tar.bz2
Source1:	http://download.oracle.com/berkeley-db/db-6.0.20.tar.gz
%description
	Package manager
%prep
	rm -rf %{_builddir}/*
	rm -rf %{_buildrootdir}/*
%setup -q -n %{name}-%{version}
%setup -q -T -D -a 1 -n %{name}-%{version}
	sed -i 's/--srcdir=$db_dist/--srcdir=$db_dist --with-pic/' db3/configure
%build
	ln -vs db-6.0.20 db
	./configure \
		--prefix=%{_prefix} \
		--program-prefix= \
		--sysconfdir=/etc \
		--with-crypto=openssl \
		--with-cap \
		--with-acl  \
		--without-external-db \
		--without-archive \
		--without-lua \
		--disable-plugins \
		--disable-dependency-tracking \
		--disable-silent-rules
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file 
	install -D -m644 COPYING %{buildroot}%{_datarootdir}/licenses/%{name}-%{version}/COPYING
	install -D -m644 INSTALL %{buildroot}%{_datarootdir}/licenses/%{name}-%{version}/INSTALL
	#	Create file list
	%find_lang %{NAME}
	find %{buildroot} -name '*.la' -delete
	rm -rf %{buildroot}%{_mandir}/fr
	rm -rf %{buildroot}%{_mandir}/ja
	rm -rf %{buildroot}%{_mandir}/ko
	rm -rf %{buildroot}%{_mandir}/pl
	rm -rf %{buildroot}%{_mandir}/ru
	rm -rf %{buildroot}%{_mandir}/sk
#	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
#	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%clean
	rm -rf %{_builddir}/*
	rm -rf %{_buildrootdir}/*
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files -f %{NAME}.lang
	%defattr(-,root,root)
	%{_bindir}/*
	%{_includedir}/rpm
	%{_libdir}/*.so
	%{_libdir}/*.0
	%{_libdir}/*.8
	%{_libdir}/pkgconfig/*.pc
	%{_libdir}/rpm
	%{_mandir}/man1/*.gz
	%{_mandir}/man8/*.gz
	%{_datarootdir}/licenses/%{name}-%{version}/COPYING
	%{_datarootdir}/licenses/%{name}-%{version}/INSTALL
%changelog
*	Sat Mar 10 2018 baho-utot <baho-utot@columbus.rr.com> 4.14.0-4
-	Added acl and cap Removed plugins and disabled python
*	Tue Feb 20 2018 baho-utot <baho-utot@columbus.rr.com> 4.14.0-3
-	Added python bindings for rpmlint
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 4.14.0-1
-	LFS-8.1
