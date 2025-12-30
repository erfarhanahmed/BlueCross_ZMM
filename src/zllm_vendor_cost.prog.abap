*&---------------------------------------------------------------------*
*& Report  ZCOSTING1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  zcosting6 no standard page heading line-size 500.

tables : mseg,
         mkpf,
         makt,
         mvke,
         tvm5t,
         ekpo,
         mast,
         stko,
         lfa1.

type-pools:  slis.

data: g_repid like sy-repid,
      fieldcat type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort type slis_t_sortinfo_alv,
      wa_sort like line of sort,
      layout type slis_layout_alv.

types : begin of itab1,
  mblnr type mseg-mblnr,
  lfbnr type mseg-lfbnr,
  matnr type mseg-matnr,
  menge type mseg-menge,
  dmbtr type mseg-dmbtr,
  ebeln type mseg-ebeln,
  ebelp type mseg-ebelp,
  shkzg type mseg-shkzg,
  zeile type mseg-zeile,
  lfpos type mseg-lfpos,
  lifnr TYPE mseg-lifnr,
  end of itab1.

types : begin of itab2,
mblnr type mseg-mblnr,
  lfbnr type mseg-lfbnr,
  matnr type mseg-matnr,
  menge type mseg-menge,
  dmbtr type mseg-dmbtr,
  ebeln type mseg-ebeln,
  ebelp type mseg-ebelp,
  shkzg type mseg-shkzg,
  zeile type mseg-zeile,
  matnr1 type mseg-matnr,
  lfpos type mseg-lfpos,
  lifnr TYPE mseg-lifnr,
end of itab2.

types : begin of itab3,
mblnr type mseg-mblnr,
  lfbnr type mseg-lfbnr,
  matnr type mseg-matnr,
  menge type mseg-menge,
  dmbtr type mseg-dmbtr,
  ebeln type mseg-ebeln,
  ebelp type mseg-ebelp,
  shkzg type mseg-shkzg,
  zeile type mseg-zeile,
  matnr1 type mseg-matnr,
  menge1 type mseg-menge,
  dmbtr1 type mseg-dmbtr,
  shkzg1 type mseg-shkzg,
  charg1 type mseg-charg,
  lfpos type mseg-lfpos,
  lifnr TYPE mseg-lifnr,
end of itab3.

types : begin of itab4,
mblnr type mseg-mblnr,
  lfbnr type mseg-lfbnr,
  matnr type mseg-matnr,
  menge type mseg-menge,
  dmbtr type mseg-dmbtr,
  ebeln type mseg-ebeln,
  ebelp type mseg-ebelp,
  shkzg type mseg-shkzg,
  zeile type mseg-zeile,
  matnr1 type mseg-matnr,
  menge1 type mseg-menge,
  dmbtr1 type mseg-dmbtr,
  shkzg1 type mseg-shkzg,
  charg1 type mseg-charg,
  lfpos type mseg-lfpos,
  lifnr TYPE mseg-lifnr,
end of itab4.

types : begin of itab5,
mblnr type mseg-mblnr,
  lfbnr type mseg-lfbnr,
  matnr type mseg-matnr,
  menge type mseg-menge,
  dmbtr type mseg-dmbtr,
  ebeln type mseg-ebeln,
  ebelp type mseg-ebelp,
  shkzg type mseg-shkzg,
  zeile type mseg-zeile,
  matnr1 type mseg-matnr,
  menge1 type mseg-menge,
  dmbtr1 type mseg-dmbtr,
  shkzg1 type mseg-shkzg,
  charg1 type mseg-charg,
  lfpos type mseg-lfpos,
  lifnr TYPE mseg-lifnr,
  lifnr1 TYPE mseg-lifnr,
end of itab5.

types : begin of itab6,
   matnr1 type mseg-matnr,
  matnr type mseg-matnr,
  menge type mseg-menge,
  dmbtr type mseg-dmbtr,
   lifnr TYPE mseg-lifnr,
end of itab6.

types : begin of itab7,
   matnr1 type mseg-matnr,
*  matnr type mseg-matnr,
  menge type mseg-menge,
  dmbtr type mseg-dmbtr,
   lifnr TYPE mseg-lifnr,
end of itab7.

types : begin of itab8,
   matnr1 type mseg-matnr,
  charg1 type mseg-charg,
  mblnr type mseg-mblnr,
  bwart type mseg-bwart,
   lifnr TYPE mseg-lifnr,
end of itab8.

types : begin of itab9,
  matnr1 type mseg-matnr,
  charg1 type mseg-charg,
  mblnr type mseg-mblnr,
  bwart type mseg-bwart,
  lfbnr type mseg-lfbnr,
   lifnr TYPE mseg-lifnr,
end of itab9.


types : begin of itab10,
   matnr1 type mseg-matnr,
  charg1 type mseg-charg,
  mblnr type mseg-mblnr,
  bwart type mseg-bwart,
  lfbnr type mseg-lfbnr,
   lifnr TYPE mseg-lifnr,
end of itab10.

types : begin of itab11,
   matnr1 type mseg-matnr,
   count   TYPE i,
   lifnr TYPE mseg-lifnr,
end of itab11.

data : it_tab1 type table of itab1,
      wa_tab1 type itab1,
      it_tab2 type table of itab2,
      wa_tab2 type itab2,
      it_tab3 type table of itab3,
      wa_tab3 type itab3,
      it_tab4 type table of itab4,
      wa_tab4 type itab4,
      it_tab5 type table of itab5,
      wa_tab5 type itab5,
      it_tab6 type table of itab6,
      wa_tab6 type itab6,
      it_tab7 type table of itab7,
      wa_tab7 type itab7,
      it_tab8 type table of itab8,
      wa_tab8 type itab8,
      it_tab9 type table of itab9,
      wa_tab9 type itab9,
      it_tab10 type table of itab10,
      wa_tab10 type itab10,
      it_tab11 type table of itab11,
      wa_tab11 type itab11.

data : it_mkpf type table of mkpf,
       wa-mkpf type mkpf,
       it_mkpf1 type table of mkpf,
       wa-mkpf1 type mkpf,
       it_mseg1 type table of mseg,
       wa_mseg1 type mseg,
       it_mseg2 type table of mseg,
       wa_mseg2 type mseg,
       it_mseg3 type table of mseg,
       wa_mseg3 type mseg,
       it_mseg4 type table of mseg,
       wa_mseg4 type mseg,
       it_mseg type table of mseg,
       wa_mseg type mseg.

data : bat_sz type p decimals 0,
       bat_sz1 type p decimals 2,
       count type i,
       count1 type i,
       a TYPE i,
       b TYPE i.

select-options : s_date for mkpf-budat.
select-options : material for mseg-matnr no-display.
select-OPTIONS: plant FOR mseg-werks.
initialization.
  g_repid = sy-repid.

start-of-selection.


  select * from mseg into table it_mseg1 where matnr in material and werks in plant and bwart in ('543','544').
  if sy-subrc ne 0.
    exit.
  endif.

  select * from  mkpf into table it_mkpf for all entries in it_mseg1 where mblnr eq it_mseg1-mblnr and budat in s_date.
  if sy-subrc ne 0.
    exit.
  endif.

  select * from mseg into table it_mseg for all entries in it_mkpf where mblnr eq it_mkpf-mblnr and matnr in material and werks in plant
    and bwart in ('543','544').
  if sy-subrc ne 0.
    exit.
  endif.

  loop at it_mseg into wa_mseg.
*    write : / wa_mseg-mblnr,wa_mseg-matnr,wa_mseg-shkzg,wa_mseg-menge,wa_mseg-dmbtr,wa_mseg-ebeln,WA_MSEG-lfbnr.
    wa_tab1-mblnr = wa_mseg-mblnr.
    wa_tab1-matnr = wa_mseg-matnr.
    if wa_mseg-shkzg eq 'S'.
      wa_mseg-menge = wa_mseg-menge * ( - 1 ).
      wa_mseg-dmbtr = wa_mseg-dmbtr * ( - 1 ).
    endif.
    wa_tab1-shkzg = wa_mseg-shkzg.
    wa_tab1-menge = wa_mseg-menge.
    wa_tab1-dmbtr = wa_mseg-dmbtr.
    wa_tab1-ebeln = wa_mseg-ebeln.
    wa_tab1-ebelp = wa_mseg-ebelp.
    wa_tab1-zeile = wa_mseg-zeile.
    wa_tab1-lfbnr = wa_mseg-lfbnr.
    wa_tab1-lfpos = wa_mseg-lfpos.
    wa_tab1-lifnr = wa_mseg-lifnr.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.
  endloop.
*  uline.
  loop at it_tab1 into wa_tab1.
*    write : / 'A',wa_tab1-mblnr,wa_tab1-matnr,wa_tab1-zeile,wa_tab1-shkzg,wa_tab1-menge,wa_tab1-dmbtr,wa_tab1-ebeln,wa_tab1-ebelp,
*    wa_tab1-lfbnr.

    wa_tab2-mblnr = wa_tab1-mblnr.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-zeile = wa_tab1-zeile.
    wa_tab2-shkzg = wa_tab1-shkzg.
    wa_tab2-menge = wa_tab1-menge.
    wa_tab2-dmbtr = wa_tab1-dmbtr.
    wa_tab2-ebeln = wa_tab1-ebeln.
    wa_tab2-ebelp = wa_tab1-ebelp.
    wa_tab2-lfbnr = wa_tab1-lfbnr.
    wa_tab2-lfpos = wa_tab1-lfpos.
    wa_tab2-lifnr = wa_tab1-lifnr.

    select single * from ekpo where ebeln eq wa_tab1-ebeln and ebelp eq wa_tab1-ebelp.
    if sy-subrc eq 0.
      wa_tab2-matnr1 = ekpo-matnr.
    endif.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.

  loop at it_tab2 into wa_tab2.
*    write : / wa_tab2-mblnr,wa_tab2-matnr1,wa_tab2-matnr,wa_tab2-zeile,wa_tab2-shkzg,wa_tab2-menge,wa_tab2-dmbtr,wa_tab2-ebeln,wa_tab2-ebelp,
*        wa_tab2-lfbnr,wa_tab2-lfpos.




    select  SINGLE * from mseg where mblnr eq wa_tab2-mblnr and matnr eq wa_tab2-matnr1 and ebeln eq wa_tab2-ebeln and ebelp eq wa_tab2-ebelp
      and bpmng ne 0 and lfpos eq wa_tab2-lfpos.
    if sy-subrc eq 0.


      wa_tab3-mblnr = wa_tab2-mblnr.
      wa_tab3-matnr1 = wa_tab2-matnr1.
      wa_tab3-matnr = wa_tab2-matnr.
      wa_tab3-zeile = wa_tab2-zeile.
      wa_tab3-shkzg = wa_tab2-shkzg.
      wa_tab3-menge = wa_tab2-menge.
      wa_tab3-dmbtr = wa_tab2-dmbtr.
      wa_tab3-ebeln = wa_tab2-ebeln.
      wa_tab3-ebelp = wa_tab2-ebelp.
      wa_tab3-lfbnr = wa_tab2-lfbnr.
      wa_tab3-lfpos = wa_tab2-lfpos.
      wa_tab3-lifnr = wa_tab2-lifnr.

*        write : /'   ', mseg-matnr,mseg-charg,mseg-menge,mseg-dmbtr,mseg-shkzg.

      if mseg-shkzg eq 'H'.
        mseg-menge = mseg-menge * ( - 1 ).
        mseg-dmbtr = mseg-dmbtr * ( - 1 ).
      endif.

      wa_tab3-menge1 = mseg-menge.
      wa_tab3-dmbtr1 = mseg-dmbtr.
      wa_tab3-shkzg1 = mseg-shkzg.
      wa_tab3-charg1 = mseg-charg.

      collect wa_tab3 into it_tab3.
      clear wa_tab3.

    endif.
*    endselect.


  endloop.
*  uline.
  sort it_tab3 by mblnr matnr1 charg1 lifnr matnr.
  sort it_tab2 by mblnr matnr1 lifnr matnr.

  loop at it_tab2 into wa_tab2.
*    write : /'B', wa_tab2-mblnr,wa_tab2-matnr1,wa_tab2-matnr,wa_tab2-zeile,wa_tab2-shkzg,wa_tab2-menge,wa_tab2-dmbtr,wa_tab2-ebeln,wa_tab2-ebelp,
*      wa_tab2-lfbnr,wa_tab2-lfpos.

    wa_tab4-mblnr = wa_tab2-mblnr.
    wa_tab4-matnr1 = wa_tab2-matnr1.
    wa_tab4-matnr = wa_tab2-matnr.
    wa_tab4-zeile = wa_tab2-zeile.
    wa_tab4-shkzg = wa_tab2-shkzg.
    wa_tab4-menge = wa_tab2-menge.
    wa_tab4-dmbtr = wa_tab2-dmbtr.
    wa_tab4-ebeln = wa_tab2-ebeln.
    wa_tab4-ebelp = wa_tab2-ebelp.
    wa_tab4-lfbnr = wa_tab2-lfbnr.
    wa_tab4-lfpos = wa_tab2-lfpos.
    wa_tab4-lifnr = wa_tab2-lifnr.



    read table it_tab3 into wa_tab3 with key mblnr = wa_tab2-mblnr matnr1 = wa_tab2-matnr1  ebeln = wa_tab2-ebeln ebelp = wa_tab2-ebelp
    lfpos = wa_tab2-lfpos lifnr = wa_tab2-lifnr.
    if sy-subrc eq 0.
*      write : wa_tab3-charg1.
      wa_tab4-charg1 = wa_tab3-charg1.
      wa_tab4-menge1 = wa_tab3-menge1.
      wa_tab4-dmbtr1 = wa_tab3-dmbtr1.
      wa_tab4-shkzg1 = wa_tab3-shkzg1.
      wa_tab4-lifnr = wa_tab3-lifnr.
    else.
      read table it_tab3 into wa_tab3 with key mblnr = wa_tab2-lfbnr matnr1 = wa_tab2-matnr1  ebeln = wa_tab2-ebeln ebelp = wa_tab2-ebelp
       lfpos = wa_tab2-lfpos lifnr = wa_tab2-lifnr..
      if sy-subrc eq 0.
*        write : wa_tab3-charg1.
        wa_tab4-charg1 = wa_tab3-charg1.
        wa_tab4-menge1 = wa_tab3-menge1.
        wa_tab4-dmbtr1 = wa_tab3-dmbtr1.
        wa_tab4-shkzg1 = wa_tab3-shkzg1.
        wa_tab4-lifnr = wa_tab3-lifnr.
      endif.
    endif.

    collect wa_tab4 into it_tab4.
    clear wa_tab4.

  endloop.

*  LOOP at it_tab4 INTO wa_tab4.
*    WRITE : / 'abb',wa_tab4-matnr1,wa_tab4-lifnr.
*ENDLOOP.

*  uline.
  sort it_tab4 by mblnr matnr1 charg1 matnr.

  loop at it_tab4 into wa_tab4.

*    write : / wa_tab4-mblnr,wa_tab4-matnr1,wa_tab4-lifnr,wa_tab4-charg1,wa_tab4-menge1,wa_tab4-dmbtr1,wa_tab4-shkzg1,
*    wa_tab4-matnr,wa_tab4-zeile, wa_tab4-shkzg,wa_tab4-menge,wa_tab4-dmbtr,wa_tab4-ebeln,wa_tab4-ebelp, wa_tab4-lfbnr.

    wa_tab5-mblnr = wa_tab4-mblnr.
    wa_tab5-matnr1 = wa_tab4-matnr1.
    wa_tab5-matnr = wa_tab4-matnr.
    wa_tab5-zeile = wa_tab4-zeile.
    wa_tab5-shkzg = wa_tab4-shkzg.
    wa_tab5-menge = wa_tab4-menge.
    wa_tab5-dmbtr = wa_tab4-dmbtr.
    wa_tab5-ebeln = wa_tab4-ebeln.
    wa_tab5-ebelp = wa_tab4-ebelp.
    wa_tab5-lfbnr = wa_tab4-lfbnr.
    wa_tab5-lfpos = wa_tab4-lfpos.
    wa_tab5-lifnr = wa_tab4-lifnr.

    if wa_tab4-charg1 ne ' '.
      wa_tab5-charg1 = wa_tab4-charg1.
    else.
      select single * from mseg where mblnr = wa_tab4-lfbnr and matnr = wa_tab4-matnr1 and ebeln = wa_tab4-ebeln and ebelp = wa_tab4-ebelp
        AND lifnr eq wa_tab4-lifnr..
      if sy-subrc eq 0.
        wa_tab5-charg1 = mseg-charg.
        wa_tab5-menge1 = mseg-menge.
        wa_tab5-dmbtr1 = mseg-dmbtr.
        wa_tab5-shkzg1 = mseg-shkzg.
        wa_tab5-lifnr = mseg-lifnr.
      endif.
    endif.

    collect wa_tab5 into it_tab5.
    clear wa_tab5.

*      pack wa_tab4-matnr1 to wa_tab4-matnr1.
*      pack wa_tab4-matnr to wa_tab4-matnr.
*
*      condense : wa_tab4-matnr1, wa_tab4-matnr.
*      modify it_tab4 from wa_tab4 transporting matnr1 matnr.

  endloop.
  sort it_tab5 by matnr1 lifnr lifnr1 matnr.
  sort it_tab5 by matnr1 lifnr lifnr1 matnr.
  loop at it_tab5 into wa_tab5.
*    write : / wa_tab5-mblnr,wa_tab5-matnr1,wa_tab5-charg1,wa_tab5-matnr,wa_tab5-menge,
*    wa_tab5-dmbtr,wa_tab5-ebeln,wa_tab5-lfbnr.

    wa_tab6-matnr1 = wa_tab5-matnr1.
    wa_tab6-matnr = wa_tab5-matnr.
    wa_tab6-menge = wa_tab5-menge.
    wa_tab6-dmbtr = wa_tab5-dmbtr.
    wa_tab6-lifnr = wa_tab5-lifnr.
    collect wa_tab6 into it_tab6.
    clear wa_tab6.
  endloop.

***  loop at it_tab5 into wa_tab5.
***    wa_tab8-matnr1 = wa_tab5-matnr1.
***    wa_tab8-charg1 = wa_tab5-charg1.
***    collect wa_tab8 into it_tab8.
***    clear wa_tab8.
***  endloop.
***  sort it_tab8 by matnr1 charg1.
***  loop at it_tab8 into wa_tab8.
***
***     on change of wa_tab8-matnr1.
***      count = 0.
***    endon.
***
***     on change of wa_tab8-charg1.
***      count = count + 1.
***    endon.
***
***
***
***    at END OF matnr1.
****      WRITE : / 'r1',wa_tab8-matnr1,count.
***      wa_tab9-matnr1 = wa_tab8-matnr1.
***      wa_tab9-count = count.
***      COLLECT wa_tab9 INTO it_tab9.
***      CLEAR wa_tab9.
***      endat.
***  endloop.

*  LOOP at it_tab9 INTO wa_tab9.
*     WRITE : / 'r2',wa_tab9-matnr1,wa_tab9-count.
*ENDLOOP.
*
*  uline.



  select * from mseg into table it_mseg3 for all entries in it_tab6 where matnr eq
    it_tab6-matnr1 and werks in plant and bwart in ('101','102') AND lifnr = it_tab6-lifnr.

  select * from  mkpf into table it_mkpf1 for all entries in it_mseg3 where mblnr
    eq it_mseg3-mblnr and budat in s_date.


  select * from mseg into table it_mseg4 for all entries in it_mkpf1 where mblnr
    eq it_mkpf1-mblnr and werks in plant and bwart in ('101','102').
*    and matnr in material

  loop at it_mseg4 into wa_mseg4.
*    WRITE : / 'bnn',wa_mseg4-matnr,wa_mseg4-lifnr.
    if wa_mseg4-charg ne ' '.
      if wa_mseg4-bwart = '101'.
        wa_tab8-matnr1 = wa_mseg4-matnr.
        wa_tab8-charg1 = wa_mseg4-charg.
        wa_tab8-bwart = wa_mseg4-bwart.
        wa_tab8-mblnr = wa_mseg4-mblnr.
        wa_tab8-lifnr = wa_mseg4-lifnr.
      endif.
      collect wa_tab8 into it_tab8.
      clear wa_tab8.
    endif.
  endloop.
  sort  it_tab8 by matnr1 charg1 bwart.


*  loop at it_tab8 into wa_tab8.
*    write : / 'live batches', wa_tab8-matnr1,wa_tab8-charg1,wa_tab8-bwart,wa_tab8-mblnr.
*  endloop.

  loop at it_mseg4 into wa_mseg4.
    if wa_mseg4-charg ne  ' '.
      if wa_mseg4-bwart = '102'.
        wa_tab9-matnr1 = wa_mseg4-matnr.
        wa_tab9-charg1 = wa_mseg4-charg.
        wa_tab9-bwart = wa_mseg4-bwart.
        wa_tab9-mblnr = wa_mseg4-mblnr.
        wa_tab9-lfbnr = wa_mseg4-lfbnr.
        wa_tab9-lifnr = wa_mseg4-lifnr.
      endif.
      collect wa_tab9 into it_tab9.
      clear wa_tab9.
    endif.
  endloop.

*  uline.

  sort  it_tab9 by matnr1 charg1 bwart.


*  loop at it_tab9 into wa_tab9.
*    write : / 'b',wa_tab9-matnr1,wa_tab9-charg1,wa_tab9-bwart,wa_tab9-mblnr,'a',wa_tab9-lfbnr.
*  endloop.

  loop at it_tab8 into wa_tab8.
    read table it_tab9 into wa_tab9 with key matnr1 = wa_tab8-matnr1 charg1 = wa_tab8-charg1 lfbnr = wa_tab8-mblnr lifnr = wa_tab8-lifnr .
    if sy-subrc eq 4.
      wa_tab10-matnr1 = wa_tab8-matnr1.
      wa_tab10-charg1 = wa_tab8-charg1.
*      wa_tab10-mblnr = wa_tab8-mblnr.
      wa_tab10-bwart = wa_tab8-bwart.
      wa_tab10-lifnr = wa_tab8-lifnr.
      COLLECT wa_tab10 INTO it_tab10.
      CLEAR wa_tab10.
    endif.
  endloop.

  count = 0.
  sort it_tab10 by matnr1 charg1 lifnr.
  loop at it_tab10 into wa_tab10.
    on CHANGE OF wa_tab10-matnr1.
      count = 1.
    endon.
    on CHANGE OF wa_tab10-lifnr.
      count1 = 1.
    endon.
***    write : /'a', wa_tab10-matnr1,wa_tab10-lifnr,wa_tab10-charg1,wa_tab10-bwart,count,count1.

*    if count le count1.
*      at END OF matnr1.
**      WRITE : / wa_tab10-matnr1,count.
*        wa_tab11-matnr1 = wa_tab10-matnr1.
*        wa_tab11-lifnr = wa_tab10-lifnr.
*        wa_tab11-count = count.
*      ENDAT.
*    else.
    wa_tab11-matnr1 = wa_tab10-matnr1.
    wa_tab11-lifnr = wa_tab10-lifnr.
    if count le count1.
      wa_tab11-count = count.
    ELSE.
      wa_tab11-count = count1.
    ENDIF.

    COLLECT wa_tab11 INTO it_tab11.
    CLEAR wa_tab11.
    CLEAR : count,count1.

    count = count + 1.
    count1 = count1 + 1.
  endloop.

*  LOOP at it_tab11 INTO wa_tab11.
*    WRITE : / 'dd',wa_tab11-matnr1,wa_tab11-lifnr,wa_tab11-count.
*  ENDLOOP.

  loop at it_mseg4 into wa_mseg4.
*    write : /'Aaa', wa_mseg4-matnr,wa_mseg4-lifnr,wa_mseg4-menge,wa_mseg4-dmbtr.
*
    if wa_mseg4-shkzg eq 'H'.
      wa_mseg4-menge = wa_mseg4-menge * ( - 1 ).
      wa_mseg4-dmbtr = wa_mseg4-dmbtr * ( - 1 ).
    endif.
    wa_tab7-matnr1 = wa_mseg4-matnr.
    wa_tab7-menge = wa_mseg4-menge.
    wa_tab7-dmbtr = wa_mseg4-dmbtr.
    wa_tab7-lifnr = wa_mseg4-lifnr.
    collect wa_tab7 into it_tab7.
    clear wa_tab7.
  endloop.

*  loop at it_tab7 into wa_tab7.
*    write : /'A', wa_tab7-matnr1,wa_tab7-lifnr,wa_tab7-menge,wa_tab7-dmbtr.
*  endloop.

  sort it_tab6 by matnr1 lifnr matnr.
  CLEAR : a,b.
  loop at it_tab6 into wa_tab6.
    on change of wa_tab6-matnr1.
      a = 0.
    endon.
    on CHANGE OF wa_tab6-lifnr.
      b = 0.
    endon.

*    WRITE : /'a',a.
*      on CHANGE OF wa_tab6-lifnr.
*    b = 0.
*    format color 3.
*    uline.
*    skip.
***    if ( a eq 0 AND b eq 0 ) or ( a eq 0 AND b eq 0 ).
***      on CHANGE OF wa_tab6-matnr1.
***        uline.
***        WRITE : / 'VENDOR',WA_TAB6-LIFNR.
***        SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_TAB6-LIFNR.
***        IF SY-SUBRC EQ 0.
***          WRITE : LFA1-NAME1,a,b.
***        ENDIF.
***        write : /'PRODUCT',10(10) wa_tab6-matnr1.
***
***        select single * from makt where matnr eq wa_tab6-matnr1.
***        if sy-subrc eq 0.
***          write : 22 makt-maktx.
***        endif.
***
***        read table it_tab11 into wa_tab11 with key matnr1 = wa_tab6-matnr1 lifnr = wa_tab6-lifnr.
***        if sy-subrc eq 0.
***          write : 53 'TOTAL NO. OF BATCH :',75(3) wa_tab11-count LEFT-JUSTIFIED.
***        endif.
***
***        select single * from mvke where matnr eq wa_tab6-matnr1.
***        if sy-subrc eq 0.
***          select single * from tvm5t where mvgr5 eq mvke-mvgr5 and spras eq 'EN'.
***          if sy-subrc eq 0.
***            write :  80 'PACK SIZE:',90 tvm5t-bezei LEFT-JUSTIFIED.
***          endif.
***        endif.
***
***        read table it_tab7 into wa_tab7 with key matnr1 = wa_tab6-matnr1 lifnr = wa_tab6-lifnr.
***        if sy-subrc eq 0.
***          write : /'TOTAL QTY RECEIVED:', 22 wa_tab7-menge.
***        endif.
***
***        select single * from mast where matnr eq wa_tab6-matnr1 and werks eq '3000'.
***        if sy-subrc eq 0.
***          select single * from stko where stlnr eq mast-stlnr.
***          if sy-subrc eq 0.
****          write :53 'STANDARD BATCH SIZE:',stko-bmeng.
***            bat_sz1 = wa_tab7-menge / ( stko-bmeng * 98 / 100 ).
***            bat_sz = bat_sz1 * stko-bmeng.
***            write :53 'STANDARD BATCH SIZE:',bat_sz.
***            clear : bat_sz,bat_sz1.
***          endif.
***        endif.
***
***        uline.
***        write : /1 'MATERIAL',22 'DESCRIPTION',53 'QUANTITY',71 'VALUE'.
***        uline.
***      endon.
*    elseif b eq 0.
*        on CHANGE OF wa_tab6-lifnr.
*          WRITE : / 'VENDOR',WA_TAB6-LIFNR.
*          SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_TAB6-LIFNR.
*          IF SY-SUBRC EQ 0.
*            WRITE : LFA1-NAME1,a,b.
*          ENDIF.
*          write : /'PRODUCT',10(10) wa_tab6-matnr1.
*
*          select single * from makt where matnr eq wa_tab6-matnr1.
*          if sy-subrc eq 0.
*            write : 22 makt-maktx.
*          endif.
*
*          read table it_tab11 into wa_tab11 with key matnr1 = wa_tab6-matnr1 lifnr = wa_tab6-lifnr.
*          if sy-subrc eq 0.
*            write : 53 'TOTAL NO. OF BATCH :',75(3) wa_tab11-count.
*          endif.
*
*          select single * from mvke where matnr eq wa_tab6-matnr1.
*          if sy-subrc eq 0.
*            select single * from tvm5t where mvgr5 eq mvke-mvgr5 and spras eq 'EN'.
*            if sy-subrc eq 0.
*              write :  80 'PACK SIZE:',90 tvm5t-bezei LEFT-JUSTIFIED.
*            endif.
*          endif.
*
*          read table it_tab7 into wa_tab7 with key matnr1 = wa_tab6-matnr1 lifnr = wa_tab6-lifnr.
*          if sy-subrc eq 0.
*            write : /'TOTAL QTY RECEIVED:', 22 wa_tab7-menge.
*          endif.
*
*          select single * from mast where matnr eq wa_tab6-matnr1 and werks eq '3000'.
*          if sy-subrc eq 0.
*            select single * from stko where stlnr eq mast-stlnr.
*            if sy-subrc eq 0.
**          write :53 'STANDARD BATCH SIZE:',stko-bmeng.
*              bat_sz1 = wa_tab7-menge / ( stko-bmeng * 98 / 100 ).
*              bat_sz = bat_sz1 * stko-bmeng.
*              write :53 'STANDARD BATCH SIZE:',bat_sz.
*              clear : bat_sz,bat_sz1.
*            endif.
*          endif.
*
*          uline.
*          write : /1 'MATERIAL',22 'DESCRIPTION',53 'QUANTITY',71 'VALUE'.
*          uline.
*        endon.
*      ENDIF.
*
*      else.
*
*        on CHANGE OF wa_tab6-matnr1.
*          uline.
*          WRITE : / 'VENDOR',WA_TAB6-LIFNR.
*          SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_TAB6-LIFNR.
*          IF SY-SUBRC EQ 0.
*            WRITE : LFA1-NAME1,   a,b.
*          ENDIF.
*          write : /'PRODUCT',10(10) wa_tab6-matnr1.
*
*          select single * from makt where matnr eq wa_tab6-matnr1.
*          if sy-subrc eq 0.
*            write : 22 makt-maktx.
*          endif.
*
*          read table it_tab11 into wa_tab11 with key matnr1 = wa_tab6-matnr1 lifnr = wa_tab6-lifnr.
*          if sy-subrc eq 0.
*            write : 53 'TOTAL NO. OF BATCH :',75(3) wa_tab11-count LEFT-JUSTIFIED.
*          endif.
*
*          select single * from mvke where matnr eq wa_tab6-matnr1.
*          if sy-subrc eq 0.
*            select single * from tvm5t where mvgr5 eq mvke-mvgr5 and spras eq 'EN'.
*            if sy-subrc eq 0.
*              write :  80 'PACK SIZE:',90 tvm5t-bezei LEFT-JUSTIFIED.
*            endif.
*          endif.
*
*          read table it_tab7 into wa_tab7 with key matnr1 = wa_tab6-matnr1 lifnr = wa_tab6-lifnr.
*          if sy-subrc eq 0.
*            write : /'TOTAL QTY RECEIVED:', 22 wa_tab7-menge.
*          endif.
*
*          select single * from mast where matnr eq wa_tab6-matnr1 and werks eq '3000'.
*          if sy-subrc eq 0.
*            select single * from stko where stlnr eq mast-stlnr.
*            if sy-subrc eq 0.
**          write :53 'STANDARD BATCH SIZE:',stko-bmeng.
*              bat_sz1 = wa_tab7-menge / ( stko-bmeng * 98 / 100 ).
*              bat_sz = bat_sz1 * stko-bmeng.
*              write :53 'STANDARD BATCH SIZE:',bat_sz.
*              clear : bat_sz,bat_sz1.
*            endif.
*          endif.
*
*          uline.
*          write : /1 'MATERIAL',22 'DESCRIPTION',53 'QUANTITY',71 'VALUE'.
*          uline.
*        endon.
*      ENDIF.
*    ENDIF.
*    endon.
    format color 3.

    IF A EQ 0.
*      WRITE :  / WA_TAB6-MATNR1,WA_TAB6-LIFNR


      WRITE : / 'VENDOR',WA_TAB6-LIFNR.
      SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_TAB6-LIFNR.
      IF SY-SUBRC EQ 0.
        WRITE : LFA1-NAME1.
      ENDIF.
      write : /'PRODUCT',10(10) wa_tab6-matnr1.

      select single * from makt where matnr eq wa_tab6-matnr1.
      if sy-subrc eq 0.
        write : 22 makt-maktx.
      endif.

      read table it_tab11 into wa_tab11 with key matnr1 = wa_tab6-matnr1 lifnr = wa_tab6-lifnr.
      if sy-subrc eq 0.
        write : 53 'TOTAL NO. OF BATCH :',75(3) wa_tab11-count LEFT-JUSTIFIED.
      endif.

      select single * from mvke where matnr eq wa_tab6-matnr1.
      if sy-subrc eq 0.
        select single * from tvm5t where mvgr5 eq mvke-mvgr5 and spras eq 'EN'.
        if sy-subrc eq 0.
          write :  80 'PACK SIZE:',90 tvm5t-bezei LEFT-JUSTIFIED.
        endif.
      endif.

      read table it_tab7 into wa_tab7 with key matnr1 = wa_tab6-matnr1 lifnr = wa_tab6-lifnr.
      if sy-subrc eq 0.
        write : /'TOTAL QTY RECEIVED:', 22 wa_tab7-menge.
      endif.

      select single * from mast where matnr eq wa_tab6-matnr1 and werks in plant .
      if sy-subrc eq 0.
        select single * from stko where stlnr eq mast-stlnr.
        if sy-subrc eq 0.
*          write :53 'STANDARD BATCH SIZE:',stko-bmeng.
          bat_sz1 = wa_tab7-menge / ( stko-bmeng * 98 / 100 ).
          bat_sz = bat_sz1 * stko-bmeng.
          write :53 'STANDARD BATCH SIZE:',bat_sz.
          clear : bat_sz,bat_sz1.
        endif.
      endif.

      uline.
      write : /1 'MATERIAL',22 'DESCRIPTION',53 'QUANTITY',71 'VALUE'.
      uline.


    ELSEIF B EQ 0.
*      WRITE : / WA_TAB6-MATNR1,WA_TAB6-LIFNR.

      WRITE : / 'VENDOR',WA_TAB6-LIFNR.
      SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_TAB6-LIFNR.
      IF SY-SUBRC EQ 0.
        WRITE : LFA1-NAME1.
      ENDIF.
      write : /'PRODUCT',10(10) wa_tab6-matnr1.

      select single * from makt where matnr eq wa_tab6-matnr1.
      if sy-subrc eq 0.
        write : 22 makt-maktx.
      endif.

      read table it_tab11 into wa_tab11 with key matnr1 = wa_tab6-matnr1 lifnr = wa_tab6-lifnr.
      if sy-subrc eq 0.
        write : 53 'TOTAL NO. OF BATCH :',75(3) wa_tab11-count LEFT-JUSTIFIED.
      endif.

      select single * from mvke where matnr eq wa_tab6-matnr1.
      if sy-subrc eq 0.
        select single * from tvm5t where mvgr5 eq mvke-mvgr5 and spras eq 'EN'.
        if sy-subrc eq 0.
          write :  80 'PACK SIZE:',90 tvm5t-bezei LEFT-JUSTIFIED.
        endif.
      endif.

      read table it_tab7 into wa_tab7 with key matnr1 = wa_tab6-matnr1 lifnr = wa_tab6-lifnr.
      if sy-subrc eq 0.
        write : /'TOTAL QTY RECEIVED:', 22 wa_tab7-menge.
      endif.

      select single * from mast where matnr eq wa_tab6-matnr1 and werks in plant.
      if sy-subrc eq 0.
        select single * from stko where stlnr eq mast-stlnr.
        if sy-subrc eq 0.
*          write :53 'STANDARD BATCH SIZE:',stko-bmeng.
          bat_sz1 = wa_tab7-menge / ( stko-bmeng * 98 / 100 ).
          bat_sz = bat_sz1 * stko-bmeng.
          write :53 'STANDARD BATCH SIZE:',bat_sz.
          clear : bat_sz,bat_sz1.
        endif.
      endif.

      uline.
      write : /1 'MATERIAL',22 'DESCRIPTION',53 'QUANTITY',71 'VALUE'.
      uline.

    ENDIF.

    format color 4.
    WRITE : /1(10) wa_tab6-matnr.
    select single * from makt where matnr eq wa_tab6-matnr.
    if sy-subrc eq 0.
      write : 22(25) makt-maktx.
    endif.

    write : 50(12) wa_tab6-menge, 65(12) wa_tab6-dmbtr.

    a = a + 1.
    b = b + 1.
  endloop.


*  wa_fieldcat-fieldname = 'MBLNR'.
*  wa_fieldcat-seltext_s = 'DOC NO'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'MATNR1'.
*  wa_fieldcat-seltext_s = 'PRODUCT'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'CHARG1'.
*  wa_fieldcat-seltext_s = 'BATCH'.
*  append wa_fieldcat to fieldcat.
*
**  wa_fieldcat-fieldname = 'MENGE1'.
**  wa_fieldcat-seltext_s = 'PRD QTY'.
**  append wa_fieldcat to fieldcat.
**
**  wa_fieldcat-fieldname = 'DMBTR1'.
**  wa_fieldcat-seltext_s = 'PRD VAL'.
**  append wa_fieldcat to fieldcat.
*
**  wa_fieldcat-fieldname = 'SHKZG1'.
**  wa_fieldcat-seltext_s = 'TYPE'.
**  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'MATNR'.
*  wa_fieldcat-seltext_s = 'COMPONANT'.
*  append wa_fieldcat to fieldcat.
*
**  wa_fieldcat-fieldname = 'ZEILE'.
**  wa_fieldcat-seltext_s = 'ITEM NO'.
**  append wa_fieldcat to fieldcat.
*
**  wa_fieldcat-fieldname = 'SHKZG'.
**  wa_fieldcat-seltext_s = 'TYPE'.
**  append wa_fieldcat to fieldcat.
*
*
*  wa_fieldcat-fieldname = 'MENGE'.
*  wa_fieldcat-seltext_s = 'QUANTITY'.
*  append wa_fieldcat to fieldcat.
*
*
*  wa_fieldcat-fieldname = 'DMBTR'.
*  wa_fieldcat-seltext_s = 'VALUE'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'EBELN'.
*  wa_fieldcat-seltext_s = 'PO'.
*  append wa_fieldcat to fieldcat.
*
**  wa_fieldcat-fieldname = 'EBELP'.
**  wa_fieldcat-seltext_s = 'NO'.
**  append wa_fieldcat to fieldcat.
*
*
*  wa_fieldcat-fieldname = 'LFBNR'.
*  wa_fieldcat-seltext_s = 'REF DOC'.
*  append wa_fieldcat to fieldcat.
*
*
*
*
*
*  layout-zebra = 'X'.
*  layout-colwidth_optimize = 'X'.
*  layout-window_titlebar  = 'material consumption'.
*
*
*  call function 'REUSE_ALV_GRID_DISPLAY'
*   exporting
**   I_INTERFACE_CHECK                 = ' '
**   I_BYPASSING_BUFFER                = ' '
**   I_BUFFER_ACTIVE                   = ' '
*     i_callback_program                =  g_repid
**   I_CALLBACK_PF_STATUS_SET          = ' '
*   i_callback_user_command           = 'USER_COMM'
*   i_callback_top_of_page            = 'TOP'
**   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
**   I_CALLBACK_HTML_END_OF_LIST       = ' '
**   I_STRUCTURE_NAME                  =
**   I_BACKGROUND_ID                   = ' '
**   I_GRID_TITLE                      =
**   I_GRID_SETTINGS                   =
*   is_layout                         = layout
*     it_fieldcat                       = fieldcat
**   IT_EXCLUDING                      =
**   IT_SPECIAL_GROUPS                 =
**   IT_SORT                           =
**   IT_FILTER                         =
**   IS_SEL_HIDE                       =
**   I_DEFAULT                         = 'X'
*   i_save                            = 'A'
**   IS_VARIANT                        =
**   IT_EVENTS                         =
**   IT_EVENT_EXIT                     =
**   IS_PRINT                          =
**   IS_REPREP_ID                      =
**   I_SCREEN_START_COLUMN             = 0
**   I_SCREEN_START_LINE               = 0
**   I_SCREEN_END_COLUMN               = 0
**   I_SCREEN_END_LINE                 = 0
**   I_HTML_HEIGHT_TOP                 = 0
**   I_HTML_HEIGHT_END                 = 0
**   IT_ALV_GRAPHICS                   =
**   IT_HYPERLINK                      =
**   IT_ADD_FIELDCAT                   =
**   IT_EXCEPT_QINFO                   =
**   IR_SALV_FULLSCREEN_ADAPTER        =
** IMPORTING
**   E_EXIT_CAUSED_BY_CALLER           =
**   ES_EXIT_CAUSED_BY_USER            =
*    tables
*      t_outtab                          = it_tab5
*   exceptions
*     program_error                     = 1
*     others                            = 2
*            .
*  if sy-subrc <> 0.
** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
**         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*  endif.
*
*

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'MATERIAL CONSUMPTION'.
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
    when 'VBELN'.
      set parameter id 'VF' field selfield-value.
      call transaction 'VF03' and skip first screen.
    when 'VBELN1'.
      set parameter id 'BV' field selfield-value.
      call transaction 'VL03N' and skip first screen.
    when others.
  endcase.
endform.                    "USER_COMM
