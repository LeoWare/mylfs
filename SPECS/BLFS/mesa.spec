Name:           mesa
Version:        17.3.4
Release:        1%{?dist}
Summary:        Mesa is an OpenGL compatible 3D graphics library.

License:        TBD
URL:            https://mesa.freedesktop.org/
Source0:        https://mesa.freedesktop.org/archive/%{name}-%{version}.tar.xz
Patch0:         http://www.linuxfromscratch.org/patches/blfs/8.2/%{name}-%{version}-add_xdemos-1.patch

BuildRequires:  libdrm, libdrm-devel, Mako-Python2, Python2, libva, libva-devel, libvdpau, libvdpau-devel
BuildRequires:  llvm, llvm-devel, wayland-protocols, libgcrypt, libgcrypt-devel, nettle, nettle-devel


%description


%prep
%setup -q
%patch -P 0 -p 1

%build
%configure CFLAGS='-O2' CXXFLAGS='-O2' LDFLAGS=-lLLVM \
            --enable-texture-float             \
            --enable-osmesa                    \
            --enable-xa                        \
            --enable-glx-tls                   \
            --with-platforms="drm,x11,wayland" \
            --with-gallium-drivers="i915,r600,nouveau,radeonsi,svga,swrast"
make %{?_smp_mflags}

%check
make -C xdemos DEMOS_PREFIX=%{_prefix}
make check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

make -C xdemos DEMOS_PREFIX=%{_prefix} install DESTDIR=$RPM_BUILD_ROOT

install -v -dm755  $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}
cp -rfv docs/* $RPM_BUILD_ROOT%{_docdir}/%{name}-%{version}

find $RPM_BUILD_ROOT -name "*.la" -delete

%clean
rm -rf $RPM_BUILD_ROOT


%files
%config(noreplace) %{_sysconfdir}/drirc
%{_bindir}/*
%{_libdir}/*.so*
%{_libdir}/dri/*
%{_libdir}/vdpau/*
%doc %{_docdir}/%{name}-%{version}
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
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 17.3.4-1
-	Initial build.