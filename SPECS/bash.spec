Summary:	The Bash package contains the Bourne-Again SHell.
Name:		bash
Version:	4.4.18
Release:	1
License:	GPLv3
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}.tar.gz
%description
	The Bash package contains the Bourne-Again SHell.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--docdir=%{_docdir}/%{NAME}-%{VERSION} \
		--without-bash-malloc \
		--with-installed-readline
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/bin
	mv -vf %{buildroot}%{_bindir}/bash %{buildroot}/bin
	ln -vs bash %{buildroot}/bin/sh
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot}%{_infodir} -name 'dir' -delete
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
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 4.4.18-1
-	Initial build.	First version
