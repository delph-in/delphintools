#!/bin/bash

LTHOME=`dirname $0`

ARCH=`uname -m`
OS=`uname`
if [ `uname` = Darwin ]; then
	OS=MacOSX
fi

PATH=$LTHOME/bin/$OS:$LTHOME/bin/$OS/$ARCH:$LTHOME/bin:$PATH
export ARCH LTHOME OS PATH
. $LTHOME/env/$OS.env
