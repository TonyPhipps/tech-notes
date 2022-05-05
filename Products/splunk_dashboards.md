Sample Dashboard
- Presents filters for time and key fields at the top
- Leverages radio buttons to reset filters
- Multiple widgets used to aggregate key fields
- Widgets leverage tokens to allow cross-widget filtering (based on clicking a cell containing a value)
- Shows all relevant fields for matching events

```
<form>
  <label>Windows Security Event Logs</label>
  <init>
    <set token="src_ip">*</set>
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
