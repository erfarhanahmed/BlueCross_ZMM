*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPREG_ISD.......................................*
DATA:  BEGIN OF STATUS_ZPREG_ISD                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPREG_ISD                     .
CONTROLS: TCTRL_ZPREG_ISD
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPREG_ISD                     .
TABLES: ZPREG_ISD                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
