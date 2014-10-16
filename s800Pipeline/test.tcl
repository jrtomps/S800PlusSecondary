#!/usr/bin/env wish

set here [file dirname [file normalize [info script]]]
lappend auto_path $here

package require S800DataPipeline

set ::S800DataPipeline::s800host spdaq48
set ::S800DataPipeline::s800DataPort 9002 
set ::S800DataPipeline::ring s800_eCaesar

proc ::S800DataPipeline::_formCommand {} { return [file join . repeat_hello]}

ttk::button .start -text "Start" -command {::S800DataPipeline::initialize}
grid .start

namespace eval ReadoutGUIPanel {}

proc ::ReadoutGUIPanel::Log {id class msg} {
  puts "$id $class $msg"
}
