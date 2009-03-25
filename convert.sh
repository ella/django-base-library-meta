#!/bin/bash

[[ $# -eq 2 ]] || {
	echo USAGE:
	echo $0 NEW-PROJ-NAME NEW-LIB-NAME
	exit
}

PROJ_NAME=${1:-djbproj}
LIB_NAME=${2:-djblib}

function create_repo()
{
	REPO=$1
	DIR=$2

	git clone ssh://githany.netcentrum.cz/projects/django/GIT/$REPO.git/ $DIR

	cd $DIR
	git remote rename origin $REPO
	git branch -M ${REPO}-master
	git checkout -b master
	cd ..
}

function new_filename()
{
	echo $1 | sed "s/djangobaseproject/$PROJ_NAME/g; s/djangobaselibrary/$LIB_NAME/g;"
}

function create_dirs()
{
	find $PROJ_NAME $LIB_NAME -type d | grep -v '\.git/' | while read i; do
		ni=$( new_filename $i )
		mkdir -p $ni
	done
}

function move_files()
{
	find $PROJ_NAME $LIB_NAME -type f | grep -v '\.git/' | while read i; do
		ni=$( new_filename $i )
		sed -i "s/djangobaseproject/$PROJ_NAME/g; s/djangobaselibrary/$LIB_NAME/g" $i
		mv $i $ni
	done
}

function add_new_files()
{
	for i in $PROJ_NAME $LIB_NAME; do
		cd $i
		git diff-files --diff-filter=D --name-only | xargs git rm -q
		git add .
		git commit -m 'base repository renamed'
		cd ..
	done
}

create_repo django-base-project $PROJ_NAME
create_repo django-base-library $LIB_NAME

create_dirs
move_files

add_new_files

