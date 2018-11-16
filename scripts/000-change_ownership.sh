    _complete="${PWD}/LOGS/${FUNCNAME}.completed"
    _logfile="${PWD}/LOGS/${FUNCNAME}.log"
    [ -e ${_complete} ] && { msg "${FUNCNAME}: SKIPPING";return 0; } || msg "${FUNCNAME}: Building"
    > ${_logfile}
    build "+ chown -R root:root /tools" "chown -R root:root /tools" ${_logfile}
    >  ${_complete}
    return 0
