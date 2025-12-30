REPORT Z_GOODSISSUE_LABELS_CO_NO MESSAGE-ID ZLAL.
* Changes done by anjali on 19.3.2002 , as per request from prod (SNJ).
*for introducing the Indl sector with the description
* Changes done by anjali on 9.10.02 as per request from stores(dm)
* for introducing resting Qc LOT no.
*table declerations-------------------------

TABLES:
  S026,
  MKPF,
  MSEG,
  LFA1,
  MCHA,
  MAKT,
  QALS,
  QAMB,
  S021,
  AFPO,
  AFKO,
  AUFM,
  AUFK,
  MAST,
  MARA,
  STPO,
  RESB,
  ZPO_MATNR,
  EKKO,
  EKBE,
  EKPO,
  EKPA.

*data declerations---------------------------

DATA : BEGIN OF T_HEADER OCCURS 0,
         AUFNR  LIKE AFPO-AUFNR,   "order no
         CHARG  LIKE AFPO-CHARG,   "batch no material
         MATNR  LIKE MAST-MATNR,   "Material no
         STLNR  LIKE MAST-STLNR,   "bom no
         MAKTXM LIKE MAKT-MAKTX,   "Material Descr
         ANDAT  LIKE MAST-ANDAT,   "date of order
       END OF T_HEADER.
DATA : BEGIN OF T_DETAILS OCCURS 0,
         STLNR    LIKE MAST-STLNR,   "bom no
*       idnrk  LIKE stpo-idnrk,   "Component no
         AUFNR    LIKE RESB-AUFNR,    "orderno
         MATNR    LIKE RESB-MATNR,   "component no
         MAKTXC   LIKE MAKT-MAKTX,   "description
         MENGE    LIKE RESB-BDMNG,   "qty
         MEINS    LIKE RESB-MEINS,   "units
         CHARG    LIKE RESB-CHARG,   "comp batc no
         PRUEFLOS LIKE QALS-PRUEFLOS, "inspection lot
         NORMT    LIKE MARA-NORMT,      "indl sector
       END OF T_DETAILS.

DATA : IT_RESB TYPE TABLE OF RESB,
       WA_RESB TYPE RESB,
       IT_QALS TYPE TABLE OF QALS,
       WA_QALS TYPE QALS.

DATA : COUNT TYPE I .
DATA : PG_COUNT TYPE I .
DATA : W_NAME(61) TYPE C,
       WERKS      TYPE AFPO-DWERK.
DATA: MTART       TYPE MARA-MTART,
      RPTXT1(30)  TYPE C,
      FORMAT1(60) TYPE C,
      RPTXT2(50)  TYPE C.
COUNT = 0 .


*selection screen-------------------------------------

SELECTION-SCREEN BEGIN OF BLOCK INPUT WITH FRAME TITLE TEXT-001 .


  PARAMETERS : P_AUFNR  LIKE AFPO-AUFNR OBLIGATORY,
               P_IDNRK  LIKE STPO-IDNRK OBLIGATORY,
               P_CHARG  LIKE RESB-CHARG OBLIGATORY,
               P_MENGE  LIKE STPO-MENGE OBLIGATORY,
               P_BUDAT  LIKE MKPF-BUDAT OBLIGATORY,
               NUMLABEL TYPE I OBLIGATORY.

*PARAMETERS :
*R1 RADIOBUTTON GROUP R1,
*             R2 RADIOBUTTON GROUP R1.

SELECTION-SCREEN END OF BLOCK INPUT.

* start of selection---------------------------------
START-OF-SELECTION.
  CLEAR T_HEADER.
  REFRESH T_HEADER.
  PERFORM T_HEADER.

  SELECT * FROM RESB INTO TABLE IT_RESB FOR ALL ENTRIES IN T_HEADER WHERE AUFNR = T_HEADER-AUFNR.
  SELECT * FROM QALS INTO TABLE IT_QALS FOR ALL ENTRIES IN IT_RESB WHERE MATNR = IT_RESB-MATNR
                            AND CHARG = IT_RESB-CHARG AND WERK = IT_RESB-WERKS
    AND STAT34 EQ 'X'.  "29.12.20
*    art = '09' and

*  sort it_qals by prueflos descending.
  SORT IT_QALS BY ENSTEHDAT DESCENDING.
  PERFORM T_DETAILS.


*  IF R1 EQ 'X'.
*    PERFORM FORM1.
*  ELSE.
  PERFORM FORM2.
*  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FORM1.
  CALL FUNCTION 'START_FORM'
*    EXPORTING
*         ARCHIVE_INDEX    =
*         FORM             = ' '
*         LANGUAGE         = ' '
*         STARTPAGE        = ' '
*         PROGRAM          = ' '
*         MAIL_APPL_OBJECT =
*    IMPORTING
*         LANGUAGE         =
    EXCEPTIONS
      FORM     = 1
      FORMAT   = 2
      UNENDED  = 3
      UNOPENED = 4
      UNUSED   = 5
      OTHERS   = 6.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
*     APPLICATION                 = 'TX'
*     ARCHIVE_INDEX               =
*     ARCHIVE_PARAMS              =
      DEVICE   = 'PRINTER'
*     DIALOG   = 'X'
      FORM     = 'Z_GOODSISS_CO_NO'
      LANGUAGE = SY-LANGU
*     OPTIONS  =
*     MAIL_SENDER                 =
*     MAIL_RECIPIENT              =
*     MAIL_APPL_OBJECT            =
*     RAW_DATA_INTERFACE          = '*'
*    IMPORTING
*     LANGUAGE =
*     NEW_ARCHIVE_PARAMS          =
*     RESULT   =
*    EXCEPTIONS
*     CANCELED = 1
*     DEVICE   = 2
*     FORM     = 3
*     OPTIONS  = 4
*     UNCLOSED = 5
*     MAIL_OPTIONS                = 6
*     ARCHIVE_ERROR               = 7
*     INVALID_FAX_NUMBER          = 8
*     MORE_PARAMS_NEEDED_IN_BATCH = 9
*     OTHERS   = 10
    .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



  IF P_CHARG NE 'W'. "AND T_DETAILS-PRUEFLOS NE 0. . Commented by sakshi 03-11-25
    DO NUMLABEL TIMES.
      IF T_DETAILS-NORMT NE SPACE.
        CONCATENATE T_DETAILS-MAKTXC T_DETAILS-NORMT INTO W_NAME SEPARATED BY '-'.
      ELSE.
        W_NAME = T_DETAILS-MAKTXC.
      ENDIF.
      CONDENSE W_NAME.

      COUNT = COUNT + 1.
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
***  PG_COUNT = COUNT MOD 9 .
***  IF PG_COUNT EQ 0 .
***
***    CALL FUNCTION 'CONTROL_FORM'
***         EXPORTING
***              COMMAND   = 'NEW-PAGE'
***         EXCEPTIONS
***              UNOPENED  = 1
***              UNSTARTED = 2
***              OTHERS    = 3.
***    IF SY-SUBRC <> 0.
**** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
****         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
***    ENDIF.
***
***  ELSE. "IF PG_COUNT EQ 0 .
***
***    CALL FUNCTION 'CONTROL_FORM'
***         EXPORTING
***              COMMAND   = 'NEW-WINDOW'
***         EXCEPTIONS
***              UNOPENED  = 1
***              UNSTARTED = 2
***              OTHERS    = 3.
***    IF SY-SUBRC <> 0.
**** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
****         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
***    ENDIF.
***
****  ENDIF. "IF PG_COUNT EQ 0 .
    ENDDO.
  ENDIF.
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


  CALL FUNCTION 'END_FORM'
*    IMPORTING
*         RESULT                   =
    EXCEPTIONS
      UNOPENED                 = 1
      BAD_PAGEFORMAT_FOR_PRINT = 2
      OTHERS                   = 3.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.                                                    "FORM1




*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM FORM2.
  CALL FUNCTION 'START_FORM'
*    EXPORTING
*         ARCHIVE_INDEX    =
*         FORM             = ' '
*         LANGUAGE         = ' '
*         STARTPAGE        = ' '
*         PROGRAM          = ' '
*         MAIL_APPL_OBJECT =
*    IMPORTING
*         LANGUAGE         =
    EXCEPTIONS
      FORM     = 1
      FORMAT   = 2
      UNENDED  = 3
      UNOPENED = 4
      UNUSED   = 5
      OTHERS   = 6.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
*     APPLICATION                 = 'TX'
*     ARCHIVE_INDEX               =
*     ARCHIVE_PARAMS              =
      DEVICE   = 'PRINTER'
*     DIALOG   = 'X'
*     form     = 'Z_GOODSISS_CO_N2'
*     FORM     = 'Z_GOODSISS_CO_N3'
      FORM     = 'Z_GOODSISS_CO_N4'
      LANGUAGE = SY-LANGU
*     OPTIONS  =
*     MAIL_SENDER                 =
*     MAIL_RECIPIENT              =
*     MAIL_APPL_OBJECT            =
*     RAW_DATA_INTERFACE          = '*'
*    IMPORTING
*     LANGUAGE =
*     NEW_ARCHIVE_PARAMS          =
*     RESULT   =
*    EXCEPTIONS
*     CANCELED = 1
*     DEVICE   = 2
*     FORM     = 3
*     OPTIONS  = 4
*     UNCLOSED = 5
*     MAIL_OPTIONS                = 6
*     ARCHIVE_ERROR               = 7
*     INVALID_FAX_NUMBER          = 8
*     MORE_PARAMS_NEEDED_IN_BATCH = 9
*     OTHERS   = 10
    .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.



  IF P_CHARG NE 'W' ."AND T_DETAILS-PRUEFLOS NE 0. Commented by sakshi on 03-11-25.
    DO NUMLABEL TIMES.
      IF T_DETAILS-NORMT NE SPACE.
        CONCATENATE T_DETAILS-MAKTXC T_DETAILS-NORMT INTO W_NAME SEPARATED BY '-'.
      ELSE.
        W_NAME = T_DETAILS-MAKTXC.
      ENDIF.
      CONDENSE W_NAME.

      SELECT SINGLE * FROM AFPO WHERE AUFNR EQ T_DETAILS-AUFNR.
      IF SY-SUBRC EQ 0.
        WERKS = AFPO-DWERK.
      ENDIF.

      CLEAR : MTART,RPTXT1.
      SELECT SINGLE * FROM MARA WHERE MATNR EQ P_IDNRK.
      IF SY-SUBRC EQ 0.
        MTART = MARA-MTART.
      ENDIF.
      CLEAR : RPTXT2.
      IF MTART EQ 'ZROH'.
        RPTXT1 = 'DISPENSED RAW MATERIAL'.
        IF WERKS EQ '1000'.
          FORMAT1 = 'Format No.SOP/QAD/060-F2'.
        ENDIF.
        RPTXT2 = 'Store/Production'.
      ELSEIF MTART EQ 'ZVRP'.
        RPTXT1 = 'DISPENSED PACKAGING MATERIAL'.
        IF WERKS EQ '1000'.
          FORMAT1 = 'Format No.SOP/QAD/060-F4'.
        ENDIF.
      ENDIF.

      COUNT = COUNT + 1.
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
***  PG_COUNT = COUNT MOD 9 .
***  IF PG_COUNT EQ 0 .
***
***    CALL FUNCTION 'CONTROL_FORM'
***         EXPORTING
***              COMMAND   = 'NEW-PAGE'
***         EXCEPTIONS
***              UNOPENED  = 1
***              UNSTARTED = 2
***              OTHERS    = 3.
***    IF SY-SUBRC <> 0.
**** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
****         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
***    ENDIF.
***
***  ELSE. "IF PG_COUNT EQ 0 .
***
***    CALL FUNCTION 'CONTROL_FORM'
***         EXPORTING
***              COMMAND   = 'NEW-WINDOW'
***         EXCEPTIONS
***              UNOPENED  = 1
***              UNSTARTED = 2
***              OTHERS    = 3.
***    IF SY-SUBRC <> 0.
**** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
****         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
***    ENDIF.
***
****  ENDIF. "IF PG_COUNT EQ 0 .
    ENDDO.
  ENDIF.
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


  CALL FUNCTION 'END_FORM'
*    IMPORTING
*         RESULT                   =
    EXCEPTIONS
      UNOPENED                 = 1
      BAD_PAGEFORMAT_FOR_PRINT = 2
      OTHERS                   = 3.
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.                                                    "FORM2

*&---------------------------------------------------------------------*
*&      Form  T_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM T_HEADER.
  SELECT * FROM AFPO WHERE AUFNR = P_AUFNR.
    MOVE-CORRESPONDING AFPO TO T_HEADER.
    SELECT SINGLE * FROM AUFM WHERE AUFNR = AFPO-AUFNR.
    SELECT SINGLE * FROM MKPF WHERE MBLNR = AUFM-MBLNR.
    T_HEADER-ANDAT = P_BUDAT.
    SELECT SINGLE * FROM MAST WHERE MATNR = AFPO-MATNR
                              AND STLAN = '1'.
    T_HEADER-STLNR = MAST-STLNR.

    SELECT SINGLE * FROM MAKT WHERE MATNR = MAST-MATNR.
    T_HEADER-MAKTXM = MAKT-MAKTX.
    APPEND T_HEADER.
  ENDSELECT.
ENDFORM.                    " T_HEADER

*&---------------------------------------------------------------------*
*&      Form  T_DETAILS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM T_DETAILS.
  LOOP AT T_HEADER.
    LOOP AT IT_RESB INTO WA_RESB WHERE AUFNR = T_HEADER-AUFNR AND MATNR EQ P_IDNRK AND CHARG EQ P_CHARG.
      IF WA_RESB-BDMNG NE 0 AND WA_RESB-CHARG NE 'W' AND WA_RESB-CHARG NE ' '.
        T_DETAILS-AUFNR = WA_RESB-AUFNR.
        T_DETAILS-MENGE = P_MENGE.
        T_DETAILS-MEINS = WA_RESB-MEINS.
        T_DETAILS-CHARG = WA_RESB-CHARG.
        SELECT SINGLE * FROM MAKT WHERE MATNR = WA_RESB-MATNR.
        T_DETAILS-MAKTXC = MAKT-MAKTX.
        SELECT SINGLE * FROM MARA WHERE MATNR = WA_RESB-MATNR.
        T_DETAILS-NORMT = MARA-NORMT.

******************************************
*******************  ADDED FOR PO TEXT ON 4.1.21*********************
*        SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_RESB-MATNR.
*        IF SY-SUBRC EQ 0.
*          SELECT SINGLE * FROM EKBE WHERE MATNR EQ WA_RESB-MATNR AND CHARG EQ WA_RESB-CHARG AND WERKS EQ WA_RESB-WERKS.
*          IF SY-SUBRC EQ 0.
*            SELECT SINGLE * FROM EKKO WHERE EBELN EQ EKBE-EBELN.
*            IF SY-SUBRC EQ 0.
*              IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*                SELECT SINGLE * FROM EKPO WHERE EBELN EQ EKBE-EBELN AND EBELP EQ EKBE-EBELP.
*                IF SY-SUBRC EQ 0.
*                  T_DETAILS-MAKTXC = EKPO-TXZ01.
*                  T_DETAILS-NORMT = SPACE.
**                    T_DETAILS-MAKTX2 = SPACE.
*                ENDIF.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.
        SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_RESB-MATNR. "18.11.22
        IF SY-SUBRC EQ 0.
          SELECT SINGLE * FROM EKBE WHERE MATNR EQ WA_RESB-MATNR AND CHARG EQ WA_RESB-CHARG AND WERKS EQ WA_RESB-WERKS.
          IF SY-SUBRC EQ 0.
            SELECT SINGLE * FROM EKKO WHERE EBELN EQ EKBE-EBELN.
            IF SY-SUBRC EQ 0.
              SELECT SINGLE * FROM EKPA WHERE EBELN EQ EKBE-EBELN AND PARVW EQ 'HR'.
              IF SY-SUBRC EQ 0.
                SELECT SINGLE * FROM ZPO_MATNR WHERE MATNR EQ WA_RESB-MATNR AND LIFNR EQ EKPA-LIFN2.
                IF SY-SUBRC EQ 0.
                  IF EKKO-AEDAT GE ZPO_MATNR-EFFECTDT.
*                SELECT SINGLE * FROM EKPO WHERE EBELN EQ EKBE-EBELN AND EBELP EQ EKBE-EBELP.
*                IF SY-SUBRC EQ 0.
                    T_DETAILS-MAKTXC = ZPO_MATNR-MAKTX.
                    T_DETAILS-NORMT = SPACE.
*                    T_DETAILS-MAKTX2 = SPACE.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

**********************************************

*        if wa_resb-postp = 'L'.
        READ TABLE IT_QALS INTO WA_QALS WITH KEY MATNR = WA_RESB-MATNR CHARG = WA_RESB-CHARG WERK = WA_RESB-WERKS .
*          art = '09'

        IF SY-SUBRC = 0.
          T_DETAILS-PRUEFLOS = WA_QALS-PRUEFLOS.
        ELSE.
          SELECT SINGLE PRUEFLOS , MATNR , CHARG FROM ZINSP INTO @DATA(WA_INSP)
             WHERE MATNR = @WA_RESB-MATNR AND CHARG = @WA_RESB-CHARG.
          IF SY-SUBRC = 0.
            T_DETAILS-PRUEFLOS = WA_INSP-PRUEFLOS.

          ENDIF.
        ENDIF.
*          else.
*            select single * from qals where matnr = wa_resb-matnr and charg = wa_resb-charg and art = '08' and werk =
*              wa_resb-werks.
*            if sy-subrc = 0.
*              t_details-prueflos = qals-prueflos.
*            else.
*
*              select single * from qals where matnr = wa_resb-matnr and charg = wa_resb-charg and werk = wa_resb-werks.
*              if sy-subrc = 0.
*                t_details-prueflos = qals-prueflos.
*              else.
*                t_details-prueflos = wa_resb-charg.
*              endif.
*            endif.
*          endif.
*        endif.
*        IF resb-postp = 'N'.
*          SELECT SINGLE * FROM qals WHERE matnr = resb-matnr
*                                    AND charg = resb-charg.
*          t_details-prueflos = 1.
*        ENDIF.

        APPEND T_DETAILS.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
ENDFORM.                    " T_DETAILS
