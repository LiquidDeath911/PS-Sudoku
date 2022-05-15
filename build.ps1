param (
    [parameter(Mandatory=$true)]
    [ValidateSet("ImportModules", "RunPSScriptAnalyzer", "RunUnitTests", "RunIntegrationTests", "RunAcceptanceTests", "PublishModule", "InstallPSSudoku")]
    [string]$FunctionToRun,
    [Parameter(Mandatory=$false)]
    [String]$NugetAPIKey
)

function ImportModules {
    $WarningPreference = "SilentlyContinue"
    Write-Verbose -Message "Initializing Module PSScriptAnalyzer"
    if (-not(Get-Module -Name PSScriptAnalyzer -ListAvailable)){
        Write-Warning "Module 'PSScriptAnalyzer' is missing or out of date. Installing module now."
        Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing Module Pester"
    if (-not(Get-Module -Name Pester -ListAvailable)){
        Write-Warning "Module 'Pester' is missing or out of date. Installing module now."
        Install-Module -Name Pester -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing PowerShellGet"
    if (-not(Get-Module -Name PowerShellGet -ListAvailable)){
        Write-Warning "Module 'PowerShellGet' is missing or out of date. Installing module now."
        Install-Module -Name PowerShellGet -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing platyPS"
    if (-not(Get-Module -Name platyPS -ListAvailable)){
        Write-Warning "Module 'platyPS' is missing or out of date. Installing module now."
        Install-Module -Name platyPS -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing PowerShellGet"
    if (-not(Get-Module -Name PowerShellGet -ListAvailable)){
        Write-Warning "Module 'PowerShellGet' is missing or out of date. Installing module now."
        Install-Module -Name PowerShellGet -Scope CurrentUser -Force
    }

    Write-Verbose -Message "Initializing PS-Sudoku"
    InstallPSSudoku
    $WarningPreference = $null
}

function InstallPSSudoku {
    # Script to install the module locally. 
    # This is used prior to publishing the module to the PowerShell Gallery
    $Version = "2.0.1"
    $InstallPath = $null
    if ($IsWindows) {
        $InstallPath = "C:\Users\runneradmin\Documents\PowerShell\Modules\PS-Sudoku"
    }
    if ($IsLinux) {
        $InstallPath = "/home/runner/.local/share/powershell/Modules/PS-Sudoku"
    }
    elseif ($IsMacOS) {
        $InstallPath = "/Users/runner/.local/share/powershell/Modules/PS-Sudoku"
    }
    else {
        $PossiblePaths = $env:PSModulePath.Split(";")
        $InstallPath = $PossiblePaths[0]
        $InstallPath = $InstallPath + "\PS-Sudoku"
    }
    if (Test-Path $InstallPath) {
        Write-Verbose "Uninstalling pre-existing module versions..."
        Remove-Item -Recurse -Force $InstallPath
    }
    Write-Verbose "Installing PS-Sudoku module version $Version`..."
    New-Item -ItemType Directory "$InstallPath\$Version" | Out-Null
    Copy-Item "$($PSScriptRoot)\*" -Exclude "*git*" -Recurse -Destination "$InstallPath\$Version"
    Write-Verbose "Ensuring module is properly installed..." 
    Import-Module PS-Sudoku -Force
    if (-not (Get-Command -Module PS-Sudoku)){
        Write-Verbose "Module not installed properly. Manually move the folder to $InstallPath`\`$Version"
    }
    else {
        Write-Verbose "PS-Sudoku version $Version installed successfully!"
    }
}

function PublishModule {
    Write-Verbose -Message "Publishing Module PS-Sudoku"
    Try {
        Publish-Module -Path "." -NuGetAPIKey $NugetAPIKey
    }
    Catch {
        Write-Warning "Publishing Module PS-Sudoku failed."
        Write-Error $_
    }
    Write-Verbose "PS-Sudoku published successfully."
}

function RunPSScriptAnalyzer {
    try {
        Write-Verbose -Message "Running PSScriptAnalyzer on Public functions"
        Invoke-ScriptAnalyzer ".\Public" -Recurse
        Write-Verbose -Message "Running PSScriptAnalyzer on Private functions"
        Invoke-ScriptAnalyzer ".\Private" -Recurse
    }
    catch {
        Write-Error $_
        throw "Couldn't run Script Analyzer"
    }
}

Function RunUnitTests {
    Write-Verbose -Message "Running Pester Unit Tests"
    $Results = Invoke-Pester -Script ".\Tests\UnitTests\*.ps1" -Output Detailed #-OutputFormat NUnitXml -OutputFile ".\Tests\UnitTests\UnitTestsResults.xml"
    if($Results.FailedCount -gt 0){
        throw "$($Results.FailedCount) Tests failed"
    }
}

Function RunIntegrationTests {
    Write-Verbose -Message "Running Pester Integration Tests"
    $Results = Invoke-Pester -Script ".\Tests\IntegrationTests\*.ps1" -Output Detailed #-OutputFormat NUnitXml -OutputFile ".\Tests\IntegrationTestsResults.xml"
    if($Results.FailedCount -gt 0){
        throw "$($Results.FailedCount) Tests failed"
    }
}

Function RunAcceptanceTests {
    Write-Verbose -Message "Running Pester Acceptance Tests"
    $Results = Invoke-Pester -Script ".\Tests\AcceptanceTests\*.ps1" -Output Detailed #-OutputFormat NUnitXml -OutputFile ".\Tests\AcceptanceTestsResults.xml"
    if($Results.FailedCount -gt 0){
        throw "$($Results.FailedCount) Tests failed"
    }
}

Invoke-Expression $FunctionToRun