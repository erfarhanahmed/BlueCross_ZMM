*&---------------------------------------------------------------------*
*& Report  ZBCLL_COSTING_VIEW
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT ZBCLL_COSTING_VIEW_A11.

SELECTION-SCREEN BEGIN OF BLOCK MERKMALE1 WITH FRAME TITLE TEXT-001.
PARAMETERS : CA RADIOBUTTON GROUP R1,
             C1 RADIOBUTTON GROUP R1,
             C2 RADIOBUTTON GROUP R1,
             C3 RADIOBUTTON GROUP R1,
             c4 RADIOBUTTON GROUP r1.

SELECTION-SCREEN END OF BLOCK MERKMALE1 .

IF CA EQ 'X'.
  CALL TRANSACTION 'ZCOST12'.
ELSEIF C1 EQ 'X'.
  CALL TRANSACTION 'ZCOST10'.
ELSEIF C2 EQ 'X'.
  CALL TRANSACTION 'ZCOST11'.
ELSEIF C3 EQ 'X'.
  CALL TRANSACTION 'ZCOST14'.
ELSEIF C4 EQ 'X'.
  CALL TRANSACTION 'ZCOST16'.
ENDIF.
