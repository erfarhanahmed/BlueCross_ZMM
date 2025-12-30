*&---------------------------------------------------------------------*
*& Report  ZMANUFACTURER_DATA_DISP_ATT
*&*
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zmanufacturer_data_disp_att.


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
         lifnr      TYPE lfa1-lifnr,
         name1      TYPE adrc-name1,
         name2      TYPE adrc-name2,
         name3      TYPE adrc-name3,
         name4      TYPE adrc-name4,
         ort01      TYPE lfa1-ort01,
         regio      TYPE lfa1-regio,
         buzei      TYPE zvendor_mfg-buzei,
         mfglic     TYPE sy-datum,
         gmplic     TYPE sy-datum,
         smfdt      TYPE sy-datum,
         qarev      TYPE sy-datum,
         other1(50) TYPE c,
         odate1     TYPE sy-datum,
         other2(50) TYPE c,
         odate2     TYPE sy-datum,
         other3(50) TYPE c,
         odate3     TYPE sy-datum,

         ename      TYPE pa0001-ename,
         cpudt      TYPE sy-datum,
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
         lifnr        TYPE lfa1-lifnr,
         venname1     TYPE lfa1-name1,
         venadrc(200) TYPE c,
         mfglic       TYPE zvendor_mfg-mfglic,
         gmplic       TYPE zvendor_mfg-gmplic,
         smfdt        TYPE zvendor_mfg-smfdt,
         qarev        TYPE zvendor_mfg-qarev,
       END OF itap3.

TYPES: BEGIN OF itas1,
         mfgr TYPE lfa1-lifnr,
       END OF itas1.

DATA: it_tab1 TYPE TABLE OF itab1,
      wa_tab1 TYPE itab1,
      it_tas1 TYPE TABLE OF itas1,
      wa_tas1 TYPE itas1,
      it_tap1 TYPE TABLE OF itap1,
      wa_tap1 TYPE itap1,
      it_tap2 TYPE TABLE OF itap2,
      wa_tap2 TYPE itap2,
      it_tap3 TYPE TABLE OF itap3,
      wa_tap3 TYPE itap3.
DATA: maktx1(40) TYPE c,
      maktx2(40) TYPE c,
      normt      TYPE mara-normt,
      maktx(100) TYPE c.
DATA: name2        TYPE adrc-name1,
      name3        TYPE adrc-name1,
      name4        TYPE adrc-name1,
      mfgadrc(160) TYPE c,
      venadrc(160) TYPE c.

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

DATA: lo_gos_manager TYPE REF TO cl_gos_manager,
      ls_borident    TYPE borident,
      lv_mblnr       TYPE mblnr.

SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE text-001.
PARAMETERS : mfgr  LIKE lfa1-lifnr,
             buzei LIKE zvendor_mfg-buzei MATCHCODE OBJECT zmfg1.

SELECTION-SCREEN END OF BLOCK merkmale1 .

START-OF-SELECTION.

  SELECT * FROM zvendor_mfg INTO TABLE it_zvendor_mfg WHERE mfgr EQ mfgr AND buzei EQ buzei.

  SORT it_zvendor_mfg BY mfgr buzei.

  READ TABLE it_zvendor_mfg INTO wa_zvendor_mfg WITH KEY mfgr = mfgr buzei = buzei.
  IF sy-subrc EQ 0.
    wa_tab1-lifnr = wa_zvendor_mfg-mfgr.
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
        wa_tab1-other1 = wa_zvendor_mfg-other1.
        wa_tab1-odate1 = wa_zvendor_mfg-odate1.

        wa_tab1-other2 = wa_zvendor_mfg-other2.
        wa_tab1-odate2 = wa_zvendor_mfg-odate2.

        wa_tab1-other3 = wa_zvendor_mfg-other3.
        wa_tab1-odate3 = wa_zvendor_mfg-odate3.

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

* Calling the ALV screen with custom container
  CALL SCREEN 0600.
  LEAVE TO SCREEN 0.
*endform.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0600  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0600 OUTPUT.
  SET PF-STATUS 'STATUS'.
*  SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0600  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0600 INPUT.

  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.
  CLEAR: ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  PBO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo OUTPUT.

*  *  *Creating objects of the container
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

*********************************
   lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '6'.
  lv_fldcat-fieldname = 'OTHER1'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 20.
  lv_fldcat-scrtext_m = 'ANY OTHER TEXT1'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

   lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '7'.
  lv_fldcat-fieldname = 'ODATE1'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'ANY OTHER DATE1'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

   lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '8'.
  lv_fldcat-fieldname = 'OTHER2'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 20.
  lv_fldcat-scrtext_m = 'ANY OTHER TEXT1'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

   lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '9'.
  lv_fldcat-fieldname = 'ODATE2'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'ANY OTHER DATE1'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


   lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '10'.
  lv_fldcat-fieldname = 'OTHER3'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 20.
  lv_fldcat-scrtext_m = 'ANY OTHER TEXT1'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

   lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '11'.
  lv_fldcat-fieldname = 'ODATE3'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'ANY OTHER DATE1'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

**********************************


  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '12'.
  lv_fldcat-fieldname = 'LIFNR'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'MFGR CODE'.
*  lv_fldcat-icon = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '13'.
  lv_fldcat-fieldname = 'NAME1'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'MFGR NAME'.
*  lv_fldcat-icon = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '14'.
  lv_fldcat-fieldname = 'NAME2'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR ADDRESS1'.
*  lv_fldcat-icon = ''.
*    LV_FLDCAT-EDIT = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '15'.
  lv_fldcat-fieldname = 'NAME3'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR ADDRESS2'.
*  lv_fldcat-icon = ''.
*    LV_FLDCAT-EDIT = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '16'.
  lv_fldcat-fieldname = 'NAME4'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR ADDRESS1'.
*  lv_fldcat-icon = ''.
*    LV_FLDCAT-EDIT = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '17'.
  lv_fldcat-fieldname = 'ORT01'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR CITY'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '18'.
  lv_fldcat-fieldname = 'REGIO'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR REGION'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '19'.
  lv_fldcat-fieldname = 'ENAME'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'ENTERED BY'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '20'.
  lv_fldcat-fieldname = 'CPUDT'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'ENTERED ON'.
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
*&      Module  ATTACHMENT  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE attachment OUTPUT.

*   DATA: lt_sel TYPE tgos_sels,
*        ls_sel TYPE sgos_sels,
*        lv_del TYPE c.
*
*  CLEAR lt_sel.
*
*   DATA:
**         lv_del    TYPE c,
*        lv_ename  TYPE zemnam,
*        lv_btext  TYPE zbtext,
*        lv_stage  TYPE zstage,
*        lv_persno TYPE persno,
*        lv_werks  TYPE pa0001-werks,
*        lv_btrtl  TYPE pa0001-btrtl.
*
*
*    ls_sel-sign = 'I'.
*    ls_sel-option = 'EQ'.
*    ls_sel-low = 'VIEW_ATTA'.
*    ls_sel-high = 'VIEW_ATTA'.
*    APPEND ls_sel TO lt_sel.
*    CLEAR ls_sel.
*
*
**  IF r1c = abap_true OR r2 = abap_true
**    OR r3 = abap_true.
**data : lv_mblnr type  lfa1-lifnr.
*    lv_mblnr = mfgr.
*
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*      EXPORTING
*        input  = lv_mblnr
*      IMPORTING
*        output = lv_mblnr.
*
*    ls_borident-objkey = lv_mblnr.
*
**    CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
*    CONCATENATE ls_borident-objkey '_' BUZEI  INTO ls_borident-objkey.
*
*    CONDENSE ls_borident-objkey.
*
*    FREE MEMORY ID 'ZDEL'.
*
*    FREE MEMORY ID: 'ZENAME',
*                    'ZBTEXT',
*                    'ZSTAGE',
*                    'ZPERSNO'.
*
**    lv_persno = pernr.
**    LV_BTEXT = DEPT.
**    LV_ENAME = ENAME.
*    IF lv_persno NE '00000000'.
*      CLEAR : lv_ename.
*      SELECT SINGLE ename werks btrtl INTO (lv_ename,lv_werks,lv_btrtl) FROM pa0001
*         WHERE pernr EQ lv_persno
*         AND begda <= sy-datum
*         AND endda >= sy-datum.
*      IF lv_werks IS NOT INITIAL AND
*         lv_btrtl IS NOT INITIAL.
*        CLEAR : lv_btext.
*        SELECT SINGLE btext INTO lv_btext FROM t001p
*          WHERE werks EQ lv_werks
*          AND btrtl EQ lv_btrtl.
*      ENDIF.
*    ENDIF.
*
**---------------> Commented by Karthik on 31.12.2019
*
**    IF R1 = ABAP_TRUE.
**      LV_STAGE = 'Create (Initiator)'.
**    ELSEIF R1C = ABAP_TRUE.
*
**---------------> End of Comments
*
**    IF r1c = abap_true.
*      lv_stage = 'Manufacturer Data'.
**    ELSEIF r2 = abap_true.
**      lv_stage = 'Department Heads Approval (Initiator)'.
**    ELSEIF r3 = abap_true.
**      lv_stage = 'Enter Impacted Activities'.
**    ENDIF.
*
*    EXPORT: lv_ename TO MEMORY ID 'ZENAME',
*            lv_btext TO MEMORY ID 'ZBTEXT',
*            lv_stage TO MEMORY ID 'ZSTAGE',
*            lv_persno TO MEMORY ID 'ZPERSNO'.
*
**    IF R3 = ABAP_TRUE. " Commented by Karthik on 31.12.2019
*
**    IF r1c = abap_true OR r2 = abap_true OR r3 = abap_true.
**      lv_del = abap_true.
**      EXPORT lv_del TO MEMORY ID 'ZDEL'. " To restrict Deletion option
**    ENDIF.
*
*    CREATE OBJECT lo_gos_manager
*      EXPORTING
*        is_object      = ls_borident
*        ip_no_commit   = ' '
*      EXCEPTIONS
*        object_invalid = 1.
*
**  ELSEIF r21 = abap_true OR r21a = abap_true. " For Reviewed by and Approved by
**
**    PERFORM activate_dms_gos_disp. " To activate DMS GOS for Display
**
**  ENDIF.


  DATA: lt_sel TYPE tgos_sels,
        ls_sel TYPE sgos_sels,
        lv_del TYPE c.

  CLEAR lt_sel.

*  IF sy-uname EQ 'ITBOM01' AND r12 EQ 'X'.  "ENABLE DELETE OPTION  21.1.21
*
****      ls_sel-sign = 'I'.
****  ls_sel-option = 'EQ'.
****  ls_sel-low = 'VIEW_ATTA'.
****  ls_sel-high = 'VIEW_ATTA'.
****  APPEND ls_sel TO lt_sel.
****  CLEAR ls_sel.
*
*  free memory id 'ZDEL'. " Commented by Karthik on 31.12.2019
*
**  if r13 <> abap_true.
**  lv_del = abap_true.
**  endif.
*
*  export lv_del to memory id 'ZDEL'. " To restrict Deletion option
*
*  lv_mblnr = mfgr.
*
*  call function 'CONVERSION_EXIT_ALPHA_OUTPUT'
*    exporting
*      input  = lv_mblnr
*    importing
*      output = lv_mblnr.
*
*  ls_borident-objkey = lv_mblnr.
*
**  CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
*  concatenate ls_borident-objkey '_' buzei "Commented & Added by Gokulan.03.01.2021
*  into ls_borident-objkey.
*
*  condense ls_borident-objkey.
*
*  create object lo_gos_manager
*    exporting
*      is_object            = ls_borident
*      it_service_selection = lt_sel
*      ip_no_commit         = ' '
*    exceptions
*      object_invalid       = 1.

*  ELSE.
*
***  ls_sel-sign = 'I'.
***  ls_sel-option = 'EQ'.
***  ls_sel-low = 'VIEW_ATTA'.
***  ls_sel-high = 'VIEW_ATTA'.
***  append ls_sel to lt_sel.
***  clear ls_sel.

*  FREE MEMORY ID 'ZDEL'. " Commented by Karthik on 31.12.2019

*  if r13 <> abap_true.
***  lv_del = abap_true.
*  endif.

***  export lv_del to memory id 'ZDEL'. " To restrict Deletion option

  lv_mblnr = mfgr.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = lv_mblnr
    IMPORTING
      output = lv_mblnr.

  ls_borident-objkey = lv_mblnr.

*  CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
  CONCATENATE ls_borident-objkey '_MFG' buzei "Commented & Added by Gokulan.03.01.2021
  INTO ls_borident-objkey.

  CONDENSE ls_borident-objkey.

  CREATE OBJECT lo_gos_manager
    EXPORTING
      is_object            = ls_borident
      it_service_selection = lt_sel
      ip_no_commit         = ' '
    EXCEPTIONS
      object_invalid       = 1.
*
*  ENDIF.

ENDMODULE.
