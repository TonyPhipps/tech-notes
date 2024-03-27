#### Non-Authoritative and Authoritative SYSVOL Restore (DFS Replication)
*From https://www.rebeladmin.com/2017/08/non-authoritative-authoritative-sysvol-restore-dfs-replication/ with some editing to smooth the flow.*

Healthy SYSVOL replication is key for every active directory infrastructure. when there are SYSVOL replication issues, you may notice one or more of these symtoms.

1. Users and systems are not applying their group policy settings properly. 

2. New group policies not applying to certain users and systems. 

3. Group policy object counts is different between domain controllers (inside SYSVOL folders).

4. Log on scripts are not processing correctly.

5. DFS Replication event logs may exist such as 2213, 5002, 5008, 5014, 4012.

Some of these errors can be fixed with simple server reboot or running commands describe in the error ( ex – event 2213 description), but if they continue to appear a Non-Authoritative or Authoritative SYSVOL restore is required.

##### Non-Authoritative Restore 

If only one or few domain controllers (less than 50%) have replication issues in a given time, a non-authoritative replication may be issued. In that scenario, the DC can be forced to replicate the SYSVOL from the PDC. 

##### Authoritative Restore

If more than 50% of domain controllers have SYSVOL replication issues it possible that entire SYSVOL got corrupted, an authoritative restore should be issued. SYSVOL will be restored from backup to PDC and then replicated over or forced over all other domain controllers SYSVOL.

##### Non-Authoritative DFS Replication 

All these commands should run from domain controllers set as non-authoritative.

1) Backup the existing SYSVOL – This can be done by copying the SYSVOL folder from the domain controller which have DFS replication issues in to a secure location.

2) Log in to Domain Controller as Domain Admin/Enterprise Admin.

3) Launch ADSIEDIT.MSC tool and connect to Default Naming Context.

4) Navigate to DC=domain,DC=local > OU=Domain Controllers > CN=(DC NAME) > CN=DFSR-LocalSettings > Domain System Volume > SYSVOL Subscription.

5) Change msDFSR-Enabled to False.
 
```msDFSR-Enabled = FALSE```

7) Force AD replication.

```repadmin /syncall /AdP```

7) Run following to install the DFS management tools using (unless this is already installed).

```Add-WindowsFeature RSAT-DFS-Mgmt-Con```

8) Run following command to update the DFRS global state.

```dfsrdiag PollAD```

9) Search for the event 4114 to confirm SYSVOL replication is disabled. 

```Get-EventLog -Log "DFS Replication" | where {$_.eventID -eq 4114} | fl```

10) Change the attribute value back from Step 5.

```msDFSR-Enabled=TRUE```

11) Force AD replication.

```repadmin /syncall /AdP```

13) Update DFRS global state running command from step 8.

```dfsrdiag PollAD```

14) Search for events 4614 and 4604 to confirm successful non-authoritative synchronization.

```Get-EventLog -Log "DFS Replication" | where {$_.eventID -eq 4614 or $_.eventID -eq 4604} | fl```

##### Authoritative DFS Replication

Please note you do not need to run Authoritative DFS Replication for every DFS replication issue. It should be the last option.

1) Log in to PDC FSMO role holder as Domain Administrator or Enterprise Administrator.

2) Stop the DFS Replication Service (This is recommended to do in all the Domain Controllers).

3) Launch ADSIEDIT.MSC tool and connect to Default Naming Context.

4) Navigate to DC=domain,DC=local > OU=Domain Controllers > CN=(DC NAME) > CN=DFSR-LocalSettings > Domain System Volume > SYSVOL Subscription.

5) Update the given attributes values as following.

```
msDFSR-Enabled=FALSE
msDFSR-options=1
```

6) Modify following attribute on ALL other domain controllers.

```msDFSR-Enabled=FALSE```

1) Force AD replication.

```repadmin /syncall /AdP```

8) Start DFS Replication service on the PDC.

9) Search for the event 4114 to verify SYSVOL replication is disabled.

10) Change following value which were set on the Step 5.

```msDFSR-Enabled=TRUE```

11) Force AD replication.

```repadmin /syncall /AdP```

12) Run following command to update the DFRS global state.

```dfsrdiag PollAD```

13) Search for the event 4602 and verify the successful SYSVOL replication. 

14) Start DFS service on all other Domain Controllers

15)  Search for the event 4114 to verify SYSVOL replication is disabled.

```Get-EventLog -Log "DFS Replication" | where {$_.eventID -eq 4114} | fl```

17) Change following value which were set on the step 6. This need to be done on ALL domain controllers. 

```msDFSR-Enabled=TRUE```

17) Run following command to update the DFRS global state.

```dfsrdiag PollAD```

18) Search for events 4614 and 4604 to confirm successful authoritative synchronization.

```Get-EventLog -Log "DFS Replication" | where {$_.eventID -eq 4614 or $_.eventID -eq 4604} | fl```
