# Edge Concepts: Cribl Edge Basics
This section explores key concepts of Cribl Edge as a next-generation data collection agent for IT and Security professionals.

## What does Cribl Edge do, again?
Cribl Edge is a next-generation agent, simplifying data collection from Windows and Linux systems. It empowers IT and SecOps teams to:

- Explore: Analyze logs, metrics, and application data at their source.
- Monitor: Track infrastructure health at scale.
- Collect: Gather various data types efficiently.
- Forward: Route data to desired destinations for further processing or storage.

Cribl Edge promotes data exploration closer to the source, allowing informed decisions about data collection and processing. It facilitates the deployment of thousands of nodes for large-scale infrastructure monitoring. Additionally, Cribl Edge enables shaping and routing endpoint data to the most suitable tools (including low-cost object storage) to optimize resource utilization.


## Challenges Addressed by Cribl Edge:
Traditional data collection methods often face several challenges:

- Multiple Agents: Managing various agents for different data types creates complexity.
- Scalability Issues: Exponential data growth necessitates scalable solutions for configuration and maintenance.
- Data Movement Costs: Increasing data volumes raise storage and transfer expenses.

Cribl Edge addresses these issues by:

- Vendor-Agnostic Support: Acting as a single, universal agent for all data types, eliminating vendor lock-in.
- Centralized Management: Streamlining configuration for tens of thousands of Edge nodes from a central location.
- Real-time Processing & Routing: Enabling data processing and routing at the edge to minimize unnecessary data movement.


## Key Components of Edge
- Sources: Define how Edge collects data (logs, metrics) from local machines or receives data from remote senders.
- Leader Node: The central component in a distributed Edge deployment. Manages and monitors Edge nodes and simplifies configuration changes.
- Fleets & Subfleets: Group Edge nodes logically for easier configuration management. Subfleets inherit configurations from parent fleets.
- Destinations: Where Edge sends collected data. Examples include Cribl Stream, SIEM, XDR, Logging, APM, or S3 platforms


## Key Benefits of Cribl Edge
- Effortless Fleet Management: Manage and monitor thousands of Edge nodes from a central console.
- Visual Configuration Authoring: Configure Edge nodes using a web-based interface with version control capabilities.
- Simplified Agent Management: Easily view logs on Edge nodes, read log contents, and perform on-demand upgrades.
- Rich Data Collection: Collect relevant data like IT metrics (CPU, memory, disk, network) and automatically discover container runtimes.
- Data Processing at the Edge: Reduce costs by filtering, transforming, routing, and forwarding data directly at the edge.
- In-depth Kubernetes Support: Easily deploy Edge using Helm charts and gain deep visibility into containerized environments with enhanced metrics and metadata.
- Cribl Search in Place: Search Edge nodes and logs directly without needing to collect or ingest data.


## Remember...
Cribl Edge offers a centralized approach to managing and collecting data from a wide range of sources. Leverage Cribl Edge's features to simplify agent management, optimize data processing, and gain deeper insights into your IT environment. Some key takeaways:

- Saves resources by eliminating the need for multiple agents, simplifying configuration, and minimizing data movement.
- Manages large deployments efficiently with centralized control.
- Enables real-time processing at the edge for quicker insights.
- Search functionality on Edge nodes (Cribl.Cloud) facilitates quicker issue identification and resolution


# Edge Concepts: Sources & Destinations
This section provides a comprehensive overview of Cribl Edge sources and destinations. Cribl Edge is designed to collect data at the edge, process it if needed, and then send it to its final destination. This module focuses on the various sources Edge can collect data from, and the destinations it can send data to.

## Edge Sources
Each Cribl Edge Source is a configuration that enables Edge nodes to collect or receive data – logs, metrics, application data, etc. – in real time.

- Push Sources: These sources allow Edge to gather data from external sources like Windows Event Forwarder, HTTP, and TCP JSON. This is useful when collecting data over slow connections.
- Pull Sources: These are supported data Sources that Cribl Edge fetches data from, like Prometheus Edge Scraper or Windows Event Logs.
- System and Internal Sources: These are unique to Cribl Edge and include System Metrics, File Monitor, and Exec. They allow you to collect data from the local machine and even run commands using "Exec" to gather additional data.


## Key Sources by Operating System
- Linux
  - System metrics: Collects data on CPU, memory, network, and disk usage. You can customize the messages you want to receive
Journal files: Capture kernel, boot messages, messages from syslog, and other services
- Windows
  - Windows Event Logs: Collects data from Applications, Security, and System logs
  - Windows Metrics: Collects data on CPU, memory, network, and disk usage.
- Kubernetes
  - Kubernetes Logs: Collects logs from containers in a Kubernetes node. You can filter and enrich incoming logs.
  - Kubernetes Events: Collects cluster-level events generated in response to state changes or errors.
  - Kubernetes Metrics: Collects data on the status and configuration of the Kubernetes cluster.


## Cribl Edge Destinations (focusing on Cribl Stream):
- Cribl HTTP: Enables Edge nodes to send data to Cribl Stream worker nodes in distributed deployments with load balancers. Ideal for larger environments. Useful in hybrid cloud deployments for optimized billing
- Cribl TCP: Recommended for medium-sized, on-premise deployments. It's faster and simpler to deploy than Cribl HTTP. Use this option when firewalls or proxies allow raw TCP egress


## Remember...
- Cribl Edge allows you to analyze data directly at the edge before deciding to collect and process it further.
- Cribl Edge offers various sources, including unique options like Cribl Internal Source (captures Edge's logs and metrics), File Monitor Source (collects log text files), and Exec Source (executes commands and collects output).
- Cribl Edge seamlessly integrates with Kubernetes environments, making it easy to gather data from containers.
- Pay close attention to the different source types and their functionalities.
- Understand the advantages and disadvantages of Cribl HTTP and Cribl TCP destinations.
- Familiarize yourself with Cribl's unique sources like Cribl Internal Source, File Monitor Source, and Exec Source.


# Edge Architecture: Overview
This section summarizes the basic components of the Cribl Edge architecture.

## Deployment Modes
- Single Mode: The Edge Node runs independently without a Leader Node for management. Suitable for smaller deployments.
- Distributed Mode: A Leader Node manages multiple Edge Nodes in a single location, ideal for larger environments.


## Cribl Edge Fleet Management
- Fleets allow you to organize Edge Nodes into logical groups based on factors like OS type, data type, or location.
- Create Subfleets within Fleets for more granular configuration. For example, a subfleet can process specific data types within a broader fleet (e.g., Windows Active Directory data within a Windows server fleet).


## Leader Node Communications
- The Leader Node manages configurations for Worker Nodes and Edge Nodes.
- Communication with Worker Nodes includes sending data collection configurations and scheduling data collection based on rules.
- Leader Node uses TCP port 4200 by default for communication with Worker Nodes (heartbeat, metrics, notifications). It also uses HTTP port 4200 for downloading configuration bundles.
- Increased Edge Nodes may require scaling up the Leader Node to handle additional workload.


## Cribl.Cloud Communications
Cribl.Cloud allows managing your Cribl environment in the cloud.

- Leader Node and Worker Nodes can reside in the cloud environment, simplifying cloud-based data processing through Cribl Stream. On-prem Worker Nodes are also supported.
- Cribl.Cloud uses secure connection (TCP port 443) for all communication with the Leader.


## Edge to Worker Group
- Cribl Edge processing is limited to a single CPU. Complex processing or situations requiring high processing power can benefit from sending data to a Cribl Stream Worker Group.
- Worker Nodes in a Worker Group can leverage multiple CPUs for data processing. You can also scale the Worker Group by adding more nodes for increased processing power.


## Remember...
- Grasp the differences between Single and Distributed Modes for Cribl Edge deployment.
- Leverage Fleets and Subfleets for efficient Edge Node management. Fleets and Subfleets group Edge Nodes logically based on shared characteristics or data types. Fleets relate to Edge Nodes similarly to how Worker Groups relate to Worker Nodes.
- Cribl Leader Node manages Worker Nodes and Edge Nodes, sending configuration information to both. Be familiar with communication ports used by the Leader Node for Worker and Edge Node interactions.
- Cribl Edge Nodes collect data at the network edge (e.g., servers).
- Consider Worker Groups for complex data processing exceeding Cribl Edge's single CPU limitation.


# Edge Architecture: On-Prem Install
This section provides an overview of how to install Cribl Edge on-premises. This module discussed installing Cribl Edge on a Linux machine, however Cribl Edge also supports installation on Windows, Docker, and Kubernetes.


## Preparation
- Installation Location: It's recommended to install Cribl Edge in the /opt directory.
- User Creation: Create a user named cribl to own and run the Cribl Edge process. This user should be non-privileged with minimal access.


## BootStart Settings
Cribl Edge can start at system boot using either systemd (more common) or initd. Use the boot-start command to enable this functionality.

## Security
- Run Cribl Edge as a non-privileged user (cribl).
- In distributed deployments, the Leader Node assigns a random password to each Edge Node's "admin" account. This might require accessing Edge Nodes via the Leader Node for direct login.


## Port Requirements
By default, Cribl Edge uses
- Port 9420 for the Edge UI.
- Port 4200 for heartbeat metrics and configuration bundles.
- Port 9000 (when using the installation script) for communication with the Leader Node


## Edge Installation Methods
Leader Node Installation Script
- Log in to the Leader Node, navigate to Manage > Edge Nodes, and select "Add and Update Edge Nodes" for Linux.
- Copy the script provided and run it on the Edge Node (ensure cribl user is created beforehand).
- The script allows modifications like fleet selection or installation package location.

Manual Installation
- The script automates several steps. Understanding these steps is crucial.
- The script sets variables, determines the Linux OS type, creates the cribl user (if needed), downloads Cribl Edge, configures it, - sets permissions, and enables the service using systemd or initd.


## Remember...
Some key takeaways:
- Understand the recommended installation location and user creation process.
- Be familiar with bootstart configuration options (systemd vs. initd).
- Grasp security best practices for running Cribl Edge.
- Memorize the default ports used by Cribl Edge.
- Know the two Cribl Edge installation methods (Leader Node script and manual) and the steps involved in each.


