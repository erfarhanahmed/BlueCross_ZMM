*&---------------------------------------------------------------------*
*& Report  ZANNUAL_PROD_REVIEW4
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  zannual_prod_review8 no standard page heading line-size 500.

tables : qals,
         qave,
         qamr,
         mapl,
         plmk.


data : it_qals type table of qals,
       wa_qals type qals,
       it_qave type table of qave,
       wa_qave type qave,
       it_qamv type table of qamv,
       wa_qamv type qamv,
       it_qamv1 type table of qamv,
       wa_qamv1 type qamv.


types : begin of itab1,
*  matnr type qals-matnr,
  charg type qals-charg,
  prueflos type qals-prueflos,
  end of itab1.

data : it_tab1 type table of itab1,
       wa_tab1 type itab1.

data : data1(25) type c,
       data2(10) type c,
       data3(25) type c,
       data4(10) type c,
       data5(16) type c,
       data51(16) type c,
       data6(16) type c,
       data7 type p decimals 4,
       data8(10) type c,
       data9 type p decimals 2.

select-options : batch for qals-charg obligatory.
select-options : art for qals-art obligatory.
select-options : s_budat for qave-vdatum obligatory.
parameters : plant like qals-werk obligatory.


select * from qals into table it_qals where charg in batch and werk eq plant and art in art.
if sy-subrc eq 0.
  select * from qave into table it_qave for all entries in it_qals where prueflos eq it_qals-prueflos and vdatum in s_budat.
  if sy-subrc ne 0.
    exit.
  endif.
endif.

sort it_qals by prueflos charg.
delete ADJACENT DUPLICATES FROM it_qals comparing prueflos charg.

loop at it_qals into wa_qals.
  read table it_qave into wa_qave with key prueflos = wa_qals-prueflos.
  if sy-subrc eq 0.
*    WRITE : / WA_QALS-MATNR,WA_QALS-CHARG,wa_qals-prueflos.
*    wa_tab1-matnr = wa_qals-matnr.
    wa_tab1-charg = wa_qals-charg.
    wa_tab1-prueflos = wa_qals-prueflos.
    collect wa_tab1 into it_tab1.
    clear wa_tab1.
  endif.

endloop.

sort it_tab1 by charg prueflos.
*sort it_tab1 by charg.
delete adjacent duplicates from it_tab1 comparing charg.

loop at it_tab1 into wa_tab1.
*  WRITE : / 'a',wa_tab1-charg,wa_tab1-prueflos.
endloop.
select * from qamv into table it_qamv for all entries in it_tab1 where prueflos eq it_tab1-prueflos.
select * from qamv into table it_qamv1 where prueflos eq wa_tab1-prueflos.
write : / 'BATCH     '.

loop at it_qamv1 into wa_qamv1.

  select single * from qamr where prueflos eq wa_qamv1-prueflos and merknr eq wa_qamv1-merknr.

  if sy-subrc eq 0.
    if  qamr-maxwertni ne '*'.
      write : wa_qamv1-kurztext+0(10).

    else.
      write : wa_qamv1-kurztext+0(10).
      write : wa_qamv1-kurztext+0(10).
    endif.
*    select single * from qals where prueflos eq wa_qamv1-prueflos.
    read table it_qals into wa_qals with key prueflos = wa_qamv1-prueflos.
    if sy-subrc eq 0.
      select single * from mapl where matnr eq wa_qals-matnr and plnty eq 'Q'.
      if sy-subrc eq 0.
        select single * from plmk where plnnr eq mapl-plnnr and merknr eq wa_qamv1-merknr.
        if sy-subrc eq 0.


          if plmk-tolunni eq 'X'.

            data1 = plmk-toleranzun.
            data2 = data1.
            if data2 ne 0.
              write : '   NLT_LMT' right-justified.
            endif.
            data1 = plmk-toleranzob.
            data2 = data1.
            if data2 ne 0.
              write : '   NMT_LMT' right-justified.
            endif.

          elseif plmk-plausiobni eq 'X'.

            data1 = plmk-plausiunte.
            data2 = data1.
            if data2 ne 0.
              write : '   NLT_LMT' right-justified.
            endif.

            data1 = plmk-plausioben.
            data2 = data1.
            if data2 ne 0.
              write : '   NMT_LMT' right-justified.
            endif.

          else.

            data1 = plmk-toleranzob.
            data2 = data1.
            if data2 ne 0.
              write : '   NMT_LMT' right-justified.
            endif.
          endif.

*          data1 = plmk-toleranzob.
*          data2 = data1.
*          if data2 ne 0.
*            if plmk-tolunni ne 'X'.
*              write : '   NMT_LMT' right-justified.
*            else.
*              write : '   NLT_LMT' right-justified,'   NMT_LMT' right-justified.
*            endif.
*          else.
*            data1 = plmk-toleranzun.
*            data2 = data1.
*            if data2 ne 0.
*              if plmk-tolunni ne 'X'.
*                write : '   NMT_LMT' right-justified.
*              else.
*                write : '   NLT_LMT' right-justified,'   NMT_LMT' right-justified.
*              endif.
*            endif.
*          endif.
        endif.
      endif.
    endif.


  endif.


*  WA_QAMV-MERKNR.
endloop.
uline.

loop at it_tab1 into wa_tab1.
  write : / wa_tab1-charg.
*  wa_tab1-prueflos.


  loop at it_qamv into wa_qamv where prueflos eq wa_tab1-prueflos.
    select single * from qamr where prueflos eq wa_tab1-prueflos and merknr eq wa_qamv-merknr.
    if sy-subrc eq 0.
*      data1 = qamr-mittelwert.
      if qamr-maxwertni eq '*'.
        data5 = qamr-minwert.
        data51 = qamr-maxwert.
*        write : 'a',data5+13(3).


        if data5+13(3) eq '+01'.
          data1 = qamr-minwert.
          data2 = data1.
          data6 = data2.
          data7 = data6 * 10.
          data8 = data7.
          write : data8 right-justified.
*           WRITE : qamr-maxwert.

**************************minimum val of limit*******************

          if data51+13(3) eq '+01'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 * 10.
            data8 = data7.
            write : data8 right-justified.
          elseif data51+13(3) eq '+02'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 * 100.
            data8 = data7.
            write : data8 right-justified.
          elseif data51+13(3) eq '-01'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 / 10.
            data8 = data7.
            write : data8 right-justified.
          elseif data51+13(3) eq '-02'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 / 100.
            data8 = data7.
            write : data8 right-justified.
          else.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 .
            data8 = data7.
            write : data8 right-justified.
          endif.
******************************mimimumval of limit***************

          read table it_qals into wa_qals with key prueflos = wa_qamv-prueflos.
          if sy-subrc eq 0.
            select single * from mapl where matnr eq wa_qals-matnr and plnty eq 'Q'.
            if sy-subrc eq 0.
              select single * from plmk where plnnr eq mapl-plnnr and merknr eq wa_qamv-merknr.
              if sy-subrc eq 0.


                if plmk-tolunni eq 'X'.
                  data1 = plmk-toleranzun.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzun.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                  data1 = plmk-toleranzob.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzob.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                elseif plmk-plausiobni eq 'X'.
                  data1 = plmk-plausiunte.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-plausiunte.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                  data1 = plmk-plausioben.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-plausioben.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                else.

*                if plmk-tolunni ne 'X'.
                  data1 = plmk-toleranzob.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzob.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                endif.


              endif.
            endif.
          endif.


****************************************limit*******************


        elseif data5+13(3) eq '+02'.
          data1 = qamr-minwert.
          data2 = data1.
          data6 = data2.
          data7 = data6 * 100.
          data8 = data7.
          write : data8 right-justified.

          if data51+13(3) eq '+01'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 * 10.
            data8 = data7.
            write : data8 right-justified.
          elseif data51+13(3) eq '+02'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 * 100.
            data8 = data7.
            write : data8 right-justified.
          elseif data51+13(3) eq '-01'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 / 10.
            data8 = data7.
            write : data8 right-justified.
          elseif data51+13(3) eq '-02'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 / 100.
            data8 = data7.
            write : data8 right-justified.
          else.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 .
            data8 = data7.
            write : data8 right-justified.
          endif.

          read table it_qals into wa_qals with key prueflos = wa_qamv-prueflos.
          if sy-subrc eq 0.
            select single * from mapl where matnr eq wa_qals-matnr and plnty eq 'Q'.
            if sy-subrc eq 0.
              select single * from plmk where plnnr eq mapl-plnnr and merknr eq wa_qamv-merknr.
              if sy-subrc eq 0.


                if plmk-tolunni eq 'X'.
                  data1 = plmk-toleranzun.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzun.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                  data1 = plmk-toleranzob.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzob.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                elseif plmk-plausiobni eq 'X'.
                  data1 = plmk-plausiunte.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-plausiunte.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                  data1 = plmk-plausioben.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-plausioben.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                else.

*                if plmk-tolunni ne 'X'.
                  data1 = plmk-toleranzob.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzob.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                endif.


              endif.
            endif.
          endif.


****************************************limit*******************



        elseif data5+13(3) eq '-01'.
          data1 = qamr-minwert.
          data2 = data1.
          data6 = data2.
          data7 = data6 / 10.
          data8 = data7.
          write : data8 right-justified.
          if data51+13(3) eq '+01'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 * 10.
            data8 = data7.
            write : data8 right-justified.
          elseif data51+13(3) eq '+02'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 * 100.
            data8 = data7.
            write : data8 right-justified.
          elseif data51+13(3) eq '-01'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 / 10.
            data8 = data7.
            write : data8 right-justified.
          elseif data51+13(3) eq '-02'.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 / 100.
            data8 = data7.
            write : data8 right-justified.
          else.
            data1 = qamr-maxwert.
            data2 = data1.
            data6 = data2.
            data7 = data6 .
            data8 = data7.
            write : data8 right-justified.
          endif.

          read table it_qals into wa_qals with key prueflos = wa_qamv-prueflos.
          if sy-subrc eq 0.
            select single * from mapl where matnr eq wa_qals-matnr and plnty eq 'Q'.
            if sy-subrc eq 0.
              select single * from plmk where plnnr eq mapl-plnnr and merknr eq wa_qamv-merknr.
              if sy-subrc eq 0.


                if plmk-tolunni eq 'X'.
                  data1 = plmk-toleranzun.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzun.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                  data1 = plmk-toleranzob.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzob.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                elseif plmk-plausiobni eq 'X'.
                  data1 = plmk-plausiunte.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-plausiunte.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                  data1 = plmk-plausioben.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-plausioben.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                else.

*                if plmk-tolunni ne 'X'.
                  data1 = plmk-toleranzob.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzob.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                endif.


              endif.
            endif.
          endif.


****************************************limit*******************



        else.
          data1 = qamr-minwert.
          data2 = data1.
          write : data2 right-justified.
*           WRITE : qamr-maxwert.
          data3 = qamr-maxwert.
          data4 = data3.
          write : data4 right-justified.
*           WRITE : qamr-minwert.

          read table it_qals into wa_qals with key prueflos = wa_qamv-prueflos.
          if sy-subrc eq 0.
            select single * from mapl where matnr eq wa_qals-matnr and plnty eq 'Q'.
            if sy-subrc eq 0.
              select single * from plmk where plnnr eq mapl-plnnr and merknr eq wa_qamv-merknr.
              if sy-subrc eq 0.


                if plmk-tolunni eq 'X'.
                  data1 = plmk-toleranzun.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzun.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                  data1 = plmk-toleranzob.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzob.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                elseif plmk-plausiobni eq 'X'.
                  data1 = plmk-plausiunte.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-plausiunte.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                  data1 = plmk-plausioben.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-plausioben.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                else.

*                if plmk-tolunni ne 'X'.
                  data1 = plmk-toleranzob.
                  data2 = data1.
                  if data2 ne 0.
                    data5 = plmk-toleranzob.
                    if data5+13(3) eq '+01'.
                      data9 = data2 * 10.
                    elseif data5+13(3) eq '+02'.
                      data9 = data2 * 100.
                    elseif data5+13(3) eq '-01'.
                      data9 = data2 / 10.
                    else.
                      data9 = data2.
                    endif.
                    data8 = data9.
                    write : data8 right-justified.
                  endif.

                endif.


              endif.
            endif.
          endif.


****************************************limit*******************



        endif.
      else.
        data1 = qamr-original_input.
        data2 = data1.
        write : data2 right-justified.

        read table it_qals into wa_qals with key prueflos = wa_qamv-prueflos.
        if sy-subrc eq 0.
          select single * from mapl where matnr eq wa_qals-matnr and plnty eq 'Q'.
          if sy-subrc eq 0.
            select single * from plmk where plnnr eq mapl-plnnr and merknr eq wa_qamv-merknr.
            if sy-subrc eq 0.


              if plmk-tolunni eq 'X'.
                data1 = plmk-toleranzun.
                data2 = data1.
                if data2 ne 0.
                  data5 = plmk-toleranzun.
                  if data5+13(3) eq '+01'.
                    data9 = data2 * 10.
                  elseif data5+13(3) eq '+02'.
                    data9 = data2 * 100.
                  elseif data5+13(3) eq '-01'.
                    data9 = data2 / 10.
                  else.
                    data9 = data2.
                  endif.
                  data8 = data9.
                  write : data8 right-justified.
                endif.

                data1 = plmk-toleranzob.
                data2 = data1.
                if data2 ne 0.
                  data5 = plmk-toleranzob.
                  if data5+13(3) eq '+01'.
                    data9 = data2 * 10.
                  elseif data5+13(3) eq '+02'.
                    data9 = data2 * 100.
                  elseif data5+13(3) eq '-01'.
                    data9 = data2 / 10.
                  else.
                    data9 = data2.
                  endif.
                  data8 = data9.
                  write : data8 right-justified.
                endif.

              elseif plmk-plausiobni eq 'X'.
                data1 = plmk-plausiunte.
                data2 = data1.
                if data2 ne 0.
                  data5 = plmk-plausiunte.
                  if data5+13(3) eq '+01'.
                    data9 = data2 * 10.
                  elseif data5+13(3) eq '+02'.
                    data9 = data2 * 100.
                  elseif data5+13(3) eq '-01'.
                    data9 = data2 / 10.
                  else.
                    data9 = data2.
                  endif.
                  data8 = data9.
                  write : data8 right-justified.
                endif.

                data1 = plmk-plausioben.
                data2 = data1.
                if data2 ne 0.
                  data5 = plmk-plausioben.
                  if data5+13(3) eq '+01'.
                    data9 = data2 * 10.
                  elseif data5+13(3) eq '+02'.
                    data9 = data2 * 100.
                  elseif data5+13(3) eq '-01'.
                    data9 = data2 / 10.
                  else.
                    data9 = data2.
                  endif.
                  data8 = data9.
                  write : data8 right-justified.
                endif.

              else.

*                if plmk-tolunni ne 'X'.
                data1 = plmk-toleranzob.
                data2 = data1.
                if data2 ne 0.
                  data5 = plmk-toleranzob.
                  if data5+13(3) eq '+01'.
                    data9 = data2 * 10.
                  elseif data5+13(3) eq '+02'.
                    data9 = data2 * 100.
                  elseif data5+13(3) eq '-01'.
                    data9 = data2 / 10.
                  else.
                    data9 = data2.
                  endif.
                  data8 = data9.
                  write : data8 right-justified.
                endif.

              endif.


            endif.
          endif.
        endif.


****************************************limit*******************



      endif.
*        write : qamr-maxwertni.
    endif.
  endloop.
endloop.
