Name:           lsb
Version:        4.1
Release:        1%{?dist}
Summary:        Lsb

License:        GPLv3
URL:            https://linuxbase.org

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


Provides: lsb = 5.0

%description
Lsb

%prep


%build


%install
rm -rf $RPM_BUILD_ROOT
install -vdm 755 $RPM_BUILD_ROOT%{_sysconfdir}/lsb-release.d
echo "" > $RPM_BUILD_ROOT%{_sysconfdir}/lsb-release.d/lsb-4.0-noarch
echo "" > $RPM_BUILD_ROOT%{_sysconfdir}/lsb-release.d/lsb-4.0-x86_64

%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_sysconfdir}/lsb-release.d/lsb-4.0-noarch
%{_sysconfdir}/lsb-release.d/lsb-4.0-x86_64

%changelog
*	Fri	Dec 07 2018	Samuel Raynor <samuel@samuelraynor.com> 4.1-1
-	Initial build.