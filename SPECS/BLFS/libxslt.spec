Name:           libxslt
Version:        1.1.32
Release:        1%{?dist}
Summary:        The libxslt package contains XSLT libraries used for extending libxml2 libraries to support XSLT files.

License:        TBD
URL:            http://xmlsoft.org/
Source0:        http://xmlsoft.org/sources/libxslt-1.1.32.tar.gz

BuildRequires:  libxml2, docbook-xml, docbook-xsl, libgcrypt, libgcrypt-devel

%description
The libxslt package contains XSLT libraries used for extending libxml2 libraries to support XSLT files.

%prep
%setup -q
sed -i s/3000/5000/ libxslt/transform.c doc/xsltproc.{1,xml}

%build
%configure --disable-static
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/*.so*
%{_libdir}/python*/site-packages/*
%{_libdir}/xsltConf.sh
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_docdir}/%{name}-python-%{version}/*
%doc %{_mandir}/*/*


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

%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.1.32-1
-	Initial build.