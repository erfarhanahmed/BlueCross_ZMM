"Name: \FU:MB_READ_MATERIAL_STOCKS\SE:END\EI
ENHANCEMENT 0 ZMB31.
*Enhancement by Jyotsna to autocopy expiry & manufacturing date from halb...

*  IF SY-TCODE EQ 'MB31'.
*data : c_hsdat TYPE mcha-hsdat,
*      c_vfdat TYPE mcha-vfdat.
*   if sy-tcode eq 'MB31'.
*     IF DM07M-VFDAT_INPUT EQ '00000000' AND DM07M-HSDAT_INPUT EQ '00000000'.
*
*         SELECT SINGLE HSDAT VFDAT FROM MCHA INTO (C_HSDAT, C_VFDAT) WHERE
**      MATNR EQ I_MSEG-MATNR AND
*      CHARG EQ MSEG-CHARG AND VFDAT NE 0 AND HSDAT NE 0 .
*    IF SY-SUBRC EQ 0.
**      MESSAGE 'BATCH ALREADY EXIST ' TYPE 'I' .
**    I_DM07M-VFDAT_INPUT = .
**    C_VFDAT = EXP_DT.
**      MESSAGE I902 WITH c_hsdat.
**      MESSAGE I903 WITH c_vfdat.
*
*      DM07M-VFDAT_INPUT = C_VFDAT.
*      DM07M-HSDAT_INPUT = C_HSDAT.
**    UPDATE MCHA.
**    ELSE.
**      MESSAGE 'NEW BATCH ' TYPE 'I' .
*    ENDIF.
*  ENDIF.
*
*ENDIF.
*
*ENDIF.

*************  change in Enhacement to pop up auto expiry in MB1B for Extacef export product.
* it is link with material master**********

TABLES : mara.
IF sy-tcode = 'MIGO'.
  DATA : c_hsdat TYPE mcha-hsdat,
         c_vfdat TYPE mcha-vfdat.
  DATA : a        TYPE i,
         iprkz    TYPE mara-iprkz,
         mhdhb    TYPE  mara-mhdhb,
         mhdhb1   TYPE  mara-mhdhb,
         w_vfdat  TYPE mcha-vfdat,
         w_vfdat1 TYPE mcha-vfdat,
         w_hsdat  TYPE mcha-hsdat.

  CLEAR : a,w_vfdat1,w_vfdat,iprkz,mhdhb,w_hsdat, mhdhb1.


  IF dm07m-vfdat_input EQ '00000000' AND dm07m-hsdat_input EQ '00000000'.
************ coding for extacef export***************
    SELECT SINGLE * FROM mara WHERE matnr EQ mseg-matnr AND mtart IN ('ZESC','ZESM').
    IF sy-subrc EQ 0.
      iprkz = mara-iprkz.
      mhdhb = mara-mhdhb.
      IF mseg-matnr+13(5) EQ '15613' OR mseg-matnr+13(5) EQ '15614'.
        a = 1.
      ENDIF.
    ENDIF.
    IF a EQ 1.
      SELECT SINGLE hsdat FROM mcha INTO w_hsdat WHERE werks EQ mseg-werks AND charg = mseg-charg AND vfdat NE 0 AND hsdat NE 0.
      IF mhdhb NE 0 AND iprkz EQ '2'.
        CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
          EXPORTING
            iv_date           = w_hsdat
          IMPORTING
*           EV_MONTH_BEGIN_DATE       =
            ev_month_end_date = w_vfdat.

        mhdhb1 = mhdhb - 1.

        CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
          EXPORTING
            months  = mhdhb1
            olddate = w_vfdat
          IMPORTING
            newdate = w_vfdat1.
      ENDIF.
      IF w_vfdat1 EQ '00000000'.
        MESSAGE ' CHECK MATERIAL MASTER - PLANT DATA FOR THIS PRODUCT' TYPE 'E'.
      ENDIF.
      dm07m-vfdat_input = w_vfdat1.
      dm07m-hsdat_input = w_hsdat.
    ELSE.
***********************************************************

      DATA : it_mcha TYPE TABLE OF mcha,
             wa_mcha TYPE mcha.
      DATA : matnr TYPE mcha-matnr.

      SELECT * FROM mcha INTO TABLE it_mcha WHERE charg EQ mseg-charg.
      LOOP AT it_mcha INTO wa_mcha WHERE matnr CS 'H'.
        matnr = wa_mcha-matnr.
        EXIT.
      ENDLOOP.
      SELECT SINGLE hsdat vfdat FROM mcha INTO (c_hsdat, c_vfdat) WHERE charg EQ mseg-charg AND vfdat NE 0 AND hsdat NE 0
          AND matnr EQ matnr.
*      MATNR EQ I_MSEG-MATNR AND
      IF sy-subrc EQ 0.
        dm07m-vfdat_input = c_vfdat.
        dm07m-hsdat_input = c_hsdat.
      ENDIF.
    ENDIF.

  ENDIF.
**************  check posting*****************

**************CHECK CONFIRMATION QTY*************
*BREAK-POINT.
  IF mseg-matnr CS 'H'.

  ELSE.

    TABLES : afru.
    SELECT SINGLE * FROM afru WHERE aufnr EQ mseg-aufnr AND aueru EQ 'X' AND stokz EQ space AND stzhl EQ 0.
    IF sy-subrc EQ 0.


      DATA: cqty TYPE mseg-erfmg,
            bqty TYPE mseg-erfmg.

      DATA: it_afru  TYPE TABLE OF afru,
            wa_afru  TYPE afru,
            it_afru1 TYPE TABLE OF afru,
            wa_afru1 TYPE afru,
            it_mchb  TYPE TABLE OF mchb,
            wa_mchb  TYPE mchb.

      CLEAR : cqty,bqty.
      SELECT * FROM mchb INTO TABLE it_mchb WHERE matnr EQ mseg-matnr AND charg EQ mseg-charg AND lgort GE 'FG01' AND
        lgort LE 'FG04' AND cspem GT 0.
      LOOP AT it_mchb INTO wa_mchb.
        bqty = bqty + wa_mchb-cspem.
      ENDLOOP.
      SELECT * FROM afru INTO TABLE it_afru WHERE aufnr EQ mseg-aufnr AND aueru EQ 'X' AND stokz EQ space AND stzhl EQ 0.
*       and iedd  ge date1.
      SELECT * FROM afru INTO TABLE it_afru1 WHERE aufnr EQ mseg-aufnr AND stokz EQ space AND stzhl EQ 0 .
*      and iedd  ge date1.
*       LTXA1 EQ SPACE.
      LOOP AT it_afru1 INTO wa_afru1 WHERE aufnr EQ mseg-aufnr.
        READ TABLE it_afru INTO wa_afru WITH KEY aufnr = mseg-aufnr.
        IF sy-subrc EQ 0.
          cqty = cqty + wa_afru1-gmnga.
        ENDIF.
      ENDLOOP.
      IF cqty = ( mseg-erfmg + bqty ).
      ELSE.
        IF sy-uname EQ 'ITBOM01'.
          MESSAGE 'CHECK FINAL CONFIRMATION AND CONFIRMATION QUANTITY' TYPE 'I'.
        ELSE.
          MESSAGE 'CHECK FINAL CONFIRMATION AND CONFIRMATION QUANTITY' TYPE 'I'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
*ENDIF.

ENDIF.

ENDENHANCEMENT.
