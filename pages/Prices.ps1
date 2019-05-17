[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function Set-UseUnsafeHeaderParsing
{
    param(
        [Parameter(Mandatory,ParameterSetName='Enable')]
        [switch]$Enable,

        [Parameter(Mandatory,ParameterSetName='Disable')]
        [switch]$Disable
    )

    $ShouldEnable = $PSCmdlet.ParameterSetName -eq 'Enable'

    $netAssembly = [Reflection.Assembly]::GetAssembly([System.Net.Configuration.SettingsSection])

    if($netAssembly)
    {
        $bindingFlags = [Reflection.BindingFlags] 'Static,GetProperty,NonPublic'
        $settingsType = $netAssembly.GetType('System.Net.Configuration.SettingsSectionInternal')

        $instance = $settingsType.InvokeMember('Section', $bindingFlags, $null, $null, @())

        if($instance)
        {
            $bindingFlags = 'NonPublic','Instance'
            $useUnsafeHeaderParsingField = $settingsType.GetField('useUnsafeHeaderParsing', $bindingFlags)

            if($useUnsafeHeaderParsingField)
            {
              $useUnsafeHeaderParsingField.SetValue($instance, $ShouldEnable)
            }
        }
    }
}

New-UDPage -Name "Live Prices" -Icon bitcoin -Content {
    $format = "`$1,000.00"

    #bad, doean't update, needs moving to a scheduled endpoint
    $poloniex = Invoke-RestMethod -Uri "https://poloniex.com/public?command=returnOrderBook&currencyPair=USDT_BTC&depth=1" -Method Get
    $kraken   = Invoke-RestMethod -Uri "https://api.kraken.com/0/public/Ticker?pair=XBTUSD" -Method Get
    
    #Weird Bitstamp response
    Set-UseUnsafeHeaderParsing -Enable
    $bitstamp = Invoke-RestMethod -Uri "https://www.bitstamp.net/api/ticker/" -Method Get

    New-UDRow {
        New-UDColumn -Size 2 {
            New-UDCounter -Title "Poloniex Ask" -Format $format -Endpoint {
                $poloniex.asks[0][0]
            }
        }
        New-UDColumn -Size 2 {
            New-UDCounter -Title "Poloniex Bid" -Format $format -Endpoint {
                $poloniex.bids[0][0]
            }
        }
        New-UDColumn -Size 2 {
            New-UDCounter -Title "Poloniex Spread" -Format $format -Endpoint {
                $poloniex.asks[0][0] - $poloniex.bids[0][0]
            }
        }
    }
    New-UDRow {
        New-UDColumn -Size 2 {
            New-UDCounter -Title "Kraken Ask" -Format $format -Endpoint {
                $kraken.result.XXBTZUSD.a[0]
            }
        }
        New-UDColumn -Size 2 {
            New-UDCounter -Title "Kraken Bid" -Format $format -Endpoint {
                $kraken.result.XXBTZUSD.b[0]
            }
        }
        New-UDColumn -Size 2 {
            New-UDCounter -Title "Kraken Spread" -Format $format -Endpoint {
                $kraken.result.XXBTZUSD.a[0] - $kraken.result.XXBTZUSD.b[0]
            }
        }
    }
    New-UDRow {
        New-UDColumn -Size 2 {
            New-UDCounter -Title "Bitstamp Ask" -Format $format -Endpoint {
                $bitstamp.ask
            }
        }
        New-UDColumn -Size 2 {
            New-UDCounter -Title "Bitstamp Bid" -Format $format -Endpoint {
                $bitstamp.bid
            }
        }
        New-UDColumn -Size 2 {
            New-UDCounter -Title "Bitstamp Spread" -Format $format -Endpoint {
                $bitstamp.ask - $bitstamp.bid
            }
        }
    }
} 