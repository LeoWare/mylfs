Name:           intltool
Version:        0.51.0
Release:        1%{?dist}
Summary:        The Intltool is an internationalization tool used for extracting translatable strings from source files.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/Text
License:        GPLv2
URL:            https://freedesktop.org/wiki/Software/intltool/
Source0:        https://launchpad.net/intltool/trunk/%{version}/+download/%{name}-%{version}.tar.gz  

%description
The Intltool is an internationalization tool used for extracting translatable strings from source files.

%prep
%setup -q
sed -i 's:\\\${:\\\$\\{:' intltool-update.in

%build
%configure
make %{?_smp_mflags}

%check
make check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
install -v -Dm644 doc/I18N-HOWTO $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}/I18N-HOWTO

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/*
%{_mandir}/*/*
%{_datadir}/aclocal/*
%{_datadir}/%{name}/*
%doc %{_docdir}/%{name}-%{version}/*




%changelog
*	Tue Oct 9 2018 Samuel Raynor <samuel@samuelraynor.com> 0.51.0-1
-	Initial build.
