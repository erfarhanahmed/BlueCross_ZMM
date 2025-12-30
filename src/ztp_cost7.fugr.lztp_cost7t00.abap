*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_COST7.......................................*
DATA:  BEGIN OF STATUS_ZTP_COST7                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_COST7                     .
CONTROLS: TCTRL_ZTP_COST7
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_COST7                     .
TABLES: ZTP_COST7                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
