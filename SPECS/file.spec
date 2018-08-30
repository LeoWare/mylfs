Summary:	Contains a utility for determining file types
Name:		file
Version:	5.32
Release:	1
License:	Other
URL:		http://www.darwinsys.com/file
Group:		Applications/File
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		ftp://ftp.astron.com/pub/file/%{name}-%{version}.tar.gz
%description
The package contains a utility for determining the type of a
given file or files
%prep
%setup -q
%build
./configure --prefix=%{_prefix}
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
#find %{buildroot}%{_libdir} -name '*.la' -delete
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_bindir}/*
%{_libdir}/*
%{_includedir}/*
%{_mandir}/*/*
%{_datarootdir}/misc/magic.mgc
%changelog
*	Thu May 01 2014 baho-utot <baho-utot@columbus.rr.com> 5.17-1
*	Mon Apr 01 2013 baho-utot <baho-utot@columbus.rr.com> 5.14-1
-	Initial version
