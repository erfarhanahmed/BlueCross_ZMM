*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPROD_SAMP_REQ..................................*
DATA:  BEGIN OF STATUS_ZPROD_SAMP_REQ                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPROD_SAMP_REQ                .
CONTROLS: TCTRL_ZPROD_SAMP_REQ
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPROD_SAMP_REQ                .
TABLES: ZPROD_SAMP_REQ                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
