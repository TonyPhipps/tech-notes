Total License Usage
```sql
index=_internal idx="myindex" source=*license_usage.log* type="Usage"
| fields _time, pool, b
| bin _time span=30d 
| stats sum(b) as b by _time, pool
| stats sum(b) AS volume by _time 
| stats avg(volume) AS avgVolume
| eval avgVolumeGB=round(avgVolume/1024/1024/1024,3) 
| fields avgVolumeGB
| rename avgVolumeGB AS "average"
```


Average Daily Ingestion by Index
```sql
index=_internal idx=* source=*license_usage.log* type="Usage"
| fields _time, pool, idx, b 
| eval idx=if(len(idx)=0 OR isnull(idx),"(UNKNOWN)",idx) 
| bin _time span=1d@d
| stats sum(b) as b by _time, pool, idx 
| stats sum(b) AS volume by idx, _time 
| stats avg(volume) AS avgVolumePerDay max(volume) AS maxVolumePerDay by idx 
| eval avgVolumeGB=round(avgVolumePerDay/1024/1024/1024,3) 
| eval maxVolumeGB=round(maxVolumePerDay/1024/1024/1024,3) 
| fields idx, avgVolumeGB, maxVolumeGB 
| rename avgVolumeGB AS "average" idx AS "Index"
```


License Usage by Sourcetype
```sql
index=_internal source=*license_usage.log type=Usage
| timechart useother=f span=1d eval(round(sum(b)/1024/1024/1024,2)) as "GB" by st
```


License Usage by Source
```sql
index=_internal source=*license_usage.log type=Usage idx=*
| stats sum(b) AS bytes by s 
| eval GB= round(bytes/1024/1024/1024,2) 
| fields s GB 
| rename s as Source 
| sort -GB
```


License Usage by Host
```sql
index=_internal source=*license_usage.log type=Usage idx=*
| stats sum(b) AS bytes by h 
| eval GB= round(bytes/1024/1024/1024,2) 
| fields h GB 
| rename h as host 
| sort -GB
```
