*&---------------------------------------------------------------------*
*& Report  ZSAMP_STOCK_VALUATION1
*&developed by Jyotsna - 4.5.2016
*&---------------------------------------------------------------------*
*&this program shows as on date stock vs. stock valuation
*&
*&---------------------------------------------------------------------*

report  zsamp_stock_valuation1.

tables : mchb,
         mbew,
         makt.

type-pools:  slis.

data: g_repid like sy-repid,
      fieldcat type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort type slis_t_sortinfo_alv,
      wa_sort like line of sort,
      layout type slis_layout_alv.

data : it_mchb type table of mchb,
       wa_mchb type mchb,
       it_mbew type table of mbew,
       wa_mbew type mbew.
types : begin of itab1,
  matnr type mchb-matnr,
  clabs type p,
  end of itab1.

types : begin of itab2,
matnr type mchb-matnr,
clabs type p,
  lbkum type p,
  maktx type makt-maktx,
  line_color(4) type c,
end of itab2.

data: ld_color(1) type c.
data : it_tab1 type table of itab1,
       wa_tab1 type itab1,
       it_tab2 type table of itab2,
       wa_tab2 type itab2.
selection-screen begin of block merkmale1 with frame title text-001.
select-options :  material for mchb-matnr obligatory.
parameters : plant like mchb-werks obligatory DEFAULT '2002'.
selection-screen end of block merkmale1 .

initialization.
  g_repid = sy-repid.

start-of-selection.

  select * from mchb into table it_mchb where matnr in material and werks eq plant and clabs gt 0.
  if sy-subrc eq 0.
    select * from mbew into table it_mbew for all entries in it_mchb where matnr eq it_mchb-matnr and bwkey eq plant and lbkum gt 0.
  endif.

  loop at it_mchb into wa_mchb.
*  WRITE : / WA_MCHB-MATNR,WA_MCHB-WERKS,WA_MCHB-LGORT,WA_MCHB-CHARG,WA_MCHB-CLABS.
    wa_tab1-matnr = wa_mchb-matnr.
    wa_tab1-clabs = wa_mchb-clabs.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.
  endloop.

  loop at it_tab1 into wa_tab1.
*  WRITE : / WA_TAB1-MATNR,WA_TAB1-CLABS.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-clabs = wa_tab1-clabs.
    read table it_mbew into wa_mbew with key matnr = wa_tab1-matnr.
    if sy-subrc eq 0.
*    WRITE :  WA_MBEW-LBKUM.
      wa_tab2-lbkum = wa_mbew-lbkum.
    endif.
    select single * from makt where matnr eq wa_tab1-matnr and spras eq 'EN'.
    if sy-subrc eq 0.
      wa_tab2-maktx = makt-maktx.
    endif.

    ld_color = ld_color + 1.
    if ld_color = 8.
      ld_color = 1.
    endif.
*    if wa_tab2-clabs eq wa_tab2-lbkum.
*      ld_color = 8.
*    else.
*      ld_color = 6.
*    endif.

    if wa_tab2-clabs gt wa_tab2-lbkum.
      ld_color = 6.
    else.
      ld_color = 8.
    endif.

    concatenate 'C' ld_color  into wa_tab2-line_color.

    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.

*  LOOP AT IT_TAB2 INTO WA_TAB2.
*    WRITE : / WA_TAB2-MATNR,WA_TAB2-MAKTX,WA_TAB2-CLABS,WA_TAB2-LBKUM.
*  ENDLOOP.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PRODUCT CODE'.
  wa_fieldcat-col_pos = '0'.
  wa_fieldcat-outputlen = '10'.
  wa_fieldcat-emphasize = 'X'.
  wa_fieldcat-key = 'X'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'PRODUCT DESCRIPTION'.
  wa_fieldcat-col_pos = '1'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CLABS'.
  wa_fieldcat-seltext_l = 'STOCK'.
  wa_fieldcat-col_pos = '2'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LBKUM'.
  wa_fieldcat-seltext_l = 'VALUATED STOCK'.
  wa_fieldcat-col_pos = '3'.
  append wa_fieldcat to fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'STOCK vs. VALUATED STOCK'.
  layout-info_fieldname  = 'LINE_COLOR'.


  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
     i_callback_program                =  g_repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
   i_callback_user_command           = 'USER_COMM'
   i_callback_top_of_page            = 'TOP'
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   is_layout                         = layout
     it_fieldcat                       = fieldcat
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
   i_save                            = 'A'
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
    tables
      t_outtab                          = it_tab2
   exceptions
     program_error                     = 1
     others                            = 2
            .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

*ENDFORM.                    "SUMMARY

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'STOCK vs. VALUATED STOCK'.
*  WA_COMMENT-INFO = P_FRMDT.
  append wa_comment to comment.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary       = comment
*     I_LOGO                   = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID       =
*     I_ALV_FORM               =
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
    when 'MATNR'.
      set parameter id 'MAT' field selfield-value.
      call transaction 'MM03' and skip first screen.
*    WHEN 'VBELN1'.
*      SET PARAMETER ID 'BV' FIELD SELFIELD-VALUE.
*      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    when others.
  endcase.
endform.                    "USER_COMM
