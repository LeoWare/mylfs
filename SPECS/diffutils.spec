Summary:	Programs that show the differences between files or directories
Name:		diffutils
Version:	3.3
Release:	0
License:	GPLv3
URL:		http://www.gnu.org/software/diffutils
Group:		LFS/Base
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/diffutils/%{name}-%{version}.tar.xz
%description
The Diffutils package contains programs that show the
differences between files or directories.
%prep
%setup -q
sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in
%build
./configure \
	--prefix=%{_prefix} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%{_mandir}/*/*
%changelog
*	Mon Apr 01 2013 baho-utot <baho-utot@columbus.rr.com> 3.3-0
-	Initial build.	First version
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 2.6.1-1
-	Initial build.	First version
