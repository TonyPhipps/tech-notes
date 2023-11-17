# Migrate Hosts Between ESXi Servers
- Right Click > Migrate
- Follow wizard
- Ensure networks are the same on both

# Health Check
- Inventory > Hosts > vCenter Server (top level)
- Monitor Tab

Allow Virtual Hosts to Communicate Cross ESXi Hosts
	• vSphere > ESXi Host > Configure > Virtual Switches > Connection > Edit Settings > Security
Check Override for Promiscuous Mode and set it to Accept

# Updates
- Review update sequence if performing full version upgrades
  - Update sequence for vSphere 7.0 and its compatible VMware products
  https://kb.vmware.com/s/article/78221?lang=en_US&queryTerm=Update%20sequence%20for%20vSphere%207

- Access vSphere Web Client
- Menu > Inventory > Hosts > Updates > Baselines
- Attach a Baseline (if needed)
- Run Check Compliance
- Run Remediation Pre-Check
- Select Baselines needed and click Stage
  - Will download any packges if needed
- Power Off or Migrate all virtual hosts to another ESXi
- Select Baselines needed and click Remediate
- Review status in the pullup in bottom of VSphere Client screen (Recent Tasks)
- ESXi Hosts may need to be removed from Maintenance Mode manually post update.

NOTE: Before updating ESXi Hosts, export a list of machine states in order to return them all to normal.
- vSphere > Hosts > ESXi Host > VMs > Export

## Possible Timeout
- It's possible Lifecycle Manager times out, like if Remediation takes over 30min
- "VMware vSphere Lifecycle Manager timed out waiting for host to reconnect after reboot. To ensure complete installation, reconnect the host, exit maintenance mode, and run a scan. Check host agent, vpxa and esxupdate logs for details."

