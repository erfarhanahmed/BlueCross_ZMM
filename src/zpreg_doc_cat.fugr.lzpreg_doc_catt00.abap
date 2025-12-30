*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPREG_DOC_CAT...................................*
DATA:  BEGIN OF STATUS_ZPREG_DOC_CAT                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPREG_DOC_CAT                 .
CONTROLS: TCTRL_ZPREG_DOC_CAT
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPREG_DOC_CAT                 .
TABLES: ZPREG_DOC_CAT                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
