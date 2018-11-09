Summary:	Programs for processing and formatting text
Name:		groff
Version:	1.22.3
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/groff
Group:		Applications/Text
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/groff/%{name}-%{version}.tar.gz

%description
The Groff package contains programs for processing
and formatting text.

%prep
%setup -q

%build
PAGE=letter %configure
make -j1

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} install
rm -f %{buildroot}%{_infodir}/dir

%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig

%files
%defattr(-,root,root)
%{_bindir}/*
%{_libdir}/*
%{_docdir}/%{name}-%{version}/*
%{_datarootdir}/%{name}/*
%doc %{_mandir}/*/*
%doc %{_infodir}/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 4.6.0-1
-	Initial build.
