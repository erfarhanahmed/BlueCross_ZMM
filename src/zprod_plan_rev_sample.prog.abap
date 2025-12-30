*&---------------------------------------------------------------------*
*& Report  ZPROD_PLAN_REV1
*& developed by Jyotsna 26.4.2017
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZPROD_PLAN_REV3 NO STANDARD PAGE HEADING LINE-SIZE 500.

TABLES : ZPROD_SAMP_REQ,
         QALS,
         MAKT,
         ZPRODSAMP_STOCK.

DATA : IT_ZPROD_SAMP_REQ    TYPE TABLE OF ZPROD_SAMP_REQ,
       WA_ZPROD_SAMP_REQ    TYPE ZPROD_SAMP_REQ,
       IT_ZPROD_SAMP_REQ1   TYPE TABLE OF ZPROD_SAMP_REQ,
       WA_ZPROD_SAMP_REQ1   TYPE ZPROD_SAMP_REQ,
       IT_ZPROD_SAMP_REQ2   TYPE TABLE OF ZPROD_SAMP_REQ,
       WA_ZPROD_SAMP_REQ2   TYPE ZPROD_SAMP_REQ,
       IT_ZPROD_SAMP_REQ3   TYPE TABLE OF ZPROD_SAMP_REQ,
       WA_ZPROD_SAMP_REQ3   TYPE ZPROD_SAMP_REQ,
       IT_ZPROD_SAMP_REQ4   TYPE TABLE OF ZPROD_SAMP_REQ,
       WA_ZPROD_SAMP_REQ4   TYPE ZPROD_SAMP_REQ,
       IT_ZPRODSAMP_STOCK   TYPE TABLE OF ZPRODSAMP_STOCK,
       WA_ZPRODSAMP_STOCK   TYPE ZPRODSAMP_STOCK,
       IT_MKPF              TYPE TABLE OF MKPF,
       WA_MKPF              TYPE MKPF,
       IT_MSEG              TYPE TABLE OF MSEG,
       WA_MSEG              TYPE MSEG,
       IT_MCHB              TYPE TABLE OF MCHB,
       WA_MCHB              TYPE MCHB,

       IT_ZPROD_SAMP_REQ_N1 TYPE TABLE OF ZPROD_SAMP_REQ,
       WA_ZPROD_SAMP_REQ_N1 TYPE ZPROD_SAMP_REQ,
       IT_ZPROD_SAMP_REQ_N2 TYPE TABLE OF ZPROD_SAMP_REQ,
       WA_ZPROD_SAMP_REQ_N2 TYPE ZPROD_SAMP_REQ,
       IT_ZPROD_SAMP_REQ_N3 TYPE TABLE OF ZPROD_SAMP_REQ,
       WA_ZPROD_SAMP_REQ_N3 TYPE ZPROD_SAMP_REQ,
       IT_ZSALES_TAB1       TYPE TABLE OF ZSALES_TAB1,
       WA_ZSALES_TAB1       TYPE ZSALES_TAB1,
       IT_ZSAMPINVP         TYPE TABLE OF ZSAMPINVP,
       WA_ZSAMPINVP         TYPE ZSAMPINVP.


TYPES : BEGIN OF ITAB1,
          MATNR TYPE MARA-MATNR,
*  CHARG TYPE MCHB-CHARG,
          MENGE TYPE MCHB-CLABS,
        END OF ITAB1.
DATA : IT_TAB1 TYPE TABLE OF ITAB1,
       WA_TAB1 TYPE ITAB1,
       IT_TAB2 TYPE TABLE OF ITAB1,
       WA_TAB2 TYPE ITAB1.

DATA : ST1     TYPE P,
       ST2     TYPE P,
       ST3     TYPE P,
       RECQTY  TYPE P,
       REVQTY  TYPE P,
       REVQTY1 TYPE P,
       REVQTY2 TYPE P,
       REVQTY3 TYPE P,
       REVQTY4 TYPE P,
       QTY1    TYPE P,
       RQTY    TYPE P,
       RQTY1   TYPE P,
       RQTY2   TYPE P,
       RQTY3   TYPE P,
       RQTY4   TYPE P,
       A       TYPE I,
       H6      TYPE P,
       F1      TYPE P,
       F2      TYPE P,
       F6      TYPE P,
       L6      TYPE P,
       REV     TYPE P,
       REV1    TYPE P,
       REV2    TYPE P,
       REV3    TYPE P,
       REV4    TYPE P,
       REC     TYPE P,
       SALEQTY TYPE P,
       E1      TYPE P,
       E2      TYPE P,
       E3      TYPE P,
       E4      TYPE P,
       NREV    TYPE P.
DATA : V1 TYPE P,
       V2 TYPE P.

DATA : ZPROD_SAMP_REQ_WA  TYPE ZPROD_SAMP_REQ,
       ZPROD_SAMP_REQ1_WA TYPE ZPROD_SAMP_REQ,
       ZPROD_SAMP_REQ2_WA TYPE ZPROD_SAMP_REQ,
       ZPROD_SAMP_REQ3_WA TYPE ZPROD_SAMP_REQ.

TYPES : BEGIN OF REC1,
*  WERKS TYPE MSEG-WERKS,
          MATNR TYPE MSEG-MATNR,
          MENGE TYPE P,
        END OF REC1.
TYPES : BEGIN OF SALE1,
          MATNR   TYPE MSEG-MATNR,
          SALEQTY TYPE P,
        END OF SALE1.

DATA : IT_REC1  TYPE TABLE OF REC1,
       WA_REC1  TYPE REC1,
       IT_SALE1 TYPE TABLE OF SALE1,
       WA_SALE1 TYPE SALE1.

DATA : LM1(2) TYPE C,
       LY1(4) TYPE C,
       LM2(2) TYPE C,
       LY2(4) TYPE C.

DATA : FDATE  TYPE SY-DATUM,
       FDATE1 TYPE SY-DATUM,
       FDATE2 TYPE SY-DATUM,
       FLDATE TYPE SY-DATUM.

DATA : L_DATE TYPE SY-DATUM,
       PDATE2 TYPE SY-DATUM,
       PDATE3 TYPE SY-DATUM,
       PDATE4 TYPE SY-DATUM,
       EDATE1 TYPE SY-DATUM,
       NDATE  TYPE SY-DATUM,
       SDATE1 TYPE SY-DATUM,
       SDATE2 TYPE SY-DATUM,
       PDATE1 TYPE SY-DATUM,
       LDATE1 TYPE SY-DATUM,
       LDATE2 TYPE SY-DATUM.
DATA : NDATE1 TYPE SY-DATUM,
       NDATE2 TYPE SY-DATUM.
DATA : QTY TYPE P.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
PARAMETERS : R1 RADIOBUTTON GROUP R1.
PARAMETERS : R2 RADIOBUTTON GROUP R1.

*PARAMETERS : PLANT LIKE MCHB-WERKS OBLIGATORY.
*SELECT-OPTIONS : sdate FOR sy-datum OBLIGATORY.
*PARAMETERS : sdate1 LIKE sy-datum OBLIGATORY,
*             sdate2 LIKE sy-datum OBLIGATORY.
*PARAMETERS : sdate1 LIKE sy-datum.
PARAMETERS : M1(2) TYPE C,
             Y1(4) TYPE C.

PARAMETERS : PM1(2) TYPE C,
             PY1(4) TYPE C.



SELECTION-SCREEN END OF BLOCK MERKMALE1 .

INITIALIZATION.

*AT SELECTION-SCREEN.



*  IF sdate1+6(2) NE '01'.
**    message 'ENTER START DATE OF MONTH' type 'E'.
*  ENDIF.
*  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
*    EXPORTING
*      day_in            = sdate1
*    IMPORTING
*      last_day_of_month = l_date.
*
**  IF sdate2 NE l_date.
***    message 'ENTER END DATE OF THE MONTH' type 'E'.
**  ENDIF.

START-OF-SELECTION.

  NDATE1+6(2) = '01'.
  NDATE1+4(2) = M1.
  NDATE1+0(4) = Y1.

  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = NDATE1
    IMPORTING
      NEWDATE = NDATE2.




  SDATE1+6(2) = '01'.
  SDATE1+4(2) = M1.
  SDATE1+0(4) = Y1.

  PDATE1+6(2) = '01'.
  PDATE1+4(2) = PM1.
  PDATE1+0(4) = PY1.


  IF NDATE2+4(2) NE PDATE1+4(2).
    MESSAGE 'ENTER STOCK FREEZ MONTH & NEXT MONTH DATE FOR PRODUCTION PLANNING' TYPE 'E'.
  ENDIF.
  IF NDATE2+0(4) NE PDATE1+0(4).
    MESSAGE 'ENTER STOCK FREEZ MONTH & NEXT MONTH DATE FOR PRODUCTION PLANNING' TYPE 'E'.
  ENDIF.





*  WRITE : / 'cl. stock date',sdate1,'prd plan display month',pdate1.

*  *  ******NEXT MONTH DATE****************
  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = PDATE1
    IMPORTING
      NEWDATE = PDATE2.
  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = PDATE2
    IMPORTING
      NEWDATE = PDATE3.
  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = PDATE3
    IMPORTING
      NEWDATE = PDATE4.

  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '-1'
      OLDDATE = PDATE1
    IMPORTING
      NEWDATE = LDATE1.
  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '-1'
      OLDDATE = LDATE1
    IMPORTING
      NEWDATE = LDATE2.

*  WRITE : / 'Prd Plan display dates',pdate1,pdate2,pdate3,pdate4.
*  WRITE :/ 'Prd Plan last month date', ldate1, 'last to ladr date',ldate2.

  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '-1'
      OLDDATE = SDATE1
    IMPORTING
      NEWDATE = SDATE2.
*  WRITE : / 'curr closing stock date',sdate1,'lm cl stock',sdate2.

  LM1 = SDATE2+4(2).
  LY1 = SDATE2+0(4).
*  WRITE : / 'CURR STOCK MONTH',M1,Y1,'LAST STOCK',LM1,LY1.



  IF R1 EQ 'X'.

    PERFORM REVCALC.
  ELSEIF R2 EQ 'X'.
    PERFORM DELETE_OLDDATA.
  ENDIF.



*&---------------------------------------------------------------------*
*&      Form  DELETE_OLDDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DELETE_OLDDATA .


*  BREAK-POINT.
*  DELETE FROM ZPROD_SAMP_REQ WHERE plant EQ plant AND pdate EQ pdate1.
*  DELETE FROM ZPROD_SAMP_REQ WHERE plant EQ plant AND pdate EQ pdate2.
*  DELETE FROM ZPROD_SAMP_REQ WHERE plant EQ plant AND pdate EQ pdate3.
*  DELETE FROM ZPROD_SAMP_REQ WHERE plant EQ plant AND pdate EQ pdate4.

  SELECT * FROM ZPRODSAMP_STOCK INTO TABLE IT_ZPRODSAMP_STOCK WHERE ZMONTH EQ M1 AND ZYEAR EQ Y1 .
  IF IT_ZPRODSAMP_STOCK IS NOT INITIAL.
    LOOP AT IT_ZPRODSAMP_STOCK INTO WA_ZPRODSAMP_STOCK.
      SELECT SINGLE * FROM ZPROD_SAMP_REQ WHERE MATNR EQ WA_ZPRODSAMP_STOCK-MATNR AND PDATE EQ WA_ZPRODSAMP_STOCK-BUDAT1.
      IF SY-SUBRC EQ 0.
*        ZPROD_SAMP_REQ_wa-plant = wa_ZPRODSamp_stock-werks.
        ZPROD_SAMP_REQ_WA-MATNR = WA_ZPRODSAMP_STOCK-MATNR.
        ZPROD_SAMP_REQ_WA-PDATE = WA_ZPRODSAMP_STOCK-BUDAT1.
        ZPROD_SAMP_REQ_WA-QTY = WA_ZPRODSAMP_STOCK-QTY1.
        ZPROD_SAMP_REQ_WA-RQTY = WA_ZPRODSAMP_STOCK-RQTY1.
        ZPROD_SAMP_REQ_WA-BUDGET = WA_ZPRODSAMP_STOCK-BUDGET1.
        MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
        CLEAR ZPROD_SAMP_REQ_WA.
        A = 1.
      ENDIF.

      SELECT SINGLE * FROM ZPROD_SAMP_REQ WHERE MATNR EQ WA_ZPRODSAMP_STOCK-MATNR AND PDATE EQ WA_ZPRODSAMP_STOCK-BUDAT2.
      IF SY-SUBRC EQ 0.
*        ZPROD_SAMP_REQ_wa-plant = wa_ZPRODSamp_stock-werks.
        ZPROD_SAMP_REQ_WA-MATNR = WA_ZPRODSAMP_STOCK-MATNR.
        ZPROD_SAMP_REQ_WA-PDATE = WA_ZPRODSAMP_STOCK-BUDAT2.
        ZPROD_SAMP_REQ_WA-QTY = WA_ZPRODSAMP_STOCK-QTY2.
        ZPROD_SAMP_REQ_WA-RQTY = WA_ZPRODSAMP_STOCK-RQTY2.
        ZPROD_SAMP_REQ_WA-BUDGET = WA_ZPRODSAMP_STOCK-BUDGET2.
        MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
        CLEAR ZPROD_SAMP_REQ_WA.
        A = 1.
      ENDIF.

      SELECT SINGLE * FROM ZPROD_SAMP_REQ WHERE MATNR EQ WA_ZPRODSAMP_STOCK-MATNR AND PDATE EQ WA_ZPRODSAMP_STOCK-BUDAT3.
      IF SY-SUBRC EQ 0.
*        ZPROD_SAMP_REQ_wa-plant = wa_ZPRODSamp_stock-werks.
        ZPROD_SAMP_REQ_WA-MATNR = WA_ZPRODSAMP_STOCK-MATNR.
        ZPROD_SAMP_REQ_WA-PDATE = WA_ZPRODSAMP_STOCK-BUDAT3.
        ZPROD_SAMP_REQ_WA-QTY = WA_ZPRODSAMP_STOCK-QTY3.
        ZPROD_SAMP_REQ_WA-RQTY = WA_ZPRODSAMP_STOCK-RQTY3.
        ZPROD_SAMP_REQ_WA-BUDGET = WA_ZPRODSAMP_STOCK-BUDGET3.
        MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
        CLEAR ZPROD_SAMP_REQ_WA.
        A = 1.
      ENDIF.

      SELECT SINGLE * FROM ZPROD_SAMP_REQ WHERE MATNR EQ WA_ZPRODSAMP_STOCK-MATNR AND PDATE EQ WA_ZPRODSAMP_STOCK-BUDAT4.
      IF SY-SUBRC EQ 0.
*        ZPROD_SAMP_REQ_wa-plant = wa_ZPRODSamp_stock-werks.
        ZPROD_SAMP_REQ_WA-MATNR = WA_ZPRODSAMP_STOCK-MATNR.
        ZPROD_SAMP_REQ_WA-PDATE = WA_ZPRODSAMP_STOCK-BUDAT4.
        ZPROD_SAMP_REQ_WA-QTY = WA_ZPRODSAMP_STOCK-QTY4.
        ZPROD_SAMP_REQ_WA-RQTY = WA_ZPRODSAMP_STOCK-RQTY4.
        ZPROD_SAMP_REQ_WA-BUDGET = WA_ZPRODSAMP_STOCK-BUDGET4.
        MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
        CLEAR ZPROD_SAMP_REQ_WA.
        A = 1.
      ENDIF.

    ENDLOOP.
  ENDIF.

*SELECT * FROM ZPRODSamp_stock INTO TABLE it_ZPRODSamp_stock WHERE zmonth EQ m1 AND zyear EQ y1 AND werks EQ plant AND budat1 EQ pdate1.
*    LOOP AT it_ZPRODSamp_stock INTO wa_ZPRODSamp_stock WHERE budat1 EQ pdate1.
*      ZPROD_SAMP_REQ_wa-plant = wa_ZPRODSamp_stock-werks.
*      ZPROD_SAMP_REQ_wa-matnr = wa_ZPRODSamp_stock-matnr.
*      ZPROD_SAMP_REQ_wa-pdate = pdate1.
*      ZPROD_SAMP_REQ_wa-qty = wa_ZPRODSamp_stock-qty1.
*      ZPROD_SAMP_REQ_wa-rqty = wa_ZPRODSamp_stock-rqty1.
*      ZPROD_SAMP_REQ_wa-budget = wa_ZPRODSamp_stock-budget1.
*      MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_wa.
*      CLEAR ZPROD_SAMP_REQ_wa.
*      a = 1.
*    ENDLOOP.




  IF A EQ 1.
    MESSAGE 'REPLACED PREVIOUS MONTH DATA NOW RUN AGAIN' TYPE 'I'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DELETE_CNF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  REVCALC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM REVCALC .


  SELECT * FROM ZPROD_SAMP_REQ INTO TABLE IT_ZPROD_SAMP_REQ1 WHERE PDATE EQ PDATE1.
  SELECT * FROM ZPROD_SAMP_REQ INTO TABLE IT_ZPROD_SAMP_REQ2 WHERE PDATE EQ PDATE2.
  SELECT * FROM ZPROD_SAMP_REQ INTO TABLE IT_ZPROD_SAMP_REQ3 WHERE PDATE EQ PDATE3.
  SELECT * FROM ZPROD_SAMP_REQ INTO TABLE IT_ZPROD_SAMP_REQ4 WHERE PDATE EQ PDATE4.
*  AND QTY GT 0.
  FDATE+6(2) = '01'.
  FDATE+4(2) = M1.
  FDATE+0(4) = Y1.


  CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
    EXPORTING
      IV_DATE           = FDATE
    IMPORTING
*     EV_MONTH_BEGIN_DATE       =
      EV_MONTH_END_DATE = FLDATE.
*FDATE+4(2) = '07'.

  PERFORM RECEIPTS.
  PERFORM SALES.
*BREAK-POINT.
*EXIT.
******************
  LOOP AT IT_ZPROD_SAMP_REQ1 INTO WA_ZPROD_SAMP_REQ1.
*    r eq '000000000000812010'.
*    BREAK-POINT.
    CLEAR : RECQTY,REVQTY1,REVQTY2,REVQTY3,REVQTY4,QTY1,RQTY1,RQTY2,RQTY3,RQTY4.
    CLEAR : L6,H6,F2,F6,REV,REC,SALEQTY,E1,E2,E3,E4,F1,NREV.

    READ TABLE IT_REC1 INTO WA_REC1 WITH KEY MATNR = WA_ZPROD_SAMP_REQ1-MATNR.
    IF SY-SUBRC EQ 0.
      REC = WA_REC1-MENGE.
    ENDIF.

*    if wa_ZPROD_SAMP_REQ1-matnr eq '000000000000013096'.
*      rec = 118348.
*    ENDIF.
*     if wa_ZPROD_SAMP_REQ1-matnr eq '000000000000012008'.
*      rec = 343606.
*    ENDIF.

    READ TABLE IT_SALE1 INTO WA_SALE1 WITH KEY MATNR = WA_ZPROD_SAMP_REQ1-MATNR.
    IF SY-SUBRC EQ 0.
      SALEQTY = WA_SALE1-SALEQTY.
    ENDIF.


*    SELECT SINGLE * FROM ZPRODSamp_stock WHERE zmonth EQ lm1 AND zyear EQ ly1 AND matnr EQ wa_ZPROD_SAMP_REQ1-matnr AND werks
*       EQ wa_ZPROD_SAMP_REQ1-plant AND budat2 EQ pdate1.
*    IF sy-subrc EQ 0.
*      l6 = ZPRODSamp_stock-rqty2.
*    ENDIF.

    SELECT SINGLE * FROM ZPRODSAMP_STOCK WHERE ZMONTH EQ M1 AND ZYEAR EQ Y1 AND MATNR EQ WA_ZPROD_SAMP_REQ1-MATNR AND BUDAT1 EQ PDATE1.
    IF SY-SUBRC EQ 0.
      L6 = ZPRODSAMP_STOCK-RQTY1.
    ENDIF.

***************new logic for H6********
    SELECT SINGLE * FROM ZPROD_SAMP_REQ WHERE MATNR EQ WA_ZPROD_SAMP_REQ1-MATNR AND PDATE EQ LDATE1.
    IF SY-SUBRC EQ 0.
*          WRITE : / 'LM REQD - H6',ZPROD_SAMP_REQ-QTY,ZPROD_SAMP_REQ-RQTY,ZPROD_SAMP_REQ-BUDGET.
      H6 = ZPROD_SAMP_REQ-RQTY.
    ENDIF.
*    SELECT SINGLE * FROM ZPRODSamp_stock WHERE zmonth EQ lm1 AND zyear EQ ly1 AND matnr EQ wa_ZPROD_SAMP_REQ1-matnr AND werks
*    EQ wa_ZPROD_SAMP_REQ1-plant AND budat1 EQ ldate1.
*    IF sy-subrc EQ 0.
*      h6 = ZPRODSamp_stock-rqty1.
*    ENDIF.

*    IF PLANT EQ '3000'.
*      SELECT SINGLE * FROM ZPRODSAMP_STOCK  WHERE ZMONTH EQ M1 AND ZYEAR EQ Y1 AND MATNR EQ WA_ZPROD_SAMP_REQ1-MATNR .
*      IF SY-SUBRC EQ 0.
**          WRITE : 'CM CL - F2',ZPRODSamp_stock-ZMONTH,ZPRODSamp_stock-ZYEAR,ZPRODSamp_stock-MATNR,ZPRODSamp_stock-FAC_STK,ZPRODSamp_stock-CNF_STK,ZPRODSamp_stock-TRAME.
*        F2 = ZPRODSAMP_STOCK-NSKSTK + ZPRODSAMP_STOCK-GOASTK + ZPRODSAMP_STOCK-OZRSTK + ZPRODSAMP_STOCK-GHASTK + ZPRODSAMP_STOCK-CNFSTK + ZPRODSAMP_STOCK-TRAME.
*      ENDIF.
*      SELECT SINGLE * FROM ZPRODSAMP_STOCK  WHERE ZMONTH EQ LM1 AND ZYEAR EQ LY1 AND MATNR EQ WA_ZPROD_SAMP_REQ1-MATNR.
*      IF SY-SUBRC EQ 0.
**          WRITE : 'LM CL- F6',ZPRODSamp_stock-ZMONTH,ZPRODSamp_stock-ZYEAR,ZPRODSamp_stock-MATNR,ZPRODSamp_stock-FAC_STK,ZPRODSamp_stock-CNF_STK,ZPRODSamp_stock-TRAME.
*        F6 = ZPRODSAMP_STOCK-NSKSTK + ZPRODSAMP_STOCK-GOASTK + ZPRODSAMP_STOCK-OZRSTK + ZPRODSAMP_STOCK-GHASTK + ZPRODSAMP_STOCK-CNFSTK + ZPRODSAMP_STOCK-TRAME.
*      ENDIF.
*    ELSE.
    SELECT SINGLE * FROM ZPRODSAMP_STOCK  WHERE ZMONTH EQ M1 AND ZYEAR EQ Y1 AND MATNR EQ WA_ZPROD_SAMP_REQ1-MATNR.
    IF SY-SUBRC EQ 0.
*          WRITE : 'CM CL - F2',ZPRODSamp_stock-ZMONTH,ZPRODSamp_stock-ZYEAR,ZPRODSamp_stock-MATNR,ZPRODSamp_stock-FAC_STK,ZPRODSamp_stock-CNF_STK,ZPRODSamp_stock-TRAME.
      F2 = ZPRODSAMP_STOCK-NSKSTK + ZPRODSAMP_STOCK-GOASTK + ZPRODSAMP_STOCK-OZRSTK + ZPRODSAMP_STOCK-GHASTK + ZPRODSAMP_STOCK-CNFSTK + ZPRODSAMP_STOCK-TRAME.
    ENDIF.
    SELECT SINGLE * FROM ZPRODSAMP_STOCK  WHERE ZMONTH EQ LM1 AND ZYEAR EQ LY1 AND MATNR EQ WA_ZPROD_SAMP_REQ1-MATNR.
    IF SY-SUBRC EQ 0.
*          WRITE : 'LM CL- F6',ZPRODSamp_stock-ZMONTH,ZPRODSamp_stock-ZYEAR,ZPRODSamp_stock-MATNR,ZPRODSamp_stock-FAC_STK,ZPRODSamp_stock-CNF_STK,ZPRODSamp_stock-TRAME.
      F6 = ZPRODSAMP_STOCK-NSKSTK + ZPRODSAMP_STOCK-GOASTK + ZPRODSAMP_STOCK-OZRSTK + ZPRODSAMP_STOCK-GHASTK + ZPRODSAMP_STOCK-CNFSTK  + ZPRODSAMP_STOCK-TRAME.
    ENDIF.
*    ENDIF.

*    NREV = ( saleqty + f2 ) - f6 - h6.
    nrev = ( saleqty + f2 ) - f6 .
*f2- last month closing stock.
*    NREV = F2 + REC - SALEQTY.

    IF NREV LE 0.
      IF NREV LT 0.
        NREV = NREV * ( - 1 ).
      ENDIF.
      REV = H6 + NREV + L6.
*******************round off*************************
      CLEAR : V1,V2.
      V1 = REV MOD 1000.
      IF V1 LT 500.
        REV = REV - V1.
      ELSE.
        V2 = 1000 - V1.
        REV = REV + V2.
      ENDIF.
************************************************
*      ZPROD_SAMP_REQ_WA-PLANT = WA_ZPROD_SAMP_REQ1-PLANT.
      ZPROD_SAMP_REQ_WA-MATNR = WA_ZPROD_SAMP_REQ1-MATNR.
      ZPROD_SAMP_REQ_WA-PDATE = PDATE1.
      ZPROD_SAMP_REQ_WA-QTY = L6." old - l6
      ZPROD_SAMP_REQ_WA-RQTY = REV.
      ZPROD_SAMP_REQ_WA-BUDGET = WA_ZPROD_SAMP_REQ1-BUDGET.
      MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
      CLEAR ZPROD_SAMP_REQ_WA.
      A = 1.
    ELSE.
      IF NREV LE H6.
        REV = ( H6 - NREV ) + L6.
*******************round off*************************
        CLEAR : V1,V2.
        V1 = REV MOD 1000.
        IF V1 LT 500.
          REV = REV - V1.
        ELSE.
          V2 = 1000 - V1.
          REV = REV + V2.
        ENDIF.
************************************************
*        ZPROD_SAMP_REQ_WA-PLANT = WA_ZPROD_SAMP_REQ1-PLANT.
        ZPROD_SAMP_REQ_WA-MATNR = WA_ZPROD_SAMP_REQ1-MATNR.
        ZPROD_SAMP_REQ_WA-PDATE = PDATE1.
        ZPROD_SAMP_REQ_WA-QTY = L6.
        ZPROD_SAMP_REQ_WA-RQTY = REV.
        ZPROD_SAMP_REQ_WA-BUDGET = WA_ZPROD_SAMP_REQ1-BUDGET.
        MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
        CLEAR ZPROD_SAMP_REQ_WA.
        A = 1.
      ELSE.
        REV = ( NREV - H6 ).
        IF REV LE L6.
          REV1 = L6 - REV.
*******************round off*************************
          CLEAR : V1,V2.
          V1 = REV1 MOD 1000.
          IF V1 LT 500.
            REV1 = REV1 - V1.
          ELSE.
            V2 = 1000 - V1.
            REV1 = REV1 + V2.
          ENDIF.
************************************************
*          ZPROD_SAMP_REQ_WA-PLANT = WA_ZPROD_SAMP_REQ1-PLANT.
          ZPROD_SAMP_REQ_WA-MATNR = WA_ZPROD_SAMP_REQ1-MATNR.
          ZPROD_SAMP_REQ_WA-PDATE = PDATE1.
          ZPROD_SAMP_REQ_WA-QTY = L6.
          ZPROD_SAMP_REQ_WA-RQTY = REV1.
          ZPROD_SAMP_REQ_WA-BUDGET = WA_ZPROD_SAMP_REQ1-BUDGET.
          MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
          CLEAR ZPROD_SAMP_REQ_WA.
          A = 1.
        ELSE.

*          ZPROD_SAMP_REQ_WA-PLANT = WA_ZPROD_SAMP_REQ1-PLANT.
          ZPROD_SAMP_REQ_WA-MATNR = WA_ZPROD_SAMP_REQ1-MATNR.
          ZPROD_SAMP_REQ_WA-PDATE = PDATE1.
          ZPROD_SAMP_REQ_WA-QTY = L6.
          ZPROD_SAMP_REQ_WA-RQTY = 0.
          ZPROD_SAMP_REQ_WA-BUDGET = WA_ZPROD_SAMP_REQ1-BUDGET.
          MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
          CLEAR ZPROD_SAMP_REQ_WA.
          A = 1.

          REV1 = REV - L6.
          SELECT SINGLE * FROM ZPROD_SAMP_REQ WHERE MATNR EQ WA_ZPROD_SAMP_REQ1-MATNR AND PDATE EQ PDATE2.
          IF SY-SUBRC EQ 0.
            IF REV1 LE ZPROD_SAMP_REQ-RQTY.
              E2 = ZPROD_SAMP_REQ-RQTY - REV1.

*******************round off*************************
              CLEAR : V1,V2.
              V1 = E2 MOD 1000.
              IF V1 LT 500.
                E2 = E2 - V1.
              ELSE.
                V2 = 1000 - V1.
                E2 = E2 + V2.
              ENDIF.
************************************************
*              ZPROD_SAMP_REQ_WA-PLANT = ZPROD_SAMP_REQ-PLANT.
              ZPROD_SAMP_REQ_WA-MATNR = ZPROD_SAMP_REQ-MATNR.
              ZPROD_SAMP_REQ_WA-PDATE = PDATE2.
              ZPROD_SAMP_REQ_WA-QTY = ZPROD_SAMP_REQ-RQTY.
              ZPROD_SAMP_REQ_WA-RQTY = E2.
              ZPROD_SAMP_REQ_WA-BUDGET = ZPROD_SAMP_REQ-BUDGET.
              MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
              CLEAR ZPROD_SAMP_REQ_WA.
              A = 1.
            ELSE.
*              ZPROD_SAMP_REQ_WA-PLANT = ZPROD_SAMP_REQ-PLANT.
              ZPROD_SAMP_REQ_WA-MATNR = ZPROD_SAMP_REQ-MATNR.
              ZPROD_SAMP_REQ_WA-PDATE = PDATE2.
              ZPROD_SAMP_REQ_WA-QTY = ZPROD_SAMP_REQ-RQTY.
              ZPROD_SAMP_REQ_WA-RQTY = 0.
              ZPROD_SAMP_REQ_WA-BUDGET = ZPROD_SAMP_REQ-BUDGET.
              MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
              CLEAR ZPROD_SAMP_REQ_WA.
              A = 1.
              REV2 = REV1 - ZPROD_SAMP_REQ-RQTY.
              SELECT SINGLE * FROM ZPROD_SAMP_REQ WHERE MATNR EQ WA_ZPROD_SAMP_REQ1-MATNR AND PDATE EQ PDATE3.
              IF SY-SUBRC EQ 0.
                IF REV2 LE ZPROD_SAMP_REQ-RQTY.
                  E3 = ZPROD_SAMP_REQ-RQTY - REV2.
*******************round off*************************
                  CLEAR : V1,V2.
                  V1 = E3 MOD 1000.
                  IF V1 LT 500.
                    E3 = E3 - V1.
                  ELSE.
                    V2 = 1000 - V1.
                    E3 = E3 + V2.
                  ENDIF.
************************************************
*                  ZPROD_SAMP_REQ_WA-PLANT = ZPROD_SAMP_REQ-PLANT.
                  ZPROD_SAMP_REQ_WA-MATNR = ZPROD_SAMP_REQ-MATNR.
                  ZPROD_SAMP_REQ_WA-PDATE = PDATE3.
                  ZPROD_SAMP_REQ_WA-QTY = ZPROD_SAMP_REQ-RQTY.
                  ZPROD_SAMP_REQ_WA-RQTY = E3.
                  ZPROD_SAMP_REQ_WA-BUDGET = ZPROD_SAMP_REQ-BUDGET.
                  MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
                  CLEAR ZPROD_SAMP_REQ_WA.
                  A = 1.
                ELSE.
*                  ZPROD_SAMP_REQ_WA-PLANT = ZPROD_SAMP_REQ-PLANT.
                  ZPROD_SAMP_REQ_WA-MATNR = ZPROD_SAMP_REQ-MATNR.
                  ZPROD_SAMP_REQ_WA-PDATE = PDATE3.
                  ZPROD_SAMP_REQ_WA-QTY = ZPROD_SAMP_REQ-RQTY.
                  ZPROD_SAMP_REQ_WA-RQTY = 0.
                  ZPROD_SAMP_REQ_WA-BUDGET = ZPROD_SAMP_REQ-BUDGET.
                  MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
                  CLEAR ZPROD_SAMP_REQ_WA.
                  A = 1.
                  REV3 = REV2 - ZPROD_SAMP_REQ-RQTY.
                  SELECT SINGLE * FROM ZPROD_SAMP_REQ WHERE MATNR EQ WA_ZPROD_SAMP_REQ1-MATNR AND PDATE EQ PDATE4.
                  IF SY-SUBRC EQ 0.
                    IF REV3 LE ZPROD_SAMP_REQ-RQTY.
                      E4 = ZPROD_SAMP_REQ-RQTY - REV3.
*******************round off*************************
                      CLEAR : V1,V2.
                      V1 = E4 MOD 1000.
                      IF V1 LT 500.
                        E4 = E4 - V1.
                      ELSE.
                        V2 = 1000 - V1.
                        E4 = E4 + V2.
                      ENDIF.
************************************************
*                      ZPROD_SAMP_REQ_WA-PLANT = ZPROD_SAMP_REQ-PLANT.
                      ZPROD_SAMP_REQ_WA-MATNR = ZPROD_SAMP_REQ-MATNR.
                      ZPROD_SAMP_REQ_WA-PDATE = PDATE4.
                      ZPROD_SAMP_REQ_WA-QTY = ZPROD_SAMP_REQ-RQTY.
                      ZPROD_SAMP_REQ_WA-RQTY = E4.
                      ZPROD_SAMP_REQ_WA-BUDGET = WA_ZPROD_SAMP_REQ1-BUDGET.
                      MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
                      CLEAR ZPROD_SAMP_REQ_WA.
                      A = 1.
                    ELSE.
*                      ZPROD_SAMP_REQ_WA-PLANT = ZPROD_SAMP_REQ-PLANT.
                      ZPROD_SAMP_REQ_WA-MATNR = ZPROD_SAMP_REQ-MATNR.
                      ZPROD_SAMP_REQ_WA-PDATE = PDATE4.
                      ZPROD_SAMP_REQ_WA-QTY = ZPROD_SAMP_REQ-RQTY.
                      ZPROD_SAMP_REQ_WA-RQTY = 0.
                      ZPROD_SAMP_REQ_WA-BUDGET = WA_ZPROD_SAMP_REQ1-BUDGET.
                      MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
                      CLEAR ZPROD_SAMP_REQ_WA.
                      A = 1.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.
***********************************************

    ENDIF.
  ENDLOOP.


  IF A EQ 1.
    MESSAGE 'REVISED QANTITY FOR PRODUCTION PLANNING IS UPDATED ' TYPE 'I'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RECEIPTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM RECEIPTS .
*BREAK-POINT.

*  SELECT SINGLE * FROM ZPRODSAMP_STOCK WHERE ZMONTH EQ LM1 AND ZYEAR EQ LY1 AND BUDAT NE 0.
*  IF SY-SUBRC EQ 0.
*    FDATE1 = ZPRODSAMP_STOCK-BUDAT.
*  ENDIF.
*  SELECT SINGLE * FROM ZPRODSAMP_STOCK WHERE ZMONTH EQ M1 AND ZYEAR EQ Y1 AND BUDAT NE 0.
*  IF SY-SUBRC EQ 0.
*    FDATE2 = ZPRODSAMP_STOCK-BUDAT.
*  ENDIF.
*
**FDATE1+6(2) = '01'.
**FDATE1+4(2) = '06'.
*  WRITE : / 'DATE',FDATE1,FDATE2.
*  IF PLANT EQ '3000'.
  IF IT_ZPROD_SAMP_REQ1 IS NOT INITIAL.
    SELECT * FROM MSEG INTO TABLE IT_MSEG FOR ALL ENTRIES IN IT_ZPROD_SAMP_REQ1 WHERE BWART IN ( '101','102' ) AND MATNR EQ IT_ZPROD_SAMP_REQ1-MATNR
      AND WERKS IN ( '3000','2000','2002' ) AND LGORT NE 'CSM'.
    IF SY-SUBRC EQ 0.
      SELECT * FROM MKPF INTO TABLE IT_MKPF FOR ALL ENTRIES IN IT_MSEG WHERE MBLNR EQ IT_MSEG-MBLNR AND BUDAT GT FDATE AND BUDAT LE FLDATE.
    ENDIF.
  ENDIF.
*  ELSE.
*    IF IT_ZPROD_SAMP_REQ1 IS NOT INITIAL.
*      SELECT * FROM MSEG INTO TABLE IT_MSEG FOR ALL ENTRIES IN IT_ZPROD_SAMP_REQ1 WHERE BWART IN ( '101','102' ) AND MATNR EQ IT_ZPROD_SAMP_REQ1-MATNR AND WERKS EQ PLANT AND LGORT GE 'FG01'
*        AND LGORT LE 'FG04'.
*      IF SY-SUBRC EQ 0.
*        SELECT * FROM MKPF INTO TABLE IT_MKPF FOR ALL ENTRIES IN IT_MSEG WHERE MBLNR EQ IT_MSEG-MBLNR AND BUDAT GT FDATE1 AND BUDAT LE FDATE2.
*      ENDIF.
*    ENDIF.
*  ENDIF.
  LOOP AT IT_MSEG INTO WA_MSEG.
    READ TABLE IT_MKPF INTO WA_MKPF WITH KEY MBLNR = WA_MSEG-MBLNR.
    IF SY-SUBRC EQ 0.
      IF WA_MSEG-BWART EQ '102'.
        WA_MSEG-MENGE = WA_MSEG-MENGE * ( - 1 ).
      ENDIF.
      WA_REC1-MATNR = WA_MSEG-MATNR.
      WA_REC1-MENGE = WA_MSEG-MENGE.
*       WA_REC1-WERKS = WA_MSEG-WERKS.
      COLLECT WA_REC1 INTO IT_REC1.
      CLEAR WA_REC1.
    ENDIF.
  ENDLOOP.
  LOOP AT IT_REC1 INTO WA_REC1.
    WRITE : / 'REC',WA_REC1-MATNR,WA_REC1-MENGE.
  ENDLOOP.
*BREAK-POINT.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RECEIPTS3000
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SALES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SALES .


*WRITE : / 'sale date', fdate,FLDATE.
  IF IT_ZPROD_SAMP_REQ1 IS NOT INITIAL.
    SELECT * FROM ZSAMPINVP INTO TABLE IT_ZSAMPINVP FOR ALL ENTRIES IN IT_ZPROD_SAMP_REQ1 WHERE SAMPCODE EQ IT_ZPROD_SAMP_REQ1-MATNR AND FKDAT GE FDATE AND FKDAT LE FLDATE.
  ENDIF.


  LOOP AT IT_ZSAMPINVP INTO WA_ZSAMPINVP.
    CLEAR : QTY.
*    qty = wa_zsales_tab1-c_qty + wa_zsales_tab1-f_qty.
    WA_SALE1-MATNR = WA_ZSAMPINVP-SAMPCODE.
    WA_SALE1-SALEQTY = WA_ZSAMPINVP-QTY.
    COLLECT WA_SALE1 INTO IT_SALE1.
    CLEAR WA_SALE1.
  ENDLOOP.

  LOOP AT IT_SALE1 INTO WA_SALE1.
    WRITE : / 'SALE',WA_SALE1-MATNR,WA_SALE1-SALEQTY.
  ENDLOOP.
ENDFORM.
