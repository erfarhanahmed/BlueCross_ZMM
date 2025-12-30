*&---------------------------------------------------------------------*
*& Report  ZBCLL_COSTING_REJECT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZBCLL_COSTING_REJECT.

CLASS LCL_EVENT_HANDLER DEFINITION .
  PUBLIC SECTION .
    METHODS:

*--Double-click control
      HANDLE_DOUBLE_CLICK
                  FOR EVENT DOUBLE_CLICK OF CL_GUI_ALV_GRID
        IMPORTING E_ROW E_COLUMN ES_ROW_NO.

  PRIVATE SECTION.
ENDCLASS.                    "lcl_event_handler DEFINITION

CLASS LCL_EVENT_HANDLER IMPLEMENTATION .


*--Handle Double Click
  METHOD HANDLE_DOUBLE_CLICK .
    PERFORM HANDLE_DOUBLE_CLICK USING E_ROW E_COLUMN ES_ROW_NO .
  ENDMETHOD .                    "handle_double_click

ENDCLASS .                    "lcl_event_handler IMPLEMENTATION

TABLES : MAKT,
         LFA1,
         ZTP_COST11,
         ZTP_COST14,
         ZTP_COST15.

DATA : IT_ZTP_COST11 TYPE TABLE OF ZTP_COST11,
       WA_ZTP_COST11 TYPE ZTP_COST11.
TYPES : BEGIN OF ITAB1,
          GJAHR   TYPE ZTP_COST11-GJAHR,
          VBELN   TYPE ZTP_COST11-VBELN,
          WERKS   TYPE ZTP_COST11-WERKS,
          MATNR   TYPE ZTP_COST11-MATNR,
          MAKTX   TYPE MAKT-MAKTX,
          FGLIFNR TYPE ZTP_COST11-FGLIFNR,
          NAME1   TYPE LFA1-NAME1,
          STLAL   TYPE ZTP_COST11-STLAL,
          REJ(1)  TYPE C,
          REJTXT  TYPE STRING,
        END OF ITAB1.
DATA: IT_TAB1 TYPE TABLE OF ITAB1,
      WA_TAB1 TYPE ITAB1.
DATA: C_CCONT   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,         "Custom container object
      C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID,         "ALV grid object
      IT_FCAT   TYPE LVC_T_FCAT,                  "Field catalogue
      IT_LAYOUT TYPE LVC_S_LAYO.                  "Layout
DATA: LS_VARIANT-REPORT  TYPE DISVARIANT.
DATA GR_EVENT_HANDLER TYPE REF TO LCL_EVENT_HANDLER .

DATA:
  OK_CODE       TYPE UI_FUNC.
DATA: ZTP_COST15_WA TYPE ZTP_COST15.
DATA: GSTRING TYPE C.

*SELECTION-SCREEN BEGIN OF BLOCK MERKMALE2 WITH FRAME TITLE TEXT-001.
*PARAMETERS : PERNR    LIKE PA0001-PERNR MATCHCODE OBJECT PREM OBLIGATORY,
*             PASS(10) TYPE C OBLIGATORY.
*SELECTION-SCREEN END OF BLOCK MERKMALE2.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE3 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : VBELN FOR ZTP_COST11-VBELN MATCHCODE OBJECT ZTP_COST1 OBLIGATORY.
PARAMETERS :   GJAHR(4) TYPE C OBLIGATORY.
SELECTION-SCREEN END OF BLOCK MERKMALE3.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK screen-name EQ 'PASS'.
    screen-invisible = 1.
    MODIFY SCREEN.
  ENDLOOP.

START-OF-SELECTION.


  CREATE OBJECT GR_EVENT_HANDLER .

  CLEAR : IT_ZTP_COST11,WA_ZTP_COST11.

  SELECT * FROM ZTP_COST11 INTO TABLE IT_ZTP_COST11 WHERE VBELN IN VBELN AND GJAHR EQ GJAHR.
  IF SY-SUBRC EQ 4.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.
  SELECT SINGLE * FROM ZTP_COST15 WHERE VBELN IN VBELN AND GJAHR EQ GJAHR.
  IF SY-SUBRC EQ 0.
    MESSAGE 'THIS COST SHEET IS ALREADY REJECTED' TYPE 'E'.
  ENDIF.


  LOOP AT IT_ZTP_COST11 INTO WA_ZTP_COST11.
    WA_TAB1-GJAHR = WA_ZTP_COST11-GJAHR.
    WA_TAB1-VBELN = WA_ZTP_COST11-VBELN.
    WA_TAB1-WERKS = WA_ZTP_COST11-WERKS.
    WA_TAB1-MATNR = WA_ZTP_COST11-MATNR.
    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZTP_COST11-MATNR AND SPRAS EQ 'EN'.
    IF SY-SUBRC EQ 0.
      WA_TAB1-MAKTX = MAKT-MAKTX.
    ENDIF.
    WA_TAB1-FGLIFNR = WA_ZTP_COST11-FGLIFNR.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZTP_COST11-FGLIFNR.
    IF SY-SUBRC EQ 0.
      WA_TAB1-NAME1 = LFA1-NAME1.
    ENDIF.
    WA_TAB1-STLAL = WA_ZTP_COST11-STLAL.
    WA_TAB1-REJ = SPACE.
    WA_TAB1-REJTXT = SPACE.
    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
  ENDLOOP.

  CALL SCREEN 0100.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'TITLE1'.
  PERFORM PBO.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  PBO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PBO .
*  *Creating objects of the container
  CREATE OBJECT C_CCONT
    EXPORTING
      CONTAINER_NAME = 'CCONT'.
*  create object for alv grid


  CREATE OBJECT C_ALVGD
    EXPORTING
      I_PARENT = CL_GUI_CUSTOM_CONTAINER=>SCREEN0.

*  CREATE OBJECT c_alvgd
*    EXPORTING
*      i_parent = c_ccont.



*  SET field for ALV

  DATA LV_FLDCAT TYPE LVC_S_FCAT.
*  IF R2 EQ 'X' OR R21 EQ 'X'.
  PERFORM ALV_BUILD_FIELDCAT1.

* Set ALV attributes FOR LAYOUT
  PERFORM ALV_REPORT_LAYOUT.
  CHECK NOT C_ALVGD IS INITIAL.


  CHECK NOT C_ALVGD IS INITIAL.
  CALL METHOD C_ALVGD->SET_TABLE_FOR_FIRST_DISPLAY
    EXPORTING
*     IS_LAYOUT                     = IT_LAYOUT
*     I_SAVE                        = 'A'
*     is_callback_user_command      = 'USER_COMM'
      IS_LAYOUT                     = IT_LAYOUT
      IS_VARIANT                    = LS_VARIANT-REPORT
      I_SAVE                        = 'A'
    CHANGING
      IT_OUTTAB                     = IT_TAB1
      IT_FIELDCATALOG               = IT_FCAT
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1
      PROGRAM_ERROR                 = 2
      TOO_MANY_LINES                = 3
      OTHERS                        = 4.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  SET HANDLER GR_EVENT_HANDLER->HANDLE_DOUBLE_CLICK FOR C_ALVGD .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_BUILD_FIELDCAT1 .
  DATA LV_FLDCAT TYPE LVC_S_FCAT.

  LV_FLDCAT-FIELDNAME = 'VBELN'.
  LV_FLDCAT-SCRTEXT_L = 'COSTSHEET NO.'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'GJAHR'.
  LV_FLDCAT-SCRTEXT_L = 'F.YEARR'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MATNR'.
  LV_FLDCAT-SCRTEXT_L = 'PRODUCT CODE'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MAKTX'.
  LV_FLDCAT-SCRTEXT_L = 'PRODUCT NAME'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'WERKS'.
  LV_FLDCAT-SCRTEXT_L = 'PLANT'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'STLAL'.
  LV_FLDCAT-SCRTEXT_L = 'BOM NO.'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'FGLIFNR'.
  LV_FLDCAT-SCRTEXT_L = 'MFG CODE'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'NAME1'.
  LV_FLDCAT-SCRTEXT_L = 'MANUFACTURER NAME'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'REJ'.
  LV_FLDCAT-SCRTEXT_L = 'REJECT'.
  LV_FLDCAT-CHECKBOX = 'X'.
  LV_FLDCAT-EDIT = 'X'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'REJTXT'.
  LV_FLDCAT-SCRTEXT_L = 'REJECTION  REASON'.
  LV_FLDCAT-EDIT = 'X'.
  LV_FLDCAT-OUTPUTLEN = 100.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_REPORT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_REPORT_LAYOUT .
  IT_LAYOUT-ZEBRA = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_ROW  text
*      -->P_E_COLUMN  text
*      -->P_ES_ROW_NO  text
*----------------------------------------------------------------------*
FORM HANDLE_DOUBLE_CLICK USING I_ROW TYPE LVC_S_ROW
                               I_COLUMN TYPE LVC_S_COL
                               IS_ROW_NO TYPE LVC_S_ROID.

  READ TABLE IT_TAB1  INTO WA_TAB1 INDEX IS_ROW_NO-ROW_ID .

  IF SY-SUBRC = 0 .
    IF I_COLUMN = 'MATNR'.
*      t_mat = wa_RPM7-MBLNR.
*      PERFORM update.
*      SET PARAMETER ID 'MBN' FIELD t_mat.
      SET PARAMETER ID 'MAT' FIELD WA_TAB1-MATNR.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
      SET PARAMETER ID 'MAT' FIELD SPACE.

*    ELSEIF I_COLUMN = 'EBELN'.
*      SET PARAMETER ID 'BES' FIELD WA_RPM7-EBELN.
*      CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
*      SET PARAMETER ID 'BES' FIELD SPACE.
*
*    ELSEIF I_COLUMN = 'LIFNR'.
*      SET PARAMETER ID 'LIF' FIELD WA_RPM7-LIFNR.
*      CALL TRANSACTION 'XK03' AND SKIP FIRST SCREEN.
*      SET PARAMETER ID 'LIF' FIELD SPACE.
*    ELSEIF I_COLUMN = 'BELNR'.
*      SET PARAMETER ID 'BLN' FIELD WA_RPM7-BELNR.
*      SET PARAMETER ID 'GJR' FIELD WA_RPM7-GJAHR.
*      CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
*      SET PARAMETER ID 'BLN' FIELD SPACE.
*      SET PARAMETER ID 'GJR' FIELD SPACE.
*    ELSEIF I_COLUMN = 'MATNR'.
*      SET PARAMETER ID 'MAT' FIELD WA_RPM7-MATNR.
*      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
*      SET PARAMETER ID 'MAT' FIELD SPACE.
*
*      CALL TRANSACTION 'MIGO'.
    ENDIF .
  ENDIF.
ENDFORM .                    "handle_double_click
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  C_ALVGD->CHECK_CHANGED_DATA( ).

  CASE OK_CODE.
    WHEN 'SAVE'.
*A pop up is called to confirm the saving of changed data
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          TITLEBAR       = 'SAVING DATA'
          TEXT_QUESTION  = 'Continue?'
          ICON_BUTTON_1  = 'icon_booking_ok'
        IMPORTING
          ANSWER         = GSTRING
        EXCEPTIONS
          TEXT_NOT_FOUND = 1
          OTHERS         = 2.
      IF SY-SUBRC NE 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
*When the User clicks 'YES'
      IF ( GSTRING = '1' ).
*          MESSAGE 'Saved' TYPE 'S'.
*Now the changed data is stored in the it_pbo internal table
*        MODIFY zgk_emp FROM TABLE it_emp.
*Subroutine to display the ALV with changed data.
*          IF R1A EQ 'X'.
*            PERFORM REDISPLAY.
*            CLEAR: OK_CODE.
*            LEAVE TO TRANSACTION 'ZPUR_REQ'.
*          ELSEIF R1 EQ 'X'.

        PERFORM REJECTSAVE.

        CLEAR: OK_CODE.
*        leave to transaction 'ZCOST'.
        LEAVE TO SCREEN 0.

      ELSE.
*When user clicks NO or Cancel
        MESSAGE 'Not Saved'  TYPE 'S'.
      ENDIF.
**When the user clicks the 'EXIT; he is out
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE TO SCREEN 0.
*        LEAVE PROGRAM.
  ENDCASE.
  CLEAR: OK_CODE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  REJECTSAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM REJECTSAVE .
  LOOP AT IT_TAB1 INTO WA_TAB1.
    IF WA_TAB1-REJ EQ SPACE .
      MESSAGE 'Select CHECKBOX to REJECT' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM ZTP_COST14 WHERE VBELN EQ WA_TAB1-VBELN AND GJAHR = WA_TAB1-GJAHR AND FINALAPR NE SPACE.
    IF SY-SUBRC EQ 0.
      MESSAGE 'Final Approval is alreday done' TYPE 'I'.
    ENDIF.
    SELECT SINGLE * FROM ZTP_COST14 WHERE VBELN EQ WA_TAB1-VBELN AND GJAHR = WA_TAB1-GJAHR AND FINALAPR NE SPACE.
    IF SY-SUBRC EQ 0.
      MESSAGE 'Final Approval is alreday done' TYPE 'I'.
    ENDIF.
  ENDLOOP.


  LOOP AT IT_TAB1 INTO WA_TAB1.
    SELECT SINGLE * FROM ZTP_COST11 WHERE VBELN EQ WA_TAB1-VBELN AND GJAHR = WA_TAB1-GJAHR.
    IF SY-SUBRC EQ 0.
      ZTP_COST15_WA-GJAHR = WA_TAB1-GJAHR.
      ZTP_COST15_WA-VBELN = WA_TAB1-VBELN.
*      ZTP_COST15_WA-PERNR = PERNR.
      ZTP_COST15_WA-REJDT = SY-DATUM.
      ZTP_COST15_WA-REJTM = SY-UZEIT.
      ZTP_COST15_WA-REJTXT = WA_TAB1-REJTXT.
      MODIFY  ZTP_COST15 FROM  ZTP_COST15_WA.
      COMMIT WORK AND WAIT .
      CLEAR  ZTP_COST15_WA.
    ENDIF.
  ENDLOOP.
*  IF IT_TAB1 IS NOT INITIAL.
*    PERFORM EMAIL.
*  ENDIF.
  IF SY-SUBRC EQ 0.
    MESSAGE 'DATA SAVED' TYPE 'I'.
  ENDIF.
ENDFORM.
