#!/usr/bin/python2.5

import sys

print >>sys.stderr, "Building hashes",

trans = {}
nevas = {}
mtrs = {}
i = 0
for l in (sys.stdin):
#	print l
	if ((i % 1000) == 0):
		print >>sys.stderr, ".",
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
		trans.setdefault(m,{})
		trans[m].setdefault(profile,{})
		trans[m][profile].setdefault(sid,{})
		trans[m][profile][sid].setdefault(aid,True)
		
		nevas.setdefault(profile,{})
		nevas[profile].setdefault(sid,{})
		nevas[profile][sid].setdefault(aid,{})
		nevas[profile][sid][aid].setdefault(tid,neva)
		
		mtrs.setdefault(profile,{})
		mtrs[profile].setdefault(sid,{})
		mtrs[profile][sid].setdefault(aid,{})
		mtrs[profile][sid][aid].setdefault(tid,{})
		mtrs[profile][sid][aid][tid].setdefault(m,True)

#		print "\t", profile, sid, aid, tid, neva, m

print >>sys.stderr, "done!"

for m in sorted(trans.keys()):
	delta = 0.0
	avg = 0.0
	ambiguous = 0
	unique = 0
	total = 0

	for p in sorted(trans[m].keys()):
#		print >>sys.stderr, "\t", p
		for s in sorted(trans[m][p].keys()):
#			print >>sys.stderr, "\t\t", s
			for a in sorted(trans[m][p][s]):
#				print >>sys.stderr, "\t\t\t", a
				max_w = 0.0
				max_wo = 0.0
				for t in sorted(mtrs[p][s][a].keys()):
#					print >>sys.stderr, "\t\t\t", t, neva
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
	
	if (ambiguous > 0):
		avg = delta/ambiguous
	
	print m, avg, delta, ambiguous, unique, total
