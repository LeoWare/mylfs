Summary:	The OpenSSH package contains ssh clients and the sshd daemon.
Name:		openssh
Version:	7.5p1
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Requires:	filesystem
Requires(pre): /usr/sbin/useradd, /usr/bin/getent
Requires(postun): /usr/sbin/userdel
Source0:	http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/%{name}-%{version}.tar.gz
Source1:	http://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20170731.tar.xz
Patch0:		openssh-7.5p1-openssl-1.1.0-1.patch
%description
	The OpenSSH package contains ssh clients and the sshd daemon. This is useful for encrypting authentication
	and subsequent traffic over a network. The ssh and scp commands are secure implementations of telnet and
	rcp respectively. 
%prep
%setup -q -n %{NAME}-%{VERSION}
%setup -q -T -D -a 1 -n %{name}-%{version}
%patch0 -p1
%build
#	CFLAGS='%_optflags ' \
#	CXXFLAGS='%_optflags ' \
	./configure \
		--prefix=%{_prefix} \
		--sysconfdir=/etc/ssh \
		--with-md5-passwords \
		--with-privsep-path=/var/lib/sshd
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -v -m755    contrib/ssh-copy-id %{buildroot}/usr/bin
	install -v -m644    contrib/ssh-copy-id.1 %{buildroot}/usr/share/man/man1
	install -v -m755 -d %{buildroot}/usr/share/doc/openssh-7.5p1
	install -v -m644    INSTALL LICENCE OVERVIEW README* %{buildroot}/usr/share/doc/openssh-7.5p1
	install  -v -m700 -d %{buildroot}/var/lib/sshd
	chown    -v root:sys %{buildroot}/var/lib/sshd
	echo "PermitRootLogin yes" >> %{buildroot}/etc/ssh/sshd_config
	#
	#	Boot scripts
	#	
	cd ${RPM_BUILD_DIR}/${RPM_PACKAGE_NAME}-${RPM_PACKAGE_VERSION}/blfs-bootscripts-20170731
	make DESTDIR=%{buildroot} install-sshd
	cd ${RPM_BUILD_DIR}/${RPM_PACKAGE_NAME}-${RPM_PACKAGE_VERSION}
	#	rm -rf %{buildroot}/%{_infodir}
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%pre
	/usr/sbin/groupadd -g 50 sshd
	/usr/sbin/useradd  -c 'sshd PrivSep' -d /var/lib/sshd -g sshd -s /bin/false -u 50 sshd
%post
	ssh-keygen -t ecdsa   -N '' -f /etc/ssh/ssh_host_ecdsa_key
	ssh-keygen -t ed25519 -N '' -f /etc/ssh/ssh_host_ed25519_key
	ssh-keygen -t rsa     -N '' -f /etc/ssh/ssh_host_rsa_key
	ssh-keygen -t dsa     -N '' -f /etc/ssh/ssh_host_dsa_key
%postun
	/usr/sbin/userdel sshd
%files -f filelist.rpm
	%defattr(-,root,root)
	/var/lib/sshd
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	Initial build.	First version
