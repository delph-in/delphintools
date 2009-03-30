#!/bin/bash

. $LTHOME/env/logon.env
. $LTHOME/env/jacy.env
. $LTHOME/bin/logon-utils.sh

jaen_transfer () {
	logon_setup
	logon_transfer $source $transfer
	logon_shutdown
}

logon_get_args $*
jaen_transfer
