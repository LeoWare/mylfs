Summary:	Administer the extended attributes on filesystem objects
Name:		attr
Version:	2.4.47
Release:	1
License:	GPLv2
URL:		http://savannah.nongnu.org/projects/attr
Group:		Applications/System
Vendor:		Bonsai
Distribution:	LFS
Source:		http://download.savannah.gnu.org/releases/attr/%{name}-%{version}.src.tar.gz
%description
The attr package contains utilities to administer the extended attributes on filesystem objects.
%prep
%setup -q
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i -e "/SUBDIRS/s|man[25]||g" man/Makefile
sed -i 's:{(:\\{(:' test/run
%build
./configure --prefix=%{_prefix} \
            --disable-static
			#--sysconfdir=/etc \
			#--docdir=/usr/share/doc/attr-2.4.48
make %{?_smp_mflags}
%check
make -j1 tests root-tests
%install
make %{?_smp_mflags} DESTDIR=%{buildroot} install
make %{?_smp_mflags} DESTDIR=%{buildroot} install-dev
make %{?_smp_mflags} DESTDIR=%{buildroot} install-lib
install -vdm 755 %{buildroot}%{_lib}
chmod -v 755 %{buildroot}%{_libdir}/libattr.so
mv -v %{buildroot}%{_libdir}/libattr.so.* %{buildroot}%{_lib}
ln -sfv ../../%{_lib}/$(readlink %{buildroot}/usr/lib/libattr.so) %{buildroot}%{_libdir}/libattr.so
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_lib}/*
%{_bindir}/*
%{_includedir}/*
%{_libdir}/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_mandir}/*/*
%{_datadir}/locale/cs/LC_MESSAGES/attr.mo
%{_datadir}/locale/de/LC_MESSAGES/attr.mo
%{_datadir}/locale/es/LC_MESSAGES/attr.mo
%{_datadir}/locale/fr/LC_MESSAGES/attr.mo
%{_datadir}/locale/gl/LC_MESSAGES/attr.mo
%{_datadir}/locale/nl/LC_MESSAGES/attr.mo
%{_datadir}/locale/pl/LC_MESSAGES/attr.mo
%{_datadir}/locale/sv/LC_MESSAGES/attr.mo
%changelog
*   Fri Sep 22 2017 Samuel Raynor <samuel@samuelraynor.com> 2.4.47-1
-	Initial build.	First version
