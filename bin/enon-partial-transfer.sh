#
# make sure this file is included from your personal `~/.bashrc', e.g. put the
# following towards the end of `~/.bashrc' (and uncomment these, of course):
#
#   LTHOME=~/logon
#   if [ -f $LTHOME/dot.bashrc ]; then
#     . $LTHOME/dot.bashrc
#   fi
#
# if you decide to keep your LOGON source tree in a different location, say
# `~/src/logon', instead, then adjust the above accordingly.  it should not be
# necessary to make changes to _this_ file, however.
#

#!/bin/bash

. $LTHOME/env/logon.env
. $LTHOME/env/enon.env
. $LTHOME/bin/logon-utils.sh

logon_get_args $*

run_logon "logon_partial_transfer $source $partial"
