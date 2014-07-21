
CXX = g++

.PHONEY : all check clean



INSTALLDIR = /home/tompkins/eCAESAR
DAQINSTALL = /usr/devopt/nscldaq/11.0

LDFLAGS += -L$(DAQINSTALL)/lib -fPIC
CXXFLAGS += -I$(DAQINSTALL)/include -g

OBJS = csrtimestamp.o

$(OBJS) : %.o : %.c
	$(CC) $(CXXFLAGS) -fPIC -c -o $@ $^

all : $(INSTALLDIR)/libcsrtimestamp.so
# unittests

$(INSTALLDIR)/libcsrtimestamp.so : $(OBJS) 
	$(CXX) -shared -o $@ $(CXXFLAGS) $< $(LDFLAGS) \
					-Wl,-soname=libcsrtimestamp.so \
					-Wl,"-rpath=$(DAQINSTALL)/lib" -Wl,-rpath=$(INSTALLDIR)

clean :
	rm -f $(OBJS)

CXXFLAGS += $(shell cppunit-config --cflags)
LDFLAGS += $(shell cppunit-config --libs)

CHECKOBJS = csrtimestamptests.o TestRunner.o 

unittests: $(CHECKOBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS) $(INSTALLDIR)/libcsrtimestamp.so \
			-Wl,-rpath=$(INSTALLDIR)
		
	
