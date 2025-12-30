report z_goodsissue_labels.
*Changes done by anjali on 19.3.2002 request by prod (SNJ) for
*introduction of Indl. Sector *
* CHANGES BY JYOTSNA - 6.10.2008
*table declerations-------------------------

tables:
  s026,
  mkpf,
  mseg,
  lfa1,
  mcha,
  makt,
  qals,
  qamb,
  s021,
  afpo,
  afko,
  aufm,
  aufk,
  mast,
  stpo,
  mara,
  resb,
  zgil,  "INSP SHOULD NOT APPEAR IN ZGIL LABEL,
  zpo_matnr,  "FOR PO DESCRIPTION
  ekbe,
  ekko,
  ekpo,
  ekpa.
*data declerations---------------------------

data : begin of t_header occurs 0,
         aufnr  like afpo-aufnr,   "order no
         charg  like afpo-charg,   "batch no material
         matnr  like mast-matnr,   "Material no
         stlnr  like mast-stlnr,   "bom no
         maktxm like makt-maktx,   "Material Descr
         andat  like mast-andat,   "date of order
       end of t_header.
*DATA : BEGIN OF T_DETAILS OCCURS 0,
types: begin of t_details,
         stlnr      like mast-stlnr,   "bom no
*       idnrk  LIKE stpo-idnrk,   "Component no
         posnr      like resb-posnr,    " item no
         rspos      type resb-rspos,
         aufnr      like resb-aufnr,    "orderno
         matnr      like resb-matnr,   "component no
*         MAKTXC   LIKE MAKT-MAKTX,   "description
         maktxc(81) type c,   " Long description

*         MENGE      LIKE RESB-BDMNG,   "qty
         menge      type mseg-menge,
         meins      like resb-meins,   "units
         charg      like resb-charg,   "comp batc no
         prueflos   like qals-prueflos, "inspection lot
         normt      like mara-normt,     " industrial standard
         mtart      type mara-mtart,
         maktx2     type makt-maktx,
       end of t_details.

data: t_details type table of t_details,
      w_details type t_details.

types: begin of itab1,
         maktxh        type makt-maktx,
         batch         type mchb-charg,
         matnr         type afpo-matnr,
         charg         type afpo-charg,
         maktx(100)    type c,
         prueflos      type qals-prueflos,
         menge         type mseg-menge,
         meins         type afpo-meins,
         format1(50)   type c,
         mattxt1(100)  type c,
         issuetxt(100) type c,
         count         type bseg-buzei,
         posnr         type resb-posnr,
         rspos         type resb-rspos,
       end of itab1.
data: it_tab1 type table of itab1,
      wa_tab1 type itab1.
data: qty1     type mseg-menge,
      qty2(13) type c.

data: werks type afpo-dwerk.
data : count type i .
data : pg_count type i .
data : w_name(100) type c.
data: mtart       type mara-mtart,
      format1(50) type c,
      mattxt1(50) type c.
count = 0 .
data : it_resb type table of resb,
       wa_resb type resb,
       it_qals type table of qals,
       wa_qals type qals.

data : maktx1(40) type c,
       maktx2(40) type c,
       maktx(81)  type c.
data: cnt1 type i.
data: n  type i,
      n1 type i.
data: qty type mseg-zeile.
data: label type i.
data: lbl(10) type c.
data: formname(30) type c.
data:  fname type     rs38l_fnam.
data : control  type ssfctrlop.
data : w_ssfcompop type ssfcompop.

data: p_budat type sy-datum. "12.8.22 as per deviation data should be today's date
*selection screen-------------------------------------

selection-screen begin of block input with frame title text-001 .
parameters :     p_aufnr like afpo-aufnr obligatory.
*PARAMETERS :     P_BUDAT LIKE MKPF-BUDAT OBLIGATORY.
parameters : r1 radiobutton group r1,
             r2 radiobutton group r1 default 'X'.
*             R3 RADIOBUTTON GROUP R1.
selection-screen end of block input.

* start of selection---------------------------------
start-of-selection.
  p_budat = sy-datum.
  clear t_header.
  refresh t_header.
  perform t_header.

  select * from resb into table it_resb for all entries in t_header where aufnr = t_header-aufnr.
*  select * from qals into table it_qals for all entries in it_resb where matnr = it_resb-matnr
*                            and charg = it_resb-charg and art = '09' and
*                            werk = it_resb-werks.
  select * from qals into table it_qals for all entries in it_resb where matnr = it_resb-matnr
                          and charg = it_resb-charg and werk = it_resb-werks
    and mblnr ne space "added on 4.6.2019
    and stat34 eq 'X'. "added on 29.12.2020
*      and art = '09' and
SELECT * from zinsp INTO TABLE @DATA(it_zinsp)  for all entries in @it_resb where matnr = @it_resb-matnr
                          and charg = @it_resb-charg and werks = @it_resb-werks.   "added by madhuri

  loop at it_qals into wa_qals.  "changs dor insp -080000067163 on 6.9.21
    select single * from zgil where prueflos eq wa_qals-prueflos.
    if sy-subrc eq 0.
      delete it_qals where prueflos eq zgil-prueflos.
    endif.
  endloop.

*     sort it_qals by prueflos DESCENDING.
  sort it_qals by enstehdat descending.
  perform t_details.
  clear : werks.
  select single * from afpo where aufnr eq p_aufnr.
  if sy-subrc eq 0.
    werks = afpo-dwerk.
  endif.

  sort t_details by posnr.
  clear : count.
  count = 1.
  loop at t_details into w_details where aufnr = t_header-aufnr.
    clear : mtart,format1,mattxt1.
    select single * from mara where matnr eq w_details-matnr.
    if sy-subrc eq 0.
      mtart = mara-mtart.
    endif.
    if mtart eq 'ZROH' or mtart eq 'ZVRP'.

      clear : w_name.
      if w_details-normt ne space.
        concatenate w_details-maktxc w_details-normt into w_name separated by '-'.
      else.
        w_name = w_details-maktxc.
      endif.
      condense w_name.
      wa_tab1-maktx = w_name.


      if werks eq '1000' and mtart eq 'ZROH'.
        format1 = 'SOP/QAD/060-F2'.
        mattxt1 = 'DISPENSED RAW MATERIAL'.
      elseif werks eq '1000' and mtart eq 'ZVRP'.
        format1 = 'SOP/QAD/060-F4'.
        mattxt1 = 'DISPENSED PACKAGING MATERIAL'.
      elseif werks eq '1001' and mtart eq 'ZROH'.
        format1 = 'ST/GM/008-F3'.
        mattxt1 = 'DISPENSED RAW MATERIAL'.
      elseif werks eq '1001' and mtart eq 'ZVRP'.
*        format1 = 'ST/GM/008-F3'.
        mattxt1 = 'DISPENSED PACKAGING MATERIAL'.
      endif.
      wa_tab1-format1 = format1.

      wa_tab1-mattxt1 = mattxt1.
      select single * from afpo where aufnr eq p_aufnr.
      if sy-subrc eq 0.
        wa_tab1-batch = afpo-charg.
        select single * from makt where matnr eq afpo-matnr and spras eq 'EN'.
        if sy-subrc eq 0.
          wa_tab1-maktxh = makt-maktx.
        endif.
      endif.
      wa_tab1-matnr = w_details-matnr.
      wa_tab1-posnr = w_details-posnr.
      wa_tab1-rspos = w_details-rspos.
      wa_tab1-charg = w_details-charg.
      wa_tab1-prueflos = w_details-prueflos.
      wa_tab1-menge = w_details-menge.
      wa_tab1-meins = w_details-meins.

      if mtart eq 'ZROH'.
        wa_tab1-issuetxt = 'Stores/Production'.
      else.
        wa_tab1-issuetxt = space.
      endif.
      wa_tab1-count = count.
      collect wa_tab1 into it_tab1.
      clear wa_tab1.
      count = count + 1.
    endif.
  endloop.

sort it_tab1 by posnr rspos.
********************smartform***********************
  clear : cnt1.
  loop at t_details into w_details.
    cnt1 = cnt1 + 1.
  endloop.

  if r1 eq 'X'.
    n = cnt1 div 8.
    n1 =  cnt1 mod 8.
    if n1 gt 0.
      n = n + 1.
    endif.
  elseif r2 eq 'X'.
    n = cnt1 div 12.
    n1 =  cnt1 mod 12 .
    if n1 gt 0.
      n = n + 1.
    endif.
  endif.
  if r1 eq 'X'.
    formname = 'ZGIL3'.
  elseif r2 eq 'X'.
*    formname = 'ZGIL4'.
    formname = 'ZGIL5'.
  endif.
  call function 'SSF_FUNCTION_MODULE_NAME'
    exporting
*     FORMNAME           = 'ZREJ_LBL'
      formname           = formname
*     VARIANT            = ‘ ‘
*     DIRECT_CALL        = ‘ ‘
    importing
      fm_name            = fname
    exceptions
      no_form            = 1
      no_function_module = 2
      others             = 3.
  control-no_open   = 'X'.
  control-no_close  = 'X'.

  call function 'SSF_OPEN'
    exporting
      control_parameters = control.

  clear : cnt1.
  lbl = 1.

  do  n times.
    if it_tab1 is not initial.
      call function fname
        exporting
          control_parameters = control
          user_settings      = 'X'
          output_options     = w_ssfcompop
          lbl                = label
          p_mittel           = qty
          n                  = n
        tables
          it_tab1            = it_tab1
*    EXCEPTIONS
*         FORMATTING_ERROR   = 1
*         INTERNAL_ERROR     = 2
*         SEND_ERROR         = 3
*         USER_CANCELED      = 4
*         OTHERS             = 5
        .
*      enddo .
      if r1 eq 'X'.
        qty = qty + 8.
      elseif r2 eq 'X'.
        qty = qty + 12.
      endif.
    endif.
  enddo.
  lbl = lbl + lbl.
  qty = 0.
*  ENDLOOP.
  clear : t_details,w_details.
  clear : qty,cnt1,n1,n.

*  endloop.

  call function 'SSF_CLOSE'.


*&---------------------------------------------------------------------*
*&      Form  T_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form t_header.
  select * from afpo where aufnr = p_aufnr.
    move-corresponding afpo to t_header.
    select single * from aufm where aufnr = afpo-aufnr.
    select single * from mkpf where mblnr = aufm-mblnr.
    t_header-andat = p_budat.
    select single * from mast where matnr = afpo-matnr and stlan = '1'.
    t_header-stlnr = mast-stlnr.

    select single * from makt where matnr = mast-matnr.
    t_header-maktxm = makt-maktx.
    append t_header.
  endselect.
endform.                    " T_HEADER

*&---------------------------------------------------------------------*
*&      Form  T_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form t_details.
  loop at t_header.
    loop at it_resb into wa_resb where aufnr = t_header-aufnr.
      if wa_resb-bdmng ne 0 and wa_resb-charg ne 'W' and wa_resb-charg ne ' '.
*    select * from resb where aufnr = t_header-aufnr.
*        if resb-bdmng ne 0 and resb-charg ne 'W' and resb-charg ne ' '.
        w_details-posnr = wa_resb-posnr.
        w_details-rspos = wa_resb-rspos.
        w_details-aufnr = wa_resb-aufnr.
        w_details-menge = wa_resb-bdmng.
*        condense w_details-menge.
        w_details-meins = wa_resb-meins.
        w_details-charg = wa_resb-charg.
        w_details-matnr = wa_resb-matnr.
*        SELECT SINGLE * FROM MAKT WHERE MATNR = WA_RESB-MATNR.
*        T_DETAILS-MAKTXC = MAKT-MAKTX.

        clear : maktx,maktx1,maktx2.
        select single * from makt where spras eq 'EN' and matnr eq wa_resb-matnr.
        if sy-subrc eq 0.
          maktx1 = makt-maktx.
        endif.
        select single * from makt where spras eq 'Z1' and matnr eq wa_resb-matnr.
        if sy-subrc eq 0.
          maktx2 = makt-maktx.
        endif.
        concatenate maktx1 maktx2 into maktx separated by space.
        w_details-maktxc = maktx.
        w_details-maktx2 = maktx2.

        select single * from mara where matnr = wa_resb-matnr.
        w_details-normt = mara-normt.
        w_details-mtart = mara-mtart.
*******************  ADDED FOR PO TEXT ON 4.1.21*********************
*        SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_RESB-MATNR.
*        IF SY-SUBRC EQ 0.
*          SELECT SINGLE * FROM EKBE WHERE MATNR EQ WA_RESB-MATNR AND CHARG EQ WA_RESB-CHARG AND WERKS EQ WA_RESB-WERKS.
*          IF SY-SUBRC EQ 0.
*            SELECT SINGLE * FROM EKKO WHERE EBELN EQ EKBE-EBELN.
*            IF SY-SUBRC EQ 0.
*              IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*                SELECT SINGLE * FROM EKPO WHERE EBELN EQ EKBE-EBELN AND EBELP EQ EKBE-EBELP.
*                IF SY-SUBRC EQ 0.
*                  T_DETAILS-MAKTXC = EKPO-TXZ01.
*                  T_DETAILS-NORMT = SPACE.
*                  T_DETAILS-MAKTX2 = SPACE.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.

        select single * from zpo_matnr where matnr eq wa_resb-matnr.
        if sy-subrc eq 0.
          select single * from ekbe where matnr eq wa_resb-matnr and charg eq wa_resb-charg and werks eq wa_resb-werks.
          if sy-subrc eq 0.
            select single * from ekko where ebeln eq ekbe-ebeln.
            if sy-subrc eq 0.
              select single * from ekpa where ebeln eq ekbe-ebeln and parvw eq 'HR'.
              if sy-subrc eq 0.
                select single * from zpo_matnr where matnr eq wa_resb-matnr and lifnr eq ekpa-lifn2.
                if sy-subrc eq 0.
                  if ekko-aedat ge zpo_matnr-effectdt.
*                SELECT SINGLE * FROM EKPO WHERE EBELN EQ EKBE-EBELN AND EBELP EQ EKBE-EBELP.
*                IF SY-SUBRC EQ 0.
                    w_details-maktxc = zpo_matnr-maktx.
                    w_details-normt = space.
                    w_details-maktx2 = space.
                  endif.
                endif.
              endif.
            endif.
          endif.
        endif.



        if wa_resb-postp = 'L'.
* to pick up the retesting lot no.
*            select single * from qals where matnr = resb-matnr
*                             and charg = resb-charg and art = '09' and
*                             werk = resb-werks .
*            read table it_qals into wa_qals with key matnr = wa_resb-matnr charg = wa_resb-charg art = '09' werk = wa_resb-werks .
*            if sy-subrc = 0.
*              t_details-prueflos = wa_qals-prueflos.
*            else.
*              select single * from qals where matnr = wa_resb-matnr
*                               and charg = wa_resb-charg and art = '08' and
*                               werk = wa_resb-werks.
*              if sy-subrc = 0.
*                t_details-prueflos = qals-prueflos.
*              else.
*                select single * from qals where matnr = wa_resb-matnr and werk = wa_resb-werks  and charg = wa_resb-charg.
*                if sy-subrc = 0.
*                  t_details-prueflos = qals-prueflos.
*                else.
*                  t_details-prueflos = wa_resb-charg.
*                endif.
*              endif.
*            endif.
* read table it_qals into wa_qals with key matnr = wa_resb-matnr charg = wa_resb-charg  werk = wa_resb-werks.  "commeneted & change for Goa- JYOTSNA 15.7.2015
          if wa_resb-werks eq '1001'.
            read table it_qals into wa_qals with key matnr = wa_resb-matnr charg = wa_resb-charg  werk = wa_resb-werks lagortchrg = wa_resb-lgort.
*            art = '09'
            if sy-subrc = 0.
              w_details-prueflos = wa_qals-prueflos.
            else.
              w_details-prueflos = '0000000000'.

              IF  w_details-prueflos is INITIAL.    "added by madhuri
     REad TABLE it_zinsp INTO DATA(wa_zinsp) with key  matnr = wa_resb-matnr charg = wa_resb-charg  werks = wa_resb-werks lgort = wa_resb-lgort.
     IF  sy-subrc = 0.
      w_details-prueflos = wa_zinsp-PRUEFLOS.
     ENDIF.
     endif.
            endif.
          else.
            read table it_qals into wa_qals with key matnr = wa_resb-matnr charg = wa_resb-charg  werk = wa_resb-werks.
*            art = '09'
            if sy-subrc = 0.
              w_details-prueflos = wa_qals-prueflos.
            else.
              w_details-prueflos = '0000000000'.

              IF  w_details-prueflos is INITIAL.    "added by madhuri
     REad TABLE it_zinsp INTO wa_zinsp with key  matnr = wa_resb-matnr charg = wa_resb-charg  werks = wa_resb-werks.
     IF  sy-subrc = 0.
      w_details-prueflos = wa_zinsp-PRUEFLOS.
     ENDIF.
      ENDIF.

            endif.
          endif.
        endif.

*          if t_details-matnr = 100064.
*            t_details-prueflos = 010000041455.
*          endif.

*        append w_details.
        collect w_details into t_details.
        clear w_details.
        clear : wa_qals,wa_resb.
      endif.
*        ENDIF.
*    endselect.
    endloop.
  endloop.
endform.                    " T_DETAILS
