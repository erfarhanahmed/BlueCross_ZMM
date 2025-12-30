
REPORT zbcllmm_costsheet_ann  NO STANDARD PAGE HEADING LINE-COUNT 60
LINE-SIZE 100.
*--------------------------------------------------------------------*
*--This report is for the  Annual cost sheet printing  for CARR      *
*                                                                    *
*--Request given by Mr. Sonawane - accounts  and developed by Anjali *
*--Started on 28.4.03
*--------------------------------------------------------------------*

*--Table Declerations -----------------------------------------------*

TABLES : afpo,
         afru,
         mseg,
         MAKT,
         MARA,
         MARM,
         MBEW,
         mast,
         stko,
         MVKE,
         TVM5T,
         T001W,
         aufk.

*--Data Declerations ------------------------------------------------*

DATA : BEGIN OF t_details OCCURS 0,
       aufnr  LIKE afpo-aufnr,
       psmng LIKE afpo-psmng,
       wemng LIKE afpo-wemng,
       matnr LIKE afpo-matnr,
       erdat LIKE aufk-erdat,
       dwerk LIKE afpo-dwerk,
       lgort LIKE afpo-lgort,
       dauat LIKE afpo-dauat,
       charg LIKE afpo-charg,
     END OF t_details.
DATA : BEGIN OF t_details1 OCCURS 0,
       mblnr  LIKE mseg-mblnr,
       mjahr like mseg-mjahr,
       bwart like mseg-bwart,
       matnr like mseg-matnr,
       werks like mseg-werks,
       lgort like mseg-lgort,
       charg like mseg-charg,
       menge like mseg-menge,
       dmbtr like mseg-dmbtr,
       aufnr like mseg-aufnr,
       shkzg like mseg-shkzg,
     END OF t_details1.
DATA : BEGIN OF t_summ OCCURS 0,
       fg_matnr like mseg-matnr,
       matnr like mseg-matnr,
       menge like mseg-menge,
       dmbtr like mseg-dmbtr,
  charg like mseg-charg,
     END OF t_summ.

DATA : w_UMREN LIKE MARM-UMREN,
       W_UMREZ LIKE MARM-UMREZ,
       W_NAME1 LIKE T001W-NAME1,
       w_effsz(13) type i,
       w_ayld(3) type p decimals 2,
       w_effyld(13) type i,
       w_effper(3) type p decimals 2,
       w_var(13) type i,
       W_VARVL(13) TYPE P DECIMALS 2,
       w_qty531 LIKE mseg-menge,
       W_MAKTX LIKE MAKT-MAKTX,
       W_MVGR5 LIKE MVKE-MVGR5,
       W_MTART LIKE MARA-MTART,
       W_BEZEI LIKE TVM5T-BEZEI,
       W_MATNR LIKE MSEG-MATNR,
       W_WEMNG LIKE AFPO-WEMNG,
       w_menge like mseg-menge,
       w_dmbtr like mseg-dmbtr,
       w_tmenge like mseg-menge,
       W_RATE(4) TYPE p decimals 2,
       W_RRATE(4) TYPE p decimals 2,
       W_RATE3(4) TYPE p decimals 2,
       W_FLAG TYPE N,
       W_PAGENO TYPE N,
       w_psmng(13) type i,
       w_wemng1(13) type i,
       w_totord(5) type i,
       w_notconf(5) type i,
       w_stlnr like mast-stlnr,
       w_bmeng like stko-bmeng,
       W_TBAT(4) TYPE N,
       w_tbat1(7) type p decimals 2,
       w_batsz(9) type p,
       w_setup like afrv-ism01,
       w_macup like afrv-ism01,
       w_labup like afrv-ism01,
       w_cleup like afrv-ism01,
       w_tdmbtr like mseg-dmbtr.
*--Selection screen --------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001 .
SELECT-OPTIONS  : s_matnr FOR afpo-matnr.
SELECT-OPTIONS  : s_aufnr FOR afpo-aufnr.
PARAMETERS : p_werks LIKE afpo-dwerk OBLIGATORY.
SELECT-OPTIONS : s_lgort FOR afpo-lgort.
SELECT-OPTIONS : s_budat FOR aufk-erdat.
SELECTION-SCREEN END OF BLOCK b1.


*--Start-of-selection ------------------------------------------------*
PERFORM collect_data.
perform collect_mseg.
perform summ_details.
PERFORM print_details.
TOP-OF-PAGE.
W_PAGENO = W_PAGENO + 1.
WRITE :/80 'PAGE NO.:',
        89 W_PAGENO.
END-OF-PAGE.

*---------------------------------------------------------------------*
*       FORM collect_data                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM collect_data.

  SELECT * FROM afpo WHERE aufnr IN s_aufnr AND matnr IN s_matnr AND
  dwerk = p_werks AND lgort IN s_lgort.

    SELECT SINGLE * FROM aufk WHERE aufnr = afpo-aufnr.
    IF aufk-erdat IN s_budat.
      MOVE-CORRESPONDING afpo TO t_details.
      t_details-erdat = aufk-erdat.
      APPEND t_details.
    ENDIF.
    CLEAR t_details.
  ENDSELECT.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM COLLECT_MSEG                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM collect_mseg.

  SELECT * FROM mseg WHERE aufnr IN s_aufnr AND matnr IN s_matnr AND
  werks = p_werks AND lgort IN s_lgort.
    MOVE-CORRESPONDING mseg TO t_details1.
      APPEND t_details1.
    CLEAR t_details1.
  ENDSELECT.

 ENDFORM.

*---------------------------------------------------------------------*
*       FORM print_tdetails                                           *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM summ_details.
sort t_details by matnr.
W_FLAG = 0.
W_PAGENO = 0.
loop at t_details.
IF W_FLAG = 0.
W_MATNR = T_DETAILS-MATNR.
W_WEMNG = T_DETAILS-WEMNG.
W_FLAG  = 1.
ENDIF.
ON CHANGE OF T_DETAILS-matnr.
W_MATNR = T_DETAILS-MATNR.
endon.
  loop at t_details1 where aufnr = t_details-aufnr.
   IF T_dETAILS1-BWART = '101' OR T_DETAILS1-BWART = '321'.
   ELSE.
   SELECT SINGLE MTART  FROM MARA INTO W_MTART WHERE MATNR =
T_DETAILS1-MATNR.
   IF T_DETAILS1-BWART = '261' AND W_MTART = 'ZHLB'.
   ELSE.
   if t_details1-shkzg = 'H'.
        w_menge =  t_details1-menge.
        w_dmbtr =  t_details1-dmbtr.
   else.
        w_menge =  t_details1-menge * -1.
        w_dmbtr =  t_details1-dmbtr * -1.
   endif.
*    w_tmenge  = w_tmenge + w_menge.
*    w_tdmbtr = w_tdmbtr + w_dmbtr.
    SELECT SINGLE * FROM MAKT WHERE MATNR = T_DETAILS1-MATNR.
    move w_matnr to t_summ-fg_matnr.
    move t_details1-matnr to t_summ-matnr.
      move t_details1-charg to t_summ-charg.
    move w_menge to t_summ-menge.
    move w_dmbtr to t_summ-dmbtr.
    collect t_summ.
    clear t_summ.
   ENDIF.
  ENDIF.
  endloop.
endloop.
endform.


form print_details.
sort t_details by matnr.
W_FLAG = 0.
W_PAGENO = 0.
loop at t_details.
*  WRITE : / 'code & batch',t_details-matnr,t_details-charg,t_details-WEMNG..
IF W_FLAG = 0.
W_MATNR = T_DETAILS-MATNR.
W_WEMNG = T_DETAILS-WEMNG.
W_FLAG  = 1.
ENDIF.
ON CHANGE OF T_DETAILS-matnr.
SELECT SINGLE MAKTX FROM MAKT INTO W_MAKTX WHERE MATNR = T_DETAILS-MATNR
.
IF W_TDMBTR NE 0.
ULINE.
WRITE :/67 w_tdmbtr.
endif.
if w_wemng1 ne 0.
uline.
  SELECT SINGLE stlnr  FROM mast INTO w_stlnr WHERE matnr =
 w_matnr AND werks = p_werks.
  SELECT SINGLE bmeng  FROM stko into w_bmeng WHERE stlnr = w_stlnr.
  w_tbat = w_wemng1 / ( w_bmeng * 98 / 100 ).
  w_tbat1 = w_wemng1 / ( w_bmeng * 98 / 100 ).
  w_batsz = w_tbat1 * w_bmeng.
*  w_batsz = w_totord * w_bmeng.


write : /1 'Total Qty Recvd.',
        20(13)'a', w_wemng1,
        35 'Total Batch',
        50(5) w_tbat,
        56 'Batch Sz.',
        65(9) w_batsz,
        75 'Order Not Confirmed',
        96(5) w_notconf.
write : /1 'Total Setup Hrs',
         17(10) w_setup,
         29 'M/c Hrs',
         37(10) w_macup,
         49 'Labr Hr',
         57(10) w_labup,
         69 'Cln Hrs',
         77(10) w_cleup.
uline.
move 0 to w_wemng1.
move 0 to w_totord.
move 0 to w_setup.
move 0 to w_macup.
move 0 to w_labup.
move 0 to w_cleup.
move 0 to w_tmenge.
move 0 to w_notconf.
move 0 to w_tdmbtr.
endif.
W_MATNR = T_DETAILS-MATNR.
W_WEMNG = T_DETAILS-WEMNG.
uline.
  WRITE : /1 'PRODUCT :',
            10 T_DETAILS-MATNR,
            20 W_MAKTX.
 SELECT SINGLE MVGR5 FROM MVKE INTO W_MVGR5 WHERE MATNR =
 T_DETAILS-MATNR.
 MOVE ' ' TO W_BEZEI.
 IF SY-SUBRC = 0.
 SELECT SINGLE BEZEI FROM  TVM5T INTO W_BEZEI WHERE MVGR5 = W_MVGR5.
 ENDIF.
   WRITE :/1 'PACK SIZE :',
          12  W_BEZEI.
  ULINE.
  WRITE :/1 'MATERIAL',
          18 '     DESCRIPTION',
          55 '  QUANTITY',
          67 '  VALUE  ',
          85 '   RATE   '.
   ULINE.
  loop at t_summ where fg_matnr  = t_details-matnr.
    w_tmenge  = w_tmenge + t_summ-menge.
    w_tdmbtr = w_tdmbtr + t_summ-dmbtr.
    SELECT SINGLE * FROM MAKT WHERE MATNR = T_summ-MATNR.
    write :/1 t_summ-matnr,
           18 MAKT-MAKTX,
           55 t_summ-menge,
           67 t_summ-dmbtr.
 endloop.
endon.
   w_psmng = w_psmng + t_details-psmng.
   w_wemng1 = w_wemng1 + t_Details-wemng.
   WRITE : / 'check',t_Details-charg, t_Details-wemng.
   w_totord = w_totord + 1.
*** to fetch the hrs.
select * from afru where aufnr = t_details-aufnr.
if sy-subrc = 4.
  w_notconf = w_notconf + 1.
else.
w_setup = w_setup + afru-ism01.
w_macup = w_macup + afru-ism02.
w_labup = w_labup + afru-ism03.
w_cleup = w_cleup + afru-ism04.
endif.
endselect.
endloop.
if w_wemng1 ne 0.
  SELECT SINGLE stlnr  FROM mast INTO w_stlnr WHERE matnr =
 t_details-matnr AND werks = t_details-dwerk.
  SELECT SINGLE bmeng  FROM stko into w_bmeng WHERE stlnr = w_stlnr.
  w_tbat = w_wemng1 / ( w_bmeng * 98 / 100 ).
  w_tbat1 = w_wemng1 / ( w_bmeng * 98 / 100 ).
  w_batsz = w_tbat1 * w_bmeng.
*w_batsz = w_totord * w_bmeng.

write : /1 'Total Qty Recvd.',
        20(13) w_wemng1,
        35 'Total Batch',
        50(5) w_tbat,
        56 'Batch Sz.',
        65(9) w_batsz,
        75 'Order Not Confirmed',
        96(5) w_notconf.
write : /1 'Total Setup Hrs',
         17(10) w_setup,
         29 'M/c Hrs',
         37(10) w_macup,
         49 'Labr Hr',
         57(10) w_labup,
         69 'Cln Hrs',
         77(10) w_cleup.

uline.
move 0 to w_wemng1.
move 0 to w_totord.
endif.

endform.
