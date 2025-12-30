*&---------------------------------------------------------------------*
*& Report ZRCM_ISD_PRINT_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRCM_ISD_PRINT_REPORT.


constants : rbselected type c length 1 value 'X'.


tables : vbrk,
         j_1imtchid,
         j_1ichidtx,
         mcha,
         thead,
         nast,
         vbdkr,
         vbrp,
         vbfa,
         lfa1,
         zrcm_data_det,
         zrcm_header,
         likp,
         t001,
         spell,
         j_1iexcdtl,
         stxh,
         mara,
         marc,
         mseg,
         mkpf,
         ekko,
         ekpo,
         zdel_ch,
         t001w,
         adrc,
         kna1,
         t005u,
         zisd_invoice.

data :  result      like  itcpp.
data : options        type itcpo,
       l_otf_data     like itcoo occurs 10,
       l_asc_data     like tline occurs 10,
       l_docs         like docs  occurs 10,
       l_pdf_data     like solisti1 occurs 10,
       l_pdf_data1    like solisti1 occurs 10,
       l_bin_filesize type i.

data: docdata like solisti1  occurs  10,
      objhead like solisti1  occurs  1,
      objbin1 like solisti1  occurs 10,
      objbin  like solisti1  occurs 10.


data righe_attachment type i.
data righe_testo type i.
data: doc_chng like sodocchgi1.
data: ltx like t247-ltx.
data reclist    like somlreci1  occurs  1 with header line.
data mcount type i.



data  begin of objpack occurs 0 .
        include structure  sopcklsti1.
data end of objpack.

data begin of objtxt occurs 0.
        include structure solisti1.
data end of objtxt.






data : it_vbrk         type table of vbrk,
       wa_vbrk         type vbrk,
       it_vbrp         type table of vbrp,
       wa_vbrp         type vbrp,
       it_ekko         type table of ekko,
       wa_ekko         type ekko,
       it_ekpo         type table of ekpo,
       wa_ekpo         type ekpo,
       it_zdel_ch      type table of zdel_ch,
       wa_zdel_ch      type zdel_ch,
       it_zisd_invoice type table of zisd_invoice,
       wa_zisd_invoice type zisd_invoice.



types : begin of imat1,
          mattext(25),
          matnr       like vbrp-matnr,
        end of imat1.

data : it_mat1 type table of imat1,
       wa_mat1 type imat1.

data :
*      z_j_1ichid like j_1imtchid-j_1ichid,
  z_j_1ichid   like marc-steuc,
  z_mvgr5      like mvke-mvgr5,
  z_kondm      like mvke-kondm,
  kondm(4)     type c,
  z_bezei      like tvm5t-bezei,
  exp          like mcha-vfdat,
  exp1(7)      type c,
  z_knumv      like vbrk-knumv,
  mknumv       like vbrk-vbeln,
  z60          like PRCD_elements-kwert,
  totmrpv      like j_1iexcdtl-exbas,
  z40          like PRCD_elements-kwert,
  z15          like PRCD_elements-kwert,
  zgrp         like PRCD_elements-kwert,
  zsam         like PRCD_elements-kwert,
  z20          like PRCD_elements-kawrt,
  joig_rt      like PRCD_elements-kawrt,
  joig_amt     like PRCD_elements-kawrt,
  zjmod        like PRCD_elements-kwert,
  qty          type i,
  pqty         type i,
  pqty_l       type i,
  totcase(5)   type n,
  totalnocase  type i,
  totalnocase1 type i,
  totcase1     type i,
  looseqty(5)  type n,
  qty_l(5)     type n,
  mumrez       like marm-umrez,
  value        like vbrp-netwr,
  tax          type i,
  simple1      like stxh-tdname,
  text1(50),
  cases        type p,
  text(19)     type c,
  text2(30)    type c,
  p_text2(150) type c,
  s_docno1(10) type c.

data  totalpts type p decimals 2.
data  toted16 type i.
data  toted161 type i.
data : toted162   like pc207-betrg,
       words(200) type c.
data  toted163 type i.
data  edvalue like j_1iexcdtl-exbas.
data  edvalue1 like j_1iexcdtl-exbas.
data  edvalue2 like j_1iexcdtl-exbas.
data  totqty type p decimals 0.
data  toted  like j_1iexcdtl-exbas.
data:
*      totval type i,
  totval       like vbrp-netwr,
  ztotval      type i,
  ztotrtamt    type i,
  ztotaxval    type i,
  ztotrtamt1   type p decimals 2,
  ztothwbas    type p decimals 2,
  ztotcgst     type p decimals 2,
  ztotsgst     type p decimals 2,
  ztotigst     type p decimals 2,
  ztotaxval1   type p decimals 2,
  ztotval1(10) type p decimals 2,
  gstrate      type p decimals 2,
  igstrate     type p decimals 2,
  srl(3)       type p decimals 0,
  gstno(30)    type c,
  bcval        type i,
  xlval        type i.
data total_1 like PRCD_elements-kwert.
data wor    like spell.
data netword1 like spell.
data netword2 like spell.

data  totalval type i.
data  plant like ausp-atwrt.
data  m_cuobj like inob-cuobj.
data  n_cuobj(50) type c.
data  inv like vbrk-vbeln.
data  party1 like ekko-ekorg.
data  rnd type i.
data  w_chapid like j_1imtchid-j_1ichid.
data : mchar(50) type c value '  '.
data : linecount(2) type n.
data : totalquantity like j_1iexcdtl-menge.
data : z_exnum like j_1iexcdtl-exnum.
data : z_cputm like j_1iexcdtl-cputm.
data : z_rdoc1 like j_1iexcdtl-rdoc1.
data : htext1 like mkpf-bktxt.
data : htext2 like mkpf-xblnr.
data : simple  like stxh-tdname.
data : z_btgew like likp-btgew.
data : z_bolnr like likp-bolnr.
data : z_vbeln like likp-vbeln.
data : werks       like vbrp-werks,
       p_text1(70) type c.
data : z_kunag like vbrk-kunag.
data : z_fkdat like vbrk-fkdat.
data : z_kunnr like t001w-kunnr.
data : z_adrnr like t001w-adrnr,
       z_ort01 like t001w-ort01,
       z_regio like t001w-regio.
data : z_adrnr1 like kna1-adrnr,
       stcd3    like kna1-stcd3.

data : itline like tline occurs 0 with header line.
data : itline1 like tline occurs 0 with header line.
data : nocase(5).

data : v_belnr like bkpf-belnr,
       z_zfbdt like bsid-zfbdt.
data : v_gjahr like bkpf-gjahr.

data : p_kunnr like t001w-kunnr.
data : p_adrnr like t001w-adrnr,
       p_regio like t001w-regio.
data : p_adrnr1 like kna1-adrnr,
       p_stcd3  like kna1-stcd3.

data : z_name1 like adrc-name1,
       z_name2 like adrc-name2,
       z_name3 like adrc-name3,
       z_name4 like adrc-name4,
       z_state like t005u-bezei.

data : p_name1      like adrc-name1,
       p_name2      like adrc-name2,
       p_name3      like adrc-name3,
       p_name4      like adrc-name4,
       p_extension1 type adrc-extension1.

data : taigst type zisd_invoice-aigst,
       tacgst type zisd_invoice-acgst,
       tasgst type zisd_invoice-asgst,
       tacess type zisd_invoice-acess.

data : tdigst type zisd_invoice-aigst,
       tdcgst type zisd_invoice-acgst,
       tdsgst type zisd_invoice-asgst,
       tdcess type zisd_invoice-acess.

data : z_extension1(40) type c.
data : z_transpzone like adrc-transpzone.
data : z_j_1icstno like j_1imocust-j_1icstno,
       z_j_1ilstno like j_1imocust-j_1ilstno.
data : z_lifnr like vbpa-lifnr,
       w_name1 like lfa1-name1,
       w_ort01 like lfa1-ort01.
data  num(70).
data : mmline  like tline occurs 0 with header line.
data : mmline1 like tline occurs 0 with header line.
data lrno like  tline-tdline.
data vehicleno like  tline-tdline.
data: retcode   like sy-subrc.         "Returncode
data trp like lfa1-lifnr.
data trpname like lfa1-name1.
data: xscreen(1) type c.
data : total like j_1iexcdtl-exbas.
*DATA : totcase(5) TYPE n.
*DATA : totalnocase(4) TYPE c.
*DATA : looseqty(5) TYPE n.
*DATA : linecount(2) TYPE n.
data  tot_ed1 like j_1iexcdtl-exbas.
data  tot_ed2 like j_1iexcdtl-exbas.
data  tot_ed like j_1iexcdtl-exbas.
data  t_total like j_1iexcdtl-exbas.
data inv_no like vbrk-vbeln.
data : inv_no1  like zisd_invoice-invoice,
       txt1(10) type c,
       mon(7)   type c.

data : it_rcm_header like zrcm_header occurs 0 with header line.
data : it_rcm_data_det like zrcm_data_det occurs 0 with header line.
data : wa_rcm_data_det type zrcm_data_det.
field-symbols:
   <fs_rcm_header> like zrcm_header         .

types : begin of typ_tab1,
          gjahr    type gjahr,
          vbeln    type vbeln_vf,
          bupla    type bupla,
          fkdat    type fkdat,
          belnr    type   belnr_d,
          gjahr_b  type   gjahr,
          hkont    type   hkont,
          steuc    type   steuc,
          dmbtr    type   p decimals 2,"dmbtr,
          hwbas    type   p decimals 2,
          hwste    type   hwste,
          igst     type  p decimals 2," hwste,
          cgst     type   p decimals 2," hwste,
          sgst     type  p decimals 2," hwste,
          ugst     type   hwste,
          rate     type    belnr_d,
          lifnr    type     lifnr,
          name1    type     name1_gp,
          ort01    type     ort01_gp,
          stcd3    type     stcd3,
          regio    type     regio,
          stras    type     lfa1-stras,
          pstlz    type     lfa1-pstlz,
          j_1icht1 type j_1ichidtx-j_1icht1,
          menge    type menge_d,
          meins    type meins,
          ref      type zrcm_data_det-ref,
          refdat   type sy-datum,

        end of typ_tab1.
types: begin of inv1,
         vbeln type zisd_invoice-vbeln,
         gjahr type zisd_invoice-gjahr,
       end of inv1.

data : wa_itab1 type typ_tab1.
data : it_itab1 type table of typ_tab1,
       it_inv1  type table of inv1,
       wa_inv1  type inv1.



types : begin of itab1,
          charg        type vbrp-charg,
          plant        like ausp-atwrt,
          j_1ichid     like j_1imtchid-j_1ichid,
          bezei        like tvm5t-bezei,
          exp1(7)      type c,
          z60          like PRCD_elements-kwert,
          fkimg        type p decimals 0,
          totmrpv      like j_1iexcdtl-exbas,
          z40          like PRCD_elements-kwert,
          z15          like PRCD_elements-kwert,
          zgrp         like PRCD_elements-kwert,
          z20          type p decimals 2,
          joig_rt(7)   type c,
          joig_amt(10) type c,

          zjmod        like PRCD_elements-kwert,
          qty          type i,
          pqty         type i,
          pqty_l       type i,
          totcase(5)   type n,
          totalnocase  type i,
          totalnocase1 type i,
          totcase1     type i,
          looseqty(5)  type n,
          qty_l(5)     type n,
          mumrez       like marm-umrez,
          value        type p decimals 2,
          totva        type p decimals 2,
          totalpts     like j_1iexcdtl-exbas,
          toted16      like j_1iexcdtl-exbas,
          toted161     like j_1iexcdtl-exbas,
          toted162     like j_1iexcdtl-exbas,
          toted163     like j_1iexcdtl-exbas,
          edvalue      like j_1iexcdtl-exbas,
          edvalue1     like j_1iexcdtl-exbas,
          edvalue2     like j_1iexcdtl-exbas,
          totqty       like j_1iexcdtl-menge,
          toted        like j_1iexcdtl-exbas,
          totval       like j_1iexcdtl-exbas,
          totalval     like j_1iexcdtl-exbas,
          tot_ed       like j_1iexcdtl-exbas,
          tot_ed1      like j_1iexcdtl-exbas,
          tot_ed2      like j_1iexcdtl-exbas,
*       tot_ed like j_1iexcdtl-exbas,
          t_total      like j_1iexcdtl-exbas,
          posnr        type vbrp-posnr,
          arktx        type vbrp-arktx,
          mfg_by(10)   type c,
          kondm(4)     type c,
        end of itab1.
data : mesg(40) type c.
data : it_tab1 type table of itab1,
       wa_tab1 type itab1.

data : zdel_ch_wa type zdel_ch,
       no(10)     type n,
       planr      type vbrp-werks.

selection-screen  begin of block bl1 with frame title text-001.
parameters : r1 radiobutton group r1.
select-options : s_docno for vbrk-vbeln .
parameters: fyear type bkpf-gjahr,
            bupla like bseg-bupla.
parameters : addr like t001w-werks.
*               aaa as CHECKBOX.
parameters : s_nocopy(2) type p  default 1.

parameter       r2 radiobutton group r1.

select-options : isdinv for zisd_invoice-vbeln.
parameters : year like zisd_invoice-gjahr.

selection-screen : end of block bl1.

*selection-screen  begin of block bl3 with frame title text-002.
*
*parameters : p_car as checkbox.
*
*selection-screen : end of block bl3.

selection-screen  begin of block bl2 with frame title text-002.
*parameters  :  p_rad1 radiobutton group r1  user-command radio default 'X'.
*               p_rad2 radiobutton group r1,
*               p_rad3 radiobutton group r1 .



selection-screen : end of block bl2.

selection-screen  begin of block bl5 with frame title text-002.

*if p_rad3 = rbselected .
*  parameter: p_email1 like somlreci1-receiver     modif id sp2 .
*
*endif.

selection-screen : end of block bl5.



at selection-screen output.
  loop at screen.
*    if p_rad3 = 'X'.
*      if screen-group1 = 'SP2'.
*        screen-input = '1'.
*        screen-invisible = '0'.
*        screen-required = '0'.
*      endif.
*    else.
    if screen-group1 = 'SP2'.
      screen-input = '0'.
      screen-invisible = '1'.
      screen-required = '0'.

    endif.

*    endif.
    modify screen.
  endloop.







at selection-screen.

*  SELECT SINGLE * FROM ZRCM_HEADER  WHERE VBELN EQ S_DOCNO-LOW .
*  IF SY-SUBRC NE 0.
*    MESSAGE 'ENTER VALID INVOICE NO' TYPE 'E'.
*  ENDIF.





start-of-selection.
  if r1 eq 'X'.
    if s_docno is initial.
      message 'ENTER INVOICE NUMBER' type 'I'.
      exit.
    endif.

*    SELECT SINGLE * FROM ZRCM_HEADER  WHERE VBELN EQ S_DOCNO-LOW .
*    IF SY-SUBRC NE 0.
*      MESSAGE 'ENTER VALID INVOICE NO' TYPE 'E'.
*    ENDIF.
    perform taxinv_print.
  elseif r2 eq 'X'.
    if isdinv is initial.
      message 'ENTER INVOICE NUMBER' type 'I'.
      exit.
    endif.
    if year is initial.
      message 'ENTER INVOICE YEAR' type 'I'.
      exit.
    endif.
    perform isd_print.
  endif.

form taxinv_print.
  select * from zrcm_data_det into table it_rcm_data_det where vbeln in s_docno and gjahr eq fyear and bupla eq bupla.
  select * from zrcm_header into table it_rcm_header where vbeln in s_docno and gjahr eq fyear and bupla eq bupla.
  text = 'RCM TAX INVOICE NO.'.
  text2 = 'RCM TAX INVOICE'.
  p_text2 = '(Issued under sec. 31(3) (F) of cgst act, 2017)'.
  data : wa_itcpo type  itcpo.
  wa_itcpo-tdcopies = s_nocopy.


  call function 'OPEN_FORM'
    exporting
      device                      = 'PRINTER'
      dialog                      = 'X'
      language                    = sy-langu
      options                     = wa_itcpo
    exceptions
      canceled                    = 1
      device                      = 2
      form                        = 3
      options                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      others                      = 12.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
      with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.



  loop at  it_rcm_header assigning <fs_rcm_header>.
    z_fkdat = <fs_rcm_header>-fkdat.
    inv_no = <fs_rcm_header>-vbeln.


    read table it_vbrp into wa_vbrp with key vbeln = s_docno-low.
    if sy-subrc eq 0.
      werks = wa_vbrp-werks.
    endif.
    read table it_vbrp into wa_vbrp with key vbeln = s_docno-low.
    if sy-subrc eq 0.
      z_rdoc1 = wa_vbrp-vgbel.
    endif.
    select single * from mkpf where mblnr eq z_rdoc1.
    if sy-subrc eq 0.
      htext1 = mkpf-bktxt.
      htext2 = mkpf-xblnr.
    endif.

* select single belnr gjahr into (v_belnr, v_gjahr) from bkpf where awtyp eq 'VBRK' and awkey eq S_DOCNO-LOW and bukrs eq vbrk-bukrs.
    select single zfbdt into z_zfbdt from bsid where bukrs eq '1000' and zuonr eq s_docno-low.
******************* test**********************
    call function 'START_FORM'
      exporting
*       form        = 'ZRCM2'
        form        = 'ZRCM2_1'
        language    = sy-langu
      exceptions
        form        = 1
        format      = 2
        unended     = 3
        unopened    = 4
        unused      = 5
        spool_error = 6
        codepage    = 7
        others      = 8.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    select single * from t001w where werks eq addr.
    if sy-subrc eq 0.
      select single * from adrc where addrnumber eq t001w-adrnr.
      if sy-subrc eq 0.

        if adrc-region ne <fs_rcm_header>-bupla.
          message 'CHECK PLANT' type 'E'.
          exit.
        endif.

        z_name1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
        z_name2 = adrc-name2.
        z_name3 = adrc-name3.
        z_name4 = adrc-city1.
        select single * from t005u where spras eq 'EN' and land1 eq 'IN' and bland eq adrc-region.
        if sy-subrc eq 0.
          z_state = t005u-bezei.
        endif.

        select single * from kna1 where kunnr eq t001w-kunnr.
        if sy-subrc eq 0.
          stcd3 = kna1-stcd3.
          p_stcd3 = kna1-stcd3.
          p_extension1 = 'BD/25 & BD/28'.
        endif.
        z_extension1 = 'BD/25 & BD/28'.
        werks = adrc.
        if werks eq '1000'.
          p_text1 = 'Nasik factory wholesale Licence No- 20B/MH/NZ-1/1399, 21B/MH/NZ-1/1329'.
        elseif werks eq '1001'.
          p_text1 = 'Goa factory wholesale Licence No- GA-SGO-5287,  GA-SGO-5288 dated 22.04.2016'.
        endif.


        p_name1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
        p_name2 = adrc-name2.
        p_name3 = adrc-name3.
        p_name4 = adrc-city1.

      endif.
    endif.
*    z_name1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
*    z_name2 = 'A-12, MIDC ' .
*    z_name3 = 'AMBAD NASHIK-422010'.
*    z_name4 = ''.
*    stcd3 = '27AAACB1549GIZX'.
*    z_extension1 = 'BD/25 & BD/28'.
*    werks = '1000'.
*    if werks eq '1000'.
*      p_text1 = 'Nasik factory wholesale Licence No- 20B/MH/NZ-1/1399, 21B/MH/NZ-1/1329'.
*    elseif werks eq '1001'.
*      p_text1 = 'Goa factory wholesale Licence No- GA-SGO-5287,  GA-SGO-5288 dated 22.04.2016'.
*    endif.
*
*
*    p_name1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
*    p_name2 = 'A-12, MIDC ' .
*    p_name3 = 'AMBAD NASHIK-422010'.
*    p_name4 = ''.
*    p_stcd3 = '27AAACB1549GIZX'.
*    p_extension1 = 'BD/25 & BD/28'.
*    .


    call function 'WRITE_FORM'
      exporting
        window = 'HEADER'.


    call function 'WRITE_FORM'
      exporting
        element = 'LAY_OUT'
        window  = 'MAIN'
      exceptions
        others  = 1.
    if sy-subrc ne 0.
    endif.


    srl = 0.
    loop at it_rcm_data_det into wa_rcm_data_det where vbeln =  <fs_rcm_header>-vbeln .
      srl = srl + 1 .
      wa_itab1-gjahr  = wa_rcm_data_det-gjahr.
      wa_itab1-vbeln  = wa_rcm_data_det-vbeln.
      wa_itab1-bupla  = wa_rcm_data_det-bupla.
      wa_itab1-fkdat  = wa_rcm_data_det-fkdat.
      wa_itab1-belnr  = wa_rcm_data_det-belnr.
      wa_itab1-gjahr_b  = wa_rcm_data_det-gjahr.
      wa_itab1-hkont  = wa_rcm_data_det-hkont.
      wa_itab1-steuc  = wa_rcm_data_det-steuc.
      wa_itab1-dmbtr  = wa_rcm_data_det-dmbtr.
      wa_itab1-hwbas  = wa_rcm_data_det-hwbas.
      wa_itab1-hwste  = wa_rcm_data_det-hwste.
      wa_itab1-igst  = wa_rcm_data_det-igst.
      wa_itab1-cgst  = wa_rcm_data_det-cgst.
      if wa_rcm_data_det-ugst gt 0.
        wa_itab1-sgst  = wa_rcm_data_det-ugst.
      else.
        wa_itab1-sgst  = wa_rcm_data_det-sgst.
      endif.
    "  wa_itab1-sgst  = wa_rcm_data_det-cgst. " added by rushi
      wa_itab1-rate  = wa_rcm_data_det-rate.
      wa_itab1-lifnr  = wa_rcm_data_det-lifnr.
      wa_itab1-name1  = wa_rcm_data_det-name1.
      wa_itab1-ort01  = wa_rcm_data_det-ort01.
      wa_itab1-stcd3  = wa_rcm_data_det-stcd3.
      wa_itab1-regio  = wa_rcm_data_det-regio.
      wa_itab1-menge  = wa_rcm_data_det-menge.
      wa_itab1-meins  = wa_rcm_data_det-meins.
      wa_itab1-ref  = wa_rcm_data_det-ref.
      wa_itab1-refdat  = wa_rcm_data_det-refdat.
      concatenate 'GST : ' wa_itab1-stcd3 ',STATE :' wa_itab1-regio into gstno .
      select single * from lfa1 where lifnr = wa_rcm_data_det-lifnr.
      if sy-subrc = 0.
        wa_itab1-stras  = lfa1-stras.
        wa_itab1-pstlz  = lfa1-pstlz.
      endif.
      select single * from j_1ichidtx where j_1ichid =  wa_rcm_data_det-steuc.
      if sy-subrc = 0.
        wa_itab1-j_1icht1  = j_1ichidtx-j_1icht1.
      endif.
      gstrate = 0.
      igstrate = 0.
      if wa_itab1-cgst > 0.
        gstrate = wa_itab1-rate / 2.
      else.
        igstrate = wa_itab1-rate.
      endif.
      if  wa_itab1-menge  > 0.
        ztotval1 =   wa_itab1-hwbas / wa_itab1-menge .
      else.
        ztotval1 =   wa_itab1-hwbas  .
      endif.
      ztotrtamt1 = ztotrtamt1 +  wa_itab1-dmbtr .
      ztothwbas = ztothwbas +  wa_itab1-hwbas.
      ztotcgst = ztotcgst +  wa_itab1-cgst.
      ztotsgst = ztotsgst +  wa_itab1-sgst.
      ztotigst = ztotigst +  wa_itab1-igst.


      call function 'WRITE_FORM'
        exporting
          element = 'ITEM_DETAIL'
        exceptions
          others  = 1.
      if sy-subrc ne 0.
*          PERFORM protocol_update.
      endif.

      call function 'WRITE_FORM'
        exporting
          element = 'LAY_OUT'
          window  = 'MAIN'
        exceptions
          others  = 1.
      if sy-subrc ne 0.
      endif.



      clear wa_itab1.


    endloop.


    call function 'Z_SPELL_AMOUNT_INDIA'
      exporting
        amount   = ztotrtamt1
        language = sy-langu
      importing
        in_words = wor.
    write wor-word to netword1-word.
    shift netword1-word left deleting leading space.
    shift netword1-word left deleting leading '0'.
    shift netword1-word left deleting leading '#'.
    shift netword1-word left deleting leading space(1).
    if ztotrtamt1 gt 0.
      call function 'Z_SPELL_AMOUNT_INDIA'
        exporting
          amount   = ztotrtamt1
          language = sy-langu
        importing
          in_words = wor.
      write wor-word to netword2-word.
      shift netword2-word left deleting leading space.
      shift netword2-word left deleting leading '0'.
      shift netword2-word left deleting leading '#'.
      shift netword2-word left deleting leading space(1).
    else.
      write 'ZERO' to netword2-word.
    endif.

    call function 'WRITE_FORM'
      exporting
        element = 'PAGE_NO'
        window  = 'FOOTER'
      exceptions
        others  = 1.
    call function 'WRITE_FORM'
      exporting
        element = 'PAGE_NO'
        window  = 'WINDOW4'
      exceptions
        others  = 1.







    call function 'END_FORM'
      exceptions
        unopened                 = 1
        bad_pageformat_for_print = 2
        spool_error              = 3
        codepage                 = 4
        others                   = 5.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    data : z_toted16 type p decimals 2.
    data : z_toted161 type p decimals 2.
    data : z_toted163 type p decimals 2.
    data : z_totval type p decimals 2.
    data : z_totalpts type p decimals 2.
    data : z_totalpts_1 type i.
    data : z_totalval type p decimals 2.

    toted162 = toted16 + toted161 + toted163.
    z_toted16 = toted16.
    z_toted161 = toted161.
    z_toted163 = toted163.
    t_total = totval + tot_ed + tot_ed1 + tot_ed2.

    totcase1 =   totalnocase +   totalnocase1.


    toted162 = toted162.

    call function 'HR_IN_CHG_INR_WRDS'
      exporting
        amt_in_num         = toted162
      importing
        amt_in_words       = words
      exceptions
        data_type_mismatch = 1
        others             = 2.
    if sy-subrc <> 0.
    endif.
    concatenate words 'ONLY' into spell-word separated by space.


    z_totval = totval.
    z_totalpts_1 = totalpts.
    z_totalpts = z_totalpts_1.
    z_totalval = totalval.



    clear : ztothwbas,ztotcgst,ztotsgst,ztotigst,ztotrtamt1.

  endloop.

  call function 'CLOSE_FORM'
* IMPORTING
*   RESULT                         =
*   RDI_RESULT                     =
* TABLES
*   OTFDATA                        =
    exceptions
      unopened                 = 1
      bad_pageformat_for_print = 2
      send_error               = 3
      spool_error              = 4
      codepage                 = 5
      others                   = 6.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.




endform.


*&---------------------------------------------------------------------*
*&      Form  casecount
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form casecount.

  linecount = 0.
  totalquantity = 0.
  loop at it_vbrp into wa_vbrp.
    totalquantity = totalquantity + wa_vbrp-fkimg.
    linecount = linecount + 1.
  endloop.
  select single umrez from marm into mumrez
  where matnr = wa_vbrp-matnr and meinh = 'SPR'.
  pqty =  totalquantity / 1000.
  totcase = pqty div mumrez.
  looseqty = pqty mod mumrez.

endform.                    "casecount

*&---------------------------------------------------------------------*
*&      Form  protocol_update
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form protocol_update.

  check xscreen = space.
  call function 'NAST_PROTOCOL_UPDATE'
    exporting
      msg_arbgb = syst-msgid
      msg_nr    = syst-msgno
      msg_ty    = syst-msgty
      msg_v1    = syst-msgv1
      msg_v2    = syst-msgv2
      msg_v3    = syst-msgv3
      msg_v4    = syst-msgv4
    exceptions
      others    = 1.

endform.                    "protocol_update
*&---------------------------------------------------------------------*
*&      Form  CHALLAN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM CHALLAN .
*SELECT SINGLE * FROM EKKO WHERE EBELN EQ S_DOCNO-LOW AND BSART EQ 'ZNIV'.
*  IF SY-SUBRC NE 0.
*    MESSAGE 'NON- INVENTORY PURCHASE ORDER NOT FOUND' TYPE 'I'.
*    EXIT.
*  ENDIF.
*  SELECT SINGLE * FROM ZDEL_CH WHERE EBELN EQ S_DOCNO-LOW AND MBLNR NE '          '.
*  IF SY-SUBRC EQ 0.
*    MESSAGE 'DELIVERY CHALLAN ALREADY GENERATED FOR THIS PURCHASE ORDER' TYPE 'I'.
*    EXIT.
*  ENDIF.
*CLEAR : PLANT,NO.
*SELECT SINGLE * FROM EKKO WHERE EBELN EQ S_DOCNO-LOW.
*  IF SY-SUBRC EQ 0.
*    SELECT SINGLE * FROM EKPO WHERE EBELN EQ EKKO-EBELN.
*      IF SY-SUBRC EQ 0.
*         PLANT = EKPO-WERKS.
*      ENDIF.
*  ENDIF.
*
*  SELECT * FROM ZDEL_CH INTO TABLE IT_ZDEL_CH WHERE WERKS EQ PLANT.
*  SORT IT_ZDEL_CH DESCENDING BY MBLNR.
*
*    ZDEL_CH_WA-EBELN = S_DOCNO-LOW.
*    ZDEL_CH_WA-WERKS = PLANT.
*    READ TABLE IT_ZDEL_CH INTO WA_ZDEL_CH WITH KEY WERKS = PLANT.
*      IF SY-SUBRC EQ 0.
*        NO = WA_ZDEL_CH-MBLNR + 1.
*      ELSE.
*        NO = 1.
*      ENDIF.
*      ZDEL_CH_WA-MBLNR = NO.
*    MODIFY ZDEL_CH FROM ZDEL_CH_WA.
*
*  MESSAGE 'DATA UPDATE' TYPE 'I'.
*
**  SELECT * FROM ZDEL_CH INTO TABLE IT_ZDEL_CH.
**    SORT IT_ZDEL_CH by werks DESCENDING MBLNR.
***    LOOP AT IT_ZDEL_CH INTO WA_ZDEL_CH.
**      READ TABLE IT_ZDEL_CH INTO WA_ZDEL_CH WITH KEY EBELN = S_DOCNO-LOW WERKS = PLANT.
**      IF SY-SUBRC EQ 0.
**        IF WA_ZDEL_CH-MBLNR EQ '          '.
**          NO = 1.
**        ELSE.
**          NO = WA_ZDEL_CH-MBLNR + 1.
**        ENDIF.
**         ZDEL_CH_WA-MBLNR = NO.
**        MODIFY ZDEL_CH FROM ZDEL_CH_WA.
**      ENDIF.
***    ENDLOOP.
*
*ENDFORM.

form email_add.
  options-tdgetotf = 'X'.

  select * from zrcm_data_det into table it_rcm_data_det where vbeln in s_docno.
  select * from zrcm_header into table it_rcm_header where vbeln in s_docno.
  text = 'RCM TAX INVOICE NO.'.
  text2 = 'RCM TAX INVOICE'.
  p_text2 = '(Issued under sec. 31(3) (F) of cgst act,2017)'.
  data : wa_itcpo type  itcpo.
  wa_itcpo-tdcopies = s_nocopy.


*  loop at itab_vbrk.
  call function 'OPEN_FORM'
    exporting
*     device                      = 'PRINTER'
      dialog                      = ''
      language                    = sy-langu
      options                     = options
    exceptions
      canceled                    = 1
      device                      = 2
      form                        = 3
      options                     = 4
      unclosed                    = 5
      mail_options                = 6
      archive_error               = 7
      invalid_fax_number          = 8
      more_params_needed_in_batch = 9
      spool_error                 = 10
      codepage                    = 11
      others                      = 12.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.


  loop at  it_rcm_header assigning <fs_rcm_header>.
    z_fkdat = <fs_rcm_header>-fkdat.
    inv_no = <fs_rcm_header>-vbeln.


    read table it_vbrp into wa_vbrp with key vbeln = s_docno-low.
    if sy-subrc eq 0.
      werks = wa_vbrp-werks.
    endif.
    read table it_vbrp into wa_vbrp with key vbeln = s_docno-low.
    if sy-subrc eq 0.
      z_rdoc1 = wa_vbrp-vgbel.
    endif.
    select single * from mkpf where mblnr eq z_rdoc1.
    if sy-subrc eq 0.
      htext1 = mkpf-bktxt.
      htext2 = mkpf-xblnr.
    endif.

* select single belnr gjahr into (v_belnr, v_gjahr) from bkpf where awtyp eq 'VBRK' and awkey eq S_DOCNO-LOW and bukrs eq vbrk-bukrs.
    select single zfbdt into z_zfbdt from bsid where bukrs eq '1000' and zuonr eq s_docno-low.
******************* test**********************
    call function 'START_FORM'
      exporting
        form        = 'ZRCM'
        language    = sy-langu
      exceptions
        form        = 1
        format      = 2
        unended     = 3
        unopened    = 4
        unused      = 5
        spool_error = 6
        codepage    = 7
        others      = 8.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
    z_name1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
    z_name2 = 'A-12, MIDC ' .
    z_name3 = 'AMBAD NASHIK-422010'.
    z_name4 = ''.
    stcd3 = '27AAACB1549GIZX'.
    z_extension1 = 'BD/25 & BD/28'.
    werks = '1000'.
    if werks eq '1000'.
      p_text1 = 'Nasik factory wholesale Licence No- 20B/MH/NZ-1/1399, 21B/MH/NZ-1/1329'.
    elseif werks eq '1001'.
      p_text1 = 'Goa factory wholesale Licence No- GA-SGO-5287,  GA-SGO-5288 dated 22.04.2016'.
    endif.


    p_name1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
    p_name2 = 'A-12, MIDC ' .
    p_name3 = 'AMBAD NASHIK-422010'.
    p_name4 = ''.
    p_stcd3 = '27AAACB1549GIZX'.
    p_extension1 = 'BD/25 & BD/28'.


    call function 'WRITE_FORM'
      exporting
        window = 'HEADER'.


    call function 'WRITE_FORM'
      exporting
        element = 'LAY_OUT'
        window  = 'MAIN'
      exceptions
        others  = 1.
    if sy-subrc ne 0.
    endif.


    srl = 0.
    loop at it_rcm_data_det into wa_rcm_data_det where vbeln =  <fs_rcm_header>-vbeln .
      srl = srl + 1 .
      wa_itab1-gjahr  = wa_rcm_data_det-gjahr.
      wa_itab1-vbeln  = wa_rcm_data_det-vbeln.
      wa_itab1-bupla  = wa_rcm_data_det-bupla.
      wa_itab1-fkdat  = wa_rcm_data_det-fkdat.
      wa_itab1-belnr  = wa_rcm_data_det-belnr.
      wa_itab1-gjahr_b  = wa_rcm_data_det-gjahr.
      wa_itab1-hkont  = wa_rcm_data_det-hkont.
      wa_itab1-steuc  = wa_rcm_data_det-steuc.
      wa_itab1-dmbtr  = wa_rcm_data_det-dmbtr.
      wa_itab1-hwbas  = wa_rcm_data_det-hwbas.
      wa_itab1-hwste  = wa_rcm_data_det-hwste.
      wa_itab1-igst  = wa_rcm_data_det-igst.
      wa_itab1-cgst  = wa_rcm_data_det-cgst.
      wa_itab1-sgst  = wa_rcm_data_det-sgst.
      wa_itab1-ugst  = wa_rcm_data_det-ugst.
      wa_itab1-rate  = wa_rcm_data_det-rate.
      wa_itab1-lifnr  = wa_rcm_data_det-lifnr.
      wa_itab1-name1  = wa_rcm_data_det-name1.
      wa_itab1-ort01  = wa_rcm_data_det-ort01.
      wa_itab1-stcd3  = wa_rcm_data_det-stcd3.
      wa_itab1-regio  = wa_rcm_data_det-regio.
      wa_itab1-menge  = wa_rcm_data_det-menge.
      wa_itab1-meins  = wa_rcm_data_det-meins.

      select single * from lfa1 where lifnr = wa_rcm_data_det-lifnr.
      if sy-subrc = 0.
        wa_itab1-stras  = lfa1-stras.
        wa_itab1-pstlz  = lfa1-pstlz.
      endif.
      select single * from j_1ichidtx where j_1ichid =  wa_rcm_data_det-steuc.
      if sy-subrc = 0.
        wa_itab1-j_1icht1  = j_1ichidtx-j_1icht1.
      endif.
      gstrate = 0.
      igstrate = 0.
      if wa_itab1-cgst > 0.
        gstrate = wa_itab1-rate / 2.
      else.
        igstrate = wa_itab1-rate.
      endif.
      if  wa_itab1-menge  > 0.
        ztotval1 =   wa_itab1-hwbas / wa_itab1-menge .
      else.
        ztotval1 =   wa_itab1-hwbas  .
      endif.
      ztotrtamt1 = ztotrtamt1 +  wa_itab1-dmbtr .


      call function 'WRITE_FORM'
        exporting
          element = 'ITEM_DETAIL'
        exceptions
          others  = 1.
      if sy-subrc ne 0.
*          PERFORM protocol_update.
      endif.




      clear wa_itab1.


    endloop.

    call function 'Z_SPELL_AMOUNT_INDIA'
      exporting
        amount   = ztotrtamt1
        language = sy-langu
      importing
        in_words = wor.
    write wor-word to netword1-word.
    shift netword1-word left deleting leading space.
    shift netword1-word left deleting leading '0'.
    shift netword1-word left deleting leading '#'.
    shift netword1-word left deleting leading space(1).
    if ztotrtamt1 gt 0.
      call function 'Z_SPELL_AMOUNT_INDIA'
        exporting
          amount   = ztotrtamt1
          language = sy-langu
        importing
          in_words = wor.
      write wor-word to netword2-word.
      shift netword2-word left deleting leading space.
      shift netword2-word left deleting leading '0'.
      shift netword2-word left deleting leading '#'.
      shift netword2-word left deleting leading space(1).
    else.
      write 'ZERO' to netword2-word.
    endif.

    call function 'WRITE_FORM'
      exporting
        element = 'PAGE_NO'
        window  = 'FOOTER'
      exceptions
        others  = 1.
    call function 'WRITE_FORM'
      exporting
        element = 'PAGE_NO'
        window  = 'WINDOW4'
      exceptions
        others  = 1.







    call function 'END_FORM'
      exceptions
        unopened                 = 1
        bad_pageformat_for_print = 2
        spool_error              = 3
        codepage                 = 4
        others                   = 5.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    data : z_toted16 type p decimals 2.
    data : z_toted161 type p decimals 2.
    data : z_toted163 type p decimals 2.
    data : z_totval type p decimals 2.
    data : z_totalpts type p decimals 2.
    data : z_totalpts_1 type i.
    data : z_totalval type p decimals 2.

    toted162 = toted16 + toted161 + toted163.
    z_toted16 = toted16.
    z_toted161 = toted161.
    z_toted163 = toted163.
    t_total = totval + tot_ed + tot_ed1 + tot_ed2.

    totcase1 =   totalnocase +   totalnocase1.


    toted162 = toted162.

    call function 'HR_IN_CHG_INR_WRDS'
      exporting
        amt_in_num         = toted162
      importing
        amt_in_words       = words
      exceptions
        data_type_mismatch = 1
        others             = 2.
    if sy-subrc <> 0.
    endif.
    concatenate words 'ONLY' into spell-word separated by space.


    z_totval = totval.
    z_totalpts_1 = totalpts.
    z_totalpts = z_totalpts_1.
    z_totalval = totalval.

  endloop.


  call function 'CLOSE_FORM'
    importing
      result  = result
    tables
      otfdata = l_otf_data.

  perform mail_requirement.


*  endloop.



endform.












form mail_requirement.

*  call function 'CONVERT_OTF'
*    exporting
*      format       = 'PDF'
*    importing
*      bin_filesize = l_bin_filesize
*    tables
*      otf          = l_otf_data
*      lines        = l_asc_data.
*
*  call function 'SX_TABLE_LINE_WIDTH_CHANGE'
*    exporting
*      line_width_dst = '255'
*    tables
*      content_in     = l_asc_data
*      content_out    = objbin.
*
*
*
*  describe table objbin lines righe_attachment.
*  objtxt = 'This eMail is meant for information only. Please DO NOT REPLY'.append objtxt.
*  objtxt = '                                 '.append objtxt.
*  objtxt = 'BLUE CROSS LABORATORIES LTD.'.append objtxt.
*  describe table objtxt lines righe_testo.
*  doc_chng-obj_name = 'URGENT'.
*  doc_chng-expiry_dat = sy-datum + 10.
*  condense ltx.
*  condense objtxt.
*
**  WRITE S_begda-LOW TO wa_d1 DD/MM/YYYY.
**  WRITE S_begda-HIGH TO wa_d2 DD/MM/YYYY.
*
**      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
*  concatenate 'Domestic Invoice '  wa_itab1-vbeln  into doc_chng-obj_descr separated by space.
*  doc_chng-sensitivty = 'F'.
*  doc_chng-doc_size = righe_testo * 255 .
*
*  clear objpack-transf_bin.
*
*  objpack-head_start = 1.
*  objpack-head_num = 0.
*  objpack-body_start = 1.
*  objpack-body_num = 4.
*  objpack-doc_type = 'TXT'.
*  append objpack.
*
*  objpack-transf_bin = 'X'.
*  objpack-head_start = 1.
*  objpack-head_num = 0.
*  objpack-body_start = 1.
*  objpack-body_num = righe_attachment.
*  objpack-doc_type = 'PDF'.
*  objpack-obj_name = 'TEST'.
*  condense ltx.
*  concatenate 'Domestic Invoice '  wa_itab1-vbeln  into objpack-obj_descr separated by space.
**  concatenate 'SR-9 NET' '.' into objpack-obj_descr separated by space.
**  objpack-doc_size = righe_attachment * 255.
*  append objpack.
*  clear objpack.
*
*  reclist-receiver =   p_email1.
*  reclist-express = 'X'.
*  reclist-rec_type = 'U'.
*  reclist-notif_del = 'X'. " request delivery notification
*  reclist-notif_ndel = 'X'. " request not delivered notification
*  append reclist.
*  clear reclist.
*
*  describe table reclist lines mcount.
*  if mcount > 0.
*    data: sender like soextreci1-receiver.
****ADDED BY SATHISH.B
*    types: begin of t_usr21,
*             bname      type usr21-bname,
*             persnumber type usr21-persnumber,
*             addrnumber type usr21-addrnumber,
*           end of t_usr21.
*
*    types: begin of t_adr6,
*             addrnumber type usr21-addrnumber,
*             persnumber type usr21-persnumber,
*             smtp_addr  type adr6-smtp_addr,
*           end of t_adr6.
*
*    data: it_usr21 type table of t_usr21,
*          wa_usr21 type t_usr21,
*          it_adr6  type table of t_adr6,
*          wa_adr6  type t_adr6.
*
*    select  bname persnumber addrnumber from usr21 into table it_usr21
*        where bname = sy-uname.
*    if sy-subrc = 0.
*      select addrnumber persnumber smtp_addr from adr6 into table it_adr6
*        for all entries in it_usr21 where addrnumber = it_usr21-addrnumber
*                                    and   persnumber = it_usr21-persnumber.
*    endif.
*    loop at it_usr21 into wa_usr21.
*      read table it_adr6 into wa_adr6 with key addrnumber = wa_usr21-addrnumber.
*      if sy-subrc = 0.
*        sender = wa_adr6-smtp_addr.
*      endif.
*    endloop.
*
*    call function 'SO_DOCUMENT_SEND_API1'
*      exporting
*        document_data              = doc_chng
*        put_in_outbox              = 'X'
*        sender_address             = sender
*        sender_address_type        = 'SMTP'
**       COMMIT_WORK                = ' '
**   IMPORTING
**       SENT_TO_ALL                =
**       NEW_OBJECT_ID              =
**       SENDER_ID                  =
*      tables
*        packing_list               = objpack
**       OBJECT_HEADER              =
*        contents_bin               = objbin
*        contents_txt               = objtxt
**       CONTENTS_HEX               =
**       OBJECT_PARA                =
**       OBJECT_PARB                =
*        receivers                  = reclist
*      exceptions
*        too_many_receivers         = 1
*        document_not_sent          = 2
*        document_type_not_exist    = 3
*        operation_no_authorization = 4
*        parameter_error            = 5
*        x_error                    = 6
*        enqueue_error              = 7
*        others                     = 8.
*    if sy-subrc <> 0.
*      message id sy-msgid type sy-msgty number sy-msgno
*              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    endif.
*
*    commit work.
*    if sy-subrc eq 0.
*      write : / 'EMAIL SENT ON ',p_email1.
*    endif.
*
*    clear   : objpack,
*              objhead,
*              objtxt,
*              objbin,
*              reclist.
*
*    refresh : objpack,
*              objhead,
*              objtxt,
*              objbin,
*              reclist.
*
*  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  ISD_PRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form isd_print.

  text = 'ISD TAX INVOICE NO.'.
  text2 = 'ISD TAX INVOICE'.
*  P_NAME1 = 'BLUE CROSS LABORATORIES PVT LTD.'.
*  P_NAME2 = 'PENINSULA CHAMBERS,PENINSULA CORPORATE'.
*  P_NAME3 = 'G.K.MARG,LOWER PAREL'.
*  P_NAME4 = 'MUMBAI-400013'.
*  P_STCD3 = '27AAACB1549GIZX'.
*  P_EXTENSION1 = 'BD/25 & BD/28'.


  select * from zisd_invoice into table it_zisd_invoice where vbeln in isdinv and gjahr eq year.
  loop at it_zisd_invoice into wa_zisd_invoice.
    wa_inv1-vbeln = wa_zisd_invoice-vbeln.
    wa_inv1-gjahr = wa_zisd_invoice-gjahr.
    collect wa_inv1 into it_inv1.
    clear wa_inv1.
*    PLANT = WA_ZISD_INVOICE-WERKS.
*    Z_FKDAT = WA_ZISD_INVOICE-FKDAT.
*    INV_NO1 = WA_ZISD_INVOICE-INVOICE.
*    IF WA_ZISD_INVOICE-XEGDR EQ 'X'.
*      TXT1 = 'INELIGIBLE'.
*    ELSE.
*      TXT1 = 'ELIGIBLE'.
*    ENDIF.
*    CONCATENATE WA_ZISD_INVOICE-FORDAT+4(2) '/' WA_ZISD_INVOICE-FORDAT+0(4) INTO MON.
  endloop.
*  SELECT SINGLE * FROM T001W WHERE WERKS EQ PLANT.
*  IF SY-SUBRC EQ 0.
*    SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER EQ T001W-ADRNR.
*    IF SY-SUBRC EQ 0.
*      Z_NAME1 = ADRC-NAME1.
*      Z_NAME2 = ADRC-NAME2.
*      Z_NAME3 = ADRC-NAME3.
*      Z_NAME4 = ADRC-NAME4.
*      SELECT SINGLE * FROM KNA1 WHERE KUNNR EQ T001W-KUNNR.
*      IF SY-SUBRC EQ 0.
*        STCD3 = KNA1-STCD3.
*      ENDIF.
*    ENDIF.
*  ENDIF.
  sort it_inv1 by vbeln gjahr.
  delete adjacent duplicates from it_inv1 comparing vbeln gjahr.
  call function 'OPEN_FORM'
    exporting
      device   = 'PRINTER'
      dialog   = 'X'
*     form     = 'ZSR24_1'
      language = sy-langu
    exceptions
      canceled = 1
      device   = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.
  loop at it_inv1 into wa_inv1.
    read table it_zisd_invoice into wa_zisd_invoice with key vbeln = wa_inv1-vbeln.
    if sy-subrc eq 0.
      plant = wa_zisd_invoice-werks.
      z_fkdat = wa_zisd_invoice-fkdat.
      inv_no1 = wa_zisd_invoice-invoice.
      if wa_zisd_invoice-xegdr eq 'X'.
        txt1 = 'INELIGIBLE'.
      else.
        txt1 = 'ELIGIBLE  '.
      endif.
      concatenate wa_zisd_invoice-fordat+4(2) '/' wa_zisd_invoice-fordat+0(4) into mon.
    endif.
    select single * from t001w where werks eq plant.
    if sy-subrc eq 0.
      select single * from adrc where addrnumber eq t001w-adrnr.
      if sy-subrc eq 0.
        z_name1 = adrc-name1.
        z_name2 = adrc-name2.
        z_name3 = adrc-name3.
        z_name4 = adrc-name4.
        select single * from kna1 where kunnr eq t001w-kunnr.
        if sy-subrc eq 0.
          stcd3 = kna1-stcd3.
        endif.
      endif.
    endif.
*    LOOP AT IT_ZISD_INVOICE INTO WA_ZISD_INVOICE WHERE VBELN = WA_INV1-VBELN.
*      WA_INV1-VBELN = WA_ZISD_INVOICE-VBELN.
*      WA_INV1-GJAHR = WA_ZISD_INVOICE-GJAHR.
*      COLLECT WA_INV1 INTO IT_INV1.
*      CLEAR WA_INV1.
*      PLANT = WA_ZISD_INVOICE-WERKS.
*      Z_FKDAT = WA_ZISD_INVOICE-FKDAT.
*      INV_NO1 = WA_ZISD_INVOICE-INVOICE.
*      IF WA_ZISD_INVOICE-XEGDR EQ 'X'.
*        TXT1 = 'INELIGIBLE'.
*      ELSE.
*        TXT1 = 'ELIGIBLE'.
*      ENDIF.
*      CONCATENATE WA_ZISD_INVOICE-FORDAT+4(2) '/' WA_ZISD_INVOICE-FORDAT+0(4) INTO MON.
*    ENDLOOP.

    call function 'START_FORM'
      exporting
        form        = 'ZINVISD1'
        language    = sy-langu
      exceptions
        form        = 1
        format      = 2
        unended     = 3
        unopened    = 4
        unused      = 5
        spool_error = 6
        codepage    = 7
        others      = 8.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
    call function 'WRITE_FORM'
      exporting
        window = 'HEADER'.

    if sy-subrc ne 0.
*          PERFORM protocol_update.
    endif.
    loop at it_zisd_invoice into wa_zisd_invoice where vbeln = wa_inv1-vbeln.
      taigst = taigst + wa_zisd_invoice-aigst.
      tacgst = tacgst + wa_zisd_invoice-acgst.
      tasgst = tasgst + wa_zisd_invoice-asgst.
      tacess = tacess + wa_zisd_invoice-acess.

      tdigst = tdigst + wa_zisd_invoice-digst.
      tdcgst = tdcgst + wa_zisd_invoice-dcgst.
      tdsgst = tdsgst + wa_zisd_invoice-dsgst.
      tdcess = tdcess + wa_zisd_invoice-dcess.

      call function 'WRITE_FORM'
        exporting
          element = 'ITEM_VALUES'
        exceptions
          others  = 1.
    endloop.
    call function 'WRITE_FORM'
      exporting
        element = 'PAGE_NO'
        window  = 'FOOTER'
      exceptions
        others  = 1.
    call function 'WRITE_FORM'
      exporting
        element = 'PAGE_NO'
        window  = 'WINDOW4'
      exceptions
        others  = 1.
    call function 'WRITE_FORM'
      exporting
        element = 'PAGE_NO'
        window  = 'TRP'
      exceptions
        others  = 1.
    call function 'END_FORM'
      exceptions
        unopened                 = 1
        bad_pageformat_for_print = 2
        spool_error              = 3
        codepage                 = 4
        others                   = 5.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
              with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.
    taigst = 0.
    tacgst = 0.
    tasgst = 0.
    tacess = 0.

    tdigst = 0.
    tdcgst = 0.
    tdsgst = 0.
    tdcess = 0.

  endloop.
  call function 'CLOSE_FORM'
* IMPORTING
*   RESULT                         =
*   RDI_RESULT                     =
* TABLES
*   OTFDATA                        =
    exceptions
      unopened                 = 1
      bad_pageformat_for_print = 2
      send_error               = 3
      spool_error              = 4
      codepage                 = 5
      others                   = 6.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

endform.
