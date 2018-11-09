Summary:	Library for manipulating pipelines
Name:		libpipeline
Version:	1.5.0
Release:	1
License:	GPLv3
URL:		http://libpipeline.nongnu.org
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source:		 http://download.savannah.gnu.org/releases/libpipeline/%{name}-%{version}.tar.gz

%description
Contains a library for manipulating pipelines of subprocesses
in a flexible and convenient way.

%prep
%setup -q
sed -i -e '/gets is a/d' gnulib/lib/stdio.in.h

%build
./configure \
	--prefix=%{_prefix}
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} install
find %{buildroot}%{_libdir} -name '*.la' -delete

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig

%files
%defattr(-,root,root)
%{_includedir}/*
%{_libdir}/*.so
%{_libdir}/*.so.*
%{_libdir}/pkgconfig/libpipeline.pc
%{_mandir}/*/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 1.5.0-1
-	Initial build.

