param (
    [Parameter(Mandatory=$true)]
    [string]$WafLogFile,
    [Parameter(Mandatory=$true)]
    [string]$OutputPath,
    [switch]$ReduceLogs,
    [switch]$UseLaFormat
)

if ($ReduceLogs -and $UseLaFormat) {
    Write-Error "Cannot use both -ReduceLogs and -UseLaFormat"
    exit
}

$wafLog = @()
Get-Content -Path $WafLogFile | ForEach-Object {
    $wafLog += ConvertFrom-Json -InputObject $_
}

if ($ReduceLogs) {
    $wafLog | Select-Object -ExcludeProperty properties -Property `
    timeStamp,
    @{Name="instanceId"; Expression={ $_.properties.instanceId }},
    @{Name="clientIp"; Expression={ $_.properties.clientIp }},
    @{Name="requestUri"; Expression={ $_.properties.requestUri }},
    @{Name="ruleSetVersion"; Expression={ $_.properties.ruleSetVersion }},
    @{Name="ruleId"; Expression={ $_.properties.ruleId }},
    @{Name="ruleGroup"; Expression={ $_.properties.ruleGroup }},
    @{Name="message"; Expression={ $_.properties.message }},
    @{Name="action"; Expression={ $_.properties.action }},
    @{Name="hostname"; Expression={ $_.properties.hostname }},
    @{Name="transactionId"; Expression={ $_.properties.transactionId }},
    @{Name="details_message"; Expression={ $_.properties.details.message }},
    @{Name="details_data"; Expression={ $_.properties.details.data }} | Export-Csv -Path $OutputPath -NoTypeInformation
}
elseif ($UseLaFormat) {
    $wafLog | Select-Object -ExcludeProperty properties -Property `
    @{Name="TimeGenerated"; Expression={ $_.timeStamp }},
    @{Name="ResourceId"; Expression={ $_.resourceId }},
    @{Name="Category"; Expression={ $_.category }},
    @{Name="ResourceGroup"; Expression={ $_.resourceId -split "/" | Select-Object -Index 4 }},
    @{Name="SubscriptionId"; Expression={ $_.resourceId -split "/" | Select-Object -Index 2 }},
    @{Name="ResourceProvider"; Expression={ $_.resourceId -split "/" | Select-Object -Index 6 }},
    @{Name="Resource"; Expression={ $_.resourceId -split "/" | Select-Object -Index 8 }},
    @{Name="ResourceType"; Expression={ $_.resourceId -split "/" | Select-Object -Index 7 }},
    @{Name="OperationName"; Expression={ $_.operationName }},
    @{Name="requestUri_s"; Expression={ $_.properties.requestUri }},
    @{Name="Message"; Expression={ $_.properties.message }},
    @{Name="instanceId_s"; Expression={ $_.properties.instanceId }},
    @{Name="clientIp_s"; Expression={ $_.properties.clientIp }},
    @{Name="ruleSetType_s"; Expression={ $_.properties.ruleSetType }},
    @{Name="ruleSetVersion_s"; Expression={ $_.properties.ruleSetVersion }},
    @{Name="ruleId_s"; Expression={ $_.properties.ruleId }},
    @{Name="ruleGroup_s"; Expression={ $_.properties.ruleGroup }},
    @{Name="action_s"; Expression={ $_.properties.action }},
    @{Name="details_message_s"; Expression={ $_.properties.details.message }},
    @{Name="details_data_s"; Expression={ $_.properties.details.data }},
    @{Name="details_file_s"; Expression={ $_.properties.details.file }},
    @{Name="details_line_s"; Expression={ $_.properties.details.line }},
    @{Name="hostname_s"; Expression={ $_.properties.hostname }},
    @{Name="policyId_s"; Expression={ $_.properties.policyId }},
    @{Name="policyScope_s"; Expression={ $_.properties.policyScope }},
    @{Name="policyScopeName_s"; Expression={ $_.properties.policyScopeName }},
    @{Name="engine_s"; Expression={ $_.properties.engine }},
    @{Name="transactionId_g"; Expression={ $_.properties.transactionId }} | Export-Csv -Path $OutputPath -NoTypeInformation
}
else {
    $wafLog | Select-Object -ExcludeProperty properties -Property `
    timeStamp,
    resourceId,
    operationName,
    category,
    @{Name="instanceId"; Expression={ $_.properties.instanceId }},
    @{Name="clientIp"; Expression={ $_.properties.clientIp }},
    @{Name="requestUri"; Expression={ $_.properties.requestUri }},
    @{Name="ruleSetType"; Expression={ $_.properties.ruleSetType }},
    @{Name="ruleSetVersion"; Expression={ $_.properties.ruleSetVersion }},
    @{Name="ruleId"; Expression={ $_.properties.ruleId }},
    @{Name="ruleGroup"; Expression={ $_.properties.ruleGroup }},
    @{Name="message"; Expression={ $_.properties.message }},
    @{Name="action"; Expression={ $_.properties.action }},
    @{Name="hostname"; Expression={ $_.properties.hostname }},
    @{Name="transactionId"; Expression={ $_.properties.transactionId }},
    @{Name="policyId"; Expression={ $_.properties.policyId }},
    @{Name="policyScope"; Expression={ $_.properties.policyScope }},
    @{Name="policyScopeName"; Expression={ $_.properties.policyScopeName }},
    @{Name="engine"; Expression={ $_.properties.engine }},
    @{Name="details_message"; Expression={ $_.properties.details.message }},
    @{Name="details_data"; Expression={ $_.properties.details.data }},
    @{Name="details_file"; Expression={ $_.properties.details.file }},
    @{Name="details_line"; Expression={ $_.properties.details.line }} | Export-Csv -Path $OutputPath -NoTypeInformation
}