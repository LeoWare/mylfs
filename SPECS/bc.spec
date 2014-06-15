Summary:	precision numeric processing language
Name:		bc
Version:	1.06.95
Release:	1
License:	GPLv2
URL:		http://alpha.gnu.org/gnu/bc/
Group:		LFS
Vendor:		Bildanet
Distribution:	Octothorpe
Source0:	http://alpha.gnu.org/gnu/bc/%{name}-%{version}.tar.bz2
%description
The Bc package contains an arbitrary precision numeric processing language.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--with-readline \
	--mandir=%{_mandir} \
	--infodir=%{_infodir} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}/%{_mandir}
rm -rf %{buildroot}%{_infodir}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%post
/sbin/ldconfig
%files
%defattr(-,root,root)
%{_bindir}/*
%{_mandir}/*/*
%changelog
*	Fri May 10 2013 baho-utot <baho-utot@columbus.rr.com> 1.06.95-1
-	initial version