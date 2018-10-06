#TARBALL:	https://github.com/libcheck/check/releases/download/0.12.0/check-0.12.0.tar.gz
#MD5SUM:	31b17c6075820a434119592941186f70;SOURCES/check-0.12.0.tar.gz
#-----------------------------------------------------------------------------
Summary:	Check is a unit testing framework for C.
Name:		check
Version:	0.12.0
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source:	%{name}-%{version}.tar.gz
%description
Check is a unit testing framework for C.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
#-----------------------------------------------------------------------------
#	Copy license/copying file 
#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	install -D -m644 COPYING.LESSER %{buildroot}/usr/share/licenses/%{name}/LICENSE
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
#-----------------------------------------------------------------------------
%changelog
*	Sat Jul 28 2018 baho-utot <baho-utot@columbus.rr.com> 0.12.0-1
-	Initial build.	First version
