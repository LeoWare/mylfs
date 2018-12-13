Name:           cairo
Version:        1.14.12
Release:        1%{?dist}
Summary:        Cairo is a 2D graphics library with support for multiple output devices.

License:        TBD
URL:            https://www.cairographics.org/
Source0:        https://www.cairographics.org/releases/cairo-1.14.12.tar.xz

BuildRequires:  libpng, pixman, fontconfig, glib, mesa, mesa-devel, llvm, llvm-devel
BuildRequires:  libdrm, libdrm-devel, wayland, wayland-devel

%description
Cairo is a 2D graphics library with support for multiple output devices. Currently supported output targets include the X Window System, win32, image buffers, PostScript, PDF and SVG. Experimental backends include OpenGL, Quartz and XCB file output. Cairo is designed to produce consistent output on all output media while taking advantage of display hardware acceleration when available (e.g., through the X Render Extension). The Cairo API provides operations similar to the drawing operators of PostScript and PDF. Operations in Cairo include stroking and filling cubic Bézier splines, transforming and compositing translucent images, and antialiased text rendering. All drawing operations can be transformed by any affine transformation (scale, rotation, shear, etc.).

%prep
%setup -q


%build
%configure --disable-static --enable-tee --enable-xlib-xcb --enable-gl --enable-gtk-doc
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/cairo
%{_libdir}/*.so*
%doc %{_datadir}/gtk-doc/html/*

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