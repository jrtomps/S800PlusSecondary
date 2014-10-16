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

OBJS = sectimestamp.o


all : $(INSTALLDIR)/libsectimestamp.so

$(OBJS) : %.o : %.c
	$(CC) $(CXXFLAGS) -fPIC -c -o $@ $^

# unittests

$(INSTALLDIR)/libsectimestamp.so : $(OBJS) 
	$(CXX) -shared -o $@ $(CXXFLAGS) $< $(LDFLAGS) \
					-Wl,-soname=libsectimestamp.so \
					-Wl,"-rpath=$(DAQINSTALL)/lib" -Wl,-rpath=$(INSTALLDIR)

clean :
	rm -f $(OBJS)

