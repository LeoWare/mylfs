Summary:	The Texinfo package contains programs for reading, writing, and converting info pages.
Name:		texinfo
Version:	6.5
Release:	1
License:	GPLv3
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Requires:	tar
Source0:	http://ftp.gnu.org/gnu/texinfo/%{name}-%{version}.tar.xz
%description
	The Texinfo package contains programs for reading, writing, and converting info pages.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	./configure \
		--prefix=%{_prefix} \
		--disable-static
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	make DESTDIR=%{buildroot} TEXMF=/usr/share/texmf install-tex
	rm -rf %{buildroot}/usr/share/info/dir
	#	Copy license/copying file
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man/d' filelist.rpm
%post
	pushd /usr/share/info
	rm -v dir
	for f in *
		do install-info $f dir 2>/dev/null
	done
	popd
%files -f filelist.rpm
	%defattr(-,root,root)
%changelog
*	Tue Jan 09 2018 baho-utot <baho-utot@columbus.rr.com> 6.5-1
-	Initial build.	First version
