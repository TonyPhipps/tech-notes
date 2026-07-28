# Saved Search Performance
- https://splunkes.bor.doi.net/en-US/app/splunk_monitoring_console/scheduler_activity_instance
- Settings > Monitoring Console
  - Search > Scheduler Activity: Instance
    - Runtime Statistics widget
      - Look into anything with Average Runtime (sec) > 100 or Internal Load Factor > 10

Search for this:
```sql
`dmc_set_index_internal` host=IBRSACLXSRH310.bor.doi.net sourcetype=scheduler (status="completed" OR status="skipped" OR
    status="deferred") 
| eval window_time = if(isnotnull(window_time), window_time, 0) 
| eval execution_latency = max(dispatch_time - (scheduled_time + window_time), 0) 
| stats avg(run_time) as runtime, avg(execution_latency) AS avg_exec_latency, count(eval(status=="completed" OR status=="skipped")) AS total_exec, count(eval(status=="skipped")) AS skipped_exec count(eval(status=="deferred")) AS deferred_exec by app, savedsearch_name, user, savedsearch_id 
| join savedsearch_id type=outer 
    [| rest splunk_server=IBRSACLXSRH310.bor.doi.net "/servicesNS/-/-/saved/searches/" 
        f=is_scheduled 
        f=disabled 
        f=dispatch.earliest_time f=dispatch.latest_time 
        f=scheduled_times 
        f=title 
        f=id
        f=eai:acl* 
        f=cron_schedule 
        f=search_workload
        earliest_time=`time_modifier(-0s@s)` latest_time=`time_modifier(+8d@d)` search="is_scheduled=1" search="disabled=0" 
    | rex field=id "/servicesNS/(?<userctx>[^/]++)/(?<appctx>[^/]++)/saved/searches/(?<savedsearchctx>.*)" 
    | eval savedsearch_id = urldecode(userctx).";".urldecode(appctx).";".urldecode(savedsearchctx) 
    | search NOT (dispatch.earliest_time=rt* OR dispatch.latest_time=rt*) 
    | stats dc(scheduled_times) as count max(scheduled_times) as max_t min(scheduled_times) as min_t by title, appctx, savedsearch_id, cron_schedule 
    | eval schedule_interval=round((max_t-min_t)/(count-1), 0) 
    | fields savedsearch_id, cron_schedule, schedule_interval ] 
| eval runtime = round(runtime, 0) 
| eval avg_exec_latency = round(avg_exec_latency, 0) 
| eval search_workload = round(runtime / schedule_interval * 100, 2)." %" 
| eval skip_ratio = round(skipped_exec / total_exec * 100, 2)." %" 
| fields savedsearch_name, app, user, cron_schedule, schedule_interval, runtime, search_workload, total_exec, skipped_exec, skip_ratio, deferred_exec, avg_exec_latency 
| sort - search_workload 
| search (runtime > 100)
| rename savedsearch_name as "Report Name", app as App, user as User, cron_schedule as "Cron Schedule", runtime as "Average Runtime (sec)", total_exec as "Total Executions", skip_ratio as "Skip Ratio", skipped_exec as "Skipped Executions", deferred_exec AS "Deferred Executions", schedule_interval as "Schedule Interval (sec)", search_workload as "Interval Load Factor", avg_exec_latency AS "Average Execution Latency (sec)"
```