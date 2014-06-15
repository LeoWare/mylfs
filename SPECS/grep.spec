Summary:	Programs for searching through files
Name:		grep
Version:	2.16
Release:	0
License:	GPLv3
URL:		http://www.gnu.org/software/grep
Group:		Applications/File
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/grep/%{name}-%{version}.tar.xz
%description
The Grep package contains programs for searching through files.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--bindir=/bin \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%files -f %{name}.lang
%defattr(-,root,root)
/bin/*
%{_mandir}/*/*
%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 2.16-0
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 2.14-1
