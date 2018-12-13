Name:           
Version:        
Release:        1%{?dist}
Summary:        
Vendor:			LeoWare
Distribution:	MyLFS

Group:          
License:        
URL:            
Source0:        

%description


%prep
%setup -q


%build
%configure
make %{?_smp_mflags}

%check
make check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%clean
rm -rf $RPM_BUILD_ROOT


%files


%changelog