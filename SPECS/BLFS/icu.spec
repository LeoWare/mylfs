Name:           icu
Version:        60.2
Release:        1%{?dist}
Summary:        The International Components for Unicode (ICU) package is a mature, widely used set of C/C++ libraries providing Unicode and Globalization support for software applications.

License:        TBD
URL:            http://www.icu-project.org/
Source0:        http://download.icu-project.org/files/icu4c/60.2/icu4c-60_2-src.tgz

%description
The International Components for Unicode (ICU) package is a mature, widely used set of C/C++ libraries providing Unicode and Globalization support for software applications. ICU is widely portable and gives applications the same results on all platforms.

%prep
%setup -q -n icu


%build
cd source
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
cd source
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_lib64dir}/%{name}/*
%{_lib64dir}/*.so*
%{_sbindir}/*
%{_datadir}/%{name}/*
%doc %{_mandir}/*/*



%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig


%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Summary: Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc


%changelog
*	Mon Dec 03 2018 Samuel Raynor <samuel@samuelraynor.com> 60.2-1
-	Initial build.