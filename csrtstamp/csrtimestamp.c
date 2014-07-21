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


/**
 * This is a timestamp extractor for s800 data.
 *  The structure of an s800 event body from the ring buffers is:
 * \verbatim
 * +----------------------------------+
 * | Words in event (32 bits)         |
 * +----------------------------------+
 * | S800 packet size                 |
 * +----------------------------------+
 * | S800_PACKET (16 bits)            |
 * +----------------------------------+
 * | first packet size (16 bits)      |
 * +----------------------------------+
 * | S800_xxxx (16 bits)              |
 * +----------------------------------+
 * | sub packet payload               |
 *     ....
 * +----------------------------------+
 *
 * \endverbatim
 */


#include <DataFormat.h>
#include <assert.h>
#include <stdint.h>
#include <stdio.h>

/**
 * This is a dummy timestamp extractor and is just a placeholder. 
 * Because the Caesar data will already be assigned a timestamp 
 * in the body header. The ringFragmentSource will always just take 
 * that value and disregard this function.
 *
 * @param pEvent - void* pointer to the event
 *
 * @return uint64_t 
 * @retval 0 
 */
uint64_t
timestamp(pPhysicsEventItem item)
{
  return 0;
}

