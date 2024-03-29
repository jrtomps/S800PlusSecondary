#    Copyright 2014, Michigan State University
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   @author Jeromy Tompkins <tompkins@nscl.msu.edu>


# ReadoutCallouts.tcl
#
# A base ReadoutCallouts.tcl script that will configure the S800 and one 
# secondary DAQ to be event built. The user certainly needs to make sure that
# the parameters. Certainly the user must replay the following strings:
#
#   SECONDARY_SPDAQ 
#   RING_ON_SECSPDAQ
#
# with meaningful values.
#
# Date  : 2/19/2014


set rdocalloutdir [file dirname [file normalize [info script]]]

set daqroot $env(DAQROOT) 
lappend auto_path [file join $daqroot TclLibs]
lappend auto_path $rdocalloutdir 

# load event builder package
package require evbcallouts

# load s800 data pipeline
package require S800DataPipeline

################################################################################
################################################################################
#                                                                              #
#                         PARAMETER SETUP                                      #
#                                                                              #


#   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -  #
#
#                         S800 Run Control PARAMETERS 
#
set s800id   5         ;# source id for the s800
set s800host spdaq48   ;# host where S800Daq runs
set s800port 8000      ;# port S800DAQ receives run control commands on
set s800ring s800_data ;# ring where s800 data will reside prior to 
                         ;#injection into the event builder
# tstamp extractor lib location for s800
set s800tstamplib [file join $rdocalloutdir libs800timestamp.so] 


#   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -  #
#
#                         S800 DATA PIPELINE PARAMETERS 
#
set S800DataPipeline::s800host     $s800host
set S800DataPipeline::s800DataPort 9002 
set S800DataPipeline::s800ring     $s800ring

#   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -  #

#                        SECONDARY PARAMETERS 
#
set secid 0                   ;# source id for the secondary readout
set sechost SECONDARY_SPDAQ   ;# host where readout will run 
set secring RING_ON_SPDAQ     ;# ring on sechost that readout will send data

# tstamp extractor lib location for secondary readout
set sectstamplib [file join $rdocalloutdir libsectimestamp.so] 

#------------------------------------------------------------------------------#


################################################################################
################################################################################
#                                                                              #
#                           USER-CODE HOOKS                                    # 
#                                                                              #
#                                                                              #
#


## @brief User-code hook called when "Start" button is pressed
#
# Starts up the S800 data pipeline
# Initializes the Event builder with following option
#  - enables GUI control
#  - EVB persists between runs rather than restarting for each run
#  - default correlation window = 100
#  - event builder correlates events (-glombuild)
#
proc OnStart {} {
  S800DataPipeline::initialize ;
  EVBC::initialize -gui true -restart off -glomdt 100 -glombuild true
}

## @brief User-code hook called when "Begin" button is pressed
#
# Inform event builder that a new run is starting.
#
# @param run  run number of current run
proc OnBegin run {
  EVBC::onBegin  ;# this ultimately calls startEVBSources
}

## @brief User-code hook called when "End" button is pressed
#
# @param run  run number of ending run
proc OnEnd run {
    EVBC::onEnd 
}

## @brief User-code hook to start data hoists to the event builder
#
# Sets up the ringSource clients to transfer data from raw data rings
# to the event builder. This proc is called by EVBC::onBegin
proc startEVBSources {} {
    global sechost secring sectstamplib secid
    global s800host s800ring s800tstamplib s800id

    # start the ring source for the secdaq ring
    EVBC::startRingSource tcp://$sechost/$secring $sectstamplib \
                          $secid "Secondary"
	
    # start ring source for the s800 ring, (this is part of nscldaq)
    EVBC::startRingSource tcp://localhost/$s800ring $s800tstamplib \
			$s800id "S800"

}


