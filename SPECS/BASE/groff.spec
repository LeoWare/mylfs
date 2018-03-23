Summary:	The Groff package contains programs for processing and formatting text.
Name:		groff
Version:	1.22.3
Release:	1
License:	GPLv3
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	findutils
Source0:	http://ftp.gnu.org/gnu/groff/%{name}-%{version}.tar.gz
%description
	The Groff package contains programs for processing and formatting text.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	PAGE=letter \
	./configure \
		--prefix=%{_prefix}
	make
%install
	make DESTDIR=%{buildroot} install
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	rm  %{buildroot}/usr/share/info/dir
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.22.3-1
-	Initial build.	First version
