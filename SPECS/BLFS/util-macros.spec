Name:           util-macros
Version:        1.19.1
Release:        1%{?dist}
Summary:        The util-macros package contains the m4 macros used by all of the Xorg packages.

License:        TBD
URL:            https://www.x.org/
Source0:        https://www.x.org/pub/individual/util/%{name}-%{version}.tar.bz2


%description
The util-macros package contains the m4 macros used by all of the Xorg packages.

%prep
%setup -q


%build
%configure


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_datadir}/aclocal/*
%{_datadir}/pkgconfig/*.pc
%doc %{_datadir}/%{name}


%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.19.1-1
-	Initial build.