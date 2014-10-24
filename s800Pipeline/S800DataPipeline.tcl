
# S800DataPipeline for ReadoutCallouts.tcl
#
# This starts up the data pipeline to pull data from the output of the S800DAQ
# eventbuilder, convert it to NSCLDAQ ring item format, and then drop it into 
# a ringbuffer on the local machine.
#

package provide S800DataPipeline 1.0

package require ring


namespace eval ::S800DataPipeline {
    variable execPath     $::env(DAQROOT)/bin/s800toring
    variable pipe         -1
    variable line         ""
    variable s800host     spdaq48
    variable s800DataPort 9002
    variable s800ring     s800_data
}

# Here we just want to start up the pipeline. That is all we ever care
# to do. The rest of this namespace code is to facilitate starting the
# the pipeline and reading output from it.
proc ::S800DataPipeline::initialize {} {

  ::S800DataPipeline::cleanup
  ::S800DataPipeline::_startPipeline
}


## @brief Figure out the process that was producing data for local S800 ring
#         during the previous run
#
proc ::S800DataPipeline::getProducerID {} {

  if {[catch {
    set fullUsage [ringbuffer usage $::S800DataPipeline::s800ring]
  } msg] == 0} {
  
    return [lindex $fullUsage 3]

  } else {
    return -1    
  }
  
}



## @brief Kill off any preexisting producer
#
proc ::S800DataPipeline::cleanup {} {
  set pid [::S800DataPipeline::getProducerID]
  if {$pid > 0} {
    exec kill $pid
  }
}

###############################################
###############################################
#
# Private utilities
#

# Generate the command for running the filter based on
# the variable values in the S800DataPipeline namespace
proc ::S800DataPipeline::_formCommand {} {
  variable s800host
  variable s800DataPort
  variable s800ring 

  set command "$S800DataPipeline::execPath $s800host $s800DataPort $s800ring"

  return $command
}


# Setup the filter to run as a subprocess.
# we will capture all of the output. We are sending the
# data to a ring data sink so we don't have to worry about data
# being sent on stdout 
# When the pipe is readable, we will display the messages on the log
# window
proc ::S800DataPipeline::_startPipeline {} {

  set ::S800DataPipeline::pipe [open "| [list {*}[ ::S800DataPipeline::_formCommand ] ] |& cat" r ]
  chan configure $::S800DataPipeline::pipe -blocking 0
  chan configure $::S800DataPipeline::pipe -buffering line
  chan event $::S800DataPipeline::pipe readable {::S800DataPipeline::_readInput $::S800DataPipeline::pipe} 

  # Log that the pipeline started up to the OutputWindow
  ReadoutGUIPanel::Log S800DataPipeline output "S800 Data pipeline started"

}


## @brief Callback for when the pipeline is readable
#
# Anything read from the pipe will end up in a tab called S800DataPipeline
#
# @param channel the i/o channel to read from
#
proc ::S800DataPipeline::_readInput {channel} {

  set pipe $channel 

  # check for end of file condition
  if { [eof $pipe] } {
     # we don't want to read anymore... so unregister the event callback
     chan event $pipe readable ""

     # close the channel
     catch {close $pipe} message

     # if this is the pipe we last opened, then reset the pipeline channel 
     # It is most likely that the eof will be from a different channel that was last opened. 
     if {$pipe eq $::S800DataPipelie::pipe} {
       set ::S800DataPipeline::pipe -1
     }

     ReadoutGUIPanel::Log S800DataPipeline warning "S800 Data pipeline exited unexpectedly!"
     tk_messageBox -icon error -message "S800 Data pipeline exited unexpectedly!"
  } else {
    # Read as much input as possible
    set input [read $pipe ]

    if {[string length $input] > 0} {

      # glue the existing message with newly read message and name it data
      append data $::S800DataPipeline::line $input

      # message has an end line
      if {[string first "\n" $data] != -1} {
        set data [string trim $data "\n"]
        ReadoutGUIPanel::Log S800DataPipeline log $data 
        set ::S800DataPipeline::line "" 
      }

    }

  }
}
