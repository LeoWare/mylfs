Name:           Linux-PAM
Version:        1.3.0
Release:        2%{?dist}
Summary:        The Linux PAM package contains Pluggable Authentication Modules used to enable the local system administrator to choose how applications authenticate users.
License:		None
URL:            http://linux-pam.org/
Source0:        http://linux-pam.org/library/Linux-PAM-1.3.0.tar.bz2
Obsoletes:		Linux-PAM = 1.3.0-1


%description
The Linux PAM package contains Pluggable Authentication Modules used to enable the local system administrator to choose how applications authenticate users.

%prep
%setup -q


%build
./configure --prefix=/usr                    \
            --sysconfdir=/etc                \
            --libdir=/usr/lib                \
            --disable-regenerate-docu        \
            --enable-securedir=/lib/security \
            --docdir=/usr/share/doc/Linux-PAM-1.3.0
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} install
chmod -v 4755 %{buildroot}/sbin/unix_chkpwd

%find_lang %{name}

%{__install} -vdm 755 %{buildroot}%{_lib}
for file in pam pam_misc pamc
do
  mv -v %{buildroot}%{_libdir}/lib${file}.so.* %{buildroot}%{_lib}
  ln -sfv ../../lib/$(readlink %{buildroot}%{_libdir}/lib${file}.so) %{buildroot}%{_libdir}/lib${file}.so
done

%{__install} -vdm 755 %{buildroot}%{_sysconfdir}/pam.d

cat > %{buildroot}%{_sysconfdir}/pam.d/other << "EOF"
# Begin /etc/pam.d/other

auth        required        pam_warn.so
auth        required        pam_deny.so
account     required        pam_warn.so
account     required        pam_deny.so
password    required        pam_warn.so
password    required        pam_deny.so
session     required        pam_warn.so
session     required        pam_deny.so

# End /etc/pam.d/other
EOF

cat > %{buildroot}%{_sysconfdir}/pam.d/system-account << "EOF"
# Begin /etc/pam.d/system-account

account   required    pam_unix.so

# End /etc/pam.d/system-account
EOF

cat > %{buildroot}%{_sysconfdir}/pam.d/system-auth << "EOF"
# Begin /etc/pam.d/system-auth

auth      required    pam_unix.so

# End /etc/pam.d/system-auth
EOF

cat > %{buildroot}%{_sysconfdir}/pam.d/system-session << "EOF"
# Begin /etc/pam.d/system-session

session   required    pam_unix.so

# End /etc/pam.d/system-session
EOF

cat > %{buildroot}%{_sysconfdir}/pam.d/system-password << "EOF"
# Begin /etc/pam.d/system-password

# use sha512 hash for encryption, use shadow, and try to use any previously
# defined authentication token (chosen password) set by any prior module
password  required    pam_unix.so       sha512 shadow try_first_pass

# End /etc/pam.d/system-password
EOF

%files -f %{name}.lang
%config(noreplace) %{_sysconfdir}/environment
%config(noreplace) %{_sysconfdir}/pam.d/*
%config(noreplace) %{_sysconfdir}/security/*
%{_lib}/*
%{_libdir}/*
%{_includedir}/*
/sbin/*
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_mandir}/*/*

%changelog
