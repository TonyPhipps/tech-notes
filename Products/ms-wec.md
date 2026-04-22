Setting up Windows Event Forwarding (WEF) in a Source-Initiated configuration (also known as a "Push" model) is the most scalable way to centralize logs. In this setup, the client (Source) initiates the connection to the server (Collector) via WinRM.

---

# Configure the Collector (WEC Server)
The Collector needs to be ready to receive and manage incoming connections.

* **Enable WinRM:** Open PowerShell as Administrator and run:
    `winrm quickconfig`
* **Start Event Collector Service:** Run:
    `wecutil qc`
* **Create the Subscription:**
- Open **Event Viewer** (`eventvwr.msc`).
- Right-click **Subscriptions** > **Create Subscription**.
- Name it (e.g., "Workstation-Security-Logs").
- Set **Destination Log** (usually *Forwarded Events*).
- Select **Source-initiated**.
- Click **Select Computer Groups** and add the computers or AD groups allowed to push logs. (e.g., "Domain Computers" and "Domain Controllers")
- Click **Select Events** to filter exactly what logs you want (e.g., Security ID 4624, 4625).
- **Advanced Settings:** Ensure the protocol is HTTP (Port 5985) or HTTPS (Port 5986).
- Edit the Log Properties for the Event Logs receiving forwared events and sure the Maximum Log Size is acceptable, and that Overwrite events is selected (200GB is fine).
- Ensure the **WS-Man** service is **Running** and **Automatic**.


# Configure the Collector GPO


## Configure WinRM

- Navigate to: `Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Remote Management (WinRM) > WinRM Service.`
- **Allow remote server management through WinRM**: Set to Enabled.
- **IPv4 filter**: Set to * or a specific subnet (e.g., 10.0.1.*) to restrict which IPs the Collector listens to.


## Force Encrypted Traffic
- Navigate to `Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Remote Management (WinRM) > WinRM Service`
- **Allow unencrypted traffic**: Disabled
- **Allow Basic Authentication**: Disabled
>Note: Kerberos (Port 5985): Even though this uses the "HTTP" port, Kerberos encrypts the payload at the application layer. However, Windows often still treats this as "unencrypted" at the transport level.


## Configure the Collector Firewall
You must allow traffic from the clients to the Collector.

- **Inbound Rule on Collector:** Allow TCP Port **5985** (HTTP) or **5986** (HTTPS) from the client IP range.
- The GPO can also be used to deploy this firewall rule under `Computer Configuration > Windows Settings > Security Settings > Windows Firewall with Advanced Security`.
 

# Configure the Source (Clients via GPO)
You need a Group Policy Object (GPO) to tell the clients where to send their logs and give them permission to read the Security Log.


## Define the Target Subscription Manager
This tells the client where the Collector lives.
- Navigate to: `Computer Configuration > Policies > Administrative Templates > Windows Components > Event Forwarding`.
-  Open **Configure target Subscription Manager**.
-  Set to **Enabled** and click **Show**.
-  Enter the connection string:
  -  **For HTTP:** `Server=http://<FQDN_OF_COLLECTOR>:5985/wsman/SubscriptionManager/WEC,Refresh=60`
  -  **For HTTPS:** `Server=https://<FQDN_OF_COLLECTOR>:5986/wsman/SubscriptionManager/WEC,Refresh=60`


## Enable WinRM Service
The client must have the WinRM service running to communicate.
- Navigate to: `Computer Configuration > Policies > Windows Settings > Security Settings > System Services`.
- Set **Windows Remote Management (WS-Management)** to **Automatic**.


## Set Security Log Permissions
By default, the "Network Service" account (which WinRM uses) cannot read the Security Log (and only this log needs this change).
-  Navigate to: `Computer Configuration > Policies > Administrative Templates > Windows Components > Event Log Service > Security`.
-  Open **Configure log access**.
-  Append `(A;;0x1;;;NS)` to the existing string. This grants **Read (0x1)** access to **Network Service (NS)**.


## The WinRM Listener (The most important setting)
- Navigate to: `Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Remote Management (WinRM) > WinRM Service`
- **Allow remote server management through WinRM**: Set to Enabled.
- **IPv4 filter**: Set to * or a specific subnet (e.g., `10.0.1.*`) to restrict which IPs the Collector listens to.


# Verification
Once the GPO refreshes on the clients (`gpupdate /force`), check the status:

| Location         | Action                                                                                                                     |
| :--------------- | :------------------------------------------------------------------------------------------------------------------------- |
| **On Client**    | Run `wecutil gs` in PowerShell to see if it has picked up the subscription.                                                |
| **On Collector** | Open Event Viewer > Subscriptions. Right-click your subscription > **Source Computers** to see if clients are checking in. |
| **On Collector** | Check the **Forwarded Events** log to see data flowing in.                                                                 |

> **Note:** If logs aren't appearing, ensure the "Event Log Readers" built-in group on the client machines includes the **Network Service** account. This is a common secondary requirement if the GPO log access string doesn't apply correctly.