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

DEV			= $(foreach n,$(shell seq -w 000 002),$(LOGONTMP)/$(SRC)2$(TGT).tanaka-dev-$(SRC)$(TGT)-$(n).$(LDATE).fan)
TEST		= $(foreach n,$(shell seq -w 003 005),$(LOGONTMP)/$(SRC)2$(TGT).tanaka-test-$(SRC)$(TGT)-$(n).$(LDATE).fan)
TRAIN		= $(foreach n,$(shell seq -w 006 100),$(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-$(n).$(LDATE).fan)

all:	dev test

kill:
	killall -9 alisp cheap logon

dev:	$(DEV)
test:	$(TEST)
train:	$(TRAIN)

$(LOGONTMP):
	mkdir -p $@

$(LOGONTMP)/$(SRC)2$(TGT).%.$(LDATE).fan:	$(TANAKA)/bitext/*/sub/%.txt $(LOGONTMP)
	LOGONTMP=$(LOGONTMP) $(LOGONROOT)/batch --binary --$(SRC)$(TGT) --ascii $<

.PHONY:	all kill dev test train
