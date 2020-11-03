Sub send_Notes_email()

    Dim wb As Workbook: Set wb = ThisWorkbook

    Dim subject As String: subject = wb.Worksheets("Email").Range("email_subject").Value
    Dim recipients As Variant: recipients = wb.Worksheets("Email").Range("recipients").Value
    Dim carbon_copy As Variant: carbon_copy = wb.Worksheets("Email").Range("carbon_copy").Value
    Dim body_blocks As Range: Set body_blocks = wb.Worksheets("Email").Range("body_blocks")

    'start Notes session
    Dim Notes_Session As Object:
        Set Notes_Session = CreateObject("Notes.NotesSession")
    Dim Notes_Database As Object:
        Set Notes_Database = Notes_Session.GETDATABASE("", "")
    Call Notes_Database.OPENMAIL
    If Not Notes_Database.IsOpen Then
        If Not Notes_Database.Open("", "") Then
            MsgBox "Can't open mail file: " & Notes_Database.SERVER & " " & Notes_Database.FILEPATH
            Exit Sub
        End If
    End If
    Set NUI_work_space = CreateObject("Notes.NotesUIWorkspace")

    'create document
    Dim doc As Object:
        Set doc = Notes_Database.CreateDocument
    doc.Form = "Memo" 'AKA email
    doc.subject = subject
    doc.sendto = recipients
    doc.copyto = carbon_copy

    Set doc_body_content = doc.CreateRichTextItem("BODY")
    Set block_style = Notes_Session.CreateRichTextStyle

    Dim body_block As Range
    For Each body_block In body_blocks

        'check for attachments
        Dim body_block_portions As Variant, portion As Variant, body_block_file_paths As Variant
        body_block_portions = Split(Replace(body_block.Value, "<file>", "</file>"), "</file>")
        body_block_file_paths = file_paths_from_text(body_block.Value)

        For Each portion In body_block_portions

            If Not is_in_array(portion, body_block_file_paths) Then

                'text styling
                block_style.Bold = body_block.Font.Bold
                block_style.Italic = body_block.Font.Italic
                block_style.FontSize = body_block.Font.Size
                If body_block.Font.Underline = -4142 Then
                    block_style.Underline = False
                Else: block_style.Underline = True
                End If
                If body_block.Font.ColorIndex = -4105 Then
                    block_style.notescolor = 0
                Else: block_style.notescolor = body_block.Font.ColorIndex - 1
                End If
            
                doc_body_content.AppendStyle block_style
                doc_body_content.appendtext portion

            Else

                block_style.Bold = False
                block_style.Italic = False
                block_style.notescolor = BLACK
                block_style.Underline = False
                block_style.FontSize = body_block.Font.Size
                doc_body_content.AppendStyle block_style
                Call doc_body_content.EmbedObject(1454, "", portion) '1454: attachment

            End If
            
        Next portion

    Next body_block

    'send email
    doc.SaveMessageOnSend = True
    doc.Importance = "2" '1: high, 2: normal
    doc.postdate = Date
    'doc.Send False 'False: don't attach form
    doc.Save True, False

    'open the user interface so we can paste in images
    Set NUIdoc = NUI_work_space.EDITDocument(True, doc)
    NUIdoc.GoToField "BODY"
    NUIdoc.FINDSTRING "<dummy_image>"
    wb.Worksheets("Email").Range("dummy_data").CopyPicture
    NUIdoc.Paste
    NUIdoc.Send
    NUIdoc.Close


    'rid vars
    Set Notes_Session = Nothing
    Set Notes_Database = Nothing
    Set doc = Nothing
    Set NUI_work_space = Nothing
    MsgBox "Done"

End Sub

Public Function array_len(arr As Variant) As Integer
    array_len = UBound(arr) - LBound(arr) + 1
End Function

Public Function is_in_array(stringToBeFound As Variant, arr As Variant) As Boolean
    Dim i
    For i = LBound(arr) To UBound(arr)
        If arr(i) = stringToBeFound Then
            is_in_array = True
            Exit Function
        End If
    Next i
    is_in_array = False
End Function

Public Function file_paths_from_text(text As String) As Variant:
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
    file_paths_from_text = file_paths
End Function
