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
from pickler import *

def process_sd(file):
	print >>stderr, "Building hashes",
	global trans, nevas, mtrs
	trans = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(bool)))))
	nevas = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(float)))))
	mtrs = defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(lambda: defaultdict(bool)))))	
	i = 0
	with open(file, 'r') as f:
		for l in f:
#			print >>stderr, l
			if ((i % 1000) == 0):
				print >>stderr, ".",
			i += 1	
			profile, sid, aid, tid, src, ref, tgt, neva, mtr_list = l.strip().split("\t")
			sid = int(sid)
			aid = int(aid)
			tid = int(tid)
			neva = float(neva)
			mtr_list = set(mtr_list.split())
			for m in mtr_list:
				trans[m][profile][sid][aid] = True
				nevas[profile][sid][aid][tid] = neva
				mtrs[profile][sid][aid][tid][m] = True
#				print >>stderr, "\t", profile, sid, aid, tid, neva, m
		print >>stderr, "done!"

def get_deltas(file):
	process_sd(file)
	deltas = defaultdict(tuple)
	for m in sorted(trans.keys()):
		delta = 0.0
		ambiguous = 0
		unique = 0
		total = 0
		for p in sorted(trans[m].keys()):
#			print >>stderr, "\t", p
			for s in sorted(trans[m][p].keys()):
#				print >>stderr, "\t\t", s
				for a in sorted(trans[m][p][s]):
#					print >>stderr, "\t\t\t", a
					max_w = 0.0
					max_wo = 0.0
					for t in sorted(mtrs[p][s][a].keys()):
#						print >>stderr, "\t\t\t", t, neva
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
		deltas[m] = (m, avg, delta, ambiguous, unique, total)
		print >>stderr, m, avg, delta, ambiguous, unique, total
	return deltas

def pack_deltas(file):
	global deltas
	deltas = get_deltas(file)
	return (deltas, )

def unpack_deltas(data):
	global deltas
	deltas = data

def main(sd, pkl='deltas.pkl'):
	unpickle_data(pkl, unpack_deltas) or \
		pickle_data(pkl, partial(pack_deltas, file=sd))

if __name__ == '__main__':
	main(sys.argv[1:])
