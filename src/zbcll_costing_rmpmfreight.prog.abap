*&---------------------------------------------------------------------*
*& Report  ZBCLL_COSTING_RMPMGST
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZBCLL_COSTING_RMPMFREIGHT_A1.
TABLES : ZTP_COST3,
         MARA,
         MAKT,
         LFA1.

TYPE-POOLS:  SLIS.

DATA: G_REPID     LIKE SY-REPID,
      FIELDCAT    TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT LIKE LINE OF FIELDCAT,
      SORT        TYPE SLIS_T_SORTINFO_ALV,
      WA_SORT     LIKE LINE OF SORT,
      LAYOUT      TYPE SLIS_LAYOUT_ALV.

DATA: IT_ZTP_COST3 TYPE TABLE OF ZTP_COST3,
      WA_ZTP_COST3 TYPE ZTP_COST3.
TYPES : BEGIN OF ITAB1,
          MATNR    TYPE MARA-MATNR,
          LIFNR    TYPE LFA1-LIFNR,
          NAME1    TYPE LFA1-NAME1,
          MAKTX    TYPE MAKT-MAKTX,
          BUDAT    TYPE SY-DATUM,
*          PERCNT(10) TYPE C,
          VAL(10)  TYPE C,
          SGTXT    TYPE ZTP_COST3-SGTXT,
          UNAME    TYPE SY-UNAME,
          CPUDT    TYPE SY-DATUM,
          UZEIT    TYPE SY-UZEIT,
          COUNT(2) TYPE C,
        END OF ITAB1.
DATA: IT_TAB1 TYPE TABLE OF ITAB1,
      WA_TAB1 TYPE ITAB1.
DATA:       A2 TYPE I.
DATA: COUNT TYPE I.
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
DATA: ZTP_COST3_WA TYPE ZTP_COST3.
***************************************************************************************

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE3 WITH FRAME TITLE TEXT-003.
PARAMETERS :  VENDOR LIKE LFA1-LIFNR .
SELECTION-SCREEN END OF BLOCK MERKMALE3.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-003.
PARAMETERS : R1 RADIOBUTTON GROUP R1,
             R2 RADIOBUTTON GROUP R1.
SELECTION-SCREEN END OF BLOCK MERKMALE1.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE2 WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS : MATERIAL FOR MARA-MATNR.
SELECTION-SCREEN END OF BLOCK MERKMALE2 .

INITIALIZATION.
  G_REPID = SY-REPID.

AT SELECTION-SCREEN.
  PERFORM AUTHORIZATION.

START-OF-SELECTION.

  IF R1 EQ 'X'.
    PERFORM DISPLAY.
  ELSEIF R2 EQ 'X'.
    IF VENDOR IS INITIAL.
      MESSAGE 'ENTER FG VENFOR CODE' TYPE 'E'.
    ENDIF.
    PERFORM UPDDADAT.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY .
  SELECT * FROM ZTP_COST3 INTO TABLE IT_ZTP_COST3 WHERE MATNR IN MATERIAL.
  IF SY-SUBRC NE 0.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.
  LOOP AT IT_ZTP_COST3 INTO WA_ZTP_COST3.
    WA_TAB1-MATNR = WA_ZTP_COST3-MATNR.
    WA_TAB1-LIFNR = WA_ZTP_COST3-FGLIFNR.
    WA_TAB1-VAL = WA_ZTP_COST3-FRTVAL.

    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZTP_COST3-FGLIFNR.
    IF SY-SUBRC EQ 0.
      WA_TAB1-NAME1 = LFA1-NAME1.
    ENDIF.
    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZTP_COST3-MATNR AND SPRAS EQ 'EN'.
    IF SY-SUBRC EQ 0.
      WA_TAB1-MAKTX = MAKT-MAKTX.
    ENDIF.
    WA_TAB1-SGTXT = WA_ZTP_COST3-SGTXT.
    WA_TAB1-CPUDT = WA_ZTP_COST3-CPUDT.
    WA_TAB1-UZEIT = WA_ZTP_COST3-UZEIT.
    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
  ENDLOOP.

  LOOP AT IT_TAB1 INTO WA_TAB1.
    PACK WA_TAB1-MATNR TO WA_TAB1-MATNR.
    PACK WA_TAB1-LIFNR TO WA_TAB1-LIFNR.
    CONDENSE : WA_TAB1-MATNR, WA_TAB1-LIFNR.
    MODIFY IT_TAB1 FROM WA_TAB1 TRANSPORTING MATNR LIFNR.
  ENDLOOP.

  WA_FIELDCAT-FIELDNAME = 'MATNR'.
  WA_FIELDCAT-SELTEXT_L = 'MATERIAL CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MAKTX'.
  WA_FIELDCAT-SELTEXT_L = 'MATERIAL NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'LIFNR'.
  WA_FIELDCAT-SELTEXT_L = 'VENDOR CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NAME1'.
  WA_FIELDCAT-SELTEXT_L = 'VENDOR NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'VAL'.
  WA_FIELDCAT-SELTEXT_L = 'FREIGHT VALUE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'SGTXT'.
  WA_FIELDCAT-SELTEXT_L = 'REMARK'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'UNAME'.
  WA_FIELDCAT-SELTEXT_L = 'ENTERED BY'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'CPUDT'.
  WA_FIELDCAT-SELTEXT_L = 'ENTERED ON DT'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'UZEIT'.
  WA_FIELDCAT-SELTEXT_L = 'ENTERED ON TIME'.
  APPEND WA_FIELDCAT TO FIELDCAT.


  LAYOUT-ZEBRA = 'X'.
  LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  LAYOUT-WINDOW_TITLEBAR  = 'MATERIAL & VENDOR WISE FREIGHT RATES FOR THIRD PARTY COSTING'.


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
  WA_COMMENT-INFO = 'MATERIAL FREIGHT RATE DETAILS'.
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


*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDDADAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDDADAT .
  CALL SCREEN 9001.


ENDFORM.


*ENDFORM.
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
*&      Form  DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATA1 .

  COUNT = 1.
  DO 20 TIMES.
    WA_TAB1-MATNR = SPACE.
*    WA_TAB1-LIFNR = SPACE.
    WA_TAB1-BUDAT = SPACE.
    WA_TAB1-VAL = SPACE.
    WA_TAB1-SGTXT = SPACE.
    WA_TAB1-COUNT = COUNT.
    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
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

  DATA LV_FLDCAT TYPE LVC_S_FCAT.

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

*  LV_FLDCAT-FIELDNAME = 'LIFNR'.
**  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
*  LV_FLDCAT-SCRTEXT_M = 'VENDOR CODE'.
*  LV_FLDCAT-EDIT   = 'X'.
*  LV_FLDCAT-F4AVAILABL = 'X'.
*  LV_FLDCAT-REF_TABLE = 'LFA1'.
*  LV_FLDCAT-REF_FIELD = 'LIFNR'.
*  LV_FLDCAT-OUTPUTLEN = 10.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.






  LV_FLDCAT-FIELDNAME = 'VAL'.
  LV_FLDCAT-SCRTEXT_M = 'FREIGHT VALUE'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 10.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.


  LV_FLDCAT-FIELDNAME = 'SGTXT'.
  LV_FLDCAT-SCRTEXT_M = 'REMARK IF ANY'.
  LV_FLDCAT-EDIT   = 'X'.
  LV_FLDCAT-OUTPUTLEN = 50.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.



ENDFORM.
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
*&      Form  DATAUPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DATAUPD .

  SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ VENDOR.
  IF SY-SUBRC EQ 4.
    MESSAGE 'ENTER VALID VENDOR CODE' TYPE 'E'.
  ENDIF.


  LOOP AT IT_TAB1 INTO WA_TAB1 WHERE VAL NE SPACE.
    IF WA_TAB1-MATNR IS INITIAL.
      MESSAGE 'ENTER MATERIAL CODE' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB1-MATNR AND MTART IN ('ZROH','ZVRP').
    IF SY-SUBRC EQ 4.
      MESSAGE 'ENTER VALID MATERIAL CODE' TYPE 'E'.
    ENDIF.
  ENDLOOP.
  CLEAR :  A2.
  LOOP AT IT_TAB1 INTO WA_TAB1 WHERE VAL NE SPACE.
    CONDENSE WA_TAB1-VAL.
    ZTP_COST3_WA-MATNR = WA_TAB1-MATNR.
    ZTP_COST3_WA-FGLIFNR = VENDOR.
    ZTP_COST3_WA-FRTVAL = WA_TAB1-VAL.
    ZTP_COST3_WA-SGTXT = WA_TAB1-SGTXT.
    ZTP_COST3_WA-UNAME = SY-UNAME.
    ZTP_COST3_WA-CPUDT = SY-DATUM.
    ZTP_COST3_WA-UZEIT = SY-UZEIT.
    MODIFY ZTP_COST3 FROM ZTP_COST3_WA.
    CLEAR ZTP_COST3_WA.
    A2 = 1.
  ENDLOOP.
  IF A2 EQ 1.
    MESSAGE 'SAVE DATA' TYPE 'I'.
  ENDIF.
ENDFORM.
