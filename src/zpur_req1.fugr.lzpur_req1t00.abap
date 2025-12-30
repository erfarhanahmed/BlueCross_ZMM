*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPUR_REQ1.......................................*
DATA:  BEGIN OF STATUS_ZPUR_REQ1                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPUR_REQ1                     .
CONTROLS: TCTRL_ZPUR_REQ1
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPUR_REQ1                     .
TABLES: ZPUR_REQ1                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
