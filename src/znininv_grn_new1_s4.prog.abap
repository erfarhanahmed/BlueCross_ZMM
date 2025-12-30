*&---------------------------------------------------------------------*
*& Report ZNININV_GRN_NEW1_S4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZNININV_GRN_NEW1_S4.
*----------------------------------------------------------------------
* Selection screen — preserved from ECC (shape; names can map 1:1)
*----------------------------------------------------------------------
TABLES: t001w.

data: gv_belnr type bkpf-belnr,
      gv_ebeln type ekko-ebeln.

SELECTION-SCREEN BEGIN OF BLOCK b0 WITH FRAME TITLE text-t00.
SELECT-OPTIONS: s_mblnr FOR gv_belnr NO INTERVALS,          "GRN range (MBLNR)
                 s_ebeln FOR gv_ebeln.                       "PO range (optional)
PARAMETERS:      p_mjahr  TYPE mjahr OBLIGATORY,               "Year
                 p_werks  TYPE werks_d OBLIGATORY.             "Plant
SELECTION-SCREEN END OF BLOCK b0.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-t01.
PARAMETERS: r2     RADIOBUTTON GROUP r MODIF ID mm,            "Non-Inventory
            r3     RADIOBUTTON GROUP r DEFAULT 'X' MODIF ID mm,"Inventory (default)
            r5     RADIOBUTTON GROUP r MODIF ID mm.            "PO view (compact)
SELECTION-SCREEN END OF BLOCK b1.

* Language for texts/labels
PARAMETERS: p_spras TYPE sylangu DEFAULT sy-langu.

*----------------------------------------------------------------------
* Normalization hooks (IN): ALPHA/MATN1/NUMC/date/unit
* (Enforce before any SELECT per field_normalization.json)
*----------------------------------------------------------------------
FORM normalize_in.
  "Pad NUMC/ALPHA keys (MBLNR, EBELN, etc.) to internal length
  LOOP AT s_mblnr ASSIGNING FIELD-SYMBOL(<r>).
    <r>-low  = |{ <r>-low  ALPHA = IN }|.
    <r>-high = COND belnr_d( WHEN <r>-high IS INITIAL THEN <r>-high ELSE |{ <r>-high ALPHA = IN }| ).
  ENDLOOP.
  LOOP AT s_ebeln ASSIGNING FIELD-SYMBOL(<p>).
    <p>-low  = |{ <p>-low  ALPHA = IN }|.
    <p>-high = COND ebeln( WHEN <p>-high IS INITIAL THEN <p>-high ELSE |{ <p>-high ALPHA = IN }| ).
  ENDLOOP.
  p_werks = to_upper( p_werks ).  "org scope normalization
ENDFORM.                                ":contentReference[oaicite:5]{index=5}:contentReference[oaicite:6]{index=6}

*----------------------------------------------------------------------
* Data shapes
*----------------------------------------------------------------------
TYPES: BEGIN OF ty_inv_line,            "Inventory (IT_TAB1 for ZMB90_41_10)
         mblnr  TYPE mblnr,
         mjahr  TYPE mjahr,
         zeile  TYPE mblpo,
         ebeln  TYPE ebeln,
         ebelp  TYPE ebelp,
         werks  TYPE werks_d,
         lgort  TYPE lgort_d,
         matnr  TYPE matnr,             "40-char internal; MATN1 applies
         charg  TYPE charg_d,
         meins  TYPE meins,
         erfmg  TYPE erfmg,             "receipt qty
         erfme  TYPE erfme,             "receipt UoM
         sgtxt  TYPE sgtxt,
         prueflos TYPE qprueflos,
         hsdAT  TYPE hsdat,
         vfdAT  TYPE vfdat,
*         licha  TYPE licha,
         licha  TYPE text25,
         knttp  TYPE knttp,
         kostl  TYPE kostl,
       END OF ty_inv_line.

TYPES: BEGIN OF ty_header,
         mblnr TYPE mblnr,  mjahr TYPE mjahr,
         budat TYPE budat,  bldat TYPE bldat,
         xblnr TYPE xblnr1, cputm TYPE cputm, usnam TYPE syuname,
         ebeln TYPE ebeln,  aedat TYPE aedat,
         lifnr TYPE lifnr,  adrnr TYPE adrnr,  "vendor chain
       END OF ty_header.

DATA: gt_inv TYPE STANDARD TABLE OF ty_inv_line WITH EMPTY KEY,
      gs_hdr TYPE ty_header.

*----------------------------------------------------------------------
* START-OF-SELECTION
*----------------------------------------------------------------------
START-OF-SELECTION.
  PERFORM normalize_in.

  IF r3 = abap_true.
    PERFORM fetch_inventory USING p_werks p_mjahr CHANGING gs_hdr gt_inv.
    PERFORM call_form_inventory USING gs_hdr gt_inv.
  ELSEIF r2 = abap_true OR r5 = abap_true.
    PERFORM fetch_noninv    USING p_werks p_mjahr CHANGING gs_hdr gt_inv.
    PERFORM call_form_noninv USING gs_hdr gt_inv.
  ENDIF.

*----------------------------------------------------------------------
* Fetch pipeline — Inventory (tables-only; explicit fields)
*  MKPF kept only for header dates/time; movements from MATDOC in S/4.
*----------------------------------------------------------------------
FORM fetch_inventory  USING    iv_werks TYPE werks_d
                               iv_mjahr TYPE mjahr
                      CHANGING cs_hdr   TYPE ty_header
                               ct_lines TYPE STANDARD TABLE.

  "Primary read: MATDOC (MKPF/MSEG replaced) — key-first by (MBLNR,MJAHR,WERKS)
  SELECT mblnr, mjahr, zeile, ebeln, ebelp, werks, lgort,
         matnr, charg, meins, erfmg, erfme,
         sgtxt, knttp_gr, kostl
    FROM matdoc
    INTO TABLE @DATA(lt_matdoc)
    WHERE mjahr = @iv_mjahr
      AND werks = @iv_werks
      AND mblnr IN @s_mblnr
      AND bwart = '101'.                  "GR for PO (adjust if ECC logic wants others)
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.                                  ":contentReference[oaicite:7]{index=7}:contentReference[oaicite:8]{index=8}

  "Header from MKPF by (MBLNR,MJAHR) — explicit fields only
  READ TABLE lt_matdoc INDEX 1 ASSIGNING FIELD-SYMBOL(<m1>).
  IF <m1> IS ASSIGNED.
    SELECT SINGLE mblnr, mjahr, budat, bldat, xblnr, cputm, usnam
      FROM mkpf
      INTO CORRESPONDING FIELDS OF @cs_hdr
      WHERE mblnr = @<m1>-mblnr AND mjahr = @<m1>-mjahr.
  ENDIF.                                   ":contentReference[oaicite:9]{index=9}

  "PO header (vendor) for address block
  IF <m1> IS ASSIGNED AND <m1>-ebeln IS NOT INITIAL.
    SELECT SINGLE ebeln, aedat, lifnr
      FROM ekko
      INTO (@cs_hdr-ebeln, @cs_hdr-aedat, @cs_hdr-lifnr)
      WHERE ebeln = @<m1>-ebeln.
    "Vendor→ADRC chain (name/address later in enrichment)
    SELECT SINGLE adrnr FROM lfa1 INTO @cs_hdr-adrnr WHERE lifnr = @cs_hdr-lifnr.
  ENDIF.

  "Batch & QM enrichments (minimal deterministic lookups)
  DATA lt_enriched TYPE STANDARD TABLE OF ty_inv_line.
  LOOP AT lt_matdoc ASSIGNING FIELD-SYMBOL(<i>).
    DATA(ls) = VALUE ty_inv_line( mblnr = <i>-mblnr  mjahr = <i>-mjahr  zeile = <i>-zeile
                                  ebeln = <i>-ebeln  ebelp = <i>-ebelp  werks = <i>-werks  lgort = <i>-lgort
                                  matnr = <i>-matnr  charg = <i>-charg  meins = <i>-meins
                                  erfmg = <i>-erfmg  erfme = <i>-erfme  sgtxt = <i>-sgtxt
                                  knttp = <i>-knttp_gr  kostl = <i>-kostl ).

    IF ls-matnr IS NOT INITIAL AND ls-werks IS NOT INITIAL AND ls-charg IS NOT INITIAL.
      SELECT SINGLE hsdAT, vfdAT, licha
        FROM mcha
        INTO (@ls-hsdat, @ls-vfdat, @ls-licha)
        WHERE matnr = @ls-matnr AND werks = @ls-werks AND charg = @ls-charg.
    ENDIF.                                  ":contentReference[oaicite:10]{index=10}

    APPEND ls TO lt_enriched.
  ENDLOOP.

  ct_lines = lt_enriched.

ENDFORM.  "fetch_inventory

*----------------------------------------------------------------------
* Fetch pipeline — Non-Inventory (ZNIV/ZI/ZSER): MATDOC filtered by PO types
*----------------------------------------------------------------------
FORM fetch_noninv USING    iv_werks TYPE werks_d
                           iv_mjahr TYPE mjahr
                  CHANGING cs_hdr   TYPE ty_header
                           ct_lines TYPE STANDARD TABLE.

  SELECT mblnr, mjahr, zeile, ebeln, ebelp, werks, lgort,
         matnr, charg, meins, erfmg, erfme, sgtxt, knttp_gr, kostl
    FROM matdoc
    INTO TABLE @DATA(lt_m)
    WHERE mjahr = @iv_mjahr
      AND werks = @iv_werks
      AND mblnr IN @s_mblnr
      AND bwart = '101'.

  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  "Keep items whose PO header has BSART in ('ZNIV','ZI','ZSER')
  DATA lt_keep TYPE STANDARD TABLE OF ty_inv_line WITH EMPTY KEY.
  LOOP AT lt_m ASSIGNING FIELD-SYMBOL(<m>).
    SELECT SINGLE bsart, aedat, lifnr
      FROM ekko
      INTO @DATA(ls_ekko)
      WHERE ebeln = @<m>-ebeln.
    IF sy-subrc = 0
      AND ( ls_ekko-bsart = 'ZNIV' or
            ls_ekko-bsart = 'ZI' or
            ls_ekko-bsart ='ZSER' ).
      DATA(ls2) = CORRESPONDING ty_inv_line( <m> ).
      APPEND ls2 TO lt_keep.
      "Header (once)
      IF cs_hdr-ebeln IS INITIAL.
        cs_hdr-ebeln = <m>-ebeln.
        cs_hdr-aedat = ls_ekko-aedat.
        cs_hdr-lifnr = ls_ekko-lifnr.
        SELECT SINGLE adrnr FROM lfa1 INTO @cs_hdr-adrnr WHERE lifnr = @cs_hdr-lifnr.
      ENDIF.
    ENDIF.
  ENDLOOP.

  "Header timestamps
  IF line_exists( lt_keep[ 1 ] ).
    data(lv_mblnr) = value #( lt_keep[ 1 ]-mblnr optional ).
    data(lv_mjahr) = value #( lt_keep[ 1 ]-mjahr optional ).
    SELECT SINGLE mblnr, mjahr, budat, bldat, xblnr, cputm, usnam
      FROM mkpf
      INTO CORRESPONDING FIELDS OF @cs_hdr
      WHERE mblnr = @lv_mblnr AND mjahr = @lv_mjahr.
  ENDIF.

  ct_lines = lt_keep.

ENDFORM.  "fetch_noninv

*----------------------------------------------------------------------
* Enrichment (addresses/UoM/currency/texts) — minimal example hooks
*----------------------------------------------------------------------
FORM enrich_header CHANGING cs_hdr TYPE ty_header.
  "Example: address.by_adrnr / country.text if needed (see enrichment_catalog)
  "Keep tables-only; no views/CDS.
ENDFORM.                                   ":contentReference[oaicite:11]{index=11}

*----------------------------------------------------------------------
* Form routing (single driver) and calls
*----------------------------------------------------------------------
FORM call_form_inventory USING is_hdr TYPE ty_header it_tab TYPE STANDARD TABLE.

  DATA: lv_fm TYPE rs38l_fnam.
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING formname = 'ZMB90_41_10'
    IMPORTING fm_name  = lv_fm
    EXCEPTIONS no_form = 1 no_function_module = 2 OTHERS = 3.

  IF sy-subrc = 0.
    PERFORM enrich_header CHANGING is_hdr.
    CALL FUNCTION lv_fm
      EXPORTING  control_parameters = VALUE ssfctrlop( )
                 output_options     = VALUE ssfcompop( )
                 "pass header fields 1:1
      TABLES     it_tab1            = it_tab.   "Inventory lines dataset
  ENDIF.
ENDFORM.

FORM call_form_noninv USING is_hdr TYPE ty_header it_tab TYPE STANDARD TABLE.
  DATA: lv_fm TYPE rs38l_fnam.
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING formname = 'ZMB90_INV2_1'
    IMPORTING fm_name  = lv_fm
    EXCEPTIONS no_form = 1 no_function_module = 2 OTHERS = 3.
  IF sy-subrc = 0.
    PERFORM enrich_header CHANGING is_hdr.
    CALL FUNCTION lv_fm
      EXPORTING  control_parameters = VALUE ssfctrlop( )
                 output_options     = VALUE ssfcompop( )
      TABLES     it_tab1            = it_tab.   "compact lines (reuse shape)
  ENDIF.
ENDFORM.
