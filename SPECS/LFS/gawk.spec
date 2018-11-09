Summary:	Contains programs for manipulating text files
Name:		gawk
Version:	4.2.0
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/gawk
Group:		Applications/File
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/gawk/%{name}-%{version}.tar.xz

%description
The Gawk package contains programs for manipulating text files.

%prep
%setup -q
sed -i 's/extras//' Makefile.in

%build
%configure
make %{?_smp_mflags}

%install
make DESTDIR=%{buildroot} install
install -vdm 755 %{buildroot}%{_docdir}/%{name}-%{version}
cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} %{buildroot}%{_defaultdocdir}/%{name}-%{version}
rm -f %{buildroot}%{_infodir}/dir
find %{buildroot}%{_libdir} -name '*.la' -delete
%find_lang %{name}

%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}

%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig

%files -f %{name}.lang
%defattr(-,root,root)
%{_bindir}/*
%{_libdir}/%{name}/*
%{_libexecdir}/*
%{_datadir}/awk/*
%{_docdir}/%{name}-%{version}/*
%doc %{_mandir}/*/*
%doc %{_infodir}/*

%package devel
Summary: Development files for %{name}-%{version}

%description devel
Development files for %{name}-%{version}

%files devel
%{_includedir}/*

%changelog
*	Tue Oct 16 2018 Samuel Raynor <samuel@samuelraynor.com> 4.2.0-1
-	Initial build.

