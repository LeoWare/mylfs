Name:           sylpheed
Version:        3.7.0
Release:        1%{?dist}
Summary:        Sylpheed is a lightweight and user-friendly e-mail client.

License:        GPLv2
URL:            http://sylpheed.sraoss.jp/en/
Source0:        https://osdn.net/dl/sylpheed/sylpheed-3.7.0.tar.xz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
Sylpheed is a lightweight and user-friendly e-mail client.

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
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/pixmaps/*
%{_libdir}/*


%post
/sbin/ldconfig
[ -f /usr/bin/xdg-desktop-menu ] && /usr/bin/xdg-desktop-menu install --novendor --mode system %{_datadir}/applications/%{name}.desktop

%postun
/sbin/ldconfig
[ -f /usr/bin/xdg-desktop-menu ] && /usr/bin/xdg-desktop-menu unininstall --novendor --mode system %{_datadir}/applications/%{name}.desktop

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*

%changelog
*	Thu Dec 06 2018 Samuel Raynor <samuel@samuelraynor.com> 3.7.0-1
-	Initial build.