*&---------------------------------------------------------------------*
*& Report  ZMATERIAL_YIELD1
*& developed by Jyotsna
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zmaterial_yield3.
TABLES : mcha,
         afpo,
         mseg,
         mast,
         stpo,
         makt,
         mara,
         mbew,
         mkpf,
         aufk,
         qals,
         qave,
         stko,
         jest,
         zmigo,
         lfa1,
         EKPO.

TYPE-POOLS:  slis.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.

DATA : it_mcha  TYPE TABLE OF mcha,
       wa_mcha  TYPE mcha,
       it_mseg  TYPE TABLE OF mseg,
       wa_mseg  TYPE mseg,
       it_afpo  TYPE TABLE OF afpo,
       wa_afpo  TYPE afpo,
       it_mast  TYPE TABLE OF mast,
       wa_mast  TYPE mast,
       it_stas  TYPE TABLE OF stas,
       wa_stas  TYPE stas,
       it_stpo  TYPE TABLE OF stpo,
       wa_stpo  TYPE stpo,
       it_aufm  TYPE TABLE OF aufm,
       wa_aufm  TYPE aufm,
       it_afko  TYPE TABLE OF afko,
       wa_afko  TYPE afko,
       it_qals  TYPE TABLE OF qals,
       wa_qals  TYPE qals,
       it_qals1 TYPE TABLE OF qals,
       wa_qals1 TYPE qals,
       it_mcha1 TYPE TABLE OF mcha,
       wa_mcha1 TYPE mcha,
       it_mseg1 TYPE TABLE OF mseg,
       wa_mseg1 TYPE mseg,

       it_mcha2 TYPE TABLE OF mcha,
       wa_mcha2 TYPE mcha,
       it_mseg2 TYPE TABLE OF mseg,
       wa_mseg2 TYPE mseg,

       it_qave  TYPE TABLE OF qave,
       wa_qave  TYPE qave.

TYPES : BEGIN OF ita1,
          stlnr TYPE stpo-stlnr,
          idnrk TYPE stpo-idnrk,
          menge TYPE stpo-menge,
          meins TYPE stpo-meins,
          posnr TYPE stpo-posnr,
          stlal TYPE mast-stlal,
        END OF ita1.

TYPES : BEGIN OF itab1,
          werks  TYPE mcha-werks,
          matnr  TYPE mcha-matnr,
          charg  TYPE mcha-charg,
          hsdat  TYPE mcha-hsdat,
          vfdat  TYPE mcha-vfdat,
          matnr1 TYPE afpo-matnr,
          charg1 TYPE mcha-charg,
          aufnr  TYPE afpo-aufnr,
          menge  TYPE mseg-menge,
          meins  TYPE mseg-meins,
          budat  TYPE mkpf-budat,
          mblnr  TYPE mseg-mblnr,
          stlst  TYPE afko-stlst,
          stlnr  TYPE afko-stlnr,
          stlal  TYPE afko-stlal,
          stlan  TYPE afko-stlan,
        END OF itab1.

TYPES : BEGIN OF itab2,
          werks  TYPE mcha-werks,
          matnr  TYPE mcha-matnr,
          charg  TYPE mcha-charg,
          charg1 TYPE mcha-charg,
          hsdat  TYPE mcha-hsdat,
          vfdat  TYPE mcha-vfdat,
          matnr1 TYPE afpo-matnr,
          aufnr  TYPE afpo-aufnr,
          menge  TYPE mseg-menge,
          meins  TYPE mseg-meins,
          budat  TYPE mkpf-budat,
          mblnr  TYPE mseg-mblnr,
          stlst  TYPE afko-stlst,
          stlnr  TYPE afko-stlnr,
          stlal  TYPE afko-stlal,
          stlan  TYPE afko-stlan,
        END OF itab2.

TYPES : BEGIN OF itab3,
          werks  TYPE mcha-werks,
          matnr  TYPE mcha-matnr,
          charg  TYPE mcha-charg,
          charg1 TYPE mcha-charg,
          hsdat  TYPE mcha-hsdat,
          vfdat  TYPE mcha-vfdat,
          matnr1 TYPE afpo-matnr,
          aufnr  TYPE afpo-aufnr,
          menge  TYPE mseg-menge,
          meins  TYPE mseg-meins,
          menge1 TYPE mseg-menge,
          meins1 TYPE mseg-meins,
          maktx  TYPE makt-maktx,
          budat  TYPE mkpf-budat,
          mblnr  TYPE mseg-mblnr,
          posnr  TYPE stpo-posnr,
          stlnr  TYPE mast-stlnr,
          stlal  TYPE mast-stlal,
        END OF itab3.

TYPES : BEGIN OF itab4,
          werks    TYPE mcha-werks,
          matnr    TYPE mcha-matnr,
          charg    TYPE mcha-charg,
          charg1   TYPE mcha-charg,
          hsdat    TYPE mcha-hsdat,
          vfdat    TYPE mcha-vfdat,
          matnr1   TYPE afpo-matnr,
          maktx1   TYPE makt-maktx,
          aufnr    TYPE afpo-aufnr,
          menge    TYPE mseg-menge,
          meins    TYPE mseg-meins,
          menge1   TYPE mseg-menge,
          meins1   TYPE mseg-meins,
          maktx    TYPE makt-maktx,
          b1       TYPE mseg-menge,
          b2       TYPE mseg-menge,
          val      TYPE p DECIMALS 3,
          qt1      TYPE p DECIMALS 2,
          dnrel(3) TYPE c,
          verpr    TYPE mbew-verpr,
          stprs    TYPE mbew-stprs,
          peinh    TYPE mbew-peinh,
          salk3    TYPE mbew-salk3,
          budat    TYPE mkpf-budat,
          mblnr    TYPE mseg-mblnr,
          prueflos TYPE qave-prueflos,
          vdatum   TYPE qave-vdatum,
          posnr    TYPE stpo-posnr,
          stlnr    TYPE mast-stlnr,
          stlal    TYPE mast-stlal,
          mfgrname TYPE lfa1-name1,
        END OF itab4.

TYPES : BEGIN OF itab7,
          werks  TYPE mcha-werks,
          matnr  TYPE mcha-matnr,
          charg  TYPE mcha-charg,
          charg1 TYPE mcha-charg,
          matnr1 TYPE afpo-matnr,
          maktx1 TYPE makt-maktx,
          aufnr  TYPE afpo-aufnr,
          menge  TYPE mseg-menge,
          meins  TYPE mseg-meins,
*          menge1 type mseg-menge,
*          meins1 type mseg-meins,
          maktx  TYPE makt-maktx,

*          posnr  type stpo-posnr,
          stlnr  TYPE mast-stlnr,
          stlal  TYPE mast-stlal,
        END OF itab7.

TYPES : BEGIN OF itab8,
          werks  TYPE mcha-werks,
          matnr  TYPE mcha-matnr,
          charg  TYPE mcha-charg,
          charg1 TYPE mcha-charg,
          matnr1 TYPE afpo-matnr,
          maktx1 TYPE makt-maktx,
          aufnr  TYPE afpo-aufnr,
          menge  TYPE mseg-menge,
          meins  TYPE mseg-meins,
          menge1 TYPE mseg-menge,
          meins1 TYPE mseg-meins,
          maktx  TYPE makt-maktx,

          posnr  TYPE stpo-posnr,
          stlnr  TYPE mast-stlnr,
          stlal  TYPE mast-stlal,
          wemng  TYPE  afpo-wemng,
          psmng  TYPE afpo-psmng,
          bmeng  TYPE stko-bmeng,
          relqty TYPE mseg-menge,
          var    TYPE mseg-menge,
        END OF itab8.

TYPES : BEGIN OF ord1,
          aufnr TYPE afpo-aufnr,
          matnr TYPE afpo-matnr,
          charg TYPE afpo-charg,
          werks TYPE afpo-pwerk,
          stlst TYPE afko-stlst,
          stlnr TYPE afko-stlnr,
          stlal TYPE afko-stlal,
          stlan TYPE afko-stlan,
        END OF ord1.

TYPES : BEGIN OF taq1,
          matnr    TYPE qals-matnr,
          charg    TYPE qals-charg,
          werks    TYPE qals-werk,
          prueflos TYPE qals-prueflos,
          vdatum   TYPE qave-vdatum,
        END OF taq1.

TYPES : BEGIN OF rm1,
          matnr TYPE qals-matnr,
          charg TYPE qals-charg,
        END OF rm1.

TYPES : BEGIN OF rm2,
          matnr    TYPE qals-matnr,
          charg    TYPE qals-charg,
          mfgrname TYPE lfa1-name1,
        END OF rm2.

DATA : it_tab1 TYPE TABLE OF itab1,
       wa_tab1 TYPE itab1,
       it_tab2 TYPE TABLE OF itab2,
       wa_tab2 TYPE itab2,
       it_tab3 TYPE TABLE OF itab3,
       wa_tab3 TYPE itab3,
       it_tab4 TYPE TABLE OF itab4,
       wa_tab4 TYPE itab4,
       it_tab5 TYPE TABLE OF itab4,
       wa_tab5 TYPE itab4,
       it_tab6 TYPE TABLE OF itab4,
       it_tab7 TYPE TABLE OF itab7,
       wa_tab7 TYPE itab7,
       it_tab8 TYPE TABLE OF itab8,
       wa_tab8 TYPE itab8,
       wa_tab6 TYPE itab4,
       it_ta1  TYPE TABLE OF ita1,
       wa_ta1  TYPE ita1,
       it_ord1 TYPE TABLE OF ord1,
       wa_ord1 TYPE ord1,
       it_taq1 TYPE TABLE OF taq1,
       wa_taq1 TYPE taq1,
       it_rm1  TYPE TABLE OF rm1,
       wa_rm1  TYPE rm1,

       it_rm2  TYPE TABLE OF rm2,
       wa_rm2  TYPE rm2,
       it_rm3  TYPE TABLE OF rm2,
       wa_rm3  TYPE rm2,
       it_pm1  TYPE TABLE OF rm1,
       wa_pm1  TYPE rm1,
       it_pm3  TYPE TABLE OF rm2,
       wa_pm3  TYPE rm2.
DATA: relqty TYPE mseg-menge,
      var    TYPE mseg-menge.
DATA : val     TYPE p DECIMALS 3,
       qt1     TYPE p DECIMALS 2,
       year(4) TYPE c,
       y1(4)   TYPE c,
       y2(4)   TYPE c.
DATA: mtart TYPE  mara-mtart.

*******************************
SELECTION-SCREEN BEGIN OF BLOCK merkmale2 WITH FRAME TITLE TEXT-001.
  PARAMETERS : p1 RADIOBUTTON GROUP r2,
               p2 RADIOBUTTON GROUP r2.
SELECTION-SCREEN END OF BLOCK merkmale2.

SELECTION-SCREEN BEGIN OF BLOCK merkmale WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : plant FOR mcha-werks OBLIGATORY.
  SELECT-OPTIONS : batch FOR mcha-charg,
                   matnr FOR mcha-matnr,
                   ersda FOR mcha-ersda OBLIGATORY.
*parameters : year like mseg-mjahr.
SELECTION-SCREEN END OF BLOCK merkmale.

SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : r1 RADIOBUTTON GROUP r1,
               r2 RADIOBUTTON GROUP r1,
               r3 RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK merkmale1.

INITIALIZATION.
  g_repid = sy-repid.

*  AT SELECTION-SCREEN.
*  AUTHORITY-CHECK OBJECT '/DSD/SL_WR'
*           ID 'WERKS' FIELD from_plt.
*
*  If sy-subrc ne 0.
*    MeSG = 'Check your entry'.
*    MESSAGE MESG TYPE 'E'.
*  endif.
AT SELECTION-SCREEN .
  y1 = ersda-low+0(4).
  y2 = ersda-high+0(4).

  IF y1 NE y2.
    MESSAGE 'ENTER DATES IN SAME YEAR' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  year = ersda-low+0(4).

*  select * from mcha into table it_mcha where werks in plant and charg in batch and ersda in ersda.
*  if sy-subrc eq 0.
*    select * from afpo into table it_afpo for all entries in it_mcha where charg eq it_mcha-charg and dgltp lt it_mcha-vfdat.
  SELECT * FROM afpo INTO TABLE it_afpo WHERE matnr IN matnr AND charg IN batch AND pwerk IN plant.
  IF sy-subrc EQ 0.
    SELECT * FROM afko INTO TABLE it_afko FOR ALL ENTRIES IN it_afpo WHERE aufnr EQ it_afpo-aufnr AND gstrp IN ersda.
*    select * from aufm into table it_aufm for all entries in it_afpo where aufnr eq it_afpo-aufnr.
*    if sy-subrc ne 0.
*      exit.
*    endif.
  ENDIF.
*  endif.

  IF it_afpo IS INITIAL.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.

  LOOP AT it_afpo INTO wa_afpo.
    READ TABLE it_afko INTO wa_afko WITH KEY aufnr = wa_afpo-aufnr.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM aufk WHERE aufnr EQ wa_afpo-aufnr AND loekz EQ 'X'.
      IF sy-subrc EQ 0.
      ELSE.
        wa_ord1-aufnr = wa_afpo-aufnr.
        wa_ord1-matnr = wa_afpo-matnr.
        wa_ord1-charg = wa_afpo-charg.
        wa_ord1-werks = wa_afpo-pwerk.
        wa_ord1-stlst = wa_afko-stlst.
        wa_ord1-stlnr = wa_afko-stlnr.
        wa_ord1-stlal = wa_afko-stlal.
        wa_ord1-stlan = wa_afko-stlan.

        COLLECT wa_ord1 INTO it_ord1.
        CLEAR wa_ord1.
      ENDIF.
    ENDIF.
*    write : /'check', wa_afpo-aufnr,wa_afpo-matnr,wa_afpo-pwerk,wa_afpo-charg.
*  endif.
  ENDLOOP.

  IF it_ord1 IS NOT INITIAL.
    SELECT * FROM aufm INTO TABLE it_aufm FOR ALL ENTRIES IN it_ord1 WHERE aufnr EQ it_ord1-aufnr.
  ENDIF.

  IF it_aufm IS NOT INITIAL.
    SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_aufm WHERE mblnr EQ it_aufm-mblnr AND mjahr EQ year AND aufnr EQ it_aufm-aufnr AND
    bwart IN ('261','262') .
  ENDIF.
*  AND werks eq plant.
*      if sy-subrc ne 0.
*        exit.
*      ENDIF.
*uline.
  LOOP AT it_mseg INTO wa_mseg.
    READ TABLE it_ord1 INTO wa_ord1 WITH KEY aufnr = wa_mseg-aufnr.
    IF sy-subrc EQ 0.
      IF wa_mseg-bwart EQ '262'.
        wa_mseg-menge = wa_mseg-menge * ( - 1 ).
      ENDIF.
*  write : / wa_mseg-mblnr,wa_mseg-aufnr,wa_mseg-matnr,wa_mseg-charg,wa_mseg-menge,wa_mseg-bwart,wa_mseg-meins.
      wa_tab1-werks = wa_mseg-werks.
      wa_tab1-aufnr = wa_mseg-aufnr.

      wa_tab1-matnr = wa_mseg-matnr.
      wa_tab1-charg = wa_mseg-charg.
      wa_tab1-menge = wa_mseg-menge.
      wa_tab1-meins = wa_mseg-meins.
      wa_tab1-mblnr = wa_mseg-mblnr.
      wa_tab1-stlst = wa_ord1-stlst.
      wa_tab1-stlnr = wa_ord1-stlnr.
      wa_tab1-stlal = wa_ord1-stlal.
      wa_tab1-stlan = wa_ord1-stlan.




      SELECT SINGLE * FROM mkpf WHERE mblnr EQ wa_mseg-mblnr AND mjahr EQ wa_mseg-mjahr.
      IF sy-subrc EQ 0.
        wa_tab1-budat = mkpf-budat.
      ENDIF.
      READ TABLE it_afpo  INTO wa_afpo WITH KEY aufnr = wa_mseg-aufnr.
      IF sy-subrc EQ 0.
        wa_tab1-matnr1 = wa_afpo-matnr.
        wa_tab1-charg1 = wa_afpo-charg.
      ENDIF.
      COLLECT wa_tab1 INTO it_tab1.
      CLEAR wa_tab1.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tab1 INTO wa_tab1.
*  write : / wa_tab1-werks,wa_tab1-aufnr,wa_tab1-matnr,wa_tab1-charg,wa_tab1-menge,wa_tab1-meins.
    READ TABLE it_afko INTO wa_afko WITH KEY aufnr = wa_tab1-aufnr.
    IF sy-subrc EQ 0.
      READ TABLE it_afpo  INTO wa_afpo WITH KEY aufnr = wa_tab1-aufnr.
      IF sy-subrc EQ 0.
*    write : wa_afpo-matnr.
        wa_tab2-werks = wa_tab1-werks.
        wa_tab2-aufnr = wa_tab1-aufnr.
        wa_tab2-matnr = wa_tab1-matnr.
        wa_tab2-charg = wa_tab1-charg.
        wa_tab2-menge = wa_tab1-menge.
        wa_tab2-meins = wa_tab1-meins.
        wa_tab2-budat = wa_tab1-budat.
        wa_tab2-mblnr = wa_tab1-mblnr.
        wa_tab2-matnr1 = wa_afpo-matnr.
        wa_tab2-charg1 = wa_afpo-charg.

        wa_tab2-stlst = wa_tab1-stlst.
        wa_tab2-stlnr = wa_tab1-stlnr.
        wa_tab2-stlal = wa_tab1-stlal.
        wa_tab2-stlan = wa_tab1-stlan.

        COLLECT wa_tab2 INTO it_tab2.
        CLEAR wa_tab2.
      ENDIF.
    ENDIF.
  ENDLOOP.


  SELECT * FROM mast INTO TABLE it_mast FOR ALL ENTRIES IN it_ord1 WHERE  matnr EQ it_ord1-matnr AND werks EQ it_ord1-werks
     AND stlan EQ 1 AND stlnr EQ it_ord1-stlnr AND stlal EQ it_ord1-stlal AND stlan EQ it_ord1-stlan.

  IF sy-subrc EQ 0.
    SELECT * FROM stas INTO TABLE it_stas FOR ALL ENTRIES IN it_mast WHERE stlnr EQ it_mast-stlnr AND stlal EQ it_mast-stlal.
    IF sy-subrc EQ 0.
      SELECT * FROM stpo INTO TABLE it_stpo FOR ALL ENTRIES IN it_stas WHERE stlnr EQ it_stas-stlnr AND stlkn EQ it_stas-stlkn.
    ENDIF.
*    select * from stpo into table it_stpo for all entries in it_mast where stlnr eq it_mast-stlnr.
*    if sy-subrc ne 0.
*      exit.
*    endif.
  ENDIF.
*  SELECT * FROM MAST INTO TABLE IT_MAST FOR ALL ENTRIES IN IT_ORD1 WHERE MATNR EQ IT_ORD1-MATNR AND WERKS EQ IT_ORD1-WERKS.
*  IF SY-SUBRC EQ 0.
*    SELECT * FROM STPO INTO TABLE IT_STPO FOR ALL ENTRIES IN IT_MAST WHERE STLNR EQ IT_MAST-STLNR.
*    IF SY-SUBRC NE 0.
*      EXIT.
*    ENDIF.
*  ENDIF.

*  loop at it_stpo into wa_stpo.
*    read table it_stas into wa_stas with key stlnr = wa_stpo-stlnr stlkn = wa_stpo-stlkn.
*    if sy-subrc eq 0.
*      read table it_mast into wa_mast with key stlnr = wa_stpo-stlnr stlal = wa_stas-stlal.
*      if sy-subrc eq 0.
**    WRITE : /'bom', wa_stpo-stlnr,wa_stpo-idnrk,wa_stpo-menge.
*        wa_ta1-stlnr = wa_stpo-stlnr.
*        wa_ta1-stlal = wa_mast-stlal.
*        wa_ta1-idnrk = wa_stpo-idnrk.
*        wa_ta1-menge = wa_stpo-menge.
*        wa_ta1-meins = wa_stpo-meins.
**        wa_ta1-posnr = wa_stpo-posnr.
*        collect wa_ta1 into it_ta1.
*        clear wa_ta1.
*      endif.
*    endif.
*  endloop.

  LOOP AT it_stpo INTO wa_stpo.
    LOOP AT it_stas INTO wa_stas WHERE stlnr = wa_stpo-stlnr AND stlkn = wa_stpo-stlkn.
*    if sy-subrc eq 0.
      LOOP AT it_mast INTO wa_mast WHERE stlnr = wa_stpo-stlnr  AND stlal = wa_stas-stlal.
*      if sy-subrc eq 0.
*    WRITE : /'bom', wa_stpo-stlnr,wa_stpo-idnrk,wa_stpo-menge.
        wa_ta1-stlnr = wa_stpo-stlnr.
        wa_ta1-stlal = wa_mast-stlal.
        wa_ta1-idnrk = wa_stpo-idnrk.
        wa_ta1-menge = wa_stpo-menge.
        wa_ta1-meins = wa_stpo-meins.
*        wa_ta1-posnr = wa_stpo-posnr.
        COLLECT wa_ta1 INTO it_ta1.
        CLEAR wa_ta1.
      ENDLOOP.
    ENDLOOP.
  ENDLOOP.


*LOOP at it_ta1 INTO wa_ta1.
*WRITE : /'bom1', wa_ta1-stlnr,wa_ta1-idnrk,wa_ta1-menge,wa_ta1-meins.
*ENDLOOP.


*uline.
  LOOP AT it_tab2 INTO wa_tab2.


*     WHERE MATNR IN MATNR.
*  write : / 'new',wa_tab2-werks,wa_tab2-aufnr,wa_tab2-matnr,wa_tab2-charg,wa_tab2-menge,wa_tab2-meins,wa_tab2-matnr1,wa_tab2-charg1.
    wa_tab3-werks = wa_tab2-werks.
    wa_tab3-aufnr = wa_tab2-aufnr.
    wa_tab3-matnr = wa_tab2-matnr.
    wa_tab3-charg = wa_tab2-charg.
    wa_tab3-menge = wa_tab2-menge.
    wa_tab3-charg1 = wa_tab2-charg1.
    wa_tab3-matnr1 = wa_tab2-matnr1.
    wa_tab3-meins = wa_tab2-meins.
    wa_tab3-budat = wa_tab2-budat.
    wa_tab3-mblnr = wa_tab2-mblnr.

    SELECT SINGLE * FROM makt WHERE matnr EQ wa_tab2-matnr.
    IF sy-subrc EQ 0.
      wa_tab3-maktx = makt-maktx.
    ENDIF.

    wa_tab3-werks = wa_tab2-werks.
*    select single * from mast where matnr eq wa_tab2-matnr1 and werks eq wa_tab2-werks.
*    if sy-subrc eq 0.

*      write : wa_ta1-idnrk, wa_ta1-menge,wa_ta1-meins.

    READ TABLE it_ta1 INTO wa_ta1 WITH KEY stlnr = wa_tab2-stlnr stlal = wa_tab2-stlal idnrk = wa_tab2-matnr.
    IF sy-subrc EQ 0.
      wa_tab3-menge1 = wa_ta1-menge.
      wa_tab3-meins1 = wa_ta1-meins.
*      wa_tab3-posnr = wa_ta1-posnr.
      wa_tab3-stlnr = wa_ta1-stlnr.
      wa_tab3-stlal = wa_ta1-stlal.
    ENDIF.
    COLLECT wa_tab3 INTO it_tab3.
    CLEAR wa_tab3.
*    endif.


  ENDLOOP.

  LOOP AT it_tab3 INTO wa_tab3.
*    WRITE : / 'xx',wa_tab3-werks,wa_tab3-aufnr,wa_tab3-charg1,wa_tab3-matnr,wa_tab3-maktx,
*    wa_tab3-charg,wa_tab3-menge,wa_tab3-meins,wa_tab3-menge1,
*    wa_tab3-meins1.
    wa_tab4-werks = wa_tab3-werks.
    wa_tab4-aufnr = wa_tab3-aufnr.
    wa_tab4-charg1 = wa_tab3-charg1.
    wa_tab4-matnr = wa_tab3-matnr.
    wa_tab4-matnr1 = wa_tab3-matnr1.
    wa_tab4-maktx = wa_tab3-maktx.
    wa_tab4-charg = wa_tab3-charg.
    wa_tab4-menge = wa_tab3-menge.
    wa_tab4-meins = wa_tab3-meins.
    wa_tab4-menge1 = wa_tab3-menge1.
    wa_tab4-meins1 = wa_tab3-meins1.
*    wa_tab4-posnr = wa_tab3-posnr.
    wa_tab4-stlnr = wa_tab3-stlnr.
    wa_tab4-stlal = wa_tab3-stlal.
    wa_tab4-budat = wa_tab3-budat.
    wa_tab4-mblnr = wa_tab3-mblnr.
*    LOOP AT It_tab3 INTO wa_tab3 WHERE charg = wa_tab3-charg.
*      IF  AND matnr cs 'H'.
*      WRITE : / '**',WA_TAB3-MENGE,WA_TAB3-MENGE1.
*      WA_TAB4-B1 = WA_TAB3-MENGE.
*      WA_TAB4-B2 = WA_TAB3-MENGE1.
*    ENDLOOP.
    COLLECT wa_tab4 INTO it_tab4.
    CLEAR wa_tab4.
  ENDLOOP.

  IF it_tab4 IS NOT INITIAL.
    SELECT * FROM qals INTO TABLE it_qals FOR ALL ENTRIES IN it_tab4 WHERE matnr EQ it_tab4-matnr AND charg EQ it_tab4-charg AND werk EQ it_tab4-werks
      AND stat34 EQ 'X'.
    IF sy-subrc EQ 0.
      SELECT * FROM qave INTO TABLE it_qave FOR ALL ENTRIES IN it_qals WHERE prueflos EQ it_qals-prueflos AND vcode IN ('A','PA').
    ENDIF.
  ENDIF.

  IF it_tab4 IS NOT INITIAL.
    LOOP AT it_tab4 INTO wa_tab4.
      LOOP AT it_qals INTO wa_qals WHERE matnr = wa_tab4-matnr AND charg = wa_tab4-charg AND werk = wa_tab4-werks.
        READ TABLE it_qave INTO wa_qave WITH KEY prueflos = wa_qals-prueflos.
        IF sy-subrc EQ 0.
          IF wa_qave-vdatum LE wa_tab4-budat.
            wa_taq1-matnr = wa_tab4-matnr.
            wa_taq1-charg = wa_tab4-charg.
            wa_taq1-werks = wa_tab4-werks.
            wa_taq1-prueflos = wa_qave-prueflos.
            wa_taq1-vdatum = wa_qave-vdatum.
            COLLECT wa_taq1 INTO it_taq1.
            CLEAR wa_taq1.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDIF.

  SORT it_taq1 DESCENDING BY vdatum.

  LOOP AT it_tab4 INTO wa_tab4.
    CLEAR : val,qt1.
*    WRITE : / 'a',wa_TAB4-werks,wa_TAB4-aufnr,wa_TAB4-charg1,wa_TAB4-matnr, wa_TAB4-maktx,
*       wa_TAB4-charg,wa_TAB4-menge,wa_TAB4-meins,wa_TAB4-menge1, wa_tab3-meins1.
    wa_tab5-werks = wa_tab4-werks.
    wa_tab5-aufnr = wa_tab4-aufnr.
    wa_tab5-charg1 = wa_tab4-charg1.
    wa_tab5-matnr = wa_tab4-matnr.
    wa_tab5-matnr1 = wa_tab4-matnr1.
    wa_tab5-maktx = wa_tab4-maktx.
    wa_tab5-charg = wa_tab4-charg.
    wa_tab5-menge = wa_tab4-menge.
    wa_tab5-meins = wa_tab4-meins.
    READ TABLE it_ta1 INTO wa_ta1 WITH KEY stlnr = wa_tab4-stlnr stlal = wa_tab4-stlal idnrk = wa_tab4-matnr.
    IF sy-subrc EQ 0.
      wa_tab5-menge1 = wa_ta1-menge.
      wa_tab5-meins1 = wa_ta1-meins.
    ENDIF.
    wa_tab5-budat = wa_tab4-budat.
    wa_tab5-mblnr = wa_tab4-mblnr.
*    wa_tab5-posnr = wa_tab4-posnr.
    wa_tab5-stlnr = wa_tab4-stlnr.
    wa_tab5-stlal = wa_tab4-stlal.
***********techo************
    READ TABLE it_afpo INTO wa_afpo WITH KEY aufnr = wa_tab4-aufnr.
    IF sy-subrc EQ 0.
*      wa_tab5-dnrel = wa_afpo-dnrel.
      IF wa_afpo-dnrel EQ 'X'.
        wa_tab5-dnrel = 'YES'.
      ENDIF.
    ENDIF.
*********************************
    IF wa_tab4-menge1 GT 0.
      qt1 = ( ( wa_tab4-menge * 100 ) / wa_tab4-menge1 ) - 100.
    ENDIF.
    wa_tab5-qt1 = qt1.

    LOOP AT it_tab3 INTO wa_tab3 WHERE charg1 = wa_tab4-charg1.
      IF  wa_tab3-matnr CS 'H'.
*        WRITE :  'b',WA_TAB3-MENGE,WA_TAB3-MENGE1.
        wa_tab4-b1 = wa_tab3-menge.
        wa_tab4-b2 = wa_tab3-menge1.
        IF wa_tab4-b2 NE 0.
          val = ( wa_tab4-b1 * wa_tab4-menge1 ) / wa_tab4-b2.
        ENDIF.
*        WRITE : 'val',val.
        wa_tab5-val = val.
        EXIT.
      ENDIF.
    ENDLOOP.
    SELECT SINGLE * FROM mbew WHERE matnr EQ wa_tab4-matnr AND bwkey EQ wa_tab4-werks.
    IF sy-subrc EQ 0.
      wa_tab5-verpr = mbew-verpr.
      wa_tab5-stprs = mbew-stprs.
      wa_tab5-peinh = mbew-peinh.
      wa_tab5-salk3 = mbew-salk3.
    ENDIF.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_tab4-matnr1 AND spras = sy-langu.
    IF sy-subrc EQ 0.
      wa_tab5-maktx1 = makt-maktx.
    ENDIF.

    READ TABLE it_taq1 INTO wa_taq1 WITH KEY matnr = wa_tab4-matnr charg = wa_tab4-charg werks = wa_tab4-werks.
    IF sy-subrc EQ 0.
      wa_tab5-prueflos = wa_taq1-prueflos.
      wa_tab5-vdatum = wa_taq1-vdatum.
    ENDIF.
*    SELECT SINGLE * FROM QALS WHERE MATNR EQ WA_TAB4-MATNR AND CHARG EQ WA_TAB4-CHARG AND WERK EQ WA_TAB4-WERKS AND BUDAT LE WA_TAB4-BUDAT AND STAT34 EQ 'X'.
*    IF SY-SUBRC EQ 0.
*      SELECT SINGLE * FROM QAVE WHERE PRUEFLOS EQ QALS-PRUEFLOS AND VCODE IN ('A','PA').
*      IF SY-SUBRC EQ 0.
*        WA_TAB5-PRUEFLOS = QAVE-PRUEFLOS.
*      ENDIF.
*    ENDIF.
    COLLECT wa_tab5 INTO it_tab5.
    CLEAR wa_tab5.
  ENDLOOP.
*uline.
  SORT it_tab5 BY charg1.
  LOOP AT it_tab5 INTO wa_tab5.
*    if wa_tab5-MATNR NA 'H'.
*      pack wa_tab5-aufnr to wa_tab5-aufnr.
*      pack wa_tab5-matnr to wa_tab5-matnr.
*      condense : wa_tab5-aufnr ,WA_tab5-MATNR.
*      modify it_tab5 from wa_tab5 transporting aufnr MATNR.
*    ELSE.
*      pack wa_tab5-aufnr to wa_tab5-aufnr.
**    pack wa_tab5-matnr to wa_tab5-matnr.
*      condense : wa_tab5-aufnr .
*      modify it_tab5 from wa_tab5 transporting aufnr.
*    ENDIF.
    IF r1 EQ 'X'.
      SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab5-matnr AND mtart EQ 'ZROH'.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING wa_tab5 TO wa_tab6.
        COLLECT wa_tab6 INTO it_tab6.
        CLEAR wa_tab6.
      ENDIF.
    ELSEIF r2 EQ 'X'.
      SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab5-matnr AND mtart EQ 'ZVRP'.
      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING wa_tab5 TO wa_tab6.
        COLLECT wa_tab6 INTO it_tab6.
        CLEAR wa_tab6.
      ENDIF.
    ELSE.
      MOVE-CORRESPONDING wa_tab5 TO wa_tab6.
      COLLECT wa_tab6 INTO it_tab6.
      CLEAR wa_tab6.
    ENDIF.
*    WRITE : / wa_tab5-werks,wa_tab5-aufnr,wa_tab5-charg1,wa_tab5-matnr,wa_tab5-charg,wa_tab5-menge,
*      wa_tab5-meins,wa_tab5-menge1,wa_tab5-meins1.
  ENDLOOP.

  IF p2 EQ 'X'.
    PERFORM summ.



  ELSE.

    LOOP AT it_tab6 INTO wa_tab6.
*      write : / wa_tab6-matnr,wa_tab6-charg.
      SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab6-matnr AND mtart EQ 'ZROH'.
      IF sy-subrc EQ 0.
        wa_rm1-matnr = wa_tab6-matnr.
        wa_rm1-charg = wa_tab6-charg.
        COLLECT wa_rm1 INTO it_rm1.
        CLEAR wa_rm1.
*        write : 'mfgr'.
      ENDIF.
      SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab6-matnr AND mtart EQ 'ZVRP'.
      IF sy-subrc EQ 0.
        wa_pm1-matnr = wa_tab6-matnr.
        wa_pm1-charg = wa_tab6-charg.
        COLLECT wa_pm1 INTO it_pm1.
        CLEAR wa_pm1.
*        write : 'mfgr'.
      ENDIF.
    ENDLOOP.
    PERFORM mfgr.

    LOOP AT it_tab6 INTO wa_tab6.
      CLEAR : mtart.
      SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab6-matnr.
      IF sy-subrc EQ 0.
        mtart = mara-mtart.
      ENDIF.
      IF mtart EQ 'ZROH'.
        READ TABLE it_rm3 INTO wa_rm3 WITH KEY matnr = wa_tab6-matnr charg = wa_tab6-charg.
        IF sy-subrc EQ 0.
          wa_tab6-mfgrname = wa_rm3-mfgrname.
          MODIFY it_tab6 FROM wa_tab6 TRANSPORTING mfgrname.
          CLEAR wa_tab6.
        ENDIF.
      ELSEIF mtart EQ 'ZVRP'.
        READ TABLE it_pm3 INTO wa_pm3 WITH KEY matnr = wa_tab6-matnr charg = wa_tab6-charg.
        IF sy-subrc EQ 0.
          wa_tab6-mfgrname = wa_pm3-mfgrname.
          MODIFY it_tab6 FROM wa_tab6 TRANSPORTING mfgrname.
          CLEAR wa_tab6.
        ENDIF.
      ENDIF.
    ENDLOOP.

*    loop at it_tab6 into wa_tab6.
*      if wa_tab6-matnr1 cs 'H'.
*      else.
**        pack wa_tab6-matnr1 to wa_tab6-matnr1.
*      endif.
*      if wa_tab6-matnr cs 'H'.
*      else.
**        pack wa_tab6-matnr to wa_tab6-matnr.
*      endif.
*      pack wa_tab6-aufnr to wa_tab6-aufnr.
**      PACK WA_TAB8-MATNR TO WA_TAB8-MATNR.
**      pack wa_tab8-matnr1 to wa_tab8-matnr1.
*      condense : wa_tab6-aufnr ,wa_tab6-matnr, wa_tab6-matnr1.
**      , wa_tab8-matnr1.
*      modify it_tab6 from wa_tab6 transporting aufnr matnr matnr1.
*
*    endloop.

    wa_fieldcat-fieldname = 'WERKS'.
    wa_fieldcat-seltext_l = 'PLANT'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'AUFNR'.
    wa_fieldcat-seltext_l = 'ORDER NO.'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'MATNR1'.
    wa_fieldcat-seltext_l = 'PRODUCT CODE'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'MAKTX1'.
    wa_fieldcat-seltext_l = 'PRODUCT NAME'.
    APPEND wa_fieldcat TO fieldcat.


    wa_fieldcat-fieldname = 'CHARG1'.
    wa_fieldcat-seltext_l = 'BATCH'.
    APPEND wa_fieldcat TO fieldcat.


    wa_fieldcat-fieldname = 'MATNR'.
    wa_fieldcat-seltext_l = 'CODE'.
    APPEND wa_fieldcat TO fieldcat.


    wa_fieldcat-fieldname = 'MAKTX'.
    wa_fieldcat-seltext_l = 'COMPONANT'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'CHARG'.
    wa_fieldcat-seltext_l = 'ID. NO'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'MFGRNAME'.
    wa_fieldcat-seltext_l = 'MANUFACTURER NAME'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'PRUEFLOS'.
    wa_fieldcat-seltext_l = 'ID. INSPECTION LOT'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'VDATUM'.
    wa_fieldcat-seltext_l = 'INSP. UD DATE'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'MENGE'.
    wa_fieldcat-seltext_l = 'USED QTY'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'MEINS'.
    wa_fieldcat-seltext_l = 'UNIT'.
    APPEND wa_fieldcat TO fieldcat.

*    wa_fieldcat-fieldname = 'POSNR'.
*    wa_fieldcat-seltext_l = 'BOM ITEM NO.'.
*    append wa_fieldcat to fieldcat.

    wa_fieldcat-fieldname = 'MENGE1'.
    wa_fieldcat-seltext_l = 'BOM QTY'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'MEINS1'.
    wa_fieldcat-seltext_l = 'BOM UNIT'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'BUDAT'.
    wa_fieldcat-seltext_l = 'RM/PM ISSUE DATE'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'MBLNR'.
    wa_fieldcat-seltext_l = 'RM/PM ISSUE DOC'.
    APPEND wa_fieldcat TO fieldcat.



    IF r3 NE 'X'.
*    wa_fieldcat-fieldname = 'VAL'.
*    wa_fieldcat-seltext_s = 'BOM RECCOM.'.
*    append wa_fieldcat to fieldcat.

      wa_fieldcat-fieldname = 'QT1'.
      wa_fieldcat-seltext_l = 'USED PERCRNTAGE'.
      APPEND wa_fieldcat TO fieldcat.
    ENDIF.

    wa_fieldcat-fieldname = 'DNREL'.
    wa_fieldcat-seltext_l = 'TECHO COMPLETE'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'VERPR'.
    wa_fieldcat-seltext_l = 'MOVING RATE'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'STPRS'.
    wa_fieldcat-seltext_l = 'STATDARD RATE'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'PEINH'.
    wa_fieldcat-seltext_l = 'UOM RATE'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'STLNR'.
    wa_fieldcat-seltext_l = 'BOM NO.'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'STLAL'.
    wa_fieldcat-seltext_l = 'ALT BOM NO'.
    APPEND wa_fieldcat TO fieldcat.



    layout-zebra = 'X'.
    layout-colwidth_optimize = 'X'.
    layout-window_titlebar  = 'ORDER WISE CONSUMPTION vs. ACTUAL'.


    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
*       I_INTERFACE_CHECK       = ' '
*       I_BYPASSING_BUFFER      = ' '
*       I_BUFFER_ACTIVE         = ' '
        i_callback_program      = g_repid
*       I_CALLBACK_PF_STATUS_SET          = ' '
        i_callback_user_command = 'USER_COMM'
        i_callback_top_of_page  = 'TOP'
*       I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*       I_CALLBACK_HTML_END_OF_LIST       = ' '
*       I_STRUCTURE_NAME        =
*       I_BACKGROUND_ID         = ' '
*       I_GRID_TITLE            =
*       I_GRID_SETTINGS         =
        is_layout               = layout
        it_fieldcat             = fieldcat
*       IT_EXCLUDING            =
*       IT_SPECIAL_GROUPS       =
*       IT_SORT                 =
*       IT_FILTER               =
*       IS_SEL_HIDE             =
*       I_DEFAULT               = 'X'
        i_save                  = 'A'
*       IS_VARIANT              =
*       IT_EVENTS               =
*       IT_EVENT_EXIT           =
*       IS_PRINT                =
*       IS_REPREP_ID            =
*       I_SCREEN_START_COLUMN   = 0
*       I_SCREEN_START_LINE     = 0
*       I_SCREEN_END_COLUMN     = 0
*       I_SCREEN_END_LINE       = 0
*       I_HTML_HEIGHT_TOP       = 0
*       I_HTML_HEIGHT_END       = 0
*       IT_ALV_GRAPHICS         =
*       IT_HYPERLINK            =
*       IT_ADD_FIELDCAT         =
*       IT_EXCEPT_QINFO         =
*       IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*       E_EXIT_CAUSED_BY_CALLER =
*       ES_EXIT_CAUSED_BY_USER  =
      TABLES
        t_outtab                = it_tab6
      EXCEPTIONS
        program_error           = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top.

  DATA: comment    TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'ORDER WISE CONSUMPTION vs. ACTUAL'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND wa_comment TO comment.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = comment
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
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
    WHEN 'MATNR1'.
      SET PARAMETER ID 'MAT' FIELD selfield-value.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN 'MBLNR'.
      SET PARAMETER ID 'MBN' FIELD selfield-value.
      CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Form  SUMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM summ .

*  break-point .
  LOOP AT it_tab6 INTO wa_tab6.
    wa_tab7-matnr = wa_tab6-matnr.
    wa_tab7-charg1 = wa_tab6-charg1.
    wa_tab7-matnr1 = wa_tab6-matnr1.
    wa_tab7-maktx1 = wa_tab6-maktx1.
    wa_tab7-aufnr = wa_tab6-aufnr.
    wa_tab7-menge = wa_tab6-menge.
    wa_tab7-meins = wa_tab6-meins.
*    wa_tab7-menge1 = wa_tab6-menge1.
*    wa_tab7-meins1 = wa_tab6-meins1.
    wa_tab7-maktx = wa_tab6-maktx.
*    wa_tab7-posnr = wa_tab6-posnr.
    wa_tab7-werks = wa_tab6-werks.
    wa_tab7-stlnr = wa_tab6-stlnr.
    wa_tab7-stlal = wa_tab6-stlal.

*    read table it_ta1 into wa_ta1 with key stlnr = wa_tab6-stlnr stlal = wa_tab6-stlal idnrk = wa_tab6-matnr posnr = wa_tab6-posnr.
*    if sy-subrc eq 0.
*      wa_tab7-menge1 = wa_ta1-menge.
*      wa_tab7-meins1 = wa_ta1-meins.
*      wa_tab7-posnr = wa_ta1-posnr.
*      wa_tab7-stlnr = wa_ta1-stlnr.
*      wa_tab7-stlal = wa_ta1-stlal.
*    endif.
    COLLECT wa_tab7 INTO it_tab7.
    CLEAR wa_tab7.
  ENDLOOP.


  LOOP AT it_tab7 INTO wa_tab7.
    wa_tab8-matnr = wa_tab7-matnr.
    wa_tab8-charg1 = wa_tab7-charg1.
    wa_tab8-matnr1 = wa_tab7-matnr1.
    wa_tab8-maktx1 = wa_tab7-maktx1.
    wa_tab8-aufnr = wa_tab7-aufnr.
    wa_tab8-menge = wa_tab7-menge.
    wa_tab8-meins = wa_tab7-meins.
*    wa_tab7-menge1 = wa_tab6-menge1.
*    wa_tab7-meins1 = wa_tab6-meins1.
    wa_tab8-maktx = wa_tab7-maktx.
*    wa_tab7-posnr = wa_tab6-posnr.
    wa_tab8-werks = wa_tab7-werks.
    wa_tab8-stlnr = wa_tab7-stlnr.
    wa_tab8-stlal = wa_tab7-stlal.

    READ TABLE it_ta1 INTO wa_ta1 WITH KEY stlnr = wa_tab7-stlnr stlal = wa_tab7-stlal idnrk = wa_tab7-matnr.
    IF sy-subrc EQ 0.
      wa_tab8-menge1 = wa_ta1-menge.
      wa_tab8-meins1 = wa_ta1-meins.
    ENDIF.
    SELECT SINGLE * FROM afpo WHERE aufnr EQ wa_tab7-aufnr AND matnr EQ wa_tab8-matnr1 AND charg EQ wa_tab8-charg1.
    IF sy-subrc EQ 0.
      wa_tab8-wemng = afpo-wemng.
      wa_tab8-psmng = afpo-psmng.
    ENDIF.
    SELECT SINGLE * FROM mast WHERE matnr EQ wa_tab8-matnr1 AND werks EQ wa_tab8-werks AND stlnr EQ wa_tab8-stlnr AND stlal EQ wa_tab8-stlal.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM stko WHERE stlnr EQ mast-stlnr AND stlal EQ mast-stlal.
      IF sy-subrc EQ 0.
        wa_tab8-bmeng = stko-bmeng.
      ENDIF.
    ENDIF.
    CLEAR relqty.
    relqty = ( wa_tab8-menge1 * wa_tab8-psmng ) / wa_tab8-bmeng.
    wa_tab8-relqty = relqty.
    CLEAR : var.
    var = wa_tab8-relqty - wa_tab8-menge.
    wa_tab8-var = var.
    COLLECT wa_tab8 INTO it_tab8.
    CLEAR wa_tab8.
  ENDLOOP.



  LOOP AT it_tab8 INTO wa_tab8.
*    if wa_tab8-matnr cs 'H'.
*      pack wa_tab8-aufnr to wa_tab8-aufnr.
*      pack wa_tab8-matnr to wa_tab8-matnr.
*      pack wa_tab8-matnr1 to wa_tab8-matnr1.
*      condense : wa_tab8-aufnr ,wa_tab8-matnr, wa_tab8-matnr1.
*      modify it_tab8 from wa_tab8 transporting aufnr matnr matnr1.
*    else.
*      pack wa_tab8-aufnr to wa_tab8-aufnr.
**    pack wa_TAB8-matnr to wa_TAB8-matnr.
*      condense : wa_tab8-aufnr .
*      modify it_tab8 from wa_tab8 transporting aufnr.
*    endif.

    IF wa_tab8-matnr1 CS 'H'.
    ELSE.
*      PACK wa_tab8-matnr1 TO wa_tab8-matnr1.
    ENDIF.
    IF wa_tab8-matnr CS 'H'.
    ELSE.
*      PACK wa_tab8-matnr TO wa_tab8-matnr.
    ENDIF.
    PACK wa_tab8-aufnr TO wa_tab8-aufnr.
*      PACK WA_TAB8-MATNR TO WA_TAB8-MATNR.
*      pack wa_tab8-matnr1 to wa_tab8-matnr1.
    CONDENSE : wa_tab8-aufnr ,wa_tab8-matnr, wa_tab8-matnr1.
*      , wa_tab8-matnr1.
    MODIFY it_tab8 FROM wa_tab8 TRANSPORTING aufnr matnr matnr1.

*      ELSEIF WA_TAB8-MATNR1 CS 'H' AND wa_tab8-matnr CS 'H'.
*    ELSE.
*      PACK WA_TAB8-AUFNR TO WA_TAB8-AUFNR.
*      PACK WA_TAB8-MATNR TO WA_TAB8-MATNR.
*      PACK WA_TAB8-MATNR1 TO WA_TAB8-MATNR1.
*      CONDENSE : WA_TAB8-AUFNR, WA_TAB8-MATNR, WA_TAB8-MATNR1.
*      MODIFY IT_TAB8 FROM WA_TAB8 TRANSPORTING AUFNR MATNR MATNR1.
*    ENDIF.
  ENDLOOP.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'PLANT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'AUFNR'.
  wa_fieldcat-seltext_l = 'ORDER NO.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MATNR1'.
  wa_fieldcat-seltext_l = 'PRODUCT CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MAKTX1'.
  wa_fieldcat-seltext_l = 'PRODUCT NAME'.
  APPEND wa_fieldcat TO fieldcat.


  wa_fieldcat-fieldname = 'CHARG1'.
  wa_fieldcat-seltext_l = 'BATCH'.
  APPEND wa_fieldcat TO fieldcat.


  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'CODE'.
  APPEND wa_fieldcat TO fieldcat.


  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'COMPONANT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MENGE'.
  wa_fieldcat-seltext_l = 'USED QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'RELQTY'.
  wa_fieldcat-seltext_l = 'ORD RELEVENT QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'VAR'.
  wa_fieldcat-seltext_l = 'VARIANCE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MEINS'.
  wa_fieldcat-seltext_l = 'UNIT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MENGE1'.
  wa_fieldcat-seltext_l = 'BOM QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MEINS1'.
  wa_fieldcat-seltext_l = 'BOM UNIT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'STLNR'.
  wa_fieldcat-seltext_l = 'BOM NO.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'STLAL'.
  wa_fieldcat-seltext_l = 'ALT BOM NO'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'WEMNG'.
  wa_fieldcat-seltext_l = 'ORD. DELIVERED QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'PSMNG'.
  wa_fieldcat-seltext_l = 'ORD. QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BMENG'.
  wa_fieldcat-seltext_l = 'STD. BOM SIZE'.
  APPEND wa_fieldcat TO fieldcat.




  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'ORDER WISE CONSUMPTION vs. ACTUAL - SUMMARY'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      is_layout               = layout
      it_fieldcat             = fieldcat
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      i_save                  = 'A'
*     IS_VARIANT              =
*     IT_EVENTS               =
*     IT_EVENT_EXIT           =
*     IS_PRINT                =
*     IS_REPREP_ID            =
*     I_SCREEN_START_COLUMN   = 0
*     I_SCREEN_START_LINE     = 0
*     I_SCREEN_END_COLUMN     = 0
*     I_SCREEN_END_LINE       = 0
*     I_HTML_HEIGHT_TOP       = 0
*     I_HTML_HEIGHT_END       = 0
*     IT_ALV_GRAPHICS         =
*     IT_HYPERLINK            =
*     IT_ADD_FIELDCAT         =
*     IT_EXCEPT_QINFO         =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER  =
    TABLES
      t_outtab                = it_tab8
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MFGR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM mfgr .
  IF it_rm1 IS NOT INITIAL.
    SELECT * FROM qals INTO TABLE it_qals1 FOR ALL ENTRIES IN it_rm1 WHERE charg EQ it_rm1-charg AND lifnr NE space.
    SELECT * FROM mcha INTO TABLE it_mcha1 FOR ALL ENTRIES IN it_rm1 WHERE charg EQ it_rm1-charg AND lifnr NE space.
  ENDIF.
  SORT it_mcha1 BY ersda.
  IF it_mcha1 IS NOT INITIAL.
    SELECT * FROM mseg INTO TABLE it_mseg1 FOR ALL ENTRIES IN it_mcha1 WHERE bwart EQ '101' AND matnr EQ it_mcha1-matnr AND werks EQ it_mcha1-werks
      AND charg EQ it_mcha1-charg.
  ENDIF.

  LOOP AT it_qals1 INTO wa_qals1.
    SELECT SINGLE * FROM jest WHERE objnr EQ wa_qals1-objnr AND stat EQ 'I0224'.
    IF sy-subrc EQ 0.
      DELETE it_qals1 WHERE prueflos EQ wa_qals1-prueflos.
    ENDIF.
  ENDLOOP.
  SORT it_qals1.

  LOOP AT  it_rm1 INTO wa_rm1.
    wa_rm2-matnr = wa_rm1-matnr.
    wa_rm2-charg = wa_rm1-charg.
    READ TABLE it_qals1 INTO wa_qals1 WITH KEY charg = wa_rm1-charg.
    IF sy-subrc EQ 0.
*      write : wa_qals1-prueflos,wa_qals1-matnr,wa_qals1-charg,wa_qals1-mblnr.
      SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_qals1-mblnr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
        IF sy-subrc EQ 0.
          wa_rm2-mfgrname = lfa1-name1.
        ENDIF.
      ENDIF.
    ENDIF.
    COLLECT wa_rm2 INTO it_rm2.
    CLEAR wa_rm2.
  ENDLOOP.

  LOOP AT it_rm2 INTO wa_rm2.
    wa_rm3-matnr = wa_rm2-matnr.
    wa_rm3-charg = wa_rm2-charg.
    wa_rm3-mfgrname = wa_rm2-mfgrname.
    IF wa_rm2-mfgrname EQ space.
      READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY charg = wa_rm2-charg.
      IF sy-subrc EQ 0.
*        SELECT SINGLE * FROM EKPO WHERE EBELN EQ wa_mseg1-ebeln AND EBELP EQ wa_mseg1-EBELP.
*          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ ekpo-mfrnr.
*          IF sy-subrc EQ 0.
*            wa_rm3-mfgrname = lfa1-name1.
*          ENDIF.
        SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_mseg1-mblnr AND zeile EQ wa_mseg1-zeile.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
          IF sy-subrc EQ 0.
            wa_rm3-mfgrname = lfa1-name1.  "25.4.20
          ENDIF.
        ELSE.
          wa_rm3-mfgrname = wa_mseg1-sgtxt.
        ENDIF.
      ENDIF.
    ENDIF.
    COLLECT wa_rm3 INTO it_rm3.
    CLEAR wa_rm3.
  ENDLOOP.

*  loop at it_rm3 into wa_rm3.
*    write : / 'a', wa_rm3-matnr,wa_rm3-charg,wa_rm3-mfgrname.
*  endloop.

  IF it_pm1 IS NOT INITIAL.
    SELECT * FROM mcha INTO TABLE it_mcha2 FOR ALL ENTRIES IN it_pm1 WHERE charg EQ it_pm1-charg.
  ENDIF.
  SORT it_mcha2 BY ersda.
  IF it_mcha2 IS NOT INITIAL.
    SELECT * FROM mseg INTO TABLE it_mseg2 FOR ALL ENTRIES IN it_mcha2 WHERE bwart EQ '101' AND matnr EQ it_mcha2-matnr AND werks EQ it_mcha2-werks
      AND charg EQ it_mcha2-charg.
  ENDIF.

  LOOP AT it_pm1 INTO wa_pm1.
    wa_pm3-matnr = wa_pm1-matnr.
    wa_pm3-charg = wa_pm1-charg.
    READ TABLE it_mseg2 INTO wa_mseg2 WITH KEY charg = wa_pm1-charg.
    IF sy-subrc EQ 0.
*      SELECT SINGLE * FROM EKPO WHERE EBELN EQ wa_mseg2-ebeln AND EBELP EQ wa_mseg2-EBELP.
*          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ ekpo-mfrnr.
*          IF sy-subrc EQ 0.
*            wa_pm3-mfgrname = lfa1-name1.
*          ENDIF.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_mseg2-lifnr.
      IF sy-subrc EQ 0.
        wa_pm3-mfgrname = lfa1-name1.  "25.4.20
      ENDIF.
    ENDIF.
    COLLECT wa_pm3 INTO it_pm3.
    CLEAR wa_pm3.
  ENDLOOP.


ENDFORM.
