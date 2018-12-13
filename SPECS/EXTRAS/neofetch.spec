Name:           neofetch
Version:        5.0.0
Release:        1%{?dist}
Summary:        A command-line system information tool written in bash 3.2+

License:        MIT
URL:            https://github.com/dylanaraps/neofetch/wiki
Source0:        https://github.com/dylanaraps/neofetch/archive/5.0.0.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

%description
A command-line system information tool written in bash 3.2+

%prep
%setup -q


%build


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/%{name}
%doc %{_mandir}/*/*


%changelog
*	Wed Dec 12 2018 Samuel Raynor <samuel@samuelraynor.com> 2.36.11-1
-	Initial build.