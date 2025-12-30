*&---------------------------------------------------------------------*
*& Report ZMM_VENDDLRES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMM_VENDDLRES.
*--------------------------------------------------------------------*
* Type Declaration
*--------------------------------------------------------------------*
TYPES: BEGIN OF TY_DATA,
         LIFNR  TYPE LIFNR,
         NAME1  TYPE LFA1-NAME1,
         SPERR  TYPE LFM1-SPERM,
         REASON TYPE ZTB_VENDRES-REASON,
         CRDAT  TYPE CRDAT,
         CRNAM  TYPE CRNAM,
         AEDAT  TYPE AEDAT,
         AENAM  TYPE AENNM,
       END OF TY_DATA.

DATA: GT_DATA   TYPE TABLE OF TY_DATA,
      GT_FCAT   TYPE LVC_T_FCAT,
      GS_FCAT   TYPE LVC_S_FCAT,
      GS_LAYOUT TYPE LVC_S_LAYO,
      GR_CONT   TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      GR_GRID   TYPE REF TO CL_GUI_ALV_GRID.

DATA GV_OKCODE TYPE SY-UCOMM.
DATA: GV_LIFNR   TYPE LFA1-LIFNR,
      gt_VENDRES TYPE STANDARD TABLE OF ZTB_VENDRES.

SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-T01.
  SELECT-OPTIONS: S_LIFNR FOR GV_LIFNR.

  SELECTION-SCREEN: BEGIN OF BLOCK B2 WITH FRAME.
    PARAMETERS: P_RB1 RADIOBUTTON GROUP RBG DEFAULT 'X',
                P_RB2 RADIOBUTTON GROUP RBG,
                P_RB3 RADIOBUTTON GROUP RBG,
                P_RB4 RADIOBUTTON GROUP RBG.
  SELECTION-SCREEN: END OF BLOCK B2.
SELECTION-SCREEN: END OF BLOCK B1.


START-OF-SELECTION.
  PERFORM READ_DATA.
  PERFORM BUILD_FIELDCAT.
  CALL SCREEN 0100.
*  PERFORM BUILD_FIELDCAT.
*  PERFORM DISPLAY_ALV.
*&---------------------------------------------------------------------*
*& Form READ_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM READ_DATA .
  CLEAR: gt_Data, gt_VENDRES.
  SELECT A~LIFNR,
         B~NAME1,
         A~SPERM,
         C~REASON,
         C~CRDAT,
         C~CRNAM,
         C~AEDAT,
         C~AENAM
   FROM LFM1 AS A
   INNER JOIN LFA1 AS B ON A~LIFNR = B~LIFNR
   LEFT OUTER JOIN ZTB_VENDRES AS C ON A~LIFNR = C~LIFNR

   WHERE A~SPERM = 'X'
     AND A~LIFNR IN @S_LIFNR
*     AND ( C~REASON IS INITIAL OR C~LIFNR IS INITIAL )
    INTO TABLE @GT_DATA.

  IF GT_DATA IS NOT INITIAL.
    SORT gt_Data BY LIFNR.
    SELECT * FROM ZTB_VENDRES
           FOR ALL ENTRIES IN @GT_DATA
               WHERE LIFNR = @GT_DATA-LIFNR
               INTO TABLE @GT_VENDRES.
    SORT GT_VENDRES BY LIFNR.

  ENDIF.

* Data massaging
  IF P_RB1 IS NOT INITIAL.          "Display Deletion flag  Vendor List pending for reason
    LOOP AT GT_VENDRES INTO DATA(LS_VENDRES).
      DELETE GT_DATA WHERE LIFNR = LS_VENDRES-LIFNR.
    ENDLOOP.

  ELSEIF  P_RB2 IS NOT INITIAL.     "Display Deletion flag  Vendor List where reason text is blank
    DELETE gt_Data WHERE REASON IS NOT INITIAL.

  ELSEIF  P_RB3 IS NOT INITIAL.     "Deletion flag  Vendor List Change Text
    DELETE gt_Data WHERE REASON IS INITIAL.
  ELSEIF  P_RB4 IS NOT INITIAL.     "Display Deletion flag  Vendor List With Reason
    DELETE gt_Data WHERE REASON IS INITIAL.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV .
  DATA: LT_EXCL    TYPE UI_FUNCTIONS,
        GS_VARIANT TYPE DISVARIANT.

  IF GR_CONT IS INITIAL.
    CREATE OBJECT GR_CONT
      EXPORTING
        CONTAINER_NAME = 'CC_ALV'.

    CREATE OBJECT GR_GRID
      EXPORTING
        I_PARENT = GR_CONT.



    " Hook events (you already have lcl_events)
*    IF GO_EVENTS IS INITIAL.
*      CREATE OBJECT GO_EVENTS.
*    ENDIF.
*    gs_layout-edit = abap_true.
    " Exclude row-creation/deletion (and clipboard) functions
    LT_EXCL = VALUE UI_FUNCTIONS(
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_APPEND_ROW     )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_INSERT_ROW     )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_DELETE_ROW     )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_MOVE_ROW       )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_COPY_ROW       )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_CUT            )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE          )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_PASTE_NEW_ROW )
*      ( cl_gui_alv_grid=>mc_fc_loc_paste_new_rows )
      ( CL_GUI_ALV_GRID=>MC_FC_LOC_UNDO           )
    ).


    CALL METHOD GR_GRID->SET_TABLE_FOR_FIRST_DISPLAY
      EXPORTING
        IS_LAYOUT            = GS_LAYOUT
        IT_TOOLBAR_EXCLUDING = LT_EXCL    " <— disables create/add/delete/etc.
      CHANGING
        IT_FIELDCATALOG      = GT_FCAT
        IT_OUTTAB            = GT_DATA.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form build_fieldcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM BUILD_FIELDCAT .
  CLEAR GS_FCAT.
  GS_FCAT-FIELDNAME = 'LIFNR'.
  GS_FCAT-SCRTEXT_L = 'Vendor'.
  GS_FCAT-KEY       = 'X'.
  GS_FCAT-OUTPUTLEN       = 10.
  APPEND GS_FCAT TO GT_FCAT.

  CLEAR GS_FCAT.
  GS_FCAT-FIELDNAME = 'NAME1'.
  GS_FCAT-SCRTEXT_L = 'Vendor Name'.
  GS_FCAT-OUTPUTLEN       = 35.
  APPEND GS_FCAT TO GT_FCAT.

  CLEAR GS_FCAT.
  GS_FCAT-FIELDNAME = 'SPERR'.
  GS_FCAT-SCRTEXT_L = 'Blocked'.
  GS_FCAT-OUTPUTLEN       = 6.
  APPEND GS_FCAT TO GT_FCAT.

  IF P_RB1 IS INITIAL.
    CLEAR GS_FCAT.
    GS_FCAT-FIELDNAME = 'REASON'.
    GS_FCAT-SCRTEXT_L = 'Reason'.
    GS_FCAT-LOWERCASE = 'X'.
    IF P_RB2 IS NOT INITIAL OR P_RB3 IS NOT INITIAL.
      GS_FCAT-EDIT      = 'X'.
    ENDIF.
    GS_FCAT-OUTPUTLEN       = 50.
    APPEND GS_FCAT TO GT_FCAT.
  ENDIF.

  IF P_RB4 IS NOT INITIAL.
    CLEAR GS_FCAT.
    GS_FCAT-FIELDNAME = 'CRDAT'.
    GS_FCAT-SCRTEXT_L = 'Created On'.
    GS_FCAT-OUTPUTLEN       = 10.
    APPEND GS_FCAT TO GT_FCAT.

    CLEAR GS_FCAT.
    GS_FCAT-FIELDNAME = 'CRNAM'.
    GS_FCAT-SCRTEXT_L = 'Created By'.
    GS_FCAT-OUTPUTLEN       = 15.
    APPEND GS_FCAT TO GT_FCAT.

    CLEAR GS_FCAT.
    GS_FCAT-FIELDNAME = 'AEDAT'.
    GS_FCAT-SCRTEXT_L = 'Changed On'.
    GS_FCAT-OUTPUTLEN       = 10.
    APPEND GS_FCAT TO GT_FCAT.

    CLEAR GS_FCAT.
    GS_FCAT-FIELDNAME = 'AENAM'.
    GS_FCAT-SCRTEXT_L = 'Changed By'.
    GS_FCAT-OUTPUTLEN       = 15.
    APPEND GS_FCAT TO GT_FCAT.
  ENDIF.

ENDFORM.

*--------------------------------------------------------------------*
*  SCREEN 0100 PBO
*--------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
  IF P_RB2 IS NOT INITIAL OR P_RB3 IS NOT INITIAL.
    SET PF-STATUS 'MAIN'.
  ELSE.
    SET PF-STATUS 'MAIN' EXCLUDING 'SAVE'.
  ENDIF.
  SET TITLEBAR 'T01'.

  PERFORM DISPLAY_ALV.

ENDMODULE.

*--------------------------------------------------------------------*
*  SCREEN 0100 PAI
*--------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CASE SY-UCOMM.
    WHEN 'SAVE'.
      PERFORM SAVE_SELECTED.
    WHEN 'BACK'.
      IF GR_GRID IS BOUND.
        GR_GRID->FREE( ).
        FREE GR_GRID.
      ENDIF.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.



*--------------------------------------------------------------------*
* Save only selected vendors
*--------------------------------------------------------------------*
FORM SAVE_SELECTED.

  DATA LT_ROWS TYPE LVC_T_ROW.
  DATA LS_VENDRES TYPE ZTB_VENDRES.

  CALL METHOD GR_GRID->CHECK_CHANGED_DATA.
  CALL METHOD GR_GRID->GET_SELECTED_ROWS
    IMPORTING
      ET_INDEX_ROWS = LT_ROWS.

  IF LT_ROWS IS INITIAL.
    MESSAGE 'No rows selected for saving.' TYPE 'I'.
    RETURN.
  ENDIF.

  LOOP AT LT_ROWS INTO DATA(LS_ROW).
    READ TABLE GT_DATA INDEX LS_ROW-INDEX ASSIGNING FIELD-SYMBOL(<FS_DATA>).
    IF SY-SUBRC <> 0 OR <FS_DATA> IS INITIAL.
      CONTINUE.
    ENDIF.

    IF <FS_DATA>-REASON IS INITIAL.
      MESSAGE |Reason missing for vendor { <FS_DATA>-LIFNR }| TYPE 'E'.
      CONTINUE.
    ENDIF.

    " Check if record exists
    READ TABLE gT_vendres INTO DATA(LS_temp) WITH KEY LIFNR = <FS_DATA>-LIFNR BINARY SEARCH.
    IF SY-SUBRC = 0.
      UPDATE ZTB_VENDRES
        SET REASON = @<FS_DATA>-REASON,
            NAME1  = @<FS_DATA>-NAME1,
            AEDAT = @SY-DATUM,
            AENAM = @SY-UNAME
      WHERE LIFNR = @<FS_DATA>-LIFNR.
    ELSE.
      LS_VENDRES-MANDT  = SY-MANDT.
      LS_VENDRES-LIFNR  = <FS_DATA>-LIFNR.
      LS_VENDRES-NAME1  = <FS_DATA>-NAME1.
      LS_VENDRES-REASON = <FS_DATA>-REASON.

      LS_VENDRES-CRDAT = SY-DATUM.
      LS_VENDRES-CRNAM = SY-UNAME.
      LS_VENDRES-AEDAT = SY-DATUM.
      LS_VENDRES-AENAM = SY-UNAME.
      INSERT ZTB_VENDRES FROM LS_VENDRES.
    ENDIF.
    CLEAR: LS_TEMP.
  ENDLOOP.

  COMMIT WORK.
  MESSAGE 'Selected vendors updated successfully' TYPE 'S'.
ENDFORM.
