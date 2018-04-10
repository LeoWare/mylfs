Summary:	The Zlib package contains compression and decompression routines used by some programs.
Name:		tools-zlib
Version:	1.2.11
Release:	1
License:	Any
URL:		http://zlib.net
Group:		LFS/Tools
Vendor:	Octothorpe
BuildRequires:	tools-xz
Source0:	http://zlib.net/zlib-%{version}.tar.xz
%define	_optflags -march=x86-64 -mtune=generic -O2 -pipe -fPIC
%description
The Zlib package contains compression and decompression routines used by some programs.
%prep
%setup -q -n zlib-%{VERSION}
%build
	  CFLAGS='%_optflags ' \
	CXXFLAGS='%_optflags ' \
	./configure \
		--prefix=%{_prefix} \
		--static
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	rm -rf %{buildroot}%{_mandir}
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
	%defattr(-,lfs,lfs)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version
