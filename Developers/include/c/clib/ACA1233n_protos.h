#ifndef CLIB_ACA1233n_PROTOS_H
#define CLIB_ACA1233n_PROTOS_H

/*
**      $VER: ACA1233n_protos.h 1.0 (15.08.2016)
**
**      ACA1233n.library proto types
**
**		(C)2016 by Marcus Gerards
**      All Rights Reserved.
*/

#include <libraries/ACA1233n.h>

/* ACA1233n protos */

struct ACA1233Info *ACA1233_GetStatus(void);
struct ACAClockInfo *ACA1233_GetCurrentSpeed(void);
struct ACAClockInfo *ACA1233_GetMaxSpeed(void);
BOOL ACA1233_SetSpeed(UBYTE);
BOOL ACA1233_DisableC0Mem(UBYTE);
BOOL ACA1233_SwitchCPU(BYTE);
BOOL ACA1233_NoMemcard(void);
BOOL ACA1233_SetWaitstates(UBYTE);
BOOL ACA1233_MapROM(STRPTR, LONG);
BOOL ACA1233_SwitchZ2Compat(UBYTE);

#endif	/* CLIB_ACA1233n_PROTOS_H */
