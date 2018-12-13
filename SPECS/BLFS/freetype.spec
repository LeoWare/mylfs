Name:           freetype
Version:        2.9
Release:        1%{?dist}
Summary:        The FreeType2 package contains a library which allows applications to properly render TrueType fonts.

License:        TBD
URL:            TPD
Source0:        https://downloads.sourceforge.net/freetype/freetype-2.9.tar.bz2
Source1:		https://downloads.sourceforge.net/freetype/freetype-doc-2.9.tar.bz2

BuildRequires:  harfbuzz, libpng, libpng-devel

%description
The FreeType2 package contains a library which allows applications to properly render TrueType fonts.

%prep
%setup -q
%{__tar} -xf $RPM_SOURCE_DIR/freetype-doc-2.9.tar.bz2 --strip-components=2 -C docs

%{__sed} -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg

%{__sed} -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" -i include/freetype/config/ftoption.h

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
%{_mandir}/*/*

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
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 2.9-1
-	Initial build.