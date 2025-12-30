*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMRP_DATA.......................................*
DATA:  BEGIN OF STATUS_ZMRP_DATA                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMRP_DATA                     .
CONTROLS: TCTRL_ZMRP_DATA
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZMRP_DATA                     .
TABLES: ZMRP_DATA                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
