#!/bin/bash

. $LTHOME/env/logon.env
. $LTHOME/env/erg.env
. $LTHOME/bin/logon-utils.sh


jaen_parse_object () {
	logon_setup
	logon_parse_object $object
	logon_shutdown
}

logon_get_args $*
jaen_parse_object
