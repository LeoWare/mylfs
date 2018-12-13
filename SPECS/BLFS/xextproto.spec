Name:           xextproto
Version:        7.3.0
Release:        1%{?dist}
Summary:        The Xorg protocol headers provide the header files required to build the system, and to allow other applications to build against the installed X Window system.

License:        TBD
URL:            https://www.x.org/
Source0:        https://www.x.org/pub/individual/proto/%{name}-%{version}.tar.bz2

BuildRequires:  util-macros

%description
The Xorg protocol headers provide the header files required to build the system, and to allow other applications to build against the installed X Window system.

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
%{_includedir}/X11/extensions/*
%{_libdir}/pkgconfig/*.pc
%doc %{_docdir}/%{name}/*


%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 7.3.0-1
-	Initial build.