#TARBALL:	http://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz
#MD5SUM:	12e517cac2b57a0121cda351570f1e63;SOURCES/intltool-0.51.0.tar.gz
#-----------------------------------------------------------------------------
Summary:	The Intltool is an internationalization tool used for extracting translatable strings from source files.
Name:		intltool
Version:	0.51.0
Release:	1
License:	GPLv2
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://launchpad.net/intltool/trunk/0.51.0/+download/%{name}-%{version}.tar.gz
%description
The Intltool is an internationalization tool used for extracting translatable strings from source files.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i 's:\\\${:\\\$\\{:' intltool-update.in
%build
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vDm 644 doc/I18N-HOWTO %{buildroot}%{_docdir}/%{name}-%{version}/I18N-HOWTO
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
	%{_mandir}/man8/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 0.51.0-1
-	Initial build.	First version
