#!/bin/bash

ARCH=`uname -m`
OS=`uname`
if [ `uname` = Darwin ]; then
	OS=MacOSX
fi

PATH=$DTHOME/bin/$OS:$DTHOME/bin/$OS/$ARCH:$DTHOME/bin:$PATH
export ARCH DTHOME OS PATH
. $DTHOME/env/$OS.env
