#TARBALL:	http://anduin.linuxfromscratch.org/LFS/iana-etc-2.30.tar.bz2
#MD5SUM:	3ba3afb1d1b261383d247f46cb135ee8;SOURCES/iana-etc-2.30.tar.bz2
#-----------------------------------------------------------------------------
Summary:	The Iana-Etc package provides data for network services and protocols.
Name:		iana-etc
Version:	2.30
Release:	1
License:	OSLv3.0
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://anduin.linuxfromscratch.org/LFS/%{name}-%{version}.tar.bz2
%description
The Iana-Etc package provides data for network services and protocols.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.30-1
-	Initial build.	First version
