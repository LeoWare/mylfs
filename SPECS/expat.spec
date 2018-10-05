Name:           expat
Version:        2.2.5
Release:        1%{?dist}
Summary:        The Expat package contains a stream oriented C library for parsing XML.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/System
License:        
URL:            
Source0:        

BuildRequires:  
Requires:       

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

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{!?_licensedir:%global license %%doc}
%license COPYING



%changelog
