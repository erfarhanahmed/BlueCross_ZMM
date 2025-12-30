*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPRD_CCPC.......................................*
DATA:  BEGIN OF STATUS_ZPRD_CCPC                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPRD_CCPC                     .
CONTROLS: TCTRL_ZPRD_CCPC
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPRD_CCPC                     .
TABLES: ZPRD_CCPC                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
