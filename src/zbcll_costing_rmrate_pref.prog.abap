*&---------------------------------------------------------------------*
*& Report  ZBCLL_COSTING_RMRATE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zbcll_costing_rmrate_pref_a1.

TABLES: ztp_cost1,
        makt,
        lfa1,
        mara,
        ztp_cost8.

TYPE-POOLS:  slis.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.


TYPES : BEGIN OF itab1,
          maktx     TYPE makt-maktx,
          matnr     TYPE ztp_cost1-matnr,
          lifnr     TYPE ztp_cost1-fglifnr,
          name1     TYPE lfa1-name1,
          budat     TYPE sy-datum,
          netpr(10) TYPE c,
          peinh     TYPE ztp_cost1-peinh,

          sgtxt     TYPE ztp_cost1-sgtxt,
          uname     TYPE ztp_cost1-uname,
          cpudt     TYPE sy-datum,
          uzeit     TYPE ztp_cost1-uzeit,
          count(10) TYPE c,
          chk(3)    TYPE c,
        END OF itab1.

TYPES : BEGIN OF mat1,
          matnr TYPE mara-matnr,
          lifnr TYPE lfa1-lifnr,
        END OF mat1.

DATA: it_tab1 TYPE TABLE OF itab1,
      wa_tab1 TYPE itab1,
      it_mat1 TYPE TABLE OF mat1,
      wa_mat1 TYPE mat1.

DATA: mat1 TYPE i,
      lif1 TYPE i.
DATA: it_ztp_cost1 TYPE TABLE OF ztp_cost1,
      wa_ztp_cost1 TYPE ztp_cost1.

DATA: variant TYPE disvariant.
DATA : gr_alvgrid    TYPE REF TO cl_gui_alv_grid,
       gr_ccontainer TYPE REF TO cl_gui_custom_container,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layo       TYPE lvc_s_layo.
DATA: c_alvgd   TYPE REF TO cl_gui_alv_grid.         "ALV grid object
DATA: it_dropdown TYPE lvc_t_drop,
      ty_dropdown TYPE lvc_s_drop,
*data declaration for refreshing of alv
      stable      TYPE lvc_s_stbl.
*Global variable declaration
DATA: gstring TYPE c.
*Data declarations for ALV
DATA: c_ccont   TYPE REF TO cl_gui_custom_container,         "Custom container object
*      C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID,         "ALV grid object
      it_fcat   TYPE lvc_t_fcat,                  "Field catalogue
      it_layout TYPE lvc_s_layo.                  "Layout
*ok code declaration
DATA:  ok_code       TYPE ui_func.
DATA: count TYPE  i.
DATA: ztp_cost8_wa TYPE ztp_cost8.
*******************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE text-001.
SELECT-OPTIONS : matnr FOR mara-matnr.
PARAMETERS : fglifnr LIKE lfa1-lifnr OBLIGATORY.

*PARAMETERS : R1 RADIOBUTTON GROUP R1,
*             R2 RADIOBUTTON GROUP R1,
*             R3 RADIOBUTTON GROUP R1.
SELECTION-SCREEN END OF BLOCK merkmale1 .

INITIALIZATION.
  g_repid = sy-repid.

AT SELECTION-SCREEN.
  PERFORM authorization.

START-OF-SELECTION.

*  IF R1 EQ 'X'.
*    PERFORM FORM1.
*  ELSEIF R2 EQ 'X'.
*    PERFORM FORM2.
*  ELSEIF R3 EQ 'X'.
  PERFORM prefer.
*  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM FORM1 .
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
*  LOOP AT IT_TAB1 INTO WA_TAB1.
*    PACK WA_TAB1-MATNR TO WA_TAB1-MATNR.
*    PACK WA_TAB1-LIFNR TO WA_TAB1-LIFNR.
*    CONDENSE : WA_TAB1-MATNR, WA_TAB1-LIFNR.
*    MODIFY IT_TAB1 FROM WA_TAB1 TRANSPORTING MATNR LIFNR.
*  ENDLOOP.
*
*  WA_FIELDCAT-FIELDNAME = 'MATNR'.
*  WA_FIELDCAT-SELTEXT_L = 'MATERIAL CODE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'MAKTX'.
*  WA_FIELDCAT-SELTEXT_L = 'MATERIAL NAME'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'LIFNR'.
*  WA_FIELDCAT-SELTEXT_L = 'VENDOR CODE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'NAME1'.
*  WA_FIELDCAT-SELTEXT_L = 'VENDOR NAME'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'PREFER'.
*  WA_FIELDCAT-SELTEXT_L = 'PREFERED VENDOR'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'NETPR'.
*  WA_FIELDCAT-SELTEXT_L = 'RATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'PEINH'.
*  WA_FIELDCAT-SELTEXT_L = 'RATE PER UNIT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'BUDAT'.
*  WA_FIELDCAT-SELTEXT_L = 'RATE UPDATTED ON'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*
*
*  WA_FIELDCAT-FIELDNAME = 'SGTXT'.
*  WA_FIELDCAT-SELTEXT_L = 'REMARK'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'UNAME'.
*  WA_FIELDCAT-SELTEXT_L = 'ENTERED BY'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'CPUDT'.
*  WA_FIELDCAT-SELTEXT_L = 'ENTERED ON DT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-FIELDNAME = 'UZEIT'.
*  WA_FIELDCAT-SELTEXT_L = 'ENTERED ON TIME'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
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
*      I_CALLBACK_USER_COMMAND = 'USER_COMM'
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
*
*ENDFORM.

FORM top.

  DATA: comment    TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'MATERIAL VENDOR PREFERENCE'.
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
**----------------------------------------------------------------------*
*FORM USER_COMM USING UCOMM LIKE SY-UCOMM
*                     SELFIELD TYPE SLIS_SELFIELD.
*
*
*
*  CASE SELFIELD-FIELDNAME.
*    WHEN 'VBELN'.
*      SET PARAMETER ID 'VF' FIELD SELFIELD-VALUE.
*      CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
*    WHEN 'VBELN1'.
*      SET PARAMETER ID 'BV' FIELD SELFIELD-VALUE.
*      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
*    WHEN OTHERS.
*  ENDCASE.
*ENDFORM.                    "USER_COMM

FORM user_comm1 USING ucomm LIKE sy-ucomm selfield TYPE slis_selfield.
*  IF R1 EQ 'X'.
  CASE sy-ucomm. "SELFIELD-FIELDNAME.
*      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
*        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
*      ENDLOOP.
*      BREAK-POINT.
    WHEN '&DATA_SAVE'(001).
*      message 'TERRITORY SAVED 1' type 'I'.
*      PERFORM BDC.
      PERFORM edit.
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
*FORM FORM2 .
*  CALL SCREEN 9001.
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM authorization .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*MODULE STATUS_9001 OUTPUT.
*  SET PF-STATUS 'STATUS'.
*  SET TITLEBAR 'CREATE'.
*  PERFORM DATA1.
*
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*MODULE USER_COMMAND_9001 INPUT.
*  GR_ALVGRID->CHECK_CHANGED_DATA( ).
*  CASE OK_CODE.
*    WHEN 'SAVE'.
**      BREAK-POINT.
*      PERFORM DATAUPD.
*      MESSAGE 'SAVE' TYPE 'I'.
*      LEAVE TO SCREEN 0.
*    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
*      LEAVE TO SCREEN 0.
*  ENDCASE.
*  CLEAR: OK_CODE.
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM DATA1 .
*  CLEAR : COUNT.
*  DO 20 TIMES.
*    COUNT = COUNT.
*    WA_TAB1-MATNR = SPACE.
*    WA_TAB1-LIFNR = SPACE.
*    WA_TAB1-BUDAT = SPACE.
*    WA_TAB1-NETPR = SPACE.
*    WA_TAB1-PEINH = 1.
*    WA_TAB1-SGTXT = SPACE.
*    WA_TAB1-COUNT = COUNT.
*    COLLECT WA_TAB1 INTO IT_TAB1.
*    CLEAR: WA_TAB1.
*    COUNT = COUNT + 1.
*  ENDDO.
*
*
*  CREATE OBJECT GR_ALVGRID
*    EXPORTING
**     i_parent          = gr_ccontainer
*      I_PARENT          = CL_GUI_CUSTOM_CONTAINER=>SCREEN0
*    EXCEPTIONS
*      ERROR_CNTL_CREATE = 1
*      ERROR_CNTL_INIT   = 2
*      ERROR_CNTL_LINK   = 3
*      ERROR_DP_CREATE   = 4
*      OTHERS            = 5.
*  IF SY-SUBRC <> 0.
**     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*  PERFORM ALV_BUILD_FIELDCAT.
*
*  CALL METHOD GR_ALVGRID->SET_TABLE_FOR_FIRST_DISPLAY
*    EXPORTING
**     I_BUFFER_ACTIVE =
**     I_BYPASSING_BUFFER            =
**     I_CONSISTENCY_CHECK           =
**     I_STRUCTURE_NAME              =
*      IS_VARIANT      = VARIANT
*      I_SAVE          = 'A'
**     I_DEFAULT       = 'X'
*      IS_LAYOUT       = GS_LAYO
**     IS_PRINT        =
**     IT_SPECIAL_GROUPS             =
**     IT_TOOLBAR_EXCLUDING          =
**     IT_HYPERLINK    =
**     IT_ALV_GRAPHICS =
**     IT_EXCEPT_QINFO =
**     IR_SALV_ADAPTER =
*    CHANGING
*      IT_OUTTAB       = IT_TAB1
*      IT_FIELDCATALOG = IT_FCAT
**     IT_SORT         =
**     IT_FILTER       =
**      EXCEPTIONS
**     INVALID_PARAMETER_COMBINATION = 1
**     PROGRAM_ERROR   = 2
**     TOO_MANY_LINES  = 3
**     others          = 4
*    .
*  IF SY-SUBRC <> 0.
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
*FORM ALV_BUILD_FIELDCAT .
*
*  DATA LV_FLDCAT TYPE LVC_S_FCAT.
*
*  LV_FLDCAT-FIELDNAME = 'MATNR'.
**  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
*  LV_FLDCAT-SCRTEXT_M = 'MATERIAL CODE'.
*  LV_FLDCAT-EDIT   = 'X'.
*  LV_FLDCAT-F4AVAILABL = 'X'.
*  LV_FLDCAT-REF_TABLE = 'MARA'.
*  LV_FLDCAT-REF_FIELD = 'MATNR'.
*  LV_FLDCAT-OUTPUTLEN = 10.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
*
*  LV_FLDCAT-FIELDNAME = 'LIFNR'.
**  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
*  LV_FLDCAT-SCRTEXT_M = 'VENDOR'.
*  LV_FLDCAT-EDIT   = 'X'.
*  LV_FLDCAT-F4AVAILABL = 'X'.
*  LV_FLDCAT-REF_TABLE = 'LFA1'.
*  LV_FLDCAT-REF_FIELD = 'LIFNR'.
*  LV_FLDCAT-OUTPUTLEN = 10.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
*
*  LV_FLDCAT-FIELDNAME = 'NETPR'.
*  LV_FLDCAT-SCRTEXT_M = 'RATE'.
*  LV_FLDCAT-EDIT   = 'X'.
*  LV_FLDCAT-OUTPUTLEN = 10.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
*
*  LV_FLDCAT-FIELDNAME = 'PEINH'.
*  LV_FLDCAT-SCRTEXT_M = 'RATE PER UNIT'.
*  LV_FLDCAT-EDIT   = 'X'.
**  LV_FLDCAT-OUTPUTLEN = 10.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
*
*  LV_FLDCAT-FIELDNAME = 'SGTXT'.
*  LV_FLDCAT-SCRTEXT_M = 'REMARK IF ANY'.
*  LV_FLDCAT-EDIT   = 'X'.
*  LV_FLDCAT-OUTPUTLEN = 50.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
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
*FORM DATAUPD .
*  LOOP AT IT_TAB1 INTO WA_TAB1 WHERE NETPR GT 0.
*    ZTP_COST1_WA-MATNR = WA_TAB1-MATNR.
*    ZTP_COST1_WA-LIFNR = WA_TAB1-LIFNR.
*    ZTP_COST1_WA-BUDAT = SY-DATUM.
*    ZTP_COST1_WA-NETPR = WA_TAB1-NETPR.
*    ZTP_COST1_WA-PEINH = WA_TAB1-PEINH.
*    ZTP_COST1_WA-SGTXT = WA_TAB1-SGTXT.
*    ZTP_COST1_WA-UNAME = SY-UNAME.
*    ZTP_COST1_WA-CPUDT = SY-DATUM.
*    ZTP_COST1_WA-UZEIT = SY-UZEIT.
*    MODIFY ZTP_COST1 FROM ZTP_COST1_WA.
*    CLEAR ZTP_COST1_WA.
*  ENDLOOP.
*  IF SY-SUBRC EQ 0.
*    MESSAGE 'SAVE DATA' TYPE 'I'.
*  ENDIF.
*ENDFORM.
**&---------------------------------------------------------------------*
*&      Form  PREFER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prefer .
  SELECT * FROM ztp_cost1 INTO TABLE it_ztp_cost1 WHERE matnr IN matnr AND fglifnr EQ fglifnr.

  LOOP AT it_ztp_cost1 INTO wa_ztp_cost1.
    wa_mat1-matnr = wa_ztp_cost1-matnr.
    wa_mat1-lifnr = wa_ztp_cost1-rplifnr.
    COLLECT wa_mat1 INTO it_mat1.
    CLEAR wa_mat1.
  ENDLOOP.
  SORT it_mat1 BY matnr lifnr.
  DELETE ADJACENT DUPLICATES FROM it_mat1 COMPARING matnr lifnr.
  SORT it_ztp_cost1 DESCENDING BY budat.

  LOOP AT it_mat1 INTO wa_mat1.
    READ TABLE it_ztp_cost1 INTO wa_ztp_cost1 WITH KEY matnr = wa_mat1-matnr rplifnr = wa_mat1-lifnr.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_ztp_cost1-matnr AND spras EQ 'EN'.
      IF sy-subrc EQ 0.
        wa_tab1-maktx = makt-maktx.
      ENDIF.
      wa_tab1-matnr = wa_ztp_cost1-matnr.
      wa_tab1-lifnr = wa_ztp_cost1-rplifnr.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_ztp_cost1-rplifnr AND spras EQ 'EN'.
      IF sy-subrc EQ 0.
        wa_tab1-name1 = lfa1-name1.
      ENDIF.
      wa_tab1-budat = wa_ztp_cost1-budat.
      wa_tab1-netpr = wa_ztp_cost1-netpr.
      wa_tab1-peinh = wa_ztp_cost1-peinh.

      wa_tab1-sgtxt = wa_ztp_cost1-sgtxt.
      wa_tab1-uname = wa_ztp_cost1-uname.
      wa_tab1-uzeit = wa_ztp_cost1-uzeit.
      SELECT SINGLE * FROM ztp_cost8 WHERE matnr EQ wa_ztp_cost1-matnr AND fglifnr EQ fglifnr AND rplifnr EQ wa_ztp_cost1-rplifnr.
      IF sy-subrc EQ 0.
        wa_tab1-chk = 'X'.
      ENDIF.
      COLLECT wa_tab1 INTO it_tab1.
      CLEAR wa_tab1.
    ENDIF.
  ENDLOOP.

*  LOOP AT IT_TAB1 INTO WA_TAB1.
*    PACK WA_TAB1-MATNR TO WA_TAB1-MATNR.
*    PACK WA_TAB1-LIFNR TO WA_TAB1-LIFNR.
*    CONDENSE : WA_TAB1-MATNR, WA_TAB1-LIFNR.
*    MODIFY IT_TAB1 FROM WA_TAB1 TRANSPORTING MATNR LIFNR.
*  ENDLOOP.

  wa_fieldcat-fieldname = 'CHK'.
  wa_fieldcat-seltext_l = 'PREFERED VENDOR'.
  wa_fieldcat-edit = 'X'.
  wa_fieldcat-checkbox = 'X'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'MATERIAL CODE'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'MATERIAL NAME'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'LIFNR'.
  wa_fieldcat-seltext_l = 'VENDOR CODE'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'VENDOR NAME'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'NETPR'.
  wa_fieldcat-seltext_l = 'RATE'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'PEINH'.
  wa_fieldcat-seltext_l = 'RATE PER UNIT'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'BUDAT'.
  wa_fieldcat-seltext_l = 'RATE UPDATTED ON'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.



  wa_fieldcat-fieldname = 'SGTXT'.
  wa_fieldcat-seltext_l = 'REMARK'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'UNAME'.
  wa_fieldcat-seltext_l = 'ENTERED BY'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'CPUDT'.
  wa_fieldcat-seltext_l = 'ENTERED ON DT'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'UZEIT'.
  wa_fieldcat-seltext_l = 'ENTERED ON TIME'.
  APPEND wa_fieldcat TO fieldcat.
  CLEAR wa_fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'MATERIAL VENDOR PREFERENCE FOR THIRD PARTY COSTING'.


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
      t_outtab                = it_tab1
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EDIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM edit .
  SORT it_tab1 BY matnr.
  CLEAR : count,mat1,lif1.
  LOOP AT it_tab1 INTO wa_tab1.
    ON CHANGE OF wa_tab1-matnr.
      mat1 = 1.
      lif1 = 1.
      count = 1.
    ENDON.
    IF wa_tab1-chk EQ 'X'.
      count = count + 1..
    ENDIF.
    IF count GT 2.
      MESSAGE 'CHECK PREFERENCE' TYPE 'E'.
    ENDIF.
  ENDLOOP.
*    IF COUNT GT 2.
*      MESSAGE 'CHECK PREFERENCE' TYPE 'E'.
*    ENDIF.
  LOOP AT it_tab1 INTO wa_tab1 WHERE chk EQ 'X'.
    ztp_cost8_wa-matnr = wa_tab1-matnr.
    ztp_cost8_wa-fglifnr = fglifnr.
    ztp_cost8_wa-rplifnr = wa_tab1-lifnr.
    ztp_cost8_wa-cpudt = sy-datum.
    ztp_cost8_wa-uname = sy-uname.
    ztp_cost8_wa-uzeit = sy-uzeit.
    MODIFY ztp_cost8 FROM ztp_cost8_wa.
    CLEAR : ztp_cost8_wa.
  ENDLOOP.


  IF sy-subrc EQ 0.
    MESSAGE 'SET PREFERENCE' TYPE 'I'.
  ENDIF.
  LEAVE TO SCREEN 0.
ENDFORM.
