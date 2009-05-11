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

# create DIR, if the cloning fails, the rest of the script won't
mkdir $PROJ_NAME &>/dev/null && mkdir $LIB_NAME &>/dev/null || {
	echo directory '"'$PROJ_NAME'"' or '"'$LIB_NAME'"' already exists >&2
	echo >&2
	print_help >&2
}

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
add_new_files "automatic fork via $0" > /dev/null

COMMAND=merge_repo
for ARGS in \
	"django-base-project $PROJ_NAME $PROJ_BRANCH --commit" \
	"django-base-library $LIB_NAME  $LIB_BRANCH  --commit" \
; do
	echo $COMMAND $ARGS
	$COMMAND $ARGS > /dev/null
done

print_farewell

