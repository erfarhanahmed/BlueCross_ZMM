*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_COST11......................................*
DATA:  BEGIN OF STATUS_ZTP_COST11                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_COST11                    .
CONTROLS: TCTRL_ZTP_COST11
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_COST11                    .
TABLES: ZTP_COST11                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
