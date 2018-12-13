Name:           polkit
Version:        0.113+git_2919920+js38
Release:        1%{?dist}
Summary:        Polkit is a toolkit for defining and handling authorizations.

License:		GPLv2
URL:            https://www.freedesktop.org/wiki/Software/polkit/
Source0:        http://anduin.linuxfromscratch.org/BLFS/polkit/polkit-0.113+git_2919920+js38.tar.xz

%description
Polkit is a toolkit for defining and handling authorizations. It is used for allowing unprivileged processes to communicate with privileged processes.

%prep
%setup -q


%build
%configure	--disable-static \
			--enable-gtk-doc
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

install -vdm 755 $RPM_BUILD_ROOT/etc/pam.d
cat > $RPM_BUILD_ROOT/etc/pam.d/polkit-1 << "EOF"
# Begin /etc/pam.d/polkit-1

auth     include        system-auth
account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/polkit-1
EOF

%find_lang polkit-1

%clean
rm -rf $RPM_BUILD_ROOT


%files -f polkit-1.lang
%{_bindir}/*
%{_lib64dir}/*
%{_sysconfdir}/dbus-1/system.d/*
%{_sysconfdir}/pam.d/polkit-1
%{_sysconfdir}/polkit-1/rules.d/*
/lib/systemd/system/polkit.service
/usr/lib/*
%{_datadir}/dbus-1/*
%{_datadir}/gettext/*
%{_datadir}/gir-1.0/*
%doc %{_datadir}/gtk-doc/html/polkit-1/*
%doc %{_mandir}/*/*
%{_datadir}/polkit-1/*


%post
/usr/sbin/groupadd -fg 27 polkitd
/usr/sbin/useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 27 \
        -g polkitd -s /bin/false polkitd
/sbin/ldconfig
%postun
/usr/sbin/userdel -f polkitd
/usr/sbin/groupdel -f polkitd
/sbin/ldconfig


%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc

%changelog
*	Mon Dec 03 2018 Samuel Raynor <samuel@samuelraynor.com> 0.113+git_2919920+js38-1
-	Initial build.