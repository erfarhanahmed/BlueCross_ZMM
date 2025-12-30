*&---------------------------------------------------------------------*
*& Report ZPRODUCTION_PLANNING_SAMPLE_1
*DEVELOPED BY Madhavi
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPRODUCTION_PLANNING_SAMPLE_1 LINE-SIZE 600.

*REPORT ZPRODUCTION_PLANNING_SAMPLE_2 LINE-SIZE 600.

TABLES : MARD,
         ZBUDGET_TAB1,
         ZPROD_SAMP_REQ,
         T247,
         MAKT,
         MVKE,
         TVM4T,
         ZPROD_ITEM1,
         MARA,
         A602,
         KONP,
         A550,
         A501,
         A611,
         A004,
         A603,
         KOTN532,
         KONDN,
         ZPRODSAMP_STOCK,
         TVM5T,
         ZPRODSAMPRT.

TYPE-POOLS:  SLIS.
DATA: G_REPID     LIKE SY-REPID,
      FIELDCAT    TYPE SLIS_T_FIELDCAT_ALV,
      WA_FIELDCAT LIKE LINE OF FIELDCAT,
      SORT        TYPE SLIS_T_SORTINFO_ALV,
      WA_SORT     LIKE LINE OF SORT,
      LAYOUT      TYPE SLIS_LAYOUT_ALV,
      L_GLAY      TYPE LVC_S_GLAY.

TYPES : BEGIN OF CNF1,
          MATNR  TYPE MARA-MATNR,
          NSKSTK TYPE MARD-LABST,
          GOASTK TYPE MARD-LABST,
          OZRSTK TYPE MARD-LABST,
          GHASTK TYPE MARD-LABST,
          CNFSTK TYPE MARD-LABST,
        END OF CNF1.

TYPES : BEGIN OF CNFV1,
          MATNR TYPE MARA-MATNR,
          MVGR4 TYPE MVKE-MVGR4,
          LABST TYPE MARD-LABST,
        END OF CNFV1.

TYPES : BEGIN OF BUD1,
          MATNR  TYPE MARA-MATNR,
          BUDQTY TYPE P,
        END OF BUD1.

DATA : IT_CNF1  TYPE TABLE OF CNF1,
       WA_CNF1  TYPE CNF1,
       IT_CNFV1 TYPE TABLE OF CNFV1,
       WA_CNFV1 TYPE CNFV1,
       IT_FAC1  TYPE TABLE OF CNF1,
       WA_FAC1  TYPE CNF1,
       IT_BUD1  TYPE TABLE OF BUD1,
       WA_BUD1  TYPE BUD1.

DATA : IT_LCNF1  TYPE TABLE OF CNF1,
       WA_LCNF1  TYPE CNF1,
       IT_LCNFV1 TYPE TABLE OF CNFV1,
       WA_LCNFV1 TYPE CNFV1,
       IT_LFAC1  TYPE TABLE OF CNF1,
       WA_LFAC1  TYPE CNF1.

DATA : IT_MARA             TYPE TABLE OF MARA,
       WA_MARA             TYPE MARA,
       IT_MARA_1           TYPE TABLE OF MARA,
       WA_MARA_1           TYPE MARA,
       IT_MARD             TYPE TABLE OF MARD,
       WA_MARD             TYPE MARD,
       IT_MARD1            TYPE TABLE OF MARD,
       WA_MARD1            TYPE MARD,
       IT_MARD2            TYPE TABLE OF MARD,
       WA_MARD2            TYPE MARD,
       IT_MVKE             TYPE TABLE OF MVKE,
       WA_MVKE             TYPE MVKE,
       IT_ZBUDGET_TAB1     TYPE TABLE OF ZBUDGET_TAB1,
       WA_ZBUDGET_TAB1     TYPE ZBUDGET_TAB1,
       IT_ZPROD_SAMP_REQ   TYPE TABLE OF ZPROD_SAMP_REQ,
       WA_ZPROD_SAMP_REQ   TYPE ZPROD_SAMP_REQ,
       IT_ZPROD_ITEM1      TYPE TABLE OF ZPROD_ITEM1,
       WA_ZPROD_ITEM1      TYPE ZPROD_ITEM1,
       IT_MCHB             TYPE TABLE OF MCHB,
       WA_MCHB             TYPE MCHB,
       IT_A602             TYPE TABLE OF A602,
       WA_A602             TYPE A602,
       IT_ZPRODSAMP_STOCK  TYPE TABLE OF ZPRODSAMP_STOCK,
       WA_ZPRODSAMP_STOCK  TYPE ZPRODSAMP_STOCK,

       IT_ZPRODSAMP_STOCK1 TYPE TABLE OF ZPRODSAMP_STOCK,
       WA_ZPRODSAMP_STOCK1 TYPE ZPRODSAMP_STOCK,
       IT_MARC             TYPE TABLE OF MARC,
       WA_MARC             TYPE MARC,
       IT_ZPROD_PRD        TYPE TABLE OF ZPROD_PRD,
       WA_ZPROD_PRD        TYPE ZPROD_PRD.

DATA : M2(2) TYPE C,
       Y2(4) TYPE C,
       NDATE TYPE SY-DATUM.

TYPES : BEGIN OF ITAB1,
          CHK         TYPE  CHAR5,
          MATNR       TYPE MARA-MATNR,
*          PLANT      TYPE MARD-WERKS,
          CDATE       TYPE SY-DATUM,
          NDATE       TYPE SY-DATUM,
          NNDATE      TYPE SY-DATUM,
          NNNDATE     TYPE SY-DATUM,
          TOTAL       TYPE P,
          NSKSTK      TYPE P,
          GOASTK      TYPE P,
          GHASTK      TYPE P,
          OZRSTK      TYPE P,
          CNFSTK      TYPE P,
          TRAME       TYPE P,
          CBUDQTY     TYPE P,
          NBUDQTY     TYPE P,
          NNBUDQTY    TYPE P,
          NNNBUDQTY   TYPE P,
          CREQQTY     TYPE P,
          NREQQTY     TYPE P,
          NNREQQTY    TYPE P,
          NNNREQQTY   TYPE P,
          RCREQQTY    TYPE P,
          RNREQQTY    TYPE P,
          RNNREQQTY   TYPE P,
          RNNNREQQTY  TYPE P,
          CL1         TYPE P,
          CL2         TYPE P,
          CL3         TYPE P,
          CL4         TYPE P,
          MAKTX       TYPE MAKT-MAKTX,
          PRDTYP(3)   TYPE C,
          TDLINE(50)  TYPE C,
          BEZEI       TYPE TVM5T-BEZEI,
          LOCATION(9) TYPE C,
          RATE        TYPE BSEG-DMBTR,
*  mvgr4 type mvke-mvgr4,
        END OF ITAB1.

TYPES : BEGIN OF ITAB11,
          CHK         TYPE  CHAR5,
*          MATNR       TYPE MARA-MATNR,
**          PLANT      TYPE MARD-WERKS,
*          CDATE       TYPE SY-DATUM,
*          NDATE       TYPE SY-DATUM,
*          NNDATE      TYPE SY-DATUM,
*          NNNDATE     TYPE SY-DATUM,
          TOTAL       TYPE P,
          FACSTK      TYPE P,
          CNFSTK      TYPE P,
          TRAME       TYPE P,
          CBUDQTY     TYPE P,
          NBUDQTY     TYPE P,
          NNBUDQTY    TYPE P,
          NNNBUDQTY   TYPE P,
          CREQQTY     TYPE P,
          NREQQTY     TYPE P,
          NNREQQTY    TYPE P,
          NNNREQQTY   TYPE P,
          RCREQQTY    TYPE P,
          RNREQQTY    TYPE P,
          RNNREQQTY   TYPE P,
          RNNNREQQTY  TYPE P,
          CL1         TYPE P,
          CL2         TYPE P,
          CL3         TYPE P,
          CL4         TYPE P,
          MAKTX       TYPE MAKT-MAKTX,
          PRDTYP(3)   TYPE C,
          TDLINE(50)  TYPE C,
          BEZEI       TYPE TVM5T-BEZEI,
          LOCATION(9) TYPE C,
*  mvgr4 type mvke-mvgr4,
        END OF ITAB11.

TYPES : BEGIN OF ITAB2,

          CHK        TYPE  CHAR5,
          MATNR      TYPE MARA-MATNR,
          PLANT      TYPE MARD-WERKS,
          CDATE      TYPE SY-DATUM,
          NDATE      TYPE SY-DATUM,
          NNDATE     TYPE SY-DATUM,
          NNNDATE    TYPE SY-DATUM,
          TOTAL      TYPE P,
          CNFLABST   TYPE P,
          FACLABST   TYPE P,
          TRAME      TYPE P,
          CBUDQTY    TYPE P,
          NBUDQTY    TYPE P,
          NNBUDQTY   TYPE P,
          NNNBUDQTY  TYPE P,
          CREQQTY    TYPE P,
          NREQQTY    TYPE P,
          NNREQQTY   TYPE P,
          NNNREQQTY  TYPE P,
          RCREQQTY   TYPE P,
          RNREQQTY   TYPE P,
          RNNREQQTY  TYPE P,
          RNNNREQQTY TYPE P,
          CL1        TYPE P,
          CL2        TYPE P,
          CL3        TYPE P,
          CL4        TYPE P,
          MAKTX      TYPE MAKT-MAKTX,
          MVGR4      TYPE MVKE-MVGR4,
          TDLINE(50) TYPE C,
          PRDTYP(3)  TYPE C,
        END OF ITAB2.

DATA : BEGIN OF ITAB3 OCCURS 0,
         TICK       TYPE CHAR1,
         CHK        TYPE  CHAR5,
         MATNR      TYPE MARA-MATNR,
*         tdline(50) type c,
         MAKTX      TYPE MAKT-MAKTX,
         BEZEI      TYPE TVM5T-BEZEI,
*         PLANT      TYPE MARD-WERKS,

         NSKSTK     TYPE P,
         GOASTK     TYPE P,
         OZRSTK     TYPE P,
         GHASTK     TYPE P,
         CNFSTK     TYPE P,
         TRAME      TYPE P,
         TOTAL      TYPE P,

         CDATE      TYPE SY-DATUM,
         CREQQTY    TYPE P,
         RCREQQTY   TYPE P,
         CBUDQTY    TYPE P,
         CL1        TYPE P,

         NDATE      TYPE SY-DATUM,
         NREQQTY    TYPE P,
         RNREQQTY   TYPE P,
         NBUDQTY    TYPE P,
         CL2        TYPE P,

         NNDATE     TYPE SY-DATUM,
         NNREQQTY   TYPE P,
         RNNREQQTY  TYPE P,
         NNBUDQTY   TYPE P,
         CL3        TYPE P,

         NNNDATE    TYPE SY-DATUM,
         NNNREQQTY  TYPE P,
         RNNNREQQTY TYPE P,
         NNNBUDQTY  TYPE P,
         CL4        TYPE P,

*         MVGR4      TYPE MVKE-MVGR4,

       END OF ITAB3.

DATA : BEGIN OF ITAB4 OCCURS 0,
         TICK       TYPE CHAR1,
         CHK        TYPE  CHAR5,
         MATNR      TYPE MARA-MATNR,
         TDLINE(50) TYPE C,
         MAKTX      TYPE MAKT-MAKTX,
         BEZEI      TYPE TVM5T-BEZEI,
         PLANT      TYPE MARD-WERKS,

         CNFLABST   TYPE P,
         FACLABST   TYPE P,
         TRAME      TYPE P,
         TOTAL      TYPE P,

         CDATE      TYPE SY-DATUM,
         CREQQTY    TYPE P,
         RCREQQTY   TYPE P,
         CBUDQTY    TYPE P,
         CL1        TYPE P,

         NDATE      TYPE SY-DATUM,
         NREQQTY    TYPE P,
         RNREQQTY   TYPE P,
         NBUDQTY    TYPE P,
         CL2        TYPE P,

         NNDATE     TYPE SY-DATUM,
         NNREQQTY   TYPE P,
         RNNREQQTY  TYPE P,
         NNBUDQTY   TYPE P,
         CL3        TYPE P,

         NNNDATE    TYPE SY-DATUM,
         NNNREQQTY  TYPE P,
         RNNNREQQTY TYPE P,
         NNNBUDQTY  TYPE P,
         CL4        TYPE P,
       END OF ITAB4.

TYPES : BEGIN OF IMAT1,
          MATNR  TYPE MARA-MATNR,
          TDLINE TYPE TLINE,
        END OF IMAT1.

TYPES : BEGIN OF IMATT1,
          MATNR  TYPE MARA-MATNR,
          TDLINE TYPE TLINE,
        END OF IMATT1.

TYPES : BEGIN OF MAT1,
          MATNR TYPE MARA-MATNR,
        END OF MAT1.

TYPES : BEGIN OF MAT2,
*,mvgr4 type mvke-mvgr4,
          MATNR TYPE MARA-MATNR,
        END OF MAT2.

TYPES : BEGIN OF REQ1,
*          PLANT TYPE ZPROD_SAMP_REQ-PLANT,
          MATNR  TYPE MARA-MATNR,
          PDATE  TYPE ZPROD_SAMP_REQ-PDATE,
          QTY    TYPE ZPROD_SAMP_REQ-QTY,
          RQTY   TYPE ZPROD_SAMP_REQ-RQTY,
          BUDGET TYPE ZPROD_SAMP_REQ-BUDGET,
        END OF REQ1.
TYPES : BEGIN OF ZVEN1,
          MATNR TYPE MARA-MATNR,
          STOCK TYPE MCHB-CLABS,
        END OF ZVEN1.

TYPES : BEGIN OF ZVEN2,
          MATNR TYPE MARA-MATNR,
          STOCK TYPE MCHB-CLABS,
          MRP   TYPE PRCD_elements-KWERT,
          LIFNR TYPE LFA1-LIFNR,
        END OF ZVEN2.

TYPES : BEGIN OF STK1,
          MATNR  TYPE MARA-MATNR,
          CHARG  TYPE MCHB-CHARG,
          NSKSTK TYPE P,
          GOASTK TYPE P,
          OZRSTK TYPE P,
          GHASTK TYPE P,
          CNFSTK TYPE P,
*  WERKS TYPE MCHB-WERKS,
        END OF STK1.

TYPES : BEGIN OF STK2,
          MATNR   TYPE MARA-MATNR,
          CHARG   TYPE MCHB-CHARG,
          CLABS   TYPE P,
          MRP     TYPE PRCD_elements-KWERT,
          ED      TYPE PRCD_elements-KWERT,
          RET_DIS TYPE PRCD_elements-KWERT,
          STK_DIS TYPE PRCD_elements-KWERT,
          PTS     TYPE PRCD_elements-KWERT,
          VAL     TYPE PRCD_elements-KWERT,
        END OF STK2.

TYPES : BEGIN OF STK5,
          MATNR TYPE MARA-MATNR,
          CLABS TYPE MCHB-CLABS,
          VAL   TYPE PRCD_elements-KWERT,
        END OF STK5.

TYPES : BEGIN OF STK6,
          MATNR TYPE MARA-MATNR,
          CLABS TYPE MCHB-CLABS,
          VAL   TYPE PRCD_elements-KWERT,
*mvgr4 type mvke-mvgr4,
        END OF STK6.

TYPES : BEGIN OF STK7,
          MATNR TYPE MARA-MATNR,
          VAL   TYPE PRCD_elements-KWERT,
        END OF STK7.

TYPES : BEGIN OF STKV1,
          MATNR TYPE MARA-MATNR,
          CHARG TYPE MCHB-CHARG,
          CLABS TYPE P,
          MRP   TYPE PRCD_elements-KWERT,
          ED    TYPE PRCD_elements-KWERT,
          PTS   TYPE PRCD_elements-KWERT,
*  mvgr4 type mvke-mvgr4,
          ERSDA TYPE MCHB-ERSDA,
        END OF STKV1.

TYPES : BEGIN OF NONITEM,
*  mvgr4 type mvke-mvgr4,
          MATNR TYPE MARA-MATNR,
        END OF NONITEM.

TYPES : BEGIN OF TMVKE1,
          MATNR TYPE MARA-MATNR,
        END OF TMVKE1.

TYPES : BEGIN OF VAL2,
*mvgr4 type mvke-mvgr4,
          MATNR TYPE MARA-MATNR,
          CHARG TYPE A602-CHARG,
        END OF VAL2.

TYPES : BEGIN OF VAL3,
*mvgr4 type mvke-mvgr4,
          MATNR TYPE MARA-MATNR,
          CHARG TYPE A602-CHARG,
          KNUMH TYPE A602-KNUMH,
        END OF VAL3.

TYPES : BEGIN OF VAL4,
*mvgr4 type mvke-mvgr4,
          MATNR TYPE MARA-MATNR,
          CHARG TYPE A602-CHARG,
          MRP   TYPE KONP-KBETR,
        END OF VAL4.

TYPES : BEGIN OF VAL5,
*mvgr4 type mvke-mvgr4,
          MATNR   TYPE MARA-MATNR,
          CHARG   TYPE A602-CHARG,
          MRP     TYPE KONP-KBETR,
          ED      TYPE KONP-KBETR,
          RET_DIS TYPE KONP-KBETR,
          STK_DIS TYPE KONP-KBETR,
          PTS     TYPE KONP-KBETR,
        END OF VAL5.

TYPES : BEGIN OF BON1,
          PER   TYPE P DECIMALS 2,
          MATNR TYPE MARA-MATNR,
*  mvgr4 type mvke-mvgr4,
        END OF BON1.

TYPES : BEGIN OF TRAN1,
          MATNR TYPE MARC-MATNR,
          TRAME TYPE MARC-TRAME,
        END OF TRAN1.

TYPES : BEGIN OF STOCK1,
          MATNR  TYPE MARA-MATNR,
          CHARG  TYPE MCHB-CHARG,
          NSKSTK TYPE MCHB-CLABS,
          GOASTK TYPE MCHB-CLABS,
          OZRSTK TYPE MCHB-CLABS,
          GHASTK TYPE MCHB-CLABS,
          CNFSTK TYPE MCHB-CLABS,
        END OF STOCK1.

DATA : IT_MAT1        TYPE TABLE OF IMAT1,
       WA_MAT1        TYPE IMAT1,
*       it_matt1 type table of imatt1,
*       wa_matt1 type imatt1,
       IT_TAB1        TYPE TABLE OF ITAB1,
       WA_TAB1        TYPE ITAB1,
       IT_TAB2        TYPE TABLE OF ITAB1,
       WA_TAB2        TYPE ITAB1,
       IT_TAB21       TYPE TABLE OF ITAB1,
       WA_TAB21       TYPE ITAB1,
       IT_TAB22       TYPE TABLE OF ITAB1,
       WA_TAB22       TYPE ITAB1,
       IT_TAB3        TYPE TABLE OF ITAB1,
       WA_TAB3        TYPE ITAB1,

       IT_TAM1        TYPE TABLE OF ITAB1,
       WA_TAM1        TYPE ITAB1,
       IT_TAM2        TYPE TABLE OF ITAB1,
       WA_TAM2        TYPE ITAB1,
       IT_TAM3        TYPE TABLE OF ITAB1,
       WA_TAM3        TYPE ITAB1,
       IT_TAM4        TYPE TABLE OF ITAB1,
       WA_TAM4        TYPE ITAB1,
       IT_TAM5        TYPE TABLE OF ITAB1,
       WA_TAM5        TYPE ITAB1,

       IT_TAM11       TYPE TABLE OF ITAB11,
       WA_TAM11       TYPE ITAB11,
       IT_TAM12       TYPE TABLE OF ITAB11,
       WA_TAM12       TYPE ITAB11,
       IT_TAM13       TYPE TABLE OF ITAB11,
       WA_TAM13       TYPE ITAB11,
       IT_TAM14       TYPE TABLE OF ITAB11,
       WA_TAM14       TYPE ITAB11,
       IT_TAM15       TYPE TABLE OF ITAB11,
       WA_TAM15       TYPE ITAB11,

       IT_TAB4        TYPE TABLE OF ITAB2,
       WA_TAB4        TYPE ITAB2,
*       it_mat type table of mat1,
*       wa_mat type mat1,
       IT_MAT2        TYPE TABLE OF MAT2,
       WA_MAT2        TYPE MAT2,
       IT_REQ1        TYPE TABLE OF REQ1,
       WA_REQ1        TYPE REQ1,
       IT_MARA1       TYPE TABLE OF MARA,
       WA_MARA1       TYPE MARA,
       IT_MVKE1       TYPE TABLE OF MVKE,
       WA_MVKE1       TYPE MVKE,
       IT_ZVENDORDATA TYPE TABLE OF ZVENDORDATA,
       WA_ZVENDORDATA TYPE ZVENDORDATA,
       IT_ZVEN1       TYPE TABLE OF ZVEN1,
       WA_ZVEN1       TYPE ZVEN1,
       IT_ZVEN2       TYPE TABLE OF ZVEN2,
       WA_ZVEN2       TYPE ZVEN2,
       IT_STK1        TYPE TABLE OF STK1,
       WA_STK1        TYPE STK1,
       IT_STK2        TYPE TABLE OF STK2,
       WA_STK2        TYPE STK2,
       IT_STK3        TYPE TABLE OF STK2,
       WA_STK3        TYPE STK2,
       IT_STK4        TYPE TABLE OF STK2,
       WA_STK4        TYPE STK2,
       IT_STK5        TYPE TABLE OF STK5,
       WA_STK5        TYPE STK5,
       IT_STK6        TYPE TABLE OF STK6,
       WA_STK6        TYPE STK6,
       IT_STK7        TYPE TABLE OF STK7,
       WA_STK7        TYPE STK7,
       IT_STKV1       TYPE TABLE OF STKV1,
       WA_STKV1       TYPE STKV1,
       IT_STKC1       TYPE TABLE OF STKV1,
       WA_STKC1       TYPE STKV1,
       IT_NONITEM     TYPE TABLE OF NONITEM,
       WA_NONITEM     TYPE NONITEM,
       IT_TMVKE1      TYPE TABLE OF TMVKE1,
       WA_TMVKE1      TYPE TMVKE1,
       IT_VAL1        TYPE TABLE OF TMVKE1,
       WA_VAL1        TYPE TMVKE1,
       IT_VAL2        TYPE TABLE OF VAL2,
       WA_VAL2        TYPE VAL2,
       IT_VAL3        TYPE TABLE OF VAL3,
       WA_VAL3        TYPE VAL3,
       IT_VAL4        TYPE TABLE OF VAL4,
       WA_VAL4        TYPE VAL4,
       IT_VAL5        TYPE TABLE OF VAL5,
       WA_VAL5        TYPE VAL5,
       IT_VAL6        TYPE TABLE OF VAL5,
       WA_VAL6        TYPE VAL5,
       IT_BON1        TYPE TABLE OF BON1,
       WA_BON1        TYPE BON1,
       IT_TRAN1       TYPE TABLE OF TRAN1,
       WA_TRAN1       TYPE TRAN1,
       IT_LTRAN1      TYPE TABLE OF TRAN1,
       WA_LTRAN1      TYPE TRAN1,
       IT_STOCK1      TYPE TABLE OF STOCK1,
       WA_STOCK1      TYPE STOCK1.
DATA : MATNR1 TYPE MARA-MATNR.

DATA : FACLABST TYPE P,
       CNFLABST TYPE P,
       TOTLABST TYPE P,
       TQTY     TYPE P,
       TVAL     TYPE P,
       TTQTY    TYPE P.

DATA : CCNFVAL        TYPE P,
       CFACVAL        TYPE P,
       CTOTVAL        TYPE P,

       CCREQQTYVAL    TYPE P,
       CRCREQQTYVAL   TYPE P,
       CCBUDQTYVAL    TYPE P,
       CCLOSING1      TYPE P,

       CNREQQTYVAL    TYPE P,
       CRNREQQTYVAL   TYPE P,
       CNBUDQTYVAL    TYPE P,
       CCLOSING2      TYPE P,

       CNNREQQTYVAL   TYPE P,
       CRNNREQQTYVAL  TYPE P,
       CNNBUDQTYVAL   TYPE P,
       CCLOSING3      TYPE P,

       CNNNREQQTYVAL  TYPE P,
       CRNNNREQQTYVAL TYPE P,
       CNNNBUDQTYVAL  TYPE P,
       CCLOSING4      TYPE P.

DATA : CNFQTY         TYPE P,
       FACQTY         TYPE P,
       TOTQTY         TYPE P,
       CREQQTY        TYPE P,
       RCREQQTY       TYPE P,
       CBUDQTY        TYPE P,
       NREQQTY        TYPE P,
       RNREQQTY       TYPE P,
       NBUDQTY        TYPE P,
       NNREQQTY       TYPE P,
       RNNREQQTY      TYPE P,
       NNBUDQTY       TYPE P,
       NNNREQQTY      TYPE P,
       RNNNREQQTY     TYPE P,
       NNNBUDQTY      TYPE P,
       CLS1           TYPE P,
       CLS2           TYPE P,
       CLS3           TYPE P,
       CLS4           TYPE P,

       CNFQTYVAL      TYPE P,
       FACQTYVAL      TYPE P,
       TOTQTYVAL      TYPE P,
       CREQQTYVAL     TYPE P,
       RCREQQTYVAL    TYPE P,
       CBUDQTYVAL     TYPE P,
       CLOSING1       TYPE P,
       NREQQTYVAL     TYPE P,
       RNREQQTYVAL    TYPE P,
       NBUDQTYVAL     TYPE P,
       CLOSING2       TYPE P,
       NNREQQTYVAL    TYPE P,
       RNNREQQTYVAL   TYPE P,
       NNBUDQTYVAL    TYPE P,
       NNNREQQTYVAL   TYPE P,
       RNNNREQQTYVAL  TYPE P,
       NNNBUDQTYVAL   TYPE P,
       CLOSING3       TYPE P,
       CLOSING4       TYPE P,

       BCNFQTY        TYPE P,
       BFACQTY        TYPE P,
       BTOTQTY        TYPE P,
       BCREQQTY       TYPE P,
       BRCREQQTY      TYPE P,
       BCBUDQTY       TYPE P,
       BNREQQTY       TYPE P,
       BRNREQQTY      TYPE P,
       BNBUDQTY       TYPE P,
       BNNREQQTY      TYPE P,
       BRNNREQQTY     TYPE P,
       BNNBUDQTY      TYPE P,
       BNNNREQQTY     TYPE P,
       BRNNNREQQTY    TYPE P,
       BNNNBUDQTY     TYPE P,
       BCLS1          TYPE P,
       BCLS2          TYPE P,
       BCLS3          TYPE P,
       BCLS4          TYPE P,
       BCLS1VAL       TYPE P,
       BCLS2VAL       TYPE P,
       BCLS3VAL       TYPE P,
       BCLS4VAL       TYPE P,

       BCNFQTYVAL     TYPE P,
       BFACQTYVAL     TYPE P,
       BTOTQTYVAL     TYPE P,

       BCREQQTYVAL    TYPE P,
       BRCREQQTYVAL   TYPE P,
       BCBUDQTYVAL    TYPE P,
       BNREQQTYVAL    TYPE P,
       BRNREQQTYVAL   TYPE P,
       BNBUDQTYVAL    TYPE P,
       BNNREQQTYVAL   TYPE P,
       BRNNREQQTYVAL  TYPE P,
       BNNBUDQTYVAL   TYPE P,
       BNNNREQQTYVAL  TYPE P,
       BRNNNREQQTYVAL TYPE P,
       BNNNBUDQTYVAL  TYPE P.

DATA : BSTOCK TYPE P.

*data : begin of itab3 occurs 0,
*  tick type char1,
*  chk type  char5,
*  matnr type mara-matnr,
*  plant type mard-werks,
*  cdate type sy-datum,
*  ndate type sy-datum,
*  nndate type sy-datum,
*  nnndate type sy-datum,
*  total type p,
*  cnflabst type p,
*  faclabst type p,
*  trame TYPE p,
*  cbudqty type p,
*  nbudqty type p,
*  nnbudqty type p,
*  nnnbudqty type p,
*  creqqty type p,
*  nreqqty type p,
*  nnreqqty type p,
*  nnnreqqty type p,
*  rcreqqty type p,
*  rnreqqty type p,
*  rnnreqqty type p,
*  rnnnreqqty type p,
*  cl1 type p,
*  cl2 type p,
*  cl3 type p,
*  cl4 type p,
*  maktx type makt-maktx,
**  mvgr4 type mvke-mvgr4,
*  end of itab3.


DATA : TOTAL TYPE P,
       CL1   TYPE P,
       CL2   TYPE P,
       CL3   TYPE P,
       CL4   TYPE P,
       A     TYPE P,
       B     TYPE P,
       ST1   TYPE P,
       ST2   TYPE P,
       QTY1  TYPE P,
       QTY2  TYPE P,
       QTY3  TYPE P,
       QTY4  TYPE P,
       QTY11 TYPE P,
       QTY12 TYPE P,
       QTY13 TYPE P,
       QTY14 TYPE P,
       CLOS1 TYPE P,
       CLOS2 TYPE P,
       CLOS3 TYPE P,
       CLOS4 TYPE P.

DATA : NMONTH1(3)  TYPE C,
       NMONTH2(3)  TYPE C,
       NMONTH3(3)  TYPE C,
       NMONTH4(3)  TYPE C,
       NMONTH5(15) TYPE C.

DATA : W_KUNNR TYPE T001W-KUNNR,
       LABST   TYPE MARD-LABST.

DATA : CREQ1(8)    TYPE C,
       CREQ2(12)   TYPE C,
       CBUD(14)    TYPE C,
       CSTK(14)    TYPE C,

       NREQ1(8)    TYPE C,
       NREQ2(12)   TYPE C,
       NBUD(14)    TYPE C,
       NSTK(14)    TYPE C,

       NNREQ1(8)   TYPE C,
       NNREQ2(12)  TYPE C,
       NNBUD(14)   TYPE C,
       NNSTK(14)   TYPE C,

       NNNREQ1(8)  TYPE C,
       NNNREQ2(12) TYPE C,
       NNNBUD(14)  TYPE C,
       NNNSTK(14)  TYPE C.

DATA : DATE1 TYPE SY-DATUM,
       DATE2 TYPE SY-DATUM,
       DATE3 TYPE SY-DATUM,
       DATE4 TYPE SY-DATUM.
*       date5 TYPE sy-datum.

DATA : ZPROD_SAMP_REQ_WA   TYPE ZPROD_SAMP_REQ,
       ZPRODSAMP_STOCK_WA  TYPE ZPRODSAMP_STOCK,
       ZPRODSMSTOCK_BAT_WA TYPE ZPRODSMSTOCK_BAT.
DATA: LT_OBJECT TYPE STRING.
DATA:L_ID     TYPE THEAD-TDID,
     L_NAME   TYPE THEAD-TDNAME,
     L_OBJECT TYPE THEAD-TDOBJECT,
     L_LANG   TYPE THEAD-TDSPRAS,
     T_LINES  TYPE TABLE OF TLINE,
     L_LINE   TYPE TLINE.
DATA : MTART TYPE MARA-MTART.
DATA: OK LIKE SY-UCOMM.
DATA: OK1 LIKE SY-UCOMM.
DATA : REG(3) TYPE C,
       VAT    TYPE KONP-KBETR,
       ABT    TYPE KONP-KBETR.
DATA :A1      TYPE KONP-KBETR,
      A2      TYPE KONP-KBETR,
      A3      TYPE KONP-KBETR,
      A4      TYPE KONP-KBETR,
      A5      TYPE KONP-KBETR,
      A6      TYPE KONP-KBETR,
      A7      TYPE KONP-KBETR,
      A8      TYPE KONP-KBETR,
      A9      TYPE KONP-KBETR,
      A10     TYPE KONP-KBETR,
      A11     TYPE KONP-KBETR,
      A12     TYPE KONP-KBETR,
      PTS_VAL TYPE KONP-KBETR.

DATA : PER TYPE P DECIMALS 2,
       C1  TYPE P,
       C2  TYPE P,
       C3  TYPE P,
       C4  TYPE P,
       CR1 TYPE P,
       CR2 TYPE P,
       CR3 TYPE P,
       CR4 TYPE P.
DATA : NDATE1   TYPE SY-DATUM,
       NDATE2   TYPE SY-DATUM,
       FREEZDT  TYPE SY-DATUM,
       PNAME(6) TYPE C.
*data: ok like sy-ucomm.
*******************************************

DATA:  NSKFCL TYPE P DECIMALS 2,
       GOAFCL TYPE P DECIMALS 2,
       MUMFCL TYPE P DECIMALS 2,
       NSKCCL TYPE P DECIMALS 2,
       GOACCL TYPE P DECIMALS 2,
       MUMCCL TYPE P DECIMALS 2,
       NSKTCL TYPE P DECIMALS 2,
       GOATCL TYPE P DECIMALS 2,
       MUMTCL TYPE P DECIMALS 2,
       TOTFCL TYPE P DECIMALS 2,
       TOTCCL TYPE P DECIMALS 2,
       TOTTCL TYPE P DECIMALS 2.

DATA : NSKTOTCL TYPE P DECIMALS 2,
       GOATOTCL TYPE P DECIMALS 2,
       MUMTOTCL TYPE P DECIMALS 2,
       TOTTOTCL TYPE P DECIMALS 2.

DATA : DBNSKFCL   TYPE P DECIMALS 2,
       CRNSKFCL   TYPE P DECIMALS 2,
       DBNSKCCL   TYPE P DECIMALS 2,
       CRNSKCCL   TYPE P DECIMALS 2,
       DBNSKTCL   TYPE P DECIMALS 2,
       CRNSKTCL   TYPE P DECIMALS 2,
       CRNSKTOTCL TYPE P DECIMALS 2,
       DBNSKTOTCL TYPE P DECIMALS 2.
DATA : NSKCREQ    TYPE P DECIMALS 2,
       NSKRCREQ   TYPE P DECIMALS 2,
       NSKCBUD    TYPE P DECIMALS 2,
       NSKCL1     TYPE P DECIMALS 2,
       NSKNREQ    TYPE P DECIMALS 2,
       NSKRNREQ   TYPE P DECIMALS 2,
       NSKNBUD    TYPE P DECIMALS 2,
       NSKCL2     TYPE P DECIMALS 2,
       NSKNNREQ   TYPE P DECIMALS 2,
       NSKRNNREQ  TYPE P DECIMALS 2,
       NSKNNBUD   TYPE P DECIMALS 2,
       NSKCL3     TYPE P DECIMALS 2,
       NSKNNNREQ  TYPE P DECIMALS 2,
       NSKRNNNREQ TYPE P DECIMALS 2,
       NSKNNNBUD  TYPE P DECIMALS 2,
       NSKCL4     TYPE P DECIMALS 2.

DATA : GOACREQ    TYPE P DECIMALS 2,
       GOARCREQ   TYPE P DECIMALS 2,
       GOACBUD    TYPE P DECIMALS 2,
       GOACL1     TYPE P DECIMALS 2,
       GOANREQ    TYPE P DECIMALS 2,
       GOARNREQ   TYPE P DECIMALS 2,
       GOANBUD    TYPE P DECIMALS 2,
       GOACL2     TYPE P DECIMALS 2,
       GOANNREQ   TYPE P DECIMALS 2,
       GOARNNREQ  TYPE P DECIMALS 2,
       GOANNBUD   TYPE P DECIMALS 2,
       GOACL3     TYPE P DECIMALS 2,
       GOANNNREQ  TYPE P DECIMALS 2,
       GOARNNNREQ TYPE P DECIMALS 2,
       GOANNNBUD  TYPE P DECIMALS 2,
       GOACL4     TYPE P DECIMALS 2.

DATA : MUMCREQ    TYPE P DECIMALS 2,
       MUMRCREQ   TYPE P DECIMALS 2,
       MUMCBUD    TYPE P DECIMALS 2,
       MUMCL1     TYPE P DECIMALS 2,
       MUMNREQ    TYPE P DECIMALS 2,
       MUMRNREQ   TYPE P DECIMALS 2,
       MUMNBUD    TYPE P DECIMALS 2,
       MUMCL2     TYPE P DECIMALS 2,
       MUMNNREQ   TYPE P DECIMALS 2,
       MUMRNNREQ  TYPE P DECIMALS 2,
       MUMNNBUD   TYPE P DECIMALS 2,
       MUMCL3     TYPE P DECIMALS 2,
       MUMNNNREQ  TYPE P DECIMALS 2,
       MUMRNNNREQ TYPE P DECIMALS 2,
       MUMNNNBUD  TYPE P DECIMALS 2,
       MUMCL4     TYPE P DECIMALS 2.

DATA : TOTCREQ    TYPE P DECIMALS 2,
       TOTRCREQ   TYPE P DECIMALS 2,
       TOTCBUD    TYPE P DECIMALS 2,
       TOTCL1     TYPE P DECIMALS 2,
       TOTNREQ    TYPE P DECIMALS 2,
       TOTRNREQ   TYPE P DECIMALS 2,
       TOTNBUD    TYPE P DECIMALS 2,
       TOTCL2     TYPE P DECIMALS 2,
       TOTNNREQ   TYPE P DECIMALS 2,
       TOTRNNREQ  TYPE P DECIMALS 2,
       TOTNNBUD   TYPE P DECIMALS 2,
       TOTCL3     TYPE P DECIMALS 2,
       TOTNNNREQ  TYPE P DECIMALS 2,
       TOTRNNNREQ TYPE P DECIMALS 2,
       TOTNNNBUD  TYPE P DECIMALS 2,
       TOTCL4     TYPE P DECIMALS 2.

DATA : CRNSKCREQ    TYPE P DECIMALS 2,
       CRNSKRCREQ   TYPE P DECIMALS 2,
       CRNSKCBUD    TYPE P DECIMALS 2,
       CRNSKCL1     TYPE P DECIMALS 2,
       CRNSKNREQ    TYPE P DECIMALS 2,
       CRNSKRNREQ   TYPE P DECIMALS 2,
       CRNSKNBUD    TYPE P DECIMALS 2,
       CRNSKCL2     TYPE P DECIMALS 2,
       CRNSKNNREQ   TYPE P DECIMALS 2,
       CRNSKRNNREQ  TYPE P DECIMALS 2,
       CRNSKNNBUD   TYPE P DECIMALS 2,
       CRNSKCL3     TYPE P DECIMALS 2,
       CRNSKNNNREQ  TYPE P DECIMALS 2,
       CRNSKRNNNREQ TYPE P DECIMALS 2,
       CRNSKNNNBUD  TYPE P DECIMALS 2,
       CRNSKCL4     TYPE P DECIMALS 2.

DATA : DBNSKCREQ    TYPE P DECIMALS 2,
       DBNSKRCREQ   TYPE P DECIMALS 2,
       DBNSKCBUD    TYPE P DECIMALS 2,
       DBNSKCL1     TYPE P DECIMALS 2,
       DBNSKNREQ    TYPE P DECIMALS 2,
       DBNSKRNREQ   TYPE P DECIMALS 2,
       DBNSKNBUD    TYPE P DECIMALS 2,
       DBNSKCL2     TYPE P DECIMALS 2,
       DBNSKNNREQ   TYPE P DECIMALS 2,
       DBNSKRNNREQ  TYPE P DECIMALS 2,
       DBNSKNNBUD   TYPE P DECIMALS 2,
       DBNSKCL3     TYPE P DECIMALS 2,
       DBNSKNNNREQ  TYPE P DECIMALS 2,
       DBNSKRNNNREQ TYPE P DECIMALS 2,
       DBNSKNNNBUD  TYPE P DECIMALS 2,
       DBNSKCL4     TYPE P DECIMALS 2.

************************************************

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
PARAMETERS :
*plant LIKE mard-werks OBLIGATORY,
  M1(2) TYPE C,
  Y1(4) TYPE C,
  PDATE TYPE SY-DATUM DEFAULT SY-DATUM.

PARAMETERS : R1  RADIOBUTTON GROUP R1,
             R11 RADIOBUTTON GROUP R1.
PARAMETER :  R2 RADIOBUTTON GROUP R1,
             R3 RADIOBUTTON GROUP R1.

SELECTION-SCREEN END OF BLOCK MERKMALE1 .

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE2 WITH FRAME TITLE TEXT-001.
PARAMETERS : S1 AS CHECKBOX,
             S2 AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK MERKMALE2 .

INITIALIZATION.
  G_REPID = SY-REPID.

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

  IF NDATE2+4(2) NE PDATE+4(2).
    MESSAGE 'ENTER STOCK FREEZ MONTH & NEXT MONTH DATE FOR PRODUCTION PLANNING' TYPE 'E'.
  ENDIF.
  IF NDATE2+0(4) NE PDATE+0(4).
    MESSAGE 'ENTER STOCK FREEZ MONTH & NEXT MONTH DATE FOR PRODUCTION PLANNING' TYPE 'E'.
  ENDIF.

  PERFORM FORM1.

  SELECT * FROM ZPROD_ITEM1 INTO TABLE IT_ZPROD_ITEM1 WHERE MAKTX EQ '                                       '.
  LOOP AT IT_ZPROD_ITEM1 INTO WA_ZPROD_ITEM1.
    SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ WA_ZPROD_ITEM1-MATNR.
    IF SY-SUBRC EQ 0.
      ZPROD_ITEM1-MATNR = WA_ZPROD_ITEM1-MATNR.
      ZPROD_ITEM1-WERKS = WA_ZPROD_ITEM1-WERKS.
      ZPROD_ITEM1-MAKTX = MAKT-MAKTX.
      MODIFY ZPROD_ITEM1.
    ENDIF.
  ENDLOOP.


  IF R1 EQ 'X'.
    CALL SCREEN 9025.
  ELSEIF R11 EQ 'X'.
    PERFORM FAC_ALV.
  ELSEIF R2 EQ 'X'.
*    PERFORM valuation.
*    IF plant EQ '3000'.
*      PERFORM print_3000.
*    ELSE.
    PERFORM PRINT.
*    ENDIF.
  ELSEIF R3 EQ 'X'.
*    PERFORM valuation.
*    IF plant EQ '3000'.
*      PERFORM print_3000.
*    ELSE.
    PERFORM VALUATION.
  ENDIF.

*  PERFORM FAC_ALV.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FORM1 .

*IF plant EQ '1000'.
*    pname = 'NASIK'.
*  ELSEIF plant EQ '1001'.
*    pname = 'GOA'.
*  ELSEIF plant EQ '3000'.
*    pname = 'BOMBAY'.
*  ENDIF.
  PNAME = 'SAMPLE'.

*  CLEAR : w_kunnr.
*  SELECT SINGLE kunnr INTO w_kunnr FROM t001w WHERE werks EQ plant.
*  IF plant EQ '3000'.
  W_KUNNR = 'SAMPLES'.
*  ENDIF.

  DATE1 = PDATE.
  DATE1+6(2) = '01'.

  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = DATE1
    IMPORTING
      NEWDATE = DATE2.

  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = DATE2
    IMPORTING
      NEWDATE = DATE3.

  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
    EXPORTING
      MONTHS  = '1'
      OLDDATE = DATE3
    IMPORTING
      NEWDATE = DATE4.

*  CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
*    EXPORTING
*      months  = '1'
*      olddate = date4
*    IMPORTING
*      newdate = date5.


*  WRITE : / 'production planing DATE',DATE1, DATE2, DATE3,DATE4.

  SELECT SINGLE * FROM T247 WHERE SPRAS EQ 'EN' AND MNR EQ DATE1+4(2).
  IF SY-SUBRC EQ 0.
    NMONTH1 = T247-KTX.
  ENDIF.
  SELECT SINGLE * FROM T247 WHERE SPRAS EQ 'EN' AND MNR EQ DATE2+4(2).
  IF SY-SUBRC EQ 0.
    NMONTH2 = T247-KTX.
  ENDIF.
  SELECT SINGLE * FROM T247 WHERE SPRAS EQ 'EN' AND MNR EQ DATE3+4(2).
  IF SY-SUBRC EQ 0.
    NMONTH3 = T247-KTX.
  ENDIF.
  SELECT SINGLE * FROM T247 WHERE SPRAS EQ 'EN' AND MNR EQ DATE4+4(2).
  IF SY-SUBRC EQ 0.
    NMONTH4 = T247-KTX.
    CONCATENATE T247-LTX '''' DATE4+0(4) INTO NMONTH5.
  ENDIF.
*  IF R2 EQ 'X'.
*    PERFORM VALUATION.
*  ENDIF.

*  IF plant EQ '3000'.
*    mtart = 'ZHWA'.
  MTART = 'ZDSM'.
*  ELSE.
**    mtart = 'ZFRT'.
*    mtart = 'ZDSM'.
*  ENDIF.

*  select * from mara into table it_mara where mtart in ('ZFRT','ZHWA').
  SELECT * FROM MARA INTO TABLE IT_MARA WHERE MTART EQ MTART.
  LOOP AT IT_MARA INTO WA_MARA.
    SELECT SINGLE * FROM MARD WHERE MATNR EQ WA_MARA-MATNR.
    IF SY-SUBRC NE 0.
      DELETE IT_MARA WHERE MATNR EQ WA_MARA-MATNR.
    ENDIF.
  ENDLOOP.

**************************add LLM PRODUCTS (BCLL FINISHED IN ************************************
*BREAK-POINT.
*  IF plant EQ '3000'.
*    SELECT * FROM zprod_prd INTO TABLE it_zprod_prd.
*    LOOP AT it_zprod_prd INTO wa_zprod_prd.
*      wa_mara-matnr = wa_zprod_prd-matnr.
*      COLLECT wa_mara INTO it_mara.
*      CLEAR wa_mara.
*    ENDLOOP.
*  ENDIF.
*  BREAK-POINT.
*************************************************************************************************

  IF IT_MARA IS NOT INITIAL.
    SELECT * FROM MARD INTO TABLE IT_MARD FOR ALL ENTRIES IN IT_MARA WHERE MATNR EQ IT_MARA-MATNR AND LGORT NE 'CSM'.
    SELECT * FROM MVKE INTO TABLE IT_MVKE FOR ALL ENTRIES IN IT_MARA WHERE MATNR EQ IT_MARA-MATNR AND VKORG EQ '1000' AND VTWEG EQ '80'.
    SELECT * FROM ZBUDGET_TAB1 INTO TABLE IT_ZBUDGET_TAB1 FOR ALL ENTRIES IN IT_MARA WHERE MATNR EQ IT_MARA-MATNR AND TAG EQ 'S' AND DATAB EQ DATE1.
    SELECT * FROM ZPROD_SAMP_REQ INTO TABLE IT_ZPROD_SAMP_REQ FOR ALL ENTRIES IN IT_MARA WHERE MATNR EQ IT_MARA-MATNR AND PDATE GE DATE1 AND PDATE LE DATE4.
    SELECT * FROM MARC INTO TABLE IT_MARC FOR ALL ENTRIES IN IT_MARA WHERE MATNR EQ IT_MARA-MATNR.
  ENDIF.


  IF S1 EQ 'X'.
*    WRITE : / 'DATE1',date1.

    SELECT * FROM ZPRODSAMP_STOCK INTO TABLE IT_ZPRODSAMP_STOCK WHERE ZMONTH EQ M1 AND ZYEAR EQ Y1 .
    IF SY-SUBRC NE 0.
      MESSAGE 'THIS MONTH DATA IS NOT YET FREEZED' TYPE 'E'.
    ENDIF.

    SELECT SINGLE * FROM ZPRODSAMP_STOCK WHERE ZMONTH EQ M1 AND ZYEAR EQ Y1 AND BUDAT NE 0.
    IF SY-SUBRC EQ 0.
      FREEZDT = ZPRODSAMP_STOCK-BUDAT.
    ENDIF.
*    CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
*      EXPORTING
*        months  = '-1'
*        olddate = sy-datum
*      IMPORTING
*        newdate = ndate.
*    m2 = ndate+4(2).
*    y2 = ndate+0(4).
*    SELECT * FROM ZPRODSAMP_STOCK INTO TABLE it_ZPRODSAMP_STOCK1 WHERE zmonth EQ m2 AND zyear EQ y2 AND werks EQ plant.
*    IF sy-subrc NE 0.
*      MESSAGE 'BACK MONTH DATA NOT YET STORED' TYPE 'E'.
*    ENDIF.
  ENDIF.

  IF S1 NE 'X'.
    LOOP AT IT_MARC INTO WA_MARC.
      WA_TRAN1-MATNR = WA_MARC-MATNR.
      WA_TRAN1-TRAME = WA_MARC-TRAME.
      COLLECT WA_TRAN1 INTO IT_TRAN1.
      CLEAR WA_TRAN1.
    ENDLOOP.
  ENDIF.

*  ***************** PUT SOME OTHER LOGIC FOR PRODUCT RESTRCTION*******
  LOOP AT IT_MARA INTO WA_MARA.
    SELECT SINGLE * FROM ZPROD_ITEM1 WHERE MATNR EQ WA_MARA-MATNR.
    IF SY-SUBRC EQ 0.
      DELETE IT_MARA WHERE MATNR = ZPROD_ITEM1-MATNR.
    ENDIF.
  ENDLOOP.
  LOOP AT IT_MARA INTO WA_MARA.
    WA_TMVKE1-MATNR = WA_MARA-MATNR.
    COLLECT WA_TMVKE1 INTO IT_TMVKE1.
    CLEAR WA_TMVKE1.
  ENDLOOP.
  SORT IT_TMVKE1 BY MATNR.
  DELETE ADJACENT DUPLICATES FROM IT_TMVKE1 COMPARING MATNR.

*  IF plant EQ '3000'.
*    CLEAR : bstock.
*    IF s1 NE 'X'.
*      SELECT * FROM zvendordata INTO TABLE it_zvendordata.
*    ENDIF.
*    IF it_zvendordata IS NOT INITIAL.
*      LOOP AT it_zvendordata INTO wa_zvendordata.
*        SELECT SINGLE * FROM mard WHERE matnr EQ wa_zvendordata-matnr AND werks EQ plant.
*        IF sy-subrc NE 0.
*          WRITE : / 'Maintain material codes ',wa_zvendordata-matnr, ' for plant',plant.
*        ENDIF.
*        READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_zvendordata-matnr.
*        IF sy-subrc EQ 0.
*          wa_zven1-matnr = wa_mara-matnr.
*          IF s1 EQ 'X'.
*            SELECT SINGLE * FROM ZPRODSAMP_STOCK WHERE matnr EQ wa_zvendordata-matnr AND werks EQ '3000'.
*            IF sy-subrc EQ 0.
*              CLEAR bstock.
*              bstock = ZPRODSAMP_STOCK-fac_stk.
*            ENDIF.
*          ENDIF.
*          wa_zven1-stock = wa_zvendordata-stock + bstock.
*          COLLECT wa_zven1  INTO it_zven1.
*          CLEAR wa_zven1.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*    SORT it_zven1 BY matnr.
*    DELETE ADJACENT DUPLICATES FROM it_zven1 COMPARING matnr.

*    LOOP AT it_zven1 INTO wa_zven1.
*      wa_zven2-matnr = wa_zven1-matnr.
*      wa_zven2-stock = wa_zven1-stock.
*      READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_zven1-matnr.
*      IF sy-subrc EQ 0.
*        READ TABLE it_zvendordata INTO wa_zvendordata WITH KEY matnr = wa_mara-matnr.
*        IF sy-subrc EQ 0.
*          wa_zven2-mrp = wa_zvendordata-mrp.
*          wa_zven2-lifnr = wa_zvendordata-lifnr.
*        ENDIF.
*      ENDIF.
*      COLLECT wa_zven2 INTO it_zven2.
*      CLEAR wa_zven2.
*    ENDLOOP.
*  ENDIF.

  LOOP AT IT_ZBUDGET_TAB1 INTO WA_ZBUDGET_TAB1.
*    select single * from mvke where matnr eq wa_zbudget_tab1-matnr and vkorg eq '1000' and vtweg eq '10'.
*    if sy-subrc eq 0.
    WA_BUD1-MATNR = WA_ZBUDGET_TAB1-MATNR.
    WA_BUD1-BUDQTY = WA_ZBUDGET_TAB1-QTY.
    COLLECT WA_BUD1 INTO IT_BUD1.
    CLEAR WA_BUD1.
*    endif.
  ENDLOOP.
  SORT IT_BUD1 BY MATNR.
  IF S1 EQ 'X'.
    LOOP AT IT_ZPRODSAMP_STOCK INTO WA_ZPRODSAMP_STOCK.
      WA_CNF1-MATNR = WA_ZPRODSAMP_STOCK-MATNR.
      WA_CNF1-NSKSTK = WA_ZPRODSAMP_STOCK-NSKSTK.
      WA_CNF1-GOASTK = WA_ZPRODSAMP_STOCK-GOASTK.
      WA_CNF1-OZRSTK = WA_ZPRODSAMP_STOCK-OZRSTK.
      WA_CNF1-GHASTK = WA_ZPRODSAMP_STOCK-GHASTK.
      WA_CNF1-CNFSTK = WA_ZPRODSAMP_STOCK-CNFSTK.
      COLLECT WA_CNF1 INTO IT_CNF1.
      CLEAR WA_CNF1.
*      WA_FAC1-MATNR = WA_ZPRODSAMP_STOCK-MATNR.
*      WA_FAC1-LABST = WA_ZPRODSAMP_STOCK-FAC_STK.
*      COLLECT WA_FAC1 INTO IT_FAC1.
*      CLEAR WA_FAC1.
      WA_TRAN1-MATNR = WA_ZPRODSAMP_STOCK-MATNR.
      WA_TRAN1-TRAME = WA_ZPRODSAMP_STOCK-TRAME.
      COLLECT WA_TRAN1 INTO IT_TRAN1.
      CLEAR WA_TRAN1.
    ENDLOOP.
  ELSE.
    LOOP AT IT_MARD INTO WA_MARD .
*    and labst gt 0.
      CLEAR : LABST.
      LABST = WA_MARD-LABST + WA_MARD-SPEME.
      IF LABST GT 0.
        READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MARD-MATNR.
        IF SY-SUBRC EQ 0.
          WA_CNF1-MATNR = WA_MARA-MATNR.
          IF WA_MARD-WERKS EQ '1000'.
            WA_CNF1-NSKSTK = WA_MARD-LABST + WA_MARD-SPEME.
          ELSEIF WA_MARD-WERKS EQ '1001'.
            WA_CNF1-GOASTK = WA_MARD-LABST + WA_MARD-SPEME.
          ELSEIF WA_MARD-WERKS EQ '2002'.
            WA_CNF1-OZRSTK = WA_MARD-LABST + WA_MARD-SPEME.
          ELSEIF WA_MARD-WERKS EQ '2000'.
            WA_CNF1-GHASTK = WA_MARD-LABST + WA_MARD-SPEME.
          ELSE.
            WA_CNF1-CNFSTK = WA_MARD-LABST + WA_MARD-SPEME.
          ENDIF.
          COLLECT WA_CNF1 INTO IT_CNF1.
          CLEAR WA_CNF1.
        ENDIF.
      ENDIF.
    ENDLOOP.
*    LOOP AT IT_MARD INTO WA_MARD.
**     and labst gt 0.
**    WRITE : / 'TT',WA_MARD-MATNR,WA_MARD-LABST.
*      CLEAR : LABST.
*      LABST = WA_MARD-LABST +  WA_MARD-SPEME.
*      IF LABST GT 0.
*        READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = WA_MARD-MATNR.
*        IF SY-SUBRC EQ 0.
**      WRITE : / 'TT',WA_MVKE-MVGR4.
*          WA_FAC1-MATNR = WA_MARA-MATNR.
*        ENDIF.
*        WA_FAC1-LABST = WA_MARD-LABST + WA_MARD-SPEME.
*        COLLECT WA_FAC1 INTO IT_FAC1.
*        CLEAR WA_FAC1.
*      ENDIF.
*    ENDLOOP.

  ENDIF.

  LOOP AT IT_ZPROD_SAMP_REQ INTO WA_ZPROD_SAMP_REQ.
    WA_REQ1-MATNR = WA_ZPROD_SAMP_REQ-MATNR.
    WA_REQ1-PDATE = WA_ZPROD_SAMP_REQ-PDATE.
    WA_REQ1-QTY = WA_ZPROD_SAMP_REQ-QTY.
    WA_REQ1-RQTY = WA_ZPROD_SAMP_REQ-RQTY.
    WA_REQ1-BUDGET = WA_ZPROD_SAMP_REQ-BUDGET.
    COLLECT WA_REQ1 INTO IT_REQ1.
    CLEAR WA_REQ1.
  ENDLOOP.
*  SORT IT_FAC1 BY MATNR.
  SORT IT_MVKE BY MATNR.

*  IF plant EQ '3000'.
  MTART = 'ZDSM'.
*  ELSE.
*    mtart = 'ZDSM'.
*  ENDIF.

  SELECT * FROM MARA INTO TABLE IT_MARA1 WHERE MTART EQ MTART.
  IF SY-SUBRC EQ 0.
    SELECT * FROM MVKE INTO TABLE IT_MVKE1 FOR ALL ENTRIES IN IT_MARA1 WHERE  MATNR EQ IT_MARA1-MATNR AND VKORG EQ '1000' AND VTWEG EQ '80'.
  ENDIF.
  SORT IT_MVKE1 BY MVGR4.
  DELETE ADJACENT DUPLICATES FROM IT_MVKE1 COMPARING MVGR4.
************************************************


*  if r2 eq 'X'.
*    PERFORM fac_VALUATION.
*    PERFORM cnf_VALUATION.
*    PERFORM ALL_VALUATION.
*    PERFORM BONUS.
*  endif.

*  loop at it_mvke into wa_mvke.
  LOOP AT IT_TMVKE1 INTO WA_TMVKE1.
    WA_TAB1-MATNR = WA_TMVKE1-MATNR.
*    wa_tab1-plant = plant.
    WA_TAB1-CDATE = DATE1.
    WA_TAB1-NDATE = DATE2.
    WA_TAB1-NNDATE = DATE3.
    WA_TAB1-NNNDATE = DATE4.
    READ TABLE IT_TRAN1 INTO WA_TRAN1 WITH KEY MATNR = WA_TMVKE1-MATNR.
    IF SY-SUBRC EQ 0.
      CLEAR : ST1,ST2.
      ST1 = WA_TRAN1-TRAME MOD 1000.
      IF ST1 GE 500.
        ST2 = 1000 - ST1.
        WA_TRAN1-TRAME = WA_TRAN1-TRAME + ST2.
      ELSE.
        WA_TRAN1-TRAME = WA_TRAN1-TRAME - ST1.
      ENDIF.
      WA_TAB1-TRAME = WA_TRAN1-TRAME.
    ENDIF.

    READ TABLE IT_CNF1 INTO WA_CNF1 WITH KEY MATNR = WA_TMVKE1-MATNR.
    IF SY-SUBRC EQ 0.
      CLEAR : ST1,ST2.
      ST1 = WA_CNF1-NSKSTK MOD 1000.
      IF ST1 GE 500.
        ST2 = 1000 - ST1.
        WA_CNF1-NSKSTK = WA_CNF1-NSKSTK + ST2.
      ELSE.
        WA_CNF1-NSKSTK = WA_CNF1-NSKSTK - ST1.
      ENDIF.
      WA_TAB1-NSKSTK = WA_CNF1-NSKSTK.

      CLEAR : ST1,ST2.
      ST1 = WA_CNF1-GOASTK MOD 1000.
      IF ST1 GE 500.
        ST2 = 1000 - ST1.
        WA_CNF1-GOASTK = WA_CNF1-GOASTK + ST2.
      ELSE.
        WA_CNF1-GOASTK = WA_CNF1-GOASTK - ST1.
      ENDIF.
      WA_TAB1-GOASTK = WA_CNF1-GOASTK.

      CLEAR : ST1,ST2.
      ST1 = WA_CNF1-OZRSTK MOD 1000.
      IF ST1 GE 500.
        ST2 = 1000 - ST1.
        WA_CNF1-OZRSTK = WA_CNF1-OZRSTK + ST2.
      ELSE.
        WA_CNF1-OZRSTK = WA_CNF1-OZRSTK - ST1.
      ENDIF.
      WA_TAB1-OZRSTK = WA_CNF1-OZRSTK.

      CLEAR : ST1,ST2.
      ST1 = WA_CNF1-GHASTK MOD 1000.
      IF ST1 GE 500.
        ST2 = 1000 - ST1.
        WA_CNF1-GHASTK = WA_CNF1-GHASTK + ST2.
      ELSE.
        WA_CNF1-GHASTK = WA_CNF1-GHASTK - ST1.
      ENDIF.
      WA_TAB1-GHASTK = WA_CNF1-GHASTK.

      CLEAR : ST1,ST2.
      ST1 = WA_CNF1-CNFSTK MOD 1000.
      IF ST1 GE 500.
        ST2 = 1000 - ST1.
        WA_CNF1-CNFSTK = WA_CNF1-CNFSTK + ST2.
      ELSE.
        WA_CNF1-CNFSTK = WA_CNF1-CNFSTK - ST1.
      ENDIF.
      WA_TAB1-CNFSTK = WA_CNF1-CNFSTK.

***      READ TABLE IT_STKC1 INTO WA_STKC1 WITH KEY MATNR = WA_TMVKE1-MATNR.
***      IF SY-SUBRC EQ 0.
***        CNFLABST = CNFLABST + ( WA_STKC1-PTS * WA_TAB1-CNFLABST ).
***      ENDIF.
    ENDIF.

*    READ TABLE IT_FAC1 INTO WA_FAC1 WITH KEY MATNR = WA_TMVKE1-MATNR.
*    IF SY-SUBRC EQ 0.
*      CLEAR : ST1,ST2.
*      ST1 = WA_FAC1-LABST MOD 1000.
*      IF ST1 GE 500.
*        ST2 = 1000 - ST1.
*        WA_FAC1-LABST = WA_FAC1-LABST + ST2.
*      ELSE.
*        WA_FAC1-LABST = WA_FAC1-LABST - ST1.
*      ENDIF.
*      WA_TAB1-FACLABST = WA_FAC1-LABST.
*      READ TABLE IT_STKV1 INTO WA_STKV1 WITH KEY MATNR = WA_FAC1-MATNR.
*      IF SY-SUBRC EQ 0.
**        WRITE : / '33',WA_STKV1-MATNR,WA_STKV1-CHARG,WA_STKV1-PTS,WA_STKV1-CLABS.
*        IF PLANT NE '3000'.
*          FACLABST = FACLABST + ( WA_STKV1-PTS * WA_TAB1-FACLABST ).
*        ENDIF.
*      ENDIF.
*    ENDIF.
*BREAK-POINT.
*    TOTLABST = CNFLABST + FACLABST.
*    IF PLANT EQ '3000'.
*      LOOP AT IT_STKV1 INTO WA_STKV1 WHERE MATNR = WA_TMVKE1-MATNR.
*        FACLABST = FACLABST + ( WA_STKV1-PTS * WA_STKV1-CLABS ).
*      ENDLOOP.
*    ENDIF.
**************CURRENT MONTH**************
    READ TABLE IT_REQ1 INTO WA_REQ1 WITH KEY MATNR = WA_TMVKE1-MATNR PDATE = DATE1.
    IF SY-SUBRC EQ 0.
      WA_TAB1-CREQQTY = WA_REQ1-QTY.
      WA_TAB1-RCREQQTY = WA_REQ1-RQTY.
      WA_TAB1-CBUDQTY = WA_REQ1-BUDGET.
    ENDIF.
*    IF WA_TAB1-CBUDQTY EQ 0.
*      READ TABLE IT_BUD1 INTO WA_BUD1 WITH KEY MATNR = WA_TMVKE1-MATNR.
*      IF SY-SUBRC EQ 0.
*        WA_TAB1-CBUDQTY = WA_BUD1-BUDQTY.
*      ENDIF.
*    ENDIF.
******************NEXT MONTH*********
    READ TABLE IT_REQ1 INTO WA_REQ1 WITH KEY MATNR = WA_TMVKE1-MATNR PDATE = DATE2.
    IF SY-SUBRC EQ 0.
      WA_TAB1-NREQQTY = WA_REQ1-QTY.
      WA_TAB1-RNREQQTY = WA_REQ1-RQTY.
      WA_TAB1-NBUDQTY = WA_REQ1-BUDGET.
    ENDIF.
*****************  Mahadevan Sir told to make budget zero****************
*    IF WA_TAB1-NBUDQTY EQ 0.
*      READ TABLE IT_BUD1 INTO WA_BUD1 WITH KEY MATNR = WA_TAB1-MATNR.
*      IF SY-SUBRC EQ 0.
*        WA_TAB1-NBUDQTY = WA_BUD1-BUDQTY.
*      ENDIF.
*    ENDIF.
********************next to next month ************************
    READ TABLE IT_REQ1 INTO WA_REQ1 WITH KEY MATNR = WA_TMVKE1-MATNR PDATE = DATE3.
    IF SY-SUBRC EQ 0.
      WA_TAB1-NNREQQTY = WA_REQ1-QTY.
      WA_TAB1-RNNREQQTY = WA_REQ1-RQTY.
      WA_TAB1-NNBUDQTY = WA_REQ1-BUDGET.
    ENDIF.
*    IF WA_TAB1-NNBUDQTY EQ 0.
*      READ TABLE IT_BUD1 INTO WA_BUD1 WITH KEY MATNR = WA_TAB1-MATNR.
*      IF SY-SUBRC EQ 0.
*        WA_TAB1-NNBUDQTY = WA_BUD1-BUDQTY.
*      ENDIF.
*    ENDIF.
**********next next to next month********************
    READ TABLE IT_REQ1 INTO WA_REQ1 WITH KEY MATNR = WA_TMVKE1-MATNR PDATE = DATE4.
    IF SY-SUBRC EQ 0.
      WA_TAB1-NNNREQQTY = WA_REQ1-QTY.
      WA_TAB1-RNNNREQQTY = WA_REQ1-RQTY.
      WA_TAB1-NNNBUDQTY = WA_REQ1-BUDGET.
    ENDIF.
*    IF WA_TAB1-NNNBUDQTY EQ 0.
*      READ TABLE IT_BUD1 INTO WA_BUD1 WITH KEY MATNR = WA_TAB1-MATNR.
*      IF SY-SUBRC EQ 0.
*        WA_TAB1-NNNBUDQTY = WA_BUD1-BUDQTY.
*      ENDIF.
*    ENDIF.

**************************************************
    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
  ENDLOOP.
  SORT IT_TAB1 BY MATNR.

  SORT IT_MAT2 DESCENDING BY MATNR.
  SORT IT_MVKE DESCENDING BY MATNR.

  LOOP AT IT_MARA INTO WA_MARA.
    CONCATENATE WA_MARA-MATNR '1000' '10' INTO LT_OBJECT.

    L_ID = '0001'.
    L_OBJECT = 'MVKE'.
    L_NAME = LT_OBJECT.
    L_LANG = 'EN'.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        ID                      = L_ID
        LANGUAGE                = L_LANG
        NAME                    = L_NAME
        OBJECT                  = L_OBJECT
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
* IMPORTING
*       HEADER                  =
      TABLES
        LINES                   = T_LINES
      EXCEPTIONS
        ID                      = 1
        LANGUAGE                = 2
        NAME                    = 3
        NOT_FOUND               = 4
        OBJECT                  = 5
        REFERENCE_CHECK         = 6
        WRONG_ACCESS_TO_ARCHIVE = 7
        OTHERS                  = 8.
    IF SY-SUBRC = 0.
      READ TABLE T_LINES INTO L_LINE INDEX 1.
    ELSE.
      L_LINE = ' '.
    ENDIF.
    WA_MAT1-MATNR = WA_MARA-MATNR.
    WA_MAT1-TDLINE = L_LINE-TDLINE.
    COLLECT WA_MAT1 INTO IT_MAT1.
    CLEAR WA_MAT1.
  ENDLOOP.

  LOOP AT IT_TAB1 INTO WA_TAB1 WHERE MATNR GT 0.
*    WRITE : /'*', wa_tab1-mvgr4,wa_tab1-cnflabst.
*    read table it_mvke1 into wa_mvke1 with key mvgr4 = wa_tab1-mvgr4.
*    if sy-subrc eq 0.
*    WRITE : /'**', wa_tab1-mvgr4,wa_tab1-cnflabst.
    CLEAR :  TOTAL,CL1,CL2,CL3,CL4,QTY1,QTY2,QTY3,QTY4.
    CLEAR : ST1,ST2.
*    IF PLANT EQ '3000'.
*      TOTAL = WA_TAB1-CNFLABST + WA_TAB1-TRAME.
*    ELSE.
    TOTAL = WA_TAB1-NSKSTK + WA_TAB1-GOASTK + WA_TAB1-OZRSTK + WA_TAB1-GHASTK + WA_TAB1-CNFSTK + WA_TAB1-TRAME.
*    ENDIF.
    ST1 = TOTAL MOD 1000.
    IF ST1 GE 500.
      ST2 = 1000 - ST1.
      TOTAL = TOTAL + ST2.
    ELSE.
      TOTAL = TOTAL - ST1.
    ENDIF.

************** check this********************

    IF WA_TAB1-RCREQQTY NE 0.
      QTY1 = WA_TAB1-RCREQQTY.
*    ELSE.
*      QTY1 = WA_TAB1-CREQQTY.
    ENDIF.
    CL1 =  ( TOTAL + QTY1 ) - WA_TAB1-CBUDQTY.
    IF WA_TAB1-RNREQQTY NE 0.
      QTY2 = WA_TAB1-RNREQQTY.
*    ELSE.
*      QTY2 = WA_TAB1-NREQQTY.
    ENDIF.
    CL2 = ( CL1 + QTY2 ) - WA_TAB1-NBUDQTY.
    IF WA_TAB1-RNNREQQTY NE 0.
      QTY3 = WA_TAB1-RNNREQQTY.
*    ELSE.
*      QTY3 = WA_TAB1-NNREQQTY.
    ENDIF.
    CL3 = ( CL2 + QTY3 ) - WA_TAB1-NNBUDQTY.
    IF WA_TAB1-RNNNREQQTY NE 0.
      QTY4 = WA_TAB1-RNNNREQQTY.
*    ELSE.
*      QTY4 = WA_TAB1-NNNREQQTY.
    ENDIF.
    CL4 = ( CL3 + QTY4 ) - WA_TAB1-NNNBUDQTY.
    WA_TAB2-CDATE = WA_TAB1-CDATE.
    WA_TAB2-NDATE = WA_TAB1-NDATE.
    WA_TAB2-NNDATE = WA_TAB1-NNDATE.
    WA_TAB2-NNNDATE = WA_TAB1-NNNDATE.
    WA_TAB2-MATNR = WA_TAB1-MATNR.
    SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_TAB1-MATNR AND VKORG EQ '1000' AND VTWEG EQ '80'.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM TVM5T WHERE SPRAS EQ 'EN' AND MVGR5 EQ MVKE-MVGR5.
      IF SY-SUBRC EQ 0.
        WA_TAB2-BEZEI = TVM5T-BEZEI.
      ENDIF.
    ENDIF.

*    WA_TAB2-PLANT = WA_TAB1-PLANT.
    WA_TAB2-NSKSTK = WA_TAB1-NSKSTK.
    WA_TAB2-GOASTK = WA_TAB1-GOASTK.
    WA_TAB2-OZRSTK = WA_TAB1-OZRSTK.
    WA_TAB2-GHASTK = WA_TAB1-GHASTK.
    WA_TAB2-CNFSTK = WA_TAB1-CNFSTK.
    WA_TAB2-TRAME = WA_TAB1-TRAME.
    WA_TAB2-TOTAL = TOTAL.
    WA_TAB2-CDATE = WA_TAB1-CDATE.


    CLEAR : CLOS1,CLOS2,CLOS3,CLOS4.
    WA_TAB2-CREQQTY = WA_TAB1-CREQQTY.
    WA_TAB2-RCREQQTY = WA_TAB1-RCREQQTY.
    WA_TAB2-CBUDQTY = WA_TAB1-CBUDQTY.
    WA_TAB2-CL1 = CL1.
    WA_TAB2-NDATE = WA_TAB1-NDATE.
    WA_TAB2-NREQQTY = WA_TAB1-NREQQTY.
    WA_TAB2-RNREQQTY = WA_TAB1-RNREQQTY.
    WA_TAB2-NBUDQTY = WA_TAB1-NBUDQTY.
    WA_TAB2-CL2 = CL2.
    WA_TAB2-NNDATE = WA_TAB1-NNDATE.
    WA_TAB2-NNREQQTY = WA_TAB1-NNREQQTY.
    WA_TAB2-RNNREQQTY = WA_TAB1-RNNREQQTY.
    WA_TAB2-NNBUDQTY = WA_TAB1-NNBUDQTY.
    WA_TAB2-CL3 = CL3.
    WA_TAB2-NNNDATE = WA_TAB1-NNNDATE.
    WA_TAB2-NNNREQQTY = WA_TAB1-NNNREQQTY.
    WA_TAB2-RNNNREQQTY = WA_TAB1-RNNNREQQTY.
    WA_TAB2-NNNBUDQTY = WA_TAB1-NNNBUDQTY.
    WA_TAB2-CL4 = CL4.
*    IF PLANT EQ '3000'.
    READ TABLE IT_MAT1 INTO WA_MAT1 WITH KEY MATNR = WA_TAB1-MATNR.
    IF SY-SUBRC EQ 0.
      CONDENSE WA_MAT1-TDLINE .
      WA_TAB2-TDLINE = WA_MAT1-TDLINE.
    ENDIF.
    SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ WA_TAB1-MATNR.
    IF SY-SUBRC EQ 0.
      WA_TAB2-MAKTX = MAKT-MAKTX.
    ENDIF.
*    ENDIF.
    COLLECT WA_TAB2 INTO IT_TAB2.
    CLEAR WA_TAB2.
*    endif.
  ENDLOOP.

*  CCNFVAL = CNFLABST .
*  CFACVAL = FACLABST .
*  CTOTVAL = TOTLABST.
*
*  CCREQQTYVAL = CREQQTYVAL.
*  CRCREQQTYVAL = RCREQQTYVAL.
*  CCBUDQTYVAL = CBUDQTYVAL .
*  CCLOSING1 = CLOSING1 .
*
*  CNREQQTYVAL = NREQQTYVAL .
*  CRNREQQTYVAL = RNREQQTYVAL .
*  CNBUDQTYVAL = NBUDQTYVAL .
*  CCLOSING2 = CLOSING2 .
*
*  CNNREQQTYVAL = NNREQQTYVAL .
*  CRNNREQQTYVAL = RNNREQQTYVAL .
*  CNNBUDQTYVAL = NNBUDQTYVAL .
*  CCLOSING3 = CLOSING3 .
*
*  CNNNREQQTYVAL = NNNREQQTYVAL .
*  CRNNNREQQTYVAL = RNNNREQQTYVAL .
*  CNNNBUDQTYVAL = NNNBUDQTYVAL .
*  CCLOSING4 = CLOSING4 .






  CONCATENATE NMONTH1 'REQD' INTO CREQ1 SEPARATED BY '-'.
  CONCATENATE 'REV' NMONTH1 'REQD' INTO CREQ2 SEPARATED BY '-'.
  CONCATENATE NMONTH1 'ESTD. DISP' INTO CBUD SEPARATED BY '-'.
  CONCATENATE 'REV' NMONTH2 'REQD' INTO NREQ2 SEPARATED BY '-'.
  CONCATENATE NMONTH1 'CL.STOCK' INTO CSTK SEPARATED BY '-'.
  CONCATENATE NMONTH2 'ESTD. DISP' INTO NBUD SEPARATED BY '-'.
  CONCATENATE NMONTH2 'REQD' INTO NREQ1 SEPARATED BY '-'.
  CONCATENATE NMONTH2 'CL.STOCK' INTO NSTK SEPARATED BY '-'.
  CONCATENATE NMONTH3 'REQD' INTO NNREQ1 SEPARATED BY '-'.
  CONCATENATE 'REV' NMONTH3 'REQD' INTO NNREQ2 SEPARATED BY '-'.
  CONCATENATE NMONTH3 'ESTD. DISP' INTO NNBUD SEPARATED BY '-'.
  CONCATENATE NMONTH3 'CL. STOCK' INTO NNSTK SEPARATED BY '-'.
  CONCATENATE NMONTH4 'REQD' INTO NNNREQ1 SEPARATED BY '-'.
  CONCATENATE 'REV' NMONTH4 'REQD' INTO NNNREQ2 SEPARATED BY '-'.
  CONCATENATE NMONTH4 'ESTD. DISP' INTO NNNBUD SEPARATED BY '-'.
  CONCATENATE NMONTH4 'CL. STOCK' INTO NNNSTK SEPARATED BY '-'.

*  IF S2 EQ 'X'.
*    PERFORM FAC_VALUATION.
*    PERFORM CNF_VALUATION.
*  perform fac_cnf.
*  ENDIF.
*endform.                    " FORM1

  LOOP AT IT_TAB2 INTO WA_TAB2.
    PACK WA_TAB2-MATNR TO WA_TAB2-MATNR.
    CONDENSE WA_TAB2-MATNR.
    MODIFY IT_TAB2 FROM WA_TAB2 TRANSPORTING MATNR.
  ENDLOOP.

  LOOP AT IT_TAB2 INTO WA_TAB2 WHERE MATNR GT 0.

    ITAB3-MATNR = WA_TAB2-MATNR.
    ITAB3-MAKTX = WA_TAB2-MAKTX.
*    SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ WA_TAB2-MATNR.
*    IF SY-SUBRC EQ 0.
*      ITAB3-MAKTX = MAKT-MAKTX.
*    ENDIF.
    ITAB3-CDATE = WA_TAB2-CDATE.
    ITAB3-NDATE = WA_TAB2-NDATE.
    ITAB3-NNDATE = WA_TAB2-NNDATE.
    ITAB3-NNNDATE = WA_TAB2-NNNDATE.
    ITAB3-MATNR = WA_TAB2-MATNR.
    ITAB3-BEZEI = WA_TAB2-BEZEI.
*    ITAB3-PLANT = WA_TAB2-PLANT.
    ITAB3-NSKSTK = WA_TAB2-NSKSTK.
    ITAB3-GOASTK = WA_TAB2-GOASTK.
    ITAB3-OZRSTK = WA_TAB2-OZRSTK.
    ITAB3-GHASTK = WA_TAB2-GHASTK.
    ITAB3-CNFSTK = WA_TAB2-CNFSTK.
    ITAB3-TRAME = WA_TAB2-TRAME.
    ITAB3-TOTAL = WA_TAB2-TOTAL.
    ITAB3-CREQQTY = WA_TAB2-CREQQTY.
    ITAB3-RCREQQTY = WA_TAB2-RCREQQTY.
    ITAB3-CBUDQTY = WA_TAB2-CBUDQTY.
    ITAB3-CL1 = WA_TAB2-CL1.
    ITAB3-NREQQTY = WA_TAB2-NREQQTY.
    ITAB3-RNREQQTY = WA_TAB2-RNREQQTY.
    ITAB3-NBUDQTY = WA_TAB2-NBUDQTY.
    ITAB3-CL2 = WA_TAB2-CL2.
    ITAB3-NNREQQTY = WA_TAB2-NNREQQTY.
    ITAB3-RNNREQQTY = WA_TAB2-RNNREQQTY.
    ITAB3-NNBUDQTY = WA_TAB2-NNBUDQTY.
    ITAB3-CL3 = WA_TAB2-CL3.
    ITAB3-NNNREQQTY = WA_TAB2-NNNREQQTY.
    ITAB3-RNNNREQQTY = WA_TAB2-RNNNREQQTY.
    ITAB3-NNNBUDQTY = WA_TAB2-NNNBUDQTY.
    ITAB3-CL4 = WA_TAB2-CL4.
    COLLECT ITAB3.
*      CLEAR ITAB3.
  ENDLOOP.

*  IF PLANT EQ '3000'.
*    LOOP AT IT_TAB2 INTO WA_TAB2 WHERE MATNR GT 0.
*      ITAB4-MATNR = WA_TAB2-MATNR.
*      SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ WA_TAB2-MATNR.
*      IF SY-SUBRC EQ 0.
*        ITAB4-MAKTX = MAKT-MAKTX.
*      ENDIF.
*      ITAB4-CDATE = WA_TAB2-CDATE.
*      ITAB4-NDATE = WA_TAB2-NDATE.
*      ITAB4-NNDATE = WA_TAB2-NNDATE.
*      ITAB4-NNNDATE = WA_TAB2-NNNDATE.
*      ITAB4-MATNR = WA_TAB2-MATNR.
*      ITAB4-BEZEI = WA_TAB2-BEZEI.
*      ITAB4-PLANT = WA_TAB2-PLANT.
*      ITAB4-CNFLABST = WA_TAB2-CNFLABST.
*      ITAB4-FACLABST = WA_TAB2-FACLABST.
*      ITAB4-TRAME = WA_TAB2-TRAME.
*      ITAB4-TOTAL = WA_TAB2-TOTAL.
*      ITAB4-CREQQTY = WA_TAB2-CREQQTY.
*      ITAB4-RCREQQTY = WA_TAB2-RCREQQTY.
*      ITAB4-CBUDQTY = WA_TAB2-CBUDQTY.
*      ITAB4-CL1 = WA_TAB2-CL1.
*      ITAB4-NREQQTY = WA_TAB2-NREQQTY.
*      ITAB4-RNREQQTY = WA_TAB2-RNREQQTY.
*      ITAB4-NBUDQTY = WA_TAB2-NBUDQTY.
*      ITAB4-CL2 = WA_TAB2-CL2.
*      ITAB4-NNREQQTY = WA_TAB2-NNREQQTY.
*      ITAB4-RNNREQQTY = WA_TAB2-RNNREQQTY.
*      ITAB4-NNBUDQTY = WA_TAB2-NNBUDQTY.
*      ITAB4-CL3 = WA_TAB2-CL3.
*      ITAB4-NNNREQQTY = WA_TAB2-NNNREQQTY.
*      ITAB4-RNNNREQQTY = WA_TAB2-RNNNREQQTY.
*      ITAB4-NNNBUDQTY = WA_TAB2-NNNBUDQTY.
*      ITAB4-CL4 = WA_TAB2-CL4.
*      ITAB4-TDLINE = WA_TAB2-TDLINE.
*      COLLECT ITAB4.
**      CLEAR ITAB4.
*    ENDLOOP.
*  ENDIF.

  SORT ITAB3 BY MAKTX.
*  SORT ITAB4 BY MAKTX.

  LOOP AT IT_TAB2 INTO WA_TAB2 WHERE MATNR GT 0.
    WA_TAB21-MATNR = WA_TAB2-MATNR.
    WA_TAB21-MAKTX = WA_TAB2-MAKTX.
    WA_TAB21-CDATE = WA_TAB2-CDATE.
    WA_TAB21-NDATE = WA_TAB2-NDATE.
    WA_TAB21-NNDATE = WA_TAB2-NNDATE.
    WA_TAB21-NNNDATE = WA_TAB2-NNNDATE.
    WA_TAB21-MATNR = WA_TAB2-MATNR.
    WA_TAB21-BEZEI = WA_TAB2-BEZEI.
*    WA_TAB21-PLANT = WA_TAB2-PLANT.
    WA_TAB21-NSKSTK = WA_TAB2-NSKSTK.
    WA_TAB21-GOASTK = WA_TAB2-GOASTK.
    WA_TAB21-OZRSTK = WA_TAB2-OZRSTK.
    WA_TAB21-GHASTK = WA_TAB2-GHASTK.
    WA_TAB21-CNFSTK = WA_TAB2-CNFSTK.
    WA_TAB21-TRAME = WA_TAB2-TRAME.
    WA_TAB21-TOTAL = WA_TAB2-TOTAL.
    WA_TAB21-CREQQTY = WA_TAB2-CREQQTY.
    WA_TAB21-RCREQQTY = WA_TAB2-RCREQQTY.
    WA_TAB21-CBUDQTY = WA_TAB2-CBUDQTY.
    WA_TAB21-CL1 = WA_TAB2-CL1.
    WA_TAB21-NREQQTY = WA_TAB2-NREQQTY.
    WA_TAB21-RNREQQTY = WA_TAB2-RNREQQTY.
    WA_TAB21-NBUDQTY = WA_TAB2-NBUDQTY.
    WA_TAB21-CL2 = WA_TAB2-CL2.
    WA_TAB21-NNREQQTY = WA_TAB2-NNREQQTY.
    WA_TAB21-RNNREQQTY = WA_TAB2-RNNREQQTY.
    WA_TAB21-NNBUDQTY = WA_TAB2-NNBUDQTY.
    WA_TAB21-CL3 = WA_TAB2-CL3.
    WA_TAB21-NNNREQQTY = WA_TAB2-NNNREQQTY.
    WA_TAB21-RNNNREQQTY = WA_TAB2-RNNNREQQTY.
    WA_TAB21-NNNBUDQTY = WA_TAB2-NNNBUDQTY.
    WA_TAB21-CL4 = WA_TAB2-CL4.
    WA_TAB21-TDLINE = WA_TAB2-TDLINE.
    COLLECT WA_TAB21 INTO IT_TAB21.
    CLEAR WA_TAB21.
  ENDLOOP.




ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FAC_VALUATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM TOP.

  DATA: COMMENT    TYPE SLIS_T_LISTHEADER,
        WA_COMMENT LIKE LINE OF COMMENT.

  WA_COMMENT-TYP = 'A'.
  WA_COMMENT-INFO = 'PRESS SAVE BUTTON TO UPDATE REQUIRED QUANTITY'.
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


FORM USER_COMM USING UCOMM LIKE SY-UCOMM
                   SELFIELD TYPE SLIS_SELFIELD.
  CASE SY-UCOMM. "SELFIELD-FIELDNAME.
    WHEN '&DATA_SAVE'(001).
      PERFORM UPDATE_DATA.
*      CALL TRANSACTION 'ZPRODSAMPPLAN'.
      EXIT.
*     PERFORM BDC.
    WHEN 'BACK'.
*      CALL TRANSACTION 'ZPRODSAMPPLAN'.
      EXIT.
    WHEN OTHERS.
      EXIT.
  ENDCASE.
  EXIT.
ENDFORM.

FORM FAC_VALUATION .
  IF IT_MVKE IS NOT INITIAL.
    SELECT * FROM MARA INTO TABLE IT_MARA_1 FOR ALL ENTRIES IN IT_MVKE WHERE MATNR EQ IT_MVKE-MATNR AND MTART EQ 'ZDSM'.
    IF SY-SUBRC EQ 0.
      SELECT * FROM MCHB INTO TABLE IT_MCHB FOR ALL ENTRIES IN IT_MARA_1 WHERE MATNR EQ IT_MARA_1-MATNR  AND LGORT NE 'CSM'.
*        and clabs gt 0.
    ENDIF.
  ENDIF.

  LOOP AT IT_MCHB INTO WA_MCHB.
*    WRITE : / 'Factory stock',PLANT,wa_mchb-matnr,WA_MCHB-CHARG,WA_MCHB-CLABS.
    WA_STK1-MATNR = WA_MCHB-MATNR.
    WA_STK1-CHARG = WA_MCHB-CHARG.
    IF WA_MCHB-WERKS EQ '1000'.
      WA_STK1-NSKSTK = WA_MCHB-CLABS + WA_MCHB-CSPEM.
    ELSEIF WA_MCHB-WERKS EQ '1001'.
      WA_STK1-GOASTK = WA_MCHB-CLABS + WA_MCHB-CSPEM.
    ELSEIF WA_MCHB-WERKS EQ '2002'.
      WA_STK1-OZRSTK = WA_MCHB-CLABS + WA_MCHB-CSPEM.
    ELSEIF WA_MCHB-WERKS EQ '2000'.
      WA_STK1-GHASTK = WA_MCHB-CLABS + WA_MCHB-CSPEM.
    ELSE.
      WA_STK1-CNFSTK = WA_MCHB-CLABS + WA_MCHB-CSPEM.
    ENDIF.

    COLLECT WA_STK1 INTO IT_STK1.
    CLEAR WA_STK1.
  ENDLOOP.

*  DELETE IT_STK1 WHERE CLABS EQ 0.
  SORT IT_STK1 BY MATNR CHARG.
  LOOP AT IT_STK1 INTO WA_STK1.
*      WRITE : / 'Factory stock',PLANT,wa_stk1-matnr,WA_stk1-CHARG,WA_stk1-CLABS.
    WA_STOCK1-MATNR = WA_STK1-MATNR.
    WA_STOCK1-CHARG = WA_STK1-CHARG.
    WA_STOCK1-NSKSTK = WA_STK1-NSKSTK.
    WA_STOCK1-GOASTK = WA_STK1-GOASTK.
    WA_STOCK1-OZRSTK = WA_STK1-OZRSTK.
    WA_STOCK1-GHASTK = WA_STK1-GHASTK.
    WA_STOCK1-CNFSTK = WA_STK1-CNFSTK.
    COLLECT WA_STOCK1 INTO IT_STOCK1.
    CLEAR WA_STOCK1.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CNF_VALUATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*FORM CNF_VALUATION .
*  CLEAR : IT_MARA_1,IT_MCHB.
*  IF IT_MVKE IS NOT INITIAL.
*    SELECT * FROM MARA INTO TABLE IT_MARA_1 FOR ALL ENTRIES IN IT_MVKE WHERE MATNR EQ IT_MVKE-MATNR AND MTART eq 'ZDSM'.
*    IF SY-SUBRC EQ 0.
*      SELECT * FROM MCHB INTO TABLE IT_MCHB FOR ALL ENTRIES IN IT_MARA_1 WHERE MATNR EQ IT_MARA_1-MATNR AND WERKS NE '1000' AND WERKS NE '1001'
*        AND WERKS NE '3000' AND LGORT NE 'CSM'.
**         and clabs gt 0.
*    ENDIF.
*  ENDIF.
*  CLEAR: IT_STK1,IT_STK2, IT_STK3,IT_STK4.
*  LOOP AT IT_MCHB INTO WA_MCHB.
**    WRITE : / '11',wa_mchb-matnr,WA_MCHB-CHARG,WA_MCHB-CLABS.
**    READ TABLE it_mvke INTO wa_mvke with KEY matnr = wa_mchb-matnr.
**    if sy-subrc eq 0.
**      WRITE : wa_mvke-mvgr4.
**    ENDIF.
*    WA_STK1-MATNR = WA_MCHB-MATNR.
*    WA_STK1-CHARG = WA_MCHB-CHARG.
*    WA_STK1-CLABS = WA_MCHB-CLABS + WA_MCHB-CSPEM.
*    COLLECT WA_STK1 INTO IT_STK1.
*    CLEAR WA_STK1.
*  ENDLOOP.
*  DELETE IT_STK1 WHERE CLABS EQ 0.
*  SORT IT_STK1 BY MATNR CHARG.
*  LOOP AT IT_STK1 INTO WA_STK1.
**    WRITE : / 'cnf stk',PLANT,WA_STK1-MATNR,WA_STK1-CHARG,WA_STK1-CLABS.
**    wa_stk2-matnr = wa_stk1-matnr.
**    wa_stk2-charg = wa_stk1-charg.
**    wa_stk2-clabs = wa_stk1-clabs.
*    WA_STOCK1-MATNR = WA_STK1-MATNR.
*    WA_STOCK1-CHARG = WA_STK1-CHARG.
*    WA_STOCK1-WERKS = PLANT.
*    WA_STOCK1-CNF_STK = WA_STK1-CLABS.
*    COLLECT WA_STOCK1 INTO IT_STOCK1.
*    CLEAR WA_STOCK1.
*  ENDLOOP.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FAC_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM FAC_ALV .

*  WA_FIELDCAT-FIELDNAME = 'PLANT'.
*  WA_FIELDCAT-SELTEXT_L = 'PLANT'.
*  WA_FIELDCAT-KEY = 'X'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'MATNR'.
  WA_FIELDCAT-SELTEXT_L = 'PRODUCT CODE'.
  WA_FIELDCAT-KEY = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

*  IF PLANT EQ '3000'.
*    WA_FIELDCAT-FIELDNAME = 'TDLINE'.
*    WA_FIELDCAT-SELTEXT_L = 'VENDOR NAME'.
*    WA_FIELDCAT-KEY = 'X'.
*    APPEND WA_FIELDCAT TO FIELDCAT.
*  ENDIF.

  WA_FIELDCAT-FIELDNAME = 'MAKTX'.
  WA_FIELDCAT-SELTEXT_L = 'PRODUCT DESCRIPTION'.
  WA_FIELDCAT-KEY = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'CDATE'..
  WA_FIELDCAT-SELTEXT_L = 'DATE1'.
  WA_FIELDCAT-KEY = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NSKSTK'.
  WA_FIELDCAT-SELTEXT_L = 'NASIK CL.STK'.
  WA_FIELDCAT-KEY = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'GOASTK'.
  WA_FIELDCAT-SELTEXT_L = 'GOA CL.STK'.
  WA_FIELDCAT-KEY = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'OZRSTK'.
  WA_FIELDCAT-SELTEXT_L = 'OZAR CL.STK'.
  WA_FIELDCAT-KEY = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'GHASTK'.
  WA_FIELDCAT-SELTEXT_L = 'GAZIABAD CL.STK'.
  WA_FIELDCAT-KEY = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'CNFSTK'.
  WA_FIELDCAT-SELTEXT_L = 'OTHER CL.STK'.
  WA_FIELDCAT-KEY = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'TRAME'.
  WA_FIELDCAT-SELTEXT_L = 'TRANSIT STOCK'.
  WA_FIELDCAT-KEY = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.
*
  WA_FIELDCAT-FIELDNAME = 'TOTAL'.
  WA_FIELDCAT-SELTEXT_L = 'TOTAL STOCK'.
  WA_FIELDCAT-KEY = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.
*
  WA_FIELDCAT-FIELDNAME = 'CREQQTY'.
*  WA_FIELDCAT-seltext_l = 'MONTH1 REQD'.
  WA_FIELDCAT-SELTEXT_L = CREQ1.
  WA_FIELDCAT-EDIT = 'X'.

  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'RCREQQTY'.
  WA_FIELDCAT-SELTEXT_L = CREQ2.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'CBUDQTY'.
  WA_FIELDCAT-SELTEXT_L = CBUD.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'CL1'.
  WA_FIELDCAT-SELTEXT_L = CSTK.
  WA_FIELDCAT-KEY = 'X'.
  WA_FIELDCAT-EDIT = ' '.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NDATE'.
  WA_FIELDCAT-SELTEXT_L = 'DATE2'.
  WA_FIELDCAT-KEY = 'X'.
  WA_FIELDCAT-EDIT = ' '.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NREQQTY'.
  WA_FIELDCAT-SELTEXT_L = NREQ1.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'RNREQQTY'.
  WA_FIELDCAT-SELTEXT_L = NREQ2.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NBUDQTY'.
  WA_FIELDCAT-SELTEXT_L = NBUD.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'CL2'.
  WA_FIELDCAT-SELTEXT_L = NSTK.
  WA_FIELDCAT-KEY = 'X'.
  WA_FIELDCAT-EDIT = ' '.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NNDATE'.
  WA_FIELDCAT-SELTEXT_L = 'DATE3'.
  WA_FIELDCAT-KEY = 'X'.
  WA_FIELDCAT-EDIT = ' '.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NNREQQTY'.
  WA_FIELDCAT-SELTEXT_L = NNREQ1.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'RNNREQQTY'.
  WA_FIELDCAT-SELTEXT_L = NNREQ2.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NNBUDQTY'.
  WA_FIELDCAT-SELTEXT_L = NNBUD.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'CL3'.
  WA_FIELDCAT-SELTEXT_L = NNSTK.
  WA_FIELDCAT-KEY = 'X'.
  WA_FIELDCAT-EDIT = ' '.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NNNDATE'.
  WA_FIELDCAT-SELTEXT_L = 'DATE4'.
  WA_FIELDCAT-KEY = 'X'.
  WA_FIELDCAT-EDIT = ' '.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NNNREQQTY'.
  WA_FIELDCAT-SELTEXT_L = NNNREQ1.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'RNNNREQQTY'.
  WA_FIELDCAT-SELTEXT_L = NNNREQ2.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'NNNBUDQTY'.
  WA_FIELDCAT-SELTEXT_L = NNNBUD.
  WA_FIELDCAT-EDIT = 'X'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-FIELDNAME = 'CL4'.
  WA_FIELDCAT-SELTEXT_L = NNNSTK.
  WA_FIELDCAT-KEY = 'X'.
  WA_FIELDCAT-EDIT = ' '.

  APPEND WA_FIELDCAT TO FIELDCAT.


  LAYOUT-ZEBRA = 'X'.
  LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
  LAYOUT-WINDOW_TITLEBAR  = 'UPDATE PRODUCTION PLANNING REQUIREMENT'.


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
      T_OUTTAB                = IT_TAB21
    EXCEPTIONS
      PROGRAM_ERROR           = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  CLEAR : IT_TAB2, WA_TAB2.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDATE_DATA .

  IF S2 EQ 'X'.
    DELETE FROM ZPRODSAMP_STOCK WHERE ZMONTH EQ SY-DATUM+4(2) AND ZYEAR EQ SY-DATUM+0(4) .
    DELETE FROM ZPRODSMSTOCK_BAT WHERE ZMONTH EQ SY-DATUM+4(2) AND ZYEAR EQ SY-DATUM+0(4) .
*BREAK-POINT.
    LOOP AT IT_TAB21 INTO WA_TAB21.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          INPUT  = WA_TAB21-MATNR
        IMPORTING
          OUTPUT = WA_TAB21-MATNR.


*    WHERE TICK EQ 'X'.
      ZPRODSAMP_STOCK_WA-ZMONTH = SY-DATUM+4(2).
      ZPRODSAMP_STOCK_WA-ZYEAR = SY-DATUM+0(4).
      ZPRODSAMP_STOCK_WA-MATNR = WA_TAB21-MATNR.
      ZPRODSAMP_STOCK_WA-NSKSTK = WA_TAB21-NSKSTK.
      ZPRODSAMP_STOCK_WA-GOASTK = WA_TAB21-GOASTK.
      ZPRODSAMP_STOCK_WA-OZRSTK = WA_TAB21-OZRSTK.
      ZPRODSAMP_STOCK_WA-GHASTK = WA_TAB21-GHASTK.
      ZPRODSAMP_STOCK_WA-CNFSTK = WA_TAB21-CNFSTK.
      ZPRODSAMP_STOCK_WA-TRAME = WA_TAB21-TRAME.
      ZPRODSAMP_STOCK_WA-BUDAT = SY-DATUM.
      ZPRODSAMP_STOCK_WA-VENDOR_NAME1 = WA_TAB21-TDLINE.

      ZPRODSAMP_STOCK_WA-BUDAT1 = WA_TAB21-CDATE.
      ZPRODSAMP_STOCK_WA-QTY1 = WA_TAB21-CREQQTY.
      ZPRODSAMP_STOCK_WA-RQTY1 = WA_TAB21-RCREQQTY.
      ZPRODSAMP_STOCK_WA-BUDGET1 = WA_TAB21-CBUDQTY.
      ZPRODSAMP_STOCK_WA-CL1 = WA_TAB21-CL1.

      ZPRODSAMP_STOCK_WA-BUDAT2 = WA_TAB21-NDATE.
      ZPRODSAMP_STOCK_WA-QTY2 = WA_TAB21-NREQQTY.
      ZPRODSAMP_STOCK_WA-RQTY2 = WA_TAB21-RNREQQTY.
      ZPRODSAMP_STOCK_WA-BUDGET2 = WA_TAB21-NBUDQTY.
      ZPRODSAMP_STOCK_WA-CL2 = WA_TAB21-CL2.

      ZPRODSAMP_STOCK_WA-BUDAT3 = WA_TAB21-NNDATE.
      ZPRODSAMP_STOCK_WA-QTY3 = WA_TAB21-NNREQQTY.
      ZPRODSAMP_STOCK_WA-RQTY3 = WA_TAB21-RNNREQQTY.
      ZPRODSAMP_STOCK_WA-BUDGET3 = WA_TAB21-NNBUDQTY.
      ZPRODSAMP_STOCK_WA-CL3 = WA_TAB21-CL3.

      ZPRODSAMP_STOCK_WA-BUDAT4 = WA_TAB21-NNNDATE.
      ZPRODSAMP_STOCK_WA-QTY4 = WA_TAB21-NNNREQQTY.
      ZPRODSAMP_STOCK_WA-RQTY4 = WA_TAB21-RNNNREQQTY.
      ZPRODSAMP_STOCK_WA-BUDGET4 = WA_TAB21-NNNBUDQTY.
      ZPRODSAMP_STOCK_WA-CL4 = WA_TAB21-CL4.

      MODIFY ZPRODSAMP_STOCK FROM ZPRODSAMP_STOCK_WA.
      COMMIT WORK AND WAIT.
      CLEAR : ZPRODSAMP_STOCK_WA.
      LOOP AT IT_STOCK1 INTO WA_STOCK1 WHERE MATNR EQ WA_TAB21-MATNR.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            INPUT  = WA_STOCK1-MATNR
          IMPORTING
            OUTPUT = WA_STOCK1-MATNR.

        ZPRODSMSTOCK_BAT_WA-ZMONTH = SY-DATUM+4(2).
        ZPRODSMSTOCK_BAT_WA-ZYEAR = SY-DATUM+0(4).
        ZPRODSMSTOCK_BAT_WA-MATNR = WA_STOCK1-MATNR.
        ZPRODSMSTOCK_BAT_WA-CHARG = WA_STOCK1-CHARG.
        ZPRODSMSTOCK_BAT_WA-NSKSTK = WA_STOCK1-NSKSTK.
        ZPRODSMSTOCK_BAT_WA-GOASTK = WA_STOCK1-GOASTK.
        ZPRODSMSTOCK_BAT_WA-OZRSTK = WA_STOCK1-OZRSTK.
        ZPRODSMSTOCK_BAT_WA-GHASTK = WA_STOCK1-GHASTK.
        ZPRODSMSTOCK_BAT_WA-CNFSTK = WA_STOCK1-CNFSTK.
        ZPRODSMSTOCK_BAT_WA-BUDAT = SY-DATUM.
        MODIFY ZPRODSMSTOCK_BAT FROM ZPRODSMSTOCK_BAT_WA.
        COMMIT WORK AND WAIT.
      ENDLOOP.
    ENDLOOP.
  ENDIF.

  LOOP AT IT_TAB21 INTO WA_TAB21.
*    WHERE TICK EQ 'X'.
*    ZPROD_SAMP_REQ_WA-PLANT = WA_TAB21-PLANT.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = WA_TAB21-MATNR
      IMPORTING
        OUTPUT = WA_TAB21-MATNR.

    ZPROD_SAMP_REQ_WA-MATNR = WA_TAB21-MATNR.
    ZPROD_SAMP_REQ_WA-PDATE = WA_TAB21-CDATE.
    ZPROD_SAMP_REQ_WA-QTY = WA_TAB21-CREQQTY.
    ZPROD_SAMP_REQ_WA-RQTY = WA_TAB21-RCREQQTY.
    ZPROD_SAMP_REQ_WA-BUDGET = WA_TAB21-CBUDQTY.
    MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
    COMMIT WORK AND WAIT.

*    ZPROD_SAMP_REQ_WA-PLANT = WA_TAB21-PLANT.
    ZPROD_SAMP_REQ_WA-MATNR = WA_TAB21-MATNR.
    ZPROD_SAMP_REQ_WA-PDATE = WA_TAB21-NDATE.
    ZPROD_SAMP_REQ_WA-QTY = WA_TAB21-NREQQTY.
    ZPROD_SAMP_REQ_WA-RQTY = WA_TAB21-RNREQQTY.
    ZPROD_SAMP_REQ_WA-BUDGET = WA_TAB21-NBUDQTY.
    MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
    COMMIT WORK AND WAIT.

*    ZPROD_SAMP_REQ_WA-PLANT = WA_TAB21-PLANT.
    ZPROD_SAMP_REQ_WA-MATNR = WA_TAB21-MATNR.
    ZPROD_SAMP_REQ_WA-PDATE = WA_TAB21-NNDATE.
    ZPROD_SAMP_REQ_WA-QTY = WA_TAB21-NNREQQTY.
    ZPROD_SAMP_REQ_WA-RQTY = WA_TAB21-RNNREQQTY.
    ZPROD_SAMP_REQ_WA-BUDGET = WA_TAB21-NNBUDQTY.
    MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
    COMMIT WORK AND WAIT.

*    ZPROD_SAMP_REQ_WA-PLANT = WA_TAB21-PLANT.
    ZPROD_SAMP_REQ_WA-MATNR = WA_TAB21-MATNR.
    ZPROD_SAMP_REQ_WA-PDATE = WA_TAB21-NNNDATE.
    ZPROD_SAMP_REQ_WA-QTY = WA_TAB21-NNNREQQTY.
    ZPROD_SAMP_REQ_WA-RQTY = WA_TAB21-RNNNREQQTY.
    ZPROD_SAMP_REQ_WA-BUDGET = WA_TAB21-NNNBUDQTY.
    MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
    COMMIT WORK AND WAIT.

  ENDLOOP.
*  BREAK-POINT.
  MESSAGE 'DATA SAVED' TYPE 'I'.

  CALL TRANSACTION 'ZPRODSAMPPLAN'.
  EXIT.

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



  LOOP AT IT_TAB21 INTO WA_TAB21 WHERE MATNR GT 0.

    WA_TAB3-MAKTX = WA_TAB21-MAKTX.
    WA_TAB3-CDATE = WA_TAB21-CDATE.
    WA_TAB3-NDATE = WA_TAB21-NDATE.
    WA_TAB3-NNDATE = WA_TAB21-NNDATE.
    WA_TAB3-NNNDATE = WA_TAB21-NNNDATE.
    WA_TAB3-MATNR = WA_TAB21-MATNR.
*    wa_tab3-plant = wa_tab21-plant.
    WA_TAB3-NSKSTK = WA_TAB21-NSKSTK.
    WA_TAB3-GOASTK = WA_TAB21-GOASTK.
    WA_TAB3-OZRSTK = WA_TAB21-OZRSTK.
    WA_TAB3-GHASTK = WA_TAB21-GHASTK.
    WA_TAB3-CNFSTK = WA_TAB21-CNFSTK.
    WA_TAB3-TRAME = WA_TAB21-TRAME.
    WA_TAB3-TOTAL = WA_TAB21-TOTAL.
    WA_TAB3-CREQQTY = WA_TAB21-CREQQTY.
    WA_TAB3-RCREQQTY = WA_TAB21-RCREQQTY.
    WA_TAB3-CBUDQTY = WA_TAB21-CBUDQTY.
    WA_TAB3-CL1 = WA_TAB21-CL1.
    WA_TAB3-NREQQTY = WA_TAB21-NREQQTY.
    WA_TAB3-RNREQQTY = WA_TAB21-RNREQQTY.
    WA_TAB3-NBUDQTY = WA_TAB21-NBUDQTY.
    WA_TAB3-CL2 = WA_TAB21-CL2.
    WA_TAB3-NNREQQTY = WA_TAB21-NNREQQTY.
    WA_TAB3-RNNREQQTY = WA_TAB21-RNNREQQTY.
    WA_TAB3-NNBUDQTY = WA_TAB21-NNBUDQTY.
    WA_TAB3-CL3 = WA_TAB21-CL3.
    WA_TAB3-NNNREQQTY = WA_TAB21-NNNREQQTY.
    WA_TAB3-RNNNREQQTY = WA_TAB21-RNNNREQQTY.
    WA_TAB3-NNNBUDQTY = WA_TAB21-NNNBUDQTY.
    WA_TAB3-CL4 = WA_TAB21-CL4.
    WA_TAB3-TDLINE = WA_TAB21-TDLINE.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ WA_TAB21-MATNR.
    IF SY-SUBRC EQ 0.
      IF MARA-EXTWG EQ 'CRD'.
        WA_TAB3-PRDTYP = '2'.
      ELSEIF MARA-EXTWG EQ 'DBT'.
        WA_TAB3-PRDTYP = '3'.
      ELSE.
        WA_TAB3-PRDTYP = '1'.
      ENDIF.
    ENDIF.
    CLEAR : MATNR1.
    UNPACK WA_TAB21-MATNR TO MATNR1.

    SELECT SINGLE * FROM MARD WHERE MATNR EQ MATNR1 AND WERKS EQ '2002' AND LGORT GE 'NS01' AND LGORT LE 'NS04'.
    IF SY-SUBRC EQ 0.
      WA_TAB3-LOCATION = '1. NASIK'.
    ELSE.
      SELECT SINGLE * FROM MARD WHERE MATNR EQ MATNR1 AND WERKS EQ '2002' AND LGORT GE 'GA01' AND LGORT LE 'GA04'.
      IF SY-SUBRC EQ 0.
        WA_TAB3-LOCATION = '2. GOA'.
      ELSE.
        SELECT SINGLE * FROM MARD WHERE MATNR EQ MATNR1 AND WERKS EQ '2002' AND LGORT GE 'MU01' AND LGORT LE 'MU04'.
        IF SY-SUBRC EQ 0.
          WA_TAB3-LOCATION = '3. MUMBAI'.
        ELSE.
          SELECT SINGLE * FROM MARD WHERE MATNR EQ MATNR1 AND WERKS EQ '1000' AND LGORT GE 'FG01' AND LGORT LE 'FG04'.
          IF SY-SUBRC EQ 0.
            WA_TAB3-LOCATION = '1. NASIK'.
          ELSE.
            SELECT SINGLE * FROM MARD WHERE MATNR EQ MATNR1 AND WERKS EQ '1001' AND LGORT GE 'FG01' AND LGORT LE 'FG04'.
            IF SY-SUBRC EQ 0.
              WA_TAB3-LOCATION = '2. GOA'.
            ELSE.
              WA_TAB3-LOCATION = '3. MUMBAI'.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    COLLECT WA_TAB3 INTO IT_TAB3.
    CLEAR WA_TAB3.
  ENDLOOP.
*SORT IT_TAB3 BY LOCATION MAKTX.

  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
      DEVICE   = 'PRINTER'
      DIALOG   = 'X'
*     form     = 'ZSR9_1'
      LANGUAGE = SY-LANGU
    EXCEPTIONS
      CANCELED = 1
      DEVICE   = 2.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  CALL FUNCTION 'START_FORM'
    EXPORTING
      FORM        = 'ZPRODSAMP'
      LANGUAGE    = SY-LANGU
    EXCEPTIONS
      FORM        = 1
      FORMAT      = 2
      UNENDED     = 3
      UNOPENED    = 4
      UNUSED      = 5
      SPOOL_ERROR = 6
      CODEPAGE    = 7
      OTHERS      = 8.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
*SORT IT_TAB3 BY PRDTYP MATNR.
  SORT IT_TAB3 BY LOCATION PRDTYP MAKTX.
  LOOP AT IT_TAB3 INTO WA_TAB3.
    ON CHANGE OF WA_TAB3-PRDTYP.
      IF WA_TAB3-PRDTYP EQ '2'.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            ELEMENT = 'C1'
            WINDOW  = 'MAIN'.
      ELSEIF WA_TAB3-PRDTYP EQ '3'.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            ELEMENT = 'C2'
            WINDOW  = 'MAIN'.
      ENDIF.
    ENDON.
    ON CHANGE OF WA_TAB3-LOCATION.
      IF WA_TAB3-LOCATION EQ '2. GOA'.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            ELEMENT = 'T12'
            WINDOW  = 'MAIN'.
      ENDIF.
      IF WA_TAB3-LOCATION EQ '3. MUMBAI'.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            ELEMENT = 'T12'
            WINDOW  = 'MAIN'.
      ENDIF.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          ELEMENT = 'T11'
          WINDOW  = 'MAIN'.

    ENDON.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        ELEMENT = 'T1'
        WINDOW  = 'MAIN'.

    AT LAST.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          ELEMENT = 'T2'
          WINDOW  = 'MAIN'.
    ENDAT.
  ENDLOOP.

  CALL FUNCTION 'END_FORM'
    EXCEPTIONS
      UNOPENED                 = 1
      BAD_PAGEFORMAT_FOR_PRINT = 2
      SPOOL_ERROR              = 3
      CODEPAGE                 = 4
      OTHERS                   = 5.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  CALL FUNCTION 'CLOSE_FORM'
* IMPORTING
*   RESULT                         =
*   RDI_RESULT                     =
* TABLES
*   OTFDATA                        =
    EXCEPTIONS
      UNOPENED                 = 1
      BAD_PAGEFORMAT_FOR_PRINT = 2
      SEND_ERROR               = 3
      SPOOL_ERROR              = 4
      CODEPAGE                 = 5
      OTHERS                   = 6.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.

*&SPWIZARD: DECLARATION OF TABLECONTROL 'TBC_9025' ITSELF
CONTROLS: TBC_9025 TYPE TABLEVIEW USING SCREEN 9025.

*&SPWIZARD: LINES OF TABLECONTROL 'TBC_9025'
DATA:     G_TBC_9025_LINES  LIKE SY-LOOPC.

DATA:     OK_CODE LIKE SY-UCOMM.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TBC_9025'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: UPDATE LINES FOR EQUIVALENT SCROLLBAR
MODULE TBC_9025_CHANGE_TC_ATTR OUTPUT.
  DESCRIBE TABLE ITAB3 LINES TBC_9025-LINES.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TC 'TBC_9025'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GET LINES OF TABLECONTROL
MODULE TBC_9025_GET_LINES OUTPUT.
  G_TBC_9025_LINES = SY-LOOPC.
ENDMODULE.

*&SPWIZARD: INPUT MODUL FOR TC 'TBC_9025'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: MARK TABLE
MODULE TBC_9025_MARK INPUT.
  DATA: G_TBC_9025_WA2 LIKE LINE OF ITAB3.
  IF TBC_9025-LINE_SEL_MODE = 1
  AND ITAB3-TICK = 'X'.
    LOOP AT ITAB3 INTO G_TBC_9025_WA2
      WHERE TICK = 'X'.
      G_TBC_9025_WA2-TICK = ''.
      MODIFY ITAB3
        FROM G_TBC_9025_WA2
        TRANSPORTING TICK.
    ENDLOOP.
  ENDIF.
  MODIFY ITAB3
    INDEX TBC_9025-CURRENT_LINE
    TRANSPORTING TICK.
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TC 'TBC_9025'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: PROCESS USER COMMAND
MODULE TBC_9025_USER_COMMAND INPUT.
  OK_CODE = SY-UCOMM.
  PERFORM USER_OK_TC USING    'TBC_9025'
                              'ITAB3'
                              'TICK'
                     CHANGING OK_CODE.
  SY-UCOMM = OK_CODE.
ENDMODULE.

*----------------------------------------------------------------------*
*   INCLUDE TABLECONTROL_FORMS                                         *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  USER_OK_TC                                               *
*&---------------------------------------------------------------------*
FORM USER_OK_TC USING    P_TC_NAME TYPE DYNFNAM
                         P_TABLE_NAME
                         P_MARK_NAME
                CHANGING P_OK      LIKE SY-UCOMM.

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA: L_OK     TYPE SY-UCOMM,
        L_OFFSET TYPE I.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

*&SPWIZARD: Table control specific operations                          *
*&SPWIZARD: evaluate TC name and operations                            *
  SEARCH P_OK FOR P_TC_NAME.
  IF SY-SUBRC <> 0.
    EXIT.
  ENDIF.
  L_OFFSET = STRLEN( P_TC_NAME ) + 1.
  L_OK = P_OK+L_OFFSET.
*&SPWIZARD: execute general and TC specific operations                 *
  CASE L_OK.
    WHEN 'INSR'.                      "insert row
      PERFORM FCODE_INSERT_ROW USING    P_TC_NAME
                                        P_TABLE_NAME.
      CLEAR P_OK.

    WHEN 'DELE'.                      "delete row
      PERFORM FCODE_DELETE_ROW USING    P_TC_NAME
                                        P_TABLE_NAME
                                        P_MARK_NAME.
      CLEAR P_OK.

    WHEN 'P--' OR                     "top of list
         'P-'  OR                     "previous page
         'P+'  OR                     "next page
         'P++'.                       "bottom of list
      PERFORM COMPUTE_SCROLLING_IN_TC USING P_TC_NAME
                                            L_OK.
      CLEAR P_OK.
*     WHEN 'L--'.                       "total left
*       PERFORM FCODE_TOTAL_LEFT USING P_TC_NAME.
*
*     WHEN 'L-'.                        "column left
*       PERFORM FCODE_COLUMN_LEFT USING P_TC_NAME.
*
*     WHEN 'R+'.                        "column right
*       PERFORM FCODE_COLUMN_RIGHT USING P_TC_NAME.
*
*     WHEN 'R++'.                       "total right
*       PERFORM FCODE_TOTAL_RIGHT USING P_TC_NAME.
*
    WHEN 'MARK'.                      "mark all filled lines
      PERFORM FCODE_TC_MARK_LINES USING P_TC_NAME
                                        P_TABLE_NAME
                                        P_MARK_NAME   .
      CLEAR P_OK.

    WHEN 'DMRK'.                      "demark all filled lines
      PERFORM FCODE_TC_DEMARK_LINES USING P_TC_NAME
                                          P_TABLE_NAME
                                          P_MARK_NAME .
      CLEAR P_OK.

*     WHEN 'SASCEND'   OR
*          'SDESCEND'.                  "sort column
*       PERFORM FCODE_SORT_TC USING P_TC_NAME
*                                   l_ok.

  ENDCASE.

ENDFORM.                              " USER_OK_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_INSERT_ROW                                         *
*&---------------------------------------------------------------------*
FORM FCODE_INSERT_ROW
              USING    P_TC_NAME           TYPE DYNFNAM
                       P_TABLE_NAME             .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA L_LINES_NAME       LIKE FELD-NAME.
  DATA L_SELLINE          LIKE SY-STEPL.
  DATA L_LASTLINE         TYPE I.
  DATA L_LINE             TYPE I.
  DATA L_TABLE_NAME       LIKE FELD-NAME.
  FIELD-SYMBOLS <TC>                 TYPE CXTAB_CONTROL.
  FIELD-SYMBOLS <TABLE>              TYPE STANDARD TABLE.
  FIELD-SYMBOLS <LINES>              TYPE I.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (P_TC_NAME) TO <TC>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE P_TABLE_NAME '[]' INTO L_TABLE_NAME. "table body
  ASSIGN (L_TABLE_NAME) TO <TABLE>.                "not headerline

*&SPWIZARD: get looplines of TableControl                              *
  CONCATENATE 'G_' P_TC_NAME '_LINES' INTO L_LINES_NAME.
  ASSIGN (L_LINES_NAME) TO <LINES>.

*&SPWIZARD: get current line                                           *
  GET CURSOR LINE L_SELLINE.
  IF SY-SUBRC <> 0.                   " append line to table
    L_SELLINE = <TC>-LINES + 1.
*&SPWIZARD: set top line                                               *
    IF L_SELLINE > <LINES>.
      <TC>-TOP_LINE = L_SELLINE - <LINES> + 1 .
    ELSE.
      <TC>-TOP_LINE = 1.
    ENDIF.
  ELSE.                               " insert line into table
    L_SELLINE = <TC>-TOP_LINE + L_SELLINE - 1.
    L_LASTLINE = <TC>-TOP_LINE + <LINES> - 1.
  ENDIF.
*&SPWIZARD: set new cursor line                                        *
  L_LINE = L_SELLINE - <TC>-TOP_LINE + 1.

*&SPWIZARD: insert initial line                                        *
  INSERT INITIAL LINE INTO <TABLE> INDEX L_SELLINE.
  <TC>-LINES = <TC>-LINES + 1.
*&SPWIZARD: set cursor                                                 *
  SET CURSOR LINE L_LINE.

ENDFORM.                              " FCODE_INSERT_ROW

*&---------------------------------------------------------------------*
*&      Form  FCODE_DELETE_ROW                                         *
*&---------------------------------------------------------------------*
FORM FCODE_DELETE_ROW
              USING    P_TC_NAME           TYPE DYNFNAM
                       P_TABLE_NAME
                       P_MARK_NAME   .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA L_TABLE_NAME       LIKE FELD-NAME.

  FIELD-SYMBOLS <TC>         TYPE CXTAB_CONTROL.
  FIELD-SYMBOLS <TABLE>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <WA>.
  FIELD-SYMBOLS <MARK_FIELD>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (P_TC_NAME) TO <TC>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE P_TABLE_NAME '[]' INTO L_TABLE_NAME. "table body
  ASSIGN (L_TABLE_NAME) TO <TABLE>.                "not headerline

*&SPWIZARD: delete marked lines                                        *
  DESCRIBE TABLE <TABLE> LINES <TC>-LINES.

  LOOP AT <TABLE> ASSIGNING <WA>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT P_MARK_NAME OF STRUCTURE <WA> TO <MARK_FIELD>.

    IF <MARK_FIELD> = 'X'.
      DELETE <TABLE> INDEX SYST-TABIX.
      IF SY-SUBRC = 0.
        <TC>-LINES = <TC>-LINES - 1.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.                              " FCODE_DELETE_ROW

*&---------------------------------------------------------------------*
*&      Form  COMPUTE_SCROLLING_IN_TC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*      -->P_OK       ok code
*----------------------------------------------------------------------*
FORM COMPUTE_SCROLLING_IN_TC USING    P_TC_NAME
                                      P_OK.
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA L_TC_NEW_TOP_LINE     TYPE I.
  DATA L_TC_NAME             LIKE FELD-NAME.
  DATA L_TC_LINES_NAME       LIKE FELD-NAME.
  DATA L_TC_FIELD_NAME       LIKE FELD-NAME.

  FIELD-SYMBOLS <TC>         TYPE CXTAB_CONTROL.
  FIELD-SYMBOLS <LINES>      TYPE I.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (P_TC_NAME) TO <TC>.
*&SPWIZARD: get looplines of TableControl                              *
  CONCATENATE 'G_' P_TC_NAME '_LINES' INTO L_TC_LINES_NAME.
  ASSIGN (L_TC_LINES_NAME) TO <LINES>.


*&SPWIZARD: is no line filled?                                         *
  IF <TC>-LINES = 0.
*&SPWIZARD: yes, ...                                                   *
    L_TC_NEW_TOP_LINE = 1.
  ELSE.
*&SPWIZARD: no, ...                                                    *
    CALL FUNCTION 'SCROLLING_IN_TABLE'
      EXPORTING
        ENTRY_ACT      = <TC>-TOP_LINE
        ENTRY_FROM     = 1
        ENTRY_TO       = <TC>-LINES
        LAST_PAGE_FULL = 'X'
        LOOPS          = <LINES>
        OK_CODE        = P_OK
        OVERLAPPING    = 'X'
      IMPORTING
        ENTRY_NEW      = L_TC_NEW_TOP_LINE
      EXCEPTIONS
*       NO_ENTRY_OR_PAGE_ACT  = 01
*       NO_ENTRY_TO    = 02
*       NO_OK_CODE_OR_PAGE_GO = 03
        OTHERS         = 0.
  ENDIF.

*&SPWIZARD: get actual tc and column                                   *
  GET CURSOR FIELD L_TC_FIELD_NAME
             AREA  L_TC_NAME.

  IF SYST-SUBRC = 0.
    IF L_TC_NAME = P_TC_NAME.
*&SPWIZARD: et actual column                                           *
      SET CURSOR FIELD L_TC_FIELD_NAME LINE 1.
    ENDIF.
  ENDIF.

*&SPWIZARD: set the new top line                                       *
  <TC>-TOP_LINE = L_TC_NEW_TOP_LINE.


ENDFORM.                              " COMPUTE_SCROLLING_IN_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_MARK_LINES
*&---------------------------------------------------------------------*
*       marks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM FCODE_TC_MARK_LINES USING P_TC_NAME
                               P_TABLE_NAME
                               P_MARK_NAME.
*&SPWIZARD: EGIN OF LOCAL DATA-----------------------------------------*
  DATA L_TABLE_NAME       LIKE FELD-NAME.

  FIELD-SYMBOLS <TC>         TYPE CXTAB_CONTROL.
  FIELD-SYMBOLS <TABLE>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <WA>.
  FIELD-SYMBOLS <MARK_FIELD>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (P_TC_NAME) TO <TC>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE P_TABLE_NAME '[]' INTO L_TABLE_NAME. "table body
  ASSIGN (L_TABLE_NAME) TO <TABLE>.                "not headerline

*&SPWIZARD: mark all filled lines                                      *
  LOOP AT <TABLE> ASSIGNING <WA>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT P_MARK_NAME OF STRUCTURE <WA> TO <MARK_FIELD>.

    <MARK_FIELD> = 'X'.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_DEMARK_LINES
*&---------------------------------------------------------------------*
*       demarks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
FORM FCODE_TC_DEMARK_LINES USING P_TC_NAME
                                 P_TABLE_NAME
                                 P_MARK_NAME .
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
  DATA L_TABLE_NAME       LIKE FELD-NAME.

  FIELD-SYMBOLS <TC>         TYPE CXTAB_CONTROL.
  FIELD-SYMBOLS <TABLE>      TYPE STANDARD TABLE.
  FIELD-SYMBOLS <WA>.
  FIELD-SYMBOLS <MARK_FIELD>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

  ASSIGN (P_TC_NAME) TO <TC>.

*&SPWIZARD: get the table, which belongs to the tc                     *
  CONCATENATE P_TABLE_NAME '[]' INTO L_TABLE_NAME. "table body
  ASSIGN (L_TABLE_NAME) TO <TABLE>.                "not headerline

*&SPWIZARD: demark all filled lines                                    *
  LOOP AT <TABLE> ASSIGNING <WA>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
    ASSIGN COMPONENT P_MARK_NAME OF STRUCTURE <WA> TO <MARK_FIELD>.

    <MARK_FIELD> = SPACE.
  ENDLOOP.
ENDFORM.                                          "fcode_tc_mark_lines
*&---------------------------------------------------------------------*
*&      Module  STATUS_9025  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9025 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'TITLE'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9025  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9025 INPUT.
  CASE OK.
*   BREAK-POINT.
    WHEN 'SAVE'.
      PERFORM UPDATE.
*      PERFORM UPDATE_DATA.
*        MESSAGE 'SAVED' TYPE 'I'.
*    WHEN 'ENTER'.
*      PERFORM UPDATE.
*      BREAK-POINT.
    WHEN 'BACK' OR 'EXIT'.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  UPDATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDATE .
*  BREAK-POINT.
  LOOP AT ITAB3.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = ITAB3-MATNR
      IMPORTING
        OUTPUT = ITAB3-MATNR.

*   WHERE TICK EQ 'X'.

*    ZPROD_SAMP_REQ_wa-plant = itab3-plant.
    ZPROD_SAMP_REQ_WA-MATNR = ITAB3-MATNR.
    ZPROD_SAMP_REQ_WA-PDATE = ITAB3-CDATE.
    ZPROD_SAMP_REQ_WA-QTY = ITAB3-CREQQTY.
    ZPROD_SAMP_REQ_WA-RQTY = ITAB3-RCREQQTY.
    ZPROD_SAMP_REQ_WA-BUDGET = ITAB3-CBUDQTY.
    MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
    COMMIT WORK AND WAIT.

*    ZPROD_SAMP_REQ_wa-plant = itab3-plant.
    ZPROD_SAMP_REQ_WA-MATNR = ITAB3-MATNR.
    ZPROD_SAMP_REQ_WA-PDATE = ITAB3-NDATE.
    ZPROD_SAMP_REQ_WA-QTY = ITAB3-NREQQTY.
    ZPROD_SAMP_REQ_WA-RQTY = ITAB3-RNREQQTY.
    ZPROD_SAMP_REQ_WA-BUDGET = ITAB3-NBUDQTY.
    MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
    COMMIT WORK AND WAIT.

*    ZPROD_SAMP_REQ_wa-plant = itab3-plant.
    ZPROD_SAMP_REQ_WA-MATNR = ITAB3-MATNR.
    ZPROD_SAMP_REQ_WA-PDATE = ITAB3-NNDATE.
    ZPROD_SAMP_REQ_WA-QTY = ITAB3-NNREQQTY.
    ZPROD_SAMP_REQ_WA-RQTY = ITAB3-RNNREQQTY.
    ZPROD_SAMP_REQ_WA-BUDGET = ITAB3-NNBUDQTY.
    MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
    COMMIT WORK AND WAIT.

*    ZPROD_SAMP_REQ_wa-plant = itab3-plant.
    ZPROD_SAMP_REQ_WA-MATNR = ITAB3-MATNR.
    ZPROD_SAMP_REQ_WA-PDATE = ITAB3-NNNDATE.
    ZPROD_SAMP_REQ_WA-QTY = ITAB3-NNNREQQTY.
    ZPROD_SAMP_REQ_WA-RQTY = ITAB3-RNNNREQQTY.
    ZPROD_SAMP_REQ_WA-BUDGET = ITAB3-NNNBUDQTY.
    MODIFY ZPROD_SAMP_REQ FROM ZPROD_SAMP_REQ_WA.
    COMMIT WORK AND WAIT.

  ENDLOOP.

  MESSAGE 'DATA SAVED' TYPE 'I'.
  CLEAR : OK.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  CALC  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE CALC INPUT.
  CLEAR : C1,C2,C3,C4,CR1,CR2,CR3,CR4.

*  IF ITAB3-RCREQQTY GT 0.
    C1 = ( ITAB3-TOTAL + ITAB3-RCREQQTY ) - ITAB3-CBUDQTY.
    ITAB3-CL1 = C1.
    MODIFY ITAB3  INDEX TBC_9025-CURRENT_LINE TRANSPORTING CREQQTY RCREQQTY CBUDQTY CL1.
*  ELSE.
*    C1 = ( ITAB3-TOTAL + ITAB3-CREQQTY ) - ITAB3-CBUDQTY.
*    ITAB3-CL1 = C1.
*    MODIFY ITAB3  INDEX TBC_9025-CURRENT_LINE TRANSPORTING CREQQTY RCREQQTY CBUDQTY CL1.
*  ENDIF.

*  IF ITAB3-RNREQQTY GT 0.
    C2 = ( C1 + ITAB3-RNREQQTY ) - ITAB3-NBUDQTY.
    ITAB3-CL2 = C2.
*    CR2 = C1 + ITAB3-NREQQTY .
*    ITAB3-RNREQQTY = CR2.
    MODIFY ITAB3  INDEX TBC_9025-CURRENT_LINE TRANSPORTING NREQQTY RNREQQTY NBUDQTY CL2.
*  ELSE.
*    C2 = ( C1 + ITAB3-NREQQTY ) - ITAB3-NBUDQTY.
*    ITAB3-CL2 = C2.
**    CR2 = C1 + ITAB3-NREQQTY .
**    ITAB3-RNREQQTY = CR2.
*    MODIFY ITAB3  INDEX TBC_9025-CURRENT_LINE TRANSPORTING NREQQTY RNREQQTY NBUDQTY CL2.
*  ENDIF.

*  IF ITAB3-RNNREQQTY GT 0.
    C3 = ( C2 + ITAB3-RNNREQQTY ) - ITAB3-NNBUDQTY.
    ITAB3-CL3 = C3.
*  CR3 = C2 + ITAB3-NNREQQTY .
*  itab3-RNNREQQTY = CR3.
    MODIFY ITAB3  INDEX TBC_9025-CURRENT_LINE TRANSPORTING NNREQQTY RNNREQQTY NNBUDQTY CL3.
*  ELSE.
*    C3 = ( C2 + ITAB3-NNREQQTY ) - ITAB3-NNBUDQTY.
*    ITAB3-CL3 = C3.
**  CR3 = C2 + ITAB3-NNREQQTY .
**  itab3-RNNREQQTY = CR3.
*    MODIFY ITAB3  INDEX TBC_9025-CURRENT_LINE TRANSPORTING NNREQQTY RNNREQQTY NNBUDQTY CL3.
*  ENDIF.

*  IF ITAB3-RNNNREQQTY GT 0.
    C4 = ( C3 + ITAB3-RNNNREQQTY ) - ITAB3-NNNBUDQTY.
    ITAB3-CL4 = C4.
*  CR4 = C3 + ITAB3-NNNREQQTY .
*  itab3-RNNNREQQTY = CR4.
    MODIFY ITAB3  INDEX TBC_9025-CURRENT_LINE TRANSPORTING NNNREQQTY RNNNREQQTY NNNBUDQTY CL4.
*  ELSE.
*    C4 = ( C3 + ITAB3-NNNREQQTY ) - ITAB3-NNNBUDQTY.
*    ITAB3-CL4 = C4.
**  CR4 = C3 + ITAB3-NNNREQQTY .
**  itab3-RNNNREQQTY = CR4.
*    MODIFY ITAB3  INDEX TBC_9025-CURRENT_LINE TRANSPORTING NNNREQQTY RNNNREQQTY NNNBUDQTY CL4.
*  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  VALUATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM VALUATION .
  WRITE : / 'RATE MAINTAINED IN TCODE - ZPRODSAMPRT'.
  ULINE.
  LOOP AT IT_TAB21 INTO WA_TAB21 WHERE MATNR GT 0.

    WA_TAB3-MAKTX = WA_TAB21-MAKTX.
    WA_TAB3-CDATE = WA_TAB21-CDATE.
    WA_TAB3-NDATE = WA_TAB21-NDATE.
    WA_TAB3-NNDATE = WA_TAB21-NNDATE.
    WA_TAB3-NNNDATE = WA_TAB21-NNNDATE.
    WA_TAB3-MATNR = WA_TAB21-MATNR.
*    wa_tab3-plant = wa_tab21-plant.
    WA_TAB3-NSKSTK = WA_TAB21-NSKSTK.
    WA_TAB3-GOASTK = WA_TAB21-GOASTK.
    WA_TAB3-OZRSTK = WA_TAB21-OZRSTK.
    WA_TAB3-GHASTK = WA_TAB21-GHASTK.
    WA_TAB3-CNFSTK = WA_TAB21-CNFSTK.
    WA_TAB3-TRAME = WA_TAB21-TRAME.
    WA_TAB3-TOTAL = WA_TAB21-TOTAL.
    WA_TAB3-CREQQTY = WA_TAB21-CREQQTY.
    WA_TAB3-RCREQQTY = WA_TAB21-RCREQQTY.
    WA_TAB3-CBUDQTY = WA_TAB21-CBUDQTY.
    WA_TAB3-CL1 = WA_TAB21-CL1.
    WA_TAB3-NREQQTY = WA_TAB21-NREQQTY.
    WA_TAB3-RNREQQTY = WA_TAB21-RNREQQTY.
    WA_TAB3-NBUDQTY = WA_TAB21-NBUDQTY.
    WA_TAB3-CL2 = WA_TAB21-CL2.
    WA_TAB3-NNREQQTY = WA_TAB21-NNREQQTY.
    WA_TAB3-RNNREQQTY = WA_TAB21-RNNREQQTY.
    WA_TAB3-NNBUDQTY = WA_TAB21-NNBUDQTY.
    WA_TAB3-CL3 = WA_TAB21-CL3.
    WA_TAB3-NNNREQQTY = WA_TAB21-NNNREQQTY.
    WA_TAB3-RNNNREQQTY = WA_TAB21-RNNNREQQTY.
    WA_TAB3-NNNBUDQTY = WA_TAB21-NNNBUDQTY.
    WA_TAB3-CL4 = WA_TAB21-CL4.
    WA_TAB3-TDLINE = WA_TAB21-TDLINE.
    CLEAR : MATNR1.
    UNPACK WA_TAB21-MATNR TO MATNR1.

    SELECT SINGLE * FROM MARA WHERE MATNR EQ MATNR1.
    IF SY-SUBRC EQ 0.
      IF MARA-EXTWG EQ 'CRD'.
        WA_TAB3-PRDTYP = '2'.
      ELSEIF MARA-EXTWG EQ 'DBT'.
        WA_TAB3-PRDTYP = '3'.
      ELSE.
        WA_TAB3-PRDTYP = '1'.
      ENDIF.
    ENDIF.


    SELECT SINGLE * FROM MARD WHERE MATNR EQ MATNR1 AND WERKS EQ '2002' AND LGORT GE 'NS01' AND LGORT LE 'NS04'.
    IF SY-SUBRC EQ 0.
      WA_TAB3-LOCATION = '1. NASIK'.
    ELSE.
      SELECT SINGLE * FROM MARD WHERE MATNR EQ MATNR1 AND WERKS EQ '2002' AND LGORT GE 'GA01' AND LGORT LE 'GA04'.
      IF SY-SUBRC EQ 0.
        WA_TAB3-LOCATION = '2. GOA'.
      ELSE.
        SELECT SINGLE * FROM MARD WHERE MATNR EQ MATNR1 AND WERKS EQ '2002' AND LGORT GE 'MU01' AND LGORT LE 'MU04'.
        IF SY-SUBRC EQ 0.
          WA_TAB3-LOCATION = '3. MUMBAI'.
        ELSE.
          SELECT SINGLE * FROM MARD WHERE MATNR EQ MATNR1 AND WERKS EQ '1000' AND LGORT GE 'FG01' AND LGORT LE 'FG04'.
          IF SY-SUBRC EQ 0.
            WA_TAB3-LOCATION = '1. NASIK'.
          ELSE.
            SELECT SINGLE * FROM MARD WHERE MATNR EQ MATNR1 AND WERKS EQ '1001' AND LGORT GE 'FG01' AND LGORT LE 'FG04'.
            IF SY-SUBRC EQ 0.
              WA_TAB3-LOCATION = '2. GOA'.
            ELSE.
              WA_TAB3-LOCATION = '3. MUMBAI'.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    SELECT SINGLE * FROM ZPRODSAMPRT WHERE MATNR EQ MATNR1 AND TODT GE SY-DATUM.
    IF SY-SUBRC EQ 0.
      WA_TAB3-RATE = ZPRODSAMPRT-RATE.
    ELSE.
      WA_TAB3-RATE = 1.
      WRITE : / 'RATE NOT DEFIND IN TABLE ZPRODSAMPRT FOR ',MATNR1.
    ENDIF.

    COLLECT WA_TAB3 INTO IT_TAB3.
    CLEAR WA_TAB3.
  ENDLOOP.

  SORT IT_TAB3 BY LOCATION.
  FORMAT COLOR 3.
  WRITE : / 'DETAIL LIST'.
  WRITE : /1 'PRODUCT NAME',40 'PRODUCT CODE',70 'RATE',80 'NSK STOCK',100 'GOA STOCK',120 'OZAR STOCK',130 'GAZIABAD STOCK',150 'CNF STOCK',
  160 'TRANSIT',185 'TOTAL STOCK',205 NMONTH1,'REQD',218 NMONTH1,'REVISED',235 NMONTH1,'BUDGET',255 'CLOSING1',
  275 NMONTH2,'REQD',285 NMONTH2,'REVISED',305 NMONTH2,'BUDGET',323 'CLOSING2',
  345 NMONTH3,'REQD',355 NMONTH3,'REVISED',375 NMONTH3,'BUDGET',390 'CLOSING3',
  410 NMONTH4,'REQD',420 NMONTH4,'REVISED',440 NMONTH4,'BUDGET',455 'CLOSING4'.


*   'WA_TAB3-CREQQTY,WA_TAB3-RCREQQTY,WA_TAB3-CBUDQTY,WA_TAB3-CL1,
*    WA_TAB3-NREQQTY,WA_TAB3-RNREQQTY,WA_TAB3-NBUDQTY,WA_TAB3-CL2,
*    WA_TAB3-NNREQQTY,WA_TAB3-RNNREQQTY,WA_TAB3-NNBUDQTY,WA_TAB3-CL3,
*    WA_TAB3-NNNREQQTY,WA_TAB3-RNNNREQQTY,WA_TAB3-NNNBUDQTY,WA_TAB3-CL4,
*    WA_TAB3-TDLINE,WA_TAB3-PRDTYP.
  FORMAT COLOR 4.
  LOOP AT IT_TAB3 INTO WA_TAB3.
    ON CHANGE OF WA_TAB3-LOCATION.
      WRITE : / WA_TAB3-LOCATION.
    ENDON.
    WRITE : /
      WA_TAB3-MAKTX,
      WA_TAB3-MATNR,WA_TAB3-RATE,WA_TAB3-NSKSTK,WA_TAB3-GOASTK,WA_TAB3-OZRSTK,WA_TAB3-GHASTK,WA_TAB3-CNFSTK,
     WA_TAB3-TRAME,WA_TAB3-TOTAL,WA_TAB3-CREQQTY,WA_TAB3-RCREQQTY,WA_TAB3-CBUDQTY,WA_TAB3-CL1,
     WA_TAB3-NREQQTY,WA_TAB3-RNREQQTY,WA_TAB3-NBUDQTY,WA_TAB3-CL2,
     WA_TAB3-NNREQQTY,WA_TAB3-RNNREQQTY,WA_TAB3-NNBUDQTY,WA_TAB3-CL3,
     WA_TAB3-NNNREQQTY,WA_TAB3-RNNNREQQTY,WA_TAB3-NNNBUDQTY,WA_TAB3-CL4,
     WA_TAB3-TDLINE,WA_TAB3-PRDTYP.

  ENDLOOP.
  ULINE.
  FORMAT COLOR 3.
  WRITE : /  'VALUATION'.

  WRITE : /10 'DEP/CNF STOCK',30 'FACTORY STOCK', 50 'TRANSIT',
  60 NMONTH1,'REVISED',80 'BUDGET',100 'CLOSING1',
  110 NMONTH2,'REVISED',130 NMONTH2,'BUDGET',150 'CLOSING2',
  160 NMONTH3,'REVISED',180 NMONTH3,'BUDGET',200 'CLOSING3',
  210 NMONTH4,'REVISED',230 NMONTH4,'BUDGET',250 'CLOSING4'.
  ULINE.
  FORMAT COLOR 5.
  LOOP AT IT_TAB3 INTO WA_TAB3.

    IF WA_TAB3-PRDTYP EQ 2.
      MOVE-CORRESPONDING WA_TAB3 TO WA_TAM1.
      COLLECT WA_TAM1 INTO IT_TAM1.
      CLEAR WA_TAM1.
    ELSEIF WA_TAB3-PRDTYP EQ 3.
      MOVE-CORRESPONDING WA_TAB3 TO WA_TAM2.
      COLLECT WA_TAM2 INTO IT_TAM2.
      CLEAR WA_TAM2.
    ELSE.
      IF WA_TAB3-LOCATION EQ '1. NASIK'.
        MOVE-CORRESPONDING WA_TAB3 TO WA_TAM3.
        COLLECT WA_TAM3 INTO IT_TAM3.
        CLEAR WA_TAM3.
      ELSEIF WA_TAB3-LOCATION EQ '2. GOA'.
        MOVE-CORRESPONDING WA_TAB3 TO WA_TAM4.
        COLLECT WA_TAM4 INTO IT_TAM4.
        CLEAR WA_TAM4.
      ELSE.
        MOVE-CORRESPONDING WA_TAB3 TO WA_TAM5.
        COLLECT WA_TAM5 INTO IT_TAM5.
        CLEAR WA_TAM5.
      ENDIF.
    ENDIF.

  ENDLOOP.

  LOOP AT IT_TAM1 INTO WA_TAM1.
    WA_TAM11-FACSTK = ( WA_TAM1-NSKSTK + WA_TAM1-GOASTK ) * WA_TAM1-RATE.
    WA_TAM11-CNFSTK = ( WA_TAM1-OZRSTK + WA_TAM1-GHASTK + WA_TAM1-CNFSTK ) * WA_TAM1-RATE.
    WA_TAM11-TRAME = WA_TAM1-TRAME * WA_TAM1-RATE.
    WA_TAM11-TOTAL = WA_TAM1-TOTAL * WA_TAM1-RATE.
    WA_TAM11-CREQQTY = WA_TAM1-CREQQTY * WA_TAM1-RATE.
    WA_TAM11-RCREQQTY = WA_TAM1-RCREQQTY * WA_TAM1-RATE.
    WA_TAM11-CBUDQTY = WA_TAM1-CBUDQTY * WA_TAM1-RATE.
    WA_TAM11-CL1 = WA_TAM1-CL1 * WA_TAM1-RATE.
    WA_TAM11-NREQQTY = WA_TAM1-NREQQTY * WA_TAM1-RATE.
    WA_TAM11-RNREQQTY = WA_TAM1-RNREQQTY * WA_TAM1-RATE.
    WA_TAM11-NBUDQTY = WA_TAM1-NBUDQTY * WA_TAM1-RATE.
    WA_TAM11-CL2 = WA_TAM1-CL2 * WA_TAM1-RATE.
    WA_TAM11-NNREQQTY = WA_TAM1-NNREQQTY * WA_TAM1-RATE.
    WA_TAM11-RNNREQQTY = WA_TAM1-RNNREQQTY * WA_TAM1-RATE.
    WA_TAM11-NNBUDQTY = WA_TAM1-NNBUDQTY * WA_TAM1-RATE.
    WA_TAM11-CL3 = WA_TAM1-CL3 * WA_TAM1-RATE.
    WA_TAM11-NNNREQQTY = WA_TAM1-NNNREQQTY * WA_TAM1-RATE.
    WA_TAM11-RNNNREQQTY = WA_TAM1-RNNNREQQTY * WA_TAM1-RATE.
    WA_TAM11-NNNBUDQTY = WA_TAM1-NNNBUDQTY * WA_TAM1-RATE.
    WA_TAM11-CL4 = WA_TAM1-CL4 * WA_TAM1-RATE.
    COLLECT WA_TAM11 INTO IT_TAM11.
    CLEAR WA_TAM11.
  ENDLOOP.
  LOOP AT IT_TAM11 INTO WA_TAM11.
    WRITE : /'CARDIAC ', WA_TAM11-CNFSTK,WA_TAM11-FACSTK,WA_TAM11-TRAME,'A',WA_TAM11-RCREQQTY,WA_TAM11-CBUDQTY,WA_TAM11-CL1,
              WA_TAM11-RNREQQTY,WA_TAM11-NBUDQTY,WA_TAM11-CL2,
              WA_TAM11-RNNREQQTY,WA_TAM11-NNBUDQTY,WA_TAM11-CL3,
              WA_TAM11-RNNNREQQTY,WA_TAM11-NNNBUDQTY,WA_TAM11-CL4.

    CRNSKCCL = WA_TAM11-CNFSTK / 100000.
    CRNSKFCL = WA_TAM11-FACSTK / 100000.
    CRNSKTCL = WA_TAM11-TRAME / 100000.
    CRNSKRCREQ = WA_TAM11-RCREQQTY / 100000.
    CRNSKCBUD = WA_TAM11-CBUDQTY / 100000.
    CRNSKCL1 = WA_TAM11-CL1 / 100000.
    CRNSKRNREQ = WA_TAM11-RNREQQTY / 100000.
    CRNSKNBUD = WA_TAM11-NBUDQTY / 100000.
    CRNSKCL2 = WA_TAM11-CL2 / 100000.
    CRNSKRNNREQ = WA_TAM11-RNNREQQTY / 100000.
    CRNSKNNBUD = WA_TAM11-NNBUDQTY / 100000.
    CRNSKCL3 = WA_TAM11-CL3 / 100000.
    CRNSKRNNNREQ = WA_TAM11-RNNNREQQTY / 100000.
    CRNSKNNNBUD = WA_TAM11-NNNBUDQTY / 100000.
    CRNSKCL4 = WA_TAM11-CL4 / 100000.

  ENDLOOP.

*************************

  LOOP AT IT_TAM2 INTO WA_TAM2.
    WA_TAM12-FACSTK = ( WA_TAM2-NSKSTK + WA_TAM2-GOASTK ) * WA_TAM2-RATE.
    WA_TAM12-CNFSTK = ( WA_TAM2-OZRSTK + WA_TAM2-GHASTK + WA_TAM2-CNFSTK ) * WA_TAM2-RATE..
    WA_TAM12-TRAME = WA_TAM2-TRAME * WA_TAM2-RATE.
    WA_TAM12-TOTAL = WA_TAM2-TOTAL * WA_TAM2-RATE.
    WA_TAM12-CREQQTY = WA_TAM2-CREQQTY * WA_TAM2-RATE.
    WA_TAM12-RCREQQTY = WA_TAM2-RCREQQTY * WA_TAM2-RATE.
    WA_TAM12-CBUDQTY = WA_TAM2-CBUDQTY * WA_TAM2-RATE.
    WA_TAM12-CL1 = WA_TAM2-CL1 * WA_TAM2-RATE..
    WA_TAM12-NREQQTY = WA_TAM2-NREQQTY * WA_TAM2-RATE.
    WA_TAM12-RNREQQTY = WA_TAM2-RNREQQTY * WA_TAM2-RATE.
    WA_TAM12-NBUDQTY = WA_TAM2-NBUDQTY * WA_TAM2-RATE..
    WA_TAM12-CL2 = WA_TAM2-CL2 * WA_TAM2-RATE.
    WA_TAM12-NNREQQTY = WA_TAM2-NNREQQTY * WA_TAM2-RATE.
    WA_TAM12-RNNREQQTY = WA_TAM2-RNNREQQTY * WA_TAM2-RATE.
    WA_TAM12-NNBUDQTY = WA_TAM2-NNBUDQTY * WA_TAM2-RATE.
    WA_TAM12-CL3 = WA_TAM2-CL3 * WA_TAM2-RATE.
    WA_TAM12-NNNREQQTY = WA_TAM2-NNNREQQTY * WA_TAM2-RATE.
    WA_TAM12-RNNNREQQTY = WA_TAM2-RNNNREQQTY * WA_TAM2-RATE.
    WA_TAM12-NNNBUDQTY = WA_TAM2-NNNBUDQTY * WA_TAM2-RATE.
    WA_TAM12-CL4 = WA_TAM2-CL4 * WA_TAM2-RATE.
    COLLECT WA_TAM12 INTO IT_TAM12.
    CLEAR WA_TAM12.
  ENDLOOP.
  LOOP AT IT_TAM12 INTO WA_TAM12.
    WRITE : /'DIABETIC', WA_TAM12-CNFSTK,WA_TAM12-FACSTK,WA_TAM12-TRAME,'A',WA_TAM12-RCREQQTY,WA_TAM12-CBUDQTY,WA_TAM12-CL1,
              WA_TAM12-RNREQQTY,WA_TAM12-NBUDQTY,WA_TAM12-CL2,
              WA_TAM12-RNNREQQTY,WA_TAM12-NNBUDQTY,WA_TAM12-CL3,
              WA_TAM12-RNNNREQQTY,WA_TAM12-NNNBUDQTY,WA_TAM12-CL4.


    DBNSKCCL = WA_TAM12-CNFSTK / 100000.
    DBNSKFCL = WA_TAM12-FACSTK / 100000.
    DBNSKTCL = WA_TAM12-TRAME / 100000.
    DBNSKRCREQ = WA_TAM12-RCREQQTY / 100000.
    DBNSKCBUD = WA_TAM12-CBUDQTY / 100000.
    DBNSKCL1 = WA_TAM12-CL1 / 100000.
    DBNSKRNREQ = WA_TAM12-RNREQQTY / 100000.
    DBNSKNBUD = WA_TAM12-NBUDQTY / 100000.
    DBNSKCL2 = WA_TAM12-CL2 / 100000.
    DBNSKRNNREQ = WA_TAM12-RNNREQQTY / 100000.
    DBNSKNNBUD = WA_TAM12-NNBUDQTY / 100000.
    DBNSKCL3 = WA_TAM12-CL3 / 100000.
    DBNSKRNNNREQ = WA_TAM12-RNNNREQQTY / 100000.
    DBNSKNNNBUD = WA_TAM12-NNNBUDQTY / 100000.
    DBNSKCL4 = WA_TAM12-CL4 / 100000.

  ENDLOOP.

***********************************

  LOOP AT IT_TAM3 INTO WA_TAM3.
    WA_TAM13-FACSTK = ( WA_TAM3-NSKSTK + WA_TAM3-GOASTK ) * WA_TAM3-RATE..
    WA_TAM13-CNFSTK = ( WA_TAM3-OZRSTK + WA_TAM3-GHASTK + WA_TAM3-CNFSTK ) * WA_TAM3-RATE.
    WA_TAM13-TRAME = WA_TAM3-TRAME * WA_TAM3-RATE.
    WA_TAM13-TOTAL = WA_TAM3-TOTAL * WA_TAM3-RATE.
    WA_TAM13-CREQQTY = WA_TAM3-CREQQTY * WA_TAM3-RATE.
    WA_TAM13-RCREQQTY = WA_TAM3-RCREQQTY * WA_TAM3-RATE.
    WA_TAM13-CBUDQTY = WA_TAM3-CBUDQTY * WA_TAM3-RATE.
    WA_TAM13-CL1 = WA_TAM3-CL1 * WA_TAM3-RATE.
    WA_TAM13-NREQQTY = WA_TAM3-NREQQTY * WA_TAM3-RATE.
    WA_TAM13-RNREQQTY = WA_TAM3-RNREQQTY * WA_TAM3-RATE.
    WA_TAM13-NBUDQTY = WA_TAM3-NBUDQTY * WA_TAM3-RATE.
    WA_TAM13-CL2 = WA_TAM3-CL2 * WA_TAM3-RATE.
    WA_TAM13-NNREQQTY = WA_TAM3-NNREQQTY * WA_TAM3-RATE.
    WA_TAM13-RNNREQQTY = WA_TAM3-RNNREQQTY * WA_TAM3-RATE.
    WA_TAM13-NNBUDQTY = WA_TAM3-NNBUDQTY * WA_TAM3-RATE.
    WA_TAM13-CL3 = WA_TAM3-CL3 * WA_TAM3-RATE.
    WA_TAM13-NNNREQQTY = WA_TAM3-NNNREQQTY * WA_TAM3-RATE.
    WA_TAM13-RNNNREQQTY = WA_TAM3-RNNNREQQTY * WA_TAM3-RATE.
    WA_TAM13-NNNBUDQTY = WA_TAM3-NNNBUDQTY * WA_TAM3-RATE.
    WA_TAM13-CL4 = WA_TAM3-CL4 * WA_TAM3-RATE.
    COLLECT WA_TAM13 INTO IT_TAM13.
    CLEAR WA_TAM13.
  ENDLOOP.
  LOOP AT IT_TAM13 INTO WA_TAM13.
    WRITE : /'NSK     ', WA_TAM13-CNFSTK,WA_TAM13-FACSTK,WA_TAM13-TRAME,'A',WA_TAM13-RCREQQTY,WA_TAM13-CBUDQTY,WA_TAM13-CL1,
              WA_TAM13-RNREQQTY,WA_TAM13-NBUDQTY,WA_TAM13-CL2,
              WA_TAM13-RNNREQQTY,WA_TAM13-NNBUDQTY,WA_TAM13-CL3,
              WA_TAM13-RNNNREQQTY,WA_TAM13-NNNBUDQTY,WA_TAM13-CL4.

    NSKCCL = WA_TAM13-CNFSTK / 100000.
    NSKFCL = WA_TAM13-FACSTK / 100000.
    NSKTCL = WA_TAM13-TRAME / 100000.
    NSKRCREQ = WA_TAM13-RCREQQTY / 100000.
    NSKCBUD = WA_TAM13-CBUDQTY / 100000.
    NSKCL1 = WA_TAM13-CL1 / 100000.
    NSKRNREQ = WA_TAM13-RNREQQTY / 100000.
    NSKNBUD = WA_TAM13-NBUDQTY / 100000.
    NSKCL2 = WA_TAM13-CL2 / 100000.
    NSKRNNREQ = WA_TAM13-RNNREQQTY / 100000.
    NSKNNBUD = WA_TAM13-NNBUDQTY / 100000.
    NSKCL3 = WA_TAM13-CL3 / 100000.
    NSKRNNNREQ = WA_TAM13-RNNNREQQTY / 100000.
    NSKNNNBUD = WA_TAM13-NNNBUDQTY / 100000.
    NSKCL4 = WA_TAM13-CL4 / 100000.
  ENDLOOP.
*********************************

  LOOP AT IT_TAM3 INTO WA_TAM4.
    WA_TAM14-FACSTK = ( WA_TAM4-NSKSTK + WA_TAM4-GOASTK ) * WA_TAM4-RATE.
    WA_TAM14-CNFSTK = ( WA_TAM4-OZRSTK + WA_TAM4-GHASTK + WA_TAM4-CNFSTK ) * WA_TAM4-RATE..
    WA_TAM14-TRAME = WA_TAM4-TRAME * WA_TAM4-RATE.
    WA_TAM14-TOTAL = WA_TAM4-TOTAL * WA_TAM4-RATE.
    WA_TAM14-CREQQTY = WA_TAM4-CREQQTY * WA_TAM4-RATE.
    WA_TAM14-RCREQQTY = WA_TAM4-RCREQQTY * WA_TAM4-RATE.
    WA_TAM14-CBUDQTY = WA_TAM4-CBUDQTY * WA_TAM4-RATE.
    WA_TAM14-CL1 = WA_TAM4-CL1 * WA_TAM4-RATE.
    WA_TAM14-NREQQTY = WA_TAM4-NREQQTY * WA_TAM4-RATE.
    WA_TAM14-RNREQQTY = WA_TAM4-RNREQQTY * WA_TAM4-RATE.
    WA_TAM14-NBUDQTY = WA_TAM4-NBUDQTY * WA_TAM4-RATE.
    WA_TAM14-CL2 = WA_TAM4-CL2 * WA_TAM4-RATE.
    WA_TAM14-NNREQQTY = WA_TAM4-NNREQQTY * WA_TAM4-RATE.
    WA_TAM14-RNNREQQTY = WA_TAM4-RNNREQQTY * WA_TAM4-RATE.
    WA_TAM14-NNBUDQTY = WA_TAM4-NNBUDQTY * WA_TAM4-RATE.
    WA_TAM14-CL3 = WA_TAM4-CL3 * WA_TAM4-RATE.
    WA_TAM14-NNNREQQTY = WA_TAM4-NNNREQQTY * WA_TAM4-RATE.
    WA_TAM14-RNNNREQQTY = WA_TAM4-RNNNREQQTY * WA_TAM4-RATE.
    WA_TAM14-NNNBUDQTY = WA_TAM4-NNNBUDQTY * WA_TAM4-RATE.
    WA_TAM14-CL4 = WA_TAM4-CL4 * WA_TAM4-RATE.
    COLLECT WA_TAM14 INTO IT_TAM14.
    CLEAR WA_TAM14.
  ENDLOOP.
  LOOP AT IT_TAM14 INTO WA_TAM14.
    WRITE : /'GOA    ', WA_TAM14-CNFSTK,WA_TAM14-FACSTK,WA_TAM14-TRAME,'A',WA_TAM14-RCREQQTY,WA_TAM14-CBUDQTY,WA_TAM14-CL1,
              WA_TAM14-RNREQQTY,WA_TAM14-NBUDQTY,WA_TAM14-CL2,
              WA_TAM14-RNNREQQTY,WA_TAM14-NNBUDQTY,WA_TAM14-CL3,
              WA_TAM14-RNNNREQQTY,WA_TAM14-NNNBUDQTY,WA_TAM14-CL4.

    GOACCL = WA_TAM14-CNFSTK / 100000.
    GOAFCL = WA_TAM14-FACSTK / 100000.
    GOATCL = WA_TAM14-TRAME / 100000.
    GOARCREQ = WA_TAM14-RCREQQTY / 100000.
    GOACBUD = WA_TAM14-CBUDQTY / 100000.
    GOACL1 = WA_TAM14-CL1 / 100000.
    GOARNREQ = WA_TAM14-RNREQQTY / 100000.
    GOANBUD = WA_TAM14-NBUDQTY / 100000.
    GOACL2 = WA_TAM14-CL2 / 100000.
    GOARNNREQ = WA_TAM14-RNNREQQTY / 100000.
    GOANNBUD = WA_TAM14-NNBUDQTY / 100000.
    GOACL3 = WA_TAM14-CL3 / 100000.
    GOARNNNREQ = WA_TAM14-RNNNREQQTY / 100000.
    GOANNNBUD = WA_TAM14-NNNBUDQTY / 100000.
    GOACL4 = WA_TAM14-CL4 / 100000.

  ENDLOOP.

*******************************

  LOOP AT IT_TAM5 INTO WA_TAM5.
    WA_TAM15-FACSTK = ( WA_TAM5-NSKSTK + WA_TAM5-GOASTK ) * WA_TAM5-RATE.
    WA_TAM15-CNFSTK = ( WA_TAM5-OZRSTK + WA_TAM5-GHASTK + WA_TAM5-CNFSTK ) * WA_TAM5-RATE..
    WA_TAM15-TRAME = WA_TAM5-TRAME * WA_TAM5-RATE.
    WA_TAM15-TOTAL = WA_TAM5-TOTAL * WA_TAM5-RATE.
    WA_TAM15-CREQQTY = WA_TAM5-CREQQTY * WA_TAM5-RATE.
    WA_TAM15-RCREQQTY = WA_TAM5-RCREQQTY * WA_TAM5-RATE.
    WA_TAM15-CBUDQTY = WA_TAM5-CBUDQTY * WA_TAM5-RATE.
    WA_TAM15-CL1 = WA_TAM5-CL1 * WA_TAM5-RATE.
    WA_TAM15-NREQQTY = WA_TAM5-NREQQTY * WA_TAM5-RATE.
    WA_TAM15-RNREQQTY = WA_TAM5-RNREQQTY * WA_TAM5-RATE.
    WA_TAM15-NBUDQTY = WA_TAM5-NBUDQTY * WA_TAM5-RATE.
    WA_TAM15-CL2 = WA_TAM5-CL2 * WA_TAM5-RATE.
    WA_TAM15-NNREQQTY = WA_TAM5-NNREQQTY * WA_TAM5-RATE.
    WA_TAM15-RNNREQQTY = WA_TAM5-RNNREQQTY * WA_TAM5-RATE.
    WA_TAM15-NNBUDQTY = WA_TAM5-NNBUDQTY * WA_TAM5-RATE.
    WA_TAM15-CL3 = WA_TAM5-CL3 * WA_TAM5-RATE.
    WA_TAM15-NNNREQQTY = WA_TAM5-NNNREQQTY * WA_TAM5-RATE.
    WA_TAM15-RNNNREQQTY = WA_TAM5-RNNNREQQTY * WA_TAM5-RATE.
    WA_TAM15-NNNBUDQTY = WA_TAM5-NNNBUDQTY * WA_TAM5-RATE.
    WA_TAM15-CL4 = WA_TAM5-CL4 * WA_TAM5-RATE.
    COLLECT WA_TAM15 INTO IT_TAM15.
    CLEAR WA_TAM15.
  ENDLOOP.
  LOOP AT IT_TAM15 INTO WA_TAM15.
    WRITE : /'MUM     ', WA_TAM15-CNFSTK,WA_TAM15-FACSTK,WA_TAM15-TRAME,'A',WA_TAM15-RCREQQTY,WA_TAM15-CBUDQTY,WA_TAM15-CL1,
              WA_TAM15-RNREQQTY,WA_TAM15-NBUDQTY,WA_TAM15-CL2,
              WA_TAM15-RNNREQQTY,WA_TAM15-NNBUDQTY,WA_TAM15-CL3,
              WA_TAM15-RNNNREQQTY,WA_TAM15-NNNBUDQTY,WA_TAM15-CL4.


    MUMCCL = WA_TAM15-CNFSTK / 100000.
    MUMFCL = WA_TAM15-FACSTK / 100000.
    MUMTCL = WA_TAM15-TRAME / 100000.
    MUMRCREQ = WA_TAM15-RCREQQTY / 100000.
    MUMCBUD = WA_TAM15-CBUDQTY / 100000.
    MUMCL1 = WA_TAM15-CL1 / 100000.
    MUMRNREQ = WA_TAM15-RNREQQTY / 100000.
    MUMNBUD = WA_TAM15-NBUDQTY / 100000.
    MUMCL2 = WA_TAM15-CL2 / 100000.
    MUMRNNREQ = WA_TAM15-RNNREQQTY / 100000.
    MUMNNBUD = WA_TAM15-NNBUDQTY / 100000.
    MUMCL3 = WA_TAM15-CL3 / 100000.
    MUMRNNNREQ = WA_TAM15-RNNNREQQTY / 100000.
    MUMNNNBUD = WA_TAM15-NNNBUDQTY / 100000.
    MUMCL4 = WA_TAM15-CL4 / 100000.
  ENDLOOP.

  ULINE.

  TOTFCL = NSKFCL + GOAFCL + MUMFCL.
  TOTCCL = NSKCCL + GOACCL + MUMCCL.
  TOTTCL = NSKTCL + GOATCL + MUMTCL.
  TOTTOTCL = TOTFCL + TOTCCL + TOTTCL.
  TOTCREQ = NSKCREQ + GOACREQ + MUMCREQ.
  TOTRCREQ = NSKRCREQ + GOARCREQ + MUMRCREQ.
  TOTCBUD = NSKCBUD + GOACBUD + MUMCBUD.
  TOTCL1 = NSKCL1 + GOACL1 + MUMCL1.
  TOTNREQ = NSKNREQ + GOANREQ + MUMNREQ.
  TOTRNREQ = NSKRNREQ + GOARNREQ + MUMRNREQ.
  TOTNBUD = NSKNBUD + GOANBUD + MUMNBUD.
  TOTCL2 = NSKCL2 + GOACL2 + MUMCL2.
  TOTNNREQ = NSKNNREQ + GOANNREQ + MUMNNREQ.
  TOTRNNREQ = NSKRNNREQ + GOARNNREQ + MUMRNNREQ.
  TOTNNBUD = NSKNNBUD + GOANNBUD + MUMNNBUD.
  TOTCL3 = NSKCL3 + GOACL3 + MUMCL3.
  TOTNNNREQ = NSKNNNREQ + GOANNNREQ + MUMNNNREQ.
  TOTRNNNREQ = NSKRNNNREQ + GOARNNNREQ + MUMRNNNREQ.
  TOTNNNBUD = NSKNNNBUD + GOANNNBUD + MUMNNNBUD.
  TOTCL4 = NSKCL4 + GOACL4 + MUMCL4.


  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
      DEVICE   = 'PRINTER'
      DIALOG   = 'X'
*     form     = 'ZSR9_1'
      LANGUAGE = SY-LANGU
    EXCEPTIONS
      CANCELED = 1
      DEVICE   = 2.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  CALL FUNCTION 'START_FORM'
    EXPORTING
      FORM        = 'ZPRODSAMPVAL'
      LANGUAGE    = SY-LANGU
    EXCEPTIONS
      FORM        = 1
      FORMAT      = 2
      UNENDED     = 3
      UNOPENED    = 4
      UNUSED      = 5
      SPOOL_ERROR = 6
      CODEPAGE    = 7
      OTHERS      = 8.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
*call function 'WRITE_FORM'
*    exporting
*      element = 'V2'
*      window  = 'WINDOW2'.
*
*  call function 'WRITE_FORM'
*    exporting
*      element = 'V3'
*      window  = 'WINDOW2'.
*
*  call function 'WRITE_FORM'
*    exporting
*      element = 'V1'
*      window  = 'WINDOW2'.
*
*  call function 'WRITE_FORM'
*    exporting
*      element = 'T1'
*      window  = 'WINDOW2'.
*
*  call function 'WRITE_FORM'
*    exporting
*      element = 'CV1'
*      window  = 'WINDOW2'.
*
*  call function 'WRITE_FORM'
*    exporting
*      element = 'DV1'
*      window  = 'WINDOW2'.

  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
*     element = 'V1'
      WINDOW = 'MAIN'.

  CALL FUNCTION 'END_FORM'
    EXCEPTIONS
      UNOPENED                 = 1
      BAD_PAGEFORMAT_FOR_PRINT = 2
      SPOOL_ERROR              = 3
      CODEPAGE                 = 4
      OTHERS                   = 5.
  IF SY-SUBRC <> 0.
    MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  CALL FUNCTION 'CLOSE_FORM'
* IMPORTING
*   RESULT                         =
*   RDI_RESULT                     =
* TABLES
*   OTFDATA                        =
    EXCEPTIONS
      UNOPENED                 = 1
      BAD_PAGEFORMAT_FOR_PRINT = 2
      SEND_ERROR               = 3
      SPOOL_ERROR              = 4
      CODEPAGE                 = 5
      OTHERS                   = 6.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.
