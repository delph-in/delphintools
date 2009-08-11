#!/bin/bash

ARCH=`uname -m`
OS=`uname`
if [ `uname` = Darwin ]; then
	OS=MacOSX
fi

DTHOME=`dirname $0`
PATH=$DTHOME/bin/$OS:$DTHOME/bin/$OS/$ARCH:$DTHOME/bin:$PATH
export ARCH DTHOME OS PATH
. $DTHOME/env/$OS.env
