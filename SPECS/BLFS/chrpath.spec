Name:           chrpath
Version:        0.16
Release:        1%{?dist}
Summary:        The chrpath modify the dynamic library load path (rpath and runpath) of compiled programs and libraries.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/System
License:        GPLv2
URL:            https://directory.fsf.org/wiki/Chrpath
Source0:        https://alioth.debian.org/frs/download.php/latestfile/813/chrpath-0.16.tar.gz

%description
The chrpath modify the dynamic library load path (rpath and runpath) of compiled programs and libraries.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}

%check

%install
rm -rf $RPM_BUILD_ROOT
make docdir=%{_docdir}/%{name}-%{version} install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
/usr/bin/chrpath
/usr/share/doc/chrpath-0.16/AUTHORS
/usr/share/doc/chrpath-0.16/COPYING
/usr/share/doc/chrpath-0.16/ChangeLog
/usr/share/doc/chrpath-0.16/INSTALL
/usr/share/doc/chrpath-0.16/NEWS
/usr/share/doc/chrpath-0.16/README
/usr/share/man/man1/chrpath.1.gz

%changelog
*	Wed Nov 14 2018 Samuel Raynor <samuel@samuelraynor.com> 0.16-1
-	Initial build.