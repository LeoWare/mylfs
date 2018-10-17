Summary:	Archiving program
Name:		tar
Version:	1.30
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/tar
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source0:	tar/%{name}-%{version}.tar.xz

%description
Contains GNU archiving program

%prep
%setup -q

%build
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=%{_prefix} \
            --bindir=/bin
make %{?_smp_mflags}

%install
make DESTDIR=%{buildroot} install
make DESTDIR=%{buildroot} -C doc install-html docdir=%{_docdir}/%{name}-%{version}
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%files -f %{name}.lang
%defattr(-,root,root)
/bin/tar
%{_libexecdir}/rmt
%doc %{_docdir}/%{name}-%{version}/*
%doc %{_mandir}/*/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 1.30-1
-	Initial build.
