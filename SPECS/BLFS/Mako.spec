%define __python2 /usr/bin/python2
%define __python3 /usr/bin/python3
%{!?python2_sitelib: %define python2_sitelib %(%{__python2} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}
%{!?python3_sitelib: %define python3_sitelib %(%{__python3} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")}
Name:           Mako-Python3
Version:        1.0.4
Release:        1%{?dist}
Summary:        Mako is a Python module that implements hyperfast and lightweight templating for the Python platform.

License:        TBD
URL:            https://www.makotemplates.org/
Source0:        https://files.pythonhosted.org/packages/source/M/Mako/Mako-1.0.4.tar.gz

BuildRequires:  Beaker-Python3, MarkupSafe-Python3

%description
Mako is a Python module that implements hyperfast and lightweight templating for the Python platform.

%prep
%setup -q -n Mako-%{version}


%build



%install
rm -rf $RPM_BUILD_ROOT
%{__python2} setup.py install --optimize=1 --prefix=%{_prefix} --root=$RPM_BUILD_ROOT

sed -i "s:mako-render:&3:g" setup.py
%{__python3} setup.py install --optimize=1 --prefix=%{_prefix} --root=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/mako-render3
%{python3_sitelib}/*

%package -n Mako-Python2
Summary: Mako is a Python module that implements hyperfast and lightweight templating for the Python platform.
BuildRequires:  Beaker-Python2, MarkupSafe-Python2

%description -n Mako-Python2
Mako is a Python module that implements hyperfast and lightweight templating for the Python platform.

%files -n Mako-Python2
%{_bindir}/mako-render
%{python2_sitelib}/*



%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.0.4-1
-	Initial build.