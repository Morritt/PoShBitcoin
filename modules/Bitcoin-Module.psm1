$user = $env:POSHBitcoinUser
$pass =  ConvertTo-SecureString -AsPlainText $env:POSHBitcoinPassword -Force
$credentials = New-Object System.Management.Automation.PSCredential ($user, $pass)

#https://masonicboom.github.io/btcrpcapi/
#https://en.bitcoin.it/wiki/Original_Bitcoin_client/API_calls_list

#Get-BitcoinInfo -Method getblockcount
#(Get-BitcoinInfo -Method getblock -Params 00000000c937983704a73af28acdec37b049d214adbda81d7e2a3dd146f6ed09).result
#(Get-BitcoinInfo -Method gettxout -Params "006aaf44da623c47d60d3b38b32c61528e077d0fc25a915eec01c2b12b5c58c2", 1).result

Function Get-BitcoinInfo
{
    [CmdletBinding()]

    Param(
        [string] $Method,
        [object[]] $Params
    )

    Begin { }

    Process
    {
        $body = @{"jsonrpc"= "2.0"; "id"="BitShell"; "method"= "$Method"; "params"= $Params } | ConvertTo-Json

        Invoke-RestMethod -Method Post -Uri http://localhost:8332/ -Credential $credentials -ContentType "application/json-rpc" -Body $body 
    }

    End {}
}
