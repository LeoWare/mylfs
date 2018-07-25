Summary:	The Autoconf package contains programs for producing shell scripts that can automatically configure source code.
Name:		autoconf
Version:	2.69
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/autoconf/%{name}-%{version}.tar.xz
%description
	The Autoconf package contains programs for producing shell scripts that can automatically configure source code.
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
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 2.69-1
-	Initial build.	First version
