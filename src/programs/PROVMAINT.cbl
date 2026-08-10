       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROVMAINT.
       AUTHOR. COBOL DEVELOPER.
      ******************************************************************
      * PROVIDER MAINTENANCE SYSTEM
      * Interactive program for managing healthcare providers
      * Supports Create, Read, Update, and Delete operations
      ******************************************************************
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PROVIDER-FILE
               ASSIGN TO "data/PROVIDERS.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PROVIDER-STATUS.
           
           SELECT PROVIDER-TEMP
               ASSIGN TO "data/PROVIDERS.tmp"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-TEMP-STATUS.
       
       DATA DIVISION.
       FILE SECTION.
       FD  PROVIDER-FILE.
       COPY PROVIDER.
       
       FD  PROVIDER-TEMP.
       01  TEMP-PROVIDER-RECORD        PIC X(223).
       
       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           05  WS-PROVIDER-STATUS      PIC XX.
           05  WS-TEMP-STATUS          PIC XX.
       
       01  WS-FLAGS.
           05  WS-EOF-PROVIDER         PIC X VALUE 'N'.
               88  EOF-PROVIDER        VALUE 'Y'.
           05  WS-PROVIDER-FOUND       PIC X VALUE 'N'.
               88  PROVIDER-FOUND      VALUE 'Y'.
           05  WS-UPDATE-MODE          PIC X VALUE 'N'.
               88  UPDATE-MODE         VALUE 'Y'.
       
       01  WS-PROVIDER-INPUT.
           05  WS-INPUT-ID             PIC X(10).
           05  WS-INPUT-NAME           PIC X(50).
           05  WS-INPUT-SPECIALTY      PIC X(30).
           05  WS-INPUT-ADDRESS        PIC X(50).
           05  WS-INPUT-CITY           PIC X(30).
           05  WS-INPUT-STATE          PIC X(2).
           05  WS-INPUT-ZIP            PIC X(10).
           05  WS-INPUT-PHONE          PIC X(15).
           05  WS-INPUT-NPI            PIC X(10).
           05  WS-INPUT-TAX-ID         PIC X(15).
           05  WS-INPUT-STATUS         PIC X(1).
       
       01  WS-PROVIDER-BACKUP.
           05  WS-BACKUP-ID            PIC X(10).
           05  WS-BACKUP-NAME          PIC X(50).
           05  WS-BACKUP-SPECIALTY     PIC X(30).
           05  WS-BACKUP-ADDRESS       PIC X(50).
           05  WS-BACKUP-CITY          PIC X(30).
           05  WS-BACKUP-STATE         PIC X(2).
           05  WS-BACKUP-ZIP           PIC X(10).
           05  WS-BACKUP-PHONE         PIC X(15).
           05  WS-BACKUP-NPI           PIC X(10).
           05  WS-BACKUP-TAX-ID        PIC X(15).
           05  WS-BACKUP-STATUS        PIC X(1).
       
       01  WS-COUNTERS.
           05  WS-PROVIDER-COUNT       PIC 9(4) VALUE 0.
           05  WS-NEXT-ID-NUM          PIC 9(8) VALUE 0.
           05  WS-RECORDS-PROCESSED    PIC 9(4) VALUE 0.
       
       01  WS-MENU-CHOICE              PIC X.
           88  CHOICE-CREATE           VALUE '1'.
           88  CHOICE-UPDATE           VALUE '2'.
           88  CHOICE-DELETE           VALUE '3'.
           88  CHOICE-REACTIVATE       VALUE '4'.
           88  CHOICE-LIST             VALUE '5'.
           88  CHOICE-SEARCH           VALUE '6'.
           88  CHOICE-RETURN           VALUE '7'.
       
       01  WS-CONTINUE                 PIC X.
           88  CONTINUE-YES            VALUE 'Y' 'y'.
       
       01  WS-CONFIRM                  PIC X.
           88  CONFIRM-YES             VALUE 'Y' 'y'.
       
       01  WS-PAUSE                    PIC X.
       
       01  WS-UPDATE-CHOICE            PIC X.
           88  UPDATE-NAME             VALUE '1'.
           88  UPDATE-SPECIALTY        VALUE '2'.
           88  UPDATE-ADDRESS          VALUE '3'.
           88  UPDATE-CITY             VALUE '4'.
           88  UPDATE-STATE            VALUE '5'.
           88  UPDATE-ZIP              VALUE '6'.
           88  UPDATE-PHONE            VALUE '7'.
           88  UPDATE-NPI              VALUE '8'.
           88  UPDATE-TAX-ID           VALUE '9'.
           88  UPDATE-STATUS           VALUE 'A' 'a'.
           88  UPDATE-DONE             VALUE '0'.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZE-PROGRAM
           PERFORM DISPLAY-WELCOME
           PERFORM MAIN-MENU-LOOP UNTIL CHOICE-RETURN
           PERFORM TERMINATE-PROGRAM
           STOP RUN.
       
       INITIALIZE-PROGRAM.
           DISPLAY " "
           DISPLAY "Initializing Provider Maintenance System..."
           MOVE 'N' TO WS-EOF-PROVIDER
           MOVE 'N' TO WS-PROVIDER-FOUND
           MOVE 'N' TO WS-UPDATE-MODE.
       
       DISPLAY-WELCOME.
           DISPLAY " "
           DISPLAY "================================================"
           DISPLAY "    PROVIDER MANAGEMENT"
           DISPLAY "================================================"
           DISPLAY " ".
       
       MAIN-MENU-LOOP.
           PERFORM DISPLAY-MAIN-MENU
           PERFORM GET-MENU-CHOICE
           EVALUATE TRUE
               WHEN CHOICE-CREATE
                   PERFORM CREATE-PROVIDER-PROCESS
               WHEN CHOICE-UPDATE
                   PERFORM UPDATE-PROVIDER-PROCESS
               WHEN CHOICE-DELETE
                   PERFORM DELETE-PROVIDER-PROCESS
               WHEN CHOICE-REACTIVATE
                   PERFORM REACTIVATE-PROVIDER-PROCESS
               WHEN CHOICE-LIST
                   PERFORM LIST-PROVIDERS-PROCESS
               WHEN CHOICE-SEARCH
                   PERFORM SEARCH-PROVIDER-PROCESS
               WHEN CHOICE-RETURN
                   DISPLAY " "
                   DISPLAY "Returning to Main Menu..."
               WHEN OTHER
                   DISPLAY " "
                   DISPLAY "Invalid choice. Please try again."
           END-EVALUATE.
       
       DISPLAY-MAIN-MENU.
           DISPLAY " "
           DISPLAY "================================================"
           DISPLAY "PROVIDER MENU"
           DISPLAY "================================================"
           DISPLAY "1. Create New Provider"
           DISPLAY "2. Update Provider"
           DISPLAY "3. Delete Provider (Mark Inactive)"
           DISPLAY "4. Reactivate Provider"
           DISPLAY "5. List All Providers"
           DISPLAY "6. Search Provider by ID"
           DISPLAY "7. Return to Main Menu"
           DISPLAY "================================================".
       
       GET-MENU-CHOICE.
           DISPLAY " "
           DISPLAY "Enter your choice (1-7): " WITH NO ADVANCING
           ACCEPT WS-MENU-CHOICE.
       
      ******************************************************************
      * CREATE PROVIDER PROCESS
      ******************************************************************
       CREATE-PROVIDER-PROCESS.
           DISPLAY " "
           DISPLAY "================================================"
           DISPLAY "CREATE NEW PROVIDER"
           DISPLAY "================================================"
           
           PERFORM GET-NEXT-PROVIDER-ID
           DISPLAY "New Provider ID: " WS-INPUT-ID
           
           PERFORM GET-PROVIDER-DETAILS
           
           DISPLAY " "
           DISPLAY "Confirm creation of new provider? (Y/N): "
               WITH NO ADVANCING
           ACCEPT WS-CONFIRM
           
           IF CONFIRM-YES
               PERFORM SAVE-NEW-PROVIDER
               DISPLAY " "
               DISPLAY "Provider created successfully!"
               DISPLAY "Provider ID: " WS-INPUT-ID
           ELSE
               DISPLAY " "
               DISPLAY "Provider creation cancelled."
           END-IF.
       
       GET-NEXT-PROVIDER-ID.
           MOVE 0 TO WS-NEXT-ID-NUM
           OPEN INPUT PROVIDER-FILE
           IF WS-PROVIDER-STATUS NOT = "00"
               DISPLAY "Note: Creating first provider in system"
               MOVE 1 TO WS-NEXT-ID-NUM
           ELSE
               PERFORM READ-ALL-PROVIDERS-FOR-ID
               CLOSE PROVIDER-FILE
               ADD 1 TO WS-NEXT-ID-NUM
           END-IF
           STRING "P" DELIMITED BY SIZE
                  WS-NEXT-ID-NUM DELIMITED BY SIZE
                  INTO WS-INPUT-ID
           INSPECT WS-INPUT-ID REPLACING ALL " " BY "0".
       
       READ-ALL-PROVIDERS-FOR-ID.
           MOVE 'N' TO WS-EOF-PROVIDER
           PERFORM UNTIL EOF-PROVIDER
               READ PROVIDER-FILE
                   AT END
                       SET EOF-PROVIDER TO TRUE
                   NOT AT END
                       IF PRV-ID(1:1) = "P"
                           MOVE PRV-ID(2:9) TO WS-NEXT-ID-NUM
                       END-IF
               END-READ
           END-PERFORM.
       
       GET-PROVIDER-DETAILS.
           DISPLAY " "
           DISPLAY "Enter Provider Name: " WITH NO ADVANCING
           ACCEPT WS-INPUT-NAME
           
           DISPLAY "Enter Specialty: " WITH NO ADVANCING
           ACCEPT WS-INPUT-SPECIALTY
           
           DISPLAY "Enter Address: " WITH NO ADVANCING
           ACCEPT WS-INPUT-ADDRESS
           
           DISPLAY "Enter City: " WITH NO ADVANCING
           ACCEPT WS-INPUT-CITY
           
           DISPLAY "Enter State (2 letters): " WITH NO ADVANCING
           ACCEPT WS-INPUT-STATE
           
           DISPLAY "Enter ZIP Code: " WITH NO ADVANCING
           ACCEPT WS-INPUT-ZIP
           
           DISPLAY "Enter Phone: " WITH NO ADVANCING
           ACCEPT WS-INPUT-PHONE
           
           DISPLAY "Enter NPI (10 digits): " WITH NO ADVANCING
           ACCEPT WS-INPUT-NPI
           
           DISPLAY "Enter Tax ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT-TAX-ID
           
           MOVE 'A' TO WS-INPUT-STATUS.
       
       SAVE-NEW-PROVIDER.
           OPEN EXTEND PROVIDER-FILE
           IF WS-PROVIDER-STATUS NOT = "00"
               DISPLAY "Error opening provider file: "
                   WS-PROVIDER-STATUS
           ELSE
               MOVE WS-INPUT-ID TO PRV-ID
               MOVE WS-INPUT-NAME TO PRV-NAME
               MOVE WS-INPUT-SPECIALTY TO PRV-SPECIALTY
               MOVE WS-INPUT-ADDRESS TO PRV-ADDRESS
               MOVE WS-INPUT-CITY TO PRV-CITY
               MOVE WS-INPUT-STATE TO PRV-STATE
               MOVE WS-INPUT-ZIP TO PRV-ZIP
               MOVE WS-INPUT-PHONE TO PRV-PHONE
               MOVE WS-INPUT-NPI TO PRV-NPI
               MOVE WS-INPUT-TAX-ID TO PRV-TAX-ID
               MOVE WS-INPUT-STATUS TO PRV-STATUS
               
               WRITE PROVIDER-RECORD
               IF WS-PROVIDER-STATUS NOT = "00"
                   DISPLAY "Error writing provider: "
                       WS-PROVIDER-STATUS
               END-IF
               CLOSE PROVIDER-FILE
           END-IF.
       
      ******************************************************************
      * UPDATE PROVIDER PROCESS
      ******************************************************************
       UPDATE-PROVIDER-PROCESS.
           DISPLAY " "
           DISPLAY "================================================"
           DISPLAY "UPDATE PROVIDER"
           DISPLAY "================================================"
           
           DISPLAY "Enter Provider ID to update: " WITH NO ADVANCING
           ACCEPT WS-INPUT-ID
           
           PERFORM FIND-PROVIDER
           
           IF PROVIDER-FOUND
               PERFORM BACKUP-PROVIDER-DATA
               PERFORM UPDATE-PROVIDER-MENU
           ELSE
               DISPLAY " "
               DISPLAY "Provider not found: " WS-INPUT-ID
           END-IF.
       
       FIND-PROVIDER.
           MOVE 'N' TO WS-PROVIDER-FOUND
           MOVE 'N' TO WS-EOF-PROVIDER
           
           OPEN INPUT PROVIDER-FILE
           IF WS-PROVIDER-STATUS NOT = "00"
               DISPLAY "Error opening provider file: "
                   WS-PROVIDER-STATUS
           ELSE
               PERFORM UNTIL EOF-PROVIDER OR PROVIDER-FOUND
                   READ PROVIDER-FILE
                       AT END
                           SET EOF-PROVIDER TO TRUE
                       NOT AT END
                           IF PRV-ID = WS-INPUT-ID
                               SET PROVIDER-FOUND TO TRUE
                               PERFORM DISPLAY-PROVIDER-DETAILS
                           END-IF
                   END-READ
               END-PERFORM
               CLOSE PROVIDER-FILE
           END-IF.
       
       DISPLAY-PROVIDER-DETAILS.
           DISPLAY " "
           DISPLAY "Provider Found:"
           DISPLAY "  ID:        " PRV-ID
           DISPLAY "  Name:      " PRV-NAME
           DISPLAY "  Specialty: " PRV-SPECIALTY
           DISPLAY "  Address:   " PRV-ADDRESS
           DISPLAY "  City:      " PRV-CITY
           DISPLAY "  State:     " PRV-STATE
           DISPLAY "  ZIP:       " PRV-ZIP
           DISPLAY "  Phone:     " PRV-PHONE
           DISPLAY "  NPI:       " PRV-NPI
           DISPLAY "  Tax ID:    " PRV-TAX-ID
           IF PRV-ACTIVE
               DISPLAY "  Status:    Active"
           ELSE
               DISPLAY "  Status:    Inactive"
           END-IF.
       
       BACKUP-PROVIDER-DATA.
           MOVE PRV-ID TO WS-BACKUP-ID
           MOVE PRV-NAME TO WS-BACKUP-NAME
           MOVE PRV-SPECIALTY TO WS-BACKUP-SPECIALTY
           MOVE PRV-ADDRESS TO WS-BACKUP-ADDRESS
           MOVE PRV-CITY TO WS-BACKUP-CITY
           MOVE PRV-STATE TO WS-BACKUP-STATE
           MOVE PRV-ZIP TO WS-BACKUP-ZIP
           MOVE PRV-PHONE TO WS-BACKUP-PHONE
           MOVE PRV-NPI TO WS-BACKUP-NPI
           MOVE PRV-TAX-ID TO WS-BACKUP-TAX-ID
           MOVE PRV-STATUS TO WS-BACKUP-STATUS.
       
       UPDATE-PROVIDER-MENU.
           MOVE 'N' TO WS-UPDATE-CHOICE
           PERFORM UNTIL UPDATE-DONE
               DISPLAY " "
               DISPLAY "=============================================="
               DISPLAY "UPDATE MENU"
               DISPLAY "=============================================="
               DISPLAY "1. Update Name"
               DISPLAY "2. Update Specialty"
               DISPLAY "3. Update Address"
               DISPLAY "4. Update City"
               DISPLAY "5. Update State"
               DISPLAY "6. Update ZIP"
               DISPLAY "7. Update Phone"
               DISPLAY "8. Update NPI"
               DISPLAY "9. Update Tax ID"
               DISPLAY "A. Update Status"
               DISPLAY "0. Save and Exit"
               DISPLAY "=============================================="
               DISPLAY "Enter choice: " WITH NO ADVANCING
               ACCEPT WS-UPDATE-CHOICE
               
               EVALUATE TRUE
                   WHEN UPDATE-NAME
                       PERFORM UPDATE-PROVIDER-NAME
                   WHEN UPDATE-SPECIALTY
                       PERFORM UPDATE-PROVIDER-SPECIALTY
                   WHEN UPDATE-ADDRESS
                       PERFORM UPDATE-PROVIDER-ADDRESS
                   WHEN UPDATE-CITY
                       PERFORM UPDATE-PROVIDER-CITY
                   WHEN UPDATE-STATE
                       PERFORM UPDATE-PROVIDER-STATE
                   WHEN UPDATE-ZIP
                       PERFORM UPDATE-PROVIDER-ZIP
                   WHEN UPDATE-PHONE
                       PERFORM UPDATE-PROVIDER-PHONE
                   WHEN UPDATE-NPI
                       PERFORM UPDATE-PROVIDER-NPI
                   WHEN UPDATE-TAX-ID
                       PERFORM UPDATE-PROVIDER-TAX-ID
                   WHEN UPDATE-STATUS
                       PERFORM UPDATE-PROVIDER-STATUS-FIELD
                   WHEN UPDATE-DONE
                       PERFORM SAVE-UPDATED-PROVIDER
                   WHEN OTHER
                       DISPLAY "Invalid choice"
               END-EVALUATE
           END-PERFORM.
       
       UPDATE-PROVIDER-NAME.
           DISPLAY "Current Name: " WS-BACKUP-NAME
           DISPLAY "Enter new Name: " WITH NO ADVANCING
           ACCEPT WS-BACKUP-NAME.
       
       UPDATE-PROVIDER-SPECIALTY.
           DISPLAY "Current Specialty: " WS-BACKUP-SPECIALTY
           DISPLAY "Enter new Specialty: " WITH NO ADVANCING
           ACCEPT WS-BACKUP-SPECIALTY.
       
       UPDATE-PROVIDER-ADDRESS.
           DISPLAY "Current Address: " WS-BACKUP-ADDRESS
           DISPLAY "Enter new Address: " WITH NO ADVANCING
           ACCEPT WS-BACKUP-ADDRESS.
       
       UPDATE-PROVIDER-CITY.
           DISPLAY "Current City: " WS-BACKUP-CITY
           DISPLAY "Enter new City: " WITH NO ADVANCING
           ACCEPT WS-BACKUP-CITY.
       
       UPDATE-PROVIDER-STATE.
           DISPLAY "Current State: " WS-BACKUP-STATE
           DISPLAY "Enter new State (2 letters): " WITH NO ADVANCING
           ACCEPT WS-BACKUP-STATE.
       
       UPDATE-PROVIDER-ZIP.
           DISPLAY "Current ZIP: " WS-BACKUP-ZIP
           DISPLAY "Enter new ZIP: " WITH NO ADVANCING
           ACCEPT WS-BACKUP-ZIP.
       
       UPDATE-PROVIDER-PHONE.
           DISPLAY "Current Phone: " WS-BACKUP-PHONE
           DISPLAY "Enter new Phone: " WITH NO ADVANCING
           ACCEPT WS-BACKUP-PHONE.
       
       UPDATE-PROVIDER-NPI.
           DISPLAY "Current NPI: " WS-BACKUP-NPI
           DISPLAY "Enter new NPI: " WITH NO ADVANCING
           ACCEPT WS-BACKUP-NPI.
       
       UPDATE-PROVIDER-TAX-ID.
           DISPLAY "Current Tax ID: " WS-BACKUP-TAX-ID
           DISPLAY "Enter new Tax ID: " WITH NO ADVANCING
           ACCEPT WS-BACKUP-TAX-ID.
       
       UPDATE-PROVIDER-STATUS-FIELD.
           DISPLAY "Current Status: " WS-BACKUP-STATUS
           DISPLAY "Enter new Status (A=Active, I=Inactive): "
               WITH NO ADVANCING
           ACCEPT WS-BACKUP-STATUS.
       
       SAVE-UPDATED-PROVIDER.
           DISPLAY " "
           DISPLAY "Saving changes..."
           
           OPEN INPUT PROVIDER-FILE
           OPEN OUTPUT PROVIDER-TEMP
           
           IF WS-PROVIDER-STATUS NOT = "00" OR WS-TEMP-STATUS NOT = "00"
               DISPLAY "Error opening files"
               CLOSE PROVIDER-FILE
               CLOSE PROVIDER-TEMP
           ELSE
               MOVE 'N' TO WS-EOF-PROVIDER
               PERFORM UNTIL EOF-PROVIDER
                   READ PROVIDER-FILE
                       AT END
                           SET EOF-PROVIDER TO TRUE
                       NOT AT END
                           IF PRV-ID = WS-INPUT-ID
                               MOVE WS-BACKUP-NAME TO PRV-NAME
                               MOVE WS-BACKUP-SPECIALTY TO PRV-SPECIALTY
                               MOVE WS-BACKUP-ADDRESS TO PRV-ADDRESS
                               MOVE WS-BACKUP-CITY TO PRV-CITY
                               MOVE WS-BACKUP-STATE TO PRV-STATE
                               MOVE WS-BACKUP-ZIP TO PRV-ZIP
                               MOVE WS-BACKUP-PHONE TO PRV-PHONE
                               MOVE WS-BACKUP-NPI TO PRV-NPI
                               MOVE WS-BACKUP-TAX-ID TO PRV-TAX-ID
                               MOVE WS-BACKUP-STATUS TO PRV-STATUS
                           END-IF
                           MOVE PROVIDER-RECORD TO TEMP-PROVIDER-RECORD
                           WRITE TEMP-PROVIDER-RECORD
                   END-READ
               END-PERFORM
               
               CLOSE PROVIDER-FILE
               CLOSE PROVIDER-TEMP
               
               PERFORM REPLACE-PROVIDER-FILE
               
               DISPLAY "Provider updated successfully!"
           END-IF.
       
       REPLACE-PROVIDER-FILE.
           CALL "CBL_DELETE_FILE" USING "data/PROVIDERS.dat"
           CALL "CBL_RENAME_FILE" USING "data/PROVIDERS.tmp"
                                         "data/PROVIDERS.dat".
       
      ******************************************************************
      * DELETE PROVIDER PROCESS
      ******************************************************************
       DELETE-PROVIDER-PROCESS.
           DISPLAY " "
           DISPLAY "=============================================="
           DISPLAY "DELETE PROVIDER (Mark as Inactive)"
           DISPLAY "=============================================="
           
           DISPLAY "Enter Provider ID to delete: " WITH NO ADVANCING
           ACCEPT WS-INPUT-ID
           
           PERFORM FIND-PROVIDER
           
           IF PROVIDER-FOUND
               IF PRV-INACTIVE
                   DISPLAY " "
                   DISPLAY "Provider is already inactive."
               ELSE
                   DISPLAY " "
                   DISPLAY "Confirm deletion? (Y/N): " WITH NO ADVANCING
                   ACCEPT WS-CONFIRM
                   
                   IF CONFIRM-YES
                       PERFORM MARK-PROVIDER-INACTIVE
                       DISPLAY " "
                       DISPLAY "Provider marked as inactive!"
                   ELSE
                       DISPLAY " "
                       DISPLAY "Deletion cancelled."
                   END-IF
               END-IF
           ELSE
               DISPLAY " "
               DISPLAY "Provider not found: " WS-INPUT-ID
           END-IF.
       
       MARK-PROVIDER-INACTIVE.
           OPEN INPUT PROVIDER-FILE
           OPEN OUTPUT PROVIDER-TEMP
           
           IF WS-PROVIDER-STATUS NOT = "00" OR WS-TEMP-STATUS NOT = "00"
               DISPLAY "Error opening files"
               CLOSE PROVIDER-FILE
               CLOSE PROVIDER-TEMP
           ELSE
               MOVE 'N' TO WS-EOF-PROVIDER
               PERFORM UNTIL EOF-PROVIDER
                   READ PROVIDER-FILE
                       AT END
                           SET EOF-PROVIDER TO TRUE
                       NOT AT END
                           IF PRV-ID = WS-INPUT-ID
                               MOVE 'I' TO PRV-STATUS
                           END-IF
                           MOVE PROVIDER-RECORD TO TEMP-PROVIDER-RECORD
                           WRITE TEMP-PROVIDER-RECORD
                   END-READ
               END-PERFORM
               
               CLOSE PROVIDER-FILE
               CLOSE PROVIDER-TEMP
               
               PERFORM REPLACE-PROVIDER-FILE
           END-IF.
       
      ******************************************************************
      * REACTIVATE PROVIDER PROCESS
      ******************************************************************
       REACTIVATE-PROVIDER-PROCESS.
           DISPLAY " "
           DISPLAY "=============================================="
           DISPLAY "REACTIVATE PROVIDER"
           DISPLAY "=============================================="
           
           DISPLAY "Enter Provider ID to reactivate: "
               WITH NO ADVANCING
           ACCEPT WS-INPUT-ID
           
           PERFORM FIND-PROVIDER
           
           IF PROVIDER-FOUND
               IF PRV-ACTIVE
                   DISPLAY " "
                   DISPLAY "Provider is already active."
               ELSE
                   DISPLAY " "
                   DISPLAY "Confirm reactivation? (Y/N): "
                       WITH NO ADVANCING
                   ACCEPT WS-CONFIRM
                   
                   IF CONFIRM-YES
                       PERFORM MARK-PROVIDER-ACTIVE
                       DISPLAY " "
                       DISPLAY "Provider reactivated successfully!"
                   ELSE
                       DISPLAY " "
                       DISPLAY "Reactivation cancelled."
                   END-IF
               END-IF
           ELSE
               DISPLAY " "
               DISPLAY "Provider not found: " WS-INPUT-ID
           END-IF.
       
       MARK-PROVIDER-ACTIVE.
           OPEN INPUT PROVIDER-FILE
           OPEN OUTPUT PROVIDER-TEMP
           
           IF WS-PROVIDER-STATUS NOT = "00" OR WS-TEMP-STATUS NOT = "00"
               DISPLAY "Error opening files"
               CLOSE PROVIDER-FILE
               CLOSE PROVIDER-TEMP
           ELSE
               MOVE 'N' TO WS-EOF-PROVIDER
               PERFORM UNTIL EOF-PROVIDER
                   READ PROVIDER-FILE
                       AT END
                           SET EOF-PROVIDER TO TRUE
                       NOT AT END
                           IF PRV-ID = WS-INPUT-ID
                               MOVE 'A' TO PRV-STATUS
                           END-IF
                           MOVE PROVIDER-RECORD TO TEMP-PROVIDER-RECORD
                           WRITE TEMP-PROVIDER-RECORD
                   END-READ
               END-PERFORM
               
               CLOSE PROVIDER-FILE
               CLOSE PROVIDER-TEMP
               
               PERFORM REPLACE-PROVIDER-FILE
           END-IF.
       
      ******************************************************************
      * LIST PROVIDERS PROCESS
      ******************************************************************
       LIST-PROVIDERS-PROCESS.
           DISPLAY " "
           DISPLAY "================================================"
           DISPLAY "ALL PROVIDERS"
           DISPLAY "================================================"
           
           MOVE 0 TO WS-PROVIDER-COUNT
           MOVE 'N' TO WS-EOF-PROVIDER
           
           OPEN INPUT PROVIDER-FILE
           IF WS-PROVIDER-STATUS NOT = "00"
               DISPLAY "Error opening provider file: "
                   WS-PROVIDER-STATUS
           ELSE
               PERFORM UNTIL EOF-PROVIDER
                   READ PROVIDER-FILE
                       AT END
                           SET EOF-PROVIDER TO TRUE
                       NOT AT END
                           ADD 1 TO WS-PROVIDER-COUNT
                           PERFORM DISPLAY-PROVIDER-SUMMARY
                   END-READ
               END-PERFORM
               CLOSE PROVIDER-FILE
               
               DISPLAY " "
               DISPLAY "Total Providers: " WS-PROVIDER-COUNT
               DISPLAY " "
               DISPLAY "Press ENTER to continue..." WITH NO ADVANCING
               ACCEPT WS-PAUSE
           END-IF.
       
       DISPLAY-PROVIDER-SUMMARY.
           DISPLAY " "
           DISPLAY "ID: " PRV-ID
           DISPLAY "  Name:      " PRV-NAME
           DISPLAY "  Specialty: " PRV-SPECIALTY
           DISPLAY "  City:      " PRV-CITY ", " PRV-STATE
           IF PRV-ACTIVE
               DISPLAY "  Status:    Active"
           ELSE
               DISPLAY "  Status:    Inactive"
           END-IF.
       
      ******************************************************************
      * SEARCH PROVIDER PROCESS
      ******************************************************************
       SEARCH-PROVIDER-PROCESS.
           DISPLAY " "
           DISPLAY "================================================"
           DISPLAY "SEARCH PROVIDER"
           DISPLAY "================================================"
           
           DISPLAY "Enter Provider ID: " WITH NO ADVANCING
           ACCEPT WS-INPUT-ID
           
           PERFORM FIND-PROVIDER
           
           IF NOT PROVIDER-FOUND
               DISPLAY " "
               DISPLAY "Provider not found: " WS-INPUT-ID
           END-IF.
       
       TERMINATE-PROGRAM.
           DISPLAY " ".
      
      * Made with Bob
