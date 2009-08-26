#!/bin/bash

DTHOME=`dirname $0`
export DTHOME
export PATH=$DTHOME/bin:$PATH

if [ `uname` = Darwin ]; then
	. $DTHOME/env/Darwin.env
elif [ `uname` = Linux ]; then
	. $DTHOME/env/Linux.env
fi
