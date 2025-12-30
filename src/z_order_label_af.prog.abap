REPORT Z_ORDER_LABEL_A1 MESSAGE-ID ZLAL.
*-------------------------------------------------------------------*
*  This Report is to print the label for materials issued against.
*  the production order which is issued afterwards. This Report
*  Calls the layout set Z_ORDER_LABEL_AF.This Program Is Demanded by.
*  Mr. Dhigolkar and Written by Pramod Kumar.Started On 05.09.2001
*  Changed by Anjali on 19.3.01 requested by Prod (SNJ) for incl.
*  Indl. sector with the Name of the Material
*  Changed by Anjali on 9.10.02 requested by stores (DM)for
*  introducting the Retesting QC lot
*-------------------------------------------------------------------*

*--table declerations-----------------------------------------------*

TABLES:
  MKPF,
  MSEG,
  MAKT,
  QALS,
  AFPO,
  AUFM,
  MARA,
  MAST,
  ZPO_MATNR,
  EKBE,
  EKKO,
  EKPO,
  EKPA.


*data declerations--------------------------------------------*

DATA : BEGIN OF T_HEADER OCCURS 0,
         AUFNR      LIKE AFPO-AUFNR,   "order no
         CHARGM     LIKE AFPO-CHARG,   "batch no material
         MAKTXM     LIKE MAKT-MAKTX,   "Material Desc
*         MAKTX    LIKE MAKT-MAKTX,   "Component Desc
         MAKTX(81)  TYPE C,   "Component LONG Desc
         PRUEFLOS   LIKE QALS-PRUEFLOS, "Inspection lot
         ERFMG      LIKE AUFM-ERFMG,      "weight
         ERFME      LIKE AUFM-ERFME,      "unit
         BUDAT      LIKE MKPF-BUDAT,      "iss date
         NORMT      LIKE MARA-NORMT,    " Indl. sector
         MATNR      LIKE AUFM-MATNR,    "material code
         CHARG      TYPE AUFM-CHARG,
         MAKTX2(40) TYPE C,
       END OF T_HEADER.
DATA : COUNT TYPE I .
DATA : PG_COUNT TYPE I .
DATA : W_NAME(61) TYPE C.
COUNT = 0 .
DATA: RETTXT(60)  TYPE C,
      FORMAT1(80) TYPE C.
DATA: MAKTX1(40) TYPE C,
      MAKTX2(40) TYPE C,
      MAKTX(81)  TYPE C.
DATA: TEXT1(11)  TYPE C,
      RPTXT1(50) TYPE C,
      MTART      TYPE MARA-MTART.
DATA: RET(1) TYPE C.
DATA: COMPNM(35) TYPE C.
DATA: PRUEFLOS TYPE QALS-PRUEFLOS.
*selection screen--------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK INPUT WITH FRAME TITLE TEXT-001.
*--Material Document No Is Input For User
  PARAMETERS : P_MBLNR LIKE AUFM-MBLNR OBLIGATORY,
               YEAR(4) TYPE C OBLIGATORY.
  PARAMETERS : R1 RADIOBUTTON GROUP R1,
               R2 RADIOBUTTON GROUP R1.
SELECTION-SCREEN END OF BLOCK INPUT.

* start of selection------------------------------------------*
START-OF-SELECTION.
  COMPNM = 'BLUE CROSS LABORATORIES PVT LTD.'.
  CLEAR T_HEADER.
  REFRESH T_HEADER.
  PERFORM T_HEADER.
  CLEAR : TEXT1.
  CLEAR : RET.
  SELECT SINGLE * FROM MSEG WHERE MBLNR EQ P_MBLNR AND MJAHR EQ YEAR AND BWART EQ '262'.
  IF SY-SUBRC EQ 0.
    TEXT1 = 'Returned On'.
    RET = 'Y'.
  ELSE.
    TEXT1 = 'Issued On'.
  ENDIF.

*-----This Is To Open The The Layout Set-----------------------*
  IF R1 EQ 'X'.
    SELECT SINGLE * FROM MSEG WHERE MBLNR EQ P_MBLNR AND MJAHR EQ YEAR AND BWART EQ '262'.
    IF SY-SUBRC EQ 4.
      MESSAGE 'NOT MRN DOCUMENT' TYPE 'I'.
    ENDIF.
    CALL FUNCTION 'OPEN_FORM'
      EXPORTING
*       APPLICATION                 = 'TX'
*       ARCHIVE_INDEX               =
*       ARCHIVE_PARAMS              =
        DEVICE                      = 'PRINTER'
*       DIALOG                      = 'X'
*       form                        = 'Z_ORDER_LABEL_A2'
*       form                        = 'Z_ORDER_LABEL_A3'
*       FORM                        = 'Z_ORDER_LABEL_A6'
*       form                        = 'Z_ORDER_LABEL_A7'
*       FORM                        = 'Z_ORDER_LABEL_1'
        FORM                        = 'Z_ORDER_LABEL_1A'
        LANGUAGE                    = SY-LANGU
*       OPTIONS                     =
*       MAIL_SENDER                 =
*       MAIL_RECIPIENT              =
*       MAIL_APPL_OBJECT            =
*       RAW_DATA_INTERFACE          = '*'
*    IMPORTING
*       LANGUAGE                    =
*       NEW_ARCHIVE_PARAMS          =
*       RESULT                      =
      EXCEPTIONS
        CANCELED                    = 1
        DEVICE                      = 2
        FORM                        = 3
        OPTIONS                     = 4
        UNCLOSED                    = 5
        MAIL_OPTIONS                = 6
        ARCHIVE_ERROR               = 7
        INVALID_FAX_NUMBER          = 8
        MORE_PARAMS_NEEDED_IN_BATCH = 9
        OTHERS                      = 10.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
  ELSEIF R2 EQ 'X'.
    SELECT SINGLE * FROM MSEG WHERE MBLNR EQ P_MBLNR AND MJAHR EQ YEAR AND BWART EQ '262'.
    IF SY-SUBRC EQ 4.
      MESSAGE 'NOT MRN DOCUMENT' TYPE 'I'.
    ENDIF.

    CALL FUNCTION 'OPEN_FORM'
      EXPORTING
*       APPLICATION                 = 'TX'
*       ARCHIVE_INDEX               =
*       ARCHIVE_PARAMS              =
        DEVICE                      = 'PRINTER'
*       DIALOG                      = 'X'
*       form                        = 'Z_ORDER_LABEL_A2'
*       FORM                        = 'Z_ORDER_LABEL_A4'
*       form                        = 'Z_ORDER_LABEL_A5'
*       FORM                        = 'Z_ORDER_LABEL_2'
        FORM                        = 'Z_ORDER_LABEL_2B'
        LANGUAGE                    = SY-LANGU
*       OPTIONS                     =
*       MAIL_SENDER                 =
*       MAIL_RECIPIENT              =
*       MAIL_APPL_OBJECT            =
*       RAW_DATA_INTERFACE          = '*'
*    IMPORTING
*       LANGUAGE                    =
*       NEW_ARCHIVE_PARAMS          =
*       RESULT                      =
      EXCEPTIONS
        CANCELED                    = 1
        DEVICE                      = 2
        FORM                        = 3
        OPTIONS                     = 4
        UNCLOSED                    = 5
        MAIL_OPTIONS                = 6
        ARCHIVE_ERROR               = 7
        INVALID_FAX_NUMBER          = 8
        MORE_PARAMS_NEEDED_IN_BATCH = 9
        OTHERS                      = 10.
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
*--To write the requried data on the label------------*
  CLEAR : FORMAT1,MTART.
  LOOP AT T_HEADER.
    IF T_HEADER-NORMT NE SPACE.
      CONCATENATE T_HEADER-MAKTX T_HEADER-NORMT INTO W_NAME SEPARATED BY
      ' - '.
    ELSE.
      W_NAME = T_HEADER-MAKTX.
    ENDIF.
    CLEAR : RPTXT1.
    SELECT SINGLE * FROM MARA WHERE MATNR EQ T_HEADER-MATNR AND MTART EQ 'ZVRP'.
    IF SY-SUBRC EQ 0.
      MTART = MARA-MTART.
      RETTXT = 'RETURNED PACKAGING MATERIAL'.
      IF RET EQ 'Y'.
        RPTXT1 = 'Packing/IPQA/Store'.  "9.11.23 changes as per AKG
      ELSE.
        RPTXT1 = 'Packing/ Store'. "changed on 31.8.23 as per BMD& VD
      ENDIF.
      SELECT SINGLE * FROM QALS WHERE PRUEFLOS EQ T_HEADER-PRUEFLOS AND WERK EQ '1000'.
      IF SY-SUBRC EQ 0.
        FORMAT1 = 'Format No. SOP/QAD/060-F5'.
      ENDIF.
      SELECT SINGLE * FROM QALS WHERE PRUEFLOS EQ T_HEADER-PRUEFLOS AND WERK EQ '1001'.
      IF SY-SUBRC EQ 0.
        FORMAT1 = 'PK/GM/020-F2'.
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM MARA WHERE MATNR EQ T_HEADER-MATNR AND MTART EQ 'ZROH'.
      IF SY-SUBRC EQ 0.
        MTART = MARA-MTART.
        RETTXT = 'RETURNED RAW MATERIAL'.
        IF RET EQ 'Y'.
          RPTXT1 = 'Production/IPQA/Store'.  "added as per AKG on 9.11.23
        ELSE.
          RPTXT1 = 'Production/ Store'.  "31.8.23 as per email from BMD & VD
        ENDIF.
        SELECT SINGLE * FROM QALS WHERE PRUEFLOS EQ T_HEADER-PRUEFLOS AND WERK EQ '1000'.
        IF SY-SUBRC EQ 0.
          FORMAT1 = 'Format No. SOP/QAD/060-F3'.
        ENDIF.
      ELSE.
        RETTXT = 'MATERIAL RETURNED'.
      ENDIF.
    ENDIF.
    SELECT SINGLE * FROM MSEG WHERE MBLNR EQ P_MBLNR AND MJAHR EQ YEAR AND BWART EQ '262'.
    IF SY-SUBRC EQ 4.
      SELECT SINGLE * FROM MARA WHERE MATNR EQ T_HEADER-MATNR AND MTART EQ 'ZROH'.
      IF SY-SUBRC EQ 0.
        RETTXT = 'DISPENSED RAW MATERIAL'.
        SELECT SINGLE * FROM QALS WHERE PRUEFLOS EQ T_HEADER-PRUEFLOS AND WERK EQ '1000'.
        IF SY-SUBRC EQ 0.
          FORMAT1 = 'Format No. SOP/QAD/060-F2'.
        ENDIF.
      ELSE.
        RETTXT = 'DISPENSED PACKING MATERIAL'.
        SELECT SINGLE * FROM QALS WHERE PRUEFLOS EQ T_HEADER-PRUEFLOS AND WERK EQ '1000'.
        IF SY-SUBRC EQ 0.
          FORMAT1 = 'Format No. SOP/QAD/060-F4'.
        ENDIF.
        SELECT SINGLE * FROM QALS WHERE PRUEFLOS EQ T_HEADER-PRUEFLOS AND WERK EQ '1001'.
        IF SY-SUBRC EQ 0.
          FORMAT1 = 'PK/GM/020-F2'.
        ENDIF.
      ENDIF.
    ENDIF.

*    CLEAR : FORMAT1.
*    SELECT SINGLE * FROM QALS WHERE PRUEFLOS EQ T_HEADER-PRUEFLOS AND WERK EQ '1000'.
*    IF SY-SUBRC EQ 0.
*      FORMAT1 = 'Format No. SOP/QAD/060-F5'.
*    ENDIF.

    IF T_HEADER-MAKTX2 EQ SPACE.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          ELEMENT                  = 'LABEL'
*         FUNCTION                 = 'SET'
*         TYPE                     = 'BODY'
          WINDOW                   = 'MAIN'
*    IMPORTING
*         PENDING_LINES            =
        EXCEPTIONS
          ELEMENT                  = 1
          FUNCTION                 = 2
          TYPE                     = 3
          UNOPENED                 = 4
          UNSTARTED                = 5
          WINDOW                   = 6
          BAD_PAGEFORMAT_FOR_PRINT = 7
          OTHERS                   = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ELSE.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          ELEMENT                  = 'LABEL1'
*         FUNCTION                 = 'SET'
*         TYPE                     = 'BODY'
          WINDOW                   = 'MAIN'
*    IMPORTING
*         PENDING_LINES            =
        EXCEPTIONS
          ELEMENT                  = 1
          FUNCTION                 = 2
          TYPE                     = 3
          UNOPENED                 = 4
          UNSTARTED                = 5
          WINDOW                   = 6
          BAD_PAGEFORMAT_FOR_PRINT = 7
          OTHERS                   = 8.
      IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ENDIF.
  ENDLOOP.

*--This is Close the Layout Set----------------------------*

  CALL FUNCTION 'CLOSE_FORM'
*    IMPORTING
*         RESULT                   =
*         RDI_RESULT               =
*    TABLES
*         OTFDATA                  =
    EXCEPTIONS
      UNOPENED                 = 1
      BAD_PAGEFORMAT_FOR_PRINT = 2
      SEND_ERROR               = 3
      OTHERS                   = 4.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  T_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM T_HEADER.
*--Data is selected for the requried Document no
*  For the Component issued to the production order hjaving movement
*  type 261

  SELECT SINGLE * FROM AUFM WHERE MBLNR = P_MBLNR AND MJAHR EQ YEAR.
  IF SY-SUBRC EQ 0.

    SELECT * FROM AUFM WHERE MBLNR = P_MBLNR AND MJAHR EQ YEAR.

      IF AUFM-ERFME EQ 'KGW'.           "ADDED BY VINAYAK S.
        T_HEADER-ERFMG = AUFM-MENGE.
        T_HEADER-ERFME = AUFM-MEINS.
      ELSE.
        T_HEADER-ERFMG = AUFM-ERFMG.
        T_HEADER-ERFME = AUFM-ERFME.
      ENDIF.

*  select the material document date from mkpf where document no is
*  equal to aufm document no
      SELECT SINGLE * FROM MKPF WHERE MBLNR = AUFM-MBLNR.
      T_HEADER-BUDAT = MKPF-BUDAT.
*    t_header-budat = mkpf-bldat.
*  select the material descripton used in this order
*      SELECT SINGLE * FROM MAKT WHERE MATNR = AUFM-MATNR.
*      T_HEADER-MAKTX = MAKT-MAKTX.
      CLEAR : MAKTX1,MAKTX2,MAKTX.  "10.12.20
      SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ AUFM-MATNR.
      IF SY-SUBRC EQ 0.
        MAKTX1 = MAKT-MAKTX.
      ENDIF.
      SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'Z1' AND MATNR EQ AUFM-MATNR.
      IF SY-SUBRC EQ 0.
        MAKTX2 = MAKT-MAKTX.
      ENDIF.
      CONCATENATE MAKTX1 MAKTX2 INTO MAKTX SEPARATED BY SPACE.
      T_HEADER-MAKTX = MAKTX.
      T_HEADER-MAKTX2 = MAKTX2.

      T_HEADER-MATNR = AUFM-MATNR.
      T_HEADER-CHARG = AUFM-CHARG.
*   select the Inspection lot no from the qals for the component used
*   if component has no inspection lot no then write the batch no of
*   the vomponent
      CLEAR PRUEFLOS.

      SELECT SINGLE * FROM QALS WHERE MATNR = AUFM-MATNR AND CHARG = AUFM-CHARG AND ART = '09' AND WERK = AUFM-WERKS.
      IF SY-SUBRC = 0.
        PRUEFLOS = QALS-PRUEFLOS.
      ELSE.
        SELECT SINGLE * FROM QALS WHERE MATNR = AUFM-MATNR AND CHARG = AUFM-CHARG AND WERK = AUFM-WERKS.
        IF SY-SUBRC = 0.
          PRUEFLOS = QALS-PRUEFLOS.
        ELSE.
          SELECT SINGLE PRUEFLOS , MATNR , CHARG FROM ZINSP INTO @DATA(WA_INSP) "Added on 04.12.2025"
             WHERE MATNR = @AUFM-MATNR AND CHARG = @AUFM-CHARG.
          IF SY-SUBRC = 0.
            PRUEFLOS = WA_INSP-PRUEFLOS.
*          t_header-prueflos = aufm-charg.  "10.12.20
          ENDIF.
        ENDIF.
      ENDIF.
      T_HEADER-PRUEFLOS = PRUEFLOS.

      SELECT SINGLE * FROM AFPO WHERE AUFNR = AUFM-AUFNR.
      T_HEADER-AUFNR = AFPO-AUFNR.
      T_HEADER-CHARGM = AFPO-CHARG.
*   Select the material description from makt for the main material
      SELECT SINGLE * FROM MAST WHERE MATNR = AFPO-MATNR
                                AND STLAN = '1'.
      SELECT SINGLE * FROM MAKT WHERE MATNR = MAST-MATNR.
      T_HEADER-MAKTXM = MAKT-MAKTX.
      SELECT SINGLE * FROM MARA WHERE MATNR = MAST-MATNR.
      T_HEADER-NORMT = MARA-NORMT.

*******************  ADDED FOR PO TEXT ON 4.1.21*********************
*      select single * from zpo_matnr where matnr eq aufm-matnr.
*      if sy-subrc eq 0.
*        select single * from ekbe where matnr eq aufm-matnr and charg eq aufm-charg and werks eq aufm-werks.
*        if sy-subrc eq 0.
*          select single * from ekko where ebeln eq ekbe-ebeln.
*          if sy-subrc eq 0.
*            if ekko-aedat ge zpo_matnr-effectdt.
*              select single * from ekpo where ebeln eq ekbe-ebeln and ebelp eq ekbe-ebelp.
*              if sy-subrc eq 0.
*                t_header-maktx = ekpo-txz01.
*                t_header-normt = space.
*                t_header-maktx2 = space.
*              endif.
*            endif.
*          endif.
*        endif.
*      endif.
      SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ AUFM-MATNR.  "18.11.22
      IF SY-SUBRC EQ 0.
        SELECT SINGLE * FROM EKBE WHERE MATNR EQ AUFM-MATNR AND CHARG EQ AUFM-CHARG AND WERKS EQ AUFM-WERKS.
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM EKKO WHERE EBELN EQ EKBE-EBELN.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM EKPA WHERE EBELN EQ EKBE-EBELN AND PARVW EQ 'HR'.
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ AUFM-MATNR AND LIFNR EQ EKPA-LIFN2.  "18.11.22
              IF SY-SUBRC EQ 0.
                IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*              SELECT SINGLE * FROM EKPO WHERE EBELN EQ EKBE-EBELN AND EBELP EQ EKBE-EBELP.
*              IF SY-SUBRC EQ 0.
                  T_HEADER-MAKTX = ZPO_MATNR-MAKTX.
                  T_HEADER-NORMT = SPACE.
                  T_HEADER-MAKTX2 = SPACE.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.


      APPEND T_HEADER.
    ENDSELECT.

  ELSE.
*********201 mov**********
    SELECT * FROM MSEG WHERE MBLNR = P_MBLNR AND MJAHR EQ YEAR.

      T_HEADER-ERFMG = MSEG-ERFMG.
      T_HEADER-ERFME = MSEG-ERFME.
*  select the material document date from mkpf where document no is
*  equal to mseg document no
      SELECT SINGLE * FROM MKPF WHERE MBLNR = MSEG-MBLNR.
      T_HEADER-BUDAT = MKPF-BUDAT.
*    t_header-budat = mkpf-bldat.
*  select the material descripton used in this order
***      SELECT SINGLE * FROM MAKT WHERE MATNR = MSEG-MATNR.
***      T_HEADER-MAKTX = MAKT-MAKTX.

      CLEAR : MAKTX1,MAKTX2,MAKTX.  "10.12.20
      SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'EN' AND MATNR EQ MSEG-MATNR.
      IF SY-SUBRC EQ 0.
        MAKTX1 = MAKT-MAKTX.
      ENDIF.
      SELECT SINGLE * FROM MAKT WHERE SPRAS EQ 'Z1' AND MATNR EQ MSEG-MATNR.
      IF SY-SUBRC EQ 0.
        MAKTX2 = MAKT-MAKTX.
      ENDIF.
      CONCATENATE MAKTX1 MAKTX2 INTO MAKTX SEPARATED BY SPACE.
      T_HEADER-MAKTX = MAKTX.
      T_HEADER-MAKTX2 = MAKTX2.


      T_HEADER-MATNR = MSEG-MATNR.
*   select the Inspection lot no from the qals for the component used
*   if component has no inspection lot no then write the batch no of
*   the vomponent
      CLEAR : PRUEFLOS.
      SELECT SINGLE * FROM QALS WHERE MATNR = MSEG-MATNR AND CHARG = MSEG-CHARG AND ART = '09' AND WERK EQ MSEG-WERKS.
      IF SY-SUBRC = 0.
        PRUEFLOS = QALS-PRUEFLOS.
      ELSE.
        SELECT SINGLE * FROM QALS WHERE MATNR = MSEG-MATNR AND CHARG = MSEG-CHARG AND WERK = MSEG-WERKS.
        IF SY-SUBRC = 0.
          PRUEFLOS = QALS-PRUEFLOS.
        ELSE.
*          t_header-prueflos = mseg-charg.  "10.12.20
        ENDIF.
      ENDIF.
      T_HEADER-PRUEFLOS = PRUEFLOS.

      SELECT SINGLE * FROM AFPO WHERE AUFNR = MSEG-AUFNR.
      T_HEADER-AUFNR = AFPO-AUFNR.
      T_HEADER-CHARGM = AFPO-CHARG.
*   Select the material description from makt for the main material
      SELECT SINGLE * FROM MAST WHERE MATNR = AFPO-MATNR
                                AND STLAN = '1'.
      SELECT SINGLE * FROM MAKT WHERE MATNR = MAST-MATNR.
      T_HEADER-MAKTXM = MAKT-MAKTX.
      SELECT SINGLE * FROM MARA WHERE MATNR = MAST-MATNR.
      T_HEADER-NORMT = MARA-NORMT.

      APPEND T_HEADER.
    ENDSELECT.

  ENDIF.
ENDFORM.                    " T_HEADER
