*&---------------------------------------------------------------------*
*& Report  ZBCLL_COSTING_APPR_REPORT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zbcll_costing_appr_report_1 NO STANDARD PAGE HEADING LINE-SIZE 600.

CLASS lcl_event_handler DEFINITION .
  PUBLIC SECTION .
    METHODS:

*--Double-click control
      handle_double_click
                  FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no.

  PRIVATE SECTION.
ENDCLASS.                    "lcl_event_handler DEFINITION

CLASS lcl_event_handler IMPLEMENTATION .


*--Handle Double Click
  METHOD handle_double_click .
    PERFORM handle_double_click USING e_row e_column es_row_no .
  ENDMETHOD .                    "handle_double_click

ENDCLASS .                    "lcl_event_handler IMPLEMENTATION

TABLES : ztp_cost11,
         mara,
         lfa1,
         pa0001,
         makt,
         ztp_cost14,
         ztp_cost15.

TYPE-POOLS : slis.
DATA lv_fldcat TYPE lvc_s_fcat.
DATA:
  ok_code       TYPE ui_func.
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

DATA gr_event_handler TYPE REF TO lcl_event_handler .


DATA : it_ztp_cost11 TYPE TABLE OF ztp_cost11,
       wa_ztp_cost11 TYPE ztp_cost11,
       it_ztp_cost14 TYPE TABLE OF ztp_cost14,
       wa_ztp_cost14 TYPE ztp_cost14.
TYPES: BEGIN OF dis1,
         vbeln           TYPE ztp_cost11-vbeln,
         gjahr           TYPE ztp_cost11-gjahr,
         matnr           TYPE ztp_cost11-matnr,
         maktx           TYPE makt-maktx,
         werks           TYPE ztp_cost11-werks,
         stlal           TYPE ztp_cost11-stlal,
         fglifnr         TYPE ztp_cost11-fglifnr,
         fgname1         TYPE lfa1-name1,
         r2              TYPE ztp_cost11-r2,
         p2              TYPE ztp_cost11-p2,
         rp1             TYPE ztp_cost11-rp1,
         m1              TYPE ztp_cost11-m1,
         ccpc            TYPE ztp_cost11-ccpc,
         anaval          TYPE ztp_cost11-anaval,
         anart           TYPE ztp_cost11-anart,
         gstval1         TYPE ztp_cost11-gstval1,
         net             TYPE ztp_cost11-net,
         margin          TYPE ztp_cost11-margin,
         fggst           TYPE ztp_cost11-fggst,
         bmeng           TYPE ztp_cost11-bmeng,
         batsz           TYPE ztp_cost11-batsz,
         rmyld           TYPE ztp_cost11-rmyld,
         pmyld           TYPE ztp_cost11-pmyld,
         cpudt           TYPE ztp_cost11-cpudt,
         uname           TYPE ztp_cost11-uname,
         uzeit           TYPE ztp_cost11-uzeit,

         prodstatus(10)  TYPE c,
         proddt          TYPE sy-datum,
         prodtm          TYPE sy-uzeit,
         prodname        TYPE pa0001-ename,

         purstatus(10)   TYPE c,
         purdt           TYPE sy-datum,
         purtm           TYPE sy-uzeit,
         purname         TYPE pa0001-ename,

         acctstatus(10)  TYPE c,
         acctdt          TYPE sy-datum,
         accttm          TYPE sy-uzeit,
         acctname        TYPE pa0001-ename,

         fistatus(10)    TYPE c,
         fidt            TYPE sy-datum,
         fitm            TYPE sy-uzeit,
         finame          TYPE pa0001-ename,

         finalstatus(10) TYPE c,
         finaldt         TYPE sy-datum,
         finaltm         TYPE sy-uzeit,
         finalname       TYPE pa0001-ename,
         status(10)      TYPE c,

       END OF dis1.
DATA: ls_variant-report  TYPE disvariant.
DATA: it_dis1 TYPE TABLE OF dis1,
      wa_dis1 TYPE dis1.

SELECTION-SCREEN BEGIN OF BLOCK merkmale3 WITH FRAME TITLE text-001.
SELECT-OPTIONS : matnr FOR mara-matnr,
                 fglifnr FOR lfa1-lifnr,
                 s_budat FOR sy-datum.
SELECT-OPTIONS : vbeln FOR ztp_cost11-vbeln MATCHCODE OBJECT ztp_cost1.
PARAMETERS :   gjahr(4) TYPE c OBLIGATORY.
SELECTION-SCREEN END OF BLOCK merkmale3.


SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE text-001.
PARAMETERS : r1 RADIOBUTTON GROUP r1, "prod
             r2 RADIOBUTTON GROUP r1, "Purchase
             r3 RADIOBUTTON GROUP r1,  "Accounts
             r4 RADIOBUTTON GROUP r1, "FI,
             r5 RADIOBUTTON GROUP r1, "final approval
             r6 RADIOBUTTON GROUP r1,
             r7 RADIOBUTTON GROUP r1.

SELECTION-SCREEN END OF BLOCK merkmale1.

INITIALIZATION.
*  G_REPID = SY-REPID.
  ls_variant-report = sy-repid.   "6.6.22

START-OF-SELECTION.
  CREATE OBJECT gr_event_handler .

  IF r1 EQ 'X'.
    PERFORM all.
  ELSEIF r2 EQ 'X'.
    PERFORM prodpen.
  ELSEIF r3 EQ 'X' OR r4 EQ 'X' OR r5 EQ 'X' OR r6 EQ 'X' OR r7 EQ 'X'.
    PERFORM purpen.
*  elseif r3 eq 'X'.
*    perform ACCTpen.
  ENDIF.

  CALL SCREEN 0100.
*&---------------------------------------------------------------------*
*&      Form  ALL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM all .
  CLEAR : it_ztp_cost11,wa_ztp_cost11.

  SELECT * FROM ztp_cost11 INTO TABLE it_ztp_cost11 WHERE gjahr EQ gjahr AND vbeln IN vbeln AND matnr IN matnr AND fglifnr IN fglifnr AND cpudt IN s_budat.
  IF it_ztp_cost11 IS INITIAL.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.
  IF it_ztp_cost11 IS NOT INITIAL.
    SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 FOR ALL ENTRIES IN it_ztp_cost11 WHERE gjahr EQ it_ztp_cost11-gjahr AND vbeln EQ it_ztp_cost11-vbeln.
  ENDIF.

  LOOP AT it_ztp_cost11 INTO wa_ztp_cost11.
    wa_dis1-vbeln = wa_ztp_cost11-vbeln.
    wa_dis1-gjahr = wa_ztp_cost11-gjahr.
    wa_dis1-matnr = wa_ztp_cost11-matnr.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_ztp_cost11-matnr AND spras EQ 'EN'.
    IF sy-subrc EQ 0.
      wa_dis1-maktx = makt-maktx.
    ENDIF.
    wa_dis1-werks = wa_ztp_cost11-werks.
    wa_dis1-stlal = wa_ztp_cost11-stlal.
    wa_dis1-fglifnr = wa_ztp_cost11-fglifnr.
    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_ztp_cost11-fglifnr.
    IF sy-subrc EQ 0.
      wa_dis1-fgname1 = lfa1-name1.
    ENDIF.
    wa_dis1-r2 = wa_ztp_cost11-r2.
    wa_dis1-p2 = wa_ztp_cost11-p2.
    wa_dis1-rp1 = wa_ztp_cost11-rp1.
    wa_dis1-m1 = wa_ztp_cost11-m1.
    wa_dis1-ccpc = wa_ztp_cost11-ccpc.
    wa_dis1-anaval = wa_ztp_cost11-anaval.
    wa_dis1-anart = wa_ztp_cost11-anart.
    wa_dis1-gstval1 = wa_ztp_cost11-gstval1.
    wa_dis1-net = wa_ztp_cost11-net.
    wa_dis1-margin = wa_ztp_cost11-margin.
    wa_dis1-fggst = wa_ztp_cost11-fggst.
    wa_dis1-bmeng = wa_ztp_cost11-bmeng.
    wa_dis1-batsz = wa_ztp_cost11-batsz.
    wa_dis1-rmyld = wa_ztp_cost11-rmyld.
    wa_dis1-pmyld = wa_ztp_cost11-pmyld.
    wa_dis1-cpudt = wa_ztp_cost11-cpudt.
    wa_dis1-uname = wa_ztp_cost11-uname.
    wa_dis1-uzeit = wa_ztp_cost11-uzeit.


    READ TABLE it_ztp_cost14 INTO wa_ztp_cost14 WITH KEY gjahr = wa_ztp_cost11-gjahr vbeln = wa_ztp_cost11-vbeln.
    IF sy-subrc EQ 0.

**********************************************************************************************************
      IF wa_ztp_cost14-prodapr EQ 'X'.
        wa_dis1-prodstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-prodrej EQ 'X'.
        wa_dis1-prodstatus = 'REJECTED'.
      ELSE.
        wa_dis1-prodstatus = space.
      ENDIF.
      wa_dis1-proddt = wa_ztp_cost14-proddt.
      wa_dis1-prodtm = wa_ztp_cost14-prodtm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-prodname = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-purapr EQ 'X'.
        wa_dis1-purstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-purrej EQ 'X'.
        wa_dis1-purstatus = 'REJECTED'.
      ELSE.
        wa_dis1-purstatus = space.
      ENDIF.
      wa_dis1-purdt = wa_ztp_cost14-purdt.
      wa_dis1-purtm = wa_ztp_cost14-purtm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-purname = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-acctapr EQ 'X'.
        wa_dis1-acctstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-acctrej EQ 'X'.
        wa_dis1-acctstatus = 'REJECTED'.
      ELSE.
        wa_dis1-acctstatus = space.
      ENDIF.
      wa_dis1-acctdt = wa_ztp_cost14-acctdt.
      wa_dis1-accttm = wa_ztp_cost14-accttm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-acctname = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-fiapr EQ 'X'.
        wa_dis1-fistatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-firej EQ 'X'.
        wa_dis1-fistatus = 'REJECTED'.
      ELSE.
        wa_dis1-fistatus = space.
      ENDIF.
      wa_dis1-fidt = wa_ztp_cost14-fidt.
      wa_dis1-fitm = wa_ztp_cost14-fitm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-finame = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-finalapr EQ 'X'.
        wa_dis1-finalstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-finalrej EQ 'X'.
        wa_dis1-finalstatus = 'REJECTED'.
      ELSE.
        wa_dis1-finalstatus = space.
      ENDIF.
      wa_dis1-finaldt = wa_ztp_cost14-finaldt.
      wa_dis1-finaltm = wa_ztp_cost14-finaltm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-finalname = pa0001-ename.
      ENDIF.
****************************************************************************************************
    ENDIF.
    SELECT SINGLE * FROM ztp_cost15 WHERE gjahr EQ wa_ztp_cost11-gjahr AND vbeln EQ wa_ztp_cost11-vbeln.
    IF sy-subrc EQ 0.
      wa_dis1-status = 'REJECTED'.
    ENDIF.

    COLLECT wa_dis1 INTO it_dis1.
    CLEAR wa_dis1.

  ENDLOOP.

  LOOP AT it_dis1 INTO wa_dis1.
    PACK wa_dis1-matnr TO wa_dis1-matnr.
    PACK wa_dis1-vbeln TO wa_dis1-vbeln.
    PACK wa_dis1-fglifnr TO wa_dis1-fglifnr.
    CONDENSE:  wa_dis1-matnr,wa_dis1-vbeln,wa_dis1-fglifnr.
    MODIFY it_dis1 FROM wa_dis1 TRANSPORTING matnr vbeln fglifnr.
  ENDLOOP.


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
FORM handle_double_click USING i_row TYPE lvc_s_row
                               i_column TYPE lvc_s_col
                               is_row_no TYPE lvc_s_roid.

  READ TABLE it_dis1 INTO wa_dis1 INDEX is_row_no-row_id .

  IF sy-subrc = 0 .
    IF i_column = 'MATNR'.
*      t_mat = wa_RPM7-MBLNR.
*      PERFORM update.
*      SET PARAMETER ID 'MBN' FIELD t_mat.
      SET PARAMETER ID 'MAT' FIELD wa_dis1-matnr.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
      SET PARAMETER ID 'MAT' FIELD space.

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
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'TITLE'.
  PERFORM pbo.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
*        LEAVE PROGRAM.
      LEAVE TO SCREEN 0.
  ENDCASE.
  CLEAR: ok_code.
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

  DATA lv_fldcat TYPE lvc_s_fcat.
*  IF R2 EQ 'X' OR R21 EQ 'X'.
  PERFORM alv_build_fieldcat1.

* Set ALV attributes FOR LAYOUT
  PERFORM alv_report_layout.
  CHECK NOT c_alvgd IS INITIAL.


  CHECK NOT c_alvgd IS INITIAL.
  CALL METHOD c_alvgd->set_table_for_first_display
    EXPORTING
*     IS_LAYOUT                     = IT_LAYOUT
*     I_SAVE                        = 'A'
*     is_callback_user_command      = 'USER_COMM'
      is_layout                     = it_layout
      is_variant                    = ls_variant-report
      i_save                        = 'A'
    CHANGING
      it_outtab                     = it_dis1
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
  SET HANDLER gr_event_handler->handle_double_click FOR c_alvgd .

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

  lv_fldcat-fieldname = 'VBELN'.
  lv_fldcat-scrtext_l = 'COSTSHEET NO.'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'GJAHR'.
  lv_fldcat-scrtext_l = 'F.YEARR'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'STATUS'.
  lv_fldcat-scrtext_l = 'COSTSHEET STATUS'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'MATNR'.
  lv_fldcat-scrtext_l = 'PRODUCT CODE'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'MAKTX'.
  lv_fldcat-scrtext_l = 'PRODUCT NAME'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'WERKS'.
  lv_fldcat-scrtext_l = 'PLANT'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'STLAL'.
  lv_fldcat-scrtext_l = 'BOM NO.'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

*  lv_fldcat-fieldname = 'LIFNR'.
*  lv_fldcat-scrtext_l = 'MFG CODE'.
*  APPEND lv_fldcat TO it_fcat.
*  CLEAR lv_fldcat.
*
*    lv_fldcat-fieldname = 'NAME1'.
*  lv_fldcat-scrtext_l = 'MANUFACTURER NAME'.
*  APPEND lv_fldcat TO it_fcat.
*  CLEAR lv_fldcat.

 lv_fldcat-fieldname = 'FGLIFNR'.
  lv_fldcat-scrtext_l = 'MFG CODE1'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


 lv_fldcat-fieldname = 'FGNAME1'.
  lv_fldcat-scrtext_l = 'MANUFACTURER NAME1'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'R2'.
  lv_fldcat-scrtext_l = 'RM RATE'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'P2'.
  lv_fldcat-scrtext_l = 'PM RATE'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'RP1'.
  lv_fldcat-scrtext_l = 'RM + PM RATE'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'MARGIN'.
  lv_fldcat-scrtext_l = 'MARGIN AT RATE '.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'M1'.
  lv_fldcat-scrtext_l = 'MARGIN CHARGE'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CCPC'.
  lv_fldcat-scrtext_l = 'CCPC'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ANAVAL'.
  lv_fldcat-scrtext_l = 'ANALYTICAL ON'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ANART'.
  lv_fldcat-scrtext_l = 'ANALYTICAL CHARGES'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'GSTVAL1'.
  lv_fldcat-scrtext_l = 'GST VALUE'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'NET'.
  lv_fldcat-scrtext_l = 'NET RATE'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'BATSZ'.
  lv_fldcat-scrtext_l = 'BATCH SIZE'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'BMENG'.
  lv_fldcat-scrtext_l = 'THEOR. QTY'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'RMYLD'.
  lv_fldcat-scrtext_l = 'RM YIELD'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PMYLD'.
  lv_fldcat-scrtext_l = 'PM YIELD'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'CPUDT'.
  lv_fldcat-scrtext_l = 'CREATED ON'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'UNAME'.
  lv_fldcat-scrtext_l = 'CREATED BY'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'UZEIT'.
  lv_fldcat-scrtext_l = 'CREATED TM'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


**********************************************************************
  lv_fldcat-fieldname = 'PRODSTATUS'.
  lv_fldcat-scrtext_l = 'PROD. STATUS'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PRODNAME'.
  lv_fldcat-scrtext_l = 'PROD. UPD BY'.
  lv_fldcat-outputlen = '20'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PRODDT'.
  lv_fldcat-scrtext_l = 'PROD. UPD DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PRODTM'.
  lv_fldcat-scrtext_l = 'PROD. UPD TIME'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

**********************************************************************
  lv_fldcat-fieldname = 'PURSTATUS'.
  lv_fldcat-scrtext_l = 'PUR. STATUS'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PURNAME'.
  lv_fldcat-scrtext_l = 'PUR. UPD BY'.
  lv_fldcat-outputlen = '20'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PURDT'.
  lv_fldcat-scrtext_l = 'PUR. UPD DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PURTM'.
  lv_fldcat-scrtext_l = 'PUR. UPD TIME'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

**********************************************************************
  lv_fldcat-fieldname = 'ACCTSTATUS'.
  lv_fldcat-scrtext_l = 'ACCT. STATUS'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ACCTNAME'.
  lv_fldcat-scrtext_l = 'ACCT. UPD BY'.
  lv_fldcat-outputlen = '20'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ACCTDT'.
  lv_fldcat-scrtext_l = 'ACCT. UPD DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ACCTTM'.
  lv_fldcat-scrtext_l = 'ACCT. UPD TIME'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

**********************************************************************
  lv_fldcat-fieldname = 'FISTATUS'.
  lv_fldcat-scrtext_l = 'FI. STATUS'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FINAME'.
  lv_fldcat-scrtext_l = 'FI. UPD BY'.
  lv_fldcat-outputlen = '20'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FIDT'.
  lv_fldcat-scrtext_l = 'FI. UPD DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FITM'.
  lv_fldcat-scrtext_l = 'FI. UPD TIME'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

**********************************************************************
  lv_fldcat-fieldname = 'FINALSTATUS'.
  lv_fldcat-scrtext_l = 'FINAL. STATUS'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FINALNAME'.
  lv_fldcat-scrtext_l = 'FINAL. UPD BY'.
  lv_fldcat-outputlen = '20'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FINALDT'.
  lv_fldcat-scrtext_l = 'FINAL. UPD DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FINALTM'.
  lv_fldcat-scrtext_l = 'FINAL. UPD TIME'.
  lv_fldcat-outputlen = '10'.
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
  it_layout-zebra = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRODPEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prodpen .
  CLEAR : it_ztp_cost11,wa_ztp_cost11.

  SELECT * FROM ztp_cost11 INTO TABLE it_ztp_cost11 WHERE gjahr EQ gjahr AND vbeln IN vbeln AND matnr IN matnr AND fglifnr IN fglifnr AND cpudt IN s_budat.
  IF it_ztp_cost11 IS INITIAL.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.
  IF it_ztp_cost11 IS NOT INITIAL.
    SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 FOR ALL ENTRIES IN it_ztp_cost11 WHERE gjahr EQ it_ztp_cost11-gjahr AND vbeln EQ it_ztp_cost11-vbeln
      AND prod EQ '00000000'.
  ENDIF.

  LOOP AT it_ztp_cost11 INTO wa_ztp_cost11.
    SELECT SINGLE * FROM ztp_cost14 WHERE gjahr = wa_ztp_cost11-gjahr AND vbeln = wa_ztp_cost11-vbeln.
    IF sy-subrc EQ 4.

      wa_dis1-vbeln = wa_ztp_cost11-vbeln.
      wa_dis1-gjahr = wa_ztp_cost11-gjahr.
      wa_dis1-matnr = wa_ztp_cost11-matnr.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_ztp_cost11-matnr AND spras EQ 'EN'.
      IF sy-subrc EQ 0.
        wa_dis1-maktx = makt-maktx.
      ENDIF.
      wa_dis1-werks = wa_ztp_cost11-werks.
      wa_dis1-stlal = wa_ztp_cost11-stlal.
      wa_dis1-fglifnr = wa_ztp_cost11-fglifnr.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_ztp_cost11-fglifnr.
      IF sy-subrc EQ 0.
        wa_dis1-fgname1 = lfa1-name1.
      ENDIF.
      wa_dis1-r2 = wa_ztp_cost11-r2.
      wa_dis1-p2 = wa_ztp_cost11-p2.
      wa_dis1-rp1 = wa_ztp_cost11-rp1.
      wa_dis1-m1 = wa_ztp_cost11-m1.
      wa_dis1-ccpc = wa_ztp_cost11-ccpc.
      wa_dis1-anaval = wa_ztp_cost11-anaval.
      wa_dis1-anart = wa_ztp_cost11-anart.
      wa_dis1-gstval1 = wa_ztp_cost11-gstval1.
      wa_dis1-net = wa_ztp_cost11-net.
      wa_dis1-margin = wa_ztp_cost11-margin.
      wa_dis1-fggst = wa_ztp_cost11-fggst.
      wa_dis1-bmeng = wa_ztp_cost11-bmeng.
      wa_dis1-batsz = wa_ztp_cost11-batsz.
      wa_dis1-rmyld = wa_ztp_cost11-rmyld.
      wa_dis1-pmyld = wa_ztp_cost11-pmyld.
      wa_dis1-cpudt = wa_ztp_cost11-cpudt.
      wa_dis1-uname = wa_ztp_cost11-uname.
      wa_dis1-uzeit = wa_ztp_cost11-uzeit.




**********************************************************************************************************
      IF wa_ztp_cost14-prodapr EQ 'X'.
        wa_dis1-prodstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-prodrej EQ 'X'.
        wa_dis1-prodstatus = 'REJECTED'.
      ELSE.
        wa_dis1-prodstatus = space.
      ENDIF.
      wa_dis1-proddt = wa_ztp_cost14-proddt.
      wa_dis1-prodtm = wa_ztp_cost14-prodtm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-prodname = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-purapr EQ 'X'.
        wa_dis1-purstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-purrej EQ 'X'.
        wa_dis1-purstatus = 'REJECTED'.
      ELSE.
        wa_dis1-purstatus = space.
      ENDIF.
      wa_dis1-purdt = wa_ztp_cost14-purdt.
      wa_dis1-purtm = wa_ztp_cost14-purtm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-purname = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-acctapr EQ 'X'.
        wa_dis1-acctstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-acctrej EQ 'X'.
        wa_dis1-acctstatus = 'REJECTED'.
      ELSE.
        wa_dis1-acctstatus = space.
      ENDIF.
      wa_dis1-acctdt = wa_ztp_cost14-acctdt.
      wa_dis1-accttm = wa_ztp_cost14-accttm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-acctname = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-fiapr EQ 'X'.
        wa_dis1-fistatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-firej EQ 'X'.
        wa_dis1-fistatus = 'REJECTED'.
      ELSE.
        wa_dis1-fistatus = space.
      ENDIF.
      wa_dis1-fidt = wa_ztp_cost14-fidt.
      wa_dis1-fitm = wa_ztp_cost14-fitm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-finame = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-finalapr EQ 'X'.
        wa_dis1-finalstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-finalrej EQ 'X'.
        wa_dis1-finalstatus = 'REJECTED'.
      ELSE.
        wa_dis1-finalstatus = space.
      ENDIF.
      wa_dis1-finaldt = wa_ztp_cost14-finaldt.
      wa_dis1-finaltm = wa_ztp_cost14-finaltm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-finalname = pa0001-ename.
      ENDIF.
****************************************************************************************************

      SELECT SINGLE * FROM ztp_cost15 WHERE gjahr EQ wa_ztp_cost11-gjahr AND vbeln EQ wa_ztp_cost11-vbeln.
      IF sy-subrc EQ 0.
        wa_dis1-status = 'REJECTED'.
      ENDIF.

      COLLECT wa_dis1 INTO it_dis1.
      CLEAR wa_dis1.
    ENDIF.

  ENDLOOP.

  LOOP AT it_dis1 INTO wa_dis1.
    PACK wa_dis1-matnr TO wa_dis1-matnr.
    PACK wa_dis1-vbeln TO wa_dis1-vbeln.
    PACK wa_dis1-fglifnr TO wa_dis1-fglifnr.
    CONDENSE:  wa_dis1-matnr,wa_dis1-vbeln,wa_dis1-fglifnr.
    MODIFY it_dis1 FROM wa_dis1 TRANSPORTING matnr vbeln fglifnr.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PURPEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM purpen .


  CLEAR : it_ztp_cost11,wa_ztp_cost11.

  SELECT * FROM ztp_cost11 INTO TABLE it_ztp_cost11 WHERE gjahr EQ gjahr AND vbeln IN vbeln AND matnr IN matnr AND fglifnr IN
    fglifnr AND cpudt IN s_budat.
  IF it_ztp_cost11 IS INITIAL.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.
  IF r3 EQ 'X'.
    IF it_ztp_cost11 IS NOT INITIAL.
      SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 FOR ALL ENTRIES IN it_ztp_cost11 WHERE gjahr EQ it_ztp_cost11-gjahr AND vbeln EQ it_ztp_cost11-vbeln
        AND pur EQ '00000000' AND prod NE '00000000'.
    ENDIF.
  ELSEIF r4 EQ 'X'.
    IF it_ztp_cost11 IS NOT INITIAL.
      SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 FOR ALL ENTRIES IN it_ztp_cost11 WHERE gjahr EQ it_ztp_cost11-gjahr AND vbeln EQ it_ztp_cost11-vbeln
        AND acct EQ '00000000' AND pur NE '00000000'.
    ENDIF.
  ELSEIF r5 EQ 'X'.
    IF it_ztp_cost11 IS NOT INITIAL.
      SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 FOR ALL ENTRIES IN it_ztp_cost11 WHERE gjahr EQ it_ztp_cost11-gjahr AND vbeln EQ it_ztp_cost11-vbeln
        AND fi EQ '00000000' AND acct NE '00000000'.
    ENDIF.
  ELSEIF r6 EQ 'X'.
    IF it_ztp_cost11 IS NOT INITIAL.
      SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 FOR ALL ENTRIES IN it_ztp_cost11 WHERE gjahr EQ it_ztp_cost11-gjahr AND vbeln EQ it_ztp_cost11-vbeln
        AND final EQ '00000000' AND fi NE '00000000'.
    ENDIF.
  ELSEIF r7 EQ 'X'.
    IF it_ztp_cost11 IS NOT INITIAL.
      SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 FOR ALL ENTRIES IN it_ztp_cost11 WHERE gjahr EQ it_ztp_cost11-gjahr AND vbeln EQ it_ztp_cost11-vbeln
        AND final NE '00000000' .
    ENDIF.
  ENDIF.

  LOOP AT it_ztp_cost11 INTO wa_ztp_cost11.
    READ TABLE it_ztp_cost14 INTO wa_ztp_cost14 WITH KEY gjahr = wa_ztp_cost11-gjahr vbeln = wa_ztp_cost11-vbeln.
    IF sy-subrc EQ 0.
      wa_dis1-vbeln = wa_ztp_cost11-vbeln.
      wa_dis1-gjahr = wa_ztp_cost11-gjahr.
      wa_dis1-matnr = wa_ztp_cost11-matnr.
      SELECT SINGLE * FROM makt WHERE matnr EQ wa_ztp_cost11-matnr AND spras EQ 'EN'.
      IF sy-subrc EQ 0.
        wa_dis1-maktx = makt-maktx.
      ENDIF.
      wa_dis1-werks = wa_ztp_cost11-werks.
      wa_dis1-stlal = wa_ztp_cost11-stlal.
      wa_dis1-fglifnr = wa_ztp_cost11-fglifnr.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_ztp_cost11-fglifnr.
      IF sy-subrc EQ 0.
        wa_dis1-fgname1 = lfa1-name1.
      ENDIF.
      wa_dis1-r2 = wa_ztp_cost11-r2.
      wa_dis1-p2 = wa_ztp_cost11-p2.
      wa_dis1-rp1 = wa_ztp_cost11-rp1.
      wa_dis1-m1 = wa_ztp_cost11-m1.
      wa_dis1-ccpc = wa_ztp_cost11-ccpc.
      wa_dis1-anaval = wa_ztp_cost11-anaval.
      wa_dis1-anart = wa_ztp_cost11-anart.
      wa_dis1-gstval1 = wa_ztp_cost11-gstval1.
      wa_dis1-net = wa_ztp_cost11-net.
      wa_dis1-margin = wa_ztp_cost11-margin.
      wa_dis1-fggst = wa_ztp_cost11-fggst.
      wa_dis1-bmeng = wa_ztp_cost11-bmeng.
      wa_dis1-batsz = wa_ztp_cost11-batsz.
      wa_dis1-rmyld = wa_ztp_cost11-rmyld.
      wa_dis1-pmyld = wa_ztp_cost11-pmyld.
      wa_dis1-cpudt = wa_ztp_cost11-cpudt.
      wa_dis1-uname = wa_ztp_cost11-uname.
      wa_dis1-uzeit = wa_ztp_cost11-uzeit.




**********************************************************************************************************
      IF wa_ztp_cost14-prodapr EQ 'X'.
        wa_dis1-prodstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-prodrej EQ 'X'.
        wa_dis1-prodstatus = 'REJECTED'.
      ELSE.
        wa_dis1-prodstatus = space.
      ENDIF.
      wa_dis1-proddt = wa_ztp_cost14-proddt.
      wa_dis1-prodtm = wa_ztp_cost14-prodtm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-prodname = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-purapr EQ 'X'.
        wa_dis1-purstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-purrej EQ 'X'.
        wa_dis1-purstatus = 'REJECTED'.
      ELSE.
        wa_dis1-purstatus = space.
      ENDIF.
      wa_dis1-purdt = wa_ztp_cost14-purdt.
      wa_dis1-purtm = wa_ztp_cost14-purtm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-purname = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-acctapr EQ 'X'.
        wa_dis1-acctstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-acctrej EQ 'X'.
        wa_dis1-acctstatus = 'REJECTED'.
      ELSE.
        wa_dis1-acctstatus = space.
      ENDIF.
      wa_dis1-acctdt = wa_ztp_cost14-acctdt.
      wa_dis1-accttm = wa_ztp_cost14-accttm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-acctname = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-fiapr EQ 'X'.
        wa_dis1-fistatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-firej EQ 'X'.
        wa_dis1-fistatus = 'REJECTED'.
      ELSE.
        wa_dis1-fistatus = space.
      ENDIF.
      wa_dis1-fidt = wa_ztp_cost14-fidt.
      wa_dis1-fitm = wa_ztp_cost14-fitm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-finame = pa0001-ename.
      ENDIF.
***************************************************************************************************

      IF wa_ztp_cost14-finalapr EQ 'X'.
        wa_dis1-finalstatus = 'APPROVED'.
      ELSEIF wa_ztp_cost14-finalrej EQ 'X'.
        wa_dis1-finalstatus = 'REJECTED'.
      ELSE.
        wa_dis1-finalstatus = space.
      ENDIF.
      wa_dis1-finaldt = wa_ztp_cost14-finaldt.
      wa_dis1-finaltm = wa_ztp_cost14-finaltm.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_dis1-finalname = pa0001-ename.
      ENDIF.
****************************************************************************************************

      SELECT SINGLE * FROM ztp_cost15 WHERE gjahr EQ wa_ztp_cost11-gjahr AND vbeln EQ wa_ztp_cost11-vbeln.
      IF sy-subrc EQ 0.
        wa_dis1-status = 'REJECTED'.
      ENDIF.

      COLLECT wa_dis1 INTO it_dis1.
      CLEAR wa_dis1.
    ENDIF.

  ENDLOOP.

  LOOP AT it_dis1 INTO wa_dis1.
    PACK wa_dis1-matnr TO wa_dis1-matnr.
    PACK wa_dis1-vbeln TO wa_dis1-vbeln.
    PACK wa_dis1-fglifnr TO wa_dis1-fglifnr.
    CONDENSE:  wa_dis1-matnr,wa_dis1-vbeln,wa_dis1-fglifnr.
    MODIFY it_dis1 FROM wa_dis1 TRANSPORTING matnr vbeln fglifnr.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ACCTPEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM acctpen .

ENDFORM.
