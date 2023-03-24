Compare Cell B2 to LookupSheet and find a matching row, then populate this Cell with the LookupSheet's 4th column
```
=VLOOKUP(B2,LookupSheet,4,FALSE)
```

Compare cell B2 to LookupSheet's column B and find a matching row, then populate this Cell with the LookupSheet's matching row's column A cell contents.
```
=INDEX('LookupSheet'!A:A,MATCH(B2,'LookupSheet'!B:B,0))
```

Make the contents of this cell match that of another after a string substitution
```
=SUBSTITUTE(A2,"currentstring","newstring")
```

Two or more string replacements (copy/paste into A2 to continue nesting)
```
=SUBSTITUTE(SUBSTITUTE(A2,"currentstring1","newstring1"),"currentstring2","newstring2")
```

Hide "#N/A" when formulas error-out
```
=IFERROR(your formula here,"") 
```

Convert Time Format and Timezone Offet

Fri, Jan 11 2021 12:24AM MST

```="05:00" + (DATEVALUE(MID(C2, 10, 2) & "-" & MID(C2, 6, 3) & "-" & MID(C2, 13, 4)) + (MID(C2, 18, 5) & " " & MID(C2, 23, 2)))```

Where "05:00" is the time offset, currently adding 5h to make it GMT

## Identify Blank Columns
- Insert a row above the Header row
- Paste the formula into A1
- Click-drag to replicate the formula across all columns in scope.
- Those with TRUE as a result are blank. These can be deleted, hidden, etc. as needed.
```
=COUNTA(A3:A1048576)=0
```



## Remove blank Columns with VBA
- Alt+F11
- Insert > Module
- Paste

<details>

```
Public Sub DeleteEmptyColumns()
    Dim SourceRange As Range
    Dim EntireColumn As Range
 
    On Error Resume Next
 
    Set SourceRange = Application.InputBox( _
        "Select a range:", "Delete Empty Columns", _
        Application.Selection.Address, Type:=8)
 
    If Not (SourceRange Is Nothing) Then
        Application.ScreenUpdating = False
 
        For i = SourceRange.Columns.Count To 1 Step -1
            Set EntireColumn = SourceRange.Cells(1, i).EntireColumn
            If Application.WorksheetFunction.CountA(EntireColumn) = 0 Then
                EntireColumn.Delete
            End If
        Next
 
        Application.ScreenUpdating = True
    End If
End Sub
```

</details>

- F5 to run.


## Allow Multiselect in Data Validation Dropdowns

<details>

```
Private Sub Worksheet_Change(ByVal Target As Range)
    'Updated by Extendoffice 2023/01/11
    'Updated by Ken Gardner 2022/07/11
    Dim xRng As Range
    Dim xValue1 As String
    Dim xValue2 As String
    Dim semiColonCnt As Integer
    Dim xType As Integer
    If Target.Count > 1 Then Exit Sub
    On Error Resume Next
    
    xType = 0
    xType = Target.Validation.Type
    If xType = 3 Then
        Application.ScreenUpdating = False
        Application.EnableEvents = False
        xValue2 = Target.Value
        Application.Undo
        xValue1 = Target.Value
        Target.Value = xValue2
        If xValue1 <> "" Then
            If xValue2 <> "" Then
                If xValue1 = xValue2 Or xValue1 = xValue2 & ";" Or xValue1 = xValue2 & "; " Then ' leave the value if only one in list
                    xValue1 = Replace(xValue1, "; ", "")
                    xValue1 = Replace(xValue1, ";", "")
                    Target.Value = xValue1
                ElseIf InStr(1, xValue1, "; " & xValue2) Then
                    xValue1 = Replace(xValue1, xValue2, "") ' removes existing value from the list on repeat selection
                    Target.Value = xValue1
                ElseIf InStr(1, xValue1, xValue2 & ";") Then
                    xValue1 = Replace(xValue1, xValue2, "")
                    Target.Value = xValue1
                Else
                    Target.Value = xValue1 & "; " & xValue2
                End If
                Target.Value = Replace(Target.Value, ";;", ";")
                Target.Value = Replace(Target.Value, "; ;", ";")
                If Target.Value <> "" Then
                    If Right(Target.Value, 2) = "; " Then
                        Target.Value = Left(Target.Value, Len(Target.Value) - 2)
                    End If
                End If
                If InStr(1, Target.Value, "; ") = 1 Then ' check for ; as first character and remove it
                    Target.Value = Replace(Target.Value, "; ", "", 1, 1)
                End If
                If InStr(1, Target.Value, ";") = 1 Then
                    Target.Value = Replace(Target.Value, ";", "", 1, 1)
                End If
                semiColonCnt = 0
                For i = 1 To Len(Target.Value)
                    If InStr(i, Target.Value, ";") Then
                        semiColonCnt = semiColonCnt + 1
                    End If
                Next i
                If semiColonCnt = 1 Then ' remove ; if last character
                    Target.Value = Replace(Target.Value, "; ", "")
                    Target.Value = Replace(Target.Value, ";", "")
                End If
            End If
        End If
        Application.EnableEvents = True
        Application.ScreenUpdating = True
    End If
End Sub
```

</details>