#!/bin/bash

. $LTHOME/env/logon.env
. $LTHOME/env/jacy.env
. $LTHOME/bin/logon-utils.sh

logon_get_args $*

run_logon logon_transfer $source $transfer