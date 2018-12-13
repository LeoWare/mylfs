%define __install_catalog %{_bindir}/install-catalog
Name:           sgml-common
Version:        0.6.3
Release:        1%{?dist}
Summary:        The SGML Common package contains install-catalog. This is useful for creating and maintaining centralized SGML catalogs.

License:        TBD
URL:            https://docbook.org/tools/
Source0:        https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/%{name}-%{version}.tgz
Patch0:         http://www.linuxfromscratch.org/patches/blfs/8.2/%{name}-%{version}-manpage-1.patch

BuildRequires:  autoconf

%description
The SGML Common package contains install-catalog. This is useful for creating and maintaining centralized SGML catalogs.

%prep
%setup -q
%patch -P 0 -p 1
autoreconf -f -i

%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT

make DESTDIR=$RPM_BUILD_ROOT docdir=/usr/share/doc install


%post
%{__install_catalog} --add /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog

%{__install_catalog} --add /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat

%preun
%{__install_catalog} --remove /etc/sgml/sgml-ent.cat \
    /usr/share/sgml/sgml-iso-entities-8879.1986/catalog

%{__install_catalog} --remove /etc/sgml/sgml-docbook.cat \
    /etc/sgml/sgml-ent.cat

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_sysconfdir}/sgml/*
%{_bindir}/*
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_mandir}/*/*
%{_datadir}/sgml/*

%changelog
*	Sun Dec 09 2018 Samuel Raynor <samuel@samuelraynor.com> 0.6.3-1
-	Initial build.