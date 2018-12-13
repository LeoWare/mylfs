Name:           libfm
Version:        1.2.5
Release:        1%{?dist}
Summary:        The libfm package contains a library used to develop file managers providing some file management utilities.

License:        TBD
URL:            https://wiki.lxde.org/en/Libfm
Source0:        https://downloads.sourceforge.net/pcmanfm/libfm-1.2.5.tar.xz

%description
The libfm package contains a library used to develop file managers providing some file management utilities.

%prep
%setup -q


%build
%configure --disable-static
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%find_lang %{name}

%clean
rm -rf $RPM_BUILD_ROOT


%files -f %{name}.lang
%{_sysconfdir}/xdg/*
%{_bindir}/*
%{_libdir}/libfm-*
%{_libdir}/libfm.*
%dir %{_libdir}/libfm
%{_libdir}/libfm/modules/*
%{_datadir}/applications/*.desktop
%{_datadir}/libfm/*
%doc %{_mandir}/*/*
%{_datadir}/mime/packages/*

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
*	Thu Dec 06 2018 Samuel Raynor <samuel@samuelraynor.com> 1.2.5-1
-	Initial build.