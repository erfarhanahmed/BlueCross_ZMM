*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTP_COST2.......................................*
DATA:  BEGIN OF STATUS_ZTP_COST2                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTP_COST2                     .
CONTROLS: TCTRL_ZTP_COST2
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTP_COST2                     .
TABLES: ZTP_COST2                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
