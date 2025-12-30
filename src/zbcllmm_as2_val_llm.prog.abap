REPORT zbcllmm_as2_val_llm NO STANDARD PAGE HEADING LINE-COUNT 60
LINE-SIZE
140.
* This report gives Valuation of stock of  RM/PM and *
* it also compare it with the Market rate prevailing *
* and valuates the Stock accordingly (Vendor)        *
* Demanded by MMS started on 23-8-2002               *
* Developed by Anjali                                *
*--Table Declerations -----------------------------------------------*

TABLES : makt,
         mara,
         lfa1,
         mslb,
         t134t,
         mbew.
DATA : BEGIN OF t_details OCCURS 0,
       matnr LIKE mslb-matnr,
       werks LIKE mslb-werks,
       lbins LIKE mslb-lbins,
       lblab LIKE mslb-lblab,
       lbein LIKE mslb-lbein,
       lifnr LIKE mslb-lifnr,
      END OF t_details.
DATA : w_stock LIKE mslb-lblab,
       w_rate(9) TYPE p DECIMALS 2,
       w_value(16) TYPE p,
       w_rateas2(9) TYPE p DECIMALS 2,
       w_as2val1(16) TYPE p,
       w_as2val(16) TYPE p,
       w_tas2val(16) TYPE p,
       w_tas2val1(16) TYPE p,
       w_tvalue(16) TYPE p,
       w_gas2val(16) TYPE p,
       w_gas2val1(16) TYPE p,
       w_gvalue(16) TYPE p.
** Selection screen --------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECT-OPTIONS s_lifnr FOR lfa1-lifnr.
SELECT-OPTIONS s_matnr FOR mara-matnr.
PARAMETERS : s_mtart LIKE mara-mtart OBLIGATORY.
SELECT-OPTIONS s_werks FOR mslb-werks.
PARAMETERS : s_date LIKE lfa1-erdat  OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.


*--Start-of-selection ------------------------------------------------*
PERFORM collect_data.
PERFORM print_details.

TOP-OF-PAGE.
  SELECT SINGLE * FROM t134t WHERE mtart = s_mtart AND spras = 'EN'.
  WRITE :/1 t134t-mtbez,
          30 'Stock Valuation of LLM As on :',
          67 s_date.
  ULINE.
  WRITE :/1  '   Material  ',
          44 'Stock Qty',
          61 'UOM',
          65 'Valuation as per MAP',
          92 'Valuation as per Mkt Rt',
          119 'Valuation as '.
  WRITE :/67 ' Value',
          85 ' Rate',
          95 ' Rate',
          105 ' Value',
          119 '  As per AS2'.

  ULINE.


END-OF-PAGE.

*---------------------------------------------------------------------*
*       FORM collect_data                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM collect_data.

  SELECT * FROM mslb WHERE werks IN s_werks AND lifnr IN s_lifnr AND
matnr IN s_matnr.
    SELECT SINGLE * FROM mara WHERE matnr = mslb-matnr.
    IF mara-mtart = s_mtart.
      MOVE-CORRESPONDING mslb TO t_details.
      COLLECT  t_details.
    ENDIF.
    CLEAR t_details.
  ENDSELECT.
ENDFORM.


*---------------------------------------------------------------------*
*       FORM print_details                                            *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM print_details.
  SORT t_details BY lifnr.
  LOOP AT t_details.
    ON CHANGE OF t_details-lifnr.
      PERFORM total_details.
      SELECT SINGLE * FROM lfa1 WHERE lifnr = t_details-lifnr.
      WRITE :/1 t_details-lifnr,
              20 lfa1-name1.
      ULINE.
    ENDON.
    w_stock = t_details-lbins + t_details-lblab + t_details-lbein.
    IF w_stock = 0.
    ELSE.
      SELECT SINGLE * FROM makt WHERE matnr = t_details-matnr.
    SELECT SINGLE * FROM mbew WHERE matnr = t_details-matnr AND bwkey =
      t_details-werks.
      SELECT SINGLE * FROM mara WHERE matnr = t_details-matnr.
      w_rate = mbew-salk3 / mbew-lbkum.
      w_value = w_rate * w_stock.
      w_rateas2 = mbew-bwprh.
      IF w_rateas2 = 0.
        w_rateas2 = w_rate.
        w_as2val = w_value.
      ELSE.
        w_as2val = w_rateas2 * w_stock.
      ENDIF.
      IF w_rateas2 LT w_rate.
        w_as2val1 = w_rateas2 * w_stock.
      ELSE.
        w_as2val1 = w_value.
      ENDIF.
      w_tvalue = w_tvalue + w_value.
      w_tas2val = w_tas2val + w_as2val.
      w_tas2val1 = w_tas2val1 + w_as2val1.
      w_gvalue = w_gvalue + w_value.
      w_gas2val = w_gas2val + w_as2val.
      w_gas2val1 = w_gas2val1 + w_as2val1.
      WRITE :/1 t_details-matnr,
              8 makt-maktx,
              44(16) w_stock,
              61(3) mara-meins,
              65(16) w_value,
              82(9) w_rate,
              92(9) w_rateas2,
              102(16) w_as2val,
              119(16) w_as2val1.
    ENDIF.
  ENDLOOP.
  PERFORM total_details.
  PERFORM grtotal_details.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM total_details                                            *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM total_details.
  IF w_tvalue NE 0 AND w_tas2val NE 0.
    ULINE.
    WRITE :/1 'Vendor Total : ',
            65(16) w_tvalue,
            102(16) w_tas2val,
            119(16) w_tas2val1.
    ULINE.
    w_tvalue = 0.
    w_tas2val = 0.
    w_tas2val1 = 0.
  ENDIF.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM grtotal_details                                          *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM grtotal_details.
  IF w_gvalue NE 0 AND w_gas2val NE 0.
    ULINE.
    WRITE :/1 'Grand Total : ',
            65(16) w_gvalue,
            102(16) w_gas2val,
            119(16) w_gas2val1.
    ULINE.
  ENDIF.
ENDFORM.
