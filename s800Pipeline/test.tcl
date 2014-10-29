#!/usr/bin/env wish

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
