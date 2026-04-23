param([string]$inventory_hostname, [string]$date, [string]$filename)

$user = "docsol_backup"
$pass = "kNFD8hDZxBuVkL3gdBJ3ZTh2"
$remotePath = "\\172.17.120.37\respaldos\codigo\$inventory_hostname\$date"

if (!(Test-Path $remotePath)) { 
    New-Item -ItemType Directory -Path $remotePath -Force 
}

$net = New-Object -ComObject WScript.Network
if (Get-PSDrive Z -ErrorAction SilentlyContinue) {
    $net.RemoveNetworkDrive("Z:", $true)
}

$net.MapNetworkDrive("Z:", $remotePath, $false, $user, $pass)
Copy-Item "C:\Windows\Temp\$filename.zip" "Z:\" -Force
$net.RemoveNetworkDrive("Z:", $true)