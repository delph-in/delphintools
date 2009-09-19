#!/usr/bin/make

SHELL		= /bin/bash

DTHOME		?= $(HOME)/delphintools
SRC		= ja
TGT		= en
TCROOT		= $(HOME)/research/data/parallel/tanaka
TANAKA		= $(TCROOT)/tc-0906

#DATE		= $(shell date)
#SDATE		= $(shell date +"%Y%m%d")
#LDATE		= $(shell date +"%y-%m-%d")

WORK		= /work/$(USER)
TREEBANK	= $(WORK)/treebank/ja2en
RESULTS		= $(WORK)/results

LOGONLOG	= $(RESULTS)/current
LOGONTMP	= $(WORK)/tmp
LOGONROOT	= $(WORK)/logon

#CURRENT	= $(RESULTS)/$(SDATE).$(REV).$(PID)
#REV		= $(shell logon_hg_id $(LOGONROOT))
#PID		= $(shell echo $$PPID)

SUF		= aa ab ac ad ae af ag ah ai aj
DEV		= $(foreach n,$(shell seq -w 000 002),$(foreach s,$(SUF),$(LOGONLOG)/tanaka-$(n).$(SRC)$(TGT).$(s).fan))
TEST		= $(foreach n,$(shell seq -w 003 005),$(foreach s,$(SUF),$(LOGONLOG)/tanaka-$(n).$(SRC)$(TGT).$(s).fan))
TRAINA		= $(foreach n,$(shell seq -w 006 037),$(foreach s,$(SUF),$(LOGONLOG)/tanaka-$(n).$(SRC)$(TGT).$(s).fan))
TRAINB		= $(foreach n,$(shell seq -w 038 069),$(foreach s,$(SUF),$(LOGONLOG)/tanaka-$(n).$(SRC)$(TGT).$(s).fan))
TRAINC		= $(foreach n,$(shell seq -w 070 099),$(foreach s,$(SUF),$(LOGONLOG)/tanaka-$(n).$(SRC)$(TGT).$(s).fan)) $(LOGONLOG)/tanaka-100.$(SRC)$(TGT).aa.fan $(LOGONLOG)/tanaka-100.$(SRC)$(TGT).ab.fan $(LOGONLOG)/tanaka-100.$(SRC)$(TGT).ac.fan

all:	dev test rsync

kill:
	kill_logon

rsync:
	rsync -Pauvz $(WORK)/results/* $(TCROOT)/results/ && rsync -Pauvz $(WORK)/treebank/ja2en $(HOME)/tbs/

logon:
	logon_hg_update $(LOGONROOT)

setup:	logon $(RESULTS) $(LOGONTMP) $(TREEBANK)

dev:	$(DEV)
test:	$(TEST)
traina:	$(TRAINA)
trainb:	$(TRAINB)
trainc:	$(TRAINC)

current:
	(REV=$$(logon_hg_id $(LOGONROOT)) && \
	SDATE=$$(date "+%Y%m%d") && \
	CURRENT="$(RESULTS)/$$SDATE.$$REV.$$PPID" && \
	mkdir -p $$CURRENT && \
	ln -Tsf $$CURRENT $(RESULTS)/current && \
	echo "ln -Tsf $$CURRENT $(RESULTS)/current")

$(RESULTS) $(LOGONTMP):
	mkdir -p $@

$(TREEBANK):
	mkdir -p $@ && ln -Tsf $@ $(LOGONROOT)/lingo/lkb/src/tsdb/home/ja2en

$(DEV) : $(LOGONLOG)/%.fan : $(TANAKA)/bitext/dev/sub/%
	. $(LOGONROOT)/dot.bashrc && $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --limit 5:5:5:5 --ascii $<

$(TEST) : $(LOGONLOG)/%.fan : $(TANAKA)/bitext/test/sub/%
	. $(LOGONROOT)/dot.bashrc && $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --limit 5:5:5:5 --ascii $<

$(TRAINA) $(TRAINB) $(TRAINC) :  $(LOGONLOG)/%.fan : $(TANAKA)/bitext/train/sub/%
	. $(LOGONROOT)/dot.bashrc && $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --limit 3:10:5:150 --ascii $<

.PHONY:	all current logon rsync kill dev test train%
