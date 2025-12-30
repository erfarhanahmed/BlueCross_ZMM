*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_COST1.......................................*
DATA:  BEGIN OF STATUS_ZTP_COST1                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_COST1                     .
CONTROLS: TCTRL_ZTP_COST1
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_COST1                     .
TABLES: ZTP_COST1                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
