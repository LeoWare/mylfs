Name:           fakeprovides
Version:        0.1
Release:        1%{?dist}
Summary:        Fake Provides for things I haven't packaged yet.

License:        None

Provides: pkgconfig(xproto), pkgconfig(kbproto), pkgconfig(x11)
Provides: pkgconfig(bigreqsproto), pkgconfig(compositeproto), pkgconfig(damageproto)
Provides: pkgconfig(dmxproto), pkgconfig(dri2proto), pkgconfig(dri3proto)
Provides: pkgconfig(fixesproto), pkgconfig(fontsproto), pkgconfig(glproto)
Provides: pkgconfig(inputproto), pkgconfig(presentproto), pkgconfig(randrproto)
Provides: pkgconfig(recordproto), pkgconfig(renderproto), pkgconfig(resourceproto)
Provides: pkgconfig(scrnsaverproto), pkgconfig(videoproto), pkgconfig(xmisc)
Provides: pkgconfig(xextproto), pkgconfig(xf86bigfontproto), pkgconfig(xf86dgaproto)
Provides: pkgconfig(xf86driproto), pkgconfig(xf86vidmodeproto), pkgconfig(xineramaproto)


%description
Fake Provides for things I haven't packaged yet. This shouldn't exist. I need to package everything on this list and remove its entry.

%prep


%build


%install
rm -rf $RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT


%files

%changelog
*	Fri	Dec 07 2018	Samuel Raynor <samuel@samuelraynor.com> 0.1-1
-	Initial build.