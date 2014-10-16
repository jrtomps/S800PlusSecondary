#
#    This software is Copyright by the Board of Trustees of Michigan
#    State University (c) Copyright 2014.
#
#    You may use this software under the terms of the GNU public license
#    (GPL).  The terms of this license are described at:
#
#     http://www.gnu.org/licenses/gpl.txt
#
#     Author:
#       Jeromy Tompkins
#	     NSCL
#	     Michigan State University
#	     East Lansing, MI 48824-1321

CXX = g++

.PHONEY : all check clean



INSTALLDIR = ../.

LDFLAGS += -L$(DAQROOT)/lib -fPIC
CXXFLAGS += -I$(DAQROOT)/include -g

OBJS = s800timestamp.o

all : $(INSTALLDIR)/libs800timestamp.so unittests

$(INSTALLDIR)/libs800timestamp.so : $(OBJS) 
	$(CXX) -shared -o $@ $(CXXFLAGS) $< $(LDFLAGS) \
					-Wl,-soname=libs800timestamp.so \
					-Wl,"-rpath=$(DAQROOT)/lib" -Wl,-rpath=$(INSTALLDIR)

$(OBJS) : %.o : %.c
	$(CC) $(CXXFLAGS) -fPIC -c -o $@ $^

clean :
	rm -f $(OBJS)

CXXFLAGS += $(shell cppunit-config --cflags)
LDFLAGS += $(shell cppunit-config --libs)

CHECKOBJS = s800timestamptests.o TestRunner.o 

unittests: $(CHECKOBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS) $(INSTALLDIR)/libs800timestamp.so \
			-Wl,-rpath=$(INSTALLDIR)
		
	
