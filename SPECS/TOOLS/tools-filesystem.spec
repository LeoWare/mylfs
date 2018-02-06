Summary:	tools chain filesystem	
Name:		tools-filesystem
Version:	8.1	
Release:	1
License:	MIT
URL:		http://www.linuxfromscratch.org
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
BuildArch:	noarch
%description
	tools chain filesystem
%prep
%install
	install -vdm 755 %{buildroot}/tools/etc
	install -vdm 755 %{buildroot}/tools/bin
	install -vdm 755 %{buildroot}/tools/include
	install -vdm 755 %{buildroot}/tools/lib
	install -vdm 755 %{buildroot}/tools/libexec
	install -vdm 755 %{buildroot}/tools/sbin
	install -vdm 755 %{buildroot}/tools/share
	install -vdm 755 %{buildroot}/tools/var
	install -vdm 755 %{buildroot}/tools/lib/pkgconfig
	ln -vsf /tools/lib %{buildroot}/tools/lib64
%post
%postun
%files
	%defattr(-,lfs,lfs)
	/tools/var
	/tools/etc
	/tools/bin
	/tools/sbin
	/tools/lib
	/tools/lib/pkgconfig
	/tools/libexec
	/tools/share
	/tools/include
	/tools/lib64
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> -1
-	LFS-8.1
