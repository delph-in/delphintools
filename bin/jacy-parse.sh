#!/bin/bash

. $LTHOME/env/logon.env
. $LTHOME/env/jacy.env
. $LTHOME/bin/logon-utils.sh

jacy_parse () {
	logon_setup
	logon_parse $source
	logon_shutdown
}

logon_get_args $*
jacy_parse
