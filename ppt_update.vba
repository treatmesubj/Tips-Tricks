Sub update_links(Optional workbook_path As Variant) '8/18/20 John Hupperts

    'This subroutine prepends an Excel workbook file-path to each implicit linked-object link
    'in this PowerPoint. It then updates all of the linked objects, so that their data
    'reflects the data in the now linked workbook. This solves the issue of the Microsoft suite
    'no longer supporting a non-automatic simultaneous update of multiple linked objects; it's
    'incredibly tedious to update each link one-by-one by hand.
    'Note: This relies on VBA Tool Reference to Microsoft Excel Object Library to use Excel.Application Object
    
    If IsMissing(workbook_path) Then
        Dim fd As FileDialog: Set fd = Application.FileDialog(msoFileDialogFilePicker)
        With fd
            .Title = "Select Excel file to link and refresh PPT objects"
            .AllowMultiSelect = False
            .InitialFileName = "C:\"
            If .Show = -1 Then
                workbook_path = .SelectedItems(1)
                Dim xlApp As Excel.Application: Set xlApp = New Excel.Application: xlApp.Visible = True
                xlApp.Workbooks.Open workbook_path
            End If
        End With
    End If

    'Declare PowerPoint Variables
    Dim PPTSlide As Slide
    Dim PPTShape As Shape
    Dim FileName As String
    Dim Position As Integer

    For Each PPTSlide In ActivePresentation.Slides
        For Each PPTShape In PPTSlide.Shapes
            'If Shape is linked
            If PPTShape.Type = msoLinkedPicture Or PPTShape.Type _
                = msoLinkedOLEObject Or PPTShape.Type = msoLinkedChart Then
                
                template = "!" & Split(PPTShape.LinkFormat.SourceFullName, "!", 2)(1)
                
                PPTShape.LinkFormat.SourceFullName = workbook_path & template
                Debug.Print PPTShape.LinkFormat.SourceFullName
                PPTShape.LinkFormat.Update
                PPTShape.LinkFormat.SourceFullName = template
                'PPT attempts to open old source-file, which is super slow
                'so, changing the source to an implicit one will avoid that

            End If
        Next PPTShape
    Next PPTSlide

    ActivePresentation.Save
    
    MsgBox "Done Updating Links"
    
End Sub


Sub update_ppt() '8/18/20 John Hupperts

    'This Excel workbook has an embedded PowerPoint; the PPT has static data and is internal.
    'Though the PPT is simply embedded, it has implicit links to objects(charts, pictures, shapes).
    'This subroutine creates an external copy of the embedded PPT in the same 
    'directory/file-path of this workbook. It then opens that PPT file and calls the 
    'PPT's subroutine: "update_links", which updates all of its linked objects so that
    'they reference this workbook's objects and then refreshes the PPT's data.
    'This solves the issue of the nature of this workbook being a living file,
    'constantly changing names/daily copies being made and being sent to others. Links between the
    'PPT and its correct copy of this workbook would always be broken.

    ThisWorkbook.Activate
    Dim pptOLEobj As OLEObject
    Set pptOLEobj = ThisWorkbook.Sheets("START HERE").OLEObjects("exec_ppt")
    
    Dim ppt_file_name As String: ppt_file_name = "Americas Exec STG Load Report.pptm"
    Dim ppt_file_path As String: ppt_file_path = ThisWorkbook.Path & "\" & ppt_file_name
    
    Dim PPapp As Object: Set PPapp = CreateObject("PowerPoint.Application")
    pptOLEobj.Verb xlVerbOpen
    With pptOLEobj.Object
        .SaveCopyAs ppt_file_path
        .Close
    End With: Set pptOLEobj = Nothing
    
    Dim ppt_copy_obj As Object: Set ppt_copy_obj = PPapp.Presentations.Open(ppt_file_path)
    
    Dim macro_name As String: macro_name = ppt_file_name & "!update_links"
    PPapp.Run macro_name, ThisWorkbook.FullName 'macro in PowerPoint file
    'excel path (ThisWorkbook.Fullname) is arg for update_links (macro in PPT file)

End Sub
