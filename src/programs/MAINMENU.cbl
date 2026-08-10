       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAINMENU.
       AUTHOR. COBOL DEVELOPER.
      ******************************************************************
      * HEALTH CLAIMS MANAGEMENT SYSTEM - MAIN MENU
      * Main entry point for the application
      * Provides navigation to Claims and Provider management
      ******************************************************************
       
       ENVIRONMENT DIVISION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-MENU-CHOICE              PIC X.
           88  CHOICE-CLAIMS           VALUE '1'.
           88  CHOICE-PROVIDERS        VALUE '2'.
           88  CHOICE-EXIT             VALUE '3'.
       
       01  WS-CONTINUE                 PIC X.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZE-PROGRAM
           PERFORM DISPLAY-WELCOME
           PERFORM MAIN-MENU-LOOP UNTIL CHOICE-EXIT
           PERFORM TERMINATE-PROGRAM
           STOP RUN.
       
       INITIALIZE-PROGRAM.
           DISPLAY "Initializing Health Claims Management System...".
       
       DISPLAY-WELCOME.
           DISPLAY " "
           DISPLAY "=================================================="
           DISPLAY "    HEALTH CLAIMS MANAGEMENT SYSTEM"
           DISPLAY "    Medicare & Medicaid Services"
           DISPLAY "=================================================="
           DISPLAY " ".
       
       MAIN-MENU-LOOP.
           PERFORM DISPLAY-MAIN-MENU
           PERFORM GET-MENU-CHOICE
           EVALUATE TRUE
               WHEN CHOICE-CLAIMS
                   PERFORM LAUNCH-CLAIMS-MENU
               WHEN CHOICE-PROVIDERS
                   PERFORM LAUNCH-PROVIDER-MENU
               WHEN CHOICE-EXIT
                   DISPLAY " "
                   DISPLAY "Exiting system..."
               WHEN OTHER
                   DISPLAY " "
                   DISPLAY "Invalid choice. Please try again."
           END-EVALUATE.
       
       DISPLAY-MAIN-MENU.
           DISPLAY " "
           DISPLAY "=================================================="
           DISPLAY "MAIN MENU"
           DISPLAY "=================================================="
           DISPLAY "1. Claims Management"
           DISPLAY "2. Provider Management"
           DISPLAY "3. Exit"
           DISPLAY "=================================================="
           DISPLAY " ".
       
       GET-MENU-CHOICE.
           DISPLAY "Enter your choice (1-3): " WITH NO ADVANCING
           ACCEPT WS-MENU-CHOICE.
       
       LAUNCH-CLAIMS-MENU.
           DISPLAY " "
           DISPLAY "Launching Claims Management..."
           CALL "SYSTEM" USING "bin/CLAIMENTRY".
       
       LAUNCH-PROVIDER-MENU.
           DISPLAY " "
           DISPLAY "Launching Provider Management..."
           CALL "SYSTEM" USING "bin/PROVMAINT".
       
       TERMINATE-PROGRAM.
           DISPLAY " "
           DISPLAY "Thank you for using the Health Claims System"
           DISPLAY " ".
      
      * Made with Bob
