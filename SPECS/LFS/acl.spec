Summary:	The Acl package contains utilities to administer Access Control Lists.
Name:		acl
Version:	2.2.52
Release:	1

License:	GPLv2
URL:		http://savannah.nongnu.org/projects/acl
Group:		Applications/System
Vendor:		Bonsai
Distribution:	LFS
Source:		http://download.savannah.gnu.org/releases/%{name}/%{name}-%{version}.src.tar.gz


%description
The Acl package contains utilities to administer Access Control Lists, which are used to define more fine-grained discretionary access rights for files and directories.


%prep
%setup -q
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
sed -i 's/{(/\\{(/' test/run
sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
    libacl/__acl_to_any_text.c

%build
./configure --prefix=%{_prefix} \
            --disable-static \
            --libexecdir=%{_libdir}
make %{?_smp_mflags}

%check

%install
make %{?_smp_mflags} DESTDIR=%{buildroot} install
make %{?_smp_mflags} DESTDIR=%{buildroot} install-dev
make %{?_smp_mflags} DESTDIR=%{buildroot} install-lib
install -vdm 755 %{buildroot}%{_lib}
chmod -v 755 %{buildroot}%{_libdir}/libacl.so
mv -v %{buildroot}%{_libdir}/libacl.so.* %{buildroot}%{_lib}
ln -sfv ../../%{_lib}/$(readlink %{buildroot}/usr/lib/libacl.so) %{buildroot}%{_libdir}/libacl.so
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
%{_datadir}/locale/de/LC_MESSAGES/acl.mo
%{_datadir}/locale/es/LC_MESSAGES/acl.mo
%{_datadir}/locale/fr/LC_MESSAGES/acl.mo
%{_datadir}/locale/gl/LC_MESSAGES/acl.mo
%{_datadir}/locale/pl/LC_MESSAGES/acl.mo
%{_datadir}/locale/sv/LC_MESSAGES/acl.mo
%changelog
*   Fri Sep 22 2017 Samuel Raynor <samuel@samuelraynor.com> 2.2.52-1
-	Initial build.	First version
