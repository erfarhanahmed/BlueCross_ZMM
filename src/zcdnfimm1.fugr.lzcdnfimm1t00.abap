*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCDNFIMM1.......................................*
DATA:  BEGIN OF STATUS_ZCDNFIMM1                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCDNFIMM1                     .
CONTROLS: TCTRL_ZCDNFIMM1
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZCDNFIMM1                     .
TABLES: ZCDNFIMM1                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
