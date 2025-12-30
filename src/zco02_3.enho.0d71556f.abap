"Name: \PR:SAPLCOZR\FO:CHECK_BATCH_DETERMINATION\SE:BEGIN\EI
ENHANCEMENT 0 ZCO02_3.
***********6.6.22************
*IF SY-TCODE EQ 'CO01' OR SY-TCODE EQ 'CO02'.
**  BREAK-POINT.
*if it_resbd_get IS NOT INITIAL.
*
*
*  TABLES : AFPO,
*           ZMRN,
*           MARA,
*           MCHB,
*           RESB,
*           ZMRN_ORD.
*
*  data: fgmatnr like mara-matnr,
*      werks like mseg-werks,
*      LGORT TYPE MSEG-LGORT,
*      GRP1 TYPE ZMRN-MONAT,
*      actgrp TYPE zmrn-monat,
*      QTY1 TYPE MSEG-MENGE,
*      chk1 TYPE i,
*      stock TYPE mseg-menge.
*TYPES : BEGIN OF chk1,
*  pmmatnr TYPE mara-matnr,
*  werks TYPE mseg-werks,
*  grp1 TYPE zmrn-monat,
*  END OF chk1.
*
*TYPES : BEGIN OF chk2,
*  fgmatnr TYPE afpo-matnr,
*  mblnr TYPE mseg-mblnr,
*  matnr TYPE mseg-matnr,
*  charg TYPE mseg-charg,
*  menge TYPE mseg-menge,
*  lgort TYPE mseg-lgort,
*  grp TYPE zmrn-monat,
*   werks TYPE mseg-werks,
*  END OF chk2.
*
*  TYPES : BEGIN OF stk1,
*    pmmatnr TYPE mara-matnr,
*    charg TYPE mchb-charg,
*    lgort TYPE mchb-lgort,
*    menge TYPE mseg-menge,
*    werks TYPE mseg-werks,
*    END OF stk1.
* DATA: C1(1) TYPE C.
*TYPES : BEGIN OF itab1,
*    matnr TYPE mara-matnr,
*END OF itab1.
*
*DATA: MATNR1 TYPE MCHB-MATNR.
*data: it_zmrn TYPE TABLE OF ZMRN,
*      WA_ZMRN TYPE ZMRN,
*      it_mseg TYPE TABLE OF mseg,
*      wa_mseg TYPE mseg,
*      it_chk1 TYPE TABLE OF chk1,
*      wa_chk1 TYPE chk1,
*      it_chk2 TYPE TABLE OF chk2,
*      wa_chk2 TYPE chk2,
*      it_chk3 TYPE TABLE OF chk2,
*      wa_chk3 TYPE chk2,
*      it_stk1 TYPE TABLE OF stk1,
*      wa_stk1 TYPE stk1,
*      it_mchb TYPE TABLE OF mchb,
*      wa_mchb TYPE mchb,
*      it_tab1 TYPE TABLE OF itab1,
*      wa_tab1 TYPE itab1.
*
*data: cstock TYPE mseg-menge,
*      cstock1 TYPE mseg-menge.
*DATA: GRP2 TYPE ZMRN-MONAT.
*
*******************************************************************
*CLEAR : FGMATNR,WERKS,LGORT.
*LOOP at it_resbd_get.
*  SELECT SINGLE * FROM MARA WHERE MATNR EQ it_resbd_get-MATNR AND MTART EQ 'ZHLB'.
*  IF SY-SUBRC EQ 0.
*    FGMATNR = it_resbd_get-baugr.
*    WERKS = it_resbd_get-WERKS.
*    LGORT = it_resbd_get-LGORT.
*    exit.
*  ENDIF.
*endloop.
**CLEAR : grp1.
**LOOP at it_resbd_get.
**  SELECT SINGLE * FROM ZMRN WHERE PMMATNR EQ it_resbd_get-MATNR AND werks eq it_resbd_get-werks AND fgmatnr eq fgmatnr.
**    if sy-subrc eq 0.
**    grp1 = zmrn-monat.
**    exit.
**    endif.
**ENDLOOP.
*
**SELECT * FROM ZMRN INTO TABLE IT_ZMRN FOR ALL ENTRIES IN it_resbd_get WHERE PMMATNR EQ it_resbd_get-MATNR AND
**   werks eq it_resbd_get-werks AND monat eq grp1.
*SELECT * FROM ZMRN INTO TABLE IT_ZMRN FOR ALL ENTRIES IN it_resbd_get WHERE PMMATNR EQ it_resbd_get-MATNR AND
*   werks eq it_resbd_get-werks.
*IF LGORT EQ 'SF04'.
*if it_zmrn IS NOT INITIAL.
*  SELECT * FROM MCHB INTO TABLE it_mchb FOR ALL ENTRIES IN it_zmrn WHERE MATNR EQ it_ZMRN-PMMATNR AND WERKS EQ it_ZMRN-WERKS AND lgort eq 'MRN4' AND CLABS GT 0.
*endif.
*ELSE.
*if it_zmrn IS NOT INITIAL.
*  SELECT * FROM MCHB INTO TABLE it_mchb FOR ALL ENTRIES IN it_zmrn WHERE MATNR EQ it_ZMRN-PMMATNR AND WERKS EQ it_ZMRN-WERKS AND lgort eq 'MRN1' AND CLABS GT 0.
*endif.
*ENDIF.
*CLEAR : cstock.
*LOOP at it_mchb INTO wa_mchb.
*SELECT SINGLE * FROM RESB WHERE KZEAR NE 'X' AND XLOEK NE 'X' AND MATNR EQ wa_MCHB-MATNR AND WERKS EQ wa_MCHB-WERKS AND
*LGORT EQ wa_MCHB-LGORT AND CHARG EQ wa_MCHB-CHARG.
*  if sy-subrc eq 4.
*      cstock = cstock + wa_mchb-clabs.
*  wa_stk1-pmmatnr = wa_mchb-matnr.
*  wa_stk1-charg = wa_mchb-charg.
*  wa_stk1-menge = wa_mchb-clabs.
*  wa_stk1-werks = wa_mchb-werks.
*  wa_stk1-LGORT = wa_mchb-LGORT.
*  COLLECT wa_stk1 INTO it_stk1.
*  CLEAR wa_stk1.
*  endif.
*ENDLOOP.
************* FG CODE OF MRN STOCK*************************
*CLEAR : IT_MSEG,WA_MSEG.
*if it_stk1 IS NOT INITIAL.
*SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_stk1 WHERE bwart eq '262' AND matnr eq it_stk1-pmmatnr
*  AND charg eq it_stk1-charg AND werks eq it_stk1-werks AND lgort eq it_stk1-lgort.
*endif.
*sort it_mseg DESCENDING by mblnr.
*if it_mseg IS NOT INITIAL.
*LOOP at it_mseg INTO wa_mseg.
*SELECT SINGLE * FROM afpo WHERE aufnr eq wa_mseg-aufnr.
*if sy-subrc eq 0.
*SELECT SINGLE * FROM zmrn WHERE pmmatnr eq wa_mseg-matnr AND werks eq wa_mseg-werks AND fgmatnr eq afpo-matnr.
*if sy-subrc eq 0.
*  if cstock1 le cstock.
*      cstock1 = cstock1 + wa_mseg-menge.
*     wa_chk2-fgmatnr = afpo-matnr.
*     wa_chk2-mblnr = wa_mseg-mblnr.
*     wa_chk2-matnr = wa_mseg-matnr.
*     wa_chk2-charg = wa_mseg-charg.
*     wa_chk2-menge = wa_mseg-menge.
*     wa_chk2-werks = wa_mseg-werks.
*     wa_chk2-lgort = wa_mseg-lgort.
*     wa_chk2-grp = zmrn-monat.
*     COLLECT wa_chk2 INTO it_chk2.
*     CLEAR wa_chk2.
*  endif.
*endif.
*ENDIF.
*ENDLOOP.
*endif.
*CLEAR : it_chk3,wa_chk3.
*LOOP at it_chk2 INTO wa_chk2.
*     wa_chk3-matnr = wa_chk2-matnr.
*     wa_chk3-charg = wa_chk2-charg.
*     wa_chk3-menge = wa_chk2-menge.
*     wa_chk3-werks = wa_chk2-werks.
*     wa_chk3-lgort = wa_chk2-lgort.
*     wa_chk3-grp = wa_chk2-grp.
*     COLLECT wa_chk3 INTO it_chk3.
*     CLEAR wa_chk3.
*ENDLOOP.
**************************************************************
*
*CLEAR : IT_TAB1,WA_TAB1.
*LOOP at it_resbd_get.
**  BREAK-POINT.
**CLEAR : grp1.
**LOOP at it_resbd_get WHERE MATNR EQ it_resbd_get-MATNR.
**  SELECT SINGLE * FROM ZMRN WHERE PMMATNR EQ it_resbd_get-MATNR AND werks eq it_resbd_get-werks AND fgmatnr eq fgmatnr.
**    if sy-subrc eq 0.
**    grp1 = zmrn-monat.
**    exit.
**    endif.
**ENDLOOP.
*  CLEAR : grp1.
*   SELECT SINGLE * FROM ZMRN WHERE PMMATNR = it_resbd_get-matnr AND WERKS = it_resbd_get-WERKS AND FGMATNR EQ FGMATNR..
*  IF SY-SUBRC EQ 0.
*    GRP1 = ZMRN-MONAT.
*  ENDIF.
*
**  READ TABLE IT_CHK2 INTO WA_CHK2 WITH KEY MATNR = it_resbd_get-matnr WERKS = it_resbd_get-WERKS.
**  IF SY-SUBRC EQ 0.
**    GRP1 = WA_CHK2-GRP.
**  ENDIF.
* CLEAR : grp2.
*  READ TABLE IT_CHK2 INTO WA_CHK2 WITH KEY MATNR = it_resbd_get-matnr WERKS = it_resbd_get-WERKS grp = grp1.
*  IF SY-SUBRC EQ 0.
*    GRP2 = WA_CHK2-GRP.
*  ENDIF.
**  CLEAR : grp2.
**  SELECT SINGLE * FROM ZMRN WHERE PMMATNR = it_resbd_get-matnr AND WERKS = it_resbd_get-WERKS AND FGMATNR EQ FGMATNR..
**  IF SY-SUBRC EQ 0.
**    GRP2 = ZMRN-MONAT.
**  ENDIF.
*IF GRP1 = GRP2.
*READ TABLE it_zmrn INTO wa_zmrn with KEY pmmatnr = it_resbd_get-matnr MONAT = GRP1.
*if sy-subrc eq 0.
**  BREAK-POINT.
**  if LGORT EQ 'SF04'.
*READ TABLE IT_STK1 INTO WA_STK1 WITH KEY PMMATNR = it_resbd_get-matnr.
*IF SY-SUBRC EQ 0.
*      CLEAR C1.
*      IF WA_STK1-CHARG = it_resbd_get-CHARG AND WA_STK1-LGORT = it_resbd_get-LGORT.
*        C1 = 'A'.
*        WA_TAB1-MATNR = WA_STK1-PMMATNR.
*        COLLECT WA_TAB1 INTO IT_TAB1.
*        CLEAR WA_TAB1.
*      ENDIF.
*IF C1 NE 'A' .
*  READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY MATNR = WA_STK1-PMMATNR.
*    IF SY-SUBRC EQ 4.
*      SELECT SINGLE * FROM zmrn_ord WHERE aufnr = it_resbd_get-aufnr.
*        if sy-subrc eq 0.
*        MESSAGE I901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT WA_STK1-MENGE.
**        MESSAGE 'CHECK MRN STOCK' TYPE 'E'.
*        else.
*          if sy-datum ge '20220401'.
*            READ TABLE it_chk3 INTO wa_chk3 with KEY matnr =  WA_STK1-PMMATNR charg = WA_STK1-CHARG lgort = wa_stk1-lgort.
*            if sy-subrc eq 0.
*              if  wa_chk3-grp = grp1.
*                 MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT WA_chk3-MENGE.
*                 else.
*                   MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT WA_chk2-MENGE.
*                   endif.
*            else.
*                MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT WA_STK1-MENGE.
*            endif.
*        endif.
**        MESSAGE 'CHECK MRN STOCK' TYPE 'E'.
*        endif.
*     ENDIF.
*ENDIF.
*ENDIF.
*
*     IF LGORT EQ 'SF04'.
*       SELECT SINGLE * FROM mchb WHERE matnr eq wa_Zmrn-pmmatnr AND werks eq wa_Zmrn-werks AND lgort eq 'MRN4' AND CLABS GT 0.
*         IF SY-SUBRC EQ 0.
**           MESSAGE 'CHECK MRN STOCK & EXISTING PRODUCTION ORDERS' TYPE 'I'.
*         ENDIF.
*     ELSE.
*       SELECT SINGLE * FROM mchb WHERE matnr eq wa_Zmrn-pmmatnr AND werks eq wa_Zmrn-werks AND lgort eq 'MRN1' AND CLABS GT 0.
*         IF SY-SUBRC EQ 0.
**            MESSAGE 'CHECK MRN STOCK & EXISTING PRODUCTION ORDERS' TYPE 'I'.
*         ENDIF.
*     ENDIF.
*
**  ELSE.
**
**
**  ENDIF.
**  BREAK-POINT.
**  MESSAGE 'check' TYPE 'I'.
*endif.
*ENDIF.
*ENDLOOP.
*ENDIF.
*ENDIF.

*  *******************end on 6.6.22*****************

*IF SY-TCODE EQ 'CO01' OR SY-TCODE EQ 'CO02'.
**  BREAK-POINT.
*if it_resbd_get IS NOT INITIAL.
*
*
*  TABLES : AFPO,
*           ZMRN,
*           MARA,
*           MCHB,
*           RESB,
*           ZMRN_ORD.
*
*  data: fgmatnr like mara-matnr,
*      werks like mseg-werks,
*      LGORT TYPE MSEG-LGORT,
*      GRP1 TYPE ZMRN-MONAT,
*      actgrp TYPE zmrn-monat,
*      QTY1 TYPE MSEG-MENGE,
*      chk1 TYPE i,
*      stock TYPE mseg-menge.
*TYPES : BEGIN OF chk1,
*  pmmatnr TYPE mara-matnr,
*  werks TYPE mseg-werks,
*  grp1 TYPE zmrn-monat,
*  END OF chk1.
*
*TYPES : BEGIN OF chk2,
*  fgmatnr TYPE afpo-matnr,
*  mblnr TYPE mseg-mblnr,
*  matnr TYPE mseg-matnr,
*  charg TYPE mseg-charg,
*  menge TYPE mseg-menge,
*  lgort TYPE mseg-lgort,
*  grp TYPE zmrn-monat,
*   werks TYPE mseg-werks,
*  END OF chk2.
*
*  TYPES : BEGIN OF stk1,
*    pmmatnr TYPE mara-matnr,
*    charg TYPE mchb-charg,
*    lgort TYPE mchb-lgort,
*    menge TYPE mseg-menge,
*    werks TYPE mseg-werks,
*    END OF stk1.
* DATA: C1(1) TYPE C.
*TYPES : BEGIN OF itab1,
*    matnr TYPE mara-matnr,
*END OF itab1.
*
*DATA: MATNR1 TYPE MCHB-MATNR.
*data: it_zmrn TYPE TABLE OF ZMRN,
*      WA_ZMRN TYPE ZMRN,
*      it_mseg TYPE TABLE OF mseg,
*      wa_mseg TYPE mseg,
*      it_chk1 TYPE TABLE OF chk1,
*      wa_chk1 TYPE chk1,
*      it_chk2 TYPE TABLE OF chk2,
*      wa_chk2 TYPE chk2,
*      it_chk3 TYPE TABLE OF chk2,
*      wa_chk3 TYPE chk2,
*      it_stk1 TYPE TABLE OF stk1,
*      wa_stk1 TYPE stk1,
*      it_mchb TYPE TABLE OF mchb,
*      wa_mchb TYPE mchb,
*      it_tab1 TYPE TABLE OF itab1,
*      wa_tab1 TYPE itab1.
*
*data: cstock TYPE mseg-menge,
*      cstock1 TYPE mseg-menge.
*DATA: GRP2 TYPE ZMRN-MONAT.
*
*******************************************************************
*CLEAR : FGMATNR,WERKS,LGORT.
*LOOP at it_resbd_get.
*  SELECT SINGLE * FROM MARA WHERE MATNR EQ it_resbd_get-MATNR AND MTART EQ 'ZHLB'.
*  IF SY-SUBRC EQ 0.
*    FGMATNR = it_resbd_get-baugr.
*    WERKS = it_resbd_get-WERKS.
*    LGORT = it_resbd_get-LGORT.
*    exit.
*  ENDIF.
*endloop.
**CLEAR : grp1.
**LOOP at it_resbd_get.
**  SELECT SINGLE * FROM ZMRN WHERE PMMATNR EQ it_resbd_get-MATNR AND werks eq it_resbd_get-werks AND fgmatnr eq fgmatnr.
**    if sy-subrc eq 0.
**    grp1 = zmrn-monat.
**    exit.
**    endif.
**ENDLOOP.
*
**SELECT * FROM ZMRN INTO TABLE IT_ZMRN FOR ALL ENTRIES IN it_resbd_get WHERE PMMATNR EQ it_resbd_get-MATNR AND
**   werks eq it_resbd_get-werks AND monat eq grp1.
*SELECT * FROM ZMRN INTO TABLE IT_ZMRN FOR ALL ENTRIES IN it_resbd_get WHERE PMMATNR EQ it_resbd_get-MATNR AND
*   werks eq it_resbd_get-werks.
*IF LGORT EQ 'SF04'.
*if it_zmrn IS NOT INITIAL.
*  SELECT * FROM MCHB INTO TABLE it_mchb FOR ALL ENTRIES IN it_zmrn WHERE MATNR EQ it_ZMRN-PMMATNR AND WERKS EQ it_ZMRN-WERKS AND lgort eq 'MRN4' AND CLABS GT 0.
*endif.
*ELSE.
*if it_zmrn IS NOT INITIAL.
*  SELECT * FROM MCHB INTO TABLE it_mchb FOR ALL ENTRIES IN it_zmrn WHERE MATNR EQ it_ZMRN-PMMATNR AND WERKS EQ it_ZMRN-WERKS AND lgort eq 'MRN1' AND CLABS GT 0.
*endif.
*ENDIF.
*CLEAR : cstock.
*LOOP at it_mchb INTO wa_mchb.
*SELECT SINGLE * FROM RESB WHERE KZEAR NE 'X' AND XLOEK NE 'X' AND MATNR EQ wa_MCHB-MATNR AND WERKS EQ wa_MCHB-WERKS AND
*LGORT EQ wa_MCHB-LGORT AND CHARG EQ wa_MCHB-CHARG AND erfmg gt 0.
*  if sy-subrc eq 4.
*      cstock = cstock + wa_mchb-clabs.
*  wa_stk1-pmmatnr = wa_mchb-matnr.
*  wa_stk1-charg = wa_mchb-charg.
*  wa_stk1-menge = wa_mchb-clabs.
*  wa_stk1-werks = wa_mchb-werks.
*  wa_stk1-LGORT = wa_mchb-LGORT.
*  COLLECT wa_stk1 INTO it_stk1.
*  CLEAR wa_stk1.
*  endif.
*ENDLOOP.
************* FG CODE OF MRN STOCK*************************
*CLEAR : IT_MSEG,WA_MSEG.
*if it_stk1 IS NOT INITIAL.
*SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_stk1 WHERE bwart eq '262' AND matnr eq it_stk1-pmmatnr
*  AND charg eq it_stk1-charg AND werks eq it_stk1-werks AND lgort eq it_stk1-lgort.
*endif.
*sort it_mseg DESCENDING by mblnr.
*if it_mseg IS NOT INITIAL.
*LOOP at it_mseg INTO wa_mseg.
*SELECT SINGLE * FROM afpo WHERE aufnr eq wa_mseg-aufnr.
*if sy-subrc eq 0.
*SELECT SINGLE * FROM zmrn WHERE pmmatnr eq wa_mseg-matnr AND werks eq wa_mseg-werks AND fgmatnr eq afpo-matnr.
*if sy-subrc eq 0.
*  if cstock1 le cstock.
*      cstock1 = cstock1 + wa_mseg-menge.
*     wa_chk2-fgmatnr = afpo-matnr.
*     wa_chk2-mblnr = wa_mseg-mblnr.
*     wa_chk2-matnr = wa_mseg-matnr.
*     wa_chk2-charg = wa_mseg-charg.
*     wa_chk2-menge = wa_mseg-menge.
*     wa_chk2-werks = wa_mseg-werks.
*     wa_chk2-lgort = wa_mseg-lgort.
*     wa_chk2-grp = zmrn-monat.
*     COLLECT wa_chk2 INTO it_chk2.
*     CLEAR wa_chk2.
*  endif.
*endif.
*ENDIF.
*ENDLOOP.
*endif.
*CLEAR : it_chk3,wa_chk3.
*LOOP at it_chk2 INTO wa_chk2.
*     wa_chk3-matnr = wa_chk2-matnr.
*     wa_chk3-charg = wa_chk2-charg.
*     wa_chk3-menge = wa_chk2-menge.
*     wa_chk3-werks = wa_chk2-werks.
*     wa_chk3-lgort = wa_chk2-lgort.
*     wa_chk3-grp = wa_chk2-grp.
*     COLLECT wa_chk3 INTO it_chk3.
*     CLEAR wa_chk3.
*ENDLOOP.
**************************************************************
*
*CLEAR : IT_TAB1,WA_TAB1.
* LOOP at IT_STK1 INTO WA_STK1 .
*  CLEAR : grp1.
*   SELECT SINGLE * FROM ZMRN WHERE PMMATNR = WA_STK1-pmmatnr AND WERKS = WA_STK1-WERKS AND FGMATNR EQ FGMATNR..
*  IF SY-SUBRC EQ 0.
*    GRP1 = ZMRN-MONAT.
*  ENDIF.
* CLEAR : grp2.
* READ TABLE IT_CHK2 INTO WA_CHK2 WITH KEY MATNR = WA_STK1-pmmatnr charg = wa_stk1-charg WERKS = WA_STK1-WERKS grp = grp1.
*  IF SY-SUBRC EQ 0.
**  READ TABLE IT_CHK2 INTO WA_CHK2 WITH KEY MATNR = WA_STK1-pmmatnr WERKS = WA_STK1-WERKS grp = grp1.
*  READ TABLE IT_CHK2 INTO WA_CHK2 WITH KEY MATNR = WA_STK1-pmmatnr charg = wa_stk1-charg WERKS = WA_STK1-WERKS grp = grp1.
*  "6.6.22
*  IF SY-SUBRC EQ 0.
*    GRP2 = WA_CHK2-GRP.
*  ENDIF.
*IF GRP1 = GRP2.
*READ TABLE it_zmrn INTO wa_zmrn with KEY pmmatnr = WA_STK1-pmmatnr MONAT = GRP1.
*if sy-subrc eq 0.
*  READ TABLE it_resbd_get with KEY matnr = wa_stk1-pmmatnr charg = wa_stk1-charg.
*  if sy-subrc eq 4.
*    MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT WA_chk2-MENGE.
*  endif.
*      CLEAR C1.
*      IF WA_STK1-CHARG = it_resbd_get-CHARG AND WA_STK1-LGORT = it_resbd_get-LGORT.
*        C1 = 'A'.
*        WA_TAB1-MATNR = WA_STK1-PMMATNR.
*        COLLECT WA_TAB1 INTO IT_TAB1.
*        CLEAR WA_TAB1.
*      ENDIF.
*IF C1 NE 'A' .
*      SELECT SINGLE * FROM zmrn_ord WHERE aufnr = it_resbd_get-aufnr.
*        if sy-subrc eq 0.
*        MESSAGE I901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT.
**         WA_STK1-MENGE.
*        else.
*          if sy-datum ge '20220401'.
*            READ TABLE it_chk3 INTO wa_chk3 with KEY matnr =  WA_STK1-PMMATNR charg = WA_STK1-CHARG lgort = wa_stk1-lgort.
*            if sy-subrc eq 0.
*              if  wa_chk3-grp = grp1.
*                 MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT .
**                 WA_chk3-MENGE.
*                 else.
*                   MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT.
**                    WA_chk2-MENGE.
*                   endif.
*            else.
*                MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT.
**                 WA_STK1-MENGE.
*            endif.
*        endif.
*        endif.
*ENDIF.
*
*     IF LGORT EQ 'SF04'.
*       SELECT SINGLE * FROM mchb WHERE matnr eq wa_Zmrn-pmmatnr AND werks eq wa_Zmrn-werks AND lgort eq 'MRN4' AND CLABS GT 0.
*         IF SY-SUBRC EQ 0.
**           MESSAGE 'CHECK MRN STOCK & EXISTING PRODUCTION ORDERS' TYPE 'I'.
*         ENDIF.
*     ELSE.
*       SELECT SINGLE * FROM mchb WHERE matnr eq wa_Zmrn-pmmatnr AND werks eq wa_Zmrn-werks AND lgort eq 'MRN1' AND CLABS GT 0.
*         IF SY-SUBRC EQ 0.
**            MESSAGE 'CHECK MRN STOCK & EXISTING PRODUCTION ORDERS' TYPE 'I'.
*         ENDIF.
*     ENDIF.
*
*endif.
*ENDIF.
*ENDif.
*ENDLOOP.
*ENDIF.
*ENDIF.
*27.7.22**********************************************


IF sy-tcode EQ 'COR1' OR sy-tcode EQ 'COR2'.
*  BREAK-POINT.
  IF it_resbd_get IS NOT INITIAL.


    TABLES : afpo,
             zmrn,
             mara,
             mchb,
             resb,
             zmrn_ord.

    DATA: fgmatnr LIKE mara-matnr,
          werks   LIKE mseg-werks,
          lgort   TYPE mseg-lgort,
          grp1    TYPE zmrn-monat,
          actgrp  TYPE zmrn-monat,
          qty1    TYPE mseg-menge,
          chk1    TYPE i,
          stock   TYPE mseg-menge.
    TYPES : BEGIN OF chk1,
              pmmatnr TYPE mara-matnr,
              werks   TYPE mseg-werks,
              grp1    TYPE zmrn-monat,
            END OF chk1.

    TYPES : BEGIN OF chk2,
              fgmatnr TYPE afpo-matnr,
              mblnr   TYPE mseg-mblnr,
              matnr   TYPE mseg-matnr,
              charg   TYPE mseg-charg,
              menge   TYPE mseg-menge,
              lgort   TYPE mseg-lgort,
              grp     TYPE zmrn-monat,
              werks   TYPE mseg-werks,
            END OF chk2.

    TYPES : BEGIN OF stk1,
              pmmatnr TYPE mara-matnr,
              charg   TYPE mchb-charg,
              lgort   TYPE mchb-lgort,
              menge   TYPE mseg-menge,
              werks   TYPE mseg-werks,
            END OF stk1.
    DATA: c1(1) TYPE c.
    TYPES : BEGIN OF itab1,
              matnr TYPE mara-matnr,
            END OF itab1.

    DATA: matnr1 TYPE mchb-matnr.
    DATA: it_zmrn TYPE TABLE OF zmrn,
          wa_zmrn TYPE zmrn,
          it_mseg TYPE TABLE OF mseg,
          wa_mseg TYPE mseg,
          it_chk1 TYPE TABLE OF chk1,
          wa_chk1 TYPE chk1,
          it_chk2 TYPE TABLE OF chk2,
          wa_chk2 TYPE chk2,
          it_chk3 TYPE TABLE OF chk2,
          wa_chk3 TYPE chk2,
          it_stk1 TYPE TABLE OF stk1,
          wa_stk1 TYPE stk1,
          it_mchb TYPE TABLE OF mchb,
          wa_mchb TYPE mchb,
          it_tab1 TYPE TABLE OF itab1,
          wa_tab1 TYPE itab1.

    DATA: cstock   TYPE mseg-menge,
          cstock1  TYPE mseg-menge,
          csstock2 TYPE mseg-menge.
    DATA: grp2 TYPE zmrn-monat.

******************************************************************
    CLEAR : fgmatnr,werks,lgort.
    LOOP AT it_resbd_get.
      SELECT SINGLE * FROM mara WHERE matnr EQ it_resbd_get-matnr AND mtart EQ 'ZHLB'.
      IF sy-subrc EQ 0.
        fgmatnr = it_resbd_get-baugr.
        werks = it_resbd_get-werks.
        lgort = it_resbd_get-lgort.
        EXIT.
      ENDIF.
    ENDLOOP.
*CLEAR : grp1.
*LOOP at it_resbd_get.
*  SELECT SINGLE * FROM ZMRN WHERE PMMATNR EQ it_resbd_get-MATNR AND werks eq it_resbd_get-werks AND fgmatnr eq fgmatnr.
*    if sy-subrc eq 0.
*    grp1 = zmrn-monat.
*    exit.
*    endif.
*ENDLOOP.

*SELECT * FROM ZMRN INTO TABLE IT_ZMRN FOR ALL ENTRIES IN it_resbd_get WHERE PMMATNR EQ it_resbd_get-MATNR AND
*   werks eq it_resbd_get-werks AND monat eq grp1.
    SELECT * FROM zmrn INTO TABLE it_zmrn FOR ALL ENTRIES IN it_resbd_get WHERE pmmatnr EQ it_resbd_get-matnr AND
       werks EQ it_resbd_get-werks.
    IF lgort EQ 'SF04'.
      IF it_zmrn IS NOT INITIAL.
        SELECT * FROM mchb INTO TABLE it_mchb FOR ALL ENTRIES IN it_zmrn WHERE matnr EQ it_zmrn-pmmatnr AND werks EQ it_zmrn-werks AND lgort EQ 'MRN4' AND clabs GT 0.
      ENDIF.
    ELSE.
      IF it_zmrn IS NOT INITIAL.
        SELECT * FROM mchb INTO TABLE it_mchb FOR ALL ENTRIES IN it_zmrn WHERE matnr EQ it_zmrn-pmmatnr AND werks EQ it_zmrn-werks AND lgort EQ 'MRN1' AND clabs GT 0.
      ENDIF.
    ENDIF.
    CLEAR : cstock.
    LOOP AT it_mchb INTO wa_mchb.
      SELECT SINGLE * FROM resb WHERE kzear NE 'X' AND xloek NE 'X' AND matnr EQ wa_mchb-matnr AND werks EQ wa_mchb-werks AND
      lgort EQ wa_mchb-lgort AND charg EQ wa_mchb-charg AND erfmg GT 0.
      IF sy-subrc EQ 4.
        cstock = cstock + wa_mchb-clabs.
        wa_stk1-pmmatnr = wa_mchb-matnr.
        wa_stk1-charg = wa_mchb-charg.
        wa_stk1-menge = wa_mchb-clabs.
        wa_stk1-werks = wa_mchb-werks.
        wa_stk1-lgort = wa_mchb-lgort.
        COLLECT wa_stk1 INTO it_stk1.
        CLEAR wa_stk1.
      ENDIF.
    ENDLOOP.
************ FG CODE OF MRN STOCK*************************
    CLEAR : it_mseg,wa_mseg.
    IF it_stk1 IS NOT INITIAL.
      SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_stk1 WHERE bwart EQ '262' AND matnr EQ it_stk1-pmmatnr
        AND charg EQ it_stk1-charg AND werks EQ it_stk1-werks AND lgort EQ it_stk1-lgort.
    ENDIF.
*sort it_mseg DESCENDING by mblnr.
    SORT it_mseg DESCENDING BY charg mblnr.
    IF it_mseg IS NOT INITIAL.
      CLEAR : csstock2.
      LOOP AT it_mseg INTO wa_mseg.
        SELECT SINGLE * FROM afpo WHERE aufnr EQ wa_mseg-aufnr.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM zmrn WHERE pmmatnr EQ wa_mseg-matnr AND werks EQ wa_mseg-werks AND fgmatnr EQ afpo-matnr.
          IF sy-subrc EQ 0.
            READ TABLE it_stk1 INTO wa_stk1 WITH KEY pmmatnr = wa_mseg-matnr charg = wa_mseg-charg lgort = wa_mseg-lgort
            werks = wa_mseg-werks.
            IF sy-subrc EQ 0.
              ON CHANGE OF wa_mseg-charg.
                csstock2 = 0.
                cstock1 = 0.
              ENDON.
              csstock2 = wa_stk1-menge.
            ENDIF.
*  if cstock1 le cstock.
            IF cstock1 LT csstock2.
              cstock1 = cstock1 + wa_mseg-menge.
              wa_chk2-fgmatnr = afpo-matnr.
              wa_chk2-mblnr = wa_mseg-mblnr.
              wa_chk2-matnr = wa_mseg-matnr.
              wa_chk2-charg = wa_mseg-charg.
              wa_chk2-menge = wa_mseg-menge.
              wa_chk2-werks = wa_mseg-werks.
              wa_chk2-lgort = wa_mseg-lgort.
              wa_chk2-grp = zmrn-monat.
              COLLECT wa_chk2 INTO it_chk2.
              CLEAR wa_chk2.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
    CLEAR : it_chk3,wa_chk3.
    LOOP AT it_chk2 INTO wa_chk2.
      wa_chk3-matnr = wa_chk2-matnr.
      wa_chk3-charg = wa_chk2-charg.
      wa_chk3-menge = wa_chk2-menge.
      wa_chk3-werks = wa_chk2-werks.
      wa_chk3-lgort = wa_chk2-lgort.
      wa_chk3-grp = wa_chk2-grp.
      COLLECT wa_chk3 INTO it_chk3.
      CLEAR wa_chk3.
    ENDLOOP.
*************************************************************

    CLEAR : it_tab1,wa_tab1.
    LOOP AT it_stk1 INTO wa_stk1 .
      CLEAR : grp1.
      SELECT SINGLE * FROM zmrn WHERE pmmatnr = wa_stk1-pmmatnr AND werks = wa_stk1-werks AND fgmatnr EQ fgmatnr..
      IF sy-subrc EQ 0.
        grp1 = zmrn-monat.
      ENDIF.
      CLEAR : grp2.
      READ TABLE it_chk2 INTO wa_chk2 WITH KEY matnr = wa_stk1-pmmatnr charg = wa_stk1-charg werks = wa_stk1-werks grp = grp1.
      IF sy-subrc EQ 0.
*  READ TABLE IT_CHK2 INTO WA_CHK2 WITH KEY MATNR = WA_STK1-pmmatnr WERKS = WA_STK1-WERKS grp = grp1.
        READ TABLE it_chk2 INTO wa_chk2 WITH KEY matnr = wa_stk1-pmmatnr charg = wa_stk1-charg werks = wa_stk1-werks grp = grp1.
        "6.6.22
        IF sy-subrc EQ 0.
          grp2 = wa_chk2-grp.
        ENDIF.
        IF grp1 = grp2.
          READ TABLE it_zmrn INTO wa_zmrn WITH KEY pmmatnr = wa_stk1-pmmatnr monat = grp1.
          IF sy-subrc EQ 0.
            READ TABLE it_resbd_get WITH KEY matnr = wa_stk1-pmmatnr charg = wa_stk1-charg.
            IF sy-subrc EQ 4.
*    MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT WA_chk2-MENGE.
*      MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT WA_stk1-MENGE.  "5.2.23
              MESSAGE i901(0u) WITH wa_stk1-pmmatnr wa_stk1-charg wa_stk1-lgort wa_stk1-menge.  "5.2.23
            ENDIF.
            CLEAR c1.
            IF wa_stk1-charg = it_resbd_get-charg AND wa_stk1-lgort = it_resbd_get-lgort.
              c1 = 'A'.
              wa_tab1-matnr = wa_stk1-pmmatnr.
              COLLECT wa_tab1 INTO it_tab1.
              CLEAR wa_tab1.
            ENDIF.
            IF c1 NE 'A' .
              SELECT SINGLE * FROM zmrn_ord WHERE aufnr = it_resbd_get-aufnr.
              IF sy-subrc EQ 0.
                MESSAGE i901(0u) WITH wa_stk1-pmmatnr wa_stk1-charg wa_stk1-lgort.
*         WA_STK1-MENGE.
              ELSE.
                IF sy-datum GE '20220401'.
                  READ TABLE it_chk3 INTO wa_chk3 WITH KEY matnr =  wa_stk1-pmmatnr charg = wa_stk1-charg lgort = wa_stk1-lgort.
                  IF sy-subrc EQ 0.
                    IF  wa_chk3-grp = grp1.
*                 MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT .
                      MESSAGE i901(0u) WITH wa_stk1-pmmatnr wa_stk1-charg wa_stk1-lgort .  "CHANGED ON 22.5.23
*                 WA_chk3-MENGE.
                    ELSE.
*                   MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT.
                      MESSAGE i901(0u) WITH wa_stk1-pmmatnr wa_stk1-charg wa_stk1-lgort.
*                    WA_chk2-MENGE.
                    ENDIF.
                  ELSE.
*                MESSAGE E901(0u) WITH WA_STK1-PMMATNR WA_STK1-CHARG WA_STK1-LGORT.
                    MESSAGE i901(0u) WITH wa_stk1-pmmatnr wa_stk1-charg wa_stk1-lgort.

*                 WA_STK1-MENGE.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.

            IF lgort EQ 'SF04'.
              SELECT SINGLE * FROM mchb WHERE matnr EQ wa_zmrn-pmmatnr AND werks EQ wa_zmrn-werks AND lgort EQ 'MRN4' AND clabs GT 0.
              IF sy-subrc EQ 0.
*           MESSAGE 'CHECK MRN STOCK & EXISTING PRODUCTION ORDERS' TYPE 'I'.
              ENDIF.
            ELSE.
              SELECT SINGLE * FROM mchb WHERE matnr EQ wa_zmrn-pmmatnr AND werks EQ wa_zmrn-werks AND lgort EQ 'MRN1' AND clabs GT 0.
              IF sy-subrc EQ 0.
*            MESSAGE 'CHECK MRN STOCK & EXISTING PRODUCTION ORDERS' TYPE 'I'.
              ENDIF.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDIF.




ENDENHANCEMENT.
