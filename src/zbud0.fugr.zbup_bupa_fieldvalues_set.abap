FUNCTION zbup_bupa_fieldvalues_set.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_BUSDEFAULT) LIKE  BUSDEFAULT STRUCTURE  BUSDEFAULT
*"       OPTIONAL
*"----------------------------------------------------------------------

  i_busdefault-langu = sy-langu .

*  gl_busdefault = i_busdefault.


  CALL FUNCTION 'BUP_BUPA_FIELDVALUES_SET'
    EXPORTING
      i_busdefault = i_busdefault.





ENDFUNCTION.
