"Name: \PR:SAPLCOKO1\FO:CHECK_MATERIAL_PLANT\SE:BEGIN\EI
ENHANCEMENT 0 ZCO01.

******** ENHANCED BY JYOTSNA**********
*caufvd-matnr.
IF SY-TCODE = 'COR1'.
  TABLES : MARA,
           marc.

   if CAUFVD-WERKS NE AFPOD-PWERK.
    MESSAGE 'CHECK PLANNING PLANT' TYPE 'E'.
*     MESSAGE 'CHECK PLANNING PLANT' TYPE 'I'.
  ENDIF.
  SELECT SINGLE * FROM MARA WHERE MATNR EQ caufvd-matnr.
    IF SY-SUBRC EQ 0.
      IF ( MARA-MTART EQ 'ZFRT' ) AND ( MARA-BISMT NE '                  ' ).
         MESSAGE I903 WITH mara-bismt.
        MESSAGE W903 WITH mara-bismt.
      ENDIF.
   ENDIF.

**********added by Jyotsna on 25.7.24 to block prd order if material is flaged for deletion for the plant
    SELECT SINGLE * FROM MARA WHERE MATNR EQ caufvd-matnr AND lvorm eq 'X'.
    IF SY-SUBRC EQ 0.
         MESSAGE 'PRODUCT CODE IS FLAGGED FOR DELETION' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM MARC WHERE MATNR EQ caufvd-matnr AND WERKS EQ caufvd-WERKS AND lvorm eq 'X'.
    IF SY-SUBRC EQ 0.
         MESSAGE 'PRODUCT CODE IS FLAGGED FOR DELETION FOR THIS PLANT' TYPE 'E'.
    ENDIF.
ENDIF.

ENDENHANCEMENT.
