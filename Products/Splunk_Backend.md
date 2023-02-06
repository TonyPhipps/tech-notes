Content here focuses on admin console access to the server running splunk.

# Installation
	1. Run the gui installer
	2. Follow default options (other than install location), should be installed as local system
	3. Splunkd service should be set to automatically run 

## Configuration
- Configuration is typically done via the web interface, but browsers are not allowed to run on servers with administrative accounts (ie, the accounts we always use on our server)
- Splunk uses port 8000 for it's web interface, so from your local workstation, browse to http://servername:8000 to interact with the web GUI
- The command Line Interface works from the server.

## Folder Monitoring
To add a folder on the server to be monitored by Splunk, run:
```
\Splunk\bin> .\splunk add monitor "E:\temp\Bluescope\SplunkAdd"
```
To list all folders being monitored, run:
```
\Splunk\bin> .\splunk list monitor
```

## Add an Uploader Role
- Navigate to Settings > Access Controls > Roles
- Add an "Uploader" role with the "input_file" capability.
- Leaving all other settings default, Save the role

## Reload Inputs.confg
```
./splunk _internal call /services/data/inputs/monitor/_reload -auth
```

# Lookups
## Lookup Table Config Files
Typical lookup table settings in %splunk%\etc\apps\search\local\transforms.conf
```
[lookup_trusted_environmentvariable]
	batch_index_query = 0
	case_sensitive_match = 0
	filename = lookup_trusted_environmentvariable.csv
 match_type = WILDCARD(VariableL)
```
