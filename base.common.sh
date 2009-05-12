#!/bin/bash

function init_repo ()
{
	REPO=$1
	DIR=$2
	BRANCH=$3
	WRK_BRANCH=${BRANCH}-tmp

	cd $DIR

	# initialize git repo if not intialized before
	[[ -d .git ]] && git checkout master || git init
	# add remote and fetch it
	git remote rm $REPO
	git remote add $REPO $REPO_PATH/$REPO.git/
	git fetch $REPO
	# actualize base tracking branch
	git branch -D ${REPO}-${BRANCH} &>/dev/null
	git checkout -b ${REPO}-${BRANCH} ${REPO}/${BRANCH}

	# if master does not exist create it, otherwise just switch
	git checkout -b master &>/dev/null || git checkout master

	# and now switch to work branch
	git checkout -b ${REPO}-${WRK_BRANCH} ${REPO}-${BRANCH} || git checkout ${REPO}-${WRK_BRANCH}

	# and just try to pull in new stuff
	git merge ${REPO}/${BRANCH}

	cd ..
}

function merge_repo ()
{
	REPO=$1
	DIR=$2
	BRANCH=$3
	WRK_BRANCH=${BRANCH}-tmp
	COMMIT=${4:---no-commit}

	cd $DIR

	git checkout master
	git merge $COMMIT ${REPO}-${WRK_BRANCH}

	cd ..
}

function new_filename ()
{
	echo $1 | sed "s/djangobaseproject/$PROJ_NAME/g; s/djangobaselibrary/$LIB_NAME/g;"
}

function create_dirs ()
{
	# create dirs with new names
	find ${PROJ_NAME}/ ${LIB_NAME}/ -type d | grep -v '\.git/' | while read i; do
		ni=$( new_filename $i )
		mkdir -p $ni
	done
}

function move_files ()
{
	# rename files and move to proper location
	# any occurences of keywords inside the files are replaced as well
	find ${PROJ_NAME}/ ${LIB_NAME}/ -type f | grep -v '\.git/' | while read i; do
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
		git diff-files --diff-filter=D --name-only | xargs git rm -q -f --
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
	[[ $# -lt 2 ]] && {
		echo USAGE:
		echo "$APP NEW-PROJ-NAME NEW-LIB-NAME [PROJ-BRANCH-NAME] [LIB-BRANCH-NAME]"
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

