New-UDPage -Name "Latest Gossip" -Icon reddit_alien -Content {

    $sub = Invoke-RestMethod -Uri "https://www.reddit.com/r/Bitcoin/new/.json?limit=25"

    New-UDRow {
        New-UDColumn -Size 12 {
            New-UDTable -Title "Latest Reddit Posts" -Headers Score, Author, Title -Endpoint {
                $sub.data.children.data | Select-Object score, author, @{ label="udlink"; expression={ New-UDLink -Text $_.title -Url $_.url -OpenInNewWindow } } | Out-UDTableData -Property score, author, udlink
            }
        }
    }
} 