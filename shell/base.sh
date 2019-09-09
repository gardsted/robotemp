#!/bin/bash
#lic:mpl2,2019,gardsted,github
[ -z "$robotemp" ] && echo robotemp not defined && exit 1
declare -a onexit_list
declare -A onarg_map
declare -a ARGS
export robo=${robo:=/tmp/robo} # set tobo in env to change working dir
export logfile=$robo/logfile.txt
export settingsfile=$robo/settings.sh
mkdir -p $robo; cd $robo


trap "onexit --exit" EXIT
onexit(){
    if [ "$1" = "--exit" ]; then
        trap "" EXIT
        . <(printf '%s\n' "${onexit_list[@]}")
    elif [ -n "$1" ]; then
        onexit_list=("${onexit_list[@]}" "$*")
    fi
}


etokenize(){
    #change --usual-suspects=x=y into --usual-suspects x=y
    (for o in $*; do
        [ ${o:0:2} = "--" ] && echo ${o/=/ } && continue
        echo $o 
    done) | xargs
}


onarg(){
    if [ "$1" = "--onarg" ]; then
        shift 
        echo set -- $*
        echo 'while [ -n "$*" ]; do case "$1" in '
        for k in "${!onarg_map[@]}" ; do
            echo "($k) ${onarg_map[$k]};;"
        done
        echo '(*) ARGS=("${ARGS[@]}" "$1")'
        echo 'esac; shift; done'
    elif [ -n "$1" ]; then
        k=$1; shift
        onarg_map[$k]="$*"
    fi
}

################################
# onexit echo bye
# onarg -k 'export killer=$2; shift'
# onarg -b 'export birdie=$2; shift'
# onarg --usual-suspects 'export usual=$2; shift'
# . <(onarg --onarg $(etokenize $@))
################################

settings(){
    touch ${settingsfile}
    sed 's/^\([^#]\{1,\}\)/export \1/' ${settingsfile}
}


setting(){
    key=$1; shift;
    value="$*"
    sed -i -e "/$key=/d" ${settingsfile}
    echo $key="$value" >> ${settingsfile}
    echo export $key="$value"
}

export -f setting settings onarg onexit etokenize
