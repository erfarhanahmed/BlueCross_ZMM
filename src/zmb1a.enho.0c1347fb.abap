"Name: \PR:SAPMM07M\FO:PICKUP_AUSFUEHREN\SE:BEGIN\EI
ENHANCEMENT 0 ZMB1A.

  DATA : zmatnr    TYPE aufm-matnr,
         zcharg    TYPE aufm-charg,
         lgort     TYPE mseg-lgort,
         lwa_afpo  TYPE afpo,
         lwa_zmrn  TYPE zmrn,
         lwa_zmb1a TYPE zmb1a.

  IF sy-tcode = 'MIGO'.

    IF cobl-bwart EQ 'Y01' OR cobl-bwart EQ 'Y02'.
      MESSAGE 'THIS MOVEMENT IS NOT POSSIBLE' TYPE 'E'.
    ENDIF.

***********NEW CHANGE TO RESTRICT PACKING MATERIAL ISSUANCE OTHER THAN PRIMARY FOR SALE PRODUCTS********************************
*  *********************************

    IF cobl-bwart EQ '261'.
      DATA: it_qals TYPE TABLE OF qals,
            wa_qals TYPE qals.

      DATA: vcode TYPE qave-vcode.
      DATA: matnr1 TYPE mara-matnr.
      DATA: zaufnr TYPE afpo-aufnr.

      DATA: exp1(1) TYPE c.
      DATA: mtart TYPE mara-mtart.
      CLEAR : vcode.

**************************** ALLOW EXPORT AND SAMPLE *************
      SELECT SINGLE * FROM afpo INTO lwa_afpo WHERE aufnr EQ cobl-aufnr.
      IF sy-subrc = 0.
*************** ALLOW EXPORT & SAMPLE. **********************************
        CLEAR : mtart,exp1.
        SELECT SINGLE mtart INTO mtart FROM mara WHERE matnr EQ lwa_afpo-matnr.

        IF mtart EQ 'ZESC' OR mtart EQ 'ZESM' OR mtart EQ 'ZDSM'.
          exp1 = 'A'.
        ENDIF.

      ENDIF.
      IF mtart EQ 'ZHLB'.
        exp1 = 'A'.
      ENDIF.
**************allow reprocessing batches 5.9.25- Jyotsna*****
      DATA: rcharg TYPE afpo-charg.
      CLEAR : rcharg.
      SELECT SINGLE  rcharg INTO rcharg FROM zcoabatch WHERE rcharg EQ lwa_afpo-charg.  "ADDED ON 5.9.25 FOR REPROCESSED BATCH
      IF rcharg IS NOT INITIAL.
        exp1 = 'A'.
      ENDIF.
***************ENDS EXPORT LIQUID**************************
      IF exp1 EQ 'A'.

      ELSE.
        SELECT SINGLE aufnr INTO zaufnr FROM zmrn_ord WHERE aufnr EQ cobl-aufnr.  "added on 16.12.24 Jyotsna for mft & mpt batch issue
        IF zaufnr IS INITIAL.

          SELECT SINGLE * FROM afpo INTO lwa_afpo WHERE aufnr EQ cobl-aufnr.
          IF sy-subrc EQ 0.
            SELECT * FROM qals INTO TABLE it_qals WHERE art EQ '04' AND charg EQ lwa_afpo-charg
              AND werk EQ lwa_afpo-pwerk.
            LOOP AT it_qals INTO wa_qals.
              SELECT SINGLE vcode FROM qave INTO vcode WHERE prueflos EQ wa_qals-prueflos AND vcode EQ 'A'.
            ENDLOOP.
            CLEAR : matnr1.
            IF vcode NE 'A'.
              IF mseg-erfmg GT 0.
*                MESSAGE 'HALB IS NOT RELEASED' TYPE 'I'.
                SELECT SINGLE matnr FROM mara INTO matnr1 WHERE matnr EQ mseg-matnr AND matkl EQ 'PPM001'.
                IF matnr1 EQ space.
                  MESSAGE 'MATERIAL ISSUE IS NOT ALLOWED AS HALB IS NOT YET RELEASED' TYPE 'E'.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.
*endif.
************************************
***************END ****************

    IF cobl-aufnr IS NOT INITIAL.
      IF cobl-bwart EQ '262'.

        CLEAR : lgort.
        SELECT SINGLE * FROM zmrn INTO lwa_zmrn WHERE pmmatnr EQ mseg-matnr AND werks EQ mseg-werks.
        IF sy-subrc EQ 0.
          SELECT SINGLE * FROM afpo INTO lwa_afpo WHERE aufnr EQ cobl-aufnr.
          IF sy-subrc EQ 0.
            lgort = lwa_afpo-lgort.
          ENDIF.
          IF lgort EQ 'FG04'.
            IF mseg-lgort NE 'MRN4'.
              IF sy-datum GE '20220401'.
                SELECT SINGLE * FROM zmb1a INTO lwa_zmb1a WHERE uname EQ sy-uname AND cpudt EQ sy-datum.
                IF sy-subrc EQ 0.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN4' TYPE 'I'.
                ELSE.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN4' TYPE 'E'.
                ENDIF.
              ENDIF.
            ENDIF.
          ELSE.
            IF mseg-lgort NE 'MRN1'.
              IF sy-datum GE '20220401'.
                SELECT SINGLE * FROM zmb1a INTO lwa_zmb1a WHERE uname EQ sy-uname AND cpudt EQ sy-datum.
                IF sy-subrc EQ 0.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN1' TYPE 'I'.
                ELSE.
                  MESSAGE 'CHECK MRN STORAGE LOCATION  - MRN1' TYPE 'E'.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.
    ENDIF.
  ENDIF.
ENDENHANCEMENT.
