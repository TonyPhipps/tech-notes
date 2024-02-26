### Search Base
At the top:
```
<search id="base1">
  <query>
    index="index_name" (ProductName=#1# OR ProductName=#2# OR ProductName=#3# OR etc.) 
    | stats count by host ProductName
  </query>
  <earliest>$TimeRange.earliest$</earliest>
  <latest>$TimeRange.latest$</latest>
  <sampleRatio>1</sampleRatio>
</search>
```

At the applicable widget(s):
```
<search base="base1">
  <query>
    search ProductName="Skype"
    | stats count
  </query>
</search>
```

### Auto Filter Special Characters when Assigning Dashboard Tokens
When using the contents of a search to assign a variable to a value via click action, use ```$click.value|s$``` to get Splunk to parse as a string, rather than attempting to pick up characters like ```\``` as an escape character.


### Colorize a Table
```
<format type="color">
          <colorPalette type="expression">case(value &lt; 2, "#A2CC3E", value &lt; 5, "#FFC300", value &gt; 4, "#FF5733", 1==1, "#555555")</colorPalette>
        </format>
```


### Sample Dashboard
This approach allows an analyst to gain familiarity with an event source and quickly investigate any suspicious activity in those logs.

- Presents filters for time and key fields at the top
- Leverages radio buttons to reset filters
- Multiple widgets used to aggregate key fields
- Widgets leverage tokens to allow cross-widget filtering (based on clicking a cell containing a value)
- Shows all relevant fields for matching events

<details>

```
```

</details>




### Add Expand/Collapse Buttons to Panels

<details>

Add this to your init section
```
...
<init>
    <set token="showExpandLink1">true</set>
    <set token="showExpandLink2">true</set>
    <set token="showExpandLink3">true</set>
    <set token="showExpandLink4">true</set>
    <set token="showExpandLink5">true</set>
    <set token="showExpandLink6">true</set>
    <set token="showExpandLink7">true</set>
    <set token="showExpandLink8">true</set>
    <set token="showExpandLink9">true</set>
    <set token="showExpandLink10">true</set>
  </init>
...
```

Add this as your first \<row\>
```
...
  <row depends="$alwaysHideCSSStyleOverride$">
    <panel>
      <html>
      <html>
        <style>
          div[id^="linkCollapse"],
          div[id^="linkExpand"]{
            width: 64px !important;
            float: right;
          }
          div[id^="linkCollapse"] button,
          div[id^="linkExpand"] button{
            flex-grow: 0;
            border-radius: 25px;
            border-width: thin;
            border-color: lightgrey;
            border-style: inset;
            width: 32px;
            padding: 10px;
          }
          div[id^="linkCollapse"] label,
          div[id^="linkExpand"] label{
            display:none;
          }
          div[id^="panel"].fieldset{
            padding: 0px;
          }
        </style>
      </html>
      </html>
    </panel>
  </row>
...
```

Add this just after the <title> closes for the panel you'd like to be collapsible.
```
...
</title>
      <input id="linkCollapse1" type="link" token="tokLinkCollapse1" searchWhenChanged="true" depends="$showCollapseLink1$">
        <label></label>
        <choice value="collapse">vvv</choice>
        <change>
          <condition value="collapse">
            <unset token="showCollapseLink1"></unset>
            <set token="showExpandLink1">true</set>
            <unset token="form.tokLinkCollapse1"></unset>
          </condition>
        </change>
      </input>
      <input id="linkExpand1" type="link" token="tokLinkExpand1" searchWhenChanged="true" depends="$showExpandLink1$">
        <label></label>
        <choice value="expand">>>></choice>
        <change>
          <condition value="expand">
            <set token="showCollapseLink1">true</set>
            <unset token="showExpandLink1"></unset>
            <unset token="form.tokLinkExpand1"></unset>
          </condition>
        </change>
      </input>
      <table rejects="$showExpandLink1$">
        <search>
		...
  ```
</details>
