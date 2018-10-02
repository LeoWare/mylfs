#-----------------------------------------------------------------------------
# PREPKG:	popt
# URL:  	https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tar.xz
# URL:		https://docs.python.org/ftp/python/doc/2.7.14/python-2.7.14-docs-html.tar.bz2
# MD5SUM:	1f6db41ad91d9eb0a6f0c769b8613c5b	Python-2.7.14.tar.xz
# MD5SUM:	1f6db41ad91d9eb0a6f0c769b8613c5b	python-2.7.14-docs-html.tar.bz2
#-----------------------------------------------------------------------------
Summary:	The Python 2 package contains the Python development environment.
Name:		python2
Version:	2.7.14
Release:	1
License:	Any
URL:		Any
Group:		LFS/Base
Vendor:	Octothorpe
Source0:	Python-%{VERSION}.tar.xz
#Source1:	python-%%{VERSION}-docs-html.tar.bz2
BuildRequires:	popt
%description
	The Python 3 package contains the Python development environment.
	This is useful for object-oriented programming, writing scripts,
	prototyping large programs or developing entire applications.
#-----------------------------------------------------------------------------
%prep
cd %{_builddir}
%setup -q -n "Python-%{VERSION}"
#	%%setup -q -T -D -a 1  -n Python-%{VERSION}
	sed -i '/^#!.*local\//s|local/||' Lib/cgi.py Tools/pybench/pybench.py
	sed -i '/#SSL/,+3 s/^#//' Modules/Setup.dist
%build
	./configure --prefix=%{_prefix} \
            --enable-shared \
            --with-system-expat \
            --with-system-ffi \
            --with-ensurepip=yes \
            --enable-unicode=ucs4
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	chmod -v 755 %{buildroot}/usr/lib/libpython2.7.so.1.0
#	rm %%{buildroot}/usr/lib/python2.7/cgi.*
#-----------------------------------------------------------------------------
#	Copy license/copying file 
	install -D -m644 LICENSE %{buildroot}/usr/share/licenses/%{name}/LICENSE
	rm %{buildroot}/usr/bin/2to3
	rm '%{buildroot}/usr/lib/python2.7/site-packages/setuptools/command/launcher manifest.xml'
	rm "%{buildroot}/usr/lib/python2.7/site-packages/setuptools/script (dev).tmpl"
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
*	Wed Sep 26 2018 baho-utot <baho-utot@columbus.rr.com> python2-2.7.14-1
-	Initial build.	First version
