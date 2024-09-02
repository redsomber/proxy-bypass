$server = "111.111.111.111"
$squidService = "squidsrv"
$shadowsocksProcess = "Shadowsocks"
$shadowsocksPath = "C:\Program Files\Shadowsocks\Shadowsocks.exe"
$interval = 1
$pollCount = 2
$logFile = "C:\logfile.txt"

# Function to log messages
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Write-Output $logMessage
    Add-Content -Path $logFile -Value $logMessage
}

# Function to write console messages with timestamps
function Write-Console {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $consoleMessage = "$timestamp - $message"
    Write-Output $consoleMessage
}

# Function to check if the server is online
function Test-ServerConnection {
    try {
        Test-Connection -ComputerName $server -Count 1 -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Function to start a service if not running
function Start-ServiceIfNotRunning {
    param (
        [string]$serviceName
    )
    if ((Get-Service -Name $serviceName).Status -ne 'Running') {
        Start-Service -Name $serviceName
        Write-Log "Started service: $serviceName"
    }
}

# Function to stop a service if running
function Stop-ServiceIfRunning {
    param (
        [string]$serviceName
    )
    if ((Get-Service -Name $serviceName).Status -eq 'Running') {
        Stop-Service -Name $serviceName
        Write-Log "Stopped service: $serviceName"
    }
}

# Function to stop a process if running
function Stop-ProcessIfRunning {
    param (
        [string]$processName
    )
    $process = Get-Process -Name $processName -ErrorAction SilentlyContinue
    if ($process) {
        Stop-Process -Name $processName -Force
        Write-Log "Stopped process: $processName"
    }
}

# Function to start Shadowsocks if not running
function Start-ShadowsocksIfNotRunning {
    $process = Get-Process -Name $shadowsocksProcess -ErrorAction SilentlyContinue
    if (-not $process) {
        Start-Process -FilePath $shadowsocksPath
        Write-Log "Started process: $shadowsocksProcess from $shadowsocksPath"
    }
}

while ($true) {
    # Perform the server connection test multiple times
    $successfulTests = 0
    for ($i = 1; $i -le $pollCount; $i++) {
        if (Test-ServerConnection) {
            $successfulTests++
            if ($successfulTests -ge 1) {
                break  # Exit early if at least one test is successful
            }
        } else {
        Write-Console "$i test failed"
        }
    }

    $serverOnline = $successfulTests -gt 0
    $shadowsocksRunning = Get-Process -Name $shadowsocksProcess -ErrorAction SilentlyContinue

    if ($serverOnline) {
        Write-Console "Server $server is online"
        if (-not $shadowsocksRunning) {
            # Execute this part only if Shadowsocks is not running
            $choice = Read-Host "Switch to Shadowsocks? (1 - switch, 2 - exit)"
            if ($choice -eq '1') {
                $serverOnline = Test-ServerConnection
                if ($serverOnline) {
                    Stop-ServiceIfRunning -serviceName $squidService
                    Start-Sleep -Seconds 3
                    Start-ShadowsocksIfNotRunning
                } else {
                    Write-Log "Server $server went offline during the switch attempt"
                }
            } elseif ($choice -eq '2') {
                Write-Log "User chose to exit the script"
                exit
            }
        }
    } else {
        Write-Console "Server $server is offline"
        Write-Log "Server $server is offline"
        # If server is offline
        Stop-ProcessIfRunning -processName $shadowsocksProcess
        Start-ServiceIfNotRunning -serviceName $squidService
    }

    Start-Sleep -Seconds $interval
}