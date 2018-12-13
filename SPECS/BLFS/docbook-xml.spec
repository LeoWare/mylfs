%define __xmlcatalog /usr/bin/xmlcatalog
Name:           docbook-xml
Version:        4.5
Release:        1%{?dist}
Summary:        The DocBook XML DTD-4.5 package contains document type definitions for verification of XML data files against the DocBook rule set.

License:        TBD
URL:            http://www.docbook.org/
Source0:        http://www.docbook.org/xml/4.5/%{name}-%{version}.zip

BuildRequires:  libxml2, sgml-common, unzip    

%description
The DocBook XML DTD-4.5 package contains document type definitions for verification of XML data files against the DocBook rule set. These are useful for structuring books and software documentation to a standard allowing you to utilize transformations already written for that standard.

%prep
%setup -q -c %{name}-%{version}


%build



%install
rm -rf $RPM_BUILD_ROOT

install -v -d -m755 $RPM_BUILD_ROOT/usr/share/xml/docbook/xml-dtd-%{version}
install -v -d -m755 $RPM_BUILD_ROOT/etc/xml
chown -R root:root .
cp -v -af docbook.cat *.dtd ent/ *.mod $RPM_BUILD_ROOT/usr/share/xml/docbook/xml-dtd-%{version}

%files
%{_datadir}/xml/docbook/*

%post
if [ ! -e /etc/xml/docbook ]; then
    %{__xmlcatalog} --noout --create /etc/xml/docbook
fi &&
%{__xmlcatalog} --noout --add "public" \
    "-//OASIS//DTD DocBook XML V4.5//EN" \
    "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
    /etc/xml/docbook &&
%{__xmlcatalog} --noout --add "public" \
    "-//OASIS//DTD DocBook XML CALS Table Model V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/calstblx.dtd" \
    /etc/xml/docbook &&
%{__xmlcatalog} --noout --add "public" \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/soextblx.dtd" \
    /etc/xml/docbook &&
%{__xmlcatalog} --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Information Pool V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbpoolx.mod" \
    /etc/xml/docbook &&
%{__xmlcatalog} --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbhierx.mod" \
    /etc/xml/docbook &&
%{__xmlcatalog} --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML HTML Tables V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/htmltblx.mod" \
    /etc/xml/docbook &&
%{__xmlcatalog} --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Notations V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbnotnx.mod" \
    /etc/xml/docbook &&
%{__xmlcatalog} --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Character Entities V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbcentx.mod" \
    /etc/xml/docbook &&
%{__xmlcatalog} --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Additional General Entities V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbgenent.mod" \
    /etc/xml/docbook &&
%{__xmlcatalog} --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook &&
%{__xmlcatalog} --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook

if [ ! -e /etc/xml/catalog ]; then
    %{__xmlcatalog} --noout --create /etc/xml/catalog
fi &&
%{__xmlcatalog} --noout --add "delegatePublic" \
    "-//OASIS//ENTITIES DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
%{__xmlcatalog} --noout --add "delegatePublic" \
    "-//OASIS//DTD DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
%{__xmlcatalog} --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
%{__xmlcatalog} --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog

for DTDVERSION in 4.1.2 4.2 4.3 4.4
do
  %{__xmlcatalog} --noout --add "public" \
    "-//OASIS//DTD DocBook XML V$DTDVERSION//EN" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/docbookx.dtd" \
    /etc/xml/docbook
  %{__xmlcatalog} --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
  %{__xmlcatalog} --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
  %{__xmlcatalog} --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
  %{__xmlcatalog} --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
done

%postun


%clean
rm -rf $RPM_BUILD_ROOT


%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 4.5-1
-	Initial build.