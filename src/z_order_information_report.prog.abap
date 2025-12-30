REPORT Z_ORDER_INFORMATION_REPORT no standard page heading line-SIZE 181.
*line-size 160 line-count 58.
*--------------------------------------------------------------*
*--This report gives all the information about the order.
*--This report has been demanded by Mr. Dhigolkar.The Program
*--is written by Pramod Kumar.Started on 18.09.2001

*--Modification history----------------------------------------*

*--1.Modified on 21.08.2001.Added two new col %varience,var amt

*--------------------------------------------------------------*

*--Tables Used ------------------------------------------------*

Tables : AUFK, "Order master data
         AFPO, "Order item
         AFKO, "order header data
         MAKT, "Material Descriptions
         MBEW,"Material Valuation
         CAUFVD.

*--Data Declaration--------------------------------------------*

Data : Begin of t_order occurs 0,
       matnr like afpo-matnr, "material no
       maktx like makt-maktx, "material description
       aufnr like afpo-aufnr, "order no
       charg like afpo-charg, "Batch Number
       psmng like afpo-psmng, "order item qty
       meins like afpo-meins, "order unit measure
       wemng like afpo-wemng, "delivered qty
       iamng like afpo-iamng, "Exp surplus/deficit for goods receipt
       pervar like caufvd-aproz, "% varience
       persign type c,"for per
       stprs like mbew-stprs, "vatience price
       end of t_order.

*--Selection Screen-----------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
select-options : s_ltrmi for afpo-ltrmi.
select-options : s_dauat for afpo-dauat.
select-options : s_lgort for afpo-lgort.
parameters : P_PWERK like afpo-pwerk obligatory.
SELECTION-SCREEN END OF BLOCK b1.


*--Top of Page ---------------------------------------------------*

skip 2.
write :/70 'Blue Cross Laboratories Ltd.'.
write :/130 'Page No :',
        140 sy-pagno.
skip .
write :/70 'Order Information Report'.
write :/70 '------------------------'.
skip .
write :/70 'From Date :',
        83 s_ltrmi-low,
        95 'To',
        105 s_ltrmi-high.
skip .
uline.
write :/2 'Material',
       12 'Material Description',
       54 'Order No',
       65 'Batch No',
       77 'Order Qty',
      100 'Deliv Qty',
      118 'Expec Yield Var',
      135 '% Varence',
      148 'Variance Amt',
      162 'Technically-complete'.


uline.

*--start of selection-----------------------------------*

start-of-selection.
  perform t_order.
  perform write_t_order.
  skip.
  write :/60 '*************** End Of Report ***************'.

*&---------------------------------------------------------------------*
*&      Form  T_ORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form t_order.
  select * from afpo where ltrmi in s_ltrmi
                     and dauat in s_dauat
                     and lgort in s_lgort
                     and pwerk = p_pwerk.

    if sy-subrc = 0.
      t_order-matnr = afpo-matnr. "material no
      t_order-aufnr = afpo-aufnr. "order no
      t_order-charg = afpo-charg. "Batch Number
      t_order-psmng = afpo-psmng. "order item qty
      t_order-meins = afpo-meins. "order unit measure
      t_order-wemng = afpo-wemng. "delivered qty
      t_order-iamng = afpo-iamng. "Exp surplus/deficit for goods receipt
      t_order-pervar = ( afpo-iamng * 100 ) / ( afpo-psmng ).
      t_order-persign = '%'.
      select single * from makt where matnr = afpo-matnr.
      t_order-maktx = makt-maktx. "material description
      select single * from mbew where matnr = afpo-matnr.
      if sy-subrc = 0.
        t_order-stprs = ( afpo-iamng ) * ( mbew-stprs ).
      endif.
      append t_order.
      clear t_order.
    endif.

  endselect.
endform.                    " T_ORDER

*&---------------------------------------------------------------------*
*&      Form  WRITE_T_ORDER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form write_t_order.
  sort t_order by aufnr.
  loop at t_order.
    write :/2 t_order-matnr,
           12 t_order-maktx,
           54 t_order-aufnr,
           65 t_order-charg,
           77 t_order-psmng,
           96 t_order-meins,
          100 t_order-wemng,
          116 t_order-iamng,
          136 t_order-pervar,
          142 t_order-persign,
          144 t_order-stprs.
    select SINGLE * FROM aufk WHERE aufnr eq t_order-aufnr AND idat2 ne 0.
      if sy-subrc eq 0.
        WRITE : 165 'Yes'.
      ENDIF.
  endloop.
  uline.
endform.                    " WRITE_T_ORDER
