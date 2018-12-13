Name:           cmake
Version:        3.10.2
Release:        1%{?dist}
Summary:        The CMake package contains a modern toolset used for generating Makefiles.

License:        TBD
URL:            https://cmake.org/
Source0:        https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz

BuildRequires:  libuv, libuv-devel curl, curl-devel, libarchive, libarchive-devel

%description
The CMake package contains a modern toolset used for generating Makefiles. It is a successor of the auto-generated configure script and aims to be platform- and compiler-independent. A significant user of CMake is KDE since version 4.

%prep
%setup -q
#sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake

%build
./bootstrap --prefix=/usr        \
            --system-libs        \
            --mandir=/share/man  \
            --no-system-jsoncpp  \
            --no-system-librhash \
            --docdir=/share/doc/cmake-3.10.2
make %{?_smp_mflags}


%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT


%clean
rm -rf $RPM_BUILD_ROOT


%files
%doc %{_docdir}/%{name}-%{version}/*
%{_datadir}/%{name}-3.10/*
%{_bindir}/*


%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_datadir}/aclocal/*


%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 3.10.2-1
-	Initial build.