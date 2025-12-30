*&---------------------------------------------------------------------*
*& Report  ZPRODUCTION_INSPECTION_YILED1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZPRODUCTION_INSPECTION_YILED2.
TABLES : AFPO,
         MAKT,
         PA0001,
         ZPROD_INSP_YLD,
         MCHA,
         ZPASSW,
         ZCSM_QTY_BATCH.

DATA: C_CCONT   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID,
      IT_LAYOUT TYPE LVC_S_LAYO,
      IT_FCAT   TYPE LVC_T_FCAT.
DATA: LV_FLDCAT TYPE LVC_S_FCAT.
DATA: OK_CODE TYPE UI_FUNC.


TYPES : BEGIN OF INSP1,
          MATNR      TYPE AFPO-MATNR,
          CHARG      TYPE AFPO-CHARG,
          MAKTX      TYPE MAKT-MAKTX,
          PSMNG      TYPE AFPO-PSMNG,
          WEMNG      TYPE AFPO-WEMNG,
          MEINS      TYPE AFPO-MEINS,
          MENGE(100) TYPE C,
          MEINS1     TYPE AFPO-MEINS,
          TXT1(100)  TYPE C,
          HSDAT      TYPE MCHA-HSDAT,
          VFDAT      TYPE MCHA-VFDAT,
        END OF INSP1.

TYPES : BEGIN OF INSP2,
          WERKS       TYPE MCHA-WERKS,
          MATNR       TYPE AFPO-MATNR,
          CHARG       TYPE AFPO-CHARG,
          MAKTX       TYPE MAKT-MAKTX,
          PSMNG       TYPE AFPO-PSMNG,
          WEMNG       TYPE AFPO-WEMNG,
          MEINS       TYPE AFPO-MEINS,
          QTY(100)    TYPE C,
          MEINS1      TYPE AFPO-MEINS,
          TXT1(100)   TYPE C,
          ENAME       TYPE PA0001-ENAME,
          NEWQTY(100) TYPE C,
          HSDAT       TYPE MCHA-HSDAT,
          VFDAT       TYPE MCHA-VFDAT,
        END OF INSP2.

TYPES : BEGIN OF DISP1,
          WERKS     TYPE MCHA-WERKS,
          MATNR     TYPE AFPO-MATNR,
          CHARG     TYPE AFPO-CHARG,
          MAKTX     TYPE MAKT-MAKTX,
          PSMNG     TYPE AFPO-PSMNG,
          WEMNG     TYPE AFPO-WEMNG,
          MEINS     TYPE AFPO-MEINS,
          QTY(100)  TYPE C,
          MEINS1    TYPE AFPO-MEINS,
          TXT1(100) TYPE C,
          ENAME     TYPE PA0001-ENAME,
          HSDAT     TYPE MCHA-HSDAT,
          VFDAT     TYPE MCHA-VFDAT,
          CPUDT     TYPE SY-DATUM,
          CPUTM     TYPE SY-UZEIT,
        END OF DISP1.

DATA: IT_AFPO TYPE TABLE OF AFPO,
      WA_AFPO TYPE AFPO.
DATA: IT_INSP1          TYPE TABLE OF INSP1,
      WA_INSP1          TYPE INSP1,
      IT_INSP2          TYPE TABLE OF INSP2,
      WA_INSP2          TYPE INSP2,
      IT_DISP1          TYPE TABLE OF DISP1,
      WA_DISP1          TYPE DISP1,
      IT_ZPROD_INSP_YLD TYPE TABLE OF ZPROD_INSP_YLD,
      WA_ZPROD_INSP_YLD TYPE ZPROD_INSP_YLD.

DATA: O_ENCRYPTOR        TYPE REF TO CL_HARD_WIRED_ENCRYPTOR,
      O_CX_ENCRYPT_ERROR TYPE REF TO CX_ENCRYPT_ERROR.
DATA:
*      v_ac_xstring type xstring,
  V_EN_STRING TYPE STRING,
*      v_en_xstring type xstring,
  V_DE_STRING TYPE STRING,
*      v_de_xstring type string,
  V_ERROR_MSG TYPE STRING.

DATA: ZPROD_INSP_YLD_WA TYPE ZPROD_INSP_YLD.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-002.
PARAMETERS : PERNR    TYPE PA0001-PERNR,
             PASS(10) TYPE C.
*PARAMETERS : phynr LIKE qprs-phynr.
SELECTION-SCREEN END OF BLOCK MERKMALE1.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE3 WITH FRAME TITLE TEXT-002.
PARAMETERS : R1 RADIOBUTTON GROUP R1 USER-COMMAND R2 DEFAULT 'X',
             R2 RADIOBUTTON GROUP R1,
             R3 RADIOBUTTON GROUP R1.
SELECTION-SCREEN END OF BLOCK MERKMALE3.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE2 WITH FRAME TITLE TEXT-002.
SELECT-OPTIONS: CHARG FOR MCHA-CHARG.
PARAMETERS : BATCH LIKE MCHA-CHARG,
             PLANT LIKE MCHA-WERKS.

SELECTION-SCREEN END OF BLOCK MERKMALE2 .

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    CHECK SCREEN-NAME EQ 'PASS'.
    SCREEN-INVISIBLE = 1.
    MODIFY SCREEN.
  ENDLOOP.
  LOOP AT SCREEN.
    IF SCREEN-NAME CP '*PLANT*'.
      SCREEN-ACTIVE = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.



  IF R3 NE 'X'.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*BATCH*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*CHARG*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.
    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*BATCH*'.
        SCREEN-ACTIVE = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

    LOOP AT SCREEN.
      IF SCREEN-NAME CP '*CHARG*'.
        SCREEN-ACTIVE = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

START-OF-SELECTION.

  PERFORM PASSW.

  IF PLANT IS INITIAL.
    MESSAGE 'ENTER PLANT' TYPE 'E'.
  ENDIF.

  IF R1 EQ 'X'.
    PERFORM BATCHYIELD.
  ELSEIF R2 EQ 'X'.
    PERFORM BATCHYIELD1.
  ELSEIF R3 EQ 'X'.
    PERFORM DISPLAY.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  BATCHYIELD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BATCHYIELD .
  SELECT * FROM AFPO INTO TABLE IT_AFPO WHERE CHARG EQ BATCH AND PWERK EQ PLANT.
  LOOP AT IT_AFPO INTO WA_AFPO.
    IF WA_AFPO-MATNR CS 'H'.
    ELSE.
      DELETE IT_AFPO WHERE AUFNR EQ WA_AFPO-AUFNR.
    ENDIF.
  ENDLOOP.

  SORT IT_AFPO DESCENDING BY AUFNR.
  LOOP AT IT_AFPO INTO WA_AFPO.
*    WRITE: / WA_AFPO-MATNR,WA_AFPO-CHARG,WA_AFPO-AUFNR.
    WA_INSP1-MATNR = WA_AFPO-MATNR.
    WA_INSP1-CHARG = WA_AFPO-CHARG.
    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_AFPO-MATNR.
    IF SY-SUBRC EQ 0.
      WA_INSP1-MAKTX = MAKT-MAKTX.
    ENDIF.
    SELECT SINGLE * FROM MCHA WHERE MATNR EQ WA_AFPO-MATNR AND CHARG EQ WA_AFPO-CHARG AND WERKS EQ WA_AFPO-PWERK.
    IF SY-SUBRC EQ 0.
      WA_INSP1-HSDAT = MCHA-HSDAT.
      WA_INSP1-VFDAT = MCHA-VFDAT.
    ENDIF.
    WA_INSP1-WEMNG = WA_AFPO-WEMNG.
    WA_INSP1-PSMNG = WA_AFPO-PSMNG.
    WA_INSP1-MEINS = WA_AFPO-MEINS.
    WA_INSP1-MEINS1 = WA_AFPO-MEINS.
*    IF WA_AFPO-MEINS EQ 'PC'.
*      WA_INSP1-TXT1 = 'Enter quantity in ''NO OF TABLET'''.
*      WA_INSP1-MEINS1 = WA_AFPO-MEINS.
*    ELSE.
*      WA_INSP1-TXT1 = 'Enter quantity in ''SALE UNIT'.
*      WA_INSP1-MEINS1 = 'EA'.
*    ENDIF.
    COLLECT WA_INSP1 INTO IT_INSP1.
    CLEAR WA_INSP1.
  ENDLOOP.

*  LOOP AT IT_INSP1 INTO WA_INSP1.
*    WRITE : / WA_INSP1-MATNR, WA_INSP1-CHARG,WA_INSP1-MAKTX,WA_INSP1-WEMNG,WA_INSP1-MEINS.
*  ENDLOOP.

  CALL SCREEN 9001.
  CLEAR : IT_INSP1,WA_INSP1.
  CLEAR : OK_CODE.
  CALL TRANSACTION 'ZPRDINSP_YLD'.
  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9001 OUTPUT.
*  IF R1 EQ 'X'.
  SET PF-STATUS 'STATUS'.
*  ELSEIF R2 EQ 'X'.
*     SET PF-STATUS 'STATUS1'.
*    ENDIF.
  IF R3 EQ 'X'.
    SET TITLEBAR 'TITLE3'.
  ELSE.
    SET TITLEBAR 'TITLE1'.
  ENDIF.
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
  CREATE OBJECT C_CCONT
    EXPORTING
      CONTAINER_NAME = 'CCONT'.

  CREATE OBJECT C_ALVGD
    EXPORTING
      I_PARENT = CL_GUI_CUSTOM_CONTAINER=>SCREEN0.

*  data lv_fieldcat type lvc_s_fcat.
  IF R1 EQ 'X'.
    PERFORM ALV.
  ELSEIF R2 EQ 'X'.
    PERFORM ALV1.
  ELSEIF R3 EQ 'X'.
    PERFORM ALV2.
  ENDIF.
  PERFORM ALV_LAYOUT.

  IF R1 EQ 'X'.

    CHECK NOT C_ALVGD IS INITIAL.
    CALL METHOD C_ALVGD->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
        IS_LAYOUT                     = IT_LAYOUT
        I_SAVE                        = 'A'
      CHANGING
        IT_OUTTAB                     = IT_INSP1
        IT_FIELDCATALOG               = IT_FCAT
      EXCEPTIONS
        INVALID_PARAMETER_COMBINATION = 1
        PROGRAM_ERROR                 = 2
        TOO_MANY_LINES                = 3
        OTHERS                        = 4.
    IF SY-SUBRC NE 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ELSEIF R2 EQ 'X'.

    CHECK NOT C_ALVGD IS INITIAL.
    CALL METHOD C_ALVGD->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
        IS_LAYOUT                     = IT_LAYOUT
        I_SAVE                        = 'A'
      CHANGING
        IT_OUTTAB                     = IT_INSP2
        IT_FIELDCATALOG               = IT_FCAT
      EXCEPTIONS
        INVALID_PARAMETER_COMBINATION = 1
        PROGRAM_ERROR                 = 2
        TOO_MANY_LINES                = 3
        OTHERS                        = 4.
    IF SY-SUBRC NE 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ELSEIF R3 EQ 'X'.
    CHECK NOT C_ALVGD IS INITIAL.
    CALL METHOD C_ALVGD->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
        IS_LAYOUT                     = IT_LAYOUT
        I_SAVE                        = 'A'
      CHANGING
        IT_OUTTAB                     = IT_DISP1
        IT_FIELDCATALOG               = IT_FCAT
      EXCEPTIONS
        INVALID_PARAMETER_COMBINATION = 1
        PROGRAM_ERROR                 = 2
        TOO_MANY_LINES                = 3
        OTHERS                        = 4.
    IF SY-SUBRC NE 0.
      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
      WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV .
  LV_FLDCAT-FIELDNAME = 'MATNR'.
  LV_FLDCAT-SCRTEXT_L = 'Material Code'.
*lv_fldcat-edit = 'X'.
*  LV_FLDCAT-OUTPUTLEN  = ''.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MAKTX'.
  LV_FLDCAT-SCRTEXT_L = 'Material Name'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '25'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.


  LV_FLDCAT-FIELDNAME = 'CHARG'.
  LV_FLDCAT-SCRTEXT_L = 'Batch/ I.D. NO.'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'HSDAT'.
  LV_FLDCAT-SCRTEXT_L = 'Mfg. Date'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'VFDAT'.
  LV_FLDCAT-SCRTEXT_L = 'Exp.Date'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'PSMNG'.
  LV_FLDCAT-SCRTEXT_L = 'Batch Quantity'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'WEMNG'.
  LV_FLDCAT-SCRTEXT_L = 'Received Quantity'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MEINS'.
  LV_FLDCAT-SCRTEXT_L = 'Rec QTY Unit'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '3'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MENGE'.
  LV_FLDCAT-SCRTEXT_L = 'Inspection Stage Quantity'.
  LV_FLDCAT-EDIT = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MEINS1'.
  LV_FLDCAT-SCRTEXT_L = 'Insp. QTY Unit'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.
*
*  LV_FLDCAT-FIELDNAME = 'TXT1'.
*  LV_FLDCAT-SCRTEXT_L = 'Unit of entered quantity'.
**lv_fldcat-edit = 'X'.
*  LV_FLDCAT-OUTPUTLEN  = '50'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV_LAYOUT .
  IT_LAYOUT-ZEBRA = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9001 INPUT.
  C_ALVGD->CHECK_CHANGED_DATA( ).

  CASE OK_CODE.
    WHEN 'SAVE'.
      IF R1 EQ 'X'.
        PERFORM UPDATEDATA.
*        CLEAR : OK_CODE.
*        LEAVE TO SCREEN 0.
      ELSEIF R2 EQ 'X'.
        PERFORM UPDATEDATA1.
      ENDIF.
      LEAVE TO SCREEN 0.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.
*  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  UPDATEDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDATEDATA .
*  BREAK-POINT  .
  LOOP AT IT_INSP1 INTO WA_INSP1.
    ZPROD_INSP_YLD_WA-CHARG = WA_INSP1-CHARG.
    ZPROD_INSP_YLD_WA-WERKS = PLANT.
    ZPROD_INSP_YLD_WA-QTY = WA_INSP1-MENGE.
    ZPROD_INSP_YLD_WA-MEINS = WA_INSP1-MEINS1.
    ZPROD_INSP_YLD_WA-PERNR = PERNR.
    ZPROD_INSP_YLD_WA-CPUDT = SY-DATUM.
    ZPROD_INSP_YLD_WA-CPUTM = SY-UZEIT.
    MODIFY ZPROD_INSP_YLD FROM ZPROD_INSP_YLD_WA.
    CLEAR ZPROD_INSP_YLD_WA.
  ENDLOOP.
  IF SY-SUBRC EQ 0.
    MESSAGE 'Data Saved' TYPE 'I'.
*    CLEAR : OK_CODE.
*    LEAVE TO SCREEN 0.
  ENDIF.
*  CLEAR : OK_CODE.
*  LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BATCHYIELD1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BATCHYIELD1 .
  SELECT SINGLE * FROM ZCSM_QTY_BATCH WHERE CHARG EQ BATCH.
    IF SY-SUBRC EQ 0.
      MESSAGE' CS ENTRY DONE.. CHANGE NOT POSSIBLE' TYPE 'E'.
    ENDIF.

  SELECT * FROM AFPO INTO TABLE IT_AFPO WHERE CHARG EQ BATCH AND PWERK EQ PLANT.
  LOOP AT IT_AFPO INTO WA_AFPO.
    IF WA_AFPO-MATNR CS 'H'.
    ELSE.
      DELETE IT_AFPO WHERE AUFNR EQ WA_AFPO-AUFNR.
    ENDIF.
  ENDLOOP.

  SORT IT_AFPO DESCENDING BY AUFNR.

  SELECT * FROM ZPROD_INSP_YLD INTO TABLE IT_ZPROD_INSP_YLD WHERE CHARG EQ BATCH AND WERKS EQ PLANT.

  LOOP AT IT_ZPROD_INSP_YLD INTO WA_ZPROD_INSP_YLD.
    READ TABLE IT_AFPO INTO WA_AFPO WITH KEY CHARG = WA_ZPROD_INSP_YLD-CHARG.
    IF SY-SUBRC EQ 0.
      WA_INSP2-MATNR = WA_AFPO-MATNR.
      WA_INSP2-PSMNG = WA_AFPO-PSMNG.
      WA_INSP2-WEMNG = WA_AFPO-WEMNG.
      WA_INSP2-MEINS = WA_AFPO-MEINS.
      SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_AFPO-MATNR AND SPRAS EQ 'EN'.
      IF SY-SUBRC EQ 0.
        WA_INSP2-MAKTX = MAKT-MAKTX.
      ENDIF.
    ENDIF.
    WA_INSP2-CHARG = WA_ZPROD_INSP_YLD-CHARG.
    WA_INSP2-WERKS = WA_ZPROD_INSP_YLD-WERKS.
    WA_INSP2-QTY = WA_ZPROD_INSP_YLD-QTY.
    WA_INSP2-MEINS = WA_ZPROD_INSP_YLD-MEINS.
    WA_INSP2-MEINS1 = WA_AFPO-MEINS.
    SELECT SINGLE * FROM PA0001 WHERE PERNR EQ WA_ZPROD_INSP_YLD-PERNR AND ENDDA GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      WA_INSP2-ENAME = PA0001-ENAME.
    ENDIF.
    WA_INSP2-NEWQTY = SPACE.
*    IF WA_AFPO-MEINS EQ 'PC'.
*      WA_INSP2-TXT1 = 'Enter quantity in ''NO OF TABLET'''.
*      WA_INSP2-MEINS1 = WA_AFPO-MEINS.
*    ELSE.
*      WA_INSP2-TXT1 = 'Enter quantity in ''SALE UNIT'.
*      WA_INSP2-MEINS1 = 'EA'.
*    ENDIF.
    SELECT SINGLE * FROM MCHA WHERE MATNR EQ WA_INSP2-MATNR AND CHARG EQ WA_INSP2-CHARG AND WERKS EQ WA_INSP2-WERKS.
    IF SY-SUBRC EQ 0.
      WA_INSP2-HSDAT = MCHA-HSDAT.
      WA_INSP2-VFDAT = MCHA-VFDAT.
    ENDIF.
    COLLECT WA_INSP2 INTO IT_INSP2.
    CLEAR WA_INSP2.
  ENDLOOP.

  CALL SCREEN 9001.
  CLEAR : IT_INSP2,WA_INSP2.
  CLEAR : OK_CODE.
  CALL TRANSACTION 'ZPRDINSP_YLD'.
*  LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATEDATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDATEDATA1 .
  LOOP AT IT_INSP2 INTO WA_INSP2.
    SELECT SINGLE * FROM ZPROD_INSP_YLD WHERE CHARG EQ WA_INSP2-CHARG.
    IF SY-SUBRC EQ 0.
      MOVE-CORRESPONDING ZPROD_INSP_YLD TO ZPROD_INSP_YLD_WA.
      ZPROD_INSP_YLD_WA-QTY = WA_INSP2-NEWQTY.
      ZPROD_INSP_YLD_WA-PERNR1 = PERNR.
      ZPROD_INSP_YLD_WA-CPUDT1 = SY-DATUM.
      ZPROD_INSP_YLD_WA-CPUTM1 = SY-UZEIT.
      MODIFY ZPROD_INSP_YLD FROM ZPROD_INSP_YLD_WA.
      CLEAR ZPROD_INSP_YLD_WA.
    ENDIF.
  ENDLOOP.
  IF SY-SUBRC EQ 0.
    MESSAGE 'Data Saved' TYPE 'I'.
  ENDIF.
*  LEAVE PROGRAM.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV1 .
  LV_FLDCAT-FIELDNAME = 'MATNR'.
  LV_FLDCAT-SCRTEXT_L = 'Material Code'.
*lv_fldcat-edit = 'X'.
*  LV_FLDCAT-OUTPUTLEN  = ''.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MAKTX'.
  LV_FLDCAT-SCRTEXT_L = 'Material Name'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '25'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.


  LV_FLDCAT-FIELDNAME = 'CHARG'.
  LV_FLDCAT-SCRTEXT_L = 'Batch/ I.D. NO.'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'HSDAT'.
  LV_FLDCAT-SCRTEXT_L = 'Mfg. Date'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'VFDAT'.
  LV_FLDCAT-SCRTEXT_L = 'Exp.Date'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'PSMNG'.
  LV_FLDCAT-SCRTEXT_L = 'Batch Quantity'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'WEMNG'.
  LV_FLDCAT-SCRTEXT_L = 'Received Quantity'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'QTY'.
  LV_FLDCAT-SCRTEXT_L = 'Inspection Yield Qty'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MEINS'.
  LV_FLDCAT-SCRTEXT_L = 'UOM'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '3'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'NEWQTY'.
  LV_FLDCAT-SCRTEXT_L = 'New Inspection Stage Quantity'.
  LV_FLDCAT-EDIT = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MEINS1'.
  LV_FLDCAT-SCRTEXT_L = 'Insp. QTY Unit'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

*  LV_FLDCAT-FIELDNAME = 'TXT1'.
*  LV_FLDCAT-SCRTEXT_L = 'Unit of entered quantity'.
**lv_fldcat-edit = 'X'.
*  LV_FLDCAT-OUTPUTLEN  = '50'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY .
  SELECT * FROM ZPROD_INSP_YLD INTO TABLE IT_ZPROD_INSP_YLD WHERE CHARG IN CHARG AND WERKS EQ PLANT.
  IF SY-SUBRC EQ 0.
    SELECT * FROM AFPO INTO TABLE IT_AFPO FOR ALL ENTRIES IN IT_ZPROD_INSP_YLD WHERE CHARG EQ IT_ZPROD_INSP_YLD-CHARG  AND PWERK EQ PLANT.
  ENDIF.
  IF IT_ZPROD_INSP_YLD IS INITIAL.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.

  IF IT_AFPO IS NOT INITIAL.
    LOOP AT IT_AFPO INTO WA_AFPO.
      IF WA_AFPO-MATNR CS 'H'.
      ELSE.
        DELETE IT_AFPO WHERE AUFNR EQ WA_AFPO-AUFNR.
      ENDIF.
    ENDLOOP.
  ENDIF.
  SORT IT_AFPO DESCENDING BY AUFNR.



  LOOP AT IT_ZPROD_INSP_YLD INTO WA_ZPROD_INSP_YLD.
    READ TABLE IT_AFPO INTO WA_AFPO WITH KEY CHARG = WA_ZPROD_INSP_YLD-CHARG.
    IF SY-SUBRC EQ 0.
      WA_DISP1-MATNR = WA_AFPO-MATNR.
      WA_DISP1-PSMNG = WA_AFPO-PSMNG.
      WA_DISP1-WEMNG = WA_AFPO-WEMNG.
      WA_DISP1-MEINS = WA_AFPO-MEINS.
      SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_AFPO-MATNR AND SPRAS EQ 'EN'.
      IF SY-SUBRC EQ 0.
        WA_DISP1-MAKTX = MAKT-MAKTX.
      ENDIF.
    ENDIF.
    WA_DISP1-CHARG = WA_ZPROD_INSP_YLD-CHARG.
    WA_DISP1-WERKS = WA_ZPROD_INSP_YLD-WERKS.
    WA_DISP1-QTY = WA_ZPROD_INSP_YLD-QTY.
    WA_DISP1-MEINS = WA_ZPROD_INSP_YLD-MEINS.
    WA_DISP1-MEINS1 = WA_ZPROD_INSP_YLD-MEINS.
    IF WA_ZPROD_INSP_YLD-PERNR1 GT 0.
      SELECT SINGLE * FROM PA0001 WHERE PERNR EQ WA_ZPROD_INSP_YLD-PERNR1 AND ENDDA GE SY-DATUM.
      IF SY-SUBRC EQ 0.
        WA_DISP1-ENAME = PA0001-ENAME.
      ENDIF.
      WA_DISP1-CPUDT = WA_ZPROD_INSP_YLD-CPUDT.
      WA_DISP1-CPUTM = WA_ZPROD_INSP_YLD-CPUTM.
    ELSE.
      SELECT SINGLE * FROM PA0001 WHERE PERNR EQ WA_ZPROD_INSP_YLD-PERNR AND ENDDA GE SY-DATUM.
      IF SY-SUBRC EQ 0.
        WA_DISP1-ENAME = PA0001-ENAME.
      ENDIF.
      WA_DISP1-CPUDT = WA_ZPROD_INSP_YLD-CPUDT1.
      WA_DISP1-CPUTM = WA_ZPROD_INSP_YLD-CPUTM1.
    ENDIF.
*    IF WA_AFPO-MEINS EQ 'PC'.
*      WA_DISP1-TXT1 = 'Entered quantity in ''NO OF TABLET'''.
*      WA_DISP1-MEINS1 = WA_AFPO-MEINS.
*    ELSE.
*      WA_DISP1-TXT1 = 'Entered quantity in ''SALE UNIT'.
*      WA_DISP1-MEINS1 = 'EA'.
*    ENDIF.

    SELECT SINGLE * FROM MCHA WHERE MATNR EQ WA_DISP1-MATNR AND CHARG EQ WA_DISP1-CHARG AND WERKS EQ WA_DISP1-WERKS.
    IF SY-SUBRC EQ 0.
      WA_DISP1-HSDAT = MCHA-HSDAT.
      WA_DISP1-VFDAT = MCHA-VFDAT.
    ENDIF.
    COLLECT WA_DISP1 INTO IT_DISP1.
    CLEAR WA_DISP1.
  ENDLOOP.

  CALL SCREEN 9001.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM ALV2 .
  LV_FLDCAT-FIELDNAME = 'MATNR'.
  LV_FLDCAT-SCRTEXT_L = 'Material Code'.
*lv_fldcat-edit = 'X'.
*  LV_FLDCAT-OUTPUTLEN  = ''.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MAKTX'.
  LV_FLDCAT-SCRTEXT_L = 'Material Name'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '25'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.


  LV_FLDCAT-FIELDNAME = 'CHARG'.
  LV_FLDCAT-SCRTEXT_L = 'Batch/ I.D. NO.'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'HSDAT'.
  LV_FLDCAT-SCRTEXT_L = 'Mfg. Date'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'VFDAT'.
  LV_FLDCAT-SCRTEXT_L = 'Exp.Date'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'PSMNG'.
  LV_FLDCAT-SCRTEXT_L = 'Batch Quantity'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MEINS'.
  LV_FLDCAT-SCRTEXT_L = 'UOM'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '3'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'WEMNG'.
  LV_FLDCAT-SCRTEXT_L = 'Received Quantity'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'QTY'.
  LV_FLDCAT-SCRTEXT_L = 'Inspection Yield Qty'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'MEINS1'.
  LV_FLDCAT-SCRTEXT_L = 'Insp. QTY Unit'.
*lv_fldcat-edit = 'X'.
  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

  LV_FLDCAT-FIELDNAME = 'ENAME'.
  LV_FLDCAT-SCRTEXT_L = 'Insp. QTY entered by'.
*lv_fldcat-edit = 'X'.
*  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

   LV_FLDCAT-FIELDNAME = 'CPUDT'.
  LV_FLDCAT-SCRTEXT_L = 'Insp. QTY entered on'.
*lv_fldcat-edit = 'X'.
*  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.

   LV_FLDCAT-FIELDNAME = 'CPUTM'.
  LV_FLDCAT-SCRTEXT_L = 'Insp. QTY entered time'.
*lv_fldcat-edit = 'X'.
*  LV_FLDCAT-OUTPUTLEN  = '10'.
  APPEND LV_FLDCAT TO IT_FCAT.
  CLEAR LV_FLDCAT.



*  LV_FLDCAT-FIELDNAME = 'TXT1'.
*  LV_FLDCAT-SCRTEXT_L = 'Unit of entered quantity'.
**lv_fldcat-edit = 'X'.
*  LV_FLDCAT-OUTPUTLEN  = '50'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PASSW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PASSW .
  SELECT SINGLE * FROM ZPASSW WHERE PERNR = PERNR.
  IF SY-SUBRC EQ 0.

    IF SY-UNAME NE ZPASSW-UNAME.
      MESSAGE 'INVALID LOGIN ID' TYPE 'E'.
    ENDIF.

    V_EN_STRING = ZPASSW-PASSWORD.
*&———————————————————————** Decryption – String to String*&———————————————————————*
    TRY.
        CREATE OBJECT O_ENCRYPTOR.
        CALL METHOD O_ENCRYPTOR->DECRYPT_STRING2STRING
          EXPORTING
            THE_STRING = V_EN_STRING
          RECEIVING
            RESULT     = V_DE_STRING.
      CATCH CX_ENCRYPT_ERROR INTO O_CX_ENCRYPT_ERROR.
        CALL METHOD O_CX_ENCRYPT_ERROR->IF_MESSAGE~GET_TEXT
          RECEIVING
            RESULT = V_ERROR_MSG.
        MESSAGE V_ERROR_MSG TYPE 'E'.
    ENDTRY.
    IF V_DE_STRING EQ PASS.
*      message 'CORRECT PASSWORD' type 'I'.
    ELSE.
      MESSAGE 'INCORRECT PASSWORD' TYPE 'E'.
    ENDIF.
  ELSE.
    MESSAGE 'NOT VALID USER' TYPE 'E'.
    EXIT.
  ENDIF.
  CLEAR : PASS.
  PASS = '   '.
ENDFORM.
