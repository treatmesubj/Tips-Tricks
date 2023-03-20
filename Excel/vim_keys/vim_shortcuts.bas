Rem Attribute VBA_ModuleType=VBAModule
' Option VBASupport 1
Sub setup_shortcuts()
  Application.OnKey "h", "go_left"
  Application.OnKey "j", "go_down"
  Application.OnKey "k", "go_up"
  Application.OnKey "l", "go_right"
  Application.OnKey "BS", "go_left"
  Application.OnKey " ", "go_right"

  Application.OnKey "i", "edit"
  Application.OnKey "a", "edit"
  'Application.OnKey "+a", "edit_end"
  Application.OnKey "+i", "edit_begin"

  Application.OnKey "o", "insert_row_below"
  Application.OnKey "+o", "insert_row_above"

  'Application.OnKey "dd", "delete_row"

  Application.OnKey "b", "go_contiguous_left"
  Application.OnKey "w", "go_contiguous_right"
  Application.OnKey "e", "go_contiguous_right"
  Application.OnKey "+b", "select_contiguous_left"
  Application.OnKey "+w", "select_contiguous_right"

  Application.OnKey "+h", "go_top"
  Application.OnKey "+l", "go_bottom"
  Application.OnKey "+m", "go_mid"
  Application.OnKey "+4", "go_end_of_row"
  Application.OnKey "0", "go_begin_of_row"
  Application.OnKey " ", "go_right"
End Sub

Sub teardown_shortcuts()
  Application.OnKey "h"
  Application.OnKey "j"
  Application.OnKey "k"
  Application.OnKey "l"
  Application.OnKey "BS"
  Application.OnKey " "

  Application.OnKey "i"
  Application.OnKey "a"
  'Application.OnKey "+a"
  Application.OnKey "+i"

  Application.OnKey "o"
  Application.OnKey "+o"

  Application.OnKey "b"
  Application.OnKey "w"
  Application.OnKey "e"
  Application.OnKey "+b"
  Application.OnKey "+w"

  Application.OnKey "+h"
  Application.OnKey "+l"
  Application.OnKey "+m"
  Application.OnKey "+4"
  Application.OnKey "0"
End Sub

Sub Auto_Open()
  Call setup_shortcuts
End Sub

Sub Auto_Close()
  Call teardown_shortcuts
End Sub
