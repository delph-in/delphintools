#!/usr/bin/make

all:	test

test:	test.out test.gold
	diff -u test.gold test.out

clean:
	rm -rf *mrs test.out .tsdb_history

test.out:	gpmrs
	cut -d@ -f1,2,12 gpmrs/*/*/result | sort -t@ -k1n -k2n -k3 > $@

gpmrs:	pmrs
	logon_do -s $(DTHOME)/lisp/settings/enen_gpmrs.lisp -g enen -t gpmrs

pmrs:	smrs
	logon_do -s $(DTHOME)/lisp/settings/enen_pmrs.lisp -g enen -t pmrs

smrs:	bitext/ascii
	logon_do -s $(DTHOME)/lisp/settings/paraphrasing.lisp -g enen -t smrs

.PHONY:	all clean test %mrs
