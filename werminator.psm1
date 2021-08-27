
<#
 .Synopsis
 Launch Windows Terminal with a set of configuration options

 .Description

 .Parameter Config
 Either a JSON configuration file held in Env:$profiledir (without extension) or a .\ local configuration file with extension

 .Example
   # Launch Windows Terminal from global config file.
   Werminator-Launch config               # Launch from global

 .Example
   # Launch Windows Terminal from local config file.
   Werminator-Launch .\pret.json          # Launch from local file
#>

function Invoke-Terminal {

    param(
        [string] $config
    )

    if ($config -match '^.\\') {
        # Then it's a local config file.
        $fullConfig = $config
    } else {
        $profiledir = $Env:werminator
        if (-Not $profiledir) {
            Write-Error "Env:werminator not configured, exiting."
            Return
        }
        $fullConfig = -join((Join-Path -Path $profiledir $config), ".json")
    }

    # Test file exists
    if (-not (Test-Path -Path $fullConfig -PathType Leaf)) {

        if (-not (Test-Path -Path (-join($fullConfig, "c")) -PathType Leaf)) {
            Write-Error "config file $fullConfig(c) not found, exiting."
            Return
        } else {
            $fullConfig = -join($fullConfig, "c") # Handle jsonc
        }
    }

    # Load json
    $configo = Get-Content $fullConfig | ConvertFrom-Json

    # Build windows terminal exec string
    $psExec = ""
    For($i = 0; $i -lt $configo.exec.Length; $i++) {

        $exec = $configo.exec[$i];

        $line = " "

        if ($exec.split) {
            $line = " split-pane -$($exec.split) "
        }

        if ($exec.movefocus) {
            $line = " move-focus $($exec.movefocus) "
        }

        $line += "-p `"$($configo.env)`" "

        if ($exec.dir) {
            $dir = Join-Path -Path $configo.root -ChildPath $exec.dir
        } else {
            $dir = $configo.root
        }
        $line += " -d `"$dir`""

        if ($exec.cmd) {
            $line += " pwsh -noExit -Command `"$($exec.cmd)`""
        }

        $psExec += " $line "
        if ($i -lt $configo.exec.Length - 1) {
            $psExec += ';'
        }
    }

    Write-Host $psExec
    Start-Process wt.exe $psExec

}
Export-ModuleMember -Function Invoke-Terminal

# Werminator - configure scripts/profiles to s