Summary:	Math libraries
Name:		gmp
Version:	6.1.2
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/gmp
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/gmp/%{name}-%{version}.tar.xz
%description
The GMP package contains math libraries. These have useful functions
for arbitrary precision arithmetic.
%prep
%setup -q
%build
%ifarch i386 i486 i586 i686
	ABI=32 ./configure --prefix=/usr    \
	--enable-cxx     \
	--disable-static \
	--docdir=/usr/share/doc/%{name}-%{version}
%else
	./configure --prefix=/usr    \
	--enable-cxx     \
	--disable-static \
	--docdir=%{docdir}/%{name}-%{version}
%endif
make %{?_smp_mflags}
make %{?_smp_mflags} html
%install
make DESTDIR=%{buildroot} install
make DESTDIR=%{buildroot} install-html
install -vdm 755 %{buildroot}%{_defaultdocdir}/%{name}-%{version}
cp -rv doc/{isa_abi_headache,configuration} doc/*.html %{buildroot}%{_defaultdocdir}/%{name}-%{version}
find %{buildroot}%{_libdir} -name '*.la' -delete
rm -rf %{buildroot}%{_infodir}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_includedir}/*.h
%{_libdir}/*
%{_defaultdocdir}/%{name}-%{version}/*
%changelog
*	Tue Apr 01 2014 baho-utot <baho-utot@columbus.rr.com> 5.1.3-1
*	Fri Jun 28 2013 baho-utot <baho-utot@columbus.rr.com> 5.1.2-1