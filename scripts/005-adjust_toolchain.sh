    _pkgname="adjust_toolchain"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
    > ${_logfile}
    build "+ mv -v /tools/bin/{ld,ld-old}" "mv -v /tools/bin/{ld,ld-old}" ${_logfile}
    build "+ mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}" "mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}" ${_logfile}
    build "+ mv -v /tools/bin/{ld-new,ld}" "mv -v /tools/bin/{ld-new,ld}" ${_logfile}
    build "+ ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld" "ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld" ${_logfile}
    gcc -dumpspecs | sed -e 's@/tools@@g'                   \
        -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
        -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
        `dirname $(gcc --print-libgcc-file-name)`/specs
    build "+ echo 'int main(){}' > dummy.c" "echo 'int main(){}' > dummy.c" ${_logfile}
    build "+ cc dummy.c -v -Wl,--verbose &> dummy.log" "cc dummy.c -v -Wl,--verbose &> dummy.log" ${_logfile}
    build "+ readelf -l a.out | grep ': /lib'" "readelf -l a.out | grep ': /lib'" ${_logfile}
    build "+ grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" "grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log" ${_logfile}
    build "+ grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'" "grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'" ${_logfile}
    build "+ grep \"/lib.*/libc.so.6 \" dummy.log" "grep \"/lib.*/libc.so.6 \" dummy.log" ${_logfile}
    build "+ grep found dummy.log" "grep found dummy.log" ${_logfile}
    build "+ rm -v dummy.c a.out dummy.log" "rm -v dummy.c a.out dummy.log" ${_logfile}

    > ${_complete}
    return 0
