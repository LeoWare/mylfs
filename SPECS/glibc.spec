Summary:		Main C library
Name:		glibc
Version:		2.27
Release:		1
License:		GPLv2
URL:			http://www.gnu.org/software/libc
Group:		LFS/Base
Vendor:		Octothorpe
BuildRequires:	man-pages
Source0:		http://ftp.gnu.org/gnu/glibc/%{name}-%{version}.tar.xz
Patch0:		glibc-2.27-fhs-1.patch
%description
This library provides the basic routines for allocating memory,
searching directories, opening and closing files, reading and
writing files, string handling, pattern matching, arithmetic,
and so on.
%define	GCC_INCDIR	/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/include
%prep
%setup -q -n %{NAME}-%{VERSION}
%patch0 -p1
	mkdir -v build
%build
	cd build
	CC='gcc -isystem %{GCC_INCDIR} -isystem /usr/include' \
	../configure --prefix=%{_prefix} \
		--disable-werror \
		--enable-kernel=3.2 \
		--enable-stack-protector=strong \
		libc_cv_slibdir=/lib
		make %{?_smp_mflags}
%install
	cd build
	touch /etc/ld.so.conf
	sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
	make install_root=%{buildroot} install
	#	Create directories
	install -vdm 755 %{buildroot}/etc
	install -vdm 755 %{buildroot}/sbin
	#	Install the configuration file and runtime directory for nscd:
	install -vDm 644 ../nscd/nscd.conf %{buildroot}/etc/nscd.conf
	install -vdm 755 %{buildroot}/var/cache/nscd
	cd -
	#	Install locale generation script and config file
	cat > %{buildroot}/etc/locale-gen.conf <<- "EOF"
		# Configuration file for locale-gen
		#
		# lists of locales that are to be generated by the locale-gen command.
		#
		# Each line is of the form:
		#
		#     <locale> <charset>
		#
		#  where <locale> is one of the locales given in /usr/share/i18n/locales
		#  and <charset> is one of the character sets listed in /usr/share/i18n/charmaps
		#
		#  Examples:
		#  en_US ISO-8859-1
		#  en_US.UTF-8 UTF-8
		#  de_DE ISO-8859-1
		#  de_DE@euro ISO-8859-15
		#
		#  The locale-gen command will generate all the locales,
		#  placing them in /usr/lib/locale.
		#
		#  A list of supported locales is included in this file.
		#  Uncomment the ones you need.
		#
		cs_CZ.UTF-8	UTF-8
		de_DE		ISO-8859-1
		de_DE@euro	ISO-8859-15
		de_DE.UTF-8	UTF-8
		en_GB.UTF-8	UTF-8
		en_HK		ISO-8859-1
		en_PH		ISO-8859-1
		en_US		ISO-8859-1
		en_US.UTF-8	UTF-8
		es_MX		ISO-8859-1
		fa_IR		UTF-8
		fr_FR		ISO-8859-1
		fr_FR@euro	ISO-8859-15
		fr_FR.UTF-8	UTF-8
		it_IT		ISO-8859-1
		it_IT.UTF-8	UTF-8
		ja_JP		EUC-JP
		ru_RU.KOI8-R	KOI8-R
		ru_RU.UTF-8	UTF-8
		tr_TR.UTF-8	UTF-8
		zh_CN.GB18030	GB18030
	EOF
	cat > %{buildroot}l <<- "EOF"
		#!/bin/sh
		set -e
		LOCALEGEN=/etc/locale-gen.conf
		LOCALES=/usr/share/i18n/locales
		if [ -n "$POSIXLY_CORRECT" ]; then
			unset POSIXLY_CORRECT
		fi
		[ -f $LOCALEGEN -a -s $LOCALEGEN ] || exit 0;
		# Remove all old locale dir and locale-archive before generating new
		# locale data.
		[ -d /usr/lib/locale ] || install -dm 755 /usr/lib/locale
		rm -rf /usr/lib/locale/* || true
		umask 022
		is_entry_ok() {
			if [ -n "$locale" -a -n "$charset" ] ; then
				true
			else
				echo "error: Bad entry '$locale $charset'"
				false
			fi
		}
		echo "Generating locales..."
		while read locale charset; do \
			case $locale in \#*) continue;; "") continue;; esac; \
			is_entry_ok || continue
			echo -n "  `echo $locale | sed 's/\([^.\@]*\).*/\1/'`"; \
			echo -n ".$charset"; \
			echo -n `echo $locale | sed 's/\([^\@]*\)\(\@.*\)*/\2/'`; \
			echo -n '...'; \
	        	if [ -f $LOCALES/$locale ]; then input=$locale; else \
		        input=`echo $locale | sed 's/\([^.]*\)[^@]*\(.*\)/\1\2/'`; fi; \
			localedef -i $input -c -f $charset -A /usr/share/locale/locale.alias $locale; \
			echo ' done'; \
		done < $LOCALEGEN
		echo "Generation complete."
	EOF
	chmod 755 %{buildroot}/sbin/locale-gen.sh
	#	Copy license/copying file
	install -D -m644 LICENSES %{buildroot}/usr/share/licenses/%{name}/LICENSE
	#	Create file list
	find %{buildroot} -name '*.la' -delete
	rm -rf %{buildroot}/usr/share/info/dir
	find "${RPM_BUILD_ROOT}" -not -type d -print > filelist.rpm
	sed -i "s|^${RPM_BUILD_ROOT}||" filelist.rpm
	sed -i '/\/usr\/share\/info/d' filelist.rpm
%files -f filelist.rpm
	%defattr(-,root,root)
	%{_infodir}/libc.*
%changelog
*	Mon Mar 19 2018 baho-utot <baho-utot@columbus.rr.com> 2.27-1
*	Wed Dec 20 2017 baho-utot <baho-utot@columbus.rr.com> 2.26-1
*	Sat Mar 22 2014 baho-utot <baho-utot@columbus.rr.com> 2.19-1
*	Sun Sep 01 2013 baho-utot <baho-utot@columbus.rr.com> 2.18-2
*	Sat Aug 24 2013 baho-utot <baho-utot@columbus.rr.com> 2.18-1
*	Sun Mar 24 2013 baho-utot <baho-utot@columbus.rr.com> 2.17-1
*	Wed Jan 30 2013 baho-utot <baho-utot@columbus.rr.com> 2.16-1
-	Initial version
