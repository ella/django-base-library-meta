#!/bin/bash

PWD=$( cd $( dirname $0 ); pwd )

function test_dirs() {
	# create DIR, if the cloning fails, the rest of the script won't
	! mkdir $PROJ_NAME &>/dev/null || ! mkdir $LIB_NAME &>/dev/null
}

ERROR_MESSAGE="already exists"
ADD_MESSAGE="automatic fork via $0"
COMMIT="--commit"

source ${PWD}/base.command.sh

