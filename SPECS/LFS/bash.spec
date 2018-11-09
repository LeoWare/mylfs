Summary:	The Bash package contains the Bourne-Again SHell.
Name:		bash
Version:	4.4.18
Release:	1
License:	GPLv3
URL:		Any
Group:		LFS/Base
Vendor:		LeoWare
Distribution:	MyLFS
Source0:	http://ftp.gnu.org/gnu/bash/%{name}-%{version}.tar.gz
Provides:	/bin/sh
Provides:	/bin/bash
%description
	The Bash package contains the Bourne-Again SHell.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--without-bash-malloc \
	--with-installed-readline \
	--docdir=%{_defaultdocdir}/%{name}-%{version}
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}/bin
ln -s bash %{buildroot}/bin/sh
%find_lang %{name}
rm -rf %{buildroot}/%{_infodir}
%files -f %{name}.lang
%defattr(-,root,root)
/bin/sh
%{_bindir}/*
%{_libdir}/*
%{_includedir}/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_mandir}/*/*
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 4.4.18-1
-	Initial build.	First version
