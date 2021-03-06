<#
    .SYNOPSIS
        Build script for the project.
#>
[CmdletBinding(ConfirmImpact = 'Medium', DefaultParameterSetName = 'DefParamSet')]
param(
    [Parameter(ParameterSetName = 'DefParamSet', Mandatory)]
        [Alias("c")]
        [ValidateSet("Debug", "Release")]
        [string]$config, # Build config to run
    [Parameter(ParameterSetName = 'DefParamSet',Mandatory)]
        [Alias("g")]
        [ValidateSet("Ninja", "Visual Studio 15 2017", "Visual Studio 16 2019")]
        [string]$generator, # Generator to use
    [Parameter(ParameterSetName = 'DefParamSet')]
        [Alias("h")]
        [ValidateSet('x64','x86')]
        [string]$hostarch, # Host architecture for the toolset
    [Parameter(ParameterSetName = 'DefParamSet')]
        [Alias("a")]
        [ValidateSet('x64','x86')]
        [string]$arch # Architecture to use
)

$config = $config.ToUpper()

if($hostarch){
    $hostparameter = "-Thost=$hostarch"
}

if($arch){
    $archparameter = "-A$arch"
}
$buildfolder = "$PSScriptRoot/build-$config"
cmake -E make_directory $buildfolder
Set-Location $buildfolder
cmake -G $generator $hostparameter $archparameter .. "-DCMAKE_BUILD_TYPE=$config"
cmake --build . --config $config 
Set-Location $PSScriptRoot