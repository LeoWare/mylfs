Summary:	Stream editor
Name:		sed
Version:	4.4
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/sed
Group:		Applications/Editors
Vendor:		LeoWare
Distribution:	MyLFS
Source:		http://ftp.gnu.org/gnu/sed/%{name}-%{version}.tar.xz
%description
The Sed package contains a stream editor.
%prep
%setup -q
sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in
%build
./configure \
	--prefix=%{_prefix} \
	--bindir=/bin
make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
rm -rf %{buildroot}%{_infodir}
%find_lang %{name}
%check
make -k check |& tee %{_specdir}/%{name}-check-log || %{nocheck}
%files -f %{name}.lang
%defattr(-,root,root)
/bin/*
%{_mandir}/man1/*
%changelog
*   Wed Oct 03 2018 Samuel Raynor <samuel@samuelraynor.com> 4.4-1
-	Initial build.
