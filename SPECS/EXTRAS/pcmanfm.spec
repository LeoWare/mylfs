Name:           pcmanfm
Version:        1.2.5
Release:        1%{?dist}
Summary:        The PCManFM package contains an extremely fast, lightweight, yet feature-rich file manager with tabbed browsing.

License:        TBD
URL:            https://wiki.lxde.org/en/PCManFM
Source0:        https://downloads.sourceforge.net/pcmanfm/pcmanfm-1.2.5.tar.xz

%description
The PCManFM package contains an extremely fast, lightweight, yet feature-rich file manager with tabbed browsing.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%find_lang %{name}

%clean
rm -rf $RPM_BUILD_ROOT


%files -f %{name}.lang
%{_sysconfdir}/xdg/*
%{_bindir}/%{name}
%dir %{_datadir}/pcmanfm
%{_datadir}/pcmanfm/*
%{_datadir}/applications/*.desktop
%doc %{_mandir}/*/*

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*

%changelog
*	Thu Dec 06 2018 Samuel Raynor <samuel@samuelraynor.com> 1.2.5-1
-	Initial build.