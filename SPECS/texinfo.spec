Summary:	Reading, writing, and converting info pages
Name:		texinfo
Version:	5.2
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/texinfo/
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source0:	%{name}-%{version}.tar.xz
%description
The Texinfo package contains programs for reading, writing,
and converting info pages.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
make DESTDIR=%{buildroot} TEXMF=%{_datarootdir}/texmf install-tex
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%{_mandir}/*/*
%dir %{_datarootdir}/texinfo
%{_datarootdir}/texinfo/*
%dir %{_datarootdir}/texmf
%{_datarootdir}/texmf/*
%lang(de.us-ascii) %{_datarootdir}/locale/de.us-ascii/LC_MESSAGES/texinfo_document.mo
%lang(eo) %{_datarootdir}/locale/eo/LC_MESSAGES/texinfo_document.mo
%lang(es.us-ascii) %{_datarootdir}/locale/es.us-ascii/LC_MESSAGES/texinfo_document.mo
%lang(fr) %{_datarootdir}/locale/fr/LC_MESSAGES/texinfo_document.mo
%lang(hu) %{_datarootdir}/locale/hu/LC_MESSAGES/texinfo_document.mo
%lang(it) %{_datarootdir}/locale/it/LC_MESSAGES/texinfo_document.mo
%lang(nl) %{_datarootdir}/locale/nl/LC_MESSAGES/texinfo_document.mo
%lang(no.us-ascii) %{_datarootdir}/locale/no.us-ascii/LC_MESSAGES/texinfo_document.mo
%lang(pl) %{_datarootdir}/locale/pl/LC_MESSAGES/texinfo_document.mo
%lang(pt.us-ascii) %{_datarootdir}/locale/pt.us-ascii/LC_MESSAGES/texinfo_document.mo
%lang(pt_BR.us-ascii) %{_datarootdir}/locale/pt_BR.us-ascii/LC_MESSAGES/texinfo_document.mo
%changelog
*	Sun Apr 06 2014 baho-utot <baho-utot@columbus.rr.com> 5.2-1
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 5.1-1
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 5.0-1
-	Upgrade version
