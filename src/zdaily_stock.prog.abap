*&---------------------------------------------------------------------*
*& Report  ZDAILY_STOCK
*& Developed by Jyotsna
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zdaily_stock_3.

tables : mard,
         mara,
         makt,
         mvke,
         tvm5t.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

types  : begin of typ_vbrp,
           vbeln type vbrp-vbeln,
           fkimg type vbrp-fkimg,
           matnr type vbrp-matnr,
         end of typ_vbrp.

data : it_mard        type table of mard,
       wa_mard        type mard,
       it_mara        type table of mara,
       wa_mara        type mara,
       it_marc        type table of marc,
       wa_marc        type marc,
       it_vbrk        type table of vbrk,
       wa_vbrk        type vbrk,
       it_vbrp        type table of typ_vbrp,
       wa_vbrp        type typ_vbrp,
       it_vbrk1       type table of vbrk,
       wa_vbrk1       type vbrk,
       it_vbrp1       type table of typ_vbrp,
       wa_vbrp1       type typ_vbrp,
       it_zsales_tab1 type table of zsales_tab1,
       wa_zsales_tab1 type zsales_tab1.

types : begin of itab1,
          matnr  type mard-matnr,
          labst  type mard-labst,
          trame  type marc-trame,
          fkimg  type vbrp-fkimg,
          yfkimg type vbrp-fkimg,
        end of itab1.

types : begin of itab2,
          matnr  type mard-matnr,
          labst  type mard-labst,
          trame  type marc-trame,
          fkimg  type vbrp-fkimg,
          yfkimg type vbrp-fkimg,
          lys    type p,
          ssd    type p,
          stock  type p,
          maktx  type makt-maktx,
          bezei  type tvm5t-bezei,
        end of itab2.

data : it_tab1 type table of itab1,
       wa_tab1 type itab1,
       it_tab2 type table of itab2,
       wa_tab2 type itab2.

data : date1  type sy-datum,
       fdate1 type sy-datum,
       sdate1 type sy-datum,
       sdate2 type sy-datum.
data : fyear(4) type c,
       nyear(4) type c.
data : lys   type p,
       ssd   type p,
       stock type p,
       stk   type p.

selection-screen begin of block merkmale1 with frame title text-001.
select-options : material for mard-matnr,
                 mtart for mara-mtart.
selection-screen end of block merkmale1.

initialization.
  g_repid = sy-repid.

start-of-selection.

  if material is initial and mtart is initial.
    message 'ENTER PRODUCT CODE OR MATERIAL TYPE' type 'E'.
    exit.
  endif.
  select * from mara into table it_mara where matnr in material and mtart in mtart.
  if sy-subrc ne 0.
    exit.
  endif.

  perform sale.
  perform stock.
  perform lys.


  loop at it_tab1 into wa_tab1.
    clear: lys,ssd,stock,stk.
    stk = wa_tab1-yfkimg + wa_tab1-labst + wa_tab1-trame + wa_tab1-fkimg.
    if stk ne 0.
      if wa_tab1-yfkimg gt 0.
        lys = wa_tab1-yfkimg / 365.
      endif.
      if lys gt 0.
        ssd = ( wa_tab1-labst + wa_tab1-trame ) / lys.
      endif.
*    write : / 'A',wa_tab1-matnr,wa_tab1-labst,wa_tab1-trame,wa_tab1-fkimg,wa_tab1-yfkimg,lys,ssd.
      wa_tab2-matnr = wa_tab1-matnr.
      wa_tab2-labst = wa_tab1-labst.
      wa_tab2-trame = wa_tab1-trame.
      wa_tab2-fkimg = wa_tab1-fkimg.
      wa_tab2-yfkimg = wa_tab1-yfkimg.
      wa_tab2-lys = lys.
      wa_tab2-ssd = ssd.
      wa_tab2-stock = wa_tab1-labst + wa_tab1-trame.
      select single * from makt where matnr eq wa_tab1-matnr and spras eq 'EN'.
      if sy-subrc eq 0.
        wa_tab2-maktx = makt-maktx.
      endif.
      select single * from mvke where matnr eq wa_tab1-matnr and vkorg eq '1000' and vtweg eq '10'.
      if sy-subrc eq 0.
        select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
        if sy-subrc eq 0.
          wa_tab2-bezei = tvm5t-bezei.
        endif.
      else.
        select single * from mvke where matnr eq wa_tab1-matnr and vkorg eq '1000' and vtweg eq '80'.
        if sy-subrc eq 0.
          select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
          if sy-subrc eq 0.
            wa_tab2-bezei = tvm5t-bezei.
          endif.
        endif.
      endif.
      collect wa_tab2 into it_tab2.
      clear wa_tab2.
    endif.
  endloop.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PRODUCT CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'PRODUCT NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_l = 'PACK SIZE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LABST'.
  wa_fieldcat-seltext_l = 'STOCK'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'TRAME'.
  wa_fieldcat-seltext_l = 'TRANSIT STOCK'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'STOCK'.
  wa_fieldcat-seltext_l = 'TOTAL STOCK'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FKIMG'.
  wa_fieldcat-seltext_l = 'THIS MONTH SALE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'YFKIMG'.
  wa_fieldcat-seltext_l = 'LAST F. YEAR SALE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LYS'.
  wa_fieldcat-seltext_l = 'AVG. DAILY SALE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'SSD'.
  wa_fieldcat-seltext_l = 'SUFFICIENT STOCK'.
  append wa_fieldcat to fieldcat.




  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'STOCK SUFFICIENT FOR NO. OF DAYS'.


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
      t_outtab                = it_tab2
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

*endform.                    "SUMMARY

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'AS ON DATE STOCK STATUS'.
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
    when 'MATNR'.
      set parameter id 'MAT' field selfield-value.
      call transaction 'MM03' and skip first screen.
    when 'VBELN1'.
      set parameter id 'BV' field selfield-value.
      call transaction 'VL03N' and skip first screen.
    when others.
  endcase.
endform.                    "USER_COMM


*&---------------------------------------------------------------------*
*&      Form  SALE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form sale.
  date1 = sy-datum.
  date1+6(2) = '01'.

  select * from vbrk into table it_vbrk where fkdat ge date1 and fkdat le sy-datum and fkart in ('ZBDF','ZCDF') and fksto ne 'X'.
  if sy-subrc eq 0.
    select vbeln fkimg matnr from vbrp into table it_vbrp for all entries in it_vbrk where vbeln eq it_vbrk-vbeln.
  endif.
  delete it_vbrp where fkimg eq 0.
  loop at it_vbrp into wa_vbrp.
    read table it_mara into wa_mara with key matnr = wa_vbrp-matnr.
    if sy-subrc eq 0.
      wa_tab1-matnr = wa_vbrp-matnr.
      wa_tab1-fkimg = wa_vbrp-fkimg.
      collect wa_tab1 into it_tab1.
      clear wa_tab1.
    endif.
  endloop.
endform.
*&---------------------------------------------------------------------*
*&      Form  STOCK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form stock .

  if it_mara is not initial.
    select * from mard into table it_mard for all entries in it_mara where matnr eq it_mara-matnr and lgort ne 'CSM'.
    select * from marc into table it_marc for all entries in it_mara where matnr eq it_mara-matnr.
  endif.

  loop at it_mard into wa_mard.
    read table it_mara into wa_mara with key matnr = wa_mard-matnr.
    if sy-subrc eq 0.
      wa_tab1-matnr = wa_mard-matnr.
      wa_tab1-labst = wa_mard-labst.
      collect wa_tab1 into it_tab1.
      clear wa_tab1.
    endif.
  endloop.

  loop at it_marc into wa_marc.
    read table it_mara into wa_mara with key matnr = wa_marc-matnr.
    if sy-subrc eq 0.
      wa_tab1-matnr = wa_marc-matnr.
      wa_tab1-trame = wa_marc-trame.
      collect wa_tab1 into it_tab1.
      clear wa_tab1.
    endif.
  endloop.


endform.
*&---------------------------------------------------------------------*
*&      Form  LYS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form lys.
  fdate1 = sy-datum.
  if fdate1+4(2) ge '04'.
    fyear = sy-datum+0(4).
  else.
    fyear = sy-datum+0(4) - 1.
  endif.

  nyear = fyear - 1.

  sdate1+6(2) = '01'.
  sdate1+4(2) = '04'.
  sdate1+0(4) = nyear.

  sdate2+6(2) = '31'.
  sdate2+4(2) = '03'.
  sdate2+0(4) = fyear.

  if it_mara is not initial.
    select * from zsales_tab1 into table it_zsales_tab1 for all entries in it_mara where matnr eq it_mara-matnr and datab ge sdate1
      and datbi le sdate2 .
  endif.
  loop at it_zsales_tab1 into wa_zsales_tab1.
    wa_tab1-matnr = wa_zsales_tab1-matnr.
    wa_tab1-yfkimg = wa_zsales_tab1-c_qty.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.
  endloop.
endform.
