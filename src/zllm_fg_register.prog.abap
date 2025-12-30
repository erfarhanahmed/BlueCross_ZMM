*&---------------------------------------------------------------------*
*& Report  ZLLM_FG_REGISTER1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zllm_fg_register66_3 no standard page heading line-size 800.

tables : mkpf,mseg,mara,
         makt,lfa1,ekpo,
         adrc,t001w,rseg,
         bkpf, bset, zgstnum1,
         ekko,mvke, tvm5t,
         a602,konp.

type-pools:  slis.
data: it_dropdown type lvc_t_drop,
      ty_dropdown type lvc_s_drop,
*data declaration for refreshing of alv
      stable      type lvc_s_stbl.
*Global variable declaration
data: gstring type c.
*Data declarations for ALV
data: c_ccont   type ref to cl_gui_custom_container,         "Custom container object
      c_alvgd   type ref to cl_gui_alv_grid,         "ALV grid object
      it_fcat   type lvc_t_fcat,                  "Field catalogue
      it_layout type lvc_s_layo.                  "Layout
*ok code declaration
data:
  ok_code       type ui_func.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

data: it_mkpf             type table of mkpf,
      wa_mkpf             type mkpf,
      it_mseg             type table of mseg,
      wa_mseg             type mseg,
      it_mseg1            type table of mseg,
      wa_mseg1            type mseg,
      it_mseg2            type table of mseg,
      wa_mseg2            type mseg,
      it_mseg3            type table of mseg,
      wa_mseg3            type mseg,
      it_wb2_v_vbrk_vbrp2 type table of wb2_v_vbrk_vbrp2,
      wa_wb2_v_vbrk_vbrp2 type wb2_v_vbrk_vbrp2,
      it_rseg             type table of rseg,
      wa_rseg             type rseg,
      it_bset             type table of bset,
      wa_bset             type bset,
      it_likp             type table of likp,
      wa_likp             type likp.

types : begin of itab1,
          werks type mseg-werks,
          bwart type mseg-bwart,
          matnr type mseg-matnr,
          charg type mseg-charg,
          menge type mseg-menge,
          meins type mseg-meins,
          ebeln type mseg-ebeln,
          ebelp type mseg-ebelp,
          lifnr type mseg-lifnr,
          dmbtr type mseg-dmbtr,
        end of itab1.

types : begin of itab2,
          werks    type mseg-werks,
          bwart    type mseg-bwart,
          matnr    type mseg-matnr,
          charg    type mseg-charg,
          menge    type mseg-menge,
          meins    type mseg-meins,
          ebeln    type mseg-ebeln,
          ebelp    type mseg-ebelp,
          lifnr    type mseg-lifnr,
          name1    type lfa1-name1,
          dmbtr    type mseg-dmbtr,
          fkart    type wb2_v_vbrk_vbrp2-fkart,
          vbeln    type wb2_v_vbrk_vbrp2-vbeln,
          fkdat    type wb2_v_vbrk_vbrp2-fkdat,
          fkimg_i  type wb2_v_vbrk_vbrp2-fkimg_i,
          netwr_i  type wb2_v_vbrk_vbrp2-netwr_i,
          mwsbp_i  type wb2_v_vbrk_vbrp2-mwsbp_i,
          maktx    type makt-maktx,
          balqty   type p,
          recplant type t001w-werks,
          bezei    type tvm5t-bezei,
          opbal1   type p,
          balqty1  type p,
          stcd3    type  lfa1-stcd3,
          newmenge type p,
        end of itab2.

types : begin of grn1,
          mjahr type mseg-mjahr,
          mblnr type mseg-mblnr,
          werks type mseg-werks,
          bwart type mseg-bwart,
          matnr type mseg-matnr,
          charg type mseg-charg,
          menge type mseg-menge,
          meins type mseg-meins,
          lgort type mseg-lgort,
          ebeln type mseg-ebeln,
          ebelp type mseg-ebelp,
          lifnr type mseg-lifnr,
          dmbtr type mseg-dmbtr,
          maktx type  makt-maktx,
          name1 type lfa1-name1,
          ort01 type lfa1-ort01,
        end of grn1.

types : begin of rpm1,
          mjahr type mseg-mjahr,
          mblnr type mseg-mblnr,
          werks type mseg-werks,
          bwart type mseg-bwart,
          matnr type mseg-matnr,
          charg type mseg-charg,
          menge type mseg-menge,
          meins type mseg-meins,
          lgort type mseg-lgort,
          ebeln type mseg-ebeln,
          ebelp type mseg-ebelp,
          lifnr type mseg-lifnr,
          dmbtr type mseg-dmbtr,
          maktx type  makt-maktx,
          name1 type lfa1-name1,
          ort01 type lfa1-ort01,
        end of rpm1.

types : begin of rpm2,
          mjahr         type mseg-mjahr,
          mblnr         type mseg-mblnr,
          werks         type mseg-werks,
          bwart         type mseg-bwart,
          matnr         type mseg-matnr,
          charg         type mseg-charg,
          fgmatnr       type mseg-matnr,
          fgcharg       type mseg-charg,
          menge         type mseg-menge,
          meins         type mseg-meins,
          lgort         type mseg-lgort,
          ebeln         type mseg-ebeln,
          ebelp         type mseg-ebelp,
          lifnr         type mseg-lifnr,
          dmbtr         type mseg-dmbtr,
          maktx         type  makt-maktx,
          name1         type lfa1-name1,
          ort01         type lfa1-ort01,
          stcd3         type lfa1-stcd3,
          deladdr1(100) type c,
          deladdr2(100) type c,
          mwskz         type ekpo-mwskz,
          belnr         type rseg-belnr,
          gjahr         type rseg-gjahr,
          rpmblnr       type mseg-mblnr,
          rpmjahr       type mseg-mjahr,
          rplifnr       type mseg-lifnr,
          rpebeln       type mseg-ebeln,
          rpebelp       type mseg-ebelp,
          rpmenge       type mseg-menge,
*          RPLINE_ID     TYPE MSEG-LINE_ID,
        end of rpm2.

types : begin of rpm3,
          mjahr         type mseg-mjahr,
          mblnr         type mseg-mblnr,
          werks         type mseg-werks,
          bwart         type mseg-bwart,
          matnr         type mseg-matnr,
          charg         type mseg-charg,
          fgmatnr       type mseg-matnr,
          fgcharg       type mseg-charg,
          menge         type mseg-menge,
          meins         type mseg-meins,
          lgort         type mseg-lgort,
          ebeln         type mseg-ebeln,
          ebelp         type mseg-ebelp,
          lifnr         type mseg-lifnr,
          dmbtr         type mseg-dmbtr,
          maktx         type  makt-maktx,
          name1         type lfa1-name1,
          ort01         type lfa1-ort01,
          stcd3         type lfa1-stcd3,
          deladdr1(100) type c,
          deladdr2(100) type c,
          mwskz         type ekpo-mwskz,
          belnr         type rseg-belnr,
          gjahr         type rseg-gjahr,
          rpmblnr       type mseg-mblnr,
          rpmjahr       type mseg-mjahr,
          rplifnr       type mseg-lifnr,
          rpebeln       type mseg-ebeln,
          rpebelp       type mseg-ebelp,
          rpbelnr       type rseg-belnr,
          rpgjahr       type rseg-gjahr,
          rpxblnr       type rseg-xblnr,
          rpmwskz       type rseg-mwskz,
          wrbtr         type rseg-wrbtr,
          rpfidoc       type bkpf-belnr,
          rpfidocyr     type bkpf-gjahr,
          hwste         type bset-hwste,
          igst          type bset-hwste,
          cgst          type bset-hwste,
          sgst          type bset-hwste,
          cess          type bset-hwste,
          othr          type bset-hwste,
          rpmenge       type mseg-menge,
*          RPLINE_ID     TYPE MSEG-LINE_ID,
          xblnr         type bkpf-xblnr,
          bldat         type bkpf-bldat,
          budat         type bkpf-budat,
          vbeln         type zgstnum1-vbeln,
          fkdat         type sy-datum,
        end of rpm3.

types : begin of tax1,
          mblnr type mseg-mblnr,
          mjahr type mseg-mjahr,
          matnr type mseg-matnr,
          charg type mseg-charg,
          lfgja type rseg-lfgja,
          lfpos type rseg-lfpos,
          belnr type rseg-belnr,
          gjahr type rseg-gjahr,
          wrbtr type rseg-wrbtr,
        end of tax1.

types : begin of tax2,
          mblnr type mseg-mblnr,
          mjahr type mseg-mjahr,
          matnr type mseg-matnr,
          charg type mseg-charg,
          lfgja type rseg-lfgja,
          lfpos type rseg-lfpos,
          belnr type bkpf-belnr,
          gjahr type bkpf-gjahr,
          wrbtr type rseg-wrbtr,
          xblnr type bkpf-xblnr,
          bldat type bkpf-bldat,
          budat type bkpf-budat,
        end of tax2.

types : begin of tax3,
          mblnr type mseg-mblnr,
          mjahr type mseg-mjahr,
          matnr type mseg-matnr,
          charg type mseg-charg,
          lfgja type rseg-lfgja,
          lfpos type rseg-lfpos,
          belnr type bkpf-belnr,
          gjahr type bkpf-gjahr,
          hwste type bset-hwste,
          wrbtr type rseg-wrbtr,
          cgst  type bset-hwste,
          sgst  type bset-hwste,
          igst  type bset-hwste,
          cess  type bset-hwste,
          othr  type bset-hwste,
          xblnr type bkpf-xblnr,
          bldat type bkpf-bldat,
          budat type bkpf-budat,
        end of tax3.

types: begin of rev1,
         mblnr type mseg-mblnr,
       end of rev1.

data: it_tab1  type table of itab1,
      wa_tab1  type itab1,
      it_tab2  type table of itab2,
      wa_tab2  type itab2,
      it_tab21 type table of itab2,
      wa_tab21 type itab2,
      it_tab3  type table of itab2,
      wa_tab3  type itab2,
      it_grn1  type table of grn1,
      wa_grn1  type  grn1,
      it_rpm1  type table of rpm1,
      wa_rpm1  type rpm1,
      it_rpm2  type table of rpm2,
      wa_rpm2  type rpm2,
      it_rpm3  type table of rpm3,
      wa_rpm3  type rpm3,
      it_tax1  type table of tax1,
      wa_tax1  type tax1,
      it_tax2  type table of tax2,
      wa_tax2  type tax2,
      it_tax3  type table of tax3,
      wa_tax3  type tax3,
      it_rev1  type table of rev1,
      wa_rev1  type rev1.

data: pts type konp-kbetr,
      mrp type konp-kbetr.

types: begin of typ_t001w,
         werks type werks_d,
         name1 type name1,
       end of typ_t001w.

data : itab_t001w type table of typ_t001w,
       wa_t001w   type typ_t001w.
data :
*      mesg(40) type c,
      msg type string.
data: awkey type bkpf-awkey.

data: qty1 type p,
      qv1  type p.
data: iiqty1 type p,
      iiqty2 type p.
data: deladdr1(100) type c,
      deladdr2(100) type c.
data: a      type i,
      iqty1  type p,
      balqty type p,
      grnqty type p.
data: opbal1  type p,
      balqty1 type p.
data: nqty1 type mseg-menge.

selection-screen begin of block merkmale1 with frame title text-001.
select-options : material for mseg-matnr,
                 date1 for mkpf-budat,
                 plant for mseg-werks.
parameters : ven like mseg-lifnr obligatory.
*                 MTART FOR MARA-MTART.
selection-screen end of block merkmale1 .
selection-screen begin of block merkmale2 with frame title text-001.
parameters : r1  radiobutton group r1,
             r11 radiobutton group r1.
selection-screen end of block merkmale2.

initialization.
  g_repid = sy-repid.

at selection-screen.
  perform authorization.

*  AUTHORITY-CHECK OBJECT '/DSD/SL_WR'
*           ID 'WERKS' FIELD from_plt.
*
*  If sy-subrc ne 0.
*    MeSG = 'Check your entry'.
*    MESSAGE MESG TYPE 'E'.
*  endif.


start-of-selection.

  select * from mkpf into table it_mkpf where vgart eq 'WE' and budat in date1.
  if sy-subrc eq 0.
    select * from mseg into table it_mseg for all entries in it_mkpf where mblnr eq it_mkpf-mblnr and mjahr eq it_mkpf-mjahr and matnr in material
      and werks in plant and lifnr eq ven.
    if sy-subrc ne 0.
      message 'NO DATA FOUND' type 'E'.
    endif.
  endif.



  if r1 eq 'X' or r11 eq 'X'.
    perform fg.
  endif.
*&---------------------------------------------------------------------*
*&      Form  FG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form fg .
  if r1 eq 'X'.
    loop at it_mseg into wa_mseg where lsmng ne 0.
      select single * from mara where matnr eq wa_mseg-matnr and mtart in ('ZFRT','ZHWA','ZDSM','ZESC','ZESM').
      if sy-subrc eq 0.
        select single * from ekko where ebeln eq wa_mseg-ebeln and bsart eq 'ZSBC'.
        if sy-subrc eq 0.
          write : / 'A',wa_mseg-mjahr,wa_mseg-mblnr,wa_mseg-werks,wa_mseg-bwart,wa_mseg-matnr,wa_mseg-charg,wa_mseg-menge,wa_mseg-meins,wa_mseg-lgort,
          wa_mseg-ebeln,wa_mseg-ebelp,wa_mseg-lifnr,wa_mseg-dmbtr.
          wa_grn1-mjahr = wa_mseg-mjahr.
          wa_grn1-mblnr = wa_mseg-mblnr.
          wa_grn1-werks = wa_mseg-werks.
          wa_grn1-bwart = wa_mseg-bwart.
          wa_grn1-matnr = wa_mseg-matnr.
          select single * from makt where matnr eq wa_mseg-matnr and spras eq 'EN'.
          if sy-subrc eq 0.
            wa_grn1-maktx = makt-maktx.
          endif.
          wa_grn1-charg = wa_mseg-charg.
          wa_grn1-menge = wa_mseg-menge.
          wa_grn1-meins = wa_mseg-meins.
          wa_grn1-lgort = wa_mseg-lgort.
          wa_grn1-ebeln = wa_mseg-ebeln.
          wa_grn1-ebelp = wa_mseg-ebelp.
          wa_grn1-lifnr = wa_mseg-lifnr.
          select single * from lfa1 where lifnr eq wa_mseg-lifnr.
          if sy-subrc eq 0.
            wa_grn1-name1 = lfa1-name1.
            wa_grn1-ort01 = lfa1-ort01.
          endif.
          wa_grn1-dmbtr = wa_mseg-dmbtr.
          collect wa_grn1 into it_grn1.
          clear wa_grn1.
        endif.
      endif.
    endloop.
    call   screen 0100.
    leave to screen 0.
  elseif r11 eq 'X'.
    perform fginv.
  endif.
endform.
*&---------------------------------------------------------------------*
*&      Form  FGINV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form fginv .
  loop at it_mseg into wa_mseg where lsmng ne 0.
    select single * from mara where matnr eq wa_mseg-matnr and mtart in ('ZFRT','ZHWA','ZDSM','ZESC','ZESM').
    if sy-subrc eq 0.
      select single * from ekko where ebeln eq wa_mseg-ebeln and bsart eq 'ZSBC'.
      if sy-subrc eq 0.
        wa_tab1-werks = wa_mseg-werks.
        wa_tab1-bwart = wa_mseg-bwart.
        wa_tab1-matnr = wa_mseg-matnr.
        wa_tab1-charg = wa_mseg-charg.
        wa_tab1-menge = wa_mseg-menge.
        wa_tab1-meins = wa_mseg-meins.
        wa_tab1-ebeln = wa_mseg-ebeln.
        wa_tab1-ebelp = wa_mseg-ebelp.
        wa_tab1-lifnr = wa_mseg-lifnr.
        wa_tab1-dmbtr = wa_mseg-dmbtr.
        collect wa_tab1 into it_tab1.
        clear wa_tab1.
      endif.
    endif.
  endloop.

  sort it_tab1 by matnr charg.
*  LOOP AT IT_TAB1 INTO WA_TAB1.
*    WRITE : /'2', WA_TAB1-MATNR,WA_TAB1-CHARG,WA_TAB1-WERKS,WA_TAB1-BWART,WA_TAB1-MENGE,WA_TAB1-MEINS,WA_TAB1-EBELN,WA_TAB1-EBELP,
*    WA_TAB1-LIFNR,WA_TAB1-DMBTR.
*  ENDLOOP.
  if it_tab1 is not initial.
    select * from wb2_v_vbrk_vbrp2 into table it_wb2_v_vbrk_vbrp2 for all entries in it_tab1 where bukrs eq '1000'
      and fkart in ('ZSTO','ZSTI','ZSAM' ) and fkdat ge date1-low and fksto ne 'X' and matnr_i eq it_tab1-matnr and charg_i eq it_tab1-charg
      and werks_i eq it_tab1-werks and fksto eq space.
    if sy-subrc eq 0.
      select * from likp into table it_likp for all entries in it_wb2_v_vbrk_vbrp2 where vbeln eq it_wb2_v_vbrk_vbrp2-vgbel_i.
    endif.
  endif.

  loop at it_wb2_v_vbrk_vbrp2 into wa_wb2_v_vbrk_vbrp2.
    read table it_likp into wa_likp with key vbeln = wa_wb2_v_vbrk_vbrp2-vgbel_i.
    if sy-subrc eq 4.
      delete it_wb2_v_vbrk_vbrp2 where vbeln eq wa_wb2_v_vbrk_vbrp2-vbeln.
    endif.
  endloop.

  sort it_wb2_v_vbrk_vbrp2 by fkdat vbeln.
  loop at it_tab1 into wa_tab1.
    clear : iiqty1.
    format color 1.
*    WRITE : / WA_TAB1-MATNR,WA_TAB1-CHARG,WA_TAB1-WERKS,WA_TAB1-BWART,WA_TAB1-MENGE,WA_TAB1-MEINS,WA_TAB1-EBELN,WA_TAB1-EBELP,
*    WA_TAB1-LIFNR,WA_TAB1-DMBTR.
    if wa_tab1-bwart ne '102'.
      read table it_wb2_v_vbrk_vbrp2 into wa_wb2_v_vbrk_vbrp2 with key matnr_i = wa_tab1-matnr charg_i = wa_tab1-charg.
      if sy-subrc eq 0.
        format color 2.
        iiqty1 = wa_wb2_v_vbrk_vbrp2-fkimg_i.

*        WRITE : 110 WA_WB2_V_VBRK_VBRP2-FKART,WA_WB2_V_VBRK_VBRP2-VBELN,WA_WB2_V_VBRK_VBRP2-FKDAT,
*      WA_WB2_V_VBRK_VBRP2-MATNR_I, WA_WB2_V_VBRK_VBRP2-CHARG_I,
*        WA_WB2_V_VBRK_VBRP2-FKIMG_I,WA_WB2_V_VBRK_VBRP2-NETWR.
        wa_tab2-matnr = wa_tab1-matnr.
        wa_tab2-charg = wa_tab1-charg.
        select single * from t001w where kunnr eq wa_wb2_v_vbrk_vbrp2-kunag.
        if sy-subrc eq 0.
          wa_tab2-recplant = t001w-werks.
        endif.
        wa_tab2-werks = wa_tab1-werks.
        wa_tab2-bwart = wa_tab1-bwart.
        wa_tab2-menge = wa_tab1-menge.
        wa_tab2-meins = wa_tab1-meins.
        wa_tab2-ebeln = wa_tab1-ebeln.
        wa_tab2-ebelp = wa_tab1-ebelp.
        wa_tab2-lifnr = wa_tab1-lifnr.
        wa_tab2-dmbtr = wa_tab1-dmbtr.
        wa_tab2-fkart = wa_wb2_v_vbrk_vbrp2-fkart.
        wa_tab2-vbeln = wa_wb2_v_vbrk_vbrp2-vbeln.
        wa_tab2-fkdat = wa_wb2_v_vbrk_vbrp2-fkdat.
        wa_tab2-fkimg_i = wa_wb2_v_vbrk_vbrp2-fkimg_i.
        wa_tab2-netwr_i = wa_wb2_v_vbrk_vbrp2-netwr_i.
        wa_tab2-mwsbp_i = wa_wb2_v_vbrk_vbrp2-mwsbp_i.
        collect wa_tab2 into it_tab2.
        clear wa_tab2.
        clear : qty1.
        qty1 = wa_tab1-menge - wa_wb2_v_vbrk_vbrp2-fkimg_i.
        if qty1 gt 0.
          delete it_wb2_v_vbrk_vbrp2 where vbeln eq wa_wb2_v_vbrk_vbrp2-vbeln and matnr_i eq wa_wb2_v_vbrk_vbrp2-matnr_i and
          charg_i eq wa_wb2_v_vbrk_vbrp2-charg_i.
          read table it_wb2_v_vbrk_vbrp2 into wa_wb2_v_vbrk_vbrp2 with key matnr_i = wa_tab1-matnr charg_i = wa_tab1-charg.
          if sy-subrc eq 0.
            if qty1 ge wa_wb2_v_vbrk_vbrp2-fkimg_i.

              iiqty1 = iiqty1 + wa_wb2_v_vbrk_vbrp2-fkimg_i.
*              WRITE : /110 WA_WB2_V_VBRK_VBRP2-FKART,WA_WB2_V_VBRK_VBRP2-VBELN,WA_WB2_V_VBRK_VBRP2-FKDAT,
*            WA_WB2_V_VBRK_VBRP2-MATNR_I, WA_WB2_V_VBRK_VBRP2-CHARG_I,
*              WA_WB2_V_VBRK_VBRP2-FKIMG_I,WA_WB2_V_VBRK_VBRP2-NETWR.
              clear : qv1.

              qv1 = wa_tab1-menge + wa_wb2_v_vbrk_vbrp2-fkimg_i.
              wa_tab2-matnr = wa_tab1-matnr.
              wa_tab2-charg = wa_tab1-charg.
              select single * from t001w where kunnr eq wa_wb2_v_vbrk_vbrp2-kunag.
              if sy-subrc eq 0.
                wa_tab2-recplant = t001w-werks.
              endif.
              wa_tab2-werks = wa_tab1-werks.
              wa_tab2-bwart = wa_tab1-bwart.
              wa_tab2-menge = wa_tab1-menge.
              wa_tab2-meins = wa_tab1-meins.
              wa_tab2-ebeln = wa_tab1-ebeln.
              wa_tab2-ebelp = wa_tab1-ebelp.
              wa_tab2-lifnr = wa_tab1-lifnr.
              wa_tab2-dmbtr = wa_tab1-dmbtr.
              wa_tab2-fkart = wa_wb2_v_vbrk_vbrp2-fkart.
              wa_tab2-vbeln = wa_wb2_v_vbrk_vbrp2-vbeln.
              wa_tab2-fkdat = wa_wb2_v_vbrk_vbrp2-fkdat.
              wa_tab2-fkimg_i = wa_wb2_v_vbrk_vbrp2-fkimg_i.
              wa_tab2-netwr_i = wa_wb2_v_vbrk_vbrp2-netwr_i.
              wa_tab2-mwsbp_i = wa_wb2_v_vbrk_vbrp2-mwsbp_i.
              collect wa_tab2 into it_tab2.
              clear wa_tab2.
            endif.
          endif.
        endif.

        clear : qty1.
        qty1 = wa_tab1-menge - qv1.
        iiqty2 = wa_tab1-menge - iiqty1.
*        IF QTY1 GT 0.
        if iiqty2 gt 0.
          delete it_wb2_v_vbrk_vbrp2 where vbeln eq wa_wb2_v_vbrk_vbrp2-vbeln and matnr_i = wa_wb2_v_vbrk_vbrp2-matnr_i and charg_i = wa_wb2_v_vbrk_vbrp2-charg_i..
          read table it_wb2_v_vbrk_vbrp2 into wa_wb2_v_vbrk_vbrp2 with key matnr_i = wa_tab1-matnr charg_i = wa_tab1-charg.
          if sy-subrc eq 0.
*            IF QTY1 GE WA_WB2_V_VBRK_VBRP2-FKIMG_I.
            if iiqty2 gt 0.
*              WRITE : /110 WA_WB2_V_VBRK_VBRP2-FKART,WA_WB2_V_VBRK_VBRP2-VBELN,WA_WB2_V_VBRK_VBRP2-FKDAT,
*            WA_WB2_V_VBRK_VBRP2-MATNR_I, WA_WB2_V_VBRK_VBRP2-CHARG_I,
*              WA_WB2_V_VBRK_VBRP2-FKIMG_I,WA_WB2_V_VBRK_VBRP2-NETWR.
              wa_tab2-matnr = wa_tab1-matnr.
              wa_tab2-charg = wa_tab1-charg.
              select single * from t001w where kunnr eq wa_wb2_v_vbrk_vbrp2-kunag.
              if sy-subrc eq 0.
                wa_tab2-recplant = t001w-werks.
              endif.
              wa_tab2-werks = wa_tab1-werks.
              wa_tab2-bwart = wa_tab1-bwart.
              wa_tab2-menge = wa_tab1-menge.
              wa_tab2-meins = wa_tab1-meins.
              wa_tab2-ebeln = wa_tab1-ebeln.
              wa_tab2-ebelp = wa_tab1-ebelp.
              wa_tab2-lifnr = wa_tab1-lifnr.
              wa_tab2-dmbtr = wa_tab1-dmbtr.
              wa_tab2-fkart = wa_wb2_v_vbrk_vbrp2-fkart.
              wa_tab2-vbeln = wa_wb2_v_vbrk_vbrp2-vbeln.
              wa_tab2-fkdat = wa_wb2_v_vbrk_vbrp2-fkdat.
              wa_tab2-fkimg_i = wa_wb2_v_vbrk_vbrp2-fkimg_i.
              wa_tab2-netwr_i = wa_wb2_v_vbrk_vbrp2-netwr_i.
              wa_tab2-mwsbp_i = wa_wb2_v_vbrk_vbrp2-mwsbp_i.
              collect wa_tab2 into it_tab2.
              clear wa_tab2.
            endif.
          endif.
        endif.
      endif.
    endif.
  endloop.
  loop at it_tab1 into wa_tab1.
    read table it_tab2 into wa_tab2 with key matnr = wa_tab1-matnr charg = wa_tab1-charg ebeln = wa_tab1-ebeln ebelp = wa_tab1-ebelp
    bwart = wa_tab1-bwart.
    if sy-subrc eq 4.
      wa_tab2-matnr = wa_tab1-matnr.
      wa_tab2-charg = wa_tab1-charg.
      wa_tab2-werks = wa_tab1-werks.
      wa_tab2-bwart = wa_tab1-bwart.
      wa_tab2-menge = wa_tab1-menge.
      wa_tab2-meins = wa_tab1-meins.
      wa_tab2-ebeln = wa_tab1-ebeln.
      wa_tab2-ebelp = wa_tab1-ebelp.
      wa_tab2-lifnr = wa_tab1-lifnr.
      wa_tab2-dmbtr = wa_tab1-dmbtr.
      wa_tab2-fkart = space.
      wa_tab2-vbeln = space.
      wa_tab2-fkdat = space.
      wa_tab2-fkimg_i = 0.
      wa_tab2-netwr_i = 0.
      wa_tab2-mwsbp_i = 0.
      wa_tab2-recplant = space.
      collect wa_tab2 into it_tab2.
      clear : wa_tab2.
    endif.
  endloop.

  sort it_tab2 by matnr charg bwart.
  it_tab21 = it_tab2.
  perform 301mov.

*  loop at it_tab2 into wa_tab2 where fkart eq space.
*    read table it_mseg3 into wa_mseg3 with key werks = wa_tab2-werks  matnr = wa_tab2-matnr  charg = wa_tab2-charg.
*    if sy-subrc eq 0.
*      select single * from mkpf where mblnr eq wa_mseg3-mblnr and mjahr eq wa_mseg3-mjahr and budat ge '20230901'.
*      if sy-subrc eq 0.
*        wa_tab2-fkart = '303'.
*        wa_tab2-vbeln = wa_mseg3-mblnr.
*        wa_tab2-fkdat = mkpf-budat.
*        wa_tab2-fkimg_i = wa_mseg3-menge.
*        clear: pts,mrp.
*        select single * from a602 where matnr eq wa_mseg3-matnr and charg eq wa_mseg3-charg and  kschl = 'Z001'
*   and datbi ge wa_tab2-fkdat.
*        if sy-subrc eq 0.
*          select single * from konp where knumh = a602-knumh and kschl eq 'Z001' and loevm_ko ne 'X'..
*          if sy-subrc eq 0.
*            mrp = konp-kbetr.
*          endif.
*        endif.
*        pts =  ( ( 6429 / 100 ) * ( mrp / 100 ) ).
*        wa_tab2-netwr_i = pts * wa_tab2-fkimg_i.
*
**        wa_tab2-netwr_i = wa_mseg3-dmbtr.
*        select single * from mseg where mblnr eq wa_mseg3-mblnr and mjahr eq wa_mseg3-mjahr and xauto eq 'X'.
*        if sy-subrc eq 0.
*          wa_tab2-recplant = mseg-werks.
*        endif.
*        modify it_tab2 from wa_tab2 transporting fkart vbeln fkdat fkimg_i netwr_i recplant where werks eq wa_tab2-werks and bwart eq wa_tab2-bwart
*        and matnr eq wa_tab2-matnr and charg = wa_tab2-charg.
*        clear: nqty1.
*        nqty1 = wa_tab2-menge - wa_mseg3-menge.
*        delete it_mseg3 where mblnr eq wa_mseg3-mblnr.
*      endif.
*    endif.
*
*  endloop.
  loop at it_mseg3 into wa_mseg3.
    read table it_tab2 into wa_tab2 with key fkart = '    '  werks = wa_mseg3-werks  matnr = wa_mseg3-matnr  charg = wa_mseg3-charg.
    if sy-subrc eq 0.
      move-corresponding wa_tab2 to wa_tab21.
      select single * from mkpf where mblnr eq wa_mseg3-mblnr and mjahr eq wa_mseg3-mjahr and budat ge '20230901'.
      if sy-subrc eq 0.
        wa_tab21-fkart = '301'.
        wa_tab21-vbeln = wa_mseg3-mblnr.
        wa_tab21-fkdat = mkpf-budat.
        wa_tab21-fkimg_i = wa_mseg3-menge.
        clear: pts,mrp.
        select single * from a602 where matnr eq wa_mseg3-matnr and charg eq wa_mseg3-charg and  kschl = 'Z001'
   and datbi ge wa_tab2-fkdat.
        if sy-subrc eq 0.
          select single * from konp where knumh = a602-knumh and kschl eq 'Z001' and loevm_ko ne 'X'..
          if sy-subrc eq 0.
            mrp = konp-kbetr.
          endif.
        endif.
*        pts =  ( ( 6429 / 100 ) * ( mrp / 100 ) ).
         pts =  ( ( 6428 / 100 ) * ( mrp / 100 ) ).  "changed on 7.4.24 as per Sanjay Sharma email
        wa_tab21-netwr_i = pts * wa_tab21-fkimg_i.

*        wa_tab2-netwr_i = wa_mseg3-dmbtr.
        select single * from mseg where mblnr eq wa_mseg3-mblnr and mjahr eq wa_mseg3-mjahr and xauto eq 'X'.
        if sy-subrc eq 0.
          wa_tab21-recplant = mseg-werks.
        endif.
*        modify it_tab2 from wa_tab2 transporting fkart vbeln fkdat fkimg_i netwr_i recplant where werks eq wa_tab2-werks and bwart eq wa_tab2-bwart
*        and matnr eq wa_tab2-matnr and charg = wa_tab2-charg.
        collect wa_tab21 into it_tab21.
        clear wa_tab21.
      endif.
    endif.
  endloop.

  loop at it_tab21 into wa_tab21 where vbeln eq space.
    read table it_mseg3 into wa_mseg3 with key werks = wa_tab21-werks  matnr = wa_tab21-matnr  charg = wa_tab21-charg.
    if sy-subrc eq 0.
      delete it_tab21 where werks = wa_tab21-werks and matnr = wa_tab21-matnr and charg = wa_tab21-charg and vbeln eq space.
    endif.
  endloop.

  loop at it_tab21 into wa_tab21.

    a = 0.
    on change of wa_tab21-matnr.
      a = 1.
      iqty1 = 0.
    endon.
    on change of wa_tab21-charg.
      a = 1.
      iqty1 = 0.
    endon.
    on change of wa_tab21-bwart.
      a = 1.
      iqty1 = 0.
    endon.
    wa_tab3-matnr = wa_tab21-matnr.
    select single * from lfa1 where lifnr eq wa_tab21-lifnr.
    if sy-subrc eq 0.
      wa_tab3-stcd3 = lfa1-stcd3.
      wa_tab3-name1 = lfa1-name1.
    endif.
    select single * from makt where matnr eq wa_tab21-matnr and spras eq 'EN'.
    if sy-subrc eq 0.
      wa_tab3-maktx = makt-maktx.
    endif.
    select single * from mvke where matnr eq wa_tab21-matnr.
    if sy-subrc eq 0.
      select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
      if sy-subrc eq 0.
        wa_tab3-bezei = tvm5t-bezei.
      endif.
    endif.
    wa_tab3-charg = wa_tab21-charg.
    wa_tab3-werks = wa_tab21-werks.
    wa_tab3-bwart = wa_tab21-bwart.
    if a eq 1.
      wa_tab3-menge = wa_tab21-menge.
      wa_tab3-dmbtr = wa_tab21-dmbtr.
      opbal1 = 0.
      balqty1 = 0.
*      OPBAL1 = WA_TAB21-MENGE.
      balqty1 = wa_tab21-menge - wa_tab21-fkimg_i.
    else.
      opbal1 = balqty1.
      balqty1 = opbal1 - wa_tab21-fkimg_i.
    endif.
    wa_tab3-opbal1 = opbal1.
    wa_tab3-balqty1 = balqty1.
    wa_tab3-meins = wa_tab21-meins.
    wa_tab3-ebeln = wa_tab21-ebeln.
    wa_tab3-ebelp = wa_tab21-ebelp.
    wa_tab3-lifnr = wa_tab21-lifnr.
    wa_tab3-fkart = wa_tab21-fkart.
    wa_tab3-vbeln = wa_tab21-vbeln.
    wa_tab3-fkdat =  wa_tab21-fkdat.
    wa_tab3-fkimg_i = wa_tab21-fkimg_i.
    wa_tab3-netwr_i =  wa_tab21-netwr_i.
    wa_tab3-mwsbp_i =  wa_tab21-mwsbp_i.
    wa_tab3-recplant = wa_tab21-recplant.
    if wa_tab3-bwart eq '102'.
      wa_tab3-newmenge = wa_tab3-menge * ( - 1 ).
      wa_tab3-balqty1 = wa_tab3-balqty1 * ( - 1 ).
    endif.
    iqty1 = iqty1 + wa_tab21-fkimg_i.
    grnqty = wa_tab21-menge.
    wa_tab3-balqty = wa_tab21-menge - wa_tab21-fkimg_i.
*    AT END OF CHARG.
*      IF IQTY1 GT 0.
*        WA_TAB3-BALQTY = GRNQTY - IQTY1.
*      ENDIF.
*    ENDAT.

    collect wa_tab3 into it_tab3.
    clear : wa_tab3.
  endloop.
  sort it_tab3 by ebeln ebelp matnr charg bwart.

  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-seltext_l = 'FROM_PLANT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PRODUCT CODE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'PRODUCT NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BEZEI'.
  wa_fieldcat-seltext_l = 'PACK SIZE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BWART'.
  wa_fieldcat-seltext_l = 'MOVEMENT'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-fieldname = 'LST'.
*  WA_FIELDCAT-seltext_l = 'SUPPL. PLANT LST'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'OPBAL1'.
  wa_fieldcat-seltext_l = 'OPENING QUANTITY'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-FIELDNAME = 'MENGE'.
*  WA_FIELDCAT-SELTEXT_L = 'RECEIPT QTY'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'NEWMENGE'.
  wa_fieldcat-seltext_l = 'RECEIPT QTY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MEINS'.
  wa_fieldcat-seltext_l = 'UOM'.
  append wa_fieldcat to fieldcat.
*
  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-seltext_l = 'PO'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'EBELP'.
  wa_fieldcat-seltext_l = 'PO ITEM'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'LIFNR'.
  wa_fieldcat-seltext_l = 'VENDOR'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NAME1'.
  wa_fieldcat-seltext_l = 'VENDOR NAME'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'STCD3'.
  wa_fieldcat-seltext_l = 'VENDOT GST NO.'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-FIELDNAME = 'DMBTR'.
*  WA_FIELDCAT-SELTEXT_L = 'GRN QTY VALUE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'FKART'.
  wa_fieldcat-seltext_l = 'INV TYPE'.
  append wa_fieldcat to fieldcat.
*
  wa_fieldcat-fieldname = 'FKDAT'.
  wa_fieldcat-seltext_l = 'INV_DT'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'VBELN'.
  wa_fieldcat-seltext_l = 'INV_NO'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'FKIMG_I'.
  wa_fieldcat-seltext_l = 'INV QUANTITY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'NETWR_I'.
  wa_fieldcat-seltext_l = 'TAXABLE VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'MWSBP_I'.
  wa_fieldcat-seltext_l = 'TAX VALUE'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'BALQTY1'.
  wa_fieldcat-seltext_l = 'CLOSING QUANTITY'.
  append wa_fieldcat to fieldcat.

  wa_fieldcat-fieldname = 'RECPLANT'.
  wa_fieldcat-seltext_l = 'RECEIVING PLANT'.
  append wa_fieldcat to fieldcat.

*  WA_FIELDCAT-FIELDNAME = 'BALQTY'.
*  WA_FIELDCAT-SELTEXT_L = 'BALANCE QUANTITY'.
*  APPEND WA_FIELDCAT TO FIELDCAT.






  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'LLM FG RECEIPTS & INVOICE DETAIL'.


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
      t_outtab                = it_tab3
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.                    "SUMMARY


form user_comm1 using ucomm like sy-ucomm
                     selfield type slis_selfield.



  case selfield-fieldname.
    when 'MBLNR'.
      set parameter id 'MBN' field selfield-value.
      call transaction 'MB03' and skip first screen.
    when 'EBELN'.
      set parameter id 'BES' field selfield-value.
      call transaction 'ME23N' and skip first screen.
    when 'VBELN'.
      set parameter id 'VF' field selfield-value.
      call transaction 'VF03' and skip first screen.
    when 'VBELN1'.
      set parameter id 'BV' field selfield-value.
      call transaction 'VL03N' and skip first screen.
    when others.
  endcase.
endform.                    "USER_COMM


*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'LLM FG RECEIPT & INVOICE'.
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




*&---------------------------------------------------------------------*
*&      Form  authorization
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form authorization .

  select werks name1 from t001w into table itab_t001w where werks in  plant.

  loop at itab_t001w into wa_t001w.
    authority-check object 'M_BCO_WERK'
           id 'WERKS' field wa_t001w-werks.
    if sy-subrc <> 0.
      concatenate 'No authorization for Plant' wa_t001w-werks into msg
      separated by space.
      message msg type 'E'.
    endif.
  endloop.


endform.                    "authorization


*ENDFORM.

*TOP-OF-PAGE.
*  WRITE : / 'GRN FROM:',DATE1-LOW,'TO',DATE1-HIGH.
*  ULINE.
*  WRITE : / 'PRD_CODE',20 'BATCH',30 'PLANT','MOV',45 'RECEIVED_QTY',62 'PO',78 'VENDOR',98 'AMOUNT',' INV_TYPE','  INVOICE',
*  '   INV_DATE','    INV QUANTITY'.
*  ULINE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_0100 output.
  set pf-status 'BACK'.
  set titlebar 'GRN'.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0100 input.
  case ok_code.
    when 'BACK' or 'EXIT' or 'CANCEL'.
      leave program.
  endcase.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  PBO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module pbo output.

*  *Creating objects of the container
  create object c_ccont
    exporting
      container_name = 'CCONT'.
*  create object for alv grid


  create object c_alvgd
    exporting
      i_parent = cl_gui_custom_container=>screen0.

*  CREATE OBJECT c_alvgd
*    EXPORTING
*      i_parent = c_ccont.



*  SET field for ALV
  perform alv_build_fieldcat.
* Set ALV attributes FOR LAYOUT
  perform alv_report_layout.
  check not c_alvgd is initial.
* Call ALV GRID
  call method c_alvgd->set_table_for_first_display
    exporting
      is_layout                     = it_layout
      i_save                        = 'A'
    changing
      it_outtab                     = it_grn1
      it_fieldcatalog               = it_fcat
    exceptions
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      others                        = 4.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
               with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
endmodule.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_build_fieldcat .
*  WA_MSEG-MJAHR,WA_MSEG-MBLNR,WA_MSEG-WERKS,WA_MSEG-BWART,WA_MSEG-MATNR,WA_MSEG-CHARG,WA_MSEG-MENGE,WA_MSEG-MEINS,WA_MSEG-LGORT,
*        WA_MSEG-EBELN,WA_MSEG-EBELP,WA_MSEG-LIFNR,WA_MSEG-DMBTR.
  data lv_fldcat type lvc_s_fcat.

  clear lv_fldcat.
*  LV_FLDCAT-ROW_POS   = '1'.
*  LV_FLDCAT-COL_POS   = '1'.
  lv_fldcat-fieldname = 'MJAHR'.
  lv_fldcat-tabname   = 'IT_GRN1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'GRN YEAR'.
*  lv_fldcat-icon = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

*  LV_FLDCAT-ROW_POS   = '1'.
*  LV_FLDCAT-COL_POS   = '2'.
  lv_fldcat-fieldname = 'MBLNR'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'GRN NO.'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

*  LV_FLDCAT-ROW_POS   = '1'.
*  LV_FLDCAT-COL_POS   = '2'.
  lv_fldcat-fieldname = 'WERKS'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'PLANT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'BWART'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'MOVEMENT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MATNR'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'PRD CODE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MAKTX'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'PRODUCT CODE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'CHARG'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'BATCH'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MENGE'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'GRN QTY'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MEINS'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'UOM'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'LGORT'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'STORAGE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.
*  WA_MSEG-EBELN,WA_MSEG-EBELP,WA_MSEG-LIFNR,WA_MSEG-DMBTR.

  lv_fldcat-fieldname = 'EBELN'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'PO'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'EBELP'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'PO ITEM'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'LIFNR'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'VENDOR CODE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'NAME1'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'VENDOR NAME'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'ORT01'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'VENDOR PLACE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'DMBTR'.
  lv_fldcat-tabname   = 'IT_GRN1'.
  lv_fldcat-scrtext_m = 'GRN VALUE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

endform.
*&---------------------------------------------------------------------*
*&      Form  ALV_REPORT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_report_layout .
  it_layout-cwidth_opt = 'X'.
  it_layout-col_opt = 'X'.
  it_layout-zebra = 'X'.
endform.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_0200 output.
  set pf-status 'BACK'.
  set titlebar 'INV'.
endmodule.
*&---------------------------------------------------------------------*
*&      Form  PBO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  ALV_REPORT_LAYOUT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  RMPM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_build_fieldcat1 .


*  WA_MSEG-MJAHR,WA_MSEG-MBLNR,WA_MSEG-WERKS,WA_MSEG-BWART,WA_MSEG-MATNR,WA_MSEG-CHARG,WA_MSEG-MENGE,WA_MSEG-MEINS,WA_MSEG-LGORT,
*        WA_MSEG-EBELN,WA_MSEG-EBELP,WA_MSEG-LIFNR,WA_MSEG-DMBTR.
  data lv_fldcat type lvc_s_fcat.

  clear lv_fldcat.
*  LV_FLDCAT-ROW_POS   = '1'.
*  LV_FLDCAT-COL_POS   = '1'.
  lv_fldcat-fieldname = 'MJAHR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'GRN YEAR'.
*  lv_fldcat-icon = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

*  LV_FLDCAT-ROW_POS   = '1'.
*  LV_FLDCAT-COL_POS   = '2'.
  lv_fldcat-fieldname = 'MBLNR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG GRN NO.'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

*  LV_FLDCAT-ROW_POS   = '1'.
*  LV_FLDCAT-COL_POS   = '2'.
  lv_fldcat-fieldname = 'WERKS'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'PLANT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'BWART'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'MOVEMENT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'EBELN'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG PO'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'EBELP'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG PO ITEM'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MWSKZ'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG PO TAX CODE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'LIFNR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG VENDOR CODE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'NAME1'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG VENDOR NAME'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'ORT01'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG VENDOR PLACE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'STCD3'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG VENDOR GSTN'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'DELADDR1'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG DELIVERY ADDRESS1'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'DELADDR2'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG DELIVERY ADDRESS2'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'BELNR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG FI DOC'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'GJAHR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG FI DOC YEAR'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.


  lv_fldcat-fieldname = 'FGMATNR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG PRD CODE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'FGCHARG'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG BATCH'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MENGE'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG GRN QTY'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MEINS'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'UOM'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'DMBTR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'FG GRN VALUE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'LGORT'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'STORAGE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MATNR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'PRD CODE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'MAKTX'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'PRODUCT CODE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'CHARG'.
  lv_fldcat-tabname   = 'IT_PRM3'.
  lv_fldcat-scrtext_m = 'BATCH'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.


*  WA_MSEG-EBELN,WA_MSEG-EBELP,WA_MSEG-LIFNR,WA_MSEG-DMBTR.

  lv_fldcat-fieldname = 'RPEBELN'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM PO'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'RPEBELP'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM PO ITEM'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.


  lv_fldcat-fieldname = 'RPMBLNR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM GRN'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'RPMJAHR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM GRN YEAR'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'RPLIFNR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM VENDOR'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'RPMENGE'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM GRN QTY'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.


*  LV_FLDCAT-FIELDNAME = 'RPBELNR'.
*  LV_FLDCAT-TABNAME   = 'IT_RPM3'.
*  LV_FLDCAT-SCRTEXT_M = 'RM/PM MIRO DOC'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.

  lv_fldcat-fieldname = 'RPFIDOCYR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM FI YEAR'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'RPFIDOC'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM FI DOC'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'BUDAT'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM FI DOC POSTING DT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

*  LV_FLDCAT-FIELDNAME = 'RPMWSKZ'.
*  LV_FLDCAT-TABNAME   = 'IT_RPM3'.
*  LV_FLDCAT-SCRTEXT_M = 'RM/PM TAX CODE'.
*  APPEND LV_FLDCAT TO IT_FCAT.
*  CLEAR LV_FLDCAT.

  lv_fldcat-fieldname = 'XBLNR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM BILL NO.'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'BLDAT'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM BILL DATE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'WRBTR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM FI BASE AMT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'HWSTE'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM TAX AMT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'IGST'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM IGST AMT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'CGST'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM CGST AMT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'SGST'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM SGST/UGST AMT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'CESS'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM CESS AMT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'OTHR'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'RM/PM OTHR AMT'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'VBELN'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'DELIVERY CHALLAN'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-fieldname = 'FKDAT'.
  lv_fldcat-tabname   = 'IT_RPM3'.
  lv_fldcat-scrtext_m = 'DELIVERY CHALLAN DATE'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

endform.
*&---------------------------------------------------------------------*
*&      Form  TAX1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form tax1 .
  clear: it_rseg,it_mseg2.
  if it_rpm2 is not initial.
    select * from mseg into table it_mseg2 for all entries in it_rpm2  where mblnr eq it_rpm2-rpmblnr and mjahr eq it_rpm2-rpmjahr and
      ebeln eq it_rpm2-rpebeln and ebelp eq it_rpm2-rpebelp and matnr eq it_rpm2-matnr and charg eq it_rpm2-charg.
    if sy-subrc eq 0.
      select * from rseg into table it_rseg for all entries in it_mseg2  where ebeln eq it_mseg2-ebeln and
        ebelp eq it_mseg2-ebelp and lfbnr eq it_mseg2-mblnr and lfgja eq it_mseg2-mjahr and matnr eq it_mseg2-matnr.
    endif.
  endif.

*    SELECT * FROM RSEG INTO TABLE IT_RSEG FOR ALL ENTRIES IN IT_RPM2  WHERE EBELN EQ IT_RPM2-RPEBELN AND
*      EBELP EQ IT_RPM2-RPEBELP AND LFBNR EQ IT_RPM2-RPMBLNR AND LFGJA EQ IT_RPM2-RPMJAHR AND MATNR EQ IT_RPM2-MATNR.

  sort it_rseg descending by belnr.
  if it_mseg2 is not initial.
    loop at it_mseg2 into wa_mseg2.
      loop at it_rseg into wa_rseg where ebeln eq wa_mseg2-ebeln and  ebelp eq wa_mseg2-ebelp and lfbnr eq wa_mseg2-mblnr and lfgja eq wa_mseg2-mjahr
         and matnr eq wa_mseg2-matnr and lfpos eq wa_mseg2-line_id.
        wa_tax1-mblnr = wa_mseg2-mblnr.
        wa_tax1-mjahr = wa_mseg2-mjahr.
        wa_tax1-matnr = wa_mseg2-matnr.
        wa_tax1-charg = wa_mseg2-charg.
        wa_tax1-lfgja = wa_rseg-lfgja.
        wa_tax1-lfpos = wa_rseg-lfpos.
        wa_tax1-belnr = wa_rseg-belnr.
        wa_tax1-gjahr = wa_rseg-gjahr.
        wa_tax1-wrbtr = wa_rseg-wrbtr.
        collect wa_tax1 into it_tax1.
        clear wa_tax1.
      endloop.
    endloop.
  endif.

  loop at it_tax1 into wa_tax1.
    wa_tax2-mblnr = wa_tax1-mblnr.
    wa_tax2-mjahr = wa_tax1-mjahr.
    wa_tax2-matnr = wa_tax1-matnr.
    wa_tax2-charg = wa_tax1-charg.
    wa_tax2-lfgja = wa_tax1-lfgja.
    wa_tax2-lfpos = wa_tax1-lfpos.
    wa_tax2-wrbtr = wa_tax1-wrbtr.
    clear: awkey.
    concatenate wa_tax1-belnr wa_tax1-gjahr into awkey.
    select single * from bkpf where bukrs eq '1000' and gjahr eq wa_tax1-gjahr and awkey = awkey.
    if sy-subrc eq 0.
      wa_tax2-belnr = bkpf-belnr.
      wa_tax2-gjahr =  bkpf-gjahr.
      wa_tax2-xblnr =  bkpf-xblnr.
      wa_tax2-bldat = bkpf-bldat.
      wa_tax2-budat = bkpf-budat.
*      SELECT SINGLE * FROM BSET WHERE BUKRS EQ 'BCLL' AND BELNR EQ BKPF-BELNR AND GJAHR EQ BKPF-GJAHR AND
*        BUZEI EQ WA_RSEG-LFPOS.
*      IF SY-SUBRC EQ 0.
*        WA_RPM3-HWSTE = BSET-HWSTE.
*      ENDIF.
    endif.
    collect wa_tax2 into it_tax2.
    clear wa_tax2.
  endloop.

  if it_tax2 is not initial.
    select * from bset into table it_bset for all entries in it_tax2 where bukrs eq '1000' and belnr eq it_tax2-belnr and gjahr eq it_tax2-gjahr.
*      AND BUZEI EQ WA_TAX2-LFPOS.
  endif.

  loop at it_tax2 into wa_tax2.
    loop at it_bset into wa_bset where belnr eq wa_tax2-belnr and gjahr eq wa_tax2-gjahr and txgrp eq wa_tax2-lfpos.
      wa_tax3-mblnr = wa_tax2-mblnr.
      wa_tax3-mjahr = wa_tax2-mjahr.
      wa_tax3-matnr = wa_tax2-matnr.
      wa_tax3-charg = wa_tax2-charg.
*      WA_TAX3-LFGJA = WA_TAX2-LFGJA.
*      WA_TAX3-LFPOS = WA_TAX2-LFPOS.
      wa_tax3-belnr = wa_tax2-belnr.
      wa_tax3-gjahr =  wa_tax2-gjahr.
      wa_tax3-xblnr =  wa_tax2-xblnr.
      wa_tax3-bldat = wa_tax2-bldat.
      wa_tax3-budat = wa_tax2-budat.
      wa_tax3-wrbtr = wa_tax2-wrbtr.
      if wa_bset-shkzg eq 'H'.
        wa_bset-hwste = wa_bset-hwste * ( - 1 ).
      endif.
      wa_tax3-hwste = wa_bset-hwste.
      if wa_bset-ktosl eq 'JIC' or wa_bset-ktosl eq 'JRC'.
        wa_tax3-cgst = wa_bset-hwste.
      elseif wa_bset-ktosl eq 'JIS' or wa_bset-ktosl eq 'JRS' or wa_bset-ktosl eq 'JIU' or wa_bset-ktosl eq 'JRU'.
        wa_tax3-sgst = wa_bset-hwste.
      elseif wa_bset-ktosl eq 'JII' or wa_bset-ktosl eq 'JRI' or wa_bset-ktosl eq 'JIM'.
        wa_tax3-igst = wa_bset-hwste.
      elseif wa_bset-ktosl eq 'JCI' or wa_bset-ktosl eq 'JCR'.
        wa_tax3-cess = wa_bset-hwste.
      else.
        wa_tax3-othr = wa_bset-hwste.
      endif.
      collect wa_tax3 into it_tax3.
      clear wa_tax3.
    endloop.
  endloop.

*  LOOP AT IT_TAX3 INTO WA_TAX3.
*
*    ENDLOOP.



*  LOOP AT IT_RPM2 INTO WA_RPM2.
*    WA_RPM3-MATNR = WA_RPM2-MATNR.
*    WA_RPM3-CHARG = WA_RPM2-CHARG.
*    WA_RPM3-RPEBELN = WA_RPM2-RPEBELN.
*    WA_RPM3-RPEBELP = WA_RPM2-RPEBELP.
*    WA_RPM3-RPMBLNR = WA_RPM2-RPMBLNR.
*    WA_RPM3-RPMJAHR =  WA_RPM2-RPMJAHR.
*    WA_RPM3-RPLINE_ID = WA_RPM2-RPLINE_ID.
*    SELECT SINGLE * FROM MSEG WHERE MBLNR EQ WA_RPM2-RPMBLNR AND MJAHR EQ WA_RPM2-RPMJAHR  AND MATNR EQ WA_RPM2-MATNR
*       AND CHARG EQ  WA_RPM2-CHARG.
*    IF SY-SUBRC EQ 0.
*      READ TABLE IT_RSEG INTO WA_RSEG WITH KEY BUZEI = MSEG-LINE_ID EBELN = WA_RPM2-RPEBELN EBELP = WA_RPM2-RPEBELP LFBNR = WA_RPM2-RPMBLNR
*      LFGJA = WA_RPM2-RPMJAHR MATNR = WA_RPM2-MATNR.
*      IF SY-SUBRC EQ 0.
*        WA_RPM3-RPBELNR = WA_RSEG-BELNR.
*        WA_RPM3-RPGJAHR =  WA_RSEG-GJAHR.
*        WA_RPM3-RPXBLNR =  WA_RSEG-XBLNR.
*        WA_RPM3-RPMWSKZ =  WA_RSEG-MWSKZ.
*        WA_RPM3-WRBTR =  WA_RSEG-WRBTR.
*        CLEAR: AWKEY.
*        CONCATENATE WA_RSEG-BELNR WA_RSEG-GJAHR INTO AWKEY.
*        SELECT SINGLE * FROM BKPF WHERE BUKRS EQ 'BCLL' AND GJAHR EQ WA_RSEG-GJAHR AND AWKEY = AWKEY.
*        IF SY-SUBRC EQ 0.
*          WA_RPM3-RPFIDOC = BKPF-BELNR.
*          WA_RPM3-RPFIDOCYR =  BKPF-GJAHR.
*          SELECT SINGLE * FROM BSET WHERE BUKRS EQ 'BCLL' AND BELNR EQ BKPF-BELNR AND GJAHR EQ BKPF-GJAHR AND
*            BUZEI EQ WA_RSEG-LFPOS.
*          IF SY-SUBRC EQ 0.
*            WA_RPM3-HWSTE = BSET-HWSTE.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*    COLLECT WA_RPM3 INTO IT_RPM3.
*    CLEAR WA_RPM3.
*  ENDLOOP.



endform.
*&---------------------------------------------------------------------*
*&      Form  301MOV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form 301mov .

  if it_tab2 is not initial.
    select * from mseg into table it_mseg3 for all entries in it_tab2 where mjahr ge '2023' and bwart in ('301','302') and matnr eq it_tab2-matnr and werks eq it_tab2-werks and charg
      eq it_tab2-charg.
  endif.

  loop at it_mseg3 into wa_mseg3.
    wa_rev1-mblnr = wa_mseg3-smbln.
    collect wa_rev1 into it_rev1.
    clear wa_rev1.
  endloop.
  sort it_rev1 by mblnr.
  delete it_mseg3 where bwart eq '302'.
  loop at it_mseg3 into wa_mseg3.
    read table it_rev1 into wa_rev1 with key mblnr = wa_mseg3-mblnr.
    if sy-subrc eq 0.
      delete it_mseg3 where mblnr eq wa_rev1-mblnr.
    endif.
  endloop.

endform.
