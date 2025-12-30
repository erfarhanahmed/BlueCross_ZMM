report zexp4.
TABLES : mchb,
         a602,
         konp,
         a004,
         mvke,
         a603,
         j_1imtchid,
         j_1iexctax,
         t001w,
         zreg_vat,
         makt.

TYPE-POOLs:  SLIS.

DATA: G_REPID LIKE SY-REPID,
      FIELDCAT TYPE slis_t_fieldcat_alv,
      WA_FIELDCAT LIKE LINE OF FIELDCAT,
      SORT TYPE slis_t_sortinfo_alv,
      WA_SORT LIKE LINE OF SORT,
      LAYOUT TYPE SLIS_LAYOUT_ALV.

data : it_mchb TYPE TABLE OF mchb,
       wa_mchb TYPE mchb,
       it_mcha TYPE TABLE OF mcha,
       wa_mcha TYPE mcha.

TYPES : BEGIN OF ITAB1,
  WERKS TYPE MCHB-WERKS,
  MATNR TYPE MCHB-MATNR,
  CHARG TYPE MCHB-CHARG,
  LGORT TYPE MCHB-LGORT,
  STOCK TYPE P,
  VFDAT TYPE MCHA-VFDAT,
  END OF ITAB1.

TYPES : BEGIN OF ITAB2,
  WERKS TYPE MCHB-WERKS,
  MATNR TYPE MCHB-MATNR,
  CHARG TYPE MCHB-CHARG,
  LGORT TYPE MCHB-LGORT,
  STOCK TYPE P,
  VFDAT TYPE MCHA-VFDAT,
  maktx TYPE makt-maktx,
  END OF ITAB2.

TYPES : BEGIN OF ITAB3,
  WERKS TYPE MCHB-WERKS,
  MATNR TYPE MCHB-MATNR,
  CHARG TYPE MCHB-CHARG,
  LGORT TYPE MCHB-LGORT,
  STOCK TYPE P,
  VFDAT TYPE MCHA-VFDAT,
  kbetr TYPE KONP-KBETR,
  maktx TYPE makt-maktx,
  END OF ITAB3.

TYPES : BEGIN OF ITAB4,
  WERKS TYPE MCHB-WERKS,
  MATNR TYPE MCHB-MATNR,
  CHARG TYPE MCHB-CHARG,
  LGORT TYPE MCHB-LGORT,
  STOCK TYPE P,
  VFDAT TYPE MCHA-VFDAT,
  kbetr TYPE KONP-KBETR,
  kbetr1 TYPE KONP-KBETR,
  maktx TYPE makt-maktx,
  END OF ITAB4.

TYPES : BEGIN OF ITAB5,
  WERKS TYPE MCHB-WERKS,
  MATNR TYPE MCHB-MATNR,
  CHARG TYPE MCHB-CHARG,
  LGORT TYPE MCHB-LGORT,
  STOCK TYPE P,
  VFDAT TYPE MCHA-VFDAT,
  kbetr TYPE KONP-KBETR,
  kbetr1 TYPE KONP-KBETR,
  kondm TYPE MVKE-KONDM,
  kbetr2 TYPE KONP-KBETR,
  kbetr3 TYPE KONP-KBETR,
  abt TYPE KONP-KBETR,
  j_1ichid TYPE j_1imtchid-J_1ICHID,
  rate TYPE j_1iexctax-rate,
  regio TYPE T001W-REGIO,
  vrate TYPE ZREG_VAT-VRATE,
  maktx TYPE makt-maktx,

  END OF ITAB5.

TYPES : BEGIN OF ITAB6,
  WERKS TYPE MCHB-WERKS,
  MATNR TYPE MCHB-MATNR,
  CHARG TYPE MCHB-CHARG,
  LGORT TYPE MCHB-LGORT,
  STOCK TYPE P,
  VFDAT TYPE MCHA-VFDAT,
  kbetr TYPE KONP-KBETR,
  kbetr1 TYPE KONP-KBETR,
  kondm TYPE MVKE-KONDM,
  kbetr2 TYPE KONP-KBETR,
  kbetr3 TYPE KONP-KBETR,
  abt TYPE KONP-KBETR,
  j_1ichid TYPE j_1imtchid-J_1ICHID,
  rate TYPE j_1iexctax-rate,
  regio TYPE T001W-REGIO,
  vrate TYPE ZREG_VAT-VRATE,
  pts TYPE p DECIMALS 2,
  tot TYPE p DECIMALS 2,
  maktx TYPE makt-maktx,

  END OF ITAB6.

DATA : IT_TAB1 TYPE TABLE OF ITAB1,
       WA_TAB1 TYPE ITAB1,
       IT_TAB2 TYPE TABLE OF ITAB2,
       WA_TAB2 TYPE ITAB2,
       IT_TAB3 TYPE TABLE OF ITAB3,
       WA_TAB3 TYPE ITAB3,
       IT_TAB4 TYPE TABLE OF ITAB4,
       WA_TAB4 TYPE ITAB4,
       IT_TAB5 TYPE TABLE OF ITAB5,
       WA_TAB5 TYPE ITAB5,
       IT_TAB6 TYPE TABLE OF ITAB6,
       WA_TAB6 TYPE ITAB6.

data :  A1 TYPE P DECIMALS 3,
      A2 TYPE P DECIMALS 3,
      A3 TYPE P DECIMALS 3,
      A4 TYPE P DECIMALS 3,
      A5 TYPE P DECIMALS 3,
      A6 TYPE P DECIMALS 3,
      A7 TYPE P DECIMALS 3,
      A8 TYPE P DECIMALS 3,
      A9 TYPE P DECIMALS 2,
      A10 TYPE P DECIMALS 2.

data : stock TYPE p.
data : MESG(40) TYPE C,
      menge TYPE p DECIMALS 0.

select-OPTIONS : material FOR mchb-matnr,
                 plant FOR mchb-werks.
select-OPTIONS : STORAGE for MCHB-LGORT.
PARAMETERS : exp_dt LIKE sy-datum OBLIGATORY.

iNITIALIZATION.
  G_REPID = SY-REPID.

AT SELECTION-SCREEN.
  AUTHORITY-CHECK OBJECT '/DSD/SL_WR'
           ID 'WERKS' FIELD PLANT.

  If sy-subrc ne 0.
    MeSG = 'Check your entry'.
    MESSAGE MESG TYPE 'E'.
  endif.

START-OF-SELECTION.

select * from mchb into table it_mchb where matnr in material and werks in plant and lgort in storage.
if sy-subrc eq 0.
  select * from mcha into table it_mcha FOR ALL ENTRIES IN it_mchb WHERE matnr eq it_mchb-matnr and charg eq it_mchb-charg
    and werks eq it_mchb-werks.
ENDIF.
loop at it_mchb INTO wa_mchb.
   stock = wa_mchb-clabs + wa_mchb-CSPEM + wa_mchb-CUMLM + wa_mchb-CINSM + wa_mchb-CRETM.
   if stock ne 0.
*     WRITE : / wa_mchb-werks,wa_mchb-matnr,wa_mchb-charg,stock.
     WA_TAB1-WERKS = WA_MCHB-WERKS.
     WA_TAB1-MATNR = WA_MCHB-MATNR.
     WA_TAB1-CHARG = WA_MCHB-CHARG.
     WA_TAB1-LGORT = WA_MCHB-LGORT.
     WA_TAB1-STOCK = STOCK.

     read TABLE it_mcha INTO wa_mcha with key matnr = wa_mchb-matnr charg = wa_mchb-charg werks = wa_mchb-werks.
     if sy-subrc eq 0.
*       write : wa_mcha-vfdat.
       WA_TAB1-VFDAT = wa_mcha-vfdat.
     endif.
   COLLECT WA_TAB1 INTO IT_TAB1.
   endif.
CLEAR WA_TAB1.
ENDLOOP.


LOOP AT IT_TAB1 INTO WA_TAB1.
  IF WA_TAB1-VFDAT LE EXP_DT.
*  WRITE : / WA_TAB1-WERKS,WA_TAB1-MATNR,WA_TAB1-CHARG,WA_TAB1-LGORT,WA_TAB1-STOCK,WA_TAB1-VFDAT.
   wa_tab2-werks = wa_tab1-werks.
   wa_tab2-matnr = wa_tab1-matnr.
   wa_tab2-charg = wa_tab1-charg.
   wa_tab2-lgort = wa_tab1-lgort.
   wa_tab2-stock = wa_tab1-stock.
   wa_tab2-vfdat = wa_tab1-vfdat.
   select single * from makt WHERE matnr eq wa_tab1-matnr.
     if sy-subrc eq 0.
       wa_tab2-maktx = makt-maktx.
     endif.
  COLLECT wa_tab2 INTO it_tab2.

  ENDIF.
clear wa_tab2.
ENDLOOP.

*LOOP at it_tab2 INTO wa_tab2.
*  WRITE : / WA_TAB2-WERKS,WA_TAB2-MATNR,WA_TAB2-CHARG,WA_TAB2-LGORT,WA_TAB2-STOCK,WA_TAB2-VFDAT.
*ENDLOOP.




LOOP AT IT_TAB2 INTO WA_TAB2.
MOVE-CORRESPONDING wa_tab2 to wa_tab3.
  SELECT single * from A602 WHERE matnr eq wa_tab2-matnr and charg eq wa_tab2-charg and  KSCHL = 'Z001'
    AND DATAB LE SY-DATUM AND DATBI GE SY-DATUM.
     if sy-subrc eq 0.
     SELECT single * FROM KONP WHERE KNUMH = A602-KNUMH and kschl eq 'Z001'.
       IF SY-SUBRC EQ 0.
          WA_TAB3-KBETR = KONP-KBETR.
       ENDIF.
     ENDIF.

collect WA_TAB3 inTO IT_TAB3.
  clear wa_tab3.
ENDLOOP.

*loop at it_tab3 INTO wa_tab3.
*  write : / wa_tab3-matnr,wa_tab3-charg,wa_tab3-kbetr.
*ENDLOOP.


loop at it_tab3 into wa_tab3.
  MOVE-CORRESPONDING WA_TAB3 TO WA_TAB4.

  SELECT SINGLE * FROM A004 WHERE MATNR EQ WA_TAB3-MATNR AND KAPPL EQ 'V' AND KSCHL EQ 'ZPTS' AND VKORG EQ '1000'
    AND VTWEG IN ('10','80') AND DATBI GE SY-DATUM AND DATAB LE SY-DATUM.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM KONP WHERE KNUMH EQ A004-KNUMH AND KSCHL EQ 'ZPTS'.
        IF SY-SUBRC EQ 0.
           WA_TAB4-KBETR1 = KONP-KBETR.
        ENDIF.
    ENDIF.

COLLECT WA_TAB4 INTO IT_TAB4.
CLEAR WA_TAB4.
ENDLOOP.
*
*
*
LOOP AT IT_TAB4 INTO WA_TAB4.

  MOVE-CORRESPONDING wa_tab4 to wa_tab5.

*wa_tab5-werks = wa_tab4-werks.
*wa_tab5-matnr = wa_tab4-matnr.
*wa_tab5-charg = wa_tab4-charg.
*wa_tab5-stock = wa_tab4-stock.
*
*
*  wa_tab5-LGORT = wa_tab4-lgort.
*  wa_tab5-VFDAT = wa_tab4-VFDAT.
*  wa_tab5-kbetr = wa_tab4-KBETR.
*  wa_tab5-kbetr1 = wa_tab4-KBETR.

*************RETAILERS DISCOUNT.***************
   SELECT SINGLE * FROM MVKE WHERE MATNR EQ WA_TAB4-MATNR and vkorg eq '1000' AND VTWEG EQ '10'.
     IF SY-SUBRC EQ 0.
       WA_TAB5-KONDM = MVKE-KONDM.
*        write : / mvke-kondm,wa_tab4-kbetr.
        Select single * from a603 where kschl = 'Z010' AND KAPPL EQ 'V' AND   "RETAILERS DISCOUNT
          KONDM EQ MVKE-KONDM AND BONUS EQ MVKE-BONUS AND DATAB LE SY-DATUM AND
          DATBI GE SY-DATUM.
          IF SY-SUBRC EQ 0.
*            WRITE : / A603-KNUMH.
            SELECT SINGLE * FROM KONP WHERE KNUMH EQ A603-KNUMH AND KSCHL = 'Z010'.
              IF SY-SUBRC EQ 0.
*                WRITE : / KONP-KBETR.
                WA_TAB5-KBETR2 = KONP-KBETR * ( - 1 / 10 ).
              ENDIF.
          ENDIF.

*************** STOKIEST DISCOUNT*********
          Select single * from a603 where kschl = 'Z015' AND KAPPL EQ 'V' AND   "STOKIEST DISCOUNT
          KONDM EQ MVKE-KONDM AND BONUS EQ MVKE-BONUS AND DATAB LE SY-DATUM AND
          DATBI GE SY-DATUM.
          IF SY-SUBRC EQ 0.
*            WRITE : / A603-KNUMH.
            SELECT SINGLE * FROM KONP WHERE KNUMH EQ A603-KNUMH AND KSCHL = 'Z015'.
              IF SY-SUBRC EQ 0.
*                WRITE : / KONP-KBETR.
                WA_TAB5-KBETR3 = KONP-KBETR * ( - 1 / 10 ).
              ENDIF.
          ENDIF.
*****************************RETAILS & STOKIEST*********

     ENDIF.
   SELECT SINGLE * FROM KONP WHERE KSCHL EQ 'Z003'.
     IF SY-SUBRC EQ 0.
       WA_TAB5-ABT = KONP-KBETR / 10.
     ENDIF.

*COLLECT wa_tab10 INTO it_tab10.
*clear wa_tab10.


   select single * from j_1imtchid where matnr eq wa_tab4-matnr.
     if sy-subrc eq 0.
*       write : / j_1imtchid-J_1ICHID.
       wa_tab5-J_1ICHID = j_1imtchid-J_1ICHID.
       Select single * from j_1iexctax where j_1ichid eq j_1imtchid-J_1ICHID.
         if sy-subrc eq 0.
*           write : j_1iexctax-rate.
           wa_tab5-rate = j_1iexctax-rate.
         endif.
     ELSEif sy-subrc eq 4.
       wa_tab5-rate = 0.
     endif.
     SELECT SINGLE * FROM T001W WHERE WERKS = wa_tab4-werks.
       IF SY-SUBRC EQ 0.
*         WRITE : / 'check', T001W-REGIO.
         WA_TAB5-REGIO = T001W-REGIO.
     SELECT SINGLE * FROM ZREG_VAT WHERE REGION EQ T001W-REGIO AND VALID_FROM LE SY-DATUM AND VALID_TO GE SY-DATUM.
       IF SY-SUBRC EQ 0.
*         WRITE : / ZREG_VAT-VRATE.
         WA_TAB5-VRATE = ZREG_VAT-VRATE.
       ENDIF.
      ENDIF.

   COLLECT wa_tab5 INTO it_tab5.

*  pack wa_tab9-matnr to wa_tab9-matnr.
*  CONDENSE wa_tab9-matnr.
*  modify it_tab9 from wa_tab9 TRANSPORTING matnr.
ENDLOOP.


LOOP at it_tab5 INTO wa_tab5.
*write : / wa_tab5-matnr,wa_tab5-charg,wa_tab5-stock,wa_tab5-vfdat.
  MOVE-CORRESPONDING WA_TAB5 TO WA_TAB6.




*  WRITE : / WA_tab5-KBETR.
  A1 = WA_tab5-KBETR * ( WA_tab5-ABT / 100 ).
*  WRITE :   'a1',A1.
  A2 = A1 * ( WA_tab5-RATE / 100 ).
*  WRITE : 'ed',A2.         " EXCISE DUTY AMOUNT
  A3 = WA_tab5-VRATE + 100.
*  WRITE : 'vrate',WA_tab5-VRATE.         " TAXABLR AMT FOR VAT
  A4 = WA_tab5-KBETR * 100 / A3.
*  WRITE : A4.
  A5 = A4 * ( WA_tab5-VRATE / 100 ).
*  WRITE : A5.          "VAT ON AMOUNT
  A6 = WA_tab5-KBETR - A2 - A5.
*  WRITE : A6.  " MRP EXCLUDING ALL TAXES

  A7 = A6 - ( A6 * WA_tab5-KBETR2 / 100 ). "LESS RETAILERS DISCOUNT
*  WRITE : A7.
  A8 = A7 - ( A7 * WA_tab5-KBETR3 / 100 ). "LESS STOKIEST DISCOUNT
*  WRITE : A8.
  A9 = A8 + A2.             "ADD ED
**  WRITE : A9.    "PTS
  WA_TAB6-PTS = A9.
*  write : a9.
  WA_TAB6-TOT = WA_tab5-stock * A9.
  COLLECT WA_TAB6 INTO IT_TAB6.
  CLEAR WA_TAB6.
*   pack wa_tab5-matnr to wa_tab5-matnr.
*   CONDENSE wa_tab5-matnr.
*   modify it_tab5 from wa_tab5 TRANSPORTING matnr.
ENDLOOP.

loop at it_tab6 INTO wa_tab6.
*  write : / wa_tab6-matnr,wa_tab6-charg,wa_tab6-stock,wa_tab6-vfdat,wa_tab6-pts,wa_tab6-tot.

   pack wa_tab6-matnr to wa_tab6-matnr.
   CONDENSE wa_tab6-matnr.
   modify it_tab6 from wa_tab6 TRANSPORTING matnr.

ENDLOOP.




  WA_FIELDCAT-fieldname = 'WERKS'.
  WA_FIELDCAT-seltext_s = 'PLANT'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'LGORT'.
  WA_FIELDCAT-seltext_s = 'LOC'.
  APPEND WA_FIELDCAT TO FIELDCAT.

*  WA_FIELDCAT-fieldname = 'KONDM'.
*  WA_FIELDCAT-seltext_s = 'PRIC_GRP'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'RATE'.
*  WA_FIELDCAT-seltext_s = 'ED_RATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.
*
*  WA_FIELDCAT-fieldname = 'VRATE'.
*  WA_FIELDCAT-seltext_s = 'VAT_RATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'MATNR'.
  WA_FIELDCAT-seltext_s = 'CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'MAKTX'.
  WA_FIELDCAT-seltext_s = 'MATERIAL'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'CHARG'.
  WA_FIELDCAT-seltext_s = 'BATCH'.
  APPEND WA_FIELDCAT TO FIELDCAT.

*  WA_FIELDCAT-fieldname = 'ABT'.
*  WA_FIELDCAT-seltext_s = 'ABATMENT'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'KBETR'.
  WA_FIELDCAT-seltext_s = 'MRP'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'PTS'.
  WA_FIELDCAT-seltext_s = 'PTS'.
  APPEND WA_FIELDCAT TO FIELDCAT.

*  WA_FIELDCAT-fieldname = 'KBETR2'.
*  WA_FIELDCAT-seltext_s = 'RETA-DISC'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

*  WA_FIELDCAT-fieldname = 'HSDAT'.
*  WA_FIELDCAT-seltext_s = 'MFG_DATE'.
*  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'VFDAT'.
  WA_FIELDCAT-seltext_s = 'EXP_DATE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'STOCK'.
  WA_FIELDCAT-seltext_s = 'CLOSING_BAL'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'TOT'.
  WA_FIELDCAT-seltext_s = 'CLOSING_VAL'.
  APPEND WA_FIELDCAT TO FIELDCAT.






LAYOUT-zebra = 'X'.
LAYOUT-colwidth_optimize = 'X'.
LAYOUT-WINDOW_TITLEBAR  = 'NEAR EXPIRY REPORT'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING

     I_CALLBACK_PROGRAM                =  G_REPID
*   I_CALLBACK_PF_STATUS_SET          = ' '
   I_CALLBACK_USER_COMMAND           = 'USER_COMM'
   I_CALLBACK_TOP_OF_PAGE            = 'TOP'

   IS_LAYOUT                         = LAYOUT
     IT_FIELDCAT                       = FIELDCAT

   I_SAVE                            = 'A'

    TABLES
      T_OUTTAB                          = IT_TAB6
   EXCEPTIONS
     PROGRAM_ERROR                     = 1
     OTHERS                            = 2
            .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



FORM TOP.

  DATA: COMMENT TYPE SLIS_T_LISTHEADER,
        WA_COMMENT LIKE LINE OF COMMENT.

  WA_COMMENT-TYP = 'A'.
  WA_COMMENT-INFO = 'NEAR EXPIRY REPORT'.
*  WA_COMMENT-INFO = P_FRMDT.
  APPEND WA_COMMENT TO COMMENT.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY       = COMMENT
*     I_LOGO                   = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID       =
*     I_ALV_FORM               =
            .

CLEAR COMMENT.

ENDFORM.



FORM USER_COMM USING UCOMM LIKE SY-UCOMM
                     SELFIELD TYPE SLIS_SELFIELD.



  CASE SELFIELD-FIELDNAME.
    WHEN 'MATNR'.
      SET PARAMETER ID 'MAT' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
