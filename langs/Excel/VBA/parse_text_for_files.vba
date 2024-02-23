Public Function return_file_paths_from_text(text As String) As Variant:

    Dim file_paths() As String, itr As Integer
    
    itr = 0
    ReDim Preserve file_paths(itr)
    While (InStr(text, "<file>") <> 0)
        front_text = Split(text, "<file>", 2)(0)
        rest_text = Split(text, "<file>", 2)(1)
        file_path = Split(rest_text, "</file>", 2)(0)
        end_text = Split(text, "</file>", 2)(1)

        ReDim Preserve file_paths(0 To itr)
        file_paths(itr) = file_path
        itr = itr + 1
        text = end_text
    Wend

    return_file_paths_from_text = file_paths
    
End Function
