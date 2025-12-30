*&---------------------------------------------------------------------*
*& Report  ZCO26_1
*&DEVELOPED BY JYOTSNA
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  zco26_2 no standard page heading line-size 380.
tables : aufm,
         aufk,
         afpo,
         makt,
         mcha,
         mvke,
         tvm5t,
         mara.

type-pools:  slis.

data: g_repid     like sy-repid,
      fieldcat    type slis_t_fieldcat_alv,
      wa_fieldcat like line of fieldcat,
      sort        type slis_t_sortinfo_alv,
      wa_sort     like line of sort,
      layout      type slis_layout_alv.

data : it_aufk      type table of aufk,
       wa_aufk      type aufk,
       it_aufm      type table of aufm,
       wa_aufm      type aufm,
       it_afpo      type table of afpo,
       wa_afpo      type afpo,
       it_afru      type table of afru,
       wa_afru      type afru,
       it_afru1     type table of afru,
       wa_afru1     type afru,
       it_zprd_ccpc type table of zprd_ccpc,
       wa_zprd_ccpc type zprd_ccpc.
data: it_mapl type table of mapl,
      wa_mapl type mapl,
      it_plko type table of plko,
      wa_plko type plko,
      it_plpo type table of plpo,
      wa_plpo type plpo,
      it_plas type table of plas,
      wa_plas type plas.

types : begin of ord1,
          aufnr type afpo-aufnr,
          vornr type afru-vornr,
        end of ord1.

data : it_aufm1 type table of aufm,
       wa_aufm1 type aufm,
       it_afpo1 type table of afpo,
       wa_afpo1 type afpo,
       it_mast  type table of mast,
       wa_mast  type mast,
       it_stpo  type table of stpo,
       wa_stpo  type stpo,
       it_mast1 type table of mast,
       wa_mast1 type mast,
       it_stpo1 type table of stpo,
       wa_stpo1 type stpo,
       it_mcha  type table of mcha,
       wa_mcha  type mcha.
data: it_ord1 type table of ord1,
      wa_ord1 type ord1.


types : begin of itab1,
          werks    type aufm-werks,
          aufnr    type aufm-aufnr,
          matnr    type aufm-matnr,
          charg    type aufm-charg,
          lgort    type aufm-lgort,
          menge    type aufm-menge,
          ablad    type aufm-ablad,
          auart    type aufk-auart,
          igmng    type afko-igmng,
          sbmng    type afko-sbmng,
          gamng    type afko-gamng,
          maktx    type makt-maktx,
          psmng    type p decimals 0,
          wemng    type p decimals 0,
          iamng    type afpo-iamng,
          wewrt    type afpo-wewrt,
          vfmng    type afpo-vfmng,
          conf_qty type p,
          ltrmi    type afpo-ltrmi,
          dgltp    type afpo-dgltp,
          erdat    type aufk-erdat,
          budat    type aufm-budat,
          vfdat    type mcha-vfdat,
        end of itab1.

types : begin of itab2,
          werks type aufm-werks,
          aufnr type aufm-aufnr,
          matnr type aufm-matnr,
          charg type aufm-charg,
          lgort type aufm-lgort,
          menge type aufm-menge,
          maktx type makt-maktx,
          psmng type p decimals 0,
          gmnga type p decimals 0,
        end of itab2.

types : begin of itab3,
          werks        type aufm-werks,
*          aufnr        type aufm-aufnr,
          aufnr(15)    type c, "25.9.22
          matnr        type aufm-matnr,
          charg        type aufm-charg,
          lgort        type aufm-lgort,
          menge        type aufm-menge,
          maktx        type makt-maktx,
          psmng        type p decimals 0,
          gmnga        type p decimals 0,
          rmdmbtr      type p decimals 2,
          pmdmbtr      type p decimals 2,
          wipqty       type p decimals 0,
          meins        type afpo-meins,
          rmval        type p decimals 2,
          pmval        type p decimals 2,
          cc           type p decimals 2,
          pc           type p decimals 2,
          lv_alphabets type string,
          lv_numbers   type string,
          ccval        type p decimals 2,
          total        type p decimals 2,
          div(2)       type c,
        end of itab3.

types: begin of ita1,
         aufnr type afru-aufnr,
         gmnga type p,
       end of ita1.

types : begin of sf1,
          matnr type mara-matnr,
          charg type mchb-charg,
        end of sf1.

types : begin of sf2,
          aufnr   type afpo-aufnr,
          matnr   type mara-matnr,
          charg   type mchb-charg,
          rmdmbtr type p decimals 2,
          pmdmbtr type p decimals 2,
        end of sf2.

types : begin of fgrm2,
          aufnr   type afpo-aufnr,
          matnr   type mara-matnr,
          charg   type mchb-charg,
          rmdmbtr type p decimals 2,
          pmdmbtr type p decimals 2,
          matnr1  type mara-matnr,
          meins   type afpo-meins,
        end of fgrm2.

types : begin of fgrm4,
          aufnr   type afpo-aufnr,
          matnr   type mara-matnr,
          charg   type mchb-charg,
          rmdmbtr type p decimals 2,
          pmdmbtr type p decimals 2,
          matnr1  type mara-matnr,
          meins   type afpo-meins,
          rmrate  type p decimals 5,
        end of fgrm4.

types  : begin of fgrm1,
           matnr type mara-matnr,
           stlnr type stpo-stlnr,
           idnrk type stpo-idnrk,
           charg type mchb-charg,
         end of fgrm1.

types : begin of ccpc1,
          matnr type mara-matnr,
        end of ccpc1.

types : begin of ccpc3,
          matnr   type mara-matnr,
          bezei   type tvm5t-bezei,
          from_dt type zprd_ccpc-from_dt,
          cc      type p decimals 2,
          pc      type p decimals 2,
        end of ccpc3.

types : begin of ccpc4,
          matnr        type mara-matnr,
          bezei        type tvm5t-bezei,
          from_dt      type zprd_ccpc-from_dt,
          cc           type p decimals 2,
          pc           type p decimals 2,
          lv_alphabets type string,
          lv_numbers   type string,
        end of ccpc4.

types : begin of div1,
          matnr  type mara-matnr,
          div(2) type c,
        end of div1.

data : it_tab1  type table of itab1,
       wa_tab1  type itab1,
       it_tab2  type table of itab2,
       wa_tab2  type itab2,
       it_tab3  type table of itab3,
       wa_tab3  type itab3,
       it_tab4  type table of itab3,
       wa_tab4  type itab3,
       it_ta1   type table of ita1,
       wa_ta1   type ita1,
       it_sf1   type table of sf1,
       wa_sf1   type sf1,
       it_fg1   type table of sf1,
       wa_fg1   type sf1,
       it_sf2   type table of sf2,
       wa_sf2   type sf2,
       it_sf3   type table of sf2,
       wa_sf3   type sf2,
       it_fg2   type table of sf2,
       wa_fg2   type sf2,
       it_fg3   type table of sf2,
       wa_fg3   type sf2,
       it_fgrm1 type table of fgrm1,
       wa_fgrm1 type fgrm1,
       it_fgrm2 type table of fgrm2,
       wa_fgrm2 type fgrm2,
       it_fgrm3 type table of fgrm2,
       wa_fgrm3 type fgrm2,
       it_fgrm4 type table of fgrm4,
       wa_fgrm4 type fgrm4,
       it_ccpc1 type table of ccpc1,
       wa_ccpc1 type ccpc1,
       it_ccpc2 type table of ccpc1,
       wa_ccpc2 type ccpc1,
       it_ccpc3 type table of ccpc3,
       wa_ccpc3 type ccpc3,
       it_ccpc4 type table of ccpc4,
       wa_ccpc4 type ccpc4,
       it_div1  type table of div1,
       wa_div1  type div1,
       it_div2  type table of div1,
       wa_div2  type div1.

data : conf_qty type p decimals 0,
       rmval    type p decimals 2,
       pmval    type p decimals 2.

data: result       type string,
      count        type i,
      cnt          type i,
      lv_alphabets type string,
      lv_numbers   type string,
      pack         type tvm5t-bezei,
      rate         type p  decimals 2,
      val          type p decimals 2,
      total        type p decimals 2,
      rmrate       type p decimals 5.

data : h_matnr type mara-matnr.

selection-screen begin of block merkmale1 with frame title text-001.
select-options : order for aufk-aufnr.


select-options : type for aufk-auart.
select-options : s_date for aufm-budat.
select-options : material for aufm-matnr.
parameters : plant like aufm-werks.
selection-screen end of block merkmale1 .

initialization.
  g_repid = sy-repid.

start-of-selection.

  select * from aufk into table it_aufk where bukrs eq '1000' and aufnr in order and auart in type and erdat in s_date and werks eq plant
  and idat2 eq 0 and loekz ne 'X'.
  if sy-subrc eq 0.
    select * from afpo into table it_afpo for all entries in it_aufk where aufnr eq it_aufk-aufnr and matnr in material and dnrel ne 'X'.
    if sy-subrc ne 0.
      exit .
    endif.
  endif.
  select * from afru into table it_afru for all entries in it_afpo where aufnr eq it_afpo-aufnr and aueru eq 'X'
  and stzhl eq ' ' and stokz eq ' '..
*******************routing***************

  if it_afpo is not initial.
    select * from mapl into table it_mapl for all entries in it_afpo where matnr eq it_afpo-matnr and werks eq it_afpo-dwerk and plnty eq 'N'.
    if sy-subrc eq 0.
      select * from plko into table it_plko for all entries in it_mapl where plnty eq 'N' and plnnr eq it_mapl-plnnr and plnal eq it_mapl-plnal
        and delkz eq space.
      if sy-subrc eq 0.
        select * from plas into table it_plas for all entries in it_plko where plnty eq 'N' and plnnr eq it_plko-plnnr and plnal eq it_plko-plnal.
        if sy-subrc eq 0.
          select * from plpo into table it_plpo for all entries in it_plas where plnty eq 'N' and plnnr eq it_plas-plnnr and zaehl eq it_plas-zaehl.
        endif.
      endif.
    endif.
  endif.


  loop at it_afpo into wa_afpo.
*    read table it_mapl into wa_mapl with key matnr = wa_afpo-matnr werks = wa_afpo-dwerk.
*    if sy-subrc eq 0.
    loop at it_mapl into wa_mapl where matnr = wa_afpo-matnr and werks = wa_afpo-dwerk.
*      read table it_plko into wa_plko with key plnnr = wa_mapl-plnnr plnal = wa_mapl-plnal.
*      if sy-subrc eq 0.
      loop at it_plko into wa_plko where plnnr = wa_mapl-plnnr and plnal = wa_mapl-plnal.
        loop at it_plas into wa_plas where plnnr = wa_plko-plnnr and  plnal eq wa_plko-plnal.
          read table it_plpo into wa_plpo with key plnty = 'N' plnnr = wa_plas-plnnr zaehl = wa_plas-zaehl.
          if sy-subrc eq 0.
            read table it_afru into wa_afru with key   aufnr = wa_afpo-aufnr vornr = wa_plpo-vornr.
            if sy-subrc eq 4.
              wa_ord1-aufnr = wa_afpo-aufnr.
*              wa_ord1-vornr = wa_afru-vornr.
              collect wa_ord1 into it_ord1.
              clear wa_ord1.
            endif.
          endif.
        endloop.
      endloop.
    endloop.
  endloop.
  sort it_ord1 by aufnr .
  delete adjacent duplicates from it_ord1.


************************************************

  loop at it_afpo into wa_afpo.


    read table it_ord1 into wa_ord1 with key aufnr = wa_afpo-aufnr.
    if sy-subrc eq 0.
*    if wa_aufm-shkzg eq 'H'.
*      WA_AFPO-MENGE = WA_AFPO-MENGE * ( - 1 ).
*    ENDIF.
*  WRITE : / wa_AFPO-werks,wa_AFPO-aufnr,wa_AFPO-matnr,wa_AFPO-charg,wa_AFPO-lgort,wa_AFPO-menge,wa_AFPO-ablad.

      wa_tab1-aufnr = wa_afpo-aufnr.
      wa_tab1-matnr = wa_afpo-matnr.
      wa_tab1-ltrmi = wa_afpo-ltrmi.
      wa_tab1-dgltp = wa_afpo-dgltp.
      select single * from makt where matnr eq wa_afpo-matnr.
      if sy-subrc eq 0.
        wa_tab1-maktx = makt-maktx.
      endif.
      wa_tab1-charg = wa_afpo-charg.
      select single * from mcha where matnr eq wa_afpo-matnr and werks eq wa_afpo-pwerk and charg eq wa_afpo-charg.
      if sy-subrc eq 0.
        wa_tab1-vfdat = mcha-vfdat.
      endif.
      wa_tab1-lgort = wa_afpo-lgort.
      wa_tab1-psmng = wa_afpo-psmng.
      wa_tab1-wemng = wa_afpo-wemng.
      wa_tab1-iamng = wa_afpo-iamng.
      wa_tab1-wewrt = wa_afpo-wewrt.
      wa_tab1-vfmng = wa_afpo-vfmng.
      wa_tab1-ablad = wa_afpo-ablad.
      conf_qty = wa_afpo-psmng - wa_afpo-iamng.
      wa_tab1-conf_qty = conf_qty.
      read table it_aufk into wa_aufk with key aufnr = wa_afpo-aufnr.
      if sy-subrc eq 0.
*    WRITE : wa_aufk-auart.
        wa_tab1-auart = wa_aufk-auart.
        wa_tab1-werks = wa_aufk-werks.
        wa_tab1-erdat = wa_aufk-erdat.
      endif.
      select single * from aufm where aufnr eq wa_afpo-aufnr and bwart eq '261'.
      if sy-subrc eq 0.
        wa_tab1-budat = aufm-budat.
      endif.
*    READ TABLE it_afko INTO wa_afko with KEY aufnr = wa_AFPO-aufnr.
*    if sy-subrc eq 0.
**    WRITE : wa_afko-igmng,wa_afko-sbmng,wa_afko-gamng.
*      wa_tab1-igmng = wa_afko-igmng.
*      wa_tab1-igmng = wa_afko-igmng.
*
*    ENDIF.
      collect wa_tab1 into it_tab1.
      clear wa_tab1.
    endif.

  endloop.

*********************

*   loop at it_afpo into wa_afpo.
*
*    read table it_ord1  into wa_ord1 with key aufnr = wa_afpo-aufnr .
*    if sy-subrc eq 4.
*
**    if wa_aufm-shkzg eq 'H'.
**      WA_AFPO-MENGE = WA_AFPO-MENGE * ( - 1 ).
**    ENDIF.
**  WRITE : / wa_AFPO-werks,wa_AFPO-aufnr,wa_AFPO-matnr,wa_AFPO-charg,wa_AFPO-lgort,wa_AFPO-menge,wa_AFPO-ablad.
*
*        wa_tab1-aufnr = wa_afpo-aufnr.
*        wa_tab1-matnr = wa_afpo-matnr.
*        wa_tab1-ltrmi = wa_afpo-ltrmi.
*        wa_tab1-dgltp = wa_afpo-dgltp.
*        select single * from makt where matnr eq wa_afpo-matnr.
*        if sy-subrc eq 0.
*          wa_tab1-maktx = makt-maktx.
*        endif.
*        wa_tab1-charg = wa_afpo-charg.
*        select single * from mcha where matnr eq wa_afpo-matnr and werks eq wa_afpo-pwerk and charg eq wa_afpo-charg.
*        if sy-subrc eq 0.
*          wa_tab1-vfdat = mcha-vfdat.
*        endif.
*        wa_tab1-lgort = wa_afpo-lgort.
*        wa_tab1-psmng = wa_afpo-psmng.
*        wa_tab1-wemng = wa_afpo-wemng.
*        wa_tab1-iamng = wa_afpo-iamng.
*        wa_tab1-wewrt = wa_afpo-wewrt.
*        wa_tab1-vfmng = wa_afpo-vfmng.
*        wa_tab1-ablad = wa_afpo-ablad.
*        conf_qty = wa_afpo-psmng - wa_afpo-iamng.
*        wa_tab1-conf_qty = conf_qty.
*        read table it_aufk into wa_aufk with key aufnr = wa_afpo-aufnr.
*        if sy-subrc eq 0.
**    WRITE : wa_aufk-auart.
*          wa_tab1-auart = wa_aufk-auart.
*          wa_tab1-werks = wa_aufk-werks.
*          wa_tab1-erdat = wa_aufk-erdat.
*        endif.
*        select single * from aufm where aufnr eq wa_afpo-aufnr and bwart eq '261'.
*        if sy-subrc eq 0.
*          wa_tab1-budat = aufm-budat.
*        endif.
**    READ TABLE it_afko INTO wa_afko with KEY aufnr = wa_AFPO-aufnr.
**    if sy-subrc eq 0.
***    WRITE : wa_afko-igmng,wa_afko-sbmng,wa_afko-gamng.
**      wa_tab1-igmng = wa_afko-igmng.
**      wa_tab1-igmng = wa_afko-igmng.
**
**    ENDIF.
*        collect wa_tab1 into it_tab1.
*        clear wa_tab1.
*
*    endif.
*  endloop.

  select * from afru into table it_afru1 for all entries in it_tab1 where aufnr eq it_tab1-aufnr and aueru ne 'X'.

  loop at it_afru1 into wa_afru1.
    if wa_afru1-stokz eq ' ' and wa_afru1-stzhl eq ' '.
*  WRITE : / 'aaa',wa_afru1-aufnr.
      wa_ta1-aufnr = wa_afru1-aufnr.
      wa_ta1-gmnga = wa_afru1-gmnga.
      collect wa_ta1 into it_ta1.
      clear wa_ta1.
    endif.
  endloop.

*  LOOP at it_ta1 INTO wa_ta1.
*    WRITE : / 'aa',wa_ta1-aufnr,wa_ta1-gmnga.
*  ENDLOOP.

  sort it_tab1 by maktx.
  loop at it_tab1 into wa_tab1 where charg ne  '  '.
*    write : /1 wa_tab1-aufnr left-justified,15 wa_tab1-matnr left-justified,30 wa_tab1-charg left-justified,45 wa_tab1-psmng left-justified,
*              60 wa_tab1-maktx left-justified.
*    read table it_ta1 into wa_ta1 with key aufnr = wa_tab1-aufnr.
*    if sy-subrc eq 0.
*      write : 100 wa_ta1-gmnga left-justified. "confirm qty
*    endif.
    wa_tab2-aufnr = wa_tab1-aufnr.
    wa_tab2-matnr = wa_tab1-matnr.
    wa_tab2-charg = wa_tab1-charg.
    wa_tab2-psmng = wa_tab1-psmng.
    wa_tab2-maktx = wa_tab1-maktx.
    read table it_ta1 into wa_ta1 with key aufnr = wa_tab1-aufnr.
    if sy-subrc eq 0.
      wa_tab2-gmnga = wa_ta1-gmnga. "confirm qty
    endif.
    collect wa_tab2 into it_tab2.
    clear wa_tab2.
  endloop.

  perform rmpm.

  loop at it_tab2 into wa_tab2.
    clear : rmval,pmval.
*    write : / 'BB', wa_tab2-aufnr, wa_tab2-matnr,wa_tab2-charg.
*    READ TABLE IT_FGRM4 INTO WA_FGRM4 WITH KEY MATNR1 = WA_TAB2-MATNR CHARG = WA_TAB2-CHARG.
*    IF SY-SUBRC EQ 0.
*      WRITE : WA_FGRM4-MEINS,WA_FGRM4-RMRATE,WA_FGRM4-RMDMBTR.
*    ENDIF.
    wa_tab3-aufnr = wa_tab2-aufnr.
    wa_tab3-matnr = wa_tab2-matnr.
    wa_tab3-charg = wa_tab2-charg.
    wa_tab3-psmng = wa_tab2-psmng.
    wa_tab3-maktx = wa_tab2-maktx.
    wa_tab3-gmnga = wa_tab2-gmnga.
    wa_tab3-wipqty = wa_tab2-psmng - wa_tab2-gmnga.
    read table it_afpo into wa_afpo with key aufnr = wa_tab2-aufnr matnr = wa_tab2-matnr charg = wa_tab2-charg.
    if sy-subrc eq 0.
*      WRITE : WA_AFPO-MEINS.
      wa_tab3-meins = wa_afpo-meins.
    endif.
    if wa_tab2-matnr ca 'H'.
      read table it_sf3 into wa_sf3 with key matnr = wa_tab2-matnr charg = wa_tab2-charg.
      if sy-subrc eq 0.
        wa_tab3-rmdmbtr = wa_sf3-rmdmbtr.
        wa_tab3-pmdmbtr = wa_sf3-pmdmbtr.
      endif.
    else.
      read table it_fgrm3 into wa_fgrm3 with key matnr1 = wa_tab2-matnr charg = wa_tab2-charg.
      if sy-subrc eq 0.
        wa_tab3-rmdmbtr = wa_fgrm3-rmdmbtr.
      endif.
      read table it_fg3 into wa_fg3 with key matnr = wa_tab2-matnr charg = wa_tab2-charg.
      if sy-subrc eq 0.
        wa_tab3-pmdmbtr = wa_fg3-pmdmbtr.
      endif.
    endif.

*    READ TABLE IT_FGRM4 INTO WA_FGRM4 WITH KEY MATNR1 = WA_TAB2-MATNR CHARG = WA_TAB2-CHARG.
*    IF SY-SUBRC EQ 0.
*      WRITE : WA_FGRM4-MEINS,WA_FGRM4-RMRATE.
*
*
*   RMVAL = ( WA_TAB3-RMDMBTR / WA_TAB3-PSMNG ) * WA_TAB3-WIPQTY.
*   ENDIF.
    pmval = ( wa_tab3-pmdmbtr / wa_tab3-psmng ) * wa_tab3-wipqty.
*   WA_TAB3-RMVAL = RMVAL.
    wa_tab3-pmval = pmval.
    read table it_ccpc4 into wa_ccpc4 with key matnr = wa_tab2-matnr.
    if sy-subrc eq 0.
      wa_tab3-cc = wa_ccpc4-cc.
      wa_tab3-pc = wa_ccpc4-pc.
      wa_tab3-lv_alphabets = wa_ccpc4-lv_alphabets.
      wa_tab3-lv_numbers = wa_ccpc4-lv_numbers.
    else.
      if wa_tab2-matnr ca 'H'.
        h_matnr = wa_tab2-matnr.
        replace all occurrences of substring 'H' in h_matnr with ''.
        shift h_matnr right deleting trailing space.
        overlay h_matnr with '0000000000000'.
*           WRITE : / WA_TAB2-MATNR,'H',H_MATNR.
        read table it_ccpc4 into wa_ccpc4 with key matnr = h_matnr.
        if sy-subrc eq 0.
          wa_tab3-cc = wa_ccpc4-cc.
          wa_tab3-pc = wa_ccpc4-pc.
          wa_tab3-lv_alphabets = wa_ccpc4-lv_alphabets.
          wa_tab3-lv_numbers = wa_ccpc4-lv_numbers.
        endif.
      endif.
    endif.
*   WRITE : 'PACK',WA_TAB3-LV_NUMBERS.
*****************RM VALUE******************
*    WRITE : / '*****',WA_TAB3-MATNR.
    if wa_tab3-matnr ca 'H'.
*     WRITE : 'HALB'.
      rmval = ( wa_tab3-rmdmbtr / wa_tab3-psmng ) * wa_tab3-wipqty.
      wa_tab3-rmval = rmval.
    else.
      read table it_fgrm4 into wa_fgrm4 with key matnr1 = wa_tab2-matnr charg = wa_tab2-charg.
      if sy-subrc eq 0.
        rmval = ( wa_fgrm4-rmrate * wa_tab3-lv_numbers ) * wa_tab3-wipqty.
        wa_tab3-rmval = rmval.
      endif.
    endif.
    collect wa_tab3 into it_tab3.
    clear wa_tab3.
  endloop.

  perform div.
  perform div1.

  loop at it_tab3 into wa_tab3.
    clear : val,total.
    wa_tab4-aufnr = wa_tab3-aufnr.
    wa_tab4-matnr = wa_tab3-matnr.
    wa_tab4-maktx = wa_tab3-maktx.
    wa_tab4-charg = wa_tab3-charg.
    wa_tab4-psmng = wa_tab3-psmng.
    wa_tab4-meins = wa_tab3-meins.
    wa_tab4-gmnga = wa_tab3-gmnga.
    wa_tab4-rmval = wa_tab3-rmval.
    wa_tab4-pmval = wa_tab3-pmval.
    wa_tab4-wipqty = wa_tab3-wipqty.
    if wa_tab3-matnr ca 'H'.
      wa_tab4-cc = 0.
      wa_tab3-cc = 0.
    else.
      wa_tab4-cc = wa_tab3-cc.
    endif.
    wa_tab4-pc = wa_tab3-pc.
    if wa_tab3-meins eq 'EA'.
      val = wa_tab3-cc * wa_tab3-wipqty.
    elseif wa_tab3-meins eq 'PC'.
      val = ( wa_tab3-cc / wa_tab3-lv_numbers ) * wa_tab3-wipqty.
    elseif wa_tab3-meins eq 'L' or wa_tab3-meins eq 'KG' or wa_tab3-meins eq 'KGS'.
      val =  ( wa_tab3-cc / ( wa_tab3-lv_numbers / 1000 ) ) * wa_tab3-wipqty.
    endif.

    wa_tab4-ccval = val.
    total = wa_tab4-rmval + wa_tab4-pmval + wa_tab4-ccval.
    wa_tab4-total = total.
    select single * from mara where matnr eq wa_tab3-matnr.
    if sy-subrc eq 0.
      if mara-spart eq '50'.
        wa_tab4-div = 'BC'.
      elseif mara-spart eq '60'.
        wa_tab4-div = 'XL'.
      elseif wa_tab3-matnr cs 'H'.
        read table it_div1 into wa_div1 with key matnr = wa_tab3-matnr.
        if sy-subrc eq 0.
          wa_tab4-div = wa_div1-div.
        endif.
      else.
        read table it_div2 into wa_div2 with key matnr = wa_tab3-matnr.
        if sy-subrc eq 0.
          wa_tab4-div = wa_div2-div.
        endif.

      endif.
    endif.
    collect wa_tab4 into it_tab4.
    clear wa_tab4.
  endloop.

  wa_fieldcat-fieldname = 'AUFNR'.
  wa_fieldcat-seltext_l = 'ORDER'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-seltext_l = 'PRODUCT CODE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-seltext_l = 'PRODUCT DESCRIPTION'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CHARG'.
  wa_fieldcat-seltext_l = 'BATCH'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'PSMNG'.
  wa_fieldcat-seltext_l = 'ORDER QTY'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'MEINS'.
  wa_fieldcat-seltext_l = 'UNIT'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'GMNGA'.
  wa_fieldcat-seltext_l = 'CONFIRMED QTY'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'WIPQTY'.
  wa_fieldcat-seltext_l = 'WIP QTY'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

*  WA_FIELDCAT-fieldname = 'RMDMBTR'.
*  WA_FIELDCAT-seltext_l = 'RM VALUE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'PMDMBTR'.
*  WA_FIELDCAT-seltext_l = 'PM VALUE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  wa_fieldcat-fieldname = 'RMVAL'.
  wa_fieldcat-seltext_l = 'RM VALUATION'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'PMVAL'.
  wa_fieldcat-seltext_l = 'PM VALUATION'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CCVAL'.
  wa_fieldcat-seltext_l = 'CC VALUATION'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'TOTAL'.
  wa_fieldcat-seltext_l = 'TOTAL VALUATION'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'CC'.
  wa_fieldcat-seltext_l = 'CC RATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'PC'.
  wa_fieldcat-seltext_l = 'PC RATE'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.

  wa_fieldcat-fieldname = 'DIV'.
  wa_fieldcat-seltext_l = 'DIVIION'.
  append wa_fieldcat to fieldcat.
  clear wa_fieldcat.


  layout-zebra = 'X'.
  layout-colwidth_optimize = 'X'.
  layout-window_titlebar  = 'WIP VALUATION'.


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
      t_outtab                = it_tab4
    exceptions
      program_error           = 1
      others                  = 2.
  if sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  endif.

*ENDFORM.                    "SUMMARY

*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form top.

  data: comment    type slis_t_listheader,
        wa_comment like line of comment.

  wa_comment-typ = 'A'.
  wa_comment-info = 'WIP VALUATION'.
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
    when 'VBELN'.
      set parameter id 'VF' field selfield-value.
      call transaction 'VF03' and skip first screen.
    when 'VBELN1'.
      set parameter id 'BV' field selfield-value.
      call transaction 'VL03N' and skip first screen.
    when others.
  endcase.
endform.                    "USER_COMM





form rmpm.
  loop at it_tab2 into wa_tab2.
*    write : / wa_tab2-aufnr, wa_tab2-matnr,wa_tab2-charg,wa_tab2-psmng,wa_tab2-maktx, wa_tab2-gmnga.
    if wa_tab2-matnr ca 'H'.
      wa_sf1-matnr = wa_tab2-matnr.
      wa_sf1-charg = wa_tab2-charg.
      collect wa_sf1 into it_sf1.
      clear wa_sf1.
    else.
      wa_fg1-matnr = wa_tab2-matnr.
      wa_fg1-charg = wa_tab2-charg.
      collect wa_fg1 into it_fg1.
      clear wa_fg1.
    endif.
  endloop.
*    LOOP AT IT_SF1 INTO WA_SF1.
*      WRITE : / 'SF',WA_SF1-MATNR,WA_SF1-CHARG.
*    ENDLOOP.
*    LOOP AT IT_FG1 INTO WA_FG1.
*      WRITE : / 'FG',WA_FG1-MATNR,WA_FG1-CHARG.
*    ENDLOOP.
  perform ccpc.
  perform sf.
  perform fgpm.
  perform fgrm.
endform.



***************new rm / pm logic starts*************************
*************RM PM FOR HALB********************
form sf.

  clear : it_afpo1,it_aufm1.
  if it_sf1 is not initial.
    select * from afpo into table it_afpo1 for all entries in it_sf1 where pwerk eq plant and matnr eq it_sf1-matnr
    and charg eq it_sf1-charg.
    if sy-subrc eq 0.
      select * from aufm into table it_aufm1 for all entries in it_afpo1 where aufnr eq it_afpo1-aufnr.
    endif.
  endif.
  loop at it_afpo1 into wa_afpo1.
    select single * from aufk where aufnr eq wa_afpo1-aufnr and loekz eq 'X'.
    if sy-subrc eq 0.
      delete it_afpo1 where aufnr eq aufk-aufnr.
    endif.
  endloop.

  loop at it_sf1 into wa_sf1.
    loop at it_afpo1 into wa_afpo1 where matnr eq wa_sf1-matnr and charg eq wa_sf1-charg.
      wa_sf2-aufnr = wa_afpo1-aufnr.
      wa_sf2-matnr = wa_sf1-matnr.
      wa_sf2-charg = wa_sf1-charg.
      collect wa_sf2 into it_sf2.
      clear wa_sf2.
    endloop.
  endloop.
  loop at it_sf2 into wa_sf2.
    loop at it_aufm1 into wa_aufm1 where aufnr eq wa_sf2-aufnr and lgort ge 'RM01' and lgort le 'RM04'.
      if wa_aufm1-shkzg eq 'S'.
        wa_aufm1-dmbtr = wa_aufm1-dmbtr * ( - 1 ).
      endif.
      wa_sf3-aufnr = wa_sf2-aufnr.
      wa_sf3-matnr = wa_sf2-matnr.
      wa_sf3-charg = wa_sf2-charg.
      wa_sf3-rmdmbtr = wa_aufm1-dmbtr.
      collect wa_sf3 into it_sf3.
      clear wa_sf3.
    endloop.
  endloop.
  loop at it_sf2 into wa_sf2.
*    LOOP AT it_aufm1 INTO wa_aufm1 WHERE aufnr EQ wa_sf2-aufnr AND lgort IN ('PM01','PM02','PM03','PM04','MRN1','MRN4').
    loop at it_aufm1 into wa_aufm1 where aufnr eq wa_sf2-aufnr .
      if wa_aufm1-lgort eq 'PM01' or wa_aufm1-lgort eq 'PM02' or wa_aufm1-lgort eq 'PM03' or wa_aufm1-lgort eq 'PM04'
        or wa_aufm1-lgort eq 'MRN1' or wa_aufm1-lgort eq 'MRN4'.
        if wa_aufm1-shkzg eq 'S'.
          wa_aufm1-dmbtr = wa_aufm1-dmbtr * ( - 1 ).
        endif.
        wa_sf3-aufnr = wa_sf2-aufnr.
        wa_sf3-matnr = wa_sf2-matnr.
        wa_sf3-charg = wa_sf2-charg.
        wa_sf3-pmdmbtr = wa_aufm1-dmbtr.
        collect wa_sf3 into it_sf3.
        clear wa_sf3.
      endif.
    endloop.
  endloop.
*  LOOP AT IT_SF3 INTO WA_SF3.
*    WRITE : / 'SF',WA_SF3-AUFNR,WA_SF3-MATNR,WA_SF3-CHARG,'RM',WA_SF3-RMDMBTR,'PM',WA_SF3-PMDMBTR.
*  ENDLOOP.

endform.

form fgpm.
  clear : it_afpo1,it_aufm1.
  if it_fg1 is not initial.
    select * from afpo into table it_afpo1 for all entries in it_fg1 where pwerk eq plant and matnr eq it_fg1-matnr
    and charg eq it_fg1-charg.
    if sy-subrc eq 0.
      select * from aufm into table it_aufm1 for all entries in it_afpo1 where aufnr eq it_afpo1-aufnr.
    endif.
  endif.

  loop at it_afpo1 into wa_afpo1.
    select single * from aufk where aufnr eq wa_afpo1-aufnr and loekz eq 'X'.
    if sy-subrc eq 0.
      delete it_afpo1 where aufnr eq aufk-aufnr.
    endif.
  endloop.

  loop at it_fg1 into wa_fg1.
    loop at it_afpo1 into wa_afpo1 where matnr eq wa_fg1-matnr and charg eq wa_fg1-charg.
      wa_fg2-aufnr = wa_afpo1-aufnr.
      wa_fg2-matnr = wa_fg1-matnr.
      wa_fg2-charg = wa_fg1-charg.
      collect wa_fg2 into it_fg2.
      clear wa_fg2.
    endloop.
  endloop.
  loop at it_fg2 into wa_fg2.
    loop at it_aufm1 into wa_aufm1 where aufnr eq wa_fg2-aufnr and lgort ge 'RM01' and lgort le 'RM04'.
      if wa_aufm1-shkzg eq 'S'.
        wa_aufm1-dmbtr = wa_aufm1-dmbtr * ( - 1 ).
      endif.
      wa_fg3-aufnr = wa_fg2-aufnr.
      wa_fg3-matnr = wa_fg2-matnr.
      wa_fg3-charg = wa_fg2-charg.
      wa_fg3-rmdmbtr = wa_aufm1-dmbtr.
      collect wa_fg3 into it_fg3.
      clear wa_fg3.
    endloop.
  endloop.
  loop at it_fg2 into wa_fg2.
    loop at it_aufm1 into wa_aufm1 where aufnr eq wa_fg2-aufnr.
*       and lgort ge 'PM01' and lgort le 'PM04'.
      if wa_aufm1-lgort eq 'PM01' or wa_aufm1-lgort eq 'PM02' or wa_aufm1-lgort eq 'PM03' or wa_aufm1-lgort eq 'PM04'
       or wa_aufm1-lgort eq 'MRN1' or wa_aufm1-lgort eq 'MRN4'.
        if wa_aufm1-shkzg eq 'S'.
          wa_aufm1-dmbtr = wa_aufm1-dmbtr * ( - 1 ).
        endif.
        wa_fg3-aufnr = wa_fg2-aufnr.
        wa_fg3-matnr = wa_fg2-matnr.
        wa_fg3-charg = wa_fg2-charg.
        wa_fg3-pmdmbtr = wa_aufm1-dmbtr.
        collect wa_fg3 into it_fg3.
        clear wa_fg3.
      endif.
    endloop.
  endloop.
*  LOOP AT IT_fg3 INTO WA_fg3.
*    WRITE : / 'FGPM',WA_fg3-AUFNR,WA_fg3-MATNR,WA_fg3-CHARG,'PM',WA_fg3-PMDMBTR.
*  ENDLOOP.

endform.

form fgrm .
*   LOOP AT IT_FG1 INTO WA_FG1.
*      WRITE : / 'FG',WA_FG1-MATNR,WA_FG1-CHARG.
*    ENDLOOP.

  if it_fg1 is not initial.
    select * from mast into table it_mast for all entries in it_fg1 where matnr eq it_fg1-matnr.
    if sy-subrc eq 0.
      select * from stpo into table it_stpo for all entries in it_mast where stlnr eq it_mast-stlnr.
    endif.
  endif.

  loop at it_stpo into wa_stpo where idnrk cs 'H'.
    read table it_mast into wa_mast with key stlnr = wa_stpo-stlnr.
    if sy-subrc eq 0.
      loop at it_fg1 into wa_fg1 where matnr eq wa_mast-matnr.
        wa_fgrm1-stlnr = wa_stpo-stlnr.
        wa_fgrm1-idnrk = wa_stpo-idnrk.
        wa_fgrm1-matnr = wa_mast-matnr.
        wa_fgrm1-charg = wa_fg1-charg.
        collect wa_fgrm1 into it_fgrm1.
        clear wa_fgrm1.
      endloop.
    endif.
  endloop.

*LOOP AT IT_FGRM1 INTO WA_FGRM1.
*  WRITE : / 'FGRM',WA_FGRM1-MATNR,WA_FGRM1-STLNR,WA_FGRM1-IDNRK,WA_FGRM1-CHARG.
*ENDLOOP.

  clear : it_afpo1,it_aufm1.

  if it_fgrm1 is not initial.
    select * from afpo into table it_afpo1 for all entries in it_fgrm1 where pwerk eq plant and matnr eq it_fgrm1-idnrk
    and charg eq it_fgrm1-charg.
    if sy-subrc eq 0.
      select * from aufm into table it_aufm1 for all entries in it_afpo1 where aufnr eq it_afpo1-aufnr.
    endif.
  endif.

  loop at it_afpo1 into wa_afpo1.
    select single * from aufk where aufnr eq wa_afpo1-aufnr and loekz eq 'X'.
    if sy-subrc eq 0.
      delete it_afpo1 where aufnr eq aufk-aufnr.
    endif.
  endloop.

  loop at it_fgrm1 into wa_fgrm1.
    loop at it_afpo1 into wa_afpo1 where matnr eq wa_fgrm1-idnrk and charg eq wa_fgrm1-charg.
      wa_fgrm2-aufnr = wa_afpo1-aufnr.
      wa_fgrm2-matnr = wa_fgrm1-idnrk.
      wa_fgrm2-matnr1 = wa_fgrm1-matnr.
      wa_fgrm2-charg = wa_fgrm1-charg.
      wa_fgrm2-meins = wa_afpo1-meins.
      collect wa_fgrm2 into it_fgrm2.
      clear wa_fgrm2.
    endloop.
  endloop.
  loop at it_fgrm2 into wa_fgrm2.
    loop at it_aufm1 into wa_aufm1 where aufnr eq wa_fgrm2-aufnr and lgort ge 'RM01' and lgort le 'RM04'.
      if wa_aufm1-shkzg eq 'S'.
        wa_aufm1-dmbtr = wa_aufm1-dmbtr * ( - 1 ).
      endif.
      wa_fgrm3-aufnr = wa_fgrm2-aufnr.
      wa_fgrm3-matnr = wa_fgrm2-matnr.
      wa_fgrm3-matnr1 = wa_fgrm2-matnr1.
      wa_fgrm3-charg = wa_fgrm2-charg.
      wa_fgrm3-rmdmbtr = wa_aufm1-dmbtr.
      collect wa_fgrm3 into it_fgrm3.
      clear wa_fgrm3.
    endloop.
  endloop.

  loop at it_fgrm3 into wa_fgrm3.
    clear rmrate.
*    WRITE : / 'FGRM3',WA_FGRM3-AUFNR,WA_FGRM3-MATNR,WA_FGRM3-MATNR1,WA_FGRM3-CHARG,'RM',WA_FGRM3-RMDMBTR.
    wa_fgrm4-aufnr = wa_fgrm3-aufnr.
    wa_fgrm4-matnr = wa_fgrm3-matnr.
    wa_fgrm4-matnr1 = wa_fgrm3-matnr1.
    wa_fgrm4-charg = wa_fgrm3-charg.
    wa_fgrm4-rmdmbtr = wa_fgrm3-rmdmbtr.
    read table it_afpo1 into wa_afpo1 with key matnr = wa_fgrm3-matnr charg = wa_fgrm3-charg.
    if sy-subrc eq 0.
      wa_fgrm4-meins = wa_afpo1-meins.
*      WRITE : WA_AFPO1-MEINS,WA_AFPO1-WEMNG.
      if wa_afpo1-wemng gt 0.
        rmrate = wa_fgrm3-rmdmbtr / wa_afpo1-wemng.
      endif.
      if wa_afpo1-meins eq 'L' or wa_afpo1-meins eq 'KG' or wa_afpo1-meins eq 'KGS'.
        rmrate = rmrate / 1000.
      endif.
    endif.
*    WRITE : RMRATE.
    wa_fgrm4-rmrate = rmrate.
    collect wa_fgrm4 into it_fgrm4.
    clear wa_fgrm4.
  endloop.


endform.
*&---------------------------------------------------------------------*
*&      Form  CCPC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form ccpc.

  loop at it_sf1 into wa_sf1.
*  WRITE : / 'SF',WA_SF1-MATNR.
    wa_ccpc1-matnr = wa_sf1-matnr.
    collect wa_ccpc1 into it_ccpc1.
    clear wa_ccpc1.
  endloop.
*

  loop at it_ccpc1 into wa_ccpc1.
*  WRITE : / '1', WA_CCPC1-MATNR.
    replace all occurrences of substring 'H' in wa_ccpc1-matnr with ''.
    shift wa_ccpc1-matnr right deleting trailing space.
    overlay wa_ccpc1-matnr with '0000000000000'.
*     WRITE : '1', WA_CCPC1-MATNR.
    wa_ccpc2-matnr = wa_ccpc1-matnr.
    collect wa_ccpc2 into it_ccpc2.
    clear wa_ccpc2.
  endloop.

  loop at it_fg1 into wa_fg1.
    wa_ccpc2-matnr = wa_fg1-matnr.
    collect wa_ccpc2 into it_ccpc2.
    clear wa_ccpc2.
  endloop.
  sort it_ccpc2 by matnr .
  delete adjacent duplicates from it_ccpc2 comparing matnr.
  select * from zprd_ccpc into table it_zprd_ccpc for all entries in it_ccpc2 where matnr eq it_ccpc2-matnr.
  sort it_zprd_ccpc descending by from_dt.

  loop at it_ccpc2 into wa_ccpc2.
*  WRITE : / '2',WA_CCPC2-MATNR.
    read table it_zprd_ccpc into wa_zprd_ccpc with key matnr = wa_ccpc2-matnr.
    if sy-subrc eq 0.
      wa_ccpc3-matnr = wa_ccpc2-matnr.
      wa_ccpc3-from_dt = wa_zprd_ccpc-from_dt.
      wa_ccpc3-cc = wa_zprd_ccpc-cc.
      wa_ccpc3-pc = wa_zprd_ccpc-pc.
      select single * from mvke where matnr eq wa_ccpc3-matnr and vkorg eq '1000' and vtweg eq '10'.
      if sy-subrc eq 0.
        select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
        if sy-subrc eq 0.
          wa_ccpc3-bezei = tvm5t-bezei.
        endif.
      else.
        select single * from mvke where matnr eq wa_ccpc3-matnr.
        if sy-subrc eq 0.
          select single * from tvm5t where spras eq 'EN' and mvgr5 eq mvke-mvgr5.
          if sy-subrc eq 0.
            wa_ccpc3-bezei = tvm5t-bezei.
          endif.
        endif.
      endif.
      collect wa_ccpc3 into it_ccpc3.
      clear wa_ccpc3.
    endif.
  endloop.

  loop at it_ccpc3 into wa_ccpc3.
    clear : pack,lv_alphabets,lv_numbers,rate,val.
    wa_ccpc4-matnr = wa_ccpc3-matnr.
    wa_ccpc4-from_dt = wa_ccpc3-from_dt.
    wa_ccpc4-cc = wa_ccpc3-cc.
    wa_ccpc4-pc = wa_ccpc3-pc.
    wa_ccpc4-bezei = wa_ccpc3-bezei.

    pack = wa_ccpc3-bezei.
    replace all occurrences of substring '''' in pack with ''.
    cnt = 0.
    count = strlen( pack ).
    if count is not initial.
      do count times.
        result = pack+cnt(1).
        if result ca 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
          concatenate lv_alphabets result into lv_alphabets.
          clear result.
        else.
          concatenate lv_numbers result into lv_numbers.
          clear result.
        endif.
        cnt = cnt + 1.
      enddo.
    endif.
    wa_ccpc4-lv_alphabets = lv_alphabets.
    wa_ccpc4-lv_numbers = lv_numbers.
    collect wa_ccpc4 into it_ccpc4.
    clear wa_ccpc4.
  endloop.



*LOOP AT IT_CCPC4 INTO WA_CCPC4.
*  WRITE : / WA_CCPC4-MATNR,WA_CCPC4-FROM_DT,WA_CCPC4-CC,WA_CCPC4-PC,WA_CCPC4-BEZEI,WA_CCPC4-lv_alphabets,WA_CCPC4-lv_numbers.
*  ENDLOOP.


endform.
*&---------------------------------------------------------------------*
*&      Form  DIV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form div .
  if it_tab3 is not initial.
    select * from stpo into table it_stpo1 for all entries in it_tab3 where idnrk eq it_tab3-matnr.
    if sy-subrc eq 0.
      select * from mast into table it_mast1 for all entries in it_stpo1 where stlnr eq it_stpo1-stlnr and werks eq plant.
    endif.
  endif.

  loop at it_mast1 into wa_mast1.
    read table it_stpo1 into wa_stpo1 with key stlnr = wa_mast1-stlnr.
    if sy-subrc eq 0.
      select single * from mara where matnr eq wa_mast1-matnr and mtart eq 'ZFRT'.
      if sy-subrc eq 0.
        if mara-spart eq '50'.
          wa_div1-matnr = wa_stpo1-idnrk.
          wa_div1-div = 'BC'.
          collect wa_div1 into it_div1.
          clear wa_div1.
        elseif mara-spart eq '60'.
          wa_div1-matnr = wa_stpo1-idnrk.
          wa_div1-div = 'XL'.
          collect wa_div1 into it_div1.
          clear wa_div1.
        endif.
      endif.
    endif.
  endloop.

*   LOOP AT IT_DIV1 INTO WA_DIV1.
*    WRITE : / WA_DIV1-MATNR,WA_DIV1-DIV.
*  ENDLOOP.

endform.
*&---------------------------------------------------------------------*
*&      Form  DIV1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form div1 .
  if it_tab3 is not initial.
    select * from mcha into table it_mcha for all entries in it_tab3 where charg eq it_tab3-charg.
  endif.
  loop at it_mcha into wa_mcha.
    read table it_tab3 into wa_tab3 with key charg = wa_mcha-charg.
    if sy-subrc eq 0.
      select single * from mara where matnr eq wa_mcha-matnr and mtart eq 'ZFRT'.
      if sy-subrc eq 0.
        if mara-spart eq '50'.
          wa_div2-matnr = wa_tab3-matnr.
          wa_div2-div = 'BC'.
          collect wa_div2 into it_div2.
          clear wa_div2.
        elseif mara-spart eq '60'.
          wa_div2-matnr = wa_tab3-matnr.
          wa_div2-div = 'XL'.
          collect wa_div2 into it_div2.
          clear wa_div2.
        endif.
      endif.
    endif.
  endloop.

*  LOOP AT IT_DIV2 INTO WA_DIV2.
*    WRITE : / 'A',WA_DIV2-MATNR,WA_DIV2-DIV.
*  ENDLOOP.

endform.
