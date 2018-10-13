Name:           Python2
Version:        2.7.14
Release:        1%{?dist}
Summary:        The Python 2 package contains the Python development environment. It is useful for object-oriented programming, writing scripts, prototyping large programs or developing entire applications. This version is for backward compatibility with other dependent packages.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Development/Languages
License:        PSFv2
URL:            http://python.org/
Source0:        https://www.python.org/ftp/python/2.7.14/Python-%{version}.tar.xz

Provides:		python(abi) = 2.7
Obsoletes:		Python = 2.7.14-1

BuildRequires:  sqlite3 tk

%description
The Python 2 package contains the Python development environment. It is useful for object-oriented programming, writing scripts, prototyping large programs or developing entire applications. This version is for backward compatibility with other dependent packages.

%prep
%setup -q -n Python-%{version}
sed -i '/#SSL/,+3 s/^#//' Modules/Setup.dist

%build
%configure  --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes \
            --enable-unicode=ucs4
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
rm -v $RPM_BUILD_ROOT%{_bindir}/2to3

chmod -v 755 /usr/lib/libpython2.7.so.1.0

%clean
rm -rf $RPM_BUILD_ROOT

%package devel
Summary: Contains the header files from %{name} %{version}.

%description devel
Contains the header files from %{name} %{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc

%files
%{_bindir}/*
%{_libdir}/python2.7/*
%{_libdir}/libpython*
%{_mandir}/*/*

%changelog
