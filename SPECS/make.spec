Summary:	Program for compiling packages
Name:		make
Version:	4.2.1
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/make
Group:		Development/Tools
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/make/%{name}-%{version}.tar.bz2

%description
The Make package contains a program for compiling packages.

%prep
%setup -q
sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c

%build
./configure \
	--prefix=%{_prefix}
make %{?_smp_mflags}

%install
rm -rf $RPM_BUILD_ROOT
make DESTDIR=%{buildroot} install
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}

%check
make PERL5LIB=$PWD/tests/ -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%doc %{_mandir}/*/*

%package devel
Summary: Development files for %{name}-%{version}.

%description devel
Development files for %{name}-%{version}.

%files devel
%{_includedir}/gnumake.h

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 4.2.1-1
-	Initial build.
