Summary:	Programs for logging system messages
Name:		sysklogd
Version:	1.5
Release:	1
License:	GPLv2
URL:		http://www.infodrom.org/projects/sysklogd
Group:		System Environment/Daemons
Vendor:		LeoWare
Distribution:	MyLFS
Source0:	http://www.infodrom.org/projects/sysklogd/download/%{name}-%{version}.tar.gz
%description
The package contains programs for logging system messages
such as those given by the kernel when unusual things happen.
%prep
%setup -q
%build
make VERBOSE=1 %{?_smp_mflags}
%install
install -vdm 755 %{buildroot}%{_sysconfdir}/logrotate.d
install -vdm 755 %{buildroot}%{_mandir}/man{5,8}
install -vdm 755 %{buildroot}%{_sbindir}
install -vdm 755 %{buildroot}%{_includedir}/sysklogd
install -vdm 755 %{buildroot}/sbin
make install prefix=%{buildroot} \
	TOPDIR=%{buildroot} \
	MANDIR=%{buildroot}%{_mandir} \
	BINDIR=%{buildroot}/sbin \
	MAN_USER=`id -nu` MAN_GROUP=`id -ng`
cat > %{buildroot}/etc/syslog.conf <<- "EOF"
	# Begin /etc/syslog.conf

	auth,authpriv.* -/var/log/auth.log
	*.*;auth,authpriv.none -/var/log/sys.log
	daemon.* -/var/log/daemon.log
	kern.* -/var/log/kern.log
	mail.* -/var/log/mail.log
	user.* -/var/log/user.log
	*.emerg *

	# End /etc/syslog.conf
EOF
cat > %{buildroot}/etc/logrotate.d/sysklogd <<- "EOF"
	/var/log/messages /var/log/secure /var/log/maillog /var/log/spooler /var/log/boot.log /var/log/cron {
	weekly
	sharedscripts
	postrotate
	/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
	endscript
}
EOF
%files
%defattr(-,root,root)
%config(noreplace) %{_sysconfdir}/syslog.conf
%config(noreplace) %{_sysconfdir}/logrotate.d/sysklogd
/sbin/*
%{_mandir}/*/*
%changelog
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 1.5-1
-	Initial build.	First version