# Stream Architecture

## What does Cribl Stream do?
Cribl Stream acts as the core engine, enabling you to:

- Collect data from diverse sources.
- Route that data to various destinations for further analysis or storage.
- Cleanse and process the data within Cribl Stream to remove duplicates, enrich it with context, or anonymize sensitive information.

By understanding Cribl Stream's architecture, you'll be well-equipped to design efficient data flow strategies and leverage its functionalities to gain control and visibility over your organization's data. Some Key takeaways:

- Cribl Leader Nodes act as the central hub, managing configurations for Worker Nodes and Edge deployments.
- Worker Nodes, grouped logically based on shared configurations, perform the actual data processing tasks.
- You can have a flexible number of Worker Nodes and Groups to match your specific data processing requirements.


## Deployment Modes: Single vs. Distributed
Cribl Stream offers two deployment options based on your needs:

- Single Mode: Ideal for testing or small-scale environments. This mode combines the Leader Node (configuration management) and Worker Node (data processing) functionalities on a single machine.
- Distributed Mode: Designed for larger deployments. Here, the Leader Node manages multiple Worker Nodes spread across separate machines, providing centralized configuration and streamlining management


## Worker Groups
Cribl Stream utilizes Worker Groups to categorize Worker Nodes with shared configurations. This logical grouping allows for:

- Data Processing Based on Type: Group Worker Nodes to handle specific data types (e.g., syslog data, a particular location's data).
- Dedicated Processing Workflows: Create specialized groups to replace existing processing servers (like a syslog server) or manage specific data categories.


## Leader Node
The Leader Node plays a critical role in Cribl Stream's communication:

- Manages configurations for both Worker Nodes and Cribl Edge deployments.
- Distributes configuration data and collection schedules to Worker Nodes.
- Communicates with Worker Nodes on the following ports: 
  - TCP port 4200 for heartbeats, metrics, and notifications.
  - HTTP port 4200 (or port 443 for secure connections in Cribl Cloud) for configuration distribution.
- As your deployment grows (more worker groups or nodes), the Leader Node's workload increases. You might need to scale up its resources accordingly.


## Cribl.Cloud
The Leader Node plays a critical role in Cribl Stream's communication:

- Move leader node management to the cloud, eliminating the need for on-premise management.
- Add Worker Nodes within the cloud environment, simplifying cloud data processing.
- Maintain the flexibility to seamlessly transfer data between cloud and on-premise Worker Nodes.


## Remember...
By understanding Cribl Stream's architecture, you'll be well-equipped to design efficient data flow strategies and leverage its functionalities to gain control and visibility over your organization's data. Some Key takeaways:

- Cribl Leader Nodes act as the central hub, managing configurations for Worker Nodes and Edge deployments.
- Worker Nodes, grouped logically based on shared configurations, perform the actual data processing tasks.
- -You can have a flexible number of Worker Nodes and Groups to match your specific data processing requirements.


# Stream Architecture: Cribl Stream Installation Guide


## Pre-Installation Prep
Before diving into the installation, ensure a smooth process by following these recommendations:

- Installation Location: The recommended installation directory is /opt/cribl.
- User Creation: Create a dedicated user named cribl to own and run the Cribl Stream processes. This user should have minimal privileges.
- Boot Start Configuration: Choose either systemd or initd (depending on your system) to enable Cribl Stream to start automatically at system boot. Refer to Cribl documentation for detailed instructions on using initd.


## Security and Licensing
- Secure User Account: The cribl user should be a non-privileged account for enhanced security.
- Worker Node Passwords: In distributed deployments, worker nodes have randomly generated admin passwords. Access them through the Leader node for administrative tasks.
- License Verification: Cribl Stream offers a free tier with a 1 TB/day processing limit. Standard and Enterprise licenses provide higher ingestion volumes and distributed deployments. Verify your license capacity aligns with your needs. Licenses can be added through the Stream UI.


## Port Requirements
- Leader User Interface: 
  - Defaults to port 9000 
- Worker Node User Interface: 
  - Defaults to port 9000
- Communications Between the Leader Node and Worker Node:
  - Port 4200: Open on the Leader Node for downloading Configuration Bundles, Heartbeats, Worker Node Metrics, and Leader requests/notifications to the clients
  - Port 9000: Open on the Leader Node for bootstrapping Worker Nodes
- Custom Ports: Edit the Cribl Yaml file located in the specified path to change default ports.


## Git Version Requirement (Distributed Mode Only) for Leader Node
Git version 1.8.3.1 or higher is mandatory for distributed deployments. Git is used for configuration version control across worker groups, allowing audit trails and version comparisons. All configuration changes must be committed to Git before deployment to worker nodes.


## Installation Steps
- Create the cribl user.
- Navigate to the desired installation location (/opt/cribl recommended).
- Download Cribl Stream from the official website (cribl.io).
- Change ownership of the downloaded files to the cribl user.
- Navigate to the cribl/bin directory and run the boot-start command to enable automatic startup.
- Start Cribl Stream.
- Verify Cribl is running and obtain the IP address if needed.
- Log in to the UI using the IP address and port 9000 (default).


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

## Logging In For The First Time
- Login: The first login uses admin for both username and password. You will be prompted to create a new password upon login.
- Registration: Register with Cribl by providing basic information and accepting the license agreement
- Deployment Type: Set the deployment mode (Single Instance, Leader, or Worker) under Settings > Distributed Settings > General Settings.
  - Leader mode requires additional Worker Nodes for processing-intensive deployments and Edge node support.
  - Git installation on the Leader Node is mandatory for Leader mode.


## Adding Worker Nodes (Leader Mode Only)
- Log in to the Leader UI.
- Navigate to Manage > Workers > Add/Update Worker Node.
- Select Linux and click Add.
- Copy the provided script and run it on the worker node (ensure the cribl user is created there).
- This script can be modified to specify a different worker group or install package location.
- Repeat the process for additional worker nodes as needed.


# Remember...
By following these steps to install and configure Cribl Stream in a local environment and understanding the key considerations, you can establish a solid foundation for managing and processing your data streams


# Stream Projects
Cribl Stream Projects is a feature that empowers administrators to provide finer-grained access and control over data and data pipelines within Cribl Stream.


# Stream Projects: Isolated Workspaces for Teams and Users
Cribl Stream Projects introduce isolated spaces for teams and users to manage and share their data independently. This self-service approach offers several benefits:
- Granular Access Control: Admins can grant specific permissions to different teams, ensuring each team only accesses and modifies relevant data streams. This eliminates concerns about unintended changes impacting other teams' data.
- Faster Data Access: Teams can access and work with required data streams more quickly as project configurations minimize setup complexities.


## Key Components of Stream Projects
- Subscriptions: Define a subset of data from a Worker Group's incoming stream using filter expressions. Optionally, you can configure a Preprocessing Pipeline to modify the data before forwarding it to destinations.
- Projects: Act as connections between subscriptions and destinations. Think of projects as designated teams within Cribl Stream. You assign subscriptions and destinations to a project, allowing the associated team to make necessary data flow connections.


## Project Access Levels
- Project Editor: Users with isolated project spaces can independently connect sources to destinations, configure pipelines, integrate Packs (pre-built configurations), and commit changes to version control using Git.
- Cribl Admin: Holds ultimate authority, creating subscriptions, projects, and assigning user access to specific projects. Cribl admins manage all teams within the Cribl Stream Projects environment.

Example: Streamlining Data Access for Different Teams

Imagine two projects: "IT Team" and "Security Team." By creating separate projects, you can restrict data visibility for each team. The IT team might only require a subset of the data accessed by the security team. Projects with limited access can still be empowered; for instance, power users within a project might be granted permissions to modify data destinations or pipelines.

- IT Team: Users with isolated project spaces can independently connect sources to destinations, configure pipelines, integrate Packs (pre-built configurations), and commit changes to version control using Git.
- Security Team: Holds ultimate authority, creating subscriptions, projects, and assigning user access to specific projects. Cribl admins manage all teams within the Cribl Stream Projects environment.


# Remember...
Cribl Stream Projects provide a valuable tool for organizing and managing data access within your Cribl Stream environment. By leveraging projects, you can ensure data security, streamline data workflows for individual teams, and empower users with self-service capabilities.


# Stream Fundamentals: Sources, Destinations & Collectors
Cribl Stream acts as a data engine that processes data flowing from various sources to designated destinations. This section focuses on understanding sources, collectors (a type of source), and destinations, as well as a few other key terms mentioned within the course.


## Sources
Sources deliver data to Cribl Stream. Take a look at the different types of Sources:
- Push Sources: These sources actively send data to Cribl Stream, like syslog, TCP, and various agent software.
- Pull Sources: Cribl Stream fetches data from these sources, including data from Amazon S3, Azure Blob Storage, or Office 365.
- Collector Sources: Designed for periodic data collection, these sources allow scheduling data retrieval from local or remote locations (e.g., Amazon S3).
- System and Internal Sources: These provide internal Cribl Stream data like system metrics and logs.


## Destinations
Destinations receive processed data from Cribl Stream. They fall into two categories:

- Streaming Destinations: Designed for real-time data reception, these include Splunk, Elasticsearch, Kafka, and InfluxDB.
- Non-Streaming Destinations: Ideal for long-term storage, these accept data in batches. Cribl Stream uses a staging directory to format and write events before sending them. Examples include Amazon S3, Azure Blob Storage, and MinIO.


## Collectors
Collectors enable on-demand or scheduled data collection tasks. The leader node sends configuration details to worker nodes, which then retrieve, filter, and forward the data to designated pipelines for processing and delivery to destinations.


## Output Routers
Output routers, found in the destinations tab, allow rule-based selection of destinations for data. Rules are evaluated sequentially, with the first match determining the destination. They are helpful for sending specific data sets to different locations based on filters and rules.


## Data Delivery & Backpressure
Cribl Stream employs backpressure and persistent queues to handle situations where sources or destinations become overwhelmed with data. Backpressure ensures minimal data loss by writing data to disk until the in-memory buffer recovers. Persistent queues further minimize data loss by storing data on disk until the receiver is ready.


## Remember...
Cribl Stream offers flexibility in data movement through various source, collector, and destination options. Sources provide data, collectors enable scheduled data retrieval, and destinations receive processed data for further analysis or storage.


# Stream Fundamentals: Routes & QuickConnect
Imagine data traveling through Cribl Stream like water flowing through pipes. This section focuses on "routes," which determine the data's path and processing.


## Routing Methods
Cribl Stream offers two main routing methods:

- QuickConnect (Simple and Quick): Ideal for establishing basic data flow paths. It allows you to connect sources directly to destinations with minimal configuration. Think of it as a quick way to get started. Ideal for beginners, non-technical users, or simple routing needs. It's a fast way to establish a data flow path.
- Routes (Flexible and Customizable):  Provide more control over data processing. Routes use filters to evaluate incoming events and direct them to specific pipelines for processing before sending them to destinations. Better for experienced users who require conditional logic or cascading processing.


## Understanding Routes
- Routes use filters to identify matching events.
- Each route is associated with a single pipeline and destination.
- Routes are evaluated sequentially, with the first match determining the path.
- By default, routes have a "final flag" set to "Yes," meaning matching events are processed by that route only and not evaluated further.
- Disabling the "final flag" allows cloning events. A copy is sent down the associated pipeline, while the original continues to be evaluated by subsequent routes.


## Route Creation & Associations
- A route can receive data from multiple sources but is linked to only one pipeline and destination.
- Filters within the route determine which data gets sent to that specific pipeline for processing.
- Unmatched data is dropped unless a "catch-all" route exists to handle it (often used for raw data storage).


## Route Strategies & Efficiency
- The goal is to minimize filter complexity and the number of routes an event is evaluated against.
- For most efficient processing without cloning, consider placing broader filters at the top to match events early on.


# Stream Fundamentals: Pipelines, Functions & Packs
This section explores Cribl Stream's core functionalities for data processing: Pipelines, Functions, and Packs. Understanding these concepts is crucial for mastering data flow within the platform.


## Imagine Cribl Stream as a Processing Factory
Think of your data as raw materials entering a factory. Pipelines act as assembly lines, and Functions are the individual stations that transform the data. Packs, on the other hand, are pre-built configurations that simplify the setup process.


## Understanding Pipelines: The Assembly Line
A pipeline is a series of Functions arranged in a specific order. Pipelines can be:

- Pre-processing - data normalization before routing
- Processing - main data transformation
- Post-processing - data normalization before sending to destination

Events (data units) are fed into the beginning of the pipeline by a Route. Each Function performs an action on the event, like shaping or modifying the data. Events progress through the pipeline, passing from one Function to the next, until they reach the end and exit as processed data.


## Functions
Functions are essentially small Javascript programs that execute specific actions on events

- These actions can involve string manipulation, encryption, converting events to metrics, and more.
- Functions can be configured with filters to target specific events for processing.
- You can add or reorder Functions within a pipeline to customize the processing flow.
- A "Final" toggle in Functions allows control over event flow within the pipeline.


## Packs
Cribl Stream offers pre-built configurations called Packs to simplify deployment.

Packs encapsulate everything between a source and a destination, including:
- Routes: define data flow paths.
- Pipelines: handle data transformation.
- Functions: perform specific actions on events.
- Sample Data: provide examples for testing purposes.
- Knowledge Objects: additional data elements for context.

Think of Packs as pre-made modules you can use to build complex data processing workflows quickly and easily. Cribl Stream also offers a Packs Dispensary, a repository where users can share and download Packs for various use cases.


## Remember...
- Pipelines define the order of data processing through a series of Functions.
- Functions are Javascript programs that perform specific actions on events.
- Packs offer pre-built configurations for faster deployment and streamlined data processing.


# Stream Fundamentals: Replay Basics
This section explores Cribl Stream's Replay functionality, a powerful tool for organizations to manage and analyze historical data.


## What is Replay & Why is it Valuable?
Cribl Stream Replay allows you to selectively re-ingest archived data into your analytics systems. This offers several benefits:

- Cost-Effective Retention: Archive data in low-cost storage like Amazon S3 while keeping only essential data readily available for analysis.
- Extended Data Availability: Analyze historical data beyond the limitations of your primary storage solution.
- Streamlined Investigations: Easily retrieve specific data subsets for security breach investigations or other purposes.
- Data Flexibility: Replay allows you to collect data from various sources (APIs, batch jobs) and re-ingest it for analysis.


## The Replay Process: Step-by-Step Walkthrough
This guide uses the example of replaying firewall logs from Cribl Stream to Amazon S3 and then back for analysis:

- Archiving Data:
  - Set up a Cribl Stream source (e.g., Syslog) to collect firewall logs.
  - Configure an Amazon S3 Destination to store the collected data. Define details like bucket name, region, and file format.

- Routing the Data:
  - Create a Route to connect the Syslog source to the S3 Destination.
  - Use a passthru pipeline (no data transformation) and set the output to the S3 Destination.

- Replaying Data from S3:
  - Set up a new Cribl Stream collector to retrieve data from the S3 bucket.
  - Use filename filtering to minimize data download and focus on relevant files.
  - Consider using a "_time" or "sourcetype" filter for efficient retrieval.


## Best Practices for Effective Replay
- Storage Class Compatibility: Avoid using storage classes with slow retrieval times like S3 Glacier or Azure archive tier.
- Filename Filters: Improve efficiency by filtering based on filenames to target specific data sets.
- Path Optimization: When replaying from S3, specify the time in the Path field (down to hour or minute) for faster filtering.
- API Limits: Be aware of API limits for your object storage (e.g., AWS S3 limits).
- Ruleset Selection: Use the appropriate Cribl Ruleset to parse replayed data for accurate analysis.
- Test in Preview Mode: Ensure you're capturing the correct data before a full replay.


## Remember...
You can leverage Cribl Stream Replay to effectively manage and analyze your historical data, gaining valuable insights from past events.


# Stream Fundamentals: Events & Processing Order
This section explores Cribl Stream's event processing engine, a core functionality for data manipulation and routing.


## Events: The Building Blocks of Data Processing
Cribl Stream processes data in units called events. Events are essentially collections of key-value pairs, similar to JSON or CSV formats. Complex data sources might require custom logic to parse and break down events into usable formats.


## Event Processing Order: Step-by-Step 
Here are the stages of event processing:

- Source Data Arrival: Data enters Cribl Stream from various external sources.
- Custom Command Processing (Optional): An external program can process and modify the data before passing it on.
- Event Breaking (Optional): If data arrives as a continuous stream, Cribl Stream can break it into individual events.
- Fields and Metadata (Optional): Additional fields or metadata can be added to the data stream.
- Pre-Processing Pipeline (Optional): Data can be normalized or transformed before routing.
- Routing: Events are routed to specific processing pipelines based on pre-defined filter criteria.
- Processing Pipeline: Events undergo transformations through a series of functions within the pipeline.
- Post-Processing Pipeline (Optional): Additional data normalization can be performed before sending events to their destinations.
- Destination: The processed data reaches its final destination (e.g., SIEM, analytics tool).


```
Sources > Custom Commands > Event Breakers > Fields (metadata) > Pre-Processing Pipelines (Optional) > Route Filters > Processing Pipelines > Post-Processing Pipelines (Optional) > Destinations
```

## Understanding Internal Fields & Timestamps
- Cribl Stream can add internal fields (identified by double underscores) to events for filtering or tracking purposes. These fields are not sent to the destination.
- If an event cannot be parsed, its raw content is stored in a field named "_raw". You can then attempt further parsing.
- All events have a timestamp associated with them. If the event doesn't have a timestamp, Cribl Stream assigns the current Unix epoch time. This value is stored in a field named "_time".


## Remember...
By understanding Cribl Stream's event processing order and how events are structured, you'll be well-equipped to design efficient data flow workflows within the platform.


# Stream Fundamentals: Filters & Value Expressions
This section explores filters and value expressions in Cribl Stream, essential tools for data manipulation within the platform. It also provides a basic introduction to JavaScript, the underlying language used in Cribl Stream.


## JavaScript: A Foundational Language
JavaScript (JS) is a programming language designed for web development in the 1990s. It allows for dynamic web pages and data processing (both visible and hidden). Familiarity with JavaScript is beneficial, but not mandatory.


## JavaScript in Cribl Stream
Cribl Stream leverages JavaScript's ease of learning to empower administrators with data manipulation capabilities.

- Cribl Stream utilizes JavaScript primarily in filters and value expressions.
- Filters are used within Routes to control data flow by selecting specific events based on filter criteria.
- Functions within Pipelines are essentially JavaScript code that perform data transformations.
- JavaScript expressions evaluate to a single value and form the building blocks of these functionalities.


## Filters: Streamlining Data Flows
Filters written in JavaScript expressions determine which data gets routed to specific pipelines.

- These expressions evaluate to either true (allowing data to pass) or false (blocking data).
- The concept of "truthy" and "falsey" comes into play:
  - Truthy expressions don't have to be the literal value "true" but need to evaluate as true
  - Falsey expressions don't have to be be the literal value "false" but need to evaluate as false (or zero, empty string, etc.).
- Filters can include multiple expressions connected by logical operators (AND, OR, NOT).


## Value Expressions: Assigning & Extracting Data
Value expressions are pieces of code that calculate or assign a value.

- They are commonly used within Functions to manipulate data flowing through the pipeline.
- Cribl Stream supports two main types of value expressions:
  - Assignment expressions: Assign a value to a specific field in an event (e.g., setting a location field to "New York").
  - Evaluation expressions: Use JavaScript code to calculate or assign a value dynamically based on existing data.


## Remember...
By understanding the role of JavaScript in Cribl Stream, you'll be well-equipped to leverage filters and value expressions for efficient data processing within your workflows.


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


# Regular Expression


## Replace Expression
- ``` ` ``` - Start or end use of regular expression
- ```${g1}``` - Reference a group from Match Regex
- ```${C.Mask.md5(g2)}``` - Replace using an MD5 of the group referenced

