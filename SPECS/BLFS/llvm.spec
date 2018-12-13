Name:           llvm
Version:        5.0.1
Release:        1%{?dist}
Summary:        The LLVM package contains a collection of modular and reusable compiler and toolchain technologies.

License:        TBD
URL:            http://llvm.org/
Source0:        http://llvm.org/releases/5.0.1/%{name}-%{version}.src.tar.xz
Source1:        http://llvm.org/releases/5.0.1/cfe-%{version}.src.tar.xz
Source2:        http://llvm.org/releases/5.0.1/compiler-rt-%{version}.src.tar.xz

BuildRequires:  cmake, cmake-devel, Python2

%description
The LLVM package contains a collection of modular and reusable compiler and toolchain technologies. The Low Level Virtual Machine (LLVM) Core libraries provide a modern source and target-independent optimizer, along with code generation support for many popular CPUs (as well as some less common ones!). These libraries are built around a well specified code representation known as the LLVM intermediate representation ("LLVM IR").

%prep
%setup -q -n %{name}-%{version}.src
%setup -T -D -a 1 -n %{name}-%{version}.src/tools
%setup -T -D -a 2 -n %{name}-%{version}.src/projects
%setup -T -D -n %{name}-%{version}.src

mv tools/cfe-%{version}.src tools/clang
mv projects/compiler-rt-%{version}.src projects/compiler-rt

%build
mkdir -v build
cd       build

CC=gcc CXX=g++                              \
cmake -DCMAKE_INSTALL_PREFIX=/usr           \
      -DLLVM_ENABLE_FFI=ON                  \
      -DCMAKE_BUILD_TYPE=Release            \
      -DLLVM_BUILD_LLVM_DYLIB=ON            \
      -DLLVM_TARGETS_TO_BUILD="host;AMDGPU" \
      -DLLVM_LIBDIR_SUFFIX=64 \
      -Wno-dev ..
make %{?_smp_mflags}

cmake -DLLVM_ENABLE_SPHINX=ON         \
      -DSPHINX_WARNINGS_AS_ERRORS=OFF \
      -Wno-dev ..
make docs-llvm-html  docs-llvm-man

make docs-clang-html docs-clang-man



%install
rm -rf $RPM_BUILD_ROOT
cd build
make install DESTDIR=$RPM_BUILD_ROOT

install -v -m644 docs/man/* $RPM_BUILD_ROOT/usr/share/man/man1
install -v -d -m755 $RPM_BUILD_ROOT/usr/share/doc/llvm-5.0.1/llvm-html
cp -Rv docs/html/* $RPM_BUILD_ROOT/usr/share/doc/llvm-5.0.1/llvm-html

install -v -m644 tools/clang/docs/man/* $RPM_BUILD_ROOT/usr/share/man/man1
install -v -d -m755 $RPM_BUILD_ROOT/usr/share/doc/llvm-5.0.1/clang-html
cp -Rv tools/clang/docs/html/* $RPM_BUILD_ROOT/usr/share/doc/llvm-5.0.1/clang-html

find $RPM_BUILD_ROOT -name "*.la" -delete


%clean
rm -rf $RPM_BUILD_ROOT


%files
%{_bindir}/*
%{_libdir}/*.so*
%{_libdir}/*.a
%{_libdir}/clang/*
%{_libdir}/cmake/*
%{_libexecdir}/*
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_mandir}/*/*
%{_datadir}/clang/*
%{_datadir}/scan-build/*
%{_datadir}/scan-view/*
%{_datadir}/opt-viewer/*


%post -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*


%changelog
*	Mon Dec 10 2018 Samuel Raynor <samuel@samuelraynor.com> 5.0.1-1
-	Initial build.