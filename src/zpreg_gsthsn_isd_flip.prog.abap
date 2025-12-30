*&---------------------------------------------------------------------*
*& Report  ZPREG_GSTHSN_ISD_FLIP
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zpreg_gsthsn_isd_flip_a1.

TABLES: zpreg_doc_cat,
        zpreg_isd,
        bkpf,
        zpreg_remisd.

DATA: it_zpreg_isd     TYPE TABLE OF zpreg_isd,
      wa_zpreg_isd     TYPE zpreg_isd,
      it_zpreg_doc_cat TYPE TABLE OF zpreg_doc_cat,
      wa_zpreg_doc_cat TYPE zpreg_doc_cat.

DATA: it_zpreg_remisd TYPE TABLE OF zpreg_remisd,
      wa_zpreg_remisd TYPE zpreg_remisd.

TYPES : BEGIN OF itab1,
          gjahr    TYPE bkpf-gjahr,
          belnr    TYPE bkpf-belnr,
          count(3) TYPE c,
        END OF itab1.

TYPES : BEGIN OF itaf1,
          gjahr    TYPE bkpf-gjahr,
          belnr    TYPE bkpf-belnr,
          blart    TYPE bkpf-blart,
          count(3) TYPE c,
        END OF itaf1.

TYPES : BEGIN OF disp2,
          gjahr TYPE bkpf-gjahr,
          belnr TYPE bkpf-belnr,
          blart TYPE bkpf-blart,
          cpudt TYPE sy-datum,
          usnam TYPE zpreg_isd-usnam,
        END OF disp2.

TYPES : BEGIN OF disp1,
          gjahr TYPE bkpf-gjahr,
          belnr TYPE bkpf-belnr,
          cpudt TYPE sy-datum,
          usnam TYPE zpreg_isd-usnam,
        END OF disp1.

DATA: it_tab1  TYPE TABLE OF itab1,
      wa_tab1  TYPE itab1,
      it_disp1 TYPE TABLE OF disp1,
      wa_disp1 TYPE disp1,
      it_disp2 TYPE TABLE OF disp2,
      wa_disp2 TYPE disp2,
      it_taf1  TYPE TABLE OF itaf1,
      wa_taf1  TYPE itaf1.

DATA: it_dropdown TYPE lvc_t_drop,
      ty_dropdown TYPE lvc_s_drop,
*data declaration for refreshing of alv
      stable      TYPE lvc_s_stbl.
*Global variable declaration
DATA: gstring TYPE c.
DATA: inp TYPE i.
*Data declarations for ALV
DATA: c_ccont   TYPE REF TO cl_gui_custom_container,         "Custom container object
      c_alvgd   TYPE REF TO cl_gui_alv_grid,         "ALV grid object
      it_fcat   TYPE lvc_t_fcat,                  "Field catalogue
      it_layout TYPE lvc_s_layo.                  "Layout
*ok code declaration
DATA:
  ok_code       TYPE ui_func.
DATA:  zpreg_isd_wa TYPE  zpreg_isd.
DATA:  zpreg_doc_cat_wa TYPE  zpreg_doc_cat.
DATA: zpreg_remisd_wa TYPE zpreg_remisd.
*********************************************
SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE text-001.
PARAMETERS : year LIKE bkpf-gjahr OBLIGATORY.

PARAMETERS : i1 RADIOBUTTON GROUP r1,
             i2 RADIOBUTTON GROUP r1,
             f1 RADIOBUTTON GROUP r1,
             f2 RADIOBUTTON GROUP r1,
             r1 RADIOBUTTON GROUP r1,
             r2 RADIOBUTTON GROUP r1.
SELECTION-SCREEN END OF BLOCK merkmale1 .

IF i1 EQ 'X' OR r1 EQ 'X'.
  PERFORM isdentry.
ELSEIF i2 EQ 'X'.
  PERFORM isddisplay.
ELSEIF f1 EQ 'X'.
  PERFORM flip.
ELSEIF f2 EQ 'X'.
  PERFORM flipdisplay.
ELSEIF r2 EQ 'X'.
  PERFORM disremisd.  "DISPALY ISD GL ENTRIES FROM PURCHASE REGISTER
ENDIF.

CALL SCREEN 0100.
*&---------------------------------------------------------------------*
*&      Form  ISDENTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM isdentry .

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '1'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.
  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '2'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.
  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '3'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.
  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '4'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.
  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '5'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.
  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '6'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.
  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '7'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.
  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '8'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.
  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '9'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '10'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '11'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '12'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '13'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '14'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '15'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '16'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '17'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '18'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '19'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.

  wa_tab1-gjahr = year.
  wa_tab1-belnr = space.
  wa_tab1-count = '20'.
  COLLECT wa_tab1 INTO it_tab1.
  CLEAR wa_tab1.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ISDDISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM isddisplay .

  SELECT * FROM zpreg_isd INTO TABLE it_zpreg_isd WHERE gjahr EQ year.
  IF sy-subrc NE 0.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.

  LOOP AT it_zpreg_isd INTO wa_zpreg_isd.
    wa_disp1-belnr = wa_zpreg_isd-belnr.
    wa_disp1-gjahr = wa_zpreg_isd-gjahr.
    wa_disp1-cpudt = wa_zpreg_isd-cpudt.
    wa_disp1-usnam = wa_zpreg_isd-usnam.
    COLLECT wa_disp1 INTO it_disp1.
    CLEAR wa_disp1.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FLIP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM flip .


  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '1'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.
  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '2'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.
  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '3'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.
  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '4'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.
  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '5'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.
  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '6'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.
  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '7'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.
  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '8'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.
  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '9'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '10'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '11'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '12'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '13'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '14'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '15'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '16'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '17'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '18'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '19'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.

  wa_taf1-gjahr = year.
  wa_taf1-belnr = space.
  wa_taf1-count = '20'.
  COLLECT wa_taf1 INTO it_taf1.
  CLEAR wa_taf1.




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FLIPDISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM flipdisplay .
  SELECT * FROM zpreg_doc_cat INTO TABLE it_zpreg_doc_cat WHERE gjahr EQ year.
  IF sy-subrc NE 0.
    MESSAGE 'NO DATA' TYPE 'E'.
  ENDIF.

  LOOP AT it_zpreg_doc_cat INTO wa_zpreg_doc_cat.
    wa_disp2-belnr = wa_zpreg_doc_cat-belnr.
    wa_disp2-gjahr = wa_zpreg_doc_cat-gjahr.
    wa_disp2-blart = wa_zpreg_doc_cat-blart.
    wa_disp2-cpudt = wa_zpreg_doc_cat-cpudt.
    wa_disp2-usnam = wa_zpreg_doc_cat-usnam.
    COLLECT wa_disp2 INTO it_disp2.
    CLEAR wa_disp2.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF i1 EQ 'X' OR f1 EQ 'X' .
    SET PF-STATUS 'STATUS'.
    SET TITLEBAR 'CREATE'.
  ELSEIF r1 EQ 'X'.
    SET PF-STATUS 'STATUS'.
    SET TITLEBAR 'REMOVE'.
  ELSEIF r2 EQ 'X'.
    SET PF-STATUS 'STATUS1'.
    SET TITLEBAR 'DISPLAY1'.
  ELSE.
    SET PF-STATUS 'STATUS1'.
    SET TITLEBAR 'DISPLAY'.
  ENDIF.

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
  IF f1 EQ 'X'.
*    * DEFINE A DROP DOWN TABLE.
    PERFORM dropdown_table.
  ENDIF.
* Set ALV attributes FOR LAYOUT
  PERFORM alv_report_layout.
  CHECK NOT c_alvgd IS INITIAL.
* Call ALV GRID
  IF i1 EQ 'X' OR r1 EQ 'X'.
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

  ELSEIF i2 EQ 'X' OR r2 EQ 'X'.
    CALL METHOD c_alvgd->set_table_for_first_display
      EXPORTING
        is_layout                     = it_layout
        i_save                        = 'A'
      CHANGING
        it_outtab                     = it_disp1
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

  ELSEIF f1 EQ 'X'.
    CALL METHOD c_alvgd->set_table_for_first_display
      EXPORTING
        is_layout                     = it_layout
        i_save                        = 'A'
      CHANGING
        it_outtab                     = it_taf1
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

  ELSEIF f2 EQ 'X'.
    CALL METHOD c_alvgd->set_table_for_first_display
      EXPORTING
        is_layout                     = it_layout
        i_save                        = 'A'
      CHANGING
        it_outtab                     = it_disp2
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

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.



  IF i1 EQ 'X' OR f1 EQ 'X' OR r1 EQ 'X'.
    c_alvgd->check_changed_data( ).


    IF i1 EQ 'X' OR r1 EQ 'X'.
      CLEAR inp.
      LOOP AT it_tab1 INTO wa_tab1 WHERE belnr GT 0.
        inp = 1.
      ENDLOOP.
      IF inp EQ 0.
        MESSAGE 'NO DATA' TYPE 'I'.
*    EXIT.
        LEAVE PROGRAM.
      ENDIF.
    ELSEIF f1 EQ 'X'.
      CLEAR inp.
      LOOP AT it_taf1 INTO wa_taf1 WHERE belnr GT 0.
        inp = 1.
      ENDLOOP.
      IF inp EQ 0.
        MESSAGE 'NO DATA' TYPE 'I'.
*    EXIT.
        LEAVE PROGRAM.
      ENDIF.
    ENDIF.



*Based on the user input
*When user clicks 'SAVE;
*    BREAK-POINT.
    CASE ok_code.
      WHEN 'SAVE'.
**A pop up is called to confirm the saving of changed data
*        CALL FUNCTION 'POPUP_TO_CONFIRM'
*          EXPORTING
*            TITLEBAR       = 'SAVING DATA'
*            TEXT_QUESTION  = 'Continue?'
*            ICON_BUTTON_1  = 'icon_booking_ok'
*          IMPORTING
*            ANSWER         = GSTRING
*          EXCEPTIONS
*            TEXT_NOT_FOUND = 1
*            OTHERS         = 2.
*        IF SY-SUBRC NE 0.
**       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**               WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*        ENDIF.
**When the User clicks 'YES'
*        IF ( GSTRING = '1' ).
*          MESSAGE 'Saved' TYPE 'S'.
*Now the changed data is stored in the it_pbo internal table
*        MODIFY zgk_emp FROM TABLE it_emp.
*Subroutine to display the ALV with changed data.
        IF i1 EQ 'X'.
          PERFORM redisplay.
        ELSEIF r1 EQ 'X'.
          PERFORM remisd.

        ELSEIF f1 EQ 'X'.
          PERFORM redisplay1.

        ENDIF.
*        ELSE.
**When user clicks NO or Cancel
*          MESSAGE 'Not Saved'  TYPE 'S'.
*        ENDIF.
**When the user clicks the 'EXIT; he is out
      WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
        LEAVE PROGRAM.
    ENDCASE.
    CLEAR: ok_code.
  ELSE.
    CASE ok_code.
      WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
        LEAVE PROGRAM.
    ENDCASE.
    CLEAR: ok_code.

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

  IF i1 EQ 'X' OR r1 EQ 'X'.

    CLEAR lv_fldcat.
    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '1'.
    lv_fldcat-fieldname = 'GJAHR'.
    lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'FISCAL YEAR'.
*  lv_fldcat-icon = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '2'.
    lv_fldcat-fieldname = 'BELNR'.
    lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'FI DOCUMNT NO.'.
*  lv_fldcat-icon = 'X'.
    lv_fldcat-edit = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.
  ELSEIF i2 EQ 'X' OR r2 EQ 'X'.


    CLEAR lv_fldcat.
    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '1'.
    lv_fldcat-fieldname = 'GJAHR'.
    lv_fldcat-tabname   = 'IT_DISP1'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'FISCAL YEAR'.
*  lv_fldcat-icon = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '2'.
    lv_fldcat-fieldname = 'BELNR'.
    lv_fldcat-tabname   = 'IT_DISP1'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'FI DOCUMNT NO.'.
*  lv_fldcat-icon = 'X'.
*  lv_fldcat-edit = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '3'.
    lv_fldcat-fieldname = 'CPUDT'.
    lv_fldcat-tabname   = 'IT_DISP1'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'DOC ENTERED ON'.
*  lv_fldcat-icon = 'X'.
*  lv_fldcat-edit = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '4'.
    lv_fldcat-fieldname = 'USNAM'.
    lv_fldcat-tabname   = 'IT_DISP1'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'DOC ENTERD BY'.
*  lv_fldcat-icon = 'X'.
*  lv_fldcat-edit = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

  ELSEIF f1 EQ 'X'.
    CLEAR lv_fldcat.
    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '1'.
    lv_fldcat-fieldname = 'GJAHR'.
    lv_fldcat-tabname   = 'IT_TAF1'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'FISCAL YEAR'.
*  lv_fldcat-icon = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '2'.
    lv_fldcat-fieldname = 'BELNR'.
    lv_fldcat-tabname   = 'IT_TAF1'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'FI DOCUMNT NO.'.
*  lv_fldcat-icon = 'X'.
    lv_fldcat-edit = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '3'.
    lv_fldcat-fieldname = 'BLART'.
    lv_fldcat-tabname   = 'IT_TAF1'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'CC- CROSS CHARG, SP-SALES PROMOTION '.
*  lv_fldcat-icon = 'X'.
    lv_fldcat-edit = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    DATA ls_fcat TYPE lvc_s_fcat.

*    ** To assign dropdown in the fieldcataogue
    LOOP AT it_fcat INTO ls_fcat.
      CASE ls_fcat-fieldname.

        WHEN 'BLART'.
          ls_fcat-drdn_hndl = '3'.
          ls_fcat-coltext = 'SELECT DATA'.
          ls_fcat-outputlen = 30.
          ls_fcat-edit = 'X'.
          MODIFY it_fcat FROM ls_fcat.
      ENDCASE.
    ENDLOOP.

  ELSEIF f2 EQ 'X'.

    CLEAR lv_fldcat.
    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '1'.
    lv_fldcat-fieldname = 'GJAHR'.
    lv_fldcat-tabname   = 'IT_DISP2'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'FISCAL YEAR'.
*  lv_fldcat-icon = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '2'.
    lv_fldcat-fieldname = 'BELNR'.
    lv_fldcat-tabname   = 'IT_DISP2'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'FI DOCUMNT NO.'.
*  lv_fldcat-icon = 'X'.
*    lv_fldcat-edit = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '3'.
    lv_fldcat-fieldname = 'BLART'.
    lv_fldcat-tabname   = 'IT_DISP2'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'CC- CROSS CHARG, SP-SALES PROMOTION '.
*  lv_fldcat-icon = 'X'.
*    lv_fldcat-edit = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.


    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '4'.
    lv_fldcat-fieldname = 'CPUDT'.
    lv_fldcat-tabname   = 'IT_DISP2'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'DOC ENTERED ON'.
*  lv_fldcat-icon = 'X'.
*  lv_fldcat-edit = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

    lv_fldcat-row_pos   = '1'.
    lv_fldcat-col_pos   = '5'.
    lv_fldcat-fieldname = 'USNAM'.
    lv_fldcat-tabname   = 'IT_DISP2'.
*  lv_fldcat-outputlen = 8.
    lv_fldcat-scrtext_m = 'DOC ENTERD BY'.
*  lv_fldcat-icon = 'X'.
*  lv_fldcat-edit = 'X'.
    APPEND lv_fldcat TO it_fcat.
    CLEAR lv_fldcat.

  ENDIF.

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
*Cells of the alv are made non editable after entering OK to save
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

  LOOP AT it_tab1 INTO wa_tab1 WHERE belnr GT 0.
    SELECT SINGLE * FROM bkpf WHERE bukrs EQ 'BCLL' AND belnr EQ wa_tab1-belnr AND gjahr EQ wa_tab1-gjahr.
    IF sy-subrc EQ 4.
      MESSAGE 'INVALID DATA' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM zpreg_isd  WHERE belnr EQ wa_tab1-belnr AND gjahr EQ wa_tab1-gjahr.
    IF sy-subrc EQ 0.
        message e963(zhr_message) with wa_tab1-belnr.
*        MESSAGE 'DATA ALREDAY EXIST' TYPE 'E'.
*      MESSAGE 'DATA ALREDAY EXIST' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM zpreg_doc_cat  WHERE belnr EQ wa_tab1-belnr AND gjahr EQ wa_tab1-gjahr.
    IF sy-subrc EQ 0.
       message e963(zhr_message) with wa_tab1-belnr.
*      MESSAGE 'DATA ALREDAY EXIST' TYPE 'E'.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tab1 INTO wa_tab1 WHERE belnr NE space.
    zpreg_isd_wa-belnr = wa_tab1-belnr.
    zpreg_isd_wa-gjahr = wa_tab1-gjahr.

    zpreg_isd_wa-cpudt = sy-datum.
    zpreg_isd_wa-usnam = sy-uname.

*    zpms_art_table_wa-usnam = sy-uname.
*    zpms_art_table_wa-cpudt = sy-datum.

    MODIFY zpreg_isd FROM zpreg_isd_wa.
    CLEAR zpreg_isd_wa.
  ENDLOOP.
  IF sy-subrc EQ 0.
    MESSAGE 'DATA SAVED' TYPE 'I'.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REDISPLAY1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM redisplay1 .

*Cells of the alv are made non editable after entering OK to save
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

  LOOP AT it_taf1 INTO wa_taf1 WHERE belnr GT 0.
    SELECT SINGLE * FROM bkpf WHERE bukrs EQ 'BCLL' AND belnr EQ wa_taf1-belnr AND gjahr EQ wa_taf1-gjahr.
    IF sy-subrc EQ 4.
      MESSAGE 'INVALID DATA' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM zpreg_doc_cat WHERE belnr EQ wa_taf1-belnr AND gjahr EQ wa_taf1-gjahr.
    IF sy-subrc EQ 0.
       message e963(zhr_message) with wa_taF1-belnr.
*      MESSAGE 'DATA ALREDAY EXIST' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM zpreg_isd  WHERE belnr EQ wa_taf1-belnr AND gjahr EQ wa_taf1-gjahr.
    IF sy-subrc EQ 0.
       message e963(zhr_message) with wa_taF1-belnr.
*      MESSAGE 'DATA ALREDAY EXIST' TYPE 'E'.
    ENDIF.
    IF wa_taf1-blart EQ 'SP'.
    ELSEIF  wa_taf1-blart EQ 'CC' .
      MESSAGE 'CROSS CHARGE ENTRIES ARE NOT ALLOWED' TYPE 'E'.
    ELSE.
      MESSAGE 'ENTER CORRECT DOCUMENT TYPE' TYPE 'E'.
    ENDIF.
  ENDLOOP.

  LOOP AT it_taf1 INTO wa_taf1 WHERE belnr GT 0.
    zpreg_doc_cat_wa-belnr = wa_taf1-belnr.
    zpreg_doc_cat_wa-gjahr = wa_taf1-gjahr.
    zpreg_doc_cat_wa-blart = wa_taf1-blart.
    zpreg_doc_cat_wa-cpudt = sy-datum.
    zpreg_doc_cat_wa-usnam = sy-uname.

*    zpms_art_table_wa-usnam = sy-uname.
*    zpms_art_table_wa-cpudt = sy-datum.

    MODIFY zpreg_doc_cat FROM zpreg_doc_cat_wa.
    CLEAR zpreg_doc_cat_wa.
  ENDLOOP.
  IF sy-subrc EQ 0.
    MESSAGE 'DATA SAVED' TYPE 'I'.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DROPDOWN_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dropdown_table .
  DATA: lt_dropdown TYPE lvc_t_drop,
        ls_dropdown TYPE lvc_s_drop.

  ls_dropdown-handle = '3'.
  ls_dropdown-value = 'CC'.
  APPEND ls_dropdown TO lt_dropdown.
  ls_dropdown-handle = '3'.
  ls_dropdown-value = 'SP'.
  APPEND ls_dropdown TO lt_dropdown.



*method to display the dropdown in ALV
  CALL METHOD c_alvgd->set_drop_down_table
    EXPORTING
      it_drop_down = lt_dropdown.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  REMISD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM remisd .
*Cells of the alv are made non editable after entering OK to save
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

  LOOP AT it_tab1 INTO wa_tab1 WHERE belnr GT 0.
    SELECT SINGLE * FROM bkpf WHERE bukrs EQ 'BCLL' AND belnr EQ wa_tab1-belnr AND gjahr EQ wa_tab1-gjahr.
    IF sy-subrc EQ 4.
      MESSAGE 'INVALID DATA' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM zpreg_remisd  WHERE belnr EQ wa_tab1-belnr AND gjahr EQ wa_tab1-gjahr.
    IF sy-subrc EQ 0.
       message e963(zhr_message) with wa_tab1-belnr.
*      MESSAGE 'DATA ALREDAY EXIST' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM zpreg_doc_cat  WHERE belnr EQ wa_tab1-belnr AND gjahr EQ wa_tab1-gjahr.
    IF sy-subrc EQ 0.
       message e963(zhr_message) with wa_tab1-belnr.
*      MESSAGE 'DATA ALREDAY EXIST' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM zpreg_isd  WHERE belnr EQ wa_tab1-belnr AND gjahr EQ wa_tab1-gjahr.
    IF sy-subrc EQ 0.
       message e963(zhr_message) with wa_tab1-belnr.
*      MESSAGE 'DATA ALREDAY EXIST' TYPE 'E'.
    ENDIF.
    IF year LE '2021'.
      MESSAGE 'ENTER DOCUMENT ONLY AFTER APRIL 22' TYPE 'E'.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tab1 INTO wa_tab1 WHERE belnr NE space.
    zpreg_remisd_wa-belnr = wa_tab1-belnr.
    zpreg_remisd_wa-gjahr = wa_tab1-gjahr.

    zpreg_remisd_wa-cpudt = sy-datum.
    zpreg_remisd_wa-usnam = sy-uname.

*    zpms_art_table_wa-usnam = sy-uname.
*    zpms_art_table_wa-cpudt = sy-datum.

    MODIFY zpreg_remisd FROM zpreg_remisd_wa.
    CLEAR zpreg_remisd_wa.
  ENDLOOP.
  IF sy-subrc EQ 0.
    MESSAGE 'DATA SAVED' TYPE 'I'.
    LEAVE TO SCREEN 0.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISREMISD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM disremisd .
  SELECT * FROM zpreg_remisd INTO TABLE it_zpreg_remisd WHERE gjahr EQ year.
  IF sy-subrc NE 0.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.

  LOOP AT it_zpreg_remisd INTO wa_zpreg_remisd.
    wa_disp1-belnr = wa_zpreg_remisd-belnr.
    wa_disp1-gjahr = wa_zpreg_remisd-gjahr.
    wa_disp1-cpudt = wa_zpreg_remisd-cpudt.
    wa_disp1-usnam = wa_zpreg_remisd-usnam.
    COLLECT wa_disp1 INTO it_disp1.
    CLEAR wa_disp1.
  ENDLOOP.
ENDFORM.
