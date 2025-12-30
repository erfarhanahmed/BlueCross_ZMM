*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMIGO...........................................*
DATA:  BEGIN OF STATUS_ZMIGO                         .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMIGO                         .
CONTROLS: TCTRL_ZMIGO
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZMIGO                         .
TABLES: ZMIGO                          .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
