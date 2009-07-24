#!/usr/bin/make

all:	test

test:	test.out test.gold
	diff -u test.gold test.out

clean:
	rm -rf *mrs test.out .tsdb_history

test.out:	gmrs
	cut -d@ -f1,2,12 $</*/*/result | sort -t@ -k1n -k2n -k3 > $@

gmrs:	tmrs
	logon_do -g jaen -t $@

tmrs:	smrs
	logon_do -g jaen -t $@

smrs:	bitext/original
	logon_do -g jaen -t $@

.PHONY:	all clean test %mrs
