#TARBALL:	https://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.bz2
#MD5SUM:	93eea9f07c0058c097891c73e4955456;SOURCES/cpio-2.12.tar.bz2
#-----------------------------------------------------------------------------
Summary:	The cpio package contains tools for archiving
Name:		cpio
Version:	2.12
Release:	1
License:	GPLv3
URL:		Any
Group:		BLFS/System_Utilities 
Vendor:	Octothorpe
Source0:	https://ftp.gnu.org/gnu/cpio/%{name}-%{version}.tar.bz2
%description
The cpio package contains tools for archiving
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--bindir=/bin \
		--enable-mt \
		--with-rmt=/usr/libexec/rmt
	make %{?_smp_mflags}
	makeinfo --html            -o doc/html      doc/cpio.texi
	makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi
	makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi
%install
	make DESTDIR=%{buildroot} install
#-----------------------------------------------------------------------------
#	Copy license/copying file
#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
#-----------------------------------------------------------------------------
%post
	pushd /usr/share/info
	rm -v dir
	for f in *; do install-info $f dir 2>/dev/null; done
	popd
%postun
	pushd /usr/share/info
	rm -v dir
	for f in *; do install-info $f dir 2>/dev/null; done
	popd
#-----------------------------------------------------------------------------
%changelog
*	Wed Feb 14 2018 baho-utot <baho-utot@columbus.rr.com> cpio-2.12-1
-	Initial build.	First version
