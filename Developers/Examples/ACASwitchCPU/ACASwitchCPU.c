/*   ACASwitchCPU
 *   a tool to switch between the 68030 of the ACA1`233n
 *   and the A1200's internal 68EC020 via ACA1233n.library.
 *
 *   generates proper AmigaDOS return codes
 *   for scripting and requesters when run from Workbench
 *
 *   Marcus Gerards, 2016-2017
 */

#include <stdlib.h>

#include <clib/alib_protos.h>
#include <exec/types.h>
#include <proto/exec.h>
#include <proto/commodities.h>
#include <proto/icon.h>
#include <proto/intuition.h>
#include <dos/dos.h>
#include <proto/dos.h>
#include <libraries/ACA1233n.h>
#include <proto/ACA1233n.h>

/* Version information */
char VersionString[] ="$VER: ACASwitchCPU 1.2 "__AMIGADATE__;

struct Library          *DosBase       = NULL;
struct IntuitionBase    *IntuitionBase = NULL;
struct Library          *CxBase        = NULL;
struct Library          *IconBase      = NULL;
struct Library          *WorkbenchBase = NULL;
struct Library          *ACA1233nBase  = NULL;

/* Variables & pointers for the command line */
const char *const *arg_pointer;
struct RDArgs *rda;
LONG *argvalues[5];
int retval = 0;

/* Tooltype stuff */
char **ttypes;

/* variables for options & default values */
ULONG delay = 10;

struct ACASwitchOptions {
    ULONG       ao_CPU;
    BOOL        ao_NoMemcard;
    BOOL        ao_Quiet;
    ULONG       ao_Delay;
    BOOL        ao_NoWait;
};

struct ACASwitchOptions AS_Options = {0};
struct ACASwitchOptions *AS_Opt = &AS_Options;


/* requesters */
struct EasyStruct ACAer_warning = {
    sizeof(struct EasyStruct),
    0, "Error",
    "Your firmware does not support NOMEMCARD\n\nContact IComp for update!",
    "OK"
};

struct EasyStruct ACAer_interactive = {
    sizeof(struct EasyStruct),
    0, " ACASwitchCPU",
    "Do you want to disable turbocard's memory?",
    "Yes|No"
};
char *ACAer_OneWayTicketWarn = "NoMemcard is active!\n\nFlip the power switch\n to get you memory back\nor to switch CPUs";
char *ACAer_from020 = "Do you want to re-enable turbocard's memory?";
char *ACAer_Cont = "Continue";
char *ACAer_Warn = "Warning";
char *ACAer_CPUWarn = "CPU %ld is already active!\n\nTerminating...";  
char *ACAer_DelayWarn = "You cannot use the options DELAY & NOWAIT at the same time!";
char *ACAer_SwitchOff030 = "Machine will switch off CPU 68030 %ld seconds after\nconfirming this requester. This will cause a reboot!\n\nFINISH ALL DISK ACTIVITY FIRST!";
char *ACAer_SwitchOn030 = "Machine will switch back to CPU 68030 %ld seconds after\nconfirming this requester.This will cause a reboot!\n\nFINISH ALL DISK ACTIVITY BEFORE YOU CONTINUE!";

LONG answer;

/* protos */
void Terminate(int);

/* the command template */
#define ARGS "Q=QUIET/S,C=CPU/K/N,N=NOWAIT/S,D=DELAY/K/N,NM=NOMEMCARD/S"

/* return variables/pointers for ACA1233.library */
struct ACA1233Info *ACAInfo = NULL;
BOOL success = FALSE;

/* Here we go */
int main(argc,argv)      
    int argc;
    char **argv; 
{
    char *tt_value;     /* for processing tooltypes */
    BOOL NoOpt = TRUE;  /* flag to check for interactive mode */
 
    argvalues[0]=argvalues[1]=argvalues[2]=argvalues[3]=argvalues[4] = NULL;
    
    /* this program is >OS 2.0 only, sorry */
    DosBase             = (struct Library *)     OpenLibrary(DOSNAME,37L);   
    ACA1233nBase        = (struct Library *)     OpenLibrary(ACA1233nNAME,0L);
    IntuitionBase       = (struct IntuitionBase *) OpenLibrary("intuition.library",39);
    CxBase              =                        OpenLibrary("commodities.library",5);
    IconBase            =                        OpenLibrary("icon.library",37);
    WorkbenchBase       =                        OpenLibrary("workbench.library",37);

    
    if (DosBase && ACA1233nBase) {
        
        /* We should always get a return values from here, on because the library
           already checked if an ACA1233n is present at this point.
        */
        
        /* start from shell */
        if (argc) {
            if ( ! (rda = ReadArgs(ARGS, (LONG *) argvalues, NULL))) {
                Terminate(RETURN_FAIL);
            }
            else {
                if (argvalues[0]) AS_Opt->ao_Quiet = TRUE;
                if (argvalues[1]) AS_Opt->ao_CPU = *argvalues[1];
                if (argvalues[2]) AS_Opt->ao_NoWait = TRUE;
                if (argvalues[3]) AS_Opt->ao_Delay = *argvalues[3];
                if (argvalues[4]) AS_Opt->ao_NoMemcard = TRUE;
            }
                    
        }
        else {
            /* start from Workbench */
            
            if (WorkbenchBase && IntuitionBase && IconBase && CxBase) {
                
                ttypes = ArgArrayInit( argc, argv );
                 
                /* parse ToolType-Settings */
                if ((tt_value = FindToolType(ttypes, "QUIET")) != NULL) {
                    AS_Opt->ao_Quiet = TRUE;
                    NoOpt = FALSE;
                }
                if ((tt_value = FindToolType(ttypes, "CPU")) != NULL) {
                    AS_Opt->ao_CPU = atoi(tt_value);
                    NoOpt = FALSE;
                }
                if ((tt_value = FindToolType(ttypes, "NOMEMCARD")) != NULL) {
                    AS_Opt->ao_NoMemcard = TRUE;
                    NoOpt = FALSE;
                }
                if ((tt_value = FindToolType(ttypes, "NOWAIT")) != NULL) 
                    AS_Opt->ao_NoWait = TRUE;
                if ((tt_value = FindToolType(ttypes, "DELAY")) != NULL) 
                    AS_Opt->ao_Delay = atoi(tt_value);
            }
            else {
                Terminate(RETURN_FAIL);
            }
        }
        
        ACAInfo = ACA1233_GetStatus();
        
        /* we are stuck once we are in 020 mode and nomemcard is active) */
        if (ACAInfo->ai_NoMemcard) {
            
            if (argc) {
                Printf("You cannot switch the CPU once NoMemcard has been activated, terminating...\n", AS_Opt->ao_CPU);
            }
            else {
                ACAer_warning.es_TextFormat = ACAer_OneWayTicketWarn;
                        
                EasyRequest(NULL, &ACAer_warning, NULL, ACAInfo->ai_CurrentCPU);
            }
            Terminate(RETURN_FAIL);
        }
        
        /* enable interactive mode if started from WB 
           and NOMEMCARD/CPU & QUIET are not set 
        */
        if ( ! (argc && NoOpt) ) {
                    
            if (ACAInfo->ai_CurrentCPU != 68030) {
                
                if (ACAInfo->ai_NoMemcard) {
                    ACAer_interactive.es_TextFormat = ACAer_from020;
                    
                    answer = EasyRequest(NULL, &ACAer_interactive, NULL);
                }
            }
            else {
                answer = EasyRequest(NULL, &ACAer_interactive, NULL);
            }
            
            if (answer == 1) {
                AS_Opt->ao_NoMemcard = TRUE;
            }
        }

        /* now we check if the user wants a specific CPU */
        if (AS_Opt->ao_CPU) {
            if (AS_Opt->ao_CPU == ACAInfo->ai_CurrentCPU) {
                if (!(AS_Opt->ao_Quiet)) {
                    if (argc) {
                        Printf("The specified CPU %ld is already active, terminating...\n", AS_Opt->ao_CPU);
                    }
                    else {
                        ACAer_warning.es_TextFormat = ACAer_CPUWarn;
                        
                        EasyRequest(NULL, &ACAer_warning, NULL, ACAInfo->ai_CurrentCPU);
                    }
                }
                Terminate(RETURN_ERROR);
            }
        }
 
        /* then we process options NOWAIT & DELAY */
        if (AS_Opt->ao_NoWait && AS_Opt->ao_Delay) {
            
            if (argc) {
                Printf("%s", ACAer_DelayWarn);
            }
            else {
                ACAer_warning.es_TextFormat = ACAer_DelayWarn;
                        
                EasyRequest(NULL, &ACAer_warning, NULL);
            }

            Terminate(RETURN_ERROR);
        }
        
        /* NOWAIT selected - remove CPU switch delay */
        if (AS_Opt->ao_NoWait) {
            delay = 0;
        }
        
        /* DELAY specified - check value */
        else if (AS_Opt->ao_Delay) {
            if (AS_Opt->ao_Delay < 0) {}
            else if (AS_Opt->ao_Delay > 60) delay = 60;
            else delay = AS_Opt->ao_Delay;
        }
                        
        if ( (delay != 0) ) {
            if (!(AS_Opt->ao_Quiet)) {
                
                /* change requester title & gadget text */
                ACAer_warning.es_Title = ACAer_Warn;
                ACAer_warning.es_GadgetFormat = ACAer_Cont;
                
                if (ACAInfo->ai_CurrentCPU == 68030) {
                    if (argc) {
                        Printf("Switching off CPU 68030 in %ld seconds...\n", delay);
                    }
                    else {
                        ACAer_warning.es_GadgetFormat = ACAer_Cont;
                        ACAer_warning.es_TextFormat = ACAer_SwitchOff030;
                        
                        EasyRequest(NULL, &ACAer_warning, NULL, delay);
                    }
                }
                else {
                    if (argc) {
                        Printf("Switching back to CPU 68030 in %ld seconds...\n", delay);
                    }
                    else {
                        ACAer_warning.es_TextFormat = ACAer_SwitchOn030;
                        
                        EasyRequest(NULL, &ACAer_warning, NULL, delay);
                    }
                }
            }
        }
            
        Delay(delay * 50);
                
        /* machine will reset after the next instruction */
        if (AS_Opt->ao_NoMemcard) {
            if (!(ACA1233_SwitchCPU(AS_MEMCARDOFF))) {
                if (argc) {
                    Printf("Your card's firmware does not support disabling memory. Please contact IComp for firmware upgrade.\n");
                }
                else {
                    EasyRequest(NULL, &ACAer_warning, NULL);
                }       
                Terminate(RETURN_ERROR);
            }
        }
        else {
            ACA1233_SwitchCPU(AS_MEMCARDON);
        }
 
        Terminate(RETURN_OK);
    }
    else {
        Terminate(RETURN_FAIL);
    }
}

/* general purpose cleanup function */ 
void Terminate(int retval) {
    
    if (rda) {
        FreeArgs(rda);
    }
    else {
        PrintFault(IoErr(), NULL);
    }
    
    if (ACA1233nBase == NULL) {
        Printf("Cannot open ACA1233n.library!\n");
    }
    else {
        CloseLibrary((struct Library *) ACA1233nBase);
    } 
    if (DosBase != NULL) CloseLibrary((struct Library *) DosBase);
    if (CxBase)          CloseLibrary(CxBase);
    if (IntuitionBase)   CloseLibrary((struct Library *)IntuitionBase);
    if (IconBase)        CloseLibrary(IconBase);
    if (WorkbenchBase)   CloseLibrary(WorkbenchBase);

    exit(retval);
}




    
