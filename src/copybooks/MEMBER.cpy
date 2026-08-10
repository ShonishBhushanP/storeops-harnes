      ******************************************************************
      * MEMBER RECORD LAYOUT
      * Contains member demographic and eligibility information
      ******************************************************************
       01  MEMBER-RECORD.
           05  MBR-ID                  PIC X(10).
           05  MBR-LAST-NAME           PIC X(30).
           05  MBR-FIRST-NAME          PIC X(20).
           05  MBR-DATE-OF-BIRTH       PIC X(10).
           05  MBR-GENDER              PIC X(1).
               88  MBR-MALE            VALUE 'M'.
               88  MBR-FEMALE          VALUE 'F'.
               88  MBR-OTHER           VALUE 'O'.
           05  MBR-ADDRESS             PIC X(50).
           05  MBR-CITY                PIC X(30).
           05  MBR-STATE               PIC X(2).
           05  MBR-ZIP                 PIC X(10).
           05  MBR-PHONE               PIC X(15).
           05  MBR-PLAN-TYPE           PIC X(10).
               88  MBR-MEDICARE        VALUE 'MEDICARE'.
               88  MBR-MEDICAID        VALUE 'MEDICAID'.
               88  MBR-DUAL            VALUE 'DUAL'.
           05  MBR-EFFECTIVE-DATE      PIC X(10).
           05  MBR-TERM-DATE           PIC X(10).
           05  MBR-STATUS              PIC X(1).
               88  MBR-ACTIVE          VALUE 'A'.
               88  MBR-INACTIVE        VALUE 'I'.
               88  MBR-SUSPENDED       VALUE 'S'.
