Name:           meson
Version:        0.44.0
Release:        1%{?dist}
Summary:        Meson is an open source build system meant to be both extremely fast, and, even more importantly, as user friendly as possible.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Development/Tools
License:        Apache v2
URL:            http://mesonbuild.com/
Source0:        https://github.com/mesonbuild/meson/releases/download/%{version}/%{name}-%{version}.tar.gz

%description
Meson is an open source build system meant to be both extremely fast, and, even more importantly, as user friendly as possible.

%prep
%setup -q


%build
python3 setup.py build

%install
rm -rf $RPM_BUILD_ROOT
PYTHONPATH=%{_libdir}/python3.*/site-packages python3 setup.py install --prefix=%{_prefix} --installdir=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_libdir}/lib%{name}*
%doc %{_docdir}/%{name}-%{version}/*

%changelog
*	Wed Oct 10 2018 Samuel Raynor <samuel@samuelraynor.com> 0.44.0-1
-	Initial build.
