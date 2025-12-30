REPORT ZBCLLMM_COSTSHEET_LLM_SUM  NO STANDARD PAGE HEADING LINE-SIZE 200.
*--------------------------------------------------------------------*
*--This report is for the cost sheet printing for LLM                *
*--Request given by Mr. Sonawane - accounts  and developed by Anjali *
*--Started on 7.8.02
*--------------------------------------------------------------------*

*--Table Declerations -----------------------------------------------*

TABLES : MSEG,
         MKPF,
         MAKT,
         MARA,
         MARM,
         MBEW,
         MVKE,
         TVM5T,
         T001W.


*--Data Declerations ------------------------------------------------*

DATA : BEGIN OF T_DETAILS OCCURS 0,
         MBLNR LIKE MSEG-MBLNR,
         MJAHR LIKE MSEG-MJAHR,
         BWART LIKE MSEG-BWART,
         MATNR LIKE MSEG-MATNR,
         WERKS LIKE MSEG-WERKS,
         LGORT LIKE MSEG-LGORT,
         CHARG LIKE MSEG-CHARG,
         MENGE LIKE MSEG-MENGE,
         DMBTR LIKE MSEG-DMBTR,
         SHKZG LIKE MSEG-SHKZG,
         BUDAT LIKE MKPF-BUDAT,
       END OF T_DETAILS.
DATA : BEGIN OF T_DETAILS1 OCCURS 0,
         MBLNR LIKE MSEG-MBLNR,
         MJAHR LIKE MSEG-MJAHR,
         BWART LIKE MSEG-BWART,
         MATNR LIKE MSEG-MATNR,
         WERKS LIKE MSEG-WERKS,
         LGORT LIKE MSEG-LGORT,
         CHARG LIKE MSEG-CHARG,
         MENGE LIKE MSEG-MENGE,
         DMBTR LIKE MSEG-DMBTR,
         LFBNR LIKE MSEG-LFBNR,
         SHKZG LIKE MSEG-SHKZG,
         MTART LIKE MARA-MTART,
       END OF T_DETAILS1.
DATA : BEGIN OF T_DETAILS2 OCCURS 0,
         MBLNR LIKE MSEG-MBLNR,
         MJAHR LIKE MSEG-MJAHR,
         BWART LIKE MSEG-BWART,
         MATNR LIKE MSEG-MATNR,
         WERKS LIKE MSEG-WERKS,
         LGORT LIKE MSEG-LGORT,
         CHARG LIKE MSEG-CHARG,
         MENGE LIKE MSEG-MENGE,
         DMBTR LIKE MSEG-DMBTR,
         LFBNR LIKE MSEG-LFBNR,
         SHKZG LIKE MSEG-SHKZG,
       END OF T_DETAILS2.


DATA : W_NAME1      LIKE T001W-NAME1,
       W_EFFSZ(13)  TYPE I,
       W_AYLD(3)    TYPE P DECIMALS 2,
       W_EFFYLD(13) TYPE I,
       W_EFFPER(3)  TYPE P DECIMALS 2,
       W_VAR(13)    TYPE I,
       W_VARVL(13)  TYPE P DECIMALS 2,
       W_QTY531     LIKE MSEG-MENGE,
       W_MAKTX      LIKE MAKT-MAKTX,
       W_MVGR5      LIKE MVKE-MVGR5,
       W_MTART      LIKE MARA-MTART,
       W_BEZEI      LIKE TVM5T-BEZEI,
       W_MATNR      LIKE MSEG-MATNR,
       W_WEMNG      LIKE AFPO-WEMNG,
       W_MENGE      LIKE MSEG-MENGE,
       W_DMBTR      LIKE MSEG-DMBTR,
       W_TMENGE     LIKE MSEG-MENGE,
*       W_RATE(4)    TYPE P DECIMALS 2,
  W_RATE    TYPE P DECIMALS 2,
       W_RRATE(4)   TYPE P DECIMALS 2,
       W_RATE3(4)   TYPE P DECIMALS 2,
       W_FLAG       TYPE N,
       W_FLAG1      TYPE N,
       W_PAGENO     TYPE N,
       W_TDMBTR     LIKE MSEG-DMBTR.


*--Selection screen --------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001 .
SELECT-OPTIONS  : S_MATNR FOR MSEG-MATNR.
SELECT-OPTIONS  : S_MBLNR FOR MSEG-MBLNR.
SELECT-OPTIONS : S_BUDAT FOR MKPF-BUDAT.
SELECT-OPTIONS : PLANT FOR MSEG-WERKS.
SELECTION-SCREEN END OF BLOCK B1.


*--Start-of-selection ------------------------------------------------*
PERFORM COLLECT_DATA.
PERFORM COLLECT_MSEG.
PERFORM COLLECT_MSEG_102.
PERFORM PRINT_DETAILS.

TOP-OF-PAGE.
  WRITE :/1 'Cost Sheet Summary - LLM'.
  ULINE.
  WRITE :/1 'Material',
          18 '    Description',
          54 'Batch No.',
          65 'Matl.Doc.',
          90 'RM Rate',
          110 'PM Rate'.
  ULINE.

END-OF-PAGE.

*---------------------------------------------------------------------*
*       FORM collect_data                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM COLLECT_DATA.

  SELECT * FROM MSEG  WHERE MBLNR IN S_MBLNR AND MATNR IN S_MATNR AND
*  werks = '3000' AND ( bwart = '101').
    WERKS IN PLANT AND BWART = '101'.
*    ('3000','1002','1003','1004','1005','1006','1007')
    SELECT SINGLE MTART FROM MARA INTO W_MTART WHERE MATNR = MSEG-MATNR.
    IF W_MTART = 'ZFRT' OR W_MTART = 'ZESC' .
      SELECT SINGLE * FROM MKPF WHERE MBLNR = MSEG-MBLNR.
      IF MKPF-BUDAT IN S_BUDAT.
        MOVE-CORRESPONDING MSEG TO T_DETAILS.
        T_DETAILS-BUDAT = MKPF-BUDAT.
        APPEND T_DETAILS.
      ENDIF.
    ENDIF.
  ENDSELECT.
  CLEAR T_DETAILS.
ENDFORM.                    "collect_data

*---------------------------------------------------------------------*
*       FORM COLLECT_MSEG                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM COLLECT_MSEG.
  LOOP AT T_DETAILS.
    SELECT * FROM MSEG WHERE LFBNR = T_DETAILS-MBLNR AND ( BWART = '543'
   OR BWART = '544' ).
      MOVE-CORRESPONDING MSEG TO T_DETAILS1.
      SELECT SINGLE MTART FROM MARA INTO W_MTART WHERE MATNR = MSEG-MATNR.
      T_DETAILS1-MTART = W_MTART.
      APPEND T_DETAILS1.
      CLEAR T_DETAILS1.
    ENDSELECT.
  ENDLOOP.
ENDFORM.                    "collect_mseg

*---------------------------------------------------------------------*
*       FORM COLLECT_MSEG_102
*
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM COLLECT_MSEG_102.
  LOOP AT T_DETAILS.
    SELECT * FROM MSEG WHERE LFBNR = T_DETAILS-MBLNR AND  BWART = '102'.
      MOVE-CORRESPONDING MSEG TO T_DETAILS2.
      APPEND T_DETAILS2.
      CLEAR T_DETAILS2.
    ENDSELECT.
  ENDLOOP.
ENDFORM.                    "collect_mseg_102


*---------------------------------------------------------------------*
*       FORM print_tdetails                                           *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM PRINT_DETAILS.
  SORT T_DETAILS BY MBLNR MJAHR.
  SORT T_DETAILS1 BY LFBNR MJAHR MTART.
  SORT T_DETAILS2 BY LFBNR MJAHR.
  LOOP AT T_DETAILS.
    W_FLAG = 0.
    W_PAGENO = 0.
    IF W_FLAG = 0.
      W_WEMNG = T_DETAILS-MENGE.
      W_MATNR = T_DETAILS-MATNR.
      W_FLAG  = 1.
    ENDIF.
    ON CHANGE OF T_DETAILS-MBLNR.
      SELECT SINGLE MAKTX FROM MAKT INTO W_MAKTX WHERE MATNR = T_DETAILS-MATNR
            .
      W_WEMNG =  T_DETAILS-MENGE.
      PERFORM COLLECT_102.
    ENDON.
    MOVE ' ' TO W_MTART.
    MOVE 0 TO W_FLAG1.
    LOOP AT T_DETAILS1 WHERE LFBNR = T_DETAILS-MBLNR.
      IF W_FLAG1 = 0.
        W_MTART = T_DETAILS1-MTART.
        W_FLAG1 = 1.
      ENDIF.
      IF T_DETAILS1-MTART NE W_MTART.
        IF W_WEMNG = 0.
          W_RATE = 0.
        ELSE.
          W_RATE = W_TDMBTR / W_WEMNG.
        ENDIF.
        WRITE :/1 T_DETAILS-MATNR,
                18 W_MAKTX,
                54 T_DETAILS-CHARG,
                65 T_DETAILS-MBLNR,
                82 W_RATE.
        W_MTART = T_DETAILS1-MTART.
        MOVE 0 TO W_TMENGE.
        MOVE 0 TO W_TDMBTR.
      ENDIF.
      IF T_DETAILS1-SHKZG = 'H'.
        W_MENGE =  T_DETAILS1-MENGE.
        W_DMBTR =  T_DETAILS1-DMBTR.
      ELSE.
        W_MENGE =  T_DETAILS1-MENGE * -1.
        W_DMBTR =  T_DETAILS1-DMBTR * -1.
      ENDIF.
      W_TMENGE  = W_TMENGE + W_MENGE.
      W_TDMBTR = W_TDMBTR + W_DMBTR.

*      SELECT SINGLE * FROM makt WHERE matnr = t_details1-matnr.
    ENDLOOP.
    IF W_TDMBTR NE 0.
      IF W_WEMNG = 0.
        W_RATE  = 0.
      ELSE.
        IF W_WEMNG EQ 1.
          W_RATE = W_TDMBTR. "30.6.20
        ELSE.
          W_RATE = W_TDMBTR / W_WEMNG.
        ENDIF.
      ENDIF.
      WRITE :100 W_RATE.
      W_MTART = T_DETAILS1-MTART.
      MOVE 0 TO W_TMENGE.
      MOVE 0 TO W_TDMBTR.
    ENDIF.

  ENDLOOP.
ENDFORM.                    "print_details

*---------------------------------------------------------------------*
*       FORM collect_102                                              *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM COLLECT_102.
  LOOP AT T_DETAILS2 WHERE LFBNR = T_DETAILS-MBLNR.
    W_WEMNG = W_WEMNG -  T_DETAILS2-MENGE.
  ENDLOOP.
ENDFORM.                    "collect_102
