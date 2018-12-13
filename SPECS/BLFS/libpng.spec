Name:           libpng
Version:        1.6.34
Release:        1%{?dist}
Summary:        The libpng package contains libraries used by other programs for reading and writing PNG files.

License:        TBD
URL:            TBD
Source0:        https://downloads.sourceforge.net/libpng/libpng-1.6.34.tar.xz
Patch0:         https://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-1.6.34-apng.patch.gz


%description
The libpng package contains libraries used by other programs for reading and writing PNG files. The PNG format was designed as a replacement for GIF and, to a lesser extent, TIFF, with many improvements and extensions and lack of patent problems.

%prep
%setup -q
%patch -P 0 -p 1


%build
export LIBS=-lpthread %configure --disable-static
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

mkdir -v $RPM_BUILD_ROOT/usr/share/doc/libpng-1.6.34 &&
cp -v README libpng-manual.txt $RPM_BUILD_ROOT/usr/share/doc/libpng-1.6.34


find $RPM_BUILD_ROOT -name "*.la" -delete


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/*.so*
%doc %{_mandir}/*/*

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
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.6.34-1
-	Initial build.