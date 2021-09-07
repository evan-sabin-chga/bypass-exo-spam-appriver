# Install required PS modules

param (
    [String[]] $Dependencies
)

foreach ($Dependency in $Dependencies) {
    if (Get-Module -ListAvailable -Name $Dependency) {
        Write-Host "Module $($Dependency) installed, skipping..." -foregroundcolor green
    } 
    else {
        Write-Host "Module $($Dependency) not installed, installing..." -foregroundcolor red
        Install-Module -Name $Dependency -AllowClobber -Scope AllUsers
    }
}