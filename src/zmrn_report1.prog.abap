*&---------------------------------------------------------------------*
*& Report  ZMRN_REPORT1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zmrn_report1_a1.
TABLES: zmrn,
        makt,
        mara,
        mast,
        stpo,
        mchb,
        zpassw,
        afpo,
        zmrn_ord,
*        ZMRN_REMOVE,
        mkpf,
        mseg.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.


DATA: it_dropdown TYPE lvc_t_drop,
      ty_dropdown TYPE lvc_s_drop,
*data declaration for refreshing of alv
      stable      TYPE lvc_s_stbl.
*Global variable declaration
DATA: gstring TYPE c.
*Data declarations for ALV
DATA: c_ccont   TYPE REF TO cl_gui_custom_container,         "Custom container object
      c_alvgd   TYPE REF TO cl_gui_alv_grid,         "ALV grid object
      it_fcat   TYPE lvc_t_fcat,                  "Field catalogue
      it_layout TYPE lvc_s_layo.                  "Layout
*ok code declaration
DATA:
  ok_code       TYPE ui_func.
DATA: it_zmrn TYPE TABLE OF zmrn,
      wa_zmrn TYPE zmrn,
      it_mchb TYPE TABLE OF mchb,
      wa_mchb TYPE mchb,
      it_mseg TYPE TABLE OF mseg,
      wa_mseg TYPE mseg.
*      IT_ZMRN_REMOVE TYPE TABLE OF ZMRN_REMOVE,
*      WA_ZMRN_REMOVE TYPE ZMRN_REMOVE.


TYPES : BEGIN OF disp1,
          pmmatnr TYPE mchb-matnr,
          werks   TYPE mchb-werks,
          maktx   TYPE makt-maktx,
          fgmatnr TYPE mchb-matnr,
          pmmaktx TYPE makt-maktx,
          fgmaktx TYPE makt-maktx,
          monat   TYPE bkpf-monat,
          cpudt   TYPE sy-datum,
          usnam   TYPE bkpf-usnam,
        END OF disp1.

TYPES : BEGIN OF itab1,
          pmmatnr TYPE mchb-matnr,
          werks   TYPE mchb-werks,
          maktx   TYPE makt-maktx,
          fgmatnr TYPE mchb-matnr,
          monat   TYPE bkpf-monat,
        END OF itab1.

TYPES : BEGIN OF mrnstk1,
          matnr TYPE mchb-matnr,
        END OF mrnstk1.

TYPES : BEGIN OF chk1,
          fgmatnr TYPE afpo-matnr,
          fgcharg TYPE afpo-charg,
          mblnr   TYPE mseg-mblnr,
          matnr   TYPE mseg-matnr,
          charg   TYPE mseg-charg,
          menge   TYPE mseg-menge,
          lgort   TYPE mseg-lgort,
          grp     TYPE zmrn-monat,
          werks   TYPE mseg-werks,
          bwart   TYPE mseg-bwart,
        END OF chk1.

TYPES : BEGIN OF chk2,
          fgmatnr TYPE afpo-matnr,
          matnr   TYPE mseg-matnr,
          charg   TYPE mseg-charg,
          menge   TYPE mseg-menge,
          lgort   TYPE mseg-lgort,

        END OF chk2.

TYPES : BEGIN OF stk1,
          matnr TYPE mseg-matnr,
          charg TYPE mseg-charg,
          stock TYPE mseg-menge,
          lgort TYPE mseg-lgort,
        END OF stk1.
TYPES : BEGIN OF doc1,
          mblnr    TYPE mseg-mblnr,
          matnr    TYPE mseg-matnr,
          charg    TYPE mseg-charg,
          maktx    TYPE makt-maktx,
          count(2) TYPE c,
        END OF doc1.
DATA: it_tab1    TYPE TABLE OF itab1,
      wa_tab1    TYPE itab1,
      it_disp1   TYPE TABLE OF disp1,
      wa_disp1   TYPE disp1,
      it_mrnstk1 TYPE TABLE OF mrnstk1,
      wa_mrnstk1 TYPE mrnstk1,
      it_chk1    TYPE TABLE OF chk1,
      wa_chk1    TYPE chk1,
      it_chk2    TYPE TABLE OF chk2,
      wa_chk2    TYPE chk2,
      it_stk1    TYPE TABLE OF stk1,
      wa_stk1    TYPE stk1,
      it_doc1    TYPE TABLE OF doc1,
      wa_doc1    TYPE doc1.
DATA: count(2) TYPE c.
DATA: stock    TYPE mchb-clabs,
      totstock TYPE mchb-clabs.
DATA: maktx1    TYPE makt-maktx,
      maktx2    TYPE makt-maktx,
      maktx(81) TYPE c.

DATA: zmrn_wa TYPE zmrn.
*DATA : ZMRN_REMOVE_WA TYPE  ZMRN_REMOVE.
DATA: a TYPE i.
DATA: aplant TYPE mchb-werks.
DATA : msg TYPE string.
TYPES: BEGIN OF typ_t001w,
         werks TYPE werks_d,
         name1 TYPE name1,
       END OF typ_t001w.

DATA : itab_t001w TYPE TABLE OF typ_t001w,
       wa_t001w   TYPE typ_t001w.
DATA:
*      v_ac_xstring type xstring,
  v_en_string TYPE string,
*      v_en_xstring type xstring,
  v_de_string TYPE string,
*      v_de_xstring type string,
  v_error_msg TYPE string.
DATA: o_encryptor        TYPE REF TO cl_hard_wired_encryptor,
      o_cx_encrypt_error TYPE REF TO cx_encrypt_error.
DATA:  zmrn_ord_wa TYPE  zmrn_ord.
*DATA: G_REPID     LIKE SY-REPID.

*SELECTION-SCREEN BEGIN OF BLOCK merkmale2 WITH FRAME TITLE TEXT-001.
*  PARAMETERS : pernr    LIKE pa0001-pernr MATCHCODE OBJECT prem,
*               pass(10) TYPE c.
*SELECTION-SCREEN END OF BLOCK merkmale2.


SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : mrnplt LIKE mcha-werks.
  SELECT-OPTIONS : mrnmatnr FOR mara-matnr.
  PARAMETERS : r4 RADIOBUTTON GROUP r1.
  PARAMETERS : allmov AS CHECKBOX.
*             r5 radiobutton group r1,
*             r6 radiobutton group r1.

  PARAMETERS : r1 RADIOBUTTON GROUP r1.
  PARAMETERS : pmmatnr TYPE mara-matnr,
               werks   TYPE mchb-werks.
  PARAMETERS : r2 RADIOBUTTON GROUP r1.

  SELECT-OPTIONS : werks1 FOR mchb-werks.
*PARAMETERS : R3 RADIOBUTTON GROUP R1.
*PARAMETERS : ORDER LIKE AFPO-AUFNR.

SELECTION-SCREEN END OF BLOCK merkmale1.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK screen-name EQ 'PASS'.
    screen-invisible = 1.
    MODIFY SCREEN.
  ENDLOOP.

INITIALIZATION.
  g_repid = sy-repid.

AT SELECTION-SCREEN.
  PERFORM authorization.

START-OF-SELECTION.

  IF r1 EQ 'X'.
*    PERFORM passw.
    PERFORM pmdata.
  ELSEIF r2 EQ 'X'.
    PERFORM display.
*  ELSEIF R3 EQ 'X'.
*    PERFORM PASSW.
*    IF SY-UNAME EQ 'ITBOM01'.
*      PERFORM ORDUPD.
*    ELSE.
*      MESSAGE 'PLEASE CONTACT EDP' TYPE 'E'.
*    ENDIF.
  ELSEIF r4 EQ 'X'.
    IF mrnplt EQ space.
      MESSAGE 'ENTER PLANT FOR MRN STOCK' TYPE 'E'.
    ENDIF.
*    perform mrnstock.
    PERFORM mrnstock1.

*  elseif r5 eq 'X'.
*    if mrnplt eq space.
*      message 'ENTER PLANT FOR MRN STOCK' type 'E'.
*    endif.
*    perform passw.
*    perform upddoc.
*  elseif r6 eq 'X'.
*    if mrnplt eq space.
*      message 'ENTER PLANT FOR MRN STOCK' type 'E'.
*    endif.
*    perform remdocdisplay.
  ENDIF.

TOP-OF-PAGE.

  IF r4 EQ 'X'.
    FORMAT COLOR 3.
    WRITE : / 'ITEM NAME',20 'ITEM CODE',36 'BATCH/I.D. No',57 'MRN STOCK','LOC',73 'FG CODE',92 'FG BATCH',102 'DOCUMENT NO'.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  PMDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pmdata.
  IF pmmatnr IS INITIAL.
    MESSAGE 'ENTER PACKING MATERIAL' TYPE 'E'.
  ENDIF.
  IF werks IS INITIAL.
    MESSAGE 'ENTER PLANT' TYPE 'E'.
  ENDIF.

  SELECT SINGLE * FROM mara WHERE matnr EQ pmmatnr AND mtart EQ 'ZVRP'.
  IF sy-subrc EQ 4.
    MESSAGE 'ENTER PACKING MATERIAL CODE' TYPE 'E'.
  ENDIF.


  wa_tab1-pmmatnr = pmmatnr.
  wa_tab1-werks = werks.
  SELECT SINGLE * FROM makt WHERE matnr EQ pmmatnr AND spras = sy-langu.
  IF sy-subrc EQ 0.
    wa_tab1-maktx = makt-maktx.
  ENDIF.
  wa_tab1-fgmatnr = space.
  wa_tab1-werks = werks.
  wa_tab1-monat = space.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.
  CALL SCREEN 0100.
  LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .
  SELECT * FROM zmrn INTO TABLE it_zmrn WHERE werks IN werks1.
  IF sy-subrc NE 0.
    MESSAGE 'NO DATA' TYPE 'E'.
  ENDIF.

  IF it_zmrn IS NOT INITIAL.
    LOOP AT it_zmrn INTO wa_zmrn.
      wa_disp1-pmmatnr = wa_zmrn-pmmatnr.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_zmrn-pmmatnr AND spras = sy-langu.
      IF sy-subrc EQ 0.
        wa_disp1-pmmaktx = makt-maktx.
      ENDIF.
      wa_disp1-werks = wa_zmrn-werks.
      wa_disp1-fgmatnr = wa_zmrn-fgmatnr.
      wa_disp1-monat = wa_zmrn-monat.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_zmrn-fgmatnr AND spras = sy-langu.
      IF sy-subrc EQ 0.
        wa_disp1-fgmaktx = makt-maktx.
      ENDIF.
      wa_disp1-cpudt = wa_zmrn-cpudt.
      wa_disp1-usnam = wa_zmrn-usnam.

      COLLECT wa_disp1 INTO it_disp1.
      CLEAR wa_disp1.
    ENDLOOP.
  ENDIF.


  LOOP AT it_disp1 INTO wa_disp1.
    PACK wa_disp1-pmmatnr TO wa_disp1-pmmatnr.
    CONDENSE wa_disp1-pmmatnr.
    PACK wa_disp1-fgmatnr TO wa_disp1-fgmatnr.
    CONDENSE wa_disp1-fgmatnr.
    MODIFY it_disp1 FROM wa_disp1 TRANSPORTING pmmatnr fgmatnr.
  ENDLOOP.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'PLANT'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'PMMATNR'.
  wa_fieldcat-seltext_l = 'PACKING CODE'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'PMMAKTX'.
  wa_fieldcat-seltext_l = 'PM NAME'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'FGMATNR'.
  wa_fieldcat-seltext_l = 'FINISHED PRODUCT'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'FGMAKTX'.
  wa_fieldcat-seltext_l = 'FINISHED PRODUCT NAME'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'MONAT'.
  wa_fieldcat-seltext_l = 'GROUPING'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUDT'.
  wa_fieldcat-seltext_l = 'ENTERED ON'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'USNAM'.
  wa_fieldcat-seltext_l = 'ENTERD BY'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.





  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'PACKING MATERIAL & RELEVANT FNISHED CODES FOR MRN'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM1'
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
      t_outtab                = it_disp1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.

FORM top.

  DATA: comment    TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.
*  if r5 eq 'X' or r6 eq 'X'.
*    wa_comment-typ = 'A'.
*    wa_comment-info = 'DOCUMENT NO, MATERIAL CODE & BATCH NOT TO CONCIDER FOR MRN STOCK'.
**  WA_COMMENT-INFO = P_FRMDT.
*    append wa_comment to comment.
*  else.
  wa_comment-typ = 'A'.
  wa_comment-info = 'LINKING FOR MRN FOR PM & FG PLANT WISE'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND wa_comment TO comment.
*  endif.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = comment
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  CLEAR comment.

ENDFORM.                    "TOP

FORM user_comm USING ucomm LIKE sy-ucomm selfield TYPE slis_selfield.
  CASE sy-ucomm. "SELFIELD-FIELDNAME.

    WHEN '&DATA_SAVE'(001).
*      if r5 eq 'X'.
*        perform adddoc.
*      endif.


    WHEN OTHERS.
  ENDCASE.

ENDFORM.

FORM user_comm1 USING ucomm LIKE sy-ucomm
                     selfield TYPE slis_selfield.



  CASE selfield-fieldname.
    WHEN 'MBLNR'.
      SET PARAMETER ID 'MBN' FIELD selfield-value.
      CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.
    WHEN 'EBELN'.
      SET PARAMETER ID 'BES' FIELD selfield-value.
      CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
    WHEN 'VBELN'.
      SET PARAMETER ID 'VF' FIELD selfield-value.
      CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD selfield-value.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'TITLE1'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  IF r1 EQ 'X'.
*To change the existing values and refresh the grid
*And only values in the dropdown or in the default
*F4 can be given , else no action takes place for the dropdown
*and error is thrown for the default F4 help and font changes to red
*and on still saving, value is not changed
    c_alvgd->check_changed_data( ).
*Based on the user input
*When user clicks 'SAVE;
*    BREAK-POINT.
    CASE ok_code.
      WHEN 'SAVE'.
*A pop up is called to confirm the saving of changed data
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar       = 'SAVING DATA'
            text_question  = 'Continue?'
            icon_button_1  = 'icon_booking_ok'
          IMPORTING
            answer         = gstring
          EXCEPTIONS
            text_not_found = 1
            OTHERS         = 2.
        IF sy-subrc NE 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
*When the User clicks 'YES'
        IF ( gstring = '1' ).
*          MESSAGE 'Saved' TYPE 'S'.
*Now the changed data is stored in the it_pbo internal table
*        MODIFY zgk_emp FROM TABLE it_emp.
*Subroutine to display the ALV with changed data.
          PERFORM redisplay.
        ELSE.
*When user clicks NO or Cancel
          MESSAGE 'Not Saved'  TYPE 'S'.
        ENDIF.
**When the user clicks the 'EXIT; he is out
      WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
        LEAVE PROGRAM.
    ENDCASE.
    CLEAR: ok_code.
  ELSE.
    CASE ok_code.
      WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
        LEAVE PROGRAM.
    ENDCASE.
    CLEAR: ok_code.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo OUTPUT.

*  *Creating objects of the container
  CREATE OBJECT c_ccont
    EXPORTING
      container_name = 'CCONT'.
*  create object for alv grid


  CREATE OBJECT c_alvgd
    EXPORTING
      i_parent = cl_gui_custom_container=>screen0.

*  CREATE OBJECT c_alvgd
*    EXPORTING
*      i_parent = c_ccont.



*  SET field for ALV
  PERFORM alv_build_fieldcat.
* Set ALV attributes FOR LAYOUT
  PERFORM alv_report_layout.
  CHECK NOT c_alvgd IS INITIAL.
* Call ALV GRID
  CALL METHOD c_alvgd->set_table_for_first_display
    EXPORTING
      is_layout                     = it_layout
      i_save                        = 'A'
    CHANGING
      it_outtab                     = it_tab1
      it_fieldcatalog               = it_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat .
  DATA lv_fldcat TYPE lvc_s_fcat.
  CLEAR lv_fldcat.
*  LV_FLDCAT-ROW_POS   = '1'.
*  LV_FLDCAT-COL_POS   = '1'.
  lv_fldcat-fieldname = 'PMMATNR'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'PACKING MATERIAL'.
*  lv_fldcat-icon = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

*  LV_FLDCAT-ROW_POS   = '1'.
*  LV_FLDCAT-COL_POS   = '2'.
  lv_fldcat-fieldname = 'MAKTX'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'PACKING MATERIAL NAME'.
*  lv_fldcat-icon = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'WERKS'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-scrtext_m = 'PLANT'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FGMATNR'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-scrtext_m = 'ENTER FINISHED PRODUCT CODE'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'MONAT'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-scrtext_m = 'GROUPING'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_REPORT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_report_layout .
  it_layout-cwidth_opt = 'X'.
  it_layout-col_opt = 'X'.
  it_layout-zebra = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REDISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM redisplay .
*Cells of the alv are made non editable after entering OK to save
  CALL METHOD c_alvgd->set_ready_for_input
    EXPORTING
      i_ready_for_input = 0.
*Row and column of the alv are refreshed after changing values
  stable-row = 'X'.
  stable-col = 'X'.
*REfreshed ALV display with the changed values
*This ALV is non editable and contains new values
  CALL METHOD c_alvgd->refresh_table_display
    EXPORTING
      is_stable = stable
    EXCEPTIONS
      finished  = 1
      OTHERS    = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


  IF r1 EQ 'X'.

    LOOP AT it_tab1 INTO wa_tab1.
      a = 0.
      SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab1-fgmatnr AND mtart IN ( 'ZFRT', 'ZDSM','ZESC','ZESM' ).
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM mast WHERE matnr EQ wa_tab1-fgmatnr AND werks EQ wa_tab1-werks.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM stpo WHERE stlty EQ 'M' AND stlnr EQ mast-stlnr AND idnrk EQ wa_tab1-pmmatnr.
          IF sy-subrc EQ 0.
            a = 1.
          ENDIF.
        ENDIF.
        IF a NE 1.
          MESSAGE 'INVALID ENTRY..PLEASE CHECK BOM' TYPE 'E'.
        ENDIF.
      ELSE.
        MESSAGE 'INVALID DATA' TYPE 'E'.
      ENDIF.
    ENDLOOP.

    LOOP AT it_tab1 INTO wa_tab1.
      a = 0.
      SELECT SINGLE * FROM mara WHERE matnr EQ wa_tab1-fgmatnr AND mtart IN ( 'ZFRT', 'ZDSM','ZESC','ZESM' ).
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM mast WHERE matnr EQ wa_tab1-fgmatnr AND werks EQ wa_tab1-werks.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM stpo WHERE stlty EQ 'M' AND stlnr EQ mast-stlnr AND idnrk EQ wa_tab1-pmmatnr.
          IF sy-subrc EQ 0.
            a = 1.
          ENDIF.
        ENDIF.
        IF a NE 1.
          MESSAGE 'INVALID ENTRY..PLEASE CHECK BOM' TYPE 'E'.
        ENDIF.
        zmrn_wa-pmmatnr = wa_tab1-pmmatnr.
        zmrn_wa-werks = wa_tab1-werks.
        zmrn_wa-fgmatnr = wa_tab1-fgmatnr.
        zmrn_wa-monat = wa_tab1-monat.
        zmrn_wa-usnam = sy-uname.
        zmrn_wa-cpudt = sy-datum.
        MODIFY zmrn FROM zmrn_wa.
        CLEAR zmrn_wa.
        MESSAGE 'DATA SAVED' TYPE 'I'.
      ENDIF.

    ENDLOOP.

  ENDIF.
  LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM authorization .
  IF r1 EQ 'X' .
    aplant = werks.
*  loop at itab_t001w into wa_t001w.
    AUTHORITY-CHECK OBJECT 'M_BCO_WERK'
           ID 'WERKS' FIELD aplant.
    IF sy-subrc <> 0.
      CONCATENATE 'No authorization for Plant' aplant INTO msg
      SEPARATED BY space.
      MESSAGE msg TYPE 'E'.
    ENDIF.
  ELSEIF r2 EQ 'X'.
    SELECT werks name1 FROM t001w INTO TABLE itab_t001w WHERE werks IN werks1.

    LOOP AT itab_t001w INTO wa_t001w.
      AUTHORITY-CHECK OBJECT 'M_BCO_WERK'
             ID 'WERKS' FIELD wa_t001w-werks.
      IF sy-subrc <> 0.
        CONCATENATE 'No authorization for Plant' wa_t001w-werks INTO msg
        SEPARATED BY space.
        MESSAGE msg TYPE 'E'.
      ENDIF.
    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat1 .
  DATA lv_fldcat TYPE lvc_s_fcat.

  CLEAR lv_fldcat.
  lv_fldcat-fieldname = 'WERKS'.
  lv_fldcat-scrtext_m = 'PLANT'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PMMATNR'.
  lv_fldcat-scrtext_m = 'PACKING CODE'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PMMAKTX'.
  lv_fldcat-scrtext_m = 'PACKING CODE NAME'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FGMATNR'.
  lv_fldcat-scrtext_m = 'FINISHED PRODUCT'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FGMAKTX'.
  lv_fldcat-scrtext_m = 'FINISHED PRODUCT NAME'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CPUDT'.
  lv_fldcat-scrtext_m = 'ENTERD ON'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'USNAM'.
  lv_fldcat-scrtext_m = 'ENTERD BY'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ORDUPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM ORDUPD.
*  SELECT SINGLE * FROM AFPO WHERE AUFNR EQ ORDER.
*  IF SY-SUBRC NE 0.
*    MESSAGE 'CHECK PRODUCTION ORDER NO.' TYPE 'E'.
*  ENDIF.
*  SELECT SINGLE * FROM ZMRN_ORD WHERE AUFNR EQ ORDER.
*  IF SY-SUBRC EQ 0.
*    MESSAGE 'THIS PRODUCTION ORDER ALREADY ADDED' TYPE 'E'.
*  ENDIF.
*
*  ZMRN_ORD_WA-AUFNR = ORDER.
*  ZMRN_ORD_WA-PERNR = PERNR.
*  ZMRN_ORD_WA-CPUDT = SY-DATUM.
*  ZMRN_ORD_WA-UNAME = SY-UNAME.
*  INSERT INTO  ZMRN_ORD VALUES ZMRN_ORD_WA.
*
*  IF SY-SUBRC EQ 0.
*    MESSAGE 'Order no. is updated, Now you can release production order without using MRN stock' TYPE 'I'.
*  ENDIF.
*  CLEAR : ZMRN_ORD_WA.
*  EXIT.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PASSW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM passw .
*  SELECT SINGLE * FROM zpassw WHERE pernr = pernr.
*  IF sy-subrc EQ 0.
*    v_en_string = zpassw-password.
**&———————————————————————** Decryption – String to String*&———————————————————————*
*    TRY.
*        CREATE OBJECT o_encryptor.
*        CALL METHOD o_encryptor->decrypt_string2string
*          EXPORTING
*            the_string = v_en_string
*          RECEIVING
*            result     = v_de_string.
*      CATCH cx_encrypt_error INTO o_cx_encrypt_error.
*        CALL METHOD o_cx_encrypt_error->if_message~get_text
*          RECEIVING
*            result = v_error_msg.
*        MESSAGE v_error_msg TYPE 'E'.
*    ENDTRY.
*    IF v_de_string EQ pass.
**      message 'CORRECT PASSWORD' type 'I'.
*    ELSE.
*      MESSAGE 'INCORRECT PASSWORD' TYPE 'E'.
*    ENDIF.
*  ELSE.
*    MESSAGE 'NOT VALID USER' TYPE 'E'.
*    EXIT.
*  ENDIF.
*  CLEAR : pass.
*  pass = '   '.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MRNSTOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM mrnstock .

  SELECT * FROM zmrn INTO TABLE it_zmrn WHERE werks EQ mrnplt.
  IF sy-subrc NE 0.
    MESSAGE 'NO MRN STOCK' TYPE 'E'.
  ENDIF.

  IF it_zmrn IS NOT INITIAL.
    LOOP AT it_zmrn INTO wa_zmrn.
      wa_mrnstk1-matnr = wa_zmrn-pmmatnr.
      COLLECT wa_mrnstk1 INTO it_mrnstk1.
      CLEAR wa_mrnstk1.
    ENDLOOP.
  ENDIF.

  SORT it_mrnstk1 BY matnr.
  DELETE ADJACENT DUPLICATES FROM it_mrnstk1 COMPARING matnr.

  SELECT * FROM mchb INTO TABLE it_mchb FOR ALL ENTRIES IN it_mrnstk1 WHERE matnr EQ it_mrnstk1-matnr AND werks EQ mrnplt AND lgort IN ('MRN1','MRN4').


  LOOP AT it_mchb INTO wa_mchb.
    wa_stk1-matnr = wa_mchb-matnr.
    wa_stk1-lgort = wa_mchb-lgort.
    wa_stk1-charg = wa_mchb-charg.
    wa_stk1-stock = wa_mchb-clabs + wa_mchb-cinsm + wa_mchb-cspem.
    COLLECT wa_stk1 INTO it_stk1.
    CLEAR wa_stk1.
  ENDLOOP.

  DELETE it_stk1 WHERE stock EQ 0.

  CLEAR : it_mseg,wa_mseg.
  IF it_mchb IS NOT INITIAL.
    SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_stk1 WHERE bwart EQ '262' AND matnr EQ it_stk1-matnr
      AND charg EQ it_stk1-charg AND werks EQ mrnplt AND lgort EQ it_stk1-lgort.
  ENDIF.

*  LOOP AT IT_MSEG INTO WA_MSEG.
*    SELECT SINGLE * FROM ZMRN_REMOVE WHERE MBLNR EQ WA_MSEG-MBLNR.
*    IF SY-SUBRC EQ 0.
*      DELETE IT_MSEG WHERE MBLNR = ZMRN_REMOVE-MBLNR.  "7.6.22
*    ENDIF.
*  ENDLOOP.


  IF it_mseg IS NOT INITIAL.
    LOOP AT it_mseg INTO wa_mseg.
      SELECT SINGLE * FROM afpo WHERE aufnr EQ wa_mseg-aufnr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM zmrn WHERE pmmatnr EQ wa_mseg-matnr AND werks EQ wa_mseg-werks AND fgmatnr EQ afpo-matnr.
        IF sy-subrc EQ 0.

*          WRITE : / AFPO-MATNR,AFPO-CHARG,WA_MSEG-MBLNR,WA_MSEG-MATNR,WA_MSEG-CHARG,WA_MSEG-MENGE,WA_MSEG-LGORT,WA_MSEG-MEINS.

          wa_chk1-fgmatnr = afpo-matnr.
          wa_chk1-fgcharg = afpo-charg.
          wa_chk1-mblnr = wa_mseg-mblnr.
          wa_chk1-matnr = wa_mseg-matnr.
          wa_chk1-charg = wa_mseg-charg.
          wa_chk1-menge = wa_mseg-menge.
          wa_chk1-werks = wa_mseg-werks.
          wa_chk1-lgort = wa_mseg-lgort.
          wa_chk1-grp = zmrn-monat.
          COLLECT wa_chk1 INTO it_chk1.
          CLEAR wa_chk1.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

  SORT it_chk1 DESCENDING BY mblnr.
  SORT it_stk1 BY matnr.
  LOOP AT it_stk1 INTO wa_stk1.

    CLEAR : maktx1,maktx2,maktx.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_stk1-matnr AND spras = sy-langu.
    IF sy-subrc EQ 0.
      maktx1 = makt-maktx.
    ENDIF.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_stk1-matnr AND spras EQ 'Z1'.
    IF sy-subrc EQ 0.
      maktx2 = makt-maktx.
    ENDIF.
    CONCATENATE maktx1 maktx2 INTO maktx SEPARATED BY space.
    ON CHANGE OF wa_stk1-matnr.
      ULINE.
      FORMAT COLOR 3.
      SKIP.
      WRITE : / maktx.
    ENDON.
    FORMAT COLOR 1.
    WRITE : / 'AVAILABLE STOCK',20 wa_stk1-matnr,wa_stk1-charg,wa_stk1-stock,wa_stk1-lgort.
    CLEAR : stock.
    stock = wa_stk1-stock.
    LOOP AT it_chk1 INTO wa_chk1 WHERE matnr = wa_stk1-matnr AND charg = wa_stk1-charg AND lgort = wa_stk1-lgort.
      IF stock GT 0.
        READ TABLE it_chk1 INTO  wa_chk1 WITH KEY matnr = wa_stk1-matnr charg = wa_stk1-charg lgort = wa_stk1-lgort.
        IF sy-subrc EQ 0.
          FORMAT COLOR 2.
          WRITE : /20 wa_chk1-matnr,wa_chk1-charg,wa_chk1-menge,wa_chk1-lgort,wa_chk1-fgmatnr,wa_chk1-fgcharg,wa_chk1-mblnr.
          stock = stock - wa_chk1-menge.
          DELETE it_chk1 WHERE mblnr = wa_chk1-mblnr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM upddoc .
  DO 10 TIMES.
    count = count + 1.
    wa_doc1-mblnr = space.
    wa_doc1-matnr = space.
    wa_doc1-charg = space.
    wa_doc1-count = count.
    COLLECT wa_doc1 INTO it_doc1.
    CLEAR wa_doc1.
  ENDDO.


  wa_fieldcat-fieldname = 'MBLNR'.
  wa_fieldcat-seltext_l = 'DOCUMENT NO.'.
  wa_fieldcat-edit = 'X'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'MATERIAL CODE'.
  wa_fieldcat-edit = 'X'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH / I.D. NO.'.
  wa_fieldcat-edit = 'X'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'ADD DOCUMNT TO REMOVE FROM MRN STOCK'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
      i_callback_user_command = 'USER_COMM'
      i_callback_top_of_page  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         = L_GLAY
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
      t_outtab                = it_doc1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ADDDOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM ADDDOC .
*  LOOP AT IT_DOC1 INTO WA_DOC1 WHERE MBLNR GT 0.
*    SELECT SINGLE * FROM MSEG WHERE MBLNR EQ WA_DOC1-MBLNR AND MATNR EQ WA_DOC1-MATNR AND CHARG = WA_DOC1-CHARG AND WERKS EQ MRNPLT.
*    IF SY-SUBRC EQ 4.
*      MESSAGE 'INVALID DOCUMENT NUMBER' TYPE 'E'.
*    ENDIF.
**    SELECT SINGLE * FROM ZMRN_REMOVE WHERE MBLNR EQ WA_DOC1-MBLNR AND MATNR EQ WA_DOC1-MATNR AND CHARG EQ WA_DOC1-CHARG.
**    IF SY-SUBRC EQ 0.
**      MESSAGE 'THIS DOCUMENT IS ALREDY ADDED' TYPE 'E'.
**    ENDIF.
*    IF WA_DOC1-MATNR EQ SPACE.
*      MESSAGE 'ENTER MATERIAL CODE' TYPE 'E'.
*    ENDIF.
*    IF WA_DOC1-CHARG EQ SPACE.
*      MESSAGE 'ENTER MATERIAL CODE' TYPE 'E'.
*    ENDIF.
*
*    ZMRN_REMOVE_WA-MBLNR = WA_DOC1-MBLNR.
*    ZMRN_REMOVE_WA-MATNR = WA_DOC1-MATNR.
*    ZMRN_REMOVE_WA-CHARG = WA_DOC1-CHARG.
*    ZMRN_REMOVE_WA-PERNR = PERNR.
*    ZMRN_REMOVE_WA-UNAME = SY-UNAME.
*    ZMRN_REMOVE_WA-CPUDT = SY-DATUM.
*    ZMRN_REMOVE_WA-UZEIT = SY-UZEIT.
*    MODIFY ZMRN_REMOVE FROM ZMRN_REMOVE_WA.
*    CLEAR ZMRN_REMOVE_WA.
*  ENDLOOP.
*  MESSAGE 'DOCUMENT IS ADDED TO REMOVE FROM MRN STOCK' TYPE 'I'.
*  SET SCREEN 0.
*  EXIT.
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REMDOCDISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM REMDOCDISPLAY .
*  SELECT * FROM ZMRN_REMOVE INTO TABLE IT_ZMRN_REMOVE.
*
*  IF IT_ZMRN_REMOVE IS NOT INITIAL.
*    LOOP AT IT_ZMRN_REMOVE INTO WA_ZMRN_REMOVE.
*      SELECT SINGLE * FROM MSEG WHERE MBLNR EQ WA_ZMRN_REMOVE-MBLNR AND WERKS EQ MRNPLT.
*      IF SY-SUBRC EQ 0.
*        WA_DOC1-MBLNR = WA_ZMRN_REMOVE-MBLNR.
*        WA_DOC1-MATNR = WA_ZMRN_REMOVE-MATNR.
*        WA_DOC1-CHARG = WA_ZMRN_REMOVE-CHARG.
*        SELECT SINGLE * FROM MAKT WHERE MATNR EQ  WA_ZMRN_REMOVE-MATNR AND SPRAS EQ 'EN'.
*        IF SY-SUBRC EQ 0.
*          WA_DOC1-MAKTX = MAKT-MAKTX.
*        ENDIF.
*        COLLECT WA_DOC1 INTO IT_DOC1.
*        CLEAR WA_DOC1.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*
*
*  WA_FIELDCAT-FIELDNAME = 'MBLNR'.
*  WA_FIELDCAT-SELTEXT_L = 'DOCUMENT NO.'.
*  WA_FIELDCAT-EDIT = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MATNR'.
*  WA_FIELDCAT-SELTEXT_L = 'MATERIAL CODE'.
**  wa_fieldcat-edit = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MAKTX'.
*  WA_FIELDCAT-SELTEXT_L = 'MATERIAL NAME'.
**  wa_fieldcat-edit = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'CHARG'.
*  WA_FIELDCAT-SELTEXT_L = 'BATCH / I.D. NO.'.
**  wa_fieldcat-edit = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*
*
*  LAYOUT-ZEBRA = 'X'.
*  LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
*  LAYOUT-WINDOW_TITLEBAR  = 'ADD DOCUMNT TO REMOVE FROM MRN STOCK'.
*
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
**     I_INTERFACE_CHECK       = ' '
**     I_BYPASSING_BUFFER      = ' '
**     I_BUFFER_ACTIVE         = ' '
*      I_CALLBACK_PROGRAM      = G_REPID
**     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
*      I_CALLBACK_USER_COMMAND = 'USER_COMM'
*      I_CALLBACK_TOP_OF_PAGE  = 'TOP'
**     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**     I_CALLBACK_HTML_END_OF_LIST       = ' '
**     I_STRUCTURE_NAME        =
**     I_BACKGROUND_ID         = ' '
**     I_GRID_TITLE            =
**     I_GRID_SETTINGS         = L_GLAY
*      IS_LAYOUT               = LAYOUT
*      IT_FIELDCAT             = FIELDCAT
**     IT_EXCLUDING            =
**     IT_SPECIAL_GROUPS       =
**     IT_SORT                 =
**     IT_FILTER               =
**     IS_SEL_HIDE             =
**     I_DEFAULT               = 'X'
*      I_SAVE                  = 'A'
**     IS_VARIANT              =
**     IT_EVENTS               =
**     IT_EVENT_EXIT           =
**     IS_PRINT                =
**     IS_REPREP_ID            =
**     I_SCREEN_START_COLUMN   = 0
**     I_SCREEN_START_LINE     = 0
**     I_SCREEN_END_COLUMN     = 0
**     I_SCREEN_END_LINE       = 0
**     I_HTML_HEIGHT_TOP       = 0
**     I_HTML_HEIGHT_END       = 0
**     IT_ALV_GRAPHICS         =
**     IT_HYPERLINK            =
**     IT_ADD_FIELDCAT         =
**     IT_EXCEPT_QINFO         =
**     IR_SALV_FULLSCREEN_ADAPTER        =
** IMPORTING
**     E_EXIT_CAUSED_BY_CALLER =
**     ES_EXIT_CAUSED_BY_USER  =
*    TABLES
*      T_OUTTAB                = IT_DOC1
*    EXCEPTIONS
*      PROGRAM_ERROR           = 1
*      OTHERS                  = 2.
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MRNSTOCK1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM mrnstock1 .
  SELECT * FROM zmrn INTO TABLE it_zmrn WHERE werks EQ mrnplt AND pmmatnr IN mrnmatnr.
  IF sy-subrc NE 0.
    MESSAGE 'NO MRN STOCK' TYPE 'E'.
  ENDIF.

  IF it_zmrn IS NOT INITIAL.
    LOOP AT it_zmrn INTO wa_zmrn.
      wa_mrnstk1-matnr = wa_zmrn-pmmatnr.
      COLLECT wa_mrnstk1 INTO it_mrnstk1.
      CLEAR wa_mrnstk1.
    ENDLOOP.
  ENDIF.

  SORT it_mrnstk1 BY matnr.
  DELETE ADJACENT DUPLICATES FROM it_mrnstk1 COMPARING matnr.

  SELECT * FROM mchb INTO TABLE it_mchb FOR ALL ENTRIES IN it_mrnstk1 WHERE matnr EQ it_mrnstk1-matnr AND werks EQ mrnplt AND lgort IN ('MRN1','MRN4').


  LOOP AT it_mchb INTO wa_mchb.
    wa_stk1-matnr = wa_mchb-matnr.
    wa_stk1-lgort = wa_mchb-lgort.
    wa_stk1-charg = wa_mchb-charg.
    wa_stk1-stock = wa_mchb-clabs + wa_mchb-cinsm + wa_mchb-cspem.
    COLLECT wa_stk1 INTO it_stk1.
    CLEAR wa_stk1.
  ENDLOOP.

  DELETE it_stk1 WHERE stock EQ 0.

  CLEAR : it_mseg,wa_mseg.
  IF it_mchb IS NOT INITIAL.
    SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_stk1 WHERE
*      BWART EQ '262' AND
      matnr EQ it_stk1-matnr AND charg EQ it_stk1-charg AND werks EQ mrnplt AND lgort EQ it_stk1-lgort.
  ENDIF.

*  LOOP AT IT_MSEG INTO WA_MSEG.
*    SELECT SINGLE * FROM ZMRN_REMOVE WHERE MBLNR EQ WA_MSEG-MBLNR.
*    IF SY-SUBRC EQ 0.
*      DELETE IT_MSEG WHERE MBLNR = ZMRN_REMOVE-MBLNR.  "7.6.22
*    ENDIF.
*  ENDLOOP.


  IF it_mseg IS NOT INITIAL.
    LOOP AT it_mseg INTO wa_mseg.
      IF wa_mseg-shkzg EQ 'H'.
        wa_mseg-menge = wa_mseg-menge * ( - 1 ).
      ENDIF.
      wa_chk1-mblnr = wa_mseg-mblnr.
      wa_chk1-bwart = wa_mseg-bwart.
      wa_chk1-matnr = wa_mseg-matnr.
      wa_chk1-charg = wa_mseg-charg.
      wa_chk1-menge = wa_mseg-menge.
      wa_chk1-werks = wa_mseg-werks.
      wa_chk1-lgort = wa_mseg-lgort.
      SELECT SINGLE * FROM afpo WHERE aufnr EQ wa_mseg-aufnr.
      IF sy-subrc EQ 0.
        wa_chk1-fgmatnr = afpo-matnr.
        wa_chk1-fgcharg = afpo-charg.
        SELECT SINGLE * FROM zmrn WHERE pmmatnr EQ wa_mseg-matnr AND werks EQ wa_mseg-werks AND fgmatnr EQ afpo-matnr.
        IF sy-subrc EQ 0.
*          WRITE : / AFPO-MATNR,AFPO-CHARG,WA_MSEG-MBLNR,WA_MSEG-MATNR,WA_MSEG-CHARG,WA_MSEG-MENGE,WA_MSEG-LGORT,WA_MSEG-MEINS.
          wa_chk1-grp = zmrn-monat.
        ENDIF.
      ENDIF.
      COLLECT wa_chk1 INTO it_chk1.
      CLEAR wa_chk1.
    ENDLOOP.
  ENDIF.

  SORT it_chk1 DESCENDING BY mblnr.
  SORT it_stk1 BY matnr.

  IF allmov EQ space.
    PERFORM allmov.
  ELSE.
    LOOP AT it_stk1 INTO wa_stk1.
      CLEAR : maktx1,maktx2,maktx.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_stk1-matnr AND spras = sy-langu.
      IF sy-subrc EQ 0.
        maktx1 = makt-maktx.
      ENDIF.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_stk1-matnr AND spras EQ 'Z1'.
      IF sy-subrc EQ 0.
        maktx2 = makt-maktx.
      ENDIF.
      CONCATENATE maktx1 maktx2 INTO maktx SEPARATED BY space.
      ON CHANGE OF wa_stk1-matnr.
        ULINE.
        FORMAT COLOR 3.
        SKIP.
        WRITE : / maktx.
      ENDON.
      FORMAT COLOR 1.
      WRITE : / 'AVAILABLE STOCK',20 wa_stk1-matnr,wa_stk1-charg,wa_stk1-stock,wa_stk1-lgort.
      CLEAR : stock.
      stock = wa_stk1-stock.
      LOOP AT it_chk1 INTO wa_chk1 WHERE matnr = wa_stk1-matnr AND charg = wa_stk1-charg AND lgort = wa_stk1-lgort.
*      if stock gt 0.
        READ TABLE it_chk1 INTO  wa_chk1 WITH KEY matnr = wa_stk1-matnr charg = wa_stk1-charg lgort = wa_stk1-lgort.
        IF sy-subrc EQ 0.
          FORMAT COLOR 2.
          WRITE : /20 wa_chk1-matnr,wa_chk1-charg,wa_chk1-menge,wa_chk1-lgort,wa_chk1-fgmatnr,wa_chk1-fgcharg,wa_chk1-mblnr,wa_chk1-bwart.
          SELECT SINGLE * FROM mkpf WHERE mblnr EQ wa_chk1-mblnr.
          IF sy-subrc EQ 0.
            WRITE : mkpf-budat.
          ENDIF.
          stock = stock - wa_chk1-menge.
          DELETE it_chk1 WHERE mblnr = wa_chk1-mblnr.
        ENDIF.
*      endif.
      ENDLOOP.
    ENDLOOP.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MRNMOV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM mrnmov .


  LOOP AT it_disp1 INTO wa_disp1.
*    wa_disp2-pmmatnr  = wa_disp1-pmmatnr.
*    wa_disp2-pmmatnr  = wa_disp1-pmmatnr.
*    wa_disp2-pmmatnr  = wa_disp1-pmmatnr.
*    wa_disp2-pmmatnr  = wa_disp1-pmmatnr.
*    wa_disp2-pmmatnr  = wa_disp1-pmmatnr.
*    pack wa_disp1-pmmatnr to wa_disp1-pmmatnr.
*    condense wa_disp1-pmmatnr.
*    pack wa_disp1-fgmatnr to wa_disp1-fgmatnr.
*    condense wa_disp1-fgmatnr.
*    modify it_disp1 from wa_disp1 transporting pmmatnr fgmatnr.
  ENDLOOP.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'PLANT'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'PMMATNR'.
  wa_fieldcat-seltext_l = 'PACKING CODE'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'PMMAKTX'.
  wa_fieldcat-seltext_l = 'PM NAME'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'FGMATNR'.
  wa_fieldcat-seltext_l = 'FINISHED PRODUCT'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'FGMAKTX'.
  wa_fieldcat-seltext_l = 'FINISHED PRODUCT NAME'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'MONAT'.
  wa_fieldcat-seltext_l = 'GROUPING'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUDT'.
  wa_fieldcat-seltext_l = 'ENTERED ON'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.

  wa_fieldcat-fieldname = 'USNAM'.
  wa_fieldcat-seltext_l = 'ENTERD BY'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR  wa_fieldcat.





  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'PACKING MATERIAL & RELEVANT FNISHED CODES FOR MRN'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM1'
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
      t_outtab                = it_disp1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALLMOV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM allmov .


  LOOP AT it_chk1 INTO wa_chk1.
    wa_chk2-matnr = wa_chk1-matnr.
    wa_chk2-charg = wa_chk1-charg.
    wa_chk2-menge = wa_chk1-menge.
    wa_chk2-fgmatnr = wa_chk1-fgmatnr.
    wa_chk2-lgort = wa_chk1-lgort.
    COLLECT wa_chk2 INTO it_chk2.
    CLEAR wa_chk2.
  ENDLOOP.
  DELETE it_chk2 WHERE menge EQ 0.
  SORT it_chk1 DESCENDING BY mblnr.

  LOOP AT it_stk1 INTO wa_stk1.
    CLEAR : maktx1,maktx2,maktx.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_stk1-matnr AND spras EQ 'EN'.
    IF sy-subrc EQ 0.
      maktx1 = makt-maktx.
    ENDIF.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_stk1-matnr AND spras EQ 'Z1'.
    IF sy-subrc EQ 0.
      maktx2 = makt-maktx.
    ENDIF.
    CONCATENATE maktx1 maktx2 INTO maktx SEPARATED BY space.
    ON CHANGE OF wa_stk1-matnr.
      ULINE.
      FORMAT COLOR 3.
      SKIP.
      WRITE : / maktx.
    ENDON.
    FORMAT COLOR 1.
    WRITE : / 'AVAILABLE STOCK',20 wa_stk1-matnr,wa_stk1-charg,wa_stk1-stock,wa_stk1-lgort.
    CLEAR : stock.
    stock = wa_stk1-stock.
    LOOP AT it_chk2 INTO wa_chk2 WHERE matnr = wa_stk1-matnr AND charg = wa_stk1-charg AND lgort = wa_stk1-lgort.
*      and lgort = wa_stk1-lgort.
*      if stock gt 0.
*      read table it_chk1 into  wa_chk1 with key matnr = wa_stk1-matnr charg = wa_stk1-charg lgort = wa_stk1-lgort.
*      if sy-subrc eq 0.
      FORMAT COLOR 2.
      WRITE : /20 wa_chk2-matnr,wa_chk2-charg,wa_chk2-menge.
      READ TABLE it_chk1 INTO wa_chk1 WITH KEY matnr = wa_chk2-matnr charg = wa_chk2-charg fgmatnr = wa_chk2-fgmatnr.
      IF sy-subrc EQ 0.
        WRITE : wa_chk1-lgort.
      ENDIF.
      WRITE : wa_chk2-fgmatnr.
      READ TABLE it_chk1 INTO wa_chk1 WITH KEY matnr = wa_chk2-matnr charg = wa_chk2-charg fgmatnr = wa_chk2-fgmatnr.
      IF sy-subrc EQ 0.
        WRITE : wa_chk1-fgcharg,wa_chk1-mblnr,wa_chk1-bwart.
      ENDIF.
*        write : /20 wa_chk1-matnr,wa_chk1-charg,wa_chk1-menge,wa_chk1-lgort,wa_chk1-fgmatnr,wa_chk1-fgcharg,wa_chk1-mblnr,wa_chk1-bwart.
*        select single * from mkpf where mblnr eq wa_chk1-mblnr.
*        if sy-subrc eq 0.
*          write : mkpf-budat.
*        endif.
      stock = stock - wa_chk1-menge.
*        delete it_chk1 where mblnr = wa_chk1-mblnr.
*      endif.
*      endif.
    ENDLOOP.
  ENDLOOP.

ENDFORM.
