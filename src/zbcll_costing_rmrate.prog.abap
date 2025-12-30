*&---------------------------------------------------------------------*
*& Report  ZBCLL_COSTING_RMRATE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZBCLL_COSTING_RMRATE_A1.

TABLES: ZTP_COST1,
        MAKT,
        LFA1.

TYPE-POOLS:  SLIS.

DATA: G_REPID     LIKE SY-REPID,
      FIELDCAT    TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT LIKE LINE OF FIELDCAT,
      SORT        TYPE SLIS_T_SORTINFO_ALV,
      WA_SORT     LIKE LINE OF SORT,
      LAYOUT      TYPE SLIS_LAYOUT_ALV.


*TYPES : BEGIN OF itab1,
*          maktx     TYPE makt-maktx,
*          matnr     TYPE ztp_cost1-matnr,
*          fglifnr   TYPE ztp_cost1-fglifnr,
*          fgname1   TYPE lfa1-name1,
*          budat     TYPE sy-datum,
*          netpr(10) TYPE c,
*          peinh     TYPE ztp_cost1-peinh,
*          sgtxt     TYPE ztp_cost1-sgtxt,
*          uname     TYPE ztp_cost1-uname,
*          cpudt     TYPE sy-datum,
*          uzeit     TYPE ztp_cost1-uzeit,
*          count(10) TYPE c,
*        END OF itab1.
*
*DATA: it_tab1 TYPE TABLE OF itab1,
*      wa_tab1 TYPE itab1.

*DATA: it_ztp_cost1 TYPE TABLE OF ztp_cost1,
*      wa_ztp_cost1 TYPE ztp_cost1.

DATA: VARIANT TYPE DISVARIANT.
DATA : GR_ALVGRID    TYPE REF TO CL_GUI_ALV_GRID,
       GR_CCONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
       GT_FCAT       TYPE LVC_T_FCAT,
       GS_LAYO       TYPE LVC_S_LAYO.
DATA: C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID.         "ALV grid object
DATA: IT_DROPDOWN TYPE LVC_T_DROP,
      TY_DROPDOWN TYPE LVC_S_DROP,
*data declaration for refreshing of alv
      STABLE      TYPE LVC_S_STBL.
*Global variable declaration
DATA: GSTRING TYPE C.
*Data declarations for ALV
DATA: C_CCONT   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,         "Custom container object
*      C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID,         "ALV grid object
      IT_FCAT   TYPE LVC_T_FCAT,                  "Field catalogue
      IT_LAYOUT TYPE LVC_S_LAYO.                  "Layout
*ok code declaration
DATA:  OK_CODE       TYPE UI_FUNC.
DATA: COUNT TYPE  I.
DATA: ZTP_COST1_WA TYPE ZTP_COST1.
*******************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
PARAMETERS : R4  RADIOBUTTON GROUP R1,
*             r41 RADIOBUTTON GROUP r1,
*             r42  RADIOBUTTON GROUP r1,
             R43 RADIOBUTTON GROUP R1,

             R1  RADIOBUTTON GROUP R1.
*             R1A RADIOBUTTON GROUP R1,
*             R3  RADIOBUTTON GROUP R1,
**             R2 RADIOBUTTON GROUP R1,
*             R5  RADIOBUTTON GROUP R1,
**             R2 RADIOBUTTON GROUP R1,
*             R6  RADIOBUTTON GROUP R1,
*             R7  RADIOBUTTON GROUP R1,
*             R8  RADIOBUTTON GROUP R1,
*             R9  RADIOBUTTON GROUP R1.

SELECTION-SCREEN END OF BLOCK MERKMALE1 .

INITIALIZATION.
  G_REPID = SY-REPID.

AT SELECTION-SCREEN.
  PERFORM AUTHORIZATION.

START-OF-SELECTION.
*  IF r4 EQ 'X'.
*    CALL TRANSACTION 'ZCOST10'.
*  ELSEIF r41 EQ 'X'.
*    CALL TRANSACTION 'ZCOST11'.
*  ELSEIF r42 EQ 'X'.
*    CALL TRANSACTION 'ZCOST12'.
  IF R4 EQ 'X'.
    CALL TRANSACTION 'ZCOST15'.
  ELSEIF R43 EQ 'X'.
    CALL TRANSACTION 'ZCOST13'.

  ELSEIF R1 EQ 'X'.
     CALL TRANSACTION 'ZCOST18'.
*    CALL TRANSACTION 'ZCOST1'.
*  ELSEIF R1A EQ 'X'.
*    CALL TRANSACTION 'ZCOST2'.
**    PERFORM FORM1.
**  ELSEIF R2 EQ 'X'.
**    CALL   TRANSACTION 'ZCOST2'.
**    PERFORM FORM2.
*  ELSEIF R3 EQ 'X'.
*    CALL TRANSACTION 'ZCOST4'.
*  ELSEIF R5 EQ 'X'.
*    CALL TRANSACTION 'ZCOST3'.
**  ELSEIF R2 EQ 'X'.
**    CALL TRANSACTION 'ZCOST2'.
*  ELSEIF R6 EQ 'X'.
*    CALL TRANSACTION 'ZCOST5'.
*  ELSEIF R7 EQ 'X'.
*    CALL TRANSACTION 'ZCOST6'.
*  ELSEIF R8 EQ 'X'.
*    CALL TRANSACTION 'ZCOST7'.
*  ELSEIF R9 EQ 'X'.
*    CALL TRANSACTION 'ZCOST8'.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*form form1 .
*  select * from ztp_cost1 into table it_ztp_cost1.
*
*  loop at it_ztp_cost1 into wa_ztp_cost1.
*    select single * from makt where matnr eq wa_ztp_cost1-matnr and spras eq 'EN'.
*    if sy-subrc eq 0.
*      wa_tab1-maktx = makt-maktx.
*    endif.
*    wa_tab1-matnr = wa_ztp_cost1-matnr.
*    wa_tab1-FGlifnr = wa_ztp_cost1-FGlifnr.
*    select single * from lfa1 where lifnr eq wa_ztp_cost1-FGlifnr and spras eq 'EN'.
*    if sy-subrc eq 0.
*      wa_tab1-FGname1 = lfa1-name1.
*    endif.
*    wa_tab1-budat = wa_ztp_cost1-budat.
*    wa_tab1-netpr = wa_ztp_cost1-netpr.
*    wa_tab1-peinh = wa_ztp_cost1-peinh.
*
*    wa_tab1-sgtxt = wa_ztp_cost1-sgtxt.
*    wa_tab1-uname = wa_ztp_cost1-uname.
*
*    wa_tab1-uzeit = wa_ztp_cost1-uzeit.
*    collect wa_tab1 into it_tab1.
*    clear wa_tab1.
*  endloop.
*
*  loop at it_tab1 into wa_tab1.
*    pack wa_tab1-matnr to wa_tab1-matnr.
*    pack wa_tab1-FGlifnr to wa_tab1-FGlifnr.
*    condense : wa_tab1-matnr, wa_tab1-FGlifnr.
*    modify it_tab1 from wa_tab1 transporting matnr FGlifnr.
*  endloop.
*
*  wa_fieldcat-fieldname = 'MATNR'.
*  wa_fieldcat-seltext_l = 'MATERIAL CODE'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'MAKTX'.
*  wa_fieldcat-seltext_l = 'MATERIAL NAME'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'LIFNR'.
*  wa_fieldcat-seltext_l = 'VENDOR CODE'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'NAME1'.
*  wa_fieldcat-seltext_l = 'VENDOR NAME'.
*  append wa_fieldcat to fieldcat.
*
*
*  wa_fieldcat-fieldname = 'NETPR'.
*  wa_fieldcat-seltext_l = 'RATE'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'PEINH'.
*  wa_fieldcat-seltext_l = 'RATE PER UNIT'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'BUDAT'.
*  wa_fieldcat-seltext_l = 'RATE UPDATTED ON'.
*  append wa_fieldcat to fieldcat.
*
*
*
*  wa_fieldcat-fieldname = 'SGTXT'.
*  wa_fieldcat-seltext_l = 'REMARK'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'UNAME'.
*  wa_fieldcat-seltext_l = 'ENTERED BY'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'CPUDT'.
*  wa_fieldcat-seltext_l = 'ENTERED ON DT'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'UZEIT'.
*  wa_fieldcat-seltext_l = 'ENTERED ON TIME'.
*  append wa_fieldcat to fieldcat.
*
*
*  layout-zebra = 'X'.
*  layout-colwidth_optimize = 'X'.
*  layout-window_titlebar  = 'MATERIAL DETAILS ALONG WITH RATES FOR THIRD PARTY COSTING'.
*
*
*  call function 'REUSE_ALV_GRID_DISPLAY'
*    exporting
**     I_INTERFACE_CHECK       = ' '
**     I_BYPASSING_BUFFER      = ' '
**     I_BUFFER_ACTIVE         = ' '
*      i_callback_program      = g_repid
**     I_CALLBACK_PF_STATUS_SET          = ' '
*      i_callback_user_command = 'USER_COMM'
*      i_callback_top_of_page  = 'TOP'
**     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**     I_CALLBACK_HTML_END_OF_LIST       = ' '
**     I_STRUCTURE_NAME        =
**     I_BACKGROUND_ID         = ' '
**     I_GRID_TITLE            =
**     I_GRID_SETTINGS         =
*      is_layout               = layout
*      it_fieldcat             = fieldcat
**     IT_EXCLUDING            =
**     IT_SPECIAL_GROUPS       =
**     IT_SORT                 =
**     IT_FILTER               =
**     IS_SEL_HIDE             =
**     I_DEFAULT               = 'X'
*      i_save                  = 'A'
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
*    tables
*      t_outtab                = it_tab1
*    exceptions
*      program_error           = 1
*      others                  = 2.
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.

*endform.

*form top.
*
*  data: comment    type slis_t_listheader,
*        wa_comment like line of comment.
*
*  wa_comment-typ = 'A'.
*  wa_comment-info = 'MATERIAL RATE DETAILS'.
**  WA_COMMENT-INFO = P_FRMDT.
*  append wa_comment to comment.
*
*  call function 'REUSE_ALV_COMMENTARY_WRITE'
*    exporting
*      it_list_commentary = comment
**     I_LOGO             = 'ENJOYSAP_LOGO'
**     I_END_OF_LIST_GRID =
**     I_ALV_FORM         =
*    .
*
*  clear comment.
*
*endform.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
FORM USER_COMM USING UCOMM LIKE SY-UCOMM
                     SELFIELD TYPE SLIS_SELFIELD.



  CASE SELFIELD-FIELDNAME.
    WHEN 'VBELN'.
      SET PARAMETER ID 'VF' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM

FORM USER_COMM1 USING UCOMM LIKE SY-UCOMM SELFIELD TYPE SLIS_SELFIELD.
*  IF R1 EQ 'X'.
  CASE SY-UCOMM. "SELFIELD-FIELDNAME.
*      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
*        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
*      ENDLOOP.
*      BREAK-POINT.
    WHEN '&DATA_SAVE'(001).
*      message 'TERRITORY SAVED 1' type 'I'.
*      PERFORM BDC.
      PERFORM EDIT.
    WHEN OTHERS.
  ENDCASE.
  EXIT.
ENDFORM.                    "USER_COMM

*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM2 .
  CALL SCREEN 9001.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM AUTHORIZATION .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*MODULE status_9001 OUTPUT.
*  SET PF-STATUS 'STATUS'.
*  SET TITLEBAR 'CREATE'.
*  PERFORM data1.
*
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*MODULE user_command_9001 INPUT.
*  gr_alvgrid->check_changed_data( ).
*  CASE ok_code.
*    WHEN 'SAVE'.
**      BREAK-POINT.
*      PERFORM dataupd.
*      MESSAGE 'SAVE' TYPE 'I'.
*      LEAVE TO SCREEN 0.
*    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
*      LEAVE TO SCREEN 0.
*  ENDCASE.
*  CLEAR: ok_code.
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM data1 .
*  CLEAR : count.
*  DO 20 TIMES.
*    count = count.
*    wa_tab1-matnr = space.
*    wa_tab1-fglifnr = space.
*    wa_tab1-budat = space.
*    wa_tab1-netpr = space.
*    wa_tab1-peinh = 1.
*    wa_tab1-sgtxt = space.
*    wa_tab1-count = count.
*    COLLECT wa_tab1 INTO it_tab1.
*    CLEAR: wa_tab1.
*    count = count + 1.
*  ENDDO.
*
*
*  CREATE OBJECT gr_alvgrid
*    EXPORTING
**     i_parent          = gr_ccontainer
*      i_parent          = cl_gui_custom_container=>screen0
*    EXCEPTIONS
*      error_cntl_create = 1
*      error_cntl_init   = 2
*      error_cntl_link   = 3
*      error_dp_create   = 4
*      OTHERS            = 5.
*  IF sy-subrc <> 0.
**     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*  PERFORM alv_build_fieldcat.
*
*  CALL METHOD gr_alvgrid->set_table_for_first_display
*    EXPORTING
**     I_BUFFER_ACTIVE =
**     I_BYPASSING_BUFFER            =
**     I_CONSISTENCY_CHECK           =
**     I_STRUCTURE_NAME              =
*      is_variant      = variant
*      i_save          = 'A'
**     I_DEFAULT       = 'X'
*      is_layout       = gs_layo
**     IS_PRINT        =
**     IT_SPECIAL_GROUPS             =
**     IT_TOOLBAR_EXCLUDING          =
**     IT_HYPERLINK    =
**     IT_ALV_GRAPHICS =
**     IT_EXCEPT_QINFO =
**     IR_SALV_ADAPTER =
*    CHANGING
*      it_outtab       = it_tab1
*      it_fieldcatalog = it_fcat
**     IT_SORT         =
**     IT_FILTER       =
**      EXCEPTIONS
**     INVALID_PARAMETER_COMBINATION = 1
**     PROGRAM_ERROR   = 2
**     TOO_MANY_LINES  = 3
**     others          = 4
*    .
*  IF sy-subrc <> 0.
**     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM alv_build_fieldcat .
*
*  DATA lv_fldcat TYPE lvc_s_fcat.
*
*  lv_fldcat-fieldname = 'MATNR'.
**  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
*  lv_fldcat-scrtext_m = 'MATERIAL CODE'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-f4availabl = 'X'.
*  lv_fldcat-ref_table = 'MARA'.
*  lv_fldcat-ref_field = 'MATNR'.
*  lv_fldcat-outputlen = 10.
*  APPEND lv_fldcat TO it_fcat.
*  CLEAR lv_fldcat.
*
*  lv_fldcat-fieldname = 'LIFNR'.
**  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
*  lv_fldcat-scrtext_m = 'VENDOR'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-f4availabl = 'X'.
*  lv_fldcat-ref_table = 'LFA1'.
*  lv_fldcat-ref_field = 'LIFNR'.
*  lv_fldcat-outputlen = 10.
*  APPEND lv_fldcat TO it_fcat.
*  CLEAR lv_fldcat.
*
*  lv_fldcat-fieldname = 'NETPR'.
*  lv_fldcat-scrtext_m = 'RATE'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 10.
*  APPEND lv_fldcat TO it_fcat.
*  CLEAR lv_fldcat.
*
*  lv_fldcat-fieldname = 'PEINH'.
*  lv_fldcat-scrtext_m = 'RATE PER UNIT'.
*  lv_fldcat-edit   = 'X'.
**  LV_FLDCAT-OUTPUTLEN = 10.
*  APPEND lv_fldcat TO it_fcat.
*  CLEAR lv_fldcat.
*
*  lv_fldcat-fieldname = 'SGTXT'.
*  lv_fldcat-scrtext_m = 'REMARK IF ANY'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 50.
*  APPEND lv_fldcat TO it_fcat.
*  CLEAR lv_fldcat.
*
*
*
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DATAUPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM dataupd .
*  LOOP AT it_tab1 INTO wa_tab1 WHERE netpr GT 0.
*    ztp_cost1_wa-matnr = wa_tab1-matnr.
*    ztp_cost1_wa-fglifnr = wa_tab1-fglifnr.
*    ztp_cost1_wa-budat = sy-datum.
*    ztp_cost1_wa-netpr = wa_tab1-netpr.
*    ztp_cost1_wa-peinh = wa_tab1-peinh.
*    ztp_cost1_wa-sgtxt = wa_tab1-sgtxt.
*    ztp_cost1_wa-uname = sy-uname.
*
*    ztp_cost1_wa-uzeit = sy-uzeit.
*    MODIFY ztp_cost1 FROM ztp_cost1_wa.
*    CLEAR ztp_cost1_wa.
*  ENDLOOP.
*  IF sy-subrc EQ 0.
*    MESSAGE 'SAVE DATA' TYPE 'I'.
*  ENDIF.
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PREFER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM PREFER .
*  SELECT * FROM ZTP_COST1 INTO TABLE IT_ZTP_COST1.
*
*  LOOP AT IT_ZTP_COST1 INTO WA_ZTP_COST1.
*    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZTP_COST1-MATNR AND SPRAS EQ 'EN'.
*    IF SY-SUBRC EQ 0.
*      WA_TAB1-MAKTX = MAKT-MAKTX.
*    ENDIF.
*    WA_TAB1-MATNR = WA_ZTP_COST1-MATNR.
*    WA_TAB1-LIFNR = WA_ZTP_COST1-LIFNR.
*    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZTP_COST1-LIFNR AND SPRAS EQ 'EN'.
*    IF SY-SUBRC EQ 0.
*      WA_TAB1-NAME1 = LFA1-NAME1.
*    ENDIF.
*    WA_TAB1-BUDAT = WA_ZTP_COST1-BUDAT.
*    WA_TAB1-NETPR = WA_ZTP_COST1-NETPR.
*    WA_TAB1-PEINH = WA_ZTP_COST1-PEINH.
*    WA_TAB1-PREFER = WA_ZTP_COST1-PREFER.
*    WA_TAB1-SGTXT = WA_ZTP_COST1-SGTXT.
*    WA_TAB1-UNAME = WA_ZTP_COST1-UNAME.
*    WA_TAB1-CPUDT = WA_ZTP_COST1-CPUDT.
*    WA_TAB1-UZEIT = WA_ZTP_COST1-UZEIT.
*    COLLECT WA_TAB1 INTO IT_TAB1.
*    CLEAR WA_TAB1.
*  ENDLOOP.
*
**  LOOP AT IT_TAB1 INTO WA_TAB1.
**    PACK WA_TAB1-MATNR TO WA_TAB1-MATNR.
**    PACK WA_TAB1-LIFNR TO WA_TAB1-LIFNR.
**    CONDENSE : WA_TAB1-MATNR, WA_TAB1-LIFNR.
**    MODIFY IT_TAB1 FROM WA_TAB1 TRANSPORTING MATNR LIFNR.
**  ENDLOOP.
*
*  WA_FIELDCAT-FIELDNAME = 'MATNR'.
*  WA_FIELDCAT-SELTEXT_L = 'MATERIAL CODE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MAKTX'.
*  WA_FIELDCAT-SELTEXT_L = 'MATERIAL NAME'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'LIFNR'.
*  WA_FIELDCAT-SELTEXT_L = 'VENDOR CODE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'NAME1'.
*  WA_FIELDCAT-SELTEXT_L = 'VENDOR NAME'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'NETPR'.
*  WA_FIELDCAT-SELTEXT_L = 'RATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'PEINH'.
*  WA_FIELDCAT-SELTEXT_L = 'RATE PER UNIT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'BUDAT'.
*  WA_FIELDCAT-SELTEXT_L = 'RATE UPDATTED ON'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'PREFER'.
*  WA_FIELDCAT-SELTEXT_L = 'PREFERED VENDOR'.
*  WA_FIELDCAT-EDIT = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'SGTXT'.
*  WA_FIELDCAT-SELTEXT_L = 'REMARK'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'UNAME'.
*  WA_FIELDCAT-SELTEXT_L = 'ENTERED BY'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'CPUDT'.
*  WA_FIELDCAT-SELTEXT_L = 'ENTERED ON DT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'UZEIT'.
*  WA_FIELDCAT-SELTEXT_L = 'ENTERED ON TIME'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*  CLEAR WA_FIELDCAT.
*
*
*  LAYOUT-ZEBRA = 'X'.
*  LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
*  LAYOUT-WINDOW_TITLEBAR  = 'MATERIAL DETAILS ALONG WITH RATES FOR THIRD PARTY COSTING'.
*
*
*  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*    EXPORTING
**     I_INTERFACE_CHECK       = ' '
**     I_BYPASSING_BUFFER      = ' '
**     I_BUFFER_ACTIVE         = ' '
*      I_CALLBACK_PROGRAM      = G_REPID
**     I_CALLBACK_PF_STATUS_SET          = ' '
*      I_CALLBACK_USER_COMMAND = 'USER_COMM1'
*      I_CALLBACK_TOP_OF_PAGE  = 'TOP'
**     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**     I_CALLBACK_HTML_END_OF_LIST       = ' '
**     I_STRUCTURE_NAME        =
**     I_BACKGROUND_ID         = ' '
**     I_GRID_TITLE            =
**     I_GRID_SETTINGS         =
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
*      T_OUTTAB                = IT_TAB1
*    EXCEPTIONS
*      PROGRAM_ERROR           = 1
*      OTHERS                  = 2.
*  IF SY-SUBRC <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EDIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM EDIT .
  MESSAGE 'SET PREFERENCE' TYPE 'I'.
ENDFORM.
