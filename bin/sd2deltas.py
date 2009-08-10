################################################################################
#!/usr/bin/python2.5
# -*- coding: utf-8 -*-

from __future__ import with_statement

# utf-8 i/o plz!
import sys
import codecs
from functools import partial
stdout = codecs.getwriter('utf-8')(sys.stdout)
stdin = codecs.getwriter('utf-8')(sys.stdin)
stderr = codecs.getwriter('utf-8')(sys.stderr)
open = partial(codecs.open, encoding='utf8')

from collections import defaultdict

print >>stderr, "Building hashes",

trans = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(bool)))))
nevas = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(float)))))
mtrs = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(bool)))))

i = 0
for l in (sys.stdin):
#	print l
	if ((i % 1000) == 0):
		print >>stderr, ".",
	i += 1

	d = l.split("\t")
	profile = d[0]
	sid = int(d[1])
	aid = int(d[2])
	tid = int(d[3])
	src = d[4]
	ref = d[5]
	tgt = d[6]
	neva = float(d[7].strip())	
	mtr_list = set(d[8].split())
	
	for m in mtr_list:
		trans[m][profile][sid][aid] = True
		nevas[profile][sid][aid][tid] = neva
		mtrs[profile][sid][aid][tid][m] = True
#		print >>stderr, "\t", profile, sid, aid, tid, neva, m

print >>stderr, "done!"

for m in sorted(trans.keys()):
	delta = 0.0
	ambiguous = 0
	unique = 0
	total = 0

	for p in sorted(trans[m].keys()):
#		print >>stderr, "\t", p
		for s in sorted(trans[m][p].keys()):
#			print >>stderr, "\t\t", s
			for a in sorted(trans[m][p][s]):
#				print >>stderr, "\t\t\t", a
				max_w = 0.0
				max_wo = 0.0
				for t in sorted(mtrs[p][s][a].keys()):
#					print >>stderr, "\t\t\t", t, neva
					neva = nevas[p][s][a][t]
					if m in mtrs[p][s][a][t]:
						max_w = max(max_w,neva)
					else:
						max_wo = max(max_wo,neva)

				total += 1
				if max_wo > 0:
					ambiguous += 1
					delta += max_w-max_wo
				else:
					unique += 1
	
	avg = delta/ambiguous if ambiguous>0 else 0.0
	print >>stdout, m, avg, delta, ambiguous, unique, total
