#!/bin/bash
#lic:mpl2,2019,gardsted,github
export robotemp=$(cd $(dirname $0); pwd)
$robotemp/shell/robotemp.sh --robo-program=roboserve || (echo; echo did You run ./shell/install.sh?)
