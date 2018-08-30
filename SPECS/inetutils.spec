Summary:	Programs for basic networking
Name:		inetutils
Version:	1.9.2
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/inetutils
Group:		Applications/Communications
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/inetutils/%{name}-%{version}.tar.gz
%description
The Inetutils package contains programs for basic networking.
%prep
%setup -q
echo '#define PATH_PROCNET_DEV "/proc/net/dev"' >> ifconfig/system/linux.h 
%build
./configure \
	--prefix=%{_prefix} \
	--localstatedir=%{_var} \
	--disable-logger \
	--disable-syslogd \
	--disable-whois \
	--disable-servers \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}/{bin,sbin}
mv -v %{buildroot}%{_bindir}/{hostname,ifconfig,ping,ping6,traceroute} %{buildroot}/bin
rm -rf %{buildroot}%{_infodir}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%files
%defattr(-,root,root)
/bin/*
%{_bindir}/*
%{_mandir}/man1/*
%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 1.9.2-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 1.9.1-1
-	Initial build.	First version
