*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPRODSAMPRT.....................................*
DATA:  BEGIN OF STATUS_ZPRODSAMPRT                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPRODSAMPRT                   .
CONTROLS: TCTRL_ZPRODSAMPRT
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPRODSAMPRT                   .
TABLES: ZPRODSAMPRT                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
