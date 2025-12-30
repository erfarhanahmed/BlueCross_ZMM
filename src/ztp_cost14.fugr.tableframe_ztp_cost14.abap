*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZTP_COST14
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZTP_COST14         .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
