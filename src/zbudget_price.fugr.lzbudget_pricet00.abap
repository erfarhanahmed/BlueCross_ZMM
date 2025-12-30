*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZBUDGET_PRICE...................................*
DATA:  BEGIN OF STATUS_ZBUDGET_PRICE                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZBUDGET_PRICE                 .
CONTROLS: TCTRL_ZBUDGET_PRICE
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZBUDGET_PRICE                 .
TABLES: ZBUDGET_PRICE                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
