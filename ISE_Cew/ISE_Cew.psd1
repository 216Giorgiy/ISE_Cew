#
# Module manifest for module 'ISE_Cew'
#
# Generated by: Ryan Yates
#
# Generated on: 14/01/2016
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'ISE_Cew.psm1'

# Version number of this module.
ModuleVersion = '0.1.11'

# ID used to uniquely identify this module
GUID = '06b814cc-9ade-444f-a667-15ab6fbd3487'

# Author of this module
Author = 'Ryan Yates'

# Company or vendor of this module
CompanyName = 'Re-Digitise'

# Copyright statement for this module
Copyright = '� 2016 Re-Digitise Ltd'

# Description of the functionality provided by this module
Description = 'ISE_Cew is a PowerShell Module that adds functionality to make Git Commits and Pester testing easier to maintain'

# Minimum version of the Windows PowerShell engine required by this module
#PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
#PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
ProcessorArchitecture = 'None'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(@{ ModuleName = 'Pester'; ModuleVersion = '3.3.14' },@{ ModuleName = 'PSScriptAnalyzer'; ModuleVersion = '1.4.0'})

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module
FunctionsToExport = @('AlignEquals','CleanWhitespace','Get-AlignedText','Get-CustomCommitMessage','Get-ProxyCode','New-ISETab','Request-YesOrNo','Save-AllNamedFile','Save-AllUnnamedFile','Save-CurrentISEFile')

# Cmdlets to export from this module
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @(
'.\FunctionTests.txt',
'.\ISE_Cew.psd1',
'.\ISE_Cew.psm1',
'.\ISE_Cew.Tests.ps1',
'.\ModuleTests.txt',
'.\ProfileExample.txt',
'.\Sample_LICENSE.MD',
'.\Standardpsm1.txt',
'.\Public\AlignEquals.ps1',
'.\Public\CleanWhitespace.ps1',
'.\Public\Get-AlignedText.ps1',
'.\Public\Get-CustomCommitMessage.ps1',
'.\Public\Get-ProxyCode.ps1',
'.\Public\New-ISETab.ps1',
'.\Public\Request-YesOrNo.ps1',
'.\Public\Save-AllNamedFile.ps1',
'.\Public\Save-AllUnnamedFile.ps1',
'.\Public\Save-CurrentISEFile.ps1')

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    #BlogUrl of this module
    BlogUrl = 'http://blog.kilasuit.org'

    #UkPowerShellUserGroup of this module
    UkPowerShellUserGroup = 'http://www.get-psuguk.org'

    #Twitter Handle of the Main Author of this module
    Twitter = '@ryanyates1990'

    #Name of the Main Author of this module
    Name = 'Ryan Yates'

    #External Program Dependancies
    AllExternalDependancies = @('Git','PSScriptAnalyzer','Pester')
    
    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('ISE','Script Creation','Module Creation','Creation Workflow Simplification','PSDrives')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/kilasuit/ISE_Cew/License'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/kilasuit/ISE_Cew'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = "Functional Change to Save-AllUnnamedFiles"

        # External dependent modules of this module
        ExternalModuleDependencies = @('Pester','PSScriptAnalyzer')

    } # End of PSData hashtable
    
} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

