#!/bin/bash

for f in $* ; do
	jacy-parse.sh -p pet -l 10 -e 50000 -a $f
	jaen-parse-object.sh -p pet -l 10 -e 50000 -a $f
	jaen-partial-transfer.sh -l 3 -e 5000 -a $f
	jaen-partial-generate.sh -l 10 -e 10000 -a $f
done
