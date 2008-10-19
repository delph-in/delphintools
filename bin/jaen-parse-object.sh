#!/bin/bash

. $LTHOME/env/logon.env
. $LTHOME/env/erg.env
. $LTHOME/bin/logon-utils.sh

logon_get_args $*

run_logon "logon_parse_object $object"
