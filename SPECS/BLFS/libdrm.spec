Name:           libdrm
Version:        2.4.89
Release:        1%{?dist}
Summary:        libdrm provides a user space library for accessing the DRM, direct rendering manager, on operating systems that support the ioctl interface. libdrm is a low-level library, typically used by graphics drivers such as the Mesa DRI drivers, the X drivers, libva and similar projects.

License:        TBD
URL:            https://dri.freedesktop.org/wiki/
Source0:        https://dri.freedesktop.org/libdrm/libdrm-2.4.89.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  cairo, cairo-devel, docbook-xml, docbook-xsl, libxslt, libxslt-devel

%description
libdrm provides a user space library for accessing the DRM, direct rendering manager, on operating systems that support the ioctl interface. libdrm is a low-level library, typically used by graphics drivers such as the Mesa DRI drivers, the X drivers, libva and similar projects.

%prep
%setup -q


%build
%configure --enable-udev
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

find $RPM_BUILD_ROOT -name "*.la" -delete

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_libdir}/*.so*
%{_datadir}/%{name}/*
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
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 2.4.89-1
-	Initial build.