%global debug_package %{nil}
#TARBALL:	https://downloads.sourceforge.net/tcl/tcl8.6.8-src.tar.gz
#MD5SUM:	81656d3367af032e0ae6157eff134f89;SOURCES/tcl8.6.8-src.tar.gz
#-----------------------------------------------------------------------------
Summary:	The Tcl package contains the Tool Command Language.
Name:		tools-tcl-core
Version:	8.6.8
Release:	1
License:	GPL
URL:		http://sourceforge.net/projects/tcl/files/Tcl/8.6.7
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	http://sourceforge.net/projects/tcl/files/Tcl/8.6.7/tcl%{version}-src.tar.gz
%description
The Tcl package contains the Tool Command Language.
#-----------------------------------------------------------------------------
%prep
%setup -q -n tcl%{version}
%build
	cd unix
	./configure --prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	cd unix
	make DESTDIR=%{buildroot} install
	chmod -v u+w %{buildroot}%{_libdir}/libtcl8.6.so
	make DESTDIR=%{buildroot} install-private-headers
	install -vdm 755 %{buildroot}%{_bindir}
	ln -sv tclsh8.6 %{buildroot}%{_bindir}/tclsh
	rm -rf %{buildroot}%{_mandir}
	cd -
#-----------------------------------------------------------------------------
#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
#-----------------------------------------------------------------------------
%changelog
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 8.6.8-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 8.6.7-1
-	LFS-8.1
