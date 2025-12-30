report zbcllmm_std_costsheet  no standard page heading line-count 60
line-size 107.
*--------------------------------------------------------------------*
*--This report is for the standard cost sheet printing               *
*--Request given by Mr. Sonawane - accounts  and developed by Anjali *
*--Started on 22.9.02
* Ed logic changed by Jyotsna**In this report use tcode ZCOST_LOT TO UPDATE MRP RATE.
* modified on 6.1.03
*--------------------------------------------------------------------*

*--Table Declerations -----------------------------------------------*

tables : makt,
         mara,
         marc,
         t001w,
         mvke,
         tvm5t,
         mbew,
         mast,
         stko,
         stas,
         zcost_lot,
         stpo.

*--Data Declerations ------------------------------------------------*

data: it_mast type table of mast,
      wa_mast type mast.

data : begin of t_detmast occurs 0,
         matnr like mast-matnr,
         werks like mast-werks,
         stlnr like mast-stlnr,
         stlal like mast-stlal,
       end of t_detmast.
data : begin of t_details occurs 0,
         stlnr like stpo-stlnr,
         idnrk like stpo-idnrk,
         meins like stpo-meins,
         menge like stpo-menge,
         stlal like stas-stlal,
       end of t_details.
data : w_stlnr      like mast-stlnr,
       w_stlal      like mast-stlal,
       w_bmeng(10)  type i,
       w_bmeng1(10) type i,
       w_bmeng2     like stko-bmeng,
       w_mvgr5      like mvke-mvgr5,
       w_rate       like mbew-stprs,
       w_rmrt       like mbew-stprs,
       w_pmrt       like mbew-stprs,
       w_mfgrt      like mbew-stprs,
       w_totrt      like mbew-stprs,
       w_assval     like zcost_lot-value,
       ass_val      like zcost_lot-value,
       w_edrt(13)   type p decimals 2,
       w_edrt1(13)  type p decimals 2,
       w_decon_ind  like mvke-kondm,
       a            type p decimals 2,
       w_vat        type p decimals 2,
       ass          type p decimals 2,
       w_retpr(13)  type p decimals 2,
       w_wspr(13)   type p decimals 2,
       w_totrt1     like mbew-stprs,
       w_nsv        like mbew-stprs,
       w_cog(13)    type p decimals 2,
       w_value(13)  type p decimals 2,
       w_tvalue(13) type p decimals 2,
       w_mtart      like mara-mtart,
       w_flag(1)    type c,
       w_matnr      like mast-matnr,
       w_bezei      like tvm5t-bezei.



*--Selection screen --------------------------------------------------*

selection-screen begin of block b1 with frame title text-001 .
select-options  : s_matnr for mast-matnr.
parameters : p_werks like mast-werks obligatory.
parameters : p_date like stpo-datuv.
selection-screen end of block b1.


*--Start-of-selection ------------------------------------------------*
perform collect_data.
perform collect_stpo_data.
*IF p_werks = '3000'.
*  PERFORM print_3000_data.
*ELSE.
*  PERFORM print_data.
*ENDIF.

if p_werks = '1000' or p_werks = '1001'.
  perform print_data.
else.
  perform print_3000_data.
endif.



*---------------------------------------------------------------------*
*       FORM collect_data                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
form collect_data.

  select * from mast where matnr in s_matnr and werks = p_werks and stlan = '1'.
    select single * from stko where stlnr eq mast-stlnr and stlal eq mast-stlal and stlst eq '01'.
    if sy-subrc eq 0.
      select single *  from marc  where matnr = mast-matnr and werks = p_werks.
      if marc-lvorm = 'X'.
      else.
        select single *  from mara  where matnr = mast-matnr.
        if mara-mtart ne 'ZHLB'.
          move-corresponding mast to t_detmast.
          append t_detmast.
        endif.
      endif.
      clear t_detmast.
    endif.
  endselect.
endform.                    "collect_data

*---------------------------------------------------------------------*
*       FORM collect_stpo_data                                        *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
form collect_stpo_data.
*  LOOP AT T_DETMAST.
*    SELECT * FROM STAS WHERE STLNR = T_DETMAST-STLNR AND STLAL =  T_DETMAST-STLAL.
*      SELECT SINGLE * FROM STPO WHERE STLNR = T_DETMAST-STLNR AND STLKN = STAS-STLKN.
*      MOVE-CORRESPONDING STPO TO T_DETAILS.
*      APPEND T_DETAILS.
*      CLEAR T_DETAILS.
*    ENDSELECT.
*  ENDLOOP.

  loop at t_detmast.
    select single * from stko where stlnr = t_detmast-stlnr and stlal =  t_detmast-stlal and stlst eq '01'.
    if sy-subrc eq 0.
      select * from stas where stlnr = t_detmast-stlnr and stlal =  t_detmast-stlal.
        select single * from stpo where stlnr = t_detmast-stlnr and stlkn = stas-stlkn.
        move-corresponding stpo to t_details.
        move stas-stlal to t_details-stlal.
        append t_details.
        clear t_details.
      endselect.
    endif.
  endloop.

endform.                    "collect_stpo_data

*---------------------------------------------------------------------*
*       FORM print_data                                               *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
form print_data.
  sort t_details by stlnr idnrk descending.
  loop at t_detmast.
    on change of t_detmast-matnr.
      w_tvalue = 0.
      new-page.
      select single * from t001w where werks = t_detmast-werks.
      write :/1  t001w-name1,
              50 'STANDARD COST SHEET'.
      uline.
      select single * from makt where matnr = t_detmast-matnr.
      write :/1 'PRODUCT  :',
              15 makt-maktx,
              72 'CODE :',
              90 t_detmast-matnr.
    endon.
    loop at t_details where stlnr = t_detmast-stlnr and stlal = t_detmast-stlal.
      select single * from mara where matnr = t_details-idnrk.
      if mara-mtart = 'ZHLB'.
        perform print_raw_data.
      else.
        select single * from makt where matnr = t_details-idnrk.
        select single * from mbew where matnr = t_details-idnrk and bwkey =
            p_werks.
        if sy-subrc = 4.
          w_rate = 0.
        else.
          if mbew-bwprh eq 0.
            w_rate = ( mbew-verpr / mbew-peinh ).
          else.
            w_rate = mbew-bwprh.
          endif.
        endif.
        w_value = w_rate * t_details-menge.

        write :/1 t_details-idnrk,
                12 makt-maktx,
                49 t_details-meins,
                55(16) t_details-menge,
                72(9) w_rate,
                83(13) w_value.
        w_tvalue = w_tvalue + w_value.
      endif.
    endloop.
    if w_bmeng1 = 0.
      w_bmeng1  = 1.
    endif.
    w_rate = w_tvalue / w_bmeng1.
    write :/12 'Total',
            83(13) w_tvalue,
            98(8) w_rate.
    w_pmrt = w_rate.
    w_tvalue = 0.
    uline.
*** area  for other rates
    w_matnr = t_detmast-matnr.
    shift w_matnr left deleting leading '0'.
    concatenate 'C' w_matnr into w_matnr.
    select single * from mbew where matnr = w_matnr and bwkey =
 p_werks.
    w_mfgrt = 0.
    if sy-subrc = '0'.
      w_mfgrt =  mbew-stprs.
    endif.
    write :/72 'MFG.CHARGES',
            98(8) w_mfgrt.
    w_totrt = w_rmrt + w_pmrt + w_mfgrt.
    write :/72 'TOTAL      ',
            98(8) w_totrt.

    select single * from mara where matnr = t_detmast-matnr.
    if mara-mtart = 'ZFRT' or mara-mtart = 'ZDSM'.
      perform asse-para.
    endif.
    if mara-mtart = 'ZFRT'.
      perform cog-para.
    endif.

  endloop.
endform.                    "print_data

*&---------------------------------------------------------------------*
*&      Form  ASSE-PARA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form asse-para.
  select single * from zcost_lot where matnr = t_detmast-matnr and zwerks
  = p_werks.
  w_assval = 0.
  if sy-subrc = '0'.
    ass_val = zcost_lot-znet_val * ( 65 / 100 ).
    w_assval = ass_val.
  endif.
  write :/72 'ASSESSABLE VALUE',
          98(8) w_assval.
  w_edrt = 0.
  if w_assval ne 0.
*** to include cess 16.32
    w_edrt = w_assval * ( ( 6 + ( 18 / 100 ) ) / 100 ).
*    w_edrt1 = ( 6 + ( 18 / 100 ) ) / 100.
*    w_edrt = W_ASSVAL * w_edrt1.
*    WRITE : / 'ed',w_edrt,w_assval.
  endif.
  write :/72 'EXCISE DUTY ',
          98(8) w_edrt.
  w_totrt1 = w_totrt + w_edrt.
  write :/72 'TOTAL COST INCL ED.',
          98(8) w_totrt1.
endform.                    "ASSE-PARA

*&---------------------------------------------------------------------*
*&      Form  COG-PARA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form cog-para.
*** to calculate nsv with new formula.
  select single * from mvke where matnr = t_detmast-matnr and vkorg =
  '1000'.
  if sy-subrc = '0'.
    w_decon_ind = mvke-kondm.
  endif.
  if w_decon_ind = '02'.
    perform deco-para.
  else.
    perform contr-para.
  endif.

*W_NSV = W_ASSVAL + W_EDRT1.
  if w_nsv = 0.
    w_cog = 0.
  else.
    w_cog = ( w_totrt1 / w_nsv ) * 100.
  endif.
  write :/72 'NSV      ',
           98(8) w_nsv.
  write :/72 'COG %  ',
           98(8) w_cog.
  write :/72 'MRP ',
            98(8) zcost_lot-znet_val.
  uline.
endform.                    "COG-PARA


*---------------------------------------------------------------------*
*       FORM PRINT_RAW_DATA                                           *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
form print_raw_data.
  clear : w_stlal.
  select  * from mast into table it_mast where matnr  = t_details-idnrk and werks = t_detmast-werks.
  loop at it_mast into wa_mast.
    select single * from stko where stlnr = wa_mast-stlnr and stlal eq wa_mast-stlal and bmeng eq t_details-menge and loekz eq space.
    if sy-subrc eq 0.
      w_stlal = stko-stlal.
      w_stlnr = stko-stlnr.
    endif.
    if w_stlal eq space and w_stlnr eq space.
      select single * from stko where stlnr = wa_mast-stlnr and stlal eq wa_mast-stlal.
      if sy-subrc eq 0.
        w_stlal = stko-stlal.
        w_stlnr = stko-stlnr.
      endif.
    endif.
  endloop.


  select  single stlnr   from mast into w_stlnr  where matnr  = t_details-idnrk and werks = t_detmast-werks and stlal eq w_stlal.
  select single * from stko where stlnr = w_stlnr and stlal eq w_stlal.
  write :/1 'Batch Size : ',
          15 stko-bmeng,
          72 'Effective from :',
          90 p_date.
  write :/1 'Yield',
          20 'Pack',
          27 'Theoratical',
          40 'Practical Standard'.
  write :/1 'Yield Percentage',
          30 '  100',
          40 '   98',
          72 'Run Date:',
          90 sy-datum.

  select single bmeng  from stko into w_bmeng where stlnr =   t_details-stlnr AND stlal eq t_details-stlal.

  select single mvgr5 from mvke into w_mvgr5 where matnr = t_detmast-matnr.
  move ' ' to w_bezei.
  if sy-subrc = 0.
    select single bezei from  tvm5t into w_bezei where mvgr5 = w_mvgr5.
  endif.
  write :/1 'Quantity ',
          20  w_bezei,
          30 w_bmeng.
  w_bmeng2 = w_bmeng * ( 98 / 100 ).
  w_bmeng1 = w_bmeng2.
  write : 40 w_bmeng1.
  uline.
  write :/1 'Item ',
          12 '  Description',
          49 'UOM',
          55 'Quantity ',
          72 'Rate ',
          83 'Value'.
  uline.
*  SELECT * FROM STAS WHERE STLNR = W_STLNR AND STLAL = MAST-STLAL.
  select * from stas where stlnr = w_stlnr and stlal = w_stlal.
    if sy-subrc eq 0.
      select single * from stpo where stlnr = w_stlnr and stlkn = stas-stlkn.
      if sy-subrc eq 0.
        select single * from makt where matnr = stpo-idnrk.
        if sy-subrc eq 0.
          select single * from mbew where matnr = stpo-idnrk and bwkey = p_werks.
          if sy-subrc = 4.
            w_rate = 0.
          else.
            if mbew-bwprh eq 0.
              w_rate = ( mbew-verpr / mbew-peinh ).
            else.
              w_rate = mbew-bwprh.
            endif.
          endif.
          w_value = w_rate * stpo-menge.
          write :/1 stpo-idnrk,
                  12 makt-maktx,
                  49 stpo-meins,
                  55(16) stpo-menge,
                  72(9) w_rate,
                  83(13) w_value.
          w_tvalue = w_tvalue + w_value.
        endif.
      endif.
    endif.
  endselect.

  w_rate = w_tvalue / w_bmeng1.
  write :/12 'Total',
          83(13) w_tvalue,
          98(8) w_rate.
  w_rmrt = w_rate.
  w_tvalue = 0.
  uline.

endform.                    "print_raw_data


*---------------------------------------------------------------------*
*       FORM print_3000_data                                          *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
form print_3000_data.
  sort t_details by stlnr idnrk.
  loop at t_detmast.
    on change of t_detmast-matnr.
      w_tvalue = 0.
      w_flag = 0.
      new-page.
      select single * from t001w where werks = t_detmast-werks.
      write :/1  t001w-name1,
              50 'STANDARD COST SHEET'.
      uline.
      select single * from makt where matnr = t_detmast-matnr.
      write :/1 'PRODUCT  :',
              15 makt-maktx,
              72 'CODE :',
              90 t_detmast-matnr.
      select single * from stko where stlnr = t_detmast-stlnr.
      write :/1 'Batch Size : ',
         15 stko-bmeng,
         72 'Effective from :',
         90 p_date.
      write :/1 'Yield',
              20 'Pack',
              27 'Theoratical',
              40 'Practical Standard'.
      write :/1 'Yield Percentage',
              30 '  100',
              40 '   98',
              72 'Run Date:',
              90 sy-datum.
      w_bmeng = stko-bmeng.
      select single mvgr5 from mvke into w_mvgr5 where matnr =
      t_detmast-matnr.
      move ' ' to w_bezei.
      if sy-subrc = 0.
        select single bezei from  tvm5t into w_bezei where mvgr5 = w_mvgr5.
      endif.
      write :/1 'Quantity ',
              20  w_bezei,
              30 w_bmeng.
      w_bmeng2 = w_bmeng * ( 98 / 100 ).
      w_bmeng1 = w_bmeng2.
      write : 40 w_bmeng1.
      uline.
      write :/1 'Item ',
              12 '  Description',
              49 'UOM',
              55 'Quantity ',
              72 'Rate ',
              83 'Value'.
      uline.

    endon.
    loop at t_details where stlnr = t_detmast-stlnr.
      if w_flag = 0.
        select single mtart from mara into w_mtart where matnr =
   t_details-idnrk.
        w_flag = 1.
      endif.
      select single * from mara  where matnr = t_details-idnrk.
      if w_mtart ne mara-mtart.
        if w_bmeng1 = 0.
          w_bmeng1  = 1.
        endif.
        w_rate = w_tvalue / w_bmeng1.
        write :/12 'Total',
                83(13) w_tvalue,
                98(8) w_rate.
        w_rmrt = w_rate.
        w_tvalue = 0.
        uline.
        w_mtart = mara-mtart.
      endif.

      select single * from makt where matnr = t_details-idnrk.
      select single * from mbew where matnr = t_details-idnrk and bwkey =
          p_werks.
      if sy-subrc = 4.
        w_rate = 0.
      else.
        if mbew-bwprh eq 0.
          w_rate = ( mbew-verpr / mbew-peinh ).
        else.
          w_rate = mbew-bwprh.
        endif.
      endif.
      w_value = w_rate * t_details-menge.

      write :/1 t_details-idnrk,
              12 makt-maktx,
              49 t_details-meins,
              55(16) t_details-menge,
              72(9) w_rate,
              83(13) w_value.
      w_tvalue = w_tvalue + w_value.
    endloop.
    if w_bmeng1 = 0.
      w_bmeng1  = 1.
    endif.
    w_rate = w_tvalue / w_bmeng1.
    write :/12 'Total',
            83(13) w_tvalue,
            98(8) w_rate.
    w_pmrt = w_rate.
    w_tvalue = 0.
    uline.
*** area  for other rates
    w_matnr = t_detmast-matnr.
    shift w_matnr left deleting leading '0'.
    concatenate 'C' w_matnr into w_matnr.
    select single * from mbew where matnr = w_matnr and bwkey =
 p_werks.
    w_mfgrt = 0.
    if sy-subrc = '0'.
      w_mfgrt =  mbew-stprs.
    endif.
    write :/72 'MFG.CHARGES',
            98(8) w_mfgrt.
    w_totrt = w_rmrt + w_pmrt + w_mfgrt.
    write :/72 'TOTAL      ',
            98(8) w_totrt.

    select single * from mara where matnr = t_detmast-matnr.
    if mara-mtart = 'ZFRT' or mara-mtart = 'ZDSM'.
      perform asse-para.
    endif.
    if mara-mtart = 'ZFRT'.
      perform cog-para.
    endif.

  endloop.
endform.                    "print_3000_data


*&---------------------------------------------------------------------*
*&      Form  DECO-PARA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form deco-para.
  a = ( zcost_lot-znet_val / 105 ) * 100.
  w_vat = a * ( 5 / 100 ).
  ass = zcost_lot-znet_val * ( 65 / 100 ).
  w_retpr = ( zcost_lot-znet_val  - w_vat - w_edrt ) * ( 80 / 100 ).
  w_wspr = ( w_retpr * ( 90 / 100 ) ).
  w_nsv = w_wspr + w_edrt.

endform.                    "DECO-PARA

*&---------------------------------------------------------------------*
*&      Form  CONTR-PARA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form contr-para.
  a = ( zcost_lot-znet_val / 105 ) * 100.
  w_vat = a * ( 5 / 100 ).
  ass = zcost_lot-znet_val * ( 65 / 100 ).
  w_retpr = ( zcost_lot-znet_val  - w_vat - w_edrt ) * ( 84 / 100 ).
  w_wspr = ( w_retpr * ( 92 / 100 ) ).
  w_nsv = w_wspr + w_edrt.
endform.                    "CONTR-PARA
