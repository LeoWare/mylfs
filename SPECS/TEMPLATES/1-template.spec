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

BuildRequires:  
Requires:       

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


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{!?_licensedir:%global license %%doc}
%license add-license-file-here
%doc add-docs-here



%changelog
