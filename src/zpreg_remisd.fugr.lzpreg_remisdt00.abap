*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPREG_REMISD....................................*
DATA:  BEGIN OF STATUS_ZPREG_REMISD                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPREG_REMISD                  .
CONTROLS: TCTRL_ZPREG_REMISD
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPREG_REMISD                  .
TABLES: ZPREG_REMISD                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
