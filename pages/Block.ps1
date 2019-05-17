New-UDPage -Url "/Block/:id" -Endpoint {
    param($id)

    $block = (Get-BitcoinInfo -Method getblock -Params $id).result

    New-UDCard -Title "Block $id" -Id "PageCard"

    New-UDRow {
        New-UDColumn {
            New-UDTable -Title "Block Information" -Headers @("Name", "Details") -Endpoint { 
               @{
                    "Block Confirmations" = $block.confirmations
                    "Block Size" = "$($block.size) (stripped $($block.strippedsize)) (weight $($block.weight))"
                    "Block Height" = $block.height
                    "Block Version" = $block.version
                    "Block Transactions" = New-UDLink -Text $block.nTx -Url "/Transactions/$($block.hash)"
                    "Block Time" = (Get-Date "1/1/1970").AddSeconds($block.mediantime).DateTime
                }.GetEnumerator() | Out-UDTableData -Property @("Name", "Value")

            }
        }
    }
    New-UDRow {
        New-UDColumn {
            New-UDCard -Title "Previous Block" -Endpoint {
                New-UDLink -Text $block.previousblockhash -Url "/Block/$($block.previousblockhash)" 
            }
        }
        New-UDColumn {
            New-UDCard -Title "Current Block" -Endpoint {
                $block.hash
            }
        }
        New-UDColumn {
            New-UDCard -Title "Next Block" -Endpoint {
                New-UDLink -Text  $block.nextblockhash -Url "/Block/$($block.nextblockhash)" 
            }
        }
    }
    New-UDRow {
        New-UDColumn {
            New-UDGrid -Title "Transactions in block $id" -Headers "Transactions" -Properties "transaction" -Endpoint {
                $block.tx | Select-Object @{ label="transaction"; expression={ New-UDLink -Text $_ -Url "/Transactions/$_" } } | Out-UDGridData 
            }
        }
    }
} 