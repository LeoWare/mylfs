#-----------------------------------------------------------------------------
Summary:	The popt package contains the popt libraries which are used by some programs parse command-line options.
Name:		popt
Version:	1.16
Release:	1
License:	GPL
URL:		http://rpm5.org/files/popt
Group:		BLFS/General_Libraries 
Vendor:		Octothorpe
Source0:	http://rpm5.org/files/popt/%{name}-%{version}.tar.gz
BuildRequires:	linux
%description
		The popt package contains the popt libraries which are used by some programs parse command-line options.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{name}-%{version}
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-static
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_mandir}/man3/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 1.16-1
-	LFS-8.1
