Return the cell value for the record that matches the search conditions.
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
