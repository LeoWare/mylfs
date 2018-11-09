Summary:	Basic and advanced IPV4-based networking
Name:		iproute2
Version:	4.15.0
Release:	1
License:	GPLv2
URL:		http://www.kernel.org/pub/linux/utils/net/iproute2
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://www.kernel.org/pub/linux/utils/net/iproute2/%{name}-%{version}.tar.xz

%description
The IPRoute2 package contains programs for basic and advanced
IPV4-based networking.

%prep
%setup -q
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
sed -i 's/m_ipt.o//' tc/Makefile

%build
make %{?_smp_mflags}

%install
rm -rf $RFM_BUILD_ROOT
make DESTDIR=%{buildroot} \
	DOCDIR=%{_docdir}/%{name}-%{version} \
	install

%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig

%files
%defattr(-,root,root)
%{_sysconfdir}/%{name}/*
/sbin/*
%{_libdir}/*
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_mandir}/*/*
%{_datadir}/bash-completion/*

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 4.15.0-1
-	Initial build.
