*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMIGO_CHK.......................................*
DATA:  BEGIN OF STATUS_ZMIGO_CHK                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMIGO_CHK                     .
CONTROLS: TCTRL_ZMIGO_CHK
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZMIGO_CHK                     .
TABLES: ZMIGO_CHK                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
