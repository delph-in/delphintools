#!/usr/bin/make

DTHOME		?= $(HOME)/delphintools
SRC			= ja
TGT			= en
TANAKA		= $(HOME)/research/data/parallel/tanaka
RESULTS		= $(TANAKA)/results

DATE		= $(shell date)
SDATE		= $(shell date -d "$(DATE)" +"%Y%m%d")
LDATE		= $(shell date -d "$(DATE)" +"%y-%m-%d")

LOGONTMP	= $(RESULTS)/$(SDATE)

SUF		= aa ab ac ad ae af ag ah ai aj
DEV		= $(foreach n,$(shell seq -w 000 002),$(foreach s,$(SUF),$(SRC)2$(TGT).tanaka-dev-$(SRC)$(TGT)-$(n)-$(s).$(LDATE).fan))
TEST		= $(foreach n,$(shell seq -w 003 005),$(foreach s,$(SUF),$(SRC)2$(TGT).tanaka-test-$(SRC)$(TGT)-$(n)-$(s).$(LDATE).fan))
TRAINA		= $(foreach n,$(shell seq -w 006 037),$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-$(n).$(LDATE).fan)
TRAINB		= $(foreach n,$(shell seq -w 038 069),$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-$(n).$(LDATE).fan)
TRAINC		= $(foreach n,$(shell seq -w 070 100),$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-$(n).$(LDATE).fan)

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

$(SRC)2$(TGT).%.$(LDATE).fan:	$(TANAKA)/bitext/*/sub/%.txt
	unset DISPLAY && unset LUI &&  $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --ascii $<

.PHONY:	all kill dev test train
