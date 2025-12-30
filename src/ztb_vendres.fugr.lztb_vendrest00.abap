*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTB_VENDRES.....................................*
DATA:  BEGIN OF STATUS_ZTB_VENDRES                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTB_VENDRES                   .
CONTROLS: TCTRL_ZTB_VENDRES
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZTB_VENDRES                   .
TABLES: ZTB_VENDRES                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
