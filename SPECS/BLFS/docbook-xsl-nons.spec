%define __xmlcatalog /usr/bin/xmlcatalog
Name:           docbook-xsl-nons
Version:        1.79.2
Release:        1%{?dist}
Summary:        The DocBook XSL Stylesheets package contains XSL stylesheets. These are useful for performing transformations on XML DocBook files.

License:        TBD
URL:            http://docbook.org/
Source0:        https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-nons-1.79.2.tar.bz2
Source1:        https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-doc-1.79.2.tar.bz2
Patch0:         http://www.linuxfromscratch.org/patches/blfs/8.2/docbook-xsl-1.79.2-stack_fix-1.patch

Provides:       docbook-xsl = %{version}

%description
The DocBook XSL Stylesheets package contains XSL stylesheets. These are useful for performing transformations on XML DocBook files.

%prep
%setup -q
%patch -P 0 -p 1
#% setup -T -D -a 1 
%{__tar} -xf $RPM_SOURCE_DIR/docbook-xsl-doc-1.79.2.tar.bz2 --strip-components=1

%build


%install
rm -rf $RPM_BUILD_ROOT

install -v -m755 -d $RPM_BUILD_ROOT/usr/share/xml/docbook/xsl-stylesheets-1.79.2

cp -v -R VERSION assembly common eclipse epub epub3 extensions fo        \
         highlighting html htmlhelp images javahelp lib manpages params  \
         profiling roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 xhtml5                                          \
         $RPM_BUILD_ROOT/usr/share/xml/docbook/xsl-stylesheets-1.79.2

ln -s VERSION $RPM_BUILD_ROOT/usr/share/xml/docbook/xsl-stylesheets-1.79.2/VERSION.xsl

install -v -m644 -D README \
                    $RPM_BUILD_ROOT/usr/share/doc/docbook-xsl-1.79.2/README.txt
install -v -m644    RELEASE-NOTES* NEWS* \
                    $RPM_BUILD_ROOT/usr/share/doc/docbook-xsl-1.79.2

cp -v -R doc/* $RPM_BUILD_ROOT/usr/share/doc/docbook-xsl-1.79.2

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_docdir}/docbook-xsl-%{version}/*
%{_datadir}/xml/docbook/xsl-stylesheets-%{version}/*

%post
if [ ! -d /etc/xml ]; then %{__install} -v -m755 -d /etc/xml; fi
if [ ! -f /etc/xml/catalog ]; then
    %{__xmlcatalog} --noout --create /etc/xml/catalog
fi

%{__xmlcatalog} --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.2" \
    /etc/xml/catalog

%{__xmlcatalog} --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.2" \
    /etc/xml/catalog

%{__xmlcatalog} --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.2" \
    /etc/xml/catalog

%{__xmlcatalog} --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-1.79.2" \
    /etc/xml/catalog

%postun

%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.79.2-1
-	Initial build.