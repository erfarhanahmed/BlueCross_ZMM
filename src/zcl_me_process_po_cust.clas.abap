class ZCL_ME_PROCESS_PO_CUST definition
  public
  final
  create public .

*"* public components of class CL_EXM_IM_ME_PROCESS_PO_CUST
*"* do not include other source files here!!!
public section.
  type-pools MMMFD .

  interfaces IF_EX_ME_PROCESS_PO_CUST .
protected section.
*"* protected components of class CL_EXM_IM_ME_PROCESS_PO_CUST
*"* do not include other source files here!!!
private section.
*"* private components of class CL_EXM_IM_ME_PROCESS_PO_CUST
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_ME_PROCESS_PO_CUST IMPLEMENTATION.


METHOD if_ex_me_process_po_cust~check .

*    " Reference variable for header
*  DATA: lo_header  TYPE REF TO if_purchase_order_mm,
*        ls_header  TYPE mepoheader.
*
*  " Get header handle
*  lo_header = im_header.
*
*  " Get header data
*  IF lo_header IS BOUND.
*    ls_header = lo_header->get_data( ).
*  ENDIF.


ENDMETHOD.                    "IF_EX_ME_PROCESS_PO_CUST~CHECK


METHOD if_ex_me_process_po_cust~close .

* close customer data
  CALL FUNCTION 'MEPOBADIEX_INIT'.

ENDMETHOD.                    "IF_EX_ME_PROCESS_PO_CUST~CLOSE


method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_HEADER .
endmethod.


method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_HEADER_REFKEYS .
endmethod.


METHOD if_ex_me_process_po_cust~fieldselection_item .

  DATA: l_persistent TYPE mmpur_bool.

  FIELD-SYMBOLS: <fs> LIKE LINE OF ch_fieldselection.

* if the item is already on the database, we disallow to change field badi_bsgru
  l_persistent = im_item->is_persistent( ).

  IF l_persistent EQ mmpur_yes.
    READ TABLE ch_fieldselection ASSIGNING <fs> WITH TABLE KEY metafield = mmmfd_cust_01.
    IF sy-subrc IS INITIAL.
      <fs>-fieldstatus = '*'. " Display
    ENDIF.
  ENDIF.

ENDMETHOD.                    "IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_ITEM


method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_ITEM_REFKEYS .
endmethod.


METHOD if_ex_me_process_po_cust~initialize .

* initializations
  CALL FUNCTION 'MEPOBADIEX_INIT'.

ENDMETHOD.                    "IF_EX_ME_PROCESS_PO_CUST~INITIALIZE


METHOD if_ex_me_process_po_cust~open .

  DATA: ls_mepoheader TYPE mepoheader.
*---------------------------------------------------------------------*
* read customer data
*---------------------------------------------------------------------*

* this has to be done when we open a persistent object
*  CHECK im_trtyp EQ 'V' OR im_trtyp EQ 'A'.

  ls_mepoheader = im_header->get_data( ).

* read customer data from database
  CALL FUNCTION 'MEPOBADIEX_OPEN'
    EXPORTING
      im_ebeln = ls_mepoheader-ebeln.
ENDMETHOD.                    "IF_EX_ME_PROCESS_PO_CUST~OPEN


METHOD if_ex_me_process_po_cust~post .

  CALL FUNCTION 'MEPOBADIEX_POST'
    EXPORTING
      im_ebeln = im_ebeln.

ENDMETHOD.                    "IF_EX_ME_PROCESS_PO_CUST~POST


method IF_EX_ME_PROCESS_PO_CUST~PROCESS_ACCOUNT .
* nothing to do
endmethod.


method IF_EX_ME_PROCESS_PO_CUST~PROCESS_HEADER .
** nothing to do
*  DATA: lo_header  TYPE REF TO if_purchase_order_mm,
*        ls_header  TYPE mepoheader.
**
*  " Get header handle
**  lo_header = im_header.
**
**  " Get header data
** * IF lo_header IS BOUND.
**    lo_header = lo_header->get_data( ).
**  ENDIF.
*  DATA: ls_mepoheader TYPE mepoheader.
**---------------------------------------------------------------------*
** read customer data
**---------------------------------------------------------------------*
*
** this has to be done when we open a persistent object
**  CHECK im_trtyp EQ 'V' OR im_trtyp EQ 'A'.
*
*  ls_mepoheader = im_header->get_data( ).
endmethod.


METHOD IF_EX_ME_PROCESS_PO_CUST~PROCESS_ITEM .

  DATA: LS_MEPOITEM TYPE MEPOITEM,
        LS_CUSTOMER TYPE MEPO_BADI_EXAMPL,
        LS_TBSG     TYPE TBSG,
        LV_DUMMY    TYPE C LENGTH 128.
  DATA : LV_NET TYPE  ZTP_COST11-RP1.


  DATA: LO_PO_HEADER TYPE REF TO IF_PURCHASE_ORDER_MM.
  LO_PO_HEADER = IM_ITEM->GET_HEADER( ).

  DATA: LS_MEPOHEADER TYPE MEPOHEADER.
  LS_MEPOHEADER = LO_PO_HEADER->GET_DATA( ).

  INCLUDE MM_MESSAGES_MAC. "useful macros for message handling

*---------------------------------------------------------------------*
* here we check customers data
*---------------------------------------------------------------------*

  LS_MEPOITEM = IM_ITEM->GET_DATA( ).

  IF LS_MEPOITEM-LOEKZ EQ 'D'.

* a physical deletion of the item was carried out. therrefor we have to
* delete customer data on the level of the item
    LS_CUSTOMER-EBELN = LS_MEPOITEM-EBELN.
    LS_CUSTOMER-EBELP = LS_MEPOITEM-EBELP.
    CALL FUNCTION 'MEPOBADIEX_SET_DATA'
      EXPORTING
        IM_DATA                    = LS_CUSTOMER
        IM_PHYSICAL_DELETE_REQUEST = 'X'.

  ELSE.

* update/insert operation
    CALL FUNCTION 'MEPOBADIEX_GET_DATA'
      EXPORTING
        IM_EBELN = LS_MEPOITEM-EBELN
        IM_EBELP = LS_MEPOITEM-EBELP
      IMPORTING
        EX_DATA  = LS_CUSTOMER.
* check customers data

* check field badi_bsgru. This should be carried out only for new items. Once the PO is posted the
* field should no longer be changeable. This is done in Method FIELDSELECTION_ITEM.
    IF IM_ITEM->IS_PERSISTENT( ) EQ MMPUR_NO.
      IF LS_CUSTOMER-BADI_BSGRU IS INITIAL.
* Place the cursor onto field badi_bsgru. The metafield was defined in BAdI ME_GUI_PO_CUST,
* Method MAP_DYNPRO_FIELDS.
        MMPUR_METAFIELD MMMFD_CUST_01.
        MESSAGE W083(ME) WITH TEXT-002 '' INTO LV_DUMMY.
        MMPUR_MESSAGE_FORCED SY-MSGTY SY-MSGID SY-MSGNO
                             SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ELSE.
* check whether the field is valid
        SELECT SINGLE * FROM TBSG INTO LS_TBSG WHERE BSGRU EQ LS_CUSTOMER-BADI_BSGRU.
        IF NOT SY-SUBRC IS INITIAL.
          MMPUR_METAFIELD MMMFD_CUST_01.
          MESSAGE E083(ME) WITH TEXT-004 SPACE INTO LV_DUMMY.
          MMPUR_MESSAGE_FORCED SY-MSGTY SY-MSGID SY-MSGNO
                               SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
* invalidate the object
          CALL METHOD IM_ITEM->INVALIDATE( ).
        ENDIF.
      ENDIF.
    ENDIF.

* check field badi_afnam
    IF LS_CUSTOMER-BADI_AFNAM IS INITIAL.
      MMPUR_METAFIELD MMMFD_CUST_02.
      MESSAGE W083(ME) WITH TEXT-003 SPACE INTO LV_DUMMY.
      MMPUR_MESSAGE_FORCED SY-MSGTY SY-MSGID SY-MSGNO
                           SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

  ENDIF.
  CLEAR : LV_NET.

  IF LS_MEPOHEADER-BSART = 'Z3P'.
    data : ls_msg(100) type c.
    data : ls_net(10) type c,
           ls_net1(10) type c.
    DATA : LV_PRICE TYPE ZTP_COST11-GSTVAL1.
    DATA : WA_TAB TYPE ZTP_ME21N.
    DATA: ls_last TYPE ztp_cost11.
    BREAK CTPLABAP.
    IF LS_MEPOITEM-NETPR NE 0.
      clear : wa_tab.
      SELECT SINGLE * FROM ZTP_ME21N INTO
                   WA_TAB WHERE BUKRS = LS_MEPOITEM-BUKRS AND
                                BNAME = SYST-UNAME   AND
                                LIFNR = LS_MEPOHEADER-LIFNR AND
                                DATAB lE LS_MEPOHEADER-AEDAT AND
                                STATUS = 'A' .
      IF SY-SUBRC NE 0.
clear : ls_last.
       SELECT *
  FROM ztp_cost11
  INTO CORRESPONDING FIELDS OF ls_last
  WHERE "werks   = ls_mepoitem-werks and
        gjahr   = ls_mepoheader-aedat+0(4)
    AND fglifnr = ls_mepoheader-lifnr
    AND matnr   = ls_mepoitem-matnr
  ORDER BY vbeln ASCENDING.       "Field that defines last record
*  UP TO 1 ROWS.
ENDSELECT.
clear : ls_net , ls_net1 , ls_msg.

LV_PRICE = LS_LAST-net - ls_last-gstval1.
        IF SY-SUBRC EQ 0.
          IF LS_MEPOITEM-NETPR LE LV_PRICE. "LS_LAST-net.
*     message 'Cost sheet Value is Less then Net Pice' type 'I' DISPLAY LIKE 'W'.
            move : LS_MEPOITEM-NETPR to ls_net1,
                   LV_PRICE          to ls_net. "LS_LAST-net       to ls_net.
            CONDENSE ls_net1. CONDENSE ls_net.
            move : 'Net Price ' to ls_msg.
            concatenate ls_msg ls_net1 ' is less then Cost sheet Value'
                               ls_net  into ls_msg SEPARATED BY space.
            CALL FUNCTION 'POPUP_TO_INFORM'
              EXPORTING
                TITEL  = 'Information'  " Title of the pop-up
                TXT1   = ls_msg "'Cost sheet Value is Less then Net Pice.'
                TXT2   = 'Click OK to continue.'
              EXCEPTIONS
                OTHERS = 1.
            IF SY-SUBRC <> 0.
              " Error handling
            ENDIF.
          ELSEIF  LS_MEPOITEM-NETPR GE LS_LAST-net.
*     message 'Cost sheet Value is More then Net Pice' TYPE 'I' DISPLAY LIKE 'W'.
              move : LS_MEPOITEM-NETPR to ls_net1,
                     LV_PRICE          to ls_net.
*                     LS_LAST-net       to ls_net.
            CONDENSE ls_net1. CONDENSE ls_net.
*            move : 'Cost sheet Value' to ls_msg.
             move : 'Net Price' to ls_msg.
            concatenate ls_msg ls_net1 'is More then Cost Sheet Value'
                               ls_net  into ls_msg SEPARATED BY space.
            CALL FUNCTION 'POPUP_TO_INFORM'
              EXPORTING
                TITEL  = 'Information'(801)  " Title of the pop-up
                TXT1   = ls_msg "'Cost sheet Value is More then Net Pice.'(802)
                TXT2   = 'Click OK to continue.'(802)
              EXCEPTIONS
                OTHERS = 1.
            IF SY-SUBRC <> 0.
              " Error handling
            ENDIF.
          ENDIF.
        ELSE.

          MESSAGE 'Cost Sheet not maintained for this Material with this Vendor'
                   TYPE 'E' DISPLAY LIKE 'W'.

        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
*select single gstval1 into lv_net from
*                 ztp_cost11 where
*                 matnr = LS_MEPOITEM-matnr and
*                 werks = LS_MEPOITEM-werks.
* if sy-subrc eq 0.
* if LS_MEPOITEM-NETPR ne lv_net.
*   MESSAGE e900(me) WITH text-005 space INTO lv_dummy.
*   mmpur_message_forced sy-msgty sy-msgid sy-msgno
*                               sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*endif.
*else.
*   MESSAGE e901(me) WITH text-005 space INTO lv_dummy.
*   mmpur_message_forced sy-msgty sy-msgid sy-msgno
*                               sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*endif.
*endif.


  """""""""""""""""""""" Added By NC  """""""""""""""""""""""""""""""""""""""""""


  IF LS_MEPOITEM-J_1BNBM IS INITIAL AND  LS_MEPOITEM-LOEKZ IS  INITIAL  .
    MESSAGE 'HSN/SAC Code Missing: Maintain HSN/SAC Code in Material Master.' TYPE 'E'.
  ENDIF .

ENDMETHOD.                    "IF_EX_ME_PROCESS_PO_CUST~PROCESS_ITEM


method IF_EX_ME_PROCESS_PO_CUST~PROCESS_SCHEDULE .
* nothing to do
endmethod.
ENDCLASS.
