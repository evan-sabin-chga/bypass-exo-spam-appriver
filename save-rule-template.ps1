# Import secret vars from `secrets.ps1`, defined by SecureAppModel script; then convert ApplicationSecret to secure string
. .\secrets.ps1
$ApplicationSecret = $ApplicationSecret | Convertto-SecureString -AsPlainText -Force

# Resolve dependent modules
.\resolve-dependencies.ps1 -Dependencies "MSOnline", "ExchangeOnlineManagement", "AzureAD", "PartnerCenter"

# connect to partner center
.\connect-partner-center.ps1

# define customer with rule implemented
$CustomerDomain = "cssbrokers.com"
$customer = Get-MsolPartnerContract -DomainName $CustomerDomain

# connect to exo tenant with rule implemented
.\create-tenant-exo-session.ps1 -Customer $customer

# save transport rule
$RuleTemplateDest = ".\rule-template.csv"
Get-TransportRule "Allow Inbound Mail from AES" | Select-Object -Property (Get-TransportRulePredicate).Name | Export-Csv -Path $RuleTemplateDest