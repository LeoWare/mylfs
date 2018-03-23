Summary:	The Shadow package contains programs for handling passwords in a secure way.
Name:		shadow
Version:	4.5
Release:	1
License:	Artistic
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	sed
Source0:	https://github.com/shadow-maint/shadow/releases/download/4.5/%{name}-%{version}.tar.xz
%description
	The Shadow package contains programs for handling passwords in a secure way.
%prep
%setup -q -n %{NAME}-%{VERSION}
	sed -i 's/groups$(EXEEXT) //' src/Makefile.in
	find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
	find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
	find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
	sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
		-e 's@/var/spool/mail@/var/mail@' etc/login.defs
	sed -i 's/1000/999/' etc/useradd
%build
	./configure \
		--sysconfdir=/etc \
		--with-group-name-max-length=32
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	install -vdm 755 %{buildroot}/bin
	mv -v %{buildroot}/usr/bin/passwd %{buildroot}/bin
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man/d' filelist.rpm
%clean
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 4.5-1
-	Initial build.	First version
