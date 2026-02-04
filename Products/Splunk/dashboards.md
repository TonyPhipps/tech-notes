- [Strange Notes](#strange-notes)
- [Theme](#theme)
- [Tokens](#tokens)
  - [Checkbox to Toggle Tokens](#checkbox-to-toggle-tokens)
  - [Provide a Field for Tokens, but do Not Display to User](#provide-a-field-for-tokens-but-do-not-display-to-user)
  - [Dynamic Dropdown to Toggle Tokens](#dynamic-dropdown-to-toggle-tokens)
  - [Auto Filter Special Characters when Assigning Dashboard Tokens](#auto-filter-special-characters-when-assigning-dashboard-tokens)
  - [Parse Data From Background Search to Token](#parse-data-from-background-search-to-token)
  - [Add Hidden Tokens to URL for Full Dashboard Sharing](#add-hidden-tokens-to-url-for-full-dashboard-sharing)
  - [Reset All of a Dashboard's Tokens](#reset-all-of-a-dashboards-tokens)
  - [Reset SOME Of a Dashboard's Tokens](#reset-some-of-a-dashboards-tokens)
  - [Hide a Panel Until a Token is Set via Drilldown](#hide-a-panel-until-a-token-is-set-via-drilldown)
  - [Hide a Panel Until Results are Found](#hide-a-panel-until-results-are-found)
- [Search Base](#search-base)
  - [Search Base WITH Export Button](#search-base-with-export-button)
- [Include a Keyword search bar](#include-a-keyword-search-bar)
- [Colorize a Table](#colorize-a-table)
- [Add Expand/Collapse Buttons to Panels](#add-expandcollapse-buttons-to-panels)


# Strange Notes
- If you want to share URLs that sets Inputs automatically, every Input must NOT set their input in <init>. Use of <init> to set tokens ignores the URL bar. Note that other, non-Input tokens are never stored in the URL, and are therefore not shareable.
- If you want to disable auto-searching entirely, Inputs that have a <change> defined in XML may end up still auto-searching.


# Theme
Set theme to light/dark via URL
```
https://splunk.com/en-US/app/myapp/mydashboard?theme="light"
```

# Tokens

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


## Checkbox to Toggle Tokens
```xml
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


## Provide a Field for Tokens, but do Not Display to User
Right after the widget's closing search, you can define a <fields> tag to hide some of the | fields chosen within the search.
```xml
...
</search>
<fields>col1, col2</fields>
```


## Dynamic Dropdown to Toggle Tokens
This sample provides a dropdown that dynamically builds its dropdown list (Display+Value) based on a search, then sets tokens accordingly.

```xml
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


## Auto Filter Special Characters when Assigning Dashboard Tokens
When using the contents of a search to assign a variable to a value via click action, use ```$tokenname|s$``` to get Splunk to parse as a string, rather than attempting to pick up characters like ```\``` as an escape character.

- NOT in the Drilldown definition, in the search string.
- Do not use quotes around the variable $'s.


## Parse Data From Background Search to Token

NOTE: Requires the "dispatch_rest_to_indexers" capability/permission.

```xml
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


## Add Hidden Tokens to URL for Full Dashboard Sharing
Only Input tokens are stored on the URL line and are included when you copy/paste a URL to another person. The way to include non-input tokens in the URL is to migrate them into hidden inputs.

First, remove any <init>'s for the tokens to be migrated.

```xml
<input type="text" token="myToken" depends="$hidden$" searchWhenChanged="true">
      <label>myToken</label>
      <initialValue>*</initialValue>
    </input>
```

 Ensuring searchWhenChanged is set to true causes the URL to be updated as the token (and therefore Input value) is updated by things like a Drilldown definition in a Widget. To set up a widget to do this, use this code.

 ```xml
<drilldown>
          <set token="myToken">$click.value$</set>
          <set token="form.myToken">$click.value$</set>
        </drilldown>
 ```

## Reset All of a Dashboard's Tokens
This code will add a thin vertical HTML widget with a Reset Dashboard link on it. This link simply sends the user to "naked" version of the dashboard with no tokens defined within the URL.

```xml
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

## Reset SOME Of a Dashboard's Tokens
```xml
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

## Hide a Panel Until a Token is Set via Drilldown
```xml
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
            </search>
            <drilldown>
              <set token="show_this_panel">true</set>
              <set token="my_token">$click.value$</set>
          </drilldown>
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

NOTE: Alternatively, specify a column's value regardless of where they click in the row via ```$row.fieldname$```


## Hide a Panel Until Results are Found
```
<panel depends="$show_panel$">
       <chart>
         <search>
           <query>...</query>
           <progress>
             <condition match="'job.resultCount'==0">
               <unset token="show_panel"></unset>
             </condition>
             <condition>
               <set token="show_panel">true</set>
             </condition>
           </progress>
         </search>
       </chart>
     </panel>
```


# Search Base
At the top:
```xml
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
```xml
<search base="base1">
  <query>
    search ProductName="Skype"
    | stats count
  </query>
</search>
```

## Search Base WITH Export Button
This approach allows using a base job while retaining the "export results" option in each widget.
Base Search
```xml
<done>
  <condition>
    <set token="[basename]_sid">$job.sid$</set>
  </condition>
</done>
```

Widget Search
```
<search depends="[basename]_sid">
  <query>| loadjob "[basename]_sid"
```


# Include a Keyword search bar
```sql
<input type="text" token="Keyword" searchWhenChanged="true">
      <label>Keyword</label>
      <default></default>
      <change>
    <condition match="len(value)=0">
      <set token="Keyword"></set>
    </condition>
    <condition>
      <set token="Keyword">"*$value$*"</set>
    </condition>
  </change>
    </input>
```

in the search:
```sql
| search $Keyword$

```


# Colorize a Table
```
<format type="color">
          <colorPalette type="expression">case(value &lt; 2, "#A2CC3E", value &lt; 5, "#FFC300", value &gt; 4, "#FF5733", 1==1, "#555555")</colorPalette>
        </format>
```


# Add Expand/Collapse Buttons to Panels

<details>

Add this to your init section
```xml
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
```xml
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
```xml
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



### Sample Dashboard
This dashboard approach allows an analyst to gain familiarity with an event source and quickly investigate any suspicious activity in those logs.

- Presents filters for time and key fields at the top
- Leverages html link button to reset filters by redirecting to the dashboard without tokens set
- A widget to aggregate each  key field
- Widgets that, when a row is clicked, sets tokens to allow cross-widget filtering

<details>

```
<form theme="dark" version="1.1">
  <label>REC - Autoruns</label>
  <search id="Autoruns">
    <query>
        index IN ($index$) sourcetype=REC:Output:CSV dataset=Autoruns $Keyword$ NOT RecModuleErrorMessage IN ("Skipped", "No Results")
        | fields _time host DateScanned Caption Command Name User UserSID Location
        | eval _time = strptime(DateScanned, "%Y-%m-%d %T%Z")
        | eventstats max(_time) as latest by host
        | where _time=latest
        | foreach host Caption Command Name User UserSID Location [ eval &lt;&lt;FIELD&gt;&gt; = if( (len(&lt;&lt;FIELD&gt;&gt;)=0 OR (&lt;&lt;FIELD&gt;&gt;)="" OR isnull(&lt;&lt;FIELD&gt;&gt;)), "-", &lt;&lt;FIELD&gt;&gt;) ]
        | search host=$host|s$ Caption=$Caption|s$ Command=$Command|s$ Name=$Name|s$ User=$User|s$ UserSID=$UserSID|s$ Location=$Location|s$
      </query>
    <earliest>$TimeRange.earliest$</earliest>
    <latest>$TimeRange.latest$</latest>
    <sampleRatio>1</sampleRatio>
  </search>
  <fieldset submitButton="true" autoRun="true">
    <input type="time" token="TimeRange" searchWhenChanged="false">
      <label>Time Range</label>
      <default>
        <earliest>-24h@h</earliest>
        <latest>now</latest>
      </default>
    </input>
    <input type="multiselect" token="index" searchWhenChanged="false">
      <label>Index</label>
      <choice value="mystuff-*">All</choice>
      <fieldForLabel>index</fieldForLabel>
      <fieldForValue>index</fieldForValue>
      <search>
        <query>| tstats count where index=mystuff-* sourcetype=REC:Output:CSV by index</query>
        <earliest>-7d@h</earliest>
        <latest>now</latest>
      </search>
      <delimiter>, </delimiter>
      <valuePrefix>"</valuePrefix>
      <valueSuffix>"</valueSuffix>
    </input>
    <input type="text" token="Keyword" searchWhenChanged="true">
      <label>Keyword</label>
	      <default></default>
      <change>
		    <condition match="len(value)=0">
		      <set token="Keyword"></set>
		    </condition>
		    <condition>
		      <set token="Keyword">"*$value$*"</set>
		    </condition>
		  </change>
    </input>
    <input type="text" token="host" depends="$show_host$" searchWhenChanged="true">
      <label>host</label>
      <default>*</default>
    </input>
    <input type="text" token="Caption" depends="$show_Caption$" searchWhenChanged="true">
      <label>Caption</label>
      <default>*</default>
    </input>
    <input type="text" token="Command" depends="$show_Command$" searchWhenChanged="true">
      <label>Command</label>
      <default>*</default>
    </input>
    <input type="text" token="Name" depends="$show_Name$" searchWhenChanged="true">
      <label>Name</label>
      <default>*</default>
    </input>
    <input type="text" token="User" depends="$show_User$" searchWhenChanged="true">
      <label>User</label>
      <default>*</default>
    </input>
    <input type="text" token="UserSID" depends="$show_UserSID$" searchWhenChanged="true">
      <label>UserSID</label>
      <default>*</default>
    </input>
    <input type="text" token="Location" depends="$show_Location$" searchWhenChanged="true">
      <label>Location</label>
      <default>*</default>
    </input>
  </fieldset>
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
    <panel>
      <title>Host</title>
      <table>
        <search base="Autoruns">
          <query>
| stats count by host
| sort - count</query>
        </search>
        <option name="count">10</option>
        <option name="dataOverlayMode">none</option>
        <option name="drilldown">cell</option>
        <option name="percentagesRow">false</option>
        <option name="refresh.display">progressbar</option>
        <option name="rowNumbers">false</option>
        <option name="totalsRow">false</option>
        <option name="wrap">true</option>
        <drilldown>
          <set token="host">$row.host$</set>
          <set token="form.host">$row.host$</set>
          <set token="show_host">$row.host$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>Name</title>
      <table>
        <search base="Autoruns">
          <query>
| stats count by Name
| sort - count</query>
        </search>
        <option name="count">10</option>
        <option name="dataOverlayMode">none</option>
        <option name="drilldown">cell</option>
        <option name="percentagesRow">false</option>
        <option name="refresh.display">progressbar</option>
        <option name="rowNumbers">false</option>
        <option name="totalsRow">false</option>
        <option name="wrap">true</option>
        <drilldown>
          <set token="Name">$row.Name$</set>
          <set token="form.Name">$row.Name$</set>
          <set token="show_Name">$row.Name$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>Caption</title>
      <table>
        <search base="Autoruns">
          <query>| stats count by Caption
| sort - count</query>
        </search>
        <option name="count">10</option>
        <option name="dataOverlayMode">none</option>
        <option name="drilldown">cell</option>
        <option name="percentagesRow">false</option>
        <option name="refresh.display">progressbar</option>
        <option name="rowNumbers">false</option>
        <option name="totalsRow">false</option>
        <option name="wrap">true</option>
        <drilldown>
          <set token="Caption">$row.Caption$</set>
          <set token="form.Caption">$row.Caption$</set>
          <set token="show_Caption">$row.Caption$</set>
        </drilldown>
      </table>
    </panel>
  </row>
  <row>
    <panel>
      <title>User SID</title>
      <table>
        <search base="Autoruns">
          <query>| stats count by UserSID
| sort - count</query>
        </search>
        <option name="count">10</option>
        <option name="dataOverlayMode">none</option>
        <option name="drilldown">cell</option>
        <option name="percentagesRow">false</option>
        <option name="refresh.display">progressbar</option>
        <option name="rowNumbers">false</option>
        <option name="totalsRow">false</option>
        <option name="wrap">true</option>
        <drilldown>
          <set token="UserSID">$row.UserSID$</set>
          <set token="form.UserSID">$row.UserSID$</set>
          <set token="show_UserSID">$row.UserSID$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>User</title>
      <table>
        <search base="Autoruns">
          <query>| stats count by User
| sort - count</query>
        </search>
        <option name="count">10</option>
        <option name="dataOverlayMode">none</option>
        <option name="drilldown">cell</option>
        <option name="percentagesRow">false</option>
        <option name="refresh.display">progressbar</option>
        <option name="rowNumbers">false</option>
        <option name="totalsRow">false</option>
        <option name="wrap">true</option>
        <drilldown>
          <set token="User">$row.User$</set>
          <set token="form.User">$row.User$</set>
          <set token="show_User">$row.User$</set>
        </drilldown>
      </table>
    </panel>
  </row>
  <row>
    <panel>
      <title>Command</title>
      <table>
        <search base="Autoruns">
          <query>| stats count by Command
| sort - count</query>
        </search>
        <option name="count">10</option>
        <option name="dataOverlayMode">none</option>
        <option name="drilldown">cell</option>
        <option name="percentagesRow">false</option>
        <option name="refresh.display">progressbar</option>
        <option name="rowNumbers">false</option>
        <option name="totalsRow">false</option>
        <option name="wrap">true</option>
        <drilldown>
          <set token="Command">$row.Command$</set>
          <set token="form.Command">$row.Command$</set>
          <set token="show_Command">$row.Command$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>Location</title>
      <table>
        <search base="Autoruns">
          <query>| stats count by Location
| sort - count</query>
        </search>
        <option name="count">10</option>
        <option name="dataOverlayMode">none</option>
        <option name="drilldown">cell</option>
        <option name="percentagesRow">false</option>
        <option name="refresh.display">progressbar</option>
        <option name="rowNumbers">false</option>
        <option name="totalsRow">false</option>
        <option name="wrap">true</option>
        <drilldown>
          <set token="Location">$row.Location$</set>
          <set token="form.Location">$row.Location$</set>
          <set token="show_Location">$row.Location$</set>
        </drilldown>
      </table>
    </panel>
  </row>
  <row>
    <panel>
      <title>Events</title>
      <table>
        <search base="Autoruns">
          <query>
| fields _time host Caption Command Name User UserSID Location _raw
| sort - _time</query>
        </search>
        <option name="drilldown">none</option>
        <option name="refresh.display">progressbar</option>
        <option name="wrap">false</option>
      </table>
    </panel>
  </row>
</form>
```

</details>
