# Leader Node Requirements
- Requires Git 1.8.3.1 or higher
- HTTP/S:9000 IN - Cribl Stream UI
- HTTP/S:9000 IN - Bootstrapping worker nodes from leader
- HTTP/S:4200 IN - Software upgrade and bundle downloads
- HTTP/S:4200 IN - Heartbeats/metrics


# Leader Node Install
```
sudo adduser cribl
cd /opt
sudo curl -Lso - $(curl -s https://cdn.cribl.io/dl/latest) | sudo tar zxvf -
sudo chown -R cribl:cribl cribl
sudo su cribl
cd cribl/bin
./cribl boot-start enable -m systemd -u cribl
./cribl start
./cribl status
http://xxx.xxx.xxx.xxx:9000
```

First Login: admin/admin

# First Setup
- Settings > Global > Distributed Settings > General Settings > Select a Mode
- Install Worker Nodes if Leader mode was selected
  - Workers > Add/Update Worker Node
  - Set up a "cribl" account on worker nodes
  - Process can be repeated for all worker nodes


# Cribl Data Flow
Sources > Pre-Processing Pipelines (Optional) > Route Filters > Processing Pipelines > Post-Processing Pipelines (Optional) > Destinations

# Processing Functions
- Eval, Lookup
  - Add, remove, update fields
- Mask
  - Find & Replace, sed-like, obfuscate, redact, hash
- GeoIP
  - Add GeoIP information to events
- Regex Extract, Parser
  - Extract fields
- Auto Timestamp
  - Extract timestamps
- Drop, regex filter, sampling, suppress, dynamic sampling
  - Drop Events
- Samplying, Dynamic Sampling
  - Sample events (e.g., high-volume, low-value data)
- Suppress
  - Suppress events (e.g. duplicates)
- Serialize
  - Serialize / change format (e.g. convert JSON to CSV)
- Unroll, JSON Unroll, XML Unroll
  - Convert JSON arrays or XML elements into own events
- Flatten
  - Flatten nested structures (e.g. nested JSON)
- Aggregate
  - Aggregate events in real-time (i.e., statistical aggregations)
- Publish Metrics
  - Convert events in metric format