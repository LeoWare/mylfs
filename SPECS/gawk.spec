Summary:	Contains programs for manipulating text files
Name:		gawk
Version:	4.1.0
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/gawk
Group:		Applications/File
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/gawk/%{name}-%{version}.tar.xz
%description
The Gawk package contains programs for manipulating text files.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}%{_defaultdocdir}/%{name}-%{version}
cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} %{buildroot}%{_defaultdocdir}/%{name}-%{version}
rm -rf %{buildroot}%{_infodir}
find %{buildroot}%{_libdir} -name '*.la' -delete
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%{_libdir}/%{name}/*
%{_includedir}/*
%{_libexecdir}/*
%{_datarootdir}/awk/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_mandir}/*/*
%changelog
*	Sat May 11 2013 baho-utot <baho-utot@columbus.rr.com> 4.1.0-1
-	Upgrade version
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 4.0.2-1
-	Upgrade version
