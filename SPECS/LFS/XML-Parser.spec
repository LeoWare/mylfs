Name:           XML-Parser
Version:        2.44
Release:        1%{?dist}
Summary:        The XML::Parser module is a Perl interface to James Clark's XML parser, Expat.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications
License:        Free
URL:            https://github.com/chorny/XML-Parser
Source0:        http://cpan.metacpan.org/authors/id/T/TO/TODDR/%{name}-%{version}.tar.gz
       

%description
The XML::Parser module is a Perl interface to James Clark's XML parser, Expat.

%prep
%setup -q

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
%{_libdir}/perl5/*
%{_mandir}/*/*


%changelog
