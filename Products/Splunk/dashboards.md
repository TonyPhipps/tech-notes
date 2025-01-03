# Strange Notes
- If you want to share URLs that sets Inputs automatically, every Input must NOT set their input in <init>. Use of <init> to set tokens ignores the URL bar. Note that other, non-Input tokens are never stored in the URL, and are therefore not shareable.
- If you want to disable auto-searching entirely, Inputs that have a <change> defined in XML may end up still auto-searching.


# Theme
Set theme to light/dark via URL
```
https://splunk.com/en-US/app/myapp/mydashboard?theme="light"
```

### Tokens

```$env:user$``` 	          Current user's username

```$env:user_realname$``` 	Current user full name.

```$env:user_email$``` 	    Current user email address.

```$env:user_timezone$``` 	Resolves the timezone to the user's preferred timezone. The token resolves to the default system timezone or the localized equivalent if the user doesn't specify a timezone.

```$env:app$```           	Current app context

```$env:locale$``` 	        Current locale

```$env:page$``` 	          Currently open page

```$env:product$``` 	      Current instance product type

```$env:instance_type$``` 	Indicates whether the current instance is a Splunk Cloud Platform or Splunk Enterprise deployment

```$env:is_cloud$``` 	      Indicates if the current instance is Splunk Cloud Platform. This token is only set when "true".

```$env:is_enterprise$``` 	Indicates if the current instance is a Splunk Enterprise deployment. This token is only set when "true".

```$env:is_hunk$``` 	      Indicates if the current instance is a Hunk deployment. This token is only set when "true".

```$env:is_lite$``` 	      Indicates if the current instance is a Splunk Light deployment. This token is only set when "true".

```$env:is_lite_free$``` 	  Indicates if the current instance is using a Splunk Light free license. This token is only set when "true".

```$env:is_free$``` 	      Indicates if the current instance is using a Splunk Enterprise free license. This token is only set when "true".

```$env:version$``` 	      Current instance product version 


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

### Checkbox to Toggle Tokens
```
<input type="checkbox" token="Checked" searchWhenChanged="true">
      <label></label>
      <choice value="yes">Checkbox Text</choice>
      <delimiter> </delimiter>
      <change>
        <condition value="yes">
          <set token="TokenToChange">ValueWhenChecked</set>
        </condition>
        <condition>
          <set token="TokenToChange">ValueWhenNotChecked</set>
        </condition>
      </change>
    </input>
```

### Dynamic Dropdown to Toggle Tokens
This sample provides a dropdown that dynamically builds its dropdown list (Display+Value) based on a search, then sets tokens accordingly.

```
<input type="dropdown">
      <label>A vs B vs C</label>
      <change>
        <condition value="selection_a">
          <set token="dropdownSelection">A</set>
        </condition>
        <condition value="selection_b">
          <set token="dropdownSelection">B</set>
        </condition>
        <condition value="selection_c">
          <set token="dropdownSelection">C</set>
        </condition>
      </change>
      <fieldForLabel>MenuDisplayString</fieldForLabel>
      <fieldForValue>MenuValueString</fieldForValue>
      <selectFirstChoice>true</selectFirstChoice>
      <search>
        <query>
          | eventcount summarize=false index=something 
          | eval whichOne = case(
            match(_raw,"term_a"),"result_a",
            match(_raw,"term_b"),"result_b",
            match(_raw,"term_c"),"result_c"
            ) 
          | stats sum(count) as count by whichOne
          | eval MenuDisplayString = case(
            match(whichOne,"result_a"),"Choose A",
            match(whichOne,"result_b"),"Choose B",
            match(whichOne,"result_c"),"Choose C"
            )
          | eval MenuValueString = case(
            match(whichOne,"result_a"),"selection_a",
            match(whichOne,"result_b"),"selection_b",
            match(whichOne,"result_c"),"selection_c"
            )
          | fields whichOne MenuDisplayString MenuValueString
          | sort whichOne
      </query>
        <earliest>-7d@d</earliest>
        <latest>now</latest>
      </search>
    </input>
```


### Auto Filter Special Characters when Assigning Dashboard Tokens
When using the contents of a search to assign a variable to a value via click action, use ```$tokenname|s$``` to get Splunk to parse as a string, rather than attempting to pick up characters like ```\``` as an escape character.

- NOT in the Drilldown definition, in the search string.
- Do not use quotes around the variable $'s.

### Colorize a Table
```
<format type="color">
          <colorPalette type="expression">case(value &lt; 2, "#A2CC3E", value &lt; 5, "#FFC300", value &gt; 4, "#FF5733", 1==1, "#555555")</colorPalette>
        </format>
```


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

Add this just after the \<title> closes for the panel you'd like to be collapsible.
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


### Parse Data From Background Search to Token

NOTE: Requires the "dispatch_rest_to_indexers" capability/permission.

```
<search>
  <query>| rest /servicesNS/-/-/data/ui/views search="eai:acl.app=$env:app$ label=$env:page$"
| rex field="eai:data" "theme\=\"(?&lt;theme&gt;.+?)\""
| stats values(theme) as theme</query>
  <earliest>0</earliest>
  <latest></latest>
  <done>
    <set token="theme_tok">$result.theme$</set>
  </done>
</search>
```


### Add Hidden Tokens to URL for Full Dashboard Sharing
Only Input tokens are stored on the URL line and are included when you copy/paste a URL to another person. The way to include non-input tokens in the URL is to migrate them into hidden inputs.

First, remove any <init>'s for the tokens to be migrated.

```
<input type="text" token="myToken" depends="$hidden$" searchWhenChanged="true">
      <label>myToken</label>
      <initialValue>*</initialValue>
    </input>
```

 Ensuring searchWhenChanged is set to true causes the URL to be updated as the token (and therefore Input value) is updated by things like a Drilldown definition in a Widget. To set up a widget to do this, use this code.

 ```
<drilldown>
          <set token="myToken">$click.value$</set>
          <set token="form.myToken">$click.value$</set>
        </drilldown>
 ```

### Reset All of a Dashboard's Tokens
This code will add a thin vertical HTML widget with a Reset Dashboard link on it. This link simply sends the user to "naked" version of the dashboard with no tokens defined within the URL.

```
<row>
    <panel>
      <html>
        <div style="float:left">
          <a href="/app/$env:app$/$env:page$" style="display:flex">
            <i class="icon-rotate"/>
            <div style="padding-left:5px;">Reset Dashboard</div>
          </a>
        </div>
      </html>
    </panel>
  </row>
  <row>
```

### Reset SOME Of a Dashboard's Tokens
```
<input type="radio" token="resetTokens" searchWhenChanged="true">
  <label></label>
  <choice value="reset">Reset Inputs</choice>
  <choice value="retain">Retain</choice>
  <default>retain</default>
  <change>
    <condition value="reset">
      <unset token="token1"></unset>
      <unset token="token2"></unset>
      <unset token="token3"></unset>
      <set token="resetTokens">retain</set>
    </condition>
  </change>
</input>
```

### Hide a Panel Until a Token is Set via Drilldown
```
<form version="1.1">
  <label>Your Label</label>
  <description>Your Description</description>
  <init>
    <unset token="show_this_panel"></unset>
  </init>

  ....
  <row>
    <panel>
        <table>
          <title>Panel that Shows the Hidden Panel via Drilldown</title>
          <search>
            <query>
              | search stuff
            </query>
            <drilldown>
              <set token="show_this_panel">true</set>
              <set token="my_token">$click.value$</set>
          </drilldown>
          </search>
    </panel>
    
    <panel depends="$show_this_panel$">
      <table>
          <title>Hidden Panel</title>
            <query>
              | search stuff $my_token$
            </query>
    </panel>
  </row>
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
