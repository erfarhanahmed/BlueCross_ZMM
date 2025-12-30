"Name: \PR:SAPMM07M\FO:OK-CODE_PRUEFEN\SE:BEGIN\EI
ENHANCEMENT 0 ZMB31_4.
******************* restrict stock posting if ud is not done but stock is posted*****************
  TABLES : QALS,QAVE,jest.
  data: lwa_mara type mara,
        lwa_qals type qals,
        lwa_qave type qave.

if sy-tcode eq 'MB1A' AND MSEG-BWART EQ '261'.
  if mseg-werks eq '1000' or mseg-werks eq '1001'.
  IF MSEG-MENGE GT 0 OR MSEG-ERFMG GT 0.
     SELECT SINGLE * FROM mara into lwa_mara WHERE matnr eq mseg-matnr AND mtart eq 'ZROH'.
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM QALS into lwa_qals
                        WHERE MATNR EQ MSEG-MATNR
                          AND CHARG EQ MSEG-CHARG
                          AND werk eq mseg-werks
                          AND STAT34 EQ 'X'.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM QAVE into lwa_qave WHERE PRUEFLOS EQ lwa_QALS-PRUEFLOS AND VCODE IN ( 'A','PA' ).
        IF SY-SUBRC EQ 0.
        ELSE.
          MESSAGE 'UD IS NOT YET DONE FOR THIS BATCH - PLEASE CHECK WITH QC' TYPE 'I'.
           MESSAGE 'UD IS NOT YET DONE FOR THIS BATCH - PLEASE CHECK WITH QC' TYPE 'W'.
           MSEG-MENGE = 0.
           mseg-erfmg = 0.
           MODIFY MSEG.
        ENDIF.
    ENDIF.
    ENDIF.


*********** error if save**************
*** if sy-ucomm eq 'BU'.
***    SELECT SINGLE * FROM mara WHERE matnr eq mseg-matnr AND mtart eq 'ZROH'.
***      IF SY-SUBRC EQ 0.
*** SELECT SINGLE * FROM QALS WHERE MATNR EQ MSEG-MATNR AND CHARG EQ MSEG-CHARG AND werk eq mseg-werks..
***    IF SY-SUBRC EQ 0.
***      SELECT SINGLE * FROM QAVE WHERE PRUEFLOS EQ QALS-PRUEFLOS AND VCODE IN ( 'A','PA' ).
***        IF SY-SUBRC EQ 0.
***        ELSE.
***            SELECT SINGLE * FROM JEST WHERE OBJNR EQ QALS-OBJNR AND STAT EQ 'I0224'.
***    IF SY-SUBRC EQ 4.
***          MESSAGE 'UD IS NOT YET DONE FOR THIS BATCH - REMOVE QUANTITY' TYPE 'E'.
***          endif.
***        ENDIF.
***    ENDIF.
***    ENDIF.
***  ENDIF.

*******************new logic********************
DATA: IT_QALS TYPE TABLE OF QALS,
      WA_QALS TYPE QALS.
DATA: UD(1) TYPE C.
CLEAR : UD.
CLEAR : IT_QALS,WA_QALS.
 if sy-ucomm eq 'BU'.
    clear: lwa_mara.
    SELECT SINGLE * FROM mara into lwa_mara WHERE matnr eq mseg-matnr AND mtart eq 'ZROH'.
      IF SY-SUBRC EQ 0.
 SELECT * FROM QALS INTO TABLE it_qals WHERE MATNR EQ MSEG-MATNR AND CHARG EQ MSEG-CHARG AND werk eq mseg-werks.

   LOOP at it_qals INTO wa_qals.
      SELECT SINGLE * FROM JEST WHERE OBJNR EQ wa_QALS-OBJNR AND STAT EQ 'I0224'.
          IF SY-SUBRC EQ 4.
            SELECT SINGLE * FROM QAVE WHERE PRUEFLOS EQ wa_QALS-PRUEFLOS AND VCODE IN ( 'A','PA' ).
              IF SY-SUBRC EQ 0.
                 ud = 'Y'.
              endif.
          endif.
   ENDLOOP.
   IF UD NE 'Y'.
       MESSAGE 'UD IS NOT YET DONE FOR THIS BATCH - REMOVE QUANTITY' TYPE 'E'.
    ENDIF.
  ENDIF.
  ENDIF.

*  ********************************************

endif.
 ENDIF.
ENDIF.


******************************************

IF SY-TCODE EQ 'MB31' .
  IF SY-UCOMM EQ 'BU' OR SY-UCOMM EQ 'YES'.
    IF DM07M-HSDAT_INPUT EQ '00000000'.
      MESSAGE 'ENTER MANUFACTURING DATE ' TYPE 'E'.
    ENDIF.
    IF DM07M-VFDAT_INPUT EQ '00000000'.
      MESSAGE 'ENTER MANUFACTURING DATE ' TYPE 'E'.
    ENDIF.
  ENDIF.
ENDIF.

ENDENHANCEMENT.
