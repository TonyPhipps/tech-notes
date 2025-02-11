# Install via pip
```bat
pip install sigma-cli
```

Install plugins
```bat
sigma plugin list
sigma plugin install splunk
```

# Convert Rules

- Assuming you are in a directory with a 'sigma' folder and inside it is the git repository 'sigma-master'.
- For Linux, use '\' in place of '^'
- If a single error is detected, no output file will result.

Basic Sample

- Just make sure the LAST property is always the source directory/file.

```bat
cd C:\Users\username\python\sigma
.\env\Scripts\activate.bat
sigma convert ^
    --target splunk ^
    --pipeline splunk_windows ^
    ./sigma/sigma-master/rules
```

Use a Custom pipeline
```bat
cd C:\Users\username\python\sigma
.\env\Scripts\activate.bat
    --pipeline my_pipeline.yml ^
```

Generate a savedsearches.conf file for splunk
```bat
cd C:\Users\username\python\sigma
.\env\Scripts\activate.bat
    -f savedsearches ^
    --output ./sigma/output/output.txt ^
```

Output rules to a folder
```bat
cd C:\Users\username\python\sigma
.\env\Scripts\activate.bat
    --output ./sigma/output/{rule}.txt ^
```

Review any  errors
```bat
cd C:\Users\username\python\sigma
.\env\Scripts\activate.bat
--verbose ^
```

Stuffed example
```bat
cd C:\Users\username\python\sigma
.\env\Scripts\activate.bat
sigma convert ^
    --target splunk ^
    --pipeline splunk_windows ^
    --output ./sigma/output/{rule}.txt ^
    ./sigma/sigma-master/rules
```

## Mass-Convert via Powershell
- Assumes a python venv named "sigma" resides in user home directory.

```powershell
$venv = "C:\Users\youruser\python\sigma"
$inputDir = "./sigma-master/rules/windows/"
$outputDir = "./output"

# Ensure output directory exists
New-Item -ItemType Directory -Path $outputDir -Force

& "$venv\Scripts\Activate.ps1"

# Loop through each YAML rule file
Get-ChildItem -Path $inputDir -Recurse -Filter "*.yml" | ForEach-Object {
    $ruleName = $_.BaseName  # Extracts the filename without extension
    $outputFile = "$outputDir/$ruleName.txt"
    
    Write-Host "Converting: $($_.FullName) -> $outputFile"

    sigma convert --target splunk --pipeline splunk_windows --output $outputFile $_.FullName
    
}

deactivate
```

# Create Rules

Rules describe what is being looked for within events.

Sample
```yaml
# ./rules/cloud/okta/okta_user_account_locked_out.yml
title: Okta User Account Locked Out
id: 14701da0-4b0f-4ee6-9c95-2ffb4e73bb9a
status: test
description: User account locked out.
references:
    - https://developer.okta.com/docs/reference/api/system-log/
    - https://developer.okta.com/docs/reference/api/event-types/
author: Austin Songer @austinsonger
date: 2021-09-12
modified: 2022-10-09
tags:
    - attack.impact
logsource:
    product: okta
    service: okta
detection:
    selection:
        displaymessage: Max sign in attempts exceeded
    condition: selection
falsepositives:
    - Unknown
level: medium
```

### level:
- *critical* should never trigger a false positive and be of high relevance
- *high* threats of high relevance that have to be reviewed manually (rare false positives > baselining required)
- *low* and *medium* indicate suspicious activity and policy violations
- *informational* have informative character and are often used for compliance or correlation purposes

- https://sigmahq.io/docs/basics/rules.html
- https://www.uuidgenerator.net/version4

## Filters

Filters are applied to rules to add exlcusions to them. Intended to keep the signature generic while still allowing for environment-specific tuning.

Sample
- Rule
```yaml
title: New Service Creation Using Sc.EXE
name: proc_creation_win_sc_create_service
description: Detects the creation of a new service using the "sc.exe" utility.
author: Timur Zinniatullin, Daniil Yugoslavskiy, oscd.community
logsource:
  category: process_creation
  product: windows
detection:
  selection:
    Image|endswith: '\sc.exe'
    CommandLine|contains|all:
      - "create"
      - "binPath"
  condition: selection
falsepositives:
  - Legitimate administrator or user creates a service for legitimate reasons.
  - Software installation
level: low
```
- Filter
```yaml
title: Filter Out Administrator accounts
description: Filters out administrator accounts that start with adm_
logsource:
  category: process_creation
  product: windows
filter:
  rules:
    - proc_creation_win_sc_create_service
  selection:
    User|startswith: "adm_"
  condition: not selection
```

- Command
```bash
sigma convert -t splunk --pipeline splunk_windows \
  --filter ./filters/win_filter_admins.yml \
  ./rules/windows/process_creation/proc_creation_win_sc_create_service.yml
```

- Bulk command

```bash
$ sigma convert -t splunk -p splunk_windows \
    --filter ./filters/windows \
    ./rules/windows
```

- https://sigmahq.io/docs/meta/filters.html

# Pipelines

- Pipelines are executed from lowest priority number to highest, 0-100. Generally it goes:
  - Starting at 10 - Generic log sources are translated into specific log sources
  - Starting at 30 - Transformation of the log signatures into the taxonomy used by a backend.
  - High Numbers - Environment-specific transformations.

Types of changes include
- Rule Pre-Processing Transformations
- Query Post-Processing Transformations
- Output Finalization Transformations

## Rule Pre-Processing Transformations
Includes
- **field_name_mapping** - *Maps a field name to one or multiple different.*
- **field_name_prefix_mapping** - *Maps a field name prefix to one or multiple different prefixes.*
- **field_name_transform** - *Maps a field name to another using provided transformation function. Can overwrite transformation by providing explicit mapping for a field.*
- **drop_detection_item** - *Deletes detection items. This should only used in combination with a detection item condition.*
- **field_name_suffix** - *Adds a field name suffix.*
- **field_name_prefix** - *Adds a field name prefix.*
- **wildcard_placeholders** - *Replaces placeholders with wildcards. Useful if remaining placeholders should be replaced with something meaningful to make conversion of rules possible without defining the placeholders content.*
- **value_placeholders** - *Replaces placeholders with values contained in variables defined in the configuration.*
- **query_expression_placeholders** - *Replaces a placeholder with a plain query containing the placeholder or an identifier mapped from the placeholder name. The main purpose is the generation of arbitrary list lookup expressions which are passed to the resulting query.*
- **add_condition** - *Adds a condition expression to rule conditions.*
- **change_logsource** - *Replaces log source as defined in transformation parameters.*
- **add_field** - *Adds one or multiple fields to the Sigma rule. The field is added to the fields list of the rule:*
- **remove_field** - *Removes one or multiple fields from the Sigma rules field list. If a given field is not in the rules list, it is ignored.*
- **set_field** - *Sets fields to the Sigma rule. The fields are set to the fields list of the transformation.*
- **replace_string** - *Replaces string part matched by regular expresssion with replacement string that can reference capture groups.*
- **map_string** - *Maps static string value to one or multiple other strings.*
- **set_state** - *Sets pipeline state key to value.*
- **regex** - *Transforms a string value to a case insensitive regular expression.*
- **set_value** - *Sets value to a fixed value. The type of the value can be enforced to str or num with the force_type parameter.*
- **convert_type** - *Converts type of value. The conversion into strings and numbers is currently supported.*
- **rule_failure** - *This is a rule transformation. Detection item and field name conditions are not evaluated if this is used.*
- **detection_item_failure** - *Raises a SigmaTransformationError with the provided message. This enables transformation pipelines to signalize that a certain situation can't be handled, e.g. only a subset of values is allowed because the target data model does't offers all possibilities.*
- **set_custom_attribute** - *Sets an arbitrary custom attribute on a rule, that can be used by a backend during processing.*
- **nest** - *Executes a nested processing pipeline as transformation. Main purpose is to apply a whole set of transformations that match the given conditions of the enclosng processing item.*

Sample add_condition transformation
NOTE: Multiple transformations can be gropuped within the same name/priority by starting over at ```-id```
```yml
name: Your Name # Name the pipeline
priority: 30 # specifies the ordering of the pipeline in case multiple pipelines are concatenated. Lower priorities are used first.
transformations: # contains a list of transformation items for the rule pre-processing stage.
  -id: your_transform_name # the identifier of the item. This is also tracked at detection item or condition level and can be used in future conditions.
  type: add_condition # the type of the transformation as specified in the identifier to class mappings below: Transformations
  conditions: # what to ADD to the matched rules.
    index: some_new_index # Arbitrary fields: values to ADD TO rules AFTER they have been matched.
  rule_conditions: # Finds rules with matching conditions of the type corresponding to the name.
    - type: # defines the condition type. It must be one of the identifiers that are defined in Conditions
      product: windows # Arbitrary fields: values to LOOK FOR in ingested rules to achieve a match.
  detection_item_conditions: # Finds rules with matching conditions of the type corresponding to the name.
  field_name_conditions: # Finds rules with matching conditions of the type corresponding to the name.
postprocessing: # ontains a list of transformation items for the query post-processing stage.
finalizers: # contains a list of transformation items for the output finalization stage.
``` 

**Transformation Type: field_name_mapping**

Sample transformation type of field_name_mapping
```yml
name: My Field Mapping
priority: 10
transformations:
- id: field_mapping
  type: field_name_mapping
  mapping:
    EventID: # The resulting field name
    - event_id # The field name to LOOK FOR
    - evtid # Another field name to LOOK FOR
```

**Transformation Type: field_name_prefix**

Sample transformation that prepends a value toa  field name
```yml
name: My Field Prefix
priority: 30
- id: windows_field_prefix
  type: field_name_prefix
  prefix: "win."
```

**Transformation Type: add_condition**

```yml
name: My Added Conditions
priority: 10
  - id: condition_system_channel
    type: add_condition
    conditions:
      Channel: System
    rule_conditions:
      - type: logsource
        product: windows
        service: system

  - id: condition_windows_create_remote_thread
    type: add_condition
    conditions:
      Channel: "Microsoft-Windows-Sysmon/Operational"
      EventID: 8
    rule_conditions:
      - type: logsource
        product: windows
        category: create_remote_thread
```

**Transformation Type: query_expression_placeholders**

```yml
name: My Query Expression Placeholders
priority: 10
  - id: Windows Placeholders Management
    type: query_expression_placeholders
    include:
      - "domain_admin"
      - "Administrator"
    expression: "`placeholder_{id}({field})`"
    rule_conditions:
      - type: logsource
        product: windows
```


### Query Post-Processing Transformations

Includes
- **embed** - *Embeds a query between a given prefix and suffix. Only applicable to string queries.*
- **simple_template** - *Replaces query with template that can refer to the following placeholders:*
  - ***query**: the postprocessed query.*
  - ***rule**: the Sigma rule including all its attributes like rule.title.*
  - ***pipeline**: the Sigma processing pipeline where this transformation is applied including all current state information in pipeline.state.*
- **template** - *Applies Jinja2 template provided as template object variable to a query. The following variables are available in the context:*
  - ***query**: the postprocessed query.*
  - ***rule**: the Sigma rule including all its attributes like rule.title.*
  - ***pipeline**: the Sigma processing pipeline where this transformation is applied including all current state information in pipeline.state.*
- **json** - *Embeds a query into a JSON structure defined as string. the placeholder value %QUERY% is replaced with the query.*
- **replace** - *Replaces query part specified by regular expression with a given string.*
- **nest** - *Applies a list of query postprocessing transformations to the query in a nested manner.*

**Query Post Processing Transformation Type: template**

```yml
name: Splunk Alert stanza Windows
priority: 20
postprocessing:
- type: template
  template: |+
    [{{ rule.title }}]
    description = {{ rule.description | replace('\n', ' ') }}
    search = index=evtx _index_earliest=-1h@h {{ query | replace('\n', '\\\n')}} | fields - _raw | collect index=notable_events source="{{ rule.title }}" marker="guid={{ rule.id }},{% for t in rule.tags %}tags={{ t }},{% endfor %}"
  rule_conditions:
    - type: logsource
      product: windows
```

### Output Finalization Transformations
Includes
- **concat** - *Concatenates queries with a given separator and embed result within a prefix or suffix string.*
- **template** - *Applies Jinja2 template provided as template object variable to the queries. The following variables are available in the context:*
  - ***queries**: all post-processed queries generated by the backend.*
  - ***pipeline**: the Sigma processing pipeline where this transformation is applied including all current state information in pipeline.state.*
- **json** - 
- **yaml** - 
- **nested** - *Applies a list of finalizers to the queries in a nested fashion.*

**Output Finalization Transformation type: template**

```yml
finalizers:
- type: template
  template: |
    [default]
    cron_schedule = */30 * * * *
    dispatch.earliest_time = 0
    dispatch.latest_time = now
    enableSched = 0
    schedule_window = auto
    {{ queries | join('\n') }}
```


Eaxmples with sigma-cli. Note TWO pipelines can be specified.
```
sigma convert -t splunk -p sysmon rules/windows/process_creation/proc_creation_win_sysinternals_procdump.yml
sigma convert -t splunk -p sysmon -p /mnt/pipelines/evtx2splunk.yml rules/windows/process_creation/proc_creation_win_sysinternals_procdump.yml
```

Batch
```
sigma convert -t splunk -p /mnt/pipelines/evtx2splunk.yml rules/windows
```

- https://sigmahq.io/docs/digging-deeper/pipelines.html
- https://blog.sigmahq.io/connecting-sigma-rule-sets-to-your-environment-with-processing-pipelines-4ee1bd577070
- Transformation types - https://sigmahq-pysigma.readthedocs.io/en/latest/Processing_Pipelines.html#transformations