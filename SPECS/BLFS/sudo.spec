Name:           sudo
Version:        1.8.22
Release:        1%{?dist}
Summary:        The Sudo package allows a system administrator to give certain users (or groups of users) the ability to run some (or all) commands as root or another user while logging the commands and arguments.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/System
License:        TBD
URL:            http://www.sudo.ws/
Source0:        http://www.sudo.ws/dist/sudo-1.8.22.tar.gz

%description
The Sudo package allows a system administrator to give certain users (or groups of users) the ability to run some (or all) commands as root or another user while logging the commands and arguments.

%prep
%setup -q


%build
%configure \
	--libexecdir=%{_libdir} \
	--with-secure-path \
	--with-all-insults \
	--with-env-editor \
	--docdir=%{_docdir}/%{name}-%{version} \
	--with-passprompt="[sudo] password for %p: "
make %{?_smp_mflags}

%check
make check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
ln -sfv libsudo_util.so.0.0.0 $RPM_BUILD_ROOT%{_libdir}/%{name}/libsudo_util.so.0
%find_lang %{name}

%clean
rm -rf $RPM_BUILD_ROOT
#rm -rf $RPM_BUILD_DIR


%files -f %{name}.lang
%config(noreplace) %{_sysconfdir}/sudoers
%{_sysconfdir}/sudoers.dist
%{_bindir}/*
%{_sbindir}/*
%doc %{_docdir}/%{name}-%{version}
%doc %{_mandir}/*/*

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*

%changelog
*	Thu Oct 18 2018 Samuel Raynor <samuel@samuelraynor.com> 1.8.22-1
-	Initial build.
