* ACA1233n.library
* simple interface to the card's settings

	opt ow+,o+,d-
	MACHINE MC68020

	incdir	"NDK_39:include/include_i/"
	
	include	"exec/memory.i"
	include "exec/initializers.i"
	include "exec/libraries.i"
	include "lvo/exec_lib.i"
	include "lvo/dos_lib.i"
	include "lvo/expansion_lib.i"
	include	"dos/dos.i"

* setting this flag produces a dummy library which 
* "behaves" like the real thing and does not depend
* on the presence of an ACA1233n
DEBUG		equ		0

	IFNE DEBUG	
		OUTPUT	ACA1233ndebug.library
		opt DEBUG XDEBUG SYMTAB
	ENDC


******** ACA Interface memory adresses **************

ACA_AutoConfigBase			equ		$40000000
ACA_LowerMapROM				equ		$47f00000
ACA_UpperMapROM				equ		$47f80000
ACA_LowerROMMirror			equ		$1e00000
ACA_UpperROMMirror			equ		$1f80000
ACA_RegisterBase			equ		$47e80000
ACA_UnlockSet0				equ		ACA_RegisterBase+$f000
ACA_UnlockReset0			equ		ACA_UnlockSet0+$20
ACA_UnlockSet1				equ		ACA_RegisterBase+$f002
ACA_UnlockReset1			equ		ACA_UnlockSet1+$20
ACA_UnlockSet2				equ		ACA_RegisterBase+$f004
ACA_UnlockReset2			equ		ACA_UnlockSet2+$20
ACA_UnlockSet3				equ		ACA_RegisterBase+$f006
ACA_UnlockReset3			equ		ACA_UnlockSet3+$20
ACA_MapROMSet				equ		ACA_RegisterBase+$f008
ACA_MapROMReset				equ		ACA_MapROMSet+$20
ACA_MapROMStatus			equ		ACA_MapROMSet
ACA_Z2ModeSet				equ		ACA_RegisterBase+$f00a
ACA_Z2ModeReset				equ		ACA_Z2ModeSet+$20
ACA_ClockDivideEnable		equ		ACA_RegisterBase+$f00c
ACA_ClockDivideReset		equ		ACA_ClockDivideEnable+$20
ACA_ClockDivisor0			equ		ACA_RegisterBase+$f00e
ACA_ClockDivisor0Reset		equ		ACA_ClockDivisor0+$20
ACA_ClockDivisor1			equ		ACA_RegisterBase+$f010
ACA_ClockDivisor1Reset		equ		ACA_ClockDivisor1+$20
ACA_Status0					equ		ACA_RegisterBase+$f008
ACA_Status1					equ		ACA_RegisterBase+$f00a
ACA_CPUSwitch				equ		ACA_RegisterBase+$f014
ACA_NoMemcard				equ		ACA_RegisterBase+$f012
ACA_NoMemcardReset			equ		ACA_NoMemcard+$20
ACA_Waitstates				equ		ACA_RegisterBase+$f016
ACA_WaitstatesReset			equ		ACA_Waitstates+$20
ACA_NoC0Mem					equ		ACA_RegisterBase+$f018
ACA_NoC0MemReset			equ		ACA_NoC0Mem+$20

ACA_020RegisterBase			equ		$b8f000
ACA_020UnlockSet0			equ		ACA_020RegisterBase
ACA_020UnlockReset0			equ		ACA_020UnlockSet0+$20
ACA_020UnlockSet1			equ		ACA_020RegisterBase+$2
ACA_020UnlockReset1			equ		ACA_020UnlockSet1+$20
ACA_020UnlockSet2			equ		ACA_020RegisterBase+$4
ACA_020UnlockReset2			equ		ACA_020UnlockSet2+$20
ACA_020UnlockSet3			equ		ACA_020RegisterBase+$6
ACA_020UnlockReset3			equ		ACA_020UnlockSet3+$20
ACA_020MapROMSet			equ		ACA_020RegisterBase+$8
ACA_020MapROMReset			equ		ACA_020MapROMSet+$20
ACA_020MapROMStatus			equ		ACA_020MapROMSet
ACA_020Z2ModeSet			equ		ACA_020RegisterBase+$a
ACA_020Z2ModeReset			equ		ACA_020Z2ModeSet+$20
ACA_020ClockDivideEnable	equ		ACA_020RegisterBase+$c
ACA_020ClockDivideReset		equ		ACA_020ClockDivideEnable+$20
ACA_020ClockDivisor0		equ		ACA_020RegisterBase+$e
ACA_020ClockDivisor0Reset	equ		ACA_020ClockDivisor0+$20
ACA_020ClockDivisor1		equ		ACA_020RegisterBase+$10
ACA_020ClockDivisor1Reset	equ		ACA_020ClockDivisor1+$20
ACA_020Status0				equ		ACA_020RegisterBase+$8
ACA_020Status1				equ		ACA_020RegisterBase+$a
ACA_020CPUSwitch			equ		ACA_020RegisterBase+$14
ACA_020NoMemcard			equ		ACA_020RegisterBase+$12
ACA_020NoMemcardReset		equ		ACA_020NoMemcard+$20
ACA_020Waitstates			equ		ACA_020RegisterBase+$16
ACA_020WaitstatesReset		equ		ACA_020Waitstates+$20
ACA_020NoC0Mem				equ		ACA_020RegisterBase+$18
ACA_020NoC0MemReset			equ		ACA_020NoC0Mem+$20
ACA_020RamDiskSet			equ		ACA_020RegisterBase+$1a	
ACA_020RamDiskReset			equ		ACA_020RamDiskSet+$20	
ACA_020BankShiftSet			equ		ACA_020RegisterBase+$1c
ACA_020BankShiftReset		equ		ACA_020BankShiftSet+$20


*****  ACAInfo offsets *****

ai_MapROM			equ		0
ai_ClockInfo		equ		2
ai_Z2Mode			equ		6
ai_NoMemcard		equ		8
ai_WriteWaitstates	equ		10
ai_NoC0Mem			equ		12
ai_Serial			equ		14
ai_CurrentCPU		equ		18

*****  ACA1233Lib defines  *****
AR_MAPINT       equ		1	
AR_MAPREMOVE	equ		-1

AS_MEMCARDON	equ		0
AS_MEMCARDOFF	equ		1

	

	incdir		""

***************** Library structure *****************
;	bsr		InitRoutine
;	bra		GetCurrentSpeed		; DEBUG
;	moveq	#1,d0
;	bra		ACA1233_SetSpeed
;	bra		GetMaxSpeed
;	bsr		InitRoutine
;	bsr 	ACA1233_GetStatus
;	bsr		ACA1233_GetMaxSpeed
;	bsr		ACA1233_GetCurrentSpeed
;	move.l	#kickname,d0
;	moveq	#0,d0
;	moveq	#-1,d1
;	bsr		ACA1233_MapROM
;	moveq	#1,d0
;	bsr		ACA1233_SetWaitstates
;	bsr		ACA1233_SwitchZ2Compat
;	moveq	#AS_MEMCARDON,d0
;	bsr		ACA1233_SwitchCPU
	
	
Startlib:
    moveq    #0,d0
    rts

RomTag:
    dc.w    $4afc		;RT_MATCHWORD /ILLEGAL
    dc.l    RomTag		;RT_MATCHTAG
    dc.l    endep		;RT_ENDSKIP
    dc.b    $80			;RT_FLAGS - AutoInit-flag set
    dc.b    1			;RT_VERSION
    dc.b    9			;RT_TYPE
    dc.b    0			;RT_PRI
    dc.l    libname		;RT_NAME
    dc.l    idstring	;RT_IDSTRING
    dc.l    init		;RT_INIT - parameters for MakeLibrary()

libname:
    dc.b    'ACA1233n.library',0
    even
idstring:
	
	IFEQ	DEBUG
	
    dc.b    '$VER: ACA1233n.library 1.3  (19-Jan-2017) '
    
    ELSEIF
    
    dc.b    '$VER: ACA1233nDEBUG.library 1.3  (19-Jan-2017) '

	ENDC    
    
    dc.b    'by Marcus Gerards '
    dc.b    '(marcus.gerards@gmail.com)',0
    even
init:
    dc.l    34	; LibSize(34)
    dc.l    functable
    dc.l    datatable
    dc.l    InitRoutine

functable:
    dc.w    -1							; ToDo: do we really need that marker?

**********	Standard library functions	*************
    dc.w    Open-functable						;-06
    dc.w    Close-functable						;-12
    dc.w    Expunge-functable					;-18
    dc.w    Startlib-functable					;-24
	
**********	Custom functions			*************
    dc.w    ACA1233_GetStatus-functable			;-30
    dc.w    ACA1233_GetCurrentSpeed-functable	;-36
    dc.w    ACA1233_GetMaxSpeed-functable		;-42
    dc.w	ACA1233_SetSpeed-functable			;-48
    dc.w    ACA1233_DisableC0Mem-functable		;-54
    dc.w    ACA1233_SwitchCPU-functable			;-60
	dc.w    ACA1233_SetWaitstates-functable		;-72
	dc.w	ACA1233_MapROM-functable			;-78
	dc.w	ACA1233_SwitchZ2Compat-functable	;-84

    dc.w    -1							; End marker

datatable:
    INITBYTE    8,9				;LN_TYPE,NT_LIBRARY
    INITLONG    10,libname		;LN_NAME,LibName
    INITBYTE    14,6			;LIB_FLAGS,LIBF_SUMUSED!LIBF_CHANGED
    INITWORD    20,1			;LIB_VERSION,VERSION
    INITWORD    22,3			;LIB_REVISION,REVISION
    INITLONG    24,idstring		;LIB_IDSTRING,IDString
    dc.l    0


**********	Library initialization	******************************************
InitRoutine:
	movem.l	d0-a6,-(sp)
    move.l	a0,seglist
    
    move.l	4.w,a6
    lea		dosname(pc),a1
    moveq	#33,d0
    jsr		_LVOOpenLibrary(a6)
    move.l	d0,dosbase
    tst.l	d0
    beq.w	openerror
    
    lea		exname(pc),a1
    moveq	#33,d0					; expansion.library V33
    jsr		_LVOOpenLibrary(a6)		; open it
    move.l	d0,exbase
	tst.l	d0
    beq.w	openerror2
    
    
* check for Autoconfig for ACA1233n
	IFEQ	DEBUG					; we need to skip this for the dummy library
autoconf:
    move.l	exbase(pc),a6        
    move.w	#0,a0
nextboard:
    move.l	#4626,d0				; ManID: IComp
    moveq	#-1,d1					; ProdID: any
    jsr		_LVOFindConfigDev(a6)
    move.l	d0,a0					; save ConfigDev pointer for next loop

    tst.l	d0
    beq.w	.no_autoconf			; last board or none?
	
	lea		ACAInfo,a3				; save serial in ACAInfo
	moveq	#1,d0					; flag marker
    cmp.b	#33,17(a0)				; ACA1233n with 030 active?
    bne.s	.check30V1 
    bra.s	.enterSerial

.check30V1:
	cmp.b	#68,17(a0)
	bne.s	.check020
	move.l	d0,FirmwareV1
    
.enterSerial:
    move.l	22(a0),ai_Serial(a3)	; for maximum clock
    move.l	#68030,ai_CurrentCPU(a3); enter CPU type
    bra.s	.found_card

.check020:
    cmp.b	#32,17(a0)				; ACA1233 with disabled CPU?
    bne.s	.check020V1
    bra.s	.enterSerial020

.check020V1:
	cmp.b	#72,17(a0)				; ACA1233 with disabled CPU and old Firmware?
	bne.s	nextboard
	move.l	d0,FirmwareV1

.enterSerial020:
	move.l	a0,ConfigDev			; store ConfigDev for GetMaxSpeed
	bsr		acaidentify_500
	tst.l	d0
	bne.s	.enterSerialACA500
	move.l	#14,ai_Serial(a3)		; and enter A1200 speed / TODO: read system clock
    move.l	#68020,ai_CurrentCPU(a3)	
    bra.s	.found_card

.enterSerialACA500:
	move.l	#14,ai_Serial(a3)		; enter ACA500 speed
    move.l	#68000,ai_CurrentCPU(a3)	
    bra.s	.found_card
	
.no_autoconf:
	moveq	#0,d0
	move.w	$b8f000,d0				; check for completely disabled card    
	move.w	#$fff,d1				; bit 0-11 must be 1
	and.w	d1,d0
	tst.w	d0
	beq.s	openerror				; all hope is lost
	move.l	#14,ai_Serial(a3)
    move.l	#68020,ai_CurrentCPU(a3)	
	
.found_card:
	ELSE IF
	
	moveq	#1,d0					; dummy lib gets a faked 030 V2
	lea		ACAInfo,a3				; with maximum 
    move.l	#40,ai_Serial(a3)		; clock
    move.l	#68030,ai_CurrentCPU(a3); enter CPU type
  
    ENDC

openerror2:
	move.l	4.w,a6					; close 
    move.l	dosbase(pc),a1			; dos.library
    jsr		_LVOCloseLibrary(a6)

openerror:							;something went wrong...
    movem.l	(sp)+,d0-a6
    rts

	
Open:								; exec delivers libptr:a6, libversion:d0 
    addq.w	#1,32(a6)				; increase LIB_OPENCNT
    bclr	#3,14(a6)				; clear the EXPUNGE-bit in LIB_FLAGS
    move.l	a6,d0					; return ACA1233nBase
    rts

Close:								; ( libptr:a6 )
    subq.w	#1,32(a6)				; decrease LIB_OPENCNT
    bne.s	.nooneopen
    btst	#3,14(a6)        		; test LIB_FLAGS - can we remove the library?
    bne.s	Expunge 				; do it -> .nooneopen2
.nooneopen:
    moveq	#0,d0
    rts

Expunge:							; ( libptr: a6 )
    tst.w	32(a6)					; test OpenCount
    beq.s	.nooneopen2				; we still have users
    bset	#3,14(a6)				; expunge at first opportunity
    moveq	#0,d0
    rts


.nooneopen2:
    movem.l	d2/a4/a6,-(sp)
    move.l	a6,a4
    move.l	seglist,d2
    move.l	a4,a1
    move.l	4.w,a6
    jsr		_LVORemove(a6)			; remove library
	
    moveq	#0,d0
    move.l	a4,a1					; get library base address
    move.w	16(a4),d0				; LIB_NEGSIZE
    sub.w	d0,a1
    add.w	18(a4),d0				; LIB_POSSIZE
    jsr		_LVOFreeMem(a6)			; FreeMem (library structure & jumptables)

    move.l	4.w,a6					; close 
    move.l	exbase(pc),a1			; expansion.library
    jsr		_LVOCloseLibrary(a6)
    
    move.l	dosbase(pc),a1
    cmp.l	#0,(a1)					; did we open dos.library?
    beq.s	.nodosopen				
    jsr		_LVOCloseLibrary(a6)

.nodosopen:
    move.l	d2,d0					; return SegmentList
    movem.l	(sp)+,d2/a4/a6
    rts
 
 
******* ACA1233n.library/ACA1233_GetStatus ***********************************
*
*   NAME
*       ACA1233_GetStatus() - return info about the card's settings
*
*   SYNOPSIS
*       status = ACA1233_GetStatus();
*       D0
*
*       struct ACA1233Info *ACA1233_GetStatus(void);
*
*   FUNCTION
*       Reads settings of the card and returns a pointer to an internal 
*       library structure. 
*       
*   INPUTS
*       none
*
*   RESULT
*       status - pointer to struct ACA1233Info (see ACA1233n.h) or NULL
*
*   EXAMPLE
*       struct ACA1233Info *ACAInfo = NULL:
*       
*       ACAInfo = ACA1233_GetStatus();
*      
*       Printf("MapROM is currently %s\n",
*                 ACAInfo->ai_MapROMStatus ? "enabled" : "not enabled");
*
*   NOTES
*       None
*
*   BUGS
*       None known
*
*   SEE ALSO
*       libraries/ACA1233n.h
* 	
*											
*******************************************************************************
 
ACA1233_GetStatus:
	movem.l	a0-a6/d1-d7,-(a7)
	lea		ACAInfo,a2
	move.l	ai_CurrentCPU(a2),d1
	cmp.l	#68030,d1
	bne.s	.setReg020
	lea 	ACA_Status0,a0
	bra.s	.readStatus

.setReg020:
	lea		ACA_020Status0,a0

.readStatus
	moveq	#0,d0
	moveq	#0,d1
	bsr		UnlockCard
	moveq	#0,d4
	
	move.b	(a0),d4
	lsr.w	#4,d4
	
.checkMapROM:
	and.b	#%1000,d4
	move.w	d4,(a2)					; ai_MapROM
	
.checkSpeed:	
	bsr.s	ACA1233_GetCurrentSpeed	; get current clock speed
	move.l	d0,ai_ClockInfo(a2)		; save pointer
	
.checkNoC0Mem:
	addq 	#2,a0					; forward to ACA_(020)Status1
	move.b	(a0),d4
	lsr.w	#4,d4
	move.l	d4,d5
	moveq	#1,d3
	
	and.b	d3,d5
	move.w	d5,ai_NoC0Mem(a2)

.checkWaitStates:
	move.l	d4,d5
	lsl.w	#1,d3
	and.b	d3,d5
	lsr.w	#1,d5
	move.w	d5,ai_WriteWaitstates(a2)
	
.checkNoMemcard:
	move.l	d4,d5
	lsl.w	#1,d3
	and.b	d3,d5
	lsr.w	#2,d5
	move.w	d5,ai_NoMemcard(a2)

.checkZ2Mem:
	move.l	d4,d5
	lsl.w	#1,d3
	and.b	d3,d5
	lsr.w	#3,d5
	move.w	d5,ai_Z2Mode(a2)

.checkdone:
	move.l	a2,d0					; return info structure
    
    movem.l	(a7)+,a0-a6/d1-d7
    rts



******* ACA1233n.library/ACA1233_GetCurrentSpeed ******************************
*
*   NAME 										
*       ACA1233_GetCurrentSpeed -- determine the current speed values 
*                                  of the card
*
*   SYNOPSIS
*       speedinfo = GetCurrentSpeed()				
*       D0
*	
*       struct ACA1233ClockInfo *ACA1233_GetCurrentSpeed(void);	
*
*   FUNCTION
*       Read current speed setting of the card. Returns a pointer to
*       an internal library structure. Both actual clock value 
*       (STRPTR) and speed stepping (UWORD) will be returned.													*
*       
*   INPUTS
*       none
*
*   RESULT
*       speedinfo - pointer to struct ACA1233ClockInfo (see ACA1233n.h) or NULL
*
*   EXAMPLE
*       struct ACA1233ClockInfo *ACASpeed = NULL:
*       
*       ACASpeed = ACA1233_GetCurrentSpeed();
*
*       Printf("My current speed stepping is %ld (%s)",
*                 ACASpeed->ci_CPUSpeedStep, ACASpeed->ci_CPUClock);
*
*   NOTES
*       Any task accessing the library may call SetSpeed(), so always call
*       GetCurrentSpeed() right before you process the ClockInfo values.
*       This function is a shortcut; you could also obtain the speed values
*       via ACA1233_GetStatus.
*       If the 68030 of the card has been deactivated, the function will
*       always return the clock speed of the host machine's CPU and either a
*       speed stepping of 0 or that of the ACA500+ (if attached, see ACA500+
*       documentation for further information).
*
*   BUGS
*       None known
*
*   SEE ALSO
*       ACA1233_GetMaxSpeed(), ACA1233_SetSpeed(), ACA1233_GetStatus,
*       libraries/ACA1233n.h
* 	
*											
******************************************************************************

ACA1233_GetCurrentSpeed:
    movem.l	a0-a6/d1-d7,-(a7)
	
	lea		ClockInfo,a2
	lea		ACAInfo,a3
	move.l	ai_CurrentCPU(a3),d1
	cmp.l	#68030,d1
	bne.s	.getHostSpeed
	lea 	ACA_Status0,a0

.getSpeed:
    lea 	ACA_Status0,a0
	lea		clocktable,a1
	moveq	#0,d0
	moveq	#0,d1
	moveq	#0,d2
	
	IFEQ	DEBUG					
	
	move.w	#%10000,d1				; mask for clockDivideEnable	
	move.b	(a0),d2
	move.l	d2,d0
	and.b	d1,d0
	tst.w	d0
	bne.s	.reducedSpeed
	moveq	#4,d0
	bra.s	.enterClockVal
	
.reducedSpeed:
	move.l	d2,d0					; fetch & mask divisor bits
	lsr.w	#5,d0					; move clock divisor bits around
	move.w  d0,d1					; and swap them
	and.w	#1,d1
	lsl.w	#1,d1
	lsr.w	#1,d0
	and.w	#1,d0
	or.w	d1,d0	
	bra.s	.enterClockVal
	
	ELSEIF	
	
	tst.l	(a2)					; the dummy lib grabs a speed setting directly from the struct
	bne.s	cspeedset
	moveq	#3,d0
	bra.s	cont
	
	ENDC

	
.getHostSpeed:
	moveq	#0,d0					; save the speed stepping
	move.w	d0,4(a2)
	move.l	#Speed020,(a2)			; save the clock value	
	bra.s	.returnSpeed
	
.enterClockVal:	
	move.w	d0,4(a2)				; save the speed stepping
	lsl.w	#2,d0					; multiply speed step by 4
	add.w	d0,a1					; point to longword with clock value
	move.l	(a1),(a2) 				; save the clock value	

.returnSpeed:
	move.l	a2,d0					; return clock structure
    
    movem.l	(a7)+,a0-a6/d1-d7
    rts


******* ACA1233n.library/ACA1233_GetMaxSpeed *********************************
*
*   NAME
*       ACA1233_GetMaxSpeed() - determine the maximum speed of the card
*
*   SYNOPSIS
*       speedinfo =	GetMaxSpeed();
*       D0
*
*       struct ClockInfo *GetMaxSpeed(void);
*
*   FUNCTION
*       Read maximum speed setting of the card. Returns a pointer to
*       an internal library structure. Both actual clock value 
*       (STRPTR) and speed stepping (UWORD) will be returned.	
*
*   INPUTS
*       none
*
*   RESULT
*       speedinfo - pointer to struct ACA1233ClockInfo (see ACA1233n.h) or NULL
*
*   EXAMPLE
*       struct ACA1233ClockInfo *ACAMaxSpeed = NULL:
*       
*       ACAMaxSpeed = ACA1233_GetMaxSpeed();
*      
*       Printf("My maximum speed stepping is %ld (%s)",
*                 ACAMaxSpeed->ci_CPUSpeedStep, ACAMaxSpeed->ci_CPUClock);
*
*   NOTES
*       The maximum speed is determined by the CPU of the ACA1233n, regardless
*       if it's currently active or not.
*
*   BUGS
*       None known
*
*   SEE ALSO
*       ACA1233_GetCurrentSpeed(), ACA1233_SetSpeed(), ACA1233_GetStatus()
*       libraries/ACA1233n.h
* 	
*											
******************************************************************************

ACA1233_GetMaxSpeed:
    movem.l d1-a6,-(a7)			; d0 = result

    lea		clocktable,a1
    lea 	ClockInfoMax,a2
	moveq	#0,d0		
	
	IFEQ	DEBUG				; the dummy lib gets maximum clock license
	
	lea		ACAInfo,a3
	moveq	#4,d0				; save speed stepping
	move.w	d0,4(a2)

	move.l	ai_CurrentCPU(a3),d1
	cmp.l	#68030,d1
	bne.s	.readConfigDev

	move.l	14(a3),d1
	bra.s	.checkMHz

.readConfigDev:
	move.l	ConfigDev,a3		; ACAInfo holds max clock of the host card
	move.l	22(a3),d1			; in 020-mode, so we need to read er_Serial
								; from ConfigDev again

.checkMHz:
	cmp.l	#40,d1
	bne.s	.set33MHz

.set40MHz:
	
	ELSEIF
	
	moveq	#4,d0				; 4 = max clock
	
	ENDC

.enterMaxClock:	
	lsl.w	#2,d0
	add.l	d0,a1
	move.l	(a1),(a2)
	bra.s	.returnMaxSpeed
	
.set33MHz:
	move.l	#Speed33,(a2)
	
.returnMaxSpeed:
	move.l	a2,d0

    movem.l    (a7)+,d1-a6        
    rts

******* ACA1233n.library/ACA1233_SetSpeed ************************************
*
*   NAME
*       ACA1233_SetSpeed - changes the current speed setting of the card
*
*   SYNOPSIS
*       Success = ACA1233_SetSpeed(speedStepping);
*       D0                         D0
*
*       BOOL ACA1233_SetSpeed(UBYTE);
*
*   FUNCTION
*       Change the current speed setting of the card to the supplied stepping.
*       The setting is in effect until the next flip of the power switch.
*
*   INPUTS
*       speedStepping   - binary value, the ACA1233n supports (depending on 
*                         the fitted CPU) stepping 0-3, which correspond to 
*                         the following clock values:
*
*                         0: 13.33 MHz
*                         1: 16.00 MHz
*                         2: 20.00 MHz
*                         3: 26.67 MHz 
*                         4: 40.00 MHz         
*
*   RESULT
*       success - TRUE, if the card accepts the setting, otherwise FALSE. You
*                 may verify this by calling ACA1233_GetCurrentSpeed(), but 
*                 only in 68030 mode, since it will return the host machine's
*                 secondary CPU's speed while the ACA1233n's CPU is 
*                 deactivated. (Lots of genitive forms over here...)
*
*   EXAMPLE
*       BOOL success = FALSE;
*       UBYTE mySpeed = 2;
*
*       success = ACA1233_SetSpeed(mySpeed);
*       
*       if (success) {
*           Printf("My speed stepping has been set to %ld\n", mySpeed);
*       }
*
*   NOTES
*       The maximum speed available is determined by CPU fitted to the card.
*       This function will always return FALSE while the CPU of the card is
*       deactivated.
*
*       You may call the function anytime without the need to disable 
*       multitasking. Other tasks (e.g. formatting disks, etc.) will not be
*       disturbed.  
*
*   BUGS
*       Well, it's technically possible to "preprogram" the speed of the card
*       while the card's CPU is switched off. But since that does not make 
*       much sense, it has not been implemented.
*
*   SEE ALSO
*       ACA1233_GetCurrentSpeed(), ACA1233_GetMaxSpeed(), libraries/ACA1233n.h
* 	
*											
******************************************************************************

ACA1233_SetSpeed:
	movem.l d1-a6,-(a7)
	moveq	#0,d1
	move.b	d0,d2
	
	IFNE	DEBUG			; dummy lib sets any speed
	
	lea		ACAInfo,a3
	move.l	ai_CurrentCPU(a3),d1
	cmp.l	#68030,d1
	bne.s	.speederror		; return false if card's cpu has been switched off
	moveq	#0,d1

	lea		ClockInfo,a3	
	move.w	d0,4(a3)		; we store it right here 
	lea		clocktable,a5
	lsl.w	#2,d0
	add.w	d0,a5
	move.w	(a5),(a3)
	
	ELSEIF
	
	cmp.b	#4,d0
	beq.s	.disableDivisor
	move.b	d0,d1
	lsr.w	#1,d0
	and.w	#1,d0
	and.w	#1,d1
	bsr		UnlockCard

.setDivisor0:
	tst.b	d1
	beq.s	.resetDivisor0
	move.b	d1,ACA_ClockDivisor0
	bra.s	.setDivisor1
.resetDivisor0:	
	move.b	d1,ACA_ClockDivisor0Reset

.setDivisor1:
	tst.b	d0
	beq.s	.resetDivisor1
	move.b	d0,ACA_ClockDivisor1
	bra.s	.setClockDivide
.resetDivisor1:
	move.b	d0,ACA_ClockDivisor1Reset
	
.setClockDivide:
	move.b	#1,ACA_ClockDivideEnable
	bsr		UnlockCard
	bra.s	.checkspeed
	
.disableDivisor:
	bsr		UnlockCard
	move.b	#0,ACA_ClockDivideReset
	

.checkspeed:
	bsr		ACA1233_GetCurrentSpeed	
	move.l	d0,a0
	move.w	4(a0),d0
	cmp.b	d0,d2
	bne.s	.speederror
	bra.s	.speedsuccess	
.speederror:
	moveq	#0,d0
	movem.l (sp)+,d1-d7/a0-a6	; Restore registers
    rts
		
	ENDC
	
.speedsuccess:
	moveq	#1,d0				; speed has been set successfully
	movem.l (sp)+,d1-d7/a0-a6	; Restore registers
    rts


******* ACA1233n.library/ACA1233_DisableC0Mem ********************************
*
*   NAME
*       ACA1233_DisableC0Mem() - turn off/back on 1 MB of memory starting 
*       at 0xC00000 
*
*   SYNOPSIS
*       success = ACA1233_DisableC0Mem(switch);
*       d0                             d0
*     
*       BOOL ACA1233_DisableC0Mem(UBYTE);
*
*   FUNCTION
*       Turns off/on the memory region 0x0c00000 to 0x0cfffff, also known as 
*       "Slow RAM" to maximize compatibility with old software or DMA devices
*       which use the lower 16M address space (like A2091 or GVP controllers).
*
*   INPUTS
*       "AC_NOC0MEM" or "AC_C0MEM" (UBYTE)
*
*   RESULT
*       success - TRUE, if the card accepts the setting, otherwise FALSE. 
*       You will obviously only be able to check for FALSE (see NOTES).
*
*   EXAMPLE
*       Printf("Turbocard's processor will be disabled in 10 seconds -");
*       Printf("Finish all disk activity NOW!\n");
*       Delay(500);
*
*       ACA1233_DisableC0Mem(AC_NOC0MEM);
*
*   NOTES
*       Calling this function will also cause an immediate reboot. Warn the
*       user! 
*       And well, the "0" in "C0" is a zero. ;-)
*
*   BUGS
*       None known
*
*   SEE ALSO
*       libraries/ACA1233n.h
*        	
*											
******************************************************************************

ACA1233_DisableC0Mem:
	
	movem.l	d1-a6,-(sp)

	lea		ACAInfo,a0
	moveq	#0,d1
	move.w	ai_NoC0Mem(a0),d1
	move.l	ai_CurrentCPU(a0),d2
	cmp.l	#68030,d2
	bne.s	.setReg020
	lea		ACA_NoC0Mem,a0
	bra.s	.checkC0Status

.setReg020:
	lea		ACA_020NoC0Mem,a0

.checkC0Status:
	cmp.b	d0,d1
	beq.s	.noChange
	tst.w	d1
	bne.s	.enableC0Mem
	
.disableC0Mem:	
	move.l	$4.w,a6
	jsr		_LVOForbid(a6)
	jsr		_LVODisable(a6)
	bsr		UnlockCard
	move.b	#1,(a0)
	jsr		_LVOColdReboot(a6)
	
	movem.l	(sp)+,d1-a6
	rts							; Ha, ha, ha...

.enableC0Mem:	
	move.l	$4.w,a6
	jsr		_LVOForbid(a6)
	jsr		_LVODisable(a6)
	bsr		UnlockCard
	move.b	#0,$20(a0)
	jsr		_LVOColdReboot(a6)
	
	movem.l	(sp)+,d1-a6
	rts							; *cough*
	
.noChange:
	moveq	#0,d0
	movem.l	(sp)+,d1-a6
	rts
	
	
******* ACA1233n.library/ACA1233_SwitchCPU ***********************************
*
*   NAME
*       ACA1233_SwitchCPU() - disable or (re-)enable the card's CPU
*
*   SYNOPSIS
*       ACA1233_SwitchCPU(option);
*       
*       VOID ACA1233_SwitchCPU(BYTE);
*
*   FUNCTION
*       Disable/enable the card's processor and thus - depending on whether
*       your machine is an A1200 or A500 - switch to either the internal
*       68EC020 of the A1200 or the 68000 of the ACA500(+). If the 68030 has
*       already been switched off, calling the function again will turn it
*       back on again.
*
*   INPUTS
*       The card's memory can be switched off or back on together with the CPU.
*       Provide AS_MEMCARDON or AS_MEMCARDOFF as option accordingly. 
*
*   RESULT
*       returns FALSE if user specifies AS_MEMCARDOFF with a firmware V1 card
*
*   EXAMPLE
*       Printf("Turbocard's processor will be disabled in 10 seconds - ");
*       Printf("the card's memory will be (re-)enabled. "
*       Printf("Finish all disk activity NOW!\n");
*       Delay(500);
*
*       ACA1233_SwitchCPU(AS_MEMCARDON);
*
*   NOTES
*       Calling this function will also cause an immediate reboot. Warn the
*       user!
*
*       NoMemCard-option is broken for firmware V1 cards. Contact IComp for
*       firmware upgrade! For newer revisions, activating NoMemCard 
*       currently is a one way ticket; you want to get your FastMem back?
*       
*       "Did you try turning it off and back on again?"
*
*
*   BUGS
*       none known
*
*   SEE ALSO
* 	
*											
******************************************************************************

ACA1233_SwitchCPU:
	lea		ACAInfo,a0
	move.l	ai_CurrentCPU(a0),d1
	move.l	ai_NoMemcard(a0),d2

	cmp.l	#68030,d1
	bne.s	.setReg020
	lea		ACA_CPUSwitch,a0
	bra.s	.checkMemcard

.setReg020:
	lea		ACA_020CPUSwitch,a0
	
.checkMemcard:
	cmp.l	#1,d2
	beq.s	.unsupported		; we cannot switch the memory back on
	cmp.l	d2,d0
	bne.s	.switchMemCard
	
.switchCPU
	bsr		UnlockCard
	move.b	#1,(a0)
	rts

.switchMemCard:
	bchg	#0,d2				; invert noMemcard-bit
	move.l	FirmwareV1,d0
	tst.l	d0
	bne.s	.unsupported
	
	cmp.l	#68030,d1
	bne.s	.setMemcard020
	
	lea		ACA_NoMemcard,a1
	bra.s	.setMemcard

.setMemcard020:
	lea		ACA_020NoMemcard,a1
	
.setMemcard:

	move.l	$4.w,a6					; Get Exec pointer

	jsr		_LVODisable(a6)
	lea.l	rebootprogram_switch,a5
	jsr		_LVOSupervisor(a6)		; Gain Supervisor status	

.unsupported:	
	bchg	#0,d0				; TRUE, if FirmwareV1 == 0
	movem.l	(sp)+,d1-a6
	rts

	
******* ACA1233n.library/ACA1233_SetWaitstates *******************************
*
*   NAME
*       ACA1233_SetWaitstates() - sets the number of write waitstates
*
*   SYNOPSIS
*       success = ACA1233_SetWaitstates(waitstates);
*       D0                              D0
*
*       BOOL ACA1233_SetWaitstates(UBYTE);
*
*   FUNCTION
*       The SD-RAM controller of the ACA1233n can be configured to operate 
*       with 0-waitstate or with 1-waitstate. Write performance is 
*       significantly higher with 0-waitstate, but timing is very tight and 
*       might get instable if an FPU is installed, the power supply is not 
*       absolutely stable or environmental conditions are difficult for the
*       card (e.g. excessive heat). 
*       Timing on power-up will be set to 0-waitstate if there is no FPU 
*       installed, and it will be set to 1-waitstate if an FPU is installed.
*       This function allows to control this behaviour manually - valid 
*       values for "waitstates" are AW_NOWAITSTATE and AW_WAITSTATE.
*
*   INPUTS
*       none
*
*   RESULT
*       success - TRUE, if the card accepts the setting, otherwise FALSE. 
*
*   EXAMPLE
*       BOOL success = FALSE;
*
*       success = ACA1233_SetWaitstates(0);
*
*       if (success) {
*           Printf("No more waitstates for writes!\n");
*       }
*
*   NOTES
*       This function can used at any time, regardless of FPU presence.
*       The effect is instant.
*
*   BUGS
*       None known
*
*   SEE ALSO
* 	
*											
******************************************************************************

ACA1233_SetWaitstates:
	movem.l	d1-a6,-(sp)
	
	lea		ACAInfo,a0
	move.l	ai_CurrentCPU(a0),d1
	cmp.l	#68030,d1
	bne.s	.setReg020
	lea		ACA_Waitstates,a0
	bra.s	.changeWaitstate

.setReg020:
	lea		ACA_020Waitstates,a0
	
.changeWaitstate:
	moveq	#0,d1
	bsr		UnlockCard
	cmp.b	#0,d0
	bne.s	.oneWaitstate
.zeroWaitstate:
	move.b	#0,$20(a0)			; trigger reset location
	bra.s	.checkWaitstate

.oneWaitstate:
	move.b	#1,(a0)				; trigger set location
	moveq	#1,d1

.checkWaitstate:
	bsr		ACA1233_GetStatus
	move.l	d0,a0
	move.w	ai_WriteWaitstates(a0),d0
	cmp.w	d0,d1
	beq.s	.returnSuccess

.returnFalse:
	moveq	#0,d0
	bra.s	.end
	
.returnSuccess:
	moveq	#1,d0	
	
.end:
	movem.l	(sp)+,d1-a6
	rts


******* ACA1233n.library/ACA1233_MapROM **************************************
*
*   NAME
*       ACA1233_MapROM() - Maps/unmaps Kickstart ROM to/from FastRAM
*
*   SYNOPSIS
*       success = ACA1233_MapROM(file, option);
*       D0                       D0    D1
*
*       BOOL ACA1233_MapROM(STRPTR, LONG);
*
*   FUNCTION
*       Maps Kickstart ROM to the contents of a file which will be copied to 
*       FastRAM beforehand.Supply AR_MAPINT as option argument to use the 
*       internal physical Kickstart ROM as the source or supply AR_MAPREMOVE to 
*       deactivate the MapROM feature. If you supply an option, "file" should 
*       be NULL, but will be ignored anyway.
*
*   INPUTS
*       file   - pointer to a filenameor NULL
*       option - one of the options AR_MAPREMOVE, ARMAPINT
*
*   RESULT
*       success - TRUE, if the card accepts the setting, otherwise FALSE. 
*
*   EXAMPLE
*       BOOL success = FALSE;
*       STRPTR file = "kickstart.rom";
*       ...
*
*       success = ACA1233_MapROM(file, 0);
*
*       if (success) {
*           Printf("Contents of the file have been mapped as Kickstart ROM\n");
*       }
*
*   NOTES
*       V1.0 of the lib contains an incomplete implementation and handles only 
*       mapping of the machine's internal ROM. Thus any argument will be 
*       overwritten by AR_MAPINT.
*
*   BUGS
*       Mapping the ROM while the card's CPU is not active is currently not
*       supported. You must map the ROM in 030 mode and then switch off the
*       CPU.
*
*   SEE ALSO
*       libraries/ACA1233n.h
*        	
*											
******************************************************************************

ACA1233_MapROM:

	movem.l	d1-a6,-(sp)
;	move.l	#kickname,d0
	move.l	d0,d2				; save filename ptr
	move.l	d1,d3				; save option
;	moveq	#AR_MAPINT,d2		; debug: test MAPINT
;	moveq	#AR_MAPREMOVE,d2	; debug: test MAPREMOVE
	

	
	lea		ACAInfo,a0
	move.l	ai_CurrentCPU(a0),d0
	cmp.l	#68030,d0
	bne		noMapROM
	
	cmp.l	#AR_MAPREMOVE,d3	; remove mapped ROM?
	bne.s	.startMapROM
	bsr		UnSetMapRom
	bsr		ACA1233_GetStatus	; check if MapRom has been 
	move.l	d0,a0				; disabled sucessfully
	move.w	(a0),d0
	bchg	#0,d0				; and swap the bit for proper return code
	bra.s	.mapROM_done

.startMapROM:	
	moveq	#0,d1
	lea 	ACA_MapROMStatus,a1
	
	bsr		UnlockCard
	move.w	(a1),d0
	lsr.w	#8,d0
	lsr.w	#7,d0
	and.w	#$1,d0
	tst.w	d0					; MapROM already active?
	bne		noMapROM
	
	cmp.l	#AR_MAPINT,d3		; copy internal ROM?
	bne		processFile		; else get the file
	lea 	$f80000,a0			; copy ROM to both maprom areas
	lea		ACA_UpperMapROM,a1
	bsr		copyROM512k
	lea		$f80000,a0
	lea		ACA_LowerMapROM,a1
	bsr		copyROM512k
	bsr.s	SetMapRom			; and enable MapROM
	
.getStatus:	
	bsr		ACA1233_GetStatus
	move.l	d0,a0
	move.w	(a0),d1
	move.l	d1,d0
	
.mapROM_done:
	movem.l	(sp)+,d1-a6
	rts

*** little subroutine for setting the MapRom-flag ***
SetMapRom:
	move.l	$4.w,a6
	jsr		_LVOForbid(a6)
	jsr		_LVODisable(a6)
	bsr		UnlockCard
	move.b	#1,ACA_MapROMSet
	jsr		_LVOEnable(a6)
	jsr		_LVOPermit(a6)
	rts

*** little subroutine for resetting the MapRom-flag ***	
UnSetMapRom:
	moveq	#0,d0				; check if we really need a reboot
	lea 	ACA_UpperMapROM,a0
	lea 	$1f80000,a1
	move.w	#$ffff,d3
	move.w	#$1,d4

.checkROM512kloop:
	move.l	(a0)+,d0
	move.l	(a1)+,d1
	cmp.l	d0,d1
	bne.s	.noteven
	dbra 	d3,.checkROM512kloop
	dbra	d4,.checkROM512kloop
	lea		ACA_MapROMReset,a0
	moveq	#0,d0
	bsr		UnlockCard
	move.l	d0,(a0)
	rts

.noteven	
	moveq	#-1,d7
	bra		rebootamiga
	rts
	
noMapROM:					; no MapRom for 020, yet.
	moveq	#0,d0
	movem.l	(sp)+,d1-a6
	rts

.freeBuffer:
	move.l	$4.w,a6
	jsr		_LVOFreeVec(a6)
	rts


*** Try to open the file and fill in FileInfoBlock ***
processFile:
	move.l  dosbase,a6
	moveq	#0,d0
	move.l	d2,d1
	move.l	#MODE_OLDFILE,d2
	jsr		_LVOOpen(a6)
	tst.l	d0
	beq		.fOpenError			; file not available?
	
	move.l	d0,d1				; save file handle
	move.l	d0,d5				; twice
	moveq	#0,d0
	move.l	#fib,d2				; buffer for FileInfoBlock
	jsr		_LVOExamineFH(a6)
	tst.l	d0
	beq.	.bAllocError
	
.checkBuffer:
	move.l	$4.w,a6
	move.l	d2,a0
	move.l	fib_Size(a0),d4	; check the kickstart's size
	
	cmp.l	#$80000,d4
	bne.s	.no512k
	move.l	d4,kickSize
	bra.s	.allocBuffer
	
.no512k:
	cmp.l	#$40000,d4	
	bne.s	.no256k
	move.l	d4,kickSize
	bra.s	.allocBuffer

.no256k:
	cmp.l	#$100000,d4
	bne		.bAllocError		; ok, it's neither 256 nor 512 nor 1024k
	move.l	d4,kickSize

.allocBuffer					; we allocate a handsome buffer for our file
	move.l	d4,d0
	move.l	#(MEMF_ANY|MEMF_CLEAR),d1
	jsr		_LVOAllocVec(a6)
	tst.l	d0
	beq.s	.bAllocError
	move.l	d0,kickBuffer
	
.readKickFile:
	moveq	#0,d0
	move.l	dosbase,a6
	move.l	d5,d1
	move.l	kickBuffer,d2
	move.l	#kickSize,d3
	jsr		_LVORead(a6)
	cmp.l	#kickSize,d0	
	beq.s	.fReadError
	move.l	kickBuffer,a0
	;move.l	d2,a0				; our buffer now contains the kickstart file

	cmp.l	#$100000,d0
	bne.s	.normalKickSize
	bsr.s	copyROM1024k
	bra		rebootamiga			; and out
;	bra.s	.fdone
	
.normalKickSize:				; copy & mirror 512k ROM
	move.l	kickBuffer,a0
	lea 	ACA_UpperMapROM,a1
	bsr.s	copyROM512k
	;bsr	repair_checksum_512kb
	move.l	kickBuffer,a0
	lea		ACA_LowerMapROM,a1
	bsr.s	copyROM512k
	bra		rebootamiga			; and out

.fReadError:
	move.l	$4.w,a6
	move.l	kickBuffer,a1
	jsr		_LVOFreeVec(a6)

.bAllocError;
	move.l	d5,d1
	jsr		_LVOClose(a6)

.fOpenError:
	moveq	#0,d0
	bra		noMapROM
	rts

.fdone:
	moveq	#1,d0
	rts


*** kick rom copy routines ***
*
* a0 = ROM/Source buffer
* a1 = target maprom space 
*
******************************
copyROM512k:
	moveq	#0,d0
	move.w	#$ffff,d1
	move.w	#$1,d2

.copyROM512kloop:
	move.l	(a0)+,d0
	move.l	d0,(a1)+
	dbra 	d1,.copyROM512kloop
	dbra	d2,.copyROM512kloop
	rts


copyROM1024k: 
	movem.l	d0-d7/a0-a6,-(sp)		; Save registers	
	move.l	$4.w,a6					; Get Exec pointer
	jsr		_LVOForbid(a6)			; Shut down Amiga OS

	lea		ACA_LowerMapROM,a1		; Extended ROM pointer

	move.w	#$0003,d0				; Copy 1024kb of data
	move.w	#$ffff,d1
.copyownkick1024kloop:
	move.l	(a0)+,d2				; Copy extended ROM
	move.l 	d2,(a1)+				; & Copy Kickstart ROM	
	dbra 	d1,.copyownkick1024kloop
	dbra 	d0,.copyownkick1024kloop
	jsr		_LVOPermit(a6)			; Restore Amiga OS
		
	movem.l (sp)+,d0-d7/a0-a6		; Restore registers

	rts

	
.copyownkickback1024k:
	movem.l	d0-d7/a0-a6,-(sp)	; Save registers
		
	move.l	$4.w,a6				; Get Exec pointer
	jsr		_LVOForbid(a6)			; Shut down Amiga OS
	
	lea.l	$e00000,a1			; Extended ROM pointer
	lea.l	$f80000,a2			; Kickstart ROM pointer

	move.l	a0,a3
	add.l	#$00080000,a3		; Kickstart pointer in Fast Ram

	move.w	#$0001,d0			; Copy 1024kb of data
	move.w	#$ffff,d1

.copyownkickback1024kloop:
	move.l	(a0)+,(a1)+			; Copy extended ROM
	move.l	(a3)+,(a2)+			; Copy Kickstart ROM	
	dbra	d1,.copyownkickback1024kloop
	dbra	d0,.copyownkickback1024kloop

	jsr		_LVOPermit(a6)			; Restore Amiga OS
		
	movem.l (sp)+,d0-d7/a0-a6	; Restore registers
	rts

	
*******************************************************************************

.prepare256krom:
	movem.l	d0-d7/a0-a6,-(sp)	; Save registers
		
	move.l	$4.w,a6				; Get Exec pointer
	jsr		_LVOForbid(a6)		; Shut down Amiga OS
	
	move.l a0,a1
	add.l #$00040000,a1
	
	move.w #$ffff,d0

.prepare256kloop:
	move.l	(a0)+,(a1)+
	dbra	d0,.prepare256kloop

	jsr		_LVOPermit(a6)		; Restore Amiga OS
		
	movem.l (sp)+,d0-d7/a0-a6	; Restore registers
	rts

repair_checksum:	
	movem.l d0-d7/a0-a6,-(sp)	; Save registers
		
	move.l	$4.w,a6				; Get Exec pointer
	jsr		_LVOForbid(a6)		; Shut down Amiga OS
	
	move.l	a0,a5
	move.l	a0,a4
	add.l	#$3ffe8,a4
	moveq	#0,d0
	clr.l	(A4)
	move.l	#$ffff,d2			; $40000	
.lbC0017E6b
	add.l	(a5)+,d0
	bcc.w	.lbC0017EEb
	addq	#1,D0
.lbC0017EEb	
    dbra	d2,.lbC0017E6b
	not.l	d0
	move.l	d0,(a4)	
	
	move.l	$4.w,a6				; Get Exec pointer
	jsr		_LVOPermit(a6)		; Restore Amiga OS
		
	movem.l (sp)+,d0-d7/a0-a6	; Restore registers
	rts


repair_checksum_512kb:
	movem.l d0-d7/a0-a6,-(sp)	; Save registers
		
	move.l	$4.w,a6				; Get Exec pointer
	jsr		_LVOForbid(a6)		; Shut down Amiga OS
	
	move.l	a0,a5
	move.l	a0,a4
	adda.l	#$7FFE8,a4
	moveq	#0,D0
	clr.l	(a4)
	move.l	#$ffff,d2			; $40000	
albC0017E6b
	add.l	(a5)+,d0
	bcc.w	albC0017EEb
	addq	#1,d0
albC0017EEb	
    dbra	d2,albC0017E6b
	not.l	d0
	move.l	d0,(a4)	
	
	move.l 	$4.w,a6				; Get Exec pointer
	jsr		_LVOPermit(a6)		; Restore Amiga OS
		
	movem.l (sp)+,d0-d7/a0-a6	; Restore registers
	rts


repair_checksum_1mb:			; ???
	movem.l d0-d7/a0-a6,-(sp)	; Save registers

	bsr 	repair_checksum
	add.l 	#$80000,a0
	bsr 	repair_checksum
	
	movem.l (sp)+,d0-d7/a0-a6	; Restore registers
	rts


*******************************************************************************
rebootamiga:		
	
	cmp.l	#-1,d7
	beq.s	.mapremove
	
	lea		ACA_MapROMSet,a0
	moveq	#1,d7
	lea.l	rebootprogram,a5
	bra.s	.mapitnow

.mapremove
	lea		ACA_MapROMReset,a0
	lea.l	rebootprogram,a5
	moveq	#0,d7

.mapitnow
	move.l	$4.w,a6					; Get Exec pointer

	jsr		_LVODisable(a6)
	jsr		_LVOSupervisor(a6)		; Gain Supervisor status	
	

	

******* ACA1233n.library/ACA1233_SwitchZ2Compat ********************************
*
*   NAME
*       ACA1233_SwitchZ2Compat() - autoconfig with Z2 memory instead of Z3 
*
*   SYNOPSIS
*       success = ACA1233_SwitchZ2Compat(switch);
*       d0                               d0
*       
*       BOOL ACA1233_SwitchZ2Compat(UBYTE);
*
*   FUNCTION
*       ACA1233n by default start up with 128MB of autoconfig Zorro III memory
*       starting at $4000.0000. To ensure compatibility with Kickstart ROMs 
*       which don't support Z3 autoconfig (1.3 and earlier), that behaviour
*       can be changed via this function. Supplying the argument "AZ_Z2MODE"
*       will turn the card's memory into a 9MB Zorro II memory expansion,
*       starting at $20.0000 after the next reboot.. The rest of the memory 
*       can still be added manually with the various addmem-commands available.
*       Supplying the argument "AZ_Z3MODE" will switch back to the default 
*       setting.
*
*   INPUTS
*       "AZ_Z2MODE" or "AZ_Z3MODE" (UBYTE)
*
*   RESULT
*       success - TRUE, if the card accepts the setting, otherwise FALSE. 
*
*   EXAMPLE
*       BOOL success;
*
*       success = ACA1233_SwitchZ2Compat();
*
*       if (success) {
*           Printf("Zorro 2 mode activated, please reboot!");
*       }
*
*   NOTES
*
*   BUGS
*       None known
*
*   SEE ALSO
*       libraries/ACA1233n.lib 	
*											
******************************************************************************

ACA1233_SwitchZ2Compat:
	
	movem.l	d1-a6,-(sp)

	lea		ACAInfo,a0
	moveq	#0,d1
	move.w	ai_Z2Mode(a0),d1
	move.l	ai_CurrentCPU(a0),d2
	cmp.l	#68030,d2
	bne.s	.setReg020
	lea		ACA_Z2ModeSet,a0
	bra.s	.checkZ2Status

.setReg020:
	lea		ACA_020Z2ModeSet,a0

.checkZ2Status:
	cmp.b	d0,d1
	beq.s	.noChange
	tst.w	d0
	bne.s	.enableZ2Mode
	
.disableZ2Mode:	
	bsr.s	UnlockCard
	move.b	#0,$20(a0)
	moveq	#1,d0
	
	movem.l	(sp)+,d1-a6
	rts							

.enableZ2Mode:	
	bsr.s	UnlockCard
	move.b	#1,(a0)
	moveq	#1,d0
	
	movem.l	(sp)+,d1-a6
	rts							; *cough*
	
.noChange:
	moveq	#0,d0
	movem.l	(sp)+,d1-a6
	rts



;========================================================================
* Private functions for (un)locking the card
;========================================================================
UnlockCard:
	movem.l		d0-a6,-(sp)
	move.l		$4.w,a6
	jsr			_LVOForbid(a6)
	jsr			_LVODisable(a6)
	lea			ACAInfo,a0
	move.l		ai_CurrentCPU(a0),d0
	cmp.l		#68030,d0
	bne.s		.unlock020

.unlock030:
	move.b		#1,ACA_UnlockSet0
	move.b		#1,ACA_UnlockSet1
	move.b		#0,ACA_UnlockReset0
	move.b		#1,ACA_UnlockSet2
	move.b		#0,ACA_UnlockReset1
	move.b		#1,ACA_UnlockSet3
	bra.s		.unlock_done

.unlock020:
	move.b		#1,ACA_020UnlockSet0
	move.b		#1,ACA_020UnlockSet1
	move.b		#0,ACA_020UnlockReset0
	move.b		#1,ACA_020UnlockSet2
	move.b		#0,ACA_020UnlockReset1
	move.b		#1,ACA_020UnlockSet3
	
.unlock_done
	jsr			_LVOEnable(a6)
	jsr			_LVOPermit(a6)
	movem.l		(sp)+,d0-a6
	rts

	
LockCard:
	movem.l		d0-a6,-(sp)
	lea			ACAInfo,a0
	move.l		ai_CurrentCPU(a0),d0
	cmp.l		#68030,d0
	bne.s		.lock020

.lock030
	move.b		ACA_UnlockSet0,d0
	bra.s		.lock_done

.lock020:
	move.b		ACA_020UnlockSet0,d0
	
.lock_done:
	movem.l		(sp)+,d0-a6
	rts	


;========================================================================
* Private function for ACA500 detection
;========================================================================

acaidentify_500:
	movem.l d1-d7/a0-a6,-(sp)	; Save registers

	move.l 	$4.w,a6				; Get Exec pointer

	jsr	 	_LVOForbid(a6)		; Forbid() - Shut down Amiga OS
	bsr.s 	is_AGA
    tst.w 	d0
	bne.s 	aca500_fail			; 1200er

	lea		$a00000,a0			; get ACA 500 flashrom base adress
	move.l	$dc(a0),d1			; check for
	cmp.l	#$0ACA0500,d1		; ACA 500 identifier
	bne.s	aca500_fail

aca500_found:
	jsr		_LVOPermit(a6)		; Permit() - Restore Amiga OS
	moveq	#1,d0				; return TRUE
	movem.l (sp)+,d1-d7/a0-a6	; Restore registers
	rts

aca500_fail:
	jsr		_LVOPermit(a6)		; Permit() - Restore Amiga OS
	moveq	#0,d0

	movem.l (sp)+,d1-d7/a0-a6	; Restore registers
	rts
	
;========================================================================
* Private helper function for AGA/A1200 detection
;========================================================================

* BOOL is_AGA (VOID)
* test for AGA chipset 
* returns 1 for AGA

is_AGA:
    move.w 	$dff07c,d0
    moveq  	#31-1,d2
    and.w  	#$ff,d0
check_loop:
    move.w 	$dff07C,d1
    and.w  	#$ff,d1
    cmp.b  	d0,d1
    bne.b  	not_AGA
    dbf    	d2,check_loop
    or.b   	#$f0,d0
    cmp.b  	#$f8,d0
    bne.b  	not_AGA
    moveq  	#1,d0
    rts
not_AGA:
    moveq  	#0,d0
    rts


	
;========================================================================
* Various buffers
;========================================================================

seglist:    dc.l    0
exbase:		dc.l    0
dosbase:	dc.l	0
envbuf:		dc.l	0

	even

memory_list:	dc.l	0 ; pointer to a list of all memory chunks allocated by the library

exname:			dc.b    "expansion.library",0
dosname:		dc.b	"dos.library",0

envname:		dc.b 	"ACA_CUSTOMCHECK",0

	even
	
clocktable:		dc.l	Speed0,Speed1,Speed2,Speed3,Speed4	; ACA1233n clock speed jump table

Speed0:			dc.b	"13.33 MHz",0
Speed1:			dc.b	"16.00 MHz",0
Speed2:			dc.b	"20.00 MHz",0
Speed3:			dc.b	"26.66 MHz",0
Speed4:			dc.b	"40.00 MHz",0

Speed33:		dc.b	"33.00 MHz",0
Speed020:		dc.b	"14.18 MHz",0
SpeedACA500:	dc.b	"14.00 MHz",0

	even
*ACAInfo struct 
ACAInfo:			
				dc.w	0	; ai_MapROM
				dc.l	0	; ai_ClockInfo (pointer to struct ACAClockInfo
				dc.w	0   ; ai_Z2 mode
				dc.w	0   ; ai_NoMemcard
				dc.w	0   ; ai_WriteWaitstates
				dc.w	0   ; ai_NoC0Mem
				dc.l	0	; ai_Serial (copy of er_serial)
				dc.l	0	; ai_CurrentCPU
					
* ACASpeed struct - STRPTR Clock, UWORD SpeedStep
ClockInfoMax	dc.l	0
				dc.w	0
ClockInfo		dc.l	0
				dc.w	0
					 
ACA500			dc.l	0
FirmwareV1:		dc.l	0

ConfigDev:		dc.l	0

	cnop	0,4

fileHandle:		dc.l	0
	
fib:			ds.b	$104

kickBuffer:		dc.l	0
kickSize:		dc.l	0
	
endep:
	even


**********************************************************
	SECTION	"reboot",CODE_C

	cnop	0,4
rebootprogram:

	move.l	#$0808,d6
	movec	d6,cacr			; Flush and disable caches

	move.w 	#$2700,sr		; Disable all interrupts
	move.w 	#$7fff,$dff09a	; Disable chipset interrupts
	move.w 	#$7fff,$dff09c	; Clear pending interrupts
	move.w 	#$7fff,$dff096	; Disable chipset DMA
	move.b 	#$7f,$bfed01	; Disable CIAB interrupts
	move.b 	#$7f,$bfdd00	; Disable CIAA interrupts
	
	move.l	#$ffff,d6		; for the show
.gimmecolours
	move.w	d6,$DFF180
	subq	#1,d6
	move.w	d6,$DFF182
	dbra	d6,.gimmecolours



	move.b	#1,ACA_UnlockSet0
	move.b	#1,ACA_UnlockSet1
	move.b	#0,ACA_UnlockReset0
	move.b	#1,ACA_UnlockSet2
	move.b	#0,ACA_UnlockReset1
	move.b	#1,ACA_UnlockSet3
	
	move.b	d7,(a0)			; (de-)activate ACAMapROM
	
	clr.l 	d0
	movec 	d0,vbr			; Set VBR to $0
	
	clr.l	$4.w			; clear execbase

	
	lea.l	$1000000,a0
	sub.l	-$14(a0),a0
	move.l	4(a0),a0
	subq.l	#2,a0
	reset	
	jmp 	(a0)			; This works thanks to 68K prefetch
	

	cnop	0,4
rebootprogram_switch:

	move.l	#$0808,d6
	movec	d6,cacr			; Flush and disable caches

	move.w #$2700,sr		; Disable all interrupts
	move.w #$7fff,$dff09a	; Disable chipset interrupts
	move.w #$7fff,$dff09c	; Clear pending interrupts
	move.w #$7fff,$dff096	; Disable chipset DMA
	move.b #$7f,$bfed01		; Disable CIAB interrupts
	move.b #$7f,$bfdd00		; Disable CIAA interrupts
	
	move.l	#$ffff,d6		; for the show
.gimmecolours
	move.w	d6,$DFF180
	subq	#1,d6
	move.w	d6,$DFF182
	subq	#1,d6
	move.w	d6,$DFF184
	dbra	d6,.gimmecolours


	clr.l 	d0
	movec 	d0,vbr			; Set VBR to $0
	
	clr.l	$4.w			; clear execbase

	move.b	#1,ACA_UnlockSet0
	move.b	#1,ACA_UnlockSet1
	move.b	#0,ACA_UnlockReset0
	move.b	#1,ACA_UnlockSet2
	move.b	#0,ACA_UnlockReset1
	move.b	#1,ACA_UnlockSet3
	
	move.b	d2,(a1)
	
;	lea		ACA_CPUSwitch,a0
	move.b	#1,(a0)


	
;kickname:	dc.b	"devs:kickstarts/os39_a1200.rom",0