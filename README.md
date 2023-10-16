# WafLogToCsvConverter

Azure Application Gateway Web Application Firewall (WAF) logs are written to a Storage Account as .JSON files when a Storage Account is the destination in a Diagnostic Settings configuration. This is a simple PowerShell script that converts the logs from .JSON to .CSV for easier reviewal or analysis.

## Parameters

```PowerShell
WafLogToCsv.ps1
    -WafLogFile <string>
    -OutputPath <string>
    [-ReduceLogs]
    [-UseLaFormat]
```

### -WafLogFile

Path to a single JSON file that needs to be converted. Local file or point directly to Azure Storage. Example: ```C:\Documents\WafLog01.json```

### -OutputPath

Path to save the logs as a CSV. Example: ```C:\Documents\convertedLogs.csv```

### -ReduceLogs

Optional parameter that reduces the fields/columns exported. **Cannot be used in with -UseLaFormat.** Includes:

```text
    timeStamp
    instanceId
    clientIp
    requestUri
    ruleSetVersion
    ruleId
    ruleGroup
    message
    action
    hostname
    transactionId
    details_message
    details_data
```

### -UseLaFormat

Uses the same naming convention as WAF Logs as seen in Log Analytics Workspace. Ie ```clientIp``` becomes ```clientIp_s``` and ```details_data``` becomes ```details_data_s```. Also includes some fields that are present in Log Analytics but are absent in the Storage Account logs such as SubscriptionId, ResourceGroup, ResourceProvider, and more. **Cannot be used in with -ReduceLogs.**

## Example

```PowerShell
PS C:\Users\user1> WafLogToCsv.ps1 -WafLogFile "C:\Documents\WafLog01.json" -OutputPath "C:\Documents\WafLog01.csv" -ReduceLogs
```
