Summary:	Reading, writing, and converting info pages
Name:		texinfo
Version:	6.5
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
	--disable-static
make %{?_smp_mflags}

%install
make DESTDIR=%{buildroot} install
make DESTDIR=%{buildroot} TEXMF=%{_datarootdir}/texmf install-tex
rm -f %{buildroot}%{_infodir}/dir
find $RPM_BUILD_ROOT -name \*.la -delete

%find_lang %{name}

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%doc %{_mandir}/*/*
%doc %{_infodir}/*
%dir %{_libdir}/texinfo
%{_libdir}/texinfo/*.so
%dir %{_datarootdir}/texinfo
%{_datarootdir}/texinfo/*
%dir %{_datarootdir}/texmf
%{_datarootdir}/texmf/*
%lang(de.us-ascii) %{_datarootdir}/locale/de.us-ascii/LC_MESSAGES/texinfo_document.mo
%lang(eo) %{_datarootdir}/locale/eo/LC_MESSAGES/texinfo_document.mo
#%lang(es.us-ascii) %{_datarootdir}/locale/es.us-ascii/LC_MESSAGES/texinfo_document.mo
%lang(fr) %{_datarootdir}/locale/fr/LC_MESSAGES/texinfo_document.mo
%lang(hu) %{_datarootdir}/locale/hu/LC_MESSAGES/texinfo_document.mo
%lang(it) %{_datarootdir}/locale/it/LC_MESSAGES/texinfo_document.mo
%lang(nl) %{_datarootdir}/locale/nl/LC_MESSAGES/texinfo_document.mo
%lang(no.us-ascii) %{_datarootdir}/locale/no.us-ascii/LC_MESSAGES/texinfo_document.mo
%lang(pl) %{_datarootdir}/locale/pl/LC_MESSAGES/texinfo_document.mo
%lang(pt.us-ascii) %{_datarootdir}/locale/pt.us-ascii/LC_MESSAGES/texinfo_document.mo
%lang(pt_BR.us-ascii) %{_datarootdir}/locale/pt_BR.us-ascii/LC_MESSAGES/texinfo_document.mo
%lang(ca) %{_datarootdir}/locale/ca/LC_MESSAGES/texinfo_document.mo
%lang(cs) %{_datarootdir}/locale/cs/LC_MESSAGES/texinfo_document.mo
%lang(de) %{_datarootdir}/locale/da/LC_MESSAGES/texinfo_document.mo
%lang(de) %{_datarootdir}/locale/de/LC_MESSAGES/texinfo_document.mo
%lang(el) %{_datarootdir}/locale/el/LC_MESSAGES/texinfo_document.mo
%lang(es) %{_datarootdir}/locale/es/LC_MESSAGES/texinfo_document.mo
%lang(hr) %{_datarootdir}/locale/hr/LC_MESSAGES/texinfo_document.mo
%lang(pt) %{_datarootdir}/locale/pt/LC_MESSAGES/texinfo_document.mo
%lang(pt_BR) %{_datarootdir}/locale/pt_BR/LC_MESSAGES/texinfo_document.mo
%lang(uk) %{_datarootdir}/locale/uk/LC_MESSAGES/texinfo_document.mo
%lang(ca.us-ascii) %{_datarootdir}/locale/ca.us-ascii/LC_MESSAGES/texinfo_document.mo

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 6.5-1
-	Initial build.
