*&---------------------------------------------------------------------*
*& Report  ZBATCH_CARD1
*& developed by Jyotsna
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  zbatch_card15 no standard page heading line-size 500.
tables : mseg,
         mara,
         likp,
         t001w,
         vbrk,
         qals,
         s035,
         makt.

type-pools:  slis.

data: g_repid like sy-repid,
      fieldcat type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort type slis_t_sortinfo_alv,
      wa_sort like line of sort,
      layout type slis_layout_alv.

types : begin of itab1,
  vbeln(12) type c,
  matnr type vbrp-matnr,
  arktx type vbrp-arktx,
  charg type vbrp-charg,
  fkimg type p decimals 0,
  netwr type vbrp-netwr,
  werks type vbrp-werks,
  lgort type vbrp-lgort,
  fkdat type vbrk-fkdat,
  kunag type vbrk-kunag,
*  vbeln1 TYPE likp-vbeln,
  vbeln1(12) type c,
  bolnr type likp-bolnr,
  vgbel type vbrp-vgbel,
  kunnr type t001w-kunnr,
  qty_c type vbrp-fkimg,
  qty_f type vbrp-fkimg,
  val_c type vbrp-netwr,
  val_f type vbrp-netwr,
  name1 type kna1-name1,
  ort01 type kna1-ort01,
  end of itab1.

types : begin of typ_mkpf,
  mblnr type mkpf-mblnr,
  mjahr type mkpf-mjahr,
  xblnr type mkpf-xblnr,
  end of typ_mkpf.

types : begin of typ_vbrk,
  vbeln type vbrk-vbeln,
  fkart type vbrk-fkart,
  fkdat type vbrk-fkdat,
  kunag type vbrk-kunag,
  rfbsk type vbrk-rfbsk,
  fksto type vbrk-fksto,
  end of typ_vbrk.

types : begin of typ_vbrp,
  vbeln type vbrk-vbeln,
  werks type vbrp-werks,
  matnr type vbrp-matnr,
  charg type vbrp-charg,
  pstyv type vbrp-pstyv,
  fkimg type vbrp-fkimg,
  netwr type vbrp-netwr,
  vgbel type vbrp-vgbel,
  arktx type vbrp-arktx,
  lgort type vbrp-lgort,
  end of typ_vbrp.

data : it_qals type table of qals,
       wa_qals type qals,
       it_mkpf type table of typ_mkpf,
       wa_mkpf type typ_mkpf,
       wa_mara type typ_mkpf,
       it_vbrk type table of typ_vbrk,
       wa_vbrk type typ_vbrk,
       it_vbrp type table of typ_vbrp,
       wa_vbrp type typ_vbrp,
       it_likp type table of likp,
       wa_likp type likp,
       it_kna1 type table of kna1,
       wa_kna1 type kna1.


data : it_tab1 type table of itab1,
    wa_tab1 type itab1.

data : rcpt type p decimals 3,
       year1(4) type c,
       year2(4) type c.

parameters : batch like mseg-charg obligatory.
*SELECT-OPTIONS : year FOR mseg-gjahr.
select-options : s_date for vbrk-fkdat.
parameters : r1 radiobutton group r1,
             r2 radiobutton group r1.
*             r3 radiobutton group r1.

at selection-screen output.
  loop at screen.
    if screen-name = 'BATCH'.
      screen-input = '1'.
      modify screen.
    endif.
*    if screen-name = 'BATCH-HIGH'.
*      screen-input = '0'.
*      modify screen.
*    endif.
  endloop.
*if r3 eq 'X'.
*    loop at screen.
*      if screen-name = 'BATCH'.
*        screen-input = '0'.
*        modify screen.
*      endif.
*    endloop.
** ELSEif R2 eq 'X'.
**    loop at screen.
**      if screen-name = 'BATCH'.
**        screen-input = '1'.
**        modify screen.
**      endif.
**    endloop.
*  endif.



initialization.
  g_repid = sy-repid.

start-of-selection.


  if r1 eq 'X'.
    perform transfer.
  elseif r2 eq 'X'.
    perform sale.
*elseif r3 eq 'X'.
*  perform summary.
  endif.

*&---------------------------------------------------------------------*
*&      Form  summary
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form summary.
  clear rcpt.
  select * from qals into table it_qals where paendterm in s_date and art eq '08' and lagortchrg in ('FG01','FG02','FG03','FG04').
*  AND charg eq batch.
  if sy-subrc ne 0.
    exit.
  endif.
*SORT IT_QALS BY .

  loop at it_qals into wa_qals.
    select single * from makt where matnr eq wa_qals-matnr.
    if sy-subrc eq 0.
      write : / makt-maktx.
    endif.
    write :  wa_qals-matnr,wa_qals-charg,wa_qals-prueflos,wa_qals-paendterm,wa_qals-lagortchrg,wa_qals-lmenge01.
    select single * from s035 where matnr = wa_qals-matnr and charg = wa_qals-charg and werks = wa_qals-werk and lgort eq 'CSM'.
    if sy-subrc eq 0.
      write : s035-cmbwbest.
    endif.
    rcpt = wa_qals-lmenge01 - s035-cmbwbest.
    write : rcpt.
  endloop.



endform.                    "summary


*&---------------------------------------------------------------------*
*&      Form  transfer
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form transfer.

  select vbeln fkart fkdat kunag rfbsk fksto from vbrk into table it_vbrk where fkart in ('ZF8','ZJSP') and fkdat in s_date and rfbsk ne 'E'.
  if sy-subrc eq 0.
    select vbeln werks matnr charg pstyv fkimg netwr vgbel arktx lgort from vbrp into table it_vbrp for all entries in it_vbrk where vbeln eq it_vbrk-vbeln and charg eq batch.
    if sy-subrc eq 0.
      select * from likp into table it_likp for all entries in it_vbrp where vbeln eq it_vbrp-vgbel.
      if sy-subrc ne 0.
        exit.
      endif.
    endif.
  endif.

  delete it_vbrp where fkimg eq 0.
*YEAR1 = S_DATE-LOW.
*YEAR2 = S_DATE-HIGH.
*WRITE : YEAR1,YEAR2.

  loop at it_vbrp into wa_vbrp from sy-tabix where charg eq batch.
    read table it_likp into wa_likp with key vbeln = wa_vbrp-vgbel.
    if sy-subrc eq 0.
*    MOVE-CORRESPONDING wa_vbrp to wa_tab1.
*  WRITE : / wa_vbrp-vbeln,wa_vbrp-matnr,wa_vbrp-arktx,wa_vbrp-charg,wa_vbrp-fkimg,wa_vbrp-netwr,wa_vbrp-werks.
      wa_tab1-vbeln =  wa_vbrp-vbeln.
      wa_tab1-matnr = wa_vbrp-matnr.
      wa_tab1-arktx = wa_vbrp-arktx.
      wa_tab1-charg = wa_vbrp-charg.
      wa_tab1-fkimg = wa_vbrp-fkimg.
      wa_tab1-netwr = wa_vbrp-netwr.
      wa_tab1-werks = wa_vbrp-werks.
      select single * from t001w where werks eq wa_vbrp-werks.
      if sy-subrc eq 0.
        wa_tab1-kunnr = t001w-kunnr.
      endif.
      wa_tab1-lgort = wa_vbrp-lgort.
      wa_tab1-vgbel = wa_vbrp-vgbel.
*  wa_tab1-BOLNR = wa_likp-BOLNR.
      read table it_vbrk into wa_vbrk with key vbeln = wa_vbrp-vbeln.
*  write : wa_vbrk-fkdat,wa_vbrk-kunag.
      wa_tab1-fkdat =  wa_vbrk-fkdat.
      wa_tab1-kunag = wa_vbrk-kunag.

      collect wa_tab1 into it_tab1.
      clear wa_tab1.
    endif.
    clear wa_tab1.
  endloop.

  select * from qals into table it_qals where charg eq batch and lagortchrg in ('FG01','FG02','FG03','FG04') and bwart in ('349','350').
  if sy-subrc ne 0.
*    EXIT.
  endif.

  loop at it_qals into wa_qals.
    if wa_qals-bwart eq '350'.
      wa_qals-lmenge01 = wa_qals-lmenge01 * ( - 1 ).
    endif.
  endloop.

  write : / 'TOTAL QUANTITY RECEIPT AT BSR :'.
  write : 33 wa_qals-lmenge01 left-justified.
  select single * from s035 where charg eq wa_qals-charg and werks eq wa_qals-werk and lgort eq 'CSM'.
  if sy-subrc eq 0.
    write :47  'QTY FOR CONTROL SAMPLE',72 s035-cmbwbest left-justified.
  endif.
  rcpt = wa_qals-lmenge01 - s035-cmbwbest.
  write : 85 'TOTAL QTY AT BSR',103 rcpt left-justified.
  write : /(113) sy-uline.

  loop at it_tab1 into wa_tab1.
    write : /1 wa_tab1-kunnr,15 wa_tab1-kunag,32 wa_tab1-vbeln,45 wa_tab1-fkdat,57 wa_tab1-vgbel,69 wa_tab1-matnr,82 wa_tab1-charg,95 wa_tab1-fkimg.
  endloop.

endform.                    "transfer

*&---------------------------------------------------------------------*
*&      Form  sale
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form sale.

  select vbeln fkart fkdat kunag rfbsk fksto from vbrk into table it_vbrk where fkart in ('ZCDF','ZBDF') and fkdat in s_date and rfbsk ne 'E'
    and fksto ne 'X'..
  if sy-subrc eq 0.
    select vbeln werks matnr charg pstyv fkimg netwr from vbrp into table it_vbrp for all entries in it_vbrk where vbeln eq it_vbrk-vbeln
      and charg eq batch.
*    IF sy-subrc EQ 0.
*    SELECT * FROM likp INTO TABLE it_likp FOR ALL ENTRIES IN it_vbrp WHERE vbeln EQ it_vbrp-vgbel.
    if sy-subrc ne 0.
      exit.
    endif.
*    ENDIF.
  endif.

  delete it_vbrp where fkimg eq 0.

  select * from kna1 into table it_kna1 for all entries in it_vbrk where kunnr eq it_vbrk-kunag.

  loop at it_vbrp into wa_vbrp.
*WRITE : / 'SALE',wa_vbrp-werks,wa_vbrp-vbeln,wa_vbrp-matnr,wa_vbrp-charg,wa_vbrp-pstyv,wa_vbrp-netwr.
    wa_tab1-werks = wa_vbrp-werks.
    wa_tab1-vbeln = wa_vbrp-vbeln.
    wa_tab1-matnr = wa_vbrp-matnr.
    wa_tab1-charg = wa_vbrp-charg.
*wa_tab1-pstyv = wa_vbrp-pstyv.

    if wa_vbrp-pstyv eq 'ZAN'.
      wa_tab1-qty_c = wa_vbrp-fkimg.
      wa_tab1-val_c = wa_vbrp-netwr.
    elseif wa_vbrp-pstyv eq 'ZANN'.
      wa_tab1-qty_f = wa_vbrp-fkimg.
      wa_tab1-val_f = wa_vbrp-netwr.
    endif.

    read table it_vbrk into wa_vbrk with key vbeln = wa_vbrp-vbeln.
    if sy-subrc eq 0.
*  WRITE : wa_vbrk-kunag,wa_vbrk-fkdat.
      wa_tab1-kunag = wa_vbrk-kunag.
      wa_tab1-fkdat = wa_vbrk-fkdat.
      read table it_kna1 into wa_kna1 with key kunnr = wa_vbrk-kunag.
      if sy-subrc eq 0.
*    WRITE : 15 WA_KNA1-NAME1,50 WA_KNA1-ORT01.
        wa_tab1-name1 = wa_kna1-name1.
        wa_tab1-ort01 = wa_kna1-ort01.
      endif.
    endif.

    collect wa_tab1 into it_tab1.
    clear wa_tab1.
  endloop.
  clear : it_vbrk,wa_vbrk,it_vbrp,wa_vbrp.



*LOOP AT IT_TAB1 INTO WA_TAB1.
*  WRITE : /1 WA_TAB1-WERKS,8 WA_TAB1-KUNAG.
*  READ TABLE IT_KNA1 INTO WA_KNA1 WITH KEY KUNNR = WA_TAB1-KUNAG.
*  IF SY-SUBRC EQ 0.
*    WRITE : 15 WA_KNA1-NAME1,50 WA_KNA1-ORT01.
*  ENDIF.
*  WRITE : 68 WA_TAB1-VBELN,80 WA_TAB1-FKDAT,92 WA_TAB1-MATNR,110 WA_TAB1-CHARG,122 WA_TAB1-QTY_C LEFT-JUSTIFIED,134 WA_TAB1-VAL_C LEFT-JUSTIFIED,
*          146 WA_TAB1-QTY_F LEFT-JUSTIFIED.
**  WA_TAB1-VAL_F.
*ENDLOOP.


  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'SALE FROM PLANT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'KUNAG'.
  wa_fieldcat-seltext_l = 'SALE TO CUSTOMER'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'CUSTOMER NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'ORT01'.
  wa_fieldcat-seltext_l = 'PLACE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VBELN'.
  wa_fieldcat-seltext_l = 'INVOICE NO'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FKDAT'.
  wa_fieldcat-seltext_l = 'INVOICE DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'MATERIAL CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'QTY_C'.
  wa_fieldcat-seltext_l = 'SALE-QTY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VAL_C'.
  wa_fieldcat-seltext_l = 'NET SALE VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'QTY_F'.
  wa_fieldcat-seltext_l = 'FREE QTY'.
  append wa_fieldcat to fieldcat.






  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'BATCH SALE'.

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
        t_outtab                          = it_tab1
     exceptions
       program_error                     = 1
       others                            = 2
              .
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    "sale


*&---------------------------------------------------------------------*
*&      Form  top
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'SALE'.
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

endform.                                                    "TOP1

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
    when 'VBELN'.
      set parameter id 'VF' field selfield-value.
      call transaction 'VF03' and skip first screen.
    when others.
  endcase.
endform.                    "USER_COMM



top-of-page.
  if r1 eq 'X'.
    write : /1 'FROM',15 'TO',32 'INV NO',45 'INV DATE',57 'DELIVERY',69 'MATERIAL',82 'BATCH',100 'QUANTITY'.
    write : /1 'LOCATION',15 'LOCATION'.
    skip.
    uline.
  elseif r2 eq 'X'.
    write : /1 'FROM',8 'TO',15 'CUSTOMER',50 'PLACE',68 'INV NO',80 'INV DATE',92 'MATERIAL',110 'BATCH',122 'SALE QTY',134 'SALE VAL',146 'FREE QTY'.
    write : /1 'PLANT',8 'CUST.',15 'NAME'.
    skip.
    uline.
*elseif r3 eq 'X'.
*write : /1 'PRODUT NAME',42  'CODE',61 'BATCH',72 'INSP. LOT NO',85 'REL_DATE',96 'STORAGE',108 'TOTAL QTY',
*         132 'CS QTY',142 'NET_QTY_AT_BSR'.
*skip.
*uline.
  endif.
