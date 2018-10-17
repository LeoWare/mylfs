Summary:	Programs that show the differences between files or directories
Name:		diffutils
Version:	3.6
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/diffutils
Group:		LFS/Base
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/diffutils/%{name}-%{version}.tar.xz

%description
The Diffutils package contains programs that show the
differences between files or directories.

%prep
%setup -q
sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in

%build
%configure
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} install
rm -f %{buildroot}%{_infodir}/dir
%find_lang %{name}

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%doc %{_mandir}/*/*
%doc %{_infodir}/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 3.6-1
-	Upgraded package.
*	Mon Apr 01 2013 baho-utot <baho-utot@columbus.rr.com> 3.3-1
-	Initial build.	First version
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 2.6.1-1
-	Initial build.	First version

