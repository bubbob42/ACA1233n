    IFND    LIBRARIES_ACA1233n_I
LIBRARIES_ACA1233n_I    SET     1
**
**      $VER: ACA1233n.i 1.0 (21-Jan-17)
**
**      ACA1233n.library definitions
**
**	(C)2017	by Marcus Gerards
**      All Rights Reserved.
**


        IFND    EXEC_TYPES_I
        INCLUDE 'exec/types.i'
        ENDC

;------------------------------------------------------------------------
; Generic library informations

ACA1233nNAME      MACRO
        dc.b    "ACA1233n.library",0
        ENDM

ACA1233nVERSION   EQU     1

; Card's speed stepping capabilities 
ACA1233nMAXSTEP   EQU     4
ACA1233nMINSTEP   EQU     0
 
; Arguments for ACA1233_MapROM function 
AR_MAPINT		EQU		1
AR_MAPREMOVE	EQU		-1

; Arguments for ACA1233_SwitchCPU function 
AS_MEMCARDON	EQU		0
AS_MEMCARDOFF	EQU		1

; Arguments for ACA1233_SetWaitstates function 
AW_NOWAITSTATE	EQU	 	0
AW_WAITSTATE	EQU 	1

; Arguments for ACA1233_NoC0Mem function 
AC_NOC0MEM 		EQU	 	1
AC_C0MEM		EQU		0

; Arguments for ACA1233_SwitchZ2Compat function 
AZ_Z2MODE		EQU		1
AZ_Z3MODE		EQU		0


;-----------------------------------------------------------------------
; ACA1233Info structure
;
; A pointer to this structure is returned by ACA1233n.library upon call 
; on ACA1233_GetStatus()
; It`s READ-ONLY!
 
  STRUCTURE ACA1233Info,0
	BOOL	ai_MapROM					; MapROM status bit. TRUE, if enabled 
	APTR	ai_ClockInfo				; pointer to clock speed info 
	BOOL	ai_Z2Mode					; Z2 compatibility bit.For Kick 1.3 
										; and earlier.TRUE, if enabled 
										
	BOOL	ai_NoMemcard				; Switches off card's fast memory. 
										; TRUE, if enabled 
	UWORD	ai_WriteWaitstates	 		; Number of write waitstates 
	BOOL	ai_NoC0Mem					; TRUE, if SlowRAM is disabled 
	ULONG	ai_Serial					; copy of Autoconf[tm] serial, 
										; equals rounded down version 
										; of card's maximum clock frequency 
	ULONG	ai_CurrentCPU				; the CPU currently in use (either 
										; 68020 or 68030 

;------------------------------------------------------------------------
;
; ClockInfo structure
;
; A pointer to this  structure is returned by ACA1233n.library upon call 
; on GetCurrentSpeed() and GetMaxSpeed()
; It`s READ-ONLY!

  STRUCTURE ClockInfo,0
    APTR	ci_CPUClock			; current/max CPU clock / String 
	UWORD	ci_CPUSpeedStep		; current/max CPU speed stepping
	
    ENDC
