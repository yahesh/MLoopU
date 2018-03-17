/* mloopu.c */ 

/*// Please, don't delete this comment. \\*/
/*
  Copyright Owner: Yahe
  Copyright Year : 2007-2018

  Unit   : mloopu (platform independant)
  Version: 0.1a1

  Contact E-Mail: hello@yahe.sh
*/
/*// Please, don't delete this comment. \\*/

/*
  Description:

  Implements a loop that can (theoretically) be nested infinitely.
*/

/*
  Change Log:

  [Version 0.1a1] (11.01.2007: initial release)
  - multiloopi() implemented
  - multiloopr() implemented
*/

typedef struct tloopdata_struct 
{ 
  int index; 
  int start; 
  int stop; 
} tloopdata; 

int multiloopi(tloopdata aloopdataarray[], int aloopdataarraylength, int (*aloopmethod) (tloopdata aloopdataarray[], int aloopdataarraylength)) 
{ 
  int lindex; 
  int llooplevel; 
  int lresult; 
  
  lresult = 0; 
  
  if ((aloopdataarraylength > 0) && (aloopdataarray != 0)) 
  { 
    for (lindex = 0; lindex < aloopdataarraylength; lindex++) 
    { 
      aloopdataarray[lindex].index = aloopdataarray[lindex].start; 
    } 
    
    llooplevel = (aloopdataarraylength - 1); 
    while (llooplevel >= 0) 
    { 
      lresult = lresult + aloopmethod(aloopdataarray, aloopdataarraylength); 
      if (lresult != 0) 
      { 
        break; 
      } 

      while (aloopdataarray[llooplevel].index >= aloopdataarray[llooplevel].stop) 
      { 
        llooplevel--; 
        
        if (llooplevel < 0) 
        { 
          break; 
        }                
      } 
      if (llooplevel >= 0) 
      { 
        aloopdataarray[llooplevel].index++; 
        for (lindex = llooplevel + 1; lindex < aloopdataarraylength; lindex++) 
        { 
          aloopdataarray[lindex].index = aloopdataarray[lindex].start; 
        } 
        llooplevel = (aloopdataarraylength - 1); 
      } 
    } 
  } 
  
  return lresult; 
} 

int recursivemultiloopr(tloopdata aloopdataarray[], int aloopdataarraylength, int (*aloopmethod) (tloopdata aloopdataarray[], int aloopdataarraylength), int alooplevel) 
{ 
  int lresult; 
  
  lresult = 0; 
  
  if ((alooplevel >= 0) && (alooplevel <= (aloopdataarraylength - 1))) 
  { 
    for (aloopdataarray[alooplevel].index = aloopdataarray[alooplevel].start; aloopdataarray[alooplevel].index <= aloopdataarray[alooplevel].stop; aloopdataarray[alooplevel].index++) 
    { 
      if (alooplevel < (aloopdataarraylength - 1)) 
      { 
        lresult = lresult + recursivemultiloopr(aloopdataarray, aloopdataarraylength, aloopmethod, (alooplevel + 1)); 
      } 
      else 
      { 
        lresult = lresult + aloopmethod(aloopdataarray, aloopdataarraylength); 
      } 
      
      if (lresult != 0) 
      { 
        break; 
      } 
    } 
  } 
  
  return lresult; 
} 

int multiloopr(tloopdata aloopdataarray[], int aloopdataarraylength, int (*aloopmethod) (tloopdata aloopdataarray[], int aloopdataarraylength)) 
{ 
  int lresult; 
  
  lresult = 0; 

  if ((aloopdataarraylength > 0) && (aloopdataarray != 0)) 
  { 
    lresult = recursivemultiloopr(aloopdataarray, aloopdataarraylength, aloopmethod, 0); 
  }  
  
  return lresult; 
}
