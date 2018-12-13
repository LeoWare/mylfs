Name:           asciidoc
Version:        8.6.9
Release:        1%{?dist}
Summary:        he Asciidoc package is a text document format for writing notes, documentation, articles, books, ebooks, slideshows, web pages, man pages and blogs. 
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/System
License:        GPLv2
URL:            http://asciidoc.org
Source0:        https://downloads.sourceforge.net/asciidoc/asciidoc-8.6.9.tar.gz

%description
The Asciidoc package is a text document format for writing notes, documentation, articles, books, ebooks, slideshows, web pages, man pages and blogs. AsciiDoc files can be translated to many formats including HTML, PDF, EPUB, and man page.

%prep
%setup -q


%build
%configure --docdir=/usr/share/doc/%{name}-%{version}
make %{?_smp_mflags}

%check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
make docs DESTDIR=$RPM_BUILD_ROOT
#%find_lang %{name}

%clean
rm -rf $RPM_BUILD_ROOT


%files
%dir %{_sysconfdir}/asciidoc
%{_sysconfdir}/asciidoc/*
%{_bindir}/*
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_mandir}/*/*

%changelog
*	Wed Nov 14 2018 Samuel Raynor <samuel@samuelraynor.com> 8.6.9-1
-	Initial build.