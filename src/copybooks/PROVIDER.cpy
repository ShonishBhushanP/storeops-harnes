      ******************************************************************
      * PROVIDER RECORD LAYOUT
      * Contains healthcare provider information
      ******************************************************************
       01  PROVIDER-RECORD.
           05  PRV-ID                  PIC X(10).
           05  PRV-NAME                PIC X(50).
           05  PRV-SPECIALTY           PIC X(30).
           05  PRV-ADDRESS             PIC X(50).
           05  PRV-CITY                PIC X(30).
           05  PRV-STATE               PIC X(2).
           05  PRV-ZIP                 PIC X(10).
           05  PRV-PHONE               PIC X(15).
           05  PRV-NPI                 PIC X(10).
           05  PRV-TAX-ID              PIC X(15).
           05  PRV-STATUS              PIC X(1).
               88  PRV-ACTIVE          VALUE 'A'.
               88  PRV-INACTIVE        VALUE 'I'.
