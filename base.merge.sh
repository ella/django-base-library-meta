#!/bin/bash

REPO_PATH=${REPO_PATH:-ssh://githany.netcentrum.cz/projects/django/GIT}
PROJ_NAME=${1:-djbproj}
LIB_NAME=${2:-djblib}

PWD=$( cd $( dirname $0 ); pwd )

PROJ_NAME=$( echo $PROJ_NAME | sed 's|/\+$||' )
LIB_NAME=$( echo $LIB_NAME | sed 's|/\+$||' )

source ${PWD}/base.common.sh

print_help $*

# test existance of directories we will be working on
[[ -d $PROJ_NAME ]] && [[ -d $LIB_NAME ]] || {
	echo directory '"'$PROJ_NAME'"' or '"'$LIB_NAME'"' does not exists >&2
	echo >&2
	print_help >&2
}

echo init_repo django-base-project $PROJ_NAME
init_repo django-base-project $PROJ_NAME > /dev/null
echo init_repo django-base-library $LIB_NAME
init_repo django-base-library $LIB_NAME > /dev/null

echo merge_repo django-base-project $PROJ_NAME
merge_repo django-base-project $PROJ_NAME > /dev/null
echo merge_repo django-base-library $LIB_NAME
merge_repo django-base-library $LIB_NAME > /dev/null

echo create_dirs
create_dirs > /dev/null
echo move_files
move_files > /dev/null

#add_new_files "automatic merge via $0"

