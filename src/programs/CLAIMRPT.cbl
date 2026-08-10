       IDENTIFICATION DIVISION.
       PROGRAM-ID. CLAIMRPT.
       AUTHOR. COBOL DEVELOPER.
      ******************************************************************
      * DAILY CLAIMS REPORT GENERATOR
      * Batch program to produce daily claims report
      * Reads claims file and generates formatted report
      ******************************************************************
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CLAIM-FILE
               ASSIGN TO "data/CLAIMS.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-CLAIM-STATUS.
           
           SELECT MEMBER-FILE
               ASSIGN TO "data/MEMBERS.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-MEMBER-STATUS.
           
           SELECT PROVIDER-FILE
               ASSIGN TO "data/PROVIDERS.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-PROVIDER-STATUS.
           
           SELECT REPORT-FILE
               ASSIGN TO WS-REPORT-FILENAME
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-REPORT-STATUS.
       
       DATA DIVISION.
       FILE SECTION.
       FD  CLAIM-FILE.
       COPY CLAIM.
       
       FD  MEMBER-FILE.
       COPY MEMBER.
       
       FD  PROVIDER-FILE.
       COPY PROVIDER.
       
       FD  REPORT-FILE.
       01  REPORT-LINE                 PIC X(132).
       
       WORKING-STORAGE SECTION.
       01  WS-FILE-STATUS.
           05  WS-CLAIM-STATUS         PIC XX.
           05  WS-MEMBER-STATUS        PIC XX.
           05  WS-PROVIDER-STATUS      PIC XX.
           05  WS-REPORT-STATUS        PIC XX.
       
       01  WS-FLAGS.
           05  WS-EOF-CLAIM            PIC X VALUE 'N'.
               88  EOF-CLAIM           VALUE 'Y'.
           05  WS-EOF-MEMBER           PIC X VALUE 'N'.
               88  EOF-MEMBER          VALUE 'Y'.
           05  WS-EOF-PROVIDER         PIC X VALUE 'N'.
               88  EOF-PROVIDER        VALUE 'Y'.
           05  WS-MEMBER-FOUND         PIC X VALUE 'N'.
               88  MEMBER-FOUND        VALUE 'Y'.
           05  WS-PROVIDER-FOUND       PIC X VALUE 'N'.
               88  PROVIDER-FOUND      VALUE 'Y'.
       
       01  WS-COUNTERS.
           05  WS-CLAIM-COUNT          PIC 9(6) VALUE 0.
           05  WS-PAGE-COUNT           PIC 9(4) VALUE 0.
           05  WS-LINE-COUNT           PIC 9(3) VALUE 99.
       
       01  WS-TOTALS.
           05  WS-TOTAL-BILLED         PIC 9(9)V99 VALUE 0.
           05  WS-TOTAL-ALLOWED        PIC 9(9)V99 VALUE 0.
           05  WS-TOTAL-PAID           PIC 9(9)V99 VALUE 0.
       
       01  WS-CURRENT-DATE.
           05  WS-CURR-YEAR            PIC 9(4).
           05  WS-CURR-MONTH           PIC 9(2).
           05  WS-CURR-DAY             PIC 9(2).
       01  WS-DATE-STRING              PIC X(10).
       01  WS-REPORT-FILENAME          PIC X(50).
       
       01  WS-MEMBER-NAME              PIC X(50).
       01  WS-PROVIDER-NAME            PIC X(50).
       
       01  REPORT-HEADER-1.
           05  FILLER                  PIC X(50) VALUE SPACES.
           05  FILLER                  PIC X(32) 
               VALUE "DAILY CLAIMS REPORT".
       
       01  REPORT-HEADER-2.
           05  FILLER                  PIC X(20) VALUE "Report Date: ".
           05  RH2-DATE                PIC X(10).
           05  FILLER                  PIC X(30) VALUE SPACES.
           05  FILLER                  PIC X(6) VALUE "Page: ".
           05  RH2-PAGE                PIC ZZZ9.
       
       01  REPORT-HEADER-3.
           05  FILLER                  PIC X(132) VALUE ALL "=".
       
       01  COLUMN-HEADER-1.
           05  FILLER                  PIC X(15) VALUE "Claim ID".
           05  FILLER                  PIC X(12) VALUE "Member".
           05  FILLER                  PIC X(32) VALUE "Member Name".
           05  FILLER                  PIC X(12) VALUE "Provider".
           05  FILLER                  PIC X(12) VALUE "Service Dt".
           05  FILLER                  PIC X(11) VALUE "Procedure".
           05  FILLER                  PIC X(13) VALUE "Billed".
           05  FILLER                  PIC X(13) VALUE "Allowed".
           05  FILLER                  PIC X(12) VALUE "Status".
       
       01  COLUMN-HEADER-2.
           05  FILLER                  PIC X(132) VALUE ALL "-".
       
       01  DETAIL-LINE.
           05  DL-CLAIM-ID             PIC X(15).
           05  FILLER                  PIC X VALUE SPACE.
           05  DL-MEMBER-ID            PIC X(10).
           05  FILLER                  PIC X VALUE SPACE.
           05  DL-MEMBER-NAME          PIC X(30).
           05  FILLER                  PIC X VALUE SPACE.
           05  DL-PROVIDER-ID          PIC X(10).
           05  FILLER                  PIC X VALUE SPACE.
           05  DL-SERVICE-DATE         PIC X(10).
           05  FILLER                  PIC X VALUE SPACE.
           05  DL-PROCEDURE            PIC X(10).
           05  FILLER                  PIC X VALUE SPACE.
           05  DL-BILLED               PIC $$$,$$$,$$9.99.
           05  DL-ALLOWED              PIC $$$,$$$,$$9.99.
           05  DL-STATUS               PIC X(10).
       
       01  TOTAL-LINE.
           05  FILLER                  PIC X(80) VALUE SPACES.
           05  FILLER                  PIC X(8) VALUE "TOTALS: ".
           05  TL-BILLED               PIC $$$,$$$,$$9.99.
           05  TL-ALLOWED              PIC $$$,$$$,$$9.99.
       
       01  SUMMARY-LINE-1.
           05  FILLER                  PIC X(30) 
               VALUE "Total Claims Processed: ".
           05  SL1-COUNT               PIC ZZZ,ZZ9.
       
       01  SUMMARY-LINE-2.
           05  FILLER                  PIC X(30) 
               VALUE "Total Amount Billed:    ".
           05  SL2-AMOUNT              PIC $$$,$$$,$$9.99.
       
       01  SUMMARY-LINE-3.
           05  FILLER                  PIC X(30) 
               VALUE "Total Amount Allowed:   ".
           05  SL3-AMOUNT              PIC $$$,$$$,$$9.99.
       
       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM INITIALIZE-REPORT
           PERFORM PROCESS-CLAIMS
           PERFORM PRINT-SUMMARY
           PERFORM TERMINATE-REPORT
           STOP RUN.
       
       INITIALIZE-REPORT.
           DISPLAY "Starting Daily Claims Report Generation..."
           
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE
           
           STRING WS-CURR-YEAR "-" 
                  WS-CURR-MONTH "-" 
                  WS-CURR-DAY
                  DELIMITED BY SIZE
                  INTO WS-DATE-STRING
           END-STRING
           
           STRING "reports/CLAIMS_REPORT_" DELIMITED BY SIZE
                  WS-CURR-YEAR DELIMITED BY SIZE
                  WS-CURR-MONTH DELIMITED BY SIZE
                  WS-CURR-DAY DELIMITED BY SIZE
                  ".txt" DELIMITED BY SIZE
                  INTO WS-REPORT-FILENAME
           END-STRING
           
           OPEN OUTPUT REPORT-FILE
           
           IF WS-REPORT-STATUS NOT = '00'
               DISPLAY "Error opening report file: " WS-REPORT-STATUS
               STOP RUN
           END-IF
           
           MOVE ZERO TO WS-CLAIM-COUNT
           MOVE ZERO TO WS-TOTAL-BILLED
           MOVE ZERO TO WS-TOTAL-ALLOWED
           MOVE ZERO TO WS-TOTAL-PAID
           
           PERFORM PRINT-PAGE-HEADER.
       
       PROCESS-CLAIMS.
           OPEN INPUT CLAIM-FILE
           
           IF WS-CLAIM-STATUS NOT = '00'
               DISPLAY "Error opening claim file: " WS-CLAIM-STATUS
               CLOSE REPORT-FILE
               STOP RUN
           END-IF
           
           MOVE 'N' TO WS-EOF-CLAIM
           
           PERFORM UNTIL EOF-CLAIM
               READ CLAIM-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-CLAIM
                   NOT AT END
                       PERFORM PROCESS-CLAIM-RECORD
               END-READ
           END-PERFORM
           
           CLOSE CLAIM-FILE.
       
       PROCESS-CLAIM-RECORD.
           ADD 1 TO WS-CLAIM-COUNT
           
           ADD CLM-BILLED-AMOUNT TO WS-TOTAL-BILLED
           ADD CLM-ALLOWED-AMOUNT TO WS-TOTAL-ALLOWED
           ADD CLM-PAID-AMOUNT TO WS-TOTAL-PAID
           
           PERFORM LOOKUP-MEMBER
           PERFORM LOOKUP-PROVIDER
           
           PERFORM PRINT-DETAIL-LINE.
       
       LOOKUP-MEMBER.
           MOVE 'N' TO WS-MEMBER-FOUND
           MOVE 'N' TO WS-EOF-MEMBER
           MOVE SPACES TO WS-MEMBER-NAME
           
           OPEN INPUT MEMBER-FILE
           
           IF WS-MEMBER-STATUS = '00'
               PERFORM UNTIL EOF-MEMBER OR MEMBER-FOUND
                   READ MEMBER-FILE
                       AT END
                           MOVE 'Y' TO WS-EOF-MEMBER
                       NOT AT END
                           IF MBR-ID = CLM-MEMBER-ID
                               MOVE 'Y' TO WS-MEMBER-FOUND
                               STRING MBR-FIRST-NAME " " 
                                      MBR-LAST-NAME
                                      DELIMITED BY "  "
                                      INTO WS-MEMBER-NAME
                               END-STRING
                           END-IF
                   END-READ
               END-PERFORM
               CLOSE MEMBER-FILE
           END-IF
           
           IF NOT MEMBER-FOUND
               MOVE "Unknown Member" TO WS-MEMBER-NAME
           END-IF.
       
       LOOKUP-PROVIDER.
           MOVE 'N' TO WS-PROVIDER-FOUND
           MOVE 'N' TO WS-EOF-PROVIDER
           MOVE SPACES TO WS-PROVIDER-NAME
           
           OPEN INPUT PROVIDER-FILE
           
           IF WS-PROVIDER-STATUS = '00'
               PERFORM UNTIL EOF-PROVIDER OR PROVIDER-FOUND
                   READ PROVIDER-FILE
                       AT END
                           MOVE 'Y' TO WS-EOF-PROVIDER
                       NOT AT END
                           IF PRV-ID = CLM-PROVIDER-ID
                               MOVE 'Y' TO WS-PROVIDER-FOUND
                               MOVE PRV-NAME TO WS-PROVIDER-NAME
                           END-IF
                   END-READ
               END-PERFORM
               CLOSE PROVIDER-FILE
           END-IF
           
           IF NOT PROVIDER-FOUND
               MOVE "Unknown Provider" TO WS-PROVIDER-NAME
           END-IF.
       
       PRINT-DETAIL-LINE.
           IF WS-LINE-COUNT > 50
               PERFORM PRINT-PAGE-HEADER
           END-IF
           
           MOVE CLM-ID TO DL-CLAIM-ID
           MOVE CLM-MEMBER-ID TO DL-MEMBER-ID
           MOVE WS-MEMBER-NAME TO DL-MEMBER-NAME
           MOVE CLM-PROVIDER-ID TO DL-PROVIDER-ID
           MOVE CLM-SERVICE-DATE TO DL-SERVICE-DATE
           MOVE CLM-PROCEDURE-CODE TO DL-PROCEDURE
           MOVE CLM-BILLED-AMOUNT TO DL-BILLED
           MOVE CLM-ALLOWED-AMOUNT TO DL-ALLOWED
           
           EVALUATE CLM-STATUS
               WHEN 'P'
                   MOVE "Pending" TO DL-STATUS
               WHEN 'A'
                   MOVE "Approved" TO DL-STATUS
               WHEN 'D'
                   MOVE "Denied" TO DL-STATUS
               WHEN 'X'
                   MOVE "Paid" TO DL-STATUS
               WHEN OTHER
                   MOVE "Unknown" TO DL-STATUS
           END-EVALUATE
           
           MOVE DETAIL-LINE TO REPORT-LINE
           WRITE REPORT-LINE
           ADD 1 TO WS-LINE-COUNT.
       
       PRINT-PAGE-HEADER.
           ADD 1 TO WS-PAGE-COUNT
           MOVE 1 TO WS-LINE-COUNT
           
           MOVE SPACES TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE REPORT-HEADER-1 TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE WS-DATE-STRING TO RH2-DATE
           MOVE WS-PAGE-COUNT TO RH2-PAGE
           MOVE REPORT-HEADER-2 TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE REPORT-HEADER-3 TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE SPACES TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE COLUMN-HEADER-1 TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE COLUMN-HEADER-2 TO REPORT-LINE
           WRITE REPORT-LINE
           
           ADD 7 TO WS-LINE-COUNT.
       
       PRINT-SUMMARY.
           MOVE SPACES TO REPORT-LINE
           WRITE REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE REPORT-HEADER-3 TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE SPACES TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE WS-TOTAL-BILLED TO TL-BILLED
           MOVE WS-TOTAL-ALLOWED TO TL-ALLOWED
           MOVE TOTAL-LINE TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE SPACES TO REPORT-LINE
           WRITE REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE WS-CLAIM-COUNT TO SL1-COUNT
           MOVE SUMMARY-LINE-1 TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE WS-TOTAL-BILLED TO SL2-AMOUNT
           MOVE SUMMARY-LINE-2 TO REPORT-LINE
           WRITE REPORT-LINE
           
           MOVE WS-TOTAL-ALLOWED TO SL3-AMOUNT
           MOVE SUMMARY-LINE-3 TO REPORT-LINE
           WRITE REPORT-LINE.
       
       TERMINATE-REPORT.
           CLOSE REPORT-FILE
           
           DISPLAY " "
           DISPLAY "Report Generation Complete!"
           DISPLAY "Report file: " WS-REPORT-FILENAME
           DISPLAY "Total claims processed: " WS-CLAIM-COUNT
           DISPLAY "Total billed: $" WS-TOTAL-BILLED
           DISPLAY " ".
