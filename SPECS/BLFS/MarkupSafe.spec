%define __python2 /usr/bin/python2
%define __python3 /usr/bin/python3
%{!?python2_sitelib: %define python2_sitelib %(%{__python2} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")}
%{!?python3_sitelib: %define python3_sitelib %(%{__python3} -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")}
Name:           MarkupSafe-Python3
Version:        1.0
Release:        1%{?dist}
Summary:        MarkupSafe is a Python module that implements a XML/HTML/XHTML Markup safe string.

Provides:       
License:        TBD
URL:            https://www.makotemplates.org/
Source0:        https://files.pythonhosted.org/packages/source/M/MarkupSafe/MarkupSafe-1.0.tar.gz

%description
MarkupSafe is a Python module that implements a XML/HTML/XHTML Markup safe string.

%prep
%setup -q -n MarkupSafe-%{version}


%build



%install
rm -rf $RPM_BUILD_ROOT
%{__python2} setup.py build
%{__python2} setup.py install --optimize=1 --prefix=%{_prefix} --root=$RPM_BUILD_ROOT

%{__python3} setup.py build
%{__python3} setup.py install --optimize=1 --prefix=%{_prefix} --root=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files

%{python3_sitelib}/*

%package -n MarkupSafe-Python2
Summary: MarkupSafe is a Python module that implements a XML/HTML/XHTML Markup safe string.

%description -n MarkupSafe-Python2
MarkupSafe is a Python module that implements a XML/HTML/XHTML Markup safe string.

%files -n MarkupSafe-Python2

%{python2_sitelib}/*



%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.0-1
-	Initial build.