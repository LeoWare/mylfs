Summary:	The Less package contains a text file viewer
Name:		less
Version:	530
Release:	1
License:	GPLv3
URL:		http://www.greenwoodsoftware.com/less
Group:		Applications/File
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://www.greenwoodsoftware.com/less/%{name}-%{version}.tar.gz

%description
The Less package contains a text file viewer

%prep
%setup -q

%build
rm -rf $RPM_BUILD_ROOT
%configure --sysconfdir=%{_sysconfdir}
make %{?_smp_mflags}

%install
make DESTDIR=%{buildroot} install

%files
%defattr(-,root,root)
%{_bindir}/*
%{_mandir}/*/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 530-1
-	Initial build.
