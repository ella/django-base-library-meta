#!/bin/bash

[[ $# -eq 3 ]] || {
	echo USAGE:
	echo $0 DIR-PATH-TO-REPO NEW-PROJ-NAME NEW-LIB-NAME
	exit
}

DIR=$1
PROJ_NAME=$2
LIB_NAME=$3

TMP=$(mktemp)

grep djangobaseproject $DIR/* -r -l | xargs echo sed -i "s/djangobaseproject/$PROJ_NAME/g" $TMP
grep djangobaselibrary $DIR/* -r -l | xargs echo sed -i "s/djangobaselibrary/$LIB_NAME/g" $TMP

function rename() {
	f=$1
	n=$( echo $f | sed "s/djangobaseproject/$PROJ_NAME/g; s/djangobaselibrary/$LIB_NAME/g;" )
	echo mkdir -p $( dirname $n )
	echo mv $f $n
}

find $DIR/* -type d | while read f; do rename $f; done
find $DIR/* -type f | while read f; do rename $f; done

