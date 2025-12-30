REPORT ZBCLLMM_STD_COSTSHEET_SUMM  NO STANDARD PAGE HEADING LINE-COUNT
60 LINE-SIZE 155.
*--------------------------------------------------------------------*
*--This report is for the standard cost sheet printing SUMMARY       *
*--Request given by Mr. Sonawane - accounts  and developed by Anjali *
*--Started ON 21.11.04                                               *
*--------------------------------------------------------------------*

*--Table Declerations -----------------------------------------------*

TABLES : MAKT,
         MARC,
         MARA,
         T001W,
         MVKE,
         TVM5T,
         MBEW,
         MAST,
         STKO,
         KOTN502,
         KONDN,
         ZCOST_LOT,
         STPO.

*--Data Declerations ------------------------------------------------*

DATA : BEGIN OF T_DETMAST OCCURS 0,
         MATNR LIKE MAST-MATNR,
         WERKS LIKE MAST-WERKS,
         STLNR LIKE MAST-STLNR,
       END OF T_DETMAST.
DATA : BEGIN OF T_DETAILS OCCURS 0,
         STLNR LIKE STPO-STLNR,
         IDNRK LIKE STPO-IDNRK,
         MEINS LIKE STPO-MEINS,
         MENGE LIKE STPO-MENGE,
       END OF T_DETAILS.
DATA :BEGIN OF T_DETSUMM OCCURS 0,
        MATNR      LIKE MAST-MATNR,
        RMRT       LIKE  MBEW-STPRS,
        PMRT       LIKE MBEW-STPRS,
        MFGRT      LIKE MBEW-STPRS,
        ASSVAL     LIKE ZCOST_LOT-VALUE,
        EDRT(13)   TYPE P DECIMALS 2,
        NSVRT      LIKE MBEW-STPRS,
        COGRT(13)  TYPE P DECIMALS 2,
        MRPRT      LIKE ZCOST_LOT-ZNET_VAL,
        CHRGQTY(8) TYPE P,
        FREQTY(8)  TYPE P,
      END OF T_DETSUMM.

DATA : W_STLNR      LIKE MAST-STLNR,
       W_BMENG(10)  TYPE I,
       W_BMENG1(10) TYPE I,
       W_BMENG2     LIKE STKO-BMENG,
       W_MVGR5      LIKE MVKE-MVGR5,
       W_DECON_IND  LIKE MVKE-KONDM,
       W_RATE       LIKE MBEW-STPRS,
       W_RMRT       LIKE MBEW-STPRS,
       W_PMRT       LIKE MBEW-STPRS,
       W_MFGRT      LIKE MBEW-STPRS,
       W_TOTRT      LIKE MBEW-STPRS,
       W_ASSVAL     LIKE ZCOST_LOT-VALUE,
       W_EDRT(13)   TYPE P DECIMALS 2,
       W_EDRT1(13)  TYPE P DECIMALS 2,
       W_TOTRT1     LIKE MBEW-STPRS,
       W_RETPR(13)  TYPE P DECIMALS 2,
       W_WSPR(13)   TYPE P DECIMALS 2,
       W_NSV        LIKE MBEW-STPRS,
       W_COG(13)    TYPE P DECIMALS 2,
       W_VALUE(13)  TYPE P DECIMALS 2,
       W_TVALUE(13) TYPE P DECIMALS 2,
       W_MTART      LIKE MARA-MTART,
       W_FLAG(1)    TYPE C,
       FROMQTY(15)  TYPE C,
       FREEQTY(15)  TYPE C,
       W_MATNR      LIKE MAST-MATNR,
       W_BEZEI      LIKE TVM5T-BEZEI.
*--Selection screen --------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001 .
SELECT-OPTIONS  : S_MATNR FOR MAST-MATNR.
PARAMETERS : P_WERKS LIKE MAST-WERKS OBLIGATORY.
PARAMETERS : P_DATE LIKE STPO-DATUV OBLIGATORY.
SELECTION-SCREEN END OF BLOCK B1.


*--Start-of-selection ------------------------------------------------*
PERFORM COLLECT_DATA.
PERFORM COLLECT_STPO_DATA.
*IF p_werks = '3000'.
*  PERFORM collect_3000_rate.
*ELSE.
*  PERFORM collect_rate.
*ENDIF.

IF P_WERKS = '1000' OR P_WERKS = '1001'.
  PERFORM COLLECT_RATE.
ELSE.
  PERFORM COLLECT_3000_RATE.
ENDIF.


PERFORM PRINT-PARA.

TOP-OF-PAGE.
  WRITE  :/38 'BLUE CROSS LABORATORIES LTD.'.
  WRITE  :/25 'COST SHEET SUMMARY AS ON :',
           55 P_DATE.
  ULINE.
  WRITE :/1 'CODE',
          11 '     DESCRIPTION',
          48 'PACK SZ',
          60 'RM.RT.',
          68 'PM.RT.',
          76 'CC PC ',
          84 'TOTAL ',
          92 'ED +  ',
         100 'TOTAL ',
         108 '  NSV ',
         116 ' COG %',
         124 ' MRP  ',
         132 'BONUS SCHEME',
         148 '  COG% '.
  WRITE :/84 'EX.ED ',
          92 ' CESS ',
         100 ' COG  ',
         132 'CHRGED',
         140 'FREE  '.

  ULINE.

END-OF-PAGE.

*---------------------------------------------------------------------*
*       FORM collect_data                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM COLLECT_DATA.

  SELECT * FROM MAST WHERE MATNR IN S_MATNR AND WERKS = P_WERKS AND
STLAN = '1'.
    SELECT SINGLE * FROM MARC WHERE MATNR = MAST-MATNR AND WERKS = P_WERKS.
    IF MARC-LVORM = 'X'.
    ELSE.
      SELECT SINGLE *  FROM MARA  WHERE MATNR = MAST-MATNR.
      IF MARA-MTART NE 'ZHLB'.
        MOVE-CORRESPONDING MAST TO T_DETMAST.
        APPEND T_DETMAST.
      ENDIF.
    ENDIF.
    CLEAR T_DETMAST.
  ENDSELECT.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM collect_stpo_data                                        *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM COLLECT_STPO_DATA.
  LOOP AT T_DETMAST.
    SELECT * FROM STPO WHERE STLNR = T_DETMAST-STLNR.
      MOVE-CORRESPONDING STPO TO T_DETAILS.
      APPEND T_DETAILS.
      CLEAR T_DETAILS.
    ENDSELECT.
  ENDLOOP.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM collect_rate                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM COLLECT_RATE.
  SORT T_DETAILS BY STLNR IDNRK DESCENDING.
  LOOP AT T_DETMAST.
    MOVE  T_DETMAST-MATNR TO T_DETSUMM-MATNR.
    ON CHANGE OF T_DETMAST-MATNR.
      W_TVALUE = 0.
      MOVE  T_DETMAST-MATNR TO T_DETSUMM-MATNR.
    ENDON.
    LOOP AT T_DETAILS WHERE STLNR = T_DETMAST-STLNR.
      SELECT SINGLE * FROM MARA WHERE MATNR = T_DETAILS-IDNRK.
      IF MARA-MTART = 'ZHLB'.
        PERFORM PRINT_RAW_DATA.
      ELSE.
        SELECT SINGLE * FROM MAKT WHERE MATNR = T_DETAILS-IDNRK.
        SELECT SINGLE * FROM MBEW WHERE MATNR = T_DETAILS-IDNRK AND BWKEY =
                        P_WERKS.
        IF SY-SUBRC = 4.
          W_RATE = 0.
        ELSE.
          IF MBEW-BWPRH EQ 0.
            W_RATE = ( MBEW-VERPR / MBEW-PEINH ).
          ELSE.
            W_RATE = MBEW-BWPRH.
          ENDIF.
        ENDIF.
        W_VALUE = W_RATE * T_DETAILS-MENGE.
        W_TVALUE = W_TVALUE + W_VALUE.
      ENDIF.
    ENDLOOP.
    IF W_BMENG1 = 0.
      W_BMENG1  = 1.
    ENDIF.
    W_RATE = W_TVALUE / W_BMENG1.
    W_PMRT = W_RATE.
    MOVE W_PMRT TO T_DETSUMM-PMRT.
    W_TVALUE = 0.
*** area  for other rates
    W_MATNR = T_DETMAST-MATNR.
    SHIFT W_MATNR LEFT DELETING LEADING '0'.
    CONCATENATE 'C' W_MATNR INTO W_MATNR.
    SELECT SINGLE * FROM MBEW WHERE MATNR = W_MATNR AND BWKEY =
 P_WERKS.
    W_MFGRT = 0.
    IF SY-SUBRC = '0'.
      W_MFGRT =  MBEW-STPRS.
    ENDIF.
    MOVE W_MFGRT TO T_DETSUMM-MFGRT.
    W_TOTRT = W_RMRT + W_PMRT + W_MFGRT.
    SELECT SINGLE * FROM MARA WHERE MATNR = T_DETMAST-MATNR.
    IF MARA-MTART = 'ZFRT' OR MARA-MTART = 'ZDSM'.
      PERFORM ASSE-PARA.
    ENDIF.
    IF MARA-MTART = 'ZFRT'.
      PERFORM COG-PARA.
    ENDIF.
    PERFORM BONUS-PARA.
    APPEND T_DETSUMM.
    CLEAR T_DETSUMM.
  ENDLOOP.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM ASSE-PARA                                                *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM ASSE-PARA.
  SELECT SINGLE * FROM ZCOST_LOT WHERE MATNR = T_DETMAST-MATNR AND ZWERKS
        = P_WERKS.
  W_ASSVAL = 0.
  IF SY-SUBRC = '0'.
    W_ASSVAL = ZCOST_LOT-VALUE.
  ENDIF.
  MOVE W_ASSVAL TO T_DETSUMM-ASSVAL.
  W_EDRT = 0.
  IF W_ASSVAL NE 0.
*** to include cess 16.32
    W_EDRT = W_ASSVAL * ( 16 / 100 ).
    W_EDRT1 = W_EDRT.
    W_EDRT = W_EDRT + ( W_EDRT * ( 2 / 100 ) ).
  ENDIF.
  MOVE W_EDRT TO T_DETSUMM-EDRT.
  W_TOTRT1 = W_TOTRT + W_EDRT.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM COG-PARA                                                 *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM COG-PARA.
** TO GET DE - CONTROL INDICATOR
  SELECT SINGLE * FROM MVKE WHERE MATNR = T_DETMAST-MATNR AND VKORG =
  '1000'.
  IF SY-SUBRC = '0'.
    W_DECON_IND = MVKE-KONDM.
  ENDIF.
  IF W_DECON_IND = '02'.
    PERFORM DECO-PARA.
  ELSE.
    PERFORM CONTR-PARA.
  ENDIF.
*  W_NSV = W_ASSVAL + W_EDRT1.
  MOVE W_NSV TO T_DETSUMM-NSVRT.
  IF W_NSV = 0.
    W_COG = 0.
  ELSE.
    W_COG = ( W_TOTRT1 / W_NSV ) * 100.
  ENDIF.
  MOVE W_COG TO T_DETSUMM-COGRT.
  MOVE  ZCOST_LOT-ZNET_VAL TO T_DETSUMM-MRPRT.
ENDFORM.


*---------------------------------------------------------------------*
*       FORM PRINT_RAW_DATA                                           *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM PRINT_RAW_DATA.
  SELECT SINGLE STLNR  FROM MAST INTO W_STLNR WHERE MATNR =
 T_DETAILS-IDNRK AND WERKS = T_DETMAST-WERKS.
  SELECT SINGLE * FROM STKO WHERE STLNR = W_STLNR.
  SELECT SINGLE BMENG  FROM STKO INTO W_BMENG WHERE STLNR =
   T_DETAILS-STLNR.
  SELECT SINGLE MVGR5 FROM MVKE INTO W_MVGR5 WHERE MATNR =
  T_DETMAST-MATNR.
  MOVE ' ' TO W_BEZEI.
  IF SY-SUBRC = 0.
    SELECT SINGLE BEZEI FROM  TVM5T INTO W_BEZEI WHERE MVGR5 = W_MVGR5.
  ENDIF.
  W_BMENG2 = W_BMENG * ( 98 / 100 ).
  W_BMENG1 = W_BMENG2.
  SELECT * FROM STPO WHERE STLNR = W_STLNR.
    SELECT SINGLE * FROM MAKT WHERE MATNR = STPO-IDNRK.
    SELECT SINGLE * FROM MBEW WHERE MATNR = STPO-IDNRK AND BWKEY = P_WERKS.
    IF SY-SUBRC = 4.
      W_RATE = 0.
    ELSE.
      IF MBEW-BWPRH EQ 0.
        W_RATE = ( MBEW-VERPR / MBEW-PEINH ).
      ELSE.
        W_RATE = MBEW-BWPRH.
      ENDIF.
    ENDIF.
    W_VALUE = W_RATE * STPO-MENGE.
    W_TVALUE = W_TVALUE + W_VALUE.
  ENDSELECT.
  W_RATE = W_TVALUE / W_BMENG1.
  W_RMRT = W_RATE.
  MOVE W_RMRT TO T_DETSUMM-RMRT.
  W_TVALUE = 0.
ENDFORM.


*---------------------------------------------------------------------*
*       FORM collect_3000_rate                                        *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM COLLECT_3000_RATE.
  SORT T_DETAILS BY STLNR IDNRK.
  LOOP AT T_DETMAST.
    MOVE  T_DETMAST-MATNR TO T_DETSUMM-MATNR.
    ON CHANGE OF T_DETMAST-MATNR.
      W_TVALUE = 0.
      W_FLAG = 0.
      MOVE  T_DETMAST-MATNR TO T_DETSUMM-MATNR.
      SELECT SINGLE * FROM STKO WHERE STLNR = T_DETMAST-STLNR.
      W_BMENG = STKO-BMENG.
      SELECT SINGLE MVGR5 FROM MVKE INTO W_MVGR5 WHERE MATNR =
      T_DETMAST-MATNR.
      MOVE ' ' TO W_BEZEI.
      IF SY-SUBRC = 0.
        SELECT SINGLE BEZEI FROM  TVM5T INTO W_BEZEI WHERE MVGR5 = W_MVGR5.
      ENDIF.
      W_BMENG2 = W_BMENG * ( 98 / 100 ).
      W_BMENG1 = W_BMENG2.
    ENDON.
    LOOP AT T_DETAILS WHERE STLNR = T_DETMAST-STLNR.
      IF W_FLAG = 0.
        SELECT SINGLE MTART FROM MARA INTO W_MTART WHERE MATNR =
   T_DETAILS-IDNRK.
        W_FLAG = 1.
      ENDIF.
      SELECT SINGLE * FROM MARA  WHERE MATNR = T_DETAILS-IDNRK.
      IF W_MTART NE MARA-MTART.
        IF W_BMENG1 = 0.
          W_BMENG1  = 1.
        ENDIF.
        W_RATE = W_TVALUE / W_BMENG1.
        W_RMRT = W_RATE.
        MOVE W_RMRT TO T_DETSUMM-RMRT.
        W_TVALUE = 0.
        W_MTART = MARA-MTART.
      ENDIF.

      SELECT SINGLE * FROM MAKT WHERE MATNR = T_DETAILS-IDNRK.
      SELECT SINGLE * FROM MBEW WHERE MATNR = T_DETAILS-IDNRK AND BWKEY =
                P_WERKS.
      IF SY-SUBRC = 4.
        W_RATE = 0.
      ELSE.
        IF MBEW-BWPRH EQ 0.
          W_RATE = ( MBEW-VERPR / MBEW-PEINH ).
        ELSE.
          W_RATE = MBEW-BWPRH.
        ENDIF.
      ENDIF.
      W_VALUE = W_RATE * T_DETAILS-MENGE.
      W_TVALUE = W_TVALUE + W_VALUE.
    ENDLOOP.
    IF W_BMENG1 = 0.
      W_BMENG1  = 1.
    ENDIF.
    W_RATE = W_TVALUE / W_BMENG1.
    W_PMRT = W_RATE.
    MOVE W_PMRT TO T_DETSUMM-PMRT.
    W_TVALUE = 0.
*** area  for other rates
    W_MATNR = T_DETMAST-MATNR.
    SHIFT W_MATNR LEFT DELETING LEADING '0'.
    CONCATENATE 'C' W_MATNR INTO W_MATNR.
    SELECT SINGLE * FROM MBEW WHERE MATNR = W_MATNR AND BWKEY =
 P_WERKS.
    W_MFGRT = 0.
    IF SY-SUBRC = '0'.
      W_MFGRT =  MBEW-STPRS.
    ENDIF.
    MOVE W_MFGRT TO T_DETSUMM-MFGRT.
    W_TOTRT = W_RMRT + W_PMRT + W_MFGRT.
    SELECT SINGLE * FROM MARA WHERE MATNR = T_DETMAST-MATNR.
    IF MARA-MTART = 'ZFRT' OR MARA-MTART = 'ZDSM'.
      PERFORM ASSE-PARA.
    ENDIF.
    IF MARA-MTART = 'ZFRT'.
      PERFORM COG-PARA.
    ENDIF.
    APPEND T_DETSUMM.
    CLEAR T_DETSUMM.
  ENDLOOP.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM BONUS-PARA                                               *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM BONUS-PARA.
  MOVE 0 TO T_DETSUMM-CHRGQTY.
  MOVE 0 TO T_DETSUMM-FREQTY.
  SELECT * FROM KOTN502 WHERE VKORG = P_WERKS AND MATNR =
T_DETMAST-MATNR.
    IF SY-SUBRC = 0.
      IF P_DATE BETWEEN KOTN502-DATAB AND KOTN502-DATBI.
        SELECT SINGLE *  FROM KONDN WHERE KNUMH = KOTN502-KNUMH.
        IF SY-SUBRC = 0.
          FROMQTY = KONDN-KNRNM.
          FREEQTY = KONDN-KNRZM.
          FROMQTY = FROMQTY - FREEQTY.
          FREEQTY = FREEQTY * 1.
          SHIFT FROMQTY LEFT DELETING LEADING SPACE.
          SHIFT FREEQTY LEFT DELETING LEADING SPACE.
          MOVE FROMQTY TO T_DETSUMM-CHRGQTY.
          MOVE FREEQTY TO T_DETSUMM-FREQTY.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDSELECT.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM PRINT-PARA                                               *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM PRINT-PARA.
  SORT T_DETSUMM BY MATNR.
  LOOP AT T_DETSUMM.
    SELECT SINGLE * FROM MVKE WHERE MATNR = T_DETSUMM-MATNR.
    IF SY-SUBRC = 0.
      SELECT SINGLE * FROM TVM5T WHERE SPRAS  = 'EN' AND MVGR5 = MVKE-MVGR5.
    ENDIF.
    SELECT SINGLE * FROM MAKT WHERE MATNR = T_DETSUMM-MATNR.
    WRITE :/1(9) T_DETSUMM-MATNR,
            11(35) MAKT-MAKTX,
            48(10) TVM5T-BEZEI,
            60(7) T_DETSUMM-RMRT  NO-ZERO,
            68(7) T_DETSUMM-PMRT  NO-ZERO,
            76(7) T_DETSUMM-MFGRT  NO-ZERO.
    W_TVALUE = T_DETSUMM-RMRT + T_DETSUMM-PMRT + T_DETSUMM-MFGRT.
    WRITE :84(7) W_TVALUE  NO-ZERO,
           92(7) T_DETSUMM-EDRT  NO-ZERO.
    W_TVALUE  = W_TVALUE + T_DETSUMM-EDRT.
    WRITE :100(7) W_TVALUE  NO-ZERO,
           108(7) T_DETSUMM-NSVRT  NO-ZERO,
           116(7) T_DETSUMM-COGRT  NO-ZERO,
           124(7) T_DETSUMM-MRPRT  NO-ZERO,
           132(7) T_DETSUMM-CHRGQTY  NO-ZERO,
           140(7) T_DETSUMM-FREQTY  NO-ZERO.
    IF T_DETSUMM-CHRGQTY = 0.
      MOVE 0 TO W_TOTRT1.
    ELSE.
      W_VALUE = ( T_DETSUMM-CHRGQTY * W_TVALUE ) + ( T_DETSUMM-FREQTY * (
      T_DETSUMM-RMRT + T_DETSUMM-PMRT + T_DETSUMM-MFGRT ) ).
      W_TOTRT1 = ( W_VALUE / ( T_DETSUMM-CHRGQTY * T_DETSUMM-NSVRT ) ) * 100.
    ENDIF.
    WRITE 148(7) W_TOTRT1  NO-ZERO.
    SKIP.
  ENDLOOP.
ENDFORM.


FORM DECO-PARA.
  W_RETPR = ( ZCOST_LOT-ZNET_VAL - W_EDRT1 ) * ( 80 / 100 ).
  W_WSPR = ( W_RETPR * ( 90 / 100 ) ).
  W_NSV = W_WSPR + W_EDRT1.
ENDFORM.

FORM CONTR-PARA.
  W_RETPR = ( ZCOST_LOT-ZNET_VAL - W_EDRT1 ) * ( 84 / 100 ).
  W_WSPR = ( W_RETPR * ( 92 / 100 ) ).
  W_NSV = W_WSPR + W_EDRT1.
ENDFORM.
