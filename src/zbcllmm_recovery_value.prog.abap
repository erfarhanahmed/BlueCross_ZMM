report zbcllmm_recovery_value   no standard page heading line-count 65
line-size 90.
* report used for the recovery value
* Initiated by Anjali, developed by anjali for Account Department.

** Table Declaration
tables : mseg,
         mkpf,
         t001w,
         mara,
         makt,
         t134t,
         mbew.

** Data Declaration
data : it_mkpf type table of mkpf,
       wa_mkpf type mkpf,
       it_mseg type table of mseg,
       wa_mseg type mseg,
       it_mara type table of mara,
       wa_mara type mara.

types  : begin of t_details,
       mblnr like mseg-mblnr,
       budat like mkpf-budat,
       matnr like mseg-matnr,
  mtart like mara-mtart,
       menge like mseg-menge,
       bwart like mseg-bwart,
       end of t_details.
types : begin of t_detsum ,
       mtart TYPE mara-mtart,
       matnr like mseg-matnr,
       menge like mseg-menge,
       end of t_detsum.

data : w_val(16) type i,
       w_matnr like mseg-matnr,
       w_tval(16) type i.
** Selection Screen
data : t_details type table of t_details,
       w_details type t_details,
       t_detsum type table of t_detsum,
       w_detsum type t_detsum.

selection-screen begin of block b1 with frame title text-002 .
select-options  : s_budat   for mkpf-budat.
select-options : s_matnr for mseg-matnr.
select-options : s_mtart for mara-mtart obligatory.
parameters : s_werks  like mseg-werks obligatory.

selection-screen end of block b1.

** Start of selection.

perform collect-data.
perform summ-data.
perform print-data.

*top-of-page.
*  select single * from t001w where  werks = s_werks.
*  select single * from t134t where spras = 'EN' and mtart = s_mtart.
*
*  write :/28 t001w-name1.
*  write :/1 'Recovery Statement for period :',
*          33 s_budat-low,
*          45 ' to ',
*          50 s_budat-high,
*          65 t134t-mtbez.
*  uline.
*  write :/1 'Matl. Code',
*          12 '      Material Description',
*          48 'Quantity',
*          66 'DPCO Rt',
*          74 '  Value'.
*  uline.

*end-of-page.
*---------------------------------------------------------------------*
*       FORM collect-data                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
form collect-data.
  select  * from mkpf into table it_mkpf where budat in s_budat.
  if sy-subrc eq 0.
    select * from mseg into table it_mseg for all entries in it_mkpf where mblnr = it_mkpf-mblnr and mjahr = it_mkpf-mjahr and
    werks = s_werks and  matnr in s_matnr and ( bwart  = '101' or bwart = '102') AND ebeln eq space AND aufnr ne space.
    if sy-subrc eq 0.
      select * from mara into table it_mara where matnr in s_matnr and mtart in s_mtart.
    endif.
  endif.
*  move-corresponding mkpf to t_details.
*  move-corresponding mseg to t_details.
*  append t_details.
*  clear t_details.
*endif.
*endif.
*endselect.
*endselect.

  loop at it_mseg into wa_mseg.
    read table it_mkpf into wa_mkpf with key mblnr = wa_mseg-mblnr.
    if sy-subrc eq 0.
      read table it_mara into wa_mara with key matnr = wa_mseg-matnr.
      if sy-subrc eq 0.
        w_details-mblnr = wa_mseg-mblnr.
        w_details-budat = wa_mkpf-budat.
        w_details-matnr = wa_mseg-matnr.
        w_details-menge = wa_mseg-menge.
        w_details-bwart = wa_mseg-bwart.
        w_details-mtart = wa_mara-mtart.

        collect w_details into t_details.
        clear w_details.
      endif.
    endif.
  endloop.
endform.                    "collect-data

*&---------------------------------------------------------------------*
*&      Form  summ-data
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form summ-data.
  sort t_details by matnr.
  loop at t_details into w_details.
    w_detsum-matnr = w_details-matnr.
    w_detsum-mtart = w_details-mtart.
    if w_details-bwart = '102'.
      w_detsum-menge = w_details-menge * -1.
    else.
      w_detsum-menge = w_details-menge.
    endif.
    collect w_detsum into t_detsum.
    clear w_detsum.
  endloop.
endform.                    " T_SUMMAT

*---------------------------------------------------------------------*
*       FORM print-data                                               *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*

form print-data.

  select single * from t001w where  werks = s_werks.
*  select single * from t134t where spras = 'EN' and mtart = s_mtart.
*
  write :/28 t001w-name1.
  write :/1 'Recovery Statement for period :',
          33 s_budat-low,
          45 ' to ',
          50 s_budat-high,
          65 t134t-mtbez.
  uline.
  write :/1 'Matl. Code',
          12 '      Material Description',
          48 'Quantity',
          66 'DPCO Rt',
          74 '  Value'.
  uline.

  w_val = 0.
  w_tval = 0.
  sort t_detsum by matnr mtart.

  loop at t_detsum into w_detsum.

    at NEW mtart.
      SKIP.
      ULINE.
      WRITE : /'MATERIAL TYPE : ',w_detsum-mtart.
      select single * from t134t where spras = 'EN' and mtart = W_DETSUM-mtart.
        IF SY-SUBRC EQ 0.
          WRITE : T134T-MTBEZ.
        ENDIF.
      uline.
      SKIP.
    ENDAT.
    write :/1(10) w_detsum-matnr.
    select single * from makt where matnr = w_detsum-matnr.
    if sy-subrc eq 0.
      write 12 makt-maktx.
    endif.
    write 48 w_detsum-menge.
    shift w_detsum-matnr left deleting leading '0'.
    concatenate 'C' w_detsum-matnr into w_matnr.
    select single * from mbew where matnr = w_matnr and bwkey = s_werks.
    if sy-subrc = '0'.
      write :66(6) mbew-stprs.
      compute w_val = w_detsum-menge * ( mbew-stprs / mbew-peinh ).
      w_tval = w_tval + w_val.
    else.
      w_val = 0.
    endif.
    write : 74(16) w_val.
  endloop.
  uline.
  write :/1 'Total Recovery Value ',
         74(16) w_tval.
  uline.
endform.                    "print-data
