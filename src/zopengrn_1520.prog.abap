*&---------------------------------------------------------------------*
*& Report  ZPROV_1520
*& DEVELOPED BY JYOTSNA
*&---------------------------------------------------------------------*
*&THIS PROGRAM SHOWS ALL OPEN GRN & VALUE MATCHED WITH GL 1520
*&
*&---------------------------------------------------------------------*

REPORT  ZPROV_1520_4 NO STANDARD PAGE HEADING LINE-SIZE 300.

TABLES : bsis,
         EKBE,
         RSEG,
         EKKO,
         LFA1,
         ekpo.

TYPE-POOLs:  SLIS.
DATA: G_REPID LIKE SY-REPID,
      FIELDCAT TYPE slis_t_fieldcat_alv,
      WA_FIELDCAT LIKE LINE OF FIELDCAT,
      SORT TYPE slis_t_sortinfo_alv,
      WA_SORT LIKE LINE OF SORT,
      LAYOUT TYPE SLIS_LAYOUT_ALV.

DATA : IT_BSIS TYPE TABLE OF BSIS,
       WA_BSIS TYPE BSIS.

DATA : TOT TYPE BSIS-DMBTR,
       tot_val TYPE bsis-dmbtr,
       TOT_VAL1 TYPE BSIS-DMBTR.

TYPES : BEGIN OF ITAB1,
  EBELN TYPE EKBE-EBELN,
  EBELP TYPE EKBE-EBELP,
  DMBTR TYPE BSIS-DMBTR,
  END OF ITAB1.

TYPES : BEGIN OF ITAB3,
EBELN TYPE EKBE-EBELN,
EBELP TYPE EKBE-EBELP,
PO_DMBTR TYPE BSIS-DMBTR,
  LIFNR TYPE LFA1-LIFNR,
  NAME1 TYPE LFA1-NAME1,
  ORT01 TYPE LFA1-ORT01,
  GRN TYPE EKBE-BELNR,
  BSART TYPE EKKO-BSART,
  grn_qty TYPE ekbe-menge,
  xblnr TYPE ekbe-xblnr,
  grn_val TYPE ekbe-dmbtr,
  bldat TYPE ekbe-bldat,
  val TYPE ekbe-dmbtr,
  MATNR TYPE EKPO-MATNR,
  TXZ01 TYPE EKPO-TXZ01,
  gjahr TYPE ekbe-gjahr,
  bwart TYPE ekbe-bwart,
  GRN_DT TYPE SY-DATUM,
END OF ITAB3.

TYPES : BEGIN OF ITAB4,
GRN TYPE EKBE-BELNR,
  VAL TYPE P   DECIMALS 2,
  END OF ITAB4.

DATA : IT_TAB1 TYPE TABLE OF ITAB1,
       WA_TAB1 TYPE ITAB1,
       IT_TAB2 TYPE TABLE OF ITAB1,
       WA_TAB2 TYPE ITAB1,
       IT_TAB3 TYPE TABLE OF ITAB3,
       WA_TAB3 TYPE ITAB3,
       IT_TAB4 TYPE TABLE OF ITAB3,
       WA_TAB4 TYPE ITAB3.

DATA : COUNT1 TYPE I,
       COUNT2 TYPE I,
       VAL TYPE P DECIMALS 2,
       poqty TYPE ekpo-menge,
       pendqty type ekpo-menge,
       MATNR TYPE EKPO-MATNR,
       TXZ01 TYPE EKPO-TXZ01.
selection-screen begin of block merkmale1 with frame title text-001.
select-OPTIONS : s_budat for bsis-budat,
                 bus FOR bsis-gsber.
selection-screen end of block merkmale1 .
*PARAMETERS : R1 RADIOBUTTON GROUP R1,
*             R2 RADIOBUTTON GROUP R1.

INITIALIZATION.
  G_REPID = SY-REPID.

START-OF-SELECTION.

  select * FROM bsis Into TABLE it_bsis WHERE bukrs EQ '1000' AND HKONT EQ '0000015200'  AND BUDAT IN S_BUDAT. " AND GSBER IN BUS. 00000015200
  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.

  LOOP AT IT_BSIS INTO WA_BSIS.
    IF WA_BSIS-SHKZG EQ 'H'.
      WA_BSIS-DMBTR =  WA_BSIS-DMBTR * ( - 1 ).
    ENDIF.
*  WRITE : / WA_BSIS-ZUONR,WA_BSIS-BELNR,WA_BSIS-DMBTR,WA_BSIS-ZUONR+0(10),WA_BSIS-ZUONR+10(5).

    WA_TAB1-EBELN = WA_BSIS-ZUONR+0(10).
    WA_TAB1-EBELP = WA_BSIS-ZUONR+10(5).
    WA_TAB1-DMBTR = WA_BSIS-DMBTR.
    COLLECT WA_TAB1 INTO IT_TAB1.
    CLEAR WA_TAB1.
  ENDLOOP .

  LOOP AT IT_TAB1 INTO WA_TAB1.
*  WRITE : / '***',WA_TAB1-EBELN,WA_TAB1-EBELP,WA_TAB1-DMBTR.
    IF WA_TAB1-DMBTR NE 0.
      WA_TAB2-EBELN = WA_TAB1-EBELN.
      WA_TAB2-EBELP = WA_TAB1-EBELP.
      WA_TAB2-DMBTR = WA_TAB1-DMBTR.
      COLLECT WA_TAB2 INTO IT_TAB2.
      CLEAR WA_TAB2.
    ENDIF.
  ENDLOOP.
  sort it_tab2 by ebeln ebelp.
  LOOP AT IT_TAB2 INTO WA_TAB2.
*  WRITE : / 'OPEN ITEM',WA_TAB2-EBELN,WA_TAB2-EBELP,WA_TAB2-DMBTR.
*  READ TABLE IT_BSIS INTO WA_BSIS WITH KEY ZUONR+0(10) = WA_TAB2-EBELN ZUONR+10(5) = WA_TAB2-EBELP.
*  IF SY-SUBRC EQ 0.
*    WRITE : WA_BSIS-XREF3.
*  ENDIF.
    TOT = TOT + WA_TAB2-DMBTR.
    SELECT SINGLE * FROM EKKO WHERE EBELN EQ WA_TAB2-EBELN AND BUKRS EQ '1000' .
    IF SY-SUBRC EQ 0.
*    WRITE : EKKO-BSART.
      SELECT SINGLE * FROM LFA1 WHERE LIFNR EQ EKKO-LIFNR.
      IF SY-SUBRC EQ 0.
*      WRITE : LFA1-LIFNR,LFA1-NAME1,LFA1-ORT01.
        SELECT * FROM EKBE WHERE EBELN EQ WA_TAB2-EBELN AND EBELP EQ WA_TAB2-EBELP AND bewtp = 'E' .
          IF SY-SUBRC EQ 0.
*        WRITE : / EKBE-BELNR.
            SELECT SINGLE * FROM RSEG WHERE EBELN EQ WA_TAB2-EBELN AND EBELP EQ WA_TAB2-EBELP AND LFBNR EQ EKBE-BELNR.
            IF SY-SUBRC NE 0.
*            WRITE : / EKBE-BELNR.
              WA_TAB3-BSART = EKKO-BSART.
              wa_tab3-ebeln = WA_TAB2-EBELN.
              wa_tab3-ebelp = WA_TAB2-EBELP.

              WA_TAB3-LIFNR = LFA1-LIFNR.
              WA_TAB3-NAME1 = LFA1-NAME1.
              WA_TAB3-ORT01 = LFA1-ORT01.
              WA_TAB3-GRN = EKBE-BELNR.
              WA_TAB3-GRN_DT = EKBE-BUDAT.
              wa_tab3-bwart = ekbe-bwart.
              wa_tab3-gjahr = ekbe-gjahr.
              wa_tab3-grn_qty = ekbe-menge.
              wa_tab3-xblnr = ekbe-xblnr.
              wa_tab3-grn_val = ekbe-dmbtr.
              wa_tab3-bldat = ekbe-bldat.
              COLLECT WA_TAB3 INTO IT_TAB3.
              CLEAR WA_TAB3.
            ENDIF.
          ENDIF.
        ENDSELECT.
      ENDIF.
    ENDIF.
  ENDLOOP.

  SORT IT_TAB3 BY EBELN EBELP.
  LOOP AT IT_TAB3 INTO WA_TAB3.
    CLEAR : poqty,val, pendqty,MATNR,TXZ01.
    READ TABLE it_tab2 INTO wa_tab2 with KEY ebeln = wa_tab3-ebeln ebelp = wa_tab3-ebelp.
    if sy-subrc eq 0.
*    WRITE : wa_tab2-dmbtr.
      wa_tab3-po_dmbtr = wa_tab2-dmbtr.
    ENDIF.

    select SINGLE * FROM ekpo WHERE ebeln eq wa_tab3-ebeln AND ebelp eq wa_tab3-ebelp.
    if sy-subrc eq 0.
*        WRITE : ekpo-txz01,ekpo-matnr.
      MATNR = EKPO-MATNR.
      TXZ01 = EKPO-TXZ01.
      poqty = ekpo-menge.
    ENDIF.

    ON CHANGE OF WA_TAB3-EBELN.
      COUNT1 = 0.
      count2 = 0.
    ENDON.
    ON CHANGE OF WA_TAB3-EBELP.
      COUNT1 = 0.
      COUNT2 = 0.
    ENDON.
    IF ( COUNT1 = 0  AND COUNT2 = 0 ).
      VAL = wa_tab3-po_dmbtr.
      tot_val = tot_val + wa_tab3-po_dmbtr.
    ENDIF.
    pendqty = poqty - wa_tab3-grn_qty.
*    IF R1 EQ 'X'.
*      WRITE : / WA_TAB3-GRn,wa_tab3-grn_qty,wa_tab3-xblnr,wa_tab3-bldat,wa_tab3-grn_val,WA_TAB3-BSART,Wa_tab3-ebeln,
*       wa_tab3-ebelp, VAL,WA_TAB3-LIFNR, WA_TAB3-NAME1, WA_TAB3-ORT01.
    wa_tab4-grn = wa_tab3-grn.
    WA_TAB4-GRN_DT = WA_TAB3-GRN_DT.
    wa_tab4-gjahr = wa_tab3-gjahr.
    wa_tab4-bwart = wa_tab3-bwart.
    wa_tab4-grn_qty = WA_TAB3-GRn_qty.
    wa_tab4-xblnr = WA_TAB3-xblnr.
    wa_tab4-bldat = WA_TAB3-BLDAT.
    wa_tab4-grn_val = WA_TAB3-GRn_val.
    wa_tab4-bsart = WA_TAB3-bsart.
    wa_tab4-ebeln = WA_TAB3-ebeln.
    wa_tab4-ebelp = WA_TAB3-ebelp.
    wa_tab4-lifnr = WA_TAB3-lifnr.
    wa_tab4-name1 = WA_TAB3-name1.
    wa_tab4-ort01 = WA_TAB3-ort01.
    wa_tab4-val = val.
    WA_TAB4-MATNR = MATNR.
    WA_TAB4-TXZ01 = TXZ01.

    COLLECT wa_tab4 INTO it_tab4.
    CLEAR wa_tab4.
*    COUNT1,COUNT2,
*    ENDIF.
*  WA_TAB4-GRN = WA_TAB3-GRn.
*  WA_TAB4-VAL = VAL.
*  COLLECT WA_TAB4 INTO IT_TAB4.
*  CLEAR WA_TAB4.
    COUNT1 = COUNT1 + 1.
    COUNT2 = COUNT2 + 1.
  ENDLOOP.

*  LOOP at it_tab4 INTO wa_tab4.
*    WRITE : / 'n',WA_TAB4-GRn,wa_tab4-grn_qty,wa_tab4-xblnr,wa_tab4-bldat,wa_tab4-grn_val,WA_TAB4-BSART,Wa_tab4-ebeln, wa_tab4-ebelp,
*    wa_tab4-VAL,WA_TAB4-LIFNR, WA_TAB4-NAME1, WA_TAB4-ORT01.
*    tot_val1 = tot_val1 + wa_tab4-val.
*  ENDLOOP.

  WA_FIELDCAT-fieldname = 'BWART'.
  WA_FIELDCAT-seltext_l = 'GRN MOVEMENT'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'GRN'.
  WA_FIELDCAT-seltext_l = 'GRN NO.'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'GRN_DT'.
  WA_FIELDCAT-seltext_l = 'GRN DATE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'GRN_QTY'.
  WA_FIELDCAT-seltext_l = 'GRN_QTY'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'XBLNR'.
  WA_FIELDCAT-seltext_l = 'BILL NO.'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'BLDAT'.
  WA_FIELDCAT-seltext_l = 'BILL DATE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'GRN_VAL'.
  WA_FIELDCAT-seltext_l = 'GRN VALUE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'BSART'.
  WA_FIELDCAT-seltext_l = 'PO TYPE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'EBELN'.
  WA_FIELDCAT-seltext_l = 'PO NO.'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'EBELP'.
  WA_FIELDCAT-seltext_l = 'PO ITEM'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'MATNR'.
  WA_FIELDCAT-seltext_l = 'MATERIAL CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'TXZ01'.
  WA_FIELDCAT-seltext_l = 'ITEM TEXT'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'VAL'.
  WA_FIELDCAT-seltext_l = 'PO ITEM OPEN VALUE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'LIFNR'.
  WA_FIELDCAT-seltext_l = 'VENDOR CODE'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'NAME1'.
  WA_FIELDCAT-seltext_l = 'VENDOR NAME'.
  APPEND WA_FIELDCAT TO FIELDCAT.

  WA_FIELDCAT-fieldname = 'ORT01'.
  WA_FIELDCAT-seltext_l = 'VENDOR LOC'.
  APPEND WA_FIELDCAT TO FIELDCAT.




  LAYOUT-zebra = 'X'.
  LAYOUT-colwidth_optimize = 'X'.
  LAYOUT-WINDOW_TITLEBAR  = 'OPEN GRN'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
   EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
     I_CALLBACK_PROGRAM                =  G_REPID
*   I_CALLBACK_PF_STATUS_SET          = ' '
   I_CALLBACK_USER_COMMAND           = 'USER_COMM'
   I_CALLBACK_TOP_OF_PAGE            = 'TOP'
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   IS_LAYOUT                         = LAYOUT
     IT_FIELDCAT                       = FIELDCAT
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
   I_SAVE                            = 'A'
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB                          = IT_tAB4
   EXCEPTIONS
     PROGRAM_ERROR                     = 1
     OTHERS                            = 2
            .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


*&---------------------------------------------------------------------*
*&      Form  TOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM TOP.

  DATA: COMMENT TYPE SLIS_T_LISTHEADER,
        WA_COMMENT LIKE LINE OF COMMENT.

  WA_COMMENT-TYP = 'A'.
  WA_COMMENT-INFO+0(21) = 'TOTAL OPEN GRN VALUE'.
  WA_COMMENT-INFO+23(20) = TOT_VAL.
  APPEND WA_COMMENT TO COMMENT.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      IT_LIST_COMMENTARY       = COMMENT
*     I_LOGO                   = 'ENJOYSAP_LOGO'
*     I_END_OF_LIST_GRID       =
*     I_ALV_FORM               =
            .

  CLEAR COMMENT.

ENDFORM.                    "TOP



*&---------------------------------------------------------------------*
*&      Form  USER_COMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->UCOMM      text
*      -->SELFIELD   text
*----------------------------------------------------------------------*
FORM USER_COMM USING UCOMM LIKE SY-UCOMM
                     SELFIELD TYPE SLIS_SELFIELD.



  CASE SELFIELD-FIELDNAME.
    WHEN 'VBELN'.
      SET PARAMETER ID 'VF' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.
    WHEN 'VBELN1'.
      SET PARAMETER ID 'BV' FIELD SELFIELD-VALUE.
      CALL TRANSACTION 'VL03N' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    "USER_COMM



*SORT IT_TAB4 BY GRN.
*IF R2 EQ 'X'.
*  LOOP AT IT_TAB4 INTO WA_TAB4.
*    WRITE : / WA_TAB4-GRN.
**    ,WA_TAB4-VAL.
*    TOT_VAL1 = TOT_VAL1 + WA_TAB4-VAL.
*  ENDLOOP.
*ENDIF.
*LOOP at it_tab2 INTO wa_tab2 .
*  READ TABLE it_tab3 INTO wa_tab3 with KEY EBELN = Wa_tab2-ebeln EBELP = wa_tab2-ebelp.
*  if sy-subrc eq 4.
*    WRITE : / '********************',wa_tab2-ebeln,wa_tab2-ebelp.
*  ENDIF.
*ENDLOOP.

*WRITE : / 'TOTAL',tot_val,tot_val1.
