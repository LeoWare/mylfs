Name:           accountsservice
Version:        0.6.45
Release:        1%{?dist}
Summary:        The AccountsService package provides a set of D-Bus interfaces for querying and manipulating user account information.

License:        GPLv3
URL:            https://www.freedesktop.org/wiki/Software/AccountsService/
Source0:        https://www.freedesktop.org/software/accountsservice/accountsservice-0.6.45.tar.xz

%description
The AccountsService package provides a set of D-Bus interfaces for querying and manipulating user account information and an implementation of those interfaces based on the usermod(8), useradd(8) and userdel(8) commands.

%prep
%setup -q


%build
%configure  --enable-admin-group=adm \
            --disable-static \
            --enable-docbook-docs
make %{?_smp_mflags}



%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%find_lang accounts-service

%clean
rm -rf $RPM_BUILD_ROOT


%files -f accounts-service.lang
%{_sysconfdir}/dbus-1/system.d/*
/lib/systemd/system/*.service
%{_libdir}/girepository-1.0/*
%{_libdir}/*.la
%{_libdir}/*.so*
%{_libexecdir}/*
%{_datadir}/dbus-1/interfaces/*
%{_datadir}/dbus-1/system-services/*
%{_datadir}/gir-1.0/*
%doc %{_datadir}/gtk-doc/html/*
%{_datadir}/polkit-1/actions/*
%doc %{_docdir}/%{name}/*



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
*	Mon Dec 03 2018 Samuel Raynor <samuel@samuelraynor.com> 0.6.45-1
-	Initial build.