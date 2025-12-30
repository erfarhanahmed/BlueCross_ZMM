*&---------------------------------------------------------------------*
*& Report  ZBCLL_COSTING_RMRATE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZBCLL_COSTING_RMRATE11_A2_A1.

TABLES: ZTP_COST1,
        MAKT,
        LFA1,
        MARA,
        ZTP_COST8.

TYPE-POOLS:  SLIS.

DATA: G_REPID     LIKE SY-REPID,
      FIELDCAT    TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT LIKE LINE OF FIELDCAT,
      SORT        TYPE SLIS_T_SORTINFO_ALV,
      WA_SORT     LIKE LINE OF SORT,
      LAYOUT      TYPE SLIS_LAYOUT_ALV.


TYPES : BEGIN OF ITAB1,
          FGNAME1    TYPE LFA1-NAME1,
          MAKTX      TYPE MAKT-MAKTX,
          MATNR      TYPE ZTP_COST1-MATNR,
          FGLIFNR    TYPE ZTP_COST1-FGLIFNR,
          RPLIFNR    TYPE ZTP_COST1-FGLIFNR,

          RPNAME1    TYPE LFA1-NAME1,
          BUDAT      TYPE SY-DATUM,
          NETPR(10)  TYPE C,
          PEINH      TYPE ZTP_COST1-PEINH,
          FRTPER(10) TYPE C,
          FRTVAL(10) TYPE C,
          SGTXT      TYPE ZTP_COST1-SGTXT,
          UNAME      TYPE ZTP_COST1-UNAME,
          CPUDT      TYPE SY-DATUM,
          UZEIT      TYPE ZTP_COST1-UZEIT,
          COUNT(10)  TYPE C,
          PREFER(20) TYPE C,
        END OF ITAB1.

TYPES: BEGIN OF RT1,
         MATNR     TYPE MARA-MATNR,
         LIFNR     TYPE LFA1-LIFNR,
         NETPR(10) TYPE C,
         PEINH     TYPE EKPO-PEINH,


       END OF RT1.

DATA: IT_TAB1 TYPE TABLE OF ITAB1,
      WA_TAB1 TYPE ITAB1,
      IT_RT1  TYPE TABLE OF RT1,
      WA_RT1  TYPE RT1.

DATA: IT_ZTP_COST1 TYPE TABLE OF ZTP_COST1,
      WA_ZTP_COST1 TYPE ZTP_COST1.

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
DATA: C_FILE TYPE STRING.
*Data declarations for ALV
DATA: C_CCONT   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,         "Custom container object
*      C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID,         "ALV grid object
      IT_FCAT   TYPE LVC_T_FCAT,                  "Field catalogue
      IT_LAYOUT TYPE LVC_S_LAYO.                  "Layout
*ok code declaration
DATA:  OK_CODE       TYPE UI_FUNC.
DATA: COUNT TYPE  POSNR.
DATA: RPLIFNR TYPE LFA1-LIFNR.
DATA: ZTP_COST1_WA TYPE ZTP_COST1.
DATA: COUNT1 TYPE POSNR.
*******************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-002.
PARAMETERS : FGLIFNR LIKE LFA1-LIFNR.
PARAMETERS : R1 RADIOBUTTON GROUP R1,
             R2 RADIOBUTTON GROUP R1.

*             R3 RADIOBUTTON GROUP R1.
SELECT-OPTIONS: MATERIAL FOR MARA-MATNR,
                FGLIFNR1 FOR LFA1-LIFNR.
PARAMETERS : R3 RADIOBUTTON GROUP R1.

SELECTION-SCREEN END OF BLOCK MERKMALE1 .
SELECTION-SCREEN BEGIN OF BLOCK MERKMALE2 WITH FRAME TITLE TEXT-001.
PARAMETERS : P_FILE TYPE RLGRAP-FILENAME.
SELECTION-SCREEN END OF BLOCK MERKMALE2 .

INITIALIZATION.
  G_REPID = SY-REPID.

AT SELECTION-SCREEN.
  PERFORM AUTHORIZATION.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      PROGRAM_NAME  = SYST-CPROG
      DYNPRO_NUMBER = SYST-DYNNR
      FIELD_NAME    = ' '
    IMPORTING
      FILE_NAME     = P_FILE.

START-OF-SELECTION.

  IF R2 EQ 'X'.
    PERFORM FORM2.
  ELSEIF R1 EQ 'X'. "maintain data
    IF FGLIFNR IS INITIAL.
      MESSAGE 'Enter FG VENDOR CODE to maintain the rates' TYPE 'E'.
    ENDIF.
    PERFORM FORM1.
  ELSEIF R3 EQ 'X'.
    PERFORM UPDTRT.
  ENDIF.
*  ELSEIF R3 EQ 'X'.
*   call TRANSACTION 'ZCOST_VPREF'.
*  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM2 .
  SELECT * FROM ZTP_COST1 INTO TABLE IT_ZTP_COST1 WHERE MATNR IN MATERIAL AND FGLIFNR IN FGLIFNR1.

  LOOP AT IT_ZTP_COST1 INTO WA_ZTP_COST1.
    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZTP_COST1-MATNR AND SPRAS EQ 'EN'.
    IF SY-SUBRC EQ 0.
      WA_TAB1-MAKTX = MAKT-MAKTX.
    ENDIF.
    WA_TAB1-MATNR = WA_ZTP_COST1-MATNR.
    WA_TAB1-FGLIFNR = WA_ZTP_COST1-FGLIFNR.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZTP_COST1-FGLIFNR AND SPRAS EQ 'EN'.
    IF SY-SUBRC EQ 0.
      WA_TAB1-FGNAME1 = LFA1-NAME1.
    ENDIF.
    WA_TAB1-RPLIFNR = WA_ZTP_COST1-RPLIFNR.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZTP_COST1-RPLIFNR AND SPRAS EQ 'EN'.
    IF SY-SUBRC EQ 0.
      WA_TAB1-RPNAME1 = LFA1-NAME1.
    ENDIF.
    WA_TAB1-BUDAT = WA_ZTP_COST1-BUDAT.
    WA_TAB1-NETPR = WA_ZTP_COST1-NETPR.
    WA_TAB1-PEINH = WA_ZTP_COST1-PEINH.
*    wa_tab1-frtper = wa_ztp_cost1-frtper.
*    wa_tab1-frtval = wa_ztp_cost1-frtval.

    WA_TAB1-SGTXT = WA_ZTP_COST1-SGTXT.
    WA_TAB1-UNAME = WA_ZTP_COST1-UNAME.
    WA_TAB1-UZEIT = WA_ZTP_COST1-UZEIT.
    SELECT SINGLE * FROM ZTP_COST8 WHERE MATNR EQ WA_ZTP_COST1-MATNR AND FGLIFNR EQ FGLIFNR AND RPLIFNR EQ WA_ZTP_COST1-RPLIFNR.
    IF SY-SUBRC EQ 0.
      WA_TAB1-PREFER = 'PREFERED VENDOR'.
    ENDIF.
    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
  ENDLOOP.
  SORT IT_TAB1 BY BUDAT DESCENDING.
  DELETE IT_TAB1 WHERE MATNR LE 0.
  LOOP AT IT_TAB1 INTO WA_TAB1.
    PACK WA_TAB1-MATNR TO WA_TAB1-MATNR.
    PACK WA_TAB1-RPLIFNR TO WA_TAB1-RPLIFNR.
    CONDENSE : WA_TAB1-MATNR, WA_TAB1-RPLIFNR.
    MODIFY IT_TAB1 FROM WA_TAB1 TRANSPORTING MATNR RPLIFNR.
  ENDLOOP.




  WA_FIELDCAT-FIELDNAME = 'FGLIFNR'.
  WA_FIELDCAT-SELTEXT_L = 'FG VENDOR'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'FGNAME1'.
  WA_FIELDCAT-SELTEXT_L = 'FG PRODUCT VENDOR NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MATNR'.
  WA_FIELDCAT-SELTEXT_L = 'MATERIAL CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MAKTX'.
  WA_FIELDCAT-SELTEXT_L = 'MATERIAL NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NETPR'.
  WA_FIELDCAT-SELTEXT_L = 'RATE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'PEINH'.
  WA_FIELDCAT-SELTEXT_L = 'RATE PER UNIT'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'RPLIFNR'.
  WA_FIELDCAT-SELTEXT_L = 'RM PM VENDOR'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'RPNAME1'.
  WA_FIELDCAT-SELTEXT_L = 'RM, PM VENDOR NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'PREFER'.
  WA_FIELDCAT-SELTEXT_L = 'RM PM VENDOR STATUS'.
  APPEND WA_FIELDCAT TO FIELDCAT.




*  wa_fieldcat-fieldname = 'FRTPER'.
*  wa_fieldcat-seltext_l = 'FREIGHT PERCENT'.
*  APPEND wa_fieldcat TO fieldcat.
*
*  wa_fieldcat-fieldname = 'FRTVAL'.
*  wa_fieldcat-seltext_l = 'FREIGHT VALUE'.
*  APPEND wa_fieldcat TO fieldcat.

  WA_FIELDCAT-FIELDNAME = 'BUDAT'.
  WA_FIELDCAT-SELTEXT_L = 'RATE UPDATTED ON'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'UNAME'.
  WA_FIELDCAT-SELTEXT_L = 'ENTERED BY'.
  APPEND WA_FIELDCAT TO FIELDCAT.

*  WA_FIELDCAT-FIELDNAME = 'CPUDT'.
*  WA_FIELDCAT-SELTEXT_L = 'ENTERED ON DT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'UZEIT'.
  WA_FIELDCAT-SELTEXT_L = 'ENTERED ON TIME'.
  APPEND WA_FIELDCAT TO FIELDCAT.


  WA_FIELDCAT-FIELDNAME = 'SGTXT'.
  WA_FIELDCAT-SELTEXT_L = 'REMARK'.
  APPEND WA_FIELDCAT TO FIELDCAT.




  LAYOUT-ZEBRA = 'X'.
  LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  LAYOUT-WINDOW_TITLEBAR  = 'MATERIAL DETAILS ALONG WITH RATES FOR THIRD PARTY COSTING'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      I_CALLBACK_PROGRAM      = G_REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
      I_CALLBACK_USER_COMMAND = 'USER_COMM'
      I_CALLBACK_TOP_OF_PAGE  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      IS_LAYOUT               = LAYOUT
      IT_FIELDCAT             = FIELDCAT
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      I_SAVE                  = 'A'
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
      T_OUTTAB                = IT_TAB1
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.

FORM TOP.

  DATA: COMMENT    TYPE SLIS_T_LISTHEADER,
        WA_COMMENT LIKE LINE OF COMMENT.

  WA_COMMENT-TYP = 'A'.
  WA_COMMENT-INFO = 'MATERIAL RATE DETAILS'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND WA_COMMENT TO COMMENT.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = COMMENT
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  CLEAR COMMENT.

ENDFORM.                    "TOP



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
FORM FORM1 .
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
MODULE STATUS_9001 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'CREATE'.
  PERFORM DATA1.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9001 INPUT.
  GR_ALVGRID->CHECK_CHANGED_DATA( ).
  CASE OK_CODE.
    WHEN 'SAVE'.
*      BREAK-POINT.
      PERFORM DATAUPD.
      MESSAGE 'SAVE' TYPE 'I'.
      LEAVE TO SCREEN 0.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR: OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATA1 .
  CLEAR : COUNT.
  DO 50 TIMES.
    COUNT = COUNT.
    WA_TAB1-FGLIFNR = FGLIFNR.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ FGLIFNR.
    IF SY-SUBRC EQ 0.
      WA_TAB1-FGNAME1 = LFA1-NAME1.
    ENDIF.
    WA_TAB1-MATNR = SPACE.
    WA_TAB1-RPLIFNR = SPACE.
*    WA_TAB1-BUDAT = SPACE.
    WA_TAB1-NETPR = SPACE.
    WA_TAB1-PEINH = 1.
*    WA_TAB1-FRTPER = SPACE.
*    WA_TAB1-FRTVAL = SPACE.
    WA_TAB1-SGTXT = SPACE.
    WA_TAB1-COUNT = COUNT.
    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR: WA_TAB1.
    COUNT = COUNT + 1.
  ENDDO.


  CREATE OBJECT GR_ALVGRID
    EXPORTING
*     i_parent          = gr_ccontainer
      I_PARENT          = CL_GUI_CUSTOM_CONTAINER=>SCREEN0
    EXCEPTIONS
      ERROR_CNTL_CREATE = 1
      ERROR_CNTL_INIT   = 2
      ERROR_CNTL_LINK   = 3
      ERROR_DP_CREATE   = 4
      OTHERS            = 5.
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  PERFORM ALV_BUILD_FIELDCAT.

  CALL METHOD GR_ALVGRID->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     I_BUFFER_ACTIVE =
*     I_BYPASSING_BUFFER            =
*     I_CONSISTENCY_CHECK           =
*     I_STRUCTURE_NAME              =
      IS_VARIANT      = VARIANT
      I_SAVE          = 'A'
*     I_DEFAULT       = 'X'
      IS_LAYOUT       = GS_LAYO
*     IS_PRINT        =
*     IT_SPECIAL_GROUPS             =
*     IT_TOOLBAR_EXCLUDING          =
*     IT_HYPERLINK    =
*     IT_ALV_GRAPHICS =
*     IT_EXCEPT_QINFO =
*     IR_SALV_ADAPTER =
    CHANGING
      IT_OUTTAB       = IT_TAB1
      IT_FIELDCATALOG = IT_FCAT
*     IT_SORT         =
*     IT_FILTER       =
*      EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1
*     PROGRAM_ERROR   = 2
*     TOO_MANY_LINES  = 3
*     others          = 4
    .
  IF SY-SUBRC <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_BUILD_FIELDCAT .
*  BREAK-POINT .
  DATA LV_FLDCAT TYPE LVC_S_FCAT.

  LV_FLDCAT-FIELDNAME = 'FGNAME1'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_L = 'FG PRODUCT VENDOR'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-f4availabl = 'X'.
*  lv_fldcat-ref_table = 'MARA'.
*  lv_fldcat-ref_field = 'MATNR'.
  LV_FLDCAT-OUTPUTLEN = 25.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.


  LV_FLDCAT-FIELDNAME = 'MATNR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'MATERIAL CODE'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-F4AVAILABL = 'X'.
  LV_FLDCAT-REF_TABLE = 'MARA'.
  LV_FLDCAT-REF_FIELD = 'MATNR'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'RPLIFNR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  LV_FLDCAT-SCRTEXT_M = 'RM,PM VENDOR'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-F4AVAILABL = 'X'.
  LV_FLDCAT-REF_TABLE = 'LFA1'.
  LV_FLDCAT-REF_FIELD = 'LIFNR'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'NETPR'.
  LV_FLDCAT-SCRTEXT_M = 'RATE'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'PEINH'.
  LV_FLDCAT-SCRTEXT_M = 'RATE PER UNIT'.
  LV_FLDCAT-EDIT   = 'X'.
*  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

*  lv_fldcat-fieldname = 'FRTPER'.
*  lv_fldcat-scrtext_m = 'FREIGHT PERCENTAGE'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 10.
*  APPEND lv_fldcat TO it_fcat.
*  CLEAR lv_fldcat.
*
*  lv_fldcat-fieldname = 'FRTVAL'.
*  lv_fldcat-scrtext_m = 'FREIGHT VALUE'.
*  lv_fldcat-edit   = 'X'.
*  lv_fldcat-outputlen = 10.
*  APPEND lv_fldcat TO it_fcat.
*  CLEAR lv_fldcat.

  LV_FLDCAT-FIELDNAME = 'SGTXT'.
  LV_FLDCAT-SCRTEXT_M = 'REMARK IF ANY'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 50.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DATAUPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATAUPD .

  LOOP AT IT_TAB1 INTO WA_TAB1 WHERE NETPR NE SPACE AND MATNR NE SPACE.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB1-MATNR AND MTART IN ('ZROH','ZVRP').
    IF SY-SUBRC EQ 4.
      MESSAGE 'CHECK YOUR MATERIAL CODE' TYPE 'E'.
    ENDIF.
    IF WA_TAB1-RPLIFNR NE SPACE.
      SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_TAB1-RPLIFNR.
      IF SY-SUBRC EQ 4.
        MESSAGE 'CHECK YOUR RM PM VENDOR CODE' TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDLOOP.
  CLEAR :  COUNT1.
  SELECT * FROM ZTP_COST1 INTO TABLE IT_ZTP_COST1 WHERE BUDAT EQ SY-DATUM.
  SORT IT_ZTP_COST1 DESCENDING BY POSNR.
  READ TABLE IT_ZTP_COST1 INTO WA_ZTP_COST1 WITH KEY BUDAT = SY-DATUM.
  IF SY-SUBRC EQ 0.
    COUNT1 = WA_ZTP_COST1-POSNR.
  ENDIF.
  COUNT1 = COUNT1 + 1.

  LOOP AT IT_TAB1 INTO WA_TAB1 WHERE NETPR NE SPACE.
    CONDENSE WA_TAB1-NETPR.
    ZTP_COST1_WA-MATNR = WA_TAB1-MATNR.
    ZTP_COST1_WA-FGLIFNR = FGLIFNR.
    ZTP_COST1_WA-POSNR = COUNT1.
    ZTP_COST1_WA-BUDAT = SY-DATUM.
    ZTP_COST1_WA-RPLIFNR = WA_TAB1-RPLIFNR.
    ZTP_COST1_WA-NETPR = WA_TAB1-NETPR.
    ZTP_COST1_WA-PEINH = WA_TAB1-PEINH.
*    ztp_cost1_wa-frtper = wa_tab1-frtper.
*    ztp_cost1_wa-frtval = wa_tab1-frtval.
    ZTP_COST1_WA-SGTXT = WA_TAB1-SGTXT.
    ZTP_COST1_WA-UZEIT = SY-UZEIT.
    ZTP_COST1_WA-UNAME = SY-UNAME.
    MODIFY ZTP_COST1 FROM ZTP_COST1_WA.
    COMMIT WORK AND WAIT.
    CLEAR ZTP_COST1_WA.
    COUNT1 = COUNT1 + 1.
  ENDLOOP.
  IF SY-SUBRC EQ 0.
    MESSAGE 'SAVE DATA' TYPE 'I'.
  ENDIF.
ENDFORM.
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
*&---------------------------------------------------------------------*
*&      Form  UPDTRT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDTRT .

  C_FILE = P_FILE.
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      FILENAME                = C_FILE
      FILETYPE                = 'ASC'
      HAS_FIELD_SEPARATOR     = 'X'
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      =
*     NO_AUTH_CHECK           = ' '
*         IMPORTING
*     FILELENGTH              =
*     HEADER                  =
    TABLES
      DATA_TAB                = IT_RT1
    EXCEPTIONS
      FILE_OPEN_ERROR         = 1
      FILE_READ_ERROR         = 2
      NO_BATCH                = 3
      GUI_REFUSE_FILETRANSFER = 4
      INVALID_TYPE            = 5
      NO_AUTHORITY            = 6
      UNKNOWN_ERROR           = 7
      BAD_DATA_FORMAT         = 8
      HEADER_NOT_ALLOWED      = 9
      SEPARATOR_NOT_ALLOWED   = 10
      HEADER_TOO_LONG         = 11
      UNKNOWN_DP_ERROR        = 12
      ACCESS_DENIED           = 13
      DP_OUT_OF_MEMORY        = 14
      DISK_FULL               = 15
      DP_TIMEOUT              = 16
      OTHERS                  = 17.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  SORT IT_RT1 BY MATNR LIFNR.
  DELETE ADJACENT DUPLICATES FROM IT_RT1 COMPARING MATNR LIFNR.
  SELECT * FROM ZTP_COST1 INTO TABLE IT_ZTP_COST1 WHERE BUDAT EQ SY-DATUM.
  SORT IT_ZTP_COST1 DESCENDING BY POSNR.
  CLEAR : COUNT.
  READ TABLE IT_ZTP_COST1 INTO WA_ZTP_COST1 WITH KEY BUDAT = SY-DATUM.
  IF SY-SUBRC EQ 0.
    COUNT = WA_ZTP_COST1-POSNR.
  ENDIF.
  COUNT = COUNT + 1.
  LOOP AT IT_RT1 INTO WA_RT1.
    CONDENSE WA_RT1-NETPR.
    UNPACK WA_RT1-MATNR TO WA_RT1-MATNR.
    UNPACK WA_RT1-LIFNR TO WA_RT1-LIFNR.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_RT1-LIFNR.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_RT1-MATNR AND MTART IN ('ZROH','ZVRP').
      IF SY-SUBRC EQ 0.
        ZTP_COST1_WA-MANDT = SY-MANDT.
        ZTP_COST1_WA-MATNR = WA_RT1-MATNR.
        ZTP_COST1_WA-FGLIFNR = WA_RT1-LIFNR.
        ZTP_COST1_WA-POSNR = COUNT.
        ZTP_COST1_WA-BUDAT = SY-DATUM.
        CLEAR: RPLIFNR.
        SELECT SINGLE * FROM ZTP_COST8 WHERE MATNR EQ WA_RT1-MATNR AND FGLIFNR EQ WA_RT1-LIFNR.
        IF SY-SUBRC EQ 0.
          RPLIFNR = ZTP_COST8-RPLIFNR.
        ENDIF.
        ZTP_COST1_WA-RPLIFNR = RPLIFNR.
        ZTP_COST1_WA-NETPR = WA_RT1-NETPR.
        ZTP_COST1_WA-PEINH = WA_RT1-PEINH.
        ZTP_COST1_WA-SGTXT = SPACE.
        ZTP_COST1_WA-UZEIT = SY-UZEIT.
        ZTP_COST1_WA-UNAME = SY-UNAME.

        MODIFY ZTP_COST1 FROM ZTP_COST1_WA.
        COMMIT WORK AND WAIT .
        CLEAR ZTP_COST1_WA.
      ENDIF.
    ENDIF.
    COUNT = COUNT + 1.
  ENDLOOP.

  IF SY-SUBRC EQ 0.
    MESSAGE 'DATA UPDATED' TYPE 'I'.
  ENDIF.


ENDFORM.
