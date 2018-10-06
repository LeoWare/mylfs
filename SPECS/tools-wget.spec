#TARBALL:	https://ftp.gnu.org/gnu/wget/wget-1.19.1.tar.xz
#MD5SUM:	d30d82186b93fcabb4116ff513bfa9bd;SOURCES/wget-1.19.1.tar.xz
%define	_optflags -march=x86-64 -mtune=generic -O2 -pipe -fPIC -Wl,--no-as-needed -ldl
#-----------------------------------------------------------------------------
Summary:	The Wget package contains a utility useful for non-interactive downloading of files from the Web. 
Name:		tools-wget
Version:	1.19.1
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	wget-%{version}.tar.xz
%description
The Wget package contains a utility useful for non-interactive downloading of files from the Web. 
#-----------------------------------------------------------------------------
%prep
%setup -q -n wget-%{VERSION}
%build
	  CFLAGS='%_optflags ' \
	CXXFLAGS='%_optflags ' \
	./configure \
		--prefix=%{_prefix} \
		--sysconfdir=%{_prefix}/etc \
		--disable-threads \
		--with-ssl=openssl
#		--disable-opie \
#		--disable-digest \
#		--disable-ntlm \
#		--with-ssl=openssl
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
#-----------------------------------------------------------------------------
#	Copy license/copying file 
#	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	rm -rf %{buildroot}%{_infodir}
	rm -rf %{buildroot}%{_mandir}
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
#	%%{_infodir}/*.gz
#	%%{_mandir}/man1/*.gz
%post
%postun
#-----------------------------------------------------------------------------
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 1.19.1-1
-	Initial build.	First version
