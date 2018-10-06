#TARBALL:	http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.5.0.tar.gz
#MD5SUM:	b7437a5020190cfa84f09c412db38902;SOURCES/libpipeline-1.5.0.tar.gz
#-----------------------------------------------------------------------------
Summary:	The Libpipeline package contains a library for manipulating pipelines of subprocesses in a flexible and convenient way.
Name:		libpipeline
Version:	1.5.0
Release:	1
License:	GPLv3
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://download.savannah.gnu.org/releases/libpipeline/%{name}-%{version}.tar.gz
%description
The Libpipeline package contains a library for manipulating pipelines of subprocesses in a flexible and convenient way.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	PKG_CONFIG_PATH=/tools/lib/pkgconfig \
	./configure \
		--prefix=%{_prefix}
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
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
	%{_mandir}/man3/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.5.0-1
-	Initial build.	First version
