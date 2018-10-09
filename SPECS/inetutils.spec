Summary:	Programs for basic networking
Name:		inetutils
Version:	1.9.4
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/inetutils
Group:		Applications/Communications
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/inetutils/%{name}-%{version}.tar.xz
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
	--disable-rcp \
	--disable-whois \
	--disable-servers \
	--disable-rexec \
	--disable-rlogin \
	--disable-rsh
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
install -vdm 755 %{buildroot}/{bin,sbin}
mv -v %{buildroot}%{_bindir}/{hostname,ping,ping6,traceroute} %{buildroot}/bin
rm -rf %{buildroot}%{_infodir}

mv -v %{buildroot}/usr/bin/ifconfig %{buildroot}/sbin

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%files
%defattr(-,root,root)
/bin/*
/sbin/*
%{_bindir}/*
%{_mandir}/man1/*

%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 1.9.2-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 1.9.1-1
-	Initial build.	First version
