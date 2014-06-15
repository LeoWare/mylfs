Summary:	Bourne-Again SHell
Name:		bash
Version:	4.2
Release:	0
License:	GPLv3
URL:		http://www.gnu.org/software/bash/
Group:		LFS/Base
Vendor:		Bildanet
Distribution:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/bash/%{name}-%{version}.tar.gz
Patch0:		http://www.linuxfromscratch.org/patches/lfs//development/bash-4.2-fixes-12.patch
Provides:	/bin/sh
Provides:	/bin/bash
%description
The package contains the Bourne-Again SHell
%prep
%setup -q
%patch0 -p1
%build
./configure \
	--prefix=%{_prefix} \
	--bindir=/bin \
	--htmldir=%{_defaultdocdir}/%{name}-%{version} \
	--without-bash-malloc \
	--with-installed-readline \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
ln -s bash %{buildroot}/bin/sh
%find_lang %{name}
rm -rf %{buildroot}/%{_infodir}
%files -f %{name}.lang
%defattr(-,root,root)
/bin/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_mandir}/*/*
%changelog
*	Sun May 19 2013 baho-utot <baho-utot@columbus.rr.com> 4.2-0
-	Upgrade version

