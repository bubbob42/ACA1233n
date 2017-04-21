/*   ACAInfo
 *   a tool to display turbocard settings of the ACA1233n
 *   via ACA1233n.library.
 *
 *   generates proper AmigaDOS return codes
 *   for scripting
 *
 *   Marcus Gerards, 2016
 */

#include <exec/types.h>
#include <proto/exec.h>
#include <dos/dos.h>
#include <proto/dos.h>
#include <libraries/ACA1233n.h>
#include <proto/ACA1233n.h>

/* Version information */
char VersionString[] ="$VER: ACAInfo 1.0 "__AMIGADATE__;

struct Library *DosBase;
struct Library *ACA1233nBase;

/* Variables & pointers for the command line */
const char *const *arg_pointer;
struct RDArgs *rda;
LONG *argvalues[4];
int retval = 0;

/* protos */
void DisplayCardInfo(void);

/* the command template */
#define ARGS "Q=QUIET/S,CS=CHECKSPEEDSTEP/K/N,CA=CPUACTIVE/S"

/* return variables/pointers for ACA1233.library */
BOOL speedSuccess;                      /* return value for SetSpeed */
struct ACAClockInfo *ACAMaxSpeed = NULL;   /* pointer to max speed stepping/clock data structure of the lib */
struct ACAClockInfo *ACASpeed = NULL;      /* pointer to current speed stepping/clock data structure of the lib */
struct ACA1233Info *ACAInfo = NULL;

/* Here we go */
int main(argc,argv)      
    int argc;
    char **argv; 
{
    argvalues[0]=argvalues[1]=argvalues[2]=argvalues[3] = NULL;
 
    /* this program is >OS 2.0 only, sorry */
    DosBase     = (struct Library *) OpenLibrary(DOSNAME,37L);   
    ACA1233nBase = (struct Library *) OpenLibrary(ACA1233nNAME,0L);
    
    if (DosBase && ACA1233nBase) {
        
        /* We should always get a return values from here, on because the library
           already checked if an ACA1233n is present at this point.
        */

        if ( (rda = ReadArgs(ARGS, (LONG *) argvalues, NULL)) != NULL ) {
            
            ACAInfo = ACA1233_GetStatus();
            ACAMaxSpeed = ACA1233_GetMaxSpeed();
            
            /* CHECKSPEED - user wants to check the card's current clock */
            if (argvalues[1]) {
                /* query current speed */
                ACASpeed = ACA1233_GetCurrentSpeed();
                
                if (*argvalues[1] == ACASpeed->ci_CPUSpeedStep) {
                    
                    if (!(argvalues[0])) {
                        Printf("Check successful - current speed stepping of this card is %ld (%s)\n", 
                                        ACASpeed->ci_CPUSpeedStep, ACASpeed->ci_CPUClock);
                    }
                    retval = RETURN_OK;
                }
                else {
                    if (!(argvalues[0])) {
                        Printf("Check *not* successful - current speed stepping of this card is %ld (%s)\n", 
                                        ACASpeed->ci_CPUSpeedStep, ACASpeed->ci_CPUClock);
                    }
                    retval = RETURN_WARN;
                }
            }
            
            /* user wants to check which CPU is active */
            if ( (argvalues[2]) && (retval == RETURN_OK) ) {
                
                if (ACAInfo->ai_CurrentCPU == 68030) {
                    
                    if (!(argvalues[0])) {
                        Printf("Check successful - active CPU: MC%ld.\n", ACAInfo->ai_CurrentCPU);
                    }
                    retval = RETURN_OK;
                }
                else {
                    if (!(argvalues[0])) {
                        Printf("Check *not* successful - active CPU: MC%ld!\n", ACAInfo->ai_CurrentCPU);
                    }
                    retval = RETURN_WARN;
                }
            }
            
            if ( !(argvalues[0] || argvalues[1] || argvalues[2]) ) {
                DisplayCardInfo();
            }
            FreeArgs(rda);
        } else {
            PrintFault(IoErr(), NULL);
            retval = RETURN_FAIL;
        }
    } else {
        if (DosBase == NULL) Printf("Cannot open dos.library V37+!\n");
        if (ACA1233nBase == NULL) Printf("Cannot open ACA1233n.library!\n");
        retval = RETURN_FAIL;
    }
    if (DosBase != NULL) CloseLibrary((struct Library *) DosBase);  
    if (ACA1233nBase != NULL) CloseLibrary((struct Library *) ACA1233nBase); 
    return (retval);
}

void DisplayCardInfo(void) {
    
    Printf("\nACA 1233n settings:\n");
    Printf("-----------------------------------------\n");
    Printf("MapROM status: %s\n", ACAInfo->ai_MapROM ? "enabled" : "disabled");
    Printf("Active CPU: %ld\n", ACAInfo->ai_CurrentCPU);
    Printf("Speed stepping: %ld\n", (UWORD)  ACAInfo->ai_ClockInfo->ci_CPUSpeedStep);
    Printf("Machine's current clock frequency: %s\n", ACAInfo->ai_ClockInfo->ci_CPUClock);
    Printf("Z2-mode: %s\n", ACAInfo->ai_Z2Mode ? "enabled" : "disabled");
    Printf("Memcard: %s\n", ACAInfo->ai_NoMemcard ? "disabled" : "enabled");
    Printf("Write waitstates: %ld\n", ACAInfo->ai_WriteWaitstates);
    Printf("SlowRam at 0x0c00000: %s\n", ACAInfo->ai_NoC0Mem ? "disabled" : "enabled");
    Printf("Card is a %s version\n", ACAMaxSpeed->ci_CPUClock);
    Printf("-----------------------------------------\n");

    
    return;
}



    
