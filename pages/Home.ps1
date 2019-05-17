Import-Module $PSScriptRoot\..\modules\Bitcoin-Module.psm1

New-UDPage -Name "Home" -Icon home -Content {
    New-UDRow {
        New-UDColumn {
            New-UDCounter -Title "Block Height" -Endpoint {
                (Get-BitcoinInfo -Method getblockcount).result
            } -AutoRefresh -RefreshInterval 1
        }
        New-UDColumn {
            New-UDCounter -Title "Difficulty" -Endpoint {
                (Get-BitcoinInfo -Method getdifficulty).result
            } -AutoRefresh -RefreshInterval 1
        }
        New-UDColumn {
            New-UDCard -Title "Block Hash" -Endpoint {
                $hash = (Get-BitcoinInfo -Method getbestblockhash).result
                New-UDLink -Text $hash -Url "/Block/$hash"
            }
        }
        New-UDColumn {
            New-UDCard -Title "Chain" -Content {
                (Get-BitcoinInfo -Method getmininginfo).result.chain 
            }
        }
        New-UDColumn {
            New-UDCard -Title "Warnings" -Content {
                (Get-BitcoinInfo -Method getmininginfo).result.warnings
            }
        }
    }
    New-UDRow {
        New-UDColumn {
            New-UDCounter -Title "Peers" -Endpoint {
                (Get-BitcoinInfo -Method getconnectioncount).result
            } -AutoRefresh -RefreshInterval 1            
        }
        New-UDColumn {
            New-UDTable -Title "Peers" -Headers ID, Address, Version, "Sent(bytes)", "Received(bytes)", Sending -Endpoint {
                (Get-BitcoinInfo -Method getpeerinfo).result | Out-UDTableData -Property id, addr, subver, bytessent, bytesrecv
            } -AutoRefresh -RefreshInterval 1
        }
        New-UDColumn {
            New-UDCounter -Title "Network In" -Endpoint {
                (Get-BitcoinInfo -Method getnettotals).result.totalbytesrecv
            } -AutoRefresh -RefreshInterval 1
            New-UDCounter -Title "Network Out" -Endpoint {
                (Get-BitcoinInfo -Method getnettotals).result.totalbytessent
            } -AutoRefresh -RefreshInterval 1            
        }
    }
} 