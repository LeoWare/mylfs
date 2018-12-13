Name:           Perl-Module-Build
Version:        0.4224
Release:        1%{?dist}
Summary:        Module::Build allows perl modules to be built without a make command being present.
Vendor:			LeoWare
Distribution:	MyLFS

License:        Free
URL:            https://github.com/Perl-Toolchain-Gang/Module-Build
Source0:        https://www.cpan.org/authors/id/L/LE/LEONT/Module-Build-0.4224.tar.gz

%description
Module::Build allows perl modules to be built without a make command being present.

%prep 
%setup -q -n Module-Build-%{version}


%build
perl Makefile.PL
make %{?_smp_mflags}

%check
make test

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/config_data
%{_libdir}/perl5/site_perl/*/*
%{_mandir}/*/*


%changelog
*	Wed Nov 21 2018 Samuel Raynor <samuel@samuelraynor.com> 0.4224-1
-	Initial build.