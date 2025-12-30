*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFGINSPR........................................*
DATA:  BEGIN OF STATUS_ZFGINSPR                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFGINSPR                      .
CONTROLS: TCTRL_ZFGINSPR
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZFGINSPR                      .
TABLES: ZFGINSPR                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
