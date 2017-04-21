/*   ACASwitchC0Mem
 *   a tool to switch off/on the 1 MB of memory starting at 
 *   0x0c00000, also known as "SlowRam" via ACA1233n.library.
 *
 *   generates proper AmigaDOS return codes
 *   for scripting and requesters when run from Workbench
 *
 *   Marcus Gerards, 2016
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
char VersionString[] ="$VER: ACASwitchC0Mem 1.0 "__AMIGADATE__;

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
    BOOL        ao_Quiet;
    ULONG       ao_Delay;
    BOOL        ao_NoWait;
    BOOL        ao_C0MemOn;
    BOOL        ao_C0MemOff;  
};

struct ACASwitchOptions AS_Options = {0};
struct ACASwitchOptions *AS_Opt = &AS_Options;
BOOL C0Option = FALSE;


/* requesters */

char *ACAer_Cont = "Continue";
char *ACAer_Warn = "Warning";
char *ACAer_Ok = "Ok";
char *ACAer_DelayWarn = "You cannot use the options DELAY & NOWAIT at the same time!\n";
char *ACAer_OnOffWarn = "You cannot use the options ON & OFF at the same time!\n";
char *ACAer_SwitchOffC0MemCon = "Machine will switch off SlowRAM-area in %ld seconds.\n\nThis will cause a reboot!\n\nFINISH ALL DISK ACTIVITY!\n";
char *ACAer_SwitchOnC0MemCon = "Machine will switch back on SlowRam-area in %ld seconds.\n\nThis will cause a reboot!\n\nFINISH ALL DISK ACTIVITY!\n";
char *ACAer_SwitchOffC0Mem = "Machine will switch off SlowRAM-area %ld seconds after\nconfirming this requester. This will cause a reboot!\n\nFINISH ALL DISK ACTIVITY FIRST!\n";
char *ACAer_SwitchOnC0Mem = "Machine will switch back on SlowRam-area %ld seconds after\nconfirming this requester.This will cause a reboot!\n\nFINISH ALL DISK ACTIVITY BEFORE YOU CONTINUE!\n";
char *ACAer_C0MemNoChange = "C0 memory is already %s. No reboot needed.\n"; 
char *ACAer_C0MemOnInteractive = "Do you want to switch back on the C0-memory?";
struct EasyStruct ACAer_warning = {
    sizeof(struct EasyStruct),
    0, "Error",
    "",
    "OK"
};

struct EasyStruct ACAer_interactive = {
    sizeof(struct EasyStruct),
    0, " ACASwitchC0MemCPU",
    "Do you want to disable turbocard's C0-memory?",
    "Yes|No"
};

LONG answer;

/* protos */
void Terminate(int);

/* the command template */
#define ARGS "Q=QUIET/S,N=NOWAIT/S,D=DELAY/K/N,ON/S,OFF/S"

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
                PrintFault(IoErr(), NULL);
                
                Terminate(RETURN_FAIL);
            }
            else {
                if (argvalues[0]) AS_Opt->ao_Quiet = TRUE;
                if (argvalues[1]) AS_Opt->ao_NoWait = TRUE;
                if (argvalues[2]) AS_Opt->ao_Delay = *argvalues[2];
                if (argvalues[3]) AS_Opt->ao_C0MemOn = TRUE;
                if (argvalues[4]) AS_Opt->ao_C0MemOff = TRUE;
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
                if ((tt_value = FindToolType(ttypes, "NOWAIT")) != NULL) 
                    AS_Opt->ao_NoWait = TRUE;
                if ((tt_value = FindToolType(ttypes, "DELAY")) != NULL) 
                    AS_Opt->ao_Delay = atoi(tt_value);
                if ((tt_value = FindToolType(ttypes, "ON")) != NULL) 
                    AS_Opt->ao_C0MemOn = TRUE;
                if ((tt_value = FindToolType(ttypes, "OFF")) != NULL) 
                    AS_Opt->ao_C0MemOff = TRUE;
            }
            else {
                Terminate(RETURN_FAIL);
            }
        }
        
        ACAInfo = ACA1233_GetStatus();
        

        /* we process options NOWAIT & DELAY */
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
        
        /* NOWAIT selected - remove reboot delay */
        if (AS_Opt->ao_NoWait) {
            delay = 0;
        }
        
        /* DELAY specified - check value */
        else if (AS_Opt->ao_Delay) {
            if (AS_Opt->ao_Delay < 0) {}
            else if (AS_Opt->ao_Delay > 60) delay = 60;
            else delay = AS_Opt->ao_Delay;
        }
        
        
        /* we process options ON & OFF */
        if (AS_Opt->ao_C0MemOn && AS_Opt->ao_C0MemOff) {
            
            if (argc) {
                Printf("%s", ACAer_OnOffWarn);
            }
            else {
                ACAer_warning.es_TextFormat = ACAer_OnOffWarn;
                        
                EasyRequest(NULL, &ACAer_warning, NULL);
            }

            Terminate(RETURN_ERROR);
        }
        else if (AS_Opt->ao_C0MemOn) C0Option = AC_C0MEM;
        else if (AS_Opt->ao_C0MemOff) C0Option = AC_NOC0MEM;
        else {
            if (argc) {
                
                Printf("C0-memory is currently %s\n", ACAInfo->ai_NoC0Mem ? "disabled" : "active");
                    
                Terminate(RETURN_OK);
            }
            else {
                if (ACAInfo->ai_NoC0Mem) {
                    ACAer_interactive.es_TextFormat = ACAer_C0MemOnInteractive;
                    
                    answer = EasyRequest(NULL, &ACAer_interactive, NULL);
                    
                    if (answer == 1) {
                        C0Option = AC_C0MEM;
                    }
                    else {
                        Terminate(RETURN_OK);
                    }
                }
                else {
                    answer = EasyRequest(NULL, &ACAer_interactive, NULL);
                    
                    if (answer ==1) { 
                        C0Option = AC_NOC0MEM;
                    }
                    else {
                        Terminate(RETURN_OK);
                    }
                }
            }
        }
        
        if (((ACAInfo->ai_NoC0Mem) && (C0Option == AC_NOC0MEM)) || ((!(ACAInfo->ai_NoC0Mem)) && (C0Option == AC_C0MEM))) {
                
            if (!(AS_Opt->ao_Quiet)) {
                
                if (argc) {
                    Printf(ACAer_C0MemNoChange, C0Option ? "active" : "disabled");
                }
                else {
            
                    /* change requester title & gadget text */
                    ACAer_warning.es_Title = ACAer_Warn;
                    ACAer_warning.es_GadgetFormat = ACAer_Ok;

                    ACAer_warning.es_TextFormat = ACAer_C0MemNoChange;
                    
                    EasyRequest(NULL, &ACAer_warning, NULL, C0Option ? "active" : "disabled");
                }
            }
            Terminate(RETURN_WARN);
        }

        if ( (delay != 0) ) {
            if (!(AS_Opt->ao_Quiet)) {
                
                /* change requester title & gadget text */
                ACAer_warning.es_Title = ACAer_Warn;
                ACAer_warning.es_GadgetFormat = ACAer_Cont;
                
                if (ACAInfo->ai_NoC0Mem) {
                    
                    if (argc) {
                        Printf(ACAer_SwitchOnC0MemCon, delay);
                    }
                    else {
                        ACAer_warning.es_GadgetFormat = ACAer_Cont;
                        ACAer_warning.es_TextFormat = ACAer_SwitchOnC0Mem;
                        
                        EasyRequest(NULL, &ACAer_warning, NULL, delay);
                    }
                }
                else {
                    if (argc) {
                        Printf(ACAer_SwitchOffC0MemCon, delay);
                    }
                    else {
                        ACAer_warning.es_TextFormat = ACAer_SwitchOffC0Mem;
                        
                        EasyRequest(NULL, &ACAer_warning, NULL, delay);
                    }
                }
            }
        }
            
        Delay(delay * 50);
               
        /* TODO: Interactive mode, lib funktion anpassen, doppelte strings einsparen */
        /* machine will reset after the next instruction (if successful) */
        success = ACA1233_DisableC0Mem(C0Option);
        
        if (!(success)) {
            if (!(AS_Opt->ao_Quiet)) {
                
                Printf("Something went wrong...\n");
            }
        }

        Terminate(RETURN_FAIL);
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




    
