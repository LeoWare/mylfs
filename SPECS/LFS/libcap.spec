Summary:	The Libcap package implements the user-space interfaces to the POSIX 1003.1e capabilities available in Linux kernels.
Name:		libcap
Version:	2.25
Release:	1
License:	GPLv2
URL:		http://www.gnu.org/software/libtool
Group:		Libraries
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/libtool/%{name}-%{version}.tar.xz
%description
The Libcap package implements the user-space interfaces to the POSIX 1003.1e capabilities available in Linux kernels. These capabilities are a partitioning of the all powerful root privilege into a set of distinct privileges.
%prep
%setup -q
sed -i '/install.*STALIBNAME/d' libcap/Makefile
%build
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} RAISE_SETFCAP=no lib=lib prefix=%{_prefix} install
chmod -v 755 %{buildroot}%{_libdir}/libcap.so
%check

%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_sbindir}/*
%{_libdir}/*
%{_includedir}/sys/*
%{_mandir}/*/*
%changelog
*	Wed Oct 03 2018 Samuel Raynor <samuel@samuelraynor.com> 2.25-1
-	Initial build.	First version	
