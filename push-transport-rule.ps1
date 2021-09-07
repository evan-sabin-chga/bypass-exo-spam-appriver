# Import secret vars from `secrets.ps1`, defined by SecureAppModel script; then convert ApplicationSecret to secure string
. .\secrets.ps1
$ApplicationSecret = $ApplicationSecret | Convertto-SecureString -AsPlainText -Force

# Resolve dependent modules
.\resolve-dependencies.ps1 -Dependencies "MSOnline", "ExchangeOnlineManagement", "AzureAD", "PartnerCenter"

# Establish Partner Center/EXO connection
.\connect-partner-center.ps1

# Get list of all customers in PC
$customers = Get-MsolPartnerContract -All

# # Use to test with a single customer
# $CustomerDomain = ""
# $customer = Get-MsolPartnerContract -DomainName $CustomerDomain

foreach ($customer in $customers) {
    .\create-tenant-exo-session.ps1 -Customer $customer
    # Insert logic for creating transport rule here
    if (-Not (Get-TransportRule -Filter "Description -like '*sender ip addresses belong to one of these ranges: '5.152.184.128/25' or '5.152.185.128/26' or '8.19.118.0/24' or '8.31.233.0/24' or '69.20.58.224/28' or '5.152.188.0/24' or '199.187.164.0/24' or '199.187.165.0/24' or '199.187.166.0/24' or '199.187.167.0/24'*'")) {
        Write-Host "No matching rule for $($customer.name), creating..."
        Import-Csv -Path .\rule-template.csv | New-TransportRule -Name "Allow Inbound Mail from AES"
    } else {
        Write-Host "Found matching rule for $($customer.name), skipping..."
    }
}