      ******************************************************************
      * PROCEDURE CODE RECORD LAYOUT
      * Contains medical procedure code information
      ******************************************************************
       01  PROCEDURE-RECORD.
           05  PROC-CODE               PIC X(10).
           05  PROC-DESCRIPTION        PIC X(60).
           05  PROC-CATEGORY           PIC X(30).
           05  PROC-STANDARD-CHARGE    PIC 9(7)V99.
