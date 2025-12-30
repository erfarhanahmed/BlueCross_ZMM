*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLLM............................................*
DATA:  BEGIN OF STATUS_ZLLM                          .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLLM                          .
CONTROLS: TCTRL_ZLLM
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZLLM                          .
TABLES: ZLLM                           .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
