Name:           Python
Version:        2.7.14
Release:        1%{?dist}
Summary:        The Python 2 package contains the Python development environment. It is useful for object-oriented programming, writing scripts, prototyping large programs or developing entire applications. This version is for backward compatibility with other dependent packages.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Development/Languages
License:        PSFv2
URL:            http://python.org/
Source0:        https://www.python.org/ftp/python/2.7.14/%{name}-${version}.tar.xz

Provides:		python(abi) = 2.7

BuildRequires:  sqlite3 tk
Requires:       

%description
The Python 2 package contains the Python development environment. It is useful for object-oriented programming, writing scripts, prototyping large programs or developing entire applications. This version is for backward compatibility with other dependent packages.

%prep
%setup -q
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

chmod -v 755 /usr/lib/libpython2.7.so.1.0

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{!?_licensedir:%global license %%doc}
%license add-license-file-here
%doc add-docs-here



%changelog
