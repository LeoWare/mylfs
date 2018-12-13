Name:           unzip
Version:        6.0
Release:        1%{?dist}
Summary:        The UnZip package contains ZIP extraction utilities. These are useful for extracting files from ZIP archives. ZIP archives are created with PKZIP or Info-ZIP utilities, primarily in a DOS environment.

License:        TBD
URL:            http://infozip.sourceforge.net/
Source0:        https://downloads.sourceforge.net/infozip/unzip60.tar.gz


%description
The UnZip package contains ZIP extraction utilities. These are useful for extracting files from ZIP archives. ZIP archives are created with PKZIP or Info-ZIP utilities, primarily in a DOS environment.

%prep
%setup -q -n unzip60


%build
make %{?_smp_mflags} -f unix/Makefile generic


%install
rm -rf $RPM_BUILD_ROOT
install -vdm 755 $RPM_BUILD_ROOT

make prefix=$RPM_BUILD_ROOT/usr MANDIR=$RPM_BUILD_ROOT%{_mandir}/man1 -f unix/Makefile install


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%doc %{_mandir}/*/*


%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 6.0-1
-	Initial build.