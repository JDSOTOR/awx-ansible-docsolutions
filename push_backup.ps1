param([string]$inventory_hostname, [string]$date, [string]$filename)

$user = "docsol_backup"
$pass = "kNFD8hDZxBuVkL3gdBJ3ZTh2"
$remotePath = "\\172.17.120.37\respaldos\codigo\$inventory_hostname\$date"

if (!(Test-Path $remotePath)) { 
    New-Item -ItemType Directory -Path $remotePath -Force 
}

$net.MapNetworkDrive("Z:", $remotePath, $false, $user, $pass)

# Agregamos validación de error explícita
try {
    Copy-Item "C:\Windows\Temp\$filename.zip" "Z:\" -Force -ErrorAction Stop
    Write-Output "Copia exitosa de $filename"
} catch {
    Write-Error "Fallo la copia al NFS: $_"
    exit 1  # Esto hará que AWX marque la tarea como FALLIDA
} finally {
    $net.RemoveNetworkDrive("Z:", $true)
}