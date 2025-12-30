*&---------------------------------------------------------------------*
*& Report ZPO_EMAIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPO_EMAIL.


DATA:ENT_RETCO  TYPE SY-SUBRC,
     ENT_SCREEN TYPE C.
DATA : V_EBELN TYPE EKKO-EBELN,
       XSCREEN TYPE C.
DATA: lv_text           TYPE char50,
      t_att_content_hex TYPE solix_tab,
      fp_formoutput     TYPE fpformoutput,
      wa_kna1           TYPE kna1,
      it_adr6           TYPE TABLE OF adr6,
      wa_adr6           TYPE adr6.
FIELD-SYMBOLS:<NS> TYPE ANY.
DATA:
  lo_send_request TYPE REF TO cl_bcs,
  lo_document     TYPE REF TO cl_document_bcs,
  lo_recipient    TYPE REF TO if_recipient_bcs,
  lt_body_text    TYPE bcsy_text,
  lv_subject      TYPE so_obj_des,
  lv_email_address TYPE ad_smtpadr,
  lv_sent_to_all  TYPE boole_d.
DATA: GV_FM_NAME         TYPE RS38L_FNAM,
      GS_FP_DOCPARAMS    TYPE SFPDOCPARAMS,
      GS_FP_OUTPUTPARAMS TYPE SFPOUTPUTPARAMS.
DATA : GV_FORM_NAME TYPE FPNAME.
START-OF-SELECTION.
*PERFORM entry_neu.
*PERFORM ENTRY_NEU USING ENT_RETCO ENT_SCREEN.
*FORM ENTRY_NEU USING ENT_RETCO ENT_SCREEN.
*FORM ENTRY USING RETURN_CODE LIKE SY-SUBRC
FORM ENTRY_NEU USING RETURN_CODE LIKE SY-SUBRC
                 US_SCREEN   TYPE C.
 DATA:NAST(60) VALUE '(RSNAST00)NAST'.
  DATA : LV_FLAG(1) TYPE C.
  ASSIGN (NAST) TO <NS>.

*  BREAK-POINT .
  IF SY-SUBRC EQ 0.
    ASSIGN COMPONENT 'OBJKY' OF STRUCTURE <NS> TO FIELD-SYMBOL(<OBJ>).
    IF SY-SUBRC EQ 0.
      V_EBELN = <OBJ>.
    ENDIF.
  ENDIF.
  DATA : LV_FNAME TYPE FUNCNAME.
  DATA DOCPARAM TYPE SFPDOCPARAMS.
  DATA : LV_BSART LIKE EKKO-BSART.
  DATA : WA_EKKO LIKE EKKO.
*  GV_FORM_NAME = 'ZF_MM_PO'.
*  gs_fp_outputparams-nodialog = 'X'.
*  gs_fp_outputparams-device = 'PRINTER'.
*  gs_fp_outputparams-dest = 'LP01'.
*  gs_fp_outputparams-getpdf  = 'X'. "space.
*  gs_fp_outputparams-preview = abap_true.
*  CALL FUNCTION 'FP_JOB_OPEN'
*    CHANGING
*      IE_OUTPUTPARAMS = GS_FP_OUTPUTPARAMS
*    EXCEPTIONS
*      CANCEL          = 1
*      USAGE_ERROR     = 2
*      SYSTEM_ERROR    = 3
*      INTERNAL_ERROR  = 4
*      OTHERS          = 5.
*  IF SY-SUBRC <> 0.
*    " Suitable Error Handling
*  ENDIF.
**&---------------------------------------------------------------------*
***&&~~ Get the Function module name based on Form Name
*  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
*    EXPORTING
*      I_NAME     = GV_FORM_NAME
*    IMPORTING
*      E_FUNCNAME = GV_FM_NAME.
*  IF SY-SUBRC <> 0.
*    " Suitable Error Handling
*  ENDIF.
**-----------------------------------------------------------------------------
*
*
*
*
*
*
*
*
*
*  CALL FUNCTION GV_FM_NAME
*    EXPORTING
*      /1BCDWB/DOCPARAMS = GS_FP_DOCPARAMS
*      EBELN             = V_EBELN
*      IMPORTING
*      /1bcdwb/formoutput = fp_formoutput
*    EXCEPTIONS
*      USAGE_ERROR       = 1
*      SYSTEM_ERROR      = 2
*      INTERNAL_ERROR    = 3
*      OTHERS            = 4.
*  IF SY-SUBRC <> 0.
** Implement suitable error handling here
*  ENDIF.
**&---------------------------------------------------------------------*
**&---- Close the spool job
*  CALL FUNCTION 'FP_JOB_CLOSE'
*    EXCEPTIONS
*      USAGE_ERROR    = 1
*      SYSTEM_ERROR   = 2
*      INTERNAL_ERROR = 3
*      OTHERS         = 4.
*  IF SY-SUBRC <> 0.
** <error handling>
*  ENDIF.
*&-------------------------------mail--------------------------------------*
PERFORM convert_pdf_to_binary.
  PERFORM mail_attachment.

*  BREAK-POINT.
  ENDFORM.

FORM convert_pdf_to_binary .
*  CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*    EXPORTING
*      buffer     = fp_formoutput-pdf
*    TABLES
*      binary_tab = t_att_content_hex.
ENDFORM. " CONVERT_PDF_TO_BINARY
FORM mail_attachment.


    DATA: lx_document_bcs TYPE REF TO cx_document_bcs VALUE IS INITIAL.
   TRY.
      " Create send request object
      lo_send_request = cl_bcs=>create_persistent( ).
      " Define email subject
      lv_subject = 'Test Email from ABAP BCS'.
      " Define email body
      APPEND 'Dear Recipient,' TO lt_body_text.
      APPEND ' ' TO lt_body_text.
      APPEND 'This is a test email sent from SAP ABAP using CL_BCS.' TO lt_body_text.
      APPEND ' ' TO lt_body_text.
      APPEND 'Best Regards,' TO lt_body_text.
      APPEND 'Your ABAP Program' TO lt_body_text.
      " Create document object (email content)
      lo_document = cl_document_bcs=>create_document(
        i_type    = 'RAW' " 'RAW' for plain text, 'HTM' for HTML
        i_text    = lt_body_text
        i_subject = lv_subject
      ).

       lv_text = 'PO'.
*  TRY.
*        lo_document->add_attachment(
*        EXPORTING
*        i_attachment_type = 'PDF'
*        i_attachment_subject = lv_text
*        i_att_content_hex = t_att_content_hex ).
*      CATCH cx_document_bcs INTO lx_document_bcs.
*    ENDTRY.
         " Add document to the send request
*      lo_send_request->set_document( lo_document ).
      " Define recipient email address
*      lv_email_address = 'mahadevtemkar85@gmail.com'. " Replace with actual email address
      lv_email_address = 'niraj.chavan@bluecrosslabs.com'. " Replace with actual email address
    DATA:
      lo_sender TYPE REF TO if_sender_bcs VALUE IS INITIAL,
      l_send    TYPE adr6-smtp_addr.
    lo_sender = cl_sapuser_bcs=>create( sy-uname ).
    lo_send_request->set_sender(
    EXPORTING
    i_sender = lo_sender ).
      " Create recipient object (internet address)
     lo_recipient = cl_cam_address_bcs=>create_internet_address( lv_email_address ).

      " Add recipient to the send request
      lo_send_request->add_recipient( i_recipient = lo_recipient ).
      " Set send immediately flag (optional, sends email immediately)
      lo_send_request->set_send_immediately( 'X' ).
      " Send the email
      lv_sent_to_all = lo_send_request->send( i_with_error_screen = 'X' ).
      " Commit work to ensure email is sent
*      COMMIT WORK.
      IF lv_sent_to_all = 'X'.
*        MESSAGE 'Email sent successfully!' TYPE 'S'.
      ELSE.
        MESSAGE 'Error sending email.' TYPE 'E'.
      ENDIF.
    CATCH cx_bcs INTO DATA(lx_bcs_exception).
      " Handle BCS exceptions
      MESSAGE lx_bcs_exception->get_text( ) TYPE 'E'.
  ENDTRY.
ENDFORM.
