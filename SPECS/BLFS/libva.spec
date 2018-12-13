Name:           libva
Version:        2.1.0
Release:        1%{?dist}
Summary:        The libva package contains a library which provides access to hardware accelerated video processing, using hardware to accelerate video processing in order to offload the central processing unit (CPU) to decode and encode compressed digital video.

License:        TBD
URL:            https://01.org/linuxmedia
Source0:        https://github.com/intel/libva/releases/download/2.1.0/libva-2.1.0.tar.bz2
Source1:        https://github.com/intel/intel-vaapi-driver/releases/download/2.1.0/intel-vaapi-driver-2.1.0.tar.bz2

BuildRequires:  libdrm, libdrm-devel, wayland, wayland-devel

%description
The libva package contains a library which provides access to hardware accelerated video processing, using hardware to accelerate video processing in order to offload the central processing unit (CPU) to decode and encode compressed digital video. The VA API video decode/encode interface is platform and window system independent targeted at Direct Rendering Infrastructure (DRI) in the X Window System however it can potentially also be used with direct framebuffer and graphics sub-systems for video output. Accelerated processing includes support for video decoding, video encoding, subpicture blending, and rendering.

%prep
%setup -q
%setup -q -T -D -a 1


%build
%configure
make %{?_smp_mflags}

cd intel-vaapi-driver-%{version}

%configure
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
cd intel-vaapi-driver-%{version}
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_prefix}/lib/dri/*.so
%{_libdir}/*.so*

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
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 2.1.0-1
-	Initial build.