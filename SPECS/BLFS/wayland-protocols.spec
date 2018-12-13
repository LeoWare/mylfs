Name:           wayland-protocols
Version:        1.13
Release:        1%{?dist}
Summary:        The Wayland-Protocols package contains additional Wayland protocols that add functionality outside of protocols already in the Wayland core.

License:        TBD
URL:            https://wayland.freedesktop.org/
Source0:        https://wayland.freedesktop.org/releases/wayland-protocols-1.13.tar.xz

BuildRequires:  wayland, wayland-devel

%description
The Wayland-Protocols package contains additional Wayland protocols that add functionality outside of protocols already in the Wayland core.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


find $RPM_BUILD_ROOT -name "*.la" -delete

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_datadir}/pkgconfig/*.pc
%{_datadir}/%{name}/*


%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.13-1
-	Initial build.