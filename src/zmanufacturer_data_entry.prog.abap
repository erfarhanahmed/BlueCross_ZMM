*&---------------------------------------------------------------------*
*& Report  ZMANUFACTURER_DATA_ENTRY
*&*
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zmanufacturer_data_entry.
TABLES : lfa1,
         zvendor_mfg,
         adrc,
         zpassw.

DATA:
*      v_ac_xstring type xstring,
  v_en_string TYPE string,
*      v_en_xstring type xstring,
  v_de_string TYPE string,
*      v_de_xstring type string,
  v_error_msg TYPE string.
DATA: o_encryptor        TYPE REF TO cl_hard_wired_encryptor,
      o_cx_encrypt_error TYPE REF TO cx_encrypt_error.

DATA: it_zvendor_mfg TYPE TABLE OF zvendor_mfg,
      wa_zvendor_mfg TYPE zvendor_mfg.
TYPES: BEGIN OF itab1,
         lifnr  TYPE lfa1-lifnr,
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
         other1 TYPE string,
         odate1 TYPE sy-datum,
         other2 TYPE string,
         odate2 TYPE sy-datum,
         other3 TYPE string,
         odate3 TYPE sy-datum,
       END OF itab1.
DATA: it_tab1 TYPE TABLE OF itab1,
      wa_tab1 TYPE itab1.

DATA: buzei  TYPE zvendor_mfg-buzei,
      buzei1 TYPE zvendor_mfg-buzei.
DATA: gstring TYPE c.
DATA:   zvendor_mfg_wa TYPE   zvendor_mfg.

DATA: c_ccont   TYPE REF TO cl_gui_custom_container,         "Custom container object
      c_alvgd   TYPE REF TO cl_gui_alv_grid,         "ALV grid object
      it_fcat   TYPE lvc_t_fcat,                  "Field catalogue
      it_layout TYPE lvc_s_layo.                  "Layout
*ok code declaration
DATA:
  ok_code       TYPE ui_func.
DATA: mfgr1   TYPE lfa1-lifnr,
      sop(20) TYPE c.
DATA: it_dropdown TYPE lvc_t_drop,
      ty_dropdown TYPE lvc_s_drop,
*data declaration for refreshing of alv
      stable      TYPE lvc_s_stbl.
**************************
DATA: lo_gos_manager TYPE REF TO cl_gos_manager,
      ls_borident    TYPE borident,
      lv_mblnr       TYPE mblnr.

DATA: g_repid     LIKE sy-repid.

SELECTION-SCREEN BEGIN OF BLOCK merkmale3 WITH FRAME TITLE text-002.
PARAMETERS : pernr    LIKE pa0001-pernr MATCHCODE OBJECT prem,
             pass(10) TYPE c.
*             CCNUM    LIKE ZDMS1-MBLNR MATCHCODE OBJECT ZCC1,
*             YEAR     LIKE ZDMS1-MJAHR.
*SELECT-OPTIONS : SDEPT FOR PA0001-BTRTL.
SELECTION-SCREEN END OF BLOCK merkmale3.


SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE text-001.
PARAMETERS : lifnr LIKE lfa1-lifnr.
*             werks like mchb-werks.
SELECTION-SCREEN END OF BLOCK merkmale1 .

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK screen-name EQ 'PASS'.
    screen-invisible = 1.
    MODIFY SCREEN.
  ENDLOOP.


INITIALIZATION.
  g_repid = sy-repid.

START-OF-SELECTION.

  PERFORM passw.


  SELECT * FROM zvendor_mfg INTO TABLE it_zvendor_mfg WHERE mfgr EQ lifnr.
  SORT it_zvendor_mfg DESCENDING BY buzei.

  CLEAR : buzei,buzei1.

  READ TABLE it_zvendor_mfg INTO wa_zvendor_mfg WITH KEY mfgr = lifnr.
  IF sy-subrc EQ 0.
    buzei = wa_zvendor_mfg-buzei.
  ENDIF.
  buzei1 = buzei + 1.

  wa_tab1-lifnr = lifnr.
  SELECT SINGLE * FROM lfa1 WHERE lifnr EQ lifnr.
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
      wa_tab1-buzei = buzei1.

      COLLECT wa_tab1 INTO it_tab1.
      CLEAR wa_tab1.
    ENDIF.
  ENDIF.

* Calling the ALV screen with custom container
  CALL SCREEN 0600.
  LEAVE TO SCREEN 0.


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
*     i_callback_top_of_page        = 'TOP'
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
*  BREAK-POINT.
  c_alvgd->check_changed_data( ).
*Based on the user input
*When user clicks 'SAVE;
*  BREAK-POINT.
  CASE ok_code.
    WHEN 'SAVE'.
*A pop up is called to confirm the saving of changed data
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar       = 'SAVING DATA'
          text_question  = 'Continue?'
          icon_button_1  = 'icon_booking_ok'
        IMPORTING
          answer         = gstring
        EXCEPTIONS
          text_not_found = 1
          OTHERS         = 2.
      IF sy-subrc NE 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
*When the User clicks 'YES'
      IF ( gstring = '1' ).
        MESSAGE 'Saved' TYPE 'S'.
*Now the changed data is stored in the it_pbo internal table
*        MODIFY zgk_emp FROM TABLE it_emp.
*Subroutine to display the ALV with changed data.
        PERFORM redisplay.
        LEAVE TO SCREEN 0.
      ELSE.
*When user clicks NO or Cancel
        MESSAGE 'Not Saved'  TYPE 'S'.
      ENDIF.
**When the user clicks the 'EXIT; he is out
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
  lv_fldcat-fieldname = 'LIFNR'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'MFGR CODE'.
*  lv_fldcat-icon = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '2'.
  lv_fldcat-fieldname = 'NAME1'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'MFGR NAME'.
*  lv_fldcat-icon = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '3'.
  lv_fldcat-fieldname = 'NAME2'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR ADDRESS1'.
*  lv_fldcat-icon = ''.
*    LV_FLDCAT-EDIT = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '4'.
  lv_fldcat-fieldname = 'NAME3'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR ADDRESS2'.
*  lv_fldcat-icon = ''.
*    LV_FLDCAT-EDIT = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '5'.
  lv_fldcat-fieldname = 'NAME4'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR ADDRESS1'.
*  lv_fldcat-icon = ''.
*    LV_FLDCAT-EDIT = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '6'.
  lv_fldcat-fieldname = 'ORT01'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR CITY'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '7'.
  lv_fldcat-fieldname = 'REGIO'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR REGION'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '8'.
  lv_fldcat-fieldname = 'BUZEI'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'Record No.'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '9'.
  lv_fldcat-fieldname = 'MFGLIC'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR LIC VALID UPTO'.
  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '10'.
  lv_fldcat-fieldname = 'GMPLIC'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'GMP LIC VALID UPTO'.
  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '11'.
  lv_fldcat-fieldname = 'SMFDT'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'SMF LIC VALID UPTO'.
  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '12'.
  lv_fldcat-fieldname = 'QAREV'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'QA REVIEW DATE'.
  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.
**************************** 1 *************************************************

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '13'.
  lv_fldcat-fieldname = 'OTHER1'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 20.
  lv_fldcat-scrtext_m = 'ANY OTHER TEXT1'.
  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '14'.
  lv_fldcat-fieldname = 'ODATE1'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'ANY OTHER DATE1'.
  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

********************************* 2 ********************************************

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '15'.
  lv_fldcat-fieldname = 'OTHER2'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 20.
  lv_fldcat-scrtext_m = 'ANY OTHER TEXT2'.
  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '16'.
  lv_fldcat-fieldname = 'ODATE2'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'ANY OTHER DATE3'.
  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

********************************* 3 ********************************************

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '17'.
  lv_fldcat-fieldname = 'OTHER3'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 20.
  lv_fldcat-scrtext_m = 'ANY OTHER TEXT3'.
  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '18'.
  lv_fldcat-fieldname = 'ODATE3'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'ANY OTHER DATE3'.
  lv_fldcat-edit = 'X'.
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


*  *Cells of the alv are made non editable after entering OK to save
  CALL METHOD c_alvgd->set_ready_for_input
    EXPORTING
      i_ready_for_input = 0.
*Row and column of the alv are refreshed after changing values
  stable-row = 'X'.
  stable-col = 'X'.
*REfreshed ALV display with the changed values
*This ALV is non editable and contains new values
  CALL METHOD c_alvgd->refresh_table_display
    EXPORTING
      is_stable = stable
    EXCEPTIONS
      finished  = 1
      OTHERS    = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


*  break-point.
  LOOP AT it_tab1 INTO wa_tab1 WHERE mfglic GT 0.
    zvendor_mfg_wa-mfgr = wa_tab1-lifnr.
    zvendor_mfg_wa-buzei = wa_tab1-buzei.
    zvendor_mfg_wa-mfglic = wa_tab1-mfglic.
    zvendor_mfg_wa-gmplic = wa_tab1-gmplic.
    zvendor_mfg_wa-smfdt = wa_tab1-smfdt.
    zvendor_mfg_wa-qarev = wa_tab1-qarev.

    zvendor_mfg_wa-other1 = wa_tab1-other1.
    zvendor_mfg_wa-odate1 = wa_tab1-odate1.
    zvendor_mfg_wa-other2 = wa_tab1-other2.
    zvendor_mfg_wa-odate2 = wa_tab1-odate2.
    zvendor_mfg_wa-other3 = wa_tab1-other3.
    zvendor_mfg_wa-odate3 = wa_tab1-odate3.

    zvendor_mfg_wa-usnam = sy-uname.
    zvendor_mfg_wa-pernr = pernr.
    zvendor_mfg_wa-cpudt = sy-datum.
    MODIFY zvendor_mfg FROM zvendor_mfg_wa.
    CLEAR zvendor_mfg_wa.
  ENDLOOP.
  IF sy-subrc EQ 0.
    MESSAGE 'SAVED DATA' TYPE 'I'.
  ENDIF.
  EXIT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  ATTACHMENT  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE attachment OUTPUT.
  DATA: lv_del    TYPE c,
        lv_ename  TYPE zemnam,
        lv_btext  TYPE zbtext,
        lv_stage  TYPE zstage,
        lv_persno TYPE persno,
        lv_werks  TYPE pa0001-werks,
        lv_btrtl  TYPE pa0001-btrtl.


*  IF r1c = abap_true OR r2 = abap_true
*    OR r3 = abap_true.
*data : lv_mblnr type  lfa1-lifnr.
  lv_mblnr = lifnr.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = lv_mblnr
    IMPORTING
      output = lv_mblnr.

  ls_borident-objkey = lv_mblnr.
  CONCATENATE ls_borident-objkey '_MFG' buzei1  INTO ls_borident-objkey.

  CONDENSE ls_borident-objkey.

  FREE MEMORY ID 'ZDEL'.

  FREE MEMORY ID: 'ZENAME',
                  'ZBTEXT',
                  'ZSTAGE',
                  'ZPERSNO'.

  lv_persno = pernr.
*    LV_BTEXT = DEPT.
*    LV_ENAME = ENAME.
  IF lv_persno NE '00000000'.
    CLEAR : lv_ename.
    SELECT SINGLE ename werks btrtl INTO (lv_ename,lv_werks,lv_btrtl) FROM pa0001
       WHERE pernr EQ lv_persno
       AND begda <= sy-datum
       AND endda >= sy-datum.
    IF lv_werks IS NOT INITIAL AND
       lv_btrtl IS NOT INITIAL.
      CLEAR : lv_btext.
      SELECT SINGLE btext INTO lv_btext FROM t001p
        WHERE werks EQ lv_werks
        AND btrtl EQ lv_btrtl.
    ENDIF.
  ENDIF.

*---------------> Commented by Karthik on 31.12.2019

*    IF R1 = ABAP_TRUE.
*      LV_STAGE = 'Create (Initiator)'.
*    ELSEIF R1C = ABAP_TRUE.

*---------------> End of Comments

*    IF r1c = abap_true.
  lv_stage = 'Manufacturer Data'.
*    ELSEIF r2 = abap_true.
*      lv_stage = 'Department Heads Approval (Initiator)'.
*    ELSEIF r3 = abap_true.
*      lv_stage = 'Enter Impacted Activities'.
*    ENDIF.

  EXPORT: lv_ename TO MEMORY ID 'ZENAME',
          lv_btext TO MEMORY ID 'ZBTEXT',
          lv_stage TO MEMORY ID 'ZSTAGE',
          lv_persno TO MEMORY ID 'ZPERSNO'.

*    IF R3 = ABAP_TRUE. " Commented by Karthik on 31.12.2019

*    IF r1c = abap_true OR r2 = abap_true OR r3 = abap_true.
*      lv_del = abap_true.
*      EXPORT lv_del TO MEMORY ID 'ZDEL'. " To restrict Deletion option
*    ENDIF.

  CREATE OBJECT lo_gos_manager
    EXPORTING
      is_object      = ls_borident
      ip_no_commit   = ' '
    EXCEPTIONS
      object_invalid = 1.

*  ELSEIF r21 = abap_true OR r21a = abap_true. " For Reviewed by and Approved by
*
*    PERFORM activate_dms_gos_disp. " To activate DMS GOS for Display
*
*  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  ACTIVATE_DMS_GOS_DISP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  PASSW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM passw .
  SELECT SINGLE * FROM zpassw WHERE pernr = pernr.
  IF sy-subrc EQ 0.
    v_en_string = zpassw-password.
*&———————————————————————** Decryption – String to String*&———————————————————————*
    TRY.
        CREATE OBJECT o_encryptor.
        CALL METHOD o_encryptor->decrypt_string2string
          EXPORTING
            the_string = v_en_string
          RECEIVING
            result     = v_de_string.
      CATCH cx_encrypt_error INTO o_cx_encrypt_error.
        CALL METHOD o_cx_encrypt_error->if_message~get_text
          RECEIVING
            result = v_error_msg.
        MESSAGE v_error_msg TYPE 'E'.
    ENDTRY.
    IF v_de_string EQ pass.
*      message 'CORRECT PASSWORD' type 'I'.
    ELSE.
      MESSAGE 'INCORRECT PASSWORD' TYPE 'E'.
    ENDIF.
  ELSE.
    MESSAGE 'NOT VALID USER' TYPE 'E'.
    EXIT.
  ENDIF.
  CLEAR : pass.
  pass = '   '.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ACTIVATE_DMS_GOS_DISP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*form activate_dms_gos_disp .
* DATA: lt_sel TYPE tgos_sels,
*        ls_sel TYPE sgos_sels,
*        lv_del TYPE c.
*
*  CLEAR lt_sel.
*
*  IF sy-uname EQ 'ITBOM01' .  "ENABLE DELETE OPTION  21.1.21
*
****      ls_sel-sign = 'I'.
****  ls_sel-option = 'EQ'.
****  ls_sel-low = 'VIEW_ATTA'.
****  ls_sel-high = 'VIEW_ATTA'.
****  APPEND ls_sel TO lt_sel.
****  CLEAR ls_sel.
*
*    FREE MEMORY ID 'ZDEL'. " Commented by Karthik on 31.12.2019
*
**  if r13 <> abap_true.
**  lv_del = abap_true.
**  endif.
*
*    EXPORT lv_del TO MEMORY ID 'ZDEL'. " To restrict Deletion option
*
*    lv_mblnr = LIFNR.
*
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*      EXPORTING
*        input  = lv_mblnr
*      IMPORTING
*        output = lv_mblnr.
*
*    ls_borident-objkey = lv_mblnr.
*
**  CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
*    CONCATENATE ls_borident-objkey '_' LIFNR "Commented & Added by Gokulan.03.01.2021
*    INTO ls_borident-objkey.
*
*    CONDENSE ls_borident-objkey.
*
*    CREATE OBJECT lo_gos_manager
*      EXPORTING
*        is_object            = ls_borident
*        it_service_selection = lt_sel
*        ip_no_commit         = ' '
*      EXCEPTIONS
*        object_invalid       = 1.
*
*  ELSE.
*
*    ls_sel-sign = 'I'.
*    ls_sel-option = 'EQ'.
*    ls_sel-low = 'VIEW_ATTA'.
*    ls_sel-high = 'VIEW_ATTA'.
*    APPEND ls_sel TO lt_sel.
*    CLEAR ls_sel.
*
**  FREE MEMORY ID 'ZDEL'. " Commented by Karthik on 31.12.2019
*
**  if r13 <> abap_true.
*    lv_del = abap_true.
**  endif.
*
*    EXPORT lv_del TO MEMORY ID 'ZDEL'. " To restrict Deletion option
*
*    lv_mblnr = LIFNR.
*
*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*      EXPORTING
*        input  = lv_mblnr
*      IMPORTING
*        output = lv_mblnr.
*
*    ls_borident-objkey = lv_mblnr.
*
**  CONCATENATE ls_borident-objkey '_' sy-datum+0(4)
*    CONCATENATE ls_borident-objkey '_' LIFNR "Commented & Added by Gokulan.03.01.2021
*    INTO ls_borident-objkey.
*
*    CONDENSE ls_borident-objkey.
*
*    CREATE OBJECT lo_gos_manager
*      EXPORTING
*        is_object            = ls_borident
*        it_service_selection = lt_sel
*        ip_no_commit         = ' '
*      EXCEPTIONS
*        object_invalid       = 1.
*
*  ENDIF.
*endform.
