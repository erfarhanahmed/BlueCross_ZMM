*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZPROD_SAMP_REQ
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZPROD_SAMP_REQ     .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
