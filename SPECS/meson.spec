Summary:	Meson is an open source build system
Name:		meson
Version:	0.44.0
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source:		%{name}-%{version}.tar.gz
%description
	Meson is an open source build system meant to be both extremely fast, and, even more importantly, as user friendly as possible.

%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	python3 setup.py build
%install
	install -vdm 755 %{buildroot}/usr/lib/python3.6/site-packages/
	#	PYTHONPATH="%{buildroot}/usr/lib/python3.6/site-packages/" 	
	python3 setup.py install --root="%{buildroot}" --optimize=1 --skip-build
	#	--root="${buildroot}"--install-dir="%{buildroot}/usr/lib/python3.6/site-packages/" --optimize=1 --skip-build
	#	install -d "${pkgdir}/usr/share/vim/vimfiles"
	#	cp -rt "${builddir}/usr/share/vim/vimfiles" data/syntax-highlighting/vim/*
	#	install -Dt "${pkgdir}/usr/share/emacs/site-lisp" -m644 data/syntax-highlighting/emacs/*
	#	install -Dt "${pkgdir}/usr/share/zsh/site-functions" -m644 data/shell-completions/zsh/*
	#	Copy license/copying file 
	#	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	install -D -m644 COPYING %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	#	rm  %{buildroot}%{_infodir}/dir
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/man\/man/d' filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_mandir}/man1/*.gz
%changelog
*	Wed Jul 25 2018 baho-utot <baho-utot@columbus.rr.com> 0.44.0-1
-	Initial build.	First version