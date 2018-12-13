Name:           gst-plugins-good
Version:        1.12.4
Release:        1%{?dist}
Summary:        The GStreamer Good Plug-ins is a set of plug-ins considered by the GStreamer developers to have good quality code, correct functionality, and the preferred license (LGPL for the plug-in code, LGPL or LGPL-compatible for the supporting library). A wide range of video and audio decoders, encoders, and filters are included. 

License:        LGPL
URL:            https://gstreamer.freedesktop.org/
Source0:        https://gstreamer.freedesktop.org/src/gst-plugins-good/%{name}-%{version}.tar.xz

%description
The GStreamer Good Plug-ins is a set of plug-ins considered by the GStreamer developers to have good quality code, correct functionality, and the preferred license (LGPL for the plug-in code, LGPL or LGPL-compatible for the supporting library). A wide range of video and audio decoders, encoders, and filters are included. 

%prep
%setup -q


%build
%configure \
	--with-package-name="GStreamer Good Plugins 1.12.4 BLFS" \
	--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/"
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
%find_lang %{name}-1.0

%clean
rm -rf $RPM_BUILD_ROOT


%files -f %{name}-1.0.lang
%{_lib64dir}/gstreamer-1.0/*
%{_datadir}/gstreamer-1.0/*
%doc %{_datadir}/gtk-doc/html/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%changelog
*	Sat Dec 01 2018 Samuel Raynor <samuel@samuelraynor.com> 1.12.4-1
-	Initial build.