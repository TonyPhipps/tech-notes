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


## Enable Jump Frames on Virtual Switches
- Hosts > ESXi Host > Configure > Newtorking > Virtual Switches
- SCROLL DOWN if needed.
- EXPAND the switch by clicking the arrow on the left
- Click EDIT
- In Properties, set MTU (Bytes) to a maximum of 9000


## Windows Server Cloning
This is the cleanest method because it automates the SID change and the domain re-join process during the cloning wizard.
- Create a Customization Specification:
  - In the vSphere Client, go to Policies and Profiles > VM Customization Specifications.
  - Click New and walk through the wizard:
    - Registration Info: Enter your name/org.
    - Computer Name: Select "Use the virtual machine name" or "Enter a name in the clone/deploy wizard."
    - Windows License: Enter your key or leave blank if using KMS.
    - Administrator Password: Set the local admin password.
    - Network: Generally, "Typical settings" is fine for DHCP.
    - Workgroup or Domain: Enter your domain name and provide a service account with "Add Workstation to Domain" permissions.
- Run the Clone:
- Right-click your source VM > Clone > Clone to Virtual Machine.
- On the Select clone options page, check "Customize the operating system"
- On the Customize guest OS page, select the profile you just created.
- Finish the wizard. VMware will boot the VM, run Sysprep automatically, change the name, and join the domain for you.
- Review progress in the Recent Tasks pane at the bottom
