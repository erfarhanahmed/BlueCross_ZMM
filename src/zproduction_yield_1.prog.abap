*&---------------------------------------------------------------------*
*& Report  ZPRODUCTION_YIELD
*&DEVELOPD BY JYOTSNA 28.7.22 TO CHECK PRODUCTION YIELD AT VARIOS LEVELS.
*&---------------------------------------------------------------------*
*&24.2.25-- mapped halb batch from order for MPT BATCHES- JYOTSNA
*&
*&---------------------------------------------------------------------*
REPORT zproduction_yield_1_na3 NO STANDARD PAGE HEADING LINE-SIZE 200.

CONSTANTS: gc_x     TYPE char1 VALUE 'X',
           gc_bukrs TYPE bukrs VALUE '1000'.
TABLES : mchb,
         afko,
         aufk,
         afru,
         jest,
         qave,
         mara,
         marm,
         zprod_insp_yld,
         afpo.

TYPE-POOLS:  slis.

DATA: g_repid     LIKE sy-repid,
      fieldcat    TYPE slis_t_fieldcat_alv,
      wa_fieldcat LIKE LINE OF fieldcat,
      sort        TYPE slis_t_sortinfo_alv,
      wa_sort     LIKE LINE OF sort,
      layout      TYPE slis_layout_alv.

DATA: it_afpo TYPE TABLE OF afpo,
      wa_afpo TYPE afpo,
      it_afru TYPE TABLE OF afru,
      wa_afru TYPE afru,
      it_qals TYPE TABLE OF qals,
      wa_qals TYPE qals.

TYPES : BEGIN OF itab1,
          aufnr TYPE afpo-aufnr,
          matnr TYPE afpo-matnr,
          charg TYPE afpo-charg,
        END OF itab1.

TYPES : BEGIN OF itab2,
          aufnr TYPE afpo-aufnr,
          matnr TYPE afpo-matnr,
          charg TYPE afpo-charg,
          vornr TYPE afru-vornr,
          gmnga TYPE afru-gmnga,
        END OF itab2.

TYPES : BEGIN OF itab3,
          charg   TYPE afpo-charg,
          MATNR   TYPE afpo-MATNR,
          per1    TYPE p DECIMALS 2,
          per2    TYPE p DECIMALS 2,
          per3    TYPE p DECIMALS 2,
          per4    TYPE p DECIMALS 2,
          per5    TYPE p DECIMALS 2,
          per6    TYPE p DECIMALS 2,
          aqty1   TYPE p DECIMALS 3,
          rqty1   TYPE p DECIMALS 3,
          aqty2   TYPE p DECIMALS 3,
          rqty2   TYPE p DECIMALS 3,
          aqty3   TYPE p DECIMALS 3,
          rqty3   TYPE p DECIMALS 3,
          aqty4   TYPE p DECIMALS 3,
          rqty4   TYPE p DECIMALS 3,
          aqty5   TYPE p DECIMALS 3,
          rqty5   TYPE p DECIMALS 3,
          sqty5   TYPE p DECIMALS 3,
          inspqty TYPE p DECIMALS 3,
          rqty6   TYPE p DECIMALS 3,
        END OF itab3.

TYPES : BEGIN OF mat1,
          charg TYPE mchb-charg,
          matnr TYPE mchb-matnr,
        END OF mat1.

TYPES : BEGIN OF fp1,
          charg TYPE mchb-charg,
          rqty  TYPE p DECIMALS 3,
          sqty  TYPE p DECIMALS 3,
          aufnr TYPE afpo-aufnr,
        END OF fp1.

TYPES : BEGIN OF fp3,
          charg TYPE mchb-charg,
          per   TYPE p DECIMALS 2,
          gmnga TYPE afru-gmnga,
          sqty  TYPE afru-gmnga,
          psmng TYPE afru-gmnga,
        END OF fp3.

TYPES : BEGIN OF samp1,
          charg TYPE mchb-charg,
          qty   TYPE i,
        END OF samp1.
DATA: it_samp1 TYPE TABLE OF samp1,
      wa_samp1 TYPE samp1.
DATA: it_zprod_yield TYPE TABLE OF zprod_yield,
      wa_zprod_yield TYPE zprod_yield.

DATA: it_tab1 TYPE TABLE OF itab1,
      wa_tab1 TYPE itab1,
      it_tab2 TYPE TABLE OF itab2,
      wa_tab2 TYPE itab2,
      it_tab3 TYPE TABLE OF itab3,
      wa_tab3 TYPE itab3,
      it_mat1 TYPE TABLE OF mat1,
      wa_mat1 TYPE mat1,
      it_fp1  TYPE TABLE OF fp1,
      wa_fp1  TYPE fp1,
      it_fp2  TYPE TABLE OF fp1,
      wa_fp2  TYPE fp1,
      it_fp3  TYPE TABLE OF fp3,
      wa_fp3  TYPE fp3.

DATA: sqty1 TYPE i,
      sqty2 TYPE i.
DATA: matnr TYPE afpo-matnr.
DATA: order TYPE afpo-aufnr,
      psmng TYPE afpo-psmng,
      charg TYPE afpo-charg.
DATA: batchsz TYPE p.
DATA : batchsize    TYPE p,
       batchsz1(15) TYPE c.


DATA: fpper TYPE p DECIMALS 2.
DATA: per1 TYPE p DECIMALS 2,
      per2 TYPE p DECIMALS 2,
      per3 TYPE p DECIMALS 2,
      per4 TYPE p DECIMALS 2,
      per5 TYPE p DECIMALS 2,
      per6 TYPE p DECIMALS 2.
DATA: it_resb1 TYPE TABLE OF resb,
      wa_resb1 TYPE resb,
      it_resb2 TYPE TABLE OF resb,
      wa_resb2 TYPE resb.
DATA: mtart TYPE mara-mtart.
DATA :
*      mesg(40) type c,
      msg TYPE string.
DATA: qty TYPE p DECIMALS 3.
DATA: liq   TYPE i,
      lqty1 TYPE p,
      lqty2 TYPE p,
      lqty3 TYPE p.

SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS : P_MATNR FOR mchb-MATNR .
  SELECT-OPTIONS : batch FOR mchb-charg .
  PARAMETERS :  plant LIKE mchb-werks .
  PARAMETERS : r1 RADIOBUTTON GROUP r1,
               r2 RADIOBUTTON GROUP r1,
               r3 RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK merkmale1.

INITIALIZATION.
  g_repid = sy-repid.

AT SELECTION-SCREEN.
  PERFORM authorization.

START-OF-SELECTION .
  IF r3 = gc_x.
    CALL TRANSACTION 'ZPRD_YIELDENTRY'.
  ELSE.
    IF plant IS INITIAL.
      MESSAGE 'ENTER PLANT' TYPE 'E'.
    ENDIF.
    IF batch IS INITIAL.
      MESSAGE 'ENTER BATCH' TYPE 'E'.
    ENDIF.
*** SOC by CK on Date 26.11.2025
  IF P_MATNR IS INITIAL.
    MESSAGE 'ENTER MATERIAL' TYPE 'E'.
  ENDIF.

*** EOC by CK on Date 26.11.2025

    PERFORM yielddata.
  ENDIF.




*&---------------------------------------------------------------------*
*&      Form  DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data1 .
*  write : / 'BATCH',20'89 INSP',40 'GRANULATION',60 'COMPRESSION',80 'COATING',100 'FP'.
*  uline.
*  loop at it_tab3 into wa_tab3.
*    write : / '1',wa_tab3-charg,20 wa_tab3-per1 left-justified,40 wa_tab3-per2 left-justified,60 wa_tab3-per3 left-justified,
*    80 wa_tab3-per4 left-justified,100  wa_tab3-per5 left-justified.
*  endloop.
*  uline.
*  uline.
wa_fieldcat-fieldname = 'MATNR'.
wa_fieldcat-seltext_l = 'MATERIAL NO.'.
APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH NO.'.
  APPEND wa_fieldcat TO fieldcat.

*  wa_fieldcat-fieldname = 'PER1'.
*  wa_fieldcat-seltext_l = '89 INSP. LOT %'.
*  append wa_fieldcat to fieldcat.
*  break-point.
  IF liq EQ 1.
    wa_fieldcat-fieldname = 'PER2'.
    wa_fieldcat-seltext_l = 'BULK %'.
    APPEND wa_fieldcat TO fieldcat.

  ELSE.
    wa_fieldcat-fieldname = 'PER2'.
    wa_fieldcat-seltext_l = 'BLEND %'.  " Granulation
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'PER3'.
    wa_fieldcat-seltext_l = 'COMPRESSION %'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'PER4'.
    wa_fieldcat-seltext_l = 'COATING%'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'PER6'.
    wa_fieldcat-seltext_l = 'INSPECTION%'.
    APPEND wa_fieldcat TO fieldcat.
  ENDIF.

*   WA_FIELDCAT-FIELDNAME = 'PER5'.
*  WA_FIELDCAT-SELTEXT_L = 'FINISHED PRODUCT %'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'PER5'.
  wa_fieldcat-seltext_l = 'FINISHED PRODUCT %'.
  APPEND wa_fieldcat TO fieldcat.



  layout-zebra = gc_x.
  layout-colwidth_optimize = gc_x.
  layout-window_titlebar  = 'BATCH WISE, STAGE WISE YIELD PERCENTGE'.


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
      t_outtab                = it_tab3
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    "SUMMARY

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top.

  DATA: comment    TYPE slis_t_listheader,
        wa_comment LIKE LINE OF comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'BATCH WISE, STAGE WISE YIELD PERCENTGE'.
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
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD selfield-value.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM


*endform.
*&---------------------------------------------------------------------*
*&      Form  DATA2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM data2 .
*  write : / 'BATCH',20'89 INSP%',30'ACT_QTY',40 'REC_QTY',50 'GRANULATION%',60 'ACT_QTY',70'REC_QTY',80 'COMPRESSION%',90 'ACT_QTY',100 'REC_QTY',
*  110 'COATING%',120 'ACT_QTY',130 'REC_QTY',140 'FP%',150 'ACT_QTY',160 'REC_QTY'.
*  uline.
*
*  loop at it_tab3 into wa_tab3.
*    write : / '1',wa_tab3-charg,20 wa_tab3-per1 left-justified,30 wa_tab3-aqty1 left-justified,40 wa_tab3-rqty1 left-justified,
*                               50 wa_tab3-per2 left-justified,60 wa_tab3-aqty2 left-justified,70 wa_tab3-rqty2 left-justified,
*                               80 wa_tab3-per3 left-justified,90 wa_tab3-aqty3 left-justified,100 wa_tab3-rqty3 left-justified,
*                               110 wa_tab3-per4 left-justified,120 wa_tab3-aqty4 left-justified,130 wa_tab3-rqty4 left-justified,
*                               140 wa_tab3-per5 left-justified, 150 wa_tab3-aqty5 left-justified,160 wa_tab3-rqty5 left-justified.
*  endloop.
  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'MATERIAL NO.'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH NO.'.
  APPEND wa_fieldcat TO fieldcat.

*  wa_fieldcat-fieldname = 'PER1'.
*  wa_fieldcat-seltext_l = '89 INSP. LOT %'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'AQTY1'.
*  wa_fieldcat-seltext_l = '89 ACT QTY'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'RQTY1'.
*  wa_fieldcat-seltext_l = '89 REC QTY'.
*  append wa_fieldcat to fieldcat.

  IF liq EQ 1.

    wa_fieldcat-fieldname = 'AQTY2'.
    wa_fieldcat-seltext_l = 'BULK ACT QTY'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'RQTY2'.
    wa_fieldcat-seltext_l = 'BULK REC QTY'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'PER2'.
    wa_fieldcat-seltext_l = 'BULK %'.
    APPEND wa_fieldcat TO fieldcat.



  ELSE.

    wa_fieldcat-fieldname = 'AQTY2'.
    wa_fieldcat-seltext_l = 'BLEND ACT QTY'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'RQTY2'.
    wa_fieldcat-seltext_l = 'BLEND REC QTY'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'PER2'.
    wa_fieldcat-seltext_l = 'BLEND %'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'AQTY3'.
    wa_fieldcat-seltext_l = 'COMP. ACT QTY'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'RQTY3'.
    wa_fieldcat-seltext_l = 'COMP. REC QTY'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'PER3'.
    wa_fieldcat-seltext_l = 'COMPRESSION %'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'AQTY4'.
    wa_fieldcat-seltext_l = 'COAT. ACT QTY'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'RQTY4'.
    wa_fieldcat-seltext_l = 'COAT. REC QTY'.
    APPEND wa_fieldcat TO fieldcat.

    wa_fieldcat-fieldname = 'PER4'.
    wa_fieldcat-seltext_l = 'COATING%'.
    APPEND wa_fieldcat TO fieldcat.

  ENDIF.

  wa_fieldcat-fieldname = 'INSPQTY'.
  wa_fieldcat-seltext_l = 'INSP. REC QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'RQTY6'.
  wa_fieldcat-seltext_l = 'INSP. ACT QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'PER6'.
  wa_fieldcat-seltext_l = 'INSPECTION%'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'AQTY5'.
  wa_fieldcat-seltext_l = 'FP. ACT QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'SQTY5'.
  wa_fieldcat-seltext_l = 'FP. SAMPLE QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'RQTY5'.
  wa_fieldcat-seltext_l = 'FP. REC QTY'.
  APPEND wa_fieldcat TO fieldcat.

  wa_fieldcat-fieldname = 'PER5'.
  wa_fieldcat-seltext_l = 'FINISHED PRODUCT %'.
  APPEND wa_fieldcat TO fieldcat.

  layout-zebra = gc_x.
  layout-colwidth_optimize = gc_x.
  layout-window_titlebar  = 'BATCH WISE, STAGE WISE YIELD PERCENTGE - DETAILS'.


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
      t_outtab                = it_tab3
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

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

  AUTHORITY-CHECK OBJECT 'M_BCO_WERK'
         ID 'WERKS' FIELD plant.
  IF sy-subrc <> 0.
    CONCATENATE 'No authorization for Plant' plant INTO msg
    SEPARATED BY space.
    MESSAGE msg TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SAMPDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sampdata .
  IF it_mat1 IS NOT INITIAL.
    SELECT * FROM zprod_yield
      INTO TABLE it_zprod_yield
      FOR ALL ENTRIES IN it_mat1
      WHERE charg EQ it_mat1-charg.
  ENDIF.
**BREAK-POINT.
*  LOOP AT it_zprod_yield INTO wa_zprod_yield.
*    CLEAR : sqty1,sqty2.
*    sqty1 = wa_zprod_yield-stability + wa_zprod_yield-rnd + wa_zprod_yield-other.
*    WRITE : / wa_zprod_yield-matnr,wa_zprod_yield-charg,wa_zprod_yield-stability.
*    SELECT SINGLE * FROM marm WHERE matnr EQ wa_zprod_yield-matnr AND meinh EQ 'PC'.
*    IF sy-subrc EQ 0.
*      sqty2 = sqty1 * marm-umren.
*    ENDIF.
*    wa_samp1-charg = wa_zprod_yield-charg.
*    wa_samp1-qty = sqty2.
*    COLLECT wa_samp1 INTO it_samp1.
*    CLEAR wa_samp1.
*  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  YIELDDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM yielddata .
  SELECT *
    FROM afpo
    INTO TABLE it_afpo
    WHERE charg IN batch
    AND dwerk EQ plant
    AND MATNR IN P_MATNR.
  IF sy-subrc NE 0.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.

  IF it_afpo IS NOT INITIAL.
    SELECT bukrs, aufnr
                  FROM aufk
                  FOR ALL ENTRIES IN @it_afpo
                            WHERE bukrs = @gc_bukrs
                              AND aufnr = @it_afpo-aufnr
                              AND loekz <> @gc_x
                    INTO TABLE @DATA(LT_aufk).
    SORT lt_aufk BY bukrs aufnr.
  ENDIF.
*** SOC by CK on Date 27.11.2025 17:10:11
  DATA LT_AFPO type TABLE of afpo.
  LT_AFPO = it_afpo.
  IF LT_AFPO IS NOT INITIAL.
    SELECT AUFNR, AUFPL, RSNUM , STLNR , STLAL
    FROM AFKO
    INTO TABLE @DATA(LT_AFKO)
          FOR ALL ENTRIES IN @LT_AFPO
          WHERE AUFNR = @LT_AFPO-AUFNR.
    IF LT_AFKO IS NOT INITIAL.

      SELECT  A~AUFNR,
      A~MATNR,
      A~CHARG
      FROM AUFM AS A
      INNER JOIN MARA AS B
      ON A~MATNR = B~MATNR
      INTO TABLE @DATA(LT_AUFM)
            FOR ALL ENTRIES IN @LT_AFKO
            WHERE A~AUFNR = @LT_AFKO-AUFNR
            AND A~BWART = '261'
            AND B~MTART = 'ZHLB'.

      IF LT_AUFM IS NOT INITIAL.
        SELECT AUFNR,
        MATNR,
        CHARG,
        PSMNG ,
        WEMNG
        FROM AFPO
        FOR ALL ENTRIES IN @LT_AUFM
        WHERE MATNR = @LT_AUFM-MATNR
        AND   CHARG = @LT_AUFM-CHARG
        INTO TABLE @DATA(LT_AFPO_1).
      ENDIF.
      "--- Step 3: Get AUFPL from AFKO (based on AFPO-AUFNR)
      IF LT_AFPO_1 IS NOT INITIAL.
        SELECT  AUFNR,
        AUFPL
        FROM AFKO
        FOR ALL ENTRIES IN @LT_AFPO_1
        WHERE AUFNR = @LT_AFPO_1-AUFNR
        INTO TABLE @DATA(LT_AFKO_1).
      ENDIF.

      "--- Step 4: Get GMNGA and SMENG from AFRU using AUFPL & VORNR = '0020'
      IF LT_AFKO_1 IS NOT INITIAL.
        SELECT AUFPL,
        VORNR,
        GMNGA,
        SMENG
        FROM AFRU
        FOR ALL ENTRIES IN @LT_AFKO_1
        WHERE AUFPL = @LT_AFKO_1-AUFPL
*        AND vornr = '0020'
        INTO TABLE @DATA(LT_AFRU).
      ENDIF.
      IF LT_AFKO_1 IS NOT INITIAL.
        SELECT  A~AUFNR,
        A~MATNR,
        A~CHARG
        FROM AUFM AS A
        INNER JOIN MARA AS B
        ON A~MATNR = B~MATNR
        INTO TABLE @DATA(LT_AUFM_1)
              FOR ALL ENTRIES IN @LT_AFKO_1
              WHERE A~AUFNR = @LT_AFKO_1-AUFNR
              AND A~BWART = '261'
              AND B~MTART = 'ZHLB'.

        IF LT_AUFM_1 IS NOT INITIAL.
          SELECT AUFNR,
          MATNR,
          CHARG ,
          PSMNG ,
          WEMNG
          FROM AFPO
          FOR ALL ENTRIES IN @LT_AUFM_1
          WHERE MATNR = @LT_AUFM_1-MATNR
          AND   CHARG = @LT_AUFM_1-CHARG
          INTO TABLE @DATA(LT_AFPO_2).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

*** EOC by CK on Date 27.11.2025 17:10:11
  LOOP AT it_afpo INTO wa_afpo.
*  write : / wa_afpo-aufnr,wa_afpo-matnr,wa_afpo-charg,wa_afpo-dnrel.
*    SELECT SINGLE * FROM aufk WHERE bukrs EQ 'BCLL' AND aufnr EQ wa_afpo-aufnr  AND loekz NE 'X' .
    READ TABLE LT_aufk INTO DATA(ls_aufk) WITH KEY aufnr = wa_afpo-aufnr BINARY SEARCH.
    IF sy-subrc = 0.
      wa_tab1-aufnr = wa_afpo-aufnr.
      wa_tab1-matnr = wa_afpo-matnr.
      wa_tab1-charg = wa_afpo-charg.
      COLLECT wa_tab1 INTO it_tab1.
      CLEAR wa_tab1.
*    select * from afru where aufnr eq wa_afpo-aufnr and stokz eq space and ltxa1 eq space.
**      write : / afru-vornr.
*    endselect.
    ENDIF.
    CLEAR: ls_aufk.
  ENDLOOP.

  IF it_tab1 IS NOT INITIAL.
    SELECT * FROM afru INTO TABLE it_afru FOR ALL ENTRIES IN it_tab1 WHERE aufnr EQ it_tab1-aufnr AND stokz EQ space AND ltxa1 EQ space.
  ENDIF.
  IF it_tab1 IS NOT INITIAL.
    SELECT * FROM qals  INTO TABLE it_qals FOR ALL ENTRIES IN it_tab1 WHERE art EQ '89' AND matnr EQ it_tab1-matnr AND charg EQ it_tab1-charg.
  ENDIF.
  LOOP AT it_qals INTO wa_qals.
    SELECT SINGLE * FROM jest WHERE objnr EQ wa_qals-objnr AND stat EQ 'I0224'.
    IF sy-subrc EQ 0.
      DELETE it_qals WHERE prueflos EQ wa_qals-prueflos.
    ENDIF.
  ENDLOOP.
  LOOP AT it_qals INTO wa_qals.
    SELECT SINGLE * FROM qave WHERE prueflos EQ wa_qals-prueflos AND vcode EQ  'A'.
    IF sy-subrc EQ 4.
      DELETE it_qals WHERE prueflos EQ wa_qals-prueflos.
    ENDIF.
  ENDLOOP.

  SORT it_qals DESCENDING BY prueflos.


  LOOP AT it_afru INTO wa_afru.
    READ TABLE it_tab1 INTO wa_tab1 WITH KEY aufnr = wa_afru-aufnr.
    IF sy-subrc EQ 0.
      wa_tab2-charg = wa_tab1-charg.
      wa_tab2-matnr = wa_tab1-matnr.
      wa_tab2-aufnr = wa_tab1-aufnr.
      wa_tab2-vornr = wa_afru-vornr.
      wa_tab2-gmnga = wa_afru-gmnga.
      COLLECT wa_tab2 INTO it_tab2.
      CLEAR wa_tab2.
    ENDIF.
  ENDLOOP.

  SORT it_tab2 BY charg aufnr vornr.
  LOOP AT it_tab2 INTO wa_tab2.
    wa_mat1-charg = wa_tab2-charg.
    wa_mat1-MATNR = wa_tab2-MATNR.
    COLLECT wa_mat1 INTO it_mat1.
    CLEAR wa_mat1.
  ENDLOOP.

  SORT it_mat1 BY charg.
  DELETE ADJACENT DUPLICATES FROM it_mat1 COMPARING charg.
  PERFORM sampdata.

  LOOP AT it_afpo INTO wa_afpo WHERE matnr NA 'H'.
    CLEAR : matnr.
    matnr = wa_afpo-matnr.
    CLEAR : liq,lqty1,lqty2,lqty3,qty.
    CLEAR : sqty1,sqty2.
    READ TABLE it_tab2 INTO wa_tab2 WITH KEY aufnr = wa_afpo-aufnr.
    IF sy-subrc EQ 0.
      wa_fp1-charg = wa_tab2-charg.
      wa_fp1-aufnr = wa_tab2-aufnr.
      CLEAR : qty.
      SELECT SINGLE * FROM marm WHERE matnr EQ wa_afpo-matnr AND meinh EQ 'PC'.
      IF sy-subrc EQ 0.
        qty = wa_afpo-wemng * marm-umren.
****************************************************
        CLEAR : sqty1,sqty2.
        READ TABLE it_zprod_yield INTO wa_zprod_yield WITH KEY matnr = wa_afpo-matnr charg = wa_afpo-charg werks =  wa_afpo-pwerk.
        IF sy-subrc EQ 0.
          sqty1 = wa_zprod_yield-stability + wa_zprod_yield-analytical + wa_zprod_yield-other.
        ENDIF.
        sqty2 =  sqty1 .
*        sqty2 = ( sqty1 / marm-umren ).
******************************************************
      ENDIF.
*      break-point .
      IF qty LE 0.
        SELECT SINGLE * FROM marm WHERE matnr EQ wa_afpo-matnr AND meinh EQ 'L'.
        IF sy-subrc EQ 0.
*          qty = wa_afpo-wemng * marm-umren.
          lqty1 = ( marm-umren * 1000 ) / marm-umrez.
          lqty2 = lqty1 MOD 10.
          lqty3 = lqty1 - lqty2.
          qty = ( wa_afpo-wemng * lqty3 ) / 1000.
          liq = 1.
***************SAMP QTY*******************
          CLEAR : sqty1,sqty2.
          READ TABLE it_zprod_yield INTO wa_zprod_yield WITH KEY matnr = wa_afpo-matnr charg = wa_afpo-charg werks =  wa_afpo-pwerk.
          IF sy-subrc EQ 0.
            sqty1 = wa_zprod_yield-stability + wa_zprod_yield-analytical + wa_zprod_yield-other.
          ENDIF.
          sqty2 = ( sqty1 * lqty3 ) / 1000.
******************************************************
        ENDIF.
      ENDIF.
      IF qty LE 0.
        SELECT SINGLE * FROM marm WHERE matnr EQ wa_afpo-matnr AND meinh EQ 'KG'.
        IF sy-subrc EQ 0.
*          qty = wa_afpo-wemng * marm-umren.
          lqty1 = ( marm-umren * 1000 ) / marm-umrez.
*          if lqty1 gt 10.
*            lqty2 = lqty1 mod 10.
*          endif.
*          lqty3 = lqty1 - lqty2.
          qty = ( wa_afpo-wemng * lqty1 ) / 1000.

***************SAMP QTY*******************
          CLEAR : sqty1,sqty2.
          READ TABLE it_zprod_yield INTO wa_zprod_yield WITH KEY matnr = wa_afpo-matnr charg = wa_afpo-charg werks =  wa_afpo-pwerk.
          IF sy-subrc EQ 0.
            sqty1 = wa_zprod_yield-stability + wa_zprod_yield-analytical + wa_zprod_yield-other.
          ENDIF.
          sqty2 = ( sqty1 * lqty1 ) / 1000.
******************************************************
          liq = 1.
        ENDIF.
      ENDIF.
*      wa_fp1-rqty = qty.
      wa_fp1-rqty = qty + sqty2.
      wa_fp1-sqty = sqty2.
      COLLECT wa_fp1 INTO it_fp1.
      CLEAR wa_fp1.
    ENDIF.
  ENDLOOP.
  LOOP AT it_fp1 INTO wa_fp1.
    wa_fp2-charg = wa_fp1-charg.
    wa_fp2-rqty = wa_fp1-rqty.
    wa_fp2-sqty = wa_fp1-sqty.
    COLLECT wa_fp2 INTO it_fp2.
    CLEAR wa_fp2.
  ENDLOOP.

  LOOP AT it_fp2 INTO wa_fp2.
*    write : / 'FP RECEIVED',wa_fp2-charg,wa_fp2-rqty.
    CLEAR : batchsz.
    LOOP AT it_afpo INTO wa_afpo WHERE charg = wa_fp2-charg AND matnr CS 'H'.
      batchsz = wa_afpo-psmng.
      EXIT.
    ENDLOOP.
********************************
******************* check haln from order**********
    IF batchsz EQ space.
      CLEAR : matnr.
      READ TABLE it_afpo INTO wa_afpo WITH KEY charg = wa_fp2-charg.
      IF sy-subrc EQ 0.
        matnr = wa_afpo-matnr.
      ENDIF.
      SELECT SINGLE * FROM afpo WHERE matnr EQ matnr AND charg EQ wa_fp2-charg AND dnrel NE 'X'.
      IF sy-subrc EQ 0.
        CLEAR : it_resb2, wa_resb2,batchsize,batchsz.
        SELECT * FROM resb INTO TABLE it_resb2 WHERE aufnr EQ afpo-aufnr .
        LOOP AT it_resb2 INTO wa_resb2 WHERE matnr CS 'H'.
          SELECT SINGLE * FROM afpo WHERE matnr EQ wa_resb2-matnr AND charg EQ wa_resb2-charg.
          IF sy-subrc EQ 0.
            batchsize = afpo-psmng.
            batchsz = batchsize.
*          BATCHUT = AFPO-MEINS.
*          CONDENSE : BATCHSZ.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
*************************************
    wa_fp3-charg = wa_fp2-charg.
*    fpper = ( wa_fp2-rqty / batchsz ) * 100.

********************************************************
******************* check haln from order**********
*    IF BATCHSZ EQ SPACE.
*      SELECT SINGLE * FROM AFPO WHERE MATNR EQ MATNR AND CHARG EQ WA_FP2-CHARG AND DNREL NE 'X'.
*      IF SY-SUBRC EQ 0.
*        CLEAR : IT_RESB1, WA_RESB1,BATCHSIZE,BATCHSZ1,BATCHSZ.
*        SELECT * FROM RESB INTO TABLE IT_RESB1 WHERE AUFNR EQ AFPO-AUFNR .
*        LOOP AT IT_RESB1 INTO WA_RESB1 WHERE MATNR CS 'H'.
*          SELECT SINGLE * FROM AFPO WHERE MATNR EQ WA_RESB1-MATNR AND CHARG EQ WA_RESB1-CHARG.
*          IF SY-SUBRC EQ 0.
*            BATCHSIZE = AFPO-PSMNG.
*            BATCHSZ1 = BATCHSIZE.
**          BATCHUT = AFPO-MEINS.
*            CONDENSE : BATCHSZ1.
*            BATCHSZ = BATCHSZ1.
*            EXIT.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
*********************************************************************
***********************************************************
    IF batchsz GT 0.  "added on 17.2.25
      fpper = ( wa_fp2-rqty  / batchsz ) * 100.
    ENDIF.
    wa_fp3-per = fpper.
    wa_fp3-gmnga = wa_fp2-rqty.
    wa_fp3-sqty = wa_fp2-sqty.
    wa_fp3-psmng = batchsz.
    COLLECT wa_fp3 INTO it_fp3.
    CLEAR wa_fp3.
  ENDLOOP.

*  loop at it_fp3 into wa_fp3.
*    write : / 'FP',wa_fp3-charg,wa_fp3-per.
*  endloop.


  LOOP AT it_mat1 INTO wa_mat1.
    CLEAR : per1,per2,per3,per4,per5,per6.
    wa_tab3-charg = wa_mat1-charg.
    wa_tab3-MATNR = wa_mat1-MATNR.
    READ TABLE it_qals INTO wa_qals WITH KEY art = '89' charg = wa_mat1-charg.
    IF sy-subrc EQ 0.
*    write:/'C', wa_tab2-charg, wa_tab2-matnr,wa_tab2-aufnr.
      READ TABLE it_afpo INTO wa_afpo WITH KEY matnr = wa_qals-matnr charg = wa_qals-charg.
      IF sy-subrc EQ 0.
*      write : wa_afpo-psmng.
        per1 = ( wa_qals-losmenge / wa_afpo-psmng ) * 100.
        wa_tab3-per1 = per1.  "89
        wa_tab3-rqty1 = wa_qals-losmenge.
        wa_tab3-aqty1 = wa_afpo-psmng.
      ENDIF.
    ENDIF.

    LOOP AT it_tab2 INTO wa_tab2 WHERE charg = wa_mat1-charg AND matnr CS 'H' AND vornr EQ '0010'.
      READ TABLE it_afpo INTO wa_afpo WITH KEY aufnr = wa_tab2-aufnr.
      IF sy-subrc EQ 0.
        per2 = ( wa_tab2-gmnga / wa_afpo-psmng ) * 100.
*      write : '010',per2.
        wa_tab3-per2 = per2.  " GRANULATION
        wa_tab3-rqty2 = wa_tab2-gmnga.
        wa_tab3-aqty2 = wa_afpo-psmng.
      ENDIF.
    ENDLOOP.
*** SOC by CK on Date 27.11.2025 17:04:17



*** EOC by CK on Date 27.11.2025 17:04:17
********************
    IF per2 EQ 0.
      CLEAR : matnr.
      READ TABLE it_afpo INTO wa_afpo WITH KEY charg = wa_mat1-charg .
      IF sy-subrc EQ 0.
        matnr = wa_afpo-matnr.
      ENDIF.
      SELECT SINGLE * FROM afpo WHERE matnr EQ matnr AND charg EQ wa_mat1-charg  AND dnrel NE 'X'.
      IF sy-subrc EQ 0.
        CLEAR : it_resb2, wa_resb2,order,psmng.
        SELECT * FROM resb INTO TABLE it_resb2 WHERE aufnr EQ afpo-aufnr .
        LOOP AT it_resb2 INTO wa_resb2 WHERE matnr CS 'H'.
          SELECT SINGLE * FROM afpo WHERE matnr EQ wa_resb2-matnr AND charg EQ wa_resb2-charg.
          IF sy-subrc EQ 0.
            order = afpo-aufnr.
            psmng = afpo-psmng.
            EXIT.
          ENDIF.
        ENDLOOP.
        SELECT SINGLE * FROM afru WHERE aufnr EQ order AND vornr EQ '0010'.
        IF sy-subrc EQ 0.
          per2 = ( afru-gmnga / psmng ) * 100.
*      write : '010',per2.
          wa_tab3-per2 = per2.  " GRANULATION
          wa_tab3-rqty2 = afru-gmnga.
          wa_tab3-aqty2 = psmng.
        ENDIF.
      ENDIF.
    ENDIF.
****************
*    if per2 eq 0.
*      CLEAR : matnr.
*      READ TABLE it_afpo INTO wa_afpo with KEY charg = WA_MAT1-CHARG .
*      if sy-subrc eq 0.
*        matnr = wa_afpo-matnr.
*      endif.
*      SELECT SINGLE * FROM AFPO WHERE MATNR EQ MATNR AND CHARG EQ WA_MAT1-CHARG  AND DNREL NE 'X'.
*      IF SY-SUBRC EQ 0.
*        CLEAR : IT_RESB2, WA_RESB2,batchsize,batchsz.
*        SELECT * FROM RESB INTO TABLE IT_RESB2 WHERE AUFNR EQ AFPO-AUFNR .
*        LOOP AT IT_RESB2 INTO WA_RESB2 WHERE MATNR CS 'H'.
*          SELECT SINGLE * FROM AFPO WHERE MATNR EQ WA_RESB2-MATNR AND CHARG EQ WA_RESB2-CHARG.
*          IF SY-SUBRC EQ 0.
*            BATCHSIZE = AFPO-PSMNG.
*            BATCHSZ = BATCHSIZE.
**          BATCHUT = AFPO-MEINS.
**          CONDENSE : BATCHSZ.
*            EXIT.
*          ENDIF.
*        ENDLOOP.
*
*      ENDIF.
*    endif.

    LOOP AT it_tab2 INTO wa_tab2 WHERE charg = wa_mat1-charg AND matnr CS 'H' AND vornr EQ '0020'.
      READ TABLE it_afpo INTO wa_afpo WITH KEY aufnr = wa_tab2-aufnr.
      IF sy-subrc EQ 0.
        per3 = ( wa_tab2-gmnga / wa_afpo-psmng ) * 100.
*      write : '020',per3.
        wa_tab3-per3 = per3.  " COMPRESSION
        wa_tab3-rqty3 = wa_tab2-gmnga.
        wa_tab3-aqty3 = wa_afpo-psmng.
      ENDIF.
    ENDLOOP.


*** SOC by CK on Date 21.11.2025 06:52:22
*    READ TABLE LT_AUFM INTO DATA(LS_AUFM) WITH KEY AUFNR = LS_AFKO-AUFNR.
*    IF SY-SUBRC IS INITIAL.
*      READ TABLE LT_AFPO_1 INTO DATA(LS_AFPO_1)
*            WITH KEY MATNR = LS_AUFM-MATNR
*            CHARG = LS_AUFM-CHARG  .
*      IF SY-SUBRC IS INITIAL.
***********  Bulk Yeild
*        GS_RESULT-BULK_YIELD = ( LS_AFPO_1-WEMNG / LS_AFPO_1-PSMNG ) * 100.
*
*
*
*        READ TABLE LT_AFKO_1 WITH KEY AUFNR = LS_AFPO_1-AUFNR INTO DATA(LS_AFKO_1) .
*        IF SY-SUBRC IS INITIAL.
***********    Compression
*
*          READ TABLE LT_AFRU INTO DATA(LS_AFRU) WITH KEY AUFPL = LS_AFKO_1-AUFPL
*                VORNR = '0020'.
*          IF SY-SUBRC IS INITIAL.
*            IF LS_AFRU-SMENG > 0.
*              GS_RESULT-COMP_YIELD = ( LS_AFRU-GMNGA / LS_AFRU-SMENG ) * 100.
*            ENDIF.
*          ENDIF.
*
***********   Coating
*          READ TABLE LT_AFRU INTO LS_AFRU WITH KEY AUFPL = LS_AFKO_1-AUFPL
*          VORNR = '0040'.
*          IF SY-SUBRC IS INITIAL.
*            IF LS_AFRU-SMENG > 0.
*              GS_RESULT-COAT_YIELD = ( LS_AFRU-GMNGA / LS_AFRU-SMENG ) * 100.
*            ENDIF.
*          ENDIF.
*
**********   Granulation
*          READ TABLE LT_AUFM_1 INTO DATA(LS_AUFM_1) WITH KEY AUFNR = LS_AFKO_1-AUFNR.
*          IF SY-SUBRC IS INITIAL.
*            READ TABLE LT_AFPO_2 INTO DATA(LS_AFPO_2)
*                  WITH KEY MATNR = LS_AUFM_1-MATNR
*                  CHARG = LS_AUFM_1-CHARG  .
*            IF SY-SUBRC IS INITIAL.
**                GS_RESULT-GRAN_YIELD = ( LS_AFPO_2-PSMNG / LS_AFPO_2-WEMNG ) * 100.
*              GS_RESULT-GRAN_YIELD = ( LS_AFPO_2-WEMNG / LS_AFPO_2-PSMNG ) * 100.
*            ENDIF.
*          ENDIF.
*
*        ENDIF.
*
*      ENDIF.
*
*    ENDIF.
*    ENDIF.

*** EOC by CK on Date 21.11.2025 06:52:22
********************
    IF per3 EQ 0.
      CLEAR : matnr.
      READ TABLE it_afpo INTO wa_afpo WITH KEY charg = wa_mat1-charg .
      IF sy-subrc EQ 0.
        matnr = wa_afpo-matnr.
      ENDIF.
      SELECT SINGLE * FROM afpo WHERE matnr EQ matnr AND charg EQ wa_mat1-charg  AND dnrel NE 'X'.
      IF sy-subrc EQ 0.
        CLEAR : it_resb2, wa_resb2,order,psmng.
        SELECT * FROM resb INTO TABLE it_resb2 WHERE aufnr EQ afpo-aufnr .
        LOOP AT it_resb2 INTO wa_resb2 WHERE matnr CS 'H'.
          SELECT SINGLE * FROM afpo WHERE matnr EQ wa_resb2-matnr AND charg EQ wa_resb2-charg.
          IF sy-subrc EQ 0.
            order = afpo-aufnr.
            psmng = afpo-psmng.
            EXIT.
          ENDIF.
        ENDLOOP.
        SELECT SINGLE * FROM afru WHERE aufnr EQ order AND vornr EQ '0020'.
        IF sy-subrc EQ 0.
          per3 = ( afru-gmnga / psmng ) * 100.
*      write : '010',per2.
          wa_tab3-per3 = per3.  " GRANULATION
          wa_tab3-rqty3 = afru-gmnga.
          wa_tab3-aqty3 = psmng.
        ENDIF.
      ENDIF.
    ENDIF.
****************
    LOOP AT it_tab2 INTO wa_tab2 WHERE charg = wa_mat1-charg AND matnr CS 'H' AND vornr EQ '0030'.
      READ TABLE it_afpo INTO wa_afpo WITH KEY aufnr = wa_tab2-aufnr.
      IF sy-subrc EQ 0.
        per4 = ( wa_tab2-gmnga / wa_afpo-psmng ) * 100.
*      write : '030',per4.
        wa_tab3-per4 = per4.  " COATING
        wa_tab3-rqty4 = wa_tab2-gmnga.
        wa_tab3-aqty4 = wa_afpo-psmng.
      ENDIF.
    ENDLOOP.

********************
    IF per4 EQ 0.
      CLEAR : matnr.
      READ TABLE it_afpo INTO wa_afpo WITH KEY charg = wa_mat1-charg .
      IF sy-subrc EQ 0.
        matnr = wa_afpo-matnr.
      ENDIF.
      SELECT SINGLE * FROM afpo WHERE matnr EQ matnr AND charg EQ wa_mat1-charg  AND dnrel NE 'X'.
      IF sy-subrc EQ 0.
        CLEAR : it_resb2, wa_resb2,order,psmng.
        SELECT * FROM resb INTO TABLE it_resb2 WHERE aufnr EQ afpo-aufnr .
        LOOP AT it_resb2 INTO wa_resb2 WHERE matnr CS 'H'.
          SELECT SINGLE * FROM afpo WHERE matnr EQ wa_resb2-matnr AND charg EQ wa_resb2-charg.
          IF sy-subrc EQ 0.
            order = afpo-aufnr.
            psmng = afpo-psmng.
            EXIT.
          ENDIF.
        ENDLOOP.
        SELECT SINGLE * FROM afru WHERE aufnr EQ order AND vornr EQ '0030'.
        IF sy-subrc EQ 0.
          per4 = ( afru-gmnga / psmng ) * 100.
*      write : '010',per2.
          wa_tab3-per4 = per4.  " GRANULATION
          wa_tab3-rqty4 = afru-gmnga.
          wa_tab3-aqty4 = psmng.
        ENDIF.
      ENDIF.
    ENDIF.
****************
*    loop at it_tab2 into wa_tab2 where charg = wa_mat1-charg and matnr na 'H' and vornr eq '0010'.
*      read table it_afpo into wa_afpo with key aufnr = wa_tab2-aufnr.
*      if sy-subrc eq 0.
*        per5 = ( wa_tab2-gmnga / wa_afpo-psmng ) * 100.
**      write : '040',per5.
*        wa_tab3-per5 = per5.  " FP
*        wa_tab3-rqty5 = wa_tab2-gmnga.
*        wa_tab3-aqty5 = wa_afpo-psmng.
*      endif.
*    endloop.
    READ TABLE it_fp3 INTO wa_fp3 WITH KEY charg = wa_mat1-charg.
    IF sy-subrc EQ 0.
      wa_tab3-per5 = wa_fp3-per.
      wa_tab3-rqty5 = wa_fp3-gmnga.
      wa_tab3-aqty5 = wa_fp3-psmng.
      wa_tab3-sqty5 = wa_fp3-sqty.
    ENDIF.

    SELECT SINGLE * FROM zprod_insp_yld WHERE charg EQ wa_tab3-charg.
    IF sy-subrc EQ 0.
      wa_tab3-inspqty = zprod_insp_yld-qty.
*      WA_TAB3-INSPMEINS = ZPROD_INSP_YLD-MEINS.
      LOOP AT it_tab2 INTO wa_tab2 WHERE charg = wa_mat1-charg AND matnr CS 'H' AND vornr EQ '0010'.
        READ TABLE it_afpo INTO wa_afpo WITH KEY aufnr = wa_tab2-aufnr.
        IF sy-subrc EQ 0.
          per6 = ( wa_tab3-inspqty / wa_afpo-psmng ) * 100.
*      write : '010',per2.
          wa_tab3-per6 = per6.  " GRANULATION
*          WA_TAB3-RQTY6 = WA_TAB2-GMNGA.
          wa_tab3-rqty6 = wa_afpo-psmng.
*        WA_TAB3-AQTY2 = WA_AFPO-PSMNG.
        ENDIF.
      ENDLOOP.
    ENDIF.
*************************
    IF per6 EQ 0.
      CLEAR : matnr.
      READ TABLE it_afpo INTO wa_afpo WITH KEY charg = wa_mat1-charg.
      IF sy-subrc EQ 0.
        matnr = wa_afpo-matnr.
      ENDIF.
      SELECT SINGLE * FROM afpo WHERE matnr EQ matnr AND charg EQ wa_mat1-charg  AND dnrel NE 'X'.
      IF sy-subrc EQ 0.
        CLEAR : it_resb2, wa_resb2,order,psmng,charg.
        SELECT * FROM resb INTO TABLE it_resb2 WHERE aufnr EQ afpo-aufnr .
        LOOP AT it_resb2 INTO wa_resb2 WHERE matnr CS 'H'.
          SELECT SINGLE * FROM afpo WHERE matnr EQ wa_resb2-matnr AND charg EQ wa_resb2-charg.
          IF sy-subrc EQ 0.
            order = afpo-aufnr.
            psmng = afpo-psmng.
            charg = afpo-charg.
            EXIT.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM zprod_insp_yld WHERE charg EQ charg.
    IF sy-subrc EQ 0.
      wa_tab3-inspqty = zprod_insp_yld-qty.
*      WA_TAB3-INSPMEINS = ZPROD_INSP_YLD-MEINS.
*      LOOP AT IT_TAB2 INTO WA_TAB2 WHERE CHARG = WA_MAT1-CHARG AND MATNR CS 'H' AND VORNR EQ '0010'.
*        READ TABLE IT_AFPO INTO WA_AFPO WITH KEY AUFNR = WA_TAB2-AUFNR.
*        IF SY-SUBRC EQ 0.
      per6 = ( wa_tab3-inspqty / psmng ) * 100.
*      write : '010',per2.
      wa_tab3-per6 = per6.  " GRANULATION
*          WA_TAB3-RQTY6 = WA_TAB2-GMNGA.
      wa_tab3-rqty6 = psmng.
*        WA_TAB3-AQTY2 = WA_AFPO-PSMNG.
*        ENDIF.
*      ENDLOOP.
    ENDIF.
********************
    COLLECT wa_tab3 INTO it_tab3.
    CLEAR wa_tab3.
  ENDLOOP.

*** SOC by CK on Date 27.11.2025 17:14:23
  "11. Build Final Output

  LOOP AT it_tab3 ASSIGNING FIELD-SYMBOL(<WA3>) .

  LOOP AT LT_AFPO ASSIGNING FIELD-SYMBOL(<FS_AFPO>)
    WHERE MATNR = <WA3>-MATNR AND CHARG = <WA3>-CHARG .

*  DATA(GS_RESULT) = VALUE TY_RESULT( ).
*  wa_tab3-MATNR = <FS_AFPO>-MATNR.
*  wa_tab3-AUFNR = <FS_AFPO>-AUFNR.



  "Order Header
  READ TABLE LT_AFKO WITH KEY AUFNR = <FS_AFPO>-AUFNR INTO DATA(LS_AFKO).
  IF SY-SUBRC = 0.

**********
    READ TABLE LT_AUFM INTO DATA(LS_AUFM) WITH KEY AUFNR = LS_AFKO-AUFNR.
    IF SY-SUBRC IS INITIAL.
      READ TABLE LT_AFPO_1 INTO DATA(LS_AFPO_1)
            WITH KEY MATNR = LS_AUFM-MATNR
            CHARG = LS_AUFM-CHARG  .
      IF SY-SUBRC IS INITIAL.
**********  Bulk Yeild
        <WA3>-PER2 = ( LS_AFPO_1-WEMNG / LS_AFPO_1-PSMNG ) * 100.



        READ TABLE LT_AFKO_1 WITH KEY AUFNR = LS_AFPO_1-AUFNR INTO DATA(LS_AFKO_1) .
        IF SY-SUBRC IS INITIAL.
**********    Compression

          READ TABLE LT_AFRU INTO DATA(LS_AFRU) WITH KEY AUFPL = LS_AFKO_1-AUFPL
                VORNR = '0020'.
          IF SY-SUBRC IS INITIAL.
            IF LS_AFRU-SMENG > 0.
              <WA3>-per3 = ( LS_AFRU-GMNGA / LS_AFRU-SMENG ) * 100.
            ENDIF.
          ENDIF.

**********   Coating
          READ TABLE LT_AFRU INTO LS_AFRU WITH KEY AUFPL = LS_AFKO_1-AUFPL
          VORNR = '0040'.
          IF SY-SUBRC IS INITIAL.
            IF LS_AFRU-SMENG > 0.
              <WA3>-per4 = ( LS_AFRU-GMNGA / LS_AFRU-SMENG ) * 100.
            ENDIF.
          ENDIF.

*********   Granulation
          READ TABLE LT_AUFM_1 INTO DATA(LS_AUFM_1) WITH KEY AUFNR = LS_AFKO_1-AUFNR.
          IF SY-SUBRC IS INITIAL.
            READ TABLE LT_AFPO_2 INTO DATA(LS_AFPO_2)
                  WITH KEY MATNR = LS_AUFM_1-MATNR
                  CHARG = LS_AUFM_1-CHARG  .
            IF SY-SUBRC IS INITIAL.
*                GS_RESULT-GRAN_YIELD = ( LS_AFPO_2-PSMNG / LS_AFPO_2-WEMNG ) * 100.
              <WA3>-per2 = ( LS_AFPO_2-WEMNG / LS_AFPO_2-PSMNG ) * 100.
            ENDIF.
          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.
  ENDIF.
ENDLOOP.
ENDLOOP.
*** EOC by CK on Date 27.11.2025 17:14:23



  IF r1 EQ 'X'.
    PERFORM data1.
  ELSEIF r2 EQ 'X'.
    PERFORM data2.
  ENDIF.
ENDFORM.
