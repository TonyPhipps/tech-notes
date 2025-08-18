# Search Concepts: Overview
This section explores the fundamentals of searching data and introduces Cribl Search functionalities.


## Data Search Fundamentals
- Data Types
  - Data originates from various sources like IoT devices, SaaS applications, and cloud storage, generating massive volumes.
- Data Storage
  - Data resides in various locations like NAS, SAN, file systems, and cloud storage
- Search Methods
  - Index-based Search: Requires data collection, structuring, and formatting for efficient searching.
  - Search-in-Place: Queries data at its source (hosts or data lakes) without prior collection or indexing.
  - Federated Search: Queries data across multiple repositories simultaneously.


## Cribl Search: A New Approach
Cribl Search helps you search, explore, and analyze machine data – logs, instrumentation data, application data, metrics, etc. – in place without first moving it to specialized storage.

- Search-at-Rest: Cribl Search retrieves data directly from its location (host, container, VM, or data lake).
- Ergonomic Interface: Utilizes a hybrid Kusto query language, easy to learn and use for quick searches.
- Interactive Visualizations: Offers customizable dashboards with charts and graphs for data visualization based on user preferences.
- Cost-Effective: Saves time and money by eliminating unnecessary data movement. Analyze only the specific data required.


## Search Query Components 
You'll start by shaping the search - Formulate the right questions to filter out irrelevant data and pinpoint valuable information. Then, Define what's being searched and filter the results:

- Dataset Providers: Specify the data source for the search.
- Datasets: Define the specific data set within the data source to be searched.
- Operators: Filter the data based on specific criteria (e.g., AND, OR, NOT).
- Functions: Perform calculations or manipulations on the data within the search query.
- Time Range: Specify the timeframe for the search.


## Remember...
By understanding these core concepts and Cribl Search's unique approach, you'll understand search functionalities and Cribl Search's advantages.


# Search Concepts: Search Basics
This section provides a comprehensive overview of Cribl Search basic concepts and how it addresses the challenge of data movement for search purposes.

## Deployment in Cribl.Cloud
Cribl Search is currently available in Cribl.Cloud - it supports hybrid deployments with cloud-based leader functionality, and the ability to search on-prem or cloud-based customer-managed platforms.


## Traditional Search vs Cribl Search
- Traditional Solutions:
  - Collect data
  - Store data centrally
  - Search the stored data
- Cribl Search:
  - Search-in-place eliminates unnecessary data movement and storage costs.
  - Access and search data directly from its source (e.g., Amazon S3, Cribl Edge).


## Cribl Search Targets
- Search across various data sources simultaneously:
  - Primary observability data sources
  - Datalakes
  - Cloud storage platforms (Amazon S3, Azure Blob Storage, Google Cloud Storage)
- Search API endpoints of SaaS services (Okta, Zoom, Google Workspace, Microsoft Graph, etc.).
- Search edge devices through Cribl Edge instances (Kubernetes clusters, VMs, containers).


## Shaping and Performing a Cribl Search Query
Refine your search results progressively using a funnel analogy:

- Start with a broad dataset: Specify the search query and target dataset (e.g., Cribl internal logs).
- Set filters: Apply filters (e.g., status code, response time) and operators (e.g., WHERE clause) to narrow down the results.
- Utilize functions: To manipulate data within the search query. Define a limit on the number of returned rows (especially for large datasets) 
- Refine: Continuously refine the search for the most relevant information.
- Display: The results will display relevant data based on your search criteria.


## Remember...

By understanding these core concepts and Cribl Search's functionalities, you'll understand basic to searching techniques and Cribl Search's capabilities.


