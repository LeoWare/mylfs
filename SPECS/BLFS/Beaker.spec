%define __python2 /usr/bin/python2
%define __python3 /usr/bin/python3
%{!?python2_sitelib: %define python2_sitelib %(%{__python2} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}
%{!?python3_sitelib: %define python3_sitelib %(%{__python3} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")}
Name:           Beaker-Python3
Version:        1.9.0
Release:        1%{?dist}
Summary:        Beaker is a Python module that implements caching and sessions WSGI middleware for use with web applications and stand-alone Python scripts and applications.

License:        TBD
URL:            https://www.makotemplates.org/
Source0:        https://files.pythonhosted.org/packages/source/B/Beaker/Beaker-1.9.0.tar.gz

BuildRequires:  funcsigs

%description
Beaker is a Python module that implements caching and sessions WSGI middleware for use with web applications and stand-alone Python scripts and applications.

%prep
%setup -q -n Beaker-%{version}


%build



%install
rm -rf $RPM_BUILD_ROOT
%{__python2} setup.py install --optimize=1 --prefix=%{_prefix} --root=$RPM_BUILD_ROOT

%{__python3} setup.py install --optimize=1 --prefix=%{_prefix} --root=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files

%{python3_sitelib}/*

%package -n Beaker-Python2
Summary: Beaker is a Python module that implements caching and sessions WSGI middleware for use with web applications and stand-alone Python scripts and applications.

%description -n Beaker-Python2
Beaker is a Python module that implements caching and sessions WSGI middleware for use with web applications and stand-alone Python scripts and applications.

%files -n Beaker-Python2

%{python2_sitelib}/*



%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.9.0-1
-	Initial build.