#!/usr/bin/make

dirs = jaen enen

all:	test

clean:
	for d in $(dirs); do \
		make -C $$d clean; \
	done

test:	$(dirs)

$(dirs): %:
	make -C $* test

.PHONY: all test $(dirs)
