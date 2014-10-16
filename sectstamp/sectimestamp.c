/*
    This software is Copyright by the Board of Trustees of Michigan
    State University (c) Copyright 2014.

    You may use this software under the terms of the GNU public license
    (GPL).  The terms of this license are described at:

     http://www.gnu.org/licenses/gpl.txt

     Author:
       Jeromy Tompkins
	     NSCL
	     Michigan State University
	     East Lansing, MI 48824-1321
*/



#include <DataFormat.h>
#include <assert.h>
#include <stdint.h>
#include <stdio.h>

/**
 * This is a dummy timestamp extractor and is just a placeholder. The body must
 * be implemented appropriately for the experiment.
 *
 * @param item - the entire PHYSICS_EVENT item 
 *
 * @return uint64_t 
 * @retval 0 
 */
uint64_t
timestamp(pPhysicsEventItem item)
{
  return 0;
}

