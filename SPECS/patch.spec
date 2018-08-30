Summary:	Program for modifying or creating files
Name:		patch
Version:	2.7.1
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/%{name}
Source:		ftp://ftp.gnu.org/gnu/patch/%{name}-%{version}.tar.xz
Group:		Development/Tools
Vendor:		Bildanet
Distribution:	Octothorpe
%description
Program for modifying or creating files by applying a patch
file typically created by the diff program.
%prep
%setup -q
%build
./configure \
	--prefix=%{_prefix} \
	--disable-silent-rules
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%files
%defattr(-,root,root)
%{_bindir}/*
%{_mandir}/*/*
%changelog
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 2.7.1-1
-	Upgrade version
