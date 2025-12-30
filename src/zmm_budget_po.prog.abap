*&---------------------------------------------------------------------*
*& Report ZMM_BUDGET_PO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_BUDGET_PO.

TABLES: EKKO, EKPO, MARA, LFA1.

TYPES: BEGIN OF TY_FINAL,
         WERKS        TYPE WERKS_D,
         MATNR        TYPE MATNR,
         MAKTX        TYPE MAKTX,
         LIFNR        TYPE LIFNR,
         NAME1        TYPE NAME1_GP,
         EBELN        TYPE EBELN,
         EBELP        TYPE EBELP,
         BUD_MON      TYPE NUMC2,
         BUD_YEAR     TYPE NUMC4,
         BUD_PRICE    TYPE ZBUDGET_PRICE-BUD_PRICE,
         NETPR        TYPE P DECIMALS 2,
         MENGE        TYPE MENGE_D,
         MEINS        TYPE MEINS,
         PO_VALUE     TYPE P DECIMALS 2,
         BUD_VALUE    TYPE P DECIMALS 2,
         UNIT_VAR     TYPE P DECIMALS 2,
         UNIT_VAR_PER TYPE P DECIMALS 2,
         VALUE_VAR    TYPE P DECIMALS 2,
         CURRENCY     TYPE WAERS,
         STATUS_TEXT  TYPE CHAR20,
       END OF TY_FINAL.
DATA: GT_FINAL TYPE STANDARD TABLE OF TY_FINAL,
      GS_FINAL TYPE TY_FINAL.

DATA: IT_FIELDCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT TYPE SLIS_FIELDCAT_ALV.
DATA : WA_LAYOUT TYPE SLIS_LAYOUT_ALV .
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-004.
  PARAMETERS: P_MON  TYPE NUMC2 OBLIGATORY,
              P_YEAR TYPE NUMC4 OBLIGATORY.

  SELECT-OPTIONS:
   S_WERKS FOR EKPO-WERKS OBLIGATORY NO INTERVALS,
   S_MATNR FOR EKPO-MATNR OBLIGATORY NO INTERVALS,
   S_LIFNR FOR EKKO-LIFNR NO INTERVALS,
   S_EBELN FOR EKPO-EBELN NO INTERVALS.
SELECTION-SCREEN END OF BLOCK B1.

START-OF-SELECTION.

  PERFORM GET_DATA.
  PERFORM FIELDCAT1.
  PERFORM DISPLAY.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_DATA .
  DATA: LT_BUDGET    TYPE TABLE OF ZBUDGET_PRICE,
        LS_BUDGET    TYPE ZBUDGET_PRICE,
        LT_EKKO      TYPE TABLE OF EKKO,
        LS_EKKO      TYPE EKKO,
        LT_EKPO      TYPE TABLE OF EKPO,
        LS_EKPO      TYPE EKPO,
        LT_MARA      TYPE TABLE OF MARA,
        LS_MARA      TYPE MARA,
        LT_LFA1      TYPE TABLE OF LFA1,
        LS_LFA1      TYPE  LFA1,
        LV_DATE_LOW  TYPE D,
        LV_DATE_HIGH TYPE D.


  CONCATENATE P_YEAR P_MON '01' INTO LV_DATE_LOW.
  LV_DATE_HIGH = LV_DATE_LOW + 31.
  LV_DATE_HIGH = LV_DATE_HIGH - 1.


  SELECT * FROM ZBUDGET_PRICE
    INTO TABLE LT_BUDGET
    WHERE WERKS IN S_WERKS
      AND MATNR IN S_MATNR
      AND BUD_MON = P_MON
  AND BUD_YEAR = P_YEAR.

  SELECT * FROM EKKO
 INTO TABLE LT_EKKO
 WHERE LIFNR IN S_LIFNR
   AND EBELN IN S_EBELN
  AND AEDAT BETWEEN LV_DATE_LOW AND LV_DATE_HIGH.
*  IF LT_EKKO IS INITIAL.
*    EXIT.
*  ENDIF.
  IF LT_EKKO IS NOT INITIAL.
    SELECT * FROM EKPO
     INTO TABLE LT_EKPO
     FOR ALL ENTRIES IN LT_EKKO
     WHERE EBELN = LT_EKKO-EBELN
       AND WERKS IN S_WERKS
    AND MATNR IN S_MATNR.
  ENDIF.
*  IF LT_EKPO IS INITIAL.
*    EXIT.
*  ENDIF.


  SELECT * FROM MARA
  INTO TABLE LT_MARA
  FOR ALL ENTRIES IN LT_EKPO
  WHERE MATNR = LT_EKPO-MATNR.

  SELECT * FROM LFA1
     INTO TABLE LT_LFA1
     FOR ALL ENTRIES IN LT_EKKO
  WHERE LIFNR = LT_EKKO-LIFNR.

  LOOP AT LT_EKPO INTO LS_EKPO.

    READ TABLE LT_EKKO INTO LS_EKKO WITH KEY EBELN = LS_EKPO-EBELN.
    IF SY-SUBRC <> 0.
      CONTINUE.
    ENDIF.
    CLEAR GS_FINAL.
    GS_FINAL-WERKS = LS_EKPO-WERKS.
    GS_FINAL-MATNR = LS_EKPO-MATNR.
    GS_FINAL-EBELN = LS_EKPO-EBELN.
    GS_FINAL-EBELP = LS_EKPO-EBELP.
    GS_FINAL-LIFNR = LS_EKKO-LIFNR.
    GS_FINAL-NETPR = LS_EKPO-NETPR.
    GS_FINAL-MENGE = LS_EKPO-MENGE.
    GS_FINAL-CURRENCY = LS_EKKO-WAERS.
    " Material Description
    READ TABLE LT_MARA INTO LS_MARA WITH KEY MATNR = LS_EKPO-MATNR.
*    IF SY-SUBRC = 0.
*      GS_FINAL-MAKTX = LS_MARA-MAKTX.
*    ENDIF.
    " Vendor Name
    READ TABLE LT_LFA1 INTO LS_LFA1 WITH KEY LIFNR = LS_EKKO-LIFNR.
    IF SY-SUBRC = 0.
      GS_FINAL-NAME1 = LS_LFA1-NAME1.
    ENDIF.
    " Budget lookup
    READ TABLE LT_BUDGET INTO LS_BUDGET
      WITH KEY WERKS = LS_EKPO-WERKS
               MATNR = LS_EKPO-MATNR
               BUD_MON = P_MON
               BUD_YEAR = P_YEAR.
    IF SY-SUBRC = 0.
      " Found budget record
      GS_FINAL-BUD_PRICE = LS_BUDGET-BUD_PRICE.
      GS_FINAL-MEINS     = LS_BUDGET-MEINS.
      GS_FINAL-BUD_MON   = LS_BUDGET-BUD_MON.
      GS_FINAL-BUD_YEAR  = LS_BUDGET-BUD_YEAR.
      " Perform calculations
      GS_FINAL-PO_VALUE  = LS_EKPO-MENGE * LS_EKPO-NETPR.
      GS_FINAL-BUD_VALUE = LS_EKPO-MENGE * LS_BUDGET-BUD_PRICE.
      GS_FINAL-UNIT_VAR  = LS_EKPO-NETPR - LS_BUDGET-BUD_PRICE.
      IF LS_BUDGET-BUD_PRICE NE 0.
        GS_FINAL-UNIT_VAR_PER = ( GS_FINAL-UNIT_VAR / LS_BUDGET-BUD_PRICE ) * 100.
      ENDIF.
      GS_FINAL-VALUE_VAR = GS_FINAL-PO_VALUE - GS_FINAL-BUD_VALUE.
      GS_FINAL-STATUS_TEXT = 'OK'.
    ELSE.
      GS_FINAL-STATUS_TEXT = 'Budget Missing'.
    ENDIF.
    APPEND GS_FINAL TO GT_FINAL.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form fieldcat1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM FIELDCAT1 .


  WA_FIELDCAT-FIELDNAME  = 'WERKS'.
  WA_FIELDCAT-SELTEXT_M  = 'Plant'."'PLANT.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'MATNR'.
  WA_FIELDCAT-SELTEXT_M  = 'Material Code'."'Material Code.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.


  WA_FIELDCAT-FIELDNAME  = 'MATNR'.
  WA_FIELDCAT-SELTEXT_M  = 'Material Desc'."'Material desc.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'LIFNR'.
  WA_FIELDCAT-SELTEXT_M  = 'Vendor Code'."'Vendor Code.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = 'NAME1'.
  WA_FIELDCAT-SELTEXT_M  = 'Vendor Name'."'Vendor name.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = ''.
  WA_FIELDCAT-SELTEXT_M  = 'PO Number'."'Vendor number.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = ''.
  WA_FIELDCAT-SELTEXT_M  = 'PO date'."'PO date.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = ''.
  WA_FIELDCAT-SELTEXT_M  = 'PO Quantity'."'PO quantity.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = ''.
  WA_FIELDCAT-SELTEXT_M  = 'Actual PO Price'."'Actual Po price.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = ''.
  WA_FIELDCAT-SELTEXT_M  = 'Budget Price'."'Budget price.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = ''.
  WA_FIELDCAT-SELTEXT_M  = 'Unit Variance(Actual – Budget)'."'Budget price.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = ''.
  WA_FIELDCAT-SELTEXT_M  = 'Unit Variance %'."'Budget price.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = ''.
  WA_FIELDCAT-SELTEXT_M  = 'PO Value (Qty × Actual Price)'."'Budget price.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = ''.
  WA_FIELDCAT-SELTEXT_M  = 'Budgeted Value (Qty × Budget Price)'."'Budget price.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.

  WA_FIELDCAT-FIELDNAME  = ''.
  WA_FIELDCAT-SELTEXT_M  = 'Value Variance (Actual – Budgeted Value)'."'Budget price.'.
  WA_FIELDCAT-TABNAME    = 'GS_FINAL'.
  APPEND WA_FIELDCAT TO IT_FIELDCAT.
  CLEAR WA_FIELDCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      "  I_INTERFACE_CHECK                 = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
     I_CALLBACK_USER_COMMAND           = 'UCOMM '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
      IS_LAYOUT          = WA_LAYOUT
      IT_FIELDCAT        = IT_FIELDCAT
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER           =
*     O_COMMON_HUB       =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB           = GT_FINAL
* EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
