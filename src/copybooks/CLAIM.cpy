      ******************************************************************
      * CLAIM RECORD LAYOUT
      * Contains medical claim transaction information
      ******************************************************************
       01  CLAIM-RECORD.
           05  CLM-ID                  PIC X(15).
           05  CLM-MEMBER-ID           PIC X(10).
           05  CLM-PROVIDER-ID         PIC X(10).
           05  CLM-SERVICE-DATE        PIC X(10).
           05  CLM-PROCEDURE-CODE      PIC X(10).
           05  CLM-DIAGNOSIS-CODE      PIC X(10).
           05  CLM-BILLED-AMOUNT       PIC 9(7)V99.
           05  CLM-ALLOWED-AMOUNT      PIC 9(7)V99.
           05  CLM-PAID-AMOUNT         PIC 9(7)V99.
           05  CLM-SUBMIT-DATE         PIC X(10).
           05  CLM-STATUS              PIC X(1).
               88  CLM-PENDING         VALUE 'P'.
               88  CLM-APPROVED        VALUE 'A'.
               88  CLM-DENIED          VALUE 'D'.
               88  CLM-PAID            VALUE 'X'.
           05  CLM-DENIAL-REASON       PIC X(50).
           05  CLM-ENTRY-DATE          PIC X(10).
           05  CLM-ENTRY-TIME          PIC X(8).
