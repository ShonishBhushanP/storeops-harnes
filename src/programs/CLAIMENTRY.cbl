       IDENTIFICATION DIVISION.
       PROGRAM-ID. CLAIMENTRY.
       AUTHOR. COBOL DEVELOPER.
      ******************************************************************
      * HEALTH CLAIMS ENTRY SYSTEM
      * Interactive program for entering medical claims
      * Validates member, provider, and procedure information
      ******************************************************************
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MEMBER-FILE
               ASSIGN TO "data/MEMBERS.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-MEMBER-STATUS.
           
           SELECT PROVIDER-FILE
               ASSIGN TO "data/PROVIDERS.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PROVIDER-STATUS.
           
           SELECT PROCEDURE-FILE
               ASSIGN TO "data/PROCEDURES.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PROCEDURE-STATUS.
           
           SELECT CLAIM-FILE
               ASSIGN TO "data/CLAIMS.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-CLAIM-STATUS.
       
       DATA DIVISION.
       FILE SECTION.
       FD  MEMBER-FILE.
       COPY MEMBER.
       
       FD  PROVIDER-FILE.
       COPY PROVIDER.
       
       FD  PROCEDURE-FILE.
       COPY PROCEDURE.
       
       FD  CLAIM-FILE.
       COPY CLAIM.
       
       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           05  WS-MEMBER-STATUS        PIC XX.
           05  WS-PROVIDER-STATUS      PIC XX.
           05  WS-PROCEDURE-STATUS     PIC XX.
           05  WS-CLAIM-STATUS         PIC XX.
       
       01  WS-FLAGS.
           05  WS-EOF-MEMBER           PIC X VALUE 'N'.
               88  EOF-MEMBER          VALUE 'Y'.
           05  WS-EOF-PROVIDER         PIC X VALUE 'N'.
               88  EOF-PROVIDER        VALUE 'Y'.
           05  WS-EOF-PROCEDURE        PIC X VALUE 'N'.
               88  EOF-PROCEDURE       VALUE 'Y'.
           05  WS-MEMBER-FOUND         PIC X VALUE 'N'.
               88  MEMBER-FOUND        VALUE 'Y'.
           05  WS-PROVIDER-FOUND       PIC X VALUE 'N'.
               88  PROVIDER-FOUND      VALUE 'Y'.
           05  WS-PROCEDURE-FOUND      PIC X VALUE 'N'.
               88  PROCEDURE-FOUND     VALUE 'Y'.
       
       01  WS-CLAIM-INPUT.
           05  WS-INPUT-MEMBER-ID      PIC X(10).
           05  WS-INPUT-PROVIDER-ID    PIC X(10).
           05  WS-INPUT-SERVICE-DATE   PIC X(10).
           05  WS-INPUT-PROCEDURE-CODE PIC X(10).
           05  WS-INPUT-DIAGNOSIS-CODE PIC X(10).
           05  WS-INPUT-BILLED-AMT     PIC 9(7)V99.
           05  WS-INPUT-BILLED-DISPLAY PIC Z,ZZZ,ZZ9.99.
       
       01  WS-CLAIM-COUNTER            PIC 9(8) VALUE 0.
       01  WS-CLAIM-ID                 PIC X(15).
       01  WS-CURRENT-DATE.
           05  WS-CURR-YEAR            PIC 9(4).
           05  WS-CURR-MONTH           PIC 9(2).
           05  WS-CURR-DAY             PIC 9(2).
       01  WS-CURRENT-TIME.
           05  WS-CURR-HOUR            PIC 9(2).
           05  WS-CURR-MINUTE          PIC 9(2).
           05  WS-CURR-SECOND          PIC 9(2).
       01  WS-DATE-STRING              PIC X(10).
       01  WS-TIME-STRING              PIC X(8).
       
       01  WS-MENU-CHOICE              PIC X.
           88  CHOICE-ENTER            VALUE '1'.
           88  CHOICE-RETURN           VALUE '2'.
       
       01  WS-CONTINUE                 PIC X.
           88  CONTINUE-YES            VALUE 'Y' 'y'.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZE-PROGRAM
           PERFORM DISPLAY-WELCOME
           PERFORM MAIN-MENU UNTIL CHOICE-RETURN
           PERFORM TERMINATE-PROGRAM
           STOP RUN.
       
       INITIALIZE-PROGRAM.
           DISPLAY "Initializing Health Claims Entry System..."
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE
           MOVE ZERO TO WS-CLAIM-COUNTER.
       
       DISPLAY-WELCOME.
           DISPLAY " "
           DISPLAY "=================================================="
           DISPLAY "    CLAIMS MANAGEMENT"
           DISPLAY "=================================================="
           DISPLAY " ".
       
       MAIN-MENU.
           DISPLAY " "
           DISPLAY "CLAIMS MENU:"
           DISPLAY "  1. Enter New Claim"
           DISPLAY "  2. Return to Main Menu"
           DISPLAY " "
           DISPLAY "Enter your choice (1-2): " WITH NO ADVANCING
           ACCEPT WS-MENU-CHOICE
           
           EVALUATE TRUE
               WHEN CHOICE-ENTER
                   PERFORM ENTER-CLAIM-PROCESS
               WHEN CHOICE-RETURN
                   DISPLAY "Returning to Main Menu..."
               WHEN OTHER
                   DISPLAY "Invalid choice. Please try again."
           END-EVALUATE.
       
       ENTER-CLAIM-PROCESS.
           DISPLAY " "
           DISPLAY "=================================================="
           DISPLAY "           NEW CLAIM ENTRY"
           DISPLAY "=================================================="
           
           PERFORM GET-CLAIM-INPUT
           PERFORM VALIDATE-CLAIM
           
           IF MEMBER-FOUND AND PROVIDER-FOUND AND PROCEDURE-FOUND
               PERFORM SAVE-CLAIM
               DISPLAY " "
               DISPLAY "Claim saved successfully!"
               DISPLAY "Claim ID: " WS-CLAIM-ID
           ELSE
               DISPLAY " "
               DISPLAY "Claim NOT saved due to validation errors."
           END-IF.
       
       GET-CLAIM-INPUT.
           DISPLAY " "
           DISPLAY "Enter Member ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT-MEMBER-ID
           
           DISPLAY "Enter Provider ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT-PROVIDER-ID
           
           DISPLAY "Enter Service Date (YYYY-MM-DD): " WITH NO ADVANCING
           ACCEPT WS-INPUT-SERVICE-DATE
           
           DISPLAY "Enter Procedure Code: " WITH NO ADVANCING
           ACCEPT WS-INPUT-PROCEDURE-CODE
           
           DISPLAY "Enter Diagnosis Code: " WITH NO ADVANCING
           ACCEPT WS-INPUT-DIAGNOSIS-CODE
           
           DISPLAY "Enter Billed Amount: " WITH NO ADVANCING
           ACCEPT WS-INPUT-BILLED-DISPLAY
           MOVE WS-INPUT-BILLED-DISPLAY TO WS-INPUT-BILLED-AMT.
       
       VALIDATE-CLAIM.
           PERFORM VALIDATE-MEMBER
           PERFORM VALIDATE-PROVIDER
           PERFORM VALIDATE-PROCEDURE.
       
       VALIDATE-MEMBER.
           MOVE 'N' TO WS-MEMBER-FOUND
           MOVE 'N' TO WS-EOF-MEMBER
           
           OPEN INPUT MEMBER-FILE
           
           IF WS-MEMBER-STATUS NOT = '00'
               DISPLAY "Error opening member file: " WS-MEMBER-STATUS
               CLOSE MEMBER-FILE
           ELSE
           
           PERFORM UNTIL EOF-MEMBER OR MEMBER-FOUND
               READ MEMBER-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-MEMBER
                   NOT AT END
                       IF MBR-ID = WS-INPUT-MEMBER-ID
                           IF MBR-ACTIVE
                               MOVE 'Y' TO WS-MEMBER-FOUND
                               DISPLAY "Member validated: " 
                                   MBR-FIRST-NAME " " MBR-LAST-NAME
                           ELSE
                               DISPLAY "ERROR: Member is not active"
                           END-IF
                       END-IF
               END-READ
           END-PERFORM
           
               IF NOT MEMBER-FOUND AND NOT EOF-MEMBER
                   DISPLAY "ERROR: Member ID not found"
               END-IF
               
               CLOSE MEMBER-FILE
           END-IF.
       
       VALIDATE-PROVIDER.
           MOVE 'N' TO WS-PROVIDER-FOUND
           MOVE 'N' TO WS-EOF-PROVIDER
           
           OPEN INPUT PROVIDER-FILE
           
           IF WS-PROVIDER-STATUS NOT = '00'
               DISPLAY "Error opening provider file: "
                   WS-PROVIDER-STATUS
               CLOSE PROVIDER-FILE
           ELSE
           
           PERFORM UNTIL EOF-PROVIDER OR PROVIDER-FOUND
               READ PROVIDER-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-PROVIDER
                   NOT AT END
                       IF PRV-ID = WS-INPUT-PROVIDER-ID
                           IF PRV-ACTIVE
                               MOVE 'Y' TO WS-PROVIDER-FOUND
                               DISPLAY "Provider validated: " PRV-NAME
                           ELSE
                               DISPLAY "ERROR: Provider is not active"
                           END-IF
                       END-IF
               END-READ
           END-PERFORM
           
               IF NOT PROVIDER-FOUND AND NOT EOF-PROVIDER
                   DISPLAY "ERROR: Provider ID not found"
               END-IF
               
               CLOSE PROVIDER-FILE
           END-IF.
       
       VALIDATE-PROCEDURE.
           MOVE 'N' TO WS-PROCEDURE-FOUND
           MOVE 'N' TO WS-EOF-PROCEDURE
           
           OPEN INPUT PROCEDURE-FILE
           
           IF WS-PROCEDURE-STATUS NOT = '00'
               DISPLAY "Error opening procedure file: "
                   WS-PROCEDURE-STATUS
               CLOSE PROCEDURE-FILE
           ELSE
           
           PERFORM UNTIL EOF-PROCEDURE OR PROCEDURE-FOUND
               READ PROCEDURE-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-PROCEDURE
                   NOT AT END
                       IF PROC-CODE = WS-INPUT-PROCEDURE-CODE
                           MOVE 'Y' TO WS-PROCEDURE-FOUND
                           DISPLAY "Procedure validated: " 
                               PROC-DESCRIPTION
                       END-IF
               END-READ
           END-PERFORM
           
               IF NOT PROCEDURE-FOUND AND NOT EOF-PROCEDURE
                   DISPLAY "ERROR: Procedure code not found"
               END-IF
               
               CLOSE PROCEDURE-FILE
           END-IF.
       
       SAVE-CLAIM.
           ADD 1 TO WS-CLAIM-COUNTER
           
           STRING "CLM" DELIMITED BY SIZE
                  WS-CURR-YEAR DELIMITED BY SIZE
                  WS-CURR-MONTH DELIMITED BY SIZE
                  WS-CURR-DAY DELIMITED BY SIZE
                  WS-CLAIM-COUNTER DELIMITED BY SIZE
                  INTO WS-CLAIM-ID
           END-STRING
           
           STRING WS-CURR-YEAR "-" 
                  WS-CURR-MONTH "-" 
                  WS-CURR-DAY
                  DELIMITED BY SIZE
                  INTO WS-DATE-STRING
           END-STRING
           
           STRING WS-CURR-HOUR ":" 
                  WS-CURR-MINUTE ":" 
                  WS-CURR-SECOND
                  DELIMITED BY SIZE
                  INTO WS-TIME-STRING
           END-STRING
           
           OPEN EXTEND CLAIM-FILE
           
           IF WS-CLAIM-STATUS NOT = '00'
               DISPLAY "Error opening claim file: " WS-CLAIM-STATUS
               CLOSE CLAIM-FILE
           ELSE
           
           MOVE WS-CLAIM-ID TO CLM-ID
           MOVE WS-INPUT-MEMBER-ID TO CLM-MEMBER-ID
           MOVE WS-INPUT-PROVIDER-ID TO CLM-PROVIDER-ID
           MOVE WS-INPUT-SERVICE-DATE TO CLM-SERVICE-DATE
           MOVE WS-INPUT-PROCEDURE-CODE TO CLM-PROCEDURE-CODE
           MOVE WS-INPUT-DIAGNOSIS-CODE TO CLM-DIAGNOSIS-CODE
           MOVE WS-INPUT-BILLED-AMT TO CLM-BILLED-AMOUNT
           MOVE WS-INPUT-BILLED-AMT TO CLM-ALLOWED-AMOUNT
           MOVE ZERO TO CLM-PAID-AMOUNT
           MOVE WS-DATE-STRING TO CLM-SUBMIT-DATE
           MOVE 'P' TO CLM-STATUS
           MOVE SPACES TO CLM-DENIAL-REASON
           MOVE WS-DATE-STRING TO CLM-ENTRY-DATE
           MOVE WS-TIME-STRING TO CLM-ENTRY-TIME
           
               WRITE CLAIM-RECORD
               
               CLOSE CLAIM-FILE
           END-IF.
       
       TERMINATE-PROGRAM.
           DISPLAY " "
           DISPLAY "Total claims entered this session: "
               WS-CLAIM-COUNTER
           DISPLAY " ".
