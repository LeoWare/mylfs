Name:           help2man
Version:        1.47.8
Release:        1%{?dist}
Summary:        help2man is a tool for automatically generating simple manual pages from program output.
Vendor:			LeoWare
Distribution:	MyLFS

License:        Unknown
URL:            https://www.gnu.org/software/help2man/help2man.html
Source0:        http://ftp.gnu.org/gnu/help2man/%{name}-%{version}.tar.xz

%description
help2man is a tool for automatically generating simple manual pages from program output. Although manual pages are optional for GNU programs other projects, such as Debian require them. This program is intended to provide an easy way for software authors to include a manual page in their distribution without having to maintain that document. Given a program which produces reasonably standard ‘--help’ and ‘--version’ outputs, help2man can re-arrange that output into something which resembles a manual page.

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
%{_bindir}/help2man
%doc %{_mandir}/*/*
%doc %{_infodir}/*


%changelog
*	Thu Nov 22 2018 Samuel Raynor <samuel@samuelraynor.com> 1.47.8-1
-	Initial build.