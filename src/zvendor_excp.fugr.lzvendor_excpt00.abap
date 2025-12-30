*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVENDOR_EXCP....................................*
DATA:  BEGIN OF STATUS_ZVENDOR_EXCP                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVENDOR_EXCP                  .
CONTROLS: TCTRL_ZVENDOR_EXCP
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZVENDOR_EXCP                  .
TABLES: ZVENDOR_EXCP                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
