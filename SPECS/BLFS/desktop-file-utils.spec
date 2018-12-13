Name:           desktop-file-utils
Version:        0.23
Release:        1%{?dist}
Summary:        The Desktop File Utils package contains command line utilities for working with Desktop entries.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/System
License:        GPLv2
URL:            localhost
Source0:        https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz

%description
These utilities are used by Desktop Environments and other applications to manipulate the MIME-types application databases and help adhere to the Desktop Entry Specification.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}

%check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
/usr/bin/desktop-file-edit
/usr/bin/desktop-file-install
/usr/bin/desktop-file-validate
/usr/bin/update-desktop-database
/usr/share/man/man1/desktop-file-edit.1.gz
/usr/share/man/man1/desktop-file-install.1.gz
/usr/share/man/man1/desktop-file-validate.1.gz
/usr/share/man/man1/update-desktop-database.1.gz

%changelog
*	Wed Nov 14 2018 Samuel Raynor <samuel@samuelraynor.com> 0.23-1
-	Initial build.