"Name: \PR:SAPLMIGO\FO:INITIALIZATION\SE:BEGIN\EI
ENHANCEMENT 0 ZMIGO.
*

*  *block rejected vendor batch - by Jyotsna
*  BREAK-POINT.
*  goitem-licha,goitem-lifnr,goitem-matnr.
  IF GOITEM-LIFNR IS NOT INITIAL.

***************check for gate entry by Jyotsna 15.11.24 ***************
*   ***************check for gate entry***************
    IF GOITEM-WERKS EQ '1000'.
      TABLES : ZPO_GATE.
      DATA: YEAR1 TYPE MJAHR,
            DATE1 TYPE SY-DATUM.
      YEAR1 = SY-DATUM+0(4).
      DATE1 = SY-DATUM - 7.
      SELECT SINGLE * FROM ZPO_GATE WHERE MJAHR EQ YEAR1 AND WERKS EQ GOITEM-WERKS AND EBELN EQ GOITEM-EBELN AND
        CPUDT GE DATE1.
      IF SY-SUBRC EQ 4.
*        MESSAGE 'CHECK GATE ENTRY FOR PO' TYPE 'E'.
      ENDIF.
    ENDIF.
*********************************************************
*********************************************************

    IF GOITEM-LICHA NE SPACE.  "14.8.2019
      IF GOITEM-LICHA NE 'NA'. "30.9.2019
        IF GOITEM-BWART EQ '101'.
          TABLES: QAVE,
                  QALS,
                  MSEG,
                  MKPF.
          DATA : IT_QALS TYPE TABLE OF QALS,
                 WA_QALS TYPE QALS.

          SELECT * FROM QALS INTO TABLE IT_QALS WHERE MATNR = GOITEM-MATNR
                                                  AND LIFNR = GOITEM-LIFNR
                                                  AND LICHN = GOITEM-LICHA.
          LOOP AT IT_QALS INTO WA_QALS.
*            SELECT SINGLE * FROM QAVE WHERE PRUEFLOS EQ wa_QALS-PRUEFLOS AND VCODE EQ 'R'.
            SELECT SINGLE * FROM QAVE WHERE PRUEFLOS EQ wa_QALS-PRUEFLOS AND VCODE EQ 'A3'.
            IF SY-SUBRC EQ 0.
*              MESSAGE ' THIS IS REJECTED VENDOR BATCH.. GRN NOT POSSIBLE' TYPE 'E'.
              MESSAGE I705(ZPP) RAISING NOT_FOUND.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

**********check duplicate delivery number**************
*    DATA: YEAR(4) TYPE C.
*    CLEar: year.
*    year = gohead-budat+0(4).
*    SELECT SINGLE * FROM mkpf WHERE mjahr eq year AND xblnr eq gohead-lfsnr.
*      if sy-subrc eq 0.
*        SELECT SINGLE * FROM mseg WHERE mblnr eq mkpf-mblnr AND mjahr eq mkpF-mjahr AND lifnr eq GOHEAD-LIFNR.
*          if sy-subrc eq 0.
*             if sy-ucomm NE SPACE.
*            MESSAGE 'PLEASE CHECK DELIVERY NOTE NUMBER - RECEIPTS IS ALREDAY DONE AGAINST THIS DEL NOTE' TYPE 'I'.
*            endif.
*          ENDIF.
*     ENDIF.

***********************************************************
  ENDIF.

*  IF GOITEM-BWART EQ '101'.
** Validation in case of rejection
*    DATA: LV_ATNAM TYPE ATNAM,
*          lv_ATINN TYPE ATINN,
*          LV_ATWRT TYPE ATWRT,
*          LV_CHARG TYPE CHARG_D,
*          LV_REJ   TYPE QBEWERTUNG.
*
**    LV_ATWRT = 'VEND_BATCH_001_REJECTED'.
*    LV_ATNAM = 'ZVENDOR_BATCH'.
*
*    SELECT SINGLE ATINN INTO @LV_ATINN FROM CABN
*                        WHERE ATNAM = @LV_ATNAM.
*
*    CALL FUNCTION 'CONVERSION_EXIT_ATINN_INPUT'
*      EXPORTING
*        INPUT  = LV_ATINN
*      IMPORTING
*        OUTPUT = LV_ATINN.
*
*    SELECT SINGLE CUOBJ_BM FROM MCH1 INTO @DATA(LV_CUOBJ)
*             WHERE MATNR = @GOITEM-MATNR
*               AND CHARG = @GOITEM-CHARG.
*    SELECT SINGLE * FROM AUSP INTO @DATA(LWA_AUSP)
*                    WHERE OBJEK = @lv_CUOBJ
*                      AND ATINN = @LV_ATINN.
**    LV_CHARG = LWA_AUSP-ATWRT.
*    IF LWA_AUSP-ATWRT IS NOT INITIAL.
**      MESSAGE ' THIS IS REJECTED VENDOR BATCH.. GRN NOT POSSIBLE' TYPE 'E'.
*      LV_REJ = 'R'.
*      SELECT * FROM QALSVE_V1 INTO TABLE @DATA(LT_QALSVE)
*                            WHERE MATNR = @GOITEM-MATNR
*                              AND CHARG = @GOITEM-CHARG
*                              AND LIFNR = @GOITEM-LIFNR
*                              AND VBEWERTUNG = @LV_REJ.
*      IF SY-SUBRC = 0.
*        MESSAGE I705(ZPP) RAISING NOT_FOUND.
*      ENDIF.
*    ENDIF.
*  ENDIF.

ENDENHANCEMENT.
