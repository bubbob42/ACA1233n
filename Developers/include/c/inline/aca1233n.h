#ifndef _INLINE_ACA1233N_H
#define _INLINE_ACA1233N_H

#ifndef CLIB_ACA1233N_PROTOS_H
#define CLIB_ACA1233N_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  LIBRARIES_ACA1233N_H
#include <libraries/ACA1233n.h>
#endif

#ifndef ACA1233N_BASE_NAME
#define ACA1233N_BASE_NAME ACA1233nBase
#endif

#define ACA1233_GetStatus() \
	LP0(0x1e, struct ACA1233Info *, ACA1233_GetStatus, \
	, ACA1233N_BASE_NAME)

#define ACA1233_GetCurrentSpeed() \
	LP0(0x24, struct ACAClockInfo *, ACA1233_GetCurrentSpeed, \
	, ACA1233N_BASE_NAME)

#define ACA1233_GetMaxSpeed() \
	LP0(0x2a, struct ACAClockInfo *, ACA1233_GetMaxSpeed, \
	, ACA1233N_BASE_NAME)

#define ACA1233_SetSpeed(SpeedStep) \
	LP1(0x30, BOOL, ACA1233_SetSpeed, UBYTE, SpeedStep, d0, \
	, ACA1233N_BASE_NAME)

#define ACA1233_DisableC0Mem(on_or_off) \
	LP1(0x36, BOOL, ACA1233_DisableC0Mem, UBYTE, on_or_off, d0, \
	, ACA1233N_BASE_NAME)

#define ACA1233_SwitchCPU(option) \
	LP1(0x3c, BOOL, ACA1233_SwitchCPU, BYTE, option, d0, \
	, ACA1233N_BASE_NAME)

#define ACA1233_SetWaitstates(Waitstate) \
	LP1(0x42, BOOL, ACA1233_SetWaitstates, UBYTE, Waitstate, d0, \
	, ACA1233N_BASE_NAME)

#define ACA1233_MapROM(file, option) \
	LP2(0x48, BOOL, ACA1233_MapROM, STRPTR, file, d0, LONG, option, d1, \
	, ACA1233N_BASE_NAME)

#define ACA1233_SwitchZ2Compat(on_or_off) \
	LP1(0x4e, BOOL, ACA1233_SwitchZ2Compat, UBYTE, on_or_off, d0, \
	, ACA1233N_BASE_NAME)

#endif /*  _INLINE_ACA1233N_H  */
