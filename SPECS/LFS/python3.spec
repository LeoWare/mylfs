%{!?python_sitelib: %define python_sitelib %(%{__python} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}

Name:           Python
Version:        3.6.4
Release:        1%{?dist}
Summary:        The Python 3 package contains the Python development environment. It is useful for object-oriented programming, writing scripts, prototyping large programs or developing entire applications.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Development/Languages
License:        PSFv2
URL:            http://python.org/
Source0:        https://www.python.org/ftp/python/%{version}/%{name}-%{version}.tar.xz

Provides:		python(abi) = 3.6

BuildRequires:  sqlite3

%description
The Python 3 package contains the Python development environment. It is useful for object-oriented programming, writing scripts, prototyping large programs or developing entire applications.

%prep
%setup -q

%build
CXX="/usr/bin/g++"              \
%configure  --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

chmod -v 755 $RPM_BUILD_ROOT%{_libdir}/libpython3.6m.so
chmod -v 755 $RPM_BUILD_ROOT%{_libdir}/libpython3.so
#ln -svfn python-3.6.4 $RPM_BUILD_ROOT%{_docdir}/python-3


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/python*/*
%{_mandir}/*/*

%package devel
Summary: Development headers for %{name} %{version}

%description devel
Development headers for %{name} %{version}

%files devel
%{_libdir}/libpython3*
%{_libdir}/pkgconfig/*.pc
%{_includedir}/*

%post	-p /sbin/ldconfig

%postun	-p /sbin/ldconfig

%changelog
*	Wed Oct 10 2018 Samuel Raynor <samuel@samuelraynor.com> 3.6.4-1
-	Initial build.
