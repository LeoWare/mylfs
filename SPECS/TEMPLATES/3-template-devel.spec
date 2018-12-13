%{name}-%{version}

%doc %{_docdir}/%{name}-%{version}

*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 5.0.1-1
-	Initial build.

find $RPM_BUILD_ROOT -name "*.la" -delete


# Use this for any package that has:
#	C language include files (/usr/include/*)
#	pkg-config files (/{,usr/}{lib,lib32,lib64}/pkgconfig/*.pc)


%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_datadir}/aclocal/*
%{_libdir}/pkgconfig/*.pc



# Use this for any package that installs a .so file.
%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_datadir}/aclocal/*
%{_libdir}/pkgconfig/*.pc


# Use this for Python and modules
%{!?python_sitelib: %define python_sitelib %(%{__python} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}