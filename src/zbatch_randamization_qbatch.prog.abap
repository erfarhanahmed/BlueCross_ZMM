*&---------------------------------------------------------------------*
*& Report  ZBATCH_RANDAMIZATION_QBATCH
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zbatch_randamization_qbatch.

*&---------------------------------------------------------------------*
*& Report  ZMM06_REASON
*& developed by Jyotsna on 25.4.24 to add reason for mm06 entries
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
*report zmm06_reason.
tables : ztpbatch_qbatch,
         zpassw,
         makt,
         mara,
         pa0001,
         mcha.


data:
*        v_ac_xstring type xstring,
  v_en_string type string,
*        v_en_xstring type xstring,
  v_de_string type string,
*        v_de_xstring type string,
  v_error_msg type string.
data: o_encryptor        type ref to cl_hard_wired_encryptor,
      o_cx_encrypt_error type ref to cx_encrypt_error.
type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

types: begin of itab1,
         charg like mcha-charg,

       end of itab1.

types: begin of disp1,
         charg like mcha-charg,
         cpudt type sy-datum,
         cputm type sy-uzeit,
         uname type uname,

         ename type pa0001-ename,

       end of disp1.

data: it_tab1 type table of itab1,
      wa_tab1 type itab1.
data:  ztpbatch_qbatch_wa type  ztpbatch_qbatch.
data: msg type string.

data: it_ztpbatch_qbatch type table of ztpbatch_qbatch,
      wa_ztpbatch_qbatch type ztpbatch_qbatch.

data: it_disp1 type table of disp1,
      wa_disp1 type disp1.

data: maktx1     type makt-maktx,
      maktx2     type  makt-maktx,
      normt      type mara-normt,
      maktx(100) type c.


*selection-screen begin of block merkmale2 with frame title text-001.
*parameters : pernr    like pa0001-pernr matchcode object prem,
*             pass(10) type c.
*selection-screen end of block merkmale2 .

selection-screen begin of block merkmale3 with frame title text-001.
parameters : r1 radiobutton group r1 user-command r2 default 'X',
             r2 radiobutton group r1.
selection-screen end of block merkmale3 .

selection-screen begin of block merkmale1 with frame title text-001.
parameters : charg like mcha-charg.
selection-screen end of block merkmale1 .

at selection-screen.


at selection-screen output.

  loop at screen.
    check screen-name eq 'PASS'.
    screen-invisible = 1.
    modify screen.
  endloop.

  if r1 eq 'X'.
    loop at screen.
      if screen-name cp '*CHARG*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.


  elseif r2 eq 'X'.
  loop at screen.
      if screen-name cp '*CHARG*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.


  endif.

initialization.
  g_repid = sy-repid.



start-of-selection.

  if r1 eq 'X'.
    if charg is initial.
      message 'ENTER BATCH NO' type 'E'.
    endif.
  endif.



  if r1 eq 'X'.

    perform passw.

    perform form1.

  elseif r2 eq 'X'.
    perform display.


  endif.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form form1 .
* DO 10 TIMES.
*    COUNT = COUNT + 1.
  select single * from ztpbatch_qbatch where charg eq charg.
  if sy-subrc eq 0.
    message 'THIS ENTRY IS ALREDY EXIST' type 'E'.
  endif.


    ztpbatch_qbatch_wa-charg = charg.
    ztpbatch_qbatch_wa-cpudt = sy-datum.
    ztpbatch_qbatch_wa-cputm = sy-uzeit.
    ztpbatch_qbatch_wa-uname = sy-uname.
*    ztpbatch_qbatch_wa-pernr = pernr.

    modify   ztpbatch_qbatch from   ztpbatch_qbatch_wa.
    clear :  ztpbatch_qbatch_wa.
*  endloop.
  if sy-subrc eq 0.
    message 'DATA SAVED' type 'I'.
  endif.
  leave to screen 0.



endform.

*form user_comm using ucomm like sy-ucomm selfield type slis_selfield.
**  IF R1 EQ 'X'.
*  case sy-ucomm. "SELFIELD-FIELDNAME.
**      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
**        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
**      ENDLOOP.
**      BREAK-POINT.
*    when '&DATA_SAVE'(001).
**      message 'TERRITORY SAVED 1' type 'I'.
**      PERFORM BDC.
*
*      perform reason.
*
*    when others.
*  endcase.
*  exit.
*endform.                    "USER_COMM
*&---------------------------------------------------------------------*
*&      Form  REASON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*form reason .
*
*
*
*  loop at it_tab1 into wa_tab1 where charg ne space.
*
*    ztpbatch_qbatch_wa-charg = wa_tab1-charg.
*    ztpbatch_qbatch_wa-cpudt = sy-datum.
*    ztpbatch_qbatch_wa-cputm = sy-uzeit.
*    ztpbatch_qbatch_wa-uname = sy-uname.
*    ztpbatch_qbatch_wa-pernr = pernr.
*
*    modify   ztpbatch_qbatch from   ztpbatch_qbatch_wa.
*    clear :  ztpbatch_qbatch_wa.
*  endloop.
*  if sy-subrc eq 0.
*    message 'DATA SAVED' type 'I'.
*  endif.
*  leave to screen 0.
*endform.
*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form authorization .
*  authority-check object 'M_BCO_WERK'  id 'WERKS' field werks.
*  if sy-subrc <> 0.
*    concatenate 'No authorization for Plant' werks into msg
*    separated by space.
*    message msg type 'E'.
*  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  PASSW
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form passw .
*  select single * from zpassw where pernr = pernr.
*  if sy-subrc eq 0.
*
*    if sy-uname ne zpassw-uname.
*      message 'INVALID LOGIN ID' type 'E'.
*    endif.
*    v_en_string = zpassw-password.
**  &———————————————————————** Decryption – String to String*&———————————————————————*
*    try.
*        create object o_encryptor.
*        call method o_encryptor->decrypt_string2string
*          exporting
*            the_string = v_en_string
*          receiving
*            result     = v_de_string.
*      catch cx_encrypt_error into o_cx_encrypt_error.
*        call method o_cx_encrypt_error->if_message~get_text
*          receiving
*            result = v_error_msg.
*        message v_error_msg type 'E'.
*    endtry.
*    if v_de_string eq pass.
**        message 'CORRECT PASSWORD' type 'I'.
*    else.
*      message 'INCORRECT PASSWORD' type 'E'.
*    endif.
*  else.
*    message 'NOT VALID USER' type 'E'.
*    exit.
*  endif.
**    CLEAR : PASS.
**    PASS = '   '.

endform.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display .
  select * from ztpbatch_qbatch into table it_ztpbatch_qbatch .
  if it_ztpbatch_qbatch is not initial.
    loop at it_ztpbatch_qbatch into wa_ztpbatch_qbatch.
      wa_disp1-charg = wa_ztpbatch_qbatch-charg.
      wa_disp1-cpudt = wa_ztpbatch_qbatch-cpudt.
      wa_disp1-cputm = wa_ztpbatch_qbatch-cputm.
      wa_disp1-uname = wa_ztpbatch_qbatch-uname.
      select single * from pa0001 where pernr eq wa_ztpbatch_qbatch-pernr and endda ge sy-datum.
      if sy-subrc eq 0.
        wa_disp1-ename = pa0001-ename.
      endif.
      collect wa_disp1 into it_disp1.
      clear wa_disp1.
    endloop.
  endif.


  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH NO'.
*  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.

 wa_fieldcat-fieldname = 'CPUDT'.
  wa_fieldcat-seltext_l = 'MAINTAIN ON'.
*  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ENAME'.
  wa_fieldcat-seltext_l = 'MAINTAIN BY'.
*  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'DISPLAY REASON FOR DELELTION IN MM06'.

  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
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
    tables
      t_outtab                = it_disp1
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
endform.


form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  if r1 eq 'X'.
    wa_comment-typ = 'A'.
    wa_comment-info = 'THIRD PARTY BATCHES FOR QUALITY'.
*  WA_COMMENT-INFO = P_FRMDT.
    append wa_comment to comment.

  else.

    wa_comment-typ = 'A'.
    wa_comment-info = 'DISPLAY BATCHES FOR QUALITY'.
*    *  WA_COMMENT-INFO = P_FRMDT.
    append wa_comment to comment.

  endif.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = comment
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  clear comment.

endform.                    "TOP
