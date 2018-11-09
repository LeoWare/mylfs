Name:           expat
Version:        2.2.5
Release:        1%{?dist}
Summary:        The Expat package contains a stream oriented C library for parsing XML.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/System
License:        None
URL:            https://github.com/libexpat/libexpat.git
Source0:        https://github.com/libexpat/libexpat/releases/download/R_2_2_5/%{name}-%{version}.tar.bz2

%description
The Expat package contains a stream oriented C library for parsing XML.

%prep
%setup -q
sed -i 's|usr/bin/env |bin/|' run.sh.in

%build
%configure --disable-static
make %{?_smp_mflags}

%check
make check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
install -v -dm755 $RPM_BUILD_ROOT%{_defaultdocdir}/%{name}-%{version}/%{name}-%{version}
install -v -m644 doc/*.{html,png,css} $RPM_BUILD_ROOT%{_defaultdocdir}/%{name}-%{version}
mv -v $RPM_BUILD_ROOT/usr/share/doc/expat/* $RPM_BUILD_ROOT%{_defaultdocdir}/%{name}-%{version

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{!?_licensedir:%global license %%doc}
%{_bindir}/*
%{_includedir}/*
%{_libdir}/*
%{_defaultdocdir}/*
%{_mandir}/*/*


%changelog
