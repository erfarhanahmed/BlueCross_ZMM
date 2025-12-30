REPORT zqassurance_prt2 .
* CHANGES DONE BY ANJALI, INTRODUCTION  OF GIN NO.
* changes done by anjali , format as per JSG's suggestion as on 2nd *
*  feb'05.


TABLES: mkpf   , mseg , qals , mara , ekko , mcha , j_1ipart1 , j_1iexchdr
 , t001l , lfa1 , t009c, zpms_art_table, makt, zmigo,
 t001w,jest,zpo_matnr,ekpo,
 ekpa, zpassw,pa0002.

DATA : material(100) TYPE c.
DATA: maktx1(40) TYPE c,
      maktx2(40) TYPE c,
      maktx(81)  TYPE c.

DATA: o_encryptor        TYPE REF TO cl_hard_wired_encryptor,
      o_cx_encrypt_error TYPE REF TO cx_encrypt_error.
DATA:
*      v_ac_xstring type xstring,
  v_en_string TYPE string,
*      v_en_xstring type xstring,
  v_de_string TYPE string,
*      v_de_xstring type string,
  v_error_msg TYPE string.
DATA:  uname(40) TYPE c.

SELECTION-SCREEN BEGIN OF BLOCK merkmale2 WITH FRAME TITLE TEXT-002.
  PARAMETERS : pernr    TYPE pa0001-pernr,
               pass(10) TYPE c.
*PARAMETERS : phynr LIKE qprs-phynr.
SELECTION-SCREEN END OF BLOCK merkmale2 .

SELECTION-SCREEN BEGIN OF BLOCK input WITH FRAME TITLE TEXT-001 .

  PARAMETERS : p1 AS CHECKBOX.


  SELECT-OPTIONS : s_mblnr FOR mseg-mblnr OBLIGATORY,
                   s_lgort FOR mseg-lgort OBLIGATORY.
  PARAMETERS : p_mjahr LIKE mseg-mjahr OBLIGATORY,
               p_werks LIKE mseg-werks OBLIGATORY.

*PARAMETERS : R1 RADIOBUTTON GROUP R1,
*             R2 RADIOBUTTON GROUP R1.


SELECTION-SCREEN END OF BLOCK input.

TYPES : BEGIN OF itab1,
          matnr  TYPE mseg-matnr,
          mblnr  TYPE mseg-mblnr,
          mjahr  TYPE mseg-mjahr,
          charg  TYPE mseg-charg,
          lgort  TYPE mseg-lgort,
          werks  TYPE mseg-werks,
          lifnr  TYPE mseg-lifnr,
          ebeln  TYPE mseg-ebeln,
          menge  TYPE mseg-menge,
          meins  TYPE mseg-meins,
          ablad  TYPE mseg-ablad,
          sgtxt  TYPE mseg-sgtxt,
          pms    TYPE zpms_art_table-pms_no,
          art_no TYPE zpms_art_table-art_no,
          mtart  TYPE mara-mtart,
          name1  TYPE lfa1-name1,
          normt  TYPE mara-normt,
        END OF itab1.

DATA : it_qals  TYPE TABLE OF qals,
       wa_qals  TYPE qals,
       it_qals1 TYPE TABLE OF qals,
       wa_qals1 TYPE qals,
       it_mseg  TYPE TABLE OF mseg,
       wa_mseg  TYPE mseg,
       it_tab1  TYPE TABLE OF itab1,
       wa_tab1  TYPE itab1.

DATA : w_sgtxt TYPE mseg-sgtxt.
DATA : mfgdt TYPE sy-datum,
       bsart TYPE ekko-bsart.

DATA : BEGIN OF t_mseg OCCURS 10 .
         INCLUDE STRUCTURE mseg.
DATA : END OF t_mseg  .
DATA : tmfg-dt(10) TYPE c,
       texp-dt(10) TYPE c.
DATA : prueflos TYPE qals-prueflos.
DATA: licha(25) TYPE c.
DATA : BEGIN OF ritext1 OCCURS 0.
         INCLUDE STRUCTURE tline.
DATA : END OF ritext1.

DATA : ln TYPE i.
DATA : ln1 TYPE i.
DATA : nolines TYPE i.
DATA: w_itext3(135) TYPE c,
      r11(1200)     TYPE c,
      r12(1200)     TYPE c.
DATA: rtdname1 LIKE stxh-tdname.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK screen-name EQ 'PASS'.
    screen-invisible = 1.
    MODIFY SCREEN.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM pass.

  CLEAR : uname.
  SELECT SINGLE * FROM pa0002 WHERE pernr EQ pernr AND endda GE sy-datum.
  IF sy-subrc EQ 0.
    CONCATENATE pa0002-vorna pa0002-nachn INTO uname SEPARATED BY space.
  ENDIF.

  mfgdt+6(2) = '14'.
  mfgdt+4(2) = '07'.
  mfgdt+0(4) = '2020'.

  IF p1 EQ 'X'.

    SELECT * FROM mseg INTO TABLE t_mseg WHERE mblnr IN s_mblnr AND mjahr = p_mjahr  AND werks = p_werks  AND lgort IN s_lgort
    AND xauto EQ 'X' AND bwart IN ('101','322','309','349').  "309 mov added on 2.10.20, 349 added on 21 5.21
  ELSE.

    SELECT * FROM mseg INTO TABLE t_mseg WHERE mblnr IN s_mblnr AND mjahr = p_mjahr  AND werks = p_werks  AND lgort IN s_lgort
      AND xauto NE 'X' AND bwart IN ('101','322','309').



  ENDIF.

  IF sy-subrc <> 0 .
    WRITE :/'No Data Found corresponding to the selection criteria.' .
  ENDIF.
*sort t_mseg DESCENDING by zeile.
*delete ADJACENT DUPLICATES FROM t_mseg COMPARING mblnr mjahr.
  DATA : ch1 TYPE i VALUE 0.


  LOOP AT t_mseg.
    IF t_mseg-ummat NE '   '.
      wa_tab1-matnr = t_mseg-ummat.
    ELSE.
      wa_tab1-matnr = t_mseg-matnr.
    ENDIF.
    wa_tab1-mblnr = t_mseg-mblnr.
    wa_tab1-mjahr = t_mseg-mjahr.
    wa_tab1-charg = t_mseg-charg.
    wa_tab1-lgort = t_mseg-lgort.
    wa_tab1-werks = t_mseg-werks.
    wa_tab1-lifnr = t_mseg-lifnr.
    IF wa_tab1-lifnr NE space.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_tab1-lifnr.
      IF sy-subrc EQ 0.
        wa_tab1-name1 = lfa1-name1.
      ENDIF.
    ENDIF.

    IF wa_tab1-lifnr EQ '          '.
*      SELECT SINGLE * FROM QALS WHERE MATNR EQ WA_TAB1-MATNR AND CHARG EQ WA_TAB1-CHARG AND SELLIFNR NE '          '.
*      IF SY-SUBRC EQ 0.
*        WA_TAB1-LIFNR = QALS-SELLIFNR.
*      ENDIF.
      SELECT SINGLE * FROM ekko WHERE ebeln EQ t_mseg-ebeln AND bsart EQ 'ZUB'.
      IF sy-subrc EQ 0.
        wa_tab1-lifnr = ekko-reswk.
        SELECT SINGLE * FROM t001w WHERE werks EQ ekko-reswk.
        IF sy-subrc EQ 0.
          wa_tab1-name1 = t001w-name1.
        ENDIF.
      ENDIF.
    ENDIF.
    wa_tab1-ebeln = t_mseg-ebeln.
    IF t_mseg-mblnr EQ '5000376551'.  "11.6.21
      wa_tab1-menge = '200'.
      wa_tab1-ablad = '40X5 L'.
    ELSE.
      wa_tab1-menge = t_mseg-menge.
      wa_tab1-ablad = t_mseg-ablad.
    ENDIF.
*    WA_TAB1-MENGE = T_MSEG-MENGE.
    wa_tab1-meins = t_mseg-meins.
*    WA_TAB1-ABLAD = T_MSEG-ABLAD.
*    WA_TAB1-SGTXT = T_MSEG-SGTXT.
*************************************************
*    BREAK-POINT. 14.7.20
    SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab1-matnr AND mtart EQ 'ZROH'.
    IF sy-subrc EQ 0.
      wa_tab1-normt = mara-normt.
      SELECT SINGLE * FROM mkpf WHERE mblnr EQ t_mseg-mblnr AND mjahr EQ t_mseg-mjahr.
      IF sy-subrc EQ 0.
        CLEAR : bsart.
        SELECT SINGLE * FROM ekko WHERE ebeln EQ t_mseg-ebeln.
        IF sy-subrc EQ 0.
          bsart = ekko-bsart.
        ENDIF.
        IF ( mkpf-budat GE mfgdt ) AND ( bsart EQ 'ZL' OR bsart EQ 'ZI' OR bsart EQ 'ZUB' ).
          SELECT SINGLE * FROM zmigo WHERE mblnr EQ t_mseg-mblnr AND zeile EQ t_mseg-zeile.
          IF sy-subrc EQ 0.
            SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
            IF sy-subrc EQ 0.
              wa_tab1-sgtxt = lfa1-name1.  "25.4.20
            ENDIF.
*                ELSE.
*                  SGTXT = LFA1-NAME1.  "25.4.20
          ELSE.
*****************************************
            SELECT SINGLE * FROM qals WHERE art EQ '01' AND charg EQ wa_tab1-charg AND lifnr NE space.
            IF sy-subrc EQ 0.
              CLEAR : prueflos.
              prueflos = qals-prueflos.

              SELECT SINGLE * FROM jest WHERE objnr EQ qals-objnr AND stat EQ 'I0224'.
              IF sy-subrc EQ 4.
                SELECT SINGLE * FROM zmigo WHERE mblnr EQ qals-mblnr AND zeile EQ t_mseg-zeile.
                IF sy-subrc EQ 0.
                  SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
                  IF sy-subrc EQ 0.
                    wa_tab1-sgtxt = lfa1-name1.  "25.4.20
                  ENDIF.
                ENDIF.

*                SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ QALS-LIFNR.
*                IF SY-SUBRC EQ 0.
*                  WA_TAB1-SGTXT = LFA1-NAME1.  "15.1.21
*                ENDIF.
              ELSE.
********************************
                SELECT SINGLE * FROM qals WHERE prueflos NE prueflos AND art EQ '01' AND charg EQ wa_tab1-charg AND lifnr NE space.
                IF sy-subrc EQ 0.
                  SELECT SINGLE * FROM zmigo WHERE mblnr EQ qals-mblnr AND zeile EQ t_mseg-zeile.
                  IF sy-subrc EQ 0.
                    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
                    IF sy-subrc EQ 0.
                      wa_tab1-sgtxt = lfa1-name1.  "25.4.20
                    ENDIF.
                  ENDIF.
*                  SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ QALS-LIFNR.
*                  IF SY-SUBRC EQ 0.
*                    WA_TAB1-SGTXT = LFA1-NAME1.  "15.1.21
*                  ENDIF.
                ENDIF.
*************************************
              ENDIF.
            ENDIF.

***********************************************
          ENDIF.

        ELSE.
          wa_tab1-sgtxt = t_mseg-sgtxt.
        ENDIF.
      ENDIF.
    ELSE.
      wa_tab1-sgtxt = t_mseg-sgtxt.
    ENDIF.

    IF wa_tab1-sgtxt EQ space.
      wa_tab1-sgtxt = t_mseg-sgtxt.
    ENDIF.
*****************************************************************

    SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab1-matnr AND mtart EQ 'ZVRP'.
    IF sy-subrc EQ 0.
      wa_tab1-mtart = mara-mtart.
      SELECT SINGLE * FROM zpms_art_table WHERE matnr EQ wa_tab1-matnr AND from_dt LE sy-datum AND to_dt GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab1-pms = zpms_art_table-pms_no.
        wa_tab1-art_no = zpms_art_table-art_no.
      ENDIF.
    ENDIF.

***********************vendor batch*******************

**********************************************

    COLLECT wa_tab1 INTO it_tab1.
    CLEAR wa_tab1.
  ENDLOOP.

  IF it_tab1 IS NOT INITIAL.
    SELECT * FROM qals INTO TABLE it_qals FOR ALL ENTRIES IN it_tab1 WHERE matnr = it_tab1-matnr AND werk = it_tab1-werks
      AND charg = it_tab1-charg AND lagortchrg = it_tab1-lgort AND mblnr NE space.
    SELECT * FROM qals INTO TABLE it_qals1 FOR ALL ENTRIES IN it_tab1 WHERE art EQ '01' AND charg = it_tab1-charg AND lifnr NE space.  "mfgr
  ENDIF.

  LOOP AT it_qals INTO wa_qals.
    SELECT SINGLE * FROM jest WHERE objnr EQ wa_qals-objnr AND stat EQ 'I0224'.
    IF sy-subrc EQ 0.
      DELETE it_qals WHERE prueflos EQ wa_qals-prueflos.
    ENDIF.
  ENDLOOP.

  LOOP AT it_qals1 INTO wa_qals1.
    SELECT SINGLE * FROM jest WHERE objnr EQ wa_qals1-objnr AND stat EQ 'I0224'.
    IF sy-subrc EQ 0.
      DELETE it_qals1 WHERE prueflos EQ wa_qals1-prueflos.
    ENDIF.
  ENDLOOP.

*  AND mblnr eq t_mseg-mblnr.
  SORT it_qals BY enstehdat DESCENDING.
*sort it_qals by aufpl descending.
*SORT it_qals BY enstehdat entstezeIT DESCENDING.
*SORT it_qals BY enstehdat aufpl DESCENDING.

*select * from mseg into table It_mseg FOR ALL ENTRIES IN T_MSEG where CHARG = T_MSEG-CHARG AND BWART IN ('101','305') .

  SORT it_tab1 BY mblnr matnr charg.


*  IF R1 EQ 'X'.
*    PERFORM FORM1.
*  ELSE.
  PERFORM simple.
*  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  SIMPLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM simple.


  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
*     APPLICATION                 = 'TX'
*     ARCHIVE_INDEX               =
*     ARCHIVE_PARAMS              =
      device                      = 'PRINTER'
      dialog                      = 'X'
*     FORM                        = 'ZQASSURANCE_3'
      language                    = sy-langu
*     OPTIONS                     =
*     MAIL_SENDER                 =
*     MAIL_RECIPIENT              =
*     MAIL_APPL_OBJECT            =
*     RAW_DATA_INTERFACE          = '*'
*     SPONUMIV                    =
* IMPORTING
*     LANGUAGE                    =
*     NEW_ARCHIVE_PARAMS          =
*     RESULT                      =
    EXCEPTIONS
      canceled                    = 1
      device                      = 2
      form                        = 3
      options                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      OTHERS                      = 12.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT it_tab1 INTO wa_tab1.
    CLEAR : prueflos.
    IF wa_tab1-werks EQ '1001'.
      CALL FUNCTION 'START_FORM'
        EXPORTING
          form        = 'ZQASSURANCE_4_1'
          language    = sy-langu
        EXCEPTIONS
          form        = 1
          format      = 2
          unended     = 3
          unopened    = 4
          unused      = 5
          spool_error = 6
          codepage    = 7
          OTHERS      = 8.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.
      CALL FUNCTION 'START_FORM'
        EXPORTING
*         FORM        = 'ZQASSURANCE_4'
          form        = 'ZQASSURANCE_4L'
          language    = sy-langu
        EXCEPTIONS
          form        = 1
          format      = 2
          unended     = 3
          unopened    = 4
          unused      = 5
          spool_error = 6
          codepage    = 7
          OTHERS      = 8.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
*  NEW-PAGE.
*  IF WA_TAB1-WERKS EQ '1000'.
**    WRITE : / '  A-12 M.I.D.C. AMBAD, NASIK - 422010. '.
*  ELSEIF WA_TAB1-WERKS EQ '1001'.
**    WRITE : / '  L-17, VERNA INDUSTRIAL ESTATE, GOA - 403 722.'.
*  ENDIF.

*  WRITE : / 'VISUAL INSPECTION REPORT / INTIMATION TO QC'.

    IF wa_tab1-name1 EQ space.  "added on 11.2.22
      READ TABLE it_qals1 INTO wa_qals1 WITH KEY charg = wa_tab1-charg.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_qals1-lifnr.
        IF sy-subrc EQ 0.
          wa_tab1-name1 = lfa1-name1.
        ENDIF.
      ENDIF.
    ENDIF.
    IF wa_tab1-sgtxt EQ space."added on 11.2.22
      READ TABLE it_qals1 INTO wa_qals1 WITH KEY charg = wa_tab1-charg.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_qals1-mblnr.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM lfa1 WHERE lifnr EQ zmigo-mfgr.
          IF sy-subrc EQ 0.
            wa_tab1-sgtxt = lfa1-name1.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A'
        window  = 'MAIN'.

*  ,'      DATE',SY-DATUM.
    SELECT SINGLE * FROM mkpf WHERE mblnr EQ wa_tab1-mblnr.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A_1'
          window  = 'MAIN'.
    ENDIF.

*  SKIP.
*  ULINE.


*  WRITE : / 'DEPARTMENT RESPONSIBLE',50 ':','STORE'.
*  SKIP.
*  WRITE : / 'NAME OF MATERIAL',50':',WA_TAB1-MATNR.

    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A_2'
        window  = 'MAIN'.

*    SELECT SINGLE * FROM MAKT WHERE MATNR = WA_TAB1-MATNR  AND SPRAS = 'EN' .
*    IF SY-SUBRC EQ 0.
*WRITE : '/',MAKT-MAKTX LEFT-JUSTIFIED.

    SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab1-matnr.
    IF sy-subrc EQ 0.
      CLEAR : maktx1,maktx2,maktx.
      SELECT SINGLE * FROM makt WHERE matnr = wa_tab1-matnr  AND spras = 'EN' .
      IF sy-subrc EQ 0.
        maktx1 = makt-maktx.
      ENDIF.
      SELECT SINGLE * FROM makt WHERE matnr = wa_tab1-matnr  AND spras = 'Z1' .
      IF sy-subrc EQ 0.
        maktx2 = makt-maktx.
      ENDIF.
      CONCATENATE maktx1 maktx2 INTO maktx SEPARATED BY space.
      CONCATENATE maktx ', ' mara-normt INTO material.
******************************************zpo_det*******************

*      *******************new confiripn for zpo_matnr*  17.10.22 ******************

      SELECT SINGLE * FROM mseg WHERE mblnr EQ wa_tab1-mblnr AND mjahr EQ wa_tab1-mjahr AND matnr EQ wa_tab1-matnr AND ebeln NE space.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM ekko WHERE ebeln EQ mseg-ebeln.
        IF sy-subrc EQ 0.
*************************
*      select single * from zpo_matnr where matnr eq wa_tab1-matnr.
**                 AND EFFECTDT GE EKKO-AEDAT.
*      if sy-subrc eq 0.
*        if ekko-aedat ge zpo_matnr-effectdt.
*          select single * from ekpo where ebeln eq mseg-ebeln and ebelp eq mseg-ebelp.
*          if sy-subrc eq 0.
*            material = ekpo-txz01.
**            normt = space.
*          endif.
*        endif.
*      endif.
          SELECT SINGLE * FROM ekpa WHERE ebeln EQ ekko-ebeln AND parvw EQ 'HR'.
          IF sy-subrc EQ 0.
            SELECT SINGLE * FROM zpo_matnr WHERE matnr EQ wa_tab1-matnr AND lifnr EQ ekpa-lifn2.
*                 AND EFFECTDT GE EKKO-AEDAT.
            IF sy-subrc EQ 0.
              IF ekko-aedat GE zpo_matnr-effectdt.
*          select single * from ekpo where ebeln eq mseg-ebeln and ebelp eq mseg-ebelp.
*          if sy-subrc eq 0.
                material = zpo_matnr-maktx.
*            normt = space.
*          endif.
              ENDIF.
            ENDIF.
          ENDIF.
***************************
        ENDIF.
      ENDIF.

******************************************************************

      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A1'
          window  = 'MAIN'.
    ENDIF.
*    SKIP.
*    ENDIF.

*  WRITE : /'GIN REFERANCE',50 ':',WA_TAB1-MBLNR.

*  SKIP.
*  WRITE : / 'I.D. NO.','/','INSP.LOT ',50 ':', WA_TAB1-CHARG.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A2'
        window  = 'MAIN'.
    SELECT SINGLE * FROM qals WHERE matnr = wa_tab1-matnr AND charg = wa_tab1-charg AND werk = wa_tab1-werks AND mblnr EQ wa_tab1-mblnr AND lagortchrg = wa_tab1-lgort.
    IF sy-subrc EQ 0.
*      WA_QALS-PRUEFLOS = QALS-PRUEFLOS.
      prueflos = qals-prueflos.
    ELSE.
*********** 17.6.2019**********
      SELECT SINGLE * FROM qals WHERE matnr = wa_tab1-matnr AND charg = wa_tab1-charg AND werk = wa_tab1-werks AND mblnr EQ wa_tab1-mblnr.
      IF sy-subrc EQ 0.
*        WA_QALS-PRUEFLOS = QALS-PRUEFLOS.
        prueflos = qals-prueflos.
      ELSE.
******************** 15.7.20********
****        READ TABLE IT_QALS INTO WA_QALS WITH KEY MATNR = WA_TAB1-MATNR CHARG = WA_TAB1-CHARG WERK = WA_TAB1-WERKS LAGORTCHRG = WA_TAB1-LGORT.
*****  SELECT SINGLE * FROM qals WHERE matnr = wa_tab1-matnr AND charg = wa_tab1-charg AND werk = wa_tab1-werks AND mblnr eq wa_tab1-mblnr AND lagortchrg = wa_tab1-lgort.
*****   MBLNR = T_MSEG-MBLNR.
****        IF SY-SUBRC EQ 0.
****          WA_QALS-PRUEFLOS = WA_QALS-PRUEFLOS.
****        ENDIF.
      ENDIF.
    ENDIF.
*    WRITE : '/',WA_QALS-PRUEFLOS.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A3'
        window  = 'MAIN'.
*    SKIP.
*    ENDIF.
*    IF WA_TAB1-LIFNR NE '  '.
*      SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_TAB1-LIFNR.
*      IF SY-SUBRC EQ 0.
*      WRITE : / 'SUPPLIER ',50 ':',LFA1-NAME1.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A4'
        window  = 'MAIN'.
*      SKIP.
*      ENDIF.
*    ENDIF.
    IF wa_tab1-lifnr EQ ' '.
      SELECT SINGLE * FROM mcha WHERE matnr = wa_tab1-matnr AND werks = wa_tab1-werks AND charg = wa_tab1-charg .
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mcha-lifnr.
        IF sy-subrc EQ 0.
*        WRITE : / 'SUPPLIER',50 ':',LFA1-NAME1.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'A4'
              window  = 'MAIN'.
*        SKIP.
        ENDIF.
      ENDIF.
    ENDIF.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A5'
        window  = 'MAIN'.

*  WRITE : /'PURCHASE ORDER CHECKED WITH CHALLAN',50 ':',wa_tab1-EBELN.
*  SKIP.
    SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_tab1-ebeln.
    IF sy-subrc EQ 0.
*    WRITE : '/',EKKO-BEDAT.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A6'
          window  = 'MAIN'.
*    SKIP.
    ENDIF.

    SELECT SINGLE * FROM mkpf WHERE mblnr = wa_tab1-mblnr AND   mjahr = p_mjahr .
    IF sy-subrc EQ 0.
*    WRITE : /'CHALLAN NO. & DATE',50 ':',MKPF-XBLNR,MKPF-BLDAT.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A7'
          window  = 'MAIN'.
*    SKIP.
    ENDIF.
*  WRITE : / 'TOTAL QUANTITY RECEIVED',50 ':',wa_tab1-MENGE,wa_tab1-MEINS,wa_tab1-ABLAD.

    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A8'
        window  = 'MAIN'.
*  SELECT SINGLE SGTXT FROM mseg INTO W_SGTXT WHERE charg eq wa_tab1-charg AND bwart eq '101'.
*    if sy-subrc eq 0.
*      CALL FUNCTION 'WRITE_FORM'
*    EXPORTING
*      element = 'A8_1'
*      WINDOW  = 'MAIN'.
*    ENDIF.
*  SKIP.
*  ULINE.
*  SKIP.
*  WRITE : / 'CHECK LIST / OBSEVATION',50 ':'.
*  SKIP 3.
*  SKIP.
*  SKIP.
*  WRITE : / 'PHARMACOPIE',50 ':'.  "kept blank on request of Mr. Mukherjee.
**  MARA-NORMT.
*  SKIP.
*  WRITE : / 'NAME OF MANUFACTURER',50 ':',wa_tab1-SGTXT.
*  SKIP.
    SELECT SINGLE * FROM mcha WHERE matnr = wa_tab1-matnr AND werks = wa_tab1-werks AND charg = wa_tab1-charg .
    IF sy-subrc EQ 0.
      CLEAR : licha.
      licha = mcha-licha.
***************** VENDOR BATCH *******************

*************************** VENDOR BATCH*********************************************************************************************************
      CLEAR : rtdname1.
      CONCATENATE wa_tab1-matnr wa_tab1-werks wa_tab1-charg INTO rtdname1.
*            RTDNAME1 = '00000000000010010010000000108421'.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'VERM'
          language                = 'E'
          name                    = rtdname1
          object                  = 'CHARGE'
*         ARCHIVE_HANDLE          = 0
*            IMPORTING
*         HEADER                  = THEAD
        TABLES
          lines                   = ritext1
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
*    ************

      DESCRIBE TABLE ritext1 LINES ln1.
      nolines = 0.
      CLEAR : w_itext3,r11,r12.
      LOOP AT ritext1."WHERE tdline NE ' '.
        CONDENSE ritext1-tdline.
        nolines =  nolines  + 1.
        IF ritext1-tdline IS NOT  INITIAL   .
          IF ritext1-tdline NE '.'.

            IF nolines LE  1.
*                  MOVE ITEXT-TDLINE TO T1.
              MOVE ritext1-tdline TO w_itext3.
              CONCATENATE r11 w_itext3  INTO r11.
*                  SEPARATED BY SPACE.
            ENDIF.

*              move ritext1-tdline to w_itext3.
*              concatenate r3 w_itext3  into r3 separated by space.
          ENDIF.
        ENDIF.
      ENDLOOP.
*            WRITE : LICHA,R11.
      IF mkpf-budat GE '20200910'.
        IF mcha-licha+0(15) = r11+0(15).  "11.9.20  "long vendor batch
          licha = r11.
        ENDIF.
      ENDIF.
*************************************************************
*    WRITE : / 'MFGR''S BATCH NO',50 ':',MCHA-LICHA.
*    SKIP.

*** for converting date in mmm'yy form
      SELECT SINGLE * FROM t009c WHERE spras = 'EN' AND periv  ='K1' AND poper = mcha-hsdat+4(2).
      IF sy-subrc = '0'.
        CONCATENATE t009c-ktext '`' mcha-hsdat+0(4) INTO tmfg-dt.
      ELSE.
        tmfg-dt  = ' -- '.
      ENDIF.
*    WRITE : / 'MANUFACTURING DATE',50 ':',TMFG-DT.


*    SKIP.
      SELECT SINGLE * FROM t009c WHERE spras = 'EN' AND periv  ='K1' AND poper = mcha-vfdat+4(2).
      IF sy-subrc = '0'.
        CONCATENATE t009c-ktext '`' mcha-vfdat+0(4) INTO texp-dt.
      ELSE.
        texp-dt = ' -- '.
      ENDIF.
*    WRITE : / 'EXPIRY DATE',50 ':',TEXP-DT.

      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A9'
          window  = 'MAIN'.

*    SKIP.
    ENDIF.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A10'
        window  = 'MAIN'.

*  WRITE : / 'LIGIBILITY & CORRECTNESS OF ALL LABEL',50 ':'.
*  SKIP.
*  WRITE : / 'CONDITION OF OUTER PACK',50 ':'.
*  SKIP.
*  WRITE : / 'SEAL & INTACTNESS OF CONTAINERS',50 ':'.
*  SKIP.
*  WRITE : / 'DAMAGED CONTAINER',50 ':'.
*  WRITE : / 'any, record Nature of Damage)',50 ':'.
*  SKIP.
*  WRITE : / 'MFG. LIC. NO.',50 ':'.
*  SKIP.
*  WRITE : / 'REMARKS',50 ':'.
*  SKIP.

    CALL FUNCTION 'END_FORM'
      EXCEPTIONS
        unopened                 = 1
        bad_pageformat_for_print = 2
        spool_error              = 3
        codepage                 = 4
        OTHERS                   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDLOOP .

  CALL FUNCTION 'CLOSE_FORM'
    EXCEPTIONS
      unopened                 = 1
      bad_pageformat_for_print = 2
      send_error               = 3
      spool_error              = 4
      codepage                 = 5
      OTHERS                   = 6.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    "SIMPLE

*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM form1.


  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
*     APPLICATION                 = 'TX'
*     ARCHIVE_INDEX               =
*     ARCHIVE_PARAMS              =
      device                      = 'PRINTER'
      dialog                      = 'X'
*     FORM                        = 'ZQASSURANCE_3'
      language                    = sy-langu
*     OPTIONS                     =
*     MAIL_SENDER                 =
*     MAIL_RECIPIENT              =
*     MAIL_APPL_OBJECT            =
*     RAW_DATA_INTERFACE          = '*'
*     SPONUMIV                    =
* IMPORTING
*     LANGUAGE                    =
*     NEW_ARCHIVE_PARAMS          =
*     RESULT                      =
    EXCEPTIONS
      canceled                    = 1
      device                      = 2
      form                        = 3
      options                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      OTHERS                      = 12.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT it_tab1 INTO wa_tab1.
    CLEAR : prueflos.
    IF wa_tab1-werks EQ '1001'.
      CALL FUNCTION 'START_FORM'
        EXPORTING
          form        = 'ZQASSURANCE_42'
          language    = sy-langu
        EXCEPTIONS
          form        = 1
          format      = 2
          unended     = 3
          unopened    = 4
          unused      = 5
          spool_error = 6
          codepage    = 7
          OTHERS      = 8.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.
      CALL FUNCTION 'START_FORM'
        EXPORTING
          form        = 'ZQASSURANCE_41'
          language    = sy-langu
        EXCEPTIONS
          form        = 1
          format      = 2
          unended     = 3
          unopened    = 4
          unused      = 5
          spool_error = 6
          codepage    = 7
          OTHERS      = 8.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
*  NEW-PAGE.
*  IF WA_TAB1-WERKS EQ '1000'.
**    WRITE : / '  A-12 M.I.D.C. AMBAD, NASIK - 422010. '.
*  ELSEIF WA_TAB1-WERKS EQ '1001'.
**    WRITE : / '  L-17, VERNA INDUSTRIAL ESTATE, GOA - 403 722.'.
*  ENDIF.

*  WRITE : / 'VISUAL INSPECTION REPORT / INTIMATION TO QC'.

    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A'
        window  = 'MAIN'.

*  ,'      DATE',SY-DATUM.
    SELECT SINGLE * FROM mkpf WHERE mblnr EQ wa_tab1-mblnr.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A_1'
          window  = 'MAIN'.
    ENDIF.

*  SKIP.
*  ULINE.


*  WRITE : / 'DEPARTMENT RESPONSIBLE',50 ':','STORE'.
*  SKIP.
*  WRITE : / 'NAME OF MATERIAL',50':',WA_TAB1-MATNR.

    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A_2'
        window  = 'MAIN'.

*    SELECT SINGLE * FROM MAKT WHERE MATNR = WA_TAB1-MATNR  AND SPRAS = 'EN' .
*    IF SY-SUBRC EQ 0.
**WRITE : '/',MAKT-MAKTX LEFT-JUSTIFIED.
*
*      SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB1-MATNR.
*      IF SY-SUBRC EQ 0.
**WRITE :  MARA-NORMT LEFT-JUSTIFIED.
*      ENDIF.
*      CONCATENATE MAKT-MAKTX ', ' MARA-NORMT INTO MATERIAL.
**    WRITE :  '/',MATERIAL.
*
*      CALL FUNCTION 'WRITE_FORM'
*        EXPORTING
*          ELEMENT = 'A1'
*          WINDOW  = 'MAIN'.
**    SKIP.
*    ENDIF.

    SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab1-matnr.
    IF sy-subrc EQ 0.
      CLEAR : maktx1,maktx2,maktx.
      SELECT SINGLE * FROM makt WHERE matnr = wa_tab1-matnr  AND spras = 'EN' .
      IF sy-subrc EQ 0.
        maktx1 = makt-maktx.
      ENDIF.
      SELECT SINGLE * FROM makt WHERE matnr = wa_tab1-matnr  AND spras = 'Z1' .
      IF sy-subrc EQ 0.
        maktx2 = makt-maktx.
      ENDIF.
      CONCATENATE maktx1 maktx2 INTO maktx SEPARATED BY space.
      CONCATENATE maktx ', ' mara-normt INTO material.


      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A1'
          window  = 'MAIN'.
    ENDIF.


*  WRITE : /'GIN REFERANCE',50 ':',WA_TAB1-MBLNR.

*  SKIP.
*  WRITE : / 'I.D. NO.','/','INSP.LOT ',50 ':', WA_TAB1-CHARG.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A2'
        window  = 'MAIN'.
    SELECT SINGLE * FROM qals WHERE matnr = wa_tab1-matnr AND charg = wa_tab1-charg AND werk = wa_tab1-werks AND mblnr EQ wa_tab1-mblnr AND lagortchrg = wa_tab1-lgort.
    IF sy-subrc EQ 0.
*      WA_QALS-PRUEFLOS = QALS-PRUEFLOS.
      prueflos = qals-prueflos.
    ELSE.
      SELECT SINGLE * FROM qals WHERE matnr = wa_tab1-matnr AND charg = wa_tab1-charg AND werk = wa_tab1-werks AND mblnr EQ wa_tab1-mblnr.
      IF sy-subrc EQ 0.
*        WA_QALS-PRUEFLOS = QALS-PRUEFLOS.
        prueflos = qals-prueflos.
      ENDIF.
*      READ TABLE IT_QALS INTO WA_QALS WITH KEY MATNR = WA_TAB1-MATNR CHARG = WA_TAB1-CHARG WERK = WA_TAB1-WERKS LAGORTCHRG = WA_TAB1-LGORT."15.7.20
**     SELECT SINGLE * FROM qals WHERE matnr = wa_tab1-matnr AND charg = wa_tab1-charg AND werk = wa_tab1-werks AND mblnr eq wa_tab1-mblnr AND lagortchrg = wa_tab1-lgort.
**   MBLNR = T_MSEG-MBLNR.
*      IF SY-SUBRC EQ 0.
**    WRITE : '/',WA_QALS-PRUEFLOS.
*        WA_QALS-PRUEFLOS = WA_QALS-PRUEFLOS.
*      ENDIF.
    ENDIF.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A3'
        window  = 'MAIN'.
*    SKIP.
*    ENDIF.
    IF wa_tab1-lifnr NE '  '.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_tab1-lifnr.
      IF sy-subrc EQ 0.
*      WRITE : / 'SUPPLIER ',50 ':',LFA1-NAME1.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'A4'
            window  = 'MAIN'.
*      SKIP.
      ENDIF.
    ENDIF.
    IF wa_tab1-lifnr EQ ' '.
      SELECT SINGLE * FROM mcha WHERE matnr = wa_tab1-matnr AND werks = wa_tab1-werks AND charg = wa_tab1-charg .
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ mcha-lifnr.
        IF sy-subrc EQ 0.
*        WRITE : / 'SUPPLIER',50 ':',LFA1-NAME1.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'A4'
              window  = 'MAIN'.
*        SKIP.
        ENDIF.
      ENDIF.
    ENDIF.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A5'
        window  = 'MAIN'.

*  WRITE : /'PURCHASE ORDER CHECKED WITH CHALLAN',50 ':',wa_tab1-EBELN.
*  SKIP.
    SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_tab1-ebeln.
    IF sy-subrc EQ 0.
*    WRITE : '/',EKKO-BEDAT.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A6'
          window  = 'MAIN'.
*    SKIP.
    ENDIF.

    SELECT SINGLE * FROM mkpf WHERE mblnr = wa_tab1-mblnr AND   mjahr = p_mjahr .
    IF sy-subrc EQ 0.
*    WRITE : /'CHALLAN NO. & DATE',50 ':',MKPF-XBLNR,MKPF-BLDAT.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A7'
          window  = 'MAIN'.
*    SKIP.
    ENDIF.
*  WRITE : / 'TOTAL QUANTITY RECEIVED',50 ':',wa_tab1-MENGE,wa_tab1-MEINS,wa_tab1-ABLAD.

    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A8'
        window  = 'MAIN'.
*  SELECT SINGLE SGTXT FROM mseg INTO W_SGTXT WHERE charg eq wa_tab1-charg AND bwart eq '101'.
*    if sy-subrc eq 0.
*      CALL FUNCTION 'WRITE_FORM'
*    EXPORTING
*      element = 'A8_1'
*      WINDOW  = 'MAIN'.
*    ENDIF.
*  SKIP.
*  ULINE.
*  SKIP.
*  WRITE : / 'CHECK LIST / OBSEVATION',50 ':'.
*  SKIP 3.
*  SKIP.
*  SKIP.
*  WRITE : / 'PHARMACOPIE',50 ':'.  "kept blank on request of Mr. Mukherjee.
**  MARA-NORMT.
*  SKIP.
*  WRITE : / 'NAME OF MANUFACTURER',50 ':',wa_tab1-SGTXT.
*  SKIP.
    SELECT SINGLE * FROM mcha WHERE matnr = wa_tab1-matnr AND werks = wa_tab1-werks AND charg = wa_tab1-charg .
    IF sy-subrc EQ 0.
*    WRITE : / 'MFGR''S BATCH NO',50 ':',MCHA-LICHA.
*    SKIP.

*** for converting date in mmm'yy form
      SELECT SINGLE * FROM t009c WHERE spras = 'EN' AND periv  ='K1' AND poper = mcha-hsdat+4(2).
      IF sy-subrc = '0'.
        CONCATENATE t009c-ktext '`' mcha-hsdat+0(4) INTO tmfg-dt.
      ELSE.
        tmfg-dt  = ' -- '.
      ENDIF.
*    WRITE : / 'MANUFACTURING DATE',50 ':',TMFG-DT.


*    SKIP.
      SELECT SINGLE * FROM t009c WHERE spras = 'EN' AND periv  ='K1' AND poper = mcha-vfdat+4(2).
      IF sy-subrc = '0'.
        CONCATENATE t009c-ktext '`' mcha-vfdat+0(4) INTO texp-dt.
      ELSE.
        texp-dt = ' -- '.
      ENDIF.
*    WRITE : / 'EXPIRY DATE',50 ':',TEXP-DT.

      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'A9'
          window  = 'MAIN'.

*    SKIP.
    ENDIF.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'A10'
        window  = 'MAIN'.

*  WRITE : / 'LIGIBILITY & CORRECTNESS OF ALL LABEL',50 ':'.
*  SKIP.
*  WRITE : / 'CONDITION OF OUTER PACK',50 ':'.
*  SKIP.
*  WRITE : / 'SEAL & INTACTNESS OF CONTAINERS',50 ':'.
*  SKIP.
*  WRITE : / 'DAMAGED CONTAINER',50 ':'.
*  WRITE : / 'any, record Nature of Damage)',50 ':'.
*  SKIP.
*  WRITE : / 'MFG. LIC. NO.',50 ':'.
*  SKIP.
*  WRITE : / 'REMARKS',50 ':'.
*  SKIP.

    CALL FUNCTION 'END_FORM'
      EXCEPTIONS
        unopened                 = 1
        bad_pageformat_for_print = 2
        spool_error              = 3
        codepage                 = 4
        OTHERS                   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDLOOP .

  CALL FUNCTION 'CLOSE_FORM'
    EXCEPTIONS
      unopened                 = 1
      bad_pageformat_for_print = 2
      send_error               = 3
      spool_error              = 4
      codepage                 = 5
      OTHERS                   = 6.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    "FORM1
*&---------------------------------------------------------------------*
*&      Form  PASS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pass .
  SELECT SINGLE * FROM zpassw WHERE pernr = pernr.
  IF sy-subrc EQ 0.

    IF sy-uname NE zpassw-uname.
      MESSAGE 'INVALID LOGIN ID' TYPE 'E'.
    ENDIF.
    v_en_string = zpassw-password.
*&———————————————————————** Decryption – String to String*&———————————————————————*
    TRY.
        CREATE OBJECT o_encryptor.
        CALL METHOD o_encryptor->decrypt_string2string
          EXPORTING
            the_string = v_en_string
          RECEIVING
            result     = v_de_string.
      CATCH cx_encrypt_error INTO o_cx_encrypt_error.
        CALL METHOD o_cx_encrypt_error->if_message~get_text
          RECEIVING
            result = v_error_msg.
        MESSAGE v_error_msg TYPE 'E'.
    ENDTRY.
    IF v_de_string EQ pass.
*      message 'CORRECT PASSWORD' type 'I'.
    ELSE.
      MESSAGE 'INCORRECT PASSWORD' TYPE 'E'.
    ENDIF.
  ELSE.
    MESSAGE 'NOT VALID USER' TYPE 'E'.
    EXIT.
  ENDIF.
  CLEAR : pass.
  pass = '   '.
ENDFORM.
