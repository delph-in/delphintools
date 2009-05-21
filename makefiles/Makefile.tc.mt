#!/usr/bin/make

DTHOME	?= $(HOME)/delphintools
SRC		= ja
TGT		= en
TANAKA	= $(HOME)/research/data/parallel/tanaka
RESULTS	= $(TANAKA)/results

DATE 	= $(shell date)
SDATE	= $(shell date -d "$(DATE)" +"%Y%m%d")
LDATE	= $(shell date -d "$(DATE)" +"%y-%m-%d")

LOGONTMP = $(RESULTS)/$(SDATE)

DEV	= $(LOGONTMP)/$(SRC)2$(TGT).tanaka-dev-$(SRC)$(TGT)-000.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-dev-$(SRC)$(TGT)-001.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-dev-$(SRC)$(TGT)-002.$(LDATE).fan

TEST	= $(LOGONTMP)/$(SRC)2$(TGT).tanaka-test-$(SRC)$(TGT)-003.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-test-$(SRC)$(TGT)-004.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-test-$(SRC)$(TGT)-005.$(LDATE).fan

TRAIN	= $(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-006.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-007.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-008.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-009.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-010.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-011.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-012.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-013.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-014.$(LDATE).fan \
	  $(LOGONTMP)/$(SRC)2$(TGT).tanaka-train-$(SRC)$(TGT)-015.$(LDATE).fan

all:	dev test

kill:
	killall -9 alisp cheap logon

dev:	$(DEV) $(LOGONTMP)
	$(MAKE) -C $(LOGONTMP) $@

test:	$(TEST) $(LOGONTMP)
	$(MAKE) -C $(LOGONTMP) $@

train:	$(TRAIN) $(LOGONTMP)
	$(MAKE) -C $(LOGONTMP) $@

$(LOGONTMP):
	mkdir -p $@

$(LOGONTMP)/$(SRC)2$(TGT).%.$(LDATE).fan:	$(TANAKA)/bitext/*/sub/%.txt \
						$(LOGONTMP) \
						$(HOME)/mosestools/makefiles/Makefile.evaluation
	(rm -f $(HOME)/fans && ln -sf $(LOGONTMP) $(HOME)/fans && \
	cp $(DTHOME)/makefiles/Makefile.tc.mt.eval $(LOGONTMP)/Makefile && \
	$(LOGONROOT)/batch --binary --$(SRC)$(TGT) --ascii $<)

.PHONY:	all kill dev test
