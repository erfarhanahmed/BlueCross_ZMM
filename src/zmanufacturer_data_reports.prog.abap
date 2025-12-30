*&---------------------------------------------------------------------*
*& Report  ZMANUFACTURER_DATA_REPORTS
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zmanufacturer_data_reports_a2.
tables : zvendor_mfg,
         lfa1,
         adrc,
         pa0001.

types: begin of ven1,
         mfgr type lfa1-lifnr,
       end of ven1.

types: begin of ven2,
         mfgr  type lfa1-lifnr,
         buzei type zvendor_mfg-buzei,
       end of ven2.

types: begin of itab1,
         mfgr   type lfa1-lifnr,
         name1  type adrc-name1,
         name2  type adrc-name2,
         name3  type adrc-name3,
         name4  type adrc-name4,
         ort01  type lfa1-ort01,
         regio  type lfa1-regio,
         buzei  type zvendor_mfg-buzei,
         mfglic type sy-datum,
         gmplic type sy-datum,
         smfdt  type sy-datum,
         qarev  type sy-datum,
         ename  type pa0001-ename,
         cpudt  type sy-datum,
       end of itab1.

types: begin of itab2,
         mfgr   type lfa1-lifnr,
         name1  type adrc-name1,
         name2  type adrc-name2,
         name3  type adrc-name3,
         name4  type adrc-name4,
         ort01  type lfa1-ort01,
         regio  type lfa1-regio,
         buzei  type zvendor_mfg-buzei,
         mfglic type sy-datum,
         gmplic type sy-datum,
         smfdt  type sy-datum,
         qarev  type sy-datum,
         ename  type pa0001-ename,
         cpudt  type sy-datum,
       end of itab2.

types: begin of itab3,
         mfgr   type lfa1-lifnr,
         name1  type adrc-name1,
         name2  type adrc-name2,
         name3  type adrc-name3,
         name4  type adrc-name4,
         ort01  type lfa1-ort01,
         regio  type lfa1-regio,
         buzei  type zvendor_mfg-buzei,
         mfglic type sy-datum,
         gmplic type sy-datum,
         smfdt  type sy-datum,
         qarev  type sy-datum,
         ename  type pa0001-ename,
         cpudt  type sy-datum,
       end of itab3.

types: begin of itab4,
         mfgr      type lfa1-lifnr,
         name1     type adrc-name1,
         addr(200) type c,
         buzei     type zvendor_mfg-buzei,
         mfglic    type sy-datum,
         gmplic    type sy-datum,
         smfdt     type sy-datum,
         qarev     type sy-datum,
         ename     type pa0001-ename,
         cpudt     type sy-datum,
       end of itab4.

data: it_zvendor_mfg type table of zvendor_mfg,
      wa_zvendor_mfg type zvendor_mfg.
data: it_ven1 type table of ven1,
      wa_ven1 type ven1,
      it_ven2 type table of ven2,
      wa_ven2 type ven2,
      it_tab1 type table of itab1,
      wa_tab1 type itab1,
      it_tab2 type table of itab2,
      wa_tab2 type itab2,
      it_tab3 type table of itab3,
      wa_tab3 type itab3,
      it_tab4 type table of itab4,
      wa_tab4 type itab4.
data: addr(200) type c.

data: date1 type sy-datum.
data: format(100) type c,
      kunnr       type kna1-kunnr.

data: ntext1(100) type c.
data : v_fm type rs38l_fnam.
data : w_return    type ssfcrescl.
data: i_otf       type itcoo    occurs 0 with header line,
      i_tline     like tline    occurs 0 with header line,
      i_record    like solisti1 occurs 0 with header line,
      i_xstring   type xstring,
* Objects to send mail.
      i_objpack   like sopcklsti1 occurs 0 with header line,
      i_objtxt    like solisti1   occurs 0 with header line,
      i_objbin    like solix      occurs 0 with header line,
      i_reclist   like somlreci1  occurs 0 with header line,
* Work Area declarations
      wa_objhead  type soli_tab,
      w_ctrlop    type ssfctrlop,
      w_compop    type ssfcompop,
*      w_return    TYPE ssfcrescl,
      wa_buffer   type string,
* Variables declarations
      v_form_name type rs38l_fnam,
      v_len_in    like sood-objlen.
data: in_mailid type ad_smtpadr.
data: c_ccont   type ref to cl_gui_custom_container,         "Custom container object
      c_alvgd   type ref to cl_gui_alv_grid,         "ALV grid object
      it_fcat   type lvc_t_fcat,                  "Field catalogue
      it_layout type lvc_s_layo.                  "Layout
*ok code declaration
data:
  ok_code       type ui_func.

selection-screen begin of block merkmale1 with frame title text-001.
select-options : mfgr for zvendor_mfg-mfgr.
parameters : days(3) type c.
parameters : r1 radiobutton group r1,
             r2 radiobutton group r1,
             r3 radiobutton group r1,
             r4 radiobutton group r1,
             r5 radiobutton group r1,
             r6 radiobutton group r1.
selection-screen end of block merkmale1 .

start-of-selection.

  date1 = sy-datum + days.

  select * from zvendor_mfg into table it_zvendor_mfg where mfgr in mfgr.
  sort it_zvendor_mfg by mfgr buzei.

  loop at it_zvendor_mfg into wa_zvendor_mfg.
    wa_ven1-mfgr = wa_zvendor_mfg-mfgr.
    collect wa_ven1 into it_ven1.
    clear wa_ven1.
  endloop.
  sort it_ven1 by mfgr.
  delete adjacent duplicates from it_ven1 comparing mfgr.
  sort it_zvendor_mfg descending by buzei.
  loop at it_ven1 into wa_ven1.
    read table it_zvendor_mfg into wa_zvendor_mfg with key mfgr = wa_ven1-mfgr.
    if sy-subrc eq 0.
      wa_ven2-mfgr = wa_zvendor_mfg-mfgr.
      wa_ven2-buzei = wa_zvendor_mfg-buzei.
      collect wa_ven2 into it_ven2.
      clear wa_ven2.
    endif.
  endloop.

  loop at it_ven2 into wa_ven2.
    read table it_zvendor_mfg into wa_zvendor_mfg with key mfgr = wa_ven2-mfgr buzei = wa_ven2-buzei.
    if sy-subrc eq 0.
      wa_tab1-mfgr = wa_zvendor_mfg-mfgr.
      select single * from lfa1 where lifnr eq wa_zvendor_mfg-mfgr.
      if sy-subrc eq 0.
        select single * from adrc where addrnumber eq lfa1-adrnr.
        if sy-subrc eq 0.
          wa_tab1-name1 = adrc-name1.
          if adrc-name2 eq space.
            wa_tab1-name2 = adrc-str_suppl1.
          else.
            wa_tab1-name2 = adrc-name2.
          endif.
          if adrc-name3 eq space.
            wa_tab1-name3 = adrc-str_suppl2.
          else.
            wa_tab1-name3 = adrc-name3.
          endif.
          if adrc-name4 eq space.
            wa_tab1-name3 = adrc-str_suppl3.
          else.
            wa_tab1-name3 = adrc-name4.
          endif.
          wa_tab1-ort01 = lfa1-ort01.
          wa_tab1-regio = lfa1-regio.
          wa_tab1-buzei = wa_zvendor_mfg-buzei.
          wa_tab1-mfglic = wa_zvendor_mfg-mfglic.
          wa_tab1-gmplic = wa_zvendor_mfg-gmplic.
          wa_tab1-smfdt = wa_zvendor_mfg-smfdt.
          wa_tab1-qarev = wa_zvendor_mfg-qarev.
          select single * from pa0001 where pernr eq wa_zvendor_mfg-pernr and endda ge sy-datum.
          if sy-subrc eq 0.
            wa_tab1-ename = pa0001-ename.
          endif.
          wa_tab1-cpudt = wa_zvendor_mfg-cpudt.
          collect wa_tab1 into it_tab1.
          clear wa_tab1.
        endif.
      endif.
    endif.
  endloop.
*  write : date1.
  if r5 eq 'X' or r6 eq 'X'.
    perform form1.
  else.
    perform form2.
  endif.

*&---------------------------------------------------------------------*
*&      Module  STATUS_0600  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_0600 output.
  set pf-status 'STATUS'.

*  SET TITLEBAR 'xxx'.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0600  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0600 input.
  case ok_code.
    when 'BACK' or 'EXIT' or 'CANCEL'.
      leave program.
  endcase.
  clear: ok_code.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  PBO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module pbo output.

*  *  *Creating objects of the container
  create object c_ccont
    exporting
      container_name = 'CCONT'.
*  create object for alv grid


  create object c_alvgd
    exporting
      i_parent = cl_gui_custom_container=>screen0.

*  CREATE OBJECT c_alvgd
*    EXPORTING
*      i_parent = c_ccont.



*  SET field for ALV
  perform alv_build_fieldcat.
* Set ALV attributes FOR LAYOUT
  perform alv_report_layout.
  check not c_alvgd is initial.
* Call ALV GRID
  call method c_alvgd->set_table_for_first_display
    exporting
      is_layout                     = it_layout
      i_save                        = 'A'
    changing
      it_outtab                     = it_tab4
      it_fieldcatalog               = it_fcat
    exceptions
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      others                        = 4.
  if sy-subrc <> 0.
    message id sy-msgid type sy-msgty number sy-msgno
               with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  endif.

endmodule.
*&---------------------------------------------------------------------*
*&      Form  ALV_BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_build_fieldcat .
  data lv_fldcat type lvc_s_fcat.
  clear lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '1'.
  lv_fldcat-fieldname = 'BUZEI'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'Record No.'.
*    LV_FLDCAT-EDIT = 'X'.
*  lv_fldcat-icon = ''.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '2'.
  lv_fldcat-fieldname = 'MFGLIC'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR LIC VALID UPTO'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '3'.
  lv_fldcat-fieldname = 'GMPLIC'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'GMP LIC VALID UPTO'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '4'.
  lv_fldcat-fieldname = 'SMFDT'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'SMF LIC VALID UPTO'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '5'.
  lv_fldcat-fieldname = 'QAREV'.
  lv_fldcat-tabname   = 'IT_TAB1'.
  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'QA REVIEW DATE'.
*  lv_fldcat-edit = 'X'.
*  lv_fldcat-icon = ''.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.


  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '6'.
  lv_fldcat-fieldname = 'MFGR'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'MFGR CODE'.
*  lv_fldcat-icon = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '7'.
  lv_fldcat-fieldname = 'NAME1'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 8.
  lv_fldcat-scrtext_m = 'MFGR NAME'.
*  lv_fldcat-icon = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.

  lv_fldcat-row_pos   = '1'.
  lv_fldcat-col_pos   = '8'.
  lv_fldcat-fieldname = 'ADDR'.
  lv_fldcat-tabname   = 'IT_TAB1'.
*  lv_fldcat-outputlen = 10.
  lv_fldcat-scrtext_m = 'MFGR ADDRESS'.
*  lv_fldcat-icon = ''.
*    LV_FLDCAT-EDIT = 'X'.
  append lv_fldcat to it_fcat.
  clear lv_fldcat.




endform.
*&---------------------------------------------------------------------*
*&      Form  ALV_REPORT_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form alv_report_layout .
  it_layout-cwidth_opt = 'X'.
  it_layout-col_opt = 'X'.
  it_layout-zebra = 'X'.
endform.
*&---------------------------------------------------------------------*
*&      Form  FORM1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form form1 .
  loop at it_tab1 into wa_tab1.

    if wa_tab1-mfglic le date1 and wa_tab1-mfglic gt 0.
      wa_tab2-mfgr = wa_tab1-mfgr.
      wa_tab2-buzei = wa_tab1-buzei.
      wa_tab2-mfglic = wa_tab1-mfglic.
      wa_tab2-gmplic = wa_tab1-gmplic.
      wa_tab2-smfdt = wa_tab1-smfdt.
      wa_tab2-qarev = wa_tab1-qarev.
      collect wa_tab2 into it_tab2.
      clear wa_tab2.
    endif.

    if wa_tab1-gmplic le date1 and wa_tab1-gmplic gt 0.
      wa_tab2-mfgr = wa_tab1-mfgr.
      wa_tab2-buzei = wa_tab1-buzei.
      wa_tab2-mfglic = wa_tab1-mfglic.
      wa_tab2-gmplic = wa_tab1-gmplic.
      wa_tab2-smfdt = wa_tab1-smfdt.
      wa_tab2-qarev = wa_tab1-qarev.
      collect wa_tab2 into it_tab2.
      clear wa_tab2.
    endif.

    if wa_tab1-smfdt le date1 and wa_tab1-smfdt gt 0.
      wa_tab2-mfgr = wa_tab1-mfgr.
      wa_tab2-buzei = wa_tab1-buzei.
      wa_tab2-mfglic = wa_tab1-mfglic.
      wa_tab2-gmplic = wa_tab1-gmplic.
      wa_tab2-smfdt = wa_tab1-smfdt.
      wa_tab2-qarev = wa_tab1-qarev.
      collect wa_tab2 into it_tab2.
      clear wa_tab2.
    endif.

    if wa_tab1-qarev le date1 and wa_tab1-qarev gt 0.
      wa_tab2-mfgr = wa_tab1-mfgr.
      wa_tab2-buzei = wa_tab1-buzei.
      wa_tab2-mfglic = wa_tab1-mfglic.
      wa_tab2-gmplic = wa_tab1-gmplic.
      wa_tab2-smfdt = wa_tab1-smfdt.
      wa_tab2-qarev = wa_tab1-qarev.
      collect wa_tab2 into it_tab2.
      clear wa_tab2.
    endif.

  endloop.

  loop at it_tab2 into wa_tab2.
*    write : / wa_tab2-mfgr,WA_TAB2-BUZEI,WA_TAB2-mfglic,WA_TAB2-gmplic,WA_TAB2-smfdt,WA_TAB2-qarev.
    wa_tab3-mfgr = wa_tab2-mfgr.
    select single * from lfa1 where lifnr eq wa_tab2-mfgr.
    if sy-subrc eq 0.
      select single * from adrc where addrnumber eq lfa1-adrnr.
      if sy-subrc eq 0.
        wa_tab3-name1 = adrc-name1.
        if adrc-name2 eq space.
          wa_tab3-name2 = adrc-str_suppl1.
        else.
          wa_tab3-name2 = adrc-name2.
        endif.
        if adrc-name3 eq space.
          wa_tab3-name3 = adrc-str_suppl2.
        else.
          wa_tab3-name3 = adrc-name3.
        endif.
        if adrc-name4 eq space.
          wa_tab3-name3 = adrc-str_suppl3.
        else.
          wa_tab3-name3 = adrc-name4.
        endif.
        wa_tab3-ort01 = lfa1-ort01.
        wa_tab3-regio = lfa1-regio.
      endif.
    endif.
    wa_tab3-buzei = wa_tab2-buzei.
    wa_tab3-mfglic = wa_tab2-mfglic.
    wa_tab3-gmplic = wa_tab2-gmplic.
    wa_tab3-smfdt = wa_tab2-smfdt.
    wa_tab3-qarev = wa_tab2-qarev.
    collect wa_tab3 into it_tab3.
    clear wa_tab3.

  endloop.

  loop at it_tab3 into wa_tab3.
    wa_tab4-mfgr = wa_tab3-mfgr.
    wa_tab4-name1 = wa_tab3-name1.
    clear : addr.
    concatenate wa_tab3-name2 wa_tab3-name3 wa_tab3-name4 wa_tab3-ort01 wa_tab3-regio into addr separated by space.
    wa_tab4-addr = addr.
    wa_tab4-buzei = wa_tab3-buzei.
    wa_tab4-mfglic = wa_tab3-mfglic.
    wa_tab4-gmplic = wa_tab3-gmplic.
    wa_tab4-smfdt = wa_tab3-smfdt.
    wa_tab4-qarev = wa_tab3-qarev.
    collect wa_tab4 into it_tab4.
    clear wa_tab4.
  endloop.
  sort it_tab4 by mfgr.

  if r5 eq 'X'.
    perform dueprint.
  elseif r6 eq 'X'.
    if sy-host eq 'SAPQLT' or sy-host eq 'SAPDEV'.
    else.
      perform dueemail.
    endif.
  endif.
*  loop at it_tab4 into wa_tab4.
*    write : / wa_tab4-mfgr,wa_tab4-name1,wa_tab4-addr,wa_tab4-mfglic,wa_tab4-gmplic,wa_tab4-smfdt,wa_tab4-qarev.
*  endloop.


endform.
*&---------------------------------------------------------------------*
*&      Form  FORM2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form form2 .
  loop at it_tab1 into wa_tab1.
    if r1 eq 'X'.
      if wa_tab1-mfglic le date1.
        wa_tab2-mfgr = wa_tab1-mfgr.
        wa_tab2-buzei = wa_tab1-buzei.
        wa_tab2-mfglic = wa_tab1-mfglic.
        wa_tab2-gmplic = wa_tab1-gmplic.
        wa_tab2-smfdt = wa_tab1-smfdt.
        wa_tab2-qarev = wa_tab1-qarev.
        collect wa_tab2 into it_tab2.
        clear wa_tab2.
      endif.
    elseif r2 eq 'X'.
      if wa_tab1-gmplic le date1.
        wa_tab2-mfgr = wa_tab1-mfgr.
        wa_tab2-buzei = wa_tab1-buzei.
        wa_tab2-mfglic = wa_tab1-mfglic.
        wa_tab2-gmplic = wa_tab1-gmplic.
        wa_tab2-smfdt = wa_tab1-smfdt.
        wa_tab2-qarev = wa_tab1-qarev.
        collect wa_tab2 into it_tab2.
        clear wa_tab2.
      endif.
    elseif r3 eq 'X'.
      if wa_tab1-smfdt le date1.
        wa_tab2-mfgr = wa_tab1-mfgr.
        wa_tab2-buzei = wa_tab1-buzei.
        wa_tab2-mfglic = wa_tab1-mfglic.
        wa_tab2-gmplic = wa_tab1-gmplic.
        wa_tab2-smfdt = wa_tab1-smfdt.
        wa_tab2-qarev = wa_tab1-qarev.
        collect wa_tab2 into it_tab2.
        clear wa_tab2.
      endif.
    elseif r4 eq 'X'.
      if wa_tab1-qarev le date1.
        wa_tab2-mfgr = wa_tab1-mfgr.
        wa_tab2-buzei = wa_tab1-buzei.
        wa_tab2-mfglic = wa_tab1-mfglic.
        wa_tab2-gmplic = wa_tab1-gmplic.
        wa_tab2-smfdt = wa_tab1-smfdt.
        wa_tab2-qarev = wa_tab1-qarev.
        collect wa_tab2 into it_tab2.
        clear wa_tab2.
      endif.
    endif.
  endloop.

  loop at it_tab2 into wa_tab2.
*    write : / wa_tab2-mfgr,WA_TAB2-BUZEI,WA_TAB2-mfglic,WA_TAB2-gmplic,WA_TAB2-smfdt,WA_TAB2-qarev.
    wa_tab3-mfgr = wa_tab2-mfgr.
    select single * from lfa1 where lifnr eq wa_zvendor_mfg-mfgr.
    if sy-subrc eq 0.
      select single * from adrc where addrnumber eq lfa1-adrnr.
      if sy-subrc eq 0.
        wa_tab3-name1 = adrc-name1.
        if adrc-name2 eq space.
          wa_tab3-name2 = adrc-str_suppl1.
        else.
          wa_tab3-name2 = adrc-name2.
        endif.
        if adrc-name3 eq space.
          wa_tab3-name3 = adrc-str_suppl2.
        else.
          wa_tab3-name3 = adrc-name3.
        endif.
        if adrc-name4 eq space.
          wa_tab3-name3 = adrc-str_suppl3.
        else.
          wa_tab3-name3 = adrc-name4.
        endif.
        wa_tab3-ort01 = lfa1-ort01.
        wa_tab3-regio = lfa1-regio.
      endif.
    endif.
    wa_tab3-buzei = wa_tab2-buzei.
    wa_tab3-mfglic = wa_tab2-mfglic.
    wa_tab3-gmplic = wa_tab2-gmplic.
    wa_tab3-smfdt = wa_tab2-smfdt.
    wa_tab3-qarev = wa_tab2-qarev.
    collect wa_tab3 into it_tab3.
    clear wa_tab3.

  endloop.

  loop at it_tab3 into wa_tab3.
    wa_tab4-mfgr = wa_tab3-mfgr.
    wa_tab4-name1 = wa_tab3-name1.
    clear : addr.
    concatenate wa_tab3-name2 wa_tab3-name3 wa_tab3-name4 wa_tab3-ort01 wa_tab3-regio into addr separated by space.
    wa_tab4-addr = addr.
    wa_tab4-buzei = wa_tab3-buzei.
    wa_tab4-mfglic = wa_tab3-mfglic.
    wa_tab4-gmplic = wa_tab3-gmplic.
    wa_tab4-smfdt = wa_tab3-smfdt.
    wa_tab4-qarev = wa_tab3-qarev.
    collect wa_tab4 into it_tab4.
    clear wa_tab4.
  endloop.

  loop at it_tab4 into wa_tab4.
    write : / wa_tab4-mfgr,wa_tab4-name1,wa_tab4-addr,wa_tab4-buzei,wa_tab4-mfglic,wa_tab4-gmplic,wa_tab4-smfdt,wa_tab4-qarev.
  endloop.

  call screen 0600.
  leave to screen 0.
endform.
*&---------------------------------------------------------------------*
*&      Form  DUEPRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form dueprint .
  call function 'SSF_FUNCTION_MODULE_NAME'
    exporting
      formname           = 'ZMFGR2'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    importing
      fm_name            = v_fm
    exceptions
      no_form            = 1
      no_function_module = 2
      others             = 3.

  call function v_fm
    exporting
*     pln              = pln
      kunnr            = kunnr
      format           = format
*     AUBEL            = AUBEL
*     adrc             = adrc
*     t001w            = t001w
*     J_1IMOCUST       = J_1IMOCUST
*     G_LSTNO          = G_LSTNO
*     WA_ADRC          = WA_ADRC
*     VBKD             = VBKD
*     vbrk             = vbrk
*     fkdat            = fkdat
*     TOTAL            = TOTAL
*     TOTAL1           = TOTAL1
*     VBRK             = VBRK
*     W_TAX            = W_TAX
*     W_VALUE          = W_VALUE
*     SPELL            = SPELL
*     W_DIFF           = W_DIFF
*     EMNAME           = EMNAME
*     RMNAME           = RMNAME
*     CLMDT            = CLMDT
    tables
      it_tab4          = it_tab4
*     it_vbrp          = it_vbrp
*     ITAB_DIVISION    = ITAB_DIVISION
*     ITAB_STORAGE     = ITAB_STORAGE
*     ITAB_PA0002      = ITAB_PA0002
    exceptions
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      others           = 5.

*  call screen 0600.
*  leave to screen 0.
endform.
*&---------------------------------------------------------------------*
*&      Form  DUEEMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form dueemail .
  if it_tab4 is not initial.
    call function 'SSF_FUNCTION_MODULE_NAME'
      exporting
        formname           = 'ZMFGR2'
*       VARIANT            = ' '
*       DIRECT_CALL        = ' '
      importing
        fm_name            = v_fm
      exceptions
        no_form            = 1
        no_function_module = 2
        others             = 3.
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
      with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

*   * Set the control parameter
    w_ctrlop-getotf = abap_true.
    w_ctrlop-no_dialog = abap_true.
    w_compop-tdnoprev = abap_true.
    w_ctrlop-preview = space.
    w_compop-tddest = 'LOCL'.

    call function v_fm
      exporting
        control_parameters = w_ctrlop
        output_options     = w_compop
        user_settings      = abap_true
*       pln                = pln
        kunnr              = kunnr
        format             = format
*       AUBEL              = AUBEL
*       adrc               = adrc
*       t001w              = t001w
*       J_1IMOCUST         = J_1IMOCUST
*       G_LSTNO            = G_LSTNO
*       WA_ADRC            = WA_ADRC
*       VBKD               = VBKD
*       vbrk               = vbrk
*       fkdat              = fkdat
*       TOTAL              = TOTAL
*       TOTAL1             = TOTAL1
*       VBRK               = VBRK
*       W_TAX              = W_TAX
*       W_VALUE            = W_VALUE
*       SPELL              = SPELL
*       W_DIFF             = W_DIFF
*       EMNAME             = EMNAME
*       RMNAME             = RMNAME
*       CLMDT              = CLMDT
      importing
        job_output_info    = w_return " This will have all output
      tables
        it_tab4            = it_tab4
*       it_vbrp            = it_vbrp
*       ITAB_DIVISION      = ITAB_DIVISION
*       ITAB_STORAGE       = ITAB_STORAGE
*       ITAB_PA0002        = ITAB_PA0002
      exceptions
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        others             = 5.

    i_otf[] = w_return-otfdata[].

* Import Binary file and filesize
    call function 'CONVERT_OTF'
      exporting
        format                = 'PDF'
        max_linewidth         = 132
      importing
        bin_filesize          = v_len_in
        bin_file              = i_xstring   " This is NOT Binary. This is Hexa
      tables
        otf                   = i_otf
        lines                 = i_tline
      exceptions
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        others                = 4.
* Sy-subrc check not checked



*  * Convert Hexa String to Binary format
    call function 'SCMS_XSTRING_TO_BINARY'
      exporting
        buffer     = i_xstring
      tables
        binary_tab = i_objbin[].
* Sy-subrc check not required.

*    DATA: IN_MAILID TYPE AD_SMTPADR.

* Begin of sending email to multiple users
* If business want email to be sent to all users at one time, it can be done

* For now we do not want to send 1 email to multiple users
* Mail has to be sent one email at a time

*  IF P2 EQ 'X'.
*
*      CLEAR IN_MAILID.
    in_mailid = 'qa-nashik@BLUECROSSLABS.COM'.
    perform send_mail using in_mailid .
*      in_mailid = 'b.deore@BLUECROSSLABS.COM'.
*      perform send_mail using in_mailid .
*      in_mailid = 'pradeep.patil@BLUECROSSLABS.COM'.
*      perform send_mail using in_mailid .
*
*      in_mailid = 'bhimraj.rohokale@BLUECROSSLABS.COM'.  "added on 20.9.22
*      perform send_mail using in_mailid .
*      in_mailid = 'kiran@BLUECROSSLABS.COM'.
*      perform send_mail using in_mailid .
*      in_mailid = 'pravin.s@BLUECROSSLABS.COM'.
*      perform send_mail using in_mailid .



  endif.
*  call screen 0600.
*  leave to screen 0.
endform.
*&---------------------------------------------------------------------*
*&      Form  SEND_MAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IN_MAILID  text
*----------------------------------------------------------------------*
form send_mail  using    p_in_mailid.
  data: salutation type string.
  data: body type string.
  data: footer type string.

  data: lo_send_request type ref to cl_bcs,
        lo_document     type ref to cl_document_bcs,
        lo_sender       type ref to if_sender_bcs,
        lo_recipient    type ref to if_recipient_bcs value is initial,lt_message_body type bcsy_text,
        lx_document_bcs type ref to cx_document_bcs,
        lv_sent_to_all  type os_boolean.

  "create send request
  lo_send_request = cl_bcs=>create_persistent( ).

  "create message body and subject
  salutation ='Dear Sir/Madam,'.
  append salutation to lt_message_body.
  append initial line to lt_message_body.

  body = 'Please find the attached LICENSE DUE FOR REVISION in PDF format.'.

  append body to lt_message_body.
  append initial line to lt_message_body.

  footer = 'With Regards,'.
  append footer to lt_message_body.
  footer = 'BLUE CROSS LABORATORIES PVT LTD.'.
  append footer to lt_message_body.


  ntext1 = 'DUE FOR REVISION'.

  "put your text into the document

*  if r4 eq 'X'.
  lo_document = cl_document_bcs=>create_document(
i_type = 'RAW'
i_text = lt_message_body
i_subject = 'DUE FOR REVISION' ).

*DATA: l_size TYPE sood-objlen. " Size of Attachment
*l_size = l_lines * 255.
  try.

      lo_document->add_attachment(
      exporting
      i_attachment_type = 'PDF'
      i_attachment_subject = 'DUE FOR REVISION'
      i_att_content_hex = i_objbin[] ).
    catch cx_document_bcs into lx_document_bcs.

  endtry.
*  elseif r6 eq 'X'.
*    lo_document = cl_document_bcs=>create_document(
*  i_type = 'RAW'
*  i_text = lt_message_body
*  i_subject = 'REJECTION BY QUALITY CONTROL' ).
*
**DATA: l_size TYPE sood-objlen. " Size of Attachment
**l_size = l_lines * 255.
*    try.
*
*        lo_document->add_attachment(
*        exporting
*        i_attachment_type = 'PDF'
*        i_attachment_subject = 'REJECTION BY QUALITY CONTROL'
*        i_att_content_hex = i_objbin[] ).
*      catch cx_document_bcs into lx_document_bcs.
*
*    endtry.
*
*  else.
*    lo_document = cl_document_bcs=>create_document(
*    i_type = 'RAW'
*    i_text = lt_message_body
*    i_subject = 'INSPECTION PLAN NOT ATTACHED' ).
*
**DATA: l_size TYPE sood-objlen. " Size of Attachment
**l_size = l_lines * 255.
*    try.
*
*        lo_document->add_attachment(
*        exporting
*        i_attachment_type = 'PDF'
*        i_attachment_subject = 'INSPECTION PLAN NOT ATTACHED'
*        i_att_content_hex = i_objbin[] ).
*      catch cx_document_bcs into lx_document_bcs.
*
*    endtry.
*
*  endif.

* Add attachment
* Pass the document to send request
  lo_send_request->set_document( lo_document ).

  "Create sender
  lo_sender = cl_sapuser_bcs=>create( sy-uname ).

  "Set sender
  lo_send_request->set_sender( lo_sender ).

  "Create recipient
  lo_recipient = cl_cam_address_bcs=>create_internet_address( in_mailid ).

*Set recipient
  lo_send_request->add_recipient(
  exporting
  i_recipient = lo_recipient
  i_express = abap_true
  ).

  lo_send_request->add_recipient( lo_recipient ).

* Send email
  lo_send_request->send(
  exporting
  i_with_error_screen = abap_true
  receiving
  result = lv_sent_to_all ).

  concatenate 'Email sent to' in_mailid into data(lv_msg) separated by space.
  write:/ lv_msg color col_positive.
  skip.
* Commit Work to send the email
  commit work.
endform.
