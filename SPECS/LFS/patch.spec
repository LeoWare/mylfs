Summary:	Program for modifying or creating files
Name:		patch
Version:	2.7.6
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/%{name}
Source:		ftp://ftp.gnu.org/gnu/patch/%{name}-%{version}.tar.xz
Group:		Development/Tools
Vendor:		LeoWare
Distribution:	MyLFS

%description
Program for modifying or creating files by applying a patch
file typically created by the diff program.

%prep
%setup -q

%build
./configure \
	--prefix=%{_prefix}
make %{?_smp_mflags}
%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} install

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%files
%defattr(-,root,root)
%{_bindir}/*
%doc %{_mandir}/*/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 2.7.6-1
-	Initial build.
