*&---------------------------------------------------------------------*
*& Report  ZDELIVERY_SCEDULE1
*&
*&---------------------------------------------------------------------*
*&Developed by Jyotsna 4.8.21
*&
*&---------------------------------------------------------------------*
REPORT zdelivery_scedule6.

CLASS lcl_event_handler DEFINITION .
  PUBLIC SECTION .
    METHODS:

*--Double-click control
      handle_double_click
                  FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no.

  PRIVATE SECTION.
ENDCLASS.                    "lcl_event_handler DEFINITION


CLASS lcl_event_handler IMPLEMENTATION .


*--Handle Double Click
  METHOD handle_double_click .
    PERFORM handle_double_click USING e_row e_column es_row_no .
  ENDMETHOD .                    "handle_double_click

ENDCLASS .                    "lcl_event_handler IMPLEMENTATION

TABLES : qals,
         jest,
         mara,
         lfa1,
         ekpo,
         ekko,
         makt,
         qave,
         mseg,
         zmigo,
         eket.

TYPES : BEGIN OF itab1,
          werk       TYPE qals-werk,
          prueflos   TYPE qals-prueflos,
          matnr      TYPE qals-matnr,
          charg      TYPE qals-charg,
          budat      TYPE qals-budat,
          losmenge   TYPE qals-losmenge,
          lmenge01   TYPE qals-lmenge01,
          ebeln      TYPE qals-ebeln,
          ebelp      TYPE qals-ebelp,
          podate     TYPE sy-datum,
          mblnr      TYPE qals-mblnr,
          mjahr      TYPE qals-mjahr,
          lifnr      TYPE lfa1-lifnr,
          udstat(50) TYPE c,
          vdatum     TYPE sy-datum,
          mfgr       TYPE  zmigo-mfgr,
          mfgrname1  TYPE lfa1-name1,
          lmenge04   TYPE qals-lmenge04, "qc rejected stock
        END OF itab1.

TYPES : BEGIN OF itab2,
          werk       TYPE qals-werk,
          prueflos   TYPE qals-prueflos,
          matnr      TYPE qals-matnr,
          charg      TYPE qals-charg,
          budat      TYPE qals-budat,
          podate     TYPE sy-datum,
          losmenge   TYPE qals-losmenge,
          lmenge01   TYPE qals-lmenge01,
          ebeln      TYPE qals-ebeln,
          ebelp      TYPE qals-ebelp,
          poqty      TYPE ekpo-menge,
          mblnr      TYPE qals-mblnr,
          mjahr      TYPE qals-mjahr,
          lifnr      TYPE lfa1-lifnr,
          eindt      TYPE eket-eindt,
          bedat      TYPE eket-bedat,
          wemng      TYPE eket-wemng,
          name1      TYPE lfa1-name1,
          delqty     TYPE ekpo-menge,
          porate(10) TYPE c,
          peinh      TYPE ekpo-peinh,
          maktx      TYPE makt-maktx,
          ort01      TYPE lfa1-ort01,
          udstat(50) TYPE c,
          vdatum     TYPE sy-datum,
          onrejqty   TYPE mseg-menge,
          othrejqty  TYPE mseg-menge,
          block(10)  TYPE c,
          mfgr       TYPE  zmigo-mfgr,
          mfgrname1  TYPE lfa1-name1,
          deldays    TYPE i,
          lmenge04   TYPE qals-lmenge04, "qc rejected stock
        END OF itab2.

DATA: it_qals TYPE TABLE OF qals,
      wa_qals TYPE qals,
      it_eket TYPE TABLE OF eket,
      wa_eket TYPE eket,
      it_mara TYPE TABLE OF mara,
      wa_mara TYPE mara,
      it_ekko TYPE TABLE OF ekko,
      wa_ekko TYPE ekko,
      it_ekpo TYPE TABLE OF ekpo,
      wa_ekpo TYPE ekpo.

DATA: it_tab1 TYPE TABLE OF itab1,
      wa_tab1 TYPE itab1,
      it_tab2 TYPE TABLE OF itab2,
      wa_tab2 TYPE itab2.
DATA: delqty TYPE ekpo-menge.
DATA: eindt TYPE eket-eindt.
DATA: udstat(50) TYPE c,
      uddate     TYPE sy-datum.

DATA : gr_alvgrid    TYPE REF TO cl_gui_alv_grid,
       gr_ccontainer TYPE REF TO cl_gui_custom_container,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layo       TYPE lvc_s_layo.

DATA : t_mat TYPE string.
DATA gr_event_handler TYPE REF TO lcl_event_handler .

DATA : ok_code LIKE sy-ucomm.
DATA: a TYPE i.
*data : t_mat type string.


DATA: lt_variant TYPE disvariant.

SELECTION-SCREEN : BEGIN OF BLOCK blk1 WITH FRAME TITLE text-001.
PARAMETERS : r1 RADIOBUTTON GROUP r1.
SELECT-OPTIONS :
*insp for qals-prueflos,
                 matnr FOR qals-matnr,
                budat FOR qals-budat ,
*                art for qals-art,
                mtart FOR mara-mtart,
                lifnr FOR qals-lifnr.
PARAMETERS : plant LIKE qals-werk .

PARAMETERS : r2 RADIOBUTTON GROUP r1.

SELECTION-SCREEN : END OF BLOCK blk1.



START-OF-SELECTION.

  IF r2 EQ 'X'.
    CALL   TRANSACTION 'ZPO_REJ'.
  ELSE.
    IF budat IS INITIAL.
      MESSAGE 'ENTER DATE' TYPE 'E'.
    ENDIF.
    IF plant IS INITIAL.
      MESSAGE 'ENTER PLANT' TYPE 'E'.
    ENDIF.
    SET SCREEN 100.

    CREATE OBJECT gr_event_handler .
    PERFORM form1.

    PERFORM dis_data.

  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM form1 .
  SELECT * FROM ekko INTO TABLE it_ekko WHERE lifnr IN lifnr AND bedat IN budat.
  IF sy-subrc EQ 0.
    SELECT * FROM ekpo INTO TABLE it_ekpo FOR ALL ENTRIES IN it_ekko WHERE ebeln EQ it_ekko-ebeln AND werks EQ plant AND matnr IN matnr..
    IF sy-subrc EQ 0.
      SELECT * FROM qals INTO TABLE it_qals FOR ALL ENTRIES IN it_ekpo WHERE werk EQ plant  AND matnr EQ it_ekpo-matnr AND
         ebeln EQ it_ekpo-ebeln AND ebelp EQ it_ekpo-ebelp.
      IF sy-subrc EQ 0.
        SELECT * FROM mara INTO TABLE it_mara FOR ALL ENTRIES IN it_qals WHERE matnr EQ it_qals-matnr AND mtart IN mtart.
      ENDIF.
    ENDIF.
  ENDIF.

  IF it_qals  IS INITIAL.
    MESSAGE 'NO DATA FOUND' TYPE 'E'.
  ENDIF.



  LOOP AT it_qals INTO wa_qals.
    SELECT SINGLE * FROM jest WHERE objnr EQ wa_qals-objnr AND stat EQ 'I0224'.
    IF sy-subrc EQ 4.
      READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_qals-matnr.
      IF sy-subrc EQ 0.
*    write : / wa_qals-werk,wa_qals-prueflos,wa_qals-matnr,wa_qals-charg,wa_qals-budat,wa_qals-EBELN,wa_qals-EBELP,wa_qals-MBKNR,wa_qals-MJAHR.
        wa_tab1-werk = wa_qals-werk.
        wa_tab1-prueflos = wa_qals-prueflos.
        CLEAR : udstat,uddate.
        SELECT SINGLE * FROM qave WHERE prueflos EQ wa_qals-prueflos .
        IF sy-subrc EQ 0.
          uddate = qave-vdatum.
          IF qave-vcode EQ 'A'.
            udstat = 'ACCEPTED'.
          ELSEIF qave-vcode EQ 'PA'.
            udstat = 'PARTLY ACCEPTED'.
          ELSEIF qave-vcode EQ 'R'.
            udstat = 'REJECTED'.
          ENDIF.
        ENDIF.
        wa_tab1-udstat = udstat.
        wa_tab1-vdatum = uddate.
        wa_tab1-matnr = wa_qals-matnr.
        wa_tab1-charg = wa_qals-charg.
        wa_tab1-budat = wa_qals-budat.
        wa_tab1-losmenge = wa_qals-losmenge.
        wa_tab1-lmenge01 = wa_qals-lmenge01.
        wa_tab1-lmenge04 = wa_qals-lmenge04.
        wa_tab1-ebeln = wa_qals-ebeln.
        READ TABLE it_ekko INTO wa_ekko WITH KEY ebeln = wa_qals-ebeln.
        IF sy-subrc EQ 0.
          wa_tab1-podate = wa_ekko-bedat.
        ENDIF.
        wa_tab1-lifnr = wa_qals-lifnr.
        wa_tab1-ebelp = wa_qals-ebelp.
        wa_tab1-mblnr = wa_qals-mblnr.
        wa_tab1-mjahr = wa_qals-mjahr.
        SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_tab1-mblnr AND mjahr EQ wa_tab1-mjahr AND zeile EQ wa_qals-zeile.
        IF sy-subrc EQ 0.
          wa_tab1-mfgr = zmigo-mfgr.
        ENDIF.
        IF wa_tab1-mfgr EQ space.
          SELECT SINGLE * FROM zmigo WHERE mblnr EQ wa_tab1-mblnr AND mjahr EQ wa_tab1-mjahr.
          IF sy-subrc EQ 0.
            wa_tab1-mfgr = zmigo-mfgr.
          ENDIF.
        ENDIF.
        SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_tab1-mfgr.
        IF sy-subrc EQ 0.
          wa_tab1-mfgrname1 = lfa1-name1.
        ENDIF.
        COLLECT wa_tab1 INTO it_tab1.
        CLEAR wa_tab1.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF it_tab1 IS NOT INITIAL.
    SELECT * FROM eket INTO TABLE it_eket FOR ALL ENTRIES IN it_tab1 WHERE ebeln EQ it_tab1-ebeln AND ebelp EQ it_tab1-ebelp
      AND wemng GT 0.
  ENDIF.
  SORT it_tab1 BY ebeln ebelp  budat mblnr.
  LOOP AT it_tab1 INTO wa_tab1.
*  write : / wa_tab1-werk,wa_tab1-prueflos,wa_tab1-matnr,wa_tab1-charg,wa_tab1-losmenge,'resc dt',wa_tab1-budat,wa_tab1-ebeln,wa_tab1-ebelp,
*  wa_tab1-mblnr,wa_tab1-mjahr,wa_tab1-lifnr.
    wa_tab2-werk = wa_tab1-werk.
    wa_tab2-prueflos = wa_tab1-prueflos.
    wa_tab2-udstat = wa_tab1-udstat.
    wa_tab2-vdatum = wa_tab1-vdatum.
    wa_tab2-matnr = wa_tab1-matnr.
    SELECT SINGLE * FROM makt WHERE matnr EQ wa_tab1-matnr AND spras EQ 'EN'.
    IF sy-subrc EQ 0.
      wa_tab2-maktx = makt-maktx.
    ENDIF.
    wa_tab2-charg = wa_tab1-charg.
    SELECT SINGLE * FROM mseg WHERE bwart EQ '344' AND werks EQ wa_tab1-werk AND matnr EQ wa_tab1-matnr AND charg EQ wa_tab1-charg AND grund EQ '0001'.
    IF sy-subrc EQ 0.
      wa_tab2-onrejqty = mseg-menge.
    ENDIF.
    SELECT SINGLE * FROM mseg WHERE bwart EQ '344' AND werks EQ wa_tab1-werk AND matnr EQ wa_tab1-matnr AND charg EQ wa_tab1-charg AND grund NE '0001'.
    IF sy-subrc EQ 0.
      wa_tab2-othrejqty = mseg-menge.
    ENDIF.
    wa_tab2-mfgr = wa_tab1-mfgr.
    wa_tab2-mfgrname1 = wa_tab1-mfgrname1.
    wa_tab2-losmenge = wa_tab1-losmenge.
    wa_tab2-lmenge01 = wa_tab1-lmenge01.
    wa_tab2-lmenge04 = wa_tab1-lmenge04.
    wa_tab2-budat = wa_tab1-budat.
    wa_tab2-ebeln = wa_tab1-ebeln.
    wa_tab2-podate = wa_tab1-podate.
    wa_tab2-ebelp = wa_tab1-ebelp.
    wa_tab2-mblnr = wa_tab1-mblnr.
    wa_tab2-mjahr = wa_tab1-mjahr.
    wa_tab2-lifnr = wa_tab1-lifnr.
    SELECT SINGLE * FROM lfa1 WHERE lifnr EQ wa_tab1-lifnr.
    IF sy-subrc EQ 0.
      wa_tab2-name1 = lfa1-name1.
      wa_tab2-ort01 = lfa1-ort01.
      IF lfa1-sperr EQ 'X' AND lfa1-sperm EQ 'X' AND lfa1-sperq EQ '99'.
        wa_tab2-block = 'BLOCKED'.
      ENDIF.
    ENDIF.
    CLEAR : a.
    ON CHANGE OF wa_tab1-ebeln.
      a = 1.
    ENDON.
    ON CHANGE OF wa_tab1-ebelp.
      a = 1.
    ENDON.
    IF a EQ 1.
      READ TABLE it_ekpo INTO wa_ekpo WITH KEY ebeln = wa_tab1-ebeln ebelp = wa_tab1-ebelp.
      IF sy-subrc EQ 0.
        wa_tab2-poqty = wa_ekpo-menge.
        wa_tab2-porate = wa_ekpo-netpr.
        wa_tab2-peinh = wa_ekpo-peinh.
      ENDIF.
    ENDIF.
    READ TABLE it_eket INTO wa_eket WITH KEY ebeln = wa_tab1-ebeln ebelp = wa_tab1-ebelp.
    IF sy-subrc EQ 0.
      CLEAR : delqty.
      wa_tab2-eindt = wa_eket-eindt.
      wa_tab2-bedat = wa_eket-bedat.
      wa_tab2-wemng = wa_eket-menge.
*        if wa_tab1-losmenge ge wa_eket-wemng.
*      delqty = wa_eket-wemng.
      DELETE it_eket WHERE ebeln = wa_eket-ebeln AND ebelp = wa_eket-ebelp AND etenr = wa_eket-etenr.
*        else.
*          delqty = wa_tab1-losmenge.
*          wa_eket-wemng = wa_eket-wemng - wa_tab1-losmenge.
*          modify it_eket from wa_eket transporting wemng where ebeln = wa_eket-ebeln and ebelp = wa_eket-ebelp and etenr = wa_eket-etenr.
*          clear : wa_eket.
*        endif.
*      wa_tab2-delqty = delqty.
    ENDIF.
*    endif.
    WRITE : / wa_tab2-ebeln,wa_tab2-ebelp,wa_tab2-eindt,wa_tab2-budat.
    CLEAR : eindt.
    IF wa_tab2-eindt EQ 0.
      SELECT  SINGLE * FROM eket WHERE ebeln = wa_tab2-ebeln AND ebelp = wa_tab2-ebelp.
      IF sy-subrc EQ 0.
        eindt = eket-eindt.
      ENDIF.
      wa_tab2-eindt = eindt.
    ELSE.
      eindt = wa_tab2-eindt.
    ENDIF.

    wa_tab2-deldays = wa_tab2-budat - eindt.
    CLEAR : delqty.

    COLLECT wa_tab2 INTO it_tab2.
    CLEAR wa_tab2.
  ENDLOOP.

  SORT it_tab2 BY ebeln ebelp  budat mblnr.
  LOOP AT it_tab2 INTO wa_tab2.
    PACK wa_tab2-matnr TO wa_tab2-matnr.
    PACK wa_tab2-lifnr TO wa_tab2-lifnr.

    CONDENSE wa_tab2-matnr.
    CONDENSE wa_tab2-lifnr.
    MODIFY it_tab2 FROM wa_tab2 TRANSPORTING matnr lifnr.

*    write : / wa_tab2-werk,wa_tab2-prueflos,wa_tab2-matnr,wa_tab2-charg,wa_tab2-losmenge,'resc dt',wa_tab2-budat,wa_tab2-ebeln,wa_tab2-ebelp,
*     wa_tab2-mblnr,wa_tab2-mjahr,wa_tab2-lifnr,wa_tab2-name1,wa_tab2-eindt,wa_tab2-bedat,wa_tab2-wemng.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_E_ROW  text
*      -->P_E_COLUMN  text
*      -->P_ES_ROW_NO  text
*----------------------------------------------------------------------*
FORM handle_double_click USING i_row TYPE lvc_s_row
                               i_column TYPE lvc_s_col
                               is_row_no TYPE lvc_s_roid.

  READ TABLE it_tab2 INTO wa_tab2 INDEX is_row_no-row_id .

  IF sy-subrc = 0 .
    IF i_column = 'PRUEFLOS'.
*      t_mat = wa_tab2-PRUEFLOS.
*      PERFORM update.
      SET PARAMETER ID 'QLS' FIELD wa_tab2-prueflos.
      CALL TRANSACTION 'QA03' AND SKIP FIRST SCREEN.
      SET PARAMETER ID 'QLS' FIELD space.

    ELSEIF i_column = 'MBLNR'.

      SET PARAMETER ID 'MBN' FIELD wa_tab2-mblnr.
      CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.
      SET PARAMETER ID 'MBN' FIELD space.

    ELSEIF i_column = 'EBELN'.

      SET PARAMETER ID 'BES' FIELD wa_tab2-ebeln.
      CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
      SET PARAMETER ID 'BES' FIELD space.

    ENDIF .
  ENDIF.
ENDFORM .                    "handle_double_click
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS'.
  SET TITLEBAR 'xxx'.

*  ok_code = sy-ucomm.
*
  CASE ok_code.
    WHEN 'BACK' .
*      if sy-subrc eq 4.
*        call transaction 'ZPO_DEL'.
*      ELSE.
*         leave to screen 0.
*      endif.
      LEAVE TO SCREEN 0.
*      set SCREEN 0.
*      leave program.
  ENDCASE.
  CLEAR : ok_code.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  ok_code = sy-ucomm.

  CASE ok_code.
    WHEN 'BACK' OR 'UP' OR 'CANC'.
*      call TRANSACTION 'ZPO_DEL'.
      LEAVE TO SCREEN 0.
*      set SCREEN 0.
*      leave program.
  ENDCASE.
  CLEAR : ok_code.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Form  DIS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dis_data .
  IF gr_alvgrid IS INITIAL.

    CREATE OBJECT gr_ccontainer
      EXPORTING
        container_name              = 'CC_ALV'
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    CREATE OBJECT gr_alvgrid
      EXPORTING
*       i_parent          = gr_ccontainer
        i_parent          = cl_gui_custom_container=>screen0
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.
    IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    PERFORM create_fcat CHANGING gt_fcat.

    PERFORM create_layout CHANGING gs_layo.

    lt_variant-report = sy-repid.
*    lt_variant-username = sy-uname.
*    lt_variant-handle = 'GRID'.


    CALL METHOD gr_alvgrid->set_table_for_first_display
      EXPORTING
*       I_BUFFER_ACTIVE =
*       I_BYPASSING_BUFFER            =
*       I_CONSISTENCY_CHECK           =
*       I_STRUCTURE_NAME  =
        is_variant      = lt_variant
        i_save          = 'X'
*       i_default       = 'X'
        is_layout       = gs_layo
*       IS_PRINT        =
*       IT_SPECIAL_GROUPS =
*       IT_TOOLBAR_EXCLUDING          =
*       IT_HYPERLINK    =
*       IT_ALV_GRAPHICS =
*       IT_EXCEPT_QINFO =
*       IR_SALV_ADAPTER =
      CHANGING
        it_outtab       = it_tab2
        it_fieldcatalog = gt_fcat
*       IT_SORT         =
*       IT_FILTER       =
*      EXCEPTIONS
*       INVALID_PARAMETER_COMBINATION = 1
*       PROGRAM_ERROR   = 2
*       TOO_MANY_LINES  = 3
*       others          = 4
      .
    IF sy-subrc <> 0.
*     MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    SET HANDLER gr_event_handler->handle_double_click FOR gr_alvgrid .

  ENDIF.
*  CLEAR : IT_TAB2,WA_TAB2.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FCAT  text
*----------------------------------------------------------------------*
FORM create_fcat  CHANGING pt_fcat TYPE lvc_t_fcat.

  DATA : ls_fcat TYPE lvc_s_fcat.

*   loop at it_tab2 into wa_tab2.
*    write : / wa_tab2-werk,wa_tab2-prueflos,wa_tab2-matnr,wa_tab2-charg,wa_tab2-losmenge,'resc dt',wa_tab2-budat,wa_tab2-ebeln,wa_tab2-ebelp,
*     wa_tab2-mblnr,wa_tab2-mjahr,wa_tab2-lifnr,wa_tab2-name1,wa_tab2-eindt,wa_tab2-bedat,wa_tab2-wemng.
*  endloop.

  ls_fcat-fieldname = 'PODATE'.
  ls_fcat-coltext = 'PO DATE'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'EBELN'.
  ls_fcat-coltext = 'PO'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.


  ls_fcat-fieldname = 'EBELP'.
  ls_fcat-coltext = 'PO ITEM'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'POQTY'.
  ls_fcat-coltext = 'PO QUANTITY'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'PORATE'.
  ls_fcat-coltext = 'PO RATE'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'PEINH'.
  ls_fcat-coltext = 'PO RATE PER'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'EINDT'.
  ls_fcat-coltext = 'DEL SCEDULE DATE'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'WEMNG'.
  ls_fcat-coltext = 'DEL SCEDULE QTY'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'MBLNR'.
  ls_fcat-coltext = 'GRN NO.'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'BUDAT'.
  ls_fcat-coltext = 'GRN DATE'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'DELDAYS'.
  ls_fcat-coltext = 'DELAY IN DAYS'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'LOSMENGE'.
  ls_fcat-coltext = 'INSPECTION QTY'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'CHARG'.
  ls_fcat-coltext = 'I.D./BATCH'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'MATNR'.
  ls_fcat-coltext = 'MATERIAL CODE'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'MAKTX'.
  ls_fcat-coltext = 'MATERIAL NAME'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'PRUEFLOS'.
  ls_fcat-coltext = 'INSPECTION LOT'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'UDSTAT'.
  ls_fcat-coltext = 'UD STATUS'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'VDATUM'.
  ls_fcat-coltext = 'UD DATE'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'LMENGE01'.
  ls_fcat-coltext = 'RELEASED QTY'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'LMENGE04'.
  ls_fcat-coltext = 'QC REJECTED QTY'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'ONREJQTY'.
  ls_fcat-coltext = 'ONLINE REJECTION'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'OTHREJQTY'.
  ls_fcat-coltext = 'OTHER REJECTION'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'WERK'.
  ls_fcat-coltext = 'PLANT'.
*  ls_fcat-outputlen = '5'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'LIFNR'.
  ls_fcat-coltext = 'SUPPLIER CODE'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'NAME1'.
  ls_fcat-coltext = 'SUPPLIER NAME'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'ORT01'.
  ls_fcat-coltext = 'SUPPLIER PLACE'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'BLOCK'.
  ls_fcat-coltext = 'SUPPLIER STATUS'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'MFGR'.
  ls_fcat-coltext = 'MFGR CODE'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.

  ls_fcat-fieldname = 'MFGRNAME1'.
  ls_fcat-coltext = 'MANUFACTURER NAME'.
  APPEND ls_fcat TO pt_fcat.
  CLEAR ls_fcat.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CREATE_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GS_LAYO  text
*----------------------------------------------------------------------*
FORM create_layout  CHANGING ps_layo TYPE lvc_s_layo.

  ps_layo-zebra = 'X'.
ENDFORM.                    " create_layout
