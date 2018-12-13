Name:           mozjs
Version:        38.2.1
Release:        1%{?dist}
Summary:        JS is Mozilla's JavaScript engine written in C.

License:        TBD
URL:            TBD
Source0:        http://anduin.linuxfromscratch.org/BLFS/mozjs/mozjs-38.2.1.rc0.tar.bz2
Patch0:			http://www.linuxfromscratch.org/patches/blfs/8.2/js38-38.2.1-upstream_fixes-2.patch

%description
JS is Mozilla's JavaScript engine written in C.

%prep
%setup -q -n mozjs-38.0.0
%patch -P 0 -p1

%build
cd js/src
autoconf2.13
%configure --with-intl-api \
			--with-system-zlib \
			--with-system-ffi \
			--with-system-nspr \
			--with-system-icu \
			--enable-threadsafe \
			--enable-readline
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT

cd js/src
make install DESTDIR=$RPM_BUILD_ROOT

pushd $RPM_BUILD_ROOT/usr/include/mozjs-38
for link in `find . -type l`; do
    header=`readlink $link`
    rm -f $link
    cp -pv $header $link
    chmod 644 $link
done
popd

chown -Rv root.root $RPM_BUILD_ROOT/usr/include/mozjs-38

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_lib64dir}/*

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%changelog
*	Mon Dec 03 2018 Samuel Raynor <samuel@samuelraynor.com> 38.2.1-1
-	Initial build.