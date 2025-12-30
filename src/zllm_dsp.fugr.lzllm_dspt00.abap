*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZLLM_DSP........................................*
DATA:  BEGIN OF STATUS_ZLLM_DSP                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLLM_DSP                      .
CONTROLS: TCTRL_ZLLM_DSP
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZLLM_DSP                      .
TABLES: ZLLM_DSP                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
