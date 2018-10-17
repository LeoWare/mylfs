Summary:	GRand Unified Bootloader
Name:		grub
Version:	2.02
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/grub
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/grub/%{name}-%{version}.tar.xz

%description
The GRUB package contains the GRand Unified Bootloader.

%prep
%setup -q

%build
./configure \
	--prefix=%{_prefix} \
	--sbindir=/sbin \
	--sysconfdir=%{_sysconfdir} \
	--disable-efiemu \
	--disable-werror
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} install
rm -f %{buildroot}%{_infodir}/dir
%find_lang %{name}

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig

%files -f %{name}.lang
%defattr(-,root,root)
%dir %{_sysconfdir}/grub.d
%config() %{_sysconfdir}/bash_completion.d/grub
%config() %{_sysconfdir}/grub.d/00_header
%config() %{_sysconfdir}/grub.d/10_linux
%config() %{_sysconfdir}/grub.d/20_linux_xen
%config() %{_sysconfdir}/grub.d/30_os-prober
%config() %{_sysconfdir}/grub.d/40_custom
%config() %{_sysconfdir}/grub.d/41_custom
%config() %{_sysconfdir}/grub.d/README
/sbin/*
%{_bindir}/*
%{_libdir}/*
%{_datadir}/%{name}/*
%{_infodir}/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 2.02-1
-	Initial build.
