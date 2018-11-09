Summary:	Key table files, console fonts, and keyboard utilities
Name:		kbd
Version:	2.0.4
Release:	1
License:	GPLv2
URL:		http://ftp.altlinux.org/pub/people/legion/kbd
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.altlinux.org/pub/people/legion/kbd/%{name}-%{version}.tar.xz
Patch0:		kbd-2.0.4-backspace-1.patch

%description
The Kbd package contains key-table files, console fonts, and keyboard utilities.

%prep
%setup -q
%patch0 -p1
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

%build
#PKG_CONFIG_PATH=/tools/lib/pkgconfig \
./configure \
	--prefix=%{_prefix} \
	--disable-vlock
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}%{_docdir}/%{name}-%{version}
cp -R -v docs/doc/* %{buildroot}%{_docdir}/%{name}-%{version}
%find_lang %{name}

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig

%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_datarootdir}/consolefonts/*
%{_datarootdir}/consoletrans/*
%{_datarootdir}/keymaps/*
%{_datarootdir}/unimaps/*
%{_mandir}/*/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 2.0.4-1
-	Initial build.
