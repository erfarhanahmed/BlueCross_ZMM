*&---------------------------------------------------------------------*
*& Report  ZBCLL_COSTING_VIEW
*& created by Jyotsna
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZBCLL_COSTING_VIEW_A1_N1 NO STANDARD PAGE HEADING LINE-SIZE 200.
TABLES : ZTP_COST11,
         ZTP_COST12,
         MAKT,
         MARA,
         LFA1,
         MARM,
         MAST,
         STKO,
         MVKE,
         TVM5T,
         ZTP_COST14,
         PA0001,
         ZTP_COST15.

TYPES : BEGIN OF ITAB5,
          MTART      TYPE MARA-MTART,
          IDNRK      TYPE STPO-IDNRK,
          IMAKTX(65) TYPE C,
          MENGE(10)  TYPE C,
          MEINS(3)   TYPE C,
          RATE(10)   TYPE C,
          GSTRATE(7) TYPE C,
          GSTVAL(12) TYPE C,
          FRTPER(7)  TYPE C,
          FRTRATE(7) TYPE C,
          FRTVAL(12) TYPE C,
          V1(12)     TYPE C,
          V2(10)     TYPE C,

          POSNR      TYPE STPO-POSNR,
        END OF ITAB5.


DATA: IT_ZTP_COST11 TYPE TABLE OF ZTP_COST11,
      WA_ZTP_COST11 TYPE ZTP_COST11,
      IT_ZTP_COST12 TYPE TABLE OF ZTP_COST12,
      WA_ZTP_COST12 TYPE ZTP_COST12.
DATA: IT_TAB5 TYPE TABLE OF ITAB5,
      WA_TAB5 TYPE ITAB5,
      IT_TAB6 TYPE TABLE OF ZCOST1A,
      WA_TAB6 TYPE ZCOST1A.
DATA: M2 TYPE P DECIMALS 2,
      M3 TYPE P DECIMALS 2,
      M4 TYPE P DECIMALS 2,
      M5 TYPE P DECIMALS 2,
      M6 TYPE P DECIMALS 2,
      M7 TYPE P DECIMALS 2,
      M8 TYPE P DECIMALS 3,
      M9 TYPE P DECIMALS 2.
DATA: V1          TYPE P DECIMALS 3,
      V2          TYPE P DECIMALS 3,
      RV1         TYPE P DECIMALS 2,
      RV2         TYPE P DECIMALS 2,
      RMVAL(12)   TYPE C,
      PMVAL(12)   TYPE C,
      RMPMTOT(12) TYPE C,
      M1VAL(10)   TYPE C,
      CCPCVAL(10) TYPE C,
      TOTVAL(10)  TYPE C,
      GSTVAL(10)  TYPE C,
      TTOTAL(10)  TYPE C.
DATA: DR2(15)      TYPE C,
      DP2(15)      TYPE C,
      DRP1(15)     TYPE C,
      DMARGIN(15)  TYPE C,
      DM1(15)      TYPE C,
      DCCPC(15)    TYPE C,
      DANAVAL(15)  TYPE C,
      DANART(15)   TYPE C,
      DTOT1(15)    TYPE C,
      DGSTVAL1(15) TYPE C,
      DNET(15)     TYPE C.
DATA: F2(1)   TYPE C,
      FGNAME1 TYPE LFA1-NAME1,
      FGLIFNR TYPE LFA1-LIFNR,
      PACK    TYPE TVM5T-BEZEI,
      UOM     TYPE MARM-MEINH,
      CPUDT   TYPE SY-DATUM.
DATA: RMYLDQTY1(20) TYPE C,
      PMYLDQTY1(20) TYPE C,
      TQTY1(15)     TYPE C,
      YIELD1(10)    TYPE C,
      YIELD2(10)    TYPE C,
      QTY(20)       TYPE C,
      MATERIAL      LIKE MARA-MATNR,
      WERKS         TYPE MCHA-WERKS,
*      FGLIFNR       TYPE LFA1-LIFNR,
      STLAL         TYPE MAST-STLAL,
      R2(20)        TYPE C,
      P2(20)        TYPE C,
      RP1(20)       TYPE C,
      M1(20)        TYPE C,
      CCPC(20)      TYPE C,
      CCPCV1        TYPE P DECIMALS 2,
      ANAVAL(20)    TYPE C,
      ANART(20)     TYPE C,
      GSTVAL1(20)   TYPE C,
      NET(20)       TYPE C,
      MARGIN(20)    TYPE C,
      FGGST(20)     TYPE C,
      BMENG         TYPE STKO-BMENG,
      BATSZ(20)     TYPE C,
      RMYLD         TYPE P DECIMALS 2,
      PMYLD         TYPE P DECIMALS 2,
      MAKTX         TYPE MAKT-MAKTX,
      BMEIN         TYPE STKO-BMEIN,
      RMYLDQTY      TYPE P,
      PMYLDQTY      TYPE P.
DATA: TOT1    TYPE P DECIMALS 2,
      TOT(10) TYPE C.

DATA: QTY1(20) TYPE C.

DATA: Q1 TYPE P,
      Q2 TYPE P,
      Q3 TYPE P,
      Q4 TYPE P.

DATA : V_FM TYPE RS38L_FNAM.
TYPES : BEGIN OF CHECK,
          GJAHR TYPE ZTP_COST11-GJAHR,
          VBELN TYPE ZTP_COST11-VBELN,
        END OF CHECK.
DATA: IT_CHECK TYPE TABLE OF CHECK,
      WA_CHECK TYPE CHECK.
DATA: VBELN(10) TYPE C,
      GJAHR(4)  TYPE C.
DATA: STATUS(20) TYPE C.

DATA : CONTROL  TYPE SSFCTRLOP.
DATA : W_SSFCOMPOP TYPE SSFCOMPOP.

DATA: PRODSTAT(10)  TYPE C,
      PRODDT        TYPE SY-DATUM,
      PRODNAME      TYPE PA0001-ENAME,
      PRODTXT       TYPE ZTP_COST14-PRODTXT,

      PURSTAT(10)   TYPE C,
      PURDT         TYPE SY-DATUM,
      PURNAME       TYPE PA0001-ENAME,
      PURTXT        TYPE ZTP_COST14-PRODTXT,
      ACCTSTAT(10)  TYPE C,
      ACCTDT        TYPE SY-DATUM,
      ACCTNAME      TYPE PA0001-ENAME,
      ACCTTXT       TYPE ZTP_COST14-PRODTXT,
      FISTAT(10)    TYPE C,
      FIDT          TYPE SY-DATUM,
      FINAME        TYPE PA0001-ENAME,
      FITXT         TYPE ZTP_COST14-PRODTXT,
      FINALSTAT(10) TYPE C,
      FINALDT       TYPE SY-DATUM,
      FINALNAME     TYPE PA0001-ENAME,
      FINALTXT      TYPE ZTP_COST14-PRODTXT.
DATA: SUBJECT(100) TYPE C.

***************************************************************************************

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: MATNR FOR MARA-MATNR,
VENDOR FOR LFA1-LIFNR,
BUDAT FOR SY-DATUM.
SELECT-OPTIONS : SHEETNO FOR ZTP_COST11-VBELN MATCHCODE OBJECT ZTP_COST1.
PARAMETERS : FYEAR LIKE ZTP_COST11-GJAHR OBLIGATORY.
SELECTION-SCREEN END OF BLOCK MERKMALE1 .

START-OF-SELECTION.

  SELECT * FROM ZTP_COST11 INTO TABLE IT_ZTP_COST11 WHERE GJAHR EQ FYEAR AND VBELN IN SHEETNO AND MATNR IN MATNR AND FGLIFNR IN VENDOR
    AND CPUDT IN BUDAT.
  LOOP AT IT_ZTP_COST11 INTO WA_ZTP_COST11.
    WA_CHECK-GJAHR = WA_ZTP_COST11-GJAHR.
    WA_CHECK-VBELN = WA_ZTP_COST11-VBELN.
    COLLECT WA_CHECK INTO IT_CHECK.
    CLEAR WA_CHECK.
  ENDLOOP.
  SORT IT_CHECK BY VBELN.
  PERFORM FORMN1.



*&---------------------------------------------------------------------*
*&      Form  FORMN1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORMN1 .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     FORMNAME           = 'ZBOM4'  "12.4.21
*     FORMNAME           = 'ZBOM3'  "
*     formname           = 'ZCOST11'  "
*     FORMNAME           = 'ZCOST12'  "
      FORMNAME           = 'ZCOST12A'  "
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      FM_NAME            = V_FM
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.

  CONTROL-NO_OPEN   = 'X'.
  CONTROL-NO_CLOSE  = 'X'.


  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      CONTROL_PARAMETERS = CONTROL.

  LOOP AT IT_CHECK INTO WA_CHECK.
    CLEAR : VBELN,GJAHR.
    VBELN = WA_CHECK-VBELN.
    GJAHR = WA_CHECK-GJAHR.
    CONDENSE: VBELN,GJAHR.

    PERFORM FORM1.
    PERFORM FORM2.
    PERFORM FORM3.
    CLEAR : STATUS.
    SELECT SINGLE * FROM ZTP_COST15 WHERE VBELN EQ VBELN AND GJAHR EQ GJAHR.
    IF SY-SUBRC EQ 0.
      STATUS = 'REJECTED COTSHEET'.
    ENDIF.
    SELECT SINGLE * FROM ZTP_COST11 WHERE VBELN EQ VBELN AND GJAHR EQ GJAHR.
    IF SY-SUBRC EQ 0.
      SUBJECT = ZTP_COST11-SUBJECT.
    ENDIF.
*    BREAK-POINT.
    M1VAL = ( RMPMTOT * MARGIN / 100 ).
    CCPCVAL = CCPC * QTY1.
    CONDENSE CCPCVAL.
    TOTVAL = RMPMTOT + M1VAL + CCPCVAL + ANAVAL.
    GSTVAL = TOTVAL * ( 12 / 100 ).
    TTOTAL = TOTVAL + GSTVAL.
    CONDENSE :TOTVAL,GSTVAL,TTOTAL.

*    BREAK-POINT .
    CALL FUNCTION V_FM
      EXPORTING
        CONTROL_PARAMETERS = CONTROL
        USER_SETTINGS      = 'X'
        OUTPUT_OPTIONS     = W_SSFCOMPOP
        NAME1              = FGNAME1
        MAKTX              = MAKTX
        MATERIAL           = MATERIAL
        PACK               = PACK
        QTY                = QTY
        YIELD1             = YIELD1
        YIELD2             = YIELD2
        R2                 = R2
        P2                 = P2
        RP1                = RP1
        M1                 = M1
        CCPC               = CCPC
        ANAVAL             = ANAVAL
        ANART              = ANART
        GSTVAL1            = GSTVAL1
        NET                = NET
        MARGIN             = MARGIN
        FGGST              = FGGST
        BATSZ              = BATSZ
        RMYLDQTY1          = RMYLDQTY1
        PMYLDQTY1          = PMYLDQTY1
        UOM                = UOM
        CPUDT              = CPUDT
        VBELN              = VBELN
        GJAHR              = GJAHR
        TOT                = TOT
        PRODSTAT           = PRODSTAT
        PRODDT             = PRODDT
        PRODNAME           = PRODNAME
        PRODTXT            = PRODTXT
        PURSTAT            = PURSTAT
        PURDT              = PURDT
        PURNAME            = PURNAME
        PURTXT             = PURTXT
        ACCTSTAT           = ACCTSTAT
        ACCTDT             = ACCTDT
        ACCTNAME           = ACCTNAME
        ACCTTXT            = ACCTTXT
        FISTAT             = FISTAT
        FIDT               = FIDT
        FINAME             = FINAME
        FITXT              = FITXT
        FINALSTAT          = FINALSTAT
        FINALDT            = FINALDT
        FINALNAME          = FINALNAME
        FINALTXT           = FINALTXT
        STATUS             = STATUS
        SUBJECT            = SUBJECT
        FGLIFNR            = FGLIFNR
        RMVAL              = RMVAL
        PMVAL              = PMVAL
        RMPMTOT            = RMPMTOT
        M1VAL              = M1VAL
        CCPCVAL            = CCPCVAL
        TOTVAL             = TOTVAL
        GSTVAL             = GSTVAL
        TTOTAL             = TTOTAL
      TABLES
        IT_TAB5            = IT_TAB6
*       itab_division      = itab_division
*       itab_storage       = itab_storage
*       itab_pa0002        = itab_pa0002
      EXCEPTIONS
        FORMATTING_ERROR   = 1
        INTERNAL_ERROR     = 2
        SEND_ERROR         = 3
        USER_CANCELED      = 4
        OTHERS             = 5.

    FORMAT COLOR 3.
    WRITE : /1 'Manufacturer',FGLIFNR,FGNAME1,100 'CostSheet No.', VBELN, 'Year', GJAHR,'Dated', CPUDT.
    WRITE : /1 'Product name',MAKTX,100 'Theoretical Yield: 100'.
    WRITE : /1 'Product Code:', MATERIAL, 100 'Theoretical Qty.:', QTY.
    WRITE: /1 'Batch size:',BATSZ, 100 'RM Yield:', YIELD1+0(10), '  RM Yield Qty.:', RMYLDQTY1.
    WRITE : /1 'Pack size:',PACK,100 'PM Yield:', YIELD2+0(10),' PM Yield Qty.:',PMYLDQTY1.

    SKIP.
    FORMAT COLOR 2.
    WRITE : / 'Material',20 'Material_Name',60 'Quantity_&_Unit',90 'GST_RATE',110 'GST_AMT',130 'FRT._RATE',145 'FREIGHT_VALUE',
    160 'TOTAL_AMT',180 'GROSS_AMT',200 ' PER_PACK'.
    SKIP.

    LOOP AT IT_TAB6 INTO WA_TAB6.
      FORMAT COLOR 1.
      WRITE : / WA_TAB6-IDNRK,WA_TAB6-IMAKTX,60 WA_TAB6-MENGE,WA_TAB6-MEINS,90 WA_TAB6-RATE,WA_TAB6-GSTRATE,110 WA_TAB6-GSTVAL,
      130 WA_TAB6-FRTPER,145 WA_TAB6-FRTRATE,160 WA_TAB6-FRTVAL,180 WA_TAB6-V1,200 WA_TAB6-V2.
    ENDLOOP.
    SKIP.
    FORMAT COLOR 3.
    WRITE : / 'RM COST',20 RMVAL,50 R2.
    WRITE : / 'PM COST',20 PMVAL,50 P2.
    WRITE : / 'TOTAL',20 RMPMTOT,50 RP1.
    WRITE : / 'MARGIN@',20 M1VAL, 50 M1.
    WRITE : / 'CCPC',20 CCPCVAL, 50 CCPC.
    WRITE : / 'Analytical Charges',20 ANAVAL, 50 ANART.
    WRITE : / 'TOTAL',20 TOTVAL, 50 TOT.
    WRITE : / 'GST',20 GSTVAL, 50 GSTVAL1.
    WRITE : / 'TOTAL RATE',20 TTOTAL, 50 NET.
    ULINE.
    CLEAR : IT_TAB5,WA_TAB5.
    CLEAR : FGNAME1,MAKTX,MATERIAL,PACK,QTY,YIELD1,YIELD2,R2,P2,RP1,M1,CCPC,ANAVAL,ANART,GSTVAL1,NET,MARGIN,FGGST,BATSZ,RMYLDQTY1,PMYLDQTY1,UOM,CPUDT,TOT,
     PRODSTAT, PRODDT, PRODNAME, PRODTXT, PURSTAT, PURDT, PURNAME, PURTXT, ACCTSTAT, ACCTDT, ACCTNAME, ACCTTXT, FISTAT,FIDT,FINAME,FITXT,
       FINALSTAT, FINALDT, FINALNAME, FINALTXT,STATUS,V1,V2,RMVAL,PMVAL,RMPMTOT,M1VAL,MARGIN,CCPCVAL,TOTVAL,GSTVAL,TTOTAL.

 CLEAR :  RMPMTOT , RMVAL, PMVAL.
  ENDLOOP.
  CALL FUNCTION 'SSF_CLOSE'.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM1 .


  CLEAR : IT_ZTP_COST12,WA_ZTP_COST12.

  SELECT * FROM ZTP_COST12 INTO TABLE IT_ZTP_COST12 WHERE GJAHR EQ WA_CHECK-GJAHR AND VBELN EQ WA_CHECK-VBELN.

*  if it_ztp_cost11 is initial.
*    message 'NO DATA FOUND' type 'E'.
*  endif.
*  if it_ztp_cost12 is initial.
*    message 'NO DATA FOUND' type 'E'.
*  endif.
  CLEAR : IT_TAB5,WA_TAB5.

  IF IT_ZTP_COST12 IS NOT INITIAL.
    LOOP AT IT_ZTP_COST12 INTO WA_ZTP_COST12 WHERE GJAHR EQ WA_CHECK-GJAHR AND VBELN EQ WA_CHECK-VBELN.
      READ TABLE IT_ZTP_COST11 INTO WA_ZTP_COST11 WITH KEY GJAHR = WA_ZTP_COST12-GJAHR VBELN = WA_ZTP_COST12-VBELN.
      IF SY-SUBRC EQ 0.
*        write : / 'test',wa_ztp_cost12-gjahr,wa_ztp_cost12-vbeln,wa_ztp_cost12-idnrk.

        WA_TAB5-IDNRK = WA_ZTP_COST12-IDNRK.
        SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZTP_COST12-IDNRK AND SPRAS EQ 'EN'.
        IF SY-SUBRC EQ 0.
          WA_TAB5-IMAKTX = MAKT-MAKTX.
        ENDIF.
        WA_TAB5-MENGE = WA_ZTP_COST12-MENGE.
        SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_ZTP_COST12-IDNRK.
        IF SY-SUBRC EQ 0.
          WA_TAB5-MEINS = MARA-MEINS.
          WA_TAB5-MTART = MARA-MTART.
        ENDIF.


        WA_TAB5-POSNR = WA_ZTP_COST12-POSNR.
        CLEAR : M9,M2,M3,M4,M5,M6,M7,M8.
        M9 = WA_ZTP_COST12-RATE.
        WA_TAB5-RATE = M9.
        M2 = WA_ZTP_COST12-GSTRATE.
        WA_TAB5-GSTRATE = M2.
        M3 = WA_ZTP_COST12-GSTVAL.
        WA_TAB5-GSTVAL = M3.
        M4 = WA_ZTP_COST12-FRTPER.
        WA_TAB5-FRTPER = M4.
        M5 = WA_ZTP_COST12-FRTRATE.
        WA_TAB5-FRTRATE = M5.
        M6 = WA_ZTP_COST12-FRTVAL.
        WA_TAB5-FRTVAL = M6.
        M7 = WA_ZTP_COST12-V1.
        WA_TAB5-V1 = M7.
        M8 = WA_ZTP_COST12-V2.
        WA_TAB5-V2 = M8.
        CONDENSE : WA_TAB5-MENGE,WA_TAB5-RATE,WA_TAB5-GSTRATE,WA_TAB5-GSTVAL,WA_TAB5-FRTPER,WA_TAB5-FRTRATE,WA_TAB5-FRTVAL,WA_TAB5-V1,
        WA_TAB5-V2.
        COLLECT WA_TAB5 INTO IT_TAB5.
        CLEAR WA_TAB5.

      ENDIF.
    ENDLOOP.
  ENDIF.
*  BREAK-POINT .
  CLEAR : IT_TAB6,WA_TAB6.
  LOOP AT IT_TAB5 INTO WA_TAB5.
*    WRITE : / WA_TAB5-IDNRK,WA_TAB5-IMAKTX,WA_TAB5-MENGE,WA_TAB5-MEINS,WA_TAB5-RATE,WA_TAB5-GSTRATE,WA_TAB5-GSTVAL,WA_TAB5-FRTPER,
*    WA_TAB5-FRTRATE,WA_TAB5-FRTVAL,WA_TAB5-V1,WA_TAB5-V2,WA_TAB5-MTART,WA_TAB5-POSNR.
    WA_TAB6-IDNRK = WA_TAB5-IDNRK.
    WA_TAB6-IMAKTX = WA_TAB5-IMAKTX.
    WA_TAB6-MENGE = WA_TAB5-MENGE.
    WA_TAB6-MEINS = WA_TAB5-MEINS.
    WA_TAB6-RATE = WA_TAB5-RATE.
    WA_TAB6-GSTRATE = WA_TAB5-GSTRATE.
    WA_TAB6-GSTVAL = WA_TAB5-GSTVAL.
    WA_TAB6-FRTPER = WA_TAB5-FRTPER.
    WA_TAB6-FRTRATE = WA_TAB5-FRTRATE.
    WA_TAB6-FRTVAL = WA_TAB5-FRTVAL.
    WA_TAB6-V1 = WA_TAB5-V1.
    WA_TAB6-V2 = WA_TAB5-V2.
*    WA_TAB6-MTART = WA_TAB5-MTART.
*    WA_TAB6-POSNR = WA_TAB5-POSNR.
    V2 = V2 + WA_TAB5-V2.
    V1 = V1 + WA_TAB5-V1.
    COLLECT WA_TAB6 INTO IT_TAB6.
    CLEAR WA_TAB6.
    AT END OF MTART.

      WA_TAB6-IDNRK = SPACE.

      WA_TAB6-MENGE = SPACE.
      WA_TAB6-MEINS = SPACE.
      WA_TAB6-RATE = SPACE.
      WA_TAB6-GSTRATE = SPACE.
      WA_TAB6-GSTVAL = SPACE.
      WA_TAB6-FRTPER = SPACE.
      WA_TAB6-FRTRATE = SPACE.
      WA_TAB6-FRTVAL = SPACE.
*      WA_TAB6-MTART = SPACE.
*      WA_TAB6-POSNR = SPACE.

*      BREAK-POINT .
      IF WA_TAB5-MTART EQ 'ZROH'.
        RMVAL = V1.
        WA_TAB6-IMAKTX = 'RM SUBTOTAL'.
      ELSEIF WA_TAB5-MTART EQ 'ZVRP'.
        PMVAL =  V1.
        WA_TAB6-IMAKTX = 'PM SUBTOTAL'.
      ENDIF.
      CLEAR : RV2.
      RV2 = V2.
      WA_TAB6-V2 = RV2.
      WA_TAB6-V1 = V1.


      CONDENSE:  WA_TAB6-V2, WA_TAB6-V1.
      APPEND WA_TAB6 TO IT_TAB6.
      CLEAR WA_TAB6.
      CLEAR : V1,V2,RV1,RV2.
    ENDAT.
    CLEAR WA_TAB6.
  ENDLOOP.
*  BREAK-POINT.
  RMPMTOT = RMVAL + PMVAL.
*  BREAK-POINT.
*  IF RMPMTOT CS '*'.
**    BREAK-POINT.
*  ELSE.
    CONDENSE: RMVAL, PMVAL,RMPMTOT.
*  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM2 .

  SELECT * from ZPRODBATCHES INTO TABLE @DATA(it_ZPRODBATCHES) FOR ALL ENTRIES IN @it_ztp_cost11 WHERE matnr = @it_ztp_cost11-matnr
                                                                                  and kunnr = @it_ztp_cost11-fglifnr.    " added by madhuri on 03/11/2025

  READ TABLE IT_ZTP_COST11 INTO WA_ZTP_COST11 WITH KEY GJAHR = WA_CHECK-GJAHR VBELN = WA_CHECK-VBELN.
  IF SY-SUBRC EQ 0.
    WERKS = WA_ZTP_COST11-WERKS.
    MATERIAL = WA_ZTP_COST11-MATNR.
    FGLIFNR = WA_ZTP_COST11-FGLIFNR.
    STLAL = WA_ZTP_COST11-STLAL.
    R2 = WA_ZTP_COST11-R2.
    P2 = WA_ZTP_COST11-P2.
    RP1 = WA_ZTP_COST11-RP1.
    M1 = WA_ZTP_COST11-M1.
    CCPC = WA_ZTP_COST11-CCPC.
    CCPCV1 = WA_ZTP_COST11-CCPC.
    ANAVAL = WA_ZTP_COST11-ANAVAL.
    ANART = WA_ZTP_COST11-ANART.
    GSTVAL1 = WA_ZTP_COST11-GSTVAL1.
    NET = WA_ZTP_COST11-NET.
    MARGIN = WA_ZTP_COST11-MARGIN.
    FGGST = WA_ZTP_COST11-FGGST.
    BMENG = WA_ZTP_COST11-BMENG.
*    BATSZ = WA_ZTP_COST11-BATSZ.
******************** soc by madhuri by jytsna 3/10//2025
     REad TABLE it_ZPRODBATCHES INTO DATA(wa_ZPRODBATCHES) WITH key matnr = wa_ztp_cost11-matnr
                                                                   kunnr = wa_ztp_cost11-fglifnr.
    IF sy-subrc = 0.
    batsz = wa_ZPRODBATCHEs-batch_size.
    ENDIF.
******************** eoc by madhuri by jytsna 3/10//2025
    RMYLD = WA_ZTP_COST11-RMYLD.
    PMYLD = WA_ZTP_COST11-PMYLD.
    CPUDT = WA_ZTP_COST11-CPUDT.
    RMYLDQTY = BMENG * ( RMYLD / 100 ).
    PMYLDQTY = BMENG * ( PMYLD / 100 ).
    RMYLDQTY1 = RMYLDQTY.
    PMYLDQTY1 = PMYLDQTY.
    YIELD1 = RMYLD.
    YIELD2 = PMYLD.
    CLEAR : TOT1,TOT.
    TOT1 = RP1 + M1 + CCPC + ANART.
    TOT = TOT1.
    CONDENSE TOT.

    CLEAR : BMEIN.
    SELECT SINGLE * FROM MAST WHERE MATNR EQ WA_ZTP_COST11-MATNR AND WERKS EQ WA_ZTP_COST11-WERKS AND STLAN EQ 1  AND STLAL EQ WA_ZTP_COST11-STLAL .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM STKO WHERE STLNR EQ MAST-STLNR AND STLAL EQ MAST-STLAL.
      IF SY-SUBRC EQ 0.
        BMEIN = STKO-BMEIN.
      ENDIF.
    ENDIF.
    QTY1 = BMENG.
    CONDENSE QTY1.
    CONCATENATE  QTY1 BMEIN INTO QTY SEPARATED BY SPACE.
    CONDENSE QTY.
    CLEAR : PACK.
    SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_ZTP_COST11-MATNR AND VKORG EQ '1000' AND VTWEG EQ '10'.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM TVM5T WHERE MVGR5 EQ MVKE-MVGR5.
      IF SY-SUBRC EQ 0.
        PACK = TVM5T-BEZEI.
      ENDIF.
    ENDIF.
    FGLIFNR = WA_ZTP_COST11-FGLIFNR.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_ZTP_COST11-FGLIFNR.
    IF SY-SUBRC EQ 0.
      FGNAME1 = LFA1-NAME1.
    ENDIF.
    SELECT SINGLE * FROM MAKT WHERE MATNR EQ WA_ZTP_COST11-MATNR AND SPRAS EQ 'EN'.
    IF SY-SUBRC EQ 0.
      MAKTX = MAKT-MAKTX.
    ENDIF.

    CLEAR : UOM.
    SELECT SINGLE * FROM MARM WHERE MATNR EQ MATERIAL AND MEINH IN ( 'L','KG' ).
    IF SY-SUBRC EQ 0.
      UOM = MARM-MEINH.
    ENDIF.
    IF UOM EQ SPACE.
      UOM = 'PC'.
    ENDIF.
    CONDENSE BATSZ.
    CONCATENATE BATSZ UOM INTO BATSZ SEPARATED BY SPACE.
    CONDENSE : RMYLDQTY1,PMYLDQTY1.
    CONDENSE: FGNAME1,MAKTX,MATERIAL,PACK,QTY,YIELD1,YIELD2,R2,P2,RP1,M1,CCPC,ANAVAL,ANART,GSTVAL1,NET,MARGIN,FGGST,BATSZ,RMYLDQTY1,PMYLDQTY1,UOM,TOT.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SEARCHHELP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  FORM3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM3 .
  CLEAR : PRODSTAT, PRODDT, PRODNAME, PRODTXT.
  CLEAR : PURSTAT, PURDT, PURNAME, PURTXT.
  CLEAR : FISTAT, FIDT, FINAME, FITXT.
  CLEAR : ACCTSTAT, ACCTDT, ACCTNAME, ACCTTXT.
  CLEAR : FINALSTAT, FINALDT, FINALNAME, FINALTXT.

  SELECT SINGLE * FROM ZTP_COST14 WHERE VBELN EQ WA_CHECK-VBELN AND GJAHR EQ WA_CHECK-GJAHR.
  IF SY-SUBRC EQ 0.
**********************************************************************************************************
    IF ZTP_COST14-PRODAPR EQ 'X'.
      PRODSTAT = 'APPROVED'.
    ELSEIF ZTP_COST14-PRODREJ EQ 'X'.
      PRODSTAT = 'REJECTED'.
    ELSE.
      PRODSTAT = SPACE.
    ENDIF.
    PRODDT = ZTP_COST14-PRODDT.
    SELECT SINGLE * FROM PA0001 WHERE PERNR EQ ZTP_COST14-PROD AND ENDDA GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      PRODNAME = PA0001-ENAME.
    ENDIF.
    PRODTXT = ZTP_COST14-PRODTXT.
*********************************************************************************************

    IF ZTP_COST14-PURAPR EQ 'X'.
      PURSTAT = 'APPROVED'.
    ELSEIF ZTP_COST14-PURREJ EQ 'X'.
      PURSTAT = 'REJECTED'.
    ELSE.
      PURSTAT = SPACE.
    ENDIF.
    PURDT = ZTP_COST14-PURDT.
    SELECT SINGLE * FROM PA0001 WHERE PERNR EQ ZTP_COST14-PUR AND ENDDA GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      PURNAME = PA0001-ENAME.
    ENDIF.
    PURTXT = ZTP_COST14-PURTXT.
*************************************************
**********************************************************************************************************
    IF ZTP_COST14-ACCTAPR EQ 'X'.
      ACCTSTAT = 'APPROVED'.
    ELSEIF ZTP_COST14-ACCTREJ EQ 'X'.
      ACCTSTAT = 'REJECTED'.
    ELSE.
      ACCTSTAT = SPACE.
    ENDIF.
    ACCTDT = ZTP_COST14-ACCTDT.
    SELECT SINGLE * FROM PA0001 WHERE PERNR EQ ZTP_COST14-ACCT AND ENDDA GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      ACCTNAME = PA0001-ENAME.
    ENDIF.
    ACCTTXT = ZTP_COST14-ACCTTXT.
**********************************************************************************************************
    IF ZTP_COST14-FIAPR EQ 'X'.
      FISTAT = 'APPROVED'.
    ELSEIF ZTP_COST14-FIREJ EQ 'X'.
      FISTAT = 'REJECTED'.
    ELSE.
      FISTAT = SPACE.
    ENDIF.
    FIDT = ZTP_COST14-FIDT.
    SELECT SINGLE * FROM PA0001 WHERE PERNR EQ ZTP_COST14-FI AND ENDDA GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      FINAME = PA0001-ENAME.
    ENDIF.
    FITXT = ZTP_COST14-FITXT.
**********************************************************************************************************
    IF ZTP_COST14-FINALAPR EQ 'X'.
      FINALSTAT = 'APPROVED'.
    ELSEIF ZTP_COST14-FINALREJ EQ 'X'.
      FINALSTAT = 'REJECTED'.
    ELSE.
      FINALSTAT = SPACE.
    ENDIF.
    FINALDT = ZTP_COST14-FINALDT.
    SELECT SINGLE * FROM PA0001 WHERE PERNR EQ ZTP_COST14-FINAL AND ENDDA GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      FINALNAME = PA0001-ENAME.
    ENDIF.
    FINALTXT = ZTP_COST14-FINALTXT.

  ENDIF.
ENDFORM.
