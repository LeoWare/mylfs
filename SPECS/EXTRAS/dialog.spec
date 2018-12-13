Name:           dialog
Version:        1.3
Release:        1%{?dist}
Summary:        Dialog is a console dialog user interface utility.

License:        GPLv2
URL:            https://invisible-island.net/dialog/
Source0:        https://invisible-island.net/datafiles/release/dialog.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

BuildRequires:  ncurses

%description
Dialog is a console dialog user interface utility.

%prep
%setup -q -n %{name}-%{version}-20181107


%build
%configure
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/libdialog.a
%{_mandir}/*/*


%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.3-1
-	Initial build.