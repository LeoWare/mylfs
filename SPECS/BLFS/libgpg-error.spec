Name:           libgpg-error
Version:        1.27
Release:        1%{?dist}
Summary:        The libgpg-error package contains a library that defines common error values for all GnuPG components.

License:        GPLv2
URL:            http://www.gnupg.org/
Source0:        https://www.gnupg.org/ftp/gcrypt/%{name}/%{name}-%{version}.tar.bz2

%description
The libgpg-error package contains a library that defines common error values for all GnuPG components.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
install -v -m644 -D README RPM_BUILD_ROOT/usr/share/doc/%{name}-%{version}/README
rm -vf $RPM_BUILD_ROOT%{_infodir}/dir

%find_lang %{name}
%clean
rm -rf $RPM_BUILD_ROOT


%files -f %{name}.lang
%{_bindir}/*
%{_libdir}/*
%doc %{_mandir}/*/*
%doc %{_infodir}/*.info*
%dir %{_datadir}/common-lisp/source/gpg-error
%{_datadir}/common-lisp/source/gpg-error/*
%dir %{_datadir}/%{name}
%{_datadir}/%{name}/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_datadir}/aclocal/*

%changelog
*	Mon Dec 03 2018 Samuel Raynor <samuel@samuelraynor.com> 1.27-1
-	Initial build.