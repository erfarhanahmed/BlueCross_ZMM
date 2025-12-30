REPORT zbcllmm_as2_val NO STANDARD PAGE HEADING LINE-COUNT 60 LINE-SIZE
145.
* This report gives Valuation of stock of  RM/PM and *
* it also compare it with the Market rate prevailing *
* and valuates the Stock accordingly                 *
* Demanded by MMS started on 19-8-2002               *
* Developed by Anjali                                *
*--Table Declerations -----------------------------------------------*

TABLES : s031,
         makt,
         mara,
         marc,
         t001w,
         t134t,
         mbew.
DATA : BEGIN OF t_details OCCURS 0,
       spmon LIKE s031-spmon,
       werks LIKE s031-werks,
       matnr LIKE s031-matnr,
       lgort LIKE s031-lgort,
       mzubb LIKE s031-mzubb,
       wzubb LIKE s031-wzubb,
       magbb LIKE s031-magbb,
       wagbb LIKE s031-wagbb,
       basme LIKE s031-basme,
      END OF t_details.
DATA : BEGIN OF t_summdet OCCURS 0,
       werks LIKE s031-werks,
       matnr LIKE s031-matnr,
*       lgort like s031-lgort,
       mzubb LIKE s031-mzubb,
       wzubb LIKE s031-wzubb,
       magbb LIKE s031-magbb,
       wagbb LIKE s031-wagbb,
       basme LIKE s031-basme,
       END OF t_summdet.
DATA : w_stock LIKE s031-mzubb,
       w_value(16) TYPE p,
       w_tvalue(16) type p,
*        like s031-wzubb,
       w_rate(8) TYPE p DECIMALS 2,
       w_rateas2 LIKE mbew-bwprh,
       w_as2val(16) TYPE p,
       w_tas2val(16) type p,
       w_tas2val1(16) type p,
       w_as2val1(16) TYPE p.
** Selection screen --------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
PARAMETERS : s_werks LIKE s031-werks OBLIGATORY.
PARAMETERS : s_mtart LIKE mara-mtart OBLIGATORY.
PARAMETERS : s_spmon LIKE s031-spmon OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.


*--Start-of-selection ------------------------------------------------*
PERFORM collect_data.
PERFORM summ_data.
PERFORM print_details.

TOP-OF-PAGE.
  SELECT SINGLE * FROM t001w WHERE werks = s_werks.
  SELECT SINGLE * FROM t134t WHERE mtart = s_mtart AND spras = 'EN'.
  WRITE :/1 t001w-name1.
  WRITE :/1 t134t-mtbez,
          30 'As on :',
          40 s_spmon.
  ULINE.
  WRITE :/1  '   Material  ',
          44 'S.Loc',
          51 'Stock Qty',
          68 'UOM',
          72 'Valuation as per MAP',
          99 'Valuation as per Mkt Rt',
          126 'Valuation as '.
  WRITE :/74 ' Value',
          92 ' Rate',
          102 ' Rate',
          112 ' Value',
          126 ' As per AS2'.

  ULINE.

END-OF-PAGE.

*---------------------------------------------------------------------*
*       FORM collect_data                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM collect_data.

  SELECT * FROM s031 WHERE werks = s_werks AND spmon LE s_spmon.
    SELECT SINGLE * FROM mara WHERE matnr = s031-matnr.
    IF mara-mtart = s_mtart.
      MOVE-CORRESPONDING s031 TO t_details.
      APPEND t_details.
    ENDIF.
    CLEAR t_details.
  ENDSELECT.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM summ_data                                                *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM summ_data.
  SORT t_details BY matnr werks.
  LOOP AT t_details.
    t_summdet-matnr = t_details-matnr.
    t_summdet-werks = t_details-werks.
*    t_summdet-lgort  = t_details-lgort.
    t_summdet-mzubb = t_details-mzubb.
    t_summdet-wzubb = t_details-wzubb.
    t_summdet-magbb = t_details-magbb.
    t_summdet-wagbb = t_details-wagbb.
    t_summdet-basme = t_details-basme.
    COLLECT t_summdet.
    CLEAR t_summdet.
  ENDLOOP.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM print_details                                            *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM print_details.
  LOOP AT t_summdet.
    w_stock = t_summdet-mzubb - t_summdet-magbb.
    w_value = t_summdet-wzubb - t_summdet-wagbb.
    if w_stock = 0.
    else.
    w_rate = w_value / w_stock.
    SELECT SINGLE * FROM mbew WHERE matnr = t_summdet-matnr AND bwkey =
    t_summdet-werks.
    IF sy-subrc = 4.
      w_rateas2 = w_rate.
      w_as2val = w_value.
    ELSE.
      w_rateas2 = mbew-bwprh.
      IF w_rateas2 = 0.
        w_rateas2 = w_rate.
        w_as2val = w_value.
      ELSE.
        w_as2val = w_rateas2 * w_stock.
      ENDIF.
    ENDIF.
    IF w_rateas2 LT w_rate.
      w_as2val1 = w_rateas2 * w_stock.
    ELSE.
      w_as2val1 = w_value.
    ENDIF.
    w_tvalue = w_tvalue + w_value.
    w_tas2val = w_tas2val + w_as2val.
    w_tas2val1 = w_tas2val1 + w_as2val1.
SELECT SINGLE * FROM makt WHERE matnr = t_summdet-matnr.
select single * from marc where matnr = t_summdet-matnr and werks =
t_summdet-werks.

    WRITE :/1  t_summdet-matnr,
            8  makt-maktx,
            44 marc-lgpro,
            51(16) w_stock,
            68(3) t_summdet-basme,
            70(16) w_value,
            89(11) w_rate,
            103(9) w_rateas2,
            111(16) w_as2val,
            128(16) w_as2val1.
   endif.
  ENDLOOP.
  uline.
  write :/1 'Total',
          70(16) w_tvalue,
          111(16) w_tas2val,
          128(16) w_tas2val1.
  uline.
ENDFORM.
