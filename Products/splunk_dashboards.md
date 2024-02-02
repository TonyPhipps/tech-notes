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
<form>
  <label>Windows Security Event Logs</label>
  <init>
    <set token="ip">*</set>
    <set token="host">*</set>
    <set token="name">*</set>
    <set token="EventCode">*</set>
    <set token="user">*</set>
    <set token="action">*</set>
  </init>
  <fieldset submitButton="true" autoRun="true">
    <input type="radio" token="resetTokens" searchWhenChanged="true">
      <label></label>
      <choice value="reset">Reset Inputs</choice>
      <choice value="retain">Retain</choice>
      <default>retain</default>
      <change>
        <condition value="reset">
          <set token="ip">*</set>
          <set token="host">*</set>
          <set token="name">*</set>
          <set token="EventCode">*</set>
          <set token="user">*</set>
          <set token="action">*</set>
          <set token="resetTokens">retain</set>
          <set token="form.resetTokens">retain</set>
        </condition>
      </change>
    </input>
    <input type="time" token="TimeRange" searchWhenChanged="true">
      <label>Time Range</label>
      <default>
        <earliest>-24h@h</earliest>
        <latest>now</latest>
      </default>
    </input>
    <input type="text" token="ip" searchWhenChanged="true">
      <label>IP Address</label>
      <default>*</default>
      <initialValue>*</initialValue>
    </input>
    <input type="text" token="user" searchWhenChanged="true">
      <label>User</label>
      <default>*</default>
      <initialValue>*</initialValue>
    </input>
    <input type="text" token="EventCode" searchWhenChanged="true">
      <label>Event ID</label>
      <default>*</default>
      <initialValue>*</initialValue>
    </input>
  </fieldset>
  
  
  <row>
    <panel>
      <title>Event Timeline</title>
      <chart>
        <search>
          <query>index=windows-security* sourcetype=WinEventLog:Security
| search src_ip = "$ip$"
| search name = "$name$"
| search user = "$user$"
| search EventCode = "$EventCode$"
| search host = "$host$"
| search action = "$action$"
| timechart count</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
        </search>
        <option name="charting.chart">line</option>
        <option name="charting.drilldown">none</option>
        <option name="refresh.display">progressbar</option>
      </chart>
    </panel>
  </row>
  <row>
    <panel>
      <title>Source IP</title>
      <table>
        <search>
          <query>index=windows-security* sourcetype=WinEventLog:Security
| search src_ip = "$ip$"
| search name = "$name$"
| search user = "$user$"
| search EventCode = "$EventCode$"
| search host = "$host$"
| search action = "$action$"
| chart count by src_ip
| sort - count</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
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
          <set token="ip">$click.value$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>Host</title>
      <table>
        <search>
          <query>index=windows-security* sourcetype=WinEventLog:Security
| search src_ip = "$ip$"
| search name = "$name$"
| search user = "$user$"
| search EventCode = "$EventCode$"
| search host = "$host$"
| search action = "$action$"
| chart count by host
| sort - count</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
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
          <set token="host">$click.value$</set>
        </drilldown>
      </table>
    </panel>
  </row>
  <row>
    <panel>
      <title>User</title>
      <table>
        <search>
          <query>index=windows-security* sourcetype=WinEventLog:Security
| search src_ip = "$ip$"
| search name = "$name$"
| search user = "$user$"
| search EventCode = "$EventCode$"
| search host = "$host$"
| search action = "$action$"
| chart count by user
| sort - count</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
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
          <set token="user">$click.value$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>Action</title>
      <table>
        <search>
          <query>index=windows-security* sourcetype=WinEventLog:Security
| search src_ip = "$ip$"
| search name = "$name$"
| search user = "$user$"
| search EventCode = "$EventCode$"
| search host = "$host$"
| search action = "$action$"
| chart count by action
| sort - count</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
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
          <set token="action">$click.value$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>Event ID</title>
      <table>
        <search>
          <query>index=windows-security* sourcetype=WinEventLog:Security
| search src_ip = "$ip$"
| search name = "$name$"
| search user = "$user$"
| search EventCode = "$EventCode$"
| search host = "$host$"
| search action = "$action$"
| stats count by EventCode
| sort - count</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
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
          <set token="EventCode">$click.value$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>Event Name</title>
      <table>
        <search>
          <query>index=windows-security* sourcetype=WinEventLog:Security
| search src_ip = "$ip$"
| search name = "$name$"
| search user = "$user$"
| search EventCode = "$EventCode$"
| search host = "$host$"
| search action = "$action$"
| stats count by name
| sort - count</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
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
          <set token="name">$click.value$</set>
        </drilldown>
      </table>
    </panel>
  </row>
  <row>
    <panel>
      <title>Events</title>
      <table>
        <search>
          <query>index=windows-security* sourcetype=WinEventLog:Security
| search src_ip = "$ip$"
| search name = "$name$"
| search user = "$user$"
| search EventCode = "$EventCode$"
| search host = "$host$"
| search action = "$action$"
| fields _time, src_ip, host, name, EventCode, user, action, _raw
| sort - _time</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
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

### Palo Alto Threat Starter Dashboard

<details>

```
<form theme="dark" version="1.1">
  <label>Palo Alto Threat</label>
  <init>
    <set token="src_ip">*</set>
    <set token="dest_ip">*</set>
    <set token="threat">*</set>
    <set token="action">*</set>
  </init>
  <fieldset submitButton="true" autoRun="true">
    <input type="radio" token="resetTokens" searchWhenChanged="true">
      <label></label>
      <choice value="reset">Reset Inputs</choice>
      <choice value="retain">Retain</choice>
      <default>retain</default>
      <change>
        <condition value="reset">
          <set token="src_ip">*</set>
          <set token="dest_ip">*</set>
          <set token="Threat">*</set>
          <set token="action">*</set>
          <set token="resetTokens">retain</set>
          <set token="form.resetTokens">retain</set>
        </condition>
      </change>
    </input>
    <input type="time" token="TimeRange" searchWhenChanged="true">
      <label>Time Range</label>
      <default>
        <earliest>-24h@h</earliest>
        <latest>now</latest>
      </default>
    </input>
    <input type="text" token="src_ip" searchWhenChanged="true">
      <label>Source IP Address</label>
      <default>*</default>
      <initialValue>*</initialValue>
    </input>
    <input type="text" token="dest_ip" searchWhenChanged="true">
      <label>Destination IP Address</label>
      <default>*</default>
      <initialValue>*</initialValue>
    </input>
    <input type="text" token="threat" searchWhenChanged="true">
      <label>Threat</label>
      <default>*</default>
      <initialValue>*</initialValue>
    </input>
    <input type="dropdown" token="action" searchWhenChanged="true">
      <label>Action</label>
      <choice value="*">*</choice>
      <choice value="allowed">allowed</choice>
      <choice value="blocked">blocked</choice>
      <default>*</default>
      <initialValue>*</initialValue>
    </input>
  </fieldset>
  <row>
    <panel>
      <title>Event Timeline</title>
      <chart>
        <search>
          <query>index=yourindex sourcetype=pan:threat
| search src_ip = "$src_ip$"
| search dest_ip = "$dest_ip$"
| search threat = "$threat$"
| search action = "$action$"
| timechart count</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
        </search>
        <option name="charting.chart">line</option>
        <option name="charting.drilldown">none</option>
        <option name="refresh.display">progressbar</option>
      </chart>
    </panel>
  </row>
  <row>
    <panel>
      <title>Event Timechart by Subtype</title>
      <chart>
        <search>
          <query>index=yourindex sourcetype=pan:threat
| search src_ip = "$src_ip$"
| search dest_ip = "$dest_ip$"
| search threat = "$threat$"
| search action = "$action$"
| timechart count by log_subtype</query>
          <earliest>-30d@d</earliest>
          <latest>now</latest>
          <sampleRatio>1</sampleRatio>
        </search>
        <option name="charting.axisLabelsX.majorLabelStyle.overflowMode">ellipsisNone</option>
        <option name="charting.axisLabelsX.majorLabelStyle.rotation">0</option>
        <option name="charting.axisTitleX.visibility">collapsed</option>
        <option name="charting.axisTitleY.visibility">collapsed</option>
        <option name="charting.axisTitleY2.visibility">collapsed</option>
        <option name="charting.axisX.abbreviation">none</option>
        <option name="charting.axisX.scale">linear</option>
        <option name="charting.axisY.abbreviation">none</option>
        <option name="charting.axisY.scale">linear</option>
        <option name="charting.axisY2.abbreviation">none</option>
        <option name="charting.axisY2.enabled">0</option>
        <option name="charting.axisY2.scale">inherit</option>
        <option name="charting.chart">line</option>
        <option name="charting.chart.bubbleMaximumSize">50</option>
        <option name="charting.chart.bubbleMinimumSize">10</option>
        <option name="charting.chart.bubbleSizeBy">area</option>
        <option name="charting.chart.nullValueMode">gaps</option>
        <option name="charting.chart.showDataLabels">none</option>
        <option name="charting.chart.sliceCollapsingThreshold">0.01</option>
        <option name="charting.chart.stackMode">default</option>
        <option name="charting.chart.style">shiny</option>
        <option name="charting.drilldown">none</option>
        <option name="charting.layout.splitSeries">1</option>
        <option name="charting.layout.splitSeries.allowIndependentYRanges">0</option>
        <option name="charting.legend.labelStyle.overflowMode">ellipsisMiddle</option>
        <option name="charting.legend.mode">standard</option>
        <option name="charting.legend.placement">none</option>
        <option name="charting.lineWidth">2</option>
        <option name="height">229</option>
        <option name="refresh.display">progressbar</option>
        <option name="trellis.enabled">1</option>
        <option name="trellis.scales.shared">1</option>
        <option name="trellis.size">medium</option>
      </chart>
    </panel>
  </row>
  <row>
    <panel>
      <title>Source IP</title>
      <table>
        <search>
          <query>index=yourindex sourcetype=pan:threat
| search src_ip = "$src_ip$"
| search dest_ip = "$dest_ip$"
| search threat = "$threat$"
| search action = "$action$"
| chart count by src_ip
| sort - count</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
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
          <set token="src_ip">$click.value$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>Destination IP</title>
      <table>
        <search>
          <query>index=yourindex sourcetype=pan:threat
| search src_ip = "$src_ip$"
| search dest_ip = "$dest_ip$"
| search threat = "$threat$"
| search action = "$action$"
| chart count by dest_ip
| sort - count</query>
          <earliest>-30d@d</earliest>
          <latest>now</latest>
          <sampleRatio>1</sampleRatio>
        </search>
        <option name="count">20</option>
        <option name="dataOverlayMode">none</option>
        <option name="drilldown">cell</option>
        <option name="percentagesRow">false</option>
        <option name="refresh.display">progressbar</option>
        <option name="rowNumbers">false</option>
        <option name="totalsRow">false</option>
        <option name="wrap">true</option>
        <drilldown>
          <set token="dest_ip">$click.value$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>Threat</title>
      <table>
        <search>
          <query>index=yourindex sourcetype=pan:threat
| search src_ip = "$src_ip$"
| search dest_ip = "$dest_ip$"
| search threat = "$threat$"
| search action = "$action$"
| chart count by threat</query>
          <earliest>-4mon@mon</earliest>
          <latest>now</latest>
          <sampleRatio>1</sampleRatio>
        </search>
        <option name="count">20</option>
        <option name="dataOverlayMode">none</option>
        <option name="drilldown">cell</option>
        <option name="percentagesRow">false</option>
        <option name="refresh.display">progressbar</option>
        <option name="rowNumbers">false</option>
        <option name="totalsRow">false</option>
        <option name="wrap">true</option>
        <drilldown>
          <set token="threat">$click.value$</set>
        </drilldown>
      </table>
    </panel>
    <panel>
      <title>Action</title>
      <table>
        <search>
          <query>index=yourindex sourcetype=pan:threat
| search src_ip = "$src_ip$"
| search dest_ip = "$dest_ip$"
| search threat = "$threat$"
| search action = "$action$"
| chart count by action
| sort - count</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
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
          <set token="action">$click.value$</set>
        </drilldown>
      </table>
    </panel>
  </row>
  <row>
    <panel>
      <title>Events</title>
      <table>
        <search>
          <query>index=yourindex sourcetype=pan:threat
| search src_ip = "$src_ip$"
| search dest_ip = "$dest_ip$"
| search threat = "$threat$"
| search action = "$action$"
| fields _time, log_subtype, threat, threat_category, severity, action, app, app:category, category, src_ip, src_port, dest_ip, dest_port, _raw
| sort - _time</query>
          <earliest>$TimeRange.earliest$</earliest>
          <latest>$TimeRange.latest$</latest>
          <sampleRatio>1</sampleRatio>
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
