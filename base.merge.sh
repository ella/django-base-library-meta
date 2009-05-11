#!/bin/bash

PWD=$( cd $( dirname $0 ); pwd )

function test_dirs() {
	# test existance of directories we will be working on
	! [[ -d $PROJ_NAME ]] || ! [[ -d $LIB_NAME ]]
}

ERROR_MESSAGE="does not exists"
ADD_MESSAGE="automatic merge via $0"
COMMIT="--no-commit"

source ${PWD}/base.command.sh

