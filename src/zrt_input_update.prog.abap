*&---------------------------------------------------------------------*
*& Report  ZSALESORDER1
*& DEVELOPED BY JYOTSNA FOR UPDATING RATES IN TABLE - ZRT_INPUT
*&---------------------------------------------------------------------*
*&FILE FORMAT SHOULD BE TXT AS PER FOLLOWING
*
*&---------------------------------------------------------------------*

report  zsalesorder13.
tables : kotn532,
         ZRT_INPUT.
* Parameters
* Sales document type




*selection-screen begin of line.
*selection-screen comment 2(20) v_text9 for field p_plant.

*selection-screen end of line.

selection-screen begin of block merkmale1 with frame title text-001.
parameters : p_file type rlgrap-filename.
selection-screen end of block merkmale1 .

DATA : A TYPE I,
      ZRT_INPUT_WA TYPE ZRT_INPUT.

data : p_ship  type kunnr .

types : begin of itab1,
  CHARG TYPE MCHB-CHARG,
  MATNR TYPE MCHB-MATNR,
  RM_RATE TYPE ZRT_INPUT-RM_RATE,
  PM_RATE TYPE ZRT_INPUT-PM_RATE,
  CCPC TYPE ZRT_INPUT-CCPC,
  ED TYPE ZRT_INPUT-ED,
  COGS_CCPC TYPE ZRT_INPUT-COGS_CCPC,
*  P_AUART TYPE AUART,
*  P_VKORG TYPE VKORG,
*  P_VTWEG TYPE VTWEG,
*  P_SPART TYPE SPART,
*  P_SOLD TYPE KUNNR,
*  P_SHIP TYPE KUNNR,
*  P_ITEM TYPE POSNR,
  p_matnr type matnr,
*  P_PLANT TYPE WERKS,
  p_menge type fkimg,
*  p_sch TYPE etenr,
  item_categ type pstyv,
  count type i,
  end of itab1.
data : it_tab1 type table of itab1,
       wa_tab1 type itab1,
       it_tab2 type table of itab1,
       wa_tab2 type itab1.

data : count type i value 1.

* Data declarations.
data: v_vbeln            like vbak-vbeln.
data: header             like bapisdhead1.
data: headerx            like bapisdhead1x.
data: item               like bapisditem  occurs 0 with header line.
data: itemx              like bapisditemx occurs 0 with header line.
data: partner            like bapipartnr  occurs 0 with header line.
data: return             like bapiret2    occurs 0 with header line.
data: lt_schedules_inx   type standard table of bapischdlx
                         with header line.
data: lt_schedules_in    type standard table of bapischdl with header line.


data: c_file type string.
data :  p_item type posnr,
        p_sch type etenr.

data : mesg(40) type c.

types: begin of t_usr05,
        bname type usr05-bname,
        parid type usr05-parid,
        parva type usr05-parva,
      end of t_usr05.

data : wa_usr05 type t_usr05.







at selection-screen on value-request for p_file.
  call function 'F4_FILENAME'
    exporting
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    importing
      file_name     = p_file.

at selection-screen output.
*  select single bname parid parva from usr05 into wa_usr05 where bname = sy-uname and parid = 'ZPLANT'.
*  p_plant = wa_usr05-parva.
*
*  select single bname parid parva from usr05 into wa_usr05 where bname = sy-uname and parid = 'AAT'.
*  if sy-subrc eq 0.
*    p_auart = wa_usr05-parva.
*  else.
*    p_auart = 'ZBDO'.
*  endif.


* Start-of-selection.
start-of-selection.

*  p_item = 10.
*  p_sch = 1.
*
*  p_ship = p_sold.

  c_file = p_file.
  call function 'GUI_UPLOAD'
    exporting
      filename                      = c_file
     filetype                      = 'ASC'
     has_field_separator           = 'X'
*           HEADER_LENGTH                 = 0
*           READ_BY_LINE                  = 'X'
*           DAT_MODE                      = ' '
*           CODEPAGE                      = ' '
*           IGNORE_CERR                   = ABAP_TRUE
*           REPLACEMENT                   = '#'
*           CHECK_BOM                     = ' '
*           VIRUS_SCAN_PROFILE            =
*           NO_AUTH_CHECK                 = ' '
*         IMPORTING
*           FILELENGTH                    =
*           HEADER                        =
    tables
      data_tab                      = it_tab1
   exceptions
     file_open_error               = 1
     file_read_error               = 2
     no_batch                      = 3
     gui_refuse_filetransfer       = 4
     invalid_type                  = 5
     no_authority                  = 6
     unknown_error                 = 7
     bad_data_format               = 8
     header_not_allowed            = 9
     separator_not_allowed         = 10
     header_too_long               = 11
     unknown_dp_error              = 12
     access_denied                 = 13
     dp_out_of_memory              = 14
     disk_full                     = 15
     dp_timeout                    = 16
     others                        = 17
            .
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.
WRITE : / 'FOLLOWING BATCHES ARE UPDATED IN SYSTEM' .
WRITE : /1 'BATCH',12 'PRODUCT CODE', 32 'RM_RATE',42  'PM_RATE',52 'CCPC',62 'ED'.
*72 'COGS_CCPC'.
ULINE.
  loop at it_tab1 into wa_tab1.
FORMAT  COLOR 4.
*    WRITE : / WA_TAB1-CHARG,WA_TAB1-MATNR,32 WA_TAB1-RM_RATE,42 WA_TAB1-PM_RATE,52 WA_TAB1-CCPC,62 WA_TAB1-ED.
*    72 WA_TAB1-COGS_CCPC.
    shift wa_tab1-matnr right deleting trailing space.
    translate wa_tab1-matnr using ' 0'.
    WRITE : WA_TAB1-P_MATNR.
    SELECT SINGLE * FROM ZRT_INPUT WHERE BATCH EQ WA_TAB1-CHARG AND MATNR EQ WA_TAB1-MATNR.
      IF SY-SUBRC EQ 0.
        A = 1.
        WRITE : / WA_TAB1-CHARG,WA_TAB1-MATNR,32 WA_TAB1-RM_RATE,42 WA_TAB1-PM_RATE,52 WA_TAB1-CCPC,62 WA_TAB1-ED.
        ZRT_INPUT_WA-BATCH = WA_TAB1-CHARG.
        ZRT_INPUT_WA-MATNR = WA_TAB1-MATNR.
        ZRT_INPUT_WA-RM_RATE = WA_TAB1-RM_RATE.
        ZRT_INPUT_WA-PM_RATE = WA_TAB1-PM_RATE.
        ZRT_INPUT_WA-CCPC = WA_TAB1-CCPC.
        ZRT_INPUT_WA-ED = WA_TAB1-ED.
        ZRT_INPUT_WA-COGS_CCPC = zrt_input-COGS_CCPC.
        UPDATE ZRT_INPUT FROM ZRT_INPUT_WA.
        CLEAR ZRT_INPUT_WA.
      ENDIF.
  endloop.

IF A EQ 1.
  MESSAGE 'DATA UPDATED' TYPE 'I'.
  EXIT.
ELSE.
  MESSAGE 'BATCH / PRODUCT CODE DOES NOT EXIST' TYPE 'I'.
  EXIT.
ENDIF.
