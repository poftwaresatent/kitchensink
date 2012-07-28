#!/bin/bash

BASE=/Volumes/prancingpony/kitchensink
OBJBASE=$BASE/obj
SYMBASE=$BASE/sym
INDEX=$BASE/idx

while read
do
    REPDIR=`dirname "$REPLY"`
    if [ $? -ne 0 ]; then
	echo "ERROR dirname does not like $REPLY"
	exit 39
    fi

    REPFILE=`basename "$REPLY"`
    if [ $? -ne 0 ]; then
	echo "ERROR basename does not like $REPLY"
	exit 40
    fi
    
    STAMP=`stat -f '%Sm' "$REPLY" | awk '{print $4 "_" $1 "_" $2 "_" $3}'`
    HASH=`openssl sha "$REPLY" | sed 's:SHA.*= ::'`
    ODIR=`echo $HASH | cut -c 1,2 -`
    
    mkdir -p "$SYMBASE/$REPDIR"
    if [ $? -ne 0 ]; then
	echo "ERROR creating symbol directory $SYMBASE/$REPDIR"
	exit 41
    fi
    
    if [ -d $OBJBASE/$ODIR -a -f $OBJBASE/$ODIR/$HASH ]; then
	echo "duplicate object $REPLY : $HASH : $STAMP"
    else
	mkdir -p $OBJBASE/$ODIR
	if [ $? -ne 0 ]; then
	    echo "ERROR creating object directory $OBJBASE/$ODIR"
	    exit 42
	fi
	echo "copying $REPLY to $OBJBASE/$ODIR/$HASH"
	cp -p "$REPLY" $OBJBASE/$ODIR/$HASH
	if [ $? -ne 0 ]; then
	    echo "ERROR copying $REPLY to $OBJBASE/$ODIR/$HASH"
	    exit 43
	fi
    fi
    
    if [ -e "$SYMBASE/$REPLY" ]; then
	IOBJ=`stat -f '%i' $OBJBASE/$ODIR/$HASH`
	ISYM=`stat -f '%i' "$SYMBASE/$REPLY"`
	if [ $IOBJ -ne $ISYM ]; then
	    echo "duplicate symbol $REPLY : $HASH : $STAMP"
	    mkdir -p "$SYMBASE/$REPDIR/CLASHES"
	    if [ $? -ne 0 ]; then
		echo "ERROR creating clashes directory $SYMBASE/$REPDIR/CLASHES"
		exit 44
	    fi
	    ln $OBJBASE/$ODIR/$HASH "$SYMBASE/$REPDIR/CLASHES/${STAMP}__${REPFILE}__${HASH}"
	    if [ $? -ne 0 ]; then
		echo "ERROR linking duplicate symbol to object"
		exit 43
	    fi
	echo "clash $HASH $STAMP $REPLY" >> $INDEX
#	else
#	    echo "skipping duplicate $REPLY : $HASH : $STAMP"
	fi
    else
	ln $OBJBASE/$ODIR/$HASH "$SYMBASE/$REPLY"
	if [ $? -ne 0 ]; then
	    echo "ERROR linking symbol to object"
	    exit 44
	fi
	echo "$HASH $STAMP $REPLY" >> $INDEX
    fi
done
