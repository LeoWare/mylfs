Summary:	Programs to parse command-line options
Name:		popt
Version:	1.16
Release:	1
License:	GPLv1
URL:		http://rpm5.org/files/popt
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source:		ftp://anduin.linuxfromscratch.org/BLFS/svn/p/%{name}-%{version}.tar.gz
%description
The popt package contains the popt libraries which are used by
some programs to parse command-line options.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--bindir=%{_bindir} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
find %{buildroot} -name '*.la' -delete
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files -f %{name}.lang
%defattr(-,root,root)
%{_includedir}/*
%{_libdir}/*
%{_mandir}/*/*
%changelog
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 1.16-1
-	Initial build.	First version	
