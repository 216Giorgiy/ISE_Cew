Function Save-CurrentISEFile { 
<#
        .SYNOPSIS
        Saves Current File that you have open in ISE - only saves the Open and active File
        .DESCRIPTION
        This uses $PSISE.CurrentFile to save the file on the basis that the first line has the following Structure
        #Script#SP CSOM Testing Lists#
        or
        #Module#Test Module#

        This will save the file in the location PSDrive called Scripts-WIP (if marked as a Script) - because you do use PSDrives right?? - with the filename 
        SP CSOM Testing Lists.ps1 as in this example it is denoted as a script and will create a default pester test script as well.

        However if you are creating a Module (again because you are creating Modules and not single scripts right??) then it will be created as a .psm1 file
        and the function will automatically create you an example .psd1 module manifest with the details as detailed in the ps1ddetails variable at the the bottom of
        the PSISE_Addons psm1 file.
   
        Also as I would expect that your using Git for Source control (You are using source control right?? - Do you see a pattern forming here??) 
        this will also commit the file saves to Git on the basis that you have the Scripts-Wip PSDrive Root as the Git Repo store i.e this folder
        contains a hidded subfolder called .git or the Modules-WIP PSDrive
   
        If not then you NEED to learn Git and start to use it - this function makes it so much simpler to deal with as well!  
        .EXAMPLE
        Save-CurrentISEFile
        .EXAMPLE
        Place into your Profile the following

        if ($host.Name -eq "Windows PowerShell ISE Host") {
        $MyMenu = $psise.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("PSISE_Addons",$null,$null)
        $MyMenu.Submenus.Add("Save & Commit Current ISE File", { Save-CurrentISEFile }, "Ctrl+Alt+Shift+S") | Out-Null
        $MyMenu.Submenus.Add("Save & Commit all files that have been named", { Save-AllNamedFiles }, "Ctrl+Shift+S") | Out-Null
        $MyMenu.Submenus.Add("Save & Commit all unnamed files", { Save-AllUnnamedFiles -GeneralModuleDetails $psd1 }, "Ctrl+Alt+S") | Out-Null
        }

        Now you can run this function using Ctrl+Alt+S and the sister function to this one, Save-AllNamedFiles with Ctrl+Shift+S and it's other more popular sister
        Save-CurrentISEFile using Ctrl+Alt+Shift+S

        .OUTPUTS
        New Saved files and Git Commits
        .NOTES
        This Function drastically makes Source control with git much easier to deal with and ensures that you never miss a small change to a script
        AUTHOR
        Ryan Yates - ryan.yates@kilasuit.org
        LICENSE
        MIT 
        CREDITS
        Jeff Hicks Blog about extending the ISE with Addons as can be found at https://www.petri.com/using-addonsmenu-property-powershell-ise-object-model
        TO-DO
        Neaten this up and build a V2 version
    #>
    #Requires -Version 4.0
    [cmdletbinding()]
    param()

If ($host.Name -ne 'Windows PowerShell ISE Host')
    { Write-Warning 'Unable to be used in the console please use this in PowerShell ISE'}
    else {
        $oldlocation = Get-Location
        $currentfile = $psISE.CurrentFile
        if (($CurrentFile.IsSaved -eq $false) -and ($CurrentFile.IsUntitled -eq $false)) {
            Write-Verbose 'Now Saving existing file to its current saved path'
            $CurrentFile.Save()
            $displayname = $($CurrentFile.DisplayName.Replace('*','')) 
            Set-Location $CurrentFile.FullPath.Replace($DisplayName,'') ; 
            if((test-path .\.git\) -eq $true) { git add $displayname ; 
                $CustomCommit = Request-YesOrNo -title 'Pre-Commit Message' -message "Do you want to provide a Custom Commit Message for $DisplayName"
                if($CustomCommit) {$CustomCommitMessage = Get-CustomCommitMessage -filename $displayname  ; git commit -m $CustomCommitMessage }
                else { git commit -m "Saving file $displayname at $(get-date -Format "dd/MM/yyyy HH:mm") and commiting to Repo"} 
            }
            else { 
                    { do {Set-Location .. } until ((Test-Path .\.git\) -eq $true) } ;
                        $gitfolder = Get-Item .\ ; 
                        $gitfile = $currentfile.FullPath.Replace("$($gitfolder.FullName)","").TrimStart('\') ; 
                        git add $gitfile ;
                        $CustomCommit = Request-YesOrNo -title 'Pre-Commit Message' -message "Do you want to provide a Custom Commit Message for $displayname"
                        if($CustomCommit) {$CustomCommitMessage = Get-CustomCommitMessage -filename $displayname  ; git commit -m $CustomCommitMessage }
                        else { git commit -m "Saving file $gitfile at $(get-date -Format "dd/MM/yyyy HH:mm") and commiting to Repo"} ;
                 }
            }
        elseif (($CurrentFile.IsSaved -eq $false) -and ($CurrentFile.IsUntitled -eq $true)) {
                $firstLine = $(($currentfile.Editor.Text -split '[\n]')[0].Trim()) ;
                        if ($firstLine.Contains('Script')) { $type = 'Script' ; $filename = $($firstline.replace('#Script','').Replace('#','')) ; $name = "$filename.ps1" }
                        elseif ($firstLine.Contains('Module')) { $type = 'Module'; $filename = $($firstline.replace('#Module','').Replace('#','')) ; $name = "$filename.psm1" }
                        if ($type -eq 'Script') {$path = "$(Get-PSDrive Scripts-Wip | Select-Object -ExpandProperty root)\$filename\" ; New-item $path -ItemType Directory -Force | Out-Null }
                        elseif ($type -eq 'Module') {$path = "$(Get-PSDrive Modules-Wip | Select-Object -ExpandProperty root)\$filename\" ; New-item $path -ItemType Directory -Force | Out-Null} 
                        $fullname = "$path$name" ; 
                        Set-Location $path ;
                        git init ;
                        $CurrentFile.saveas($fullname) ;
                        if ($type -eq 'Script')  { 
                            New-Item -Path .\$filename.tests.ps1 -ItemType File -Force | Out-Null ;
                            New-Item -Path .\README.md -ItemType File -Value "This is a Readme file for $filename" -Force | Out-Null ;
                            New-Item -Path .\LICENSE -ItemType File -Value $License_MD_Content -Force | Out-Null
                            git add --all ;
                            $CustomCommit = Request-YesOrNo -title 'Pre-Commit Message' -message "Do you want to provide a Custom Commit Message for $filename"
                            if($CustomCommit) {$CustomCommitMessage = Get-CustomCommitMessage -filename $filename  ; git commit -m $CustomCommitMessage }
                            else { git commit -m "Saving file $displayname at $(get-date -Format "dd/MM/yyyy HH:mm") and commiting to Repo"}
                        }
                        elseif ($type -eq 'Module') { 
                            Set-location $path
                            $psd1.RootModule = $name ; 
                            $psd1.Path = "$path$filename.psd1" ; $psd1.Description = $psd1.Description.Replace('*ModuleName*',$filename) ;
                            New-ModuleManifest @psd1 ;
                            New-Item -Path .\Public\ -ItemType Directory -Force | Out-Null ;
                            New-Item -Path .\Private\ -ItemType Directory -Force | Out-Null ;
                            New-Item -Path .\$filename.tests.ps1 -ItemType File -Force | Out-Null ;
                            New-Item -Path .\README.md -ItemType File -Value "This is a Readme file for $filename" -Force | Out-Null ;
                            New-Item -Path .\LICENSE -ItemType File -Value $License_MD_Content -Force | Out-Null
                            Set-Content -Path .\$filename.tests.ps1 -Value $Default_Module_Pester_Tests ;
                            git add --all ;
                            $CustomCommit = Request-YesOrNo -title 'Pre-Commit Message' -message "Do you want to provide a Custom Commit Message for $filename"
                            if($CustomCommit) {$CustomCommitMessage = Get-CustomCommitMessage -filename $filename  ; git commit -m $CustomCommitMessage }
                            else { git commit -m "Created new module $filename at $(get-date -Format "dd/MM/yyyy HH:mm") in Git Repo at $path"}
                        }
            }
    Set-Location $oldlocation
        }
}
