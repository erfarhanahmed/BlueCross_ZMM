*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_COST12......................................*
DATA:  BEGIN OF STATUS_ZTP_COST12                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_COST12                    .
CONTROLS: TCTRL_ZTP_COST12
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_COST12                    .
TABLES: ZTP_COST12                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
