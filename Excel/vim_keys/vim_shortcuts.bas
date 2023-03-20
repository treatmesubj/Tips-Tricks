Rem Attribute VBA_ModuleType=VBAModule
' Option VBASupport 1
Sub setup_shortcuts()
  Application.OnKey "h", "go_left"
  Application.OnKey "j", "go_down"
  Application.OnKey "k", "go_up"
  Application.OnKey "l", "go_right"
  Application.OnKey "{BS}", "go_left"
  Application.OnKey " ", "go_right"

  Application.OnKey "i", "edit"
  Application.OnKey "a", "edit"
  Application.OnKey "+a", "edit_end"
  Application.OnKey "+i", "edit_begin"

  Application.OnKey "o", "insert_row_below"
  Application.OnKey "+o", "insert_row_above"

  'Application.OnKey "dd", "delete_row"
  'Application.OnKey "dw", "delete_cell"
  Application.OnKey "x", "delete_cell"

  Application.OnKey "b", "go_contiguous_left"
  Application.OnKey "w", "go_contiguous_right"
  Application.OnKey "e", "go_contiguous_right"

  Application.OnKey "+h", "go_top_of_viewport"
  Application.OnKey "^u", "page_up" 
  Application.OnKey "+l", "go_bottom_of_viewport"
  Application.OnKey "^d", "page_down"
  Application.OnKey "+4", "go_end_of_row_values" '$
  Application.OnKey "0", "go_begin_of_row"
  Application.OnKey "+-", "go_begin_of_row_values" '_

  Application.OnKey "/", "do_search"
End Sub

Sub teardown_shortcuts()
  Application.OnKey "h"
  Application.OnKey "j"
  Application.OnKey "k"
  Application.OnKey "l"
  Application.OnKey "{BS}"
  Application.OnKey " "

  Application.OnKey "i"
  Application.OnKey "a"
  Application.OnKey "+a"
  Application.OnKey "+i"

  Application.OnKey "o"
  Application.OnKey "+o"

  'Application.OnKey "dd"
  'Application.OnKey "dw"
  Application.OnKey "x"

  Application.OnKey "b"
  Application.OnKey "w"
  Application.OnKey "e"

  Application.OnKey "+h"
  Application.OnKey "^u"
  Application.OnKey "+l"
  Application.OnKey "^d"
  Application.OnKey "+4"
  Application.OnKey "0"
  Application.OnKey "+-"

  Application.OnKey "/"
End Sub
