Import-Module $PSScriptRoot\modules\Bitcoin-Module.psm1

$HomePage = . (Join-Path $PSScriptRoot "pages\Home.ps1")
$PricesPage = . (Join-Path $PSScriptRoot "pages\Prices.ps1")
$RedditPage = . (Join-Path $PSScriptRoot "pages\Reddit.ps1")
$BlockPage = . (Join-Path $PSScriptRoot "pages\Block.ps1")
$TransactionsPage = . (Join-Path $PSScriptRoot "pages\Transactions.ps1")

$Pages = @( $HomePage, $PricesPage, $RedditPage, $TransactionsPage, $BlockPage )

Get-UDDashboard | Stop-UDDashboard

$init = New-UDEndpointInitialization -Module @("$PSScriptRoot\modules\Bitcoin-Module.psm1") 

$Dashboard = New-UDDashboard -Pages $Pages -EndpointInitialization $init -Title "Bitcoin Explorer"

$Server = Start-UDDashboard -Port 10001 -Dashboard $Dashboard

start http://localhost:10001