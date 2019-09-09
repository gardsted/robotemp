#!/bin/bash
#lic:mpl2,2019,gardsted,github
[ -z "$robotemp" ] && echo robotemp not defined && exit 1
. $robotemp/shell/base.sh
export robo_port=${robo_port:=8844}         # --robo-port=8844 | --robo-port 8844 | -p 8844
export robo_host=${robo_host:=localhost}    # --robo-host=localhost | --robo-host localhost | -h localhost
export robo_scheme=http                     # man websocketd
export robo_program=${robo_program:=robotemp}  # --robo-program=roboserve|robotemp 


robotemp(){
    declare -i retval
    while true; do
        retval=$(od -vAn -td1 -N1 /dev/random)/20+20
        echo ${retval}
        sleep 1
    done
}

roboserve(){
    echo; echo now go to ${robo_scheme}://${robo_host}:${robo_port} ; echo
    onexit echo roboserve stopped
    [ "${debugsockets}" = "true" ] \
        && http="--devconsole" \
        || http="--cgidir=$robotemp/cgi --staticdir=$robotemp/static" 
    websocketd \
        --port=${robo_port} \
        --address=${robo_host} \
        ${http} \
        --dir=$robotemp/sockets \
        --passenv=robotemp      #,DISPLAY,XAUTHORITY,DBUS_SESSION_BUS_ADDRESS,XMODIFIERS
}


onarg --robo-port 'export robo_port=$2; shift'
onarg -p 'export robo_port=$2; shift'
onarg --robo-host 'export robo_host=$2; shift'
onarg -h 'export robo_host=$2; shift'
onarg --robo-program 'export robo_program=$2; shift'

. <(settings)
. <(onarg --onarg $(etokenize $*))

${robo_program}
