*&---------------------------------------------------------------------*
*& Report  ZEXPORT_PRINTS
*&---------------------------------------------------------------------*
*&DESCRIPTION       : Exports prints like prod.order , proforma invoice
*&
*&CREATED BY         : Shraddha Pradhan
*&CREATED ON         : 18/09/2023
*&Request No         : BCDK933602 ,BCDK933564,BCDK933642, BCDK933710
*&Request No         : BCDK933738, BCDK933877,BCDK933959,BCDK933972
*&Request No         : BCDK934027,BCDK934100,BCDK934205,BCDK934223
*&                     BCDK934229
*&Customised TR      : BCDK933602,BCDK933604, BCDK933974,
*&T-Code             : ZEXPORT_PRINTS
*&--------------------------------------------------------------------------------------------------------------------------*
*&Modification History
*&---------------------------
*&Changed by/date      : 09.02.2024/shraddhap
*&DESCRIPTION          : Packsize changes if BOM is not available for material.
*&                       Packsize - selection change no BOM in consideration chk only material master units
*&                       Corr in material desc prod.order
*&                       Corr in packsize and qty when matrl is GEL/LIQ
*&Request No.          : BCDK934285,BCDK934294,BCDK934326,BCDK934330,BCDK934332,BCDK934342
*&----------------------------------------------------------------------------------------------------------------------------*
*&Changed by/date      : 07.03.2024/shraddhap
*&DESCRIPTION          : Add CAP material group for packsize. Also single strip/box needs tp print in packsize
*&Request No.          : BCDK934499,BCDK934530
*&-----------------------------------------------------------------------------------------------------------------------------*
*&Changed by/date      : 18.03.2024/shraddhap
*&DESCRIPTION          : changes for pre/post shipment
*&Request No.          :  BCDK934592,BCDK934662,BCDK934664,BCDK934674
*&-----------------------------------------------------------------------------------------------------------------------------*
*&Changed by/date      : 28.05.2024/shraddhap
*&DESCRIPTION          : changes for pre/post shipment- added inv.hdr text,chngs PFI consignee address
*&                       added option to delete pre/post shipment
*&Request No.          : BCDK935048 , BCDK935098,BCDK935154
*&Custm TR No.         : BCDK935150 - VOTXN - add text Z010 in VF01/02 for pre/post shipment no.of kind packages print.
*&------------------------------------------------------------------------------------------------------------------------------*
*&Changed by/date      : 10.06.2024/shraddhap
*&DESCRIPTION          : changes for pfi/pre/post shipment - rounding down for rate
*&Request No.          :  BCDK935249,BCDK935253
*&-----------------------------------------------------------------------------------------------------------------------------*
*&Changed by/date      : 01.09.2024/shraddhap
*&DESCRIPTION          :  for post-shipment no. and bill of lading date at input.
*&                     :  correction in pfi/pre/post shipment layout for sale/bonus/samples wise printing.
*&                     :  for pre/post-inv/packLst - add new txt at bill.header(Z024) for Bank LC addr.so it will get printed in Consignee area
*&Request No.          :  BCDK935782, BCDK935802, BCDK935828
*&-----------------------------------------------------------------------------------------------------------------------------*
*&Changed by/date      : 24.02.2025 / shraddhap
*&DESCRIPTION          : Promotional items at pre-shipment level and add gross/net weight columns in promotional items
*&                     : Add the same in total gross/net weight
*&Request No.          : BCDK936408
*&-----------------------------------------------------------------------------------------------------------------------------*
*&Changed by/date      : 25.03.2025 / shraddhap
*&DESCRIPTION          : In pre-shipment - Rate calculation correction done. Order Net price is refered instead of net value of item
*&Request No.          :BCDK936517
*&-----------------------------------------------------------------------------------------------------------------------------*
*&Changed by/date      : 15.03.2025 / shraddhap
*&DESCRIPTION          : In pre-shipment - Rate calculation correction done when multiple deliveries are there with same material.
*&                       collect data of deliveries of same material and same export order so that rate will not get doubled.
*&Request No.          : BCDK936625
*&-----------------------------------------------------------------------------------------------------------------------------*
*&Changed by/date      : 19.05.2025 / shraddhap
*&DESCRIPTION          : New unit of measure is added for INJ material (AMP) and same is added for packsize in Exp.Order
*&Request No.          : BCDK936833 , BCDK936841
*&-----------------------------------------------------------------------------------------------------------------------------*
report zexport_prints.

tables :vbak,
        vbap,
        sscrfields,
        kna1,
        zexp_ord_mat,
        zexp_ord_mailid,
        zexp_promo_mat,
        zexport_preship,
        zexport_post1,
        zexport_post2.


constants : gc_true          type c value 'X',
            gc_email_sender  type adr6-smtp_addr value 'zexp@bluecrosslabs.com',
            gc_fm_prod_ord   type  tdsfname value 'ZEXPORT_PRODUCTION_ORDER_SF',
            gc_fm_prof_inv   type  tdsfname value 'ZEXPORT_PROFORMA_INVOICE_SF',
            gc_fm_pre_shpmnt type  tdsfname value 'ZEXPORT_PRE_SHIPMENT_SF',
            gc_fm_pack_list  type  tdsfname value 'ZEXPORT_PACK_LIST_SF'.

types : begin of ty_marm,
          matnr type matnr,
          meinh type lrmei,
          umrez type umrez,
          umren type umren,
        end of ty_marm,

        begin of ty_marc,
          matnr      type matnr,
          werks      type werks_d,
          zzregn_no  type zzmat_regn_no,
          zzpacksize type zzpacksize,
        end of ty_marc,

        begin of ty_shp_f4,
          vbeln   type vbeln_vl,
          vbelv   type vbelv,
          invnum  type char20,
          cpudt   type cpudt,
          uname   type uname,

          gjahr   type gjahr,
          vbeln1  type vbeln_vl,
          postnum type char20,
          cpudt1  type cpudt,
          uname1  type uname,
        end of ty_shp_f4.

data : gt_vbak      type table of vbak,
       gw_vbak      type vbak,
       gt_vbap      type table of vbap,
       gw_vbap      type vbap,
       gt_vbrk      type table of vbrk,
       gw_vbrk      type vbrk,
       gt_vbrp      type table of vbrp,
       gw_vbrp      type vbrp,
       gt_vbfa      type table of vbfa,
       gw_vbfa      type vbfa,
       gt_likp      type table of likp,
       gw_likp      type likp,
       gt_lips      type table of lips,
       gw_lips      type lips,
       gt_fdata     type table of zty_export_data,     "for final data display
       gw_fdata     type zty_export_data,
       gt_promo_mat type table of zexp_promo_mat,    "for promotional materials
       gt_marm      type table of ty_marm,
       gw_marm      type ty_marm,
       gt_marc      type table of ty_marc,
       gw_marc      type ty_marc,
*****       gt_exp_mat TYPE TABLE OF zexp_ord_mat,
*****       gw_exp_mat TYPE zexp_ord_mat,
       gt_mailid    type table of zexp_ord_mailid,
       gw_mailid    type zexp_ord_mailid,
       gt_kna1      type table of kna1,
       gw_kna1      type kna1,
       gt_adrc      type table of adrc,
       gw_adrc      type adrc,
       gt_zpreship  type table of zexport_preship,
       gw_zpreship  type zexport_preship,
       gt_shp_f4    type table of ty_shp_f4,
       gw_shp_f4    type ty_shp_f4,
       gt_zpostshp1 type table of zexport_post1,
       gw_zpostshp1 type  zexport_post1,
       gt_zpostshp2 type table of zexport_post2,
       gw_zpostshp2 type  zexport_post2.

data : gw_output_opts type ssfcompop,
       gw_contrl_para type ssfctrlop,
       gt_otf_data    type ssfcrescl,
       gt_otf         type standard table of itcoo,
       gt_tline       type standard table of tline,
       gt_pdf_data    type solix_tab,
       gt_text        type bcsy_text.

data : lv_auart   type auart,
       gv_postinv type string,
       gv_postdt  type cpudt,
       gv_answer  type c,
       gv_msg     type string.

data : g_html_container type ref to cl_gui_custom_container,
       g_html_control   type ref to cl_gui_html_viewer.

data:     ok_code like sy-ucomm.
"Object References
data: lo_bcs     type ref to cl_bcs,
      lo_doc_bcs type ref to cl_document_bcs,
      lo_recep   type ref to if_recipient_bcs,
      lo_sender  type ref to if_sender_bcs,  "cl_sapuser_bcs,
      lo_cx_bcx  type ref to cx_bcs.

data :gv_bin_filesize type so_obj_len,
      gv_bin_xstr     type xstring,
      gv_text         type string,
      gv_sent_to_all  type os_boolean,
      gv_subject      type so_obj_des,
      gv_button       type c.

selection-screen begin of block b1 with frame title text-001 no intervals.
parameters  : p_zexp  type vbeln_va matchcode object vmva modif id exp."OBLIGATORY,
parameters  : p_ship  type char20 modif id shp.
*****SELECT-OPTIONS : s_ppshp FOR ZEXPORT_PRESHIP-INVNUM MODIF ID shp.
selection-screen end of block b1.

selection-screen begin of block b3 with frame title text-004 no intervals.
parameters: p_prdord radiobutton group r2 user-command rb2 default 'X'.    " production order
parameters: p_proinv radiobutton group r2.    "proforma invoice

*selection-screen uline.
*parameters : p_cppshp radiobutton group r2.    "create pre/post shipment          " commented by ps
*parameters : p_dppshp radiobutton group r2.    "delete pre/post shipment     "" commented by ps
*selection-screen uline.
*parameters : p_preshp radiobutton group r2.   "pre-shipment invoice         " commented by ps
*parameters : p_paclst radiobutton group r2.   "packing list     " commented by ps
selection-screen end of block b3.
selection-screen begin of block b2 with frame title text-002 .
parameters: p_rad1  radiobutton group r1 user-command rb1 default 'X',    " print
            p_rad11 radiobutton group r1,
            p_rad2  radiobutton group r1,    "Email
            p_rad22 radiobutton group r1.    "Email
*****SELECTION-SCREEN SKIP.
selection-screen uline.
selection-screen comment /1(40) text-003.
selection-screen uline.

*****PARAMETERS: p_rad3 RADIOBUTTON GROUP r1 ,    " Export material master
parameters: p_rad5 radiobutton group r1,    " Export promotional material against proforma Invoice
            p_rad4 radiobutton group r1.    "Email
selection-screen uline.
selection-screen end of block b2.

at selection-screen output.
  if p_prdord = gc_true or p_proinv = gc_true.
    loop at screen.
      if screen-group1 = 'EXP'  or screen-group1 = ''.
        screen-active = 1.
        modify screen.
      else.
        screen-active = 0.
        modify screen.
      endif.
    endloop.
*  elseif p_preshp = gc_true or p_paclst = gc_true or p_dppshp = gc_true.   ""commented by ps
*    loop at screen.
*      if screen-group1 = 'SHP'  or screen-group1 = ''.
*        screen-active = 1.
*        modify screen.
*      else.
*        screen-active = 0.
*        modify screen.
*      endif.
*    endloop.
*  elseif p_cppshp = 'X'.         " commented by ps
*    loop at screen.
*      if screen-group1 = 'SHP'  or screen-group1 = 'EXP'.
*        screen-active = 0.
*        modify screen.
*      endif.
*    endloop.
  endif.

at selection-screen on p_zexp.
  clear lv_auart.
  select single auart from vbak into lv_auart where vbeln = p_zexp.
  if sy-subrc = 0.
*    if lv_auart ne 'Z002' and
*     message 'Please select export order only' type 'E'.              " add lv_auart ne z003 nd z004.
*endif.
*    if
*  lv_auart = 'Z003'.
**     lv_auart = 'ZQT' or
**      lv_auart = 'Z004'.  " added zqt and z004 by pratiksha
*
*      message 'Please select export order only' type 'E'.
*    endif.
  endif.

at selection-screen on value-request for p_ship.
  perform get_p_ship_f4 using p_ship.



start-of-selection.
  if p_zexp is not initial or p_ship is not initial.
******  get initial data from export order
    perform get_data.
******  prepare final print data for production order
    if p_prdord = gc_true.
      perform prepare_fdata_prod_ord.
******  prepare final print data for proforma Invoice
    elseif p_proinv = gc_true.
      perform prepare_fdata_proforma_inv.
*    elseif p_preshp = gc_true or p_paclst = gc_true.
********  prepare final print data for Pre-shipment and packing list
*      perform prepare_fdata_pre_shipment.
    endif.
    if gt_fdata[] is not initial.
      if p_rad1 = gc_true.
        perform disp_form.
******  for OML location only.
      elseif p_rad11 = gc_true.
        sort gt_fdata by werks.
        delete gt_fdata where werks <> '3000'.
        if gt_fdata[] is not initial.
          perform disp_form.
        else.
          message 'No data found' type 'S'.
        endif.
******  send email
      elseif p_rad2 = gc_true.
        if gt_fdata[] is not initial.
          perform email_form.
          if gt_otf[] is not initial.
            perform send_email.
          endif.
        else.
          message 'No data found' type 'S'.
        endif.
******  send email - for OML location only.
      elseif p_rad22 = gc_true.
        sort gt_fdata by werks.
        delete gt_fdata where werks <> '3000'.
        if gt_fdata[] is not initial.
          perform email_form.
          if gt_otf[] is not initial.
            perform send_email.
          endif.
        else.
          message 'No data found' type 'S'.
        endif.
      endif.
    else.
      message 'No data found' type 'S'.
    endif.
*****  ELSE.
*****    IF p_rad1 = gc_true OR p_rad11 = gc_true OR p_rad2 = gc_true OR p_rad22 = gc_true.
*****      MESSAGE 'Please enter Export order no.' TYPE 'I'.
*****    ENDIF.
  endif.


*****  IF p_rad3 = gc_true.
*****    CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
*****      EXPORTING
*****        action                       = 'U'
*****        view_name                    = 'ZEXP_ORD_MAT' "maint.View
*****      EXCEPTIONS
*****        client_reference             = 1
*****        foreign_lock                 = 2
*****        invalid_action               = 3
*****        no_clientindependent_auth    = 4
*****        no_database_function         = 5
*****        no_editor_function           = 6
*****        no_show_auth                 = 7
*****        no_tvdir_entry               = 8
*****        no_upd_auth                  = 9
*****        only_show_allowed            = 10
*****        system_failure               = 11
*****        unknown_field_in_dba_sellist = 12
*****        view_not_found               = 13
*****        OTHERS                       = 14.
  if p_rad4 = gc_true.
    call function 'VIEW_MAINTENANCE_CALL'
      exporting
        action                       = 'U'
        view_name                    = 'ZEXP_ORD_MAILID' "maint.View
      exceptions
        client_reference             = 1
        foreign_lock                 = 2
        invalid_action               = 3
        no_clientindependent_auth    = 4
        no_database_function         = 5
        no_editor_function           = 6
        no_show_auth                 = 7
        no_tvdir_entry               = 8
        no_upd_auth                  = 9
        only_show_allowed            = 10
        system_failure               = 11
        unknown_field_in_dba_sellist = 12
        view_not_found               = 13
        others                       = 14.

  elseif p_rad5 = 'X'.
    call function 'VIEW_MAINTENANCE_CALL'
      exporting
        action                       = 'U'
        view_name                    = 'ZEXP_PROMO_MAT' "maint.View
      exceptions
        client_reference             = 1
        foreign_lock                 = 2
        invalid_action               = 3
        no_clientindependent_auth    = 4
        no_database_function         = 5
        no_editor_function           = 6
        no_show_auth                 = 7
        no_tvdir_entry               = 8
        no_upd_auth                  = 9
        only_show_allowed            = 10
        system_failure               = 11
        unknown_field_in_dba_sellist = 12
        view_not_found               = 13
        others                       = 14.
  endif.

*  if p_cppshp = gc_true.      " create pre/post shipment             " commented by ps
*    call transaction 'ZEXPORT_PP'.
*  endif.

**** delete pre/post shipment
*  if p_dppshp = gc_true.                          ""commented by ps 528
*    if p_ship is not initial.
*      if p_ship+0(5) = 'OS-PS'.
*        clear gt_zpreship[].
*        select * from zexport_preship into table gt_zpreship
*          where invnum = p_ship.
*        if sy-subrc = 0.
*          clear gt_zpostshp2[].
*          select * from zexport_post2 into table gt_zpostshp2
*            where invnum = p_ship.
*          if sy-subrc = 0.
*            clear gt_zpostshp1[].
*            select * from zexport_post1 into table gt_zpostshp1
*              for all entries in gt_zpostshp2
*              where postnum = gt_zpostshp2-postnum.
*            if sy-subrc = 0.
*              clear gv_text.
*              concatenate 'Deleting' p_ship 'will also delete related Post-shipment. Do you want to still delete?'
*                into gv_text separated by space.
*              clear gv_answer.
*              call function 'POPUP_TO_CONFIRM'
*                exporting
*                  titlebar       = 'Deleting Pre and Post Shipment'
*                  text_question  = gv_text
*                  text_button_1  = 'Yes'
*                  icon_button_1  = 'ICON_CHECKED'
*                  text_button_2  = 'No'
*                  icon_button_2  = 'ICON_CANCEL'
*                  default_button = '1'
*                importing
*                  answer         = gv_answer.
*              if sy-subrc <> 0.
** Implement suitable error handling here
*              endif.
*              if gv_answer = '1'.
*                clear gw_zpostshp2.
*                read table  gt_zpostshp2 into gw_zpostshp2 with key invnum = p_ship.
*                if sy-subrc = 0.
*                  delete from zexport_post1 where postnum = gw_zpostshp2-postnum.
*                  if sy-subrc = 0.
*                    delete from zexport_post2 where invnum = gw_zpostshp2-invnum.
*                    if sy-subrc = 0.
*                      delete from zexport_preship where invnum = p_ship.
*                      if sy-subrc = 0.
*                        clear gv_msg.
*                        concatenate 'Pre-shipment:' p_ship 'with Post-shipment:'  gw_zpostshp2-postnum 'are deleted.'
*                        into gv_msg separated by space.
*                        message gv_msg type 'I'.
*                        exit.
*                      endif.
*                    endif.
*                  endif.
*                endif.
*              else.
*                leave program.
*              endif.
*            endif.
*          else.   "no post-shipment exists
*            clear gv_text.
*            concatenate 'Confirm deleting Pre-Shipment:' p_ship
*              into gv_text separated by space.
*            clear gv_answer.
*            call function 'POPUP_TO_CONFIRM'
*              exporting
*                titlebar       = 'Deleting Pre-Shipment'
*                text_question  = gv_text
*                text_button_1  = 'Yes'
*                icon_button_1  = 'ICON_CHECKED'
*                text_button_2  = 'No'
*                icon_button_2  = 'ICON_CANCEL'
*                default_button = '1'
*              importing
*                answer         = gv_answer.
*            if gv_answer = '1'.
*              delete from zexport_preship where invnum = p_ship.
*              if sy-subrc = 0.
*                clear gv_msg.
*                concatenate 'Pre-shipment:' p_ship 'deleted.' into gv_msg separated by space.
*                message gv_msg type 'I'.
*                exit.
*              endif.
*            else.
*              leave program.
*            endif.
*          endif.
*        endif.
*      else.  "check if entered no.is post-shipment
*        clear gt_zpostshp2[].
*        select * from zexport_post2 into table gt_zpostshp2
*          where postnum = p_ship.
*        if sy-subrc = 0.
*          clear gt_zpostshp1[].
*          select * from zexport_post1 into table gt_zpostshp1
*            for all entries in gt_zpostshp2
*            where postnum = gt_zpostshp2-postnum.
*          if sy-subrc = 0.
*            clear gv_text.
*            concatenate 'Confirm deleting Post-Shipment:' p_ship into gv_text separated by space.
*            clear gv_answer.
*            call function 'POPUP_TO_CONFIRM'
*              exporting
*                titlebar       = 'Deleting Post-Shipment'
*                text_question  = gv_text
*                text_button_1  = 'Yes'
*                icon_button_1  = 'ICON_CHECKED'
*                text_button_2  = 'No'
*                icon_button_2  = 'ICON_CANCEL'
*                default_button = '1'
*              importing
*                answer         = gv_answer.
*            if gv_answer = '1'.
*              clear gw_zpostshp2.
*              read table  gt_zpostshp2 into gw_zpostshp2 with key postnum = p_ship.
*              if sy-subrc = 0.
*                delete from zexport_post1 where postnum = gw_zpostshp2-postnum.
*                if sy-subrc = 0.
*                  delete from zexport_post2 where postnum = gw_zpostshp2-postnum.
*                  if sy-subrc = 0.
*                    if sy-subrc = 0.
*                      clear gv_msg.
*                      concatenate 'Post-Shipment:' p_ship 'deleted.' into gv_msg separated by space.
*                      message gv_msg type 'I'.
*                      exit.
*                    endif.
*                  endif.
*                endif.
*              endif.
*            else.
*              leave program.
*            endif.
*          endif.
*        endif.
*      endif.
*    endif.
*  endif.

*&---------------------------------------------------------------------*
*&      Form  DISP_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form disp_form .

  data: fm_name type  tdsfname.

  if p_prdord = gc_true.      "production order print
    clear fm_name.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname = gc_fm_prod_ord
      importing
        fm_name  = fm_name.

*****  GW_OUTPUT_OPTS-TDNOPREV = SPACE."gc_true.
*****  GW_OUTPUT_OPTS-TDDEST    = 'LOCL'.
*****  GW_OUTPUT_OPTS-TDNOPRINT = SPACE."gc_true.
*****
*****  GW_CONTRL_PARA-GETOTF = SPACE."gc_true.
*****  GW_CONTRL_PARA-NO_DIALOG = SPACE."gc_true.
*****  GW_CONTRL_PARA-PREVIEW = SPACE.

*    gw_output_opts-tdnoprev = gc_true.  COMMENTED 29-09-2025
*    gw_output_opts-tddest    = 'LP01'.
*    gw_output_opts-tdnoprint = gc_true.
*
*    gw_contrl_para-getotf = gc_true.
*    gw_contrl_para-no_dialog = gc_true.
*    gw_contrl_para-preview = space.

    call function fm_name
      exporting
        control_parameters = gw_contrl_para
        output_options     = gw_output_opts
****      gv_rep_hdr         = gv_rep_hdr
      importing
*       document_output_info =
        job_output_info    = gt_otf_data
*       job_output_options =
      tables
        gt_vbak            = gt_vbak
        gt_vbap            = gt_vbap
        gt_fdata           = gt_fdata
      exceptions
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        others             = 5.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    endif.
  endif.

  if p_proinv = gc_true.      "proforma Inv print
    clear fm_name.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname = gc_fm_prof_inv
      importing
        fm_name  = fm_name.

*****  GW_OUTPUT_OPTS-TDNOPREV = SPACE."gc_true.
*****  GW_OUTPUT_OPTS-TDDEST    = 'LOCL'.
*****  GW_OUTPUT_OPTS-TDNOPRINT = SPACE."gc_true.
*****
*****  GW_CONTRL_PARA-GETOTF = SPACE."gc_true.
*****  GW_CONTRL_PARA-NO_DIALOG = SPACE."gc_true.
*****  GW_CONTRL_PARA-PREVIEW = SPACE.

*    gw_output_opts-tdnoprev = gc_true.              " commented 1-10-25
*    gw_output_opts-tddest    = 'LP01'.
*    gw_output_opts-tdnoprint = gc_true.
*
*    gw_contrl_para-getotf = gc_true.
*    gw_contrl_para-no_dialog = gc_true.
*    gw_contrl_para-preview = space.

    call function fm_name
      exporting
        control_parameters = gw_contrl_para
        output_options     = gw_output_opts
****      gv_rep_hdr         = gv_rep_hdr
      importing
*       document_output_info =
        job_output_info    = gt_otf_data
*       job_output_options =
      tables
        gt_vbak            = gt_vbak[]
        gt_vbap            = gt_vbap[]
        gt_kna1            = gt_kna1[]
        gt_fdata           = gt_fdata[]
        gt_promo_mat       = gt_promo_mat[]
        gt_adrc            = gt_adrc[]
      exceptions
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        others             = 5.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    endif.
  endif.

*  if p_preshp = gc_true.      "pre-shipment Inv print      " commented by ps 698
*    clear fm_name.
*    call function 'SSF_FUNCTION_MODULE_NAME'
*      exporting
*        formname = gc_fm_pre_shpmnt
*      importing
*        fm_name  = fm_name.
*
******  GW_OUTPUT_OPTS-TDNOPREV = SPACE."gc_true.
******  GW_OUTPUT_OPTS-TDDEST    = 'LOCL'.
******  GW_OUTPUT_OPTS-TDNOPRINT = SPACE."gc_true.
******
******  GW_CONTRL_PARA-GETOTF = SPACE."gc_true.
******  GW_CONTRL_PARA-NO_DIALOG = SPACE."gc_true.
******  GW_CONTRL_PARA-PREVIEW = SPACE.
*
**    gw_output_opts-tdnoprev = gc_true.                       "commented 1-10-25
**    gw_output_opts-tddest    = 'LP01'.
**    gw_output_opts-tdnoprint = gc_true.
**
**    gw_contrl_para-getotf = gc_true.
**    gw_contrl_para-no_dialog = gc_true.
**    gw_contrl_para-preview = space.
*
*    call function fm_name
*      exporting
*        control_parameters = gw_contrl_para
*        output_options     = gw_output_opts
*        gv_postinv         = gv_postinv      "for post-shipment no.
*        gv_postdt          = gv_postdt       "for post-shipment dt
*      importing
**       document_output_info =
*        job_output_info    = gt_otf_data
**       job_output_options =
*      tables
*        gt_vbak            = gt_vbak[]
*        gt_vbap            = gt_vbap[]
*        gt_kna1            = gt_kna1[]
*        gt_fdata           = gt_fdata[]
*        gt_promo_mat       = gt_promo_mat[]
*        gt_zpreship        = gt_zpreship[]
*        gt_adrc            = gt_adrc[]
*      exceptions
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        others             = 5.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*
*    endif.
*  endif.

*  if p_paclst = gc_true.      "packing list print      " commented by ps 754
*    clear fm_name.
*    call function 'SSF_FUNCTION_MODULE_NAME'
*      exporting
*        formname = gc_fm_pack_list
*      importing
*        fm_name  = fm_name.
*
******  GW_OUTPUT_OPTS-TDNOPREV = SPACE."gc_true.
******  GW_OUTPUT_OPTS-TDDEST    = 'LOCL'.
******  GW_OUTPUT_OPTS-TDNOPRINT = SPACE."gc_true.
******
******  GW_CONTRL_PARA-GETOTF = SPACE."gc_true.
******  GW_CONTRL_PARA-NO_DIALOG = SPACE."gc_true.
******  GW_CONTRL_PARA-PREVIEW = SPACE.
*
**    gw_output_opts-tdnoprev = gc_true.            COMMENTED 29-09-2025
**    gw_output_opts-tddest    = 'LP01'.
**    gw_output_opts-tdnoprint = gc_true.
**
**    gw_contrl_para-getotf = gc_true.
**    gw_contrl_para-no_dialog = gc_true.
**    gw_contrl_para-preview = space.
*
*
*    call function fm_name
*      exporting
*        control_parameters = gw_contrl_para
*        output_options     = gw_output_opts
*        gv_postinv         = gv_postinv
*        gv_postdt          = gv_postdt
*      importing
**       document_output_info =
*        job_output_info    = gt_otf_data
**       job_output_options =
*      tables
*        gt_vbak            = gt_vbak[]
*        gt_vbap            = gt_vbap[]
*        gt_kna1            = gt_kna1[]
*        gt_fdata           = gt_fdata[]
*        gt_promo_mat       = gt_promo_mat[]
*        gt_zpreship        = gt_zpreship[]
*        gt_adrc            = gt_adrc[]
*      exceptions
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        others             = 5.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*
*    endif.
*  endif.

  if gt_otf_data is not   initial.

    clear: gt_otf[],gt_tline[].
***** PDF print preview with big window size.
    gt_otf[] = gt_otf_data-otfdata[].

    call function 'CONVERT_OTF'
      exporting
        format                = 'PDF'
      importing
        bin_filesize          = gv_bin_filesize
        bin_file              = gv_bin_xstr
      tables
        otf                   = gt_otf[]
        lines                 = gt_tline[]
      exceptions
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        others                = 4.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

**** for pdf preview on big window.
    call screen 9000 .

********* for direct PDF print preview.
*****    GT_OTF[] = GT_OTF_DATA-OTFDATA[].
*****
*****    CALL FUNCTION 'SSFCOMP_PDF_PREVIEW'
*****      EXPORTING
*****        I_OTF                    = GT_OTF[]
*****      EXCEPTIONS
*****        CONVERT_OTF_TO_PDF_ERROR = 1
*****        CNTL_ERROR               = 2
*****        OTHERS                   = 3.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_FDATA_PROD_ORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form prepare_fdata_prod_ord .

  types : begin of ty_stpo,
            stlnr type stnum,
            idnrk type idnrk,
          end of ty_stpo,

          begin of ty_mara,
            matnr type matnr,
            mtart type mtart,
            meins type meins,
          end of ty_mara,
          begin of ty_mast,
            matnr type matnr,
            stlnr type stnum,
          end of ty_mast.

  data : lv_psize      type string,
         lv_umren      type umren,
         lv_umren_char type string,
         lt_mast       type table of ty_mast,
         lw_mast       type ty_mast,
         lt_stpo       type table of ty_stpo,
         lw_stpo       type ty_stpo,
         lt_mara       type table of ty_mara,
         lw_mara       type ty_mara,
         lv_matnr      type matnr,
         lt_makt       type table of makt,
         lw_makt       type makt.


  sort gt_vbak by vbeln.
  sort gt_vbap by vbeln posnr.

****** for material desc.
  clear lt_makt[].
  select * from makt into table lt_makt
    for all entries in gt_vbap
    where matnr = gt_vbap-matnr
    and spras = sy-langu.


  clear gt_fdata[].
  loop at gt_vbap into gw_vbap.
    gw_fdata-vbeln = gw_vbap-vbeln.
    gw_fdata-matnr = gw_vbap-matnr.
*****    GW_FDATA-ARKTX = GW_VBAP-ARKTX.
    clear lw_makt.
    read table lt_makt into lw_makt with key matnr = gw_vbap-matnr.
    if sy-subrc = 0.
      gw_fdata-arktx = lw_makt-maktx.
    endif.
    gw_fdata-mvgr5 = gw_vbap-mvgr5.
*****  packsize and mat regn.no.
    read table gt_marc into gw_marc with key matnr = gw_vbap-matnr werks = gw_vbap-werks.
    if sy-subrc = 0.
*****      gw_fdata-zpacksize = gw_marc-zzpacksize.
      gw_fdata-zmat_regn_no = gw_marc-zzregn_no.
    endif.
**** for packsize as per units in mat.master
    select single bezei from tvm5t into gw_fdata-bezei
  where spras = sy-langu
    and mvgr5 = gw_vbap-mvgr5.

***** packsize considering units.
    case gw_vbap-mvgr1.
      when 'TAB' or 'CAP'.
        clear gw_marm.
        read table gt_marm into gw_marm with key matnr = gw_vbap-matnr meinh = 'STP'.
        if sy-subrc = 0.
          clear: lv_psize, lv_umren.
          lv_umren = gw_marm-umrez  / gw_marm-umren.
          lv_psize = lv_umren.
*****          IF LV_UMREN <> 1.
          concatenate lv_psize gw_fdata-bezei  into gw_fdata-bezei  separated by 'X '.
*****          ENDIF.
        endif.
        read table gt_marm into gw_marm with key matnr = gw_vbap-matnr meinh = 'BOX'.
        if sy-subrc = 0.
          clear: lv_psize, lv_umren.
          lv_umren = gw_marm-umrez  / gw_marm-umren.
          lv_psize = lv_umren.
*****          IF LV_UMREN <> 1.
          concatenate lv_psize gw_fdata-bezei  into gw_fdata-bezei  separated by 'X '.
*****          ENDIF.
        endif.
      when 'INJ'.  "added for AMP unit
        clear gw_marm.
        read table gt_marm into gw_marm with key matnr = gw_vbap-matnr meinh = 'AMP'.
        if sy-subrc = 0.
          clear: lv_psize, lv_umren.
          lv_umren = gw_marm-umrez  / gw_marm-umren.
*****          lv_psize = lv_umren.
          lv_umren_char = lv_umren.
          concatenate lv_umren_char 'AMP' into lv_psize separated by space.
*****          IF LV_UMREN <> 1.
          concatenate lv_psize gw_fdata-bezei  into gw_fdata-bezei  separated by ' X '.
*****          ENDIF.
        endif.
    endcase.
    gw_fdata-zpacksize = gw_fdata-bezei.

**** location/plant name
    gw_fdata-werks = gw_vbap-werks.
    if gw_vbap-werks <> '3000'.
      select single ORT01 from t001w into gw_fdata-name1   " KUNNR REPLACE ORT01 BY PS
      where werks = gw_vbap-werks.
    else.
      gw_fdata-name1 = 'OML'.
    endif.

    clear lv_matnr.
    call function 'CONVERSION_EXIT_MATN1_OUTPUT'
      exporting
        input  = gw_vbap-matnr
      importing
        output = lv_matnr.

***** sales qty
    if lv_matnr+0(1) <> '9' and gw_vbap-pstyv = 'ZGN'."'TAN'. ZAN IS COMMENTED BY PS AND REPLCE ZTAN
      gw_fdata-sale_qty = gw_vbap-kwmeng.
    endif.
***** sample qty
    if lv_matnr+0(1) = '9' and gw_vbap-pstyv = 'ZANN'or gw_vbap-pstyv ='TANN'.
      gw_fdata-samp_qty = gw_vbap-kwmeng.
    endif.
***** bonus qty
    if lv_matnr+0(1) <> '9' and gw_vbap-pstyv = 'ZANN'OR gw_vbap-pstyv ='TANN'.
      gw_fdata-bons_qty = gw_vbap-kwmeng.
    endif.

    collect   gw_fdata into gt_fdata.
    clear gw_fdata.
  endloop.

*****  IF GT_FDATA[] IS NOT INITIAL.
*****    SORT GT_FDATA BY MATNR.
*********** if material unit is KG - check for BOM against material for base unit.
*****    CLEAR LT_MAST[].
*****    SELECT MATNR STLNR FROM MAST INTO TABLE LT_MAST
*****      FOR ALL ENTRIES IN GT_FDATA
*****    WHERE MATNR = GT_FDATA-MATNR.
*****    IF SY-SUBRC = 0.
*****      SORT LT_MAST BY STLNR.
*****      CLEAR LT_STPO[].
*****      SELECT STLNR IDNRK FROM STPO INTO TABLE LT_STPO
*****        FOR ALL ENTRIES IN LT_MAST
*****      WHERE STLNR = LT_MAST-STLNR.
*****      IF SY-SUBRC = 0.
*****        SORT LT_STPO BY IDNRK.
*****        CLEAR LT_MARA[].
*****        SELECT MATNR MTART MEINS FROM MARA INTO TABLE LT_MARA
*****          FOR ALL ENTRIES IN LT_STPO
*****          WHERE MATNR = LT_STPO-IDNRK
*****          AND MTART = 'ZHLB'
*****        AND MEINS <> 'KG'.
*****      ENDIF.
*****    ENDIF.
*****
*****
*********** also take it from material master for other units
*****    CLEAR GT_MARM[].
*****    SELECT MATNR MEINH UMREZ UMREN FROM MARM INTO TABLE GT_MARM
*****      FOR ALL ENTRIES IN GT_FDATA
*****    WHERE MATNR = GT_FDATA-MATNR.
*****  ENDIF.
*****
********** update packsize
*****  LOOP AT GT_FDATA INTO GW_FDATA.
*****    CLEAR LW_MAST.
*****    READ TABLE LT_MAST INTO LW_MAST WITH KEY MATNR = GW_FDATA-MATNR.
*****    IF SY-SUBRC = 0.
*****      CLEAR LW_STPO.
*****      LOOP AT LT_STPO INTO LW_STPO WHERE STLNR = LW_MAST-STLNR.
*****        CLEAR LW_MARA.
*****        READ TABLE LT_MARA INTO LW_MARA WITH KEY MATNR = LW_STPO-IDNRK.
*****        IF SY-SUBRC = 0.
*****
*****          CLEAR: LV_PSIZE, LV_UMREN.
*****          READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'STP'."'EA'.
*****          IF SY-SUBRC = 0.
*****            LV_UMREN = GW_MARM-UMREZ  / GW_MARM-UMREN.
*****            LV_PSIZE = LV_UMREN.
*****            CONCATENATE LV_PSIZE GW_FDATA-BEZEI  INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****          ELSE.
*****            CLEAR: LV_PSIZE, LV_UMREN.
*****            READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'EA'.
*****            IF SY-SUBRC = 0.
*****              LV_UMREN = GW_MARM-UMREZ  / GW_MARM-UMREN.
*****              LV_PSIZE = LV_UMREN.
*****              CONCATENATE LV_PSIZE GW_FDATA-BEZEI  INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****            ENDIF.
*****          ENDIF.
*****          READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'BOX'.
*****          IF SY-SUBRC = 0.
*****            LV_UMREN = GW_MARM-UMREZ /  GW_MARM-UMREN.
*****            LV_PSIZE = LV_UMREN.
*****            CONCATENATE LV_PSIZE GW_FDATA-BEZEI INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****          ELSE.
*****            READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'SPR'.
*****            IF SY-SUBRC = 0.
*****              LV_UMREN = GW_MARM-UMREZ /  GW_MARM-UMREN.
*****              LV_PSIZE = LV_UMREN.
*****              CONCATENATE LV_PSIZE GW_FDATA-BEZEI INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****            ENDIF.
*****          ENDIF.
*****          GW_FDATA-ZPACKSIZE = GW_FDATA-BEZEI.
*****          MODIFY GT_FDATA FROM GW_FDATA TRANSPORTING BEZEI ZPACKSIZE.
*****          CLEAR GW_FDATA.
*****        ENDIF.
*****      ENDLOOP.
*****   ELSE.   " if BOM is not available then consider unit EA for packsize
*****        CLEAR: LV_PSIZE, LV_UMREN.
*****         READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'EA'.
*****            IF SY-SUBRC = 0.
*****              LV_UMREN = GW_MARM-UMREZ  / GW_MARM-UMREN.
*****              LV_PSIZE = LV_UMREN.
*****              CONCATENATE LV_PSIZE GW_FDATA-BEZEI  INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****
*****              GW_FDATA-ZPACKSIZE = GW_FDATA-BEZEI.
*****              MODIFY GT_FDATA FROM GW_FDATA TRANSPORTING BEZEI ZPACKSIZE.
*****              CLEAR GW_FDATA.
*****            ENDIF.
*****    ENDIF.
*****  ENDLOOP.
endform.
*&---------------------------------------------------------------------*
*&      Form  EMAIL_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form email_form .
  data: fm_name type  tdsfname.


  clear fm_name.
  if p_prdord = 'X'.        "for production order email
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname = gc_fm_prod_ord
      importing
        fm_name  = fm_name.

*    gw_output_opts-tdnoprev = gc_true.
*    gw_output_opts-tddest    = 'LOCL'.
*    gw_output_opts-tdnoprint = gc_true.
*
*    gw_contrl_para-getotf = gc_true.
*    gw_contrl_para-no_dialog = gc_true.
*    gw_contrl_para-preview = space.
*    gw_output_opts-tdnoprev = gc_true.                           COMMTENDE 1-10-25
*    gw_output_opts-tddest    = 'LP01'.
*    gw_output_opts-tdnoprint = gc_true.
*
*    gw_contrl_para-getotf = gc_true.
*    gw_contrl_para-no_dialog = gc_true.
*    gw_contrl_para-preview = space.


    call function fm_name
      exporting
*       ARCHIVE_INDEX      =
*       ARCHIVE_INDEX_TAB  =
*       ARCHIVE_PARAMETERS =
        control_parameters = gw_contrl_para
*       MAIL_APPL_OBJ      =
*       MAIL_RECIPIENT     =
*       MAIL_SENDER        =
        output_options     = gw_output_opts
*       USER_SETTINGS      = 'X'
****      gv_rep_hdr         = gv_rep_hdr
      importing
*       document_output_info =
        job_output_info    = gt_otf_data
*       job_output_options =
      tables
        gt_vbak            = gt_vbak
        gt_vbap            = gt_vbap
        gt_fdata           = gt_fdata
      exceptions
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        others             = 5.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
  endif.

  if p_proinv = gc_true.  "for Proforma Invoice email
    clear fm_name.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname = gc_fm_prof_inv
      importing
        fm_name  = fm_name.

    gw_output_opts-tdnoprev = gc_true.
    gw_output_opts-tddest    = 'LOCL'.
    gw_output_opts-tdnoprint = gc_true.

    gw_contrl_para-getotf = gc_true.
    gw_contrl_para-no_dialog = gc_true.
    gw_contrl_para-preview = space.

    call function fm_name
      exporting
*       ARCHIVE_INDEX      =
*       ARCHIVE_INDEX_TAB  =
*       ARCHIVE_PARAMETERS =
        control_parameters = gw_contrl_para
*       MAIL_APPL_OBJ      =
*       MAIL_RECIPIENT     =
*       MAIL_SENDER        =
        output_options     = gw_output_opts
*       USER_SETTINGS      = 'X'
****      gv_rep_hdr         = gv_rep_hdr
      importing
*       document_output_info =
        job_output_info    = gt_otf_data
*       job_output_options =
      tables
        gt_vbak            = gt_vbak
        gt_vbap            = gt_vbap
        gt_kna1            = gt_kna1
        gt_fdata           = gt_fdata
        gt_promo_mat       = gt_promo_mat
        gt_adrc            = gt_adrc
      exceptions
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        others             = 5.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    endif.
  endif.

*  if p_preshp = gc_true.      "pre-shipment Inv print  " commented by ps 1196
*    clear fm_name.
*    call function 'SSF_FUNCTION_MODULE_NAME'
*      exporting
*        formname = gc_fm_pre_shpmnt
*      importing
*        fm_name  = fm_name.
*
*    gw_output_opts-tdnoprev = gc_true.
*    gw_output_opts-tddest    = 'LOCL'.
*    gw_output_opts-tdnoprint = gc_true.
*
*    gw_contrl_para-getotf = gc_true.
*    gw_contrl_para-no_dialog = gc_true.
*    gw_contrl_para-preview = space.
*
*    call function fm_name
*      exporting
*        control_parameters = gw_contrl_para
*        output_options     = gw_output_opts
*        gv_postinv         = gv_postinv      "for post-shipment no.
*        gv_postdt          = gv_postdt       "for post-shipment dt
*      importing
**       document_output_info =
*        job_output_info    = gt_otf_data
**       job_output_options =
*      tables
*        gt_vbak            = gt_vbak[]
*        gt_vbap            = gt_vbap[]
*        gt_kna1            = gt_kna1[]
*        gt_fdata           = gt_fdata[]
*        gt_promo_mat       = gt_promo_mat[]
*        gt_zpreship        = gt_zpreship[]
*        gt_adrc            = gt_adrc[]
*      exceptions
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        others             = 5.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*
*    endif.
*  endif.

*  if p_paclst = gc_true.      "packing list print    " commented by ps 1243
*    clear fm_name.
*    call function 'SSF_FUNCTION_MODULE_NAME'
*      exporting
*        formname = gc_fm_pack_list
*      importing
*        fm_name  = fm_name.
*
*    gw_output_opts-tdnoprev = gc_true.
*    gw_output_opts-tddest    = 'LOCL'.
*    gw_output_opts-tdnoprint = gc_true.
*
*    gw_contrl_para-getotf = gc_true.
*    gw_contrl_para-no_dialog = gc_true.
*    gw_contrl_para-preview = space.
*
*    call function fm_name
*      exporting
*        control_parameters = gw_contrl_para
*        output_options     = gw_output_opts
*        gv_postinv         = gv_postinv
*        gv_postdt          = gv_postdt
*      importing
**       document_output_info =
*        job_output_info    = gt_otf_data
**       job_output_options =
*      tables
*        gt_vbak            = gt_vbak[]
*        gt_vbap            = gt_vbap[]
*        gt_kna1            = gt_kna1[]
*        gt_fdata           = gt_fdata[]
*        gt_promo_mat       = gt_promo_mat[]
*        gt_zpreship        = gt_zpreship[]
*        gt_adrc            = gt_adrc[]
*      exceptions
*        formatting_error   = 1
*        internal_error     = 2
*        send_error         = 3
*        user_canceled      = 4
*        others             = 5.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*
*    endif.
*  endif.

  gt_otf[] = gt_otf_data-otfdata[].

  call function 'CONVERT_OTF'
    exporting
      format                = 'PDF'
    importing
      bin_filesize          = gv_bin_filesize
      bin_file              = gv_bin_xstr
    tables
      otf                   = gt_otf[]
      lines                 = gt_tline[]
    exceptions
      err_max_linewidth     = 1
      err_format            = 2
      err_conv_not_possible = 3
      others                = 4.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  SEND_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form send_email .
  data : lv_atta_sub type so_obj_des,
         lv_emailid  type ad_smtpadr.
***Xstring to binary
  call function 'SCMS_XSTRING_TO_BINARY'
    exporting
      buffer     = gv_bin_xstr
    tables
      binary_tab = gt_pdf_data.

  try.
*     -------- create persistent send request ------------------------
      lo_bcs = cl_bcs=>create_persistent( ).

****  email body
      concatenate 'This eMail is meant for information only. Please DO NOT REPLY.' cl_abap_char_utilities=>newline into gv_text.
      append gv_text to gt_text.
      clear gv_text.
      clear gv_text.
      concatenate cl_abap_char_utilities=>newline gv_text into gv_text.
      concatenate cl_abap_char_utilities=>newline gv_text into gv_text.
      append ' BLUE CROSS LABORATORIES PRIVATE LTD.' to gt_text.

****Add the email body content to document
      clear : gv_text, gv_subject.
*****      CONCATENATE sy-datum+6(2) sy-datum+4(2) sy-datum+0(4) INTO gv_text SEPARATED BY '.'.
      gv_text = p_zexp.
      if p_prdord = gc_true.
        concatenate 'Export Order' gv_text into gv_subject separated by space.
      elseif p_proinv = gc_true.
        concatenate 'Proforma Invoice' gv_text into gv_subject separated by space.
*      elseif p_preshp = gc_true.
*        concatenate 'Pre/Post shipment'  gv_text into gv_subject separated by space.
*      elseif p_paclst = gc_true.
*        concatenate 'Pre/Post packing list'  gv_text into gv_subject separated by space.
      endif.
      lo_doc_bcs = cl_document_bcs=>create_document(
                     i_type    = 'RAW'
                     i_text    = gt_text[]
                     i_length  = '12'
                     i_subject = gv_subject ).   "Subject of the Email

***     Add attachment to document and Add document to send request
***The internal table gt_pdf_data[] contains the content of our attachment.
      clear lv_atta_sub.
      concatenate 'Order No.' p_zexp into lv_atta_sub separated by space.
      call method lo_doc_bcs->add_attachment
        exporting
          i_attachment_type    = 'PDF'
          i_attachment_size    = gv_bin_filesize
          i_attachment_subject = lv_atta_sub
          i_att_content_hex    = gt_pdf_data.

*     add document to send request
      call method lo_bcs->set_document( lo_doc_bcs ).

****    Set Sender
      if p_prdord = gc_true.
        lo_sender = cl_cam_address_bcs=>create_internet_address( i_address_string = gc_email_sender
                                                                 i_address_name = 'Export Order' ).
      endif.
      if p_proinv = gc_true.
        lo_sender = cl_cam_address_bcs=>create_internet_address( i_address_string = gc_email_sender
                                                         i_address_name = 'Proforma Invoice' ).
      endif.
*      if p_preshp = gc_true.
*        lo_sender = cl_cam_address_bcs=>create_internet_address( i_address_string = gc_email_sender
*                                                         i_address_name = 'Pre/Post shipment' ).
*      endif.
*      if p_paclst = gc_true.
*        lo_sender = cl_cam_address_bcs=>create_internet_address( i_address_string = gc_email_sender
*                                                         i_address_name = 'Pre/Post packing list' ).
*      endif.

      call method lo_bcs->set_sender
        exporting
          i_sender = lo_sender.

****    Add recipient (e–mail address) - TO
      loop at gt_mailid into gw_mailid where mail_to = gc_true.
        clear lv_emailid.
        lv_emailid = gw_mailid-zemail.
        lo_recep = cl_cam_address_bcs=>create_internet_address( lv_emailid  ).

        "Add recipient with its respective attributes to send request
        call method lo_bcs->add_recipient
          exporting
            i_recipient = lo_recep
            i_express   = gc_true.
      endloop.

****    Add recipient (e–mail address) - CC
      loop at gt_mailid into gw_mailid where mail_cc = gc_true.
        clear lv_emailid.
        lv_emailid = gw_mailid-zemail.
        lo_recep = cl_cam_address_bcs=>create_internet_address( lv_emailid ).

        "Add recipient with its respective attributes to send request
        call method lo_bcs->add_recipient
          exporting
            i_recipient = lo_recep
            i_express   = gc_true
            i_copy      = gc_true. "cc
      endloop.
****    Add recipient (e–mail address) - BCC
      loop at gt_mailid into gw_mailid where mail_bcc = gc_true.
        clear lv_emailid.
        lv_emailid = gw_mailid-zemail.
        lo_recep = cl_cam_address_bcs=>create_internet_address( lv_emailid ).

        "Add recipient with its respective attributes to send request
        call method lo_bcs->add_recipient
          exporting
            i_recipient  = lo_recep
            i_express    = gc_true
            i_blind_copy = gc_true. "bcc
      endloop.

****    Set Send Immediately
      call method lo_bcs->set_send_immediately
        exporting
          i_send_immediately = gc_true.

***Send the Email
      call method lo_bcs->send(
        exporting
          i_with_error_screen = gc_true
        receiving
          result              = gv_sent_to_all ).

      if gv_sent_to_all is not initial.
        commit work.
        message 'Email sent successfully' type 'S'.
      endif.

    catch cx_bcs into lo_cx_bcx.
      "Appropriate Exception Handling
      write: 'Exception:', lo_cx_bcx->error_type.
  endtry.
endform.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_data .

  if p_prdord = gc_true or p_proinv = gc_true.
***** get order header and item details
    if p_zexp is not initial.
      clear : gt_vbak[].
      select * from vbak into table @gt_vbak
         where vbeln = @p_zexp
*      and auart = 'Z002'.
        and auart in ('Z003','ZQT','Z004' ).
*        lv_auart =  'ZQT'.
*         lv_auart = 'Z004'.
*        or  auart = 'ZQT'
*        or auart = 'Z004'.
      if sy-subrc = 0.
        clear gt_vbap[].
        select * from vbap into table gt_vbap
        where vbeln = p_zexp.
        if sy-subrc = 0.
          sort gt_vbap by matnr.
*****      CLEAR gt_exp_mat[].
*****      SELECT * FROM zexp_ord_mat INTO TABLE gt_exp_mat
*****        FOR ALL ENTRIES IN gt_vbap
*****      WHERE matnr = gt_vbap-matnr.

          clear gt_marc[].
          select matnr werks zzregn_no zzpacksize from marc into table gt_marc
            for all entries in gt_vbap
          where matnr = gt_vbap-matnr
            and werks = gt_vbap-werks.

****** material master units
          clear gt_marm[].
          select matnr meinh umrez umren from marm into table gt_marm
            for all entries in gt_vbap
          where matnr = gt_vbap-matnr.

        endif.
*****  get sold-to-party details.
        clear gw_vbak.
        read table gt_vbak into gw_vbak index 1.
        clear gt_kna1[].
        select * from kna1 into table gt_kna1
        where kunnr = gw_vbak-kunnr.
        if sy-subrc = 0.
          clear gt_adrc[].
          select * from adrc into table gt_adrc
            for all entries in gt_kna1
            where addrnumber = gt_kna1-adrnr.
        endif.
      endif.
    else.
      message 'Pls enter export order no.' type 'S'.
    endif.
  endif.
******** select pre-shipment data ***************************************
*  if p_preshp = gc_true or p_paclst = gc_true.    " commented by ps 1586
*
*    if p_ship is not initial.
*      clear gt_zpreship[].
*      select * from zexport_preship into table gt_zpreship
*        where invnum = p_ship.
*      if sy-subrc <> 0. "if pre-shipment not found i.e.entered no.at input is post-shipment.
********  get post-shipment
*        clear gt_zpostshp1[].
*        select * from zexport_post1 into table gt_zpostshp1
*          where postnum = p_ship.
*        if sy-subrc = 0.
*          sort gt_zpostshp1 by postnum vbeln.
*          clear gt_zpostshp2[].
*          select * from zexport_post2 into table gt_zpostshp2
*            for all entries in gt_zpostshp1
*            where gjahr = gt_zpostshp1-gjahr
*            and vbeln = gt_zpostshp1-vbeln
*            and postnum = gt_zpostshp1-postnum.
*          if sy-subrc = 0.
*            sort gt_zpostshp2 by postnum vbeln.
******* get preshipments
*            clear gt_zpreship[].
*            select * from zexport_preship into table gt_zpreship
*              for all entries in gt_zpostshp2
*              where invnum = gt_zpostshp2-invnum
*              and vbelv = gt_zpostshp2-vbelv.
*          endif.
******  get invoice no.and date to get printed in layout.
*          read table gt_zpostshp1 into gw_zpostshp1 with key postnum = p_ship.
*          if sy-subrc = 0.
*            clear: gv_postinv, gv_postdt.
*            gv_postinv = gw_zpostshp1-postnum.
*            read table gt_zpostshp2 into gw_zpostshp2 with key postnum = gw_zpostshp1-postnum.
*            if sy-subrc = 0.
*              gv_postdt = gw_zpostshp2-zbl_dt.
*            endif.
*          endif.
*        endif.
*      endif.
*      if gt_zpreship[] is not initial.
*        sort gt_zpreship by vbelv.
*        clear : gt_vbak[].
*        select * from vbak into table gt_vbak
*          for all entries in gt_zpreship
*          where vbeln = gt_zpreship-vbelv.
*        if sy-subrc = 0.
******  get sold-to-party details.
*          clear gw_vbak.
*          read table gt_vbak into gw_vbak index 1.
*          clear gt_kna1[].
*          select * from kna1 into table gt_kna1
*          where kunnr = gw_vbak-kunnr.
*          if sy-subrc = 0.
*            clear gt_adrc[].
*            select * from adrc into table gt_adrc
*              for all entries in gt_kna1
*              where addrnumber = gt_kna1-adrnr.
*          endif.
*        endif.
*
******* get promotional materials, if any
*        clear gt_promo_mat[].
*        select * from zexp_promo_mat into table gt_promo_mat
*          for all entries in gt_zpreship
*        where vbeln = gt_zpreship-vbelv. "based on export order
*        if sy-subrc <> 0.  "if not availble then check if any based on delivery i.e.only applicable on pre/post shipments and not PFI
*          select * from zexp_promo_mat into table gt_promo_mat
*            for all entries in gt_zpreship
*          where vbeln = gt_zpreship-vbeln."based on delivery
*        endif.
*
*        clear gt_vbap[].
*        select * from vbap into table gt_vbap
*          for all entries in gt_zpreship
*          where vbeln = gt_zpreship-vbelv.
****** select delivery details
*        clear gt_likp[].
*        select * from likp into table gt_likp
*          for all entries in gt_zpreship
*          where vbeln = gt_zpreship-vbeln.
*        if sy-subrc = 0.
*          sort gt_likp by vbeln.
*          clear gt_lips[].
*          select * from lips into table gt_lips
*            for all entries in gt_likp
*            where vbeln = gt_likp-vbeln
*            and lfimg <> '0.00'.
*          if sy-subrc = 0.
*            sort gt_lips by matnr.
*            clear gt_marc[].
*            select matnr werks zzregn_no zzpacksize from marc into table gt_marc
*              for all entries in gt_lips
*            where matnr = gt_lips-matnr
*              and werks = gt_lips-werks.
*
**********  select for proforma inv with accounting ref.delivery
*            sort gt_lips by vbeln posnr.
*            clear gt_vbfa[].
*            select * from vbfa into table gt_vbfa
*              for all entries in gt_lips
*              where vbelv = gt_lips-vbeln
*              and posnv = gt_lips-posnr
*              and vbtyp_n in ('U' , 'M')
*              and rfmng <> '0.00'.
*          endif.
*        endif.
*      endif.
*    else.
*      message 'Pls enter pre/post shipment no.' type 'S'.
*    endif.
*  endif.
  if p_rad2 = gc_true.
***** get location-wise mail ids
    sort gt_vbap by werks.
    clear gt_mailid[].
    select * from zexp_ord_mailid into table gt_mailid
      for all entries in gt_vbap
    where werks = gt_vbap-werks.
    if sy-subrc = 0.
      sort gt_mailid by werks.
    endif.

  elseif p_rad22 = gc_true.
***** get location-wise mail ids
    clear gt_mailid[].
    select * from zexp_ord_mailid into table gt_mailid
    where werks = '3000'.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_FDATA_PROFORMA_INV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form prepare_fdata_proforma_inv .

  types : begin of ty_stpo,
            stlnr type stnum,
            idnrk type idnrk,
          end of ty_stpo,

          begin of ty_mara,
            matnr type matnr,
            mtart type mtart,
            meins type meins,
          end of ty_mara,
          begin of ty_mast,
            matnr type matnr,
            stlnr type stnum,
          end of ty_mast.

  data : lv_psize      type string,
         lv_umren      type umren,
         lv_umren_char type string,
         lt_mast       type table of ty_mast,
         lw_mast       type ty_mast,
         lt_stpo       type table of ty_stpo,
         lw_stpo       type ty_stpo,
         lt_mara       type table of ty_mara,
         lw_mara       type ty_mara,
         lv_matnr      type matnr,
         lv_qty_unit   type zval_dec0,
         lv_rate       type p decimals 2,
         lv_name       type tdobname,
         lt_makt       type table of makt,
         lw_makt       type makt.

  data : lt_line like tline occurs 0 with header line.

  sort gt_vbak by vbeln.
  sort gt_vbap by pstyv matnr posnr.

  if gt_vbap[] is not initial.
*****    SORT GT_VBAP BY PSTYV.
*********** if material unit is KG - check for BOM against material for base unit.
*****    CLEAR LT_MAST[].
*****    SELECT MATNR STLNR FROM MAST INTO TABLE LT_MAST
*****      FOR ALL ENTRIES IN GT_VBAP
*****    WHERE MATNR = GT_VBAP-MATNR.
*****    IF SY-SUBRC = 0.
*****      SORT LT_MAST BY STLNR.
*****      CLEAR LT_STPO[].
*****      SELECT STLNR IDNRK FROM STPO INTO TABLE LT_STPO
*****        FOR ALL ENTRIES IN LT_MAST
*****      WHERE STLNR = LT_MAST-STLNR.
*****      IF SY-SUBRC = 0.
*****        SORT LT_STPO BY IDNRK.
*****        CLEAR LT_MARA[].
*****        SELECT MATNR MTART MEINS FROM MARA INTO TABLE LT_MARA
*****          FOR ALL ENTRIES IN LT_STPO
*****          WHERE MATNR = LT_STPO-IDNRK
*****          AND MTART = 'ZHLB'
*****        AND MEINS <> 'KG'.
*****      ENDIF.
*****    ENDIF.


****** also take it from material master for other units
    clear gt_marm[].
    select matnr meinh umrez umren from marm into table gt_marm
      for all entries in gt_vbap
    where matnr = gt_vbap-matnr.

****** for material desc.
    clear lt_makt[].
    select * from makt into table lt_makt
      for all entries in gt_vbap
      where matnr = gt_vbap-matnr
      and spras = sy-langu.
  endif.


  clear gt_fdata[].
  loop at gt_vbap into gw_vbap.

*****  for unit/packsize wise qty.
    clear lv_qty_unit.
    lv_qty_unit = 1.

    gw_fdata-vbeln = gw_vbap-vbeln.
    gw_fdata-posnr = gw_vbap-posnr.
    gw_fdata-matnr = gw_vbap-matnr.
*****    GW_FDATA-ARKTX = GW_VBAP-ARKTX.
    clear lw_makt.
    read table lt_makt into lw_makt with key matnr = gw_vbap-matnr.
    if sy-subrc = 0.
      gw_fdata-arktx = lw_makt-maktx.
    endif.
**** check for material master - basic data text - for material desc.
    clear lv_name.
    lv_name = gw_vbap-matnr.
    call function 'READ_TEXT'
      exporting
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = sy-langu
        name                    = lv_name
        object                  = 'MATERIAL'
      tables
        lines                   = lt_line[]
      exceptions
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        others                  = 8.
    if sy-subrc = 0.
      read table lt_line index 1.
      if sy-subrc = 0.
        if lt_line-tdline <> ' '.
          gw_fdata-arktx = lt_line-tdline. "replace mat.desc, if available
        endif.
      endif.
    endif.

    gw_fdata-mvgr5 = gw_vbap-mvgr5.
    gw_fdata-werks = gw_vbap-werks.
*****  mat regn.no.
    clear gw_marc.
    read table gt_marc into gw_marc with key matnr = gw_vbap-matnr werks = gw_vbap-werks.
    if sy-subrc = 0.
      gw_fdata-zmat_regn_no = gw_marc-zzregn_no.
*****      gw_fdata-zpacksize = gw_marc-zzpacksize.
    endif.
*****  get for Unit of material
    read table gt_marm into gw_marm with key matnr = gw_fdata-matnr.
    if sy-subrc = 0.
      gw_fdata-pstyv =  gw_marm-meinh.
    endif.

***** packsize as per units in mat.master
    select single bezei from tvm5t into gw_fdata-bezei
  where spras = sy-langu
    and mvgr5 = gw_vbap-mvgr5.

***** packsize considering units.
    case gw_vbap-mvgr1.
      when 'TAB' or 'CAP'.
        clear gw_marm.
        read table gt_marm into gw_marm with key matnr = gw_vbap-matnr meinh = 'STP'.
        if sy-subrc = 0.
          clear: lv_psize, lv_umren.
          lv_umren = gw_marm-umrez  / gw_marm-umren.
          lv_psize = lv_umren.
*****          IF LV_UMREN <> 1.
          concatenate lv_psize gw_fdata-bezei  into gw_fdata-bezei  separated by 'X '.
*****          ENDIF.
*************   for qty.in unit (like BOX,BTL etc)
          lv_qty_unit = lv_qty_unit * lv_umren.
        endif.
        read table gt_marm into gw_marm with key matnr = gw_vbap-matnr meinh = 'BOX'.
        if sy-subrc = 0.
          clear: lv_psize, lv_umren.
          lv_umren = gw_marm-umrez  / gw_marm-umren.
          lv_psize = lv_umren.
*****          IF LV_UMREN <> 1.
          concatenate lv_psize gw_fdata-bezei  into gw_fdata-bezei  separated by 'X '.
*****          ENDIF.
*************   for qty.in unit (like BOX,BTL etc)
          lv_qty_unit = lv_qty_unit * lv_umren.
        endif.
      when 'GEL' or 'LIQ'.
        clear gw_marm.
        read table gt_marm into gw_marm with key matnr = gw_vbap-matnr meinh = gw_vbap-meins."i.e.'EA'.
        if sy-subrc = 0.
          clear: lv_psize, lv_umren.
          lv_umren = gw_marm-umrez  / gw_marm-umren.
          lv_psize = lv_umren.
          if lv_umren <> 1.
            concatenate lv_psize gw_fdata-bezei  into gw_fdata-bezei  separated by 'X '.
          endif.
*************   for qty.in unit (like BOX,BTL etc)
          lv_qty_unit = lv_qty_unit * lv_umren.
        endif.
      when others.
        read table gt_marm into gw_marm with key matnr = gw_fdata-matnr meinh = gw_fdata-pstyv.
        if sy-subrc = 0.
          lv_umren = gw_marm-umrez /  gw_marm-umren.
          lv_psize = lv_umren.
          if lv_umren <> 1.
            if gw_fdata-pstyv = 'AMP' and gw_vbap-mvgr1 = 'INJ'.
              lv_umren_char = lv_umren.
              concatenate lv_umren_char gw_fdata-pstyv into lv_psize separated by space.
              concatenate lv_psize gw_fdata-bezei into gw_fdata-bezei  separated by ' X '.
            else.
              concatenate lv_psize gw_fdata-bezei into gw_fdata-bezei  separated by 'X '.
            endif.
          endif.
********   for qty.in unit (like BOX,BTL etc)
          lv_qty_unit = lv_qty_unit * lv_umren.
        endif.
    endcase.
***** packsize
    gw_fdata-zpacksize = gw_fdata-bezei.

*****    CLEAR LW_MAST.
*****    READ TABLE LT_MAST INTO LW_MAST WITH KEY MATNR = GW_FDATA-MATNR.
*****    IF SY-SUBRC = 0.
*****      CLEAR LW_STPO.
*****      LOOP AT LT_STPO INTO LW_STPO WHERE STLNR = LW_MAST-STLNR.
*****        CLEAR LW_MARA.
*****        READ TABLE LT_MARA INTO LW_MARA WITH KEY MATNR = LW_STPO-IDNRK.
*****        IF SY-SUBRC = 0.
*****          CLEAR: LV_PSIZE, LV_UMREN.
*****          READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'STP'."'EA'.
*****          IF SY-SUBRC = 0.
*****            LV_UMREN = GW_MARM-UMREZ  / GW_MARM-UMREN.
*****            LV_PSIZE = LV_UMREN.
*****            IF LV_UMREN <> 1.
*****              CONCATENATE LV_PSIZE GW_FDATA-BEZEI  INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****            ENDIF.
*************   for qty.in unit (like BOX,BTL etc)
*****            LV_QTY_UNIT = LV_QTY_UNIT * LV_UMREN.
*****          ELSE.  "check if STP is not there i.e.for single strip
*****            CLEAR: LV_PSIZE, LV_UMREN.
*****            READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'EA'.
*****            IF SY-SUBRC = 0.
*****              LV_UMREN = GW_MARM-UMREZ  / GW_MARM-UMREN.
*****              LV_PSIZE = LV_UMREN.
*****              IF LV_UMREN <> 1.
*****                CONCATENATE LV_PSIZE GW_FDATA-BEZEI  INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****              ENDIF.
*************   for qty.in unit (like BOX,BTL etc)
*****              LV_QTY_UNIT = LV_QTY_UNIT * LV_UMREN.
*****            ENDIF.
*****          ENDIF.
*****          READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = GW_FDATA-PSTYV." 'BOX'.
*****          IF SY-SUBRC = 0.
*****            LV_UMREN = GW_MARM-UMREZ /  GW_MARM-UMREN.
*****            LV_PSIZE = LV_UMREN.
*****            CONCATENATE LV_PSIZE GW_FDATA-BEZEI INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*************   for qty.in unit (like BOX,BTL etc)
*****            LV_QTY_UNIT = LV_QTY_UNIT * LV_UMREN.
*****          ENDIF.
*****        ENDIF.
*****      ENDLOOP.
***** ELSE.   " if BOM is not available then consider unit EA for packsize
*****        CLEAR: LV_PSIZE, LV_UMREN.
*****         READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'EA'.
*****            IF SY-SUBRC = 0.
*****              LV_UMREN = GW_MARM-UMREZ  / GW_MARM-UMREN.
*****              LV_PSIZE = LV_UMREN.
*****              CONCATENATE LV_PSIZE GW_FDATA-BEZEI  INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****
*****              GW_FDATA-ZPACKSIZE = GW_FDATA-BEZEI.
*****              MODIFY GT_FDATA FROM GW_FDATA TRANSPORTING BEZEI ZPACKSIZE.
*****              CLEAR GW_FDATA.
*****            ENDIF.
*****    ENDIF.

    clear lv_matnr.
    call function 'CONVERSION_EXIT_MATN1_OUTPUT'
      exporting
        input  = gw_vbap-matnr
      importing
        output = lv_matnr.
****** for Bbonus material qty
*    if lv_matnr+0(1) <> '9' and gw_vbap-pstyv = 'ZANN'OR gw_vbap-pstyv = 'TANN'."OR'TANN' commented .
******      gw_fdata-bons_qty = gw_vbap-kwmeng.
*********   for qty.in unit (like BOX,BTL etc)
*      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
*        gw_fdata-bons_qty = gw_vbap-kwmeng / lv_qty_unit.
*      endcatch.
*    endif.
*
****** For Sample materials qty
*   if lv_matnr+0(1) = '9' and gw_vbap-pstyv = 'ZANN'OR gw_vbap-pstyv ='TANN' ."OR'TANN'." TANN CHNGE
*      gw_fdata-samp_qty = gw_vbap-kwmeng.
*    endif.
*
*    collect   gw_fdata into gt_fdata.

***** For Sales materials Qty
    if lv_matnr+0(1) <> '9' and gw_vbap-pstyv = 'ZGN'."'TAN'." OR'TAN' commented. ZTAN REPLCE BT ZANN1
********   for qty.in unit (like BOX,BTL etc)
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gw_fdata-sale_qty = gw_vbap-kwmeng / lv_qty_unit.
      endcatch.
***** Amount USD
*****      gw_fdata-zamount = gw_vbap-netwr.
*********** 15.04.2025 - commented above for correction in rate calc. and added below
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gw_fdata-zamount = ( gw_vbap-netpr / gw_vbap-kpein ) *  gw_vbap-kwmeng.
      endcatch.
***** rate/BOX = quantity div by zamount
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
*****        gw_fdata-rate = gw_fdata-zamount / gw_fdata-sale_qty.
        clear lv_rate.
        lv_rate = gw_fdata-zamount / gw_fdata-sale_qty.
      endcatch.
      call function 'ROUND'
        exporting
          decimals      = 4
          input         = lv_rate
          sign          = '-'
        importing
          output        = gw_fdata-rate
        exceptions
          input_invalid = 1
          overflow      = 2
          type_invalid  = 3
          others        = 4.
    endif.
***** for Bbonus material qty
    if lv_matnr+0(1) <> '9' and gw_vbap-pstyv = 'ZANN'OR gw_vbap-pstyv = 'TANN'."OR'TANN' commented .
*****      gw_fdata-bons_qty = gw_vbap-kwmeng.
********   for qty.in unit (like BOX,BTL etc)
      catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
        gw_fdata-bons_qty = gw_vbap-kwmeng / lv_qty_unit.
      endcatch.
    endif.

***** For Sample materials qty
   if lv_matnr+0(1) = '9' and gw_vbap-pstyv = 'ZANN'OR gw_vbap-pstyv ='TANN' ."OR'TANN'." TANN CHNGE
      gw_fdata-samp_qty = gw_vbap-kwmeng.
    endif.

    collect   gw_fdata into gt_fdata.
    sort gt_fdata by POSNR.
****    append   gw_fdata to gt_fdata.
    clear gw_fdata.

  endloop.

****** get promotional materials, if any
  clear gt_promo_mat[].
  select * from zexp_promo_mat into table gt_promo_mat
  where vbeln = p_zexp.

endform.
*&---------------------------------------------------------------------*
*&      Form  PREPARE_FDATA_PRE_SHIPMENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form prepare_fdata_pre_shipment .
  types : begin of ty_stpo,
            stlnr type stnum,
            idnrk type idnrk,
          end of ty_stpo,

          begin of ty_mara,
            matnr type matnr,
            mtart type mtart,
            meins type meins,
          end of ty_mara,
          begin of ty_mast,
            matnr type matnr,
            stlnr type stnum,
          end of ty_mast.

  data : lv_psize      type string,
         lv_umren      type umren,
         lv_umren_char type string,
         lt_mast       type table of ty_mast,
         lw_mast       type ty_mast,
         lt_stpo       type table of ty_stpo,
         lw_stpo       type ty_stpo,
         lt_mara       type table of ty_mara,
         lw_mara       type ty_mara,
         lv_matnr      type matnr,
         lv_qty_unit   type zval_dec0,
         lv_rate       type p decimals 2,
         lt_makt       type table of makt,
         lw_makt       type makt,
         lt_lips       type table of lips,
         lw_lips       type lips.

  sort gt_vbak by vbeln.
  sort gt_vbap by pstyv matnr posnr.
  sort gt_lips by vgbel pstyv matnr vgpos.

  if gt_vbap[] is not initial.
*****    SORT GT_VBAP BY PSTYV.
*********** if material unit is KG - check for BOM against material for base unit.
*****    CLEAR LT_MAST[].
*****    SELECT MATNR STLNR FROM MAST INTO TABLE LT_MAST
*****      FOR ALL ENTRIES IN GT_VBAP
*****    WHERE MATNR = GT_VBAP-MATNR.
*****    IF SY-SUBRC = 0.
*****      SORT LT_MAST BY STLNR.
*****      CLEAR LT_STPO[].
*****      SELECT STLNR IDNRK FROM STPO INTO TABLE LT_STPO
*****        FOR ALL ENTRIES IN LT_MAST
*****      WHERE STLNR = LT_MAST-STLNR.
*****      IF SY-SUBRC = 0.
*****        SORT LT_STPO BY IDNRK.
*****        CLEAR LT_MARA[].
*****        SELECT MATNR MTART MEINS FROM MARA INTO TABLE LT_MARA
*****          FOR ALL ENTRIES IN LT_STPO
*****          WHERE MATNR = LT_STPO-IDNRK
*****          AND MTART = 'ZHLB'
*****        AND MEINS <> 'KG'.
*****      ENDIF.
*****    ENDIF.


****** also take it from material master for other units
    clear gt_marm[].
    select matnr meinh umrez umren from marm into table gt_marm
      for all entries in gt_vbap
    where matnr = gt_vbap-matnr.
*****      for material desc.
    clear lt_makt[].
    select * from makt into table lt_makt
      for all entries in gt_vbap
      where matnr = gt_vbap-matnr
      and spras = sy-langu.
  endif.
******  collect qty for similar materials of same deliv./order to avoid rate duplicacy
  if gt_lips[] is not initial.
    loop at gt_lips into gw_lips.
*****      lw_lips-vbeln = gw_lips-vbeln.       "commenting to avoid double rate when multiple deliveries against one order.
      lw_lips-vgbel = gw_lips-vgbel.  "for same order
      lw_lips-vgpos = gw_lips-vgpos.  "for same order item.no
      lw_lips-matnr = gw_lips-matnr.  "for same materials
      lw_lips-matwa = gw_lips-matwa.
      lw_lips-matkl = gw_lips-matkl.
      lw_lips-mvgr1 = gw_lips-mvgr5.
      lw_lips-mvgr2 = gw_lips-mvgr5.
      lw_lips-mvgr3 = gw_lips-mvgr5.
      lw_lips-mvgr4 = gw_lips-mvgr5.
      lw_lips-mvgr5 = gw_lips-mvgr5.
      lw_lips-werks = gw_lips-werks.
      lw_lips-pstyv = gw_lips-pstyv.
      lw_lips-lfimg = gw_lips-lfimg.
      lw_lips-meins = gw_lips-meins.
      lw_lips-vrkme = gw_lips-vrkme.
      lw_lips-umvkz = gw_lips-umvkz.
      lw_lips-umvkn = gw_lips-umvkn.
      lw_lips-ntgew = gw_lips-ntgew.
      lw_lips-brgew = gw_lips-brgew.
      lw_lips-gewei = gw_lips-gewei.
      lw_lips-volum = gw_lips-volum.
      lw_lips-voleh = gw_lips-voleh.
      lw_lips-kztlf = gw_lips-kztlf.
      lw_lips-lgmng = gw_lips-lgmng.
      lw_lips-arktx = gw_lips-arktx.
      lw_lips-vbelv = gw_lips-vbelv.
      lw_lips-posnv = gw_lips-posnv.
      lw_lips-vbtyv = gw_lips-vbtyv.
      lw_lips-vkgrp = gw_lips-vkgrp.
      lw_lips-vtweg = gw_lips-vtweg.
      lw_lips-spart = gw_lips-spart.

      collect lw_lips into lt_lips.
      clear lw_lips.
    endloop.
    if lt_lips[] is not initial.
      clear gt_lips[].
      gt_lips[] = lt_lips[].
    endif.
  endif.

  clear gt_fdata[].

  loop at gt_vbap into gw_vbap.
    loop at gt_lips into gw_lips where vgbel = gw_vbap-vbeln and vgpos = gw_vbap-posnr.

      clear lv_qty_unit.
      lv_qty_unit = 1.
      gw_fdata-vbeln = gw_vbap-vbeln.
      gw_fdata-posnr = gw_vbap-posnr.
      gw_fdata-matnr = gw_lips-matnr.
****      gw_fdata-arktx = gw_vbap-arktx. "GW_LIPS-ARKTX.
      clear lw_makt.
      read table lt_makt into lw_makt with key matnr = gw_vbap-matnr.
      if sy-subrc = 0.
        gw_fdata-arktx = lw_makt-maktx.
      endif.
      gw_fdata-mvgr5 = gw_lips-mvgr5.
      gw_fdata-werks = gw_lips-werks.
*****  mat regn.no.
      clear gw_marc.
      read table gt_marc into gw_marc with key matnr = gw_lips-matnr werks = gw_lips-werks.
      if sy-subrc = 0.
        gw_fdata-zmat_regn_no = gw_marc-zzregn_no.
*****      gw_fdata-zpacksize = gw_marc-zzpacksize.
      endif.
*****  get for Unit of material
      read table gt_marm into gw_marm with key matnr = gw_fdata-matnr.
      if sy-subrc = 0.
        gw_fdata-pstyv =  gw_marm-meinh.
      endif.

***** packsize as per units in mat.master
      select single bezei from tvm5t into gw_fdata-bezei
    where spras = sy-langu
      and mvgr5 = gw_lips-mvgr5.

***** packsize
      case gw_vbap-mvgr1.
        when 'TAB' or 'CAP'.
          clear gw_marm.
          read table gt_marm into gw_marm with key matnr = gw_vbap-matnr meinh = 'STP'.
          if sy-subrc = 0.
            clear: lv_psize, lv_umren.
            lv_umren = gw_marm-umrez  / gw_marm-umren.
            lv_psize = lv_umren.
*****            IF LV_UMREN <> 1.
            concatenate lv_psize gw_fdata-bezei  into gw_fdata-bezei  separated by 'X '.
*****            ENDIF.
*************   for qty.in unit (like BOX,BTL etc)
            lv_qty_unit = lv_qty_unit * lv_umren.
          endif.
          read table gt_marm into gw_marm with key matnr = gw_vbap-matnr meinh = 'BOX'.
          if sy-subrc = 0.
            clear: lv_psize, lv_umren.
            lv_umren = gw_marm-umrez  / gw_marm-umren.
            lv_psize = lv_umren.
*****            IF LV_UMREN <> 1.
            concatenate lv_psize gw_fdata-bezei  into gw_fdata-bezei  separated by 'X '.
*****            ENDIF.
*************   for qty.in unit (like BOX,BTL etc)
            lv_qty_unit = lv_qty_unit * lv_umren.
          endif.
        when others.
          read table gt_marm into gw_marm with key matnr = gw_fdata-matnr meinh = gw_fdata-pstyv.
          if sy-subrc = 0.
            lv_umren = gw_marm-umrez /  gw_marm-umren.
            lv_psize = lv_umren.
            if lv_umren <> 1.
              if gw_fdata-pstyv = 'AMP' and gw_vbap-mvgr1 = 'INJ'.
                lv_umren_char = lv_umren.
                concatenate lv_umren_char gw_fdata-pstyv into lv_psize separated by space.
                concatenate lv_psize gw_fdata-bezei into gw_fdata-bezei  separated by ' X '.
              else.
                concatenate lv_psize gw_fdata-bezei into gw_fdata-bezei  separated by 'X '.
              endif.
            endif.
********   for qty.in unit (like BOX,BTL etc)
            lv_qty_unit = lv_qty_unit * lv_umren.
          endif.
      endcase.
      gw_fdata-zpacksize = gw_fdata-bezei.

*****      CLEAR LW_MAST.
*****      READ TABLE LT_MAST INTO LW_MAST WITH KEY MATNR = GW_FDATA-MATNR.
*****      IF SY-SUBRC = 0.
*****        CLEAR LW_STPO.
*****        LOOP AT LT_STPO INTO LW_STPO WHERE STLNR = LW_MAST-STLNR.
*****          CLEAR LW_MARA.
*****          READ TABLE LT_MARA INTO LW_MARA WITH KEY MATNR = LW_STPO-IDNRK.
*****          IF SY-SUBRC = 0.
*****            CLEAR: LV_PSIZE, LV_UMREN.
*****            READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'STP'."'EA'.
*****            IF SY-SUBRC = 0.
*****              LV_UMREN = GW_MARM-UMREZ  / GW_MARM-UMREN.
*****              LV_PSIZE = LV_UMREN.
*****              IF LV_UMREN <> 1.
*****                CONCATENATE LV_PSIZE GW_FDATA-BEZEI  INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****              ENDIF.
*************   for qty.in unit (like BOX,BTL etc)
*****              LV_QTY_UNIT = LV_QTY_UNIT * LV_UMREN.
*****            ELSE.
*****              CLEAR: LV_PSIZE, LV_UMREN.
*****              READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'EA'.
*****              IF SY-SUBRC = 0.
*****                LV_UMREN = GW_MARM-UMREZ  / GW_MARM-UMREN.
*****                LV_PSIZE = LV_UMREN.
*****                IF LV_UMREN <> 1.
*****                  CONCATENATE LV_PSIZE GW_FDATA-BEZEI  INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****                ENDIF.
*************   for qty.in unit (like BOX,BTL etc)
*****                LV_QTY_UNIT = LV_QTY_UNIT * LV_UMREN.
*****              ENDIF.
*****            ENDIF.
*****            READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = GW_FDATA-PSTYV." 'BOX'.
*****            IF SY-SUBRC = 0.
*****              LV_UMREN = GW_MARM-UMREZ /  GW_MARM-UMREN.
*****              LV_PSIZE = LV_UMREN.
*****              CONCATENATE LV_PSIZE GW_FDATA-BEZEI INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*************   for qty.in unit (like BOX,BTL etc)
*****              LV_QTY_UNIT = LV_QTY_UNIT * LV_UMREN.
*****            ENDIF.
*****          ENDIF.
*****        ENDLOOP.
***** ELSE.   " if BOM is not available then consider unit EA for packsize
*****        CLEAR: LV_PSIZE, LV_UMREN.
*****         READ TABLE GT_MARM INTO GW_MARM WITH KEY MATNR = GW_FDATA-MATNR MEINH = 'EA'.
*****            IF SY-SUBRC = 0.
*****              LV_UMREN = GW_MARM-UMREZ  / GW_MARM-UMREN.
*****              LV_PSIZE = LV_UMREN.
*****              CONCATENATE LV_PSIZE GW_FDATA-BEZEI  INTO GW_FDATA-BEZEI  SEPARATED BY 'X '.
*****
*****              GW_FDATA-ZPACKSIZE = GW_FDATA-BEZEI.
*****              MODIFY GT_FDATA FROM GW_FDATA TRANSPORTING BEZEI ZPACKSIZE.
*****              CLEAR GW_FDATA.
*****            ENDIF.
*****      ENDIF.

      clear lv_matnr.
      call function 'CONVERSION_EXIT_MATN1_OUTPUT'
        exporting
          input  = gw_lips-matnr
        importing
          output = lv_matnr.

***** For Sales materials Qty
      if lv_matnr+0(1) <> '9' and gw_lips-pstyv = 'ZGN'."ZAN1 REPLCE BY PS ZTAN1
********   for qty.in unit (like BOX,BTL etc)
        catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
          gw_fdata-sale_qty = gw_lips-lfimg / lv_qty_unit.
          clear lv_qty_unit.
          lv_qty_unit = 1.
        endcatch.
***** Amount USD
*******        gw_fdata-zamount = gw_vbap-netwr.
*********** BCDK936517 - 25.03.2025 - commented above for correction in rate calc. and added below
        catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
          gw_fdata-zamount = ( gw_vbap-netpr / gw_vbap-kpein ) *  gw_lips-lfimg.
        endcatch.
***** rate/BOX = quantity div by zamount
        catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
*****          gw_fdata-rate = gw_fdata-zamount / gw_fdata-sale_qty.
          clear lv_rate.
          lv_rate = gw_fdata-zamount / gw_fdata-sale_qty.
        endcatch.
        call function 'ROUND'
          exporting
            decimals      = 4
            input         = lv_rate
            sign          = '-'
          importing
            output        = gw_fdata-rate
          exceptions
            input_invalid = 1
            overflow      = 2
            type_invalid  = 3
            others        = 4.

      endif.
***** for Bbonus material qty
      if lv_matnr+0(1) <> '9' and gw_lips-pstyv = 'ZANN' OR gw_lips-pstyv ='TANN'.
*****        gw_fdata-bons_qty = gw_lips-lfimg.
********   for qty.in unit (like BOX,BTL etc)
        catch system-exceptions conversion_errors = 1 arithmetic_errors = 5.
          gw_fdata-bons_qty = gw_lips-lfimg / lv_qty_unit.
          clear lv_qty_unit.
          lv_qty_unit = 1.
        endcatch.
      endif.

***** For Sample materials qty
      if lv_matnr+0(1) = '9' and gw_lips-pstyv = 'ZANN'OR gw_lips-pstyv = 'TANN'.
        gw_fdata-samp_qty = gw_lips-lfimg.
      endif.

      collect   gw_fdata into gt_fdata.
      clear gw_fdata.
    endloop.
  endloop.

endform.
*&---------------------------------------------------------------------*
*&      Form  GET_P_SHIP_F4
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_SHIP  text
*----------------------------------------------------------------------*
form get_p_ship_f4  using p_ship type char20.
  data:
    lt_values type standard table of t003o,
    lt_return type standard table of ddshretval.

  clear gt_shp_f4[].
  select a~vbeln a~vbelv a~invnum  a~cpudt a~uname
         b~gjahr b~vbeln b~postnum b~cpudt b~uname into table gt_shp_f4[]
    from zexport_preship as a
    left outer join zexport_post2 as b
    on a~vbelv = b~vbelv.


  call function 'F4IF_INT_TABLE_VALUE_REQUEST'
    exporting
      retfield        = 'INVNUM'    " Name of field in VALUE_TAB
      value_org       = 'S'        " Value return: C: cell by cell, S: structured
    tables
      value_tab       = gt_shp_f4  " Table of values: entries cell by cell
      return_tab      = lt_return  " Return the selected value
    exceptions
      parameter_error = 1          " Incorrect parameter
      no_values_found = 2          " No values found
      others          = 3.

  if sy-subrc ne 0.
    return.
  endif.

  read table lt_return into data(ls_return) index 1.
  p_ship = ls_return-fieldval.

endform.
*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_9000 output.
  data lv_url type char255.

  set pf-status 'ST_9000'.
  set titlebar 'T001'.

  create object g_html_container
    exporting
      container_name = 'PDF'.

  create object g_html_control
    exporting
      parent = g_html_container.
* Convert xstring to binary table to pass to the LOAD_DATA method
***Xstring to binary
  call function 'SCMS_XSTRING_TO_BINARY'
    exporting
      buffer     = gv_bin_xstr
    tables
      binary_tab = gt_pdf_data.

* Load the HTML
  call method g_html_control->load_data(
    exporting
      type                 = 'application' "'text' " 'application'
      subtype              = 'PDF' "'html'  "'pdf'
    importing
      assigned_url         = lv_url
    changing
      data_table           = gt_pdf_data "i_html "LT_DATA
    exceptions
      dp_invalid_parameter = 1
      dp_error_general     = 2
      cntl_error           = 3
      others               = 4 ).

* Show it
  call method g_html_control->show_url(
      url      = lv_url
      in_place = 'X' ).
endmodule.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_9000 input.
  clear ok_code.

  ok_code = sy-ucomm.
  case ok_code.
    when 'BACK'.
      leave to screen 0.
    when 'CANCEL'.
      leave program.
    when 'EXIT'.
      leave program.
  endcase.
endmodule.
