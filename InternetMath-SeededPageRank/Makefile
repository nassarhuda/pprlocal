
UNAME := $(shell uname)
ifeq ($(UNAME),Linux)
	SHAREDLIB_EXT := so
	SHAREDLIB_FLAG := -shared
endif
ifeq ($(UNAME),Darwin)
	SHAREDLIB_EXT := dylib
	SHAREDLIB_FLAG := -dynamiclib
endif

CURDIR := $(shell pwd)
BISQUIKLIBNAME := $(CURDIR)/libbisquik.$(SHAREDLIB_EXT)
SFUTILLIBNAME := $(CURDIR)/libsfutil.$(SHAREDLIB_EXT)


CC:=$(CXX)
CXXFLAGS += -std=c++0x -U__STRICT_ANSI__ -O3
all: bisquik

.PHONY: all clean perf

OBJS=bisquik.o sf_util.o

bisquik.o: bisquik_opts.hpp sparfun_util.h

bisquik: $(OBJS)
	g++ $(CXXFLAGS) -fPIC -c bisquik.cc sf_util.cc
	g++ $(SHAREDLIB_FLAG) -o $(SFUTILLIBNAME) sf_util.o
	g++ $(SHAREDLIB_FLAG) -o $(BISQUIKLIBNAME) $(SFUTILLIBNAME) bisquik.o sf_util.o
	
        # used to use this to fix lib paths:
        # export LD_LIBRARY_PATH=$(CURDIR):$$LD_LIBRARY_PATH
	

perf: bisquik
	time -p ./bisquik as-22july06.smat.degs -t 50 --graphfile test.perf --seed 1
	rm -rf test.perf
	
clean:
	$(RM) -rf $(OBJS) bisquik
	$(RM) -rf $(BISQUIKLIBNAME) $(SFUTILLIBNAME) bisquik
