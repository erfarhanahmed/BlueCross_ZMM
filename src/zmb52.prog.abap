*&---------------------------------------------------------------------*
*& Report ZBCLLSD_DLYSTK_BAT_SHPSZ7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBCLLSD_DLYSTK_BAT_SHPSZ7.

* developed by anjali for BSR nasik and Goa
* Original prog is ZDBS - changes are made by Jyotsna - 26.5.2009
** added purchase price for SPR & ADDED - jYOTSNA11.9.24
TABLES : MCHA,
         MCHB,
         MARM,
         A602,
         KONP,
         MAKT,
         T001W,
         MSEG,
         QALS,
         A501,
         A611,
         MARA,
         AFPO,
         AUFK,
         AFRU,
         A609,
         ADRC,
         ZSHIPPER,
         EKPO.

TYPE-POOLS:  SLIS.

DATA: G_REPID     LIKE SY-REPID,
      FIELDCAT    TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT LIKE LINE OF FIELDCAT,
      SORT        TYPE SLIS_T_SORTINFO_ALV,
      WA_SORT     LIKE LINE OF SORT,
      LAYOUT      TYPE SLIS_LAYOUT_ALV.
DATA: IT_MSEG TYPE TABLE OF MSEG,
      WA_MSEG TYPE MSEG.

TYPES : BEGIN OF ITAS1,
          MATNR       LIKE MCHB-MATNR,
          MAKTX       LIKE MAKT-MAKTX,
          LGORT       LIKE MCHB-LGORT,
          CHARG       LIKE MCHB-CHARG,
          VFDAT       LIKE MCHA-VFDAT,
          HSDAT       LIKE MCHA-HSDAT,
          STOCK       TYPE MCHB-CLABS,
          STOCK1      TYPE MCHB-CLABS,
          STATUS(2)   TYPE C,
          ABLAD       LIKE MSEG-ABLAD,
          W_REM(15)   TYPE C,
          W_KBETR1(7) TYPE C,
          ZEX2        TYPE P DECIMALS 2,
          W_KBETR2    LIKE KONP-KBETR,
          JMOD        TYPE KONP-KBETR,
          BRGEW       TYPE MARA-BRGEW,
          NTGEW       TYPE MARA-NTGEW,
          IEDD        TYPE AFRU-IEDD,
          TEXT1(50)   TYPE C,
          MENGE       TYPE MSEG-MENGE,
          TEXT2(1000) TYPE C,
          ZSAM        TYPE KONV-KBETR,
          ZSMP        TYPE KONV-KBETR,
          """""""""""""""""""""""""""""""""
          MFRNR       TYPE EKPO-MFRNR,
          NAME1       TYPE LFA1-NAME1,
          CLABS       TYPE MCHB-CLABS,
          CINSM       TYPE MCHB-CINSM,
          CSPEM       TYPE MCHB-CSPEM,
          VERPR       TYPE MBEW-VERPR,
          PEINH       TYPE MBEW-PEINH,
          MBLNR       TYPE MSEG-MBLNR,
          BUDAT       TYPE MKPF-BUDAT,
          LIFNR       TYPE LFA1-LIFNR,
          VED_NAME    TYPE LFA1-NAME1,

          MENGE1      TYPE EKPO-MFRNR,
          MENGE3      TYPE EKBE-MENGE,
          OPN_QTY     TYPE EKBE-MENGE,

          TOT_QTY     TYPE EKBE-MENGE,
          TOT_VLUE    TYPE EKBE-MENGE,
          BATCHNO     TYPE CLBATCH-ATWTB,
        END OF ITAS1.

TYPES : BEGIN OF ITAB2,
          MATNR      LIKE MCHB-MATNR,
          MAKTX      LIKE MAKT-MAKTX,
          LGORT      LIKE MCHB-LGORT,
          CHARG      LIKE MCHB-CHARG,
          VFDAT      LIKE MCHA-VFDAT,
          HSDAT      LIKE MCHA-HSDAT,
          STOCK(15)  TYPE C,
          STOCK1(15) TYPE C,
          W_REM(15)  TYPE C,
          MRPSAM(10) TYPE C,
*          W_KBETR1(7) TYPE C,
*          ZEX2        TYPE P DECIMALS 2,
*          W_KBETR2    LIKE KONP-KBETR,
*          JMOD        TYPE KONP-KBETR,
*          BRGEW       TYPE MARA-BRGEW,
*          NTGEW       TYPE MARA-NTGEW,
*          IEDD        TYPE AFRU-IEDD,
*          TEXT1(50)   TYPE C,
*          MENGE       TYPE MSEG-MENGE,
*          TEXT2(1000) TYPE C,
*          ZSAM        TYPE KONV-KBETR,
        END OF ITAB2.

DATA: ABLAD(500) TYPE C.

TYPES: BEGIN OF SMP1,
         MATNR TYPE MARA-MATNR,
         CHARG TYPE MCHB-CHARG,
       END OF SMP1.
DATA : IT_TAS1 TYPE TABLE OF ITAS1,
       WA_TAS1 TYPE ITAS1,
       IT_TAB2 TYPE TABLE OF ITAB2,
       WA_TAB2 TYPE ITAB2,
       IT_SMP1 TYPE TABLE OF SMP1,
       WA_SMP1 TYPE SMP1.



DATA : BEGIN OF ITAB OCCURS 0,
         MATNR     LIKE MCHB-MATNR,
         MAKTX     LIKE MAKT-MAKTX,
         LGORT     LIKE MCHB-LGORT,
         CHARG     LIKE MCHB-CHARG,
         VFDAT     LIKE MCHA-VFDAT,
         HSDAT     LIKE MCHA-HSDAT,
         STOCK     TYPE MCHB-CLABS,
         STOCK1    TYPE MCHB-CLABS,
         STATUS(2) TYPE C,
         ABLAD     LIKE MSEG-ABLAD.

DATA : END OF ITAB.
DATA : BEGIN OF W-MCHB OCCURS 0.
         INCLUDE STRUCTURE  MCHB.
DATA : END OF W-MCHB.

DATA : W_VFDAT LIKE MCHA-VFDAT.
DATA : W_HSDAT LIKE MCHA-HSDAT.
DATA : W_MAKTX LIKE MAKT-MAKTX.
DATA : W_NAME3 LIKE T001W-NAME1.
DATA : W_TOTQTY LIKE MCHB-CLABS.
DATA : W_TOTQTY1 LIKE MCHB-CLABS.
DATA : W_UMREZ LIKE MARM-UMREZ.
DATA : W_UMREZ1(6) TYPE C.
DATA : W_REM(15) TYPE C.
DATA : W_REMK(15) TYPE C.
DATA : W_FQTY(6)  TYPE C.
DATA : W_SQTY(6) TYPE C .
DATA : W_FQTY1(6) TYPE C.
DATA : W_SQTY1(6) TYPE C.
DATA : W_KNUMH LIKE A602-KNUMH.
DATA : W_KBETR LIKE KONP-KBETR.
DATA : W_KNUMH1 LIKE A602-KNUMH.
DATA : W_KBETR2 LIKE KONP-KBETR.
DATA : W_KBETR1(7) TYPE C,
       JMOD        TYPE KONP-KBETR,
       ZEX2        TYPE P DECIMALS 2.
DATA: MTART TYPE MARA-MTART.
DATA:  RATE TYPE EKPO-NETPR.

DATA : A1 TYPE P DECIMALS 2,
       A2 TYPE P DECIMALS 2,
       A3 TYPE P DECIMALS 2.

DATA : MATNR TYPE MARA-MATNR.

DATA : V_FM TYPE RS38L_FNAM.
DATA : FORMAT(100) TYPE C.

TYPES: BEGIN OF TYP_T001W,
         WERKS TYPE WERKS_D,
         NAME1 TYPE NAME1,
       END OF TYP_T001W.

DATA : ITAB_T001W TYPE TABLE OF TYP_T001W,
       WA_T001W   TYPE TYP_T001W.
DATA : MSG TYPE STRING.
DATA: KUNNR     TYPE T001W-KUNNR,
      ADDR(100) TYPE C.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE WITH FRAME TITLE TEXT-001.
  PARAMETERS : P_PLANT LIKE MCHB-WERKS,
               P_LFROM LIKE MCHB-LGORT,
               P_LTO   LIKE MCHB-LGORT.
SELECTION-SCREEN END OF BLOCK MERKMALE.
SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
  PARAMETERS : R1 RADIOBUTTON GROUP R1,
               R2 RADIOBUTTON GROUP R1,
               R3 RADIOBUTTON GROUP R1,
               R4 RADIOBUTTON GROUP R1.
SELECTION-SCREEN END OF BLOCK MERKMALE1.

INITIALIZATION.
  G_REPID = SY-REPID.

AT SELECTION-SCREEN.
  PERFORM AUTHORIZATION.

START-OF-SELECTION.

  IF R4 EQ 'X'.
    CALL TRANSACTION 'ZSHIPPER'.
  ELSE.

    SELECT SINGLE * FROM T001W WHERE WERKS EQ P_PLANT.
    IF SY-SUBRC EQ 0.
      IF P_PLANT EQ '1000'.
        KUNNR = T001W-ORT01.
      ELSE.
        KUNNR = T001W-KUNNR.
      ENDIF.
      CLEAR : ADDR.
      SELECT SINGLE * FROM ADRC WHERE ADDRNUMBER EQ T001W-ADRNR.
      IF SY-SUBRC EQ 0.
        ADDR = ADRC-NAME2 .
*        CONCATENATE adrc-name2 adrc-name3 INTO addr.
      ENDIF.
    ENDIF.

    SELECT * FROM MCHB INTO TABLE W-MCHB WHERE WERKS = P_PLANT AND ( LGORT BETWEEN P_LFROM AND P_LTO ).

    LOOP AT W-MCHB.
      W_TOTQTY = W-MCHB-CLABS + W-MCHB-CUMLM + W-MCHB-CINSM + W-MCHB-CEINM + W-MCHB-CSPEM + W-MCHB-CRETM.
      W_TOTQTY1 = W-MCHB-CLABS.
      IF W_TOTQTY GT 0.
*        SELECT SINGLE  VFDAT HSDAT  FROM MCHA INTO (W_VFDAT,W_HSDAT) WHERE MATNR = W-MCHB-MATNR AND WERKS = W-MCHB-WERKS AND CHARG = W-MCHB-CHARG.
        SELECT SINGLE  VFDAT HSDAT  FROM MCH1 INTO (W_VFDAT,W_HSDAT) WHERE MATNR = W-MCHB-MATNR  AND CHARG = W-MCHB-CHARG ." AND werks = w-mchb-werks .
        SELECT SINGLE MAKTX FROM MAKT INTO W_MAKTX WHERE MATNR = W-MCHB-MATNR
                                                     AND SPRAS = SY-LANGU.
        PERFORM ITAB-UPD.
      ENDIF.
    ENDLOOP.



    PERFORM ITAB-PRT.
  ENDIF.
*---------------------------------------------------------------------*
*       FORM itab-upd                                                 *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM ITAB-UPD.

  W_TOTQTY = W-MCHB-CLABS + W-MCHB-CUMLM + W-MCHB-CINSM + W-MCHB-CEINM +
 W-MCHB-CSPEM + W-MCHB-CRETM.
  W_TOTQTY1 = W-MCHB-CLABS.
  CLEAR ITAB.
  ITAB-MATNR = W-MCHB-MATNR.
  ITAB-MAKTX = W_MAKTX.
  ITAB-LGORT = W-MCHB-LGORT.
  ITAB-CHARG = W-MCHB-CHARG.
  ITAB-VFDAT = W_VFDAT.
  ITAB-HSDAT = W_HSDAT.
  ITAB-STOCK = W_TOTQTY.
  ITAB-STOCK1 = W_TOTQTY1.
  IF ITAB-STOCK = ITAB-STOCK1.
    ITAB-STATUS = 'R'.
*       else.
*         itab-status = 'B'.
  ENDIF.

  APPEND ITAB.
ENDFORM.                    "itab-upd

TOP-OF-PAGE.
*  FORMAT COLOR 4.

  SELECT SINGLE NAME1 FROM T001W INTO W_NAME3 WHERE WERKS = P_PLANT.

  WRITE : /1 'Daily Stock Statement (Batchwise)  as on ' ,
          45 SY-DATUM,
          60 'for ',
          65 W_NAME3.
  ULINE.
  WRITE :
*           141 'ZEX2',
*           149 'ZEX2',
*           157 'ZEX2',
*           165 'NEW',
          85 '  Total',
          100 'Unrestricted',
*          148 'ZCIN',
          175 'Gross',
          186 'Net',
          196 'Batch'.


  WRITE : /1  'Matnr.no.',
           13 'Description',
           39 'Stor',
           46 'Batch',
           59 'Exp. date',
           71 'Mfg. Date',
           85 '  Stock',
           100 'Stock',
           110 'Shipper Brk.up',
           137 'MRP',
*           142 '10',
*           150 '20',
*           158 '80',
*           141 'ZEX2',
*           141 'ZSAM',
           149 'ZSAM',
           159 'ZSMP',
           165 'ZCIN',
           175 'Weight',
           186 'Weight',
           198 'Final conf',
           208 'CONTROL SAMPLE STATUS'.

  ULINE.

*   WRITE : /1(8) WA_TAS1-MATNR LEFT-JUSTIFIED,11(25) WA_TAS1-MAKTX LEFT-JUSTIFIED,39(4) WA_TAS1-LGORT,46(10) WA_TAS1-CHARG,
*    59(10) WA_TAS1-VFDAT,71(10) WA_TAS1-HSDAT,84(10) WA_TAS1-STOCK,97(10) WA_TAS1-STOCK1,110(25) WA_TAS1-W_REM,
*    137(7) WA_TAS1-W_KBETR1,147(7) WA_TAS1-ZSAM,157(7) WA_TAS1-ZSMP,166(7) WA_TAS1-W_KBETR2,175 WA_TAS1-BRGEW LEFT-JUSTIFIED,186 WA_TAS1-NTGEW LEFT-JUSTIFIED,
*    196(10) WA_TAS1-IEDD LEFT-JUSTIFIED ,208(15) WA_TAS1-TEXT1 LEFT-JUSTIFIED.
**      137(7) WA_TAS1-W_KBETR1,147(7) WA_TAS1-ZSAM,157(7) WA_TAS1-ZSMP,WA_TAS1-W_KBETR2,166 WA_TAS1-BRGEW LEFT-JUSTIFIED,176 WA_TAS1-NTGEW LEFT-JUSTIFIED,
**    186(10) WA_TAS1-IEDD LEFT-JUSTIFIED ,198(15) WA_TAS1-TEXT1 LEFT-JUSTIFIED.
*    IF WA_TAS1-MENGE NE 0.
*      WRITE : 225 WA_TAS1-MENGE LEFT-JUSTIFIED.
*    ELSE.
*      WRITE : 225 WA_TAS1-TEXT2 LEFT-JUSTIFIED.

*---------------------------------------------------------------------*
*       FORM ITAB-PRT                                                 *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM ITAB-PRT.
  SORT ITAB BY MATNR CHARG.

  SELECT CHARG, EBELN , EBELP , MBLNR, MATNR
  FROM MSEG
   INTO TABLE @DATA(IT_MSEG)
     FOR ALL ENTRIES IN @ITAB
       WHERE CHARG = @ITAB-CHARG
        AND   BWART = '101' .



  IF SY-SUBRC EQ 0 .

    SELECT MBLNR , BUDAT
      FROM MKPF
        FOR ALL ENTRIES IN @IT_MSEG
          WHERE MBLNR = @IT_MSEG-MBLNR
            INTO TABLE @DATA(IT_MKPF) .

    SORT IT_MSEG BY MBLNR DESCENDING .

    SELECT EBELN , MFRNR , EBELP , MENGE
      FROM   EKPO
        INTO TABLE @DATA(IT_EKPO)
          FOR ALL ENTRIES IN @IT_MSEG
            WHERE EBELN = @IT_MSEG-EBELN
            AND   EBELP = @IT_MSEG-EBELP .

    IF SY-SUBRC EQ 0 .


      SELECT EBELN, EBELP , BEWTP , SHKZG , MENGE
        FROM EKBE
         INTO TABLE @DATA(IT_EKBE)
           FOR ALL ENTRIES IN @IT_EKPO
             WHERE EBELN = @IT_EKPO-EBELN
             AND   EBELP = @IT_EKPO-EBELP
             AND   BEWTP = 'E'.




      SELECT NAME1, LIFNR
        FROM LFA1
         INTO TABLE @DATA(IT_LFA1)
           FOR ALL ENTRIES IN @IT_EKPO
             WHERE LIFNR = @IT_EKPO-MFRNR  .


      SELECT * FROM MCHB
        INTO TABLE @DATA(IT_MCHB)
           FOR ALL ENTRIES IN @ITAB
             WHERE MATNR = @ITAB-MATNR
             AND   WERKS = @P_PLANT
             AND   CHARG = @ITAB-CHARG .


      SELECT * FROM MBEW
        INTO TABLE @DATA(IT_MBEW)
          FOR ALL ENTRIES IN @ITAB
           WHERE MATNR = @ITAB-MATNR
            AND  BWKEY = @P_PLANT .
    ENDIF.

    SELECT EBELN, LIFNR
      FROM EKKO
        INTO TABLE @DATA(IT_EKKO)
           FOR ALL ENTRIES IN @IT_MSEG
              WHERE EBELN = @IT_MSEG-EBELN.
    IF SY-SUBRC EQ 0 .
      SELECT NAME1, LIFNR
        FROM LFA1
         INTO TABLE @DATA(IT_LFA2)
           FOR ALL ENTRIES IN @IT_EKKO
             WHERE LIFNR = @IT_EKKO-LIFNR  .
    ENDIF.
  ENDIF.


  LOOP AT ITAB.

    READ TABLE IT_MBEW INTO DATA(WA_BMEW) WITH KEY MATNR = ITAB-MATNR .
    IF SY-SUBRC EQ 0.

      IF  WA_BMEW-VPRSV = 'V'.
        WA_TAS1-VERPR = WA_BMEW-VERPR  .
      ELSEIF WA_BMEW-VPRSV = 'S'..
        WA_TAS1-VERPR = WA_BMEW-STPRS  .
      ENDIF.
      WA_TAS1-PEINH = WA_BMEW-PEINH  .
    ENDIF.


    READ TABLE IT_MCHB INTO DATA(WA_MCHB) WITH KEY MATNR = ITAB-MATNR
                                                   CHARG = ITAB-CHARG .
    IF SY-SUBRC EQ 0 .
      WA_TAS1-CLABS = WA_MCHB-CLABS .
      WA_TAS1-CINSM = WA_MCHB-CINSM .
      WA_TAS1-CSPEM = WA_MCHB-CSPEM .
    ENDIF.


    READ TABLE IT_MSEG INTO DATA(WA_MSEG) WITH KEY  CHARG = ITAB-CHARG
                                                    MATNR = ITAB-MATNR .
    IF SY-SUBRC EQ 0 .

      READ TABLE IT_MKPF INTO DATA(WA_MKPF) WITH KEY MBLNR = WA_MSEG-MBLNR.
      IF SY-SUBRC EQ 0 .
        WA_TAS1-BUDAT = WA_MKPF-BUDAT .
      ENDIF.
      WA_TAS1-MBLNR = WA_MSEG-MBLNR .

      READ TABLE IT_EKKO INTO DATA(WA_EKKO) WITH KEY EBELN = WA_MSEG-EBELN .
      IF SY-SUBRC EQ 0.
        READ TABLE IT_LFA2 INTO DATA(WA_LFA2) WITH KEY LIFNR = WA_EKKO-LIFNR.
        IF SY-SUBRC EQ 0.
          WA_TAS1-LIFNR = WA_LFA2-LIFNR.
          WA_TAS1-VED_NAME = WA_LFA2-NAME1.
        ENDIF.
      ENDIF.
      READ TABLE IT_EKPO INTO DATA(WA_EKPO) WITH KEY  EBELN = WA_MSEG-EBELN
                                                      EBELP = WA_MSEG-EBELP .

      IF SY-SUBRC EQ 0 .
        WA_TAS1-MFRNR  = WA_EKPO-MFRNR .
        WA_TAS1-MENGE1 = WA_EKPO-MENGE .

        LOOP AT IT_EKBE INTO DATA(WA_EKBE) WHERE  EBELN = WA_EKPO-EBELN
                                            AND   EBELP = WA_EKPO-EBELP .
          IF WA_EKBE-SHKZG = 'S'.

            WA_TAS1-MENGE3 = WA_TAS1-MENGE3 + WA_EKBE-MENGE .
          ELSEIF WA_EKBE-SHKZG = 'H'.
            WA_TAS1-MENGE3 = WA_TAS1-MENGE3 - WA_EKBE-MENGE .
          ENDIF.

        ENDLOOP.


        READ TABLE IT_LFA1 INTO DATA(WA_LFA1) WITH KEY LIFNR = WA_EKPO-MFRNR  .
        IF SY-SUBRC EQ 0 .
          WA_TAS1-NAME1 = WA_LFA1-NAME1 .
        ENDIF.

      ENDIF.
    ENDIF.

    SHIFT WA_TAS1-MFRNR  LEFT DELETING LEADING '0'.
    SHIFT WA_TAS1-LIFNR  LEFT DELETING LEADING '0'.


    CLEAR : W_KBETR,W_UMREZ,W_UMREZ1,W_TOTQTY,W_REM,W_SQTY,W_FQTY,W_FQTY1,W_SQTY,W_SQTY1,ZEX2,JMOD,ABLAD.
    W_UMREZ  = 0.
    W_REM = '  '.
    W_KBETR = 0.
    W_KNUMH = '  '.
    SELECT SINGLE UMREZ FROM MARM INTO W_UMREZ WHERE MATNR = ITAB-MATNR AND MEINH = 'SPR'.

    SELECT SINGLE * FROM ZSHIPPER WHERE MATNR EQ ITAB-MATNR.  "30.5.22
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM MCHA WHERE MATNR EQ ITAB-MATNR AND CHARG EQ ITAB-CHARG AND ERSDA LE ZSHIPPER-TO_DT.
      IF SY-SUBRC EQ 0.
        W_UMREZ = ZSHIPPER-UMREZ.
      ENDIF.
    ENDIF.


    WA_TAS1-OPN_QTY = WA_TAS1-MENGE1 - WA_TAS1-MENGE3 .
*****************mrp logic for Nepal**********************************************************
    CLEAR : MATNR,W_KBETR1.

    IF ITAB-MATNR+10(3) EQ '425'.
      MATNR = ITAB-MATNR.
      IF MATNR+10(3) EQ '425'.
*        matnr+10(3) = '000'.  "DEACTIVATED ON EMAIL FROM NEKAR DATED 12.6.22 ---JYOTSNA
      ENDIF.

**********************

*******************

      SELECT SINGLE * FROM A602 WHERE KSCHL = 'Z001' AND VKORG EQ '2000' AND MATNR = ITAB-MATNR AND CHARG = ITAB-CHARG AND DATBI GT SY-DATUM.
      IF SY-SUBRC = 0.
        SELECT SINGLE * FROM KONP WHERE KNUMH = A602-KNUMH.
        IF SY-SUBRC EQ 0.
          W_KBETR1 = KONP-KBETR.
        ENDIF.
      ENDIF.
      IF W_KBETR1 EQ SPACE.
        SELECT SINGLE * FROM A602 WHERE KSCHL = 'Z001' AND MATNR = MATNR AND CHARG = ITAB-CHARG AND DATBI GT SY-DATUM.
        IF SY-SUBRC = 0.
          SELECT SINGLE * FROM KONP WHERE KNUMH = A602-KNUMH.
          IF SY-SUBRC EQ 0.
            W_KBETR1 = KONP-KBETR.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM A602 WHERE KSCHL = 'Z001' AND MATNR = ITAB-MATNR AND CHARG = ITAB-CHARG AND DATBI GT SY-DATUM.
      IF SY-SUBRC = 0.
        SELECT SINGLE * FROM KONP WHERE KNUMH = A602-KNUMH.
        IF SY-SUBRC EQ 0.
          W_KBETR1 = KONP-KBETR.
        ENDIF.
      ENDIF.
    ENDIF.
    IF W_KBETR1 EQ SPACE.
      W_KBETR1 = 'NOT DEF'.
    ENDIF.
*************************************************************************************************
    W_UMREZ1 = W_UMREZ.
    W_TOTQTY = ITAB-STOCK.
    IF W_UMREZ = 0.
      W_REM = 'NOT DEFINED'.
    ELSE.
      W_SQTY = W_TOTQTY MOD W_UMREZ.
      W_FQTY = ( W_TOTQTY - W_SQTY ) / W_UMREZ.
      W_FQTY1 = W_FQTY.
      W_SQTY1 = W_SQTY.
      SHIFT W_FQTY1 LEFT DELETING LEADING SPACE.
      SHIFT W_SQTY1 LEFT DELETING LEADING SPACE.
      SHIFT W_UMREZ1 LEFT DELETING LEADING SPACE.
      CONCATENATE W_FQTY1 'x' W_UMREZ1 INTO W_REM.
      IF W_SQTY NE 0.
        CONCATENATE W_REM ',' '1x' W_SQTY1 INTO W_REM.
      ENDIF.
    ENDIF.
*    FORMAT COLOR 1.
*    write : /1(10) itab-matnr,
*     12(25) itab-maktx,
*     39(4) itab-lgort,
*     45(10) itab-charg,
**            57(2)  itab-status,
*     57(10) itab-vfdat,
*     69(10) itab-hsdat,
*     80(9) itab-stock,
*     90(9) itab-stock1,
*     103(25) w_rem,
*     131(7) w_kbetr1.
**            122(2) itab-status.

    WA_TAS1-MATNR = ITAB-MATNR.
    WA_TAS1-MAKTX = ITAB-MAKTX.
    WA_TAS1-LGORT = ITAB-LGORT.
    WA_TAS1-CHARG = ITAB-CHARG.
*            57(2)  itab-status,
    WA_TAS1-VFDAT = ITAB-VFDAT.
    WA_TAS1-HSDAT = ITAB-HSDAT.
    WA_TAS1-STOCK = ITAB-STOCK.
    WA_TAS1-STOCK1 = ITAB-STOCK1.
    WA_TAS1-W_REM = W_REM.
    WA_TAS1-W_KBETR1 = W_KBETR1.
*            122(2) itab-status.

************* NEW LOGIC FOR ZEX2*****

    SELECT SINGLE * FROM A501 WHERE MATNR EQ ITAB-MATNR AND CHARG EQ ITAB-CHARG AND KSCHL EQ 'ZEX2' AND VKORG EQ '1000' AND VTWEG EQ '10' AND
    DATAB LE SY-DATUM AND DATBI GE SY-DATUM.
    IF SY-SUBRC EQ 0.
*    write :  '10'.
*    if a501-vtweg eq '10'.
      SELECT SINGLE * FROM KONP WHERE KNUMH EQ A501-KNUMH AND KSCHL EQ 'ZEX2'.
      IF SY-SUBRC EQ 0.
        A1 = KONP-KBETR / 10.
*          WRITE : 140(6) a1.
      ENDIF.
    ENDIF.

    SELECT SINGLE * FROM A501 WHERE MATNR EQ ITAB-MATNR AND CHARG EQ ITAB-CHARG AND KSCHL EQ 'ZEX2' AND VKORG EQ '1000' AND VTWEG EQ '20' AND
    DATAB LE SY-DATUM AND DATBI GE SY-DATUM.
    IF SY-SUBRC EQ 0.
*    write :  '10'.
*    if a501-vtweg eq '10'.
      SELECT SINGLE * FROM KONP WHERE KNUMH EQ A501-KNUMH AND KSCHL EQ 'ZEX2'.
      IF SY-SUBRC EQ 0.
        A2 = KONP-KBETR / 10.
*          WRITE : 148(6) a2.
      ENDIF.
    ENDIF.

    SELECT SINGLE * FROM A501 WHERE MATNR EQ ITAB-MATNR AND CHARG EQ ITAB-CHARG AND KSCHL EQ 'ZEX2' AND VKORG EQ '1000' AND VTWEG EQ '80' AND
    DATAB LE SY-DATUM AND DATBI GE SY-DATUM.
    IF SY-SUBRC EQ 0.
*    write :  '10'.
*    if a501-vtweg eq '10'.
      SELECT SINGLE * FROM KONP WHERE KNUMH EQ A501-KNUMH AND KSCHL EQ 'ZEX2'.
      IF SY-SUBRC EQ 0.
        A3 = KONP-KBETR / 10.
*          WRITE : 156(6) a3.
      ENDIF.
    ENDIF.


    SELECT SINGLE * FROM A611 WHERE KAPPL EQ 'V' AND MATNR EQ ITAB-MATNR AND CHARG EQ ITAB-CHARG AND KSCHL EQ 'ZEX2' AND VKORG EQ '1000' AND DATAB LE SY-DATUM AND
    DATBI GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM KONP WHERE KNUMH EQ A611-KNUMH AND KSCHL EQ 'ZEX2'.
      IF SY-SUBRC EQ 0.
        ZEX2 = KONP-KBETR / 10.
*        write :  140(6) zex2.
        WA_TAS1-ZEX2 = ZEX2.
      ENDIF.
    ENDIF.

******ZCIN VALUE**********************

    SELECT SINGLE KNUMH FROM A602 INTO W_KNUMH1 WHERE KSCHL = 'ZCIN' AND MATNR = ITAB-MATNR AND CHARG = ITAB-CHARG AND DATBI GT SY-DATUM.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE KBETR FROM KONP INTO W_KBETR2 WHERE KNUMH = W_KNUMH1.
*      write : 148(6) w_kbetr2 left-justified.
      WA_TAS1-W_KBETR2 = W_KBETR2.
    ENDIF.
***************JMOD******************
    SELECT SINGLE * FROM A611 WHERE KAPPL EQ 'V' AND KSCHL EQ 'JMOD' AND VKORG EQ '1000' AND MATNR EQ ITAB-MATNR AND CHARG = ITAB-CHARG AND
    DATAB LE SY-DATUM AND DATBI GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM KONP WHERE KNUMH EQ A611-KNUMH AND KSCHL EQ 'JMOD'.
      IF SY-SUBRC EQ 0.
        CLEAR : JMOD.
        JMOD = KONP-KBETR / 10.
        WA_TAS1-JMOD = JMOD.
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM A609 WHERE KAPPL EQ 'V' AND KSCHL EQ 'JMOD' AND VKORG EQ '1000' AND MATNR EQ ITAB-MATNR AND
      DATAB LE SY-DATUM AND DATBI GE SY-DATUM.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM KONP WHERE KNUMH EQ A609-KNUMH AND KSCHL EQ 'JMOD'.
        IF SY-SUBRC EQ 0.
          CLEAR : JMOD.
          JMOD = KONP-KBETR / 10.
          WA_TAS1-JMOD = JMOD.
        ENDIF.
      ENDIF.
    ENDIF.
**********************
    CLEAR : MTART.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ ITAB-MATNR.
    IF SY-SUBRC EQ 0.
*     WRITE : 156 mara-brgew LEFT-JUSTIFIED,164 mara-ntgew LEFT-JUSTIFIED.
*      write : 165 mara-brgew left-justified,174 mara-ntgew left-justified.
      WA_TAS1-BRGEW = MARA-BRGEW.
      WA_TAS1-NTGEW = MARA-NTGEW.
      MTART = MARA-MTART.
    ENDIF.
*****************TECHO  STATUS******************
    SELECT SINGLE * FROM AFPO WHERE DWERK EQ P_PLANT AND MATNR EQ ITAB-MATNR AND CHARG EQ ITAB-CHARG AND WEMNG GT 0 .
*      AND DNREL EQ 'X'.
    IF SY-SUBRC EQ 0.
*      WRITE : AFPO-ELIKZ,AFPO-DNREL.
      SELECT SINGLE * FROM AFRU WHERE AUFNR EQ AFPO-AUFNR AND AUERU EQ 'X'.
      IF SY-SUBRC EQ 0.
        WA_TAS1-IEDD = AFRU-IEDD.
      ENDIF.
    ENDIF.
***********************************************
    SELECT SINGLE * FROM MSEG WHERE MATNR EQ ITAB-MATNR AND CHARG EQ ITAB-CHARG AND WERKS EQ P_PLANT AND LGORT EQ 'CSM'.
    IF SY-SUBRC EQ 0.
      WA_TAS1-TEXT1 = 'CS ISSUED   '.
      WA_TAS1-MENGE = MSEG-MENGE.
    ELSE.
      WA_TAS1-TEXT1 = 'CS NOT ISSUED  '.
      CLEAR : ABLAD.
      SELECT * FROM MSEG WHERE MATNR EQ ITAB-MATNR AND CHARG EQ ITAB-CHARG AND WERKS EQ P_PLANT AND MBLNR EQ WA_MSEG-MBLNR.
        CONCATENATE ABLAD MSEG-ABLAD INTO ABLAD SEPARATED BY '   '.
      ENDSELECT.
      WA_TAS1-TEXT2 = ABLAD.
*      select single * from mseg where matnr eq itab-matnr and charg eq itab-charg and werks eq p_plant and ablad ne space.
*      if sy-subrc eq 0.
*        wa_tas1-text2 = mseg-ablad.
*      endif.

    ENDIF.

    SELECT SINGLE * FROM A602 WHERE KSCHL = 'ZSAM' AND VKORG EQ '1000' AND MATNR = ITAB-MATNR AND CHARG = ITAB-CHARG AND DATBI GT SY-DATUM.
    IF SY-SUBRC = 0.
      SELECT SINGLE * FROM KONP WHERE KNUMH = A602-KNUMH.
      IF SY-SUBRC EQ 0.
        WA_TAS1-ZSAM = KONP-KBETR.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM A602 WHERE KSCHL = 'ZSMP' AND VKORG EQ '1000' AND MATNR = ITAB-MATNR AND CHARG = ITAB-CHARG AND DATBI GT SY-DATUM.
    IF SY-SUBRC = 0.
      SELECT SINGLE * FROM KONP WHERE KNUMH = A602-KNUMH.
      IF SY-SUBRC EQ 0.
        WA_TAS1-ZSMP = KONP-KBETR.
      ENDIF.
    ENDIF.
    IF R3 EQ 'X'.
*      IF mtart EQ 'ZDSM'.  "23.5.22
      IF MTART EQ 'ZDSM' OR MTART EQ 'ZESM'.  "7.6.22
*        IF  WA_TAS1-W_KBETR1 NE SPACE.
        WA_TAS1-W_KBETR1 = WA_TAS1-ZSAM .
        CONDENSE  WA_TAS1-W_KBETR1.
*        ENDIF.
      ENDIF.
      IF  WA_TAS1-W_KBETR1 EQ SPACE.
        IF MTART EQ 'ZDSM' OR MTART EQ 'ZSMP'.  "7.6.22
*        IF  WA_TAS1-W_KBETR1 NE SPACE.
          WA_TAS1-W_KBETR1 = WA_TAS1-ZSMP .
          CONDENSE  WA_TAS1-W_KBETR1.
*        ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.

    WA_TAS1-TOT_QTY  = WA_TAS1-CLABS + WA_TAS1-CINSM + WA_TAS1-CSPEM .
*    wa_tas1-tot_vlue = wa_tas1-tot_qty * wa_tas1-verpr .
    WA_TAS1-TOT_VLUE = WA_TAS1-STOCK * WA_TAS1-VERPR .

*    SELECT SINGLE * FROM mseg WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND werks EQ p_plant.
*
*    IF mseg-lgort CS 'CSM '.
**      WRITE : 163 'CS ISSUED   '.
*      WRITE : 171 'CS ISSUED   '.
*      SELECT * FROM mseg WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND werks EQ p_plant.
*        IF mseg-lgort EQ 'CSM '.
**          WRITE : 176 mseg-menge.
*          WRITE : 184 mseg-menge.
*        ENDIF.
*      ENDSELECT.
*    ELSE.
*      WRITE : 171 'CS NOT ISSUED  '.
*      SELECT * FROM mseg WHERE matnr EQ itab-matnr AND charg EQ itab-charg AND
*      werks EQ p_plant.
*        WRITE :   mseg-ablad.
*      ENDSELECT.
*
*
*    ENDIF.

*ENDSELECT.

    COLLECT WA_TAS1 INTO IT_TAS1.
    CLEAR WA_TAS1.
  ENDLOOP.
  IF R3 NE 'X'.


    DATA : BATCH_DETAILS    TYPE TABLE OF CLBATCH,
           WA_BATCH_DETAILS TYPE CLBATCH,
           BATCHNO          TYPE ATWTB.

    LOOP AT IT_TAS1 INTO WA_TAS1.

      CALL FUNCTION 'VB_BATCH_GET_DETAIL' "added by rushi
        EXPORTING
          MATNR              = WA_TAS1-MATNR
          CHARG              = WA_TAS1-CHARG
          WERKS              = P_PLANT
          GET_CLASSIFICATION = 'X'
*         EXISTENCE_CHECK    =
*         READ_FROM_BUFFER   =
*         NO_CLASS_INIT      = ' '
*         LOCK_BATCH         = ' '
*       IMPORTING
*         YMCHA              =
*         CLASSNAME          =
*         BATCH_DEL_FLG      =
        TABLES
          CHAR_OF_BATCH      = BATCH_DETAILS
        EXCEPTIONS
          NO_MATERIAL        = 1
          NO_BATCH           = 2
          NO_PLANT           = 3
          MATERIAL_NOT_FOUND = 4
          PLANT_NOT_FOUND    = 5
          NO_AUTHORITY       = 6
          BATCH_NOT_EXIST    = 7
          LOCK_ON_BATCH      = 8
          OTHERS             = 9.
      IF SY-SUBRC <> 0.
* Implement suitable error handling here
      ENDIF.


      READ TABLE BATCH_DETAILS INTO WA_BATCH_DETAILS WITH KEY ATNAM = 'ZVENDOR_BATCH'.
      IF SY-SUBRC = 0 .
        WA_TAS1-BATCHNO  = WA_BATCH_DETAILS-ATWTB.
**       wa_tab5-PRUEFLOS = wa_inspe-QPLOS.
*        wa_tab5-PRUEFLOS = WA_QALS-QPLOS.
      ENDIF.

      IF WA_TAS1-MATNR CA 'H'.
      ELSE.
*        PACK wa_tas1-matnr TO wa_tas1-matnr.

        SHIFT WA_TAS1-MATNR LEFT DELETING LEADING '0'.
        CONDENSE WA_TAS1-MATNR.
        MODIFY IT_TAS1 FROM WA_TAS1 TRANSPORTING MATNR BATCHNO.
      ENDIF.
      MODIFY IT_TAS1 FROM WA_TAS1 TRANSPORTING BATCHNO .
    ENDLOOP.
  ENDIF.

*        MATNR  maktx lgort charg vfdat hsdat stock
*          stock1  status(2) ablad w_rem(15) w_kbetr1(7) zex2 w_kbetr2 jmod brgew ntgew
*          iedd text1(50) menge text2

  IF R1 EQ 'X'.
    PERFORM ALV.
  ELSEIF R2 EQ 'X'.
    PERFORM NONALV.
  ELSEIF R3 EQ 'X'.
    PERFORM PRINT.
  ENDIF.

ENDFORM.

FORM NONALV.
  LOOP AT IT_TAS1 INTO WA_TAS1.
    WRITE : /1(8) WA_TAS1-MATNR LEFT-JUSTIFIED,11(25) WA_TAS1-MAKTX LEFT-JUSTIFIED,39(4) WA_TAS1-LGORT,46(10) WA_TAS1-CHARG,
    59(10) WA_TAS1-VFDAT,71(10) WA_TAS1-HSDAT,84(10) WA_TAS1-STOCK,97(10) WA_TAS1-STOCK1,110(25) WA_TAS1-W_REM,
    137(7) WA_TAS1-W_KBETR1,147(7) WA_TAS1-ZSAM,157(7) WA_TAS1-ZSMP,166(7) WA_TAS1-W_KBETR2,175 WA_TAS1-BRGEW LEFT-JUSTIFIED,186 WA_TAS1-NTGEW LEFT-JUSTIFIED,
    196(10) WA_TAS1-IEDD LEFT-JUSTIFIED ,208(15) WA_TAS1-TEXT1 LEFT-JUSTIFIED.
*      137(7) WA_TAS1-W_KBETR1,147(7) WA_TAS1-ZSAM,157(7) WA_TAS1-ZSMP,WA_TAS1-W_KBETR2,166 WA_TAS1-BRGEW LEFT-JUSTIFIED,176 WA_TAS1-NTGEW LEFT-JUSTIFIED,
*    186(10) WA_TAS1-IEDD LEFT-JUSTIFIED ,198(15) WA_TAS1-TEXT1 LEFT-JUSTIFIED.
    IF WA_TAS1-MENGE NE 0.
      WRITE : 225 WA_TAS1-MENGE LEFT-JUSTIFIED.
    ELSE.
      WRITE : 225 WA_TAS1-TEXT2 LEFT-JUSTIFIED.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM ALV.
  WA_FIELDCAT-FIELDNAME = 'MATNR'.
  WA_FIELDCAT-SELTEXT_L = 'PRODUCT CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MAKTX'.
  WA_FIELDCAT-SELTEXT_L = 'PRODUCT NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'LGORT'.
  WA_FIELDCAT-SELTEXT_L = 'STORAGE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'CHARG'.
  WA_FIELDCAT-SELTEXT_L = 'BATCH'.
  APPEND WA_FIELDCAT TO FIELDCAT.


  WA_FIELDCAT-FIELDNAME = 'MFRNR'.
  WA_FIELDCAT-SELTEXT_L = 'MANUFACTURER'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NAME1'.
  WA_FIELDCAT-SELTEXT_L = 'MANUFACTURER NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.



  WA_FIELDCAT-FIELDNAME = 'VFDAT'.
  WA_FIELDCAT-SELTEXT_L = 'EXPIRY DATE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'HSDAT'.
  WA_FIELDCAT-SELTEXT_L = 'MFG. DATE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'STOCK'.
  WA_FIELDCAT-SELTEXT_L = 'TOTAL STOCK'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'STOCK1'.
  WA_FIELDCAT-SELTEXT_L = 'UNREST.STOCK'.
  APPEND WA_FIELDCAT TO FIELDCAT.

*  wa_fieldcat-fieldname = 'CLABS'.
*  wa_fieldcat-seltext_l = 'UNREST.STOCK.NW'.
*  APPEND wa_fieldcat TO fieldcat.

  WA_FIELDCAT-FIELDNAME = 'CINSM'.
  WA_FIELDCAT-SELTEXT_L = 'Quality Stock'.
  APPEND WA_FIELDCAT TO FIELDCAT.


  WA_FIELDCAT-FIELDNAME = 'CSPEM'.
  WA_FIELDCAT-SELTEXT_L = 'Blocked Stock'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'VERPR'.
  WA_FIELDCAT-SELTEXT_L = 'Material Rate'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'PEINH'.
  WA_FIELDCAT-SELTEXT_L = 'Rate Per Unit'.
  APPEND WA_FIELDCAT TO FIELDCAT.


*  wa_fieldcat-fieldname = 'TOT_QTY'.
*  wa_fieldcat-seltext_l = 'Total quantity'.
*  APPEND wa_fieldcat TO fieldcat.

  WA_FIELDCAT-FIELDNAME = 'tot_vlue'.
  WA_FIELDCAT-SELTEXT_L = 'Total Value'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MBLNR'.
  WA_FIELDCAT-SELTEXT_L = 'GRN Doc'.
  APPEND WA_FIELDCAT TO FIELDCAT.


  WA_FIELDCAT-FIELDNAME = 'BUDAT'.
  WA_FIELDCAT-SELTEXT_L = 'GRN Posting Date'.
  APPEND WA_FIELDCAT TO FIELDCAT.


  WA_FIELDCAT-FIELDNAME = 'LIFNR'.
  WA_FIELDCAT-SELTEXT_L = 'Vendor Code'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'VED_NAME'.
  WA_FIELDCAT-SELTEXT_L = 'Vendor Name'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MENGE1'.
  WA_FIELDCAT-SELTEXT_L = 'Ordered Quantity'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MENGE3'.
  WA_FIELDCAT-SELTEXT_L = 'GR Quantity'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'OPN_QTY'.
  WA_FIELDCAT-SELTEXT_L = 'Open PO Qty'.
  APPEND WA_FIELDCAT TO FIELDCAT.


*  wa_fieldcat-fieldname = 'STATUS'.
*  wa_fieldcat-seltext_l = 'STATUS'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'ABLAD'.
*  wa_fieldcat-seltext_l = 'ABLAD'.
*  append wa_fieldcat to fieldcat.

  WA_FIELDCAT-FIELDNAME = 'W_REM'.
  WA_FIELDCAT-SELTEXT_L = 'SHIPPER BREAK UP'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'W_KBETR1'.
  WA_FIELDCAT-SELTEXT_L = 'MRP'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'ZSAM'.
  WA_FIELDCAT-SELTEXT_L = 'ZSAM'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'ZSMP'.
  WA_FIELDCAT-SELTEXT_L = 'ZSMP'.
  APPEND WA_FIELDCAT TO FIELDCAT.

*  wa_fieldcat-fieldname = 'ZEX2'.
*  wa_fieldcat-seltext_l = 'ZEX2'.
*  append wa_fieldcat to fieldcat.

  WA_FIELDCAT-FIELDNAME = 'W_KBETR2'.
  WA_FIELDCAT-SELTEXT_L = 'ZCIN'.
  APPEND WA_FIELDCAT TO FIELDCAT.

*  wa_fieldcat-fieldname = 'JMOD'.
*  wa_fieldcat-seltext_l = 'JMOD'.
*  append wa_fieldcat to fieldcat.

  WA_FIELDCAT-FIELDNAME = 'BRGEW'.
  WA_FIELDCAT-SELTEXT_L = 'GROSS WT'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NTGEW'.
  WA_FIELDCAT-SELTEXT_L = 'NET WT'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'IEDD'.
  WA_FIELDCAT-SELTEXT_L = 'FINAL BATCH CONF.'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'TEXT1'.
  WA_FIELDCAT-SELTEXT_L = 'CS STATUS'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MENGE'.
  WA_FIELDCAT-SELTEXT_L = 'CS QTY'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'TEXT2'.
  WA_FIELDCAT-SELTEXT_L = 'STATUS'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'BATCHNO'.
  WA_FIELDCAT-SELTEXT_L = 'Vendor Batch No.'.
  APPEND WA_FIELDCAT TO FIELDCAT.


  LAYOUT-ZEBRA = 'X'.
  LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  LAYOUT-WINDOW_TITLEBAR  = 'STOCK DETAIL'.




  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK       = ' '
*     I_BYPASSING_BUFFER      = ' '
*     I_BUFFER_ACTIVE         = ' '
      I_CALLBACK_PROGRAM      = G_REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
      I_CALLBACK_USER_COMMAND = 'USER_COMM'
      I_CALLBACK_TOP_OF_PAGE  = 'TOP'
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME        =
*     I_BACKGROUND_ID         = ' '
*     I_GRID_TITLE            =
*     I_GRID_SETTINGS         =
      IS_LAYOUT               = LAYOUT
      IT_FIELDCAT             = FIELDCAT
*     IT_EXCLUDING            =
*     IT_SPECIAL_GROUPS       =
*     IT_SORT                 =
*     IT_FILTER               =
*     IS_SEL_HIDE             =
*     I_DEFAULT               = 'X'
      I_SAVE                  = 'A'
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
    TABLES
      T_OUTTAB                = IT_TAS1
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    "itab-prt

FORM TOP.

  DATA: COMMENT    TYPE SLIS_T_LISTHEADER,
        WA_COMMENT LIKE LINE OF COMMENT.

  WA_COMMENT-TYP = 'A'.
  WA_COMMENT-INFO = 'STOCK DETAILS'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND WA_COMMENT TO COMMENT.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY = COMMENT
*     I_LOGO             = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

  CLEAR COMMENT.

ENDFORM.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
FORM USER_COMM USING UCOMM LIKE SY-UCOMM
                     SELFIELD TYPE SLIS_SELFIELD.



  CASE SELFIELD-FIELDNAME.
    WHEN 'MATNR'.
      SET PARAMETER ID 'MAT' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM

FORM AUTHORIZATION .

  SELECT WERKS NAME1 FROM T001W INTO TABLE ITAB_T001W WHERE WERKS EQ P_PLANT.

  LOOP AT ITAB_T001W INTO WA_T001W.
    AUTHORITY-CHECK OBJECT 'M_BCO_WERK'
    ID 'WERKS' FIELD WA_T001W-WERKS.
    IF SY-SUBRC <> 0.
      CONCATENATE 'No authorization for Plant' WA_T001W-WERKS INTO MSG
      SEPARATED BY SPACE.
      MESSAGE MSG TYPE 'E'.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PRINT .

  LOOP AT IT_TAS1 INTO WA_TAS1.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAS1-MATNR AND MTART EQ 'ZDSI'.
    IF SY-SUBRC EQ 0.
      WA_SMP1-MATNR = MARA-MATNR.
      WA_SMP1-CHARG = WA_TAS1-CHARG.
      COLLECT WA_SMP1 INTO IT_SMP1.
      CLEAR WA_SMP1.
    ENDIF.
  ENDLOOP.

  IF IT_SMP1 IS NOT INITIAL.
    SELECT * FROM MSEG INTO TABLE IT_MSEG FOR ALL ENTRIES IN IT_SMP1 WHERE BWART EQ '101' AND MATNR EQ IT_SMP1-MATNR AND CHARG EQ IT_SMP1-CHARG
      AND LIFNR NE SPACE.
  ENDIF.
  SORT IT_MSEG DESCENDING BY MBLNR.

  LOOP AT IT_TAS1 INTO WA_TAS1.
    WA_TAB2-MATNR = WA_TAS1-MATNR.
    WA_TAB2-MAKTX = WA_TAS1-MAKTX.
    WA_TAB2-LGORT = WA_TAS1-LGORT.
    WA_TAB2-CHARG = WA_TAS1-CHARG.
    WA_TAB2-VFDAT = WA_TAS1-VFDAT.
    WA_TAB2-HSDAT = WA_TAS1-HSDAT.

    WA_TAB2-STOCK = WA_TAS1-STOCK.
    WA_TAB2-STOCK1 = WA_TAS1-STOCK1.
    WA_TAB2-W_REM = WA_TAS1-W_REM.
    CLEAR: MTART.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAS1-MATNR.
    IF SY-SUBRC EQ 0.
      MTART = MARA-MTART.
    ENDIF.
    IF MTART EQ 'ZDSM'.
      WA_TAB2-MRPSAM = WA_TAS1-ZSAM.
    ELSE.
      WA_TAB2-MRPSAM = WA_TAS1-W_KBETR1.
    ENDIF.

    IF MTART EQ 'ZDSI'.
      READ TABLE IT_MSEG INTO WA_MSEG WITH KEY MATNR = WA_TAS1-MATNR CHARG = WA_TAS1-CHARG.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM EKPO WHERE EBELN EQ WA_MSEG-EBELN AND EBELP EQ WA_MSEG-EBELP.
        IF SY-SUBRC EQ 0.
          CLEAR : RATE.
          RATE = EKPO-NETPR / EKPO-PEINH.
        ENDIF.
        WA_TAB2-MRPSAM = RATE.
      ENDIF.
    ENDIF.

    CONDENSE : WA_TAB2-STOCK,WA_TAB2-STOCK1,WA_TAB2-W_REM,WA_TAB2-MRPSAM.
    COLLECT WA_TAB2 INTO IT_TAB2.
    CLEAR WA_TAB2.
  ENDLOOP.

  LOOP AT IT_TAB2 INTO WA_TAB2.
    IF WA_TAB2-MATNR CA 'H'.
    ELSE.
*      PACK wa_tab2-matnr TO wa_tab2-matnr.

      SHIFT WA_TAS1-MATNR LEFT DELETING LEADING '0'.
      CONDENSE WA_TAB2-MATNR.
      MODIFY IT_TAB2 FROM WA_TAB2 TRANSPORTING MATNR.
    ENDIF.
  ENDLOOP.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
*     formname           = 'ZDBS1'
      FORMNAME           = 'ZDBS2'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      FM_NAME            = V_FM
    EXCEPTIONS
      NO_FORM            = 1
      NO_FUNCTION_MODULE = 2
      OTHERS             = 3.

  CALL FUNCTION V_FM
    EXPORTING
*     from_dt          = from_dt
*     to_dt            = to_dt
      FORMAT           = FORMAT
      KUNNR            = KUNNR
      ADDR             = ADDR
*     AUBEL            = AUBEL
*     adrc             = adrc
*     t001w            = t001w
*     J_1IMOCUST       = J_1IMOCUST
*     G_LSTNO          = G_LSTNO
*     WA_ADRC          = WA_ADRC
*     VBKD             = VBKD
*     vbrk             = vbrk
*     fkdat            = fkdat
*     TOTAL            = TOTAL
*     TOTAL1           = TOTAL1
*     VBRK             = VBRK
*     W_TAX            = W_TAX
*     W_VALUE          = W_VALUE
*     SPELL            = SPELL
*     W_DIFF           = W_DIFF
*     EMNAME           = EMNAME
*     RMNAME           = RMNAME
*     CLMDT            = CLMDT
    TABLES
      IT_TAB2          = IT_TAB2
*     it_vbrp          = it_vbrp
*     ITAB_DIVISION    = ITAB_DIVISION
*     ITAB_STORAGE     = ITAB_STORAGE
*     ITAB_PA0002      = ITAB_PA0002
    EXCEPTIONS
      FORMATTING_ERROR = 1
      INTERNAL_ERROR   = 2
      SEND_ERROR       = 3
      USER_CANCELED    = 4
      OTHERS           = 5.



*  wa_fieldcat-fieldname = 'W_KBETR1'.
*  wa_fieldcat-seltext_l = 'MRP'.
*  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'ZSAM'.
*  wa_fieldcat-seltext_l = 'ZSAM'.
*  append wa_fieldcat to fieldcat.
*
**  wa_fieldcat-fieldname = 'ZEX2'.
**  wa_fieldcat-seltext_l = 'ZEX2'.
**  append wa_fieldcat to fieldcat.
*
*  wa_fieldcat-fieldname = 'W_KBETR2'.
*  wa_fieldcat-seltext_l = 'ZCIN'.
*  append wa_fieldcat to fieldcat.


ENDFORM.
