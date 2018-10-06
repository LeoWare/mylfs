#TARBALL:	http://ftp.gnu.org/gnu/tar/tar-1.30.tar.xz
#MD5SUM:	2d01c6cd1387be98f57a0ec4e6e35826;SOURCES/tar-1.30.tar.xz
#-----------------------------------------------------------------------------
Summary:	The Tar package contains an archiving program.
Name:		tar
Version:	1.30
Release:	1
License:	GPLv3
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu/tar/%{name}-%{version}.tar.xz
%description
The Tar package contains an archiving program.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	FORCE_UNSAFE_CONFIGURE=1 \
	./configure \
		--prefix=%{_prefix} \
		--bindir=/bin
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	make -C doc DESTDIR=%{buildroot} install-html docdir=%{_docdir}/%{NAME}-%{VERSION}
	rm -rf %{buildroot}/%{_infodir}
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
#-----------------------------------------------------------------------------
#	Create file list
#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
	%defattr(-,root,root)
#	%%{_infodir}/*.gz
	%{_mandir}/man1/*.gz
	%{_mandir}/man8/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.30-1
-	Initial build.	First version
