#TARBALL:	http://www.greenwoodsoftware.com/less/less-530.tar.gz
#MD5SUM:	6a39bccf420c946b0fd7ffc64961315b;SOURCES/less-530.tar.gz
#-----------------------------------------------------------------------------
Summary:	The Less package contains a text file viewer.
Name:		less
Version:	530
Release:	1
License:	Other
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	http://www.greenwoodsoftware.com/less/%{name}-%{version}.tar.gz
%description
The Less package contains a text file viewer.
#-----------------------------------------------------------------------------
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--sysconfdir=/etc
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
#-----------------------------------------------------------------------------
#	Copy license/copying file
	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
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
	%{_mandir}/man1/*.gz
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 530-1
-	Initial build.	First version
