Name:           lightdm
Version:        1.24
Release:        1%{?dist}
Summary:        LightDM is a display manager for X Windows.

License:        
URL:            
Source0:        
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  
Requires:       

%description
LightDM is a display manager for X Windows.

%prep
%setup -q


%build
%configure
make %{?_smp_mflags}


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
