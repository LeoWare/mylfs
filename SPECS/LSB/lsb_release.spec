Name:           lsb-release
Version:        1.4
Release:        1%{?dist}
Summary:        The lsb_release script gives information about the Linux Standards Base (LSB) status of the distribution.

License:        TBD
URL:            http://linuxbase.org/
Source0:        https://downloads.sourceforge.net/lsb/lsb-release-1.4.tar.gz

BuildRequires:  help2man

%description
The lsb_release script gives information about the Linux Standards Base (LSB) status of the distribution.

%prep
%setup -q
sed -i "s|n/a|unavailable|" lsb_release

%build
./help2man -N --include ./lsb_release.examples \
              --alt_version_key=program_version ./lsb_release > lsb_release.1

%install
rm -rf $RPM_BUILD_ROOT

install -vD -m 644 lsb_release.1 $RPM_BUILD_ROOT%{_mandir}/man1/lsb_release.1
install -vD -m 755 lsb_release   $RPM_BUILD_ROOT%{_bindir}/lsb_release

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%doc %{_mandir}/*/*


%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 1.4-1
-	Initial build.