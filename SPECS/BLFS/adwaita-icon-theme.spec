Name:           adwaita-icon-theme
Version:        3.26.1
Release:        1%{?dist}
Summary:        The Adwaita Icon Theme package contains an icon theme for Gtk+ 3 applications.

License:        TBD
URL:            https://gitlab.gnome.org/GNOME/adwaita-icon-theme
Source0:        http://ftp.gnome.org/pub/gnome/sources/adwaita-icon-theme/3.26/adwaita-icon-theme-3.26.1.tar.xz

BuildRequires:  librsvg, librsvg-devel

%description
The Adwaita Icon Theme package contains an icon theme for Gtk+ 3 applications.

%prep
%setup -q


%build
%configure --enable-l-xl-variants
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files




%changelog
*	Wed Dec 12 2018 Samuel Raynor <samuel@samuelraynor.com> 3.26.1-1
-	Initial build.