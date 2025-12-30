*&---------------------------------------------------------------------*
*& Report  ZAC1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zac11 NO STANDARD PAGE HEADING line-SIZE 500.
TABLES : aufk,
         afpo,
         mara,
         mvke,
         tvm5t.

TYPES : BEGIN OF itab1,

  matnr TYPE afpo-matnr,
  charg TYPE afpo-charg,
  maktx TYPE makt-maktx,
  psmng TYPE afpo-psmng,
  wemng TYPE afpo-wemng,
  bezei TYPE tvm5t-bezei,
  rate1 TYPE p DECIMALS 2,
  mtart TYPE mara-mtart,
   aufnr TYPE afpo-aufnr,
END OF itab1.

TYPES : BEGIN OF itab2,
  matnr TYPE afpo-matnr,
  charg TYPE afpo-charg,
  aufnr TYPE afpo-aufnr,
  maktx TYPE makt-maktx,
  psmng TYPE afpo-psmng,
  wemng TYPE afpo-wemng,
  bezei TYPE tvm5t-bezei,
  menge TYPE aufm-menge,
  dmbtr TYPE aufm-dmbtr,
END OF itab2.

TYPES : BEGIN OF itab3,
  matnr TYPE afpo-matnr,
*  charg TYPE afpo-charg,
  aufnr TYPE afpo-aufnr,
  aufnr1 TYPE afpo-aufnr,
  maktx TYPE makt-maktx,
  psmng TYPE afpo-psmng,
  wemng TYPE afpo-wemng,
  bezei TYPE tvm5t-bezei,
  matnr1 TYPE afpo-matnr,
  maktx1 TYPE makt-maktx,
  menge1 TYPE aufm-menge,
  dmbtr1 TYPE aufm-dmbtr,
END OF itab3.

TYPES : BEGIN OF itab4,
  matnr TYPE afpo-matnr,
*  charg TYPE afpo-charg,
*  aufnr TYPE afpo-aufnr,
*  aufnr1 TYPE afpo-aufnr,
  maktx TYPE makt-maktx,
  psmng TYPE afpo-psmng,
  wemng TYPE afpo-wemng,
  bezei TYPE tvm5t-bezei,
  matnr1 TYPE afpo-matnr,
  maktx1 TYPE makt-maktx,
  menge1 TYPE aufm-menge,
  dmbtr1 TYPE aufm-dmbtr,
END OF itab4.

TYPES : BEGIN OF itab5,
  matnr TYPE afpo-matnr,
*  charg TYPE afpo-charg,
*  aufnr TYPE afpo-aufnr,
*  aufnr1 TYPE afpo-aufnr,
  maktx TYPE makt-maktx,
  psmng TYPE afpo-psmng,
  wemng TYPE afpo-wemng,
*  bezei TYPE tvm5t-bezei,
  matnr1 TYPE afpo-matnr,
  maktx1 TYPE makt-maktx,
  menge1 TYPE aufm-menge,
  dmbtr1 TYPE aufm-dmbtr,
END OF itab5.

TYPES : BEGIN OF itab11,
  matnr TYPE afpo-matnr,
  charg TYPE afpo-charg,
  END OF ITAB11.

TYPES : BEGIN OF itab12,
matnr TYPE afpo-matnr,
count TYPE i,
END OF ITAB12.

DATA : it_tab1 TYPE TABLE OF itab1,
       wa_tab1 TYPE itab1,
       it_tab2 TYPE TABLE OF itab2,
       wa_tab2 TYPE itab2,
       it_tab3 TYPE TABLE OF itab3,
       wa_tab3 TYPE itab3,
       it_tab4 TYPE TABLE OF itab4,
       wa_tab4 TYPE itab4,
       it_tab5 TYPE TABLE OF itab5,
       wa_tab5 TYPE itab5,
       it_tab11 TYPE TABLE OF itab11,
       wa_tab11 TYPE itab11,
       it_tab12 TYPE TABLE OF itab12,
       wa_tab12 TYPE itab12.

DATA : it_afpo TYPE TABLE OF afpo,
       wa_afpo TYPE afpo,
       it_aufk TYPE TABLE OF aufk,
       wa_aufk TYPE aufk,
       it_aufm TYPE TABLE OF aufm,
       wa_aufm TYPE aufm,
       it_mara TYPE TABLE OF mara,
       wa_mara TYPE mara,
       it_makt TYPE TABLE OF makt,
       wa_makt TYPE makt.

DATA : val TYPE p DECIMALS 2,
       val1 TYPE p DECIMALS 2,
       val2 TYPE p DECIMALS 2,
       qty TYPE p DECIMALS 3,
       rate1 TYPE p DECIMALS 2,
       rate2 TYPE p DECIMALS 2,
       val_1 TYPE p DECIMALS 2,
       type1 TYPE mara-mtart,
       w_rate TYPE p DECIMALS 2.

DATA : count TYPE i VALUE 1,
       count1 TYPE i,
       w_matnr TYPE mara-matnr.

DATA : w_umren LIKE marm-umren,
       w_umrez LIKE marm-umrez,
       w_stlnr like mast-stlnr,
       w_bmeng like stko-bmeng,
       w_tbat(4) type n,
       w_tbat1(7) type p decimals 2,
       w_batsz(9) type p.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECT-OPTIONS  : s_matnr FOR   afpo-matnr.
SELECT-OPTIONS  : s_aufnr FOR afpo-aufnr.
PARAMETERS : p_werks LIKE afpo-dwerk OBLIGATORY.
SELECT-OPTIONS : batch FOR afpo-charg.
*SELECT-OPTIONS : s_lgort FOR afpo-lgort .
SELECT-OPTIONS : s_budat FOR aufk-erdat OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

SELECT * FROM aufk INTO TABLE it_aufk WHERE aufnr IN s_aufnr AND erdat IN s_budat AND werks EQ p_werks AND loekz ne 'X'.
IF sy-subrc NE 0.
  EXIT.
ENDIF.

SELECT * FROM afpo INTO TABLE it_afpo FOR ALL ENTRIES IN it_aufk WHERE aufnr EQ it_aufk-aufnr AND matnr IN s_matnr AND charg IN batch.
*      AND lgort IN s_lgort.
IF sy-subrc NE 0.
  EXIT.
ENDIF.


SELECT * FROM aufm INTO TABLE it_aufm FOR ALL ENTRIES IN it_afpo WHERE aufnr EQ it_afpo-aufnr.
IF sy-subrc NE 0.
  EXIT.
ENDIF.

SELECT * FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_aufm WHERE matnr EQ it_aufm-matnr AND  mtart IN ('ZVRP','ZROH').
IF sy-subrc EQ 0.
  SELECT * FROM makt INTO TABLE it_makt FOR ALL ENTRIES IN it_aufm WHERE matnr EQ it_aufm-matnr.
  IF sy-subrc NE 0.
  ENDIF.
ENDIF.



*SORT it_afpo BY charg ASCENDING matnr DESCENDING.
SORT it_afpo BY matnr.
SORT it_aufm BY matnr.


LOOP AT it_afpo INTO wa_afpo.

  wa_tab1-matnr = wa_afpo-matnr.
  READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_afpo-matnr.
  IF sy-subrc EQ 0.
*    WRITE : 31(35) wa_makt-maktx.
    wa_tab1-maktx = wa_makt-maktx.
  ENDIF.
  SELECT SINGLE * FROM mara WHERE matnr = wa_afpo-matnr.
  IF sy-subrc EQ 0.
    wa_tab1-mtart = mara-mtart.
  ENDIF.
*  WRITE : 68 'ORDER',wa_afpo-aufnr.
  wa_tab1-aufnr = wa_afpo-aufnr.
*  WRITE : / 'BATCH SIZE',12 wa_afpo-psmng LEFT-JUSTIFIED,68 'ACTUAL QTY RECD.',wa_afpo-wemng.
  val_1 = wa_afpo-wemng.

  wa_tab1-psmng = wa_afpo-psmng.
  wa_tab1-wemng = wa_afpo-wemng.
  SELECT SINGLE * FROM mvke WHERE matnr EQ wa_afpo-matnr.
  IF sy-subrc EQ 0.
    SELECT SINGLE * FROM tvm5t WHERE mvgr5 EQ mvke-mvgr5.
    IF sy-subrc EQ 0.
*          WRITE : /1 'PACK SIZE',12 tvm5t-bezei LEFT-JUSTIFIED.
      wa_tab1-bezei = tvm5t-bezei.
    ENDIF.
  ENDIF.
*  WRITE : 68 'BATCH ', wa_afpo-charg .
  wa_tab1-charg = wa_afpo-charg.
*  wa_afpo-dnrel.
*  WRITE :/1(100) SY-ULINE..
*  WRITE : /1 'MATERIAL',31 'DESCRIPTION',68 'ID NO.',80 'QUANTITY',97 'VALUE'.
*  WRITE :/1(100) SY-ULINE..


  LOOP AT it_aufm INTO wa_aufm WHERE aufnr EQ wa_afpo-aufnr.
    IF wa_aufm-shkzg EQ 'S'.
      wa_aufm-menge = wa_aufm-menge * ( - 1 ).
      wa_aufm-dmbtr = wa_aufm-dmbtr * ( - 1 ).
    ENDIF.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_aufm-matnr .
    IF sy-subrc EQ 0.
*        WRITE : /1 wa_aufm-matnr LEFT-JUSTIFIED.
      wa_tab2-aufnr = wa_aufm-aufnr.
      wa_tab2-matnr = wa_aufm-matnr.
      READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_aufm-matnr.
      IF sy-subrc EQ 0.
*              WRITE : 31(35) wa_makt-maktx LEFT-JUSTIFIED.
        wa_tab2-maktx = wa_makt-maktx.
      ENDIF.
*           WRITE : 68 wa_aufm-charg LEFT-JUSTIFIED,80 wa_aufm-menge LEFT-JUSTIFIED,97 wa_aufm-dmbtr LEFT-JUSTIFIED.
*           wa_tab2-charg = wa_aufm-charg.
      wa_tab2-menge = wa_aufm-menge.
      wa_tab2-dmbtr = wa_aufm-dmbtr.

*           val = val + wa_aufm-dmbtr.
*           qty = qty + wa_aufm-menge.
    ENDIF.
    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.
  ENDLOOP.


  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.
ENDLOOP.

SORT it_tab1 BY charg ASCENDING matnr DESCENDING.

LOOP AT it_tab1 INTO wa_tab1.

*WRITE : / WA_TAB1-MATNR,WA_TAB1-BEZEI.
  wa_tab4-matnr = wa_tab1-matnr.
  wa_tab4-maktx = wa_tab1-maktx.
  wa_tab4-wemng = wa_tab1-wemng.
  WA_TAB4-PSMNG = WA_TAB1-PSMNG.
  wa_tab4-bezei = wa_tab1-bezei.
*  wa_tab4-aufnr = wa_tab1-aufnr.
  COLLECT wa_tab4 INTO it_tab4.
  CLEAR wa_tab4.
  LOOP AT it_tab2 INTO wa_tab2 WHERE aufnr = wa_tab1-aufnr.
    if wa_tab2-dmbtr ne 0.
      wa_tab3-matnr = wa_tab1-matnr.
      wa_tab3-matnr1 = wa_tab2-matnr.
      wa_tab3-maktx1 = wa_tab2-maktx.
      wa_tab3-menge1 = wa_tab2-menge.
      wa_tab3-dmbtr1 = wa_tab2-dmbtr.
*    wa_tab3-aufnr1 = wa_tab1-aufnr.
      COLLECT wa_tab3 INTO it_tab3 .
      CLEAR wa_tab3.
    ENDIF.
  ENDLOOP.

ENDLOOP.

*WRITE :/1(100) SY-ULINE..

LOOP AT IT_TAB1 INTO WA_TAB1.
  if wa_tab1-charg ne '   '.
    WA_TAB11-MATNR = WA_TAB1-MATNR.
    WA_TAB11-CHARG = WA_TAB1-CHARG.
    COLLECT WA_TAB11 INTO IT_TAB11.
    CLEAR WA_TAB11.
  ENDIF.
ENDLOOP.
SORT IT_TAB11 BY MATNR CHARG.

LOOP AT IT_TAB11 INTO WA_TAB11.

  ON CHANGE OF WA_TAB11-MATNR.
    if count1 ne 0.
*      WRITE : / w_matnr,count1.
      wa_tab12-matnr = w_matnr.
      wa_tab12-count = count1.
*      skip.
    ENDIF.

    count1 = 0.
    COUNT = 1.
  ENDON.
  count1 = count.
  w_matnr = WA_TAB11-MATNR.
  COUNT = COUNT + 1.

  AT last.
*    WRITE : / w_matnr,count1.
    wa_tab12-matnr = w_matnr.
    wa_tab12-count = count1.
  ENDAT.
  COLLECT wa_tab12 INTO it_tab12.
  CLEAR wa_tab12.

ENDLOOP.

*LOOP at it_tab12 INTO wa_tab12.
*  WRITE  : / 'count',wa_tab12-matnr,wa_tab12-count.
*ENDLOOP.

CLEAR : W_TBAT,W_TBAT1,W_BATSZ,W_BMENG,W_STLNR.

SORT IT_TAB3 BY MATNR.
LOOP at it_tab3 INTO wa_tab3 .
  ON CHANGE OF WA_TAB3-MATNR.
    IF VAL1 NE 0.
      WRITE :/1(100) SY-ULINE..
      WRITE : /69 VAL1.
      VAL1 = 0.
      WRITE :/1(100) SY-ULINE.
*      SKIP.
    ENDIF.
    READ TABLE IT_TAB4 INTO WA_TAB4 WITH KEY MATNR = WA_TAB3-MATNR.
    IF SY-SUBRC EQ 0.
      WRITE : /1(100) SY-ULINE.
      WRITE : /'PRODUCT', wa_tab4-matnr.
      WRITE : WA_TAB4-MAKTX.
      WRITE : / 'PACK SIZE',WA_TAB4-BEZEI.
      WRITE : / 'TOTAL QUANTITY RECEIVED',wa_tab4-wemng LEFT-JUSTIFIED.
      READ TABLE it_tab12 INTO wa_tab12 with KEY matnr = wa_tab4-matnr.
      if sy-subrc eq 0.
        WRITE : 'TOTAL BATCH :',WA_TAB12-COUNT LEFT-JUSTIFIED.
      ENDIF.

      select single stlnr  from mast into w_stlnr where matnr = wa_tab4-matnr and werks = p_werks.
      select single bmeng  from stko into w_bmeng where stlnr = w_stlnr.
      w_tbat = wa_tab4-wemng / ( w_bmeng * 98 / 100 ).
      w_tbat1 = wa_tab4-wemng / ( w_bmeng * 98 / 100 ).
      w_batsz = w_tbat1 * w_bmeng.

*      WRITE : 'BATCH SIZE :',W_BATSZ LEFT-JUSTIFIED.
      WRITE : 'BATCH SIZE :',WA_TAB4-PSMNG LEFT-JUSTIFIED.
    ENDIF.
    WRITE :/1(100) SY-ULINE..
    WRITE : /1 'MATERIAL',12 'DESCRIPTION',55 'QUALITY',70 'VALUE',85 'RATE'.
    WRITE :/1(100) SY-ULINE..
  ENDON.

*    ,wa_tab1-maktx,wa_tab1-bezei.
  WRITE : /1 wa_tab3-matnr1,12 wa_tab3-maktx1,55 wa_tab3-menge1,70 wa_tab3-dmbtr1.
  VAL1 = VAL1 +  wa_tab3-dmbtr1.
ENDLOOP.
*ENDLOOP.
WRITE :/1(100) SY-ULINE..

*******************************************************
