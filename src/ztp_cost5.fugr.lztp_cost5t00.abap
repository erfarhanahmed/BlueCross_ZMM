*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_COST5.......................................*
DATA:  BEGIN OF STATUS_ZTP_COST5                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_COST5                     .
CONTROLS: TCTRL_ZTP_COST5
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_COST5                     .
TABLES: ZTP_COST5                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
