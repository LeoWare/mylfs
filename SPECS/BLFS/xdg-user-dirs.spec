Name:           xdg-user-dirs
Version:        0.16
Release:        1%{?dist}
Summary:        Xdg-user-dirs is a tool to help manage “well known” user directories like the desktop folder and the music folder. It also handles localization (i.e. translation) of the filenames.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Applications/System
License:        GPLv2
URL:            https://www.freedesktop.org/wiki/Software/xdg-user-dirs/
Source0:        https://user-dirs.freedesktop.org/releases/xdg-user-dirs-0.16.tar.gz

%description
Xdg-user-dirs is a tool to help manage “well known” user directories like the desktop folder and the music folder. It also handles localization (i.e. translation) of the filenames.

%prep
%setup -q


%build
./configure --prefix=/usr --sysconfdir=/etc
make %{?_smp_mflags}

%check

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT
%find_lang %{name}

%clean
rm -rf $RPM_BUILD_ROOT


%files -f %{name}.lang
%{_bindir}/xdg-user-dir
%{_bindir}/xdg-user-dirs-update
%{_sysconfdir}/xdg/autostart/*
%{_sysconfdir}/xdg/*
%{_mandir}/*/*

%changelog
*	Wed Nov 14 2018 Samuel Raynor <samuel@samuelraynor.com> 0.16-1
-	Initial build.