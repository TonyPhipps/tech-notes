# Return the cell value for the record that matches the search conditions.
```
LOOKUPVALUE(
    <result_columnName>,
    <search_columnName>, <search_value>
    [, <search2_columnName>, <search2_value>]…
    [, <alternateResult>]
)
```

example
```
NewColumn = 
LOOKUPVALUE (
    'TableB'[Name],
    'TableB'[Id], 'TableA'[Id],
    'No Match'
)
```


# Display Rows in Table1 With No Related Rows in Table2
```
Table1_No_Table2 = 
COUNTROWS( 
    FILTER(
        Table1,
        ISEMPTY(RELATEDTABLE(Table2))
    )
)
```

# Add in Table1 Rows a Count of Matches in Table2
- First Approach is better if you want to show the row and value when there are NO matches ("0") when filter across panels.
In Table2:
```
CountRows_Table2 = COALESCE(COUNTROWS(Table2), 0)
```

In Table1:
Nothing, just add the CountRows_Table2 to Table1 slicer(s)

- 2nd Approach is best when you want to hide the entire row when there is no match when filtering across panels.
Note that this is rarely better than the first approach. In Table2, add a New Column (in PowerBI) with the formula
```
Count = 1
```