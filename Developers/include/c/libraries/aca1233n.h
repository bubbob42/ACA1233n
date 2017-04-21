#ifndef LIBRARIES_ACA1233n_H
#define LIBRARIES_ACA1233n_H

/*
**      $VER: ACA1233n.h 1.1 (12.08.2016)
**    
**
**      ACA1233n.library definitions
**
**	(C)2016 by Marcus Gerards
**      All Rights Reserved.
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

/* Generic library information */
#define ACA1233nNAME     "ACA1233n.library"
#define ACA1233nVERSION  1

/* Card's speed stepping capabilities */
#define ACA1233nMAXSTEP  4
#define ACA1233nMINSTEP  0        

/* Arguments for ACA1233_MapROM function */
#define AR_MAPINT        1	
#define AR_MAPREMOVE	-1

/* Arguments for ACA1233_SwitchCPU function */
#define AS_MEMCARDON	 0
#define AS_MEMCARDOFF	 1

/* Arguments for ACA1233_SetWaitstates function */
#define AW_NOWAITSTATE	 0	
#define AW_WAITSTATE	 1

/* Arguments for ACA1233_NoC0Mem function */
#define AC_NOC0MEM		 1	
#define AC_C0MEM		 0

/* Arguments for ACA1233_SwitchZ2Compat function */
#define AZ_Z2MODE		 1	
#define AZ_Z3MODE		 0


/*-----------------------------------------------------------------------
 ACA1233Info structure

 A pointer to this structure is returned by ACA1233n.library upon call 
 on ACA1233_GetStatus()
 It`s READ-ONLY!
 */

struct ACA1233Info {
	BOOL	ai_MapROM;					/* MapROM status bit. TRUE, if enabled */
	struct	ACAClockInfo *ai_ClockInfo;/* pointer to clock speed info */
	BOOL	ai_Z2Mode;					/* Z2 compatibility bit.For Kick 1.3 */
										/* and earlier.TRUE, if enabled */
	BOOL	ai_NoMemcard;				/* Switches off card's fast memory. */
										/* TRUE, if enabled */
	UWORD	ai_WriteWaitstates; 		/* Number of write waitstates */
	BOOL	ai_NoC0Mem;					/* TRUE, if SlowRAM is disabled */						
	ULONG	ai_Serial;					/* copy of Autoconf[tm] serial, */
										/* equals rounded down version */
										/* of card's maximum clock frequency */
	ULONG	ai_CurrentCPU;				/* the CPU currently in use (either */
										/* 68020 or 68030 */
};



/*-----------------------------------------------------------------------
 ACAClockInfo structure

 A pointer to this structure is returned by ACA1233n.library upon call 
 on GetCurrentSpeed() and GetMaxSpeed()
 It`s READ-ONLY!
 */

struct ACAClockInfo {
    STRPTR	ci_CPUClock;		/* current/max CPU clock */
    UWORD	ci_CPUSpeedStep;	/* current/max CPU speed stepping */	
};

#endif /* LIBRARIES_ACA1233n_H */

