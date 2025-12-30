"Name: \PR:SAPLMEPO\EX:PO_PROCESS_04\EI
ENHANCEMENT 0 ZME21N_NEW.

  TABLES : mara,
           zpur_req1.

******** 6 DIGIT HSN MANDATORY FOR RETURN PO*****************
  DATA: hsnl    TYPE i,
        hsn(10) TYPE c.

********purchase requisition check***************************
*** Below code comment starts 04.10.25
*  IF SY-TCODE EQ 'ME21N' .
*    iF CHT_EKPO-banfn ne space.
*      SELECT SINGLE * FROM zpur_req1 WHERE banfn eq CHT_EKPO-banfn AND bnfpo eq CHT_EKPO-bnfpo AND apr2 eq 'X'.
*        IF SY-SUBRC EQ 4.
*          MESSAGE 'THIS REQUISITION IS NOT YET APPROVED' TYPE 'E'.
*        ENDIF.
*         SELECT SINGLE * FROM eban WHERE banfn eq CHT_EKPO-banfn AND bnfpo eq CHT_EKPO-bnfpo AND ebeln ne space.
*        IF SY-SUBRC EQ 0.
*          SELECT SINGLE * FROM EKPO WHERE EBELN EQ EBAN-EBELN AND EBELP EQ EBAN-EBELP AND LOEKZ EQ SPACE.
*            IF SY-SUBRC EQ 0.
**            ELSE.
*               iF CHT_EKPO-ebeln eq space.
*                MESSAGE 'PURCHASE ORDER IS ALREADY RAISED FOR THIS REQUISITION' TYPE 'E'.
*                ENDIF.
*            ENDIF.
*        ENDIF.
*    ENDIF.
*  endif.
*
*IF SY-TCODE EQ 'ME22N'.
*    iF CHT_EKPO-banfn ne space.
*      SELECT SINGLE * FROM zpur_req1 WHERE banfn eq CHT_EKPO-banfn AND bnfpo eq CHT_EKPO-bnfpo AND apr2 eq 'X'.
*        IF SY-SUBRC EQ 4.
*          MESSAGE 'THIS REQUISITION IS NOT YET APPROVED' TYPE 'E'.
*        ENDIF.
*         SELECT SINGLE * FROM eban WHERE banfn eq CHT_EKPO-banfn AND bnfpo eq CHT_EKPO-bnfpo AND ebeln ne space.
*        IF SY-SUBRC EQ 0.
*          SELECT SINGLE * FROM EKPO WHERE EBELN EQ EBAN-EBELN AND EBELP EQ EBAN-EBELP AND LOEKZ EQ SPACE.
*            IF SY-SUBRC EQ 0.
**            ELSE.
*               iF CHT_EKPO-ebeln eq space.
*                  MESSAGE 'PURCHASE ORDER IS ALREADY RAISED FOR THIS REQUISITION' TYPE 'E'.
*                ELSE.
*                MESSAGE 'PURCHASE ORDER IS ALREADY RAISED FOR THIS REQUISITION' TYPE 'I'.
*                ENDIF.
*            ENDIF.
*        ENDIF.
*    ENDIF.
* endif.
*
*****************************************************************
*
* IF SY-TCODE EQ 'ME21N' OR SY-TCODE EQ 'ME22N'.
*
*********purchase requisition check***************************
*    iF CHT_EKPO-banfn ne space.
*      SELECT SINGLE * FROM zpur_req1 WHERE banfn eq CHT_EKPO-banfn AND bnfpo eq CHT_EKPO-bnfpo AND apr2 eq 'X'.
*        IF SY-SUBRC EQ 4.
*          MESSAGE 'THIS REQUISITION IS NOT YET APPROVED' TYPE 'E'.
*        ENDIF.
*
*         SELECT SINGLE * FROM eban WHERE banfn eq CHT_EKPO-banfn AND bnfpo eq CHT_EKPO-bnfpo AND ebeln ne space.
*        IF SY-SUBRC EQ 0.
*          MESSAGE 'PURCHASE ORDER IS ALREADY RAISED FOR THIS REQUISITION' TYPE 'I'.
*        ENDIF.
*    ENDIF.
*endif.
*** Below code comment ends 04.10.25
*********    *************************
  IF sy-tcode EQ 'ME21N' OR sy-tcode EQ 'ME22N'.
    IF cht_ekpo-retpo EQ 'X'.
      CLEAR : hsn,hsnl.
      hsn = cht_ekpo-j_1bnbm.
      REPLACE ALL OCCURRENCES OF '.' IN hsn WITH ''.
      CONDENSE hsn NO-GAPS.
      hsnl = strlen( hsn ).
      IF hsnl LT 6.
        MESSAGE 'ENTER MINIMUM 6 DIGIT HSN CODE' TYPE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.

*****************************************

  IF sy-tcode EQ 'ME21N'.
    IF ekko-bsart EQ 'ZUB'.
      SELECT SINGLE * FROM mara WHERE matnr EQ cht_ekpo-ematn.
      IF sy-subrc EQ 0.
        IF mara-bismt NE '                 '.
          MESSAGE e129(pic01) WITH mara-bismt.
        ENDIF.
      ENDIF.
    ENDIF.

    IF tkomv IS NOT INITIAL.
      LOOP AT tkomv WHERE kschl EQ 'JOCM'.
        IF tkomv-kbetr GT 0.
          MESSAGE 'REMOVE OCTROI CONDITION' TYPE 'E'.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDIF.


ENDENHANCEMENT.
