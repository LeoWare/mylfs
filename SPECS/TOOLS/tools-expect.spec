Summary:	The Expect package contains a program for carrying out scripted dialogues with other interactive programs. 		
Name:		tools-expect
Version:	5.45
Release:	1
License:	GPL
URL:		http://prdownloads.sourceforge.net/expect
Group:		LFS/Tools
Vendor:		Octothorpe
Distribution:	LFS-8.1
ExclusiveArch:	x86_64
Source0:	http://prdownloads.sourceforge.net/expect/expect%{version}.tar.gz
%description
	The Expect package contains a program for carrying out scripted dialogues with other interactive programs. 
%prep
%setup -q -n expect%{version}
%build
	cp -v configure{,.orig}
	sed 's:/usr/local/bin:/bin:' configure.orig > configure
	./configure --prefix=%{_prefix} \
		--with-tcl=/tools/lib \
		--with-tclinclude=/tools/include
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} SCRIPTS="" install
	rm -rf %{buildroot}/tools/man
	find %{buildroot}/tools -name '*.la' -delete
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
%changelog
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 5.45-1
-	LFS-8.1