Truncate everything in message after the first sentence, as this content is already parsed. Should reduce log size by ~50%
```
# ================================= Processors =================================
processors:
  - dissect:
    # Reference https://github.com/elastic/beats/issues/16591
      tokenizer: "%{message}."
      field: "message"
      target_prefix: ""
      overwrite_keys: true
```
Add a winlogbeatymlversion field. This can help you track which version of your config file was used for each event parsed.
```
# ================================= Processors =================================
processors:
  - add_fields:
      fields:
        winlogbeatymlversion: '2020-11-24.2'
```
