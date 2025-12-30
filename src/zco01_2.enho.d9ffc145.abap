"Name: \FU:VB_BATCH_DETERMINATION\SE:END\EI
ENHANCEMENT 0 ZCO01_2.
*Jyotsna 15.6.20 - restrict Prodcion order release if UD is not done..
TABLES : QALS,QAVE,mara.

SELECT SINGLE * FROM MARA WHERE MATNR EQ E_BDBATCH-MATNR AND MTART EQ 'ZROH'.
  IF SY-SUBRC EQ 0.

****************** CHECK IF FEFO BTCH EXIST IN STOCK 31.12.24 by Jyotsna**************
SELECt SINGLE * FROM qals WHERE matnr eq E_BDBATCH-MATNR AND charg eq e_bdbatch-charg AND werk eq e_bdbatch-werks
  AND STAT34 EQ 'X'.
  if sy-subrc eq 0.
    if E_BDBATCH-matnr gt 0.
    DATA: ZVFDAT TYPE VFDAT.
    DATA: IT_MSEG TYPE TABLE OF MSEG,
          WA_MSEG TYPE MSEG,
          IT_MCHB TYPE TABLE OF MCHB,
          WA_MCHB TYPE MCHB.
    CLEAR : ZVFDAT,IT_MSEG,WA_MSEG,IT_MCHB,WA_MCHB.
    if E_BDBATCH-werks eq '1000' or E_BDBATCH-werks eq '1001'.
      SELECT SINGLE vfdat INTO zvfdat FROM mcha WHERE matnr eq e_bdbatch-matnr AND  charg eq e_bdbatch-charg
        AND werks eq e_bdbatch-werks.
      SELECT * FROM MCHB INTO TABLE IT_MCHB WHERE MATNR EQ E_BDBATCH-MATNR AND charg NE e_bdbatch-charg
        AND werkS eq e_bdbatch-werks AND CLABS GT 0.
        if sy-subrc eq 0.
          SELECT * FROM mseg INTO TABLE it_mseg FOR ALL ENTRIES IN it_mchb WHERE bwart eq '261' AND
             matnr eq it_mchb-matnr AND charg eq it_mchb-charg AND werks eq it_mchb-werks.
        endif.
     LOOP AT IT_MCHB INTO WA_MCHB WHERE MATNR EQ E_BDBATCH-MATNR.
       READ TABLE IT_Mseg INTO WA_Mseg WITH KEY MATNR = WA_MCHB-MATNR CHARG = WA_MCHB-CHARG.
       IF SY-SUBRC EQ 0.
*         MESSAGE 'CHECK OLD ISSUED STOCK FOR ' TYPE 'I'.
*         MESSAGE I972(ZHR_MESSAGE) WITH E_BDBATCH-MATNR.  "decpmmented on 17.9.25 Jyotsna
       endif.
     ENDLOOP.
    ENDIF.
  ENDIF.
  endif.

*    ********************************
SELECt SINGLE * FROM qals WHERE matnr eq E_BDBATCH-MATNR AND charg eq e_bdbatch-charg AND werk eq e_bdbatch-werks
  AND STAT34 EQ 'X'.
  if sy-subrc eq 0.
    if E_BDBATCH-werks eq '1000' or E_BDBATCH-werks eq '1001'.
    SELECT SINGLE * FROM qave WHERE prueflos eq qals-prueflos AND vcode in ( 'A','PA' ).
      IF SY-SUBRC EQ 0.

      ELSE.
*        MESSAGE 'UD IS NOT YET DONE FOR ITEM CODE ' TYPE 'E'.
        if sy-uname eq 'ITBOM01'.
           MESSAGE I901(PG) WITH E_BDBATCH-MATNR E_BDBATCH-CHARG.
        ELSE.
*           MESSAGE E901(PG) WITH E_BDBATCH-MATNR E_BDBATCH-CHARG. "decpmmented on 17.9.25 Jyotsna
        ENDIF.
      ENDIF.
    endif.
  ENDIF.
  endif.

ENDENHANCEMENT.
