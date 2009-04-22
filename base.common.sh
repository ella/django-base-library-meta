#!/bin/bash

function create_repo ()
{
	REPO=$1
	DIR=$2

	# create DIR, if the cloning fails, the rest of the script won't
	mkdir $DIR &>/dev/null || {
		echo directory '"'$PROJ_NAME'"' or '"'$LIB_NAME'"' already exists
		echo
		print_help
	}

	add_remote_repo $REPO $DIR
}

function add_remote_repo ()
{
	REPO=$1
	DIR=$2

	cd $DIR &>/dev/null || {
		echo directory '"'$PROJ_NAME'"' or '"'$LIB_NAME'"' does not exists
		echo
		print_help
	}

	# initialize git repo if not intialized before
	[[ -d .git ]] || git init && git checkout master
	# add remote and fetch it
	git remote | grep -q $REPO || git remote add $REPO $REPO_PATH/$REPO.git/
	git fetch $REPO
	# actualize base tracking branch
	git branch -D ${REPO}-master
	git checkout -b ${REPO}-master ${REPO}/master

	# if master does not exist create it, otherwise just switch
	git checkout -b master &>/dev/null || git checkout master

	cd ..
}

function new_filename ()
{
	echo $1 | sed "s/djangobaseproject/$PROJ_NAME/g; s/djangobaselibrary/$LIB_NAME/g;"
}

function create_dirs ()
{
	# create dirs with new names
	find $PROJ_NAME $LIB_NAME -type d | grep -v '\.git/' | while read i; do
		ni=$( new_filename $i )
		mkdir -p $ni
	done
}

function move_files ()
{
	# rename files and move to proper location
	# any occurences of keywords inside the files are replaced as well
	find $PROJ_NAME $LIB_NAME -type f | grep -v '\.git/' | while read i; do
		ni=$( new_filename $i )
		sed -i "s/djangobaseproject/$PROJ_NAME/g; s/djangobaselibrary/$LIB_NAME/g" $i
		[[ "$i" != "$ni" ]] && mv $i $ni
	done
}

function add_new_files ()
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

function print_help ()
{
	APP=$0
	[[ $# -eq 2 ]] || {
		echo USAGE:
		echo $APP NEW-PROJ-NAME NEW-LIB-NAME
		exit
	}
}

function print_farewell ()
{
	echo
	echo "--------------------------------------------------------------------------------"
	echo

	echo project '"'$PROJ_NAME'"' and library '"'$LIB_NAME'"' created successfully
	echo
	echo don"'"t forget to: grep -rl "'"TODO: REPLACE"'" '"'$PROJ_NAME'"/*' '"'$LIB_NAME'"/*'
	echo for all lines that must be renamed by hand

	echo
	echo bye...
	echo
}

