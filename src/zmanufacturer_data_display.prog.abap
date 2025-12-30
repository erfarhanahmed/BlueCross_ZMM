*&---------------------------------------------------------------------*
*& Report  ZMANUFACTURER_DATA_DISPLAY
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zmanufacturer_data_display NO STANDARD PAGE HEADING LINE-SIZE 250.
TABLES : lfa1,
         zvendor_mfg,
         adrc,
         eord,
         makt,
         mara,
         pa0001.

DATA: it_zvendor_mfg TYPE TABLE OF zvendor_mfg,
      wa_zvendor_mfg TYPE zvendor_mfg,
      it_eord        TYPE TABLE OF eord,
      wa_eord        TYPE eord,
      it_wyt3        TYPE TABLE OF wyt3,
      wa_wyt3        TYPE wyt3.

TYPES: BEGIN OF itab1,
         mfgr   TYPE lfa1-lifnr,
         name1  TYPE adrc-name1,
         name2  TYPE adrc-name2,
         name3  TYPE adrc-name3,
         name4  TYPE adrc-name4,
         ort01  TYPE lfa1-ort01,
         regio  TYPE lfa1-regio,
         buzei  TYPE zvendor_mfg-buzei,
         mfglic TYPE sy-datum,
         gmplic TYPE sy-datum,
         smfdt  TYPE sy-datum,
         qarev  TYPE sy-datum,
         ename  TYPE pa0001-ename,
         cpudt  TYPE sy-datum,
       END OF itab1.

TYPES: BEGIN OF itap1,
         mfgr  TYPE lfa1-lifnr,
         matnr TYPE eord-matnr,
         werks TYPE eord-werks,
       END OF itap1.

TYPES: BEGIN OF itap2,
         mfgr  TYPE lfa1-lifnr,  "MANUFACTURER
         lifnr TYPE lfa1-lifnr,
         matnr TYPE eord-matnr,
         werks TYPE eord-werks,
       END OF itap2.

TYPES: BEGIN OF itap3,
         mfgr         TYPE lfa1-lifnr,  "MANUFACTURER
         werks        TYPE eord-werks,
         mfgname1     TYPE lfa1-name1,
         mfgadrc(200) TYPE c,
         matnr        TYPE eord-matnr,
         maktx(100)   TYPE c,
*         lifnr        TYPE lfa1-lifnr,
*         venname1     TYPE lfa1-name1,
*         venadrc(200) TYPE c,
         mfglic       TYPE zvendor_mfg-mfglic,
         gmplic       TYPE zvendor_mfg-gmplic,
         smfdt        TYPE zvendor_mfg-smfdt,
         qarev        TYPE zvendor_mfg-qarev,
         other1       TYPE zvendor_mfg-other1,
         odate1       TYPE zvendor_mfg-odate1,
         other2       TYPE zvendor_mfg-other1,
         odate2       TYPE zvendor_mfg-odate1,
         other3       TYPE zvendor_mfg-other1,
         odate3       TYPE zvendor_mfg-odate1,
       END OF itap3.

TYPES: BEGIN OF itas1,
         mfgr TYPE lfa1-lifnr,
       END OF itas1.

TYPES: BEGIN OF ven1,
         mfgr TYPE lfa1-lifnr,
       END OF ven1.

TYPES: BEGIN OF ven2,
         mfgr  TYPE lfa1-lifnr,
         buzei TYPE zvendor_mfg-buzei,
       END OF ven2.

DATA: it_tab1 TYPE TABLE OF itab1,
      wa_tab1 TYPE itab1,
      it_tas1 TYPE TABLE OF itas1,
      wa_tas1 TYPE itas1,
      it_tap1 TYPE TABLE OF itap1,
      wa_tap1 TYPE itap1,
      it_tap2 TYPE TABLE OF itap2,
      wa_tap2 TYPE itap2,
      it_tap3 TYPE TABLE OF itap3,
      wa_tap3 TYPE itap3,
      it_ven1 TYPE TABLE OF ven1,
      wa_ven1 TYPE ven1,
      it_ven2 TYPE TABLE OF ven2,
      wa_ven2 TYPE ven2.

DATA: maktx1(40) TYPE c,
      maktx2(40) TYPE c,
      normt      TYPE mara-normt,
      maktx(100) TYPE c.
DATA: name2        TYPE adrc-name1,
      name3        TYPE adrc-name1,
      name4        TYPE adrc-name1,
      mfgadrc(160) TYPE c,
      venadrc(160) TYPE c.
DATA: buzei  TYPE zvendor_mfg-buzei,
      buzei1 TYPE zvendor_mfg-buzei.
DATA: gstring TYPE c.
DATA: zvendor_mfg_wa TYPE zvendor_mfg.
DATA: format(100) TYPE c,
      kunnr       TYPE kna1-kunnr.
DATA : v_fm TYPE rs38l_fnam.

DATA: c_ccont   TYPE REF TO cl_gui_custom_container,         "Custom container object
      c_alvgd   TYPE REF TO cl_gui_alv_grid,         "ALV grid object
      it_fcat   TYPE lvc_t_fcat,                  "Field catalogue
      it_layout TYPE lvc_s_layo.                  "Layout
*ok code declaration
DATA:
  ok_code       TYPE ui_func.
SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE text-001.
PARAMETERS : p1 RADIOBUTTON GROUP p1,
             p3 RADIOBUTTON GROUP p1,
             p2 RADIOBUTTON GROUP p1.
SELECT-OPTIONS : mfgr FOR lfa1-lifnr.
*               plant for eord-werks.

SELECTION-SCREEN END OF BLOCK merkmale1 .

START-OF-SELECTION.


  SELECT * FROM zvendor_mfg INTO TABLE it_zvendor_mfg WHERE mfgr IN mfgr.

  IF p1 EQ 'X'.
    PERFORM print.
  ELSEIF p2 EQ 'X' .
    PERFORM allalv.
  ELSEIF p3 EQ 'X'.
    PERFORM alv.
  ENDIF.






*&---------------------------------------------------------------------*
*&      Module  STATUS_0600  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0600 OUTPUT.
  SET PF-STATUS 'STATUS'.
*  SET TITLEBAR 'TEST'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo OUTPUT.

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
  PERFORM alv_build_fieldcat.
* Set ALV attributes FOR LAYOUT
  PERFORM alv_report_layout.
  CHECK NOT c_alvgd IS INITIAL.
* Call ALV GRID
  CALL METHOD c_alvgd->set_table_for_first_display
    EXPORTING
      is_layout                     = it_layout
      i_save                        = 'A'
    CHANGING
      it_outtab                     = it_tab1
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

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0600  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0600 INPUT.
*To change the existing values and refresh the grid
*And only values in the dropdown or in the default
*F4 can be given , else no action takes place for the dropdown
*and error is thrown for the default F4 help and font changes to red
*and on still saving, value is not changed
*  c_alvgd->check_changed_data( ).
*Based on the user input
*When user clicks 'SAVE;
*  BREAK-POINT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.
  CLEAR: ok_code.
ENDMODULE.
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
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '1'.
  lv_fldcat-fieldname = 'BUZEI'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'Record No.'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '2'.
  lv_fldcat-fieldname = 'MFGLIC'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR LIC VALID UPTO'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '3'.
  lv_fldcat-fieldname = 'GMPLIC'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'GMP LIC VALID UPTO'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '4'.
  lv_fldcat-fieldname = 'SMFDT'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'SMF LIC VALID UPTO'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '5'.
  lv_fldcat-fieldname = 'QAREV'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'QA REVIEW DATE'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '6'.
  lv_fldcat-fieldname = 'MFGR'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'MFGR CODE'.
*  lv_fldcat-icon = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '7'.
  lv_fldcat-fieldname = 'NAME1'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'MFGR NAME'.
*  lv_fldcat-icon = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '8'.
  lv_fldcat-fieldname = 'NAME2'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR ADDRESS1'.
*  lv_fldcat-icon = ''.
*    LV_FLDCAT-EDIT = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '9'.
  lv_fldcat-fieldname = 'NAME3'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR ADDRESS2'.
*  lv_fldcat-icon = ''.
*    LV_FLDCAT-EDIT = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '10'.
  lv_fldcat-fieldname = 'NAME4'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR ADDRESS1'.
*  lv_fldcat-icon = ''.
*    LV_FLDCAT-EDIT = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '11'.
  lv_fldcat-fieldname = 'ORT01'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR CITY'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '12'.
  lv_fldcat-fieldname = 'REGIO'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR REGION'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '13'.
  lv_fldcat-fieldname = 'ENAME'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'Entered By'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '14'.
  lv_fldcat-fieldname = 'ENAME'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'Entered On'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
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
  it_layout-cwidth_opt = 'X'.
  it_layout-col_opt = 'X'.
  it_layout-zebra = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REDISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM redisplay .
  MESSAGE 'SAVED DATA' TYPE 'I'.
*  break-point.
  LOOP AT it_tab1 INTO wa_tab1 WHERE mfglic GT 0.
    zvendor_mfg_wa-mfgr = wa_tab1-mfgr.
    zvendor_mfg_wa-buzei = wa_tab1-buzei.
    zvendor_mfg_wa-mfglic = wa_tab1-mfglic.
    zvendor_mfg_wa-gmplic = wa_tab1-gmplic.
    zvendor_mfg_wa-smfdt = wa_tab1-smfdt.
    zvendor_mfg_wa-qarev = wa_tab1-qarev.
    MODIFY zvendor_mfg FROM zvendor_mfg_wa.
    CLEAR zvendor_mfg_wa.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print .
  SORT it_zvendor_mfg DESCENDING BY buzei.

  LOOP AT it_zvendor_mfg INTO wa_zvendor_mfg.
    wa_tas1-mfgr = wa_zvendor_mfg-mfgr.
    COLLECT wa_tas1 INTO it_tas1.
    CLEAR wa_tas1.
  ENDLOOP.
  SORT it_tas1 BY mfgr.
  DELETE ADJACENT DUPLICATES FROM it_tas1 COMPARING mfgr.

  IF it_tas1 IS NOT INITIAL.
    SELECT * FROM eord INTO TABLE it_eord FOR ALL ENTRIES IN it_tas1 WHERE lifnr EQ it_tas1-mfgr.
*      and werks in plant.
  ENDIF.
  LOOP AT it_tas1 INTO wa_tas1.
    LOOP AT it_eord INTO wa_eord WHERE lifnr EQ wa_tas1-mfgr.
      wa_tap1-mfgr = wa_tas1-mfgr.
      wa_tap1-werks = wa_eord-werks.
      wa_tap1-matnr = wa_eord-matnr.
      COLLECT wa_tap1 INTO it_tap1.
      CLEAR wa_tap1.
*      read table it_zvendor_mfg into wa_zvendor_mfg with key mfgr = wa_tas1-lifnr.
*      if sy-subrc eq 0.
*        write : wa_zvendor_mfg-mfglic,wa_zvendor_mfg-gmplic.
*      endif.
    ENDLOOP.
  ENDLOOP.
  LOOP AT it_tas1 INTO wa_tas1.
    READ TABLE it_eord INTO wa_eord WITH KEY lifnr = wa_tas1-mfgr.
    IF sy-subrc EQ 4.
      wa_tap1-mfgr = wa_tas1-mfgr.
      wa_tap1-matnr = space.
      wa_tap1-werks = space.
      COLLECT wa_tap1 INTO it_tap1.
      CLEAR wa_tap1.
    ENDIF.
  ENDLOOP.
  IF it_tap1 IS NOT INITIAL.
    SELECT * FROM wyt3 INTO TABLE it_wyt3 FOR ALL ENTRIES IN it_tap1 WHERE parvw EQ 'HR' AND lifn2 EQ it_tap1-mfgr.
  ENDIF.

  LOOP AT it_tap1 INTO wa_tap1.
*    write : / wa_tap1-lifnr,wa_tap1-matnr.
    LOOP AT it_wyt3 INTO wa_wyt3 WHERE lifn2 EQ wa_tap1-mfgr.
*      write : / wa_wyt3-lifnr.
      wa_tap2-mfgr = wa_tap1-mfgr.
      wa_tap2-matnr = wa_tap1-matnr.
      wa_tap2-werks = wa_tap1-werks.
      wa_tap2-lifnr = wa_wyt3-lifnr.
      COLLECT wa_tap2 INTO it_tap2.
      CLEAR wa_tap2.
    ENDLOOP.
  ENDLOOP.

  LOOP AT it_tap1 INTO wa_tap1.
    READ TABLE it_wyt3 INTO wa_wyt3 WITH KEY lifn2 = wa_tap1-mfgr.
    IF sy-subrc EQ 4.
*      write : / wa_wyt3-lifnr.
      wa_tap2-mfgr = wa_tap1-mfgr.
      wa_tap2-matnr = wa_tap1-matnr.
      wa_tap2-werks = wa_tap1-werks.
      wa_tap2-lifnr = space.
      COLLECT wa_tap2 INTO it_tap2.
      CLEAR wa_tap2.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tap2 INTO wa_tap2.
    wa_tap3-mfgr = wa_tap2-mfgr.
    wa_tap3-matnr = wa_tap2-matnr.
    wa_tap3-werks = wa_tap2-werks.
*    wa_tap3-lifnr = wa_tap2-lifnr.
    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_tap2-mfgr.
    IF sy-subrc EQ 0.
      wa_tap3-mfgname1 = lfa1-name1.
*******************adress***************
      CLEAR : name2,name3,name4,mfgadrc.
      SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
      IF sy-subrc EQ 0.
        IF adrc-name2 EQ space.
          name2 = adrc-str_suppl1.
        ELSE.
          name2 = adrc-name2.
        ENDIF.
        IF adrc-name3 EQ space.
          name3 = adrc-str_suppl2.
        ELSE.
          name3 = adrc-name3.
        ENDIF.
        IF adrc-name4 EQ space.
          name4 = adrc-str_suppl3.
        ELSE.
          name4 = adrc-name4.
        ENDIF.
        CONCATENATE name2 name3 name4 adrc-city1 adrc-region INTO mfgadrc SEPARATED BY space.
        wa_tap3-mfgadrc  = mfgadrc.
      ENDIF.
***********************************************
    ENDIF.
*    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_tap2-lifnr.
*    IF sy-subrc EQ 0.
*      wa_tap3-venname1 = lfa1-name1.
**      *******************adress***************
*      CLEAR : name2,name3,name4,venadrc.
*      SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
*      IF sy-subrc EQ 0.
*        IF adrc-name2 EQ space.
*          name2 = adrc-str_suppl1.
*        ELSE.
*          name2 = adrc-name2.
*        ENDIF.
*        IF adrc-name3 EQ space.
*          name3 = adrc-str_suppl2.
*        ELSE.
*          name3 = adrc-name3.
*        ENDIF.
*        IF adrc-name4 EQ space.
*          name4 = adrc-str_suppl3.
*        ELSE.
*          name4 = adrc-name4.
*        ENDIF.
*        CONCATENATE name2 name3 name4 adrc-city1 adrc-region INTO venadrc SEPARATED BY space.
*        wa_tap3-venadrc  = venadrc.
*      ENDIF.
************************************************
*    ENDIF.
    CLEAR : maktx1,maktx2,normt,maktx.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_tap2-matnr AND spras EQ 'EN'.
    IF sy-subrc EQ 0.
      maktx1 = makt-maktx.
    ENDIF.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_tap2-matnr AND spras EQ 'Z1'.
    IF sy-subrc EQ 0.
      maktx2 = makt-maktx.
    ENDIF.
    SELECT SINGLE * FROM mara WHERE matnr EQ wa_tap2-matnr.
    IF sy-subrc EQ 0.
      normt = mara-normt.
    ENDIF.
    CONCATENATE maktx1 maktx2 normt INTO maktx.
    wa_tap3-maktx = maktx.
    READ TABLE it_zvendor_mfg INTO wa_zvendor_mfg WITH KEY mfgr = wa_tap2-mfgr.
    IF sy-subrc EQ 0.
      wa_tap3-mfglic = wa_zvendor_mfg-mfglic.
      wa_tap3-gmplic = wa_zvendor_mfg-gmplic.
      wa_tap3-smfdt = wa_zvendor_mfg-smfdt.
      wa_tap3-qarev = wa_zvendor_mfg-qarev.
      wa_tap3-other1 = wa_zvendor_mfg-other1.
      wa_tap3-odate1 = wa_zvendor_mfg-odate1.
      wa_tap3-other2 = wa_zvendor_mfg-other2.
      wa_tap3-odate2 = wa_zvendor_mfg-odate2.
      wa_tap3-other3 = wa_zvendor_mfg-other3.
      wa_tap3-odate3 = wa_zvendor_mfg-odate3.
    ENDIF.
    COLLECT wa_tap3 INTO it_tap3.
    CLEAR wa_tap3.
  ENDLOOP.

*  loop at it_tap3 into wa_tap3.
*    write: /1 wa_tap3-mfgr left-justified,7 wa_tap3-werks, 12 wa_tap3-mfgname1,15 wa_tap3-mfgadrc,60 wa_tap3-matnr,80 wa_tap3-maktx,125 wa_tap3-lifnr,135 wa_tap3-venname1,
*    145 wa_tap3-venadrc, 175 wa_tap3-mfglic,186 wa_tap3-gmplic,197 wa_tap3-smfdt,208 wa_tap3-qarev.
*  endloop.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZMFGR_DT'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = v_fm
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  CALL FUNCTION v_fm
    EXPORTING
*     pln              = pln
      kunnr            = kunnr
      format           = format
*     AUBEL            = AUBEL
*     adrc             = adrc
*     t001w            = t001w
*     J_1IMOCUST       = J_1IMOCUST
*     G_LSTNO          = G_LSTNO
*     WA_ADRC          = WA_ADRC
*     VBKD             = VBKD
*     vbrk             = vbrk
*     fkdat            = fkdat
*     TOTAL            = TOTAL
*     TOTAL1           = TOTAL1
*     VBRK             = VBRK
*     W_TAX            = W_TAX
*     W_VALUE          = W_VALUE
*     SPELL            = SPELL
*     W_DIFF           = W_DIFF
*     EMNAME           = EMNAME
*     RMNAME           = RMNAME
*     CLMDT            = CLMDT
    TABLES
      it_tap3          = it_tap3
*     it_vbrp          = it_vbrp
*     ITAB_DIVISION    = ITAB_DIVISION
*     ITAB_STORAGE     = ITAB_STORAGE
*     ITAB_PA0002      = ITAB_PA0002
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.


ENDFORM.

** Calling the ALV screen with custom container
*  call screen 0600.
*  leave to screen 0.
*endform.
*&---------------------------------------------------------------------*
*&      Form  ALLALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM allalv.
  SORT it_zvendor_mfg BY mfgr buzei.

  LOOP AT it_zvendor_mfg INTO wa_zvendor_mfg.
    wa_tab1-mfgr = wa_zvendor_mfg-mfgr.
    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_zvendor_mfg-mfgr.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
      IF sy-subrc EQ 0.
        wa_tab1-name1 = adrc-name1.
        IF adrc-name2 EQ space.
          wa_tab1-name2 = adrc-str_suppl1.
        ELSE.
          wa_tab1-name2 = adrc-name2.
        ENDIF.
        IF adrc-name3 EQ space.
          wa_tab1-name3 = adrc-str_suppl2.
        ELSE.
          wa_tab1-name3 = adrc-name3.
        ENDIF.
        IF adrc-name4 EQ space.
          wa_tab1-name3 = adrc-str_suppl3.
        ELSE.
          wa_tab1-name3 = adrc-name4.
        ENDIF.
        wa_tab1-ort01 = lfa1-ort01.
        wa_tab1-regio = lfa1-regio.
        wa_tab1-buzei = wa_zvendor_mfg-buzei.
        wa_tab1-mfglic = wa_zvendor_mfg-mfglic.
        wa_tab1-gmplic = wa_zvendor_mfg-gmplic.
        wa_tab1-smfdt = wa_zvendor_mfg-smfdt.
        wa_tab1-qarev = wa_zvendor_mfg-qarev.
        SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_zvendor_mfg-pernr AND endda GE sy-datum.
        IF sy-subrc EQ 0.
          wa_tab1-ename = pa0001-ename.
        ENDIF.
        wa_tab1-cpudt = wa_zvendor_mfg-cpudt.
        COLLECT wa_tab1 INTO it_tab1.
        CLEAR wa_tab1.
      ENDIF.
    ENDIF.
  ENDLOOP.

* Calling the ALV screen with custom container
  CALL SCREEN 0600.
  LEAVE TO SCREEN 0.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  ATTACHMENT  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv .
  SORT it_zvendor_mfg BY mfgr buzei.

  LOOP AT it_zvendor_mfg INTO wa_zvendor_mfg.
    wa_ven1-mfgr = wa_zvendor_mfg-mfgr.
    COLLECT wa_ven1 INTO it_ven1.
    CLEAR wa_ven1.
  ENDLOOP.
  SORT it_ven1 BY mfgr.
  DELETE ADJACENT DUPLICATES FROM it_ven1 COMPARING mfgr.
  SORT it_zvendor_mfg DESCENDING BY buzei.
  LOOP AT it_ven1 INTO wa_ven1.
    READ TABLE it_zvendor_mfg INTO wa_zvendor_mfg WITH KEY mfgr = wa_ven1-mfgr.
    IF sy-subrc EQ 0.
      wa_ven2-mfgr = wa_zvendor_mfg-mfgr.
      wa_ven2-buzei = wa_zvendor_mfg-buzei.
      COLLECT wa_ven2 INTO it_ven2.
      CLEAR wa_ven2.
    ENDIF.
  ENDLOOP.

  LOOP AT it_ven2 INTO wa_ven2.
    READ TABLE it_zvendor_mfg INTO wa_zvendor_mfg WITH KEY mfgr = wa_ven2-mfgr buzei = wa_ven2-buzei.
    IF sy-subrc EQ 0.
      wa_tab1-mfgr = wa_zvendor_mfg-mfgr.
      SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_zvendor_mfg-mfgr.
      IF sy-subrc EQ 0.
        SELECT SINGLE * FROM adrc WHERE addrnumber EQ lfa1-adrnr.
        IF sy-subrc EQ 0.
          wa_tab1-name1 = adrc-name1.
          IF adrc-name2 EQ space.
            wa_tab1-name2 = adrc-str_suppl1.
          ELSE.
            wa_tab1-name2 = adrc-name2.
          ENDIF.
          IF adrc-name3 EQ space.
            wa_tab1-name3 = adrc-str_suppl2.
          ELSE.
            wa_tab1-name3 = adrc-name3.
          ENDIF.
          IF adrc-name4 EQ space.
            wa_tab1-name3 = adrc-str_suppl3.
          ELSE.
            wa_tab1-name3 = adrc-name4.
          ENDIF.
          wa_tab1-ort01 = lfa1-ort01.
          wa_tab1-regio = lfa1-regio.
          wa_tab1-buzei = wa_zvendor_mfg-buzei.
          wa_tab1-mfglic = wa_zvendor_mfg-mfglic.
          wa_tab1-gmplic = wa_zvendor_mfg-gmplic.
          wa_tab1-smfdt = wa_zvendor_mfg-smfdt.
          wa_tab1-qarev = wa_zvendor_mfg-qarev.
          SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_zvendor_mfg-pernr AND endda GE sy-datum.
          IF sy-subrc EQ 0.
            wa_tab1-ename = pa0001-ename.
          ENDIF.
          wa_tab1-cpudt = wa_zvendor_mfg-cpudt.
          COLLECT wa_tab1 INTO it_tab1.
          CLEAR wa_tab1.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

* Calling the ALV screen with custom container
  CALL SCREEN 0600.
  LEAVE TO SCREEN 0.
ENDFORM.
