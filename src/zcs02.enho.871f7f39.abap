"Name: \PR:SAPLCSDI\FO:STPUB_DB_READ\SE:BEGIN\EI
ENHANCEMENT 0 ZCS02.
** In case of multiple BOM< user will get alert - Jyotsna 24.6.24
  data: a1 TYPE p.
  DATA: IT_MAST1 TYPE TABLE OF MAST,
        WA_MAST1 TYPE MAST,
        IT_STKO1 TYPE TABLE OF STKO,
        WA_STKO1 TYPE STKO.

  SELECT * FROM MAST INTO TABLE IT_MAST1 WHERE MATNR EQ RC29N-MATNR AND WERKS EQ RC29N-WERKS AND STLAN EQ 1.
    IF SY-SUBRC EQ 0.
      SELECT * FROM STKO INTO TABLE IT_STKO1 FOR ALL ENTRIES IN IT_MAST1 WHERE STLNR EQ IT_MAST1-STLNR
        AND STLAL EQ IT_MAST1-STLAL AND STLST EQ '01'.
    ENDIF.
     A1 = 1.
     LOOP AT IT_STKO1 INTO WA_STKO1.
       A1 = A1 + 1.
     ENDLOOP.
     if a1 gt 2.
       MESSAGE 'This product code has multiple BOM, do the changes accordingly' TYPE 'I'.
     ENDIF.
*************************
*Send an email if BOM is changes - by Jyotsna
 if sy-host EQ 'SAPQLT' or sy-host EQ 'SAPDEV'.

 else.
   if sy-uname ne 'ITBOM01'.

  IF SY-TCODE EQ 'CS02'.
    if sy-fdpos eq 1.
      IF SY-UNAME NE 'RDNSK01'."16.12.21
DATA : A TYPE I.
TYPES : BEGIN OF email,
  email TYPE AD_SMTPADR,
  END OF email.
data : it_email TYPE TABLE OF email,
       wa_email TYPE email.
  IF A LT 10.
DATA : MATNR TYPE MATNR.
*MESSAGE 'BOM IS CHANGED' TYPE 'I'.
*STZUB-STLNR,STZUB-TSTMP,STZUB-STLDT,STZUB-WRKAN.
SELECT SINGLE * FROM MAST WHERE STLNR EQ STZUB-STLNR.
  IF SY-SUBRC EQ 0.
    MATNR = MAST-MATNR.
  ENDIF.

******************
  TABLES : makt.


DATA :  OPTIONS        TYPE ITCPO,
        L_OTF_DATA     LIKE ITCOO OCCURS 10,
        L_ASC_DATA     LIKE TLINE OCCURS 10,
        L_DOCS         LIKE DOCS  OCCURS 10,
        L_PDF_DATA     LIKE SOLISTI1 OCCURS 10,
        L_PDF_DATA1    LIKE SOLISTI1 OCCURS 10,
        L_BIN_FILESIZE TYPE I.
DATA :  RESULT      LIKE  ITCPP.
DATA: DOCDATA LIKE SOLISTI1  OCCURS  10,
      OBJHEAD LIKE SOLISTI1  OCCURS  1,
      OBJBIN1 LIKE SOLISTI1  OCCURS 10,
      OBJBIN  LIKE SOLISTI1  OCCURS 10.
DATA: LISTOBJECT LIKE ABAPLIST  OCCURS  1 .
DATA: DOC_CHNG LIKE SODOCCHGI1.
DATA RECLIST    LIKE SOMLRECI1  OCCURS  1 WITH HEADER LINE.
DATA MCOUNT TYPE I.
DATA : V_WERKS TYPE WERKS_D.
DATA : V_TEXT(70) TYPE C.
DATA: LTX LIKE T247-LTX.

DATA : USRID_LONG LIKE PA0105-USRID_LONG.
DATA : W_USRID_LONG TYPE PA0105-USRID_LONG.
DATA RIGHE_ATTACHMENT TYPE I.
DATA RIGHE_TESTO TYPE I.
DATA TAB_LINES TYPE I.
DATA  BEGIN OF OBJPACK OCCURS 0 .
        INCLUDE STRUCTURE  SOPCKLSTI1.
DATA END OF OBJPACK.

DATA BEGIN OF OBJTXT OCCURS 0.
        INCLUDE STRUCTURE SOLISTI1.
DATA END OF OBJTXT.
DATA: V_MSG(125) TYPE C,
      WA_D1(10)  TYPE C,
      maktx TYPE makt-maktx.

if STZUB-wrkan eq '1000'.

  wa_email-email = 'kec@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
  wa_email-email = 'sachin.s@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
   wa_email-email = 'b.deore@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
*   wa_email-email = 'shashikant@bluecrosslabs.com'.
*  APPEND wa_email to it_email.
*  CLEAR wa_email.
   wa_email-email = 'm.thakre@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
   wa_email-email = 'pradeep.patil@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
     wa_email-email = 'shubhangi@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
  wa_email-email = 'sandeep.s@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.

       wa_email-email = 'jyotsna@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
elseif  STZUB-wrkan eq '1001'.

  wa_email-email = 'vishwas@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
  wa_email-email = 'sachin.s@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
   wa_email-email = 'dinar@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
   wa_email-email = 'pur_goa@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
   wa_email-email = 'sandeep.s@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
else.
  wa_email-email = 'sachin.s@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
  wa_email-email = 'awadhut.p@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
*   wa_email-email = 'deepak.i@bluecrosslabs.com'.  "removed on 24.8.23 as per his request
*  APPEND wa_email to it_email.
*  CLEAR wa_email.
   wa_email-email = 'sandeep.s@bluecrosslabs.com'.
  APPEND wa_email to it_email.
  CLEAR wa_email.
endif.



CALL FUNCTION 'SX_TABLE_LINE_WIDTH_CHANGE'
      EXPORTING
        LINE_WIDTH_DST = '255'
      TABLES
        CONTENT_IN     = L_ASC_DATA
        CONTENT_OUT    = OBJBIN.

    WRITE SY-DATUM TO WA_D1 DD/MM/YYYY.
*    WRITE S_BUDAT-HIGH TO WA_D2 DD/MM/YYYY.
SELECT SINGLE * FROM makt WHERE matnr eq matnr.
  if sy-subrc eq 0.
    maktx = makt-maktx.
  endif.
    DESCRIBE TABLE OBJBIN LINES RIGHE_ATTACHMENT.
    OBJTXT = 'BOM is changed for material'.APPEND OBJTXT.
    OBJTXT = matnr .APPEND OBJTXT.
    OBJTXT = maktx.APPEND OBJTXT.
      OBJTXT = 'For more detail please execute report- ZBOM_CHG'.APPEND OBJTXT.
    DESCRIBE TABLE OBJTXT LINES RIGHE_TESTO.
    DOC_CHNG-OBJ_NAME = 'URGENT'.
    DOC_CHNG-EXPIRY_DAT = SY-DATUM + 10.
    CONDENSE LTX.
    CONDENSE OBJTXT.
*      CONCATENATE 'SR9 for the period' ltx '-' INTO doc_chng-obj_descr SEPARATED BY space.
    CONCATENATE 'BOM IS CHANGED ON: ' WA_D1 INTO DOC_CHNG-OBJ_DESCR SEPARATED BY SPACE.
    DOC_CHNG-SENSITIVTY = 'F'.
    DOC_CHNG-DOC_SIZE = RIGHE_TESTO * 255 .

    CLEAR OBJPACK-TRANSF_BIN.

    OBJPACK-HEAD_START = 1.
    OBJPACK-HEAD_NUM = 0.
    OBJPACK-BODY_START = 1.
    OBJPACK-BODY_NUM = 4.
    OBJPACK-DOC_TYPE = 'TXT'.
    APPEND OBJPACK.
    LOOP at it_email INTO wa_email.
    RECLIST-RECEIVER = wa_email-email.
    RECLIST-EXPRESS = 'X'.
    RECLIST-REC_TYPE = 'U'.
    RECLIST-NOTIF_DEL = 'X'. " request delivery notification
    RECLIST-NOTIF_NDEL = 'X'. " request not delivered notification
    APPEND RECLIST.
    CLEAR RECLIST.
    endloop.
*  endif.
*  ENDLOOP.

    DESCRIBE TABLE RECLIST LINES MCOUNT.
    IF MCOUNT > 0.
      DATA: SENDER LIKE SOEXTRECI1-RECEIVER.
**ADDED BY SATHISH.B
      TYPES: BEGIN OF T_USR21,
               BNAME      TYPE USR21-BNAME,
               PERSNUMBER TYPE USR21-PERSNUMBER,
               ADDRNUMBER TYPE USR21-ADDRNUMBER,
             END OF T_USR21.

      TYPES: BEGIN OF T_ADR6,
               ADDRNUMBER TYPE USR21-ADDRNUMBER,
               PERSNUMBER TYPE USR21-PERSNUMBER,
               SMTP_ADDR  TYPE ADR6-SMTP_ADDR,
             END OF T_ADR6.

      DATA: IT_USR21 TYPE TABLE OF T_USR21,
            WA_USR21 TYPE T_USR21,
            IT_ADR6  TYPE TABLE OF T_ADR6,
            WA_ADR6  TYPE T_ADR6.
      SELECT  BNAME PERSNUMBER ADDRNUMBER FROM USR21 INTO TABLE IT_USR21
          WHERE BNAME = SY-UNAME.
      IF SY-SUBRC = 0.
        SELECT ADDRNUMBER PERSNUMBER SMTP_ADDR FROM ADR6 INTO TABLE IT_ADR6
          FOR ALL ENTRIES IN IT_USR21 WHERE ADDRNUMBER = IT_USR21-ADDRNUMBER
                                      AND   PERSNUMBER = IT_USR21-PERSNUMBER.
      ENDIF.

      LOOP AT IT_USR21 INTO WA_USR21.
        READ TABLE IT_ADR6 INTO WA_ADR6 WITH KEY ADDRNUMBER = WA_USR21-ADDRNUMBER.
        IF SY-SUBRC = 0.
          SENDER = WA_ADR6-SMTP_ADDR.
        ENDIF.
      ENDLOOP.
      CALL FUNCTION 'SO_DOCUMENT_SEND_API1'
        EXPORTING
          DOCUMENT_DATA              = DOC_CHNG
          PUT_IN_OUTBOX              = 'X'
          SENDER_ADDRESS             = SENDER
          SENDER_ADDRESS_TYPE        = 'SMTP'
*         COMMIT_WORK                = ' '
* IMPORTING
*         SENT_TO_ALL                =
*         NEW_OBJECT_ID              =
*         SENDER_ID                  =
        TABLES
          PACKING_LIST               = OBJPACK
*         OBJECT_HEADER              =
          CONTENTS_BIN               = OBJBIN
          CONTENTS_TXT               = OBJTXT
*         CONTENTS_HEX               =
*         OBJECT_PARA                =
*         OBJECT_PARB                =
          RECEIVERS                  = RECLIST
        EXCEPTIONS
          TOO_MANY_RECEIVERS         = 1
          DOCUMENT_NOT_SENT          = 2
          DOCUMENT_TYPE_NOT_EXIST    = 3
          OPERATION_NO_AUTHORIZATION = 4
          PARAMETER_ERROR            = 5
          X_ERROR                    = 6
          ENQUEUE_ERROR              = 7
          OTHERS                     = 8.
      IF SY-SUBRC <> 0.
        MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

      COMMIT WORK.

*      IF SY-SUBRC EQ 0.
*        WRITE : / 'EMAIL SENT ON ',WA_EMAIL-USRID_LONG.
*      ENDIF.

**modid ver1.0 starts

      CLEAR   : OBJPACK,
                OBJHEAD,
                OBJTXT,
                OBJBIN,
                RECLIST.

      REFRESH : OBJPACK,
                OBJHEAD,
                OBJTXT,
                OBJBIN,
                RECLIST.
    ENDIF.

*********************
A = 10.
ENDIF.
endif.
ENDIF.
  ENDIF.

  endif.
endif.
ENDENHANCEMENT.
