Summary:	Package manager
Name:		rpm
Version:	4.14.2
Release:	1
License:	GPLv2
URL:		http://rpm.org
Group:		Applications/System
Vendor:		LeoWare
Distribution:	MyLFS
Source0:	http://rpm.org/releases/rpm-4.11.x/%{name}-%{version}.tar.bz2
Source1:	http://download.oracle.com/berkeley-db/db-6.0.20.tar.gz
#Source2:	rpm.conf
%description
RPM package manager
%prep
%setup -q
%setup -q -T -D -a 1
ln -svf db-6.0.20 db
cd m4
for f in *.m4;
do
	sed -i "s/AM_PROG_MKDIR_P/AC_PROG_MKDIR_P/g" $f
done

%build
./autogen.sh --noconfigure
./configure \
	CPPFLAGS='-I/usr/include/nspr -I/usr/include/nss' \
        --program-prefix= \
        --prefix=%{_prefix} \
        --exec-prefix=%{_prefix} \
        --bindir=%{_bindir} \
        --sbindir=%{_sbindir} \
        --sysconfdir=%{_sysconfdir} \
        --datadir=%{_datadir} \
        --includedir=%{_includedir} \
        --libdir=%{_libdir} \
        --libexecdir=%{_libexecdir} \
        --localstatedir=%{_var} \
        --sharedstatedir=%{_sharedstatedir} \
        --mandir=%{_mandir} \
        --infodir=%{_infodir} \
        --disable-dependency-tracking \
       	--disable-static \
		--without-lua \
		--disable-silent-rules \
		--enable-python \
		--disable-rpath \
		--with-pic=yes \
		--with-cap \
		--with-acl \
		--without-selinux \
		--with-external-db=no \
		--with-crypto=nss

make %{?_smp_mflags}
%install
make DESTDIR=%{buildroot} install
find %{buildroot} -name '*.la' -delete
%find_lang %{name}
#	System macros and prefix
#install -dm 755 %{buildroot}%{_sysconfdir}/rpm
#install -vm644 %{_topdir}/macros %{buildroot}%{_sysconfdir}/rpm/
%post -p /sbin/ldconfig
%postun	-p /sbin/ldconfig
%clean
rm -rf %{buildroot}
%files -f %{name}.lang
%defattr(-,root,root)
#%config(noreplace) %{_sysconfdir}/rpm/macros
%{_bindir}/*
%{_includedir}/*
%{_libdir}/*
%{_mandir}/fr/man8/*
%{_mandir}/ja/man8/*
%{_mandir}/ko/man8/*
%{_mandir}/*/*
%{_mandir}/pl/man1/*
%{_mandir}/pl/man8/*
%{_mandir}/ru/man8/*
%{_mandir}/sk/man8/*

%package devel
Summary: Development files for %{name}-%{version}

%description devel
Development files for %{name}-%{version}

%files devel
%{_includedir}/*
%{_libdir}/pkgconfig/*

%changelog
*	Fri Oct 19 2018 Samuel Raynor <samuel@samuelraynor.com> 4.14.2-1
-	Initial build.
