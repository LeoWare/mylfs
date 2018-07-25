Summary:	Ninja is a small build system with a focus on speed.
Name:		ninja
Version:	1.8.2
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:		Octothorpe
Source:		%{name}-%{version}.tar.gz
%description
	Ninja is a small build system with a focus on speed.
%prep
%setup -q -n %{NAME}-%{VERSION}
%build
	python3 configure.py --bootstrap
%install
	install -vdm 755 %{buildroot}/usr/bin/
	install -vm 644	ninja %{buildroot}/usr/bin/
	install -vDm644 misc/bash-completion %{buildroot}/usr/share/bash-completion/completions/ninja
	install -vDm644 misc/zsh-completion %{buildroot}/usr/share/zsh/site-functions/_ninja
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
%changelog
*	Wed Jul 25 2018 baho-utot <baho-utot@columbus.rr.com> 1.8.2-1
-	Initial build.	First version
