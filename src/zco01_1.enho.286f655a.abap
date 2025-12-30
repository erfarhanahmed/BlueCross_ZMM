"Name: \PR:SAPLCOKO1\FO:CONFIG_OVERWRITE_LOCK\SE:BEGIN\EI
ENHANCEMENT 0 ZCO01_1.
*eNHACED BY Jyotsna TO RESTRICT used batch prefix at one plant should not be used at other plant for Nashik & Goa 12.1.25
  IF sy-tcode = 'COR1' OR sy-tcode = 'COR2'.

    DATA: it_afpo  TYPE TABLE OF afpo,
          wa_afpo  TYPE afpo,
          it_aufk  TYPE TABLE OF aufk,
          wa_aufk  TYPE aufk,
          lwa_mara TYPE mara.
    DATA: hqty  TYPE p,
          fqty  TYPE p,
          nqty  TYPE p,
          cqty  TYPE p,
          hunit TYPE afpo-meins.
    DATA: fsz1 TYPE p,
          csz1 TYPE p.
    DATA: date1  TYPE sy-datum,
          werks1 TYPE werks.

    IF afpod-charg NE space.
      DATA:var(20) TYPE c,
           moff    TYPE i,
           mlen    TYPE i,
           alp     TYPE char10,
           num     TYPE char10,
           len     TYPE i,
           off     TYPE i.
      TYPES: BEGIN OF bat1,
               alp(10) TYPE c,
             END OF bat1.
      DATA: it_bat1 TYPE TABLE OF bat1,
            wa_bat1 TYPE bat1.

********************check for used batch**************
      IF afpod-dwerk EQ '1000'.
        werks1 = '1001'.
      ELSEIF afpod-dwerk EQ '1001'.
        werks1 = '1000'.
      ENDIF.
      date1 = sy-datum.
      date1+0(4) = sy-datum+0(4) - 10.
      SELECT * FROM afpo INTO TABLE it_afpo WHERE dwerk EQ werks1 AND dgltp GE date1 AND lgort GE 'SF01' AND
        lgort LE 'SF04'.
      IF it_afpo IS NOT INITIAL.
        SELECT * FROM aufk INTO TABLE it_aufk FOR ALL ENTRIES IN it_afpo WHERE aufnr EQ it_afpo-aufnr AND loekz
          NE 'X'.
      ENDIF.
      LOOP AT it_afpo INTO wa_afpo.
        READ TABLE it_aufk INTO wa_aufk WITH KEY aufnr = wa_afpo-aufnr.
        IF sy-subrc EQ 0.
          CLEAR : var,len,alp,num.
          var = wa_afpo-charg.
          FIND REGEX '([[:alpha:]]*)' IN var IGNORING CASE MATCH OFFSET moff MATCH LENGTH mlen.
          IF mlen GT 0.
            len = strlen( var ).
            alp = var+0(mlen).
            CONDENSE alp.
            wa_bat1-alp = alp.
            COLLECT wa_bat1 INTO it_bat1.
            CLEAR wa_bat1.
          ENDIF.
        ENDIF.
      ENDLOOP.
      SORT it_bat1 BY alp.
      DELETE ADJACENT DUPLICATES FROM it_bat1 COMPARING alp.

      CLEAR : var,len,alp,num.
      var = afpod-charg.
      FIND REGEX '([[:alpha:]]*)' IN var IGNORING CASE MATCH OFFSET moff MATCH LENGTH mlen.
      IF mlen GT 0.
        len = strlen( var ).
        alp = var+0(mlen).
        CONDENSE alp.
      ENDIF.
      IF alp NE space.
        READ TABLE it_bat1 INTO wa_bat1 WITH KEY alp = alp.
        IF sy-subrc EQ 0.
          MESSAGE 'THIS BATCH PREFIX IS ALREADY USED' TYPE 'E'.
        ENDIF.
      ENDIF.
*endif.
      CLEAR : it_afpo,wa_afpo,it_aufk,wa_aufk.

    ENDIF.
  ENDIF.

******************************************************

  IF sy-tcode EQ 'COR1' .

    CLEAR: lwa_mara.
    IF afpod-charg NE space.
      SELECT SINGLE * FROM mara INTO lwa_mara WHERE matnr EQ afpod-matnr AND mtart NE 'ZHLB'.
      IF sy-subrc EQ 0.
        SELECT * FROM afpo INTO TABLE it_afpo WHERE charg EQ afpod-charg.
        IF sy-subrc EQ 0.
          SELECT * FROM aufk INTO TABLE it_aufk FOR ALL ENTRIES IN it_afpo WHERE aufnr EQ it_afpo-aufnr AND loekz EQ space.
        ENDIF.

        CLEAR : hqty,fqty,cqty,nqty.
        CLEAR : fsz1,csz1.

        LOOP AT it_afpo INTO wa_afpo WHERE charg = afpod-charg.
          READ TABLE it_aufk INTO wa_aufk WITH KEY aufnr = wa_afpo-aufnr loekz = space.
          IF sy-subrc EQ 0.
            SELECT SINGLE * FROM mara INTO lwa_mara WHERE matnr EQ wa_afpo-matnr AND mtart EQ 'ZHLB'.
            IF sy-subrc EQ 0.
              hunit = wa_afpo-meins.
              hqty = hqty + wa_afpo-psmng.
            ENDIF.
          ENDIF.
        ENDLOOP.

        IF hunit EQ 'PC'.

          LOOP AT it_afpo INTO wa_afpo WHERE charg = afpod-charg.
            READ TABLE it_aufk INTO wa_aufk WITH KEY aufnr = wa_afpo-aufnr loekz = space.
            IF sy-subrc EQ 0.
              SELECT SINGLE * FROM mara INTO lwa_mara WHERE matnr EQ wa_afpo-matnr AND mtart EQ 'ZHLB'.
              IF sy-subrc EQ 4.
                SELECT SINGLE * FROM marm WHERE matnr EQ wa_afpo-matnr AND meinh EQ 'PC'.
                IF sy-subrc EQ 0.
                  fqty = fqty + ( wa_afpo-psmng * marm-umren ).
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.

          SELECT SINGLE * FROM marm WHERE matnr EQ afpod-matnr AND meinh EQ 'PC'.
          IF sy-subrc EQ 0.
            cqty = afpod-psmng * marm-umren.
          ENDIF.

          nqty = cqty + fqty.

          IF nqty GT hqty.
            MESSAGE 'BATCH SIZE IS EXCEEDING ' TYPE 'E'.
          ENDIF.

        ELSEIF hunit EQ 'L' .

          hqty = hqty * 1000.
          LOOP AT it_afpo INTO wa_afpo WHERE charg = afpod-charg.
            READ TABLE it_aufk INTO wa_aufk WITH KEY aufnr = wa_afpo-aufnr loekz = space.
            IF sy-subrc EQ 0.
              SELECT SINGLE * FROM mara INTO lwa_mara WHERE matnr EQ wa_afpo-matnr AND mtart EQ 'ZHLB'.
              IF sy-subrc EQ 4.
                SELECT SINGLE * FROM marm WHERE matnr EQ wa_afpo-matnr AND meinh EQ 'L'.
                IF sy-subrc EQ 0.
*            Fqty = Fqty + ( wa_afpo-psmng * MARM-UMREZ ).
                  fsz1 = wa_afpo-psmng  *  ( ( marm-umren * 1000 ) / marm-umrez  ).
                  fqty = fqty + fsz1.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.

          SELECT SINGLE * FROM marm WHERE matnr EQ afpod-matnr AND meinh EQ 'L'.
          IF sy-subrc EQ 0.
            csz1 = ( marm-umren * 1000 ) / marm-umrez.
            cqty = afpod-psmng * csz1.
          ENDIF.

          nqty = cqty + fqty.

          IF nqty GT hqty.
            MESSAGE 'BATCH SIZE IS EXCEEDING ' TYPE 'E'.
          ENDIF.

        ELSEIF hunit EQ 'KG' .

          hqty = hqty * 1000.
          LOOP AT it_afpo INTO wa_afpo WHERE charg = afpod-charg.
            READ TABLE it_aufk INTO wa_aufk WITH KEY aufnr = wa_afpo-aufnr loekz = space.
            IF sy-subrc EQ 0.
              SELECT SINGLE * FROM mara INTO lwa_mara WHERE matnr EQ wa_afpo-matnr AND mtart EQ 'ZHLB'.
              IF sy-subrc EQ 4.
                SELECT SINGLE * FROM marm WHERE matnr EQ wa_afpo-matnr AND meinh EQ 'KG'.
                IF sy-subrc EQ 0.
                  fsz1 = wa_afpo-psmng  *  ( ( marm-umren * 1000 ) / marm-umrez  ).
                  fqty = fqty + fsz1.
*            Fqty = Fqty + ( wa_afpo-psmng * MARM-UMREZ ).
                ENDIF.
              ENDIF.
            ENDIF.
          ENDLOOP.

          SELECT SINGLE * FROM marm WHERE matnr EQ afpod-matnr AND meinh EQ 'KG'.
          IF sy-subrc EQ 0.
            csz1 = ( marm-umren * 1000 ) / marm-umrez.
            cqty = afpod-psmng * csz1.
*     Cqty = afpoD-psmng * MARM-UMREZ.
          ENDIF.

          nqty = cqty + fqty.

          IF nqty GT hqty.
            MESSAGE 'BATCH SIZE IS EXCEEDING ' TYPE 'E'.
          ENDIF.


        ENDIF.


      ENDIF.
    ENDIF.
  ENDIF.

ENDENHANCEMENT.
