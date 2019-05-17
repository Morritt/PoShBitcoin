# PoShBitcoin
PowerShell Bitcoin node watcher and tools

To get the dashboard working, you need to install the Powershell Universal Dashboard (https://universaldashboard.io/). You have a 60 minute limit on running dashboards without paying.  This code may (probably won't) work with the free community edition without some tweaks.

## Prerequisites

* Bitcoin Core running (0.18 tested, others may vary)
* `POSHBitcoinUser` environment variable set to the RPC username in your bitcoin.conf
* `POSHBitcoinPassword` environment variable set to the RPC password in your bitcoin.conf

## Installation

Requires PowerShellGet 2+ to install.

```powershell
Update-Module PowerShellGet
Remove-Module PowerShellGet
Import-Module PowerShellGet -MinimumVersion 2.0.0
Install-Module UniversalDashboard -AcceptLicense
```

## Running
Create two environment bariables
Run `Dashboard.ps1` in your editor of choice.
