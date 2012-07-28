#!/bin/bash

DIRECTORIES=""

function abspath {
    if [ foo`echo $1 | sed 's:\(.\).*:\1:'` = "foo/" ]; then
        RETVAL=$1
    else
        RETVAL=`pwd`/$1
    fi
}

if [ -z "$1" ]; then
    DIRECTORIES=`pwd`
else
    while [ ! -z "$1" ]; do
	abspath $1
	DIRECTORIES="$DIRECTORIES $1"
	shift
    done
fi

find $DIRECTORIES -type f | fgrep -v -e /.svn/ -e /.git/ | sed -e 's: :\\ :g' -e "s:':\\\\':g"
