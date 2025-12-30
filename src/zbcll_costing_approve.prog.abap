*&---------------------------------------------------------------------*
*& Report  ZBCLL_COSTING_APPROVE
*&*
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zbcll_costing_approve_a1.

TABLES: ztp_cost14,
        ztp_cost11,
        pa0001,
        ztp_cost15,
        pa0105,
        zpa0001.

TYPE-POOLS : slis.

DATA : it_ztp_cost11 TYPE TABLE OF ztp_cost11,
       wa_ztp_cost11 TYPE ztp_cost11,
       it_ztp_cost14 TYPE TABLE OF ztp_cost14,
       wa_ztp_cost14 TYPE ztp_cost14.

TYPES: BEGIN OF itab1,
         vbeln  TYPE ztp_cost11-vbeln,
         gjahr  TYPE ztp_cost11-gjahr,
         apr(1) TYPE c,
         rej(1) TYPE c,
         txt    TYPE string,
       END OF itab1.

TYPES: BEGIN OF itab2,
         vbeln    TYPE ztp_cost11-vbeln,
         gjahr    TYPE ztp_cost11-gjahr,
         proddt   TYPE sy-datum,
         prodtxt  TYPE ztp_cost14-prodtxt,
         prodname TYPE pa0001-ename,
         apr(1)   TYPE c,
         rej(1)   TYPE c,
         txt      TYPE string,
       END OF itab2.

TYPES: BEGIN OF itab3,
         vbeln    TYPE ztp_cost11-vbeln,
         gjahr    TYPE ztp_cost11-gjahr,
         proddt   TYPE sy-datum,
         prodtxt  TYPE ztp_cost14-prodtxt,
         prodname TYPE pa0001-ename,
         purdt    TYPE sy-datum,
         purtxt   TYPE ztp_cost14-prodtxt,
         purname  TYPE pa0001-ename,
         apr(1)   TYPE c,
         rej(1)   TYPE c,
         txt      TYPE string,
       END OF itab3.

TYPES: BEGIN OF itab4,
         vbeln    TYPE ztp_cost11-vbeln,
         gjahr    TYPE ztp_cost11-gjahr,
         proddt   TYPE sy-datum,
         prodtxt  TYPE ztp_cost14-prodtxt,
         prodname TYPE pa0001-ename,
         purdt    TYPE sy-datum,
         purtxt   TYPE ztp_cost14-prodtxt,
         purname  TYPE pa0001-ename,
         acctdt   TYPE sy-datum,
         accttxt  TYPE ztp_cost14-prodtxt,
         acctname TYPE pa0001-ename,
         apr(1)   TYPE c,
         rej(1)   TYPE c,
         txt      TYPE string,
       END OF itab4.

TYPES: BEGIN OF itab5,
         vbeln    TYPE ztp_cost11-vbeln,
         gjahr    TYPE ztp_cost11-gjahr,
         proddt   TYPE sy-datum,
         prodtxt  TYPE ztp_cost14-prodtxt,
         prodname TYPE pa0001-ename,
         purdt    TYPE sy-datum,
         purtxt   TYPE ztp_cost14-prodtxt,
         purname  TYPE pa0001-ename,
         acctdt   TYPE sy-datum,
         accttxt  TYPE ztp_cost14-prodtxt,
         acctname TYPE pa0001-ename,
         fidt     TYPE sy-datum,
         fitxt    TYPE ztp_cost14-prodtxt,
         finame   TYPE pa0001-ename,
         apr(1)   TYPE c,
         rej(1)   TYPE c,
         txt      TYPE string,
       END OF itab5.

DATA: it_tab1 TYPE TABLE OF itab1,
      wa_tab1 TYPE itab1,
      it_tab2 TYPE TABLE OF itab2,
      wa_tab2 TYPE itab2,
      it_tab3 TYPE TABLE OF itab3,
      wa_tab3 TYPE itab3,
      it_tab4 TYPE TABLE OF itab4,
      wa_tab4 TYPE itab4,
      it_tab5 TYPE TABLE OF itab5,
      wa_tab5 TYPE itab5.

DATA: gstring TYPE c.
*Data declarations for ALV
DATA: c_ccont   TYPE REF TO cl_gui_custom_container,         "Custom container object
      c_alvgd   TYPE REF TO cl_gui_alv_grid,         "ALV grid object
      it_fcat   TYPE lvc_t_fcat,                  "Field catalogue
      it_layout TYPE lvc_s_layo.                  "Layout
*ok code declaration
DATA:
  ok_code       TYPE ui_func.
DATA: ztp_cost14_wa TYPE ztp_cost14.
******************************
DATA: v_form_name TYPE rs38l_fnam.
DATA : w_return    TYPE ssfcrescl.
DATA: i_otf      TYPE itcoo    OCCURS 0 WITH HEADER LINE,
      i_tline    LIKE tline    OCCURS 0 WITH HEADER LINE,
      i_record   LIKE solisti1 OCCURS 0 WITH HEADER LINE,
      i_xstring  TYPE xstring,
* Objects to send mail.
      i_objpack  LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,
      i_objtxt   LIKE solisti1   OCCURS 0 WITH HEADER LINE,
      i_objbin   LIKE solix      OCCURS 0 WITH HEADER LINE,
      i_reclist  LIKE somlreci1  OCCURS 0 WITH HEADER LINE,
* Work Area declarations
      wa_objhead TYPE soli_tab,
      w_ctrlop   TYPE ssfctrlop,
      w_compop   TYPE ssfcompop,
*      w_return    TYPE ssfcrescl,
      wa_buffer  TYPE string,
* Variables declarations
*      v_form_name type rs38l_fnam,
      v_len_in   LIKE sood-objlen.

DATA: in_mailid TYPE ad_smtpadr.
DATA: format(10) TYPE c.
DATA: ntext1(100) TYPE c.
*************************************************************
DATA: finaltxt      TYPE ztp_cost14-prodtxt.

TABLES :
*  ztp_cost11,
  ztp_cost12,
  makt,
  mara,
  lfa1,
  marm,
  mast,
  stko,
  mvke,
  tvm5t.
*         ztp_cost14,
*         pa0001.

TYPES : BEGIN OF itab51,

          idnrk      TYPE stpo-idnrk,
          imaktx(65) TYPE c,
          menge(10)  TYPE c,
          meins(3)   TYPE c,
          rate(10)   TYPE c,
          gstrate(7) TYPE c,
          gstval(12) TYPE c,
          frtper(7)  TYPE c,
          frtrate(7) TYPE c,
          frtval(12) TYPE c,
          v1(12)     TYPE c,
          v2(10)     TYPE c,
          mtart      TYPE mara-mtart,
          posnr      TYPE stpo-posnr,
        END OF itab51.


DATA:
*      it_ztp_cost11 type table of ztp_cost11,
*      wa_ztp_cost11 type ztp_cost11,
  it_ztp_cost12 TYPE TABLE OF ztp_cost12,
  wa_ztp_cost12 TYPE ztp_cost12.
DATA: it_tab51 TYPE TABLE OF itab51,
      wa_tab51 TYPE itab51.
DATA: m2 TYPE p DECIMALS 2,
      m3 TYPE p DECIMALS 2,
      m4 TYPE p DECIMALS 2,
      m5 TYPE p DECIMALS 2,
      m6 TYPE p DECIMALS 2,
      m7 TYPE p DECIMALS 2,
      m8 TYPE p DECIMALS 2,
      m9 TYPE p DECIMALS 2.

DATA: dr2(15)      TYPE c,
      dp2(15)      TYPE c,
      drp1(15)     TYPE c,
      dmargin(15)  TYPE c,
      dm1(15)      TYPE c,
      dccpc(15)    TYPE c,
      danaval(15)  TYPE c,
      danart(15)   TYPE c,
      dtot1(15)    TYPE c,
      dgstval1(15) TYPE c,
      dnet(15)     TYPE c.
DATA: f2(1)   TYPE c,
      fgname1 TYPE lfa1-name1,
      pack    TYPE tvm5t-bezei,
      uom     TYPE marm-meinh,
      cpudt   TYPE sy-datum.
DATA: rmyldqty1(20) TYPE c,
      pmyldqty1(20) TYPE c,
      tqty1(15)     TYPE c,
      yield1(10)    TYPE c,
      yield2(10)    TYPE c,
      qty(20)       TYPE c,
      material      LIKE mara-matnr,
      werks         TYPE mcha-werks,
      fglifnr       TYPE lfa1-lifnr,
      stlal         TYPE mast-stlal,
      r21(20)       TYPE c,
      p2(20)        TYPE c,
      rp1(20)       TYPE c,
      m1(20)        TYPE c,
      ccpc(20)      TYPE c,
      anaval(20)    TYPE c,
      anart(20)     TYPE c,
      gstval1(20)   TYPE c,
      net(20)       TYPE c,
      margin(20)    TYPE c,
      fggst(20)     TYPE c,
      bmeng         TYPE stko-bmeng,
      batsz(20)     TYPE c,
      rmyld         TYPE p DECIMALS 2,
      pmyld         TYPE p DECIMALS 2,
      maktx         TYPE makt-maktx,
      bmein         TYPE stko-bmein,
      rmyldqty      TYPE p,
      pmyldqty      TYPE p.
DATA: tot1    TYPE p DECIMALS 2,
      tot(10) TYPE c.

DATA: qty1(20) TYPE c.

DATA: q1 TYPE p,
      q2 TYPE p,
      q3 TYPE p,
      q4 TYPE p.

DATA : v_fm TYPE rs38l_fnam.
TYPES : BEGIN OF check,
          gjahr TYPE ztp_cost11-gjahr,
          vbeln TYPE ztp_cost11-vbeln,
        END OF check.
*DATA: IT_CHECK TYPE TABLE OF CHECK,
*      WA_CHECK TYPE CHECK.
*data: vbeln(10) type c,
*      gjahr(4)  type c.

DATA : control  TYPE ssfctrlop.
DATA : w_ssfcompop TYPE ssfcompop.

DATA: prodstat(10)  TYPE c,
      proddt        TYPE sy-datum,
      prodname      TYPE pa0001-ename,
      prodtxt       TYPE ztp_cost14-prodtxt,

      purstat(10)   TYPE c,
      purdt         TYPE sy-datum,
      purname       TYPE pa0001-ename,
      purtxt        TYPE ztp_cost14-prodtxt,
      acctstat(10)  TYPE c,
      acctdt        TYPE sy-datum,
      acctname      TYPE pa0001-ename,
      accttxt       TYPE ztp_cost14-prodtxt,
      fistat(10)    TYPE c,
      fidt          TYPE sy-datum,
      finame        TYPE pa0001-ename,
      fitxt         TYPE ztp_cost14-prodtxt,
      finalstat(10) TYPE c,
      finaldt       TYPE sy-datum,
      finalname     TYPE pa0001-ename.
DATA: status(20) TYPE c.
DATA: subject(100) TYPE c.
DATA: pernr TYPE pa0001-pernr,
      btrtl TYPE pa0001-btrtl.
*      finaltxt      type ztp_cost14-prodtxt.
***************************************************************
*********************************************************************************************************************
*SELECTION-SCREEN BEGIN OF BLOCK merkmale2 WITH FRAME TITLE text-001.
*PARAMETERS : pernr    LIKE pa0001-pernr MATCHCODE OBJECT prem OBLIGATORY,
*             pass(10) TYPE c OBLIGATORY.
*SELECTION-SCREEN END OF BLOCK merkmale2.

SELECTION-SCREEN BEGIN OF BLOCK merkmale3 WITH FRAME TITLE TEXT-001.
  PARAMETERS : vbeln    TYPE ztp_cost11-vbeln MATCHCODE OBJECT ztp_cost1 OBLIGATORY,
               gjahr(4) TYPE c OBLIGATORY.
SELECTION-SCREEN END OF BLOCK merkmale3.

SELECTION-SCREEN BEGIN OF BLOCK merkmale1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : ra RADIOBUTTON GROUP r1,
               r1 RADIOBUTTON GROUP r1, "purch
               r2 RADIOBUTTON GROUP r1. "acc
*               r3 RADIOBUTTON GROUP r1. "Accounts
*             r4 RADIOBUTTON GROUP r1, "FI,
*             r5 RADIOBUTTON GROUP r1. "final approval
SELECTION-SCREEN END OF BLOCK merkmale1.

AT SELECTION-SCREEN.
  PERFORM authorization.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    CHECK screen-name EQ 'PASS'.
    screen-invisible = 1.
    MODIFY SCREEN.
  ENDLOOP.

  IF sy-datum+4(2) GE '04'.
    gjahr = sy-datum+0(4).
  ELSE.
    gjahr = sy-datum+0(4) - 1.
  ENDIF.

START-OF-SELECTION .

  SELECT SINGLE * FROM pa0105 WHERE usrid EQ sy-uname.
  IF sy-subrc EQ 0.
    pernr = pa0105-pernr.
  ENDIF.
  SELECT SINGLE * FROM zpa0001 WHERE pernr EQ pernr.
  IF sy-subrc EQ 0.
    btrtl = zpa0001-btrtl.
  ENDIF.
  IF ra EQ 'X'.
    PERFORM viewcs.
  ELSE.
    IF r1 EQ 'X'.
      IF btrtl EQ '1121'.
      ELSE.
        MESSAGE 'INVALID APPROVER' TYPE 'E'.
      ENDIF.
      PERFORM prodsel.
    ELSEIF r2 EQ 'X'.
      IF btrtl EQ '1201'.
      ELSE.
        MESSAGE 'INVALID APPROVER' TYPE 'E'.
      ENDIF.
      PERFORM pursel.
*    ELSEIF r3 EQ 'X'.
*      PERFORM acctsel.
*    ELSEIF r4 EQ 'X'.
*      PERFORM fisel.
*    ELSEIF r5 EQ 'X'.
*      PERFORM finalsel.
    ENDIF.
    CALL SCREEN 0900.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  APPROVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prodsel.
  CLEAR : it_ztp_cost11,wa_ztp_cost11.
*  BREAK-POINT .
  SELECT * FROM ztp_cost11 INTO TABLE it_ztp_cost11 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 4.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.

  SELECT SINGLE * FROM ztp_cost15 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 0.
    MESSAGE 'THIS COST SHEET IS REJECTED' TYPE 'E'.
  ENDIF.

  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND prod GT 0.
  IF sy-subrc EQ 0.
    MESSAGE 'Purchase  APPROVAL/REJECTION IS ALREDY DONE FOR THIS COSTSHEET' TYPE 'E'.
  ENDIF.

  LOOP AT it_ztp_cost11 INTO wa_ztp_cost11.
    wa_tab1-vbeln = wa_ztp_cost11-vbeln.
    wa_tab1-gjahr = wa_ztp_cost11-gjahr.
    wa_tab1-apr = space.
    wa_tab1-rej = space.
    wa_tab1-txt = space.
    COLLECT wa_tab1 INTO it_tab1.
    CLEAR wa_tab1.
  ENDLOOP.
*  BREAK-POINT.
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

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0900  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0900 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'APPROVE'.
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
*    PERFORM ALV_BUILD_FIELDCAT1.
*  ELSEIF R1 EQ 'X'.  "HOD APPROVAL
  IF r1 EQ 'X'.
    PERFORM alv_build_fieldcat1.
  ELSEIF r2 EQ 'X'.
    PERFORM alv_build_fieldcat2.
*  ELSEIF r3 EQ 'X'.
*    PERFORM alv_build_fieldcat3.
*  ELSEIF r4 EQ 'X'.
*    PERFORM alv_build_fieldcat4.
*  ELSEIF r5 EQ 'X'.
*    PERFORM alv_build_fieldcat5.
  ENDIF.
*  ELSEIF R11 EQ 'X'.  "FINAL APPROVAL
*    PERFORM ALV_BUILD_FIELDCAT3.
*  ELSE.
*    PERFORM ALV_BUILD_FIELDCAT.
*  ENDIF.

* Set ALV attributes FOR LAYOUT
  PERFORM alv_report_layout.
  CHECK NOT c_alvgd IS INITIAL.
* Call ALV GRID
*  IF R1A EQ 'X'.
*    CALL METHOD C_ALVGD->SET_TABLE_FOR_FIRST_DISPLAY
*      EXPORTING
*        IS_LAYOUT                     = IT_LAYOUT
*        I_SAVE                        = 'A'
*      CHANGING
*        IT_OUTTAB                     = IT_TAB1
*        IT_FIELDCATALOG               = IT_FCAT
*      EXCEPTIONS
*        INVALID_PARAMETER_COMBINATION = 1
*        PROGRAM_ERROR                 = 2
*        TOO_MANY_LINES                = 3
*        OTHERS                        = 4.
*    IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*    ENDIF.
*  ELSEIF R1 EQ 'X'.
  IF r1 EQ 'X'.
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
  ELSEIF r2 EQ 'X'.

    CALL METHOD c_alvgd->set_table_for_first_display
      EXPORTING
        is_layout                     = it_layout
        i_save                        = 'A'
      CHANGING
        it_outtab                     = it_tab2
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

*  ELSEIF r3 EQ 'X'.
*
*    CALL METHOD c_alvgd->set_table_for_first_display
*      EXPORTING
*        is_layout                     = it_layout
*        i_save                        = 'A'
*      CHANGING
*        it_outtab                     = it_tab3
*        it_fieldcatalog               = it_fcat
*      EXCEPTIONS
*        invalid_parameter_combination = 1
*        program_error                 = 2
*        too_many_lines                = 3
*        OTHERS                        = 4.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.

*  ELSEIF r4 EQ 'X'.
*
*    CALL METHOD c_alvgd->set_table_for_first_display
*      EXPORTING
*        is_layout                     = it_layout
*        i_save                        = 'A'
*      CHANGING
*        it_outtab                     = it_tab4
*        it_fieldcatalog               = it_fcat
*      EXCEPTIONS
*        invalid_parameter_combination = 1
*        program_error                 = 2
*        too_many_lines                = 3
*        OTHERS                        = 4.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.
*
*  ELSEIF r5 EQ 'X'.
*
*    CALL METHOD c_alvgd->set_table_for_first_display
*      EXPORTING
*        is_layout                     = it_layout
*        i_save                        = 'A'
*      CHANGING
*        it_outtab                     = it_tab5
*        it_fieldcatalog               = it_fcat
*      EXCEPTIONS
*        invalid_parameter_combination = 1
*        program_error                 = 2
*        too_many_lines                = 3
*        OTHERS                        = 4.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.


  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat1.
  DATA lv_fldcat TYPE lvc_s_fcat.

  lv_fldcat-fieldname = 'VBELN'.
  lv_fldcat-scrtext_l = 'COSTSHEET NO.'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'GJAHR'.
  lv_fldcat-scrtext_l = 'F.YEARR'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'APR'.
  lv_fldcat-scrtext_l = 'APPROVE'.
  lv_fldcat-checkbox = 'X'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'REJ'.
  lv_fldcat-scrtext_l = 'REJECT'.
  lv_fldcat-checkbox = 'X'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'TXT'.
  lv_fldcat-scrtext_l = 'REMARK'.
  lv_fldcat-edit = 'X'.
  lv_fldcat-outputlen = '40'.
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
*&      Module  USER_COMMAND_0900  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0900 INPUT.
  c_alvgd->check_changed_data( ).

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
*          MESSAGE 'Saved' TYPE 'S'.
*Now the changed data is stored in the it_pbo internal table
*        MODIFY zgk_emp FROM TABLE it_emp.
*Subroutine to display the ALV with changed data.
*          IF R1A EQ 'X'.
*            PERFORM REDISPLAY.
*            CLEAR: OK_CODE.
*            LEAVE TO TRANSACTION 'ZPUR_REQ'.
*          ELSEIF R1 EQ 'X'.
        IF r1 EQ 'X'.
          PERFORM prodapprove.
        ELSEIF r2 EQ 'X'.
          PERFORM purapprove.
*        ELSEIF r3 EQ 'X'.
*          PERFORM acctapprove.
*        ELSEIF r4 EQ 'X'.
*          PERFORM fiapprove.
*        ELSEIF r5 EQ 'X'.
*          PERFORM finalapprove.
        ENDIF.
        CLEAR: ok_code.
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
  CLEAR: ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  PRODAPPROVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prodapprove.

  LOOP AT it_tab1 INTO wa_tab1.
    IF wa_tab1-apr EQ space AND wa_tab1-rej EQ space.
      MESSAGE 'Select APPROVE or REJECT' TYPE 'E'.
    ENDIF.
    IF wa_tab1-apr NE space AND wa_tab1-rej NE space.
      MESSAGE 'Either APPROVE or REJECT' TYPE 'E'.
    ENDIF.

    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab1-vbeln AND gjahr = wa_tab1-gjahr.
    IF sy-subrc EQ 0.
      MESSAGE 'Selection is alredy dobe by Production' TYPE 'E'.
    ENDIF.
  ENDLOOP.


  LOOP AT it_tab1 INTO wa_tab1.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab1-vbeln AND gjahr = wa_tab1-gjahr.
    IF sy-subrc EQ 4.
      ztp_cost14_wa-vbeln = wa_tab1-vbeln.
      ztp_cost14_wa-gjahr = wa_tab1-gjahr.
      ztp_cost14_wa-prod = pernr.
      ztp_cost14_wa-prodapr = wa_tab1-apr.
      ztp_cost14_wa-prodrej = wa_tab1-rej.
      ztp_cost14_wa-proddt = sy-datum.
      ztp_cost14_wa-prodtm = sy-uzeit.
      ztp_cost14_wa-prodtxt = wa_tab1-txt.
      MODIFY  ztp_cost14 FROM  ztp_cost14_wa.
      COMMIT WORK AND WAIT .
      CLEAR  ztp_cost14_wa.
    ENDIF.
  ENDLOOP.
  IF it_tab1 IS NOT INITIAL.
    PERFORM email.
  ENDIF.
  IF sy-subrc EQ 0.
    MESSAGE 'DATA SAVED' TYPE 'I'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PURAPPROVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM purapprove .
  LOOP AT it_tab2 INTO wa_tab2.
* commented from 741 to 748 by madhuri given by jyothsna mam 13/11/2025
*    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab2-vbeln AND gjahr = wa_tab2-gjahr AND prodapr EQ 'X'.
*    IF sy-subrc EQ 4.
*      MESSAGE 'NOT YET APPROOVED BY PRODUCTION DEPARTMENT' TYPE 'E'.
*    ENDIF.
*    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab2-vbeln AND gjahr = wa_tab2-gjahr AND prodapr EQ 'X' AND pur EQ '00000000'.
*    IF sy-subrc EQ 4.
*      MESSAGE 'PLZ CHECK PURCHASE APPROVAL/ REJECTION' TYPE 'E'.
*    ENDIF.
    IF wa_tab2-apr EQ space AND wa_tab2-rej EQ space.
      MESSAGE 'Select APPROVE or REJECT' TYPE 'E'.
    ENDIF.
    IF wa_tab2-apr NE space AND wa_tab2-rej NE space.
      MESSAGE 'Either APPROVE or REJECT' TYPE 'E'.
    ENDIF.
  ENDLOOP.
*  BREAK-POINT .

  LOOP AT it_tab2 INTO wa_tab2.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab2-vbeln AND gjahr = wa_tab2-gjahr.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING ztp_cost14 TO ztp_cost14_wa.
      ztp_cost14_wa-pur = pernr.
      ztp_cost14_wa-purapr = wa_tab2-apr.
      ztp_cost14_wa-purrej = wa_tab2-rej.
      ztp_cost14_wa-purdt = sy-datum.
      ztp_cost14_wa-purtm = sy-uzeit.
      ztp_cost14_wa-purtxt = wa_tab2-txt.
      ztp_cost14_wa-purapprover = sy-uname.

      MODIFY  ztp_cost14 FROM  ztp_cost14_wa.
      COMMIT WORK AND WAIT .
      CLEAR  ztp_cost14_wa.
    ENDIF.
  ENDLOOP.
  IF it_tab2 IS NOT INITIAL.
    PERFORM email.  "email deactivated
  ENDIF.
  IF sy-subrc EQ 0.
    MESSAGE 'DATA SAVED' TYPE 'I'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PURSEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pursel .
*  BREAK-POINT.
  SELECT SINGLE * FROM ztp_cost11 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 4.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.

  SELECT SINGLE * FROM ztp_cost15 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 0.
    MESSAGE 'THIS COST SHEET IS REJECTED' TYPE 'E'.
  ENDIF.


*  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND pur GT 0.
*  IF sy-subrc EQ 0.
*    MESSAGE 'Purchase  APPROVAL/REJECTION IS ALREDY DONE FOR THIS COSTSHEET' TYPE 'E'.
*  ENDIF.

  IF r1 EQ 'X'.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND pROD GT 0.
    IF sy-subrc EQ 0.
      MESSAGE 'Purchase  APPROVAL/REJECTION IS ALREDY DONE FOR THIS COSTSHEET' TYPE 'E'.
    ENDIF.
  ENDIF.
  IF r2 EQ 'X'.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND pur GT 0.
    IF sy-subrc EQ 0.
      MESSAGE 'Accounts  APPROVAL/REJECTION IS ALREDY DONE FOR THIS COSTSHEET' TYPE 'E'.
    ENDIF.
  ENDIF.

*  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND prodapr EQ space.
*  IF sy-subrc EQ 0.
*    MESSAGE 'NOT YET APPROVED BY PRODUCTION FOR THIS COSTSHEET' TYPE 'E'.
*  ENDIF.

*  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND prodapr EQ 'X' AND pur EQ '00000000'.
*  IF sy-subrc EQ 0.
*  ELSE.
*    MESSAGE 'PURCHASE  APPROVAL/REJECTION IS ALREADY DONE FOR THIS COSTSHEET' TYPE 'E'.
*  ENDIF.
  CLEAR : it_ztp_cost14.
  SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.  " AND prodapr EQ 'X'.

  IF it_ztp_cost14 IS NOT INITIAL.
    LOOP AT it_ztp_cost14 INTO wa_ztp_cost14.
      wa_tab2-vbeln = wa_ztp_cost14-vbeln.
      wa_tab2-gjahr = wa_ztp_cost14-gjahr.
      wa_tab2-proddt = wa_ztp_cost14-proddt.
      wa_tab2-prodtxt = wa_ztp_cost14-prodtxt.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-prod AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab2-prodname = pa0001-ename.
      ENDIF.
      wa_tab2-apr = space.
      wa_tab2-rej = space.
      wa_tab2-txt = space.
      COLLECT wa_tab2 INTO it_tab2.
      CLEAR wa_tab2.
    ENDLOOP.
  ENDIF.
*  BREAK-POINT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat2 .
  DATA lv_fldcat TYPE lvc_s_fcat.

  lv_fldcat-fieldname = 'VBELN'.
  lv_fldcat-scrtext_l = 'COSTSHEET NO.'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'GJAHR'.
  lv_fldcat-scrtext_l = 'F.YEARR'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'APR'.
  lv_fldcat-scrtext_l = 'APPROVE'.
  lv_fldcat-checkbox = 'X'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'REJ'.
  lv_fldcat-scrtext_l = 'REJECT'.
  lv_fldcat-checkbox = 'X'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'TXT'.
  lv_fldcat-scrtext_l = 'REMARK'.
  lv_fldcat-edit = 'X'.
  lv_fldcat-outputlen = '40'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PRODNAME'.
  lv_fldcat-scrtext_l = 'PURCHASE APPROVAL BY'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'PRODDT'.
  lv_fldcat-scrtext_l = 'PURCHASE APPROVED DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ACCTSEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM acctsel .

  SELECT SINGLE * FROM ztp_cost15 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 0.
    MESSAGE 'THIS COST SHEET IS REJECTED' TYPE 'E'.
  ENDIF.


  SELECT SINGLE * FROM ztp_cost11 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 4.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.
*  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND purapr EQ space.
*  IF sy-subrc EQ 0.
*    MESSAGE 'NOT YET APPROVED BY PURCHASE FOR THIS COSTSHEET' TYPE 'E'.
*  ENDIF.
* * commented below select query by madhuri given by jyothsna mam 13/11/2025
*  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acct EQ '00000000'.
*  IF sy-subrc EQ 0.
*  ELSE.
*    MESSAGE 'ACCOUNTS APPROVAL/REJECTION IS ALREDAY DONE FOR THIS COSTSHEET' TYPE 'E'.
*  ENDIF.
  CLEAR : it_ztp_cost14.
  SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr . "AND prodapr EQ 'X' AND purapr EQ 'X'.
  CLEAR : it_tab3,wa_tab3.
  IF it_ztp_cost14 IS NOT INITIAL.
    LOOP AT it_ztp_cost14 INTO wa_ztp_cost14.
      wa_tab3-vbeln = wa_ztp_cost14-vbeln.
      wa_tab3-gjahr = wa_ztp_cost14-gjahr.
      wa_tab3-proddt = wa_ztp_cost14-proddt.
      wa_tab3-prodtxt = wa_ztp_cost14-prodtxt.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-prod AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab3-prodname = pa0001-ename.
      ENDIF.
      wa_tab3-purdt = wa_ztp_cost14-purdt.
      wa_tab3-purtxt = wa_ztp_cost14-purtxt.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab3-purname = pa0001-ename.
      ENDIF.
      wa_tab3-apr = space.
      wa_tab3-rej = space.
      wa_tab3-txt = space.
      COLLECT wa_tab3 INTO it_tab3.
      CLEAR wa_tab3.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat3 .
  DATA lv_fldcat TYPE lvc_s_fcat.

  lv_fldcat-fieldname = 'VBELN'.
  lv_fldcat-scrtext_l = 'COSTSHEET NO.'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'GJAHR'.
  lv_fldcat-scrtext_l = 'F.YEARR'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'APR'.
  lv_fldcat-scrtext_l = 'APPROVE'.
  lv_fldcat-checkbox = 'X'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'REJ'.
  lv_fldcat-scrtext_l = 'REJECT'.
  lv_fldcat-checkbox = 'X'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'TXT'.
  lv_fldcat-scrtext_l = 'REMARK'.
  lv_fldcat-edit = 'X'.
  lv_fldcat-outputlen = '40'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PRODNAME'.
  lv_fldcat-scrtext_l = 'PRODUCTION APPROVAL BY'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'PRODDT'.
  lv_fldcat-scrtext_l = 'PRODUCTION APPROVED DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PURNAME'.
  lv_fldcat-scrtext_l = 'PURCHASE APPROVAL BY'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'PURDT'.
  lv_fldcat-scrtext_l = 'PURCHASE APPROVED DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ACCTAPPROVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM acctapprove .
  LOOP AT it_tab3 INTO wa_tab3.
* commented from 1028 to 1036 by madhuri given by jyothsna mam 13/11/2025
*    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab3-vbeln AND gjahr = wa_tab3-gjahr AND prodapr EQ 'X' AND purapr EQ 'X'.
*    IF sy-subrc EQ 4.
*      MESSAGE 'NOT YET APPROOVED BY PRODUCTION DEPARTMENT' TYPE 'E'.
*    ENDIF.
*    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab3-vbeln AND gjahr = wa_tab3-gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acct EQ '00000000'.
*    IF sy-subrc EQ 4.
*      MESSAGE 'PLZ CHECK PURCHASE APPROVAL/ REJECTION' TYPE 'E'.
*    ENDIF.
    IF wa_tab3-apr EQ space AND wa_tab3-rej EQ space.
      MESSAGE 'Select APPROVE or REJECT' TYPE 'E'.
    ENDIF.
    IF wa_tab3-apr NE space AND wa_tab3-rej NE space.
      MESSAGE 'Either APPROVE or REJECT' TYPE 'E'.
    ENDIF.
  ENDLOOP.


  LOOP AT it_tab3 INTO wa_tab3.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab3-vbeln AND gjahr = wa_tab3-gjahr .  "AND prodapr EQ 'X' AND purapr EQ 'X'.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING ztp_cost14 TO ztp_cost14_wa.
      ztp_cost14_wa-acct = pernr.
      ztp_cost14_wa-acctapr = wa_tab3-apr.
      ztp_cost14_wa-acctrej = wa_tab3-rej.
      ztp_cost14_wa-acctdt = sy-datum.
      ztp_cost14_wa-accttm = sy-uzeit.
      ztp_cost14_wa-accttxt = wa_tab3-txt.
      ztp_cost14_wa-accAPPROVER = sy-uname.
      MODIFY  ztp_cost14 FROM  ztp_cost14_wa.
      COMMIT WORK AND WAIT .
      CLEAR  ztp_cost14_wa.
    ENDIF.
  ENDLOOP.
  IF it_tab3 IS NOT INITIAL.
    PERFORM email.
  ENDIF.
  IF sy-subrc EQ 0.
    MESSAGE 'DATA SAVED' TYPE 'I'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FISEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fisel .

  SELECT SINGLE * FROM ztp_cost15 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 0.
    MESSAGE 'THIS COST SHEET IS REJECTED' TYPE 'E'.
  ENDIF.

  SELECT SINGLE * FROM ztp_cost11 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 4.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.
*  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND acctapr EQ space.
*  IF sy-subrc EQ 0.
*    MESSAGE 'NOT YET APPROVED BY ACCOUNTS FOR THIS COSTSHEET' TYPE 'E'.
*  ENDIF.

  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acctapr EQ 'X' AND fi EQ '00000000'.
  IF sy-subrc EQ 0.
  ELSE.
    MESSAGE 'FI APPROVAL/REJECTION IS ALREADY DONE FOR THIS COSTSHEET' TYPE 'E'.
  ENDIF.
  CLEAR : it_ztp_cost14.
  SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acctapr EQ 'X'.
  CLEAR : it_tab4,wa_tab4.
  IF it_ztp_cost14 IS NOT INITIAL.
    LOOP AT it_ztp_cost14 INTO wa_ztp_cost14.
      wa_tab4-vbeln = wa_ztp_cost14-vbeln.
      wa_tab4-gjahr = wa_ztp_cost14-gjahr.
      wa_tab4-proddt = wa_ztp_cost14-proddt.
      wa_tab4-prodtxt = wa_ztp_cost14-prodtxt.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-prod AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab4-prodname = pa0001-ename.
      ENDIF.
      wa_tab4-purdt = wa_ztp_cost14-purdt.
      wa_tab4-purtxt = wa_ztp_cost14-purtxt.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab4-purname = pa0001-ename.
      ENDIF.
      wa_tab4-acctdt = wa_ztp_cost14-acctdt.
      wa_tab4-accttxt = wa_ztp_cost14-accttxt.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-acct AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab4-acctname = pa0001-ename.
      ENDIF.
      wa_tab4-apr = space.
      wa_tab4-rej = space.
      wa_tab4-txt = space.
      COLLECT wa_tab4 INTO it_tab4.
      CLEAR wa_tab4.
    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat4 .
  DATA lv_fldcat TYPE lvc_s_fcat.

  lv_fldcat-fieldname = 'VBELN'.
  lv_fldcat-scrtext_l = 'COSTSHEET NO.'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'GJAHR'.
  lv_fldcat-scrtext_l = 'F.YEARR'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'APR'.
  lv_fldcat-scrtext_l = 'APPROVE'.
  lv_fldcat-checkbox = 'X'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'REJ'.
  lv_fldcat-scrtext_l = 'REJECT'.
  lv_fldcat-checkbox = 'X'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'TXT'.
  lv_fldcat-scrtext_l = 'REMARK'.
  lv_fldcat-edit = 'X'.
  lv_fldcat-outputlen = '40'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PRODNAME'.
  lv_fldcat-scrtext_l = 'PRODUCTION APPROVAL BY'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'PRODDT'.
  lv_fldcat-scrtext_l = 'PRODUCTION APPROVED DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PURNAME'.
  lv_fldcat-scrtext_l = 'PURCHASE APPROVAL BY'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'PURDT'.
  lv_fldcat-scrtext_l = 'PURCHASE APPROVED DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ACCTNAME'.
  lv_fldcat-scrtext_l = 'ACCOUNTS APPROVAL BY'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'ACCTDT'.
  lv_fldcat-scrtext_l = 'ACCOUNTS APPROVED DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FIAPPROVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fiapprove .
  LOOP AT it_tab4 INTO wa_tab4.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab4-vbeln AND gjahr = wa_tab4-gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acctapr EQ 'X'.
    IF sy-subrc EQ 4.
      MESSAGE 'NOT YET APPROOVED BY PRODUCTION DEPARTMENT' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab4-vbeln AND gjahr = wa_tab4-gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acctapr EQ 'X' AND
      fi EQ '00000000'.
    IF sy-subrc EQ 4.
      MESSAGE 'PLZ CHECK ACCOUNTS APPROVAL/ REJECTION' TYPE 'E'.
    ENDIF.
    IF wa_tab4-apr EQ space AND wa_tab4-rej EQ space.
      MESSAGE 'Select APPROVE or REJECT' TYPE 'E'.
    ENDIF.
    IF wa_tab4-apr NE space AND wa_tab4-rej NE space.
      MESSAGE 'Either APPROVE or REJECT' TYPE 'E'.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tab4 INTO wa_tab4.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab4-vbeln AND gjahr = wa_tab4-gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acctapr EQ 'X'.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING ztp_cost14 TO ztp_cost14_wa.
*      ztp_cost14_wa-fi = pernr.
      ztp_cost14_wa-fiapr = wa_tab4-apr.
      ztp_cost14_wa-firej = wa_tab4-rej.
      ztp_cost14_wa-fidt = sy-datum.
      ztp_cost14_wa-fitm = sy-uzeit.
      ztp_cost14_wa-fitxt = wa_tab4-txt.
      MODIFY  ztp_cost14 FROM  ztp_cost14_wa.
      COMMIT WORK AND WAIT .
      CLEAR  ztp_cost14_wa.
    ENDIF.
  ENDLOOP.
  IF it_tab4 IS NOT INITIAL.
    PERFORM email.
  ENDIF.
  IF sy-subrc EQ 0.
    MESSAGE 'DATA SAVED' TYPE 'I'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FINALSEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM finalsel .

  SELECT SINGLE * FROM ztp_cost15 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 0.
    MESSAGE 'THIS COST SHEET IS REJECTED' TYPE 'E'.
  ENDIF.

  SELECT SINGLE * FROM ztp_cost11 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 4.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.
*  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND fiapr EQ space.
*  IF sy-subrc EQ 0.
*    MESSAGE 'NOT YET APPROVED BY FI FOR THIS COSTSHEET' TYPE 'E'.
*  ENDIF.
  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acctapr EQ 'X' AND fiapr EQ 'X'
    AND final EQ '00000000'.
  IF sy-subrc EQ 0.
  ELSE.
    MESSAGE 'FINAL APPROVAL/REJECTION IS ALREDAY DONE FOR THIS COSTSHEET' TYPE 'E'.
  ENDIF.
  CLEAR : it_ztp_cost14.
  SELECT * FROM ztp_cost14 INTO TABLE it_ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acctapr EQ 'X'
    AND fiapr EQ 'X'.
  CLEAR : it_tab5,wa_tab5.
  IF it_ztp_cost14 IS NOT INITIAL.
    LOOP AT it_ztp_cost14 INTO wa_ztp_cost14.
      wa_tab5-vbeln = wa_ztp_cost14-vbeln.
      wa_tab5-gjahr = wa_ztp_cost14-gjahr.
      wa_tab5-proddt = wa_ztp_cost14-proddt.
      wa_tab5-prodtxt = wa_ztp_cost14-prodtxt.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-prod AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab5-prodname = pa0001-ename.
      ENDIF.
      wa_tab5-purdt = wa_ztp_cost14-purdt.
      wa_tab5-purtxt = wa_ztp_cost14-purtxt.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-pur AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab5-purname = pa0001-ename.
      ENDIF.
      wa_tab5-acctdt = wa_ztp_cost14-acctdt.
      wa_tab5-accttxt = wa_ztp_cost14-accttxt.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-acct AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab5-acctname = pa0001-ename.
      ENDIF.
      wa_tab5-fidt = wa_ztp_cost14-fidt.
      wa_tab5-fitxt = wa_ztp_cost14-fitxt.
      SELECT SINGLE * FROM pa0001 WHERE pernr EQ wa_ztp_cost14-fi AND endda GE sy-datum.
      IF sy-subrc EQ 0.
        wa_tab5-finame = pa0001-ename.
      ENDIF.
      wa_tab5-apr = space.
      wa_tab5-rej = space.
      wa_tab5-txt = space.
      COLLECT wa_tab5 INTO it_tab5.
      CLEAR wa_tab5.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT5
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_build_fieldcat5 .


  DATA lv_fldcat TYPE lvc_s_fcat.

  lv_fldcat-fieldname = 'VBELN'.
  lv_fldcat-scrtext_l = 'COSTSHEET NO.'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'GJAHR'.
  lv_fldcat-scrtext_l = 'F.YEARR'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'APR'.
  lv_fldcat-scrtext_l = 'APPROVE'.
  lv_fldcat-checkbox = 'X'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'REJ'.
  lv_fldcat-scrtext_l = 'REJECT'.
  lv_fldcat-checkbox = 'X'.
  lv_fldcat-edit = 'X'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'TXT'.
  lv_fldcat-scrtext_l = 'REMARK'.
  lv_fldcat-edit = 'X'.
  lv_fldcat-outputlen = '40'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PRODNAME'.
  lv_fldcat-scrtext_l = 'PRODUCTION APPROVAL BY'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'PRODDT'.
  lv_fldcat-scrtext_l = 'PRODUCTION APPROVED DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'PURNAME'.
  lv_fldcat-scrtext_l = 'PURCHASE APPROVAL BY'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.


  lv_fldcat-fieldname = 'PURDT'.
  lv_fldcat-scrtext_l = 'PURCHASE APPROVED DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ACCTNAME'.
  lv_fldcat-scrtext_l = 'ACCOUNTS APPROVAL BY'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'ACCTDT'.
  lv_fldcat-scrtext_l = 'ACCOUNTS APPROVED DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FINAME'.
  lv_fldcat-scrtext_l = 'FI APPROVAL BY'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

  lv_fldcat-fieldname = 'FIDT'.
  lv_fldcat-scrtext_l = 'FI APPROVED DT'.
  lv_fldcat-outputlen = '10'.
  APPEND lv_fldcat TO it_fcat.
  CLEAR lv_fldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FINALAPPROVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM finalapprove .
  LOOP AT it_tab5 INTO wa_tab5.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab5-vbeln AND gjahr = wa_tab5-gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acctapr EQ 'X'
      AND fiapr EQ 'X'.
    IF sy-subrc EQ 4.
      MESSAGE 'NOT YET APPROOVED BY FINANCE DEPARTMENT' TYPE 'E'.
    ENDIF.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab5-vbeln AND gjahr = wa_tab5-gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acctapr EQ 'X'
       AND fiapr EQ 'X' AND final EQ '00000000'.
    IF sy-subrc EQ 4.
      MESSAGE 'PLZ CHECK FINANCE APPROVAL/ REJECTION' TYPE 'E'.
    ENDIF.
    IF wa_tab5-apr EQ space AND wa_tab5-rej EQ space.
      MESSAGE 'Select APPROVE or REJECT' TYPE 'E'.
    ENDIF.
    IF wa_tab5-apr NE space AND wa_tab5-rej NE space.
      MESSAGE 'Either APPROVE or REJECT' TYPE 'E'.
    ENDIF.
  ENDLOOP.

  LOOP AT it_tab5 INTO wa_tab5.
    SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ wa_tab5-vbeln AND gjahr = wa_tab5-gjahr AND prodapr EQ 'X' AND purapr EQ 'X' AND acctapr EQ 'X'
      AND fiapr EQ 'X'.
    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING ztp_cost14 TO ztp_cost14_wa.
*      ztp_cost14_wa-final = pernr.
      ztp_cost14_wa-finalapr = wa_tab5-apr.
      ztp_cost14_wa-finalrej = wa_tab5-rej.
      ztp_cost14_wa-finaldt = sy-datum.
      ztp_cost14_wa-finaltm = sy-uzeit.
      ztp_cost14_wa-finaltxt = wa_tab5-txt.
      MODIFY  ztp_cost14 FROM  ztp_cost14_wa.
      COMMIT WORK AND WAIT .
      CLEAR  ztp_cost14_wa.
    ENDIF.
  ENDLOOP.
  IF it_tab5 IS NOT INITIAL.
    PERFORM email.
  ENDIF.
  IF sy-subrc EQ 0.
    MESSAGE 'DATA SAVED' TYPE 'I'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM email .
  IF sy-host EQ 'SAPQLT' OR sy-host EQ 'SAPDEV'.
**  if sy-host eq 'SAPDEV'.
  ELSE.
*  IF IT_TAB1 IS NOT INITIAL.  "12.9.21
*  BREAK-POINT .
*PERFORM halbemail.


*LOOP AT IT_EMAIL INTO WA_EMAIL.
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = 'ZCOST12'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      IMPORTING
*       FM_NAME            = V_FM
        fm_name            = v_form_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

*   * Set the control parameter
    w_ctrlop-getotf = abap_true.
    w_ctrlop-no_dialog = abap_true.
    w_compop-tdnoprev = abap_true.
    w_ctrlop-preview = space.
    w_compop-tddest = 'LOCL'.

    PERFORM costsheet.





    CALL FUNCTION v_form_name
      EXPORTING
        control_parameters = w_ctrlop
        output_options     = w_compop
        user_settings      = abap_true
        format             = format
        name1              = fgname1
        maktx              = maktx
        material           = material
        pack               = pack
        qty                = qty
        yield1             = yield1
        yield2             = yield2
        r2                 = r21
        p2                 = p2
        rp1                = rp1
        m1                 = m1
        ccpc               = ccpc
        anaval             = anaval
        anart              = anart
        gstval1            = gstval1
        net                = net
        margin             = margin
        fggst              = fggst
        batsz              = batsz
        rmyldqty1          = rmyldqty1
        pmyldqty1          = pmyldqty1
        uom                = uom
        cpudt              = cpudt
        vbeln              = vbeln
        gjahr              = gjahr
        tot                = tot
        prodstat           = prodstat
        proddt             = proddt
        prodname           = prodname
        prodtxt            = prodtxt
        purstat            = purstat
        purdt              = purdt
        purname            = purname
        purtxt             = purtxt
        acctstat           = acctstat
        acctdt             = acctdt
        acctname           = acctname
        accttxt            = accttxt
        fistat             = fistat
        fidt               = fidt
        finame             = finame
        fitxt              = fitxt
        finalstat          = finalstat
        finaldt            = finaldt
        finalname          = finalname
        finaltxt           = finaltxt
        status             = status
        subject            = subject
      IMPORTING
        job_output_info    = w_return " This will have all output
      TABLES
        it_tab5            = it_tab51
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.


    i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
        max_linewidth         = 132
      IMPORTING
        bin_filesize          = v_len_in
        bin_file              = i_xstring   " This is NOT Binary. This is Hexa
      TABLES
        otf                   = i_otf
        lines                 = i_tline
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        OTHERS                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = i_xstring
      TABLES
        binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
*    IF r1 EQ 'X'.
*      in_mailid = 'h.sheth@BLUECROSSLABS.COM'.
*    ELSE
    IF  r1 EQ 'X'.
      in_mailid = 'sachin.s@BLUECROSSLABS.COM'.
    ELSEIF r2 EQ 'X'.
      in_mailid = 'vishal.m@BLUECROSSLABS.COM'.
*    ELSE.
*      in_mailid = 'vishal.m@BLUECROSSLABS.COM'.
    ENDIF.
    PERFORM send_mail USING in_mailid .

*    IN_MAILID = 'sachin.s@BLUECROSSLABS.COM'.
*    PERFORM SEND_MAIL USING IN_MAILID .
*    IN_MAILID = 'vishal.m@BLUECROSSLABS.COM'.
*    PERFORM SEND_MAIL USING IN_MAILID .
*    in_mailid = 'jyotsna@BLUECROSSLABS.COM'.
*    PERFORM send_mail USING in_mailid .


*  ENDLOOP.
*  ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IN_MAILID  text
*----------------------------------------------------------------------*
FORM send_mail  USING    p_in_mailid.
  DATA: salutation TYPE string.
  DATA: body TYPE string.
  DATA: footer TYPE string.

  DATA: lo_send_request TYPE REF TO cl_bcs,
        lo_document     TYPE REF TO cl_document_bcs,
        lo_sender       TYPE REF TO if_sender_bcs,
        lo_recipient    TYPE REF TO if_recipient_bcs VALUE IS INITIAL,lt_message_body TYPE bcsy_text,
        lx_document_bcs TYPE REF TO cx_document_bcs,
        lv_sent_to_all  TYPE os_boolean.

  "create send request
  lo_send_request = cl_bcs=>create_persistent( ).

  "create message body and subject
  salutation ='Dear Sir/Madam,'.
  APPEND salutation TO lt_message_body.
  APPEND INITIAL LINE TO lt_message_body.

  body = 'Please find the attached Costsheet for your Approval'.

  APPEND body TO lt_message_body.
  APPEND INITIAL LINE TO lt_message_body.

  footer = 'With Regards,'.
  APPEND footer TO lt_message_body.
  footer = 'BLUE CROSS LABORATORIES PVT LTD.'.
  APPEND footer TO lt_message_body.


  ntext1 = 'Costsheet for your Approval'.

  "put your text into the document


  lo_document = cl_document_bcs=>create_document(
  i_type = 'RAW'
  i_text = lt_message_body
  i_subject = 'COST SHEET FOR APPROVAL' ).

*DATA: l_size TYPE sood-objlen. " Size of Attachment
*l_size = l_lines * 255.
  TRY.

      lo_document->add_attachment(
      EXPORTING
      i_attachment_type = 'PDF'
      i_attachment_subject = 'COSTSHEET'
      i_att_content_hex = i_objbin[] ).
    CATCH cx_document_bcs INTO lx_document_bcs.

  ENDTRY.

*  endif.

* Add attachment
* Pass the document to send request
  lo_send_request->set_document( lo_document ).

  "Create sender
  lo_sender = cl_sapuser_bcs=>create( sy-uname ).

  "Set sender
  lo_send_request->set_sender( lo_sender ).

  "Create recipient
  lo_recipient = cl_cam_address_bcs=>create_internet_address( in_mailid ).

*Set recipient
  lo_send_request->add_recipient(
  EXPORTING
  i_recipient = lo_recipient
  i_express = abap_true
  ).

  lo_send_request->add_recipient( lo_recipient ).

* Send email
  lo_send_request->send(
  EXPORTING
  i_with_error_screen = abap_true
  RECEIVING
  result = lv_sent_to_all ).

  CONCATENATE 'Email sent to' in_mailid INTO DATA(lv_msg) SEPARATED BY space.
  WRITE:/ lv_msg COLOR COL_POSITIVE.
  SKIP.
* Commit Work to send the email
  COMMIT WORK.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  COSTSHEET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM costsheet .
  PERFORM form1.
  PERFORM form2.
  PERFORM form3.

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
  CLEAR : it_ztp_cost11,wa_ztp_cost11.
  CLEAR : it_ztp_cost12,wa_ztp_cost12.

  SELECT * FROM ztp_cost11 INTO TABLE it_ztp_cost11 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  SELECT * FROM ztp_cost12 INTO TABLE it_ztp_cost12 WHERE gjahr EQ gjahr AND vbeln EQ vbeln.

*  if it_ztp_cost11 is initial.
*    message 'NO DATA FOUND' type 'E'.
*  endif.
*  if it_ztp_cost12 is initial.
*    message 'NO DATA FOUND' type 'E'.
*  endif.
  CLEAR : it_tab51,wa_tab51.

  IF it_ztp_cost12 IS NOT INITIAL.
    LOOP AT it_ztp_cost12 INTO wa_ztp_cost12 WHERE gjahr EQ gjahr AND vbeln EQ vbeln.
      READ TABLE it_ztp_cost11 INTO wa_ztp_cost11 WITH KEY gjahr = wa_ztp_cost12-gjahr vbeln = wa_ztp_cost12-vbeln.
      IF sy-subrc EQ 0.
*        write : / 'test',wa_ztp_cost12-gjahr,wa_ztp_cost12-vbeln,wa_ztp_cost12-idnrk.

        wa_tab51-idnrk = wa_ztp_cost12-idnrk.
        SELECT SINGLE * FROM makt WHERE matnr EQ wa_ztp_cost12-idnrk AND spras EQ 'EN'.
        IF sy-subrc EQ 0.
          wa_tab51-imaktx = makt-maktx.
        ENDIF.
        wa_tab51-menge = wa_ztp_cost12-menge.
        SELECT SINGLE * FROM mara WHERE matnr EQ wa_ztp_cost12-idnrk.
        IF sy-subrc EQ 0.
          wa_tab51-meins = mara-meins.
          wa_tab51-mtart = mara-mtart.
        ENDIF.


        wa_tab51-posnr = wa_ztp_cost12-posnr.
        CLEAR : m9,m2,m3,m4,m5,m6,m7,m8.
        m9 = wa_ztp_cost12-rate.
        wa_tab51-rate = m9.
        m2 = wa_ztp_cost12-gstrate.
        wa_tab51-gstrate = m2.
        m3 = wa_ztp_cost12-gstval.
        wa_tab51-gstval = m3.
        m4 = wa_ztp_cost12-frtper.
        wa_tab51-frtper = m4.
        m5 = wa_ztp_cost12-frtrate.
        wa_tab51-frtrate = m5.
        m6 = wa_ztp_cost12-frtval.
        wa_tab51-frtval = m6.
        m7 = wa_ztp_cost12-v1.
        wa_tab51-v1 = m7.
        m8 = wa_ztp_cost12-v2.
        wa_tab51-v2 = m8.
        CONDENSE : wa_tab51-menge,wa_tab51-rate,wa_tab51-gstrate,wa_tab51-gstval,wa_tab51-frtper,wa_tab51-frtrate,wa_tab51-frtval,wa_tab51-v1,
        wa_tab51-v2.
        COLLECT wa_tab51 INTO it_tab51.
        CLEAR wa_tab51.

      ENDIF.
    ENDLOOP.
  ENDIF.

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
**** Added by madhuri below select qurey given by jyotsna on 3/10/2025
  SELECT * FROM zprodbatches INTO TABLE @DATA(it_ZPRODBATCHES) FOR ALL ENTRIES IN @it_ztp_cost11 WHERE matnr = @it_ztp_cost11-matnr
                                                                                    AND kunnr = @it_ztp_cost11-fglifnr.
  READ TABLE it_ztp_cost11 INTO wa_ztp_cost11 WITH KEY gjahr = gjahr vbeln = vbeln.
  IF sy-subrc EQ 0.
    werks = wa_ztp_cost11-werks.
    material = wa_ztp_cost11-matnr.
    fglifnr = wa_ztp_cost11-fglifnr.
    stlal = wa_ztp_cost11-stlal.
    r21 = wa_ztp_cost11-r2.
    CONDENSE r21.
    p2 = wa_ztp_cost11-p2.
    rp1 = wa_ztp_cost11-rp1.
    m1 = wa_ztp_cost11-m1.
    ccpc = wa_ztp_cost11-ccpc.
    anaval = wa_ztp_cost11-anaval.
    anart = wa_ztp_cost11-anart.
    gstval1 = wa_ztp_cost11-gstval1.
    net = wa_ztp_cost11-net.
    margin = wa_ztp_cost11-margin.
    fggst = wa_ztp_cost11-fggst.
    bmeng = wa_ztp_cost11-bmeng.
*    batsz = wa_ztp_cost11-batsz.
******************** Soc by madhuri by jytsna 3/10//2025
    READ TABLE it_ZPRODBATCHES INTO DATA(wa_ZPRODBATCHES) WITH KEY matnr = wa_ztp_cost11-matnr
                                                                   kunnr = wa_ztp_cost11-fglifnr.
    IF sy-subrc = 0.
      batsz = wa_ZPRODBATCHEs-batch_size.
    ENDIF.
******************** eoc by madhuri by jytsna 3/10//2025
    rmyld = wa_ztp_cost11-rmyld.
    pmyld = wa_ztp_cost11-pmyld.
    cpudt = wa_ztp_cost11-cpudt.
    subject = wa_ztp_cost11-subject.
    rmyldqty = bmeng * ( rmyld / 100 ).
    pmyldqty = bmeng * ( pmyld / 100 ).
    rmyldqty1 = rmyldqty.
    pmyldqty1 = pmyldqty.
    yield1 = rmyld.
    yield2 = pmyld.
    CLEAR : tot1,tot.
    tot1 = rp1 + m1 + ccpc + anart.
    tot = tot1.
    CONDENSE tot.

    CLEAR : bmein.
    SELECT SINGLE * FROM mast WHERE matnr EQ wa_ztp_cost11-matnr AND werks EQ wa_ztp_cost11-werks AND stlan EQ 1  AND stlal EQ wa_ztp_cost11-stlal .
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM stko WHERE stlnr EQ mast-stlnr AND stlal EQ mast-stlal.
      IF sy-subrc EQ 0.
        bmein = stko-bmein.
      ENDIF.
    ENDIF.
    qty1 = bmeng.
    CONDENSE qty1.
    CONCATENATE  qty1 bmein INTO qty SEPARATED BY space.
    CONDENSE qty.
    CLEAR : pack.
    SELECT SINGLE * FROM mvke WHERE matnr EQ wa_ztp_cost11-matnr AND vkorg EQ '1000' AND vtweg EQ '10'.
    IF sy-subrc EQ 0.
      SELECT SINGLE * FROM tvm5t WHERE mvgr5 EQ mvke-mvgr5.
      IF sy-subrc EQ 0.
        pack = tvm5t-bezei.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_ztp_cost11-fglifnr.
    IF sy-subrc EQ 0.
      fgname1 = lfa1-name1.
    ENDIF.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_ztp_cost11-matnr AND spras EQ 'EN'.
    IF sy-subrc EQ 0.
      maktx = makt-maktx.
    ENDIF.

    CLEAR : uom.
    SELECT SINGLE * FROM marm WHERE matnr EQ material AND meinh IN ( 'L','KG' ).
    IF sy-subrc EQ 0.
      uom = marm-meinh.
    ENDIF.
    IF uom EQ space.
      uom = 'PC'.
    ENDIF.
    CONDENSE batsz.
    CONCATENATE batsz uom INTO batsz SEPARATED BY space.
    CONDENSE : rmyldqty1,pmyldqty1.
    CONDENSE: fgname1,maktx,material,pack,qty,yield1,yield2,r21,p2,rp1,m1,ccpc,anaval,anart,gstval1,net,margin,fggst,batsz,rmyldqty1,pmyldqty1,uom,tot.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form3 .
  CLEAR : prodstat, proddt, prodname, prodtxt.
  CLEAR : purstat, purdt, purname, purtxt.
  CLEAR : fistat, fidt, finame, fitxt.
  CLEAR : acctstat, acctdt, acctname, accttxt.
  CLEAR : finalstat, finaldt, finalname, finaltxt.

  SELECT SINGLE * FROM ztp_cost14 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 0.
**********************************************************************************************************
    IF ztp_cost14-prodapr EQ 'X'.
      prodstat = 'APPROVED'.
    ELSEIF ztp_cost14-prodrej EQ 'X'.
      prodstat = 'REJECTED'.
    ELSE.
      prodstat = space.
    ENDIF.
    proddt = ztp_cost14-proddt.
    SELECT SINGLE * FROM pa0001 WHERE pernr EQ ztp_cost14-prod AND endda GE sy-datum.
    IF sy-subrc EQ 0.
      prodname = pa0001-ename.
    ENDIF.
    prodtxt = ztp_cost14-prodtxt.
*********************************************************************************************

    IF ztp_cost14-purapr EQ 'X'.
      purstat = 'APPROVED'.
    ELSEIF ztp_cost14-purrej EQ 'X'.
      purstat = 'REJECTED'.
    ELSE.
      purstat = space.
    ENDIF.
    purdt = ztp_cost14-purdt.
    SELECT SINGLE * FROM pa0001 WHERE pernr EQ ztp_cost14-pur AND endda GE sy-datum.
    IF sy-subrc EQ 0.
      purname = pa0001-ename.
    ENDIF.
    purtxt = ztp_cost14-purtxt.
*************************************************
**********************************************************************************************************
    IF ztp_cost14-acctapr EQ 'X'.
      acctstat = 'APPROVED'.
    ELSEIF ztp_cost14-acctrej EQ 'X'.
      acctstat = 'REJECTED'.
    ELSE.
      acctstat = space.
    ENDIF.
    acctdt = ztp_cost14-acctdt.
    SELECT SINGLE * FROM pa0001 WHERE pernr EQ ztp_cost14-acct AND endda GE sy-datum.
    IF sy-subrc EQ 0.
      acctname = pa0001-ename.
    ENDIF.
    accttxt = ztp_cost14-accttxt.
**********************************************************************************************************
    IF ztp_cost14-fiapr EQ 'X'.
      fistat = 'APPROVED'.
    ELSEIF ztp_cost14-firej EQ 'X'.
      fistat = 'REJECTED'.
    ELSE.
      fistat = space.
    ENDIF.
    fidt = ztp_cost14-fidt.
    SELECT SINGLE * FROM pa0001 WHERE pernr EQ ztp_cost14-fi AND endda GE sy-datum.
    IF sy-subrc EQ 0.
      finame = pa0001-ename.
    ENDIF.
    fitxt = ztp_cost14-fitxt.
**********************************************************************************************************
    IF ztp_cost14-finalapr EQ 'X'.
      finalstat = 'APPROVED'.
    ELSEIF ztp_cost14-finalrej EQ 'X'.
      finalstat = 'REJECTED'.
    ELSE.
      finalstat = space.
    ENDIF.
    finaldt = ztp_cost14-finaldt.
    SELECT SINGLE * FROM pa0001 WHERE pernr EQ ztp_cost14-final AND endda GE sy-datum.
    IF sy-subrc EQ 0.
      finalname = pa0001-ename.
    ENDIF.
    finaltxt = ztp_cost14-finaltxt.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  VIEWCS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM viewcs .


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZCOST12'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
*     FM_NAME            = V_FM
      fm_name            = v_form_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

**   * Set the control parameter
*  W_CTRLOP-GETOTF = ABAP_TRUE.
*  W_CTRLOP-NO_DIALOG = ABAP_TRUE.
*  W_COMPOP-TDNOPREV = ABAP_TRUE.
*  W_CTRLOP-PREVIEW = SPACE.
*  W_COMPOP-TDDEST = 'LOCL'.

  PERFORM costsheet.

  CLEAR : status.
  SELECT SINGLE * FROM ztp_cost15 WHERE vbeln EQ vbeln AND gjahr EQ gjahr.
  IF sy-subrc EQ 0.
    status = 'REJECTED COSTSHEET'.
  ENDIF.


  CALL FUNCTION v_form_name
    EXPORTING
*     CONTROL_PARAMETERS = W_CTRLOP
*     OUTPUT_OPTIONS   = W_COMPOP
*     USER_SETTINGS    = ABAP_TRUE
      format           = format
      name1            = fgname1
      maktx            = maktx
      material         = material
      pack             = pack
      qty              = qty
      yield1           = yield1
      yield2           = yield2
      r2               = r21
      p2               = p2
      rp1              = rp1
      m1               = m1
      ccpc             = ccpc
      anaval           = anaval
      anart            = anart
      gstval1          = gstval1
      net              = net
      margin           = margin
      fggst            = fggst
      batsz            = batsz
      rmyldqty1        = rmyldqty1
      pmyldqty1        = pmyldqty1
      uom              = uom
      cpudt            = cpudt
      vbeln            = vbeln
      gjahr            = gjahr
      tot              = tot
      prodstat         = prodstat
      proddt           = proddt
      prodname         = prodname
      prodtxt          = prodtxt
      purstat          = purstat
      purdt            = purdt
      purname          = purname
      purtxt           = purtxt
      acctstat         = acctstat
      acctdt           = acctdt
      acctname         = acctname
      accttxt          = accttxt
      fistat           = fistat
      fidt             = fidt
      finame           = finame
      fitxt            = fitxt
      finalstat        = finalstat
      finaldt          = finaldt
      finalname        = finalname
      finaltxt         = finaltxt
      status           = status
      subject          = subject
*    IMPORTING
*     JOB_OUTPUT_INFO  = W_RETURN " This will have all output
    TABLES
      it_tab5          = it_tab51
*     itab_division    = itab_division
*     itab_storage     = itab_storage
*     itab_pa0002      = itab_pa0002
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.



ENDFORM.
