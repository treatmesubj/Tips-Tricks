Rem Attribute VBA_ModuleType=VBAModule
' Option VBASupport 1
Option Explicit

' up, down, left, right
Public Sub go_up()
  Application.SendKeys "{UP}"
End Sub
Public Sub go_down()
  Application.SendKeys "{DOWN}"
End Sub
Public Sub go_left()
  Application.SendKeys "{LEFT}"
End Sub
Public Sub go_right()
  Application.SendKeys "{RIGHT}"
End Sub

' editing
Public Sub edit()
  Application.SendKeys "{F2}"
End Sub
Public Sub edit_begin()
  Call go_begin_of_row
  Call go_contiguous_right
  Call edit
  Application.SendKeys "{HOME}"
End Sub
Public Sub edit_end()
  Dim row As Long
  Dim col As Long
  row = Selection.row
  Cells(row, 16384).Select
  col = Selection.End(xlToLeft).Column
  Cells(row, col).Select
End Sub

' contiguous left, right
Public Sub go_contiguous_left()
  Dim col As Long
  Dim row As Long
  col = Selection.End(xlToLeft).Column
  row = Selection.row
  Cells(row, col).Select
  If IsEmpty(Selection) Then
    Cells(row-1, 16384).Select
    If IsEmpty(Selection) Then
      row = Selection.row
      col = Selection.End(xlToLeft).Column
      Cells(row, col).Select
      If IsEmpty(Selection) Then
        Cells(row, 1).Select
      End If
    End If
  End If
End Sub
Public Sub go_contiguous_right()
  Dim col As Long
  Dim row As Long
  col = Selection.End(xlToRight).Column
  row = Selection.row
  Cells(row, col).Select
  If IsEmpty(Selection) Then
    Cells(row+1, 1).Select
    If IsEmpty(Selection) Then
      row = Selection.row
      col = Selection.End(xlToRight).Column
      Cells(row, col).Select
      If IsEmpty(Selection) Then
        Cells(row, 1).Select
      End If
    End If
  End If
End Sub

' insert rows 
Public Sub insert_row_above()
  Dim row As Long
  row = Selection.row
  Rows(row & ":" & row).EntireRow.Insert
  Cells(row, Selection.Column).Select
  Application.SendKeys "{F2}"
End Sub
Public Sub insert_row_below()
  Dim row As Long
  row = Selection.row
  Rows(row + 1 & ":" & row + 1).EntireRow.Insert
  Cells(row + 1, Selection.Column).Select
  Application.SendKeys "{F2}"
End Sub

' delete rows, cells
Public Sub delete_row()
  Dim row As Long
  row = Selection.row
  Rows(row & ":" & row).EntireRow.Delete
  Cells(row, Selection.Column).Select
  Application.SendKeys "{F2}"
End Sub
Public Sub delete_cell()
  Application.SendKeys "{DEL}"
End Sub

' absolute movements
Public Sub go_a1()
  Range("A1").Select
End Sub
Public Sub go_top()
  Dim w As Window
  Set w = ActiveWindow
  ' w.SmallScroll down:=-9999
  ' w.LargeScroll Down:=1
  ' w.ScrollRow = Selection.Row
  Cells(w.ScrollRow, Selection.Column).Select
End Sub
Public Sub go_begin_of_row()
  Dim thisRow As Long
  thisRow = Selection.row
  Cells(thisRow, 1).Select
End Sub
Public Sub go_end_of_row()
  Dim lastColumn As Long
  Dim thisRow As Long
  lastColumn = Cells.SpecialCells(xlCellTypeLastCell).Column
  thisRow = Selection.row
  Cells(thisRow, lastColumn).Select
End Sub
Public Sub go_bottom()
  Dim new_view_row As Long, old_view_row As Long
  Dim w As Window
  Set w = ActiveWindow
  old_view_row = w.ScrollRow
  Application.ScreenUpdating = False
  w.LargeScroll Down:=1
  new_view_row = w.ScrollRow
  w.ScrollRow = old_view_row
  Application.ScreenUpdating = True
  Cells(new_view_row - 1, Selection.Column).Select
End Sub
Public Sub go_mid()
  Dim new_view_row As Long
  Dim old_view_row As Long
  Dim w As Window
  Set w = ActiveWindow
  old_view_row = w.ScrollRow
  Application.ScreenUpdating = False
  w.LargeScroll Down:=1
  new_view_row = w.ScrollRow
  w.ScrollRow = old_view_row
  Application.ScreenUpdating = True
  Cells(Int((new_view_row - old_view_row) / 2), Selection.Column).Select
End Sub
Public Sub page_up()
  Application.SendKeys "{PGUP}"
End Sub
Public Sub page_down()
  Application.SendKeys "{PGDN}"
End Sub


