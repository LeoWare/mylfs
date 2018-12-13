Name:           rpmdevtools
Version:        8.9
Release:        1%{?dist}
Summary:        rpmdevtools contains many scripts to aid in package development.
Vendor:			LeoWare
Distribution:	MyLFS

License:        GPLv2
URL:            Localhost
Source0:        rpmdevtools-8.9.tar.xz

%description
rpmdevtools contains many scripts to aid in package development.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}

%check


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%doc %{_mandir}/*/*
%{_datadir}/rpmdevtools/*
%{_datadir}/bash-completion/completions/*
%dir %{_sysconfdir}/rpmdevtools
%config(noreplace) %{_sysconfdir}/rpmdevtools/*

%changelog
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 8.9-1
-	Initial build.