*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMRN............................................*
DATA:  BEGIN OF STATUS_ZMRN                          .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMRN                          .
CONTROLS: TCTRL_ZMRN
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZMRN                          .
TABLES: ZMRN                           .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
