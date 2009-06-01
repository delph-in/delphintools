#!/usr/bin/python2.5

import sys
import sqlalchemy
from sqlalchemy import create_engine
#engine = create_engine('sqlite:///:memory:', echo=True)
engine = create_engine('sqlite:///:memory:')

from sqlalchemy import Table, Column, Integer, Float, Text, MetaData, ForeignKey
metadata = MetaData()

trans_table = Table('trans', metadata,
	Column('id', Integer, primary_key=True),
	Column('profile', Text),
	Column('sid', Integer)
)

neva_table = Table('nevas', metadata,
	Column('id', Integer, primary_key=True),
	Column('trans_id', Integer, ForeignKey('trans.id')),
	Column('tid', Integer),
	Column('src', Text),
	Column('ref', Text),
	Column('tgt', Text),
	Column('neva', Float)
)

mtr_table = Table('mtrs', metadata,
	Column('id', Integer, primary_key=True),
	Column('trans_id', Integer, ForeignKey('trans.id')),
	Column('neva_id', Integer, ForeignKey('nevas.id')),
	Column('mtr', Text, nullable=False, unique=True)
)

assoc_table1 = Table('assoc1', metadata,
	Column('trans_id', Integer, ForeignKey('trans.id')),
	Column('mtr_id', Integer, ForeignKey('mtrs.id')),
)

assoc_table2 = Table('assoc2', metadata,
	Column('neva_id', Integer, ForeignKey('nevas.id')),
	Column('mtr_id', Integer, ForeignKey('mtrs.id')),
)

# create tables
metadata.create_all(engine)
# bind to engine
metadata.bind = engine

class Trans(object):
	def __init__(self, profile, sid):
		self.profile = profile
		self.sid = sid
	def __repr__(self):
	   return "<Trans('%s','%d')>" % (self.profile, self.sid)

class Neva(object):
	def __init__(self, tid, src, ref, tgt, neva):
		self.tid = tid
		self.src = src
		self.ref = ref
		self.tgt = tgt
		self.neva = neva
	def __repr__(self):
	   return "<Neva('%d', '%s', '%s', '%s', '%f')>" % (self.tid, self.src, self.ref, self.tgt, self.neva)

class Mtr(object):
	def __init__(self, mtr):
		self.mtr = mtr
	def __repr__(self):
	   return "<Mtr('%s')>" % (self.mtr)

# map objects to tables
from sqlalchemy.orm import mapper, relation

mapper(Trans, trans_table, properties={
    'mtrs':relation(Mtr, secondary=assoc_table1, backref='trans')
})
mapper(Neva, neva_table, properties={
    'mtrs':relation(Mtr, secondary=assoc_table2, backref='nevas')
})
mapper(Mtr, mtr_table)

from sqlalchemy.orm import sessionmaker
Session = sessionmaker(bind=engine, autoflush=True, transactional=True)
session = Session()

for l in (sys.stdin):
	d = l.split("\t")
	profile = d[0]
	sid = int(d[1])
	t = session.query(Trans).filter_by(profile=profile).filter_by(sid=sid).first()
	if not t:
		t = Trans(profile, sid)
		session.save(t)
		session.commit()
#	print t.id, t
	
	tid = int(d[2])
	src = d[3]
	ref = ""
	tgt = d[4]
	neva = float(d[5].strip())
	n = Neva(tid, src, ref, tgt, neva)
	n.trans_id = t.id
	session.save(n)
#	print n.trans_id, n
	
	mtrs = d[6].split()
	for mtr in mtrs:
		m = session.query(Mtr).filter_by(mtr=mtr).first()
		if not m:
			m = Mtr(mtr)
			session.save(m)
#		print "\t", m
		m.trans.append(t)
		m.nevas.append(n)
session.commit()

from sqlalchemy.sql import select, func
#s = session.query(Neva).select_from(select([func.max(neva_table.c.neva, type_=Float).label('max_neva')])).first()
#print s.neva

for m in session.query(Mtr).all():
	print m.mtr,
	delta = 0.0
	complete = 0
	total = 0
	for t in set(m.trans):
#		print "\t", t
		max_w = 0.0
		max_wo = 0.0
		for n in session.query(Neva).filter_by(trans_id=t.id):
#			print "\t\t", n
			if m in n.mtrs:
				max_w = max(max_w, n.neva)
			else:
				max_wo = max(max_wo, n.neva)
		total += 1
		if max_wo > 0:
			delta += max_w - max_wo
		else:
			complete += 1
	print delta, complete, total
