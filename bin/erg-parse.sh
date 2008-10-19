#!/bin/bash

. $LTHOME/env/logon.env
. $LTHOME/env/erg.env
. $LTHOME/bin/logon-utils.sh

erg_parse () {
	logon_setup
	logon_parse $source
	logon_shutdown
}

logon_get_args $*
erg_parse
