function Invoke-TAP {
    <#
    .FUNCTIONALITY
    Internal
    #>
    param($Tenant, $Settings)
    If ($Settings.Remediate) {
        
    $TAPConfig = $Settings.Config
    if (!$TAPConfig) { $TAPConfig = 'true' }
    try {
        $MinimumLifetime = '60' #Minutes
        $MaximumLifetime = '480' #minutes
        $DefaultLifeTime = '60' #minutes
        $DefaultLength = '8'
        $body = @"
  {"@odata.type":"#microsoft.graph.temporaryAccessPassAuthenticationMethodConfiguration",
  "id":"TemporaryAccessPass",
  "includeTargets":[{"id":"all_users",
  "isRegistrationRequired":false,
  "targetType":"group","displayName":"All users"}],
  "defaultLength":$DefaultLength,
  "defaultLifetimeInMinutes":$DefaultLifeTime,
  "isUsableOnce": $TAPConfig,
  "maximumLifetimeInMinutes":$MaximumLifetime,
  "minimumLifetimeInMinutes":$MinimumLifetime,
  "state":"enabled"}
"@
    (New-GraphPostRequest -tenantid $tenant -Uri 'https://graph.microsoft.com/beta/policies/authenticationmethodspolicy/authenticationMethodConfigurations/TemporaryAccessPass' -Type patch -asApp $true -Body $body -ContentType 'application/json') 
        Write-LogMessage -API 'Standards' -tenant $tenant -message 'Enabled Temporary Access Passwords.' -sev Info
    } catch {
        Write-LogMessage -API 'Standards' -tenant $tenant -message "Failed to enable TAP. Error: $($_.exception.message)" -sev Error
    }
}
}