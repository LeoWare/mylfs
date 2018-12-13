%define __python2 /usr/bin/python2
%define __python3 /usr/bin/python3
%{!?python2_sitelib: %define python2_sitelib %(%{__python2} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}
%{!?python3_sitelib: %define python3_sitelib %(%{__python3} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")}
Name:           funcsigs
Version:        1.0.2
Release:        1%{?dist}
Summary:        funcsigs is a is a backport of the PEP 362 function signature features from Python 3.3's inspect module for Python 2.x.

License:        TBD
URL:            https://readthedocs.org/projects/funcsigs/
Source0:        https://files.pythonhosted.org/packages/source/f/funcsigs/funcsigs-1.0.2.tar.gz

%description
funcsigs is a is a backport of the PEP 362 function signature features from Python 3.3's inspect module for Python 2.x.

%prep
%setup -q


%build



%install
rm -rf $RPM_BUILD_ROOT
%{__python2} setup.py install --optimize=1 --prefix=%{_prefix} --root=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{python2_sitelib}/*


%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.0.2-1
-	Initial build.