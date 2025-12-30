*&---------------------------------------------------------------------*
*& Report  ZBCLL_COSTING_RMPMGST
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zbcll_costing_fg_ana_a1.
tables : ztp_cost6,
         mara,
         makt,
         lfa1.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

data: it_ztp_cost6 type table of ztp_cost6,
      wa_ztp_cost6 type ztp_cost6.
types : begin of itab1,
          matnr      type mara-matnr,
          lifnr      type lfa1-lifnr,
          name1      type lfa1-name1,
          maktx      type makt-maktx,
          budat      type sy-datum,
          percnt(10) type c,
          sgtxt      type ztp_cost6-sgtxt,
          uname      type sy-uname,
          cpudt      type sy-datum,
          uzeit      type sy-uzeit,
          count(2)   type c,
        end of itab1.
data: it_tab1 type table of itab1,
      wa_tab1 type itab1.
data: count type i.
data: variant type disvariant.
data : gr_alvgrid    type ref to cl_gui_alv_grid,
       gr_ccontainer type ref to cl_gui_custom_container,
       gt_fcat       type lvc_t_fcat,
       gs_layo       type lvc_s_layo.
data: c_alvgd   type ref to cl_gui_alv_grid.         "ALV grid object
data: it_dropdown type lvc_t_drop,
      ty_dropdown type lvc_s_drop,
*data declaration for refreshing of alv
      stable      type lvc_s_stbl.
*Global variable declaration
data: gstring type c.
*Data declarations for ALV
data: c_ccont   type ref to cl_gui_custom_container,         "Custom container object
*      C_ALVGD   TYPE REF TO CL_GUI_ALV_GRID,         "ALV grid object
      it_fcat   type lvc_t_fcat,                  "Field catalogue
      it_layout type lvc_s_layo.                  "Layout
*ok code declaration
data:  ok_code       type ui_func.
data: ztp_cost6_wa type ztp_cost6.
***************************************************************************************

selection-screen begin of block merkmale1 with frame title text-001.
select-options : material for mara-matnr.

parameters : r1 radiobutton group r1,
             r2 radiobutton group r1.
selection-screen end of block merkmale1 .

initialization.
  g_repid = sy-repid.

at selection-screen.
  perform authorization.

start-of-selection.

  if r1 eq 'X'.
    perform display.
  elseif r2 eq 'X'.
    perform upddadat.
  endif.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form display .
  select * from ztp_cost6 into table it_ztp_cost6 where matnr in material.
  if sy-subrc ne 0.
    message 'NO DATA FOUND' type 'E'.
  endif.
  loop at it_ztp_cost6 into wa_ztp_cost6.
    wa_tab1-matnr = wa_ztp_cost6-matnr.
    wa_tab1-lifnr = wa_ztp_cost6-lifnr.
    select single * from lfa1 where lifnr eq wa_ztp_cost6-lifnr.
    if sy-subrc eq 0.
      wa_tab1-name1 = lfa1-name1.
    endif.
    select single * from makt where matnr eq wa_ztp_cost6-matnr and spras eq 'EN'.
    if sy-subrc eq 0.
      wa_tab1-maktx = makt-maktx.
    endif.
    wa_tab1-budat = wa_ztp_cost6-budat.
    wa_tab1-percnt = wa_ztp_cost6-percnt.
    wa_tab1-sgtxt = wa_ztp_cost6-sgtxt.
    wa_tab1-cpudt = wa_ztp_cost6-cpudt.
    wa_tab1-uzeit = wa_ztp_cost6-uzeit.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.
  endloop.

  loop at it_tab1 into wa_tab1.
    pack wa_tab1-matnr to wa_tab1-matnr.
    pack wa_tab1-lifnr to wa_tab1-lifnr.
    condense : wa_tab1-matnr, wa_tab1-lifnr.
    modify it_tab1 from wa_tab1 transporting matnr lifnr.
  endloop.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'MATERIAL CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'MATERIAL NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LIFNR'.
  wa_fieldcat-seltext_l = 'VENDOR CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'VENDOR NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PERCNT'.
  wa_fieldcat-seltext_l = 'ANALYTICAL CHARGES'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BUDAT'.
  wa_fieldcat-seltext_l = 'EFFECTIVE DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SGTXT'.
  wa_fieldcat-seltext_l = 'REMARK'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'UNAME'.
  wa_fieldcat-seltext_l = 'ENTERED BY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CPUDT'.
  wa_fieldcat-seltext_l = 'ENTERED ON DT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'UZEIT'.
  wa_fieldcat-seltext_l = 'ENTERED ON TIME'.
  append wa_fieldcat to fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'FINISHED PRODUCT, VENDOR WISE ANALYTICAL CHARGES FOR THIRD PARTY COSTING'.


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
      t_outtab                = it_tab1
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

  wa_comment-typ = 'A'.
  wa_comment-info = 'FINISHED PRODUCT VENDOR WISE CCPC RATES'.
*  WA_COMMENT-INFO = P_FRMDT.
  append wa_comment to comment.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = comment
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  clear comment.

endform.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
form user_comm using ucomm like sy-ucomm
                     selfield type slis_selfield.



  case selfield-fieldname.
    when 'VBELN'.
      set parameter id 'VF' field selfield-value.
      call transaction 'VF03' and skip first screen.
    when 'VBELN1'.
      set parameter id 'BV' field selfield-value.
      call transaction 'VL03N' and skip first screen.
    when others.
  endcase.
endform.                    "USER_COMM


*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDDADAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form upddadat .
  call screen 9001.


endform.


*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTHORIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form authorization .

endform.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_9001 output.
  set pf-status 'STATUS'.
  set titlebar 'CREATE'.
  perform data1.
endmodule.
*&---------------------------------------------------------------------*
*&      Form  DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form data1 .

  count = 1.
  do 20 times.
    wa_tab1-matnr = space.
    wa_tab1-lifnr = space.
    wa_tab1-budat = space.
    wa_tab1-percnt = space.
    wa_tab1-sgtxt = space.
    wa_tab1-count = count.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.
    count = count + 1.
  enddo.

  create object gr_alvgrid
    exporting
*     i_parent          = gr_ccontainer
      i_parent          = cl_gui_custom_container=>screen0
    exceptions
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      others            = 5.
  if sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

  perform alv_build_fieldcat.

  call method gr_alvgrid->set_table_for_first_display
    exporting
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
    changing
      it_outtab       = it_tab1
      it_fieldcatalog = it_fcat
*     IT_SORT         =
*     IT_FILTER       =
*      EXCEPTIONS
*     INVALID_PARAMETER_COMBINATION = 1
*     PROGRAM_ERROR   = 2
*     TOO_MANY_LINES  = 3
*     others          = 4
    .
  if sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_build_fieldcat .

  data lv_fldcat type lvc_s_fcat.

  lv_fldcat-fieldname = 'MATNR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  lv_fldcat-scrtext_m = 'MATERIAL CODE'.
  lv_fldcat-edit   = 'X'.
  lv_fldcat-f4availabl = 'X'.
  lv_fldcat-ref_table = 'MARA'.
  lv_fldcat-ref_field = 'MATNR'.
  lv_fldcat-outputlen = 10.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'LIFNR'.
*  LV_FLDCAT-TABNAME   = 'IT_TAB1'.
  lv_fldcat-scrtext_m = 'VENDOR CODE'.
  lv_fldcat-edit   = 'X'.
  lv_fldcat-f4availabl = 'X'.
  lv_fldcat-ref_table = 'LFA1'.
  lv_fldcat-ref_field = 'LIFNR'.
  lv_fldcat-outputlen = 10.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'BUDAT'.
  lv_fldcat-scrtext_m = 'EFFECTIVE FROM'.
  lv_fldcat-edit   = 'X'.
  lv_fldcat-outputlen = 10.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.


  lv_fldcat-fieldname = 'PERCNT'.
  lv_fldcat-scrtext_m = 'ANALYTICAL CHARGES'.
  lv_fldcat-edit   = 'X'.
  lv_fldcat-outputlen = 10.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.


  lv_fldcat-fieldname = 'SGTXT'.
  lv_fldcat-scrtext_m = 'REMARK IF ANY'.
  lv_fldcat-edit   = 'X'.
  lv_fldcat-outputlen = 50.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.



endform.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_9001 input.
  gr_alvgrid->check_changed_data( ).
  case ok_code.
    when 'SAVE'.
*      BREAK-POINT.
      perform dataupd.
      message 'SAVE' type 'I'.
      leave to screen 0.
    when 'BACK' or 'EXIT' or 'CANCEL'.
      leave to screen 0.
  endcase.
  clear: ok_code.
endmodule.
*&---------------------------------------------------------------------*
*&      Form  DATAUPD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form dataupd .

  loop at it_tab1 into wa_tab1 where percnt gt 0.
    if wa_tab1-matnr is initial.
      message 'ENTER MATERIAL CODE' type 'E'.
    endif.
*    select single * from mara where matnr eq wa_tab1-matnr and mtart in ( 'ZHWA', 'ZDSM' ).
    select single * from mara where matnr eq wa_tab1-matnr and mtart in ( 'ZFRT', 'ZDSM' ).
    if sy-subrc eq 4.
      message 'ENTER VALID MATERIAL CODE' type 'E'.
    endif.
    select single * from lfa1 where lifnr eq wa_tab1-lifnr .
    if sy-subrc eq 4.
      message 'ENTER VALID VENDOR CODE' type 'E'.
    endif.
    if wa_tab1-budat lt sy-datum.
      message 'BACK DATE ENTRY IS NOT ALLOWED, ENTER FUTURE DATE' type 'E'.
    endif.
  endloop.

  loop at it_tab1 into wa_tab1 where percnt gt 0.
    ztp_cost6_wa-matnr = wa_tab1-matnr.
    ztp_cost6_wa-lifnr = wa_tab1-lifnr.
    ztp_cost6_wa-budat = wa_tab1-budat.
    ztp_cost6_wa-percnt = wa_tab1-percnt.
    ztp_cost6_wa-sgtxt = wa_tab1-sgtxt.
    ztp_cost6_wa-uname = sy-uname.
    ztp_cost6_wa-cpudt = sy-datum.
    ztp_cost6_wa-uzeit = sy-uzeit.
    modify ztp_cost6 from ztp_cost6_wa.
    clear ztp_cost6_wa.
  endloop.
  if sy-subrc eq 0.
    message 'SAVE DATA' type 'I'.
  endif.
endform.
