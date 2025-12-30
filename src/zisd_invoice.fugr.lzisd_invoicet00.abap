*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZISD_INVOICE....................................*
DATA:  BEGIN OF STATUS_ZISD_INVOICE                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZISD_INVOICE                  .
CONTROLS: TCTRL_ZISD_INVOICE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZISD_INVOICE                  .
TABLES: ZISD_INVOICE                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
