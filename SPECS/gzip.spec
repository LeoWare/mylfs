Summary:	Programs for compressing and decompressing files
Name:		gzip
Version:	1.6
Release:	0
License:	GPLv3
URL:		http://www.gnu.org/software
Group:		Applications/File
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/gzip/%{name}-%{version}.tar.xz
%description
The Gzip package contains programs for compressing and
decompressing files.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--bindir=/bin \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}/bin
install -vdm 755 %{buildroot}%{_bindir}
mv -v %{buildroot}/bin/{gzexe,uncompress,zcmp,zdiff,zegrep}	%{buildroot}%{_bindir}
mv -v %{buildroot}/bin/{zfgrep,zforce,zgrep,zless,zmore,znew}	%{buildroot}%{_bindir}
rm -rf %{buildroot}%{_infodir}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%files
%defattr(-,root,root)
/bin/*
%{_bindir}/*
%{_mandir}/*/*
%changelog
*	Fri Jun 28 2013 baho-utot <baho-utot@columbus.rr.com> 1.6-0
-	Update version
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 1.5-1
-	Initial build.	First version
