Name:           glib
Version:        2.56.3
Release:        2%{?dist}
Summary:        The GLib package contains low-level libraries useful for providing data structure handling for C, portability wrappers and interfaces for such runtime functionality as an event loop, threads, dynamic loading and an object system.
Vendor:			LeoWare
Distribution:	MyLFS

License:        LGPLv2.1
URL:            https://developer.gnome.org/glib/
Source0:        http://ftp.gnome.org/pub/gnome/sources/glib/2.56/%{name}-%{version}.tar.xz
#Patch0:			http://www.linuxfromscratch.org/patches/blfs/8.2/glib-2.54.3-meson_fixes-1.patch
Patch1:			http://www.linuxfromscratch.org/patches/blfs/8.2/glib-2.54.3-skip_warnings-1.patch

%description
The GLib package contains low-level libraries useful for providing data structure handling for C, portability wrappers and interfaces for such runtime functionality as an event loop, threads, dynamic loading and an object system.

%prep
%setup -q
#% bpatch -P 0 -p1
%patch -P 1 -p1


%build
mkdir build-glib
cd    build-glib

LANG=en_US.UTF-8 %{__meson} --prefix=/usr -Dwith-pcre=system -Dwith-docs=no -Dselinux=false ..
LANG=en_US.UTF-8 %{__ninja}

%check


%install
rm -rf $RPM_BUILD_ROOT
cd build-glib
DESTDIR=$RPM_BUILD_ROOT %{__ninja} install

chmod -v 755 $RPM_BUILD_ROOT/usr/bin/{gdbus-codegen,glib-gettextize}

mkdir -pv $RPM_BUILD_ROOT/usr/share/doc/%{name}-%{version}
cp -r ../docs/reference/{COPYING,NEWS,AUTHORS,gio,glib,gobject} $RPM_BUILD_ROOT/usr/share/doc/%{name}-%{version}

%{find_lang} glib20

%clean
rm -rf $RPM_BUILD_ROOT


%files -f build-glib/glib20.lang
%{_bindir}/*
%{_lib64dir}/libgio-2.0.*
%{_lib64dir}/libglib-2.0.*
%{_lib64dir}/libgmodule-2.0.*
%{_lib64dir}/libgobject-2.0.*
%{_lib64dir}/libgthread-2.0.*
%{_datadir}/bash-completion/completions/*
%doc %{_docdir}/%{name}-%{version}/*
%{_datadir}/gdb/*
%{_datadir}/gettext/*
%{_datadir}/glib-2.0/*
#% {_mandir}/*/*

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Summary: Development files for %{name}-%{version}.

%files devel
%{_includedir}/gio-unix-2.0/*
%{_includedir}/glib-2.0/*
%{_lib64dir}/pkgconfig/*.pc
%{_lib64dir}/glib-2.0/include/*
%{_datadir}/aclocal/*

%changelog
*	Sat Dec 01 2018 Samuel Raynor <samuel@samuelraynor.com> 2.56-2
-	Upgrade version.
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 2.54.3-1
-	Initial build.