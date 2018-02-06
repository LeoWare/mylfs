Summary:	The Tcl package contains the Tool Command Language.	
Name:		tools-tcl-core
Version:	8.6.7
Release:	1
License:	GPL
URL:		http://sourceforge.net/projects/tcl/files/Tcl/8.6.7
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	http://sourceforge.net/projects/tcl/files/Tcl/8.6.7/tcl-core%{version}-src.tar.gz
%description
	The Tcl package contains the Tool Command Language.
%prep
%setup -q -n tcl%{version}
%build
	cd unix
	./configure --prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	cd unix
	make DESTDIR=%{buildroot} install
	chmod -v u+w %{buildroot}/tools/lib/libtcl8.6.so
	make DESTDIR=%{buildroot} install-private-headers
	install -vdm 755 %{buildroot}/tools/bin
	ln -sv tclsh8.6 %{buildroot}/tools/bin/tclsh
	rm -rf %{buildroot}/tools/man
	cd -
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 8.6.7-1
-	LFS-8.1