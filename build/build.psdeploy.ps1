<#
    $env:psgallerykey is set in the Continous Integration plaform
    $env:modulePath is set in the build.ps1
    $env:moduleName is set in the build.ps1
    $ENV:BH* are set by the BuildHelpers module
#>
if(
    $env:modulePath -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq "master" -and
    $env:BHCommitMessage -match '!deploy'
)
{

    "Deploying Module`n" +
    "`t* Key='$env:psgallerykey' `n" +
    #"`t* Key='$env:mynugetapikey' `n" +
    #"`t* Key='$nugetapikey' `n" +
    "`t* Source='$((Join-Path -path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath $modulePath))' `n" +
    "`t* " |
        Write-Host

    Deploy -Name Module {
        By -DeploymentType PSGalleryModule {
            FromSource -Source (Join-Path -path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath $modulePath)
            To -Targets PSGallery
            WithOptions -Options @{
                ApiKey = $env:psgallerykey
            }
        }
    }
}
else
{
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
    "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)" |
        Write-Host
}