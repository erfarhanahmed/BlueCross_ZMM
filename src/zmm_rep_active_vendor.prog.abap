*&---------------------------------------------------------------------*
*& Report ZMM_REP_ACTIVE_VENDOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_rep_active_vendor.

TABLES: eord .

TYPES : BEGIN OF ty_final,
          werks     TYPE eord-werks,     "Plant
          name1_wrk TYPE t001w-name1,    "Plant Name
          matnr     TYPE eord-matnr,     "Material
          maktx     TYPE makt-maktx,     "Material Description
          matkl     TYPE mara-matkl,     "Material Group
          wgbez     TYPE t023t-wgbez,    "Material Group Description
          meins     TYPE mara-meins,     "Base Unit
          lifnr     TYPE eord-lifnr,     "Vendor
          name1_vdr TYPE lfa1-name1,     "Vendor Name
          stras_vdr TYPE lfa1-stras,     "Vendor Address
          ort01_vdr TYPE lfa1-ort01,     "Vendor City
          regio_vdr TYPE lfa1-regio,     "Vendor Region
          ematn     TYPE eord-ematn,     "MPN
          man_lifnr TYPE eord-lifnr,     "Manufacturer Code
          man_name1 TYPE lfa1-name1,     "Manufacturer Name
          man_stras TYPE lfa1-stras,     "Manufacturer Address
          man_ort01 TYPE lfa1-ort01,     "Manufacturer City
          man_regio TYPE lfa1-regio,     "Manufacturer Region
          vdatu     TYPE CHAR10,         "eord-vdatu,     "Valid From
          bdatu     TYPE CHAR10,         "eord-bdatu,     "Valid To
          flifn     TYPE eord-flifn,     "Fixed Source
          notkz     TYPE eord-notkz,     "Blocked
          erdat     TYPE eord-erdat,     "Created On
          ernam     TYPE eord-ernam,     "Created By
        END OF ty_final.

DATA: it_Final TYPE TABLE OF ty_final,
      wa_final TYPE ty_final.


SELECT-OPTIONS :s_MATNR FOR eord-matnr ,
                s_WERKS FOR eord-werks ,
                s_lifnr FOR eord-lifnr ,
                s_EMATN FOR eord-ematn ,
                s_BDATU FOR eord-bdatu  .

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv.

START-OF-SELECTION .


  SELECT matnr,
         werks,
         lifnr,
         ematn,
         vdatu,
         meins,
         bdatu,
         flifn,
         notkz,
         erdat,
         ernam
    FROM eord
    INTO TABLE @DATA(it_eord)
     WHERE  matnr  IN  @s_MATNR
      AND   werks  IN  @s_WERKS
      AND   lifnr  IN  @s_lifnr
      AND   ematn  IN  @s_EMATN
      AND   bdatu  IN  @s_BDATU .

  IF  it_eord IS NOT INITIAL .
    SELECT name1 ,
           werks
      FROM t001w
      INTO TABLE @DATA(it_t001w)
      FOR ALL ENTRIES IN @it_eord
      WHERE werks = @it_eord-werks .


    SELECT matnr ,
           maktx
      FROM makt
      INTO TABLE @DATA(it_makt)
      FOR ALL ENTRIES IN @it_eord
      WHERE matnr = @it_eord-matnr .


    SELECT matnr,
           matkl,
           meins
       FROM mara
        INTO  TABLE @DATA(it_mara)
         FOR ALL ENTRIES IN @it_eord
          WHERE matnr = @it_eord-matnr .

    IF it_mara IS NOT INITIAL .

      SELECT wgbez ,
             matkl
        FROM t023t
        INTO TABLE @DATA(it_t023t)
          FOR ALL ENTRIES IN @it_mara
           WHERE  matkl = @it_mara-matkl
           AND    spras = @sy-langu .

    ENDIF.


    SELECT lifnr,
           adrnr ,
           name1 ,
           stras ,
           ort01,
           regio
     FROM lfa1
      INTO TABLE @DATA(it_lfa1)
       FOR ALL ENTRIES IN @it_eord
        WHERE lifnr = @it_eord-lifnr .




    SELECT matnr,
           mfrnr
      FROM mara
      INTO  TABLE @DATA(it_mara1)
       FOR ALL ENTRIES IN @it_eord
        WHERE matnr = @it_eord-ematn .


    IF it_mara1 IS NOT INITIAL .
      SELECT lifnr,
             adrnr,
             name1,
             stras,
             ort01,
             regio
             FROM lfa1
              INTO TABLE @DATA(it_lfa11)
                FOR ALL ENTRIES IN @it_mara1
                  WHERE lifnr = @it_mara1-mfrnr .

    ENDIF.


  ENDIF.



  LOOP AT it_eord INTO DATA(wa_eord).
    wa_final-werks = wa_eord-werks .
    wa_final-matnr = wa_eord-matnr .
    SHIFT wa_final-matnr LEFT DELETING LEADING '0'.

    wa_final-lifnr = wa_eord-lifnr .
    SHIFT wa_final-lifnr LEFT DELETING LEADING '0'.


*    wa_final-vdatu = wa_eord-vdatu  .
    wa_final-vdatu = wa_eord-vdatu+6(2) && '.' && wa_eord-vdatu+4(2) && '.' && wa_eord-vdatu(4).
*    wa_final-bdatu = wa_eord-bdatu  .
    wa_final-bdatu = wa_eord-bdatu+6(2) && '.' && wa_eord-bdatu+4(2) && '.' && wa_eord-bdatu(4).
    wa_final-flifn = wa_eord-flifn  .
    wa_final-notkz = wa_eord-notkz  .
*    wa_final-erdat = wa_eord-erdat  .
    wa_final-erdat = wa_eord-erdat+6(2) && '.' && wa_eord-erdat+4(2) && '.' && wa_eord-erdat(4).
    wa_final-ernam = wa_eord-ernam  .

    wa_Final-ematn = wa_eord-ematn .

    READ TABLE it_t001w INTO DATA(wa_t001w) WITH KEY werks = wa_eord-werks .
    IF sy-subrc EQ 0 .
      wa_final-name1_wrk = wa_t001w-name1 .

    ENDIF.

    READ TABLE it_makt INTO DATA(wa_makt) WITH KEY matnr = wa_eord-matnr .
    IF sy-subrc EQ 0 .
      wa_final-maktx = wa_makt-maktx .

    ENDIF.

    READ TABLE it_mara INTO DATA(wa_mara) WITH KEY matnr = wa_eord-matnr .
    IF sy-subrc EQ 0 .
      wa_Final-matkl = wa_mara-matkl .
      wa_final-meins = wa_mara-meins .

      READ TABLE it_t023t INTO DATA(wa_t023t)  WITH KEY matkl = wa_mara-matkl.
      IF sy-subrc EQ 0 .

        wa_final-wgbez = wa_t023t-wgbez .
      ENDIF.


    ENDIF.

    READ TABLE  it_lfa1 INTO DATA(wa_lfa1) WITH KEY lifnr = wa_eord-lifnr .
    IF sy-subrc EQ 0 .
      wa_Final-name1_vdr = wa_lfa1-name1 .
      wa_Final-stras_vdr = wa_lfa1-stras .
      wa_Final-ort01_vdr = wa_lfa1-ort01 .
      wa_Final-regio_vdr = wa_lfa1-regio .

    ENDIF.

    READ TABLE it_mara1 INTO DATA(wa_mara1)  WITH KEY  matnr = wa_eord-ematn .
    IF sy-subrc EQ 0 .

      READ TABLE it_lfa11 INTO DATA(wa_lfa11) WITH KEY lifnr = wa_mara1-mfrnr .
      IF sy-subrc EQ 0 .

        wa_final-man_lifnr = wa_lfa11-lifnr .
        SHIFT wa_final-man_lifnr
         LEFT DELETING LEADING '0'.
        wa_final-man_name1 = wa_lfa11-name1 .
        wa_final-man_stras = wa_lfa11-stras .
        wa_final-man_ort01 = wa_lfa11-ort01 .
        wa_final-man_regio = wa_lfa11-regio .
      ENDIF.

    ENDIF.

    APPEND wa_final TO it_final .

    CLEAR : wa_final , wa_lfa11, wa_mara1 , wa_lfa1 , wa_t023t , wa_mara , wa_makt , wa_t001w ,wa_eord.

  ENDLOOP.



  PERFORM build_fieldcatalog.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-cprog
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = gt_fieldcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
      i_default          = 'X'
      i_save             = 'A'
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*     O_PREVIOUS_SRAL_HANDLER           =
*     O_COMMON_HUB       =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


FORM build_fieldcatalog .
  CLEAR gt_fieldcat.

  PERFORM add_field USING 'WERKS'     'Plant'                    'IT_FINAL'.
  PERFORM add_field USING 'NAME1_WRK' 'Plant Name'               'IT_FINAL'.
  PERFORM add_field USING 'MATNR'     'Material'                 'IT_FINAL'.
  PERFORM add_field USING 'MAKTX'     'Material Description'     'IT_FINAL'.
  PERFORM add_field USING 'MATKL'     'Material Group'           'IT_FINAL'.
  PERFORM add_field USING 'WGBEZ'     'Material Group Desc'      'IT_FINAL'.
  PERFORM add_field USING 'MEINS'     'Base Unit'                'IT_FINAL'.
  PERFORM add_field USING 'LIFNR'     'Vendor'                   'IT_FINAL'.
  PERFORM add_field USING 'NAME1_VDR' 'Vendor Name'              'IT_FINAL'.
  PERFORM add_field USING 'STRAS_VDR' 'Vendor Address'           'IT_FINAL'.
  PERFORM add_field USING 'ORT01_VDR' 'City'                     'IT_FINAL'.
  PERFORM add_field USING 'REGIO_VDR' 'Region'                   'IT_FINAL'.
  PERFORM add_field USING 'EMATN'     'MPN'                      'IT_FINAL'.
  PERFORM add_field USING 'MAN_LIFNR' 'Manufacturer Code'        'IT_FINAL'.
  PERFORM add_field USING 'MAN_NAME1' 'Manufacturer Name'        'IT_FINAL'.
  PERFORM add_field USING 'MAN_STRAS' 'Manufacturer Address'     'IT_FINAL'.
  PERFORM add_field USING 'MAN_ORT01' 'Manufacturer City'        'IT_FINAL'.
  PERFORM add_field USING 'MAN_REGIO' 'Manufacturer Region'      'IT_FINAL'.
  PERFORM add_field USING 'VDATU'     'Valid From'               'IT_FINAL'.
  PERFORM add_field USING 'BDATU'     'Valid To'                 'IT_FINAL'.
  PERFORM add_field USING 'FLIFN'     'Fixed Source'             'IT_FINAL'.
  PERFORM add_field USING 'NOTKZ'     'Blocked'                  'IT_FINAL'.
  PERFORM add_field USING 'ERDAT'     'Created On'               'IT_FINAL'.
  PERFORM add_field USING 'ERNAM'     'Created By'               'IT_FINAL'.
ENDFORM.

FORM add_field USING p_fieldname TYPE slis_fieldname
                      p_coltext  TYPE scrtext_m
                      p_ref_tab  TYPE tabname.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname     = p_fieldname.
  gs_fieldcat-seltext_m     = p_coltext.
  gs_fieldcat-ref_tabname   = p_ref_tab.
*  gs_fieldcat-outputlen     = 20.   " Default column width
  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.
