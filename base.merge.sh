#!/bin/bash

REPO_PATH=${REPO_PATH:-ssh://githany.netcentrum.cz/projects/django/GIT}
PROJ_NAME=${1:-djbproj}
LIB_NAME=${2:-djblib}
PWD=$( cd $( dirname $0 ); pwd )

source ${PWD}/base.common.sh

print_help $*

echo add_remote_repo django-base-project $PROJ_NAME
add_remote_repo django-base-project $PROJ_NAME > /dev/null
echo add_remote_repo django-base-library $LIB_NAME
add_remote_repo django-base-library $LIB_NAME > /dev/null

echo merge_repo django-base-project $PROJ_NAME
merge_repo django-base-project $PROJ_NAME > /dev/null
echo merge_repo django-base-library $LIB_NAME
merge_repo django-base-library $LIB_NAME > /dev/null

echo create_dirs
create_dirs > /dev/null
echo move_files
move_files > /dev/null

#add_new_files "automatic merge via $0"

