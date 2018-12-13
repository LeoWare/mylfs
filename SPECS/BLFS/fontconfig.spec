Name:           fontconfig
Version:        2.12.6
Release:        1%{?dist}
Summary:        The Fontconfig package contains a library and support programs used for configuring and customizing font access.

License:        TBD
URL:            https://www.freedesktop.org/wiki/Software/fontconfig/
Source0:        https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.6.tar.bz2

BuildRequires:  freetype

%description
The Fontconfig package contains a library and support programs used for configuring and customizing font access.

%prep
%setup -q
rm -f src/fcobjshash.h

%build
%configure	--disable-docs \
			--docdir=/usr/share/doc/%{name}-%{version}
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete

%clean
rm -rf $RPM_BUILD_ROOT


%files
%config(noreplace) %{_sysconfdir}/fonts/conf.d/*
%config(noreplace) %{_sysconfdir}/fonts/fonts.conf
%{_bindir}/*
%{_datadir}/%{name}
%{_datadir}/xml/%{name}
%{_libdir}/

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc



%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 2.12.6-1
-	Initial build.