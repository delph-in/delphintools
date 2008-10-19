#!/bin/bash

. $LTHOME/env/logon.env
. $LTHOME/env/jacy.env
. $LTHOME/bin/logon-utils.sh

logon_get_args $*

run_logon logon_generate_source $source $name/imrs 
