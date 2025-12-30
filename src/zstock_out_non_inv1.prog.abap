*&---------------------------------------------------------------------*
*& Report  ZSTOCK_OUT_NON_INV1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zstock_out_non_inv1_n1.

TABLES : mseg,
         ekkn,
         ekpo,
         ekko,
         makt,
         mara,
         pa0001,
         zpa0001,
         PA0105.
DATA: PERNR TYPE PA0001-PERNR.

DATA: ok_code TYPE ui_func.
DATA: variant TYPE disvariant.
DATA : gr_alvgrid    TYPE REF TO cl_gui_alv_grid,
       gr_ccontainer TYPE REF TO cl_gui_custom_container,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layo       TYPE lvc_s_layo.
DATA: c_alvgd   TYPE REF TO cl_gui_alv_grid.         "ALV grid object
DATA: gstring TYPE c.
*Data declarations for ALV
DATA: c_ccont   TYPE REF TO cl_gui_custom_container,         "Custom container object
*      C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID,         "ALV grid object
      it_fcat   TYPE lvc_t_fcat,                  "Field catalogue
      it_layout TYPE lvc_s_layo.

DATA: it_mseg TYPE TABLE OF mseg,
      wa_mseg TYPE mseg,
      it_mkpf TYPE TABLE OF mkpf,
      wa_mkpf TYPE mkpf,
      it_mchb TYPE TABLE OF mchb,
      wa_mchb TYPE mchb,
      it_mara TYPE TABLE OF mara,
      wa_mara TYPE mara,
      it_ekko TYPE TABLE OF ekko,
      wa_ekko TYPE ekko,
      it_ekpo TYPE TABLE OF ekpo,
      wa_ekpo TYPE ekpo,
      it_mard TYPE TABLE OF mard,
      wa_mard TYPE mard.
TYPES: BEGIN OF disp1,
         matnr     TYPE mchb-matnr,
         werks     TYPE mchb-werks,
         lgort     TYPE mchb-lgort,
         charg     TYPE mchb-charg,
         clabs(10) TYPE c,
         clabs1    TYPE mchb-clabs,
         mblnr     TYPE mseg-mblnr,
         kostl     TYPE mseg-kostl,
         meins     TYPE mseg-meins,
         txz01     TYPE ekpo-txz01,
         bsart     TYPE ekko-bsart,
         ebeln     TYPE ekpo-ebeln,
         ebelp     TYPE ekpo-ebelp,
         chk(1)    TYPE c,
       END OF disp1.
TYPES: BEGIN OF with1,
         matnr TYPE mseg-matnr,
         charg TYPE mseg-charg,
         clabs TYPE mchb-clabs,
         meins TYPE mseg-meins,
         kostl TYPE mseg-kostl,
         werks TYPE mseg-werks,
         lgort TYPE mseg-lgort,
       END OF with1.
DATA: it_disp1 TYPE TABLE OF disp1,
      wa_disp1 TYPE disp1,
      it_with1 TYPE TABLE OF with1,
      wa_with1 TYPE with1.
DATA:
*      goodsmvt_header TYPE BAPI2017_GM_HEAD_RET,
  goodsmvt_code   TYPE bapi2017_gm_code,
  goodsmvt_header TYPE bapi2017_gm_head_01,
  goodsmvt_item   TYPE bapi2017_gm_item_create.
*      goodsmvt_itemt TYPE
DATA: err1 TYPE i.
DATA: goodsmvt_itemt        TYPE STANDARD TABLE OF bapi2017_gm_item_create,
      return                TYPE STANDARD TABLE OF bapiret2,
      goodsmvt_serialnumber TYPE STANDARD TABLE OF bapi2017_gm_serialnumber.

DATA: materialdocument TYPE mkpf-mblnr,
      matdocumentyear  TYPE mkpf-mjahr.
DATA: date1 TYPE sy-datum,
      mjahr TYPE mseg-mjahr.
*SELECTION-SCREEN BEGIN OF BLOCK MERKMALE3 WITH FRAME TITLE TEXT-001.
*PARAMETERS : PERNR    LIKE PA0001-PERNR MATCHCODE OBJECT PREM,
*             PASS(10) TYPE C.
*SELECTION-SCREEN END OF BLOCK MERKMALE3.

SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE TEXT-001.
*SELECT-OPTIONS : MBLNR FOR MSEG-MBLNR,
*BUDAT FOR SY-DATUM.
*CC FOR EKKN-KOSTL.
  SELECT-OPTIONS : matnr FOR mara-matnr.
  PARAMETERS:  werks TYPE mseg-werks.
*PARAMETERS : MJAHR TYPE MKPF-MJAHR .
  PARAMETERS : s1 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK merkmale1.



SELECTION-SCREEN BEGIN OF BLOCK merkmale2 WITH FRAME TITLE TEXT-001.
  PARAMETERS: r1 RADIOBUTTON GROUP r1,
              r2 RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK merkmale2.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK screen-name EQ 'PASS'.
    screen-invisible = 1.
    MODIFY SCREEN.
  ENDLOOP.

START-OF-SELECTION.

SELECT SINGLE * FROM pa0105 WHERE usrid EQ sy-uname.
  IF sy-subrc EQ 0.
    pernr = pa0105-pernr.
  ENDIF.


  date1 = sy-datum - 180.
  mjahr = sy-datum+0(4).
  PERFORM deptchk.
  IF r1 EQ 'X'.
    PERFORM form1.
  ELSEIF r2 EQ 'X'.
    PERFORM form2.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9001 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'TITLE1'.

  PERFORM pbo.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  PBO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pbo .
  CREATE OBJECT gr_alvgrid
    EXPORTING
*     i_parent          = gr_ccontainer
      i_parent          = cl_gui_custom_container=>screen0
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  PERFORM alv_build_fieldcat.


  CALL METHOD gr_alvgrid->set_table_for_first_display
    EXPORTING
*     I_BUFFER_ACTIVE =
*     I_BYPASSING_BUFFER            =
*     I_CONSISTENCY_CHECK           =
*     I_STRUCTURE_NAME              =
      is_variant      = variant
      i_save          = 'A'
*     I_DEFAULT       = 'X'
      is_layout       = gs_layo
*     IS_PRINT        =
*     IT_SPECIAL_GROUPS             =
*     IT_TOOLBAR_EXCLUDING          =
*     IT_HYPERLINK    =
*     IT_ALV_GRAPHICS =
*     IT_EXCEPT_QINFO =
*     IR_SALV_ADAPTER =
    CHANGING
      it_outtab       = it_disp1
      it_fieldcatalog = it_fcat
*     IT_SORT         =
*     IT_FILTER       =
*      EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1
*     PROGRAM_ERROR   = 2
*     TOO_MANY_LINES  = 3
*     others          = 4
    .
  IF sy-subrc <> 0.
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
FORM alv_build_fieldcat .
  DATA lv_fldcat TYPE lvc_s_fcat.


*  LV_FLDCAT-FIELDNAME = 'MBLNR'.
*  LV_FLDCAT-SCRTEXT_M = 'GRN No.'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.

  lv_fldcat-fieldname = 'WERKS'.
  lv_fldcat-scrtext_m = 'Plant'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

*  LV_FLDCAT-FIELDNAME = 'EBELN'.
*  LV_FLDCAT-SCRTEXT_M = 'PO No.'.
*  LV_FLDCAT-OUTPUTLEN = 25.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
**
*  LV_FLDCAT-FIELDNAME = 'EBELP'.
*  LV_FLDCAT-SCRTEXT_M = 'PDO Item no.'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.
*
*  LV_FLDCAT-FIELDNAME = 'BSART'.
*  LV_FLDCAT-SCRTEXT_M = 'PO Type'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.



  lv_fldcat-fieldname = 'MATNR'.
  lv_fldcat-scrtext_m = 'Material Code'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'TXZ01'.
  lv_fldcat-scrtext_m = 'Material Description'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CHARG'.
  lv_fldcat-scrtext_m = 'Batch'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'MEINS'.
  lv_fldcat-scrtext_m = 'UOM'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'CLABS1'.
  lv_fldcat-scrtext_m = 'Available Stock'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CLABS'.
  lv_fldcat-scrtext_m = 'Withdraw Stock'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'KOSTL'.
  lv_fldcat-scrtext_m = 'Cost Center'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'CHK'.
  lv_fldcat-scrtext_m = 'Select to Withdraw'.
  lv_fldcat-edit = 'X'.
  lv_fldcat-checkbox = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.
  gr_alvgrid->check_changed_data( ).
  CASE ok_code.
    WHEN 'SAVE'.
      PERFORM withdraw1.
      LEAVE TO SCREEN 0.
    WHEN 'BACK' OR 'EXIT'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'OTHERS'.
      LEAVE PROGRAM.
  ENDCASE.
  CLEAR : sy-ucomm.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  WITHDRAW1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM withdraw1 .
*  BREAK-POINT.
  CLEAR err1.
  LOOP AT it_disp1 INTO wa_disp1 WHERE matnr GT 0 AND chk NE space.
    CLEAR : err1.
    wa_with1-matnr = wa_disp1-matnr.
    wa_with1-charg = wa_disp1-charg.
    IF wa_disp1-clabs GT wa_disp1-clabs1.
      err1 = 1.
      MESSAGE 'CHECK QUANTITY' TYPE 'E'.
    ENDIF.
    wa_with1-clabs = wa_disp1-clabs.
    wa_with1-meins = wa_disp1-meins.
    wa_with1-kostl = wa_disp1-kostl.
    wa_with1-werks = wa_disp1-werks.
    wa_with1-lgort = wa_disp1-lgort.
    COLLECT wa_with1 INTO it_with1.
    CLEAR wa_with1.
  ENDLOOP.


*  ******BAPI TO POST***********************

  IF err1 NE 1.
    " Set GM_CODE
    goodsmvt_code-gm_code = '03'  . " Withdrawal

    " Set Header Line
    goodsmvt_header-pstng_date = sy-datum .
    goodsmvt_header-doc_date   = sy-datum.
    goodsmvt_header-header_txt = 'ISSUANCE FROM STORE DEPT.'.  "header_txt. "# a description as input
    goodsmvt_header-pr_uname   = sy-uname .
    IF r1 EQ 'X'.
      LOOP AT it_with1 INTO wa_with1.
        goodsmvt_item-material   = wa_with1-matnr.
        goodsmvt_item-plant      = wa_with1-werks.  "p_werks_out .
        goodsmvt_item-stge_loc   = wa_with1-lgort.  "p_lgort_out.
        goodsmvt_item-batch   = wa_with1-charg.  "p_lgort_out.
        goodsmvt_item-move_type  = '201' .
        goodsmvt_item-costcenter = wa_with1-kostl.
        goodsmvt_item-gl_account = '0000040300'. "" '0000004030'  added by rushi 25.09.25
        goodsmvt_item-entry_qnt  = wa_with1-clabs."p_qty . "# Set your quantity
        goodsmvt_item-move_plant = wa_with1-werks.  "p_werks_in.
        goodsmvt_item-move_stloc = wa_with1-lgort.  "p_lgort_in.
        goodsmvt_item-mvt_ind    = '' .
        APPEND goodsmvt_item TO goodsmvt_itemt.
      ENDLOOP.
    ELSE.
      LOOP AT it_with1 INTO wa_with1.
        goodsmvt_item-material   = wa_with1-matnr.
        goodsmvt_item-plant      = wa_with1-werks.  "p_werks_out .
        goodsmvt_item-stge_loc   = wa_with1-lgort.  "p_lgort_out.
*    GOODSMVT_ITEM-BATCH   = WA_WITH1-CHARG.  "p_lgort_out.
        goodsmvt_item-move_type  = '201' .
        goodsmvt_item-costcenter = wa_with1-kostl.
        goodsmvt_item-gl_account = '0000040300'. "" '0000004030'  added by rushi 25.09.25
        goodsmvt_item-entry_qnt  = wa_with1-clabs."p_qty . "# Set your quantity
        goodsmvt_item-move_plant = wa_with1-werks.  "p_werks_in.
        goodsmvt_item-move_stloc = wa_with1-lgort.  "p_lgort_in.
        goodsmvt_item-mvt_ind    = '' .
        APPEND goodsmvt_item TO goodsmvt_itemt.
      ENDLOOP.
    ENDIF.
    " Call Good Movement Creation BAPI
    CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
      EXPORTING
        goodsmvt_header       = goodsmvt_header
        goodsmvt_code         = goodsmvt_code
*       testrun               = p_testrun "# 'X' "testrun
      IMPORTING
        materialdocument      = materialdocument
        matdocumentyear       = matdocumentyear
      TABLES
        goodsmvt_item         = goodsmvt_itemt
        goodsmvt_serialnumber = goodsmvt_serialnumber
        return                = return.
*  BREAK-POINT.
    IF return[] IS INITIAL .
*    and p_testrun EQ ' '.
      " commit Transaction
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ELSE.
*    " Error -> Roll Back
*    call function 'BAPI_TRANSACTION_ROLLBACK'
    ENDIF.

    CLEAR : goodsmvt_itemt,goodsmvt_serialnumber,goodsmvt_header.
    CLEAR : it_disp1,wa_disp1,it_with1,wa_with1.

*  WRITE : / 'MATERIAL DOCUMENT IS POSTED',MATERIALDOCUMENT.
    IF materialdocument GT 0.
      MESSAGE s536(0u) WITH materialdocument.
    ENDIF.
  ENDIF.
  LEAVE TO SCREEN 0.
  EXIT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form1 .
  SELECT * FROM mara INTO TABLE it_mara WHERE matnr IN matnr AND mtart IN ('ZRQC','ZNBW','ZDSI').
  IF sy-subrc EQ 0.
    SELECT * FROM mchb INTO TABLE it_mchb FOR ALL ENTRIES IN it_mara WHERE matnr EQ it_mara-matnr AND werks EQ werks AND clabs GT 0.

  ENDIF.
  SELECT * FROM mkpf INTO TABLE it_mkpf WHERE mjahr EQ mjahr AND budat GE date1.
  IF sy-subrc EQ 0.
    SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_mkpf WHERE mblnr EQ it_mkpf-mblnr AND mjahr EQ mjahr AND werks EQ werks AND
       kostl NE space AND lifnr GT 0.
  ENDIF.

*  ENDIF.
*  IF IT_MSEG IS NOT INITIAL.
*    SELECT * FROM EKKO INTO TABLE IT_EKKO FOR ALL ENTRIES IN IT_MSEG WHERE EBELN EQ IT_MSEG-EBELN.
*    IF SY-SUBRC EQ 0.
*      SELECT * FROM EKPO INTO TABLE IT_EKPO FOR ALL ENTRIES IN IT_EKKO WHERE EBELN EQ IT_EKKO-EBELN.
*    ENDIF.
*  ENDIF.
  SORT it_mseg DESCENDING BY budat_mkpf.
  DELETE it_mchb WHERE matnr EQ '000000000000400000'.
  LOOP AT it_mchb INTO wa_mchb.
    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_mchb-matnr.
    IF sy-subrc EQ 0.
      wa_disp1-matnr = wa_mchb-matnr.
      wa_disp1-werks = wa_mchb-werks.
      wa_disp1-lgort = wa_mchb-lgort.
      wa_disp1-charg = wa_mchb-charg.
      wa_disp1-clabs = wa_mchb-clabs.
      wa_disp1-clabs1 = wa_mchb-clabs.
      IF werks EQ '1000'.
        wa_disp1-kostl = '10S'.
      ELSEIF werks EQ '1001'.
        wa_disp1-kostl = '30S'.
      ENDIF.
      READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = wa_mchb-matnr charg = wa_mchb-charg werks = wa_mchb-werks .
      IF sy-subrc EQ 0.
*        WA_DISP1-MBLNR = WA_MSEG-MBLNR.
*        WA_DISP1-KOSTL = WA_MSEG-KOSTL.
        wa_disp1-meins = wa_mseg-meins.
        SELECT SINGLE * FROM ekpo WHERE  ebeln = wa_mseg-ebeln AND ebelp = wa_mseg-ebelp.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_mseg-ebeln.
          IF sy-subrc EQ 0.
*            WA_DISP1-EBELN = EKPO-EBELN.
*            WA_DISP1-EBELP = EKPO-EBELP.
*            WA_DISP1-BSART = EKKO-BSART.
            wa_disp1-txz01 = ekpo-txz01.
          ENDIF.
        ENDIF.
      ENDIF.
      IF wa_disp1-txz01 EQ space.
        SELECT SINGLE * FROM makt WHERE matnr EQ wa_mchb-matnr AND spras EQ 'EN'.
        IF sy-subrc EQ 0.
          wa_disp1-txz01 = makt-maktx.
        ENDIF.
      ENDIF.
      IF wa_disp1-kostl EQ space.
        SELECT SINGLE * FROM mseg WHERE bwart EQ '101' AND matnr = wa_mchb-matnr AND charg = wa_mchb-charg AND werks = wa_mchb-werks AND kostl NE space..
        IF sy-subrc EQ 0.
          wa_disp1-kostl = mseg-kostl.
        ENDIF.
      ENDIF.
      IF s1 EQ 'X'.
        wa_disp1-chk = 'X'.
      ENDIF.
      CONDENSE wa_disp1-clabs.
      COLLECT wa_disp1 INTO it_disp1.
      CLEAR wa_disp1.
    ENDIF.
  ENDLOOP.
  SORT it_disp1 BY matnr charg.
  CALL SCREEN 9001.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form2 .
  SELECT * FROM mara INTO TABLE it_mara WHERE matnr IN matnr AND mtart IN ('ZRQC','ZNBW','ZDSI').
  IF sy-subrc EQ 0.
    SELECT * FROM mard INTO TABLE it_mard FOR ALL ENTRIES IN it_mara WHERE matnr EQ it_mara-matnr AND werks EQ werks AND labst GT 0.
    SELECT * FROM mchb INTO TABLE it_mchb FOR ALL ENTRIES IN it_mara WHERE matnr EQ it_mara-matnr AND werks EQ werks AND clabs GT 0.
  ENDIF.
  SELECT * FROM mkpf INTO TABLE it_mkpf WHERE mjahr EQ mjahr AND budat GE date1.
  IF sy-subrc EQ 0.
    SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_mkpf WHERE mblnr EQ it_mkpf-mblnr AND mjahr EQ mjahr AND werks EQ werks AND
       kostl NE space AND lifnr GT 0.
  ENDIF.

*  ENDIF.
*  IF IT_MSEG IS NOT INITIAL.
*    SELECT * FROM EKKO INTO TABLE IT_EKKO FOR ALL ENTRIES IN IT_MSEG WHERE EBELN EQ IT_MSEG-EBELN.
*    IF SY-SUBRC EQ 0.
*      SELECT * FROM EKPO INTO TABLE IT_EKPO FOR ALL ENTRIES IN IT_EKKO WHERE EBELN EQ IT_EKKO-EBELN.
*    ENDIF.
*  ENDIF.
  SORT it_mseg DESCENDING BY budat_mkpf.
  DELETE it_mard WHERE matnr EQ '000000000000400000'.
  LOOP AT it_mard INTO wa_mard.
    READ TABLE it_mchb INTO wa_mchb WITH KEY matnr = wa_mard-matnr werks = wa_mard-werks.
    IF sy-subrc EQ 4.
      READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_mard-matnr.
      IF sy-subrc EQ 0.
        wa_disp1-matnr = wa_mard-matnr.
        wa_disp1-werks = wa_mard-werks.
        wa_disp1-lgort = wa_mard-lgort.
*      WA_DISP1-CHARG = WA_MARD-CHARG.
        wa_disp1-clabs = wa_mard-labst.
        wa_disp1-clabs1 = wa_mard-labst.
        IF werks EQ '1000'.
          wa_disp1-kostl = '10S'.
        ELSEIF werks EQ '1001'.
          wa_disp1-kostl = '30S'.
        ENDIF.
        READ TABLE it_mseg INTO wa_mseg WITH KEY matnr = wa_mard-matnr werks = wa_mard-werks .
        IF sy-subrc EQ 0.
*        WA_DISP1-MBLNR = WA_MSEG-MBLNR.
*          WA_DISP1-KOSTL = WA_MSEG-KOSTL.
          wa_disp1-meins = wa_mseg-meins.
          SELECT SINGLE * FROM ekpo WHERE  ebeln = wa_mseg-ebeln AND ebelp = wa_mseg-ebelp.
          IF sy-subrc EQ 0.
            SELECT SINGLE * FROM ekko WHERE ebeln EQ wa_mseg-ebeln.
            IF sy-subrc EQ 0.
*            WA_DISP1-EBELN = EKPO-EBELN.
*            WA_DISP1-EBELP = EKPO-EBELP.
*            WA_DISP1-BSART = EKKO-BSART.
              wa_disp1-txz01 = ekpo-txz01.
            ENDIF.
          ENDIF.
        ENDIF.
        IF wa_disp1-txz01 EQ space.
          SELECT SINGLE * FROM makt WHERE matnr EQ wa_mard-matnr AND spras EQ 'EN'.
          IF sy-subrc EQ 0.
            wa_disp1-txz01 = makt-maktx.
          ENDIF.
        ENDIF.
        IF wa_disp1-kostl EQ space.
          SELECT SINGLE * FROM mseg WHERE bwart EQ '101' AND matnr = wa_mard-matnr AND werks = wa_mard-werks AND kostl NE space..
          IF sy-subrc EQ 0.
            wa_disp1-kostl = mseg-kostl.
          ENDIF.
        ENDIF.
        IF s1 EQ 'X'.
          wa_disp1-chk = 'X'.
        ENDIF.
        COLLECT wa_disp1 INTO it_disp1.
        CLEAR wa_disp1.
      ENDIF.
    ENDIF.
  ENDLOOP.

  SORT it_disp1 BY matnr charg.
  CALL SCREEN 9001.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DEPTCHK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM deptchk .
  CLEAR : err1.
  IF werks EQ '1000' OR werks EQ '1001'.
    err1 = 1.
  ENDIF.
  IF werks EQ '1000'.
    SELECT SINGLE * FROM zPA0001 WHERE PERNR EQ PERNR AND btrtl EQ '1222' AND endda GE sy-datum."PERNR EQ PERNR AND BTRTL EQ '1222' AND ENDDA GE SY-DATUM. ""RN
    IF sy-subrc EQ 0.
      err1 = 0.
    ENDIF.
  ELSEIF werks EQ '1001'.
    SELECT SINGLE * FROM zPA0001 WHERE PERNR EQ PERNR AND btrtl EQ '1322' AND endda GE sy-datum.""PERNR EQ PERNR AND BTRTL EQ '1322' AND ENDDA GE SY-DATUM. ""RN
    IF sy-subrc EQ 0.
      err1 = 0.
    ENDIF.
  ENDIF.

  IF err1 EQ 1.
    MESSAGE 'ONLY STORE DEPARTMENT IS ALLOWED FOR WITHDRAWAL' TYPE 'E'.
  ENDIF.

ENDFORM.
