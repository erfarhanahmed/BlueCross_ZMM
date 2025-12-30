*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMRN_ORD........................................*
DATA:  BEGIN OF STATUS_ZMRN_ORD                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMRN_ORD                      .
CONTROLS: TCTRL_ZMRN_ORD
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZMRN_ORD                      .
TABLES: ZMRN_ORD                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
