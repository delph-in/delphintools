bin = xml2sxml sxml2dot sxml2mtr

all:										install

clean:
	rm -f *.c *.o

cleanall:									clean
	rm -f $(bin)

install:									$(bin)
	mkdir -p ../bin/$(OS)/$(ARCH)
	install $(bin) ../bin/$(OS)/$(ARCH)/

%.o:										%.scm
	csc -O3 -c $*.scm

%:										%.o
	csc $? -o $@

.PHONY:	all clean cleanall install
