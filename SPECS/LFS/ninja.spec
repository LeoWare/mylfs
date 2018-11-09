Name:           ninja
Version:        1.8.2
Release:        1%{?dist}
Summary:        Ninja is a small build system with a focus on speed.
Vendor:			LeoWare
Distribution:	MyLFS

Group:          Development/Tools
License:        Apache v2
URL:            https://ninja-build.org/
Source0:        https://github.com/ninja-build/ninja/archive/v%{version}/%{name}-%{version}.tar.gz
Patch0:			http://www.linuxfromscratch.org/patches/lfs/8.2/%{name}-%{version}-add_NINJAJOBS_var-1.patch

%description
Ninja is a small build system with a focus on speed.

%prep
%setup -q
%{__patch} -Np1 -i %{_sourcedir}/%{name}-%{version}-add_NINJAJOBS_var-1.patch

%build
python3 configure.py --bootstrap

%check
python3 configure.py
./ninja ninja_test
./ninja_test --gtest_filter=-SubprocessTest.SetWithLots

%install
rm -rf $RPM_BUILD_ROOT
install -vdm755 $RPM_BUILD_ROOT%{_bindir}
install -vm755 ninja $RPM_BUILD_ROOT%{_bindir}/
install -vDm644 misc/bash-completion $RPM_BUILD_ROOT%{_datadir}/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  $RPM_BUILD_ROOT%{_datadir}/zsh/site-functions/_ninja

%clean
rm -rf $RPM_BUILD_ROOT

%files
%{_bindir}/%{name}
%{_datadir}/bash-completion/completions/%{name}
%{_datadir}/zsh/site-functions/_%{name}

%changelog
*	Wed Oct 10 2018 Samuel Raynor <samuel@samuelraynor.com> 1.8.2-1
-	Initial build.
