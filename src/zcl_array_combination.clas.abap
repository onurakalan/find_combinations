""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Abap : Onur Akalan
" Tarih: 24.08.2022
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
CLASS zcl_array_combination DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES : decimal TYPE p LENGTH 13 DECIMALS 7.

    TYPES : BEGIN OF ty_index,
              index TYPE i,
              value TYPE decimal,
            END OF ty_index,
            tt_index TYPE TABLE OF ty_index WITH DEFAULT KEY.

    TYPES : BEGIN OF ty_line,
              line  TYPE i,
              value TYPE decimal,
            END OF ty_line,
            tt_line TYPE TABLE OF ty_line WITH DEFAULT KEY.


    TYPES : BEGIN OF ty_comb,
              comb TYPE tt_line,
              sum  TYPE decimal,
            END OF ty_comb,
            tt_comb TYPE TABLE OF ty_comb WITH DEFAULT KEY.



    METHODS :
      get_combinations
        IMPORTING
          index_tab       TYPE tt_index
          comb_count      TYPE i
        RETURNING
          VALUE(comb_tab) TYPE tt_comb,
      get_all_combinations
        IMPORTING
          index_tab       TYPE tt_index
        RETURNING
          VALUE(comb_tab) TYPE tt_comb,
      get_matching_line
        IMPORTING
          index_tab       TYPE tt_index
          comb_count      TYPE i
          target_val    TYPE decimal
        RETURNING
          VALUE(match_line) TYPE ty_comb.


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA :
        _indextab TYPE tt_index.
    DATA :
        _mt_comb TYPE tt_comb.

    DATA :
        _mv_target_val TYPE decimal.

    METHODS :
      _calc_combination
        IMPORTING
          comb_count     TYPE i  " kaçlı kombinasyon olacak
          start_position TYPE i  " başlangıç konumu
        CHANGING
          result_tab     TYPE tt_line. "dönüş tablosu
ENDCLASS.



CLASS zcl_array_combination IMPLEMENTATION.
  METHOD get_combinations.
    _indextab = index_tab.

    DATA result_tab TYPE tt_line.

    DO comb_count TIMES.
      APPEND INITIAL LINE TO result_tab.
    ENDDO.

    _calc_combination(
      EXPORTING
        comb_count     = comb_count
        start_position = 1
      CHANGING
        result_tab     = result_tab
    ).

    comb_tab = _mt_comb.

  ENDMETHOD.

  METHOD _calc_combination.
    IF comb_count EQ 0.
      APPEND INITIAL LINE TO _mt_comb ASSIGNING FIELD-SYMBOL(<lfs_comb>).
      <lfs_comb>-comb = result_tab.

      LOOP AT result_tab INTO DATA(ls_result).
        <lfs_comb>-sum = <lfs_comb>-sum + ls_result-value.
      ENDLOOP.

      RETURN.
    ENDIF.


    LOOP AT _indextab INTO DATA(ls_arr)
        FROM start_position
        TO lines( _indextab ) - comb_count + 1.

      DATA(tbx) = sy-tabix.

      result_tab[ lines( result_tab ) - comb_count + 1 ]-line = ls_arr-index.
      result_tab[ lines( result_tab ) - comb_count + 1 ]-value = ls_arr-value.


      _calc_combination(
        EXPORTING
          comb_count     = comb_count - 1
          start_position = tbx + 1
        CHANGING
           result_tab = result_tab
      ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_all_combinations.

    DO lines( index_tab ) TIMES.
      DATA(lt_comb) = me->get_combinations(
        EXPORTING
          index_tab  = index_tab
          comb_count = sy-index
      ).
      APPEND LINES OF lt_comb TO comb_tab.

      CLEAR : _mt_comb.
    ENDDO.


  ENDMETHOD.

  METHOD get_matching_line.

  ENDMETHOD.

ENDCLASS.
