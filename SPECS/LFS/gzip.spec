Summary:	Programs for compressing and decompressing files
Name:		gzip
Version:	1.9
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software
Group:		Applications/File
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/gzip/%{name}-%{version}.tar.xz

%description
The Gzip package contains programs for compressing and
decompressing files.

%prep
%setup -q

%build
%configure
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install
install -vdm 755 %{buildroot}/bin
mv -v %{buildroot}%{_bindir}/gzip %{buildroot}/bin
rm -f %{buildroot}%{_infodir}/dir

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%files
%defattr(-,root,root)
/bin/*
%{_bindir}/*
%doc %{_mandir}/*/*
%doc %{_infodir}

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 1.9-1
-	Initial build.
