*&---------------------------------------------------------------------*
*& Report  ZSFG_VALUATION
*& Developed by Jyotsna 8.1.2017
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zsfg_valuation1 NO STANDARD PAGE HEADING LINE-SIZE 500.

TABLES : mchb,
         makt,
         mvke,
         tvm5t,
         afpo.

DATA : it_mchb      TYPE TABLE OF mchb,
       wa_mchb      TYPE mchb,
       it_afpo      TYPE TABLE OF afpo,
       wa_afpo      TYPE afpo,
       it_aufm      TYPE TABLE OF aufm,
       wa_aufm      TYPE aufm,
       it_stpo      TYPE TABLE OF stpo,
       wa_stpo      TYPE stpo,
       it_mast      TYPE TABLE OF mast,
       wa_mast      TYPE mast,
       it_mara      TYPE TABLE OF mara,
       wa_mara      TYPE mara,
       it_zprd_ccpc TYPE TABLE OF zprd_ccpc,
       wa_zprd_ccpc TYPE zprd_ccpc.

TYPE-POOLS:  slis.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.

TYPES : BEGIN OF itab1,
          matnr TYPE mchb-matnr,
          werks TYPE mchb-werks,
          lgort TYPE mchb-lgort,
          charg TYPE mchb-charg,
          clabs TYPE mchb-clabs,
        END OF itab1.

TYPES : BEGIN OF itab2,
          aufnr   TYPE afpo-aufnr,
          meins   TYPE afpo-meins,
          matnr   TYPE mchb-matnr,
          maktx   TYPE makt-maktx,
          werks   TYPE mchb-werks,
          lgort   TYPE mchb-lgort,
          charg   TYPE mchb-charg,
          clabs   TYPE p,
          rmdmbtr TYPE aufm-dmbtr,
          pmdmbtr TYPE aufm-dmbtr,
          halb    TYPE mara-matnr,
          bezei   TYPE tvm5t-bezei,
          rmrate  TYPE p DECIMALS 2,
          rmval   TYPE p DECIMALS 2,
          wemng   TYPE afpo-wemng,
        END OF itab2.

TYPES : BEGIN OF itab5,
          aufnr   TYPE afpo-aufnr,
          meins   TYPE afpo-meins,
          matnr   TYPE mchb-matnr,
          maktx   TYPE makt-maktx,
          werks   TYPE mchb-werks,
          lgort   TYPE mchb-lgort,
          charg   TYPE mchb-charg,
          clabs   TYPE p,
          rmdmbtr TYPE aufm-dmbtr,
          pmdmbtr TYPE aufm-dmbtr,
          halb    TYPE mara-matnr,
          bezei   TYPE tvm5t-bezei,
          rate    TYPE p DECIMALS 3,
          val     TYPE p DECIMALS 2,
          cc      TYPE p DECIMALS 2,
          pc      TYPE p DECIMALS 2,
          total   TYPE p DECIMALS 2,
          rmrate  TYPE p DECIMALS 2,
          rmval   TYPE p DECIMALS 2,
          wemng   TYPE afpo-wemng,
        END OF itab5.

TYPES : BEGIN OF imat1,
          matnr TYPE mara-matnr,
          idnrk TYPE stpo-idnrk,
        END OF imat1.

TYPES : BEGIN OF imat2,
          matnr TYPE mara-matnr,
          idnrk TYPE stpo-idnrk,
          cc    TYPE p DECIMALS 2,
          pc    TYPE p DECIMALS 2,
        END OF imat2.

DATA : it_tab1 TYPE TABLE OF itab1,
       wa_tab1 TYPE itab1,
       it_tab2 TYPE TABLE OF itab2,
       wa_tab2 TYPE itab2,
       it_tab3 TYPE TABLE OF itab2,
       wa_tab3 TYPE itab2,
       it_tab4 TYPE TABLE OF itab2,
       wa_tab4 TYPE itab2,
       it_tab5 TYPE TABLE OF itab5,
       wa_tab5 TYPE itab5,
       it_mat1 TYPE TABLE OF imat1,
       wa_mat1 TYPE imat1,
       it_mat2 TYPE TABLE OF imat2,
       wa_mat2 TYPE imat2.

DATA : qty    TYPE p,
       qty1   TYPE p,
       rmrate TYPE p DECIMALS 6,
       rmval  TYPE p DECIMALS 2.
DATA: result       TYPE string,
      count        TYPE i,
      cnt          TYPE i,
      lv_alphabets TYPE string,
      lv_numbers   TYPE string,
      pack         TYPE tvm5t-bezei,
      rate         TYPE p  DECIMALS 3,
      val          TYPE p DECIMALS 2.

SELECTION-SCREEN BEGIN OF BLOCK merkmale WITH FRAME TITLE TEXT-001.
  PARAMETERS : plant LIKE mchb-werks OBLIGATORY.
  PARAMETERS : lgort_f LIKE mchb-lgort DEFAULT 'SF01',
               lgort_t LIKE mchb-lgort DEFAULT 'SF04'.
SELECTION-SCREEN END OF BLOCK merkmale.

START-OF-SELECTION.
  g_repid = sy-repid.

*select * from mchb into table it_mchb where werks eq plant and lgort ge 'SF01' and lgort le 'SF04'.
  SELECT * FROM mchb INTO TABLE it_mchb WHERE werks EQ plant AND lgort GE lgort_f AND lgort LE lgort_t.

  LOOP AT it_mchb INTO wa_mchb.
    qty = wa_mchb-clabs + wa_mchb-cinsm.
    IF qty GT 0.
      wa_tab1-matnr = wa_mchb-matnr.
      wa_tab1-werks = wa_mchb-werks.
      wa_tab1-lgort = wa_mchb-lgort.
      wa_tab1-charg = wa_mchb-charg.
      wa_tab1-clabs = qty.
      COLLECT wa_tab1 INTO it_tab1.
      CLEAR wa_tab1.
    ENDIF.
  ENDLOOP.
  IF it_tab1 IS NOT INITIAL.
    SELECT * FROM afpo INTO TABLE it_afpo FOR ALL ENTRIES IN it_tab1 WHERE pwerk EQ plant AND matnr EQ it_tab1-matnr AND charg EQ it_tab1-charg.
    IF sy-subrc EQ 0.
      SELECT * FROM aufm INTO TABLE it_aufm FOR ALL ENTRIES IN it_afpo WHERE aufnr EQ it_afpo-aufnr.
    ENDIF.
  ENDIF.

  LOOP AT it_tab1 INTO wa_tab1.
    LOOP AT it_afpo INTO wa_afpo WHERE matnr EQ wa_tab1-matnr AND charg EQ wa_tab1-charg.
      wa_tab2-aufnr = wa_afpo-aufnr.
      wa_tab2-meins = wa_afpo-meins.
      wa_tab2-matnr = wa_tab1-matnr.
      wa_tab2-werks = wa_tab1-werks.
      wa_tab2-lgort = wa_tab1-lgort.
      wa_tab2-charg = wa_tab1-charg.
*      wa_tab2-clabs = wa_tab1-clabs.
      COLLECT wa_tab2 INTO it_tab2.
      CLEAR wa_tab2.
    ENDLOOP.
  ENDLOOP.

  LOOP AT it_tab2 INTO wa_tab2.
    LOOP AT it_aufm INTO wa_aufm WHERE aufnr EQ wa_tab2-aufnr AND lgort GE 'RM01' AND lgort LE 'RM04'.
      IF wa_aufm-shkzg EQ 'S'.
        wa_aufm-dmbtr = wa_aufm-dmbtr * ( - 1 ).
      ENDIF.
*    write : / '**',wa_aufm-matnr,wa_aufm-lgort,wa_aufm-charg,wa_aufm-dmbtr.
      wa_tab3-aufnr = wa_tab2-aufnr.
      wa_tab3-meins = wa_tab2-meins.
      wa_tab3-matnr = wa_tab2-matnr.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_tab2-matnr AND spras EQ 'EN'.
      IF sy-subrc EQ 0.
        wa_tab3-maktx = makt-maktx.
      ENDIF.
      wa_tab3-werks = wa_tab2-werks.
      wa_tab3-lgort = wa_tab2-lgort.
      wa_tab3-charg = wa_tab2-charg.
*      wa_tab3-clabs = wa_tab2-clabs.
      wa_tab3-rmdmbtr = wa_aufm-dmbtr.
      COLLECT wa_tab3 INTO it_tab3.
      CLEAR wa_tab3.
    ENDLOOP.
  ENDLOOP.

  LOOP AT it_tab2 INTO wa_tab2.
    LOOP AT it_aufm INTO wa_aufm WHERE aufnr EQ wa_tab2-aufnr AND lgort GE 'PM01' AND lgort LE 'PM04'.
      IF wa_aufm-shkzg EQ 'S'.
        wa_aufm-dmbtr = wa_aufm-dmbtr * ( - 1 ).
      ENDIF.
*    write : / '**',wa_aufm-matnr,wa_aufm-lgort,wa_aufm-charg,wa_aufm-dmbtr.
      wa_tab3-aufnr = wa_tab2-aufnr.
      wa_tab3-meins = wa_tab2-meins.
      wa_tab3-matnr = wa_tab2-matnr.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_tab2-matnr AND spras EQ 'EN'.
      IF sy-subrc EQ 0.
        wa_tab3-maktx = makt-maktx.
      ENDIF.
      wa_tab3-werks = wa_tab2-werks.
      wa_tab3-lgort = wa_tab2-lgort.
      wa_tab3-charg = wa_tab2-charg.
*      wa_tab3-clabs = wa_tab2-clabs.
      wa_tab3-pmdmbtr = wa_aufm-dmbtr.
      COLLECT wa_tab3 INTO it_tab3.
      CLEAR wa_tab3.
    ENDLOOP.
  ENDLOOP.

  IF it_tab3 IS NOT INITIAL.
    SELECT * FROM stpo INTO TABLE it_stpo FOR ALL ENTRIES IN it_tab3 WHERE idnrk EQ it_tab3-matnr.
    IF sy-subrc EQ 0.
      SELECT * FROM mast INTO TABLE it_mast FOR ALL ENTRIES IN it_stpo WHERE stlnr EQ it_stpo-stlnr AND werks EQ plant.
      IF sy-subrc EQ 0.
        SELECT * FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_mast WHERE matnr EQ it_mast-matnr  AND mtart EQ 'ZFRT'.
      ENDIF.
    ENDIF.
  ENDIF.

  LOOP AT it_mara INTO wa_mara.
    READ TABLE it_mast INTO wa_mast WITH KEY matnr = wa_mara-matnr.
    IF sy-subrc EQ 0.
      READ TABLE it_stpo INTO wa_stpo WITH KEY stlnr = wa_mast-stlnr.
      IF sy-subrc EQ 0.
        wa_mat1-matnr = wa_mara-matnr.
        wa_mat1-idnrk = wa_stpo-idnrk.
        COLLECT wa_mat1 INTO it_mat1.
        CLEAR wa_mat1.
      ENDIF.
    ENDIF.
  ENDLOOP.
*  IF IT_MAT1 IS NOT INITIAL.
  SELECT * FROM zprd_ccpc INTO TABLE it_zprd_ccpc.
*   endif.
  SORT it_zprd_ccpc DESCENDING BY from_dt.
  LOOP AT it_mat1 INTO wa_mat1.
    wa_mat2-matnr = wa_mat1-matnr.
    wa_mat2-idnrk = wa_mat1-idnrk.
    READ TABLE it_zprd_ccpc INTO wa_zprd_ccpc WITH KEY matnr = wa_mat1-matnr.
    IF sy-subrc EQ 0.
      wa_mat2-cc = wa_zprd_ccpc-cc.
      wa_mat2-pc = wa_zprd_ccpc-pc.
    ENDIF.
    COLLECT wa_mat2 INTO it_mat2.
    CLEAR wa_mat2.
  ENDLOOP.

*    LOOP at it_mat2 INTO wa_mat2.
*      WRITE : / 'cc/pc', wa_mat2-matnr,wa_mat2-cc,wa_mat2-pc.
*      endloop.

  LOOP AT it_tab3 INTO wa_tab3.
    CLEAR : qty1,rmrate,rmval.
*    write : / '1', wa_tab3-matnr,wa_tab3-aufnr,wa_tab3-matnr,wa_tab3-charg,wa_tab3-rmdmbtr.
    SELECT SINGLE * FROM afpo WHERE aufnr EQ wa_tab3-aufnr.
    IF sy-subrc EQ 0.
      qty1 = afpo-wemng.
      wa_tab4-wemng = afpo-wemng.
    ENDIF.
    IF qty1 > 0 .
      rmrate = wa_tab3-rmdmbtr / qty1.
    ENDIF.
    wa_tab4-rmrate = rmrate.
    wa_tab4-aufnr = wa_tab3-aufnr.
    wa_tab4-meins = wa_tab3-meins.
    wa_tab4-halb = wa_tab3-matnr.
    wa_tab4-maktx = wa_tab3-maktx.
    wa_tab4-werks = wa_tab3-werks.
    wa_tab4-lgort = wa_tab3-lgort.
    wa_tab4-charg = wa_tab3-charg.
    READ TABLE it_tab1 INTO wa_tab1 WITH KEY matnr = wa_tab3-matnr charg = wa_tab3-charg lgort = wa_tab3-lgort.
    IF sy-subrc EQ 0.
      wa_tab4-clabs = wa_tab1-clabs.
*      WRITE : wa_tab1-clabs.
      rmval = rmrate * wa_tab1-clabs.
      wa_tab4-rmval = rmval.
    ENDIF.
    READ TABLE it_mat1 INTO wa_mat1 WITH KEY idnrk = wa_tab3-matnr.
    IF sy-subrc EQ 0.
      wa_tab4-matnr = wa_mat1-matnr.
      SELECT SINGLE * FROM mvke WHERE matnr EQ wa_mat1-matnr AND vkorg EQ '1000' AND vtweg EQ '10'.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM tvm5t WHERE spras EQ 'EN' AND mvgr5 EQ mvke-mvgr5.
        IF sy-subrc EQ 0.
          wa_tab4-bezei = tvm5t-bezei.
        ENDIF.
      ENDIF.
    ENDIF.
    IF wa_tab4-matnr EQ 0.
      REPLACE ALL OCCURRENCES OF SUBSTRING 'H' IN wa_tab3-matnr WITH ''.
      wa_tab4-matnr = wa_tab3-matnr.
      SHIFT wa_tab4-matnr RIGHT DELETING TRAILING space.
      OVERLAY wa_tab4-matnr WITH '0000000000000'.
      SELECT SINGLE * FROM mvke WHERE matnr EQ wa_tab4-matnr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM tvm5t WHERE spras EQ 'EN' AND mvgr5 EQ mvke-mvgr5.
        IF sy-subrc EQ 0.
          wa_tab4-bezei = tvm5t-bezei.
        ENDIF.
      ENDIF.
    ENDIF.
    wa_tab4-rmdmbtr = wa_tab3-rmdmbtr.
    wa_tab4-pmdmbtr = wa_tab3-pmdmbtr.
    COLLECT wa_tab4 INTO it_tab4.
    CLEAR wa_tab4.
  ENDLOOP.

  LOOP AT it_tab4 INTO wa_tab4.
    CLEAR : pack,lv_alphabets,lv_numbers,rate,val.
    wa_tab5-aufnr = wa_tab4-aufnr.
    wa_tab5-meins = wa_tab4-meins.
    wa_tab5-halb = wa_tab4-halb.
    wa_tab5-maktx = wa_tab4-maktx.
    wa_tab5-werks = wa_tab4-werks.
    wa_tab5-lgort = wa_tab4-lgort.
    wa_tab5-charg = wa_tab4-charg.
    wa_tab5-clabs = wa_tab4-clabs.
    wa_tab5-matnr = wa_tab4-matnr.
    wa_tab5-rmrate = wa_tab4-rmrate.
    wa_tab5-rmval = wa_tab4-rmval.
    wa_tab5-wemng = wa_tab4-wemng.
    IF wa_tab4-clabs LT wa_tab4-wemng.
      wa_tab5-rmval = wa_tab4-rmval.
    ELSE.
      wa_tab5-rmval = wa_tab4-rmdmbtr.
    ENDIF.

*    IF WA_TAB4-MATNR EQ 0.
*    WRITE : / 'MATNR','M',WA_TAB4-HALB,'A',WA_TAB4-MATNR,'B'.
*    REPLACE ALL OCCURRENCES OF SUBSTRING 'H' IN WA_TAB4-HALB WITH ''.
*    WRITE
*    ENDIF.


    wa_tab5-bezei = wa_tab4-bezei.
    wa_tab5-rmdmbtr = wa_tab4-rmdmbtr.
    wa_tab5-pmdmbtr = wa_tab4-pmdmbtr.
    pack = wa_tab4-bezei.
    REPLACE ALL OCCURRENCES OF SUBSTRING '''' IN pack WITH ''.
    cnt = 0.
    count = strlen( pack ).
    IF count IS NOT INITIAL.
      DO count TIMES.
        result = pack+cnt(1).
        IF result CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
          CONCATENATE lv_alphabets result INTO lv_alphabets.
          CLEAR result.
        ELSE.
          CONCATENATE lv_numbers result INTO lv_numbers.
          CLEAR result.
        ENDIF.
        cnt = cnt + 1.
      ENDDO.
    ENDIF.
*WRITE:  'The Albhabets Are :', lv_alphabets.
*WRITE: 'The Numbers Are :', lv_numbers.
    SORT it_mat2 DESCENDING BY cc.

    READ TABLE it_mat2 INTO wa_mat2 WITH KEY matnr = wa_tab4-matnr.
    IF sy-subrc EQ 0.
      wa_tab5-cc = wa_mat2-cc.
      wa_tab5-pc = wa_mat2-pc.
      IF lv_alphabets CS 'ML' OR lv_alphabets CS 'GM'.
        rate = wa_mat2-cc / ( lv_numbers / 1000 ).
      ELSE.
        rate = wa_mat2-cc / lv_numbers .
      ENDIF.
      val = rate * wa_tab4-clabs.
      wa_tab5-rate = rate.
      wa_tab5-val = val.
    ELSE.
      READ TABLE it_zprd_ccpc INTO wa_zprd_ccpc WITH KEY matnr = wa_tab4-matnr.
      IF sy-subrc EQ 0.
        wa_tab5-cc = wa_zprd_ccpc-cc.
        wa_tab5-pc = wa_zprd_ccpc-pc.
        IF lv_alphabets CS 'ML' OR lv_alphabets CS 'GM'.
          rate = wa_zprd_ccpc-cc / ( lv_numbers / 1000 ).
        ELSE.
          rate = wa_zprd_ccpc-cc / lv_numbers .
        ENDIF.
        val = rate * wa_tab4-clabs.
        wa_tab5-rate = rate.
        wa_tab5-val = val.
      ENDIF.
    ENDIF.

    IF wa_tab5-cc EQ 0.
      READ TABLE it_mat2 INTO wa_mat2 WITH KEY idnrk = wa_tab4-halb.
      IF sy-subrc EQ 0.
        wa_tab5-cc = wa_mat2-cc.
        wa_tab5-pc = wa_mat2-pc.
        IF lv_alphabets CS 'ML' OR lv_alphabets CS 'GM'.
          rate = wa_mat2-cc / ( lv_numbers / 1000 ).
        ELSE.
          rate = wa_mat2-cc / lv_numbers .
        ENDIF.
        val = rate * wa_tab4-clabs.
        wa_tab5-rate = rate.
        wa_tab5-val = val.
      ENDIF.
    ENDIF.

*wa_tab5-total = wa_tab5-rmdmbtr + wa_tab5-pmdmbtr + val.
    wa_tab5-total = wa_tab5-rmval + wa_tab5-pmdmbtr + wa_tab5-val.
    COLLECT wa_tab5 INTO it_tab5.
    CLEAR wa_tab5.
  ENDLOOP.

  wa_fieldcat-fieldname = 'AUFNR'.
  wa_fieldcat-seltext_l = 'ORDER'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'PLANT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'LGORT'.
  wa_fieldcat-seltext_l = 'STORAGE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'HALB'.
  wa_fieldcat-seltext_l = 'PRODUCT CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'FINISHED PRODUCT CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_l = 'FG PACK SIZE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'PRODUCT NAME'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MEINS'.
  wa_fieldcat-seltext_l = 'UNIT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CLABS'.
  wa_fieldcat-seltext_l = 'QUANTITY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CC'.
  wa_fieldcat-seltext_l = 'CONVERSION CHARGE'.
  APPEND wa_fieldcat TO fieldcat.

*   wa_fieldcat-fieldname = 'PC'.
*  wa_fieldcat-seltext_l = 'PACKING CHARGE'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RATE'.
  wa_fieldcat-seltext_l = 'CC RATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'VAL'.
  wa_fieldcat-seltext_l = 'CC VALUE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'RMVAL'.
  wa_fieldcat-seltext_l = 'RM VALUE'.
  APPEND wa_fieldcat TO fieldcat.

*  wa_fieldcat-fieldname = 'RMDMBTR'.
*  wa_fieldcat-seltext_l = 'RM VALUE'.
*  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PMDMBTR'.
  wa_fieldcat-seltext_l = 'PM VALUE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'TOTAL'.
  wa_fieldcat-seltext_l = 'TOTAL VALUE'.
  APPEND wa_fieldcat TO fieldcat.

*   wa_fieldcat-fieldname = 'RMRATE'.
*  wa_fieldcat-seltext_l = 'RM RATE'.
*  append wa_fieldcat to fieldcat.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'SFG VALUATION'.

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
      t_outtab                = it_tab5
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

*endform.                    "SUMMARY

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top.

  DATA: comment    TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'SFG VALUATION on date :'.
  wa_comment-info+25(2) = sy-datum+6(2).
  wa_comment-info+27(1) = '.'.
  wa_comment-info+28(2) = sy-datum+4(2).
  wa_comment-info+30(1) = '.'.
  wa_comment-info+31(4) = sy-datum+0(4).
  wa_comment-info+36(4) = 'time'.
  wa_comment-info+41(2) = sy-uzeit+0(2).
  wa_comment-info+43(1) = ':'.
  wa_comment-info+44(2) = sy-uzeit+2(2).
  wa_comment-info+46(1) = ':'.
  wa_comment-info+47(2) = sy-uzeit+4(2).


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
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD selfield-value.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
