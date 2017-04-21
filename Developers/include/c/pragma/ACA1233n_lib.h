#ifndef _INCLUDE_PRAGMA_ACA1233N_LIB_H
#define _INCLUDE_PRAGMA_ACA1233N_LIB_H

#ifndef CLIB_ACA1233N_PROTOS_H
#include <clib/aca1233n_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(ACA1233nBase,0x01e,ACA1233_GetStatus())
#pragma amicall(ACA1233nBase,0x024,ACA1233_GetCurrentSpeed())
#pragma amicall(ACA1233nBase,0x02a,ACA1233_GetMaxSpeed())
#pragma amicall(ACA1233nBase,0x030,ACA1233_SetSpeed(d0))
#pragma amicall(ACA1233nBase,0x036,ACA1233_DisableC0Mem(d0))
#pragma amicall(ACA1233nBase,0x03c,ACA1233_SwitchCPU(d0))
#pragma amicall(ACA1233nBase,0x042,ACA1233_SetWaitstates(d0))
#pragma amicall(ACA1233nBase,0x048,ACA1233_MapROM(d0,d1))
#pragma amicall(ACA1233nBase,0x04e,ACA1233_SwitchZ2Compat(d0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall ACA1233nBase ACA1233_GetStatus      01e 00
#pragma  libcall ACA1233nBase ACA1233_GetCurrentSpeed 024 00
#pragma  libcall ACA1233nBase ACA1233_GetMaxSpeed    02a 00
#pragma  libcall ACA1233nBase ACA1233_SetSpeed       030 001
#pragma  libcall ACA1233nBase ACA1233_DisableC0Mem   036 001
#pragma  libcall ACA1233nBase ACA1233_SwitchCPU      03c 001
#pragma  libcall ACA1233nBase ACA1233_SetWaitstates  042 001
#pragma  libcall ACA1233nBase ACA1233_MapROM         048 1002
#pragma  libcall ACA1233nBase ACA1233_SwitchZ2Compat 04e 001
#endif

#endif	/*  _INCLUDE_PRAGMA_ACA1233N_LIB_H  */
