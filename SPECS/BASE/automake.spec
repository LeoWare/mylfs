Summary:	The Automake package contains programs for generating Makefiles for use with Autoconf
Name:		automake
Version:	1.15.1
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	autoconf
Source0:	http://ftp.gnu.org/gnu/automake/%{name}-%{version}.tar.xz
%description
	The Automake package contains programs for generating Makefiles for use with Autoconf
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--docdir=%{_docdir}/%{NAME}-%{VERSION}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.15.1-1
-	Initial build.	First version
