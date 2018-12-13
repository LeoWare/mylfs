Name:           Perl-IPC-System-Simple
Version:        1.25
Release:        1%{?dist}
Summary:        IPC::System::Simple - Run commands simply, with detailed diagnostics
Vendor:			LeoWare
Distribution:	MyLFS

License:        Unknown
URL:            http://search.cpan.org/dist/IPC-System-Simple/
Source0:        https://cpan.metacpan.org/authors/id/P/PJ/PJF/IPC-System-Simple-1.25.tar.gz

%description
IPC::System::Simple - Run commands simply, with detailed diagnostics

%prep 
%setup -q -n IPC-System-Simple-%{version}


%build
perl Makefile.PL
make %{?_smp_mflags}

%check
make test

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
rm -vf $RPM_BUILD_ROOT%{_libdir}/perl5/*/*/perllocal.pod

%clean
rm -rf $RPM_BUILD_ROOT


%files

%{_libdir}/perl5/*/*
%{_mandir}/*/*


%changelog
*	Wed Nov 21 2018 Samuel Raynor <samuel@samuelraynor.com> 1.22-1
-	Initial build.