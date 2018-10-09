Summary:	Bourne-Again SHell
Name:		bash
Version:	4.4.18
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/bash/
Group:		LFS/Base
Vendor:		LeoWare
Distribution:	MyLFS
Source0:	http://ftp.gnu.org/gnu/bash/%{name}-%{version}.tar.gz
Provides:	/bin/sh
Provides:	/bin/bash
%description
The package contains the Bourne-Again SHell
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
*	Sun May 19 2013 baho-utot <baho-utot@columbus.rr.com> 4.2-1
-	Upgrade version

