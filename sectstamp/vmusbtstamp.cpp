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


#include  <stdint.h>
#include  <assert.h>
#include  <DataFormat.h>


// Make sure we create C-style symbols in the dynamic library
extern "C" {

  /**! Timestamp extractor for physics events
   *
   * A hook for the user to define the tstamp extraction algorithm for data 
   * read by the event stack. The pointer provided points to the event header,
   * which is just the exclusive size of the event body in 16-bit units. 
   *
   * This implementation expects that the 64-bits of data following the
   * event header are the tstamp.
   *
   * \param item  - pointer to the body of physics event (i.e. event header)
   *
   * \returns tstamp
   */
  uint64_t  getEventTimestamp(void* item)
  {
    // initialize the return value
    uint64_t time=0;

    // interpet the data as a bunch of 16-bit integers for sake of skipping 
    // event header
    uint16_t* body = reinterpret_cast<uint16_t*>(item);

    // skip the event header (exclusive size of event in units of 16-bit words)
    body++;

    // The tstamp is the first 64-bits of the event, so recast the pointer
    // and dereference it to get the tstamp
    uint64_t* pTstamp = reinterpret_cast<uint64_t*>(body);
    time = *pTstamp;

    // done.
    return time;
  }



  /**! Timestamp extractor for scaler items
   *
   * This receives a pointer to the data from a scaler stack execution. The
   * first 16-bits pointed to are the event header containing the number of
   * 16-bit words to follow and also the stack id=1 identifier. 
   *
   * In this example, the clock went into the 239th scaler channel. Each of the
   * 238 scaler channels before it were 24-bits wide but read out from the
   * module as 32-bits each.
   *
   * \param item  - pointer to the body of physics event (i.e. event header)
   *
   * \returns tstamp
   */
  uint64_t  getScalerTimestamp(void* item)
  {

    // interpret the memory as 16-bit units to skip over the event header
    uint16_t* pItem = reinterpret_cast<uint16_t*>(item);
    ++pItem;
    
    // reinterpret the memory pointed to as 32-bit units for skipping channels.
    uint32_t* pBody = reinterpret_cast<uint32_t*>(pItem);

    // We have to form the 64-bit tstamp from two 24-bit entities.
    int channel_offset = 238;
    uint64_t rawtime0 = *(pBody+channel_offset);
    uint64_t rawtime1 = *(pBody+channel_offset+1);

    // make sure that we combine only 24-bit elements.
    uint64_t incrtime0 = (rawtime0 & 0xffffff);
    uint64_t incrtime1 = (rawtime1 & 0xffffff);

    // make the 48-bit scaler from the two 
    uint64_t time = (incrtime1<<24)|incrtime0;

    // done
    return time;
  }

}
