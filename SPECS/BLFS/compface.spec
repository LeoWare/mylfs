Name:           compface
Version:        1.5.2
Release:        1%{?dist}
Summary:        Compface provides utilities and a library to convert from/to X-Face format, a 48x48 bitmap format used to carry thumbnails of email authors in a mail header.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/System
License:        GPLv2
URL:            localhost
Source0:        http://anduin.linuxfromscratch.org/BLFS/compface/compface-1.5.2.tar.gz

%description
Compface provides utilities and a library to convert from/to X-Face format, a 48x48 bitmap format used to carry thumbnails of email authors in a mail header.

%prep
%setup -q


%build
%configure --mandir=/usr/share/man
make %{?_smp_mflags}

%check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
install -vdm 755 $RPM_BUILD_ROOT%{_bindir}
install -m755 -v xbm2xface.pl $RPM_BUILD_ROOT%{_bindir}

%clean
rm -rf $RPM_BUILD_ROOT

%files
/usr/bin/xbm2xface.pl

%changelog
*	Wed Nov 14 2018 Samuel Raynor <samuel@samuelraynor.com> 1.5.2-1
-	Initial build.