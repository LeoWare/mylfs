Summary:	The Bash package contains the Bourne-Again SHell.
Name:		bash
Version:	4.4
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Source0:	http://ftp.gnu.org/gnu/%{name}/%{name}-%{version}.tar.gz
Patch0:		bash-4.4-upstream_fixes-1.patch
%description
	The Bash package contains the Bourne-Again SHell.
%prep
%setup -q -n %{NAME}-%{VERSION}
%patch0 -p1
%build
	./configure \
		--prefix=%{_prefix} \
		--docdir=/usr/share/doc/%{NAME}-%{VERSION} \
		--without-bash-malloc \
		--with-installed-readline
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/bin
	mv -vf %{buildroot}/usr/bin/bash %{buildroot}/bin
	ln -vs bash %{buildroot}/bin/sh
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	rm  %{buildroot}/usr/share/info/dir
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version