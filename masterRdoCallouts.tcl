# ReadoutCallouts.tcl
#
# Author: Jeromy Tompkins <tompkins@nscl.msu.edu>
# Date  : 2/19/2014

set rdocalloutdir [file dirname [file normalize [info script]]]

set daqroot $env(DAQROOT) 
lappend auto_path [file join $daqroot TclLibs]

# load event builder package
package require evbcallouts


########################################################################
########################################################################
#
#    Set up parameters for the data sources
# ----------------------------------------------------------------------

# Set up the csr
set csrhost spdaq45 
set csrring filt 
set csrtstamplib [file join $rdocalloutdir libcsrtimestamp.so] 
set csrid 0

# Set up the s800 
# s800::s800Host is set in .bashrc S800_HOST
set s800host spdaq48 
# s800::s800Port is set in .bashrc S800_PORT
set s800port 8000 
# s800::s800Ring is set in .bashrc S800_RING
set s800ring s800_eCaesar
#set s800tstamplib [file join $daqroot lib libS800Timestamp.so]
set s800tstamplib [file join $rdocalloutdir libs800timestamp.so]
set s800id 5


# VMUSB daqconfig script
set daqconfig [file join $rdocalloutdir daqconfig.tcl]

########################################################################
########################################################################
#
#    Define ReadoutCallouts proc to define start/begin/end procedures
# ----------------------------------------------------------------------

proc OnStart {} {
    EVBC::initialize -gui true -restart off -glomdt 100 -glombuild true
}

proc OnBegin run {
    EVBC::onBegin 
}

proc OnEnd run {
    EVBC::onEnd 
}

# Sets up the ringSource clients to transfer data from raw data rings
# to the event builder. This proc is called by EVBC::onBegin
proc startEVBSources {} {
    global csrhost csrring csrtstamplib csrid
    global s800host s800ring s800tstamplib s800id

    # start the ring source for the csrdaq ring
    EVBC::startRingSource tcp://$csrhost/$csrring $csrtstamplib \
                          $csrid "CAESAR"
	
    # start ring source for the s800 ring, (this is part of nscldaq)
#    EVBC::startS800Source tcp://localhost/$s800ring $s800id
    EVBC::startRingSource tcp://localhost/$s800ring $s800tstamplib \
			$s800id "S800"

}


#################################################################
#################################################################
## Utility procs

proc saveConfigScript {} {
	puts "Saving config script"

	global daqconfig
	
	# Figure out where to stick the daqconfig file
	set currentDir [::ExpFileSystem::WhereisCurrentData]
		
	# force overwriting the daq config file every run
	file copy -force $daqconfig $currentDir
}

