#!/bin/bash
#lic:mpl2,2019,gardsted,github
[ -z "$robotemp" ] && echo robotemp not defined && exit 1
. $robotemp/shell/base.sh

which websocketd || (
    wget https://github.com/joewalnes/websocketd/releases/download/v0.3.1/websocketd-0.3.1_amd64.deb
    sudo dpkg -i websocketd-0.3.1_amd64.deb
    sudo apt-get -fy install
)
