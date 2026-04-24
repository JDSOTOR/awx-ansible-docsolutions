param([string]$inventory_hostname, [string]$date, [string]$filename)

$user = "docsol_backup"
$pass = "kNFD8hDZxBuVkL3gdBJ3ZTh2"
# La raíz del recurso para el mapeo inicial
$rootPath = "\\172.17.120.37\respaldos"
# La ruta específica para este backup
$remotePath = "Z:\codigo\$inventory_hostname\$date"

$net = New-Object -ComObject WScript.Network

# 1. Limpieza preventiva
if (Get-PSDrive Z -ErrorAction SilentlyContinue) {
    $net.RemoveNetworkDrive("Z:", $true)
}

try {
    # 2. AUTENTICAR PRIMERO: Mapear la raíz para ganar acceso
    $net.MapNetworkDrive("Z:", $rootPath, $false, $user, $pass)

    # 3. AHORA SÍ: Crear el directorio (Z: ya tiene los permisos del usuario)
    if (!(Test-Path $remotePath)) { 
        New-Item -ItemType Directory -Path $remotePath -Force | Out-Null
    }

    # 4. COPIAR
    Copy-Item "C:\Windows\Temp\$filename.zip" "$remotePath\" -Force -ErrorAction Stop
    Write-Output "Copia exitosa de $filename"
} 
catch {
    Write-Error "Error en el proceso de backup: $_"
    exit 1
} 
finally {
    # 5. SIEMPRE DESMONTAR
    if (Get-PSDrive Z -ErrorAction SilentlyContinue) {
        $net.RemoveNetworkDrive("Z:", $true)
    }
}