#!/bin/bash

. $LTHOME/env/logon.env
. $LTHOME/env/erg.env
. $LTHOME/bin/logon-utils.sh

jaen_generate () {
	logon_setup
	logon_generate $transfer $generate
	logon_shutdown
}

logon_get_args $*
jaen_generate
