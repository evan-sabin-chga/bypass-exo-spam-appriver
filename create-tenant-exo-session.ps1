# Create and import EXO session for specified customer in MSOL PC

param ($Customer)

# Remove any existing remote PS sessions to avoid going over maximum
Get-PSSession -Name "WinRM*" | Remove-PSSession

$token = New-PartnerAccessToken -ApplicationId 'a0c73c16-a7e3-4564-9a95-2bdf47383716'-RefreshToken $ExchangeRefreshToken -Scopes 'https://outlook.office365.com/.default' -Tenant $customer.TenantId
$tokenValue = ConvertTo-SecureString "Bearer $($token.AccessToken)" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($upn, $tokenValue)
$customerId = $customer.DefaultDomainName
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell-liveid?DelegatedOrg=$($customerId)&amp;BasicAuthToOAuthConversion=true" -Credential $credential -Authentication Basic -AllowRedirection
Import-PSSession $session -allowclobber -Disablenamechecking