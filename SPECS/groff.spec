Summary:	Programs for processing and formatting text
Name:		groff
Version:	1.22.2
Release:	1
License:	GPLv3
URL:		http://www.gnu.org/software/groff
Group:		Applications/Text
Vendor:		Bildanet
Distribution:	Octothorpe
Source:		http://ftp.gnu.org/gnu/groff/%{name}-%{version}.tar.gz
%description
The Groff package contains programs for processing
and formatting text.
%prep
%setup -q
%build
PAGE=letter ./configure \
	--prefix=%{_prefix} 
make %{?_smp_mflags}
%install
install -vdm 755 %{_defaultdocdir}/%{name}-1.22/pdf
make DESTDIR=%{buildroot} install
ln -sv eqn %{buildroot}%{_bindir}/geqn
ln -sv tbl %{buildroot}%{_bindir}/gtbl
rm -rf %{buildroot}%{_infodir}
%post	-p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%files
%defattr(-,root,root)
%{_bindir}/*
%{_libdir}/*
%{_defaultdocdir}/%{name}-%{version}/*
%{_datarootdir}/%{name}/*
%{_mandir}/*/*
%changelog
*	Wed Mar 21 2013 baho-utot <baho-utot@columbus.rr.com> 1.22.2-1
-	Upgrade version
