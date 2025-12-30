report zbcllsd_daily_stock_batch no standard page heading line-size 350.

********DEVELOPED BY JYOTSNA FOR STORE
tables : mch1,
         mchb,
         makt,
         mara,
         t023t,
         mbew,
         jest,
         mkpf,
         ekko,
         lfa1,
         t001w,
         qals,
         mseg.


type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

types : begin of itas1,
          werks  type mchb-werks,
          matnr  like mchb-matnr,
          mtart  type mara-mtart,
          matkl  type mara-matkl,
          wgbez  type t023t-wgbez,
          maktx  like makt-maktx,
          lgort  like mchb-lgort,
          charg  like mchb-charg,
          vfdat  like MCH1-vfdat,
          hsdat  like MCH1-hsdat,
          clabs  type mchb-clabs,
          cinsm  type mchb-cinsm,
          cspem  type mchb-cspem,
          verpr  type mbew-verpr,
          peinh  type mbew-peinh,
          val    type p decimals 2,
          totqty type mchb-clabs,
        end of itas1.

types : begin of itas2,
          werks    type mchb-werks,
          matnr    like mchb-matnr,
          mtart    type mara-mtart,
          matkl    type mara-matkl,
          wgbez    type t023t-wgbez,
          maktx    like makt-maktx,
          lgort    like mchb-lgort,
          charg    like mchb-charg,
          vfdat    like mch1-vfdat,
          hsdat    like mch1-hsdat,
          clabs    type mchb-clabs,
          cinsm    type mchb-cinsm,
          cspem    type mchb-cspem,
          verpr    type mbew-verpr,
          peinh    type mbew-peinh,
          val      type p decimals 2,
          mblnr    type mseg-mblnr,
          totqty   type mchb-clabs,
          budat    type mkpf-budat,
          lifnr    type lfa1-lifnr,
          ebeln    type mseg-ebeln,
          name1    type lfa1-name1,
          popenqty type ekpo-menge,
        end of itas2.

types : begin of itab1,
          txt1(10) type c,
        end of itab1.

data: ablad(500) type c.
data : it_tas1 type table of itas1,
       wa_tas1 type itas1,
       it_tas2 type table of itas2,
       wa_tas2 type itas2,
       it_tab1 type table of itab1,
       wa_tab1 type itab1.

data: it_mchb  type table of mchb,
      wa_mchb  type mchb,
      it_mara  type table of  mara,
      wa_mara  type mara,
      it_mseg  type table of mseg,
      wa_mseg  type mseg,
      it_qals  type table of qals,
      wa_qals  type qals,
      it_qals1 type table of qals,
      wa_qals1 type qals,
      it_ekpo  type table of ekpo,
      wa_ekpo  type ekpo,
      it_ekko  type table of ekko,
      wa_ekko  type ekko.

data : it_mast type table of mast,
       wa_mast type mast,
       it_stpo type table of stpo,
       wa_stpo type stpo.

types : begin of tal1,
          idnrk  type stpo-idnrk,
          maktx  type makt-maktx,
          maktx1 type makt-maktx,
          menge  type stpo-menge,
          meins  type stpo-meins,
          stlnr  type mast-stlnr,
          matnr  type mast-matnr,
          werks  type mast-werks,
          del    type mara-lvorm,
        end of tal1.

types : begin of po1,
          matnr type ekpo-matnr,
          menge type ekpo-menge,
        end of po1.

data: it_tal1 type table of tal1,
      wa_tal1 type tal1,
      it_po1  type table of po1,
      wa_po1  type po1.

data: maktx1     type makt-maktx,
      maktx2     type makt-maktx,
      normt      type mara-normt,
      maktx(100) type c.
data: rate type p decimals 2,
      val  type p decimals 2.

data: w_totqty type mchb-clabs.

types: begin of typ_t001w,
         werks type werks_d,
         name1 type name1,
       end of typ_t001w.

types: begin of itam1,
         matnr      type qals-matnr,
         werks      type qals-werk,
         maktx(100) type c,
         menge      type mseg-menge,
         meins      type mseg-meins,
       end of itam1.

types: begin of itam2,
         matnr      type qals-matnr,
         maktx(100) type c,
         menge(15)  type c,
         meins      type mseg-meins,
       end of itam2.

data : itab_t001w type table of typ_t001w,
       wa_t001w   type typ_t001w.
data: it_tam1 type table of itam1,
      wa_tam1 type itam1.
data: it_tam2 type table of itam2,
      wa_tam2 type itam2.
data : msg type string.
data: qty type p decimals 3.
data: kunnr type t001w-kunnr.

data: g_repid1     like sy-repid,
      fieldcat1    type slis_t_fieldcat_alv,
      wa_fieldcat1 like line of fieldcat,
      sort1        type slis_t_sortinfo_alv,
      wa_sort1     like line of sort,
      layout1      type slis_layout_alv,
      l_glay1      type lvc_s_glay.
data: podate1 type sy-datum.
******************************************************************************************************************
data: fm_name         type rs38l_fnam,      " CHAR 30 0 Name of Function Module
      fp_docparams    type sfpdocparams,    " Structure  SFPDOCPARAMS Short Description  Form Parameters for Form Processing
      fp_outputparams type sfpoutputparams. " Structure  SFPOUTPUTPARAMS Short Description  Form Processing Output Parameter
*      it_mara         type zmara_t1.       " tamle Type ZMARI_TBL MARI tamle Tyoe
*      it_qals         type table of qals,
*      wa_qals         type qals.
data: year  type mseg-mjahr,
      year2 type mseg-mjahr.
********************************************************************************************************************

selection-screen begin of block merkmale1 with frame title text-001.
parameters : r1 radiobutton group r1  user-command r2 default 'X',
             r2 radiobutton group r1.
selection-screen end of block merkmale1.

selection-screen begin of block merkmale with frame title text-001.
select-options  : matnr for mara-matnr,
mtart for mara-mtart,
lgort for mchb-lgort.
*P_PLANT FOR  MCHB-WERKS OBLIGATORY.
parameters :  p_plant like mchb-werks.
selection-screen end of block merkmale.

selection-screen begin of block merkmale2 with frame title text-002.
select-options : mcode for qals-matnr,
                 budat for sy-datum ,
                 mov for mseg-bwart,
                 str for mseg-lgort.
parameters: werks like mchb-werks .
selection-screen end of block merkmale2.

at selection-screen output.
  if r1 eq 'X'.
    loop at screen.
      if screen-name cp '*MATNR*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*MTART*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*LGORT*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*P_PLANT*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.

    loop at screen.
      if screen-name cp '*MCODE*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.

    loop at screen.
      if screen-name cp '*BUDAT*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*MOV*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*STR*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*WERKS*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.



  elseif r2 eq 'X'.
    loop at screen.
      if screen-name cp '*MATNR*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*MTART*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*LGORT*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*P_PLANT*'.
        screen-active = 0.
        modify screen.
      endif.
    endloop.

    loop at screen.
      if screen-name cp '*MCODE*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.

    loop at screen.
      if screen-name cp '*BUDAT*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*MOV*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*STR*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
    loop at screen.
      if screen-name cp '*WERKS*'.
        screen-active = 1.
        modify screen.
      endif.
    endloop.
  endif.


initialization.
  g_repid = sy-repid.

at selection-screen.
  perform authorization.

start-of-selection.

  if r1 eq 'X'.
    if p_plant is initial.
      message 'ENTER PLANT ' type 'E'.
    endif.
  elseif r2 eq 'X'.
    if werks is initial.
      message 'ENTER PLANT' type 'E'.
    endif.
    if budat is initial.
      message 'ENTER POSTING DATE' type 'E'.
    endif.

  endif.


  if r2 eq 'X'.
    perform mat_cons.
  else.
    perform stock.
  endif.


*---------------------------------------------------------------------*
*       FORM itab-upd                                                 *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*





form alv.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'PLANT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MTART'.
  wa_fieldcat-seltext_l = 'TYPE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'MATERIAL CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'MATERIAL NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LGORT'.
  wa_fieldcat-seltext_l = 'STORAGE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MATKL'.
  wa_fieldcat-seltext_l = 'MAT GROUP'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'WGBEZ'.
  wa_fieldcat-seltext_l = 'MAT GROUP NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VFDAT'.
  wa_fieldcat-seltext_l = 'EXPIRY DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'HSDAT'.
  wa_fieldcat-seltext_l = 'MFG. DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CLABS'.
  wa_fieldcat-seltext_l = 'UNRESTRICTED STOCK'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CINSM'.
  wa_fieldcat-seltext_l = 'QUALITY STOCK'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CSPEM'.
  wa_fieldcat-seltext_l = 'BLOCKED STOCK'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VERPR'.
  wa_fieldcat-seltext_l = 'MOVING RATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'PEINH'.
  wa_fieldcat-seltext_l = 'MOVING RATE PER'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'TOTQTY'.
  wa_fieldcat-seltext_l = 'TOTAL QUANTITY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VAL'.
  wa_fieldcat-seltext_l = 'TOTAL VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MBLNR'.
  wa_fieldcat-seltext_l = 'GRN DOC'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BUDAT'.
  wa_fieldcat-seltext_l = 'GRN POSTING DT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LIFNR'.
  wa_fieldcat-seltext_l = 'VENDOR CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'VENDOR NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'POPENQTY'.
  wa_fieldcat-seltext_l = 'PO PENDING QTY'.
  append wa_fieldcat to fieldcat.



  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'STOCK DETAIL'.


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
*     IT_EVENTS               = IT_EVENTS
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
      t_outtab                = it_tas2
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    "itab-prt

form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'DOUBLE CLICK ON MATERIAL CODE FOR WHERE USED FG CODE LIST'.
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

form top2.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'LIST OF FINISHED PRODUCTS WHERE MATERIAL IS USED'.
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
form user_comm using ucomm like sy-ucomm selfield type slis_selfield.
*FORM USER_COMMAND USING UCOMM LIKE SY-UCOMM SELC TYPE SLIS_SELFIELD.
*  BREAK-POINT.
  check ucomm = '&IC1'.

  case ucomm.
      if selfield-fieldname = 'MATNR'.
        clear : matnr.
        matnr = selfield-value.
        select single * from mara where matnr eq matnr and mtart in ('ZROH','ZVRP').
        if sy-subrc eq 4.
          message 'FG WHERE USED LIST IS ONLY FOR RM & PM' type 'E'.
        endif.
        SHIFT matnr LEFT DELETING LEADING '0'.

        perform bom.
        perform alv1.

*        WA_TAB1-TXT1 = 'TEST'.
*        COLLECT WA_TAB1 INTO IT_TAB1.
*        CLEAR WA_TAB1.
      endif.
  endcase.





*  CASE UCOMM.
*    BREAK-POINT.
*    WHEN '&IC1'.
*      PERFORM BOMDATA.
*    WHEN OTHERS.
*  ENDCASE.

*  CASE SELFIELD-FIELDNAME.
*    WHEN 'MATNR'.
*      SET PARAMETER ID 'MAT' FIELD SELFIELD-VALUE.
*      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
*    WHEN 'VBELN1'.
*      SET PARAMETER ID 'BV' FIELD SELFIELD-VALUE.
*      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
*    WHEN OTHERS.
*  ENDCASE.
endform.                    "USER_COMM

form authorization .

  select werks name1 from t001w into table itab_t001w where werks eq p_plant.

  loop at itab_t001w into wa_t001w.
    authority-check object 'M_BCO_WERK'
           id 'WERKS' field wa_t001w-werks.
    if sy-subrc <> 0.
      concatenate 'No authorization for Plant' wa_t001w-werks into msg
      separated by space.
      message msg type 'E'.
    endif.
  endloop.

endform.
*&---------------------------------------------------------------------*
*&      Form  BOMDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form bomdata .
*  BREAK-POINT.
  message 'CHECK' type 'I' .
endform.
*&---------------------------------------------------------------------*
*&      Form  TITLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SELC_FIELDNAME  text
*      <--P_TITLE  text
*----------------------------------------------------------------------*
form alv1.

  wa_fieldcat1-fieldname = 'IDNRK'.
  wa_fieldcat1-seltext_s = 'ITEM CODE'.
  append wa_fieldcat1 to fieldcat1.
  clear  wa_fieldcat1 .

  wa_fieldcat1-fieldname = 'MAKTX'.
  wa_fieldcat1-seltext_l = 'ITEM CODE DESCRIPTION'.
  append wa_fieldcat1 to fieldcat1.
  clear  wa_fieldcat1 .

  wa_fieldcat1-fieldname = 'MENGE'.
  wa_fieldcat1-seltext_l = 'ITEM QTY'.
  append wa_fieldcat1 to fieldcat1.
  clear  wa_fieldcat1 .

  wa_fieldcat1-fieldname = 'MEINS'.
  wa_fieldcat1-seltext_l = 'UOM'.
  append wa_fieldcat1 to fieldcat1.
  clear  wa_fieldcat1 .

  wa_fieldcat1-fieldname = 'MATNR'.
  wa_fieldcat1-seltext_l = 'BOM PRODUCT'.
  append wa_fieldcat1 to fieldcat1.
  clear  wa_fieldcat1 .

  wa_fieldcat1-fieldname = 'MAKTX1'.
  wa_fieldcat1-seltext_l = 'BOM PRODUCT DESCRIPTION'.
  append wa_fieldcat1 to fieldcat1.
  clear  wa_fieldcat1 .

  wa_fieldcat1-fieldname = 'WERKS'.
  wa_fieldcat1-seltext_l = 'PLANT'.
  append wa_fieldcat1 to fieldcat1.
  clear  wa_fieldcat1 .

  wa_fieldcat1-fieldname = 'DEL'.
  wa_fieldcat1-seltext_l = 'DELETION FLAG'.
  append wa_fieldcat1 to fieldcat1.
  clear  wa_fieldcat1 .



*  WA_FIELDCAT1-FIELDNAME = 'TXT1'.
*  WA_FIELDCAT1-SELTEXT_L = 'TEXT'.
*  APPEND WA_FIELDCAT1 TO FIELDCAT1.
*  CLEAR WA_FIELDCAT1.

*    WA_FIELDCAT1-FIELDNAME = 'BELNR'.
*    WA_FIELDCAT1-SELTEXT_L = 'DOC NO.'.
*    APPEND WA_FIELDCAT1 TO FIELDCAT1.
*    CLEAR WA_FIELDCAT1.
*
*    WA_FIELDCAT1-FIELDNAME = 'GJAHR'.
*    WA_FIELDCAT1-SELTEXT_L = 'YEAR'.
*    APPEND WA_FIELDCAT1 TO FIELDCAT1.
*    CLEAR WA_FIELDCAT1.
*
*    WA_FIELDCAT1-FIELDNAME = 'BUZEI'.
*    WA_FIELDCAT1-SELTEXT_L = 'ITEM NO.'.
*    APPEND WA_FIELDCAT1 TO FIELDCAT1.
*    CLEAR WA_FIELDCAT1.
*
*    WA_FIELDCAT1-FIELDNAME = 'DMBTR'.
*    WA_FIELDCAT1-SELTEXT_L = 'VALUE'.
*    APPEND WA_FIELDCAT1 TO FIELDCAT1.
*    CLEAR WA_FIELDCAT1.

  layout1-zebra = 'X'.
  layout1-colwidth_optimize = 'X'.
  layout1-window_titlebar  = 'DETAIL LIST'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = 'STATUS'
      i_callback_user_command = 'USER_COMM1'
      i_callback_top_of_page  = 'TOP2'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         = L_GLAY
      is_layout               = layout1
      it_fieldcat             = fieldcat1
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
      t_outtab                = it_tal1
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.


  clear : it_tab1,wa_tab1, fieldcat1.
endform.
*&---------------------------------------------------------------------*
*&      Form  BOM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form bom .
  clear : it_stpo,wa_stpo,it_mast,wa_mast.
  clear : it_tal1,wa_tal1.
  select * from stpo into table it_stpo where stlty eq 'M' and idnrk eq matnr.
  if sy-subrc eq 0.
    select * from mast into table it_mast for all entries in it_stpo where stlnr eq it_stpo-stlnr and werks eq p_plant.
  endif.

  loop at it_stpo   into wa_stpo .
    loop at it_mast into wa_mast where stlnr eq wa_stpo-stlnr.
*      WRITE : / 'A',WA_STPO-IDNRK,WA_STPO-MENGE,WA_STPO-MEINS,WA_MAST-STLNR,WA_MAST-MATNR,WA_MAST-WERKS.
      wa_tal1-idnrk = wa_stpo-idnrk.
      wa_tal1-menge = wa_stpo-menge.
      wa_tal1-meins = wa_stpo-meins.
      select single * from makt where matnr eq wa_stpo-idnrk and spras eq 'EN'.
      if sy-subrc eq 0.
        wa_tal1-maktx = makt-maktx.
      endif.
      wa_tal1-stlnr = wa_mast-stlnr.
      wa_tal1-matnr = wa_mast-matnr.
      select single * from makt where matnr eq wa_mast-matnr and spras eq 'EN'.
      if sy-subrc eq 0.
        wa_tal1-maktx1 = makt-maktx.
      endif.
      wa_tal1-werks = wa_mast-werks.
      select single * from mara where matnr eq wa_mast-matnr.
      if sy-subrc eq 0.
        wa_tal1-del = mara-lvorm.
      endif.
      collect wa_tal1 into it_tal1.
      clear wa_tal1.
    endloop.
  endloop.
endform.
*&---------------------------------------------------------------------*
*&      Form  PENPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form penpo .
  podate1 = sy-datum - 900.
  if it_tas1 is not initial.
    select * from ekpo into table it_ekpo for all entries in it_tas1 where loekz eq space and matnr eq it_tas1-matnr and werks eq p_plant
      and aedat ge podate1 and elikz eq space.
    if sy-subrc eq 0.
      select * from ekko into table it_ekko for all entries in it_ekpo where ebeln eq it_ekpo-ebeln and bsart eq 'ZDOM' and aedat ge podate1.
    endif.
  endif.

  loop at it_ekpo into wa_ekpo.
    read table it_ekko into wa_ekko with key ebeln = wa_ekpo-ebeln.
    if sy-subrc eq 0.
      wa_po1-matnr = wa_ekpo-matnr.
      wa_po1-menge = wa_ekpo-menge.
      collect wa_po1 into it_po1.
      clear wa_po1.
    endif.
  endloop.

*  LOOP AT IT_PO1 INTO WA_PO1.
*    WRITE : / WA_PO1-MATNR, WA_PO1-MENGE.
*  ENDLOOP.


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
  clear : it_mchb,it_mara.

  select * from mchb into table it_mchb where matnr in matnr  and werks eq p_plant and lgort in lgort and lgort ne 'CSM'.
  if sy-subrc eq 0.
    select * from mara into table it_mara where matnr in matnr and mtart in mtart.
  endif.
  clear : it_tas1,wa_tas1.
  loop at it_mchb into wa_mchb.

    clear : w_totqty.
    w_totqty = wa_mchb-clabs + wa_mchb-cinsm + wa_mchb-cspem .
*    w_totqty1 = wa_mchb-clabs.
    if w_totqty gt 0.
      read table it_mara into wa_mara with key matnr = wa_mchb-matnr.
      if sy-subrc eq 0.
        wa_tas1-matnr = wa_mchb-matnr.
        wa_tas1-mtart = wa_mara-mtart.
        wa_tas1-matkl = wa_mara-matkl.
        select single * from t023t where spras eq 'EN' and matkl eq wa_mara-matkl.
        if sy-subrc eq 0.
          wa_tas1-wgbez = t023t-wgbez.
        endif.
        wa_tas1-werks = wa_mchb-werks.
        wa_tas1-lgort = wa_mchb-lgort.
        wa_tas1-charg = wa_mchb-charg.
        wa_tas1-clabs = wa_mchb-clabs.
        wa_tas1-cinsm = wa_mchb-cinsm.
        wa_tas1-cspem = wa_mchb-cspem.
        select single  * from mch1 where matnr = wa_mchb-matnr and charg = wa_mchb-charg.
        if sy-subrc eq 0.
          wa_tas1-vfdat = mch1-vfdat.
          wa_tas1-hsdat = mch1-hsdat.
        endif.
        clear : maktx,maktx1,maktx2,normt.
        select single * from makt where matnr = wa_mchb-matnr and spras eq 'EN'.
        if sy-subrc eq 0.
          maktx1 = makt-maktx.
        endif.
        select single * from makt where matnr = wa_mchb-matnr and spras eq 'Z1'.
        if sy-subrc eq 0.
          maktx2 =  makt-maktx.
        endif.
*        select single * from mara where matnr = wa_mchb-matnr.
*        if sy-subrc eq 0.
        normt =  wa_mara-normt.
*        endif.
        concatenate maktx1 maktx2 normt into maktx.
        wa_tas1-maktx = maktx.

*      perform itab-upd.

        clear : rate.
        select single * from mbew where matnr eq wa_mchb-matnr and bwkey eq wa_mchb-werks.
        if sy-subrc eq 0.
          rate = mbew-verpr / mbew-peinh.
          wa_tas1-verpr = mbew-verpr.
          wa_tas1-peinh = mbew-peinh.
        endif.
        val = rate * w_totqty.
        wa_tas1-val = val.
        wa_tas1-totqty = w_totqty.
*********************
        collect wa_tas1 into it_tas1.
        clear wa_tas1.
      endif.
    endif.
  endloop.
*  BREAK-POINT.
  if it_tas1 is not initial.
    select * from mseg into table it_mseg for all entries in it_tas1 where bwart eq '101' and matnr eq it_tas1-matnr and charg eq it_tas1-charg
      and werks eq it_tas1-werks.
  endif.
  sort it_mseg descending by mblnr.

  if it_tas1 is not initial.
    select * from qals into table it_qals for all entries in it_tas1 where art eq '01' and werk eq it_tas1-werks and charg eq it_tas1-charg.
  endif.
  sort it_qals by prueflos.

  loop at it_qals into wa_qals.
    select single * from jest where objnr eq wa_qals-objnr and stat eq 'I0224'.
    if sy-subrc eq 0.
      delete it_qals where prueflos = wa_qals-prueflos.
    endif.
  endloop.

****************************

  if it_tas1 is not initial.
    select * from qals into table it_qals1 for all entries in it_tas1 where art eq '08' and werk eq it_tas1-werks and charg eq it_tas1-charg.
  endif.
  sort it_qals1 by prueflos.

  loop at it_qals1 into wa_qals1.
    select single * from jest where objnr eq wa_qals1-objnr and stat eq 'I0224'.
    if sy-subrc eq 0.
      delete it_qals1 where prueflos = wa_qals1-prueflos.
    endif.
  endloop.

  perform penpo.
  sort it_tas1 by matnr.
  loop at it_tas1 into wa_tas1.
    wa_tas2-werks = wa_tas1-werks.
    wa_tas2-matnr = wa_tas1-matnr.
    SHIFT wa_tas2-matnr LEFT DELETING LEADING '0'.
    wa_tas2-mtart = wa_tas1-mtart.
    wa_tas2-matkl = wa_tas1-matkl.
    wa_tas2-wgbez = wa_tas1-wgbez.
    wa_tas2-maktx = wa_tas1-maktx.
    wa_tas2-lgort = wa_tas1-lgort.
    wa_tas2-charg = wa_tas1-charg.
    wa_tas2-vfdat = wa_tas1-vfdat.
    wa_tas2-hsdat = wa_tas1-hsdat.
    wa_tas2-clabs = wa_tas1-clabs.
    wa_tas2-cinsm = wa_tas1-cinsm.
    wa_tas2-cspem = wa_tas1-cspem.
    wa_tas2-verpr = wa_tas1-verpr.
    wa_tas2-peinh = wa_tas1-peinh.
    wa_tas2-val = wa_tas1-val.
    wa_tas2-totqty = wa_tas1-totqty.
    read table it_mseg into wa_mseg with key matnr = wa_tas1-matnr charg = wa_tas1-charg werks = wa_tas1-werks.
    if sy-subrc eq 0.
      wa_tas2-mblnr = wa_mseg-mblnr.
      select single * from mkpf where mblnr eq wa_mseg-mblnr and mjahr eq wa_mseg-mjahr.
      if sy-subrc eq 0.
        wa_tas2-budat = mkpf-budat.
      endif.
      wa_tas2-lifnr = wa_mseg-lifnr.
*      SHIFT wa_tas2-lifnr LEFT DELETING LEADING '0'.
      wa_tas2-ebeln = wa_mseg-ebeln.
    endif.
    if wa_tas2-mblnr eq space.
      read table it_qals into wa_qals with key charg = wa_tas1-charg werk = wa_tas1-werks.
      if sy-subrc eq 0.
        wa_tas2-mblnr = wa_qals-mblnr.
        select single * from mkpf where mblnr eq wa_qals-mblnr.
        if sy-subrc eq 0.
          wa_tas2-budat = mkpf-budat.
        endif.
        wa_tas2-lifnr = wa_qals-lifnr.
*        SHIFT wa_tas2-lifnr LEFT DELETING LEADING '0'.
        wa_tas2-ebeln = wa_qals-ebeln.


      endif.
    endif.
    if wa_tas2-mblnr eq space.
      read table it_qals1 into wa_qals1 with key charg = wa_tas1-charg werk = wa_tas1-werks.
      if sy-subrc eq 0.
        wa_tas2-mblnr = wa_qals1-mblnr.
        select single * from mkpf where mblnr eq wa_qals1-mblnr.
        if sy-subrc eq 0.
          wa_tas2-budat = mkpf-budat.
        endif.
        wa_tas2-lifnr = wa_qals1-lifnr.
        SHIFT wa_tas2-lifnr LEFT DELETING LEADING '0'.
        wa_tas2-ebeln = wa_qals1-ebeln.
      endif.
    endif.
    select single * from lfa1 where lifnr eq wa_tas2-lifnr.
    if sy-subrc eq 0.
      wa_tas2-name1 = lfa1-name1.
    endif.
    if wa_tas2-lifnr eq space.
      select single * from ekko where ebeln eq wa_tas2-ebeln.
      if sy-subrc eq 0.
        wa_tas2-lifnr = ekko-reswk.
*        SHIFT wa_tas2-lifnr LEFT DELETING LEADING '0'.
        select single * from t001w where werks eq ekko-reswk.
        if sy-subrc eq 0.
          wa_tas2-name1 = t001w-name1.
        endif.
      endif.
    endif.

    on change of wa_tas1-matnr.
      read table it_po1 into wa_po1 with key matnr = wa_tas1-matnr.
      if sy-subrc eq 0.
        wa_tas2-popenqty = wa_po1-menge.
      endif.
    endon.

    collect wa_tas2 into it_tas2.
    clear wa_tas2.
  endloop.



  perform alv.
  exit.



endform.
*&---------------------------------------------------------------------*
*&      Form  MAT_CONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form mat_cons .
  year = budat-low+0(4).
  year2  = budat-high+0(4).

  if year2 is not initial.
    if year ne year2.
      message 'ENTER DATE IN SAME YEAR' type 'E'.
    endif.
  endif.
*  fp_outputparams-dest = 'PDFP'.
  fp_outputparams-dest = 'LP01'.
  fp_outputparams-device = 'PRINTER'.
  fp_outputparams-nodialog = 'X'.
  fp_outputparams-connection = 'ADS'.
  fp_outputparams-preview = 'X'.
  fp_outputparams-adstrlevel = '00'.

  fp_docparams-langu   = 'E'.
  fp_docparams-country = 'IN'.

* Sets the output parameters and opens the spool job

*fp_outputparams-dest = 'PDFPRINTER'.
*fp_outputparams-device = 'PDFPRINTER'.
*fp_outputparams-device = 'RQPOSNAME'.
*fp_outputparams-nodialog = 'X'.
*
*fp_outputparams-preview = 'X'.

  call function 'FP_JOB_OPEN'                   "& Form Processing: Call Form
    changing
      ie_outputparams = fp_outputparams
    exceptions
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      others          = 5.
  if sy-subrc <> 0.
*            <error handling>
  endif.
*&---- Get the name of the generated function module
  call function 'FP_FUNCTION_MODULE_NAME'           "& Form Processing Generation
    exporting
      i_name     = 'ZSTK1'
    importing
      e_funcname = fm_name.
  if sy-subrc <> 0.
*  <error handling>
  endif.
*-- Fetch the Data and store it in the Internal tamle
*  select * from mkpf into table it_mkpf where mjahr eq year and budat in budat.
*  if sy-subrc eq 0.
*    select * from mseg into table it_mseg for all entries in it_mkpf where mblnr eq it_mkpf-mblnr and mjahr eq it_mkpf-mjahr and
*      bwart in mov AND matnr in matnr and werks eq werks .
*  endif.


  select * from mseg into table it_mseg where mjahr eq year and werks eq werks and budat_mkpf in  budat and matnr in mcode
    and lgort in str and bwart in mov
    %_hints oracle 'INDEX("MSEG" "MSEG~M1")'.


  if it_mseg is not initial.
    loop at it_mseg into wa_mseg.

      if wa_mseg-shkzg eq 'S'.
        wa_mseg-menge = wa_mseg-menge * ( - 1 ).
      endif.
*    wa_tam1-werks = wa_mseg-werks.
      clear : maktx1,maktx2,normt , maktx.
      select single * from makt where matnr eq wa_mseg-matnr and spras eq 'EN'.
      if sy-subrc eq 0.
        maktx1 = makt-maktx.
      endif.
      select single * from makt where matnr eq wa_mseg-matnr and spras eq 'Z1'.
      if sy-subrc eq 0.
        maktx2 = makt-maktx.
      endif.
      select single * from mara where matnr eq wa_mseg-matnr.
      if sy-subrc eq 0.
        normt = mara-normt.
      endif.
      concatenate maktx1 maktx2 normt into maktx.
      wa_tam1-maktx = maktx.
      wa_tam1-matnr = wa_mseg-matnr.
      wa_tam1-werks = wa_mseg-werks.
      wa_tam1-menge = wa_mseg-menge.
      wa_tam1-meins = wa_mseg-meins.
      collect wa_tam1 into it_tam1.
      clear wa_tam1.
    endloop.
  endif.

  loop at it_tam1 into wa_tam1.
    wa_tam2-matnr = wa_tam1-matnr.
    wa_tam2-maktx = wa_tam1-maktx.
    clear : qty.
    qty = wa_tam1-menge.
    wa_tam2-menge = qty.
    wa_tam2-meins = wa_tam1-meins.
    collect wa_tam2 into it_tam2.
    clear wa_tam2.
  endloop.
  select single * from t001w where werks eq werks.
  if sy-subrc eq 0.
    kunnr = t001w-kunnr.
  endif.

  sort it_tam2 by maktx.
* Language and country setting (here US as an example)
*fp_docparams-langu   = 'E'.
*fp_docparams-country = 'IN'.
*CALL FUNCTION 'ZPDF_SET_OUTPUT_MODE'
*
*CHANGING
*
*FP_OUTPUTPARAMS = fp_outputparams.
*
*fp_outputparams-dest = 'ZPDF'.

*
*fp_outputparams-nodialog = 'X'.
*
*fp_outputparams-preview = 'X'.
*&--- Call the generated function module



  call function fm_name
    exporting
      /1bcdwb/docparams = fp_docparams
      it_tab1           = it_tam2
      kunnr             = kunnr
      budat1            = budat-low
      budat2            = budat-high
      mov1              = mov-low
      mov2              = mov-high
      udate             = sy-datum
      utime             = sy-uzeit
*    IMPORTING
*     /1BCDWB/FORMOUTPUT       =
    exceptions
      usage_error       = 1
      system_error      = 2
      internal_error    = 3.
  if sy-subrc <> 0.
*  <error handling>
  endif.
*&---- Close the spool job
  call function 'FP_JOB_CLOSE'
*    IMPORTING
*     E_RESULT             =
    exceptions
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      others         = 4.
  if sy-subrc <> 0.
*            <error handling>
  endif.
endform.
