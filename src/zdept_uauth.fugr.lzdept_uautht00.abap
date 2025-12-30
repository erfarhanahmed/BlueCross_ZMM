*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDEPT_UAUTH.....................................*
DATA:  BEGIN OF STATUS_ZDEPT_UAUTH                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDEPT_UAUTH                   .
CONTROLS: TCTRL_ZDEPT_UAUTH
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDEPT_UAUTH                   .
TABLES: ZDEPT_UAUTH                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
