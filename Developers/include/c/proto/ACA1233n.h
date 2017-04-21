#ifndef _PROTO_ACA1233N_H
#define _PROTO_ACA1233N_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#if !defined(CLIB_ACA1233N_PROTOS_H) && !defined(__GNUC__)
#include <clib/aca1233n_protos.h>
#endif

#ifndef __NOLIBBASE__
extern struct Library *ACA1233nBase;
#endif

#ifdef __GNUC__
#include <inline/aca1233n.h>
#elif !defined(__VBCC__)
#include <pragma/aca1233n_lib.h>
#endif

#endif	/*  _PROTO_ACA1233N_H  */
