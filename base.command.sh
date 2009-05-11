#!/bin/bash

REPO_PATH=${REPO_PATH:-ssh://githany.netcentrum.cz/projects/django/GIT}
PROJ_NAME=${1:-djbproj}
LIB_NAME=${2:-djblib}

PROJ_BRANCH=${3:-master}
LIB_BRANCH=${4:-master}

PWD=$( cd $( dirname $0 ); pwd )

PROJ_NAME=$( echo $PROJ_NAME | sed 's|/\+$||' )
LIB_NAME=$( echo $LIB_NAME | sed 's|/\+$||' )

source ${PWD}/base.common.sh

print_help $*

# on run this via test defined in master script
if test_dirs; then
	echo directory '"'$PROJ_NAME'"' or '"'$LIB_NAME'"' $ERROR_MESSAGE >&2
	echo >&2
	print_help >&2
fi

COMMAND=init_repo
for ARGS in \
	"django-base-project $PROJ_NAME $PROJ_BRANCH" \
	"django-base-library $LIB_NAME  $LIB_BRANCH"  \
; do
	echo $COMMAND $ARGS
	$COMMAND $ARGS > /dev/null
done

echo create_dirs
create_dirs > /dev/null
echo move_files
move_files > /dev/null

echo commit
add_new_files $ADD_MESSAGE > /dev/null

COMMAND=merge_repo
for ARGS in \
	"django-base-project $PROJ_NAME $PROJ_BRANCH $COMMIT" \
	"django-base-library $LIB_NAME  $LIB_BRANCH  $COMMIT" \
; do
	echo $COMMAND $ARGS
	$COMMAND $ARGS > /dev/null
done

exit_func

