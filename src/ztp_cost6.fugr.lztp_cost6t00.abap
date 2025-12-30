*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_COST6.......................................*
DATA:  BEGIN OF STATUS_ZTP_COST6                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_COST6                     .
CONTROLS: TCTRL_ZTP_COST6
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_COST6                     .
TABLES: ZTP_COST6                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
