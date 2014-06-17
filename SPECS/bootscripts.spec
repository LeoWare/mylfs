Summary:	Scripts for booting system
Name:		bootscripts
Version:	20130821
Release:	1
License:	GPLv3
URL:		http://www.linuxfromscratch.org/lfs
Group:		LFS/Base
Vendor:		Bildanet
Distribution:	Octothorpe
BuildArch:	noarch
Source0:	http://www.linuxfromscratch.org/lfs/downloads/development/lfs-%{name}-%{version}.tar.bz2
%description
The LFS-Bootscripts package contains a set of scripts to start/stop
the LFS system at boot up/shutdown.
%prep
cd %{_builddir}
tar xvf %{SOURCE0}
cd %{_builddir}/lfs-%{name}-%{version}
%build
%install
cd %{_builddir}/lfs-%{name}-%{version}
make DESTDIR=%{buildroot} install
%files
%defattr(-,root,root)
%dir	%{_sysconfdir}/rc.d/init.d
%config %{_sysconfdir}/init.d
%config %{_sysconfdir}/rc.d/init.d/checkfs
%config %{_sysconfdir}/rc.d/init.d/cleanfs
%config %{_sysconfdir}/rc.d/init.d/console
%config %{_sysconfdir}/rc.d/init.d/functions
%config %{_sysconfdir}/rc.d/init.d/halt
%config %{_sysconfdir}/rc.d/init.d/localnet
%config %{_sysconfdir}/rc.d/init.d/modules
%config %{_sysconfdir}/rc.d/init.d/mountfs
%config %{_sysconfdir}/rc.d/init.d/mountvirtfs
%config %{_sysconfdir}/rc.d/init.d/network
%config %{_sysconfdir}/rc.d/init.d/rc
%config %{_sysconfdir}/rc.d/init.d/reboot
%config %{_sysconfdir}/rc.d/init.d/sendsignals
%config %{_sysconfdir}/rc.d/init.d/setclock
%config %{_sysconfdir}/rc.d/init.d/swap
%config %{_sysconfdir}/rc.d/init.d/sysctl
%config %{_sysconfdir}/rc.d/init.d/sysklogd
%config %{_sysconfdir}/rc.d/init.d/template
%config %{_sysconfdir}/rc.d/init.d/udev
%config %{_sysconfdir}/rc.d/init.d/udev_retry
%config %{_sysconfdir}/rc.d/rc0.d
%config %{_sysconfdir}/rc.d/rc1.d
%config %{_sysconfdir}/rc.d/rc2.d
%config %{_sysconfdir}/rc.d/rc3.d
%config %{_sysconfdir}/rc.d/rc4.d
%config %{_sysconfdir}/rc.d/rc5.d
%config %{_sysconfdir}/rc.d/rc6.d
%config %{_sysconfdir}/rc.d/rcS.d
%config %{_sysconfdir}/sysconfig/createfiles
%config %{_sysconfdir}/sysconfig/modules
%config (noreplace) %{_sysconfdir}/sysconfig/rc.site
%config %{_sysconfdir}/sysconfig/udev_retry
/lib/lsb
/lib/services/init-functions
/lib/services/ipv4-static
/lib/services/ipv4-static-route
/sbin/*
%{_mandir}/*/*
%changelog
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 20130821-1
*	Thu May 16 2013 baho-utot <baho-utot@columbus.rr.com> 20130515-1
*	Wed May 15 2013 baho-utot <baho-utot@columbus.rr.com> 20130511-1
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 20130123-1
-	Upgrade version
