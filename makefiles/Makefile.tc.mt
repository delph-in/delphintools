#!/usr/bin/make

DTHOME		?= $(HOME)/delphintools
SRC		= ja
TGT		= en
TCROOT		= $(HOME)/research/data/parallel/tanaka
TANAKA		= $(TCROOT)/tc-0906
WORK		= /work/$(USER)
RESULTS		= $(WORK)/results
TREEBANK	= $(WORK)/treebank/ja2en

DATE		= $(shell date)
SDATE		= $(shell date +"%Y%m%d")
LDATE		= $(shell date +"%y-%m-%d")

REV		= $(shell hg -R $(HOME)/logon.hg id -n)
PID		= $(shell echo $$PPID)
CURRENT		= $(RESULTS)/$(SDATE).$(REV).$(PID)
LOGONLOG	= $(RESULTS)/current
LOGONTMP	= $(WORK)/tmp

SUF		= aa ab ac ad ae af ag ah ai aj
DEV		= $(foreach n,$(shell seq -w 000 002),$(foreach s,$(SUF),$(LOGONLOG)/$(SRC)2$(TGT).tanaka-$(n).$(SRC)$(TGT).$(s).$(LDATE).fan))
TEST		= $(foreach n,$(shell seq -w 003 005),$(foreach s,$(SUF),$(LOGONLOG)/$(SRC)2$(TGT).tanaka-$(n).$(SRC)$(TGT).$(s).$(LDATE).fan))
TRAINA		= $(foreach n,$(shell seq -w 006 037),$(foreach s,$(SUF),$(LOGONLOG)/$(SRC)2$(TGT).tanaka-$(n).$(SRC)$(TGT).$(s).$(LDATE).fan))
TRAINB		= $(foreach n,$(shell seq -w 038 069),$(foreach s,$(SUF),$(LOGONLOG)/$(SRC)2$(TGT).tanaka-$(n).$(SRC)$(TGT).$(s).$(LDATE).fan))
TRAINC		= $(foreach n,$(shell seq -w 070 099),$(foreach s,$(SUF),$(LOGONLOG)/$(SRC)2$(TGT).tanaka-$(n).$(SRC)$(TGT).$(s).$(LDATE).fan)) $(LOGONLOG)/$(SRC)2$(TGT).tanaka-100.$(SRC)$(TGT).aa.$(LDATE).fan $(LOGONLOG)/$(SRC)2$(TGT).tanaka-100.$(SRC)$(TGT).ab.$(LDATE).fan $(LOGONLOG)/$(SRC)2$(TGT).tanaka-100.$(SRC)$(TGT).ac.$(LDATE).fan

all:	dev test rsync

kill:
	kill_logon

rsync:
	rsync -Pauvz $(WORK)/results/* $(TCROOT)/results/ && rsync -Pauvz $(WORK)/treebank/ja2en $(HOME)/tbs/

dev:	$(DEV)
test:	$(TEST)
traina:	$(TRAINA)
trainb:	$(TRAINB)
trainc:	$(TRAINC)

current:	$(CURRENT)
	ln -Tsf $(CURRENT) $(RESULTS)/current

$(CURRENT) $(RESULTS) $(LOGONTMP):
	mkdir -p $@

$(TREEBANK):
	mkdir -p $@ && ln -Tsf $@ $(LOGONROOT)/lingo/lkb/src/tsdb/home/ja2en

$(LOGONLOG):	$(RESULTS) $(LOGONTMP) $(TREEBANK)

$(DEV) : $(LOGONLOG)/$(SRC)2$(TGT).%.$(LDATE).fan : $(TANAKA)/bitext/dev/sub/% $(LOGONLOG) $(RESULTS) $(LOGONTMP) $(TREEBANK)
	unset DISPLAY && unset LUI && $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --limit 5:5:5:5 --ascii $<

$(TEST) : $(LOGONLOG)/$(SRC)2$(TGT).%.$(LDATE).fan : $(TANAKA)/bitext/test/sub/% $(LOGONLOG) $(RESULTS) $(LOGONTMP) $(TREEBANK)
	unset DISPLAY && unset LUI && $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --limit 5:5:5:5 --ascii $<

$(TRAINA) $(TRAINB) $(TRAINC) :  $(LOGONLOG)/$(SRC)2$(TGT).%.$(LDATE).fan : $(TANAKA)/bitext/train/sub/% $(LOGONLOG) $(RESULTS) $(LOGONTMP) $(TREEBANK)
	unset DISPLAY && unset LUI && $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --limit 3:10:5:150 --ascii $<

.PHONY:	all current rsync kill dev test train%
