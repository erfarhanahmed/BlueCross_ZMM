*&---------------------------------------------------------------------*
*& Report  ZMB51_DELADDR1
*& DEVELOPED BY JYOTSNA
*&---------------------------------------------------------------------*
*&THIS IS CUSTOMIZED REPORT OF MB51
*&
*&---------------------------------------------------------------------*

REPORT  zmb51_deladdr4 NO STANDARD PAGE HEADING LINE-SIZE 300.
TABLES : mseg,
         mkpf,
         ekpo,
         lfa1,
         makt,
         mara,
         tspat,
         t023t,
         j_1igrxref,
         t007s,
         rseg,
         bkpf,
         rbkp.

TYPE-POOLS:  slis.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.

TYPES : BEGIN OF typ_mkpf,
          mblnr TYPE mkpf-mblnr,
          mjahr TYPE mkpf-mjahr,
          bldat TYPE mkpf-bldat,
          budat TYPE mkpf-budat,
          xblnr TYPE mkpf-xblnr,
          bktxt TYPE mkpf-bktxt,
        END OF typ_mkpf.

TYPES : BEGIN OF typ_mseg,
          mblnr TYPE mseg-mblnr,
          mjahr TYPE mseg-mjahr,
          zeile TYPE mseg-zeile,
          bwart TYPE mseg-bwart,
          xauto TYPE mseg-xauto,
          matnr TYPE mseg-matnr,
          werks TYPE mseg-werks,
          lgort TYPE mseg-lgort,
          charg TYPE mseg-charg,
          lifnr TYPE mseg-lifnr,
          kunnr TYPE mseg-kunnr,
          shkzg TYPE mseg-shkzg,
          dmbtr TYPE mseg-dmbtr,
          menge TYPE mseg-menge,
          meins TYPE mseg-meins,
          ebeln TYPE mseg-ebeln,
          ebelp TYPE mseg-ebelp,
          lfbja TYPE mseg-lfbja,
          lfbnr TYPE mseg-lfbnr,
          emlif TYPE mseg-emlif,
        END OF typ_mseg.

DATA : it_mkpf TYPE TABLE OF typ_mkpf,
       wa_mkpf TYPE typ_mkpf,
       it_mseg TYPE TABLE OF typ_mseg,
       wa_mseg TYPE typ_mseg,
       it_mara TYPE TABLE OF mara,
       wa_mara TYPE mara,
       it_rseg TYPE TABLE OF rseg,
       wa_rseg TYPE rseg,
       it_bseg TYPE TABLE OF bseg,
       wa_bseg TYPE bseg,
       it_bset TYPE TABLE OF bset,
       wa_bset TYPE bset.

TYPES : BEGIN OF itab1,
          mblnr      TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          zeile      TYPE mseg-zeile,
          bwart      TYPE mseg-bwart,
          xauto      TYPE mseg-xauto,
          matnr      TYPE mseg-matnr,
          werks      TYPE mseg-werks,
          lgort      TYPE mseg-lgort,
          charg      TYPE mseg-charg,
          lifnr      TYPE mseg-lifnr,
          kunnr      TYPE mseg-kunnr,
          shkzg      TYPE mseg-shkzg,
          dmbtr      TYPE mseg-dmbtr,
          menge      TYPE mseg-menge,
          meins      TYPE mseg-meins,
          ebeln      TYPE mseg-ebeln,
          ebelp      TYPE mseg-ebelp,
          lfbja      TYPE mseg-lfbja,
          lfbnr      TYPE mseg-lfbnr,
          emlif      TYPE mseg-emlif,
          maktx      TYPE makt-maktx,
          name1      TYPE lfa1-name1,
          ort01      TYPE lfa1-ort01,
          name2      TYPE lfa1-name1,
          ort02      TYPE lfa1-ort01,
          budat      TYPE mkpf-budat,
          bldat      TYPE mkpf-bldat,
          xblnr      TYPE mkpf-xblnr,
          mtart      TYPE mara-mtart,
          spart      TYPE mara-spart,
          vtext      TYPE tspat-vtext,
          matkl      TYPE mara-matkl,
          wgbez      TYPE t023t-wgbez,
          bktxt      TYPE bkpf-bktxt,
          exbed      TYPE j_1igrxref-exbed,
          mwskz      TYPE ekpo-mwskz,
          text1      TYPE t007s-text1,
          netpr      TYPE ekpo-netpr,
          peinh      TYPE ekpo-peinh,
          po_stat(7) TYPE c,
        END OF itab1.


TYPES : BEGIN OF itab2,
          mblnr      TYPE mseg-mblnr,
          mjahr      TYPE mseg-mjahr,
          zeile      TYPE mseg-zeile,
          bwart      TYPE mseg-bwart,
          xauto      TYPE mseg-xauto,
*          matnr      TYPE mseg-matnr,
   matnr(20) TYPE c,
          werks      TYPE mseg-werks,
          lgort      TYPE mseg-lgort,
          charg      TYPE mseg-charg,
          lifnr      TYPE mseg-lifnr,
          kunnr      TYPE mseg-kunnr,
          shkzg      TYPE mseg-shkzg,
          dmbtr      TYPE mseg-dmbtr,
          menge      TYPE mseg-menge,
          meins      TYPE mseg-meins,
          ebeln      TYPE mseg-ebeln,
          ebelp      TYPE mseg-ebelp,
          lfbja      TYPE mseg-lfbja,
          lfbnr      TYPE mseg-lfbnr,
          emlif      TYPE mseg-emlif,
          maktx      TYPE makt-maktx,
          name1      TYPE lfa1-name1,
          ort01      TYPE lfa1-ort01,
          name2      TYPE lfa1-name1,
          ort02      TYPE lfa1-ort01,
          budat      TYPE mkpf-budat,
          bldat      TYPE mkpf-bldat,
          xblnr      TYPE mkpf-xblnr,
          mtart      TYPE mara-mtart,
          spart      TYPE mara-spart,
          vtext      TYPE tspat-vtext,
          matkl      TYPE mara-matkl,
          wgbez      TYPE t023t-wgbez,
          bktxt      TYPE bkpf-bktxt,
          exbed      TYPE j_1igrxref-exbed,
          mwskz      TYPE ekpo-mwskz,
          text1      TYPE t007s-text1,
          netpr      TYPE ekpo-netpr,
          peinh      TYPE ekpo-peinh,
          po_stat(7) TYPE c,

*          belnr      type bkpf-belnr,
          belnr(12)  TYPE c,
          gjahr      TYPE bkpf-gjahr,
*  MATNR TYPE EKPO-MATNR,
*  EBELN TYPE ekpo-ebeln,
*  EBELP TYPE ekpo-ebelp,
          txgrp      TYPE bseg-txgrp,
          hwste      TYPE bset-hwste,
          hwbas      TYPE bset-hwbas,
          rate(10)   TYPE c,
*     KTOSL(3) TYPE C,
*     MWSKZ TYPE BSET-MWSKZ,
          sgst       TYPE bset-hwste,
          cgst       TYPE bset-hwste,
          igst       TYPE bset-hwste,
          ugst       TYPE bset-hwste,
          othr       TYPE bset-hwste,
        END OF itab2.

TYPES : BEGIN OF itax1,
          mblnr  TYPE mseg-mblnr,
          mjahr  TYPE mseg-mjahr,
          belnr  TYPE bkpf-belnr,
          gjahr  TYPE bkpf-gjahr,
          matnr  TYPE ekpo-matnr,
          ebeln  TYPE ekpo-ebeln,
          ebelp  TYPE ekpo-ebelp,
          buzei  TYPE bset-buzei,
          buzei1 TYPE bset-buzei,
        END OF itax1.

TYPES : BEGIN OF itax2,
          mblnr    TYPE mseg-mblnr,
          mjahr    TYPE mseg-mjahr,
          belnr    TYPE bkpf-belnr,
          gjahr    TYPE bkpf-gjahr,
          matnr    TYPE ekpo-matnr,
          ebeln    TYPE ekpo-ebeln,
          ebelp    TYPE ekpo-ebelp,
          txgrp    TYPE bseg-txgrp,
          hwste    TYPE bset-hwste,
          hwbas    TYPE bset-hwbas,
          rate(10) TYPE c,
*     KTOSL(3) TYPE C,
*     MWSKZ TYPE BSET-MWSKZ,
          sgst     TYPE bset-hwste,
          cgst     TYPE bset-hwste,
          igst     TYPE bset-hwste,
          ugst     TYPE bset-hwste,
          othr     TYPE bset-hwste,
          buzei    TYPE bset-buzei,
        END OF itax2.

DATA : it_tab1 TYPE TABLE OF itab1,
       wa_tab1 TYPE itab1,
       it_tab2 TYPE TABLE OF itab2,
       wa_tab2 TYPE itab2,
       it_tax1 TYPE TABLE OF itax1,
       wa_tax1 TYPE itax1,
       it_tax2 TYPE TABLE OF itax2,
       wa_tax2 TYPE itax2,
       it_tax3 TYPE TABLE OF itax2,
       wa_tax3 TYPE itax2.

DATA : doc TYPE bkpf-awkey,
       tax TYPE bseg-dmbtr.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-000..

SELECT-OPTIONS : material FOR mseg-matnr,
                 plant FOR mseg-werks,
                 str_loc FOR mseg-lgort,
                 batch FOR mseg-charg,
                 mov FOR mseg-bwart,
                 type FOR mara-mtart,
                 vgart FOR mkpf-vgart.

SELECT-OPTIONS : s_budat FOR mkpf-budat OBLIGATORY.
*                 del FOR ekpo-emlif.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  g_repid = sy-repid.

*  AT SELECTION-SCREEN.
*  perform authorization.

*  AUTHORITY-CHECK OBJECT '/DSD/SL_WR'
*           ID 'WERKS' FIELD from_plt.
*
*  If sy-subrc ne 0.
*    MeSG = 'Check your entry'.
*    MESSAGE MESG TYPE 'E'.
*  endif.


START-OF-SELECTION.

  SELECT mblnr mjahr bldat budat xblnr bktxt FROM mkpf INTO TABLE it_mkpf WHERE vgart IN vgart AND budat IN s_budat.
  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  DELETE ADJACENT DUPLICATES FROM it_mkpf.

  IF it_mkpf IS NOT INITIAL.
    SELECT mblnr mjahr zeile bwart xauto matnr werks lgort charg lifnr kunnr shkzg dmbtr menge meins ebeln ebelp lfbja lfbnr emlif FROM mseg INTO TABLE
      it_mseg FOR ALL ENTRIES IN it_mkpf WHERE mblnr EQ it_mkpf-mblnr AND mjahr = it_mkpf-mjahr AND matnr IN material AND werks IN plant AND lgort
      IN str_loc AND charg IN batch AND bwart IN mov.
    IF sy-subrc EQ 0.
      SELECT * FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_mseg WHERE matnr EQ it_mseg-matnr AND mtart IN type.
      IF sy-subrc NE 0.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

  LOOP AT it_mseg INTO wa_mseg .
*    from sy-tabix.
    READ TABLE it_mkpf INTO wa_mkpf WITH KEY mblnr = wa_mseg-mblnr mjahr = wa_mseg-mjahr.
    IF sy-subrc EQ 0.
      READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_mseg-matnr.
      IF sy-subrc EQ 0.
*        write : '*', / wa_mseg-mblnr,wa_mseg-ebeln,wa_mseg-ebelp..
        wa_tab1-budat = wa_mkpf-budat.
        wa_tab1-bldat = wa_mkpf-bldat.
        wa_tab1-xblnr = wa_mkpf-xblnr.
        wa_tab1-bktxt = wa_mkpf-bktxt.
        wa_tab1-mblnr = wa_mseg-mblnr.
        wa_tab1-mjahr = wa_mseg-mjahr.
        wa_tab1-zeile = wa_mseg-zeile.
        wa_tab1-bwart = wa_mseg-bwart.
        wa_tab1-xauto = wa_mseg-xauto.
        wa_tab1-matnr = wa_mseg-matnr.
        wa_tab1-mtart = wa_mara-mtart.
        wa_tab1-spart = wa_mara-spart.
        wa_tab1-matkl = wa_mara-matkl.
*        SELECT SINGLE * FROM J_1IGRXREF WHERE MBLNR EQ WA_MSEG-MBLNR AND MJAHR EQ WA_MSEG-MJAHR AND ZEILE EQ
*          WA_MSEG-ZEILE.
*        IF SY-SUBRC EQ 0.
*          WA_TAB1-EXBED = J_1IGRXREF-EXBED.
*        ENDIF.
        SELECT SINGLE * FROM tspat WHERE spras EQ 'EN' AND spart EQ wa_mara-spart.
        IF sy-subrc EQ 0.
          wa_tab1-vtext = tspat-vtext.
        ENDIF.
        SELECT SINGLE * FROM t023t WHERE spras EQ 'EN' AND matkl EQ wa_mara-matkl.
        IF sy-subrc EQ 0.
          wa_tab1-wgbez = t023t-wgbez.
        ENDIF.
        IF wa_mseg-shkzg EQ 'H'.
          wa_mseg-dmbtr = wa_mseg-dmbtr * ( - 1 ).
          wa_mseg-menge = wa_mseg-menge * ( - 1 ).
        ENDIF.
        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_mseg-lifnr.
        IF sy-subrc EQ 0.
*              WRITE : lfa1-name1,lfa1-ort01.
          wa_tab1-name2 = lfa1-name1.
          wa_tab1-ort02 = lfa1-ort01.
        ENDIF.
        SELECT SINGLE * FROM makt WHERE matnr EQ wa_mseg-matnr AND spras EQ 'EN'.
        IF sy-subrc EQ 0.
          wa_tab1-maktx = makt-maktx.
        ENDIF.
        wa_tab1-werks = wa_mseg-werks.
        wa_tab1-lgort = wa_mseg-lgort.
        wa_tab1-charg = wa_mseg-charg.
        wa_tab1-lifnr = wa_mseg-lifnr.
        wa_tab1-kunnr = wa_mseg-kunnr.
        wa_tab1-shkzg = wa_mseg-shkzg.
        wa_tab1-dmbtr = wa_mseg-dmbtr.
        wa_tab1-menge = wa_mseg-menge.
        wa_tab1-meins = wa_mseg-meins.
        wa_tab1-ebeln = wa_mseg-ebeln.
        wa_tab1-ebelp = wa_mseg-ebelp.
        wa_tab1-lfbnr = wa_mseg-lfbnr.
*        WA_TAB1-LFPOS = WA_MSEG-LFPOS.
        wa_tab1-lfbja = wa_mseg-lfbja.

        SELECT SINGLE * FROM ekpo WHERE ebeln EQ wa_mseg-ebeln AND ebelp EQ wa_mseg-ebelp .
*        AND emlif in del.
        IF sy-subrc EQ 0.
          IF ekpo-loekz NE ' '.
            wa_tab1-po_stat = 'DELETED'.
          ENDIF.


          wa_tab1-emlif = ekpo-emlif.
          wa_tab1-mwskz = ekpo-mwskz.
          wa_tab1-netpr = ekpo-netpr.
          wa_tab1-peinh = ekpo-peinh.
          SELECT SINGLE * FROM t007s WHERE spras EQ 'EN' AND kalsm EQ 'TAXINN' AND mwskz EQ ekpo-mwskz.
          IF sy-subrc EQ 0..
            wa_tab1-text1 = t007s-text1.
          ELSE.
            SELECT SINGLE * FROM t007s WHERE spras EQ 'EN' AND mwskz EQ ekpo-mwskz.
            IF sy-subrc EQ 0..
              wa_tab1-text1 = t007s-text1.
            ENDIF.
          ENDIF.
          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ ekpo-emlif.
          IF sy-subrc EQ 0.
*              WRITE : lfa1-name1,lfa1-ort01.
            wa_tab1-name1 = lfa1-name1.
            wa_tab1-ort01 = lfa1-ort01.
          ENDIF.
        ENDIF.

        COLLECT wa_tab1 INTO it_tab1.
        CLEAR wa_tab1.
      ENDIF.
    ENDIF.
  ENDLOOP.

  PERFORM tax.

*  LOOP AT IT_TAX3 INTO WA_TAX3.
*
*  ENDLOOP.


  LOOP AT it_tab1 INTO wa_tab1.
*    WRITE : /  WA_TAB1-MBLNR,WA_TAB1-MATNR.
    READ TABLE it_tax3 INTO wa_tax3 WITH KEY mblnr = wa_tab1-mblnr mjahr = wa_tab1-mjahr ebeln = wa_tab1-ebeln  ebelp = wa_tab1-ebelp
   matnr = wa_tab1-matnr buzei = wa_tab1-zeile.
    IF sy-subrc EQ 4.

*      LOOP AT it_tax3 INTO wa_tax3 WHERE mblnr = wa_tab1-mblnr AND mjahr = wa_tab1-mjahr AND ebeln = wa_tab1-ebeln  AND ebelp = wa_tab1-ebelp
*        AND matnr = wa_tab1-matnr AND buzei = wa_tab1-zeile.
       LOOP AT it_tax3 INTO wa_tax3 WHERE mblnr = wa_tab1-mblnr AND mjahr = wa_tab1-mjahr AND ebeln = wa_tab1-ebeln  AND ebelp = wa_tab1-ebelp
        AND matnr = wa_tab1-matnr .
*    IF sy-subrc EQ 0.
*
*      WRITE : / WA_TAX3-BELNR.
        wa_tab2-belnr = wa_tax3-belnr.
        wa_tab2-gjahr = wa_tax3-gjahr.
        wa_tab2-hwbas = wa_tax3-hwbas.
        wa_tab2-hwste = wa_tax3-hwste.
        wa_tab2-rate = wa_tax3-rate.
        wa_tab2-igst = wa_tax3-igst.
        wa_tab2-cgst = wa_tax3-cgst.
        wa_tab2-sgst = wa_tax3-sgst.
        wa_tab2-ugst = wa_tax3-ugst.
        wa_tab2-txgrp = wa_tax3-txgrp.

        wa_tab2-bktxt = wa_tab1-bktxt.
        wa_tab2-mblnr = wa_tab1-mblnr.
        wa_tab2-mjahr = wa_tab1-mjahr.
        wa_tab2-bldat = wa_tab1-bldat.
        wa_tab2-budat = wa_tab1-budat.
        wa_tab2-zeile = wa_tab1-zeile.
        wa_tab2-bwart = wa_tab1-bwart.
        wa_tab2-xauto = wa_tab1-xauto.
        wa_tab2-mtart = wa_tab1-mtart.
        wa_tab2-matnr = wa_tab1-matnr.
        wa_tab2-maktx = wa_tab1-maktx.
        wa_tab2-werks = wa_tab1-werks.
        wa_tab2-lgort = wa_tab1-lgort.
        wa_tab2-charg = wa_tab1-charg.
        wa_tab2-lifnr = wa_tab1-lifnr.
*            WA_TAB2-NAME = WA_TAB1-NAME.
*             WA_TAB2-ORT01 = WA_TAB1-ORT01.
        wa_tab2-kunnr = wa_tab1-kunnr.
        wa_tab2-dmbtr = wa_tab1-dmbtr.
        IF wa_tab2-HWSTE LT 0.
          WA_TAB2-MENGE = 0.
        ELSE.
        wa_tab2-menge = wa_tab1-menge.
        ENDIF.
        wa_tab2-meins = wa_tab1-meins.
        wa_tab2-exbed = wa_tab1-exbed.
        wa_tab2-ebeln = wa_tab1-ebeln.
        wa_tab2-ebelp = wa_tab1-ebelp.
        wa_tab2-po_stat = wa_tab1-po_stat.
        wa_tab2-netpr = wa_tab1-netpr.
        wa_tab2-peinh = wa_tab1-peinh.
        wa_tab2-mwskz = wa_tab1-mwskz.
        wa_tab2-text1 = wa_tab1-text1.
        wa_tab2-spart = wa_tab1-spart.
        wa_tab2-vtext = wa_tab1-vtext.
        wa_tab2-matkl = wa_tab1-matkl.
        wa_tab2-wgbez = wa_tab1-wgbez.
        wa_tab2-xblnr = wa_tab1-xblnr.
        wa_tab2-emlif = wa_tab1-emlif.
        wa_tab2-name1 = wa_tab1-name1.
        wa_tab2-ort01 = wa_tab1-ort01.
        COLLECT wa_tab2 INTO it_tab2.
        CLEAR wa_tab2.
      ENDLOOP.
    ELSE.
      LOOP AT it_tax3 INTO wa_tax3 WHERE mblnr = wa_tab1-mblnr AND mjahr = wa_tab1-mjahr AND ebeln = wa_tab1-ebeln AND  ebelp = wa_tab1-ebelp
        AND  matnr = wa_tab1-matnr AND buzei = wa_tab1-zeile.
*    IF sy-subrc EQ 0.
*      READ TABLE it_tax3 INTO wa_tax3 WITH KEY mblnr = wa_tab1-mblnr mjahr = wa_tab1-mjahr ebeln = wa_tab1-ebeln  ebelp = wa_tab1-ebelp
*matnr = wa_tab1-matnr .
*BUZEI1 = WA_TAB1-ZEILE.
*      IF sy-subrc EQ 0.
*      WRITE : / WA_TAX3-BELNR.
        wa_tab2-belnr = wa_tax3-belnr.
        wa_tab2-gjahr = wa_tax3-gjahr.
        wa_tab2-hwbas = wa_tax3-hwbas.
        wa_tab2-hwste = wa_tax3-hwste.
        wa_tab2-rate = wa_tax3-rate.
        wa_tab2-igst = wa_tax3-igst.
        wa_tab2-cgst = wa_tax3-cgst.
        wa_tab2-sgst = wa_tax3-sgst.
        wa_tab2-ugst = wa_tax3-ugst.
        wa_tab2-txgrp = wa_tax3-txgrp.

        wa_tab2-bktxt = wa_tab1-bktxt.
        wa_tab2-mblnr = wa_tab1-mblnr.
        wa_tab2-mjahr = wa_tab1-mjahr.
        wa_tab2-bldat = wa_tab1-bldat.
        wa_tab2-budat = wa_tab1-budat.
        wa_tab2-zeile = wa_tab1-zeile.
        wa_tab2-bwart = wa_tab1-bwart.
        wa_tab2-xauto = wa_tab1-xauto.
        wa_tab2-mtart = wa_tab1-mtart.
        wa_tab2-matnr = wa_tab1-matnr.
        wa_tab2-maktx = wa_tab1-maktx.
        wa_tab2-werks = wa_tab1-werks.
        wa_tab2-lgort = wa_tab1-lgort.
        wa_tab2-charg = wa_tab1-charg.
        wa_tab2-lifnr = wa_tab1-lifnr.
*            WA_TAB2-NAME = WA_TAB1-NAME.
*             WA_TAB2-ORT01 = WA_TAB1-ORT01.
        wa_tab2-kunnr = wa_tab1-kunnr.
        wa_tab2-dmbtr = wa_tab1-dmbtr.
        IF WA_TAB2-HWSTE LT 0.
          WA_TAB2-MENGE = 0.
        ELSE.
        wa_tab2-menge = wa_tab1-menge.
        ENDIF.
        wa_tab2-meins = wa_tab1-meins.
        wa_tab2-exbed = wa_tab1-exbed.
        wa_tab2-ebeln = wa_tab1-ebeln.
        wa_tab2-ebelp = wa_tab1-ebelp.
        wa_tab2-po_stat = wa_tab1-po_stat.
        wa_tab2-netpr = wa_tab1-netpr.
        wa_tab2-peinh = wa_tab1-peinh.
        wa_tab2-mwskz = wa_tab1-mwskz.
        wa_tab2-text1 = wa_tab1-text1.
        wa_tab2-spart = wa_tab1-spart.
        wa_tab2-vtext = wa_tab1-vtext.
        wa_tab2-matkl = wa_tab1-matkl.
        wa_tab2-wgbez = wa_tab1-wgbez.
        wa_tab2-xblnr = wa_tab1-xblnr.
        wa_tab2-emlif = wa_tab1-emlif.
        wa_tab2-name1 = wa_tab1-name1.
        wa_tab2-ort01 = wa_tab1-ort01.
        COLLECT wa_tab2 INTO it_tab2.
        CLEAR wa_tab2.
      ENDLOOP.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tab1 INTO wa_tab1.
    READ TABLE it_tax3 INTO wa_tax3 WITH KEY  mblnr = wa_tab1-mblnr  mjahr = wa_tab1-mjahr  ebeln = wa_tab1-ebeln  ebelp = wa_tab1-ebelp
    matnr = wa_tab1-matnr.
    IF sy-subrc EQ 4.
      wa_tab2-belnr = ' '.
      wa_tab2-gjahr = ' '.
      wa_tab2-hwbas = 0.
      wa_tab2-hwste = 0.
      wa_tab2-rate = 0.
      wa_tab2-igst = 0.
      wa_tab2-cgst = 0.
      wa_tab2-sgst = 0.
      wa_tab2-ugst = 0.
      wa_tab2-txgrp = 0.

      wa_tab2-bktxt = wa_tab1-bktxt.
      wa_tab2-mblnr = wa_tab1-mblnr.
      wa_tab2-mjahr = wa_tab1-mjahr.
      wa_tab2-bldat = wa_tab1-bldat.
      wa_tab2-budat = wa_tab1-budat.
      wa_tab2-zeile = wa_tab1-zeile.
      wa_tab2-bwart = wa_tab1-bwart.
      wa_tab2-xauto = wa_tab1-xauto.
      wa_tab2-mtart = wa_tab1-mtart.
      wa_tab2-matnr = wa_tab1-matnr.
      wa_tab2-maktx = wa_tab1-maktx.
      wa_tab2-werks = wa_tab1-werks.
      wa_tab2-lgort = wa_tab1-lgort.
      wa_tab2-charg = wa_tab1-charg.
      wa_tab2-lifnr = wa_tab1-lifnr.
*            WA_TAB2-NAME = WA_TAB1-NAME.
*             WA_TAB2-ORT01 = WA_TAB1-ORT01.
      wa_tab2-kunnr = wa_tab1-kunnr.
      wa_tab2-dmbtr = wa_tab1-dmbtr.
      wa_tab2-menge = wa_tab1-menge.
      wa_tab2-meins = wa_tab1-meins.
      wa_tab2-exbed = wa_tab1-exbed.
      wa_tab2-ebeln = wa_tab1-ebeln.
      wa_tab2-ebelp = wa_tab1-ebelp.
      wa_tab2-po_stat = wa_tab1-po_stat.
      wa_tab2-netpr = wa_tab1-netpr.
      wa_tab2-peinh = wa_tab1-peinh.
      wa_tab2-mwskz = wa_tab1-mwskz.
      wa_tab2-text1 = wa_tab1-text1.
      wa_tab2-spart = wa_tab1-spart.
      wa_tab2-vtext = wa_tab1-vtext.
      wa_tab2-matkl = wa_tab1-matkl.
      wa_tab2-wgbez = wa_tab1-wgbez.
      wa_tab2-xblnr = wa_tab1-xblnr.
      wa_tab2-emlif = wa_tab1-emlif.
      wa_tab2-name1 = wa_tab1-name1.
      wa_tab2-ort01 = wa_tab1-ort01.
      COLLECT wa_tab2 INTO it_tab2.
      CLEAR wa_tab2.
    ENDIF.
  ENDLOOP.

  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO NO.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'EBELP'.
  wa_fieldcat-seltext_l = 'PO ITEM'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BKTXT'.
  wa_fieldcat-seltext_l = 'HEADER TEXT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MBLNR'.
  wa_fieldcat-seltext_l = 'DOC NO.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BLDAT'.
  wa_fieldcat-seltext_l = 'DOC DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BUDAT'.
  wa_fieldcat-seltext_l = 'POSTING DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'DMBTR'.
  wa_fieldcat-seltext_l = 'VALUE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MENGE'.
  wa_fieldcat-seltext_l = 'QUANTITY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BELNR'.
  wa_fieldcat-seltext_l = 'FI DOC'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'GJAHR'.
  wa_fieldcat-seltext_l = 'FI YEAR'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'HWBAS'.
  wa_fieldcat-seltext_l = 'GST TAXABLE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'HWSTE'.
  wa_fieldcat-seltext_l = 'GST TAX'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'RATE'.
  wa_fieldcat-seltext_l = 'GST RATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'IGST'.
  wa_fieldcat-seltext_l = 'IGST'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CGST'.
  wa_fieldcat-seltext_l = 'CGST'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'SGST'.
  wa_fieldcat-seltext_l = 'SGST'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'UGST'.
  wa_fieldcat-seltext_l = 'UGST'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MJAHR'.
  wa_fieldcat-seltext_l = 'DOC YEAR'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ZEILE'.
  wa_fieldcat-seltext_l = 'ITEM NO.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BWART'.
  wa_fieldcat-seltext_l = 'MOVEMENT TYPE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'XAUTO'.
  wa_fieldcat-seltext_l = 'XAUTO'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MTART'.
  wa_fieldcat-seltext_l = 'MATERIAL TYPE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'MATERIAL CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'DESCRIPTION'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'PLANT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'LGORT'.
  wa_fieldcat-seltext_l = 'STORAGE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'LIFNR'.
  wa_fieldcat-seltext_l = 'VENDOR'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'NAME2'.
  wa_fieldcat-seltext_l = 'VENDOR NAME'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ORT02'.
  wa_fieldcat-seltext_l = 'VENDOR CITY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'KUNNR'.
  wa_fieldcat-seltext_l = 'CUSTOMER CODE'.
  APPEND wa_fieldcat TO fieldcat.



  wa_fieldcat-fieldname = 'MEINS'.
  wa_fieldcat-seltext_l = 'UOM'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'EXBED'.
  wa_fieldcat-seltext_l = 'EXCISE DUTY'.
  APPEND wa_fieldcat TO fieldcat.



  wa_fieldcat-fieldname = 'PO_STAT'.
  wa_fieldcat-seltext_l = 'PO STATUS'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'NETPR'.
  wa_fieldcat-seltext_l = 'NET RATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'PEINH'.
  wa_fieldcat-seltext_l = 'RATE PER'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MWSKZ'.
  wa_fieldcat-seltext_l = 'TAX CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'TEXT1'.
  wa_fieldcat-seltext_l = 'TEXT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'SPART'.
  wa_fieldcat-seltext_l = 'DIV'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'VTEXT'.
  wa_fieldcat-seltext_l = 'DIVISION'.
  APPEND wa_fieldcat TO fieldcat.


  wa_fieldcat-fieldname = 'MATKL'.
  wa_fieldcat-seltext_l = 'GROUP'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'WGBEZ'.
  wa_fieldcat-seltext_l = 'GROUP NAME'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'XBLNR'.
  wa_fieldcat-seltext_l = 'REFERANCE'.
  APPEND wa_fieldcat TO fieldcat.

*  WA_FIELDCAT-fieldname = 'LFBJA'.
*  WA_FIELDCAT-seltext_L = 'REF. YEAR'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'EMLIF'.
  wa_fieldcat-seltext_l = 'DEL. CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'DELIVERY ADDR.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ORT01'.
  wa_fieldcat-seltext_l = 'CITY'.
  APPEND wa_fieldcat TO fieldcat.






  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'DOCUMENT DETAILS WITH DELIVERY ADDRESS'.


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
      t_outtab                = it_tab2
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
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
  wa_comment-info = 'DOCUMENT DETAILS'.
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
    WHEN 'VBELN'.
      SET PARAMETER ID 'VF' FIELD selfield-value.
      CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
    WHEN 'MATNR'.
      SET PARAMETER ID 'MAT' FIELD selfield-value.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Form  TAX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM tax .

  IF it_tab1 IS NOT INITIAL.
    SELECT * FROM rseg INTO TABLE it_rseg FOR ALL ENTRIES IN it_tab1 WHERE  ebeln EQ it_tab1-ebeln AND
       ebelp EQ it_tab1-ebelp  AND matnr EQ it_tab1-matnr AND lfbnr EQ it_tab1-mblnr .
  ENDIF.

  LOOP AT it_rseg INTO wa_rseg.
    CLEAR doc.
    LOOP AT it_tab1 INTO wa_tab1 WHERE mblnr = wa_rseg-lfbnr AND mjahr = wa_rseg-lfgja.
*    IF SY-SUBRC EQ 0.
      wa_tax1-mblnr = wa_rseg-lfbnr.
      wa_tax1-buzei = wa_rseg-lfpos.
      wa_tax1-buzei1 = wa_rseg-buzei.
      wa_tax1-mjahr = wa_rseg-lfgja.
      CONCATENATE wa_rseg-belnr  wa_rseg-gjahr INTO doc.
      SELECT SINGLE * FROM bkpf WHERE bukrs EQ 'BCLL' AND gjahr EQ wa_rseg-gjahr AND awkey EQ doc.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM rbkp WHERE belnr EQ wa_rseg-belnr AND gjahr EQ wa_rseg-gjahr AND stblg EQ space.
        IF sy-subrc EQ 0.
          wa_tax1-belnr = bkpf-belnr.
          wa_tax1-gjahr = bkpf-gjahr.
        ENDIF.
      ENDIF.
*    READ TABLE IT_TAB1 INTO WA_TAB1 WITH KEY MBLNR = WA_RSEG-LFBNR MJAHR = WA_RSEG-LFGJA.
*    IF SY-SUBRC EQ 0.
      wa_tax1-ebeln = wa_tab1-ebeln.
      wa_tax1-ebelp = wa_tab1-ebelp.
      wa_tax1-matnr = wa_tab1-matnr.
*    ENDIF.
      COLLECT wa_tax1 INTO it_tax1.
      CLEAR wa_tax1.
    ENDLOOP.
  ENDLOOP.


  IF it_tax1 IS NOT INITIAL.
    SELECT * FROM bseg INTO TABLE it_bseg FOR ALL ENTRIES IN it_tax1 WHERE bukrs EQ 'BCLL' AND belnr
      EQ it_tax1-belnr AND gjahr EQ it_tax1-gjahr AND ebeln EQ it_tax1-ebeln AND ebelp EQ it_tax1-ebelp AND
      matnr EQ it_tax1-matnr.
    IF sy-subrc EQ 0.
      SELECT * FROM bset INTO TABLE it_bset FOR ALL ENTRIES IN it_bseg WHERE bukrs EQ 'BCLL' AND belnr EQ
        it_bseg-belnr AND gjahr EQ it_bseg-gjahr AND txgrp EQ it_bseg-txgrp.
    ENDIF.
  ENDIF.
*  LOOP AT IT_TAX1 INTO WA_TAX1.
*    WRITE : / '1',WA_TAX1-MBLNR,WA_TAX1-BUZEI.
*  ENDLOOP.

  LOOP AT it_bset INTO wa_bset.
*   READ TABLE IT_BSEG INTO WA_BSEG WITH KEY BELNR = WA_BSET-BELNR GJAHR = WA_BSET-GJAHR TXGRP = WA_BSET-TXGRP.
*   IF SY-SUBRC EQ 0.
*    BREAK-POINT.
**************************************************************
    READ TABLE it_bseg INTO wa_bseg WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr  txgrp = wa_bset-txgrp buzid = 'W'.
    IF sy-subrc EQ 4.
*      BREAK-POINT.
      LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND txgrp = wa_bset-txgrp AND buzid EQ 'M'.
*     LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND txgrp = wa_bset-txgrp AND mwart eq 'V'.
*   IF SY-SUBRC EQ 0.

*      WRITE : / 'A',WA_BSET-BELNR,WA_BSET-TXGRP.
        wa_tax2-ebeln = wa_bseg-ebeln.
        wa_tax2-ebelp = wa_bseg-ebelp.
        wa_tax2-belnr = wa_bset-belnr.
        wa_tax2-gjahr = wa_bset-gjahr.
        wa_tax2-txgrp = wa_bset-txgrp.
        READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln
        ebelp = wa_bseg-ebelp buzei = wa_bset-buzei.
        IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
          wa_tax2-mblnr = wa_tax1-mblnr.
          wa_tax2-buzei = wa_tax1-buzei.
          wa_tax2-mjahr = wa_tax1-mjahr.
          wa_tax2-matnr = wa_tax1-matnr.
          DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei = wa_bset-buzei.
        ELSE.
          READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp buzei1 = wa_bset-buzei.
          IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
            wa_tax2-mblnr = wa_tax1-mblnr.
            wa_tax2-buzei = wa_tax1-buzei.
            wa_tax2-mjahr = wa_tax1-mjahr.
            wa_tax2-matnr = wa_tax1-matnr.
            DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei1 = wa_bset-buzei.
          ELSE.
            READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp.
            IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
              wa_tax2-mblnr = wa_tax1-mblnr.
              wa_tax2-buzei = wa_tax1-buzei.
              wa_tax2-mjahr = wa_tax1-mjahr.
              wa_tax2-matnr = wa_tax1-matnr.
              DELETE it_tax1 WHERE mblnr EQ wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp.
            ENDIF.

          ENDIF.

        ENDIF.
*     WA_TAX2-MWSKZ = WA_BSET-MWSKZ.
        IF wa_bset-shkzg EQ 'H'.
          wa_bset-hwste = wa_bset-hwste * ( - 1 ).
          wa_bset-hwbas = wa_bset-hwbas * ( - 1 ).
        ENDIF.

        IF wa_bset-ktosl EQ 'JII' OR wa_bset-ktosl EQ 'JOI' OR wa_bset-ktosl EQ 'JIM'.
          wa_tax2-igst = wa_bset-hwste.
          wa_tax2-hwste = wa_bset-hwste.
        ELSE.
          wa_tax2-hwste = wa_bset-hwste * 2.
          IF wa_bset-ktosl EQ 'JIC'.
            wa_tax2-cgst = wa_bset-hwste.
*        endif.
*        if wa_bset-ktosl eq 'JIS'.
            READ TABLE it_bset INTO wa_bset WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr txgrp = wa_bset-txgrp ktosl = 'JIS'.
            IF sy-subrc EQ 0.
              wa_tax2-sgst = wa_bset-hwste.
            ENDIF.
            READ TABLE it_bset INTO wa_bset WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr txgrp = wa_bset-txgrp ktosl = 'JIU'.
            IF sy-subrc EQ 0.
              wa_tax2-ugst = wa_bset-hwste.
            ENDIF.
          ENDIF.
*       WA_TAX2-OTHR = WA_BSET-HWSTE.
        ENDIF.
*     ENDIF.
        IF wa_bset-ktosl EQ 'JII' OR wa_bset-ktosl EQ 'JRI' OR wa_bset-ktosl EQ 'JOI' OR wa_bset-ktosl EQ 'JIM'.
          wa_tax2-rate = ( wa_bset-kbetr / 10 ).
*     ELSEIF WA_BSET-KTOSL EQ 'NVV'.
*      WA_TAX2-RATE = ( WA_BSET-KBETR / 10 ).
        ELSE.
          wa_tax2-rate = ( wa_bset-kbetr / 10 ) * 2.
        ENDIF.
*     WA_TAX1-KTOSL = WA_BSET-KTOSL.
        IF wa_bset-ktosl EQ 'JII'.
          wa_tax2-hwbas = wa_bset-hwbas.
        ELSEIF wa_bset-ktosl EQ 'JIC' OR wa_bset-ktosl EQ 'JIS'.
          wa_tax2-hwbas = wa_bset-hwbas.
        ELSEIF wa_bset-ktosl EQ 'JRC'.
*     WA_TAX1-HWBAS = WA_BSET-HWBAS.
        ELSEIF wa_bset-ktosl EQ 'JOI'.
          wa_tax2-hwbas = wa_bset-hwbas.
        ELSEIF wa_bset-ktosl EQ 'JIM'.
          wa_tax2-hwbas = wa_bset-hwbas.
*     ELSEIF WA_BSET-KTOSL EQ 'NVV'.
*     WA_TAX2-HWBAS = WA_BSET-HWBAS.
        ENDIF.
        COLLECT wa_tax2 INTO it_tax2.
        CLEAR wa_tax2.
*    ENDIF.
*    ENDIF.
************************************************************************************************************
      ENDLOOP.

    ELSE.
      LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND txgrp = wa_bset-txgrp AND buzid EQ 'W'.
*     LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND txgrp = wa_bset-txgrp AND mwart eq 'V'.
*   IF SY-SUBRC EQ 0.

*      WRITE : / 'A',WA_BSET-BELNR,WA_BSET-TXGRP.
        wa_tax2-ebeln = wa_bseg-ebeln.
        wa_tax2-ebelp = wa_bseg-ebelp.
        wa_tax2-belnr = wa_bset-belnr.
        wa_tax2-gjahr = wa_bset-gjahr.
        wa_tax2-txgrp = wa_bset-txgrp.
        READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln
        ebelp = wa_bseg-ebelp buzei = wa_bset-buzei.
        IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
          wa_tax2-mblnr = wa_tax1-mblnr.
          wa_tax2-buzei = wa_tax1-buzei.
          wa_tax2-mjahr = wa_tax1-mjahr.
          wa_tax2-matnr = wa_tax1-matnr.
          DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei = wa_bset-buzei.
        ELSE.
          READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp buzei1 = wa_bset-buzei.
          IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
            wa_tax2-mblnr = wa_tax1-mblnr.
            wa_tax2-buzei = wa_tax1-buzei.
            wa_tax2-mjahr = wa_tax1-mjahr.
            wa_tax2-matnr = wa_tax1-matnr.
            DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei1 = wa_bset-buzei.
          ELSE.
            READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp.
            IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
              wa_tax2-mblnr = wa_tax1-mblnr.
              wa_tax2-buzei = wa_tax1-buzei.
              wa_tax2-mjahr = wa_tax1-mjahr.
              wa_tax2-matnr = wa_tax1-matnr.
              DELETE it_tax1 WHERE mblnr EQ wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp.
            ENDIF.

          ENDIF.

        ENDIF.
*     WA_TAX2-MWSKZ = WA_BSET-MWSKZ.
        IF wa_bset-shkzg EQ 'H'.
          wa_bset-hwste = wa_bset-hwste * ( - 1 ).
          wa_bset-hwbas = wa_bset-hwbas * ( - 1 ).
        ENDIF.

        IF wa_bset-ktosl EQ 'JII' OR wa_bset-ktosl EQ 'JOI' OR wa_bset-ktosl EQ 'JIM'.
          wa_tax2-igst = wa_bset-hwste.
          wa_tax2-hwste = wa_bset-hwste.
        ELSE.
          wa_tax2-hwste = wa_bset-hwste * 2.
          IF wa_bset-ktosl EQ 'JIC'.
            wa_tax2-cgst = wa_bset-hwste.
*        endif.
*        if wa_bset-ktosl eq 'JIS'.
            READ TABLE it_bset INTO wa_bset WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr txgrp = wa_bset-txgrp ktosl = 'JIS'.
            IF sy-subrc EQ 0.
              wa_tax2-sgst = wa_bset-hwste.
            ENDIF.
            READ TABLE it_bset INTO wa_bset WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr txgrp = wa_bset-txgrp ktosl = 'JIU'.
            IF sy-subrc EQ 0.
              wa_tax2-ugst = wa_bset-hwste.
            ENDIF.
          ENDIF.
*       WA_TAX2-OTHR = WA_BSET-HWSTE.
        ENDIF.
*     ENDIF.
        IF wa_bset-ktosl EQ 'JII' OR wa_bset-ktosl EQ 'JRI' OR wa_bset-ktosl EQ 'JOI' OR wa_bset-ktosl EQ 'JIM'.
          wa_tax2-rate = ( wa_bset-kbetr / 10 ).
*     ELSEIF WA_BSET-KTOSL EQ 'NVV'.
*      WA_TAX2-RATE = ( WA_BSET-KBETR / 10 ).
        ELSE.
          wa_tax2-rate = ( wa_bset-kbetr / 10 ) * 2.
        ENDIF.
*     WA_TAX1-KTOSL = WA_BSET-KTOSL.
        IF wa_bset-ktosl EQ 'JII'.
          wa_tax2-hwbas = wa_bset-hwbas.
        ELSEIF wa_bset-ktosl EQ 'JIC' OR wa_bset-ktosl EQ 'JIS'.
          wa_tax2-hwbas = wa_bset-hwbas.
        ELSEIF wa_bset-ktosl EQ 'JRC'.
*     WA_TAX1-HWBAS = WA_BSET-HWBAS.
        ELSEIF wa_bset-ktosl EQ 'JOI'.
          wa_tax2-hwbas = wa_bset-hwbas.
        ELSEIF wa_bset-ktosl EQ 'JIM'.
          wa_tax2-hwbas = wa_bset-hwbas.
*     ELSEIF WA_BSET-KTOSL EQ 'NVV'.
*     WA_TAX2-HWBAS = WA_BSET-HWBAS.
        ENDIF.
        COLLECT wa_tax2 INTO it_tax2.
        CLEAR wa_tax2.
*    ENDIF.
*    ENDIF.
************************************************************************************************************
      ENDLOOP.
    ENDIF.
  ENDLOOP.
*  BREAK-POINT.
  LOOP AT it_tax2 INTO wa_tax2.
    CLEAR : tax.
    tax = wa_tax2-igst + wa_tax2-cgst.
*    IF tax GT 0.
    IF tax NE 0.
      wa_tax3-mblnr = wa_tax2-mblnr.
      wa_tax3-buzei = wa_tax2-buzei.
      wa_tax3-mjahr = wa_tax2-mjahr.
      wa_tax3-matnr = wa_tax2-matnr.
      wa_tax3-txgrp = wa_tax2-txgrp.
      wa_tax3-belnr = wa_tax2-belnr.
      wa_tax3-gjahr = wa_tax2-gjahr.
      wa_tax3-txgrp = wa_tax2-txgrp.
      wa_tax3-hwbas = wa_tax2-hwbas.
      wa_tax3-hwste = wa_tax2-hwste.
      wa_tax3-igst = wa_tax2-igst.
      wa_tax3-cgst = wa_tax2-cgst.
      wa_tax3-sgst = wa_tax2-sgst.
      wa_tax3-ugst = wa_tax2-ugst.
      wa_tax3-rate = wa_tax2-rate.
      wa_tax3-ebeln = wa_tax2-ebeln.
      wa_tax3-ebelp = wa_tax2-ebelp.
      COLLECT wa_tax3 INTO it_tax3.
      CLEAR wa_tax3.
    ENDIF.
  ENDLOOP.

*LOOP AT IT_TAX3 INTO WA_TAX3.
*  WRITE : / 'A',WA_TAX3-MBLNR,WA_TAX3-MJAHR,WA_TAX3-BELNR,WA_TAX3-GJAHR,WA_TAX3-MATNR,
*  WA_TAX3-EBELN,WA_TAX3-EBELP,WA_TAX3-HWBAS,WA_TAX3-HWSTE,WA_TAX3-RATE,WA_TAX3-IGST,WA_TAX3-CGST,
*  WA_TAX3-SGST,WA_TAX3-UGST.
*ENDLOOP.

ENDFORM.
