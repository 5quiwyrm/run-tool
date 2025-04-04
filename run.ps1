param (
    [switch]$new,
    [switch]$show,
    [switch]$write,
    [switch]$read,
    [switch]$help,
    [switch]$filelook
)

if ($help) {
    Write-Host "Welcome to the run.ps1 tool!
Run with no flags to run the run command.

Available options:
-n -> Enter new command.
-s -> Show run command.
-w -> Write run command to a .runcommand file. 
-r -> Read run command from a .runcommand file.
-f -> See what run command has been stored in the .runcommand file.
-h -> Display this help message." -ForegroundColor DarkGreen
    return
}

if ($filelook) {
    Write-Host "Run command: $(Get-Content -Path ./.runcommand -ErrorAction Stop)" -ForegroundColor Cyan
    return
}

if ($global:runcommand -eq $null) {
    $global:runcommand = ""
}

if ($write) {
    if ($global:runcommand -ne "") {
        try {
            $prevcontent = Get-Content -Path ./.runcommand -ErrorAction Stop
            if ($prevcontent -eq "" -or $prevcontent -eq $global:runcommand) {
                Out-File -FilePath .runcommand -InputObject $runcommand 
                Write-Host "Run command: $global:runcommand" -ForegroundColor Cyan
                return
            }
            Write-Host "Are you sure you want to overwrite the file contents?" -ForegroundColor Yellow
            Write-Host "Current file content: $prevcontent" -ForegroundColor Blue
            Write-Host "New run command: $global:runcommand" -ForegroundColor Cyan
            Write-Host "Confirm (y/n) (y is default): " -NoNewLine -ForegroundColor Cyan
            $confirm = Read-Host
            if ($confirm -eq "n") {
                Write-Host "Aborted!" -ForegroundColor Yellow
                return
            }
        } catch { }
        Out-File -FilePath .runcommand -InputObject $runcommand 
        Write-Host "Run command: $global:runcommand" -ForegroundColor Cyan
    } else {
        Write-Host "Command empty!" -ForegroundColor Red
    }
    return
}
if ($read) {
    $fileruncommand = Get-Content -Path ./.runcommand -ErrorAction Stop
    if ($global:runcommand -eq $fileruncommand) {
        Write-Host "No change!" -ForegroundColor Yellow
        Write-Host "Run command: $global:runcommand" -ForegroundColor Cyan
    } elseif ($global:runcommand -eq "") {
        $global:runcommand = $fileruncommand
        Write-Host "Run command: $global:runcommand" -ForegroundColor Cyan
    } else {
        Write-Host "Are you sure you want to overwrite the current command?" -ForegroundColor Yellow
        Write-Host "Current run command: $global:runcommand" -ForegroundColor Blue
        Write-Host "New run command: $fileruncommand" -ForegroundColor Cyan
        Write-Host "Confirm (y/n) (y is default): " -NoNewLine -ForegroundColor Cyan
        $confirm = Read-Host
        if ($confirm -eq "n") {
            Write-Host "Aborted!" -ForegroundColor Yellow
        } else {
            $global:runcommand = $fileruncommand
            Write-Host "Run command: $global:runcommand" -ForegroundColor Cyan
        }
    }
    return
}

if ($new -or $global:runcommand -eq "") {
    Write-Host "New run command: " -ForegroundColor Green -NoNewLine
    $global:runcommand = Read-Host 
    return
} elseif ($show) {
    Write-Host "Run command: $global:runcommand" -ForegroundColor Cyan
    return
} else {
    Write-Host "Run command: $global:runcommand" -ForegroundColor Cyan
    Invoke-Expression $global:runcommand
    return
}
