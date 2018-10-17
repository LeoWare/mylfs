Summary:	Utilities for file systems, consoles, partitions, and messages
Name:		util-linux
Version:	2.31.1
Release:	1
URL:		http://www.kernel.org/pub/linux/utils/util-linux
License:	GPLv2
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source:		%{name}-%{version}.tar.xz

%description
Utilities for handling file systems, consoles, partitions,
and messages.

%prep
%setup -q

%build
./configure ADJTIME_PATH=%{_sharedstatedir}/hwclock/adjtime   \
            --docdir=%{_docdir}/%{name}-%{version} \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
install -vdm 755 %{buildroot}%{_sharedstatedir}/hwclock
make DESTDIR=%{buildroot} install
find %{buildroot} -name '*.la' -delete
%find_lang %{name}

%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig

%files -f %{name}.lang
%defattr(-,root,root)
%dir %{_sharedstatedir}/hwclock
/bin/*
%{_lib}/*
/sbin/*
%{_bindir}/*
%{_libdir}/*
%{_includedir}/*
%{_sbindir}/*
%doc %{_mandir}/*/*
%{_datadir}/bash-completion/completions/*
%{_docdir}/%{name}-%{version}/getopt/*

%package devel
Summary: Development files for %{name}-%{version}

%description devel
Developement files for %{name}-%{version}

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*.pc

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 2.31.1-1
-	Initial build.
