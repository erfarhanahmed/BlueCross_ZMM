*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_COST15......................................*
DATA:  BEGIN OF STATUS_ZTP_COST15                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_COST15                    .
CONTROLS: TCTRL_ZTP_COST15
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_COST15                    .
TABLES: ZTP_COST15                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
