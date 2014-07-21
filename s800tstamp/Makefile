
CXX = g++

.PHONEY : all check clean



INSTALLDIR = /home/tompkins/eCAESAR
DAQINSTALL = /usr/devopt/nscldaq/11.0

LDFLAGS += -L$(DAQINSTALL)/lib -fPIC
CXXFLAGS += -I$(DAQINSTALL)/include -g

OBJS = s800timestamp.o

$(OBJS) : %.o : %.c
	$(CC) $(CXXFLAGS) -fPIC -c -o $@ $^

all : $(INSTALLDIR)/libs800timestamp.so unittests

$(INSTALLDIR)/libs800timestamp.so : $(OBJS) 
	$(CXX) -shared -o $@ $(CXXFLAGS) $< $(LDFLAGS) \
					-Wl,-soname=libs800timestamp.so \
					-Wl,"-rpath=$(DAQINSTALL)/lib" -Wl,-rpath=$(INSTALLDIR)

clean :
	rm -f $(OBJS)

CXXFLAGS += $(shell cppunit-config --cflags)
LDFLAGS += $(shell cppunit-config --libs)

CHECKOBJS = s800timestamptests.o TestRunner.o 

unittests: $(CHECKOBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS) $(INSTALLDIR)/libs800timestamp.so \
			-Wl,-rpath=$(INSTALLDIR)
		
	
