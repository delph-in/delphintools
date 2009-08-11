#!/usr/bin/make

DTHOME		?= $(HOME)/delphintools
SRC			= ja
TGT			= en
TCROOT		= $(HOME)/research/data/parallel/tanaka
TANAKA		= $(TCROOT)/tc-0906
RESULTS		= $(TCROOT)/results

DATE		= $(shell date)
SDATE		= $(shell date -d "$(DATE)" +"%Y%m%d")
LDATE		= $(shell date -d "$(DATE)" +"%y-%m-%d")

LOGONTMP	= $(RESULTS)/$(SDATE)

SUF		= aa ab ac ad ae af ag ah ai aj
DEV		= $(foreach n,$(shell seq -w 000 002),$(foreach s,$(SUF),$(SRC)2$(TGT).tanaka-$(n).$(SRC)$(TGT).$(s).$(LDATE).fan))
TEST		= $(foreach n,$(shell seq -w 003 005),$(foreach s,$(SUF),$(SRC)2$(TGT).tanaka-$(n).$(SRC)$(TGT).$(s).$(LDATE).fan))
TRAINA		= $(foreach n,$(shell seq -w 006 037),$(SRC)2$(TGT).tanaka-$(n).$(SRC)$(TGT).$(LDATE).fan)
TRAINB		= $(foreach n,$(shell seq -w 038 069),$(SRC)2$(TGT).tanaka-$(n).$(SRC)$(TGT).$(LDATE).fan)
TRAINC		= $(foreach n,$(shell seq -w 070 100),$(SRC)2$(TGT).tanaka-$(n).$(SRC)$(TGT).$(LDATE).fan)

all:	dev test

kill:
	killall -9 alisp cheap logon

dev:	$(DEV)
test:	$(TEST)
traina:	$(TRAINA)
trainb:	$(TRAINB)
trainc:	$(TRAINC)

$(LOGONTMP):
	mkdir -p $@

$(DEV) : $(SRC)2$(TGT).%.$(LDATE).fan : $(TANAKA)/bitext/dev/sub/%
	unset DISPLAY && unset LUI &&  $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --limit 5:5:5:125 --ascii $<

$(TEST) : $(SRC)2$(TGT).%.$(LDATE).fan : $(TANAKA)/bitext/test/sub/%
	unset DISPLAY && unset LUI &&  $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --limit 5:5:5:125 --ascii $<

$(TRAINA) $(TRAINB) $(TRAINC) :  $(SRC)2$(TGT).%.$(LDATE).fan : $(TANAKA)/bitext/train/sub/%
	unset DISPLAY && unset LUI &&  $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --limit 3:10:5:150 --ascii $<

.PHONY:	all kill dev test train
