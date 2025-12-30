*&---------------------------------------------------------------------*
*& Report  ZBATCH1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  zbatch1.
TABLES : mcha,
         mara,
         a501,
         konp,
         makt,
         a611.

TYPE-POOLS : slis.

DATA :  g_repid LIKE sy-repid,
      fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort TYPE slis_t_sortinfo_alv,
      wa_sort LIKE LINE OF sort,
      layout TYPE slis_layout_alv.

DATA : it_mcha TYPE TABLE OF mcha,
       wa_mcha TYPE mcha,
       it_mara TYPE TABLE OF mara,
       wa_mara TYPE mara,
       it_a501 TYPE TABLE OF a501,
       wa_a501 TYPE a501,
       it_konp TYPE TABLE OF konp,
       wa_konp TYPE konp.

TYPES : BEGIN OF itab1,
   mtart TYPE mara-mtart,
   werks TYPE mcha-werks,
   ersda TYPE mcha-ersda,
  matnr TYPE mcha-matnr,
  charg TYPE mcha-charg,
  hsdat TYPE mcha-hsdat,
  vfdat TYPE mcha-vfdat,
  END OF itab1.

TYPES : BEGIN OF itab2,
   mtart TYPE mara-mtart,
   werks TYPE mcha-werks,
   ersda TYPE mcha-ersda,
  matnr TYPE mcha-matnr,
  charg TYPE mcha-charg,
  hsdat TYPE mcha-hsdat,
  vfdat TYPE mcha-vfdat,
  kbetr TYPE konp-kbetr,
  maktx TYPE makt-maktx,
  END OF itab2.

TYPES : BEGIN OF itab3,
   mtart TYPE mara-mtart,
   werks TYPE mcha-werks,
   ersda TYPE mcha-ersda,
  matnr TYPE mcha-matnr,
  charg TYPE mcha-charg,
  hsdat TYPE mcha-hsdat,
  vfdat TYPE mcha-vfdat,
  kbetr TYPE konp-kbetr,
    maktx TYPE makt-maktx,
  END OF itab3.

TYPES : BEGIN OF itab4,
   mtart TYPE mara-mtart,
   werks TYPE mcha-werks,
   ersda TYPE mcha-ersda,
  matnr TYPE mcha-matnr,
  charg TYPE mcha-charg,
  hsdat TYPE mcha-hsdat,
  vfdat TYPE mcha-vfdat,
  kbetr TYPE konp-kbetr,
    maktx TYPE makt-maktx,
  END OF itab4.

DATA : it_tab1 TYPE TABLE OF itab1,
       wa_tab1 TYPE itab1,
       it_tab2 TYPE TABLE OF itab2,
       wa_tab2 TYPE itab2,
       it_tab3 TYPE TABLE OF itab3,
       wa_tab3 TYPE itab3,
       it_tab4 TYPE TABLE OF itab4,
       wa_tab4 TYPE itab4.

PARAMETERS : from_dt LIKE mcha-ersda OBLIGATORY,
             to_dt LIKE mcha-ersda OBLIGATORY.

PARAMETERS : plant LIKE mcha-werks OBLIGATORY.
SELECT-OPTIONS : type FOR mara-mtart OBLIGATORY,
                 material FOR mcha-matnr,
                 batch FOR mcha-charg.


PARAMETERS : r1 RADIOBUTTON GROUP r1,
             r2 RADIOBUTTON GROUP r1.


INITIALIZATION.

  g_repid = sy-repid.

START-OF-SELECTION.


  IF r1 EQ 'X'.
    PERFORM form1.
  ELSEIF r2 EQ 'X'.
    PERFORM form2.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM form1. "ed not maintain

  SELECT * FROM mcha INTO TABLE it_mcha WHERE ersda GE from_dt AND ersda  LE  to_dt AND werks EQ plant AND matnr IN material AND charg IN batch.
  IF sy-subrc EQ 0.
    SELECT  * FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_mcha WHERE matnr EQ it_mcha-matnr AND mtart IN type.
    IF sy-subrc NE 0.
      EXIT.
    ENDIF.
  ENDIF.

  LOOP AT it_mcha INTO wa_mcha.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_mcha-matnr.
    IF sy-subrc EQ 0.
*      write : / wa_mara-mtart.
*       write :  wa_mcha-werks,wa_mcha-ersda,wa_mcha-matnr,wa_mcha-charg,wa_mcha-hsdat,wa_mcha-vfdat.
      wa_tab1-mtart = wa_mara-mtart.
      wa_tab1-werks = wa_mcha-werks.
      wa_tab1-ersda = wa_mcha-ersda.
      wa_tab1-matnr = wa_mcha-matnr.
      wa_tab1-charg = wa_mcha-charg.
      wa_tab1-hsdat = wa_mcha-hsdat.
      wa_tab1-vfdat = wa_mcha-vfdat.
*       WA_TAB1-WERKS = WA_MCHA-WERKS.
      COLLECT wa_tab1 INTO it_tab1.
      CLEAR wa_tab1.
    ENDIF.
  ENDLOOP.



  IF it_tab1 IS  NOT INITIAL.
    SELECT * FROM a501 INTO TABLE it_a501 FOR ALL ENTRIES IN it_tab1 WHERE matnr EQ it_tab1-matnr AND charg EQ it_tab1-charg AND kschl EQ 'ZEX2' AND
      datab LE from_dt AND datbi GE to_dt.
    IF sy-subrc EQ 0.
      SELECT * FROM konp INTO TABLE it_konp FOR ALL ENTRIES IN it_a501 WHERE knumh EQ it_a501-knumh AND kschl EQ 'ZEX2'.
      IF  sy-subrc NE 0.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

  LOOP AT it_tab1 INTO wa_tab1.
*  write : / wa_tab1-mtart,wa_tab1-werks,wa_tab1-ersda,wa_tab1-matnr,wa_tab1-charg,wa_tab1-hsdat,wa_tab1-vfdat.
    wa_tab2-mtart = wa_tab1-mtart.
    wa_tab2-werks = wa_tab1-werks.
    wa_tab2-ersda = wa_tab1-ersda.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-hsdat = wa_tab1-hsdat.
    wa_tab2-vfdat = wa_tab1-vfdat.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_tab1-matnr.
    IF sy-subrc EQ 0.
      wa_tab2-maktx = makt-maktx.
    ENDIF.
    SELECT SINGLE * FROM a501 WHERE matnr = wa_tab1-matnr AND charg = wa_tab1-charg AND kschl = 'ZEX2' AND datbi GE to_dt.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM konp WHERE knumh = a501-knumh AND kschl = 'ZEX2'.
      IF sy-subrc EQ 0.
*          WRITE : KONP-KBETR.
        IF sy-subrc EQ 0.
          wa_tab2-kbetr = konp-kbetr / 10.
        ENDIF.
      ENDIF.
    ENDIF.
    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.

*  READ TABLE IT_A501 INTO WA_A501 WITH KEY MATNR = WA_TAB1-MATNR CHARG = WA_TAB1-CHARG KSCHL = 'ZEX2'.
*  IF SY-SUBRC EQ 0.
*    WRITE :  WA_A501-KNUMH.
*    READ TABLE IT_KONP INTO WA_KONP WITH KEY KNUMH = WA_A501-KNUMH KSCHL = 'ZEX2'.
*    IF SY-SUBRC EQ 0.
*      WRITE : WA_KONP-KBETR.
*    ENDIF.
*  ENDIF.
  ENDLOOP.

  LOOP AT it_tab2 INTO wa_tab2.
*  write : / 'CHECK1',wa_tab2-mtart,wa_tab2-werks,wa_tab2-ersda,wa_tab2-matnr,wa_tab2-charg,wa_tab2-hsdat,wa_tab2-vfdat,wa_tab2-kbetr.
    IF wa_tab2-kbetr EQ 0.
      SELECT SINGLE * FROM a611 WHERE matnr EQ wa_tab2-matnr AND charg EQ wa_tab2-charg AND
        kappl EQ 'V' AND kschl = 'ZEX2' AND vkorg EQ '1000' AND datab LE sy-datum AND datbi GE sy-datum.
      IF sy-subrc NE 0.
      MOVE-CORRESPONDING wa_tab2 TO wa_tab3.
      COLLECT wa_tab3 INTO it_tab3.

      CLEAR wa_tab3.
      ENDIF.
    ENDIF.

    IF wa_tab2-kbetr NE 0.
      MOVE-CORRESPONDING wa_tab2 TO wa_tab4.
      COLLECT wa_tab4 INTO it_tab4.

      CLEAR wa_tab4.
    ENDIF.

  ENDLOOP.




*IF R1 EQ 'X'.

  LOOP  AT it_tab3 INTO wa_tab3.
    PACK wa_tab3-matnr TO wa_tab3-matnr.
    CONDENSE wa_tab3-matnr.
    MODIFY it_tab3 FROM wa_tab3 TRANSPORTING matnr.
*   write : / 'CHECK1',wa_TAB3-mtart,wa_TAB3-werks,wa_TAB3-ersda,wa_TAB3-matnr,wa_TAB3-charg,wa_TAB3-hsdat,wa_TAB3-vfdat,wa_TAB3-kbetr.
  ENDLOOP.

  wa_fieldcat-fieldname = 'MTART'.
  wa_fieldcat-seltext_s = 'TYPE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_s = 'PLANT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ERSDA'.
  wa_fieldcat-seltext_s = 'BATCH CR. DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_s = 'CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_s = 'MATERIAL'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_s = 'BATCH'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'HSDAT'.
  wa_fieldcat-seltext_s = 'MFG. DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'VFDAT'.
  wa_fieldcat-seltext_s = 'EXP. DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'KBETR'.
  wa_fieldcat-seltext_s = 'ED'.
  APPEND wa_fieldcat TO fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'BATCH DETAIL'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
     i_callback_program                =  g_repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
   i_callback_user_command           = 'USER_COMM'
   i_callback_top_of_page            = 'TOP1'
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
      t_outtab                          = it_tab3
   EXCEPTIONS
     program_error                     = 1
     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.                                                    "FORM1

*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM form2.


  SELECT * FROM mcha INTO TABLE it_mcha WHERE ersda GE from_dt AND ersda  LE  to_dt AND werks EQ plant AND matnr IN material AND charg IN batch.
  IF sy-subrc EQ 0.
    SELECT  * FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_mcha WHERE matnr EQ it_mcha-matnr AND mtart IN type.
    IF sy-subrc NE 0.
      EXIT.
    ENDIF.
  ENDIF.

  LOOP AT it_mcha INTO wa_mcha.

    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_mcha-matnr.
    IF sy-subrc EQ 0.
*      write : / wa_mara-mtart.
*       write :  wa_mcha-werks,wa_mcha-ersda,wa_mcha-matnr,wa_mcha-charg,wa_mcha-hsdat,wa_mcha-vfdat.
      wa_tab1-mtart = wa_mara-mtart.
      wa_tab1-werks = wa_mcha-werks.
      wa_tab1-ersda = wa_mcha-ersda.
      wa_tab1-matnr = wa_mcha-matnr.
      wa_tab1-charg = wa_mcha-charg.
      wa_tab1-hsdat = wa_mcha-hsdat.
      wa_tab1-vfdat = wa_mcha-vfdat.
*       WA_TAB1-WERKS = WA_MCHA-WERKS.
      COLLECT wa_tab1 INTO it_tab1.
      CLEAR wa_tab1.
    ENDIF.
  ENDLOOP.



  IF it_tab1 IS  NOT INITIAL.
    SELECT * FROM a501 INTO TABLE it_a501 FOR ALL ENTRIES IN it_tab1 WHERE matnr EQ it_tab1-matnr AND charg EQ it_tab1-charg AND kschl EQ 'ZEX2' AND
      datab LE from_dt AND datbi GE to_dt.
    IF sy-subrc EQ 0.
      SELECT * FROM konp INTO TABLE it_konp FOR ALL ENTRIES IN it_a501 WHERE knumh EQ it_a501-knumh AND kschl EQ 'ZEX2'.
      IF  sy-subrc NE 0.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.

*IF it_tab1 IS  NOT INITIAL.
*    SELECT * FROM a611 INTO TABLE it_a611 FOR ALL ENTRIES IN it_tab1 WHERE matnr EQ it_tab1-matnr
*      AND charg EQ it_tab1-charg AND kschl EQ 'ZEX2' AND datab LE from_dt AND datbi GE to_dt.
*    IF sy-subrc EQ 0.
*      SELECT * FROM konp INTO TABLE it_konp FOR ALL ENTRIES IN it_a611 WHERE knumh EQ it_a611-knumh
*        AND kschl EQ 'ZEX2'.
*      IF  sy-subrc NE 0.
*        EXIT.
*      ENDIF.
*    ENDIF.
*  ENDIF.

  LOOP AT it_tab1 INTO wa_tab1.
*  write : / wa_tab1-mtart,wa_tab1-werks,wa_tab1-ersda,wa_tab1-matnr,wa_tab1-charg,wa_tab1-hsdat,wa_tab1-vfdat.
    wa_tab2-mtart = wa_tab1-mtart.
    wa_tab2-werks = wa_tab1-werks.
    wa_tab2-ersda = wa_tab1-ersda.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-hsdat = wa_tab1-hsdat.
    wa_tab2-vfdat = wa_tab1-vfdat.

    SELECT SINGLE * FROM makt WHERE matnr EQ wa_tab1-matnr.
    IF sy-subrc EQ 0.
      wa_tab2-maktx = makt-maktx.
    ENDIF.

    SELECT SINGLE * FROM a501 WHERE matnr = wa_tab1-matnr AND charg = wa_tab1-charg AND kschl = 'ZEX2' AND datbi GE to_dt.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM konp WHERE knumh = a501-knumh AND kschl = 'ZEX2'.
      IF sy-subrc EQ 0.
*          WRITE : KONP-KBETR.
        IF sy-subrc EQ 0.
          wa_tab2-kbetr = konp-kbetr / 10.
        ENDIF.
      ENDIF.
    else.

    SELECT SINGLE * FROM a611 WHERE matnr = wa_tab1-matnr AND charg = wa_tab1-charg AND kschl = 'ZEX2' AND
      datbi GE to_dt.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM konp WHERE knumh = a611-knumh AND kschl = 'ZEX2'.
      IF sy-subrc EQ 0.
*          WRITE : KONP-KBETR.
        IF sy-subrc EQ 0.
          wa_tab2-kbetr = konp-kbetr / 10.
        ENDIF.
      ENDIF.
    ENDIF.

    ENDIF.




    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.

*  READ TABLE IT_A501 INTO WA_A501 WITH KEY MATNR = WA_TAB1-MATNR CHARG = WA_TAB1-CHARG KSCHL = 'ZEX2'.
*  IF SY-SUBRC EQ 0.
*    WRITE :  WA_A501-KNUMH.
*    READ TABLE IT_KONP INTO WA_KONP WITH KEY KNUMH = WA_A501-KNUMH KSCHL = 'ZEX2'.
*    IF SY-SUBRC EQ 0.
*      WRITE : WA_KONP-KBETR.
*    ENDIF.
*  ENDIF.
  ENDLOOP.

  LOOP AT it_tab2 INTO wa_tab2.
*  write : / 'CHECK1',wa_tab2-mtart,wa_tab2-werks,wa_tab2-ersda,wa_tab2-matnr,wa_tab2-charg,wa_tab2-hsdat,wa_tab2-vfdat,wa_tab2-kbetr.
*    IF wa_tab2-kbetr EQ 0.
*      SELECT SINGLE * FROM a611 WHERE matnr EQ wa_tab2-matnr AND charg EQ wa_tab2-charg AND
*        kappl EQ 'V' AND kschl = 'ZEX2' AND vkorg EQ '1000' AND datab LE sy-datum AND datbi GE sy-datum.
*      IF sy-subrc EQ 0.
*         SELECT SINGLE * FROM konp WHERE knumh = a611-knumh AND kschl = 'ZEX2'.
*            IF sy-subrc EQ 0.
**      move-corresponding wa_tab2 to wa_tab3.
*               wa_tab4-mtart = wa_tab2-mtart.
*               wa_tab4-mtart = wa_tab2-werks.
*               wa_tab4-mtart = wa_tab2-ersda.
*               wa_tab4-mtart = wa_tab2-matnr.
*               wa_tab4-mtart = wa_tab2-charg.
*               wa_tab4-mtart = wa_tab2-hsdat.
*               wa_tab4-mtart = wa_tab2-vfdat.
*               wa_tab4-mtart = konp-kbetr.
*               wa_tab4-mtart = wa_tab2-maktx.
*               COLLECT wa_tab4 INTO it_tab4.
*               CLEAR wa_tab4.
*            ENDIF.
*     ENDIF.
*   ENDIF.

    IF wa_tab2-kbetr NE 0.
      MOVE-CORRESPONDING wa_tab2 TO wa_tab4.
      COLLECT wa_tab4 INTO it_tab4.

      CLEAR wa_tab4.
    ENDIF.

  ENDLOOP.




*IF R1 EQ 'X'.

  LOOP  AT it_tab4 INTO wa_tab4.
    PACK wa_tab4-matnr TO wa_tab4-matnr.
    CONDENSE wa_tab4-matnr.
    MODIFY it_tab4 FROM wa_tab4 TRANSPORTING matnr.
*   write : / 'CHECK1',wa_TAB4-mtart,wa_TAB4-werks,wa_TAB4-ersda,wa_TAB4-matnr,wa_TAB4-charg,wa_TAB4-hsdat,wa_TAB4-vfdat,wa_TAB4-kbetr.
  ENDLOOP.

  wa_fieldcat-fieldname = 'MTART'.
  wa_fieldcat-seltext_s = 'TYPE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_s = 'PLANT'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'ERSDA'.
  wa_fieldcat-seltext_s = 'BATCH CR. DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_s = 'CODE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_s = 'MATERIAL'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_s = 'BATCH'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'HSDAT'.
  wa_fieldcat-seltext_s = 'MFG. DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'VFDAT'.
  wa_fieldcat-seltext_s = 'EXP. DATE'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'KBETR'.
  wa_fieldcat-seltext_s = 'ED'.
  APPEND wa_fieldcat TO fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'PLANT WISE STOCK TRANSFER DETAIL'.


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
      t_outtab                          = it_tab4
   EXCEPTIONS
     program_error                     = 1
     OTHERS                            = 2
            .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



ENDFORM.                                                    "FORM2

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top.

  DATA: comment TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'BATCHES WHERE ED MAINTAINED'.
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
*&      Form  TOP1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top1.

  DATA: comment TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'BATCHES WHERE ED NOT MAINTAINED'.
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

ENDFORM.                                                    "TOP1


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
    WHEN 'MATNR'.
      SET PARAMETER ID 'MAT' FIELD selfield-value.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD selfield-value.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
