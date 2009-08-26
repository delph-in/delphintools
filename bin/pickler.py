################################################################################
#!/usr/bin/python2.5
# -*- coding: utf-8 -*-

# utf-8 i/o plz!
import sys
import codecs
from functools import partial
stdout = codecs.getwriter('utf-8')(sys.stdout)
stdin = codecs.getwriter('utf-8')(sys.stdin)
stderr = codecs.getwriter('utf-8')(sys.stderr)
open = partial(codecs.open, encoding='utf8')

try:
	import cPickle as pickle
except ImportError:
	import pickle
				 
def pickle_data(pkl, pack):
	'''Pickle data and store it to file.'''
	data = pack()
	name = pack.__name__ if not hasattr(pack,'func') else pack.func.__name__ 
	print >>stderr, "Pickling (%s) ..." % name,
	i = file(pkl, 'w')
	pickle.dump(data, i, 2)
	i.close()
	print >>stderr, "done!"

def unpickle_data(pkl, unpack):
	'''Read data from file and unpickle it.'''
	try:
		name = unpack.__name__ if not hasattr(unpack,'func') else unpack.func.__name__ 
		print >>stderr, "Unpickling (%s) ..." % name,
		i = file(pkl, 'r')
		data = pickle.load(i)
		unpack(data)
		print >>stderr, "done!"
		return True
	except Exception:
		stderr.flush()
		print >>stderr, "failed!"
		return False
