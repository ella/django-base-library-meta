#!/bin/bash

[[ $# -eq 2 ]] || {
	echo USAGE:
	echo $0 NEW-PROJ-NAME NEW-LIB-NAME
	exit
}

PROJ_NAME=${1:-djbproj}
LIB_NAME=${2:-djblib}
PWD=$( cd $( dirname $0 ); pwd )

source ${PWD}/base.common.sh

create_dirs
move_files

add_new_files "automatic merge via $0"

