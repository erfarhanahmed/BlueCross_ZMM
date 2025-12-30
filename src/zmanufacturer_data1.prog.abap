*&---------------------------------------------------------------------*
*& Report  ZMANUFACTURER_DATA1
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
report zmanufacturer_data1.
tables : lfa1,
         zvendor_mfg.

selection-screen begin of block merkmale1 with frame title text-001.
parameters : r1 radiobutton group r1,
             r4 radiobutton group r1,
             r2 radiobutton group r1,
             R5 RADIOBUTTON GROUP R1,
             r3 radiobutton group r1.
selection-screen end of block merkmale1.

if r1 eq 'X'.
  call transaction 'ZMFG1'.
ELSEif r4 eq 'X'.
  call transaction 'ZMFG3'.
elseif r2 eq 'X'.
  call transaction 'ZMFG2'.
ELSEIF R5 EQ 'X'.
  CALL TRANSACTION 'ZMFG4'.
elseif r3 eq 'X'.
  call transaction 'ZAVL'.
endif.
