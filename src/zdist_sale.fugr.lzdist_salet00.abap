*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDIST_SALE......................................*
DATA:  BEGIN OF STATUS_ZDIST_SALE                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDIST_SALE                    .
CONTROLS: TCTRL_ZDIST_SALE
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZDIST_SALE                    .
TABLES: ZDIST_SALE                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
