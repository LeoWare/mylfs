Summary:	This package contains programs to find files
Name:		findutils
Version:	4.6.0
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/findutils
Group:		Applications/File
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/findutils/%{name}-%{version}.tar.gz

%description
These programs are provided to recursively search through a
directory tree and to create, maintain, and search a database
(often faster than the recursive find, but unreliable if the
database has not been recently updated).

%prep
%setup -q
sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in

%build
%configure --localstatedir=%{_sharedstatedir}/locate
make %{?_smp_mflags}

%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}/bin
mv -v %{buildroot}%{_bindir}/find %{buildroot}/bin
sed -i 's/find:=${BINDIR}/find:=\/bin/' %{buildroot}%{_bindir}/updatedb
rm -f %{buildroot}%{_infodir}/dir
%find_lang %{name}

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig

%files -f %{name}.lang
%defattr(-,root,root)
/bin/find
%{_bindir}/*
%{_libexecdir}/*
%doc %{_mandir}/*/*
%doc %{_infodir}/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 4.6.0-1
-	Initial build.
