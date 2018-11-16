    _pkgname="ninja"
    _pkgver="1.8.2"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ export NINJAJOBS=4" "export NINJAJOBS=4" ${_logfile}
    build "+ patch -Np1 -i ../../SOURCES/ninja-1.8.2-add_NINJAJOBS_var-1.patch" "patch -Np1 -i ../../SOURCES/ninja-1.8.2-add_NINJAJOBS_var-1.patch" ${_logfile}
    build "+ python3 configure.py --bootstrap" "python3 configure.py --bootstrap" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}

    build "+ python3 configure.py" "python3 configure.py" ${_logfile}
    build "+ ./ninja ninja_test" "./ninja ninja_test" ${_logfile}
    build "+ ./ninja_test --gtest_filter=-SubprocessTest.SetWithLots" "./ninja_test --gtest_filter=-SubprocessTest.SetWithLots" ${_logfile}
    build "+ install -vm755 ninja /usr/bin/" "install -vm755 ninja /usr/bin/" ${_logfile}
    build "+ install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja" "install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja" ${_logfile}
    build "+ install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja" "install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja" ${_logfile}

    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
