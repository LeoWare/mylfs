Summary:	The Psmisc package contains programs for displaying information about running processes.
Name:		psmisc
Version:	23.1
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	shadow
Source0:	https://sourceforge.net/projects/psmisc/files/%{name}/%{name}-%{version}.tar.xz
%description
	The Psmisc package contains programs for displaying information about running processes.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	CPPFLAGS='-I/usr/include ' \
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/bin
	mv -v %{buildroot}%{_bindir}/fuser   %{buildroot}/bin
	mv -v %{buildroot}%{_bindir}/killall %{buildroot}/bin
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man/d' filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 23.1-1
-	Initial build.	First version
