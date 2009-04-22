#!/bin/bash

REPO_PATH=${REPO_PATH:-ssh://githany.netcentrum.cz/projects/django/GIT}
PROJ_NAME=${1:-djbproj}
LIB_NAME=${2:-djblib}
PWD=$( cd $( dirname $0 ); pwd )

source ${PWD}/base.common.sh

print_help $*

add_remote_repo django-base-project $PROJ_NAME
add_remote_repo django-base-library $LIB_NAME

#create_dirs
#move_files

#add_new_files "automatic merge via $0"

