*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPROD_INSP_YLD..................................*
DATA:  BEGIN OF STATUS_ZPROD_INSP_YLD                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPROD_INSP_YLD                .
CONTROLS: TCTRL_ZPROD_INSP_YLD
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZPROD_INSP_YLD                .
TABLES: ZPROD_INSP_YLD                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
