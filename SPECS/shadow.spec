Summary:	Programs for handling passwords in a secure way
Name:		shadow
Version:	4.1.5.1
Release:	0
URL:		http://pkg-shadow.alioth.debian.org/
License:	BSD
Group:		Applications/System
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://cdn.debian.net/debian/pool/main/s/%{name}/%{name}_%{version}.orig.tar.gz
%description
The Shadow package contains programs for handling passwords
in a secure way.
%prep
%setup -q -n %{name}-%{version}
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
	-e 's@/var/spool/mail@/var/mail@' etc/login.defs
%build
./configure \
	--sysconfdir=/etc \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}/bin
mv -v %{buildroot}%{_bindir}/passwd %{buildroot}/bin
sed -i 's/yes/no/' %{buildroot}/etc/default/useradd
%find_lang %{name}
%post
%{_sbindir}/pwconv
%{_sbindir}/grpconv
%files -f %{name}.lang
%defattr(-,root,root)
%config(noreplace) /etc/login.defs
%config(noreplace) /etc/login.access
%config(noreplace) /etc/default/useradd
%config(noreplace) /etc/limits
/bin/*
/sbin/nologin
%{_bindir}/*
%{_sbindir}/*
%{_mandir}/*/*
%changelog
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 4.1.5.1-0
-	Initial build.	First version
