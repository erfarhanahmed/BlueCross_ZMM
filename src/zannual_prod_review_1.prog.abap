*&---------------------------------------------------------------------*
*& Report  ZANNUAL_PROD_REVIEW4
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  ZANNUAL_PROD_REVIEW8 NO STANDARD PAGE HEADING LINE-SIZE 800.

TABLES : QALS,
         QAVE,
         QAMR,
         MAPL,
         PLMK,
         QAMV,
         MARA,
         LFA1,
         MSEG,
         MAKT,
         JEST,
         ZMIGO.


DATA : IT_QALS   TYPE TABLE OF QALS,
       WA_QALS   TYPE QALS,
       IT_QAVE   TYPE TABLE OF QAVE,
       WA_QAVE   TYPE QAVE,
       IT_QAMV   TYPE TABLE OF QAMV,
       WA_QAMV   TYPE QAMV,
       IT_QAMV1  TYPE TABLE OF QAMV,
       WA_QAMV1  TYPE QAMV,
       IT_QALS11 TYPE TABLE OF QALS,
       WA_QALS11 TYPE QALS,
       IT_MSEG   TYPE TABLE OF MSEG,
       WA_MSEG   TYPE MSEG,
       IT_QALS_1 TYPE TABLE OF QALS,
       WA_QALS_1 TYPE QALS.


TYPES : BEGIN OF ITAB1,
          LIFNR    TYPE QALS-LIFNR,
          MATNR    TYPE QALS-MATNR,
          CHARG    TYPE QALS-CHARG,
          PRUEFLOS TYPE QALS-PRUEFLOS,
          MFGR     TYPE ZMIGO-MFGR,
        END OF ITAB1.

DATA: A TYPE I.

DATA : IT_TAB1 TYPE TABLE OF ITAB1,
       WA_TAB1 TYPE ITAB1.

DATA : DATA1(25)  TYPE C,
       DATA2(10)  TYPE C,
       DATA3(25)  TYPE C,
       DATA4(10)  TYPE C,
       DATA5(16)  TYPE C,
       DATA51(16) TYPE C,
       DATA6(16)  TYPE C,
       DATA7      TYPE P DECIMALS 4,
       DATA8(10)  TYPE C,
       DATA9      TYPE P DECIMALS 2.

DATA : MAKTX         TYPE MAKT-MAKTX,
       NORMT         TYPE MARA-NORMT,
       MAKTX1(50)    TYPE C,
       COUNT         TYPE I,
       VENDORNM(100) TYPE C,
       MFGRNAME(100) TYPE C.
DATA: PRUEFLOS1 TYPE QAVE-PRUEFLOS.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : BATCH FOR QALS-CHARG .
SELECT-OPTIONS : ART FOR QALS-ART OBLIGATORY.
SELECT-OPTIONS : S_BUDAT FOR QAVE-VDATUM OBLIGATORY.
PARAMETERS : PLANT    LIKE QALS-WERK OBLIGATORY,
             MATERIAL LIKE QALS-MATNR OBLIGATORY.
SELECT-OPTIONS : CHARS FOR QAMV-VERWMERKM.
PARAMETERS : REMARK TYPE STRING.
PARAMETERS : CONC TYPE STRING.
SELECTION-SCREEN END OF BLOCK MERKMALE1 .

SELECT * FROM QALS INTO TABLE IT_QALS WHERE WERK EQ PLANT AND ART IN ART AND MATNR EQ MATERIAL AND CHARG IN BATCH.
IF SY-SUBRC EQ 0.
  SELECT * FROM QAVE INTO TABLE IT_QAVE FOR ALL ENTRIES IN IT_QALS WHERE PRUEFLOS EQ IT_QALS-PRUEFLOS AND VDATUM IN S_BUDAT.
  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.
ENDIF.

SORT IT_QALS BY PRUEFLOS CHARG.
*DELETE ADJACENT DUPLICATES FROM IT_QALS COMPARING PRUEFLOS CHARG.

LOOP AT IT_QALS INTO WA_QALS.
  READ TABLE IT_QAVE INTO WA_QAVE WITH KEY PRUEFLOS = WA_QALS-PRUEFLOS.
  IF SY-SUBRC EQ 0.
*    WRITE : / WA_QALS-MATNR,WA_QALS-CHARG,wa_qals-prueflos.
    WA_TAB1-MATNR = WA_QALS-MATNR.
    WA_TAB1-CHARG = WA_QALS-CHARG.
    WA_TAB1-PRUEFLOS = WA_QALS-PRUEFLOS.
    WA_TAB1-LIFNR = WA_QALS-LIFNR.
    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
  ENDIF.

ENDLOOP.
PERFORM UPDLIFNR.
PERFORM MFGR.

SORT IT_TAB1 BY LIFNR CHARG PRUEFLOS.
*sort it_tab1 by charg.
DELETE ADJACENT DUPLICATES FROM IT_TAB1 COMPARING CHARG.

* NEW DETAILS************************
CLEAR : MAKTX,NORMT,MAKTX1.
FORMAT COLOR 3.
SELECT SINGLE * FROM MAKT WHERE MATNR EQ MATERIAL AND SPRAS EQ 'EN'.
IF SY-SUBRC EQ 0.
*  write : /1(10) makt-matnr left-justified.
  MAKTX =  MAKT-MAKTX.
  SELECT SINGLE * FROM MARA WHERE MATNR EQ MATERIAL.
  IF SY-SUBRC EQ 0.
    NORMT = MARA-NORMT.
  ENDIF.
ENDIF.
CONCATENATE MAKTX NORMT INTO MAKTX1 SEPARATED BY SPACE.
*write : maktx1.
*uline.
********************************************
*uline.
SORT IT_TAB1 BY LIFNR MFGR.

*LOOP AT IT_TAB1 INTO WA_TAB1.
**  WRITE : / 'a',wa_tab1-charg,wa_tab1-prueflos.
*ENDLOOP.
*******************************************************************************************************************************************
SELECT * FROM QAMV INTO TABLE IT_QAMV FOR ALL ENTRIES IN IT_TAB1 WHERE PRUEFLOS EQ IT_TAB1-PRUEFLOS AND VERWMERKM IN CHARS.
SELECT * FROM QAMV INTO TABLE IT_QAMV1 WHERE PRUEFLOS EQ WA_TAB1-PRUEFLOS AND VERWMERKM IN CHARS.
IF IT_QAMV1 IS INITIAL.
  SORT IT_QAVE DESCENDING BY VDATUM.
  CLEAR : PRUEFLOS1.
  READ TABLE IT_QAVE INTO WA_QAVE INDEX 1.
  IF SY-SUBRC EQ 0.
    PRUEFLOS1 = WA_QAVE-PRUEFLOS.
  ENDIF.
  SELECT * FROM QAMV INTO TABLE IT_QAMV1 WHERE PRUEFLOS EQ PRUEFLOS1 AND VERWMERKM IN CHARS.
ENDIF.
*  SELECT * FROM QAMV INTO TABLE IT_QAMV1 FOR ALL ENTRIES IN IT_TAB1 WHERE PRUEFLOS EQ IT_TAB1-PRUEFLOS AND VERWMERKM IN CHARS.
********************************************************************************************************************************
* write : /1(2) 'Sr',4(10) 'Receipt',17(10) 'Quantity',32(25) 'Packing-No. of bags',59(10) 'Approved/',70(11) 'A.R. Number', 83(15) 'Mfgr''s Batch No.'.
**   WRITE : /1(2) 'No.',59(10) 'Rejected'.
*
******************************
*loop at it_qamv1 into wa_qamv1.
*
*  select single * from qamr where prueflos eq wa_qamv1-prueflos and merknr eq wa_qamv1-merknr.
*
*  if sy-subrc eq 0.
*    if  qamr-maxwertni ne '*'.
*      write : wa_qamv1-kurztext+0(10).
*
*    else.
*      write : wa_qamv1-kurztext+0(10).
*      write : wa_qamv1-kurztext+0(10).
*    endif.
**    select single * from qals where prueflos eq wa_qamv1-prueflos.
*    read table it_qals into wa_qals with key prueflos = wa_qamv1-prueflos.
*    if sy-subrc eq 0.
*      select single * from mapl where matnr eq wa_qals-matnr and plnty eq 'Q'.
*      if sy-subrc eq 0.
*        select single * from plmk where plnnr eq mapl-plnnr and merknr eq wa_qamv1-merknr.
*        if sy-subrc eq 0.
*
*
*          if plmk-tolunni eq 'X'.
*
*            data1 = plmk-toleranzun.
*            data2 = data1.
*            if data2 ne 0.
*              write : '   NLT_LMT' right-justified.
*            endif.
*            data1 = plmk-toleranzob.
*            data2 = data1.
*            if data2 ne 0.
*              write : '   NMT_LMT' right-justified.
*            endif.
*
*          elseif plmk-plausiobni eq 'X'.
*
*            data1 = plmk-plausiunte.
*            data2 = data1.
*            if data2 ne 0.
*              write : '   NLT_LMT' right-justified.
*            endif.
*
*            data1 = plmk-plausioben.
*            data2 = data1.
*            if data2 ne 0.
*              write : '   NMT_LMT' right-justified.
*            endif.
*
*          else.
*
*            data1 = plmk-toleranzob.
*            data2 = data1.
*            if data2 ne 0.
*              write : '   NMT_LMT' right-justified.
*            endif.
*          endif.
*
**          data1 = plmk-toleranzob.
**          data2 = data1.
**          if data2 ne 0.
**            if plmk-tolunni ne 'X'.
**              write : '   NMT_LMT' right-justified.
**            else.
**              write : '   NLT_LMT' right-justified,'   NMT_LMT' right-justified.
**            endif.
**          else.
**            data1 = plmk-toleranzun.
**            data2 = data1.
**            if data2 ne 0.
**              if plmk-tolunni ne 'X'.
**                write : '   NMT_LMT' right-justified.
**              else.
**                write : '   NLT_LMT' right-justified,'   NMT_LMT' right-justified.
**              endif.
**            endif.
**          endif.
*        endif.
*      endif.
*    endif.
*
*
*  endif.
*
*
**  WA_QAMV-MERKNR.
*endloop.
*
* write : /1(2) 'No',4(10) 'Date',59(10) 'Rejected'.
*uline.

IF IT_TAB1 IS NOT INITIAL.
  SELECT * FROM QALS INTO TABLE IT_QALS11 FOR ALL ENTRIES IN IT_TAB1 WHERE PRUEFLOS EQ IT_TAB1-PRUEFLOS.
ENDIF.
IF IT_QALS11 IS NOT INITIAL.
  SELECT * FROM MSEG INTO TABLE IT_MSEG FOR ALL ENTRIES IN IT_QALS11 WHERE MBLNR EQ IT_QALS11-MBLNR AND MJAHR EQ IT_QALS11-MJAHR.
ENDIF.

LOOP AT IT_TAB1 INTO WA_TAB1.
*  write : /1(80) wa_tab1-charg LEFT-JUSTIFIED.
  A = 0.
  ON CHANGE OF WA_TAB1-LIFNR.
    A = 1.
  ENDON.
  ON CHANGE OF WA_TAB1-MFGR.
    A = 1.
  ENDON.

*  ON CHANGE OF WA_TAB1-LIFNR.
  IF A = 1.
    FORMAT COLOR 3.
    ULINE.
    WRITE : / 'Name of Material  :',MAKTX1.
    WRITE : / 'Material Code     :',WA_TAB1-MATNR.
    WRITE : /'Vendor code & Name:',WA_TAB1-LIFNR.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_TAB1-LIFNR.
    IF SY-SUBRC EQ 0.
      CLEAR : VENDORNM.
      CONCATENATE LFA1-NAME1 LFA1-ORT01 INTO VENDORNM SEPARATED BY ','.
      WRITE : VENDORNM.
    ENDIF.
**********************
    WRITE : /'Mfgr. code & Name:',WA_TAB1-MFGR.
    SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ WA_TAB1-MFGR.
    IF SY-SUBRC EQ 0.
      CLEAR : MFGRNAME.
      CONCATENATE LFA1-NAME1 LFA1-ORT01 INTO MFGRNAME SEPARATED BY ','.
      WRITE : MFGRNAME.
    ENDIF.
**********************
    WRITE : / 'Period from       :',S_BUDAT-LOW ,'To',S_BUDAT-HIGH.

    COUNT = 0.
    SKIP.
    ULINE.

    LOOP AT IT_QAMV1 INTO WA_QAMV1.
      FORMAT COLOR 1.
      WRITE : / WA_QAMV1-VERWMERKM,':',WA_QAMV1-KURZTEXT.
    ENDLOOP.
    FORMAT COLOR 3.
    ULINE.

*****************************************************************************************************
    WRITE : /1(2) 'Sr',4(10) 'Receipt',17(20) 'Quantity  UOM',32(25) 'Packing-No. of bags/',59(10) 'Accepted/',70(11) 'Insp. Lot', 83(17) 'Mfgr''s_Batch_No.:'.
*   WRITE : /1(2) 'No.',59(10) 'Rejected'.

*****************************
    LOOP AT IT_QAMV1 INTO WA_QAMV1.

      SELECT SINGLE * FROM QAMR WHERE PRUEFLOS EQ WA_QAMV1-PRUEFLOS AND MERKNR EQ WA_QAMV1-MERKNR.

      IF SY-SUBRC EQ 0.
        IF  QAMR-MAXWERTNI NE '*'.
          WA_QAMV1-KURZTEXT+0(10) = WA_QAMV1-VERWMERKM.
          WRITE : WA_QAMV1-KURZTEXT+0(10).

        ELSE.
          WA_QAMV1-KURZTEXT+0(10) = WA_QAMV1-VERWMERKM.
          WRITE : WA_QAMV1-KURZTEXT+0(10).
*          write : wa_qamv1-kurztext+0(10).
        ENDIF.
*    select single * from qals where prueflos eq wa_qamv1-prueflos.
        READ TABLE IT_QALS INTO WA_QALS WITH KEY PRUEFLOS = WA_QAMV1-PRUEFLOS.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM MAPL WHERE MATNR EQ WA_QALS-MATNR AND PLNTY EQ 'Q'.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM PLMK WHERE PLNNR EQ MAPL-PLNNR AND MERKNR EQ WA_QAMV1-MERKNR.
            IF SY-SUBRC EQ 0.


              IF PLMK-TOLUNNI EQ 'X'.

                DATA1 = PLMK-TOLERANZUN.
                DATA2 = DATA1.
                IF DATA2 NE 0.
                  WRITE : '   NLT_LMT' RIGHT-JUSTIFIED.
                ENDIF.
                DATA1 = PLMK-TOLERANZOB.
                DATA2 = DATA1.
                IF DATA2 NE 0.
                  WRITE : '   NMT_LMT' RIGHT-JUSTIFIED.
                ENDIF.

              ELSEIF PLMK-PLAUSIOBNI EQ 'X'.

                DATA1 = PLMK-PLAUSIUNTE.
                DATA2 = DATA1.
                IF DATA2 NE 0.
                  WRITE : '   NLT_LMT' RIGHT-JUSTIFIED.
                ENDIF.

                DATA1 = PLMK-PLAUSIOBEN.
                DATA2 = DATA1.
                IF DATA2 NE 0.
                  WRITE : '   NMT_LMT' RIGHT-JUSTIFIED.
                ENDIF.

              ELSE.

                DATA1 = PLMK-TOLERANZOB.
                DATA2 = DATA1.
                IF DATA2 NE 0.
                  WRITE : '   NMT_LMT' RIGHT-JUSTIFIED.
                ENDIF.
              ENDIF.

*          data1 = plmk-toleranzob.
*          data2 = data1.
*          if data2 ne 0.
*            if plmk-tolunni ne 'X'.
*              write : '   NMT_LMT' right-justified.
*            else.
*              write : '   NLT_LMT' right-justified,'   NMT_LMT' right-justified.
*            endif.
*          else.
*            data1 = plmk-toleranzun.
*            data2 = data1.
*            if data2 ne 0.
*              if plmk-tolunni ne 'X'.
*                write : '   NMT_LMT' right-justified.
*              else.
*                write : '   NLT_LMT' right-justified,'   NMT_LMT' right-justified.
*              endif.
*            endif.
*          endif.
            ENDIF.
          ENDIF.
        ENDIF.


      ENDIF.


*  WA_QAMV-MERKNR.
    ENDLOOP.

    WRITE : /1(2) 'No',4(10) 'Date',59(10) 'Rejected',32(25) 'Container'.
    ULINE.
    ULINE.
*  ENDON.
  ENDIF.
  FORMAT COLOR 4.
*WRITE : / 1(80)wa_tab1-charg.

  SELECT SINGLE * FROM QALS WHERE PRUEFLOS EQ WA_TAB1-PRUEFLOS.
  IF SY-SUBRC EQ 0.

*    loop at it_mseg into wa_mseg where mblnr eq qals-mblnr.
    COUNT = COUNT + 1.
    WRITE : /1(2) COUNT,4(10) QALS-BUDAT,17(10) QALS-LOSMENGE,28(3) QALS-MENGENEINH.
*      ,32(25) QALS-LICHN.
    SELECT SINGLE * FROM MSEG WHERE MBLNR EQ QALS-MBLNR AND MJAHR EQ QALS-MJAHR AND ZEILE EQ QALS-ZEILE AND CHARG EQ QALS-CHARG.
    IF SY-SUBRC EQ 0.
      WRITE : 32(35) MSEG-ABLAD.
    ENDIF.
    SELECT SINGLE * FROM QAVE WHERE PRUEFLOS EQ WA_TAB1-PRUEFLOS.
    IF SY-SUBRC EQ 0.
      IF QAVE-VCODE EQ 'A'.
        WRITE : 59(10) 'ACCEPTED'.
      ELSEIF QAVE-VCODE EQ 'R'.
        WRITE : 59(10) 'REJECTED'.
      ENDIF.
    ENDIF.
    WRITE : 70(12) WA_TAB1-PRUEFLOS,83(17) QALS-LICHN LEFT-JUSTIFIED.
*    endloop.
  ENDIF.
*  wa_tab1-prueflos.


  LOOP AT IT_QAMV INTO WA_QAMV WHERE PRUEFLOS EQ WA_TAB1-PRUEFLOS AND VERWMERKM IN CHARS.
    SELECT SINGLE * FROM QAMR WHERE PRUEFLOS EQ WA_TAB1-PRUEFLOS AND MERKNR EQ WA_QAMV-MERKNR.
    IF SY-SUBRC EQ 0.
*      data1 = qamr-mittelwert.
      IF QAMR-MAXWERTNI EQ '*'.
        DATA5 = QAMR-MINWERT.
        DATA51 = QAMR-MAXWERT.
*        write : 'a',data5+13(3).


        IF DATA5+13(3) EQ '+01'.
          DATA1 = QAMR-MINWERT.
          DATA2 = DATA1.
          DATA6 = DATA2.
          DATA7 = DATA6 * 10.
          DATA8 = DATA7.
          WRITE : DATA8 RIGHT-JUSTIFIED.
*           WRITE : qamr-maxwert.

**************************minimum val of limit*******************

          IF DATA51+13(3) EQ '+01'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 * 10.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSEIF DATA51+13(3) EQ '+02'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 * 100.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSEIF DATA51+13(3) EQ '+03'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 * 1000.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSEIF DATA51+13(3) EQ '-01'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 / 10.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSEIF DATA51+13(3) EQ '-02'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 / 100.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSE.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 .
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ENDIF.
******************************mimimumval of limit***************

          READ TABLE IT_QALS INTO WA_QALS WITH KEY PRUEFLOS = WA_QAMV-PRUEFLOS.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM MAPL WHERE MATNR EQ WA_QALS-MATNR AND PLNTY EQ 'Q'.
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM PLMK WHERE PLNNR EQ MAPL-PLNNR AND MERKNR EQ WA_QAMV-MERKNR.
              IF SY-SUBRC EQ 0.


                IF PLMK-TOLUNNI EQ 'X'.
                  DATA1 = PLMK-TOLERANZUN.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZUN.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                  DATA1 = PLMK-TOLERANZOB.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZOB.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ELSEIF PLMK-PLAUSIOBNI EQ 'X'.
                  DATA1 = PLMK-PLAUSIUNTE.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-PLAUSIUNTE.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                  DATA1 = PLMK-PLAUSIOBEN.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-PLAUSIOBEN.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ELSE.

*                if plmk-tolunni ne 'X'.
                  DATA1 = PLMK-TOLERANZOB.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZOB.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ENDIF.


              ENDIF.
            ENDIF.
          ENDIF.


****************************************limit*******************


        ELSEIF DATA5+13(3) EQ '+02'.
          DATA1 = QAMR-MINWERT.
          DATA2 = DATA1.
          DATA6 = DATA2.
          DATA7 = DATA6 * 100.
          DATA8 = DATA7.
          WRITE : DATA8 RIGHT-JUSTIFIED.

          IF DATA51+13(3) EQ '+01'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 * 10.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSEIF DATA51+13(3) EQ '+02'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 * 100.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSEIF DATA51+13(3) EQ '-01'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 / 10.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSEIF DATA51+13(3) EQ '-02'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 / 100.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSE.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 .
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ENDIF.

          READ TABLE IT_QALS INTO WA_QALS WITH KEY PRUEFLOS = WA_QAMV-PRUEFLOS.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM MAPL WHERE MATNR EQ WA_QALS-MATNR AND PLNTY EQ 'Q'.
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM PLMK WHERE PLNNR EQ MAPL-PLNNR AND MERKNR EQ WA_QAMV-MERKNR.
              IF SY-SUBRC EQ 0.


                IF PLMK-TOLUNNI EQ 'X'.
                  DATA1 = PLMK-TOLERANZUN.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZUN.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                  DATA1 = PLMK-TOLERANZOB.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZOB.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ELSEIF PLMK-PLAUSIOBNI EQ 'X'.
                  DATA1 = PLMK-PLAUSIUNTE.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-PLAUSIUNTE.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                  DATA1 = PLMK-PLAUSIOBEN.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-PLAUSIOBEN.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ELSE.

*                if plmk-tolunni ne 'X'.
                  DATA1 = PLMK-TOLERANZOB.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZOB.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ENDIF.


              ENDIF.
            ENDIF.
          ENDIF.


****************************************limit*******************



        ELSEIF DATA5+13(3) EQ '-01'.
          DATA1 = QAMR-MINWERT.
          DATA2 = DATA1.
          DATA6 = DATA2.
          DATA7 = DATA6 / 10.
          DATA8 = DATA7.
          WRITE : DATA8 RIGHT-JUSTIFIED.
          IF DATA51+13(3) EQ '+01'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 * 10.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSEIF DATA51+13(3) EQ '+02'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 * 100.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSEIF DATA51+13(3) EQ '-01'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 / 10.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSEIF DATA51+13(3) EQ '-02'.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 / 100.
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ELSE.
            DATA1 = QAMR-MAXWERT.
            DATA2 = DATA1.
            DATA6 = DATA2.
            DATA7 = DATA6 .
            DATA8 = DATA7.
            WRITE : DATA8 RIGHT-JUSTIFIED.
          ENDIF.

          READ TABLE IT_QALS INTO WA_QALS WITH KEY PRUEFLOS = WA_QAMV-PRUEFLOS.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM MAPL WHERE MATNR EQ WA_QALS-MATNR AND PLNTY EQ 'Q'.
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM PLMK WHERE PLNNR EQ MAPL-PLNNR AND MERKNR EQ WA_QAMV-MERKNR.
              IF SY-SUBRC EQ 0.


                IF PLMK-TOLUNNI EQ 'X'.
                  DATA1 = PLMK-TOLERANZUN.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZUN.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                  DATA1 = PLMK-TOLERANZOB.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZOB.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ELSEIF PLMK-PLAUSIOBNI EQ 'X'.
                  DATA1 = PLMK-PLAUSIUNTE.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-PLAUSIUNTE.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                  DATA1 = PLMK-PLAUSIOBEN.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-PLAUSIOBEN.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ELSE.

*                if plmk-tolunni ne 'X'.
                  DATA1 = PLMK-TOLERANZOB.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZOB.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ENDIF.


              ENDIF.
            ENDIF.
          ENDIF.


****************************************limit*******************



        ELSE.
          DATA1 = QAMR-MINWERT.
          DATA2 = DATA1.
          WRITE : DATA2 RIGHT-JUSTIFIED.
*           WRITE : qamr-maxwert.
          DATA3 = QAMR-MAXWERT.
          DATA4 = DATA3.
          WRITE : DATA4 RIGHT-JUSTIFIED.
*           WRITE : qamr-minwert.

          READ TABLE IT_QALS INTO WA_QALS WITH KEY PRUEFLOS = WA_QAMV-PRUEFLOS.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM MAPL WHERE MATNR EQ WA_QALS-MATNR AND PLNTY EQ 'Q'.
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM PLMK WHERE PLNNR EQ MAPL-PLNNR AND MERKNR EQ WA_QAMV-MERKNR.
              IF SY-SUBRC EQ 0.


                IF PLMK-TOLUNNI EQ 'X'.
                  DATA1 = PLMK-TOLERANZUN.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZUN.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                  DATA1 = PLMK-TOLERANZOB.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZOB.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ELSEIF PLMK-PLAUSIOBNI EQ 'X'.
                  DATA1 = PLMK-PLAUSIUNTE.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-PLAUSIUNTE.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                  DATA1 = PLMK-PLAUSIOBEN.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-PLAUSIOBEN.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ELSE.

*                if plmk-tolunni ne 'X'.
                  DATA1 = PLMK-TOLERANZOB.
                  DATA2 = DATA1.
                  IF DATA2 NE 0.
                    DATA5 = PLMK-TOLERANZOB.
                    IF DATA5+13(3) EQ '+01'.
                      DATA9 = DATA2 * 10.
                    ELSEIF DATA5+13(3) EQ '+02'.
                      DATA9 = DATA2 * 100.
                    ELSEIF DATA5+13(3) EQ '+03'.
                      DATA9 = DATA2 * 1000.
                    ELSEIF DATA5+13(3) EQ '-01'.
                      DATA9 = DATA2 / 10.
                    ELSE.
                      DATA9 = DATA2.
                    ENDIF.
                    DATA8 = DATA9.
                    WRITE : DATA8 RIGHT-JUSTIFIED.
                  ENDIF.

                ENDIF.


              ENDIF.
            ENDIF.
          ENDIF.


****************************************limit*******************



        ENDIF.
      ELSE.
        DATA1 = QAMR-ORIGINAL_INPUT.
        DATA2 = DATA1.
        WRITE : DATA2 RIGHT-JUSTIFIED.

        READ TABLE IT_QALS INTO WA_QALS WITH KEY PRUEFLOS = WA_QAMV-PRUEFLOS.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM MAPL WHERE MATNR EQ WA_QALS-MATNR AND PLNTY EQ 'Q'.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM PLMK WHERE PLNNR EQ MAPL-PLNNR AND MERKNR EQ WA_QAMV-MERKNR.
            IF SY-SUBRC EQ 0.


              IF PLMK-TOLUNNI EQ 'X'.
                DATA1 = PLMK-TOLERANZUN.
                DATA2 = DATA1.
                IF DATA2 NE 0.
                  DATA5 = PLMK-TOLERANZUN.
                  IF DATA5+13(3) EQ '+01'.
                    DATA9 = DATA2 * 10.
                  ELSEIF DATA5+13(3) EQ '+02'.
                    DATA9 = DATA2 * 100.
                  ELSEIF DATA5+13(3) EQ '+03'.
                    DATA9 = DATA2 * 1000.
                  ELSEIF DATA5+13(3) EQ '-01'.
                    DATA9 = DATA2 / 10.
                  ELSE.
                    DATA9 = DATA2.
                  ENDIF.
                  DATA8 = DATA9.
                  WRITE : DATA8 RIGHT-JUSTIFIED.
                ENDIF.

                DATA1 = PLMK-TOLERANZOB.
                DATA2 = DATA1.
                IF DATA2 NE 0.
                  DATA5 = PLMK-TOLERANZOB.
                  IF DATA5+13(3) EQ '+01'.
                    DATA9 = DATA2 * 10.
                  ELSEIF DATA5+13(3) EQ '+02'.
                    DATA9 = DATA2 * 100.
                  ELSEIF DATA5+13(3) EQ '+03'.
                    DATA9 = DATA2 * 1000.
                  ELSEIF DATA5+13(3) EQ '-01'.
                    DATA9 = DATA2 / 10.
                  ELSE.
                    DATA9 = DATA2.
                  ENDIF.
                  DATA8 = DATA9.
                  WRITE : DATA8 RIGHT-JUSTIFIED.
                ENDIF.

              ELSEIF PLMK-PLAUSIOBNI EQ 'X'.
                DATA1 = PLMK-PLAUSIUNTE.
                DATA2 = DATA1.
                IF DATA2 NE 0.
                  DATA5 = PLMK-PLAUSIUNTE.
                  IF DATA5+13(3) EQ '+01'.
                    DATA9 = DATA2 * 10.
                  ELSEIF DATA5+13(3) EQ '+02'.
                    DATA9 = DATA2 * 100.
                  ELSEIF DATA5+13(3) EQ '+03'.
                    DATA9 = DATA2 * 1000.
                  ELSEIF DATA5+13(3) EQ '-01'.
                    DATA9 = DATA2 / 10.
                  ELSE.
                    DATA9 = DATA2.
                  ENDIF.
                  DATA8 = DATA9.
                  WRITE : DATA8 RIGHT-JUSTIFIED.
                ENDIF.

                DATA1 = PLMK-PLAUSIOBEN.
                DATA2 = DATA1.
                IF DATA2 NE 0.
                  DATA5 = PLMK-PLAUSIOBEN.
                  IF DATA5+13(3) EQ '+01'.
                    DATA9 = DATA2 * 10.
                  ELSEIF DATA5+13(3) EQ '+02'.
                    DATA9 = DATA2 * 100.
                  ELSEIF DATA5+13(3) EQ '+03'.
                    DATA9 = DATA2 * 1000.
                  ELSEIF DATA5+13(3) EQ '-01'.
                    DATA9 = DATA2 / 10.
                  ELSE.
                    DATA9 = DATA2.
                  ENDIF.
                  DATA8 = DATA9.
                  WRITE : DATA8 RIGHT-JUSTIFIED.
                ENDIF.

              ELSE.

*                if plmk-tolunni ne 'X'.
                DATA1 = PLMK-TOLERANZOB.
                DATA2 = DATA1.
                IF DATA2 NE 0.
                  DATA5 = PLMK-TOLERANZOB.
                  IF DATA5+13(3) EQ '+01'.
                    DATA9 = DATA2 * 10.
                  ELSEIF DATA5+13(3) EQ '+02'.
                    DATA9 = DATA2 * 100.
                  ELSEIF DATA5+13(3) EQ '+03'.
                    DATA9 = DATA2 * 1000.
                  ELSEIF DATA5+13(3) EQ '-01'.
                    DATA9 = DATA2 / 10.
                  ELSE.
                    DATA9 = DATA2.
                  ENDIF.
                  DATA8 = DATA9.
                  WRITE : DATA8 RIGHT-JUSTIFIED.
                ENDIF.

              ENDIF.


            ENDIF.
          ENDIF.
        ENDIF.


****************************************limit*******************



      ENDIF.
*        write : qamr-maxwertni.
    ENDIF.
  ENDLOOP.
  AT END OF LIFNR.
    FORMAT COLOR 1.
    SKIP.
    SKIP.
    WRITE : / 'Remark:',REMARK.
    WRITE : / 'Conclusion',CONC.
*    write: / 'Remark: The Vendor data is reviewed & found to be consistent'.
*    write: / 'Conclusion: Vendor can be continued'.
    SKIP.
    SKIP.
    WRITE : 'Prepared By:',50 'Checked By:',100 'Approved BY:'.
    SKIP.
    SKIP.
*    write : / 'Officer/Executive-Q.A.',50 'Manager-Q.A.',100 'Manager QC/DGM-Q.A.'.
    SKIP.
    ULINE.
    ULINE.


  ENDAT.
ENDLOOP.
*&---------------------------------------------------------------------*
*&      Form  UPDLIFNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDLIFNR .

  IF IT_TAB1 IS NOT INITIAL.
    SELECT * FROM QALS INTO TABLE IT_QALS_1 FOR ALL ENTRIES IN IT_TAB1 WHERE ART EQ '01' AND CHARG EQ IT_TAB1-CHARG AND LIFNR NE SPACE.
  ENDIF.

  LOOP AT IT_QALS_1 INTO WA_QALS_1.
    SELECT SINGLE * FROM JEST WHERE OBJNR EQ WA_QALS_1-OBJNR AND STAT EQ 'I0224'.
    IF SY-SUBRC EQ 0.
      DELETE IT_QALS_1 WHERE PRUEFLOS EQ WA_QALS_1-PRUEFLOS.
    ENDIF.
  ENDLOOP.
  LOOP AT IT_TAB1 INTO WA_TAB1 WHERE LIFNR EQ SPACE.
    READ TABLE IT_QALS_1 INTO WA_QALS_1 WITH KEY CHARG = WA_TAB1-CHARG.
    IF SY-SUBRC EQ 0.
      WA_TAB1-LIFNR = WA_QALS_1-LIFNR.
      MODIFY IT_TAB1 FROM WA_TAB1 TRANSPORTING LIFNR.
      CLEAR WA_TAB1.
    ENDIF.
  ENDLOOP.

*  LOOP AT IT_QALS INTO WA_QALS.
*    READ TABLE IT_QAVE INTO WA_QAVE WITH KEY PRUEFLOS = WA_QALS-PRUEFLOS.
*    IF SY-SUBRC EQ 0.
**    WRITE : / WA_QALS-MATNR,WA_QALS-CHARG,wa_qals-prueflos.
*      WA_TAB1-MATNR = WA_QALS-MATNR.
*      WA_TAB1-CHARG = WA_QALS-CHARG.
*      WA_TAB1-PRUEFLOS = WA_QALS-PRUEFLOS.
*      WA_TAB1-LIFNR = WA_QALS-LIFNR.
*      COLLECT WA_TAB1 INTO IT_TAB1.
*      CLEAR WA_TAB1.
*    ENDIF.
*
*  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  MFGR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM MFGR.

  LOOP AT IT_TAB1 INTO WA_TAB1.
    SELECT SINGLE * FROM QALS WHERE PRUEFLOS EQ WA_TAB1-PRUEFLOS.
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM ZMIGO WHERE MBLNR EQ QALS-MBLNR AND MJAHR EQ QALS-MJAHR AND ZEILE EQ QALS-ZEILE.
      IF SY-SUBRC EQ 0.
        WA_TAB1-MFGR = ZMIGO-MFGR.
        MODIFY IT_TAB1 FROM WA_TAB1 TRANSPORTING MFGR.
        CLEAR WA_TAB1.
      ENDIF.
    ENDIF.
  ENDLOOP.

ENDFORM.
