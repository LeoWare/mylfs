#!/tools/bin/bash
set -o errexit
set -o nounset
set +h
source ./config.inc
source ./function.inc

LIST="linux-api-headers man-pages glibc tzdata "
LIST+="adjust-tool-chain zlib file "
LIST+="readline m4 bc binutils gmp mpfr mpc gcc test-gcc "
LIST+="bzip2 pkg-config ncurses attr acl libcap sed shadow psmisc iana-etc bison "
#LIST+="flex grep bash libtool gdbm gperf expat inetutils perl perl-xml-parser "
#LIST+="intltool autoconf automake xz kmod gettext systemd procps-ng e2fsprogs "
#LIST+="coreutils diffutils gawk findutils groff grub less gzip iproute2 kbd "
#LIST+="libpipeline make patch dbus util-linux man-db tar texinfo vim "
#	The following packages comprise the package management system RPM
#LIST+="elfutils nspr nss popt lua rpm " # chapter-config
for i in ${LIST}; do
	RPMPKG=""
	case ${i} in
		adjust-tool-chain) 
			[ -e LOGS/adjust-tool-chain.log ] || {	> LOGS/adjust-tool-chain.log
				build "mv -v /tools/bin/{ld,ld-old}" "mv -v /tools/bin/{ld,ld-old}" "LOGS/adjust-tool-chain.log"
				build "mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}" "mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}" "LOGS/adjust-tool-chain.log"
				build "mv -v /tools/bin/{ld-new,ld}" "mv -v /tools/bin/{ld-new,ld}" "LOGS/adjust-tool-chain.log"
				build "ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld" "ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld" "LOGS/adjust-tool-chain.log"
				gcc -dumpspecs | sed -e 's@/tools@@g' -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
					-e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > `dirname $(gcc --print-libgcc-file-name)`/specs
				build "echo 'main(){}' > dummy.c" "echo 'main(){}' > dummy.c" "LOGS/adjust-tool-chain.log"
				build "cc dummy.c -v -Wl,--verbose &> dummy.log" "cc dummy.c -v -Wl,--verbose &> dummy.log" "LOGS/adjust-tool-chain.log"
				build "readelf -l a.out | grep ': /lib'" "readelf -l a.out | grep ': /lib'" "LOGS/adjust-tool-chain.log"
				build "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "LOGS/adjust-tool-chain.log"
				build "grep -B1 '^ /usr/include' dummy.log" "grep -B1 '^ /usr/include' dummy.log" "LOGS/adjust-tool-chain.log"
				build "grep 'SEARCH.*' dummy.log |sed 's|; |\n|g'" "grep 'SEARCH.*' dummy.log |sed 's|; |\n|g'" "LOGS/adjust-tool-chain.log"
				build 'grep "/lib.*/libc.so.6 " dummy.log' 'grep "/lib.*/libc.so.6 " dummy.log' "LOGS/adjust-tool-chain.log"
				build "grep found dummy.log" "grep found dummy.log" "LOGS/adjust-tool-chain.log"
				build "rm -v dummy.c a.out dummy.log" "rm -v dummy.c a.out dummy.log" "LOGS/adjust-tool-chain.log"
			};
		;;
		chapter-config) chapter-config ;;
		test-gcc)	[ -e "LOGS/gcc-test.log" ] || {
					> "LOGS/gcc-test.log"
					build "Testing chapter-06: gcc" "echo 'main(){}' > dummy.c" "LOGS/gcc-test.log"
					build "cc dummy.c -v -Wl,--verbose &> dummy.log" "cc dummy.c -v -Wl,--verbose &> dummy.log" "LOGS/gcc-test.log"
					build "readelf -l a.out | grep ': /lib'" "readelf -l a.out | grep ': /lib'" "LOGS/gcc-test.log"
					build "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "LOGS/gcc-test.log"
					build "grep -B4 '^ /usr/include' dummy.log" "grep -B4 '^ /usr/include' dummy.log" "LOGS/gcc-test.log"
					build "grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'" "grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'" "LOGS/gcc-test.log"
					build "grep '/lib.*/libc.so.6 ' dummy.log" "grep '/lib.*/libc.so.6 ' dummy.log" "LOGS/gcc-test.log"
					build "grep found dummy.log" "grep found dummy.log" "LOGS/gcc-test.log"
					build "Clean up test files: gcc" "rm -v dummy.c a.out dummy.log" "LOGS/gcc-test.log"
				}
		;;
		*)	rm -rf BUILD/* BUILDROOT/* > /dev/null 2>&1
			RPMPKG=$(find RPMS -name "${i}-[0-9]*.rpm" -print)
			[ -z $RPMPKG ] || printf "%s\n" "Skipping: ${i}"
			[ -z $RPMPKG ] && > "LOGS/${i}.log"	# clean log files
			[ -z $RPMPKG ] && build "Building: ${i}" "rpmbuild -ba --nocheck --define \"_topdir ${PARENT}\" SPECS/${i}.spec" "LOGS/${i}.log"
			[ -e LOGS/${i}.completed ] && continue;
			RPMPKG=$(find RPMS -name "${i}-[0-9]*.rpm" -print)
			[ -z $RPMPKG ] && die "installation error: rpm package not found\n"
			case ${i} in
				glibc | readline | gmp | gcc | bzip2 | ncurses | util-linux | e2fsprogs | shadow | bison | perl | texinfo | vim | linux | udev | rpm)
					build "Installing: ${i}" "rpm -Uvh --nodeps --force ${RPMPKG}" "LOGS/${i}.completed" ;;
				*)	build "Installing: ${i}" "rpm -Uvh ${RPMPKG}" "LOGS/${i}.completed" ;;
			esac
		;;
	esac
done
/sbin/locale-gen.sh
/sbin/ldconfig
/usr/sbin/pwconv
/usr/sbin/grpconv
