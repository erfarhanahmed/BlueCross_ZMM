
*&---------------------------------------------------------------------*
*& Report  ZEXPIRY_TRANSFER
*& This report transfers expired goods to rejection
*& T-code - ZEXPTRF
*&---------------------------------------------------------------------*
*&FG expired in blocked in storage loc - -REJ1  "1.11.2019
*&RM expired in blocked in storage loc - -REJ2  "1.11.2019
*PM expired in blocked in storage loc - -REJ3  "1.11.2019
*&---------------------------------------------------------------------*
*&Modification History
*&---------------------------
*&Changed by/date       : 26/11/2024 / Shraddha Pradhan
*&DESCRIPTION           : Added option R3 - Auto block products which are expiring within 6 months from current date.
*&                        Used mvt.type 344, in background for continueos checking/blocking.
*&Request No.          : BCDK936068,BCDK936078
*&-------------------------------------------------------------------------------------------------*
report zqctransfer9.

tables : mchb,
         makt,
         mcha,
         mara.
*INCLUDE bdcrecx1.
*DATA :bdcdata LIKE bdcdata    OCCURS 0 WITH HEADER LINE.
*PARAMETERS : filename LIKE rlgrap-filename.
type-pools:  slis.
data : bdcdata like bdcdata    occurs 0 with header line.
data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

data : it_mchb type table of mchb,
       wa_mchb type mchb,
       it_mara type table of mara,
       wa_mara type mara,
       it_afpo type table of afpo,
       wa_afpo type afpo,
       it_afru type table of afru,
       wa_afru type afru.

types : begin of itab1,
          werks type mchb-werks,
          matnr type mchb-matnr,
          charg type mchb-charg,
          lgort type mchb-lgort,
          cspem type mchb-cspem,
          maktx type makt-maktx,
          chk   type  char5,
          elikz type afpo-elikz,
          aufnr type afpo-aufnr,
          aueru type afru-aueru,
          hsdat type mcha-hsdat,
          vfdat type mcha-vfdat,
        end of itab1.

types : begin of itab3,
          werks           type mchb-werks,
          matnr           type mchb-matnr,
          charg           type mchb-charg,
          lgort           type mchb-lgort,
          cspem(017),
          sdate(10),

          xfull_006(001),
* data element: WVERS3
          wvers3_007(001),
* data element: UMLGO
          umlgo_008(004),
* data element: MATNR
*        MATNR_01_009(018),
* data element: ERFMG
*        ERFMG_01_010(017),
* data element: CHARG_D
*        CHARG_01_011(010),
* data element: FMORE
*          fmore_012(001),
* data element: FMORE
*          fmore_013(001),
* data element: FMORE
*          fmore_014(001),

          rej             type mchb-lgort,
        end of itab3.


types : begin of ty_fdata,
          werks type werks_d,
          matnr type matnr,
          charg type charg_d,
          lgort type lgort_d,
          clabs type labst,     "Valuated Unrestricted-Use Stock
          cspem type speme,     "blocked stock
          maktx type maktx,
          vfdat type vfdat,     "expiry date
          meins type meins,
        end of ty_fdata.

data : gt_mchb  type table of mchb,
       gw_mchb  type mchb,
       gt_mcha  type table of mcha,
       gw_mcha  type mcha,
       gt_mara  type table of mara,
       gw_mara  type mara,
       gt_fdata type table of ty_fdata,
       gw_fdata type ty_fdata.

data : gv_exp_dt type sy-datum.

data : it_mess type table of bdcmsgcoll.

data : it_tab1 type table of itab1,
       wa_tab1 type itab1,
       it_tab2 type table of itab1,
       wa_tab2 type itab1,
       it_tab3 type table of itab3,
       wa_tab3 type itab3.

data : qty    type p,
       a1(2)  type c,
       a2(2)  type c,
       a3(4)  type c,
       a4(10) type c,
       a      type i.

data: begin of record occurs 0,
* data element: BLDAT
        bldat_001(010),
* data element: BUDAT
        budat_002(010),
* data element: BWARTWA
        bwartwa_003(003),
* data element: WERKS_D
        werks_004(004),
* data element: LGORT_D
        lgort_005(004),
* data element:
        xfull_006(001),
* data element: WVERS3
        wvers3_007(001),
* data element: MATNR
        matnr_01_008(018),
* data element: ERFMG
        erfmg_01_009(017),
* data element: CHARG_D
        charg_01_010(010),
* data element: FMORE
*        FMORE_011(001),
** data element: FMORE
*        FMORE_012(001),
** data element: FMORE
*        FMORE_013(001),
      end of record.
selection-screen begin of block b1 with frame title text-001.
selection-screen begin of block b2 ."with frame title text-001.
*PARAMETERS : P1 RADIOBUTTON GROUP R1,
*             P2 RADIOBUTTON GROUP R1.
parameters : r1 radiobutton group r1 user-command rb,
             r2 radiobutton group r1.
select-options : plant for mchb-werks. "obligatory.
select-options : loc for mchb-lgort. "obligatory.
select-options : material for mchb-matnr.

selection-screen uline.
selection-screen skip.
parameters :  r3 radiobutton group r1.      "for auto block near expiry
selection-screen begin of block b3 with frame title text-002.
select-options : s_mtart for mara-mtart no intervals ,"obligatory,
                 s_werks for mchb-werks." obligatory.
selection-screen end of block b3.
selection-screen end of block b2.
selection-screen end of block b1.


initialization.
  g_repid = sy-repid.

at selection-screen output.
*******  "for auto BLOCK near expiry
  if r3 = abap_true.

    s_mtart-low = 'ZFRT'.
    s_mtart-sign = 'I'.
    s_mtart-option = 'EQ'.
    append s_mtart.

    s_mtart-low = 'ZHWA'.
    s_mtart-sign = 'I'.
    s_mtart-option = 'EQ'.
    append s_mtart.

  endif.
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR filename.
*
*  PERFORM export_file.



start-of-selection.

*  PERFORM upload_file.
*
*  PERFORM open_group.
*  IF P1 EQ 'X'.
*    PERFORM QUALITY.
*  ELSEIF P2 EQ 'X'.
  if r1 eq 'X'.
    perform auto.
  elseif r2 eq 'X'.
    if plant[] is not initial .
      if loc[] is not initial.
        perform manual.
      else.
        message 'Please Select Plant' type 'E'.
      endif.
    else.
      message 'Please Select Plant' type 'E'.
    endif.
  else.
    if s_mtart[] is not initial and s_werks[] is not initial.
      perform do_auto_block_near_expiry.
    endif.
  endif.

*  ENDIF.

form manual.

  select * from mchb into table it_mchb where werks in plant and lgort in loc and matnr in material and lgort ne 'CSM' and clabs gt 0.

  loop at it_mchb into wa_mchb.
    select single * from mcha where matnr eq wa_mchb-matnr and werks eq wa_mchb-werks and charg eq wa_mchb-charg and vfdat le sy-datum.
    if sy-subrc eq 0.
      if mcha-vfdat ne '00000000'.
        wa_tab1-werks = wa_mchb-werks.
        wa_tab1-matnr = wa_mchb-matnr.
        wa_tab1-charg = wa_mchb-charg.
        wa_tab1-lgort = wa_mchb-lgort.
        wa_tab1-cspem = wa_mchb-clabs.
        wa_tab1-hsdat = mcha-hsdat.
        wa_tab1-vfdat = mcha-vfdat.
*       + WA_MCHB-CINSM.
        collect wa_tab1 into it_tab1.
        clear wa_tab1.
      endif.
    endif.
  endloop.

  delete it_tab1 where cspem eq 0.

  loop at it_tab1 into wa_tab1.
    wa_tab2-werks = wa_tab1-werks.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-lgort = wa_tab1-lgort.
    wa_tab2-cspem = wa_tab1-cspem.
    wa_tab2-hsdat = wa_tab1-hsdat.
    wa_tab2-vfdat = wa_tab1-vfdat.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.

  sort it_tab2 by charg.

*  LOOP AT it_tab2 INTO wa_tab2.
*    WRITE : / '**', wa_tab2-matnr,wa_tab2-charg,wa_tab2-lgort,wa_tab2-cspem.
*  ENDLOOP.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'FROM_PLANT'.
  append wa_fieldcat to fieldcat.


  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PRODCU CODE'.
  append wa_fieldcat to fieldcat.


  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LGORT'.
  wa_fieldcat-seltext_l = 'STORAGE LOC'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CSPEM'.
  wa_fieldcat-seltext_l = 'BLOCKED QTY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'HSDAT'.
  wa_fieldcat-seltext_l = 'MFG. DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VFDAT'.
  wa_fieldcat-seltext_l = 'EXPIRY DATE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHK'.
  wa_fieldcat-seltext_l = 'SELECT'.
  wa_fieldcat-checkbox = 'X'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'TRANSFER BLOCKED STOCK TO QUALITY ON BATCH CONFIRMATION'.


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
endform.
form top.
  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'TICK THE CHECKBOX & SAVE'.
*  WA_COMMENT-INFO = P_FRMDT.
  append wa_comment to comment.

  call function 'REUSE_ALV_COMMENTARY_WRITE'
    exporting
      it_list_commentary = comment.
*     I_LOGO                   = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID       =
*     I_ALV_FORM               =
  clear comment.
endform.                    "TOP

form user_comm using ucomm like sy-ucomm selfield type slis_selfield.
*  IF R1 EQ 'X'.
  case sy-ucomm. "SELFIELD-FIELDNAME.
*      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
*        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
*      ENDLOOP.
*      BREAK-POINT.
    when '&DATA_SAVE'(001).
*      message 'TERRITORY SAVED 1' type 'I'.
*      PERFORM BDC.
      perform update_bdc.
    when others.
  endcase.
  exit.
endform.                    "USER_COMM

form user_comm1 using ucomm like sy-ucomm selfield type slis_selfield.
*  IF R1 EQ 'X'.
  case sy-ucomm. "SELFIELD-FIELDNAME.
*      loop at it_tab5 into wa_tab5 WHERE nsampqty ne 0 AND chk ne 'X'.
*        MESSAGE 'TICK THE CHECKBOX TO SAVE DATA' TYPE 'E'.
*      ENDLOOP.
*      BREAK-POINT.
    when '&DATA_SAVE'(001).
*      message 'TERRITORY SAVED 1' type 'I'.
*      PERFORM BDC.
      perform update_bdc1.
    when others.
  endcase.
  exit.
endform.                    "USER_COMM

form bdc_dynpro using program dynpro.
  clear bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  append bdcdata.
endform.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
form bdc_field using fnam fval.
*  IF FVAL <> NODATA.
  clear bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  append bdcdata.
*  ENDIF.
endform.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form update_bdc.

  loop at it_tab2 into wa_tab2 where chk eq 'X'.
    clear : qty, a1,a2,a3,a4.
    wa_tab3-werks = wa_tab2-werks.
    wa_tab3-matnr = wa_tab2-matnr.
    wa_tab3-charg = wa_tab2-charg.
    wa_tab3-lgort = wa_tab2-lgort.
*    QTY = WA_TAB2-CSPEM.
    wa_tab3-cspem = wa_tab2-cspem.

    a1 = sy-datum+6(2).
    a2 = sy-datum+4(2).
    a3 = sy-datum+0(4).
    concatenate a1 a2 a3 into a4 separated by '.'.
    wa_tab3-sdate = a4.
    select single * from mara where matnr eq wa_tab2-matnr.
*    if sy-subrc eq 0.
*      if mara-mtart eq 'ZFRT' or mara-mtart eq 'ZHWA' or mara-mtart eq 'ZHLB' or mara-mtart eq 'ZDSM' or mara-mtart eq 'ZESC'
*        or mara-mtart eq 'ZESM'.
*        wa_tab3-rej = 'REJ1'.
*      elseif mara-mtart eq 'ZROH'.
*        wa_tab3-rej = 'REJ2'.
*      else.
*        wa_tab3-rej = 'REJ3'.
*      endif.
*    endif.
    collect wa_tab3 into it_tab3.
    clear wa_tab3.
  endloop.

*  EXIT.

*  PERFORM open_dataset USING dataset.
*  PERFORM open_group.
*  break-point.
*  LOOP AT record.
  loop at it_tab3 into wa_tab3.

*read dataset dataset into record.
*if sy-subrc <> 0. exit. endif.

    perform bdc_dynpro      using 'SAPMM07M' '0400'.
    perform bdc_field       using 'BDC_CURSOR'
*                                  'RM07M-WERKS'.
                                  'RM07M-LGORT'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '/00'.
    perform bdc_field       using 'MKPF-BLDAT'
*                              record-BLDAT_001.
*                                   '02.04.2018'.
                                    wa_tab3-sdate.
    perform bdc_field       using 'MKPF-BUDAT'
*                              record-BUDAT_002.
*                                   '02.04.2018'.
                                   wa_tab3-sdate.
    perform bdc_field       using 'RM07M-BWARTWA'
*                              record-BWARTWA_003.
                                   '344'.
    perform bdc_field       using 'RM07M-WERKS'
*                                  record-werks_004.
*                                  '1000'.
                                   wa_tab3-werks.
    perform bdc_field       using 'RM07M-LGORT'
*                                  record-lgort_005.
*                                  'FG01'.
                                   wa_tab3-lgort.
*'REJ'.
*   wa_tab3-rej.
    perform bdc_field       using 'XFULL'
*                                  record-xfull_006.
                                   'X'.
    perform bdc_field       using 'RM07M-WVERS3'
*                                  record-wvers3_007.
                                   'X'.
    perform bdc_dynpro      using 'SAPMM07M' '0421'.
    perform bdc_field       using 'BDC_CURSOR'
                                  'MSEG-CHARG(01)'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '/00'.

    perform bdc_field       using 'MSEGK-UMLGO'
                                wa_tab3-lgort.

    perform bdc_field       using 'MSEG-MATNR(01)'
*                                  record-matnr_01_008.
*                                  '41074'.
                                   wa_tab3-matnr.
    perform bdc_field       using 'MSEG-ERFMG(01)'
*                                  record-erfmg_01_009.
*                                   '10'.
                                    wa_tab3-cspem.
    perform bdc_field       using 'MSEG-CHARG(01)'
*                                  record-charg_01_010.
*                                   'LST1804'.
                                    wa_tab3-charg.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_011.
    perform bdc_dynpro      using 'SAPLKACB' '0002'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTE'.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_012.
    perform bdc_dynpro      using 'SAPLKACB' '0002'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTE'.
    perform bdc_dynpro      using 'SAPMM07M' '0421'.
    perform bdc_field       using 'BDC_CURSOR'
                                  'MSEG-ERFMG(01)'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=BU'.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_013.
    perform bdc_dynpro      using 'SAPLKACB' '0002'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTE'.
*    PERFORM bdc_transaction USING 'MB1B'.
    call transaction 'MB1B' using bdcdata  mode 'N' messages into it_mess.
    if sy-subrc eq 0.
      a = 1.
    endif.
    commit work and wait.
    refresh bdcdata.
    clear bdcdata.
*    ENDIF.
  endloop.
*ENDFORM.

  if a eq '1'.
    message 'DATA HAS BEEN MOVED TO BLOCKED - REJECTION' type 'I'.
  endif.
  set screen 0.

*  EXIT.

*  PERFORM close_group.

endform.
*FORM upload_file.
*
*
*  CALL FUNCTION 'WS_UPLOAD'
*    EXPORTING
**     CODEPAGE = ' '
*      filename = filename
*      filetype = 'DAT'
**     HEADLEN  = ' '
**     LINE_EXIT               = ' '
**     TRUNCLEN = ' '
**     USER_FORM               = ' '
**     USER_PROG               = ' '
**     DAT_D_FORMAT            = ' '
**    IMPORTING
**     FILELENGTH              =
*    TABLES
*      data_tab = record
**    EXCEPTIONS
**     CONVERSION_ERROR        = 1
**     FILE_OPEN_ERROR         = 2
**     FILE_READ_ERROR         = 3
**     INVALID_TYPE            = 4
**     NO_BATCH = 5
**     UNKNOWN_ERROR           = 6
**     INVALID_TABLE_WIDTH     = 7
**     GUI_REFUSE_FILETRANSFER = 8
**     CUSTOMER_ERROR          = 9
**     OTHERS   = 10
*    .
*  IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*ENDFORM.                    " UPLOAD_FILE
**---------------------------------------------------------------------*
**       FORM EXPORT_FILE                                              *
**---------------------------------------------------------------------*
**       ........                                                      *
**---------------------------------------------------------------------*
*FORM export_file.
*  CALL FUNCTION 'WS_FILENAME_GET'
*    EXPORTING
*      def_filename     = ' '
*      def_path         = filename
*      mask             = ',*.*,*.*.'
*      mode             = 'O'
*      title            = 'Choose from file'
*    IMPORTING
*      filename         = filename
**     RC               =
*    EXCEPTIONS
*      inv_winsys       = 1
*      no_batch         = 2
*      selection_cancel = 3
*      selection_error  = 4
*      OTHERS           = 5.
*  IF sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  ENDIF.
*
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM AUTO .
*  SELECT * FROM MCHB INTO TABLE IT_MCHB WHERE WERKS EQ PLANT AND LGORT IN LOC AND CHARG IN BATCH AND CSPEM NE 0 AND LGORT NE 'CSM'.
*  IF SY-SUBRC EQ 0.
*    SELECT * FROM MARA INTO TABLE IT_MARA FOR ALL ENTRIES IN IT_MCHB WHERE MATNR EQ IT_MCHB-MATNR AND MTART IN ( 'ZFRT','ZESC','ZDSM','ZESM' ).
*    IF SY-SUBRC NE 0.
*      MESSAGE 'NO DATA FOUND' TYPE 'E'.
*    ENDIF.
*  ENDIF.
*
*  LOOP AT IT_MCHB INTO WA_MCHB.
*    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MCHB-MATNR.
*    IF SY-SUBRC EQ 0.
*      WA_TAB1-WERKS = WA_MCHB-WERKS.
*      WA_TAB1-MATNR = WA_MCHB-MATNR.
*      WA_TAB1-CHARG = WA_MCHB-CHARG.
*      WA_TAB1-LGORT = WA_MCHB-LGORT.
*      WA_TAB1-CSPEM = WA_MCHB-CSPEM.
*      COLLECT WA_TAB1 INTO IT_TAB1.
*      CLEAR WA_TAB1.
*    ENDIF.
*  ENDLOOP.
*
*  IF IT_TAB1 IS NOT INITIAL.
*    SELECT * FROM AFPO INTO TABLE IT_AFPO FOR ALL ENTRIES IN IT_TAB1 WHERE MATNR EQ IT_TAB1-MATNR AND PWERK EQ PLANT
*      AND CHARG EQ IT_TAB1-CHARG .
*  ENDIF.
*  IF IT_AFPO IS NOT INITIAL.
*    SELECT * FROM AFRU INTO TABLE IT_AFRU FOR ALL ENTRIES IN IT_AFPO WHERE AUFNR EQ IT_AFPO-AUFNR AND AUERU EQ 'X'.
*  ENDIF.
*  SORT IT_AFRU DESCENDING BY RMZHL.
*
*  LOOP AT IT_TAB1 INTO WA_TAB1.
**    WRITE : / wa_tab1-matnr,wa_tab1-charg,wa_tab1-lgort,wa_tab1-cspem.
*    LOOP AT IT_AFPO INTO WA_AFPO WHERE MATNR EQ WA_TAB1-MATNR AND CHARG EQ WA_TAB1-CHARG.
**      WRITE : / 'order', wa_afpo-aufnr,wa_afpo-matnr,wa_afpo-charg,wa_afpo-psmng.
*      READ TABLE IT_AFRU INTO WA_AFRU WITH KEY AUFNR = WA_AFPO-AUFNR .
**      aueru = 'X'.
*      IF SY-SUBRC EQ 0.
**        WRITE : 'CONFIRMED'.
*        WA_TAB2-WERKS = WA_TAB1-WERKS.
*        WA_TAB2-MATNR = WA_TAB1-MATNR.
*        WA_TAB2-CHARG = WA_TAB1-CHARG.
*        WA_TAB2-LGORT = WA_TAB1-LGORT.
*        WA_TAB2-CSPEM = WA_TAB1-CSPEM.
*        WA_TAB2-ELIKZ = WA_AFPO-ELIKZ.
*        WA_TAB2-AUFNR = WA_AFPO-AUFNR.
*        WA_TAB2-AUERU = WA_AFRU-AUERU.
*        SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_TAB1-MATNR AND SPRAS EQ 'EN'.
*        IF SY-SUBRC EQ 0.
*          WA_TAB2-MAKTX = MAKT-MAKTX.
*        ENDIF.
**        IF s1 EQ 'X'.
**          wa_tab2-chk = 'X'.
**        ENDIF.
*        COLLECT WA_TAB2 INTO IT_TAB2.
*        CLEAR WA_TAB2.
*      ENDIF.
*    ENDLOOP.
*  ENDLOOP.
*
*  SORT IT_TAB2 BY CHARG.
*
*************************************
**   MESSAGE 'DATA UPDFATED' TYPE 'I'.
*
*
*  LOOP AT IT_TAB2 INTO WA_TAB2 .
*    CLEAR : QTY, A1,A2,A3,A4.
*    WA_TAB3-WERKS = WA_TAB2-WERKS.
*    WA_TAB3-MATNR = WA_TAB2-MATNR.
*    WA_TAB3-CHARG = WA_TAB2-CHARG.
*    WA_TAB3-LGORT = WA_TAB2-LGORT.
*    QTY = WA_TAB2-CSPEM.
*    WA_TAB3-CSPEM = QTY.
*    A1 = SY-DATUM+6(2).
*    A2 = SY-DATUM+4(2).
*    A3 = SY-DATUM+0(4).
*    CONCATENATE A1 A2 A3 INTO A4 SEPARATED BY '.'.
*    WA_TAB3-SDATE = A4.
*    COLLECT WA_TAB3 INTO IT_TAB3.
*    CLEAR WA_TAB3.
*  ENDLOOP.
*
**  EXIT.
*
**  PERFORM open_dataset USING dataset.
**  PERFORM open_group.
*
**  LOOP AT record.
*  LOOP AT IT_TAB3 INTO WA_TAB3.
*
**read dataset dataset into record.
**if sy-subrc <> 0. exit. endif.
*
*    PERFORM BDC_DYNPRO      USING 'SAPMM07M' '0400'.
*    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                  'RM07M-WERKS'.
*    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                  '/00'.
*    PERFORM BDC_FIELD       USING 'MKPF-BLDAT'
**                              record-BLDAT_001.
**                                   '02.04.2018'.
*                                    WA_TAB3-SDATE.
*    PERFORM BDC_FIELD       USING 'MKPF-BUDAT'
**                              record-BUDAT_002.
**                                   '02.04.2018'.
*                                   WA_TAB3-SDATE.
*    PERFORM BDC_FIELD       USING 'RM07M-BWARTWA'
**                              record-BWARTWA_003.
*                                   '349'.
*    PERFORM BDC_FIELD       USING 'RM07M-WERKS'
**                                  record-werks_004.
**                                  '1000'.
*                                   WA_TAB3-WERKS.
*    PERFORM BDC_FIELD       USING 'RM07M-LGORT'
**                                  record-lgort_005.
**                                  'FG01'.
*                                   WA_TAB3-LGORT.
*    PERFORM BDC_FIELD       USING 'XFULL'
**                                  record-xfull_006.
*                                   'X'.
*    PERFORM BDC_FIELD       USING 'RM07M-WVERS3'
**                                  record-wvers3_007.
*                                   'X'.
*    PERFORM BDC_DYNPRO      USING 'SAPMM07M' '0421'.
*    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                  'MSEG-CHARG(01)'.
*    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                  '/00'.
*    PERFORM BDC_FIELD       USING 'MSEG-MATNR(01)'
**                                  record-matnr_01_008.
**                                  '41074'.
*                                   WA_TAB3-MATNR.
*    PERFORM BDC_FIELD       USING 'MSEG-ERFMG(01)'
**                                  record-erfmg_01_009.
**                                   '10'.
*                                    WA_TAB3-CSPEM.
*    PERFORM BDC_FIELD       USING 'MSEG-CHARG(01)'
**                                  record-charg_01_010.
**                                   'LST1804'.
*                                    WA_TAB3-CHARG.
**perform bdc_field       using 'DKACB-FMORE'
**                              record-FMORE_011.
*    PERFORM BDC_DYNPRO      USING 'SAPLKACB' '0002'.
*    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                  '=ENTE'.
**perform bdc_field       using 'DKACB-FMORE'
**                              record-FMORE_012.
*    PERFORM BDC_DYNPRO      USING 'SAPLKACB' '0002'.
*    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                  '=ENTE'.
*    PERFORM BDC_DYNPRO      USING 'SAPMM07M' '0421'.
*    PERFORM BDC_FIELD       USING 'BDC_CURSOR'
*                                  'MSEG-ERFMG(01)'.
*    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                  '=BU'.
**perform bdc_field       using 'DKACB-FMORE'
**                              record-FMORE_013.
*    PERFORM BDC_DYNPRO      USING 'SAPLKACB' '0002'.
*    PERFORM BDC_FIELD       USING 'BDC_OKCODE'
*                                  '=ENTE'.
**    PERFORM bdc_transaction USING 'MB1B'.
*    CALL TRANSACTION 'MB1B' USING BDCDATA MODE 'N' .
*  ENDLOOP.
**ENDFORM.
*
**  MESSAGE 'DATA HAS BEEN MOVED TO QUALITY' TYPE 'I'.
*  SET SCREEN 0.
*  EXIT.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  AUTO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form quality.

  select * from mchb into table it_mchb where werks eq plant and lgort in loc and matnr in material and lgort ne 'CSM' and cinsm gt 0.

  loop at it_mchb into wa_mchb.
    select single * from mcha where matnr eq wa_mchb-matnr and werks eq wa_mchb-werks and charg eq wa_mchb-charg and vfdat le sy-datum.
    if sy-subrc eq 0.
      wa_tab1-werks = wa_mchb-werks.
      wa_tab1-matnr = wa_mchb-matnr.
      wa_tab1-charg = wa_mchb-charg.
      wa_tab1-lgort = wa_mchb-lgort.
      wa_tab1-cspem = wa_mchb-cinsm.
      collect wa_tab1 into it_tab1.
      clear wa_tab1.
    endif.
  endloop.

  delete it_tab1 where cspem eq 0.

  loop at it_tab1 into wa_tab1.
    wa_tab2-werks = wa_tab1-werks.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-lgort = wa_tab1-lgort.
    wa_tab2-cspem = wa_tab1-cspem.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.

  sort it_tab2 by charg.

*  LOOP AT it_tab2 INTO wa_tab2.
*    WRITE : / '**', wa_tab2-matnr,wa_tab2-charg,wa_tab2-lgort,wa_tab2-cspem.
*  ENDLOOP.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'FROM_PLANT'.
  append wa_fieldcat to fieldcat.


  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PRODCU CODE'.
  append wa_fieldcat to fieldcat.


  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LGORT'.
  wa_fieldcat-seltext_l = 'STORAGE LOC'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CSPEM'.
  wa_fieldcat-seltext_l = 'BLOCKED QTY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHK'.
  wa_fieldcat-seltext_l = 'SELECT'.
  wa_fieldcat-checkbox = 'X'.
  wa_fieldcat-edit = 'X'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'TRANSFER BLOCKED STOCK TO QUALITY ON BATCH CONFIRMATION'.


  call function 'REUSE_ALV_GRID_DISPLAY'
    exporting
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      i_callback_program      = g_repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
      i_callback_user_command = 'USER_COMM1'
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
endform.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_BDC1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form update_bdc1 .

  loop at it_tab2 into wa_tab2 where chk eq 'X' .
    clear : qty, a1,a2,a3,a4.
    wa_tab3-werks = wa_tab2-werks.
    wa_tab3-matnr = wa_tab2-matnr.
    wa_tab3-charg = wa_tab2-charg.
    wa_tab3-lgort = wa_tab2-lgort.
*    QTY = WA_TAB2-CSPEM.
    wa_tab3-cspem = wa_tab2-cspem.

    a1 = sy-datum+6(2).
    a2 = sy-datum+4(2).
    a3 = sy-datum+0(4).
    concatenate a1 a2 a3 into a4 separated by '.'.
    wa_tab3-sdate = a4.
    collect wa_tab3 into it_tab3.
    clear wa_tab3.
  endloop.

*  EXIT.

*  PERFORM open_dataset USING dataset.
*  PERFORM open_group.

*  LOOP AT record.
  loop at it_tab3 into wa_tab3.

*read dataset dataset into record.
*if sy-subrc <> 0. exit. endif.

    perform bdc_dynpro      using 'SAPMM07M' '0400'.
    perform bdc_field       using 'BDC_CURSOR'
                                  'RM07M-WERKS'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '/00'.
    perform bdc_field       using 'MKPF-BLDAT'
*                              record-BLDAT_001.
*                                   '02.04.2018'.
                                    wa_tab3-sdate.
    perform bdc_field       using 'MKPF-BUDAT'
*                              record-BUDAT_002.
*                                   '02.04.2018'.
                                   wa_tab3-sdate.
    perform bdc_field       using 'RM07M-BWARTWA'
*                              record-BWARTWA_003.
                                   '350'.
    perform bdc_field       using 'RM07M-WERKS'
*                                  record-werks_004.
*                                  '1000'.
                                   wa_tab3-werks.
    perform bdc_field       using 'RM07M-LGORT'
*                                  record-lgort_005.
*                                  'FG01'.
                                   wa_tab3-lgort.
    perform bdc_field       using 'XFULL'
*                                  record-xfull_006.
                                   'X'.
    perform bdc_field       using 'RM07M-WVERS3'
*                                  record-wvers3_007.
                                   'X'.
    perform bdc_dynpro      using 'SAPMM07M' '0421'.
    perform bdc_field       using 'BDC_CURSOR'
                                  'MSEG-CHARG(01)'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '/00'.
    perform bdc_field       using 'MSEG-MATNR(01)'
*                                  record-matnr_01_008.
*                                  '41074'.
                                   wa_tab3-matnr.
    perform bdc_field       using 'MSEG-ERFMG(01)'
*                                  record-erfmg_01_009.
*                                   '10'.
                                    wa_tab3-cspem.
    perform bdc_field       using 'MSEG-CHARG(01)'
*                                  record-charg_01_010.
*                                   'LST1804'.
                                    wa_tab3-charg.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_011.
    perform bdc_dynpro      using 'SAPLKACB' '0002'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTE'.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_012.
    perform bdc_dynpro      using 'SAPLKACB' '0002'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTE'.
    perform bdc_dynpro      using 'SAPMM07M' '0421'.
    perform bdc_field       using 'BDC_CURSOR'
                                  'MSEG-ERFMG(01)'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=BU'.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_013.
    perform bdc_dynpro      using 'SAPLKACB' '0002'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTE'.
*    PERFORM bdc_transaction USING 'MB1B'.
    call transaction 'MB1B' using bdcdata  mode 'N' messages into it_mess.
    if sy-subrc eq 0.
      a = 1.
    endif.
    commit work and wait.
    refresh bdcdata.
    clear bdcdata.
*    ENDIF.
  endloop.
*ENDFORM.

  if a eq '1'.
    message 'DATA HAS BEEN MOVED TO BLOCKED - REJECTION' type 'I'.
  endif.
  set screen 0.

*  EXIT.

*  PERFORM close_group.

endform.
*&---------------------------------------------------------------------*
*&      Form  AUTO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form auto .

  select * from mchb into table it_mchb where werks in plant and lgort in loc and matnr in material and lgort ne 'CSM' and clabs gt 0.

  loop at it_mchb into wa_mchb.
    select single * from mcha where matnr eq wa_mchb-matnr and werks eq wa_mchb-werks and charg eq wa_mchb-charg and vfdat le sy-datum.
    if sy-subrc eq 0.
      if mcha-vfdat ne '00000000'.
        wa_tab1-werks = wa_mchb-werks.
        wa_tab1-matnr = wa_mchb-matnr.
        wa_tab1-charg = wa_mchb-charg.
        wa_tab1-lgort = wa_mchb-lgort.
        wa_tab1-cspem = wa_mchb-clabs.
        wa_tab1-hsdat = mcha-hsdat.
        wa_tab1-vfdat = mcha-vfdat.
*       + WA_MCHB-CINSM.
        collect wa_tab1 into it_tab1.
        clear wa_tab1.
      endif.
    endif.
  endloop.

  delete it_tab1 where cspem eq 0.

  loop at it_tab1 into wa_tab1.
    wa_tab2-werks = wa_tab1-werks.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-lgort = wa_tab1-lgort.
    wa_tab2-cspem = wa_tab1-cspem.
    wa_tab2-hsdat = wa_tab1-hsdat.
    wa_tab2-vfdat = wa_tab1-vfdat.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.

  sort it_tab2 by charg.

*  LOOP AT it_tab2 INTO wa_tab2.
*    WRITE : / '**', wa_tab2-matnr,wa_tab2-charg,wa_tab2-lgort,wa_tab2-cspem.
*  ENDLOOP.

  loop at it_tab2 into wa_tab2 .
    clear : qty, a1,a2,a3,a4.
    wa_tab3-werks = wa_tab2-werks.
    wa_tab3-matnr = wa_tab2-matnr.
    wa_tab3-charg = wa_tab2-charg.
    wa_tab3-lgort = wa_tab2-lgort.
*    QTY = WA_TAB2-CSPEM.
    wa_tab3-cspem = wa_tab2-cspem.

    a1 = sy-datum+6(2).
    a2 = sy-datum+4(2).
    a3 = sy-datum+0(4).
    concatenate a1 a2 a3 into a4 separated by '.'.
    wa_tab3-sdate = a4.

*    select single * from mara where matnr eq wa_tab2-matnr.
*    if sy-subrc eq 0.
*      if mara-mtart eq 'ZFRT' or mara-mtart eq 'ZHWA' or mara-mtart eq 'ZHLB' or mara-mtart eq 'ZDSM' or mara-mtart eq 'ZESC'
*        or mara-mtart eq 'ZESM'.
*        wa_tab3-rej = 'REJ1'.
*      elseif mara-mtart eq 'ZROH'.
*        wa_tab3-rej = 'REJ2'.
*      else.
*        wa_tab3-rej = 'REJ3'.
*      endif.
*    endif.

    collect wa_tab3 into it_tab3.
    clear wa_tab3.
  endloop.

*  EXIT.

*  PERFORM open_dataset USING dataset.
*  PERFORM open_group.

*  LOOP AT record.
  loop at it_tab3 into wa_tab3.

*read dataset dataset into record.
*if sy-subrc <> 0. exit. endif.

    perform bdc_dynpro      using 'SAPMM07M' '0400'.
    perform bdc_field       using 'BDC_CURSOR'
*                                  'RM07M-WERKS'.
                                  'RM07M-LGORT'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '/00'.
    perform bdc_field       using 'MKPF-BLDAT'
*                              record-BLDAT_001.
*                                   '02.04.2018'.
                                    wa_tab3-sdate.
    perform bdc_field       using 'MKPF-BUDAT'
*                              record-BUDAT_002.
*                                   '02.04.2018'.
                                   wa_tab3-sdate.
    perform bdc_field       using 'RM07M-BWARTWA'
*                              record-BWARTWA_003.
                                   '344'.
    perform bdc_field       using 'RM07M-WERKS'
*                                  record-werks_004.
*                                  '1000'.
                                   wa_tab3-werks.
    perform bdc_field       using 'RM07M-LGORT'
*                                  record-lgort_005.
*                                  'FG01'.
                                   wa_tab3-lgort.
*                                    'REJ'.
*                                   wa_tab3-rej.
    perform bdc_field       using 'XFULL'
*                                  record-xfull_006.
                                   'X'.
    perform bdc_field       using 'RM07M-WVERS3'
*                                  record-wvers3_007.
                                   'X'.
    perform bdc_dynpro      using 'SAPMM07M' '0421'.
    perform bdc_field       using 'BDC_CURSOR'
                                  'MSEG-CHARG(01)'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '/00'.

    perform bdc_field       using 'MSEGK-UMLGO'
                                 wa_tab3-lgort.

    perform bdc_field       using 'MSEG-MATNR(01)'
*                                  record-matnr_01_008.
*                                  '41074'.
                                   wa_tab3-matnr.
    perform bdc_field       using 'MSEG-ERFMG(01)'
*                                  record-erfmg_01_009.
*                                   '10'.
                                    wa_tab3-cspem.
    perform bdc_field       using 'MSEG-CHARG(01)'
*                                  record-charg_01_010.
*                                   'LST1804'.
                                    wa_tab3-charg.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_011.
    perform bdc_dynpro      using 'SAPLKACB' '0002'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTE'.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_012.
    perform bdc_dynpro      using 'SAPLKACB' '0002'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTE'.
    perform bdc_dynpro      using 'SAPMM07M' '0421'.
    perform bdc_field       using 'BDC_CURSOR'
                                  'MSEG-ERFMG(01)'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=BU'.
*perform bdc_field       using 'DKACB-FMORE'
*                              record-FMORE_013.
    perform bdc_dynpro      using 'SAPLKACB' '0002'.
    perform bdc_field       using 'BDC_OKCODE'
                                  '=ENTE'.
*    PERFORM bdc_transaction USING 'MB1B'.
    call transaction 'MB1B' using bdcdata  mode 'N' messages into it_mess.
    if sy-subrc eq 0.
      a = 1.
    endif.
    commit work and wait.
    refresh bdcdata.
    clear bdcdata.
*    ENDIF.
  endloop.
*ENDFORM.

*  IF A EQ '1'.
*    MESSAGE 'DATA HAS BEEN MOVED TO QUALITY' TYPE 'I'.
*  ENDIF.
  set screen 0.

*  EXIT.

*  PERFORM close_group.

endform.
*&---------------------------------------------------------------------*
*&      Form  DO_AUTO_BLOCK_NEAR_EXPIRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form do_auto_block_near_expiry .
******* get 6 months date - to check expiry of products
  clear gv_exp_dt.
  call function 'RE_ADD_MONTH_TO_DATE'
    exporting
      months  = '6'
      olddate = sy-datum
    importing
      newdate = gv_exp_dt.

***** get materials of type as per input
  clear gt_mara[].
  select * from mara into table gt_mara where mtart in s_mtart and lvorm <> abap_true.

***** get materials/batch/plant details
  clear gt_mchb[].
  select * from mchb into table gt_mchb where werks in s_werks and lgort ne 'CSM' and clabs gt 0.
  if sy-subrc = 0.
******* get materials/batch/plant - which are expirying within 6 months from current dt.
    sort gt_mchb[] by matnr werks charg.
    clear gt_mcha[].
    select * from mcha into table gt_mcha
      for all entries in gt_mchb
      where matnr = gt_mchb-matnr
      and werks = gt_mchb-werks
      and charg = gt_mchb-charg
    and vfdat between sy-datum and gv_exp_dt.

  endif.

****** get data to move it to for transfer posting using mb1b i.e.to block the stock
  if gt_mcha[] is not initial.
    clear gt_fdata[].
    loop at gt_mchb into gw_mchb.
      read table gt_mcha into gw_mcha with key matnr = gw_mchb-matnr werks = gw_mchb-werks charg = gw_mchb-charg.
      if sy-subrc = 0 and gw_mcha-vfdat is not initial.
        gw_fdata-werks = gw_mchb-werks.
        gw_fdata-matnr = gw_mchb-matnr.
        gw_fdata-charg = gw_mchb-charg.
        gw_fdata-lgort = gw_mchb-lgort.
        gw_fdata-clabs = gw_mchb-clabs.
        gw_fdata-cspem = gw_mchb-clabs.
        gw_fdata-vfdat = gw_mcha-vfdat.

        clear gw_mara.
        read table gt_mara into gw_mara with key matnr = gw_mchb-matnr.
        if sy-subrc = 0.
          gw_fdata-meins = gw_mara-meins.
          collect gw_fdata into gt_fdata.
        endif.
        clear gw_fdata.
      endif.
    endloop.
  endif.

********* do MB1B - move stock to blocked as they are eligible for expiry
  if gt_fdata[] is not initial.
    perform do_mb1b.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  DO_MB1B
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form do_mb1b .
  data : ls_hdr     like bapi2017_gm_head_01,
         lw_mvt_hdr like bapi2017_gm_head_ret,
         lt_itm     type table of bapi2017_gm_item_create,
         lw_itm     type  bapi2017_gm_item_create,
         lt_return  type table of bapiret2,
         lw_return  type bapiret2,
         lv_msg     type string.

  loop at gt_fdata into gw_fdata.

    clear ls_hdr.
    ls_hdr-pstng_date = sy-datum.
    ls_hdr-doc_date = sy-datum.
    ls_hdr-pr_uname = sy-uname.
    ls_hdr-header_txt = 'Auto Block expiry'.

    clear lt_itm[].
    lw_itm-material = gw_fdata-matnr.
    lw_itm-plant = gw_fdata-werks.
    lw_itm-stge_loc = gw_fdata-lgort.
    lw_itm-batch = gw_fdata-charg.
    lw_itm-move_type = '344'.
    lw_itm-item_text = 'Expiry within 6 Months'.
    lw_itm-entry_qnt = gw_fdata-clabs.
    lw_itm-entry_uom = gw_fdata-meins.
    lw_itm-entry_uom_iso = gw_fdata-meins.
    lw_itm-mvt_ind = ''.
    append lw_itm to lt_itm.
    clear lw_itm.
  endloop.

  if lt_itm[] is not initial.
    clear lw_mvt_hdr.
    clear lt_return.
    call function 'BAPI_GOODSMVT_CREATE'
      exporting
        goodsmvt_header  = ls_hdr
        goodsmvt_code    = '04'
*       TESTRUN          = ' '
*       GOODSMVT_REF_EWM =
      importing
        goodsmvt_headret = lw_mvt_hdr
*       MATERIALDOCUMENT =
*       MATDOCUMENTYEAR  =
      tables
        goodsmvt_item    = lt_itm[]
*       GOODSMVT_SERIALNUMBER         =
        return           = lt_return[]
*       GOODSMVT_SERV_PART_DATA       =
*       EXTENSIONIN      =
      .
    if sy-subrc = 0 and lt_return[] is initial.
      call function 'BAPI_TRANSACTION_COMMIT'
        exporting
          wait = abap_true.

      clear lv_msg.
      concatenate 'SUCESS: Document created - ' lw_mvt_hdr-mat_doc '/' lw_mvt_hdr-doc_year into lv_msg separated by space.
      write :/ lv_msg.
      message lv_msg type 'S'.

    else.
*****      call function 'BAPI_TRANSACTION_ROLLBACK'
*****        importing
*****          return = lt_return.

      loop at  lt_return  into lw_return where type <> 'S'.
        if sy-subrc = 0.
          clear lv_msg.
          concatenate 'ERROR - ' lw_return-message into lv_msg separated by space.
          write :/ lv_msg.
          message lv_msg type 'S'.
        endif.
      endloop.
    endif.
  endif.
endform.
