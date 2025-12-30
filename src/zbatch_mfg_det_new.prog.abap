*&---------------------------------------------------------------------*
*& Report  ZBATCH_MFG_DET
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zbatch_mfg_det_2.
TABLES : mseg,
         bkpf,
         rbkp,
         t007s,
         ekbe.

DATA: it_mseg TYPE TABLE OF mseg,
      wa_mseg TYPE mseg,
      it_rseg TYPE TABLE OF rseg,
      wa_rseg TYPE rseg,
      it_bseg TYPE TABLE OF bseg,
      wa_bseg TYPE bseg,
      it_bset TYPE TABLE OF bset,
      wa_bset TYPE bset,
      it_ekpo TYPE TABLE OF ekpo,
      wa_ekpo TYPE ekpo.

TYPES : BEGIN OF itab1,
          matnr TYPE mseg-matnr,
          charg TYPE mseg-charg,
          mblnr TYPE mseg-mblnr,
          mjahr TYPE mseg-mjahr,
          menge TYPE mseg-menge,
          ebeln TYPE mseg-ebeln,
          ebelp TYPE mseg-ebelp,
          lifnr TYPE lfa1-lifnr,
        END OF itab1.

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
          charg  TYPE mseg-charg,
          menge  TYPE mseg-menge,
        END OF itax1.

TYPES : BEGIN OF itax2,
          mblnr    TYPE mseg-mblnr,
          mjahr    TYPE mseg-mjahr,
          belnr    TYPE bkpf-belnr,
          gjahr    TYPE bkpf-gjahr,
          matnr    TYPE ekpo-matnr,
          charg    TYPE mseg-charg,
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
          mwskz    TYPE bset-mwskz,
          text(50) TYPE c,
          menge    TYPE mseg-menge,
        END OF itax2.

DATA: it_tab1 TYPE TABLE OF itab1,
      wa_tab1 TYPE itab1,
      it_tax1 TYPE TABLE OF itax1,
      wa_tax1 TYPE itax1,
      it_tax2 TYPE TABLE OF itax2,
      wa_tax2 TYPE itax2,
      it_tax3 TYPE TABLE OF itax2,
      wa_tax3 TYPE itax2.

DATA : doc TYPE bkpf-awkey,
       tax TYPE bseg-dmbtr.
TYPE-POOLS:  slis.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.

TYPES : BEGIN OF tp2,
          matnr  TYPE mcha-matnr,
          charg  TYPE mcha-charg,
          matnr1 TYPE mcha-matnr,
          charg1 TYPE mcha-charg,
        END OF tp2.

TYPES : BEGIN OF stk1,
          matnr TYPE mseg-matnr,
          charg TYPE mseg-charg,
          dmbtr TYPE mseg-dmbtr,
          menge TYPE mseg-menge,
          ebeln TYPE mseg-ebeln,
          ebelp TYPE mseg-ebelp,
          werks TYPE mseg-werks,
          mblnr TYPE mseg-mblnr,
          mjahr TYPE mseg-mjahr,
          bwart TYPE mseg-bwart,
          lifnr TYPE mseg-lifnr,
          emlif TYPE mseg-emlif,
        END OF stk1.

DATA : it_tp2  TYPE TABLE OF tp2,
       wa_tp2  TYPE tp2,
       it_stk2 TYPE TABLE OF stk1,
       wa_stk2 TYPE stk1.

SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE text-001.
*PARAMETERS  : material LIKE mseg-matnr OBLIGATORY,
*              batch    LIKE mseg-charg.
SELECT-OPTIONS : material FOR mseg-matnr OBLIGATORY,
            batch FOR mseg-charg.
SELECT-OPTIONS  year FOR mseg-gjahr OBLIGATORY.

PARAMETERS : r1 RADIOBUTTON GROUP r1,
             r2 RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK merkmale1 .


INITIALIZATION.
  g_repid = sy-repid.

START-OF-SELECTION.

  SELECT * FROM mseg INTO TABLE it_mseg WHERE mjahr IN year AND bwart IN ('101','102') AND matnr IN material AND charg IN batch AND lifnr NE space.
  IF it_mseg IS NOT INITIAL.
    LOOP AT it_mseg INTO wa_mseg.
      IF wa_mseg-shkzg EQ 'H'.
        wa_mseg-menge = wa_mseg-menge * ( - 1 ).
      ENDIF.
      wa_tab1-matnr = wa_mseg-matnr.
      wa_tab1-charg = wa_mseg-charg.
      wa_tab1-mblnr = wa_mseg-mblnr.
      wa_tab1-mjahr = wa_mseg-mjahr.
      wa_tab1-menge = wa_mseg-menge.
      wa_tab1-ebelp = wa_mseg-ebelp.
      wa_tab1-ebeln = wa_mseg-ebeln.
      wa_tab1-lifnr = wa_mseg-lifnr.
      COLLECT wa_tab1 INTO it_tab1.
      CLEAR wa_tab1.
    ENDLOOP.
  ENDIF.

  IF it_tab1 IS INITIAL.
    PERFORM form1.
  ENDIF.

  IF it_tab1 IS INITIAL.
    MESSAGE ' NO DATA FOUND ' TYPE 'I'.
    EXIT.
  ENDIF.

  LOOP AT it_tab1 INTO wa_tab1.
    WRITE : / 'A',wa_tab1-mblnr,wa_tab1-mblnr,wa_tab1-charg,wa_tab1-menge,wa_tab1-ebeln,wa_tab1-ebelp.
  ENDLOOP.


*******************************************************************************************************************
*  BREAK-POINT.
  IF it_tab1 IS NOT INITIAL.
    SELECT * FROM rseg INTO TABLE it_rseg FOR ALL ENTRIES IN it_tab1 WHERE  ebeln EQ it_tab1-ebeln AND
       ebelp EQ it_tab1-ebelp  AND matnr EQ it_tab1-matnr AND lfbnr EQ it_tab1-mblnr .
  ENDIF.
*  BREAK-POINT.
  IF it_rseg IS NOT INITIAL.
    LOOP AT it_rseg INTO wa_rseg.
      CLEAR doc.
*      BREAK-POINT.
      LOOP AT it_tab1 INTO wa_tab1 WHERE mblnr = wa_rseg-lfbnr AND mjahr = wa_rseg-lfgja.
        SELECT SINGLE * FROM ekbe WHERE ebeln EQ wa_rseg-ebeln AND ebelp EQ wa_rseg-ebelp  AND  matnr EQ wa_rseg-matnr  AND charg EQ wa_tab1-charg
          AND belnr EQ wa_rseg-lfbnr AND buzei EQ wa_rseg-lfpos.
        IF sy-subrc EQ 0.
*    IF SY-SUBRC EQ 0.
          wa_tax1-mblnr = wa_rseg-lfbnr.
          wa_tax1-menge = wa_tab1-menge.
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
          wa_tax1-charg = wa_tab1-charg.
*    WA_TAX1-LIFNR = WA_TAB1-LIFNR.
*    ENDIF.
          COLLECT wa_tax1 INTO it_tax1.
          CLEAR wa_tax1.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDIF.

  IF it_tax1 IS INITIAL.
    MESSAGE 'no data' TYPE 'I'.
    EXIT.
  ENDIF.


  IF it_tax1 IS NOT INITIAL.
*    BREAK-POINT .
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



  IF r1 EQ 'X'.
    PERFORM gst.
  ELSEIF r2 EQ 'X'.
    PERFORM nongst.
  ENDIF.


*  LOOP AT it_tax3 INTO wa_tax3.
*    WRITE : / 'A',wa_tax3-mblnr,wa_tax3-mjahr,wa_tax3-belnr,wa_tax3-gjahr,wa_tax3-matnr,wa_tax3-charg,
*    wa_tax3-ebeln,wa_tax3-ebelp,wa_tax3-hwbas,'a',wa_tax3-hwste,wa_tax3-rate,wa_tax3-igst,wa_tax3-cgst,
*    wa_tax3-sgst,wa_tax3-ugst,wa_tax3-othr,wa_tax3-mwskz.
*  ENDLOOP.


  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO NO.'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'EBELP'.
  wa_fieldcat-seltext_l = 'PO ITEM'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.


  wa_fieldcat-fieldname = 'MBLNR'.
  wa_fieldcat-seltext_l = 'DOC NO.'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MJAHR'.
  wa_fieldcat-seltext_l = 'DOC YEAR'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.
*
*
  wa_fieldcat-fieldname = 'MENGE'.
  wa_fieldcat-seltext_l = 'GRN QUANTITY'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.
*
  wa_fieldcat-fieldname = 'BELNR'.
  wa_fieldcat-seltext_l = 'FI DOC'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'GJAHR'.
  wa_fieldcat-seltext_l = 'FI YEAR'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'HWBAS'.
  wa_fieldcat-seltext_l = 'GST TAXABLE'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.
*
  wa_fieldcat-fieldname = 'HWSTE'.
  wa_fieldcat-seltext_l = 'GST TAX'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.
*
  wa_fieldcat-fieldname = 'RATE'.
  wa_fieldcat-seltext_l = 'GST RATE'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'IGST'.
  wa_fieldcat-seltext_l = 'IGST'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'CGST'.
  wa_fieldcat-seltext_l = 'CGST'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SGST'.
  wa_fieldcat-seltext_l = 'SGST'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'UGST'.
  wa_fieldcat-seltext_l = 'UGST'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'OTHR'.
  wa_fieldcat-seltext_l = 'TAX BEFORE GST'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MWSKZ'.
  wa_fieldcat-seltext_l = 'TAX CODE'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'TEXT'.
  wa_fieldcat-seltext_l = 'TAX CODE DESC.'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'MATERIAL CODE'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'BATCH RECEIPT DETAILS'.


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
      t_outtab                = it_tax3
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
  wa_comment-info = 'BATCH DETAILS'.
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
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form1 .
  SELECT * FROM mseg INTO TABLE it_mseg WHERE mjahr IN year AND bwart EQ '309' AND matnr IN material AND charg IN batch .

*   IF it_mat1 IS NOT INITIAL.
*    LOOP AT it_mat1 INTO wa_mat1.
  LOOP AT it_mseg INTO wa_mseg.
    READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = wa_mseg-matnr charg = wa_mseg-charg.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr AND charg = wa_mseg-charg AND xauto = ' '.
      IF sy-subrc EQ 0.
        wa_tp2-matnr = wa_mseg-matnr.
        wa_tp2-charg = wa_mseg-charg.
        wa_tp2-matnr1 = mseg-matnr.
        wa_tp2-charg1 = mseg-charg.
        IF wa_tp2-matnr EQ wa_tp2-matnr1.
          IF wa_tp2-charg EQ wa_tp2-charg1.
            DELETE it_mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr.
            READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = wa_mseg-matnr charg = wa_mseg-charg.
            IF sy-subrc EQ 0.
              SELECT SINGLE * FROM mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr AND xauto = ' '.
              IF sy-subrc EQ 0.
                wa_tp2-matnr = wa_mseg-matnr.
                wa_tp2-charg = wa_mseg-charg.
                wa_tp2-matnr1 = mseg-matnr.
                wa_tp2-charg1 = mseg-charg.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
        COLLECT wa_tp2 INTO it_tp2.
        CLEAR wa_tp2.
      ELSE.
        SELECT SINGLE * FROM mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr AND xauto = ' '.
        IF sy-subrc EQ 0.
          wa_tp2-matnr = wa_mseg-matnr.
          wa_tp2-charg = wa_mseg-charg.
          wa_tp2-matnr1 = mseg-matnr.
          wa_tp2-charg1 = mseg-charg.
          IF wa_tp2-matnr EQ wa_tp2-matnr1.
            IF wa_tp2-charg EQ wa_tp2-charg1.
              DELETE it_mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr.
              READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = wa_mseg-matnr charg = wa_mseg-charg.
              IF sy-subrc EQ 0.
                SELECT SINGLE * FROM mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr AND xauto = ' '.
                IF sy-subrc EQ 0.
                  wa_tp2-matnr = wa_mseg-matnr.
                  wa_tp2-charg = wa_mseg-charg.
                  wa_tp2-matnr1 = mseg-matnr.
                  wa_tp2-charg1 = mseg-charg.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
          COLLECT wa_tp2 INTO it_tp2.
          CLEAR wa_tp2.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
  LOOP AT it_tp2 INTO wa_tp2.
    IF wa_tp2-matnr = wa_tp2-matnr1 AND wa_tp2-charg = wa_tp2-charg1.
      DELETE it_tp2 WHERE matnr EQ wa_tp2-matnr.
    ENDIF.
  ENDLOOP.
**********************************************************************
*BREAK-POINT.
*  IF it_tp2 IS INITIAL.
*     SELECT * FROM mseg INTO TABLE it_mseg WHERE mjahr IN year AND bwart EQ '309' AND matnr EQ material AND charg EQ batch .
*    READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = material charg = batch.
*    IF sy-subrc EQ 0.
*      SELECT SINGLE * FROM mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr AND charg = wa_mseg-charg AND xauto NE space.
*      IF sy-subrc EQ 0.
*        wa_tp2-matnr = material.
*        wa_tp2-charg = batch.
*        wa_tp2-matnr1 = mseg-matnr.
*        wa_tp2-charg1 = mseg-charg.
*        IF wa_tp2-matnr EQ wa_tp2-matnr1.
*          IF wa_tp2-charg EQ wa_tp2-charg1.
*            DELETE it_mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr.
*            READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = material charg = batch.
*            IF sy-subrc EQ 0.
*              SELECT SINGLE * FROM mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr AND xauto NE space.
*              IF sy-subrc EQ 0.
*                wa_tp2-matnr = material.
*                wa_tp2-charg = batch.
*                wa_tp2-matnr1 = mseg-matnr.
*                wa_tp2-charg1 = mseg-charg.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.
*        COLLECT wa_tp2 INTO it_tp2.
*        CLEAR wa_tp2.
*      ELSE.
*        SELECT SINGLE * FROM mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr AND xauto NE space.
*        IF sy-subrc EQ 0.
*          wa_tp2-matnr = material.
*          wa_tp2-charg = batch.
*          wa_tp2-matnr1 = mseg-matnr.
*          wa_tp2-charg1 = mseg-charg.
*          IF wa_tp2-matnr EQ wa_tp2-matnr1.
*            IF wa_tp2-charg EQ wa_tp2-charg1.
*              DELETE it_mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr.
*              READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = material charg = batch.
*              IF sy-subrc EQ 0.
*                SELECT SINGLE * FROM mseg WHERE mblnr = wa_mseg-mblnr AND mjahr = wa_mseg-mjahr AND xauto NE space.
*                IF sy-subrc EQ 0.
*                  wa_tp2-matnr = material.
*                  wa_tp2-charg = batch.
*                  wa_tp2-matnr1 = mseg-matnr.
*                  wa_tp2-charg1 = mseg-charg.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*          COLLECT wa_tp2 INTO it_tp2.
*          CLEAR wa_tp2.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*  ENDIF.
*************************************************************************
*    ENDLOOP.
*  ENDIF.
  CLEAR : it_mseg,wa_mseg,it_ekpo,wa_ekpo.

  IF it_tp2 IS NOT INITIAL.
*    SELECT * FROM MCHA INTO TABLE IT_MCHA FOR ALL ENTRIES IN IT_MAT2 WHERE CHARG EQ IT_MAT1-CHARG1.
*    IF SY-SUBRC EQ 0.
*      SELECT * FROM MKPF INTO TABLE IT_MKPF FOR ALL ENTRIES IN IT_MCHA WHERE BUDAT EQ IT_MCHA-LWEDT AND VGART EQ 'WE'.
*      IF SY-SUBRC EQ 0.
    SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN  it_tp2 WHERE matnr EQ it_tp2-matnr1 AND charg EQ it_tp2-charg1 AND bwart IN ('101','102').
    IF sy-subrc EQ 0.
      SELECT * FROM ekpo INTO TABLE it_ekpo FOR ALL ENTRIES IN it_mseg WHERE ebeln = it_mseg-ebeln AND ebelp = it_mseg-ebelp.
    ENDIF.
  ENDIF.

*
*
  IF it_mseg IS NOT INITIAL.
    LOOP AT it_mseg INTO wa_mseg.
      IF wa_mseg-shkzg EQ 'H'.
        wa_mseg-dmbtr = wa_mseg-dmbtr * ( - 1 ).
        wa_mseg-menge = wa_mseg-menge * ( - 1 ).
      ENDIF.
      READ TABLE it_tp2 INTO wa_tp2 WITH KEY matnr1 = wa_mseg-matnr charg1 = wa_mseg-charg.
      IF sy-subrc EQ 0.
*        wa_stk2-matnr = wa_tp2-matnr.
*        wa_stk2-charg = wa_tp2-charg.
*        wa_stk2-dmbtr = wa_mseg-dmbtr.
*        wa_stk2-menge = wa_mseg-menge.
*        wa_stk2-ebeln = wa_mseg-ebeln.
*        wa_stk2-ebelp = wa_mseg-ebelp.
*        wa_stk2-werks = wa_mseg-werks.
*        wa_stk2-mblnr = wa_mseg-mblnr.
*        wa_stk2-mjahr = wa_mseg-mjahr.
*        wa_stk2-bwart = wa_mseg-bwart.
*        wa_stk2-menge = wa_mseg-menge.
*        wa_stk2-dmbtr = wa_mseg-dmbtr.
*        wa_stk2-lifnr = wa_mseg-lifnr.
*        wa_stk2-emlif = wa_mseg-emlif.
*        COLLECT wa_stk2 INTO it_stk2.
*        CLEAR wa_stk2.
        wa_tab1-matnr = wa_tp2-matnr1.
        wa_tab1-charg = wa_tp2-charg1.
*        wa_tab1-dmbtr = wa_mseg-dmbtr.
        wa_tab1-menge = wa_mseg-menge.
        wa_tab1-ebeln = wa_mseg-ebeln.
        wa_tab1-ebelp = wa_mseg-ebelp.
*        wa_tab1-werks = wa_mseg-werks.
        wa_tab1-mblnr = wa_mseg-mblnr.
        wa_tab1-mjahr = wa_mseg-mjahr.
*        wa_tab1-bwart = wa_mseg-bwart.
*        wa_tab1-menge = wa_mseg-menge.
*        wa_tab1-dmbtr = wa_mseg-dmbtr.
        wa_tab1-lifnr = wa_mseg-lifnr.
*        wa_tab1-emlif = wa_mseg-emlif.
        COLLECT wa_tab1 INTO it_tab1.
        CLEAR wa_tab1.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM gst .
*  BREAK-POINT.
  IF it_bset IS NOT INITIAL.
    LOOP AT it_bset INTO wa_bset.
*   READ TABLE IT_BSEG INTO WA_BSEG WITH KEY BELNR = WA_BSET-BELNR GJAHR = WA_BSET-GJAHR TXGRP = WA_BSET-TXGRP.
*   IF SY-SUBRC EQ 0.
*    BREAK-POINT.
**************************************************************
      READ TABLE it_bseg INTO wa_bseg WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr  txgrp = wa_bset-txgrp buzid = 'W'.
      IF sy-subrc EQ 0.
*      BREAK-POINT.
*************new*************************


**********************************
        LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND txgrp = wa_bset-txgrp AND buzid EQ 'W'.
*     LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND txgrp = wa_bset-txgrp AND mwart eq 'V'.
*   IF SY-SUBRC EQ 0.

*      WRITE : / 'A',WA_BSET-BELNR,WA_BSET-TXGRP.
          wa_tax2-ebeln = wa_bseg-ebeln.
          wa_tax2-ebelp = wa_bseg-ebelp.
          wa_tax2-belnr = wa_bset-belnr.
          wa_tax2-gjahr = wa_bset-gjahr.
          wa_tax2-txgrp = wa_bset-txgrp.
          wa_tax2-mwskz = wa_bset-mwskz.
          SELECT SINGLE * FROM t007s WHERE spras EQ 'EN' AND kalsm EQ 'TAXINN' AND mwskz EQ wa_bset-mwskz.
          IF sy-subrc EQ 0.
            wa_tax2-text = t007s-text1.
          ENDIF.


          READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln
          ebelp = wa_bseg-ebelp buzei = wa_bset-buzei.
          IF sy-subrc EQ 4.
**        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
*        wa_tax2-mblnr = wa_tax1-mblnr.
*        wa_tax2-buzei = wa_tax1-buzei.
*        wa_tax2-mjahr = wa_tax1-mjahr.
*        wa_tax2-matnr = wa_tax1-matnr.
*        DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei = wa_bset-buzei.
*      ELSE.
            READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp buzei1 = wa_bset-buzei.
            IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
              wa_tax2-mblnr = wa_tax1-mblnr.
              wa_tax2-buzei = wa_tax1-buzei.
              wa_tax2-mjahr = wa_tax1-mjahr.
              wa_tax2-matnr = wa_tax1-matnr.
              wa_tax2-charg = wa_tax1-charg.
              wa_tax2-menge = wa_tax1-menge.
              DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei1 = wa_bset-buzei.
            ELSE.
              READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp.
              IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
                wa_tax2-mblnr = wa_tax1-mblnr.
                wa_tax2-buzei = wa_tax1-buzei.
                wa_tax2-mjahr = wa_tax1-mjahr.
                wa_tax2-matnr = wa_tax1-matnr.
                wa_tax2-charg = wa_tax1-charg.
                wa_tax2-menge = wa_tax1-menge.
                DELETE it_tax1 WHERE mblnr EQ wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp.
              ENDIF.

            ENDIF.
          ELSE.
*   WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
            wa_tax2-mblnr = wa_tax1-mblnr.
            wa_tax2-buzei = wa_tax1-buzei.
            wa_tax2-mjahr = wa_tax1-mjahr.
            wa_tax2-matnr = wa_tax1-matnr.
            wa_tax2-charg = wa_tax1-charg.
            wa_tax2-menge = wa_tax1-menge.
            DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei = wa_bset-buzei.

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

  ELSE.

    SELECT * FROM bset INTO TABLE it_bset FOR ALL ENTRIES IN it_bseg WHERE bukrs EQ 'BCLL' AND belnr EQ
           it_bseg-belnr AND gjahr EQ it_bseg-gjahr .

    LOOP AT it_bset INTO wa_bset.
*   READ TABLE IT_BSEG INTO WA_BSEG WITH KEY BELNR = WA_BSET-BELNR GJAHR = WA_BSET-GJAHR TXGRP = WA_BSET-TXGRP.
*   IF SY-SUBRC EQ 0.
*    BREAK-POINT.
**************************************************************
      READ TABLE it_bseg INTO wa_bseg WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr  buzid = 'W'.
      IF sy-subrc EQ 0.
*      BREAK-POINT.

**********************************
        LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND buzid EQ 'W'.
*     LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND txgrp = wa_bset-txgrp AND mwart eq 'V'.
*   IF SY-SUBRC EQ 0.

*      WRITE : / 'A',WA_BSET-BELNR,WA_BSET-TXGRP.
          wa_tax2-ebeln = wa_bseg-ebeln.
          wa_tax2-ebelp = wa_bseg-ebelp.
          wa_tax2-belnr = wa_bset-belnr.
          wa_tax2-gjahr = wa_bset-gjahr.
          wa_tax2-txgrp = wa_bset-txgrp.
          wa_tax2-mwskz = wa_bset-mwskz.
          SELECT SINGLE * FROM t007s WHERE spras EQ 'EN' AND kalsm EQ 'TAXINN' AND mwskz EQ wa_bset-mwskz.
          IF sy-subrc EQ 0.
            wa_tax2-text = t007s-text1.
          ENDIF.


          READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln
          ebelp = wa_bseg-ebelp buzei = wa_bset-buzei.
          IF sy-subrc EQ 4.
**        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
*        wa_tax2-mblnr = wa_tax1-mblnr.
*        wa_tax2-buzei = wa_tax1-buzei.
*        wa_tax2-mjahr = wa_tax1-mjahr.
*        wa_tax2-matnr = wa_tax1-matnr.
*        DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei = wa_bset-buzei.
*      ELSE.
            READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp buzei1 = wa_bset-buzei.
            IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
              wa_tax2-mblnr = wa_tax1-mblnr.
              wa_tax2-buzei = wa_tax1-buzei.
              wa_tax2-mjahr = wa_tax1-mjahr.
              wa_tax2-matnr = wa_tax1-matnr.
              wa_tax2-charg = wa_tax1-charg.
              wa_tax2-menge = wa_tax1-menge.
              DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei1 = wa_bset-buzei.
            ELSE.
              READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp.
              IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
                wa_tax2-mblnr = wa_tax1-mblnr.
                wa_tax2-buzei = wa_tax1-buzei.
                wa_tax2-mjahr = wa_tax1-mjahr.
                wa_tax2-matnr = wa_tax1-matnr.
                wa_tax2-charg = wa_tax1-charg.
                wa_tax2-menge = wa_tax1-menge.
                DELETE it_tax1 WHERE mblnr EQ wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp.
              ENDIF.

            ENDIF.
          ELSE.
*   WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
            wa_tax2-mblnr = wa_tax1-mblnr.
            wa_tax2-buzei = wa_tax1-buzei.
            wa_tax2-mjahr = wa_tax1-mjahr.
            wa_tax2-matnr = wa_tax1-matnr.
            wa_tax2-charg = wa_tax1-charg.
            wa_tax2-menge = wa_tax1-menge.
            DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei = wa_bset-buzei.

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


  ENDIF.
*  BREAK-POINT.
*  IF r1 EQ 'X'.
  LOOP AT it_tax2 INTO wa_tax2 WHERE mblnr NE space.
    CLEAR : tax.
    tax = wa_tax2-igst + wa_tax2-cgst.
    IF tax GT 0.
*    IF tax NE 0.
      wa_tax3-mblnr = wa_tax2-mblnr.
      wa_tax3-buzei = wa_tax2-buzei.
      wa_tax3-mjahr = wa_tax2-mjahr.
      wa_tax3-matnr = wa_tax2-matnr.
      wa_tax3-charg = wa_tax2-charg.
      wa_tax3-mwskz = wa_tax2-mwskz.
      wa_tax3-text = wa_tax2-text.
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
      wa_tax3-menge = wa_tax2-menge.
      IF tax EQ 0.
        wa_tax3-othr = wa_tax2-hwste.
      ELSE.
        wa_tax3-othr = 0.
      ENDIF.
      wa_tax3-ebeln = wa_tax2-ebeln.
      wa_tax3-ebelp = wa_tax2-ebelp.
      COLLECT wa_tax3 INTO it_tax3.
      CLEAR wa_tax3.
    ENDIF.
  ENDLOOP.

*  ELSEIF r2 EQ 'X'.
*    LOOP AT it_tax2 INTO wa_tax2.
*      CLEAR : tax.
*      tax = wa_tax2-igst + wa_tax2-cgst.
**    IF tax GT 0.
**    IF tax NE 0.
*      wa_tax3-mblnr = wa_tax2-mblnr.
*      wa_tax3-buzei = wa_tax2-buzei.
*      wa_tax3-mjahr = wa_tax2-mjahr.
*      wa_tax3-matnr = wa_tax2-matnr.
*      wa_tax3-charg = wa_tax2-charg.
*      wa_tax3-mwskz = wa_tax2-mwskz.
*      wa_tax3-text = wa_tax2-text.
*      wa_tax3-txgrp = wa_tax2-txgrp.
*      wa_tax3-belnr = wa_tax2-belnr.
*      wa_tax3-gjahr = wa_tax2-gjahr.
*      wa_tax3-txgrp = wa_tax2-txgrp.
*      wa_tax3-hwbas = wa_tax2-hwbas.
*      wa_tax3-hwste = wa_tax2-hwste.
*      wa_tax3-igst = wa_tax2-igst.
*      wa_tax3-cgst = wa_tax2-cgst.
*      wa_tax3-sgst = wa_tax2-sgst.
*      wa_tax3-ugst = wa_tax2-ugst.
*      wa_tax3-rate = wa_tax2-rate.
*      IF tax EQ 0.
*        wa_tax3-othr = wa_tax2-hwste.
*      ELSE.
*        wa_tax3-othr = 0.
*      ENDIF.
*      wa_tax3-ebeln = wa_tax2-ebeln.
*      wa_tax3-ebelp = wa_tax2-ebelp.
*      COLLECT wa_tax3 INTO it_tax3.
*      CLEAR wa_tax3.
**    ENDIF.
*    ENDLOOP.
*
*  ENDIF.




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  NONGST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM nongst .


  IF it_bset IS NOT INITIAL.
    LOOP AT it_bset INTO wa_bset.
*   READ TABLE IT_BSEG INTO WA_BSEG WITH KEY BELNR = WA_BSET-BELNR GJAHR = WA_BSET-GJAHR TXGRP = WA_BSET-TXGRP.
*   IF SY-SUBRC EQ 0.
*    BREAK-POINT.
**************************************************************
      READ TABLE it_bseg INTO wa_bseg WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr  txgrp = wa_bset-txgrp buzid = 'W'.
      IF sy-subrc EQ 0.
*      BREAK-POINT.

**********************************
        LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND txgrp = wa_bset-txgrp AND buzid EQ 'W'.
*     LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND txgrp = wa_bset-txgrp AND mwart eq 'V'.
*   IF SY-SUBRC EQ 0.

*      WRITE : / 'A',WA_BSET-BELNR,WA_BSET-TXGRP.
          wa_tax2-ebeln = wa_bseg-ebeln.
          wa_tax2-ebelp = wa_bseg-ebelp.
          wa_tax2-belnr = wa_bset-belnr.
          wa_tax2-gjahr = wa_bset-gjahr.
          wa_tax2-txgrp = wa_bset-txgrp.
          wa_tax2-mwskz = wa_bset-mwskz.
          SELECT SINGLE * FROM t007s WHERE spras EQ 'EN' AND kalsm EQ 'TAXINN' AND mwskz EQ wa_bset-mwskz.
          IF sy-subrc EQ 0.
            wa_tax2-text = t007s-text1.
          ENDIF.


          READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln
          ebelp = wa_bseg-ebelp buzei = wa_bset-buzei.
          IF sy-subrc EQ 4.
**        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
*        wa_tax2-mblnr = wa_tax1-mblnr.
*        wa_tax2-buzei = wa_tax1-buzei.
*        wa_tax2-mjahr = wa_tax1-mjahr.
*        wa_tax2-matnr = wa_tax1-matnr.
*        DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei = wa_bset-buzei.
*      ELSE.
            READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp buzei1 = wa_bset-buzei.
            IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
              wa_tax2-mblnr = wa_tax1-mblnr.
              wa_tax2-buzei = wa_tax1-buzei.
              wa_tax2-mjahr = wa_tax1-mjahr.
              wa_tax2-matnr = wa_tax1-matnr.
              wa_tax2-charg = wa_tax1-charg.
              wa_tax2-menge = wa_tax1-menge.
              DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei1 = wa_bset-buzei.
            ELSE.
              READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp.
              IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
                wa_tax2-mblnr = wa_tax1-mblnr.
                wa_tax2-buzei = wa_tax1-buzei.
                wa_tax2-mjahr = wa_tax1-mjahr.
                wa_tax2-matnr = wa_tax1-matnr.
                wa_tax2-charg = wa_tax1-charg.
                wa_tax2-menge = wa_tax1-menge.
                DELETE it_tax1 WHERE mblnr EQ wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp.
              ENDIF.

            ENDIF.
          ELSE.
*   WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
            wa_tax2-mblnr = wa_tax1-mblnr.
            wa_tax2-buzei = wa_tax1-buzei.
            wa_tax2-mjahr = wa_tax1-mjahr.
            wa_tax2-matnr = wa_tax1-matnr.
            wa_tax2-charg = wa_tax1-charg.
            wa_tax2-menge = wa_tax1-menge.
            DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei = wa_bset-buzei.

          ENDIF.
*     WA_TAX2-MWSKZ = WA_BSET-MWSKZ.
          IF wa_bset-shkzg EQ 'H'.
            wa_bset-hwste = wa_bset-hwste * ( - 1 ).
            wa_bset-hwbas = wa_bset-hwbas * ( - 1 ).
          ENDIF.

*          IF wa_bset-ktosl EQ 'JII' OR wa_bset-ktosl EQ 'JOI' OR wa_bset-ktosl EQ 'JIM'.
          wa_tax2-hwste = wa_bset-hwste.
          wa_tax2-hwbas = wa_bset-hwbas.
*          ELSE.
*            wa_tax2-hwste = wa_bset-hwste * 2.
*            IF wa_bset-ktosl EQ 'JIC'.
*              wa_tax2-cgst = wa_bset-hwste.
**        endif.
**        if wa_bset-ktosl eq 'JIS'.
*              READ TABLE it_bset INTO wa_bset WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr txgrp = wa_bset-txgrp ktosl = 'JIS'.
*              IF sy-subrc EQ 0.
*                wa_tax2-sgst = wa_bset-hwste.
*              ENDIF.
*              READ TABLE it_bset INTO wa_bset WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr txgrp = wa_bset-txgrp ktosl = 'JIU'.
*              IF sy-subrc EQ 0.
*                wa_tax2-ugst = wa_bset-hwste.
*              ENDIF.
*            ENDIF.
**       WA_TAX2-OTHR = WA_BSET-HWSTE.
*          ENDIF.
*     ENDIF.
*          IF wa_bset-ktosl EQ 'JII' OR wa_bset-ktosl EQ 'JRI' OR wa_bset-ktosl EQ 'JOI' OR wa_bset-ktosl EQ 'JIM'.
          wa_tax2-rate = ( wa_bset-kbetr / 10 ).
*     ELSEIF WA_BSET-KTOSL EQ 'NVV'.
*      WA_TAX2-RATE = ( WA_BSET-KBETR / 10 ).
*          ELSE.
*            wa_tax2-rate = ( wa_bset-kbetr / 10 ) * 2.
*          ENDIF.
*     WA_TAX1-KTOSL = WA_BSET-KTOSL.
*          IF wa_bset-ktosl EQ 'JII'.
*            wa_tax2-hwbas = wa_bset-hwbas.
*          ELSEIF wa_bset-ktosl EQ 'JIC' OR wa_bset-ktosl EQ 'JIS'.
*            wa_tax2-hwbas = wa_bset-hwbas.
*          ELSEIF wa_bset-ktosl EQ 'JRC'.
**     WA_TAX1-HWBAS = WA_BSET-HWBAS.
*          ELSEIF wa_bset-ktosl EQ 'JOI'.
*            wa_tax2-hwbas = wa_bset-hwbas.
*          ELSEIF wa_bset-ktosl EQ 'JIM'.
*            wa_tax2-hwbas = wa_bset-hwbas.
*
*
**     ELSEIF WA_BSET-KTOSL EQ 'NVV'.
**     WA_TAX2-HWBAS = WA_BSET-HWBAS.
*          ENDIF.
          COLLECT wa_tax2 INTO it_tax2.
          CLEAR wa_tax2.
*    ENDIF.
*    ENDIF.
************************************************************************************************************
        ENDLOOP.
      ENDIF.
    ENDLOOP.

  ELSE.

    SELECT * FROM bset INTO TABLE it_bset FOR ALL ENTRIES IN it_bseg WHERE bukrs EQ 'BCLL' AND belnr EQ
           it_bseg-belnr AND gjahr EQ it_bseg-gjahr .

    LOOP AT it_bset INTO wa_bset.
*   READ TABLE IT_BSEG INTO WA_BSEG WITH KEY BELNR = WA_BSET-BELNR GJAHR = WA_BSET-GJAHR TXGRP = WA_BSET-TXGRP.
*   IF SY-SUBRC EQ 0.
*    BREAK-POINT.
**************************************************************
      READ TABLE it_bseg INTO wa_bseg WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr  buzid = 'W'.
      IF sy-subrc EQ 0.
*      BREAK-POINT.

**********************************
        LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND buzid EQ 'W'.
*     LOOP AT it_bseg INTO wa_bseg WHERE belnr = wa_bset-belnr AND gjahr = wa_bset-gjahr AND txgrp = wa_bset-txgrp AND mwart eq 'V'.
*   IF SY-SUBRC EQ 0.

*      WRITE : / 'A',WA_BSET-BELNR,WA_BSET-TXGRP.
          wa_tax2-ebeln = wa_bseg-ebeln.
          wa_tax2-ebelp = wa_bseg-ebelp.
          wa_tax2-belnr = wa_bset-belnr.
          wa_tax2-gjahr = wa_bset-gjahr.
          wa_tax2-txgrp = wa_bset-txgrp.
          wa_tax2-mwskz = wa_bset-mwskz.
          SELECT SINGLE * FROM t007s WHERE spras EQ 'EN' AND kalsm EQ 'TAXINN' AND mwskz EQ wa_bset-mwskz.
          IF sy-subrc EQ 0.
            wa_tax2-text = t007s-text1.
          ENDIF.


          READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln
          ebelp = wa_bseg-ebelp buzei = wa_bset-buzei.
          IF sy-subrc EQ 4.
**        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
*        wa_tax2-mblnr = wa_tax1-mblnr.
*        wa_tax2-buzei = wa_tax1-buzei.
*        wa_tax2-mjahr = wa_tax1-mjahr.
*        wa_tax2-matnr = wa_tax1-matnr.
*        DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei = wa_bset-buzei.
*      ELSE.
            READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp buzei1 = wa_bset-buzei.
            IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
              wa_tax2-mblnr = wa_tax1-mblnr.
              wa_tax2-buzei = wa_tax1-buzei.
              wa_tax2-mjahr = wa_tax1-mjahr.
              wa_tax2-matnr = wa_tax1-matnr.
              wa_tax2-charg = wa_tax1-charg.
              wa_tax2-menge = wa_tax1-menge.
              DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei1 = wa_bset-buzei.
            ELSE.
              READ TABLE it_tax1 INTO wa_tax1 WITH KEY belnr = wa_bseg-belnr gjahr = wa_bseg-gjahr ebeln = wa_bseg-ebeln ebelp = wa_bseg-ebelp.
              IF sy-subrc EQ 0.
*        WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
                wa_tax2-mblnr = wa_tax1-mblnr.
                wa_tax2-buzei = wa_tax1-buzei.
                wa_tax2-mjahr = wa_tax1-mjahr.
                wa_tax2-matnr = wa_tax1-matnr.
                wa_tax2-charg = wa_tax1-charg.
                wa_tax2-menge = wa_tax1-menge.
                DELETE it_tax1 WHERE mblnr EQ wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp.
              ENDIF.

            ENDIF.
          ELSE.
*   WRITE : WA_TAX1-MBLNR,WA_TAX1-BUZEI.
            wa_tax2-mblnr = wa_tax1-mblnr.
            wa_tax2-buzei = wa_tax1-buzei.
            wa_tax2-mjahr = wa_tax1-mjahr.
            wa_tax2-matnr = wa_tax1-matnr.
            wa_tax2-charg = wa_tax1-charg.
            wa_tax2-menge = wa_tax1-menge.
            DELETE it_tax1 WHERE mblnr = wa_tax1-mblnr AND belnr = wa_bseg-belnr AND gjahr = wa_bseg-gjahr AND ebeln = wa_bseg-ebeln AND ebelp = wa_bseg-ebelp AND buzei = wa_bset-buzei.

          ENDIF.
*     WA_TAX2-MWSKZ = WA_BSET-MWSKZ.
          IF wa_bset-shkzg EQ 'H'.
            wa_bset-hwste = wa_bset-hwste * ( - 1 ).
            wa_bset-hwbas = wa_bset-hwbas * ( - 1 ).
          ENDIF.

*          IF wa_bset-ktosl EQ 'JII' OR wa_bset-ktosl EQ 'JOI' OR wa_bset-ktosl EQ 'JIM'.
          wa_tax2-hwbas = wa_bset-hwbas.
          wa_tax2-hwste = wa_bset-hwste.
*          ELSE.
*            wa_tax2-hwste = wa_bset-hwste * 2.
*            IF wa_bset-ktosl EQ 'JIC'.
*              wa_tax2-cgst = wa_bset-hwste.
**        endif.
**        if wa_bset-ktosl eq 'JIS'.
*              READ TABLE it_bset INTO wa_bset WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr txgrp = wa_bset-txgrp ktosl = 'JIS'.
*              IF sy-subrc EQ 0.
*                wa_tax2-sgst = wa_bset-hwste.
*              ENDIF.
*              READ TABLE it_bset INTO wa_bset WITH KEY belnr = wa_bset-belnr gjahr = wa_bset-gjahr txgrp = wa_bset-txgrp ktosl = 'JIU'.
*              IF sy-subrc EQ 0.
*                wa_tax2-ugst = wa_bset-hwste.
*              ENDIF.
*            ENDIF.
**       WA_TAX2-OTHR = WA_BSET-HWSTE.
*          ENDIF.
*     ENDIF.
*          IF wa_bset-ktosl EQ 'JII' OR wa_bset-ktosl EQ 'JRI' OR wa_bset-ktosl EQ 'JOI' OR wa_bset-ktosl EQ 'JIM'.
          wa_tax2-rate = ( wa_bset-kbetr / 10 ).
*     ELSEIF WA_BSET-KTOSL EQ 'NVV'.
*      WA_TAX2-RATE = ( WA_BSET-KBETR / 10 ).
*          ELSE.
*            wa_tax2-rate = ( wa_bset-kbetr / 10 ) * 2.
*          ENDIF.
*     WA_TAX1-KTOSL = WA_BSET-KTOSL.
*          IF wa_bset-ktosl EQ 'JII'.
*            wa_tax2-hwbas = wa_bset-hwbas.
*          ELSEIF wa_bset-ktosl EQ 'JIC' OR wa_bset-ktosl EQ 'JIS'.
*            wa_tax2-hwbas = wa_bset-hwbas.
*          ELSEIF wa_bset-ktosl EQ 'JRC'.
**     WA_TAX1-HWBAS = WA_BSET-HWBAS.
*          ELSEIF wa_bset-ktosl EQ 'JOI'.
*            wa_tax2-hwbas = wa_bset-hwbas.
*          ELSEIF wa_bset-ktosl EQ 'JIM'.
*            wa_tax2-hwbas = wa_bset-hwbas.
*
*
**     ELSEIF WA_BSET-KTOSL EQ 'NVV'.
**     WA_TAX2-HWBAS = WA_BSET-HWBAS.
*          ENDIF.
          COLLECT wa_tax2 INTO it_tax2.
          CLEAR wa_tax2.
*    ENDIF.
*    ENDIF.
************************************************************************************************************
        ENDLOOP.
      ENDIF.
    ENDLOOP.


  ENDIF.
*  BREAK-POINT.
*  IF r1 EQ 'X'.
*    LOOP AT it_tax2 INTO wa_tax2.
*      CLEAR : tax.
*      tax = wa_tax2-igst + wa_tax2-cgst.
*      IF tax GT 0.
**    IF tax NE 0.
*        wa_tax3-mblnr = wa_tax2-mblnr.
*        wa_tax3-buzei = wa_tax2-buzei.
*        wa_tax3-mjahr = wa_tax2-mjahr.
*        wa_tax3-matnr = wa_tax2-matnr.
*        wa_tax3-charg = wa_tax2-charg.
*        wa_tax3-mwskz = wa_tax2-mwskz.
*        wa_tax3-text = wa_tax2-text.
*        wa_tax3-txgrp = wa_tax2-txgrp.
*        wa_tax3-belnr = wa_tax2-belnr.
*        wa_tax3-gjahr = wa_tax2-gjahr.
*        wa_tax3-txgrp = wa_tax2-txgrp.
*        wa_tax3-hwbas = wa_tax2-hwbas.
*        wa_tax3-hwste = wa_tax2-hwste.
*        wa_tax3-igst = wa_tax2-igst.
*        wa_tax3-cgst = wa_tax2-cgst.
*        wa_tax3-sgst = wa_tax2-sgst.
*        wa_tax3-ugst = wa_tax2-ugst.
*        wa_tax3-rate = wa_tax2-rate.
*        IF tax EQ 0.
*          wa_tax3-othr = wa_tax2-hwste.
*        ELSE.
*          wa_tax3-othr = 0.
*        ENDIF.
*        wa_tax3-ebeln = wa_tax2-ebeln.
*        wa_tax3-ebelp = wa_tax2-ebelp.
*        COLLECT wa_tax3 INTO it_tax3.
*        CLEAR wa_tax3.
*      ENDIF.
*    ENDLOOP.
*
**  ELSEIF r2 EQ 'X'.
  LOOP AT it_tax2 INTO wa_tax2.
    CLEAR : tax.
    tax = wa_tax2-igst + wa_tax2-cgst.
*    IF tax GT 0.
*    IF tax NE 0.
    wa_tax3-mblnr = wa_tax2-mblnr.
    wa_tax3-buzei = wa_tax2-buzei.
    wa_tax3-mjahr = wa_tax2-mjahr.
    wa_tax3-matnr = wa_tax2-matnr.
    wa_tax3-charg = wa_tax2-charg.
    wa_tax3-mwskz = wa_tax2-mwskz.
    wa_tax3-text = wa_tax2-text.
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
    IF tax EQ 0.
      wa_tax3-othr = wa_tax2-hwste.
    ELSE.
      wa_tax3-othr = 0.
    ENDIF.
    wa_tax3-ebeln = wa_tax2-ebeln.
    wa_tax3-ebelp = wa_tax2-ebelp.
    wa_tax3-menge = wa_tax2-menge.
    COLLECT wa_tax3 INTO it_tax3.
    CLEAR wa_tax3.
*    ENDIF.
  ENDLOOP.

*  ENDIF.




ENDFORM.
