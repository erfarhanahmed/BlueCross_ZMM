*&---------------------------------------------------------------------*
*& Report  ZTEST1
*& Developed by Jyotsna
*&---------------------------------------------------------------------*
*&This program will upload / replace rate in MM02 in ACCOUNTING VIEW 2 - COMMERCIAL PRICE1
*&
*&---------------------------------------------------------------------*
report ztest2.
tables : mara,
         mbew.

data: headdata type bapimathead.

data: valdata type  bapi_mbew.
data: valdatax type  bapi_mbewx.
data: return type  bapiret2 .
data: returnm type table of bapi_matreturn2 with header line.
data: xmara type mara.
data : xmbew type mbew.

types : begin of itab1,
          matnr type mara-matnr,
*  P_PLANT TYPE WERKS,
          bwkey type mbew-bwkey,
*  p_sch TYPE etenr,
          bwprh type mbew-bwprh,
*  count type i,
        end of itab1.

data : it_tab1 type table of itab1,
       wa_tab1 type itab1.

data : a type i.

*parameters: p_matnr type mbew-matnr,
*            p_bwkey type mbew-bwkey,
**            p_bwtar type mbew-bwtar,
**            p_stprs type mbew-stprs.
*            p_bwprh type mbew-bwprh.

data: c_file type string.
selection-screen begin of block merkmale1 with frame title text-001.
parameters : p_file type rlgrap-filename.
selection-screen end of block merkmale1.

at selection-screen on value-request for p_file.
  call function 'F4_FILENAME'
    exporting
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    importing
      file_name     = p_file.

start-of-selection.
  c_file = p_file.
  call function 'GUI_UPLOAD'
    exporting
      filename                = c_file
      filetype                = 'ASC'
      has_field_separator     = 'X'
*     HEADER_LENGTH           = 0
*     READ_BY_LINE            = 'X'
*     DAT_MODE                = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     CHECK_BOM               = ' '
*     VIRUS_SCAN_PROFILE      =
*     NO_AUTH_CHECK           = ' '
*         IMPORTING
*     FILELENGTH              =
*     HEADER                  =
    tables
      data_tab                = it_tab1
    exceptions
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      others                  = 17.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.


**************************************************************************************

  loop at it_tab1 into wa_tab1.
    clear : xmara,xmbew.
    shift wa_tab1-matnr right deleting trailing space.
    translate wa_tab1-matnr using ' 0'.
*    select single * from mara into xmara where matnr = wa_tab1-matnr.
*    select single * from mbew into xmbew where matnr = wa_tab1-matnr and bwkey eq wa_tab1-bwkey.
    select single * from mara where matnr = wa_tab1-matnr.
    if sy-subrc eq 0.
      select single * from mbew where matnr = wa_tab1-matnr and bwkey eq wa_tab1-bwkey.
      if sy-subrc eq 0.

        headdata-material        = mara-matnr.
        headdata-ind_sector      = mara-mbrsh.
        headdata-matl_type       = mara-mtart.
        headdata-account_view = 'X'.

        valdata-val_area  = mbew-bwkey.
        valdata-val_type  = mbew-bwtar.
*valdata-std_price = xmbew-stprs.
        valdata-commprice1 = wa_tab1-bwprh.

        valdatax-val_area  = mbew-bwkey.
        valdatax-val_type  = mbew-bwtar.
*valdatax-std_price = 'X'.
        valdatax-commprice1 = 'X'.


        call function 'BAPI_MATERIAL_SAVEDATA'
          exporting
            headdata       = headdata
*           CLIENTDATA     =
*           CLIENTDATAX    =
*           PLANTDATA      =
*           PLANTDATAX     =
*           FORECASTPARAMETERS         =
*           FORECASTPARAMETERSX        =
*           PLANNINGDATA   =
*           PLANNINGDATAX  =
*           STORAGELOCATIONDATA        =
*           STORAGELOCATIONDATAX       =
            valuationdata  = valdata
            valuationdatax = valdatax
*           WAREHOUSENUMBERDATA        =
*           WAREHOUSENUMBERDATAX       =
*           SALESDATA      =
*           SALESDATAX     =
*           STORAGETYPEDATA            =
*           STORAGETYPEDATAX           =
*           FLAG_ONLINE    = ' '
*           FLAG_CAD_CALL  = ' '
*           NO_DEQUEUE     = ' '
*           NO_ROLLBACK_WORK           = ' '
          importing
            return         = return
          tables
*           MATERIALDESCRIPTION        =
*           UNITSOFMEASURE =
*           UNITSOFMEASUREX            =
*           INTERNATIONALARTNOS        =
*           MATERIALLONGTEXT           =
*           TAXCLASSIFICATIONS         =
            returnmessages = returnm.
*   PRTDATA                    =
*   PRTDATAX                   =
*   EXTENSIONIN                =
*   EXTENSIONINX               =
        .
        if sy-subrc eq 0.
          a = 1.
        endif.
      endif.
    endif.
  endloop.
  if a eq 1.
    message 'DATA UPDATED' type 'I'.
  endif.
*****************************************************
*  break-point.
