Summary:	The GNU Database Manager
Name:		gdbm
Version:	1.11
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/gdbm
Group:		Applications/Databases
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/gdbm/%{name}-%{version}.tar.gz
%description
This is a disk file format database which stores key/data-pairs in
single files. The actual data of any record being stored is indexed
by a unique key, which can be retrieved in less time than if it was
stored in a text file.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--enable-libgdbm-compat \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
find %{buildroot}%{_libdir} -name '*.la' -delete
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%{_libdir}/*
%{_includedir}/*
%{_mandir}/*/*
%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 1.11-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 1.10-1
-	Initial build.	First version
