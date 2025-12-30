*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_COST14......................................*
DATA:  BEGIN OF STATUS_ZTP_COST14                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_COST14                    .
CONTROLS: TCTRL_ZTP_COST14
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_COST14                    .
TABLES: ZTP_COST14                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
