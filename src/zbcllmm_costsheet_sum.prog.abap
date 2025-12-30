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
         tvm5t,
         makt,
         a602,
         konp,
         a501,
         a611,
         a004,
         A609.

TYPE-POOLS:  slis.

DATA: g_repid LIKE sy-repid,
      fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort TYPE slis_t_sortinfo_alv,
      wa_sort LIKE LINE OF sort,
      layout TYPE slis_layout_alv.


TYPES : BEGIN OF itab1,
  bwart TYPE mseg-bwart,
 matnr TYPE afpo-matnr,
  charg TYPE mseg-charg,
  END OF itab1.

TYPES : BEGIN OF itab2,
aufnr TYPE afpo-aufnr,
matnr TYPE afpo-matnr,
matnr1 TYPE afpo-matnr,
charg TYPE afpo-charg,
maktx TYPE makt-maktx,
psmng TYPE afpo-psmng,
wemng TYPE afpo-wemng,
bezei TYPE tvm5t-bezei,
rate1 TYPE p DECIMALS 2,
mtart TYPE mara-mtart,
  rm_rate TYPE p DECIMALS 2,
   pm_rate TYPE p DECIMALS 2,
  rm_rt TYPE p DECIMALS 2,
END OF itab2.

TYPES : BEGIN OF itab3,

  matnr TYPE afpo-matnr,
  charg TYPE afpo-charg,
  aufnr TYPE afpo-aufnr,
  maktx TYPE makt-maktx,
  psmng TYPE afpo-psmng,
  wemng TYPE afpo-wemng,
  bezei TYPE tvm5t-bezei,
  menge TYPE aufm-menge,
  dmbtr TYPE aufm-dmbtr,
  mtart TYPE mara-mtart,
  rm_rate TYPE p DECIMALS 2,
  pm_rate TYPE p DECIMALS 2,
END OF itab3.

TYPES : BEGIN OF itab11,
  bwart TYPE mseg-bwart,
  mblnr TYPE mseg-mblnr,
  matnr TYPE mseg-matnr,
  charg TYPE mseg-charg,
  menge TYPE mseg-menge,
  END OF itab11.

TYPES : BEGIN OF itab12,
count TYPE i,
count1 TYPE i,
matnr TYPE mseg-matnr,
charg TYPE mseg-charg,
menge TYPE mseg-menge,
menge1 TYPE mseg-menge,
  rm_rt TYPE p DECIMALS 2,
  pm_rate TYPE p DECIMALS 2,
  aufnr_pm TYPE afpo-aufnr,
  aufnr_rm TYPE afpo-aufnr,
  maktx TYPE makt-maktx,
END OF itab12.

TYPES : BEGIN OF ITAS1,
matnr  TYPE mseg-matnr,
charg TYPE mseg-charg,
menge TYPE mseg-menge,
menge1 TYPE mseg-menge,
  rm_rt TYPE p DECIMALS 2,
  pm_rate TYPE p DECIMALS 2,
  aufnr_pm TYPE afpo-aufnr,
  aufnr_rm TYPE afpo-aufnr,
  maktx TYPE makt-maktx,
  MRP TYPE konp-kbetr,
  ED TYPE konp-kbetr,
  edVAL TYPE konp-kbetr,
  CCPC TYPE konp-kbetr,
END OF ITAS1.

TYPES : BEGIN OF ITAS2,
matnr(19) TYPE c,
*   TYPE mseg-matnr,
charg TYPE mseg-charg,
menge TYPE mseg-menge,
menge1 TYPE mseg-menge,
  rm_rt TYPE p DECIMALS 2,
  pm_rate TYPE p DECIMALS 2,
  aufnr_pm TYPE afpo-aufnr,
  aufnr_rm TYPE afpo-aufnr,
  maktx TYPE makt-maktx,
  MRP TYPE konp-kbetr,
  ED TYPE konp-kbetr,
  edVAL TYPE konp-kbetr,
  CCPC TYPE konp-kbetr,
  PTS TYPE konp-kbetr,
  GST TYPE konp-kbetr,
END OF ITAS2.

DATA :
*      it_tab1 TYPE TABLE OF itab1,
*       wa_tab1 TYPE itab1,
       it_tab2 TYPE TABLE OF itab2,
       wa_tab2 TYPE itab2,
       it_tab3 TYPE TABLE OF itab3,
       wa_tab3 TYPE itab3,
       it_tab4 TYPE TABLE OF itab3,
       wa_tab4 TYPE itab3,
       it_tab31 TYPE TABLE OF itab3,
       wa_tab31 TYPE itab3,
       it_tab32 TYPE TABLE OF itab2,
       wa_tab32 TYPE itab2,
       it_tab33 TYPE TABLE OF itab2,
       wa_tab33 TYPE itab2,
       it_tab34 TYPE TABLE OF itab2,
       wa_tab34 TYPE itab2,
       it_tab41 TYPE TABLE OF itab3,
       wa_tab41 TYPE itab3,
       it_tab42 TYPE TABLE OF itab3,
       wa_tab42 TYPE itab3,
       it_tab11 TYPE TABLE OF itab11,
       wa_tab11 TYPE itab11,
       it_tab12 TYPE TABLE OF itab12,
       wa_tab12 TYPE itab12,
       it_tab13 TYPE TABLE OF itab12,
       wa_tab13 TYPE itab12,
       it_tab14 TYPE TABLE OF itab12,
       wa_tab14 TYPE itab12,
       it_taS1 TYPE TABLE OF ITAS1,
       wa_taS1 TYPE ITAS1,
       it_taS2 TYPE TABLE OF ITAS2,
       wa_taS2 TYPE ITAS2.


DATA : it_mseg TYPE TABLE OF mseg,
       wa_mseg TYPE mseg,
       it_mkpf TYPE TABLE OF mkpf,
       wa_mkpf TYPE mkpf,
       it_afpo TYPE TABLE OF afpo,
       wa_afpo TYPE afpo,
       it_aufm TYPE TABLE OF aufm,
       wa_aufm TYPE aufm,
       IT_ZPRD_CCPC TYPE TABLE OF ZPRD_CCPC,
       WA_ZPRD_CCPC TYPE ZPRD_CCPC.

DATA : val_1 TYPE p DECIMALS 2,
       rm_rate TYPE p DECIMALS 2,
       pm_rate TYPE p DECIMALS 2,
       w_umren LIKE marm-umren,
       w_umrez LIKE marm-umrez,
       w_rate TYPE p DECIMALS 2,
       ed TYPE konp-kbetr,
       ABT TYPE konp-kbetr,
       edVAL TYPE konp-kbetr,
       edVAL1 TYPE konp-kbetr,
       CCPC TYPE konp-kbetr,
       PTS TYPE konp-kbetr,
       GST TYPE konp-kbetr.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECT-OPTIONS  : s_matnr FOR   afpo-matnr.
*SELECT-OPTIONS  : s_aufnr FOR afpo-aufnr.
PARAMETERS : p_werks LIKE afpo-dwerk OBLIGATORY.
SELECT-OPTIONS : batch FOR afpo-charg.
*SELECT-OPTIONS : s_lgort FOR afpo-lgort .
SELECT-OPTIONS : s_budat FOR aufk-erdat OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  g_repid = sy-repid.

*AT SELECTION-SCREEN.
*  AUTHORITY-CHECK OBJECT '/DSD/SL_WR'
*           ID 'WERKS' FIELD p_werks.
*  IF sy-subrc NE 0.
*    mesg = 'Check your entry'.
*    MESSAGE mesg TYPE 'E'.
*  ENDIF.

START-OF-SELECTION.




  SELECT * FROM mkpf INTO TABLE it_mkpf WHERE budat IN s_budat.
  IF sy-subrc EQ 0.
    SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_mkpf WHERE mblnr EQ it_mkpf-mblnr AND werks EQ p_werks AND matnr IN s_matnr
      AND charg IN batch  AND bwart IN ('101','102') AND lgort GE 'FG01' AND lgort LE 'FG04'.
    IF sy-subrc NE 0.
      EXIT.
    ENDIF.
  ENDIF.

  DATA : a TYPE i VALUE 1,
         b TYPE i VALUE 1.

  SORT it_mseg BY bwart matnr charg.
  LOOP AT it_mseg INTO wa_mseg.
*    WRITE : / wa_mseg-bwart,wa_mseg-mblnr,wa_mseg-mjahr,wa_mseg-lgort,wa_mseg-matnr,wa_mseg-charg,wa_mseg-menge,wa_mseg-dmbtr.
    wa_tab11-bwart = wa_mseg-bwart.
    wa_tab11-mblnr = wa_mseg-mblnr.
    wa_tab11-matnr = wa_mseg-matnr.
    wa_tab11-charg = wa_mseg-charg.
    wa_tab11-menge = wa_mseg-menge.
    COLLECT wa_tab11 INTO it_tab11.
    CLEAR wa_tab11.

*    wa_tab1-bwart = wa_mseg-bwart.
*    wa_tab1-matnr = wa_mseg-matnr.
*    wa_tab1-charg = wa_mseg-charg.
*    COLLECT wa_tab1 INTO it_tab1.
*    CLEAR wa_tab1.
  ENDLOOP.
******************BATCH COUNT ***************
  DATA : count TYPE i VALUE 1,
         count1 TYPE i VALUE 1,
         count2 TYPE i VALUE 1,
         w_diff TYPE p DECIMALS 3.

  SORT it_tab11 BY matnr charg.
  LOOP AT it_tab11 INTO wa_tab11.
*    WRITE : /1 wa_tab11-bwart,5 wa_tab11-mblnr,17 wa_tab11-matnr,37 wa_tab11-charg.
    wa_tab12-matnr = wa_tab11-matnr.
    wa_tab12-charg = wa_tab11-charg.

    IF wa_tab11-bwart EQ '101'.
      wa_tab12-menge = wa_tab11-menge.
    ELSEIF wa_tab11-bwart EQ '102'.
      wa_tab12-menge1 = wa_tab11-menge.
    ENDIF.

    wa_tab12-count = count.
    wa_tab12-count1 = count1.
    COLLECT wa_tab12 INTO it_tab12.
    CLEAR wa_tab12.

    ON CHANGE OF wa_tab11-matnr.
      count = 1.
      count1 = 1.
    ENDON.
    ON CHANGE OF wa_tab11-charg.
      count = 1.
      count1 = 1.
    ENDON.
    IF wa_tab11-bwart EQ '101'.
*      WRITE : 50 count.
      count = count + 1.
    ENDIF.
    IF wa_tab11-bwart EQ '102'.
*      WRITE : 60 count1.
      count1 = count1 + 1.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tab12 INTO wa_tab12.
*    FORMAT COLOR 1.
*    WRITE : / wa_tab12-matnr,wa_tab12-charg,wa_tab12-menge,wa_tab12-menge1,wa_tab12-count,wa_tab12-count1.
    count2 = wa_tab12-count - wa_tab12-count1.
    w_diff = wa_tab12-menge - wa_tab12-menge1.
*    FORMAT COLOR 3.
*    WRITE : w_diff.
*    FORMAT COLOR 1.
*    WRITE : wa_tab12-count,wa_tab12-count1.
*    FORMAT COLOR 3.
*    WRITE : count2.
    IF w_diff GT 0.
      IF count GT 0.
        wa_tab13-matnr = wa_tab12-matnr.
        wa_tab13-charg = wa_tab12-charg.
        COLLECT wa_tab13 INTO it_tab13.
        CLEAR wa_tab13.
      ENDIF.
    ENDIF.
  ENDLOOP.
  SORT it_tab13.
  DELETE ADJACENT DUPLICATES FROM it_tab13 COMPARING ALL FIELDS.
*  LOOP AT it_tab13 INTO wa_tab13.
*    WRITE : / wa_tab13-matnr,wa_tab13-charg.
*  ENDLOOP.
***********************************************

*  SORT it_mseg BY bwart matnr charg.
*  LOOP AT it_mseg INTO wa_mseg.
**  WRITE : / wa_mseg-bwart,wa_mseg-mblnr,wa_mseg-mjahr,WA_MSEG-LGORT,wa_mseg-matnr,wa_mseg-charg,WA_MSEG-MENGE,WA_MSEG-DMBTR.
*    wa_tab1-bwart = wa_mseg-bwart.
*    wa_tab1-matnr = wa_mseg-matnr.
*    wa_tab1-charg = wa_mseg-charg.
*    COLLECT wa_tab1 INTO it_tab1.
*    CLEAR wa_tab1.
*  ENDLOOP.

*  LOOP AT it_tab1 INTO wa_tab1.
*    WRITE : /'N',wa_tab1-bwart,wa_tab1-matnr,wa_tab1-charg.
*  ENDLOOP.

  PERFORM rm_rate.
  PERFORM pm_rate.
  PERFORM all_rate.

*&---------------------------------------------------------------------*
*&      Form  rm_rate
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM rm_rate.
**********************************rm rate************************
  SELECT * FROM afpo INTO TABLE it_afpo FOR ALL ENTRIES IN it_tab13 WHERE charg EQ it_tab13-charg
*    matnr EQ it_tab1-matnr
    AND pwerk EQ p_werks AND wemng GT 0.
  IF sy-subrc EQ 0.
    SELECT * FROM aufm INTO TABLE it_aufm FOR ALL ENTRIES IN it_afpo WHERE aufnr EQ it_afpo-aufnr.
  ENDIF.

  LOOP AT it_afpo INTO wa_afpo.
    wa_tab2-matnr = wa_afpo-matnr.
    wa_tab2-aufnr = wa_afpo-aufnr.
    wa_tab2-psmng = wa_afpo-psmng.
    wa_tab2-wemng = wa_afpo-wemng.
    wa_tab2-charg = wa_afpo-charg.
    IF ( wa_afpo-lgort EQ 'SF01' ) OR ( wa_afpo-lgort EQ 'SF02' ) OR ( wa_afpo-lgort EQ 'SF03' ) OR ( wa_afpo-lgort EQ 'SF04' ).
      LOOP AT it_aufm INTO wa_aufm WHERE aufnr EQ wa_afpo-aufnr.
        IF wa_aufm-shkzg EQ 'S'.
          wa_aufm-menge = wa_aufm-menge * ( - 1 ).
          wa_aufm-dmbtr = wa_aufm-dmbtr * ( - 1 ).
        ENDIF.
        wa_tab3-aufnr = wa_aufm-aufnr.
        wa_tab3-matnr = wa_aufm-matnr.
        wa_tab3-menge = wa_aufm-menge.
        wa_tab3-dmbtr = wa_aufm-dmbtr.
        SELECT SINGLE * FROM mara WHERE matnr EQ wa_aufm-matnr.
        IF sy-subrc EQ 0.
          wa_tab3-mtart = mara-mtart.
        ENDIF.
        COLLECT wa_tab3 INTO it_tab3.
        CLEAR wa_tab3.
      ENDLOOP.

    ENDIF.
    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.
  ENDLOOP.
***************************rm rate**********************
  LOOP AT it_tab3 INTO wa_tab3.
*    WRITE : / 'o',wa_tab3-matnr,wa_tab3-charg,wa_tab3-dmbtr,wa_tab3-aufnr,wa_tab3-mtart.
    IF wa_tab3-mtart EQ 'ZROH'.
      wa_tab31-aufnr = wa_tab3-aufnr.
      wa_tab31-dmbtr = wa_tab3-dmbtr.
      COLLECT wa_tab31 INTO it_tab31.
      CLEAR wa_tab31.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tab2 INTO wa_tab2.
*    WRITE : / 's', wa_tab2-matnr,wa_tab2-aufnr,wa_tab2-psmng,wa_tab2-wemng , wa_tab2-charg.
    READ TABLE it_tab31 INTO wa_tab31 WITH KEY aufnr = wa_tab2-aufnr.
    IF sy-subrc EQ 0.
      IF wa_tab2-charg NE '   '.
*      WRITE : wa_tab31-aufnr,wa_tab31-dmbtr.
        rm_rate = wa_tab31-dmbtr / wa_tab2-wemng.
*      WRITE : rm_rate.
        wa_tab32-rm_rate = rm_rate.
        wa_tab32-matnr = wa_tab2-matnr.
        wa_tab32-aufnr = wa_tab2-aufnr.
        wa_tab32-psmng = wa_tab2-psmng.
        wa_tab32-wemng = wa_tab2-wemng.
        wa_tab32-charg = wa_tab2-charg.
        COLLECT wa_tab32 INTO it_tab32.
        CLEAR wa_tab32.
      ENDIF.
    ENDIF.
  ENDLOOP.

*  LOOP AT it_tab32 INTO wa_tab32.
**    WRITE : / wa_tab32-aufnr,wa_tab32-matnr,wa_tab32-charg,wa_tab32-psmng,wa_tab32-wemng,wa_tab32-rm_rate.
*  ENDLOOP.
********************************
**********************pm packing***************************


**********************************************************

  LOOP AT it_tab13 INTO wa_tab13.
*    WRITE : /'n1',wa_tab1-bwart,wa_tab1-matnr,wa_tab1-charg.
    LOOP AT it_tab2 INTO wa_tab2 WHERE charg EQ wa_tab13-charg.
*      WRITE : wa_tab2-aufnr.
      READ TABLE it_tab32 INTO wa_tab32 WITH KEY aufnr = wa_tab2-aufnr.
      IF sy-subrc EQ 0.
*        WRITE : wa_tab32-rm_rate.
        wa_tab33-matnr = wa_tab13-matnr.
        wa_tab33-matnr1 = wa_tab2-matnr.
        wa_tab33-charg = wa_tab13-charg.
        wa_tab33-aufnr = wa_tab2-aufnr.
        wa_tab33-rm_rate = wa_tab32-rm_rate.
        SELECT SINGLE umren umrez  FROM marm INTO (w_umren, w_umrez) WHERE matnr = wa_tab13-matnr AND ( meinh = 'L  ' OR meinh = 'PC '
           OR meinh = 'KG ').
        IF  sy-subrc = 0.
          w_rate = ( wa_tab32-rm_rate * w_umren ) / w_umrez.
          wa_tab33-rm_rt = w_rate .
        ENDIF.
      ENDIF.
      COLLECT wa_tab33 INTO it_tab33.
      CLEAR wa_tab33.
    ENDLOOP.
  ENDLOOP.

*  LOOP AT it_tab33 INTO wa_tab33.
*    WRITE : / 'w',wa_tab33-matnr,wa_tab33-matnr1,wa_tab33-charg,wa_tab33-aufnr,wa_tab33-rm_rate,wa_tab33-rm_rt.
*  ENDLOOP.
ENDFORM.                    "rm_rate
**************************************pm rate***************************


FORM pm_rate.
  CLEAR : it_tab2,wa_tab2,it_tab3,wa_tab3,it_tab31,wa_tab31,it_tab32,wa_tab32.
**********************************Pm rate************************
  SELECT * FROM afpo INTO TABLE it_afpo FOR ALL ENTRIES IN it_tab13 WHERE charg EQ it_tab13-charg AND matnr EQ it_tab13-matnr
    AND pwerk EQ p_werks AND wemng GT 0.
  IF sy-subrc EQ 0.
    SELECT * FROM aufm INTO TABLE it_aufm FOR ALL ENTRIES IN it_afpo WHERE aufnr EQ it_afpo-aufnr.
  ENDIF.

  LOOP AT it_afpo INTO wa_afpo.
*    WRITE : / 'A',WA_AFPO-MATNR,WA_AFPO-AUFNR.
    wa_tab2-matnr = wa_afpo-matnr.
    wa_tab2-aufnr = wa_afpo-aufnr.
*    val_1 = wa_afpo-wemng.
    wa_tab2-psmng = wa_afpo-psmng.
    wa_tab2-wemng = wa_afpo-wemng.
    wa_tab2-charg = wa_afpo-charg.
*    IF ( wa_afpo-lgort EQ 'FG01' ) OR ( wa_afpo-lgort EQ 'FG02' ) OR ( wa_afpo-lgort EQ 'FG03' ) OR ( wa_afpo-lgort EQ 'FG04' ).
    LOOP AT it_aufm INTO wa_aufm WHERE aufnr EQ wa_afpo-aufnr.
      IF wa_aufm-shkzg EQ 'S'.
        wa_aufm-menge = wa_aufm-menge * ( - 1 ).
        wa_aufm-dmbtr = wa_aufm-dmbtr * ( - 1 ).
      ENDIF.
      wa_tab3-aufnr = wa_aufm-aufnr.
      wa_tab3-matnr = wa_aufm-matnr.
      wa_tab3-menge = wa_aufm-menge.
      wa_tab3-dmbtr = wa_aufm-dmbtr.
      SELECT SINGLE * FROM mara WHERE matnr EQ wa_aufm-matnr.
      IF sy-subrc EQ 0.
        wa_tab3-mtart = mara-mtart.
      ENDIF.
      COLLECT wa_tab3 INTO it_tab3.
      CLEAR wa_tab3.
    ENDLOOP.

*    ENDIF.
    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.
  ENDLOOP.
***************************pm rate**********************
  LOOP AT it_tab3 INTO wa_tab3.
*    WRITE : / 'o',wa_tab3-matnr,wa_tab3-charg,wa_tab3-dmbtr,wa_tab3-aufnr,wa_tab3-mtart.
    IF wa_tab3-mtart EQ 'ZVRP'.
      wa_tab31-aufnr = wa_tab3-aufnr.
      wa_tab31-dmbtr = wa_tab3-dmbtr.
      COLLECT wa_tab31 INTO it_tab31.
      CLEAR wa_tab31.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tab2 INTO wa_tab2.
    CLEAR PM_RATE.
*    WRITE : / 's', wa_tab2-matnr,wa_tab2-aufnr,wa_tab2-psmng,wa_tab2-wemng , wa_tab2-charg.
    READ TABLE it_tab31 INTO wa_tab31 WITH KEY aufnr = wa_tab2-aufnr.
    IF sy-subrc EQ 0.
      IF wa_tab2-charg NE '   '.
*      WRITE : wa_tab31-aufnr,wa_tab31-dmbtr.
        pm_rate = wa_tab31-dmbtr / wa_tab2-wemng.
*      WRITE : rm_rate.
        wa_tab32-pm_rate = pm_rate.
        wa_tab32-matnr = wa_tab2-matnr.
        wa_tab32-aufnr = wa_tab2-aufnr.
        wa_tab32-psmng = wa_tab2-psmng.
        wa_tab32-wemng = wa_tab2-wemng.
        wa_tab32-charg = wa_tab2-charg.
        COLLECT wa_tab32 INTO it_tab32.
        CLEAR wa_tab32.
      ENDIF.
    ENDIF.
  ENDLOOP.

*  LOOP AT it_tab32 INTO wa_tab32.
*    WRITE : / 'N2',wa_tab32-aufnr,wa_tab32-matnr,wa_tab32-charg,wa_tab32-psmng,wa_tab32-wemng,wa_tab32-rm_rate.
*  ENDLOOP.
********************************
**********************pm packing***************************


**********************************************************

  LOOP AT it_tab13 INTO wa_tab13.
*    WRITE : /'n1',wa_tab1-bwart,wa_tab1-matnr,wa_tab1-charg.
    LOOP AT it_tab2 INTO wa_tab2 WHERE charg EQ wa_tab13-charg AND MATNR EQ WA_TAB13-MATNR.
*      WRITE : wa_tab2-aufnr.
      READ TABLE it_tab32 INTO wa_tab32 WITH KEY aufnr = wa_tab2-aufnr .
*      MATNR1 = WA_TAB13-MATNR.
      IF sy-subrc EQ 0.
*        WRITE : wa_tab32-rm_rate.
*        WRITE :  'W111',WA_TAB1-MATNR,WA_TAB2-MATNR,WA_TAB1-CHARG.
        wa_tab34-matnr = wa_tab13-matnr.
        wa_tab34-matnr1 = wa_tab2-matnr.
        wa_tab34-charg = wa_tab13-charg.
        wa_tab34-aufnr = wa_tab2-aufnr.
        wa_tab34-pm_rate = wa_tab32-pm_rate.
        COLLECT wa_tab34 INTO it_tab34.
        CLEAR wa_tab34.
      ENDIF.
    ENDLOOP.
  ENDLOOP.

*  LOOP AT it_tab34 INTO wa_tab34.
*    WRITE : / 'w11',wa_tab34-matnr1,wa_tab34-charg,wa_tab34-aufnr,wa_tab34-pm_rate.
*  ENDLOOP.
ENDFORM.                    "pm_rate

*&---------------------------------------------------------------------*
*&      Form  ALL_RATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM all_rate.
  LOOP AT it_tab13 INTO wa_tab13.
*    WRITE : /'N',3 wa_tab13-matnr,30 wa_tab13-charg.
    wa_tab14-matnr = wa_tab13-matnr.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_tab13-matnr.
    IF sy-subrc EQ 0.
      wa_tab14-maktx = makt-maktx.
    ENDIF.
    wa_tab14-charg = wa_tab13-charg.
    READ TABLE it_tab33 INTO wa_tab33 WITH KEY matnr = wa_tab13-matnr charg = wa_tab13-charg.
    IF sy-subrc EQ 0.
*      WRITE : 45 wa_tab33-rm_rt.
      wa_tab14-rm_rt = wa_tab33-rm_rt.
      wa_tab14-aufnr_rm = wa_tab33-aufnr.
    ENDIF.
    READ TABLE it_tab34 INTO wa_tab34 WITH KEY matnr = wa_tab13-matnr charg = wa_tab13-charg.
    IF sy-subrc EQ 0.
*      WRITE : 65 wa_tab34-pm_rate.
      wa_tab14-pm_rate = wa_tab34-pm_rate.
      wa_tab14-aufnr_pm = wa_tab34-aufnr.
    ENDIF.
    COLLECT wa_tab14 INTO it_tab14.
    CLEAR wa_tab14.
  ENDLOOP.

  select single * from konp where kschl eq 'Z003' and loevm_ko ne 'X' .
  if sy-subrc eq 0.
    ABT = konp-kbetr / 10.
*   WRITE : ABT.
  endif.

  SORT it_tab14 BY charg matnr.
  LOOP AT it_tab14 INTO wa_tab14.
    CLEAR : ED.
    WA_TAS1-MATNR = wa_tab14-matnr.
    WA_TAS1-CHARG = wa_tab14-charg.
    WA_TAS1-AUFNR_RM = wa_tab14-aufnr_rm.
    WA_TAS1-RM_RT = wa_tab14-rm_rt.
    WA_TAS1-AUFNR_PM = wa_tab14-aufnr_pm.
    WA_TAS1-PM_RATE = wa_tab14-pm_rate.
    select single * from a602 where matnr eq wa_tab14-matnr and charg eq wa_tab14-charg and  kschl = 'Z001'
      and datab le sy-datum and datbi ge sy-datum.
    if sy-subrc eq 0.
      select single * from konp where knumh = a602-knumh and kschl eq 'Z001' AND loevm_ko ne 'X'..
      if sy-subrc eq 0.
        WA_TAS1-MRP = konp-kbetr.
      ENDIF.
    ENDIF.
****************ed*********************
    select single * from a501 where  kappl eq 'V' and kschl = 'ZEX2' and vkorg eq '1000' and vtweg eq '10'
      and matnr eq wa_tab14-matnr and charg eq wa_tab14-charg and datab le sy-datum and datbi ge sy-datum.
    if sy-subrc eq 0.
      select single * from konp where knumh = a501-knumh and kappl eq 'V' and kschl eq 'ZEX2' AND loevm_ko ne 'X'.
      if sy-subrc eq 0.
        ed = konp-kbetr / 10.
      endif.
    else.
******************************
      select single * from a611 where matnr = wa_tab14-matnr and charg = wa_tab14-charg and kschl = 'ZEX2' and  datbi ge sy-datum.
      if sy-subrc eq 0.
        select single * from konp where knumh = a611-knumh and kschl = 'ZEX2' AND loevm_ko ne 'X'..
        if sy-subrc eq 0.
          ed = konp-kbetr / 10.
        endif.
      else.
******************************
        select single * from a004 where kappl eq 'V' and kschl = 'ZEX2' and vkorg eq '1000' and vtweg eq '10'
          and matnr eq wa_tab14-matnr and datab le sy-datum and datbi ge sy-datum.
        if sy-subrc eq 0.
          select single * from konp where knumh = a004-knumh and kappl eq 'V' and kschl eq 'ZEX2' AND loevm_ko ne 'X'..
          if sy-subrc eq 0.
            ed = konp-kbetr / 10.
          endif.
        else.
          select single * from a611 where kappl eq 'V' and kschl = 'JMOD' and vkorg eq '1000' and
            matnr eq wa_tab14-matnr AND CHARG EQ WA_TAB14-CHARG and datab le sy-datum and datbi ge sy-datum.
        if sy-subrc eq 0.
          select single * from konp where knumh = A611-knumh and kappl eq 'V' and kschl eq 'JMOD' AND loevm_ko ne 'X'..
          if sy-subrc eq 0.
            ed = konp-kbetr / 10.
          endif.
        ELSE.
           select single * from a609 where kappl eq 'V' and kschl = 'JMOD' and vkorg eq '1000' and
            matnr eq wa_tab14-matnr and datab le sy-datum and datbi ge sy-datum.
        if sy-subrc eq 0.
          select single * from konp where knumh = A609-knumh and kappl eq 'V' and kschl eq 'JMOD' AND loevm_ko ne 'X'..
          if sy-subrc eq 0.
            ed = konp-kbetr / 10.
          endif.
        ENDIF.
        ENDIF.
        endif.
      endif.
    endif.

    WA_TAS1-ED = ed.
    COLLECT WA_TAS1 INTO IT_TAS1.
    CLEAR WA_TAS1.
  ENDLOOP.
SELECT * FROM ZPRD_CCPC INTO TABLE IT_ZPRD_CCPC FOR ALL ENTRIES IN IT_TAS1 WHERE MATNR EQ IT_TAS1-MATNR.
  SORT IT_ZPRD_CCPC DESCENDING BY FROM_DT.

  LOOP AT IT_TAS1 INTO WA_TAS1.
    CLEAR : EDVAL1,EDVAL,CCPC,PTS,GST.
    WA_TAS2-MATNR = WA_TAS1-MATNR.
    WA_TAS2-CHARG = WA_TAS1-CHARG.
    WA_TAS2-RM_RT = WA_TAS1-RM_RT.
    WA_TAS2-AUFNR_RM = WA_TAS1-AUFNR_RM.
    WA_TAS2-PM_RATE = WA_TAS1-PM_RATE.
    WA_TAS2-AUFNR_PM = WA_TAS1-AUFNR_PM.
    WA_TAS2-MRP = WA_TAS1-MRP.
    PTS = ( ( 6429 / 100 ) * ( WA_TAS1-MRP / 100 ) ).
    GST = PTS * ( 12 / 100 ).
    WA_TAS2-PTS = PTS.
    WA_TAS2-GST = GST.
    WA_TAS2-ED = WA_TAS1-ED.
    EDVAL = WA_TAS1-MRP * ( ABT / 100 ).
    WA_TAS2-EDVAL = EDVAL * ( WA_TAS1-ED / 100 ).
    READ TABLE IT_ZPRD_CCPC INTO WA_ZPRD_CCPC WITH KEY MATNR = WA_TAS1-MATNR.
    IF SY-SUBRC EQ 0.
      CCPC = WA_ZPRD_CCPC-CC + WA_ZPRD_CCPC-PC.
      WA_TAS2-CCPC = CCPC.
    ENDIF.
    READ TABLE IT_TAB14 INTO WA_TAB14 WITH KEY MATNR = WA_TAS1-MATNR.
    IF SY-SUBRC EQ 0.
      WA_TAS2-MAKTX = WA_TAB14-MAKTX.
    ENDIF.
    COLLECT WA_TAS2 INTO IT_TAS2.
    CLEAR WA_TAS2.
    ENDLOOP.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_s = 'MATERIAL'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_s = 'DESCRIPTION'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_s = 'BATCH'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'AUFNR_RM'.
  wa_fieldcat-seltext_s = 'RM ORDER'.
  APPEND wa_fieldcat TO fieldcat.



  wa_fieldcat-fieldname = 'AUFNR_PM'.
  wa_fieldcat-seltext_s = 'PM ORDER'.
  APPEND wa_fieldcat TO fieldcat.

   wa_fieldcat-fieldname = 'RM_RT'.
  wa_fieldcat-seltext_s = 'RM RATE'.
  APPEND wa_fieldcat TO fieldcat.

   wa_fieldcat-fieldname = 'PM_RATE'.
  wa_fieldcat-seltext_s = 'PM RATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MRP'.
  wa_fieldcat-seltext_s = 'MRP'.
  APPEND wa_fieldcat TO fieldcat.

   wa_fieldcat-fieldname = 'GST'.
  wa_fieldcat-seltext_s = 'GST VALUE'.
  APPEND wa_fieldcat TO fieldcat.

   wa_fieldcat-fieldname = 'PTS'.
  wa_fieldcat-seltext_s = 'GST PTS'.
  APPEND wa_fieldcat TO fieldcat.


   wa_fieldcat-fieldname = 'CCPC'.
  wa_fieldcat-seltext_s = 'CCPC'.
  APPEND wa_fieldcat TO fieldcat.

   wa_fieldcat-fieldname = 'EDVAL'.
  wa_fieldcat-seltext_s = 'ED VALUE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ED'.
  wa_fieldcat-seltext_s = 'ED RATE'.
  APPEND wa_fieldcat TO fieldcat.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'ACTUAL COST SHEET SUMMARY'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
     i_callback_program                =  g_repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
   i_callback_user_command           = 'USER_COMM'
   i_callback_top_of_page            = 'TOP'
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   is_layout                         = layout
     it_fieldcat                       = fieldcat
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
   i_save                            = 'A'
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab                          = IT_TAS2
   EXCEPTIONS
     program_error                     = 1
     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.                    "ALL_RATE


*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top.

  DATA: comment TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'ACTUAL COST SHEET SUMMARY'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND wa_comment TO comment.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary       = comment
*     I_LOGO                   = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID       =
*     I_ALV_FORM               =
            .

  CLEAR comment.

ENDFORM.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
FORM user_comm USING ucomm LIKE sy-ucomm
                     selfield TYPE slis_selfield.



  CASE selfield-fieldname.
    WHEN 'AUFNR_RM'.
      SET PARAMETER ID 'ANR' FIELD selfield-value.
      CALL TRANSACTION 'CO03' AND SKIP FIRST SCREEN.
    WHEN 'AUFNR_PM'.
      SET PARAMETER ID 'ANR' FIELD selfield-value.
      CALL TRANSACTION 'CO03' AND SKIP FIRST SCREEN.
    WHEN 'MATNR'.
      SET PARAMETER ID 'MAT' FIELD selfield-value.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
