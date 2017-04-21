/*   ACASwitchZ2Mode
 *   a tool to disable Z3 memory autoconfig on the ACA1233n 
 *   via ACA1233n.library. The machine will start up with 9MB
 *   of Z2 fast memory.
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
char VersionString[] ="$VER: ACASwitchZ2Mode 1.1 "__AMIGADATE__;

struct Library          *DosBase       = NULL;
struct IntuitionBase    *IntuitionBase = NULL;
struct Library          *CxBase        = NULL;
struct Library          *IconBase      = NULL;
struct Library          *WorkbenchBase = NULL;
struct Library          *ACA1233nBase  = NULL;

/* Variables & pointers for the command line */
const char *const *arg_pointer;
struct RDArgs *rda;
LONG *argvalues[6];
int retval = 0;

/* Tooltype stuff */
char **ttypes;

/* variables for options & default values */
ULONG delay = 10;

struct ACASwitchOptions {
    BOOL        ao_Quiet;
    ULONG       ao_Delay;
    BOOL        ao_NoWait;
    BOOL        ao_Z2ModeOn;
    BOOL        ao_Z2ModeOff;  
    BOOL        ao_Reboot;
};

struct ACASwitchOptions AS_Options = {0};
struct ACASwitchOptions *AS_Opt = &AS_Options;
BOOL Z2Option = FALSE;


/* requesters */

char *ACAer_Cont = "Continue";
char *ACAer_Warn = "Warning";
char *ACAer_Ok = "Ok";
char *ACAer_Name = "ACASwitchZ2Mode";
char *ACAer_DelayWarn = "You cannot use the options DELAY & NOWAIT at the same time!\n";
char *ACAer_OnOffWarn = "You cannot use the options Z2 & Z3 at the same time!\n";
char *ACAer_SwitchZ2ModeConRB = "Machine will switch to Zorro II mode %ld seconds.\n\nThis will cause a reboot!\n\nFINISH ALL DISK ACTIVITY!\n";
char *ACAer_SwitchZ3ModeConRB = "Machine will switch back to Zorro III mode in %ld seconds.\n\nThis will cause a reboot!\n\nFINISH ALL DISK ACTIVITY!\n";
char *ACAer_SwitchZ2Mode = "You cannot switch to Zorro II mode from the Workbench!\n\n Start this command immediately after booting\n (e.g. as first command in your statup-sequence) n";
char *ACAer_SwitchZ3ModeRB = "Machine will switch back to Zorro III mode %ld seconds after\nconfirming this requester.This will cause a reboot!\n\nFINISH ALL DISK ACTIVITY BEFORE YOU CONTINUE!\n";
char *ACAer_SwitchZ3Mode = "Machine will switch back to Zorro III mode after the next reset\n";
char *ACAer_Z2ModeNoChange = "%s is already active. No reboot needed.\n"; 
char *ACAer_Z3ModeInteractive = "Do you want to switch back to Zorro III mode?";
struct EasyStruct ACAer_warning = {
    sizeof(struct EasyStruct),
    0, "Error",
    "",
    "OK"
};

struct EasyStruct ACAer_interactive = {
    sizeof(struct EasyStruct),
    0, " ACASwitchZ2Mem",
    "Do you want to switch to Zorro II mode?",
    "Yes|No"
};

LONG answer;

/* protos */
void Terminate(int);

/* the command template */
#define ARGS "Q=QUIET/S,N=NOWAIT/S,D=DELAY/K/N,Z2/S,Z3/S,REBOOT/S"

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
 
    argvalues[0]=argvalues[1]=argvalues[2]=argvalues[3]=argvalues[4]=argvalues[5] = NULL;
    
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
                if (argvalues[3]) AS_Opt->ao_Z2ModeOn = TRUE;
                if (argvalues[4]) AS_Opt->ao_Z2ModeOff = TRUE;
                if (argvalues[5]) AS_Opt->ao_Reboot = TRUE;
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
                if ((tt_value = FindToolType(ttypes, "Z2")) != NULL) 
                    AS_Opt->ao_Z2ModeOn = TRUE;
                if ((tt_value = FindToolType(ttypes, "Z3")) != NULL) 
                    AS_Opt->ao_Z2ModeOff = TRUE;
                if ((tt_value = FindToolType(ttypes, "REBOOT")) != NULL) 
                    AS_Opt->ao_Reboot = TRUE;
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
        
        
        /* we process options Z2 & Z3 */
        if (AS_Opt->ao_Z2ModeOn && AS_Opt->ao_Z2ModeOff) {
            
            if (argc) {
                Printf("%s", ACAer_OnOffWarn);
            }
            else {
                ACAer_warning.es_TextFormat = ACAer_OnOffWarn;
                        
                EasyRequest(NULL, &ACAer_warning, NULL);
            }

            Terminate(RETURN_ERROR);
        }
        else if (AS_Opt->ao_Z2ModeOn) Z2Option = AZ_Z2MODE;
        else if (AS_Opt->ao_Z2ModeOff) Z2Option = AZ_Z3MODE;
        else {
            if (argc) {
                
                Printf("Zorro II mode is currently %s\n", ACAInfo->ai_Z2Mode ? "active" : "disabled");
                    
                Terminate(RETURN_OK);
            }
            else {
                ACAer_warning.es_Title = ACAer_Name;
                
                if (ACAInfo->ai_Z2Mode) {
   
                    ACAer_interactive.es_TextFormat = ACAer_Z3ModeInteractive;
                    
                    answer = EasyRequest(NULL, &ACAer_interactive, NULL);
                    
                    if (answer == 1) {
                        Z2Option = AZ_Z3MODE;
                    }
                    else {
                        Terminate(RETURN_OK);
                    }
                }
                else {
                    answer = EasyRequest(NULL, &ACAer_interactive, NULL);
                    
                    if (answer ==1) { 
                        Z2Option = AZ_Z2MODE;
                    }
                    else {
                        Terminate(RETURN_OK);
                    }
                }
            }
        }
        
        if (((ACAInfo->ai_Z2Mode) && (Z2Option == AZ_Z2MODE)) || ((!(ACAInfo->ai_Z2Mode)) && (Z2Option == AZ_Z3MODE))) {
                
            if (!(AS_Opt->ao_Quiet)) {
                
                if (argc) {
                    Printf(ACAer_Z2ModeNoChange, ACAInfo->ai_Z2Mode ? "Zorro II mode" : "Zorro III mode");
                }
                else {
            
                    /* change requester title & gadget text */
                    ACAer_warning.es_Title = ACAer_Warn;
                    ACAer_warning.es_GadgetFormat = ACAer_Ok;

                    ACAer_warning.es_TextFormat = ACAer_Z2ModeNoChange;
                    
                    EasyRequest(NULL, &ACAer_warning, NULL, Z2Option ? "active" : "disabled");
                }
            }
            Terminate(RETURN_WARN);
        }

        if ( (delay != 0) ) {
            if (!(AS_Opt->ao_Quiet)) {
                
                if (AS_Opt->ao_Reboot) {
                
                    /* change requester title & gadget text */
                    ACAer_warning.es_Title = ACAer_Warn;
                    ACAer_warning.es_GadgetFormat = ACAer_Cont;
                
                    if (ACAInfo->ai_Z2Mode) {
                    
                        if (argc) {
                            Printf(ACAer_SwitchZ3ModeConRB, delay);
                        }
                        else {
                            ACAer_warning.es_GadgetFormat = ACAer_Cont;
                            ACAer_warning.es_TextFormat = ACAer_SwitchZ3ModeRB;
                        
                            EasyRequest(NULL, &ACAer_warning, NULL, delay);
                        }
                    }
                    else {
                        if (argc) {
                            Printf(ACAer_SwitchZ2ModeConRB, delay);
                        }
                        else {
                            ACAer_warning.es_TextFormat = ACAer_SwitchZ2Mode;
                        
                            EasyRequest(NULL, &ACAer_warning, NULL, delay);
                            
                            Terminate(RETURN_FAIL);
                        }
                    }
                    Delay(delay * 50);
                }
                else {
                    if (ACAInfo->ai_Z2Mode) {
                    
                        if (argc) {
                            Printf(ACAer_SwitchZ3Mode);
                        }
                        else {
                            ACAer_warning.es_GadgetFormat = ACAer_Cont;
                            ACAer_warning.es_TextFormat = ACAer_SwitchZ3Mode;
                        
                            EasyRequest(NULL, &ACAer_warning, NULL, delay);
                        }
                    }
                    else {
                        if (argc) {
                            Printf(ACAer_SwitchZ2Mode, delay);
                        }
                        else {
                            ACAer_warning.es_TextFormat = ACAer_SwitchZ2Mode;
                        
                            EasyRequest(NULL, &ACAer_warning, NULL, delay);
                            
                            Terminate(RETURN_FAIL);
                        }
                    }
                }
                    
            }
        }
               
        /* TODO: Interactive mode, lib funktion anpassen, doppelte strings einsparen */
        /* machine will reset after the next instruction (if successful) */
        success = ACA1233_SwitchZ2Compat(Z2Option);
        
        if (!(success)) {
            if (!(AS_Opt->ao_Quiet)) {
                
                Printf("Something went wrong...\n");
                Terminate(RETURN_FAIL);
            }
        }
        else {
        
            if (AS_Opt->ao_Reboot) {
                ColdReboot();
                Terminate(RETURN_FAIL);
            }
            else Terminate(RETURN_OK);
        }
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




    
