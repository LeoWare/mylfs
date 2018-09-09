#-----------------------------------------------------------------------------
Summary:	The GDBM package contains the GNU Database Manager
Name:		gdbm
Version:	1.14.1
Release:	1
License:	GPLv3
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/gdbm/%{name}-%{version}.tar.gz
BuildRequires:	libtool
%description
	The GDBM package contains the GNU Database Manager. It is a library of database
	functions that use extensible hashing and work similar to the standard UNIX dbm.
	The library provides primitives for storing key/data pairs, searching and
	retrieving the data by its key and deleting a key along with its data.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-static \
		--enable-libgdbm-compat
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
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
	%{_mandir}/man3/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.14.1-1
-	Initial build.	First version
