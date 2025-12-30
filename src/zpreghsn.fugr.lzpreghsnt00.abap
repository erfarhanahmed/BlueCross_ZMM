*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPREGHSN........................................*
DATA:  BEGIN OF STATUS_ZPREGHSN                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPREGHSN                      .
CONTROLS: TCTRL_ZPREGHSN
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPREGHSN                      .
TABLES: ZPREGHSN                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
