New-UDPage -Url "/Transactions/:id" -Icon money -Endpoint {
    param($id)

    $transaction = (Get-BitcoinInfo -Method gettxout -Params $id, 1).result

    New-UDRow {
        New-UDColumn {
            New-UDTable -Title "Transactions in block $id" -Headers "Transaction" -Endpoint {
                $transaction
            }
        }
    }
} 