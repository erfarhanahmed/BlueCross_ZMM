*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_COST13......................................*
DATA:  BEGIN OF STATUS_ZTP_COST13                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_COST13                    .
CONTROLS: TCTRL_ZTP_COST13
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_COST13                    .
TABLES: ZTP_COST13                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
