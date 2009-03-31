#!/bin/bash

function create_repo()
{
	REPO=$1
	DIR=$2

	# create DIR, if the cloning fails, the rest of the script won't
	mkdir $DIR

	git clone $REPO_PATH/$REPO.git/ $DIR

	# renaming of the origin repo, because this will be fork of it
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
	# create dirs with new names
	find $PROJ_NAME $LIB_NAME -type d | grep -v '\.git/' | while read i; do
		ni=$( new_filename $i )
		mkdir -p $ni
	done
}

function move_files()
{
	# rename files and move to proper location
	# any occurences of keywords inside the files are replaced as well
	find $PROJ_NAME $LIB_NAME -type f | grep -v '\.git/' | while read i; do
		ni=$( new_filename $i )
		sed -i "s/djangobaseproject/$PROJ_NAME/g; s/djangobaselibrary/$LIB_NAME/g" $i
		mv $i $ni
	done
}

function add_new_files()
{
	MSG="$1"
	for i in $PROJ_NAME $LIB_NAME; do
		cd $i
		# git remove removed files
		git diff-files --diff-filter=D --name-only | xargs git rm -q
		# add everything new
		git add .
		# and commit
		[[ "$MSG" ]] && git commit -m "$MSG"
		cd ..
	done
}

function print_help()
{
	APP=$0
	[[ $# -eq 2 ]] || {
		echo USAGE:
		echo $APP NEW-PROJ-NAME NEW-LIB-NAME
		exit
	}
}

