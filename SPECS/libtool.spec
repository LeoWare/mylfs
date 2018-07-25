Summary:	The Libtool package contains the GNU generic library support script
Name:		libtool
Version:	2.4.6
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/libtool/%{name}-%{version}.tar.xz
%description
	The Libtool package contains the GNU generic library support script. It wraps the
	complexity of using shared libraries in a consistent, portable interface.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.4.6-1
-	Initial build.	First version
