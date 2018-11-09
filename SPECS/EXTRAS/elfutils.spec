Name:		elfutils
Summary:	A collection of utilities and DSOs to handle compiled objects
Version:	0.170
Release:	1
URL:		https://fedorahosted.org/elfutils/
License:	GPLv3+ and (GPLv2+ or LGPLv3+)
Group:		Development/Tools
Source:		 https://fedorahosted.org/releases/e/l/elfutils/%{version}/%{name}-%{version}.tar.bz2

%description
Elfutils is a collection of utilities, including ld (a linker),
nm (for listing symbols from object files), size (for listing the
section sizes of an object or archive file), strip (for discarding
symbols), readelf (to see the raw ELF file structures), and elflint
(to check for well-formed ELF files).

%prep
%setup -q

%build
%configure --program-prefix="eu-" --with-zlib --with-bzlib --with-lzma
make %{?_smp_mflags}

%install
make install DESTDIR=%{buildroot}
chmod +x %{buildroot}%{_libdir}/lib*.so*
chmod +x %{buildroot}%{_libdir}/elfutils/lib*.so*
%find_lang %{name}
find $RPM_BUILD_ROOT -name "*libelf*" -delete
%check
make -s check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig

%files	 -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%{_libdir}/*

%package devel
Summary: Development files for %{name}

%description devel
Development files for %{name}

%files devel
%{_includedir}/*

%changelog
*	Thu Apr 10 2014 baho-utot <baho-utot@columbus.rr.com> 0.158-1
*	Sun Aug 25 2013 baho-utot <baho-utot@columbus.rr.com> 0.156-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 0.155-1
-	Initial build.	First version
