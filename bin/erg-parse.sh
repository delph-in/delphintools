#!/bin/bash

. $DTHOME/env/logon.env
. $DTHOME/env/erg.env
#. $DTHOME/bin/logon-utils.sh

erg_parse () {
	logon_setup
	logon_parse $*
	logon_shutdown
}

name=$1
if [ "${name#/}" = "$name" ]; then 
	name=$PWD/$name
fi
export name

erg_parse $*
