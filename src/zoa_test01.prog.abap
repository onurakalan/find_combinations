REPORT zoa_test01.

PARAMETERS : p_comb TYPE i.

"1. deneme datası
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

DATA : lt_index TYPE zcl_array_combination=>tt_index.
lt_index = VALUE #(  ( index = 1 value = 10 )
                     ( index = 2 value = 20 )
                     ( index = 3 value = 30 )
                     ( index = 4 value = 40 )
                     ( index = 5 value = 50 )
                     ( index = 6 value = 60 )
                     ( index = 7 value = 70 )
                     ( index = 8 value = 80 )
                     ( index = 9 value = 90 )
                     ( index = 10 value = 100 ) ).


"2.find combination
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
DATA(lo_comb) = NEW zcl_array_combination( ).

DATA(lt_comb) = lo_comb->get_combinations(
  EXPORTING
    index_tab  = lt_index
    comb_count = p_comb
).
"3. display alv
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
TYPES : BEGIN OF ty_alv,
          combination TYPE char50,
          sum         TYPE zcl_array_combination=>decimal,
        END OF ty_alv.

DATA : lt_alv TYPE TABLE OF ty_alv.


LOOP AT lt_comb INTO DATA(ls_comb).

  APPEND INITIAL LINE TO lt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>).

  <lfs_alv>-sum = ls_comb-sum.

  LOOP AT ls_comb-comb INTO DATA(ls_combination).
    IF sy-tabix EQ 1.
      <lfs_alv>-combination = |{ ls_combination-line }|.
    ELSE.
      <lfs_alv>-combination = |{ <lfs_alv>-combination },{ ls_combination-line }|.
    ENDIF.
  ENDLOOP.

ENDLOOP.

cl_demo_output=>display( lt_alv ).
