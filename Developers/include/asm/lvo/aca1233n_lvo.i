		IFND LIBRARIES_ACA1233N_LVO_I
LIBRARIES_ACA1233N_LVO_I	SET	1

		XDEF	_LVOACA1233_GetStatus
		XDEF	_LVOACA1233_GetCurrentSpeed
		XDEF	_LVOACA1233_GetMaxSpeed
		XDEF	_LVOACA1233_SetSpeed
		XDEF	_LVOACA1233_DisableC0Mem
		XDEF	_LVOACA1233_SwitchCPU
		XDEF	_LVOACA1233_SetWaitstates
		XDEF	_LVOACA1233_MapROM
		XDEF	_LVOACA1233_SwitchZ2Compat

_LVOACA1233_GetStatus       	EQU	-30
_LVOACA1233_GetCurrentSpeed 	EQU	-36
_LVOACA1233_GetMaxSpeed     	EQU	-42
_LVOACA1233_SetSpeed        	EQU	-48
_LVOACA1233_DisableC0Mem    	EQU	-54
_LVOACA1233_SwitchCPU       	EQU	-60
_LVOACA1233_SetWaitstates   	EQU	-66
_LVOACA1233_MapROM          	EQU	-72
_LVOACA1233_SwitchZ2Compat  	EQU	-78

		ENDC
