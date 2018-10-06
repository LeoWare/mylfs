%global debug_package %{nil}
#TARBALL:	http://ftp.gnu.org/gnu//ncurses/ncurses-6.1.tar.gz
#MD5SUM:	98c889aaf8d23910d2b92d65be2e737a;SOURCES/ncurses-6.1.tar.gz
#-----------------------------------------------------------------------------
Summary:	The Ncurses package contains libraries for terminal-independent handling of character screens.
Name:		tools-ncurses
Version:	6.1
Release:	1
License:	GPL
URL:		http://ftp.gnu.org/gnu/ncurses
Group:		LFS/Tools
Vendor:	Octothorpe
Source0:	http://ftp.gnu.org/gnu//ncurses/ncurses-%{version}.tar.gz
%description
The Ncurses package contains libraries for terminal-independent handling of character screens.
#-----------------------------------------------------------------------------
%prep
%setup -q -n ncurses-%{version}
	sed -i s/mawk// configure
%build
	./configure --prefix=%{_prefix} \
		--with-shared   \
		--without-debug \
		--without-ada   \
		--enable-widec  \
		--enable-overwrite
	make %{?_smp_mflags}
%install
	make DESTDIR=%{buildroot} install
	find %{buildroot}/tools -name '*.la' -delete
	rm -rf %{buildroot}%{_mandir}
	find %{buildroot} -name '*.la' -delete
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
#-----------------------------------------------------------------------------
%files -f filelist.rpm
   %defattr(-,lfs,lfs)
#-----------------------------------------------------------------------------
%changelog
*	Sun Mar 11 2018 baho-utot <baho-utot@columbus.rr.com> 6.1-1
*	Mon Jan 01 2018 baho-utot <baho-utot@columbus.rr.com> 6.0-1
-	LFS-8.1
