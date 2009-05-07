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

# test existance of directories we will be working on
[[ -d $PROJ_NAME ]] && [[ -d $LIB_NAME ]] || {
	echo directory '"'$PROJ_NAME'"' or '"'$LIB_NAME'"' does not exists >&2
	echo >&2
	print_help >&2
}

for ARGS in "django-base-project $PROJ_NAME $PROJ_BRANCH" "django-base-library $LIB_NAME $LIB_BRANCH"; do
	COMMAND=init_repo
	echo $COMMAND $ARGS
	$COMMAND $ARGS > /dev/null
done

echo create_dirs
create_dirs > /dev/null
echo move_files
move_files > /dev/null

echo commit
add_new_files "automatic merge via $0" > /dev/null

for ARGS in "django-base-project $PROJ_NAME $PROJ_BRANCH --no-commit" "django-base-library $LIB_NAME $LIB_BRANCH --no-commit"; do
	COMMAND=merge_repo
	echo $COMMAND $ARGS
	$COMMAND $ARGS > /dev/null
done


