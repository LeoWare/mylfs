%define __python3 /usr/bin/python3
%define python_sitelib %(%{__python3} -Es %{_rpmconfigdir}/python-macro-helper sitelib)
Name:		libxml2
Version:	2.9.7
Release:	1%{?_dist}
Summary:	The libxml2 package contains libraries and utilities used for parsing XML files.
License:	Free
Url:		http://xmlsoft.org/
Source0:	http://xmlsoft.org/sources/libxml2-2.9.7.tar.gz
Patch0:		http://www.linuxfromscratch.org/patches/blfs/8.2/libxml2-2.9.7-python3_hack-1.patch

%description
The libxml2 package contains libraries and utilities used for parsing XML files.

%prep
%setup -q
%patch -P 0 -p1
sed -i '/_PyVerify_fd/,+1d' python/types.c

%build
%configure \
	--disable-static \
	--with-history   \
	--with-python=/usr/bin/python3

make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=$RPM_BUILD_ROOT install
find $RPM_BUILD_ROOT -name \*.la -delete

%files
%{_bindir}/*
%{_libdir}/*.so*
%{_libdir}/xml2Conf.sh
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_datadir}/gtk-doc/*
%doc %{_mandir}/*/*


%package devel
Summary: Development files for %{name}-%{version}

%description devel
Development files for %{name}-%{version}

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*
%{_libdir}/cmake/%{name}/*
%{_datadir}/aclocal/*.m4

%package python
Summary: Python bindings for %{name}

%description python
Python bindings for %{name}

%files python
%{python_sitelib}/*
%doc %{_docdir}/%{name}-python-%{version}/*



%changelog
*	Fri Oct 19 2018 Samuel Raynor <samuel@samuelraynor.com> 2.9.7-1
-	Initial build.
