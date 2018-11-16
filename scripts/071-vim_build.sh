    _pkgname="vim"
    _pkgver="8.0.586"
    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: ${_pkgname} ${_pkgver}: Building"
    > ${_logfile}
    build " Clean build directory" 'rm -rf BUILD/*' ${_logfile}
    build " Change directory: BUILD" "pushd BUILD" ${_logfile}
    unpack "${PWD}" "${_pkgname}-${_pkgver}"
    build "+ mv vim?? vim-${_pkgver}" "mv vim?? vim-${_pkgver}" ${_logfile}
    build " Change directory: ${_pkgname}-${_pkgver}" "pushd ${_pkgname}-${_pkgver}" ${_logfile}
    build "+ echo '#define SYS_VIMRC_FILE \"/etc/vimrc\"' >> src/feature.h" "echo '#define SYS_VIMRC_FILE \"/etc/vimrc\"' >> src/feature.h" ${_logfile}
    build "+ sed -i '/call/{s/split/xsplit/;s/303/492/}' src/testdir/test_recover.vim" "sed -i '/call/{s/split/xsplit/;s/303/492/}' src/testdir/test_recover.vim" ${_logfile}
    #build " Create work directory" "install -vdm 755 ../build" ${_logfile}
    #build " Change directory: ../build" "pushd ../build" ${_logfile}
    build "+ ../${_pkgname}-${_pkgver}/configure --prefix=/usr" "../${_pkgname}-${_pkgver}/configure --prefix=/usr" ${_logfile}
    build "+ make" "make" ${_logfile}
    build "+ make -j1 test &> vim-test.log" "make -j1 test &> vim-test.log" ${_logfile}
    build "+ make install" "make install" ${_logfile}
    build "+ ln -sv vim /usr/bin/vi" "ln -sv vim /usr/bin/vi" ${_logfile}
    for L in  /usr/share/man/{,*/}man1/vim.1; do
        build "+ ln -sv vim.1 $(dirname $L)/vi.1" "ln -sv vim.1 $(dirname $L)/vi.1" ${_logfile}
    done
    build "+ ln -sv ../vim/vim80/doc /usr/share/doc/vim-8.0.586" "ln -sv ../vim/vim80/doc /usr/share/doc/vim-8.0.586" ${_logfile}
    msg_line "Creating /etc/vimrc"
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1 

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" (this one to fix my syntax hightlighting)
" End /etc/vimrc
EOF
    msg_success
    #build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    build " Restore directory" "popd " /dev/null
    >  ${_complete}
    return 0
