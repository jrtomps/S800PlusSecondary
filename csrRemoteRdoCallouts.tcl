
set here [file dirname [info script]]
lappend auto_path [file join $::env(DAQROOT) TclLibs]
lappend auto_path $here 
puts $auto_path

package require evbcallouts
package require CSRFilter 

# Set up the remote control server
package require ReadoutGuiRemoteControl
ReadoutGuiRemoteControl %AUTO%
OutputMonitor %AUTO%

# Defines what happens when the Start button is pushed
proc OnStart {} {

  # Initialize the event builder
  # Options specify;
  #     a ring containing the ordered data
  #     gloms events within 1 clock tick
  #     restart of the event builder pipeline on each run
  #     outputs ordered fragments to orderedfrags ring
  #     outputs glommed events into scinit ring
  EVBC::initialize -teering orderedfrags -restart no -glombuild yes \
                  -glomdt 1 -destring scinti \
                  -setdestringasevtlogsource false

  # Initialize the filter. Adds some basic controls to GUI to control
  # its behavior
  ::CsrFilter::initialize
}

# This gets called by the EVBC::onBegin to set up the connection with the event builder 
proc startEVBSources {} {
    global here
  # Beware that that the source ids must match the values specified
  # for the VMUSBReadout and CCUSBReadout programs when loaded as sshPipe providers
  set vmtstamplib [file join $here libevbvmusbtstamp.so]
  set vmsourceID 0
  EVBC::startRingSource tcp://localhost/event $vmtstamplib $vmsourceID "VMUSB events"

  set cctstamplib [file join $here libevbccusbtstamp.so]
  set ccsourceID 1
  EVBC::startRingSource tcp://localhost/sclr $cctstamplib $ccsourceID "CCUSB events"

  after 1000  

}

proc OnBegin run {

  EVBC::onBegin

  ::CsrFilter::onBegin
 
} 


proc OnEnd run {
  EVBC::onEnd

}

