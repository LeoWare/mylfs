Name:           libvdpau
Version:        1.1.1
Release:        1%{?dist}
Summary:        The libvdpau package contains a library which implements the VDPAU library. 

License:        TBD
URL:            https://01.org/linuxmedia
Source0:        https://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.bz2

%description
The libvdpau package contains a library which implements the VDPAU library.
VDPAU (Video Decode and Presentation API for Unix) is an open source library (libvdpau) and API originally designed by Nvidia for its GeForce 8 series and later GPU hardware targeted at the X Window System This VDPAU API allows video programs to offload portions of the video decoding process and video post-processing to the GPU video-hardware.
Currently, the portions capable of being offloaded by VDPAU onto the GPU are motion compensation (mo comp), inverse discrete cosine transform (iDCT), VLD (variable-length decoding) and deblocking for MPEG-1, MPEG-2, MPEG-4 ASP (MPEG-4 Part 2), H.264/MPEG-4 AVC and VC-1, WMV3/WMV9 encoded videos. Which specific codecs of these that can be offloaded to the GPU depends on the version of the GPU hardware; specifically, to also decode MPEG-4 ASP (MPEG-4 Part 2), Xvid/OpenDivX (DivX 4), and DivX 5 formats, a GeForce 200M (2xxM) Series (the eleventh generation of Nvidia's GeForce graphics processing units) or newer GPU hardware is required. 

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}

%configure --docdir=%{_docdir}/libvdpau-1.1.1
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete

%clean
rm -rf $RPM_BUILD_ROOT


%files
%config(noreplace) %{_sysconfdir}/*.cfg
%{_libdir}/*.so*
%{_libdir}/vdpau/*.so*


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
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.1.1-1
-	Initial build.